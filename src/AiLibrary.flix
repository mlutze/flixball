namespace Flixball/AiLibrary {
    use Flixball/Core.GameState;
    use Flixball/Core.GameState.{GameState};
    use Flixball/Core.Board;
    use Flixball/Core.Board.{Board};
    use Flixball/Core.Coordinates;
    use Flixball/Core.Coordinates.Coordinates;
    use Flixball/Core.Move;
    use Flixball/Core.Move.{Turn, Shoot, Walk};
    use Flixball/Core.Position;
    use Flixball/Core.Position.{Position};
    use Flixball/Core.MoveLogic;
    use Flixball/Core.MoveLogic.{MoveLogic};
    use Flixball/Core.Rotation;
    use Flixball/Core.Rotation.{Clockwise, Counterclockwise};
    use Flixball/Core.Direction;
    use Flixball/Core.Direction.{North, South, West, East};

    use Flixball/GridGraph.findShortestPath;

    def constantAction(m: Move): MoveLogic =
        ((_, i, map) -> (m, i, map)) |> MoveLogic

    pub def shoot(): MoveLogic = constantAction(Shoot)

    pub def walk(): MoveLogic = constantAction(Walk)

    pub def rotate(r: Rotation): MoveLogic = constantAction(Turn(r))

    pub def spinAndShoot(r: Rotation): MoveLogic =
        MoveLogic((_, i0, m0) -> {
            if (i0 == 0) (Turn(r), 1, m0)
            else (Shoot, 0, m0)
        })

    pub def goAndSpin(id: {id::Int32}, coords: Coordinates): MoveLogic =
        MoveLogic(match GameState(_, playerMap, board) -> (i0, m0) -> {
            let currentPosition = match playerMap |> Map.get(id.id) {
                case None => ?unreachable
                case Some(v) => v
            };
            let move = goTo(currentPosition, coords, board) |> Option.getWithDefault(Turn(Clockwise));
            (move, i0, m0)
        })

    // Utilities

    pub def goTo(p: Position, coords: Coordinates, b: Board): Option[Move] = {
        use Option.flatMap;

        let Board(br) = b;
        let Position(coordsFrom, direction) = p;
        
        let* path = findShortestPath(
            c -> Option.isEmpty(Map.get(c, br.tiles)),
            start=coordsFrom, coords);
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

    pub enum DirectionChoice with Eq {
        case Nothing
        case Either
        case MustTurn(Rotation)
    }

    pub def rotateTowardsDir(current: {current::Direction}, target: Direction): DirectionChoice =
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
