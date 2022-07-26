namespace Flixball/Engine {
    use Flixball/Core.Board.Board;
    use Flixball/Core.Board;
    use Flixball/Core.Direction.East;
    use Flixball/Core.Direction.North;
    use Flixball/Core.Direction.South;
    use Flixball/Core.Direction.West;
    use Flixball/Core.Direction;
    use Flixball/Core.GameState.GameState;
    use Flixball/Core.GameState;
    use Flixball/Core.Move.Shoot;
    use Flixball/Core.Move.Turn;
    use Flixball/Core.Move.Walk;
    use Flixball/Core.Move;
    use Flixball/Core.Player.Player;
    use Flixball/Core.Player;
    use Flixball/Core.Position.Position;
    use Flixball/Core.Position;
    use Flixball/Core.Rotation.Clockwise;
    use Flixball/Core.Rotation.Counterclockwise;
    use Flixball/Core.Rotation;
    use Flixball/Core.Tile.Person;
    use Flixball/Core.Tile.Wall;
    use Flixball/Core.Tile;



    pub def getPlayerMap(b: Board): Map[Int32, Position] =
        let Board(br) = b;
        br.tiles |> Map.toList |> List.filterMap(match ((x, y), t) -> match t {
            case Person(Player(id, direction, _)) =>
                Some((id, Position(x, y, direction)))
            case _ => None
        }) |> List.toMap

    ///
    /// resolves one step of the GameState.
    ///
    pub def runStep(gs: GameState): GameState = {
        let GameState(_, board) = gs;
        let Board(br) = board;
        let moves0 = Map.valuesOf(br.tiles) |> List.filterMap(tile -> match tile {
            case Person(p) =>
                let Player(_, _, move) = p;
                Some((p, move(gs)))
            case _ => None
        }) |> List.toMap;
        resolve(moves0, gs)
    }
    
    // loop:
    // get all players' moves
    // resolve the moves
    // display the board
    pub def resolve(moves0: Map[Player, Move], state0: GameState): GameState = {
        let shooters = moves0 
            |> Map.filter(Eq.eq(Shoot)) 
            |> Map.keysOf;
        let dead = resolveShots(state0, shooters);
        let state1 = (state0, dead) ||> Set.foldLeft(acc -> match Player(id, _, _) -> Flixball/Core/GameState.removePlayer(id, acc));
        let moves1 = (moves0, dead) ||> Set.foldLeft((acc, p) -> Map.remove(p, acc));
        let _rotators = moves1
            |> Map.filterMap(m -> match m {
                case Turn(r) => Some(r)
                case Shoot => None
                case Walk => None
            });
        // TODO finish rotating

        let _movers = moves1
            |> Map.filter(Eq.eq(Walk))
            |> Map.keysOf;
        // TODO finish moving
        
        state1
    }

    pub def unsafeGet(k: k, m: Map[k, v]): v with Order[k] = match Map.get(k, m) {
        case None => bug!(":(")
        case Some(v) => v
    }

    pub def rotatePlayer(rot: Rotation, p: Player): Player = {
        let Player(id, dir, f) = p; 
        Player(id, rotateDir(rot, dir), f)
    }

    pub def rotateDir(rot: Rotation, dir: Direction): Direction = match (rot, dir) {
        case (Clockwise, North) => East
        case (Clockwise, East) => South
        case (Clockwise, South) => West
        case (Clockwise, West) => North

        case (Counterclockwise, North) => West
        case (Counterclockwise, West) => South
        case (Counterclockwise, South) => East
        case (Counterclockwise, East) => North
    }

    /// Returns the set of dead players
    pub def resolveShots(state: GameState, shooters: Set[Player]): Set[Player] = {
        shooters |> Set.flatMap(resolveShot(state) >> Option.toSet) 
    }


    pub def resolveShot(state: GameState, shooter: Player): Option[Player] = {
        let GameState(_, board) = state;
        use Option.flatMap;
        let* Position(row, col, dir) = getPosition(shooter, state);
        let (r, c) = step(row, col, dir);
        match raytrace(dir, r, c, board) {
            case Some(Person(p)) => Some(p)
            case Some(Wall) => None
            case None => None
        }
    }

    pub def step(row: Int32, col: Int32, dir: Direction): (Int32, Int32) = match dir {
        case North => (row - 1, col)
        case East => (row, col + 1)
        case South => (row + 1, col)
        case West => (row, col - 1)
    }

    pub def raytrace(dir: Direction, row: Int32, col: Int32, board: Board): Option[Tile] = {
        let Board(rec) = board;
        let rows = rec.rows;
        let cols = rec.cols;
        let tiles = rec.tiles;
        if (row < 0 or row >= rows) {
            None
        } else if (col < 0 or col >= cols) {
            None
        } else {
            match (tiles |> Map.get((row, col))) {
                case None =>
                    let (r, c) = step(row, col, dir);
                    raytrace(dir, r, c, board)
                case Some(tile) => Some(tile)
            }
        }
    }

    pub def getPosition(p: Player, state: GameState): Option[Position] = {
        let Player.Player(id, _, _) = p;
        let GameState(players, _) = state;
        use Option.flatMap;
        players |> Map.get(id)
    }
}
