namespace Flixball/AiLibrary {
    use Flixball/Core.AiState;
    use Flixball/Core.Board;
    use Flixball/Core.Board.{Board};
    use Flixball/Core.Coordinates;
    use Flixball/Core.Coordinates.Coordinates;
    use Flixball/Core.Direction;
    use Flixball/Core.Direction.{North, South, West, East};
    use Flixball/Core.GameState;
    use Flixball/Core.GameState.{GameState};
    use Flixball/Core.Move;
    use Flixball/Core.Move.{Turn, Shoot, Walk};
    use Flixball/Core.MoveLogic;
    use Flixball/Core.PlayerId;
    use Flixball/Core.Position;
    use Flixball/Core.Position.{Position};
    use Flixball/Core.Rotation;
    use Flixball/Core.Rotation.{Clockwise, Counterclockwise};
    use Flixball/Core.Tile.{Person, Wall};
    use Flixball/GridGraph.findShortestPath;
    use Flixball/GridGraph.raytraceEx;

    def constantAction(m: Move): MoveLogic[reg] =
        // TODO: this should use the upcast keyword at 0.31.0
        _reg -> upcast(_id -> upcast(_b -> m))
    
    pub def shoot(): MoveLogic[reg] = constantAction(Shoot)

    pub def walk(): MoveLogic[reg] = constantAction(Walk)

    pub def rotate(r: Rotation): MoveLogic[reg] = constantAction(Turn(r))

    pub def wander(seed: Int64): MoveLogic[reg] = wanderAux(seed)

    def wanderAux(seed: Int64, reg: Region[reg], _id: PlayerId): (Board -> Move & reg) & reg =
        use RegionedRandom.{nextInt32, newWithSeed};
        let random = newWithSeed(reg, seed);

        def moveFunction(_b: Board) = {
            let choices = Nel(Walk, Walk :: Turn(Clockwise) :: Turn(Counterclockwise) :: Nil);
            RegionedRandom.chooseNel(random, choices)
        };
        moveFunction

    pub def spinAndShoot(r: Rotation): MoveLogic[reg] = spinAndShootAux(r)

    def spinAndShootAux(r: Rotation, reg: Region[reg], _id: PlayerId): (Board -> Move & reg) & reg =
        let shouldTurn = ref true @ reg;
        def changeAction() = shouldTurn := not deref shouldTurn;

        def moveFunction(_b: Board) = {
            changeAction();
            if (deref shouldTurn) Turn(r) else Shoot
        };
        moveFunction

    pub def goAndSpin(coords: Coordinates): MoveLogic[reg] = goAndSpinAux(coords)

    def goAndSpinAux(coords: Coordinates, _reg: Region[reg], id: PlayerId): (Board -> Move & reg) & reg =
        // Here the whole plan could be cached once computed
        // instead of full recomputation on each step.
        def moveFunction(b: Board) = {
            use Option.flatMap;
            let optMove = {
                let* pos = Flixball/Core/Board.player(b, id);
                goTo(pos, coords, b)
            };
            match optMove {
                case Some(m) => m
                case None => Turn(Clockwise)
            }
        };
        // sadly things are messy because of subtype-less effects
        upcast(moveFunction) as & reg
    
    ///
    /// Go to the next player on the list and shoot them.
    /// Doesn't necessarily take the shortest path to find a shooting angle.
    ///
    pub def naiveSearchAndDestroy(): MoveLogic[r] = naiveSearchAndDestroyAux

    def naiveSearchAndDestroyAux(reg: Region[reg], myId: PlayerId): (Board -> Move & reg) & reg =
        let target = ref None @ reg;

        def moveFunction(b: Board) = {

            let playerMap = Flixball/Core/Board.players(b) |> List.toMap;

            // Get my own position
            let Position(coords, dir) = match playerMap |> Map.get(myId) {
                case None => unreachable!()
                case Some(v) => v
            };

            // find out if we need a new target and update living target position
            let needNewTarget = match deref target {
                case Some((targetId, _)) =>
                    match Map.find((id, _) -> targetId == id, playerMap) {
                        case None => true // target is dead
                        case Some((_, pos)) =>
                            // target is alive, update position
                            target := Some((targetId, pos));
                            false
                    }
                case None => true
            };

            // try to find a new target
            if (needNewTarget) {
                // Pick a target from among the players (lowest ID except me)
                target := playerMap |> Map.find((id, _) -> myId != id) 
            } else ();

            match deref target {
                // Case 1: No target. Just spin for fun.
                case None => Turn(Clockwise)

                // Case 2: Some target. Hunt them down.
                case Some((targetId, Position(targetCoords, _))) =>
                    match raytraceEx(dir, coords, b) {
                        // Case 2.1: Looking at my target. Shoot.
                        case Some(Person(viewId, _)) if viewId == targetId => Shoot 
                        // Case 2.2: Not looking at my target. Keep moving.
                        case _ => goTo(Position(coords, dir), targetCoords, b) |> Option.getWithDefault(Turn(Clockwise))
                            // TODO pick another target if this one is inaccessible
                    }
            }
        };
        moveFunction

    // Utilities

    ///
    /// Selects a move based on the shortest path from position p to the given coords.
    ///
    def goTo(p: Position, coords: Coordinates, b: Board): Option[Move] = {
        use Option.flatMap;

        let Board(br) = b;
        let Position(coordsFrom, direction) = p;
        
        let* path = findShortestPath(
            c -> Map.get(c, br.tiles) != Some(Wall),
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
