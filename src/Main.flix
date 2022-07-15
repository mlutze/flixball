// The main entry point.
def main(): Unit & Impure =
    println("Hello World!")

namespace Flixball {
    
    pub def left(): Char = '<'

    pub def right(): Char = '>'

    pub def up(): Char = '^'

    pub def down(): Char = 'v'

    pub enum Board({rows :: Int32, cols :: Int32, get :: (Int32, Int32) -> Tile})

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
        case Player(Player)
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


    pub enum GameState(Set[Player], Board)

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
}
