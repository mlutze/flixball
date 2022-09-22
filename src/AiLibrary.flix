namespace Flixball/AiLibrary {
    use Flixball/State.{toState, fromState};
    use Flixball/Core.Board.Board;
    use Flixball/Core.Direction.{East, North, South, West};
    use Flixball/Core.GameState.GameState;
    use Flixball/Core.Move.{Shoot, Turn, Walk};
    use Flixball/Core.Position.Position;
    use Flixball/Core.Rotation.Clockwise;
    use Flixball/Core.Rotation.Counterclockwise;
    use Flixball/Core.Tile.{Person, Wall};
    use Flixball/Core.{AiInfo, Board, Coordinates, Direction, Move,
        MoveLogic, PlayerId, Position, Rotation, Strategy, Tile};
    use Flixball/GridGraph.{findShortestPath, raytraceEx};
    use Flixball/Core/AiState.{empty => aiStateEmpty}
    use Flixball/Core/AiInfo.{getPlayers, getTiles, getColumns, getRows};

    def statelessMoveLogic(logic: AiInfo -> Move): MoveLogic =
        (info, state) -> (logic(info), state)

    def statelessStrategy(s: PlayerId -> AiInfo -> Move): Strategy =
        id -> (_ -> aiStateEmpty(), statelessMoveLogic(s(id)))

    def constantStrategy(m: Move): Strategy =
        statelessStrategy((_, _) -> m)

    pub def shoot(): Strategy = constantStrategy(Shoot)

    pub def walk(): Strategy = constantStrategy(Walk)

    pub def rotate(r: Rotation): Strategy = constantStrategy(Turn(r))

    pub def wander(): Strategy = _id -> {
        use RegionedRandom.nextInt64;
        let stateGen = seed -> toState(seed);
        let moveLogic = (_, state) -> region r {
            // use "0" if there's a bad encoding
            let ran = RegionedRandom.newWithSeed(r, fromState(state) |> Option.getWithDefault(0i64));
            let roll = ref nextInt64(ran) @ r;
            let choices = Nel(Walk, Walk :: Turn(Clockwise) :: Turn(Counterclockwise) :: Nil);
            let move = RegionedRandom.chooseNel(ran, choices);
            (move, toState(deref roll))
        };
        (stateGen, moveLogic)
    }

    pub def spinAndShoot(r: Rotation): Strategy = _id -> {
        let stateGen = seed -> toState(seed mod 2i64 == 0i64);
        let moveLogic = (_, state) -> {
            // use "false" if there's a bad encoding
            let shoot = fromState(state) |> Option.getWithDefault(false);
            if (shoot) (Shoot, toState(false))
            else (Turn(r), toState(true))
        };
        (stateGen, moveLogic)
    }

    pub def goAndSpin(coords: Coordinates): Strategy =
        statelessStrategy((id, info) -> {
            let currentPosition = getPlayers(info) |> Map.get(id) |> Utils/Option.unsafeGet;
            let goal = match Position(c, _) -> c == coords;
            goTo(currentPosition, goal, passablePlayers=false, getTiles(info)) |>
                Option.getWithDefault(Turn(Clockwise))
        })
    
    ///
    /// Go to the next player on the list and shoot them.
    /// Doesn't necessarily take the shortest path to find a shooting angle.
    ///
    pub def naiveSearchAndDestroy(): Strategy =
        statelessStrategy((id, info) -> {
            let playerMap = getPlayers(info);
            let tiles = getTiles(info);
            let board = Board({rows=getRows(info), cols=getColumns(info), tiles=tiles});
            // Pick a target from among the players (lowest ID except me)
            let target = playerMap
                |> Map.filterWithKey((id2, _) -> id != id2) 
                |> Map.toList
                |> List.head;

            // Get my own position
            let Position(coords, dir) = playerMap |> Map.get(id) |> Utils/Option.unsafeGet;

            // Pick a move
            match target {
                // Case 1: No target. Just spin for fun.
                case None => Turn(Clockwise)

                // Case 2: Some target. Hunt them down.
                case Some((targetId, Position(targetCoords, _))) =>
                    let goal = match Position(c, _) -> c == targetCoords;
                    match raytraceEx(dir, coords, board) {
                        // Case 2.1: Looking at my target. Shoot.
                        case Some(Person(viewId, _)) if viewId == targetId => Shoot 
                        // Case 2.2: Not looking at my target. Keep moving.
                        case _ =>
                            goTo(Position(coords, dir), goal, passablePlayers=true, tiles) |>
                                Option.getWithDefault(Turn(Counterclockwise))
                            // TODO pick another target if this one is inaccessible
                    }
            }
        })

    pub def smartSearchAndDestroy(): Strategy =
        statelessStrategy((id, info) -> {
            let tiles = getTiles(info);
            let board = Board({rows=getRows(info), cols=getColumns(info), tiles=tiles});
            // Get my own position
            let Position(coords, dir) = getPlayers(info) |> Map.get(id) |> Utils/Option.unsafeGet;

            match raytraceEx(dir, coords, board) {
                case Some(Person(_, _)) =>
                    // Shoot first, ask questions later!
                    Shoot
                case _ =>
                    // optimization possibility: precompute the set of spaces where this predicate
                    // is true in n^2 time, instead of on-demand evaluation (n^3)

                    // find a position where somebody (not ourselves) can be shot
                    let goal = match Position(c, d) -> match raytraceEx(d, c, board) {
                        case Some(Person(seenId, _)) => seenId != id
                        case _ => false
                    };
                    // go to such a position, otherwise do a victory spin 
                    goTo(Position(coords, dir), goal, passablePlayers=false, tiles)
                     |> Option.getWithDefault(Turn(Counterclockwise))
            }
        })

    // Utilities

    ///
    /// Selects a move based on the shortest path from position p to a
    /// coordinate where `goal` is true. Considers players obstacles if
    /// `passablePlayers` is `false`.
    ///
    def goTo
            (p: Position, goal: Position -> Bool \ ef, passablePlayers: {passablePlayers=Bool}, tiles: Map[Coordinates, Tile]):
            Option[Move] \ ef =
    {
        use Option.flatMap;

        // todo: this predicate should just be caller supplied
        def availablePosition(c: Coordinates) = {
            if (passablePlayers.passablePlayers)
                Map.get(c, tiles) != Some(Wall)
            else
                Map.get(c, tiles) == None
        };
        let* moves = findShortestPath(availablePosition, p, goal);
        List.head(moves)
    }

}
