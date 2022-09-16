namespace Flixball/Display {
    use Flixball/Core.{Board, Direction, GameState, Tile};
    use Flixball/Core.Board.Board;
    use Flixball/Core.Direction.{East, North, South, West};
    use Flixball/Core.GameState.GameState;
    use Flixball/Core.Tile.{Person, Wall};

    ///
    /// Clears then screen and then displays the board. The cursor will be left
    /// at the end.
    ///
    pub def displayBoard(b: Board): Unit & Impure =
        Terminal.clearScreenAndReset();
        b |> boardLines |> List.foreach(println)

    ///
    /// Continously simulates the game state and drawing it between each step with a
    /// set delay. One second is `1000i64`.
    ///
    pub def runGameState(delayDuration: Int64, gs: GameState): Unit & Impure =
        import static java.lang.Thread.sleep(Int64): Unit & Impure;
        let GameState(_, _, _, board) = gs;
        displayBoard(board);
        sleep(delayDuration);
        runGameState(delayDuration, Flixball/Engine.runStep(gs))

    def boardLines(b: Board): List[String] = region r {
        let Board(br) = b;
        let lines = new MutList(r);
        let idColor = mkIdColorMap(b);
        Iterator.range(r, 0, br.rows) |> Iterator.foreach(row -> {
            let sb = StringBuilder.new(r);
            Iterator.range(r, 0, br.cols) |> Iterator.foreach(column -> {
                match Map.get((row, column), br.tiles) {
                    case None => StringBuilder.append!(" ", sb)
                    case Some(tile) => StringBuilder.append!(tileStr(idColor, tile), sb)
                }
            });
            MutList.push!(StringBuilder.toString(sb), lines)
        });
        MutList.toList(lines)
    }

    def tileStr(idColor: Int32 -> String -> String, t: Tile): String = match t {
        case Wall => "#"
        case Person(id, direction) => directionStr(direction) |> idColor(id)
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

}
