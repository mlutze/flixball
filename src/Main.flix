// The main entry point.
def main(): Unit & Impure =
    println("Hello World!")

namespace Flixball {
    
    pub def left(): Char = '<'

    pub def right(): Char = '>'

    pub def up(): Char = '^'

    pub def down(): Char = 'v'

    pub enum Board({rows :: Int32, cols :: Int32, tiles :: Map[(Int32, Int32), Tile]})

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
        case Empty
    }

    // id
    pub enum Player(Int32, Rotation, Board -> Move)

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

    /// pub def resolveShot(shooter: Player, board: Board): Option[Player] = {
    ///     let* start = 
    /// }

    pub def getPosition(p: Player, state: GameState): Option[(Rotation, Int32, Int32)] = {
        let Player.Player(_, rot, _) = p;
        let GameState(players, _) = state;
        use Option.flatMap;
        let* loc = players |> Map.get(p);
        ???
    }

    pub def toOption(loc: Location): Option[(Int32, Int32)] = match loc {
        case At(row, col) => Some((row, col))
        case Dead => None
    }
}
