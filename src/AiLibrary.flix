namespace Flixball/AiLibrary {
    use Flixball/Core.{Board, Coordinates, Direction, Move, MoveLogic, Position, Rotation};
    use Flixball/Core.Board.Board;
    use Flixball/Core.Direction.{East, North, South, West};
    use Flixball/Core.GameState.GameState;
    use Flixball/Core.Move.{Shoot, Turn, Walk};
    use Flixball/Core.MoveLogic.MoveLogic;
    use Flixball/Core.Position.Position;
    use Flixball/Core.Rotation.Clockwise;
    use Flixball/Core.Rotation.Counterclockwise;
    use Flixball/Core.Tile.{Person, Wall};
    use Flixball/GridGraph.{findShortestPath, raytraceEx};

    def constantAction(m: Move): MoveLogic =
        ((_, _, state) -> (m, state)) |> MoveLogic

    pub def shoot(): MoveLogic = constantAction(Shoot)

    pub def walk(): MoveLogic = constantAction(Walk)

    pub def rotate(r: Rotation): MoveLogic = constantAction(Turn(r))

    pub def wander(): MoveLogic =
        use RegionedRandom.nextInt32;
        MoveLogic((_, _) -> match (i0, m0) -> region r {
            let ran = RegionedRandom.newWithSeed(r, Int32.toInt64(i0));
            let roll = ref nextInt32(ran) @ r;
            let choices = Nel(Walk, Walk :: Turn(Clockwise) :: Turn(Counterclockwise) :: Nil);
            let move = RegionedRandom.chooseNel(ran, choices);
            (move, (deref roll, m0))
        })

    pub def spinAndShoot(r: Rotation): MoveLogic =
        MoveLogic((_, _) -> match (i0, m0) -> {
            if (i0 == 0) (Turn(r), (1, m0))
            else (Shoot, (0, m0))
        })

    pub def goAndSpin(coords: Coordinates): MoveLogic =
        MoveLogic(match GameState(_, _, playerMap, board) -> id -> state -> {
            let currentPosition = match playerMap |> Map.get(id) {
                case None => ?unreachable
                case Some(v) => v
            };
            let move = goTo(currentPosition, Eq.eq(coords), board) |> Option.getWithDefault(Turn(Clockwise));
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
            let Position(coords, dir) = match playerMap |> Map.get(id) {
                case None => unreachable!()
                case Some(v) => v
            };

            // Pick a move
            let move = match target {
                // Case 1: No target. Just spin for fun.
                case None => Turn(Clockwise)

                // Case 2: Some target. Hunt them down.
                case Some((targetId, Position(targetCoords, _))) =>
                    match raytraceEx(dir, coords, board) {
                        // Case 2.1: Looking at my target. Shoot.
                        case Some(Person(viewId, _)) if viewId == targetId => Shoot 
                        // Case 2.2: Not looking at my target. Keep moving.
                        case _ => goTo(Position(coords, dir), Eq.eq(targetCoords), board) |> Option.getWithDefault(Turn(Clockwise))
                            // TODO pick another target if this one is inaccessible
                    }
            };
            (move, state)
        })

    // Utilities

    ///
    /// Selects a move based on the shortest path from position p to a
    /// coordinate where `goal` is true.
    ///
    def goTo(p: Position, goal: Coordinates -> Bool \ ef, b: Board): Option[Move] \ ef = {
        use Option.flatMap;

        let Board(br) = b;
        let Position(coordsFrom, direction) = p;
        
        let* path = findShortestPath(
            c -> Map.get(c, br.tiles) != Some(Wall),
            start=coordsFrom, goal);
        let* (xNext, yNext) = List.head(path);
        let (xFrom, yFrom) = coordsFrom;

        // if a path exist, find the correct move/turn
        let neededDirection = match (xNext-xFrom, yNext-yFrom) {
            case (1 , 0 ) => South
            case (-1, 0 ) => North
            case (0 , 1 ) => East
            case (0 , -1) => West
            case _ => ?unreachable
        };
        match rotateTowardsDir(current=direction, neededDirection) {
            case Nothing => Some(Walk)
            case MustTurn(rot) => Some(Turn(rot))
            case Either => Some(Turn(Clockwise))
        }
    }

    enum DirectionChoice with Eq {
        case Nothing
        case Either
        case MustTurn(Rotation)
    }

    def rotateTowardsDir(current: {current::Direction}, target: Direction): DirectionChoice =
        match (current.current, target) {
            case (North, North) => Nothing
            case (North, East ) => MustTurn(Clockwise)
            case (North, South) => Either
            case (North, West ) => MustTurn(Counterclockwise)

            case (East, North) => MustTurn(Counterclockwise)
            case (East, East ) => Nothing
            case (East, South) => MustTurn(Clockwise)
            case (East, West ) => Either

            case (South, North) => Either
            case (South, East ) => MustTurn(Counterclockwise)
            case (South, South) => Nothing
            case (South, West ) => MustTurn(Clockwise)

            case (West, North) => MustTurn(Clockwise)
            case (West, East ) => Either
            case (West, South) => MustTurn(Counterclockwise)
            case (West, West ) => Nothing
        }

}
