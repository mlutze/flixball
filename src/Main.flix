// The main entry point.
def main(): Unit & Impure =
    println("Hello World!")

namespace Flixball {
    
    pub def left(): Char = '<'

    pub def right(): Char = '>'

    pub def up(): Char = '^'

    pub def down(): Char = 'v'

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
        case Move
    }

    pub enum Tile {
        case Wall
        case Person(Player)
    }

    // id
    pub enum Player(Int32, Direction, Board -> Move)

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

    enum Location {
        case At(Int32, Int32)
        case Dead
    }


    pub enum GameState(Map[Player, Location], Board)

    // loop:
    // get all players' moves
    // resolve the moves
    // display the board
    pub def resolve(moves: Map[Player, Move], board: Board): Board = {
        let shoots = moves 
            |> Map.filter(Eq.eq(Shoot)) 
            |> Map.keysOf;
        ???
    }

    /// Returns the set of dead players
    pub def resolveShots(shooters: Set[Player], board: Board): Set[Player] = {
        ???
    }

    pub def resolveShot(shooter: Player, state: GameState): Option[Player] = {
        use Option.flatMap;
        let* (dir, row, col) = getPosition(shooter, state);
        ???
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
        ???
    }

    pub def getPosition(p: Player, state: GameState): Option[(Direction, Int32, Int32)] = {
        let Player.Player(_, dir, _) = p;
        let GameState(players, _) = state;
        use Option.flatMap;
        let* loc = players |> Map.get(p);
        let* (row, col) = loc |> toOption;
        Some((dir, row, col))
    }

    pub def toOption(loc: Location): Option[(Int32, Int32)] = match loc {
        case At(row, col) => Some((row, col))
        case Dead => None
    }
}
