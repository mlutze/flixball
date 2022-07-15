// The main entry point.
def main(): Unit & Impure =
    println("Hello World!")

def left(): Char = '<'

def right(): Char = '>'

def up(): Char = '^'

def down(): Char = 'v'

enum Board({rows :: Int32, cols :: Int32, get :: (Int32, Int32) -> Tile})

enum Rotation with Eq {
    case Clockwise
    case Counterclockwise
}

enum Move with Eq {
    case Turn(Rotation)
    case Shoot
    case Move
}

enum Tile {
    case Wall
    case Player(Player)
    case Empty
}

// id
enum Player(Int32, Rotation, Board -> Move)

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


enum GameState(Set[Player], Board)

// loop:
// get all players' moves
// resolve the moves
// display the board
def resolve(moves: Map[Player, Move], board: Board): Board = {
    let shoots = moves 
        |> Map.filter(Eq.eq(Shoot)) 
        |> Map.keysOf;
    ???
}