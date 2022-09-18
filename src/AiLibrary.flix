namespace Flixball/AiLibrary {
    use Flixball/State.{toState, fromState};
    use Flixball/Core.Board.Board;
    use Flixball/Core.Direction.{East, North, South, West};
    use Flixball/Core.GameState.GameState;
    use Flixball/Core.Move.{Shoot, Turn, Walk};
    use Flixball/Core.MoveLogic.MoveLogic;
    use Flixball/Core.Position.Position;
    use Flixball/Core.Rotation.Clockwise;
    use Flixball/Core.Rotation.Counterclockwise;
    use Flixball/Core.Tile.{Person, Wall};
    use Flixball/Core.{Board, Coordinates, Direction, Move, MoveLogic, Position, Rotation};
    use Flixball/GridGraph.{findShortestPath, raytraceEx};

    def constantAction(m: Move): MoveLogic =
        ((_, _, state) -> (m, state)) |> MoveLogic

    pub def shoot(): MoveLogic = constantAction(Shoot)

    pub def walk(): MoveLogic = constantAction(Walk)

    pub def rotate(r: Rotation): MoveLogic = constantAction(Turn(r))

    pub def wander(): MoveLogic =
        use RegionedRandom.nextInt64;
        MoveLogic((_, _) -> state -> region r {
            // use "0" if there's a bad encoding
            let ran = RegionedRandom.newWithSeed(r, fromState(state) |> Option.getWithDefault(0i64));
            let roll = ref nextInt64(ran) @ r;
            let choices = Nel(Walk, Walk :: Turn(Clockwise) :: Turn(Counterclockwise) :: Nil);
            let move = RegionedRandom.chooseNel(ran, choices);
            (move, toState(deref roll))
        })

    pub def spinAndShoot(r: Rotation): MoveLogic =
        MoveLogic((_, _, state) -> {
            // use "false" if there's a bad encoding
            if (not (fromState(state) |> Option.getWithDefault(false))) (Turn(r), toState(true))
            else (Shoot, toState(false))
        })

    pub def goAndSpin(coords: Coordinates): MoveLogic =
        MoveLogic(match GameState(_, _, playerMap, board) -> id -> state -> {
            let currentPosition = playerMap |> Map.get(id) |> Utils/Option.unsafeGet;
            let goal = match Position(c, _) -> c == coords;
            let move = goTo(currentPosition, goal, passablePlayers=false, board) |> Option.getWithDefault(Turn(Clockwise));
            (move, state)
        })
    
    ///
    /// Go to the next player on the list and shoot them.
    /// Doesn't necessarily take the shortest path to find a shooting angle.
    ///
    pub def naiveSearchAndDestroy(): MoveLogic =
        MoveLogic(match GameState(_, _, playerMap, board) -> id -> state -> {

            // Pick a target from among the players (lowest ID except me)
            let target = playerMap 
                |> Map.filterWithKey((id2, _) -> id != id2) 
                |> Map.toList
                |> List.head;

            // Get my own position
            let Position(coords, dir) = playerMap |> Map.get(id) |> Utils/Option.unsafeGet;

            // Pick a move
            let move = match target {
                // Case 1: No target. Just spin for fun.
                case None => Turn(Clockwise)

                // Case 2: Some target. Hunt them down.
                case Some((targetId, Position(targetCoords, _))) =>
                    let goal = match Position(c, _) -> c == targetCoords;
                    match raytraceEx(dir, coords, board) {
                        // Case 2.1: Looking at my target. Shoot.
                        case Some(Person(viewId, _)) if viewId == targetId => Shoot 
                        // Case 2.2: Not looking at my target. Keep moving.
                        case _ => goTo(Position(coords, dir), goal, passablePlayers=true, board) |> Option.getWithDefault(Turn(Counterclockwise))
                            // TODO pick another target if this one is inaccessible
                    }
            };
            (move, state)
        })

    // Utilities

    ///
    /// Selects a move based on the shortest path from position p to a
    /// coordinate where `goal` is true. Considers players obstacles if
    /// `passablePlayers` is `false`.
    ///
    def goTo
            (p: Position, goal: Position -> Bool \ ef, passablePlayers: {passablePlayers=Bool}, b: Board):
            Option[Move] \ ef =
    {
        use Option.flatMap;

        let Board(br) = b;
        def availablePosition(c: Coordinates) = {
            if (passablePlayers.passablePlayers)
                Map.get(c, br.tiles) != Some(Wall)
            else
                Map.get(c, br.tiles) == None
        };
        let* moves = findShortestPath(availablePosition, p, goal);
        List.head(moves)
    }

    enum DirectionChoice with Eq {
        case Nothing
        case Either
        case MustTurn(Rotation)
    }

}
