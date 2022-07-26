namespace Flixball/Display {
    use Flixball/Core.Board;
    use Flixball/Core.Board.{Board};
    use Flixball/Core.Direction;
    use Flixball/Core.Direction.{North, East, South, West};
    use Flixball/Core.GameState;
    use Flixball/Core.GameState.GameState;
    use Flixball/Core.Player;
    use Flixball/Core.Player.{Player};
    use Flixball/Core.Tile;
    use Flixball/Core.Tile.{Wall, Person};

    ///
    /// Clears the screen completely and resets the cursor to the first
    /// position.
    ///
    pub def resetScreen(): Unit & Impure =
        clearScreen();
        resetCursor()

    ///
    /// Clears then screen and then displays the board. The cursor will be left
    /// at the end.
    ///
    pub def displayBoard(b: Board): Unit & Impure = region r {
        let Board(br) = b;
        let idColor = mkIdColorMap(b);
        resetScreen();
        Iterator.range(r, 0, br.rows) |> Iterator.foreach(row -> {
            let sb = StringBuilder.new(r);
            Iterator.range(r, 0, br.cols) |> Iterator.foreach(column -> {
                match Map.get((row, column), br.tiles) {
                    case None => StringBuilder.append!(" ", sb)
                    case Some(tile) => StringBuilder.append!(tileStr(idColor, tile), sb)
                }
            });
            StringBuilder.toString(sb) |> println
        })
    }

    def sleep(): Unit & Impure =
        import static java.lang.Thread.sleep(Int64): Unit & Impure;
        sleep(1000i64)

    pub def runBoard(b: Board): Unit & Impure =
        runGameState(Flixball/Core/GameState.mkGameState(b))
        
    pub def runGameState(gs: GameState): Unit & Impure =
        let GameState(_, _, board) = gs;
        displayBoard(board);
        sleep();
        runGameState(Flixball/Engine.runStep(gs))

    def tileStr(idColor: Int32 -> String -> String, t: Tile): String = match t {
        case Wall => "#"
        case Person(Player(id, direction, _)) => directionStr(direction) |> idColor(id)
    }

    def mkIdColorMap(_b: Board): Int32 -> String -> String =
        id -> match (id mod 5) {
            case 0 => Console.magenta
            case 1 => Console.red
            case 2 => Console.yellow
            case 3 => Console.blue
            case _ => Console.green
        }

    def directionStr(d: Direction): String = match d {
        case North => "^"
        case South => "v"
        case West => "<"
        case East => ">"
    }

    def print(s: s): Unit & Impure with ToString[s] = Console.print(s)

    def println(s: s): Unit & Impure with ToString[s] = Console.printLine(s)

    def escape(s: String): String =
        "\u001B${s}"

    def csi(s: String): String =
        escape("[${s}")

    def setCursor(x: {x::Int32}, y: Int32): Unit & Impure =
        csi("${y+1};${x.x+1}H") |> print
    
    def resetCursor(): Unit & Impure =
        setCursor(x = 0, 0)
    
    def clearScreen(): Unit & Impure =
        csi("2J") |> print

}
