// The main entry point.
def main(): Unit & Impure =
    println("Hello World!")

def left(): Char = '<'

def right(): Char = '>'

def up(): Char = '^'

def down(): Char = 'v'

enum Board({rows :: Int32, cols :: Int32, get :: (Int32, Int32) -> Tile})

enum Rotation {
    case Clockwise
    case Counterclockwise
}

enum Move {
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
enum Player(Int32, Board -> Move)

// loop:
// get all players' moves
// resolve the moves
// display the board