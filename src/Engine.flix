namespace Flixball/Engine {
    use Flixball/Core.Board;
    use Flixball/Core.Board.Board;
    use Flixball/Core/Board.get_;
    use Flixball/Core.Direction;
    use Flixball/Core.Direction.East;
    use Flixball/Core.Direction.North;
    use Flixball/Core.Direction.South;
    use Flixball/Core.Direction.West;
    use Flixball/Core.GameState;
    use Flixball/Core.GameState.GameState;
    use Flixball/Core.Move;
    use Flixball/Core.Move.Shoot;
    use Flixball/Core.Move.Turn;
    use Flixball/Core.Move.Walk;
    use Flixball/Core.MoveLogic;
    use Flixball/Core.MoveLogic.{MoveLogic};
    use Flixball/Core.Player;
    use Flixball/Core.Player.Player;
    use Flixball/Core.Position;
    use Flixball/Core.Position.Position;
    use Flixball/Core.Rotation;
    use Flixball/Core.Rotation.Clockwise;
    use Flixball/Core.Rotation.Counterclockwise;
    use Flixball/Core.Tile;
    use Flixball/Core.Tile.Person;
    use Flixball/Core.Tile.Wall;

    ///
    /// resolves one step of the GameState.
    ///
    pub def runStep(gs: GameState): GameState = region r {
        let GameState(states0, playerMap0, board) = gs;
        let players = Flixball/Core/Board.players(board);
        let newStates = new MutMap(r);
        let moves = players |> List.map(p -> match p {
            case Player(id, _, MoveLogic(move)) =>
                match Map.get(id, states0) {
                    case Some((i0, m0)) =>
                        let (moveToDo, i, m) = move(gs, i0, m0);
                        MutMap.put!(id, (i, m), newStates);
                        (p, moveToDo)
                    case None => unreachable!()
                }
        }) |> List.toMap;
        // Everything in gamestate except the values in player states is handled in resolve.
        resolve(moves, GameState(MutMap.toMap(newStates), playerMap0, board))
    }
    
    ///
    /// Resolve in order:
    ///     shoot
    ///     rotate
    ///     move
    ///
    pub def resolve(moves0: Map[Player, Move], state0: GameState): GameState = {
        let shooters = moves0 
            |> Map.filter(Eq.eq(Shoot)) 
            |> Map.keysOf;
        let dead = resolveShots(state0, shooters);
        let state1 = (state0, dead) ||> Set.foldLeft(acc -> match Player(id, _, _) -> Flixball/Core/GameState.removePlayer(id, acc));
        let moves1 = (moves0, dead) ||> Set.foldLeft((acc, p) -> Map.remove(p, acc));
        let rotators = moves1
            |> Map.filterMap(m -> match m {
                case Turn(r) => Some(r)
                case Shoot => None
                case Walk => None
            });
        let state2 = (state1, rotators) ||> Map.foldLeftWithKey(acc -> match Player(id, _, _) -> rot -> Flixball/Core/GameState.rotatePlayer(id, rot, acc));
        let GameState(_, _, board2) = state2;

        let movers = moves1
            |> Map.filter(Eq.eq(Walk))
            |> Map.keysOf;
        let maybeNewPos = movers 
            |> Set.toList 
            |> List.filterMap(mover -> getPosition(mover, state2) |> Option.map(pos -> (mover, pos)))
            |> List.toMap;
        let newPos = maybeNewPos 
            |> Map.filter(match Position(row, col, _) -> (board2 |> get_(row, col)) |> Option.isEmpty)
            |> Map.map(match Position(row, col, _) -> (row, col))
            |> withUniqueValues;
        // a new position cannot be a wall, a previous player's position, or a new player's position
        let state3 = (state2, newPos) ||> Map.foldLeftWithKey(acc -> match Player(id, _, _) -> match (row, col) -> Flixball/Core/GameState.movePlayer(id, row, col, acc));
        
        state3
    }

    pub def unsafeGet(k: k, m: Map[k, v]): v with Order[k] = match Map.get(k, m) {
        case None => bug!(":(")
        case Some(v) => v
    }

    // TODO terribly inefficient but I did not want to enforce order on the values
    def withUniqueValues(m: Map[k, v]): Map[k, v] with Order[k], Eq[v] = {
        m |> Map.filter(v1 -> not Map.exists((_, v2) -> v1 == v2, m))
    }

    /// Returns the set of dead players
    pub def resolveShots(state: GameState, shooters: Set[Player]): Set[Player] = {
        shooters |> Set.flatMap(resolveShot(state) >> Option.toSet) 
    }


    pub def resolveShot(state: GameState, shooter: Player): Option[Player] = {
        let GameState(_, _, board) = state;
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
        let GameState(_, players, _) = state;
        use Option.flatMap;
        players |> Map.get(id)
    }
}
