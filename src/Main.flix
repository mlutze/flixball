// The main entry point.
def main(): Unit & Impure =
    println("Hello World!")

def left(): Char = '<'

def right(): Char = '>'

def up(): Char = '^'

def down(): Char = 'v'

enum Board[a]({rows :: Int32, cols :: Int32, get :: (Int32, Int32) -> a})