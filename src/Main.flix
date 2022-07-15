namespace Flixball {
    
    pub enum Board({rows :: Int32, cols :: Int32, tiles :: Map[(Int32, Int32), Tile]})

    pub enum Direction with Eq {
        case North
        case East
        case South
        case West
    }

    pub enum Rotation with Eq {
        case Clockwise
        case Counterclockwise
    }

    pub enum Move with Eq {
        case Turn(Rotation)
        case Shoot
        case Walk
    }

    pub enum Tile {
        case Wall
        case Person(Player)
    }

    // id
    pub enum Player(Int32, Direction, GameState -> Move)

    instance Eq[Player] {

        pub def eq(x: Player, y: Player): Bool =
            let Player.Player((p1, _, _)) = x;
            let Player.Player((p2, _, _)) = y;
            p1 == p2

    }


    instance Order[Player] {

        pub def compare(x: Player, y: Player): Comparison =
            let Player.Player((p1, _, _)) = x;
            let Player.Player((p2, _, _)) = y;
            p1 <=> p2

    }

    pub enum GameState(Map[Int32, (Int32, Int32)], Board)

    // loop:
    // get all players' moves
    // resolve the moves
    // display the board
    pub def resolve(moves0: Map[Player, Move], state0: GameState): GameState = {
        let shooters = moves0 
            |> Map.filter(Eq.eq(Shoot)) 
            |> Map.keysOf;
        let dead = resolveShots(state0, shooters);
        let GameState(players0, board0) = state0;
        let players1 = (players0, dead) ||> Set.foldLeft((acc, p) -> Map.remove(p, acc));
        let moves1 = (moves0, dead) ||> Set.foldLeft((acc, p) -> Map.remove(p, acc));
        let board1 = (board0, dead) ||> ???;
        let rotators = moves1
            |> Map.filterMap(m -> match m {
                case Turn(r) => Some(r)
                case Shoot => None
                case Walk => None
            })
            |> Map.filterWithKey((person, _) -> not Set.memberOf(person, dead)); 

        let movers = moves1
            |> Map.filter(Eq.eq(Walk))
            |> Map.keysOf;
        ???
    }

    /// Returns the set of dead players
    pub def resolveShots(state: GameState, shooters: Set[Player]): Set[Player] = {
        shooters |> Set.flatMap(resolveShot(state) >> Option.toSet) 
    }


    pub def resolveShot(state: GameState, shooter: Player): Option[Player] = {
        let GameState(_, board) = state;
        use Option.flatMap;
        let* (dir, row, col) = getPosition(shooter, state);
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

    pub def getPosition(p: Player, state: GameState): Option[(Direction, Int32, Int32)] = {
        let Player.Player(_, dir, _) = p;
        let GameState(players, _) = state;
        use Option.flatMap;
        let* loc = players |> Map.get(p);
        let (row, col) = loc;
        Some((dir, row, col))
    }
}
