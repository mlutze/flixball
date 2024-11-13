mod Flixball.Display {
    import java.lang.Thread

    use Flixball.Core.Direction
    use Flixball.Core.Direction.{East, North, South, West}
    use Flixball.Core.Tile
    use Flixball.Core.Tile.Person
    use Flixball.Core.Tile.Wall
    use Flixball.Core.Board.Board
    use Flixball.Core.Board.Board.Board
    use Flixball.Core.GameState.{board => gsBoard}
    use Flixball.Core.GameState.GameState

    ///
    /// Clears then screen and then displays the board. The cursor will be left
    /// at the end.
    ///
    pub def displayBoard(b: Board): Unit \ IO = {
        Console.run(() -> Terminal.clearScreenAndReset());
        b |> boardLines |> List.forEach(println)
    }

    ///
    /// Continously simulates the game state and drawing it between each step with a
    /// set delay. One second is `1000i64`.
    ///
    pub def runGameState(delayDuration: Int64, gs: GameState): Unit \ IO = {
        displayBoard(gsBoard(gs));
        Thread.sleep(delayDuration);
        runGameState(delayDuration, Flixball.Engine.runStep(gs))
    }

    def boardLines(b: Board): List[String] = region r {
        let Board(br) = b;
        let lines = MutList.empty(r);
        let idColor = mkIdColorMap(b);
        Iterator.range(r, 0, br#rows) |> Iterator.forEach(row -> {
            let sb = StringBuilder.empty(r);
            Iterator.range(r, 0, br#cols) |> Iterator.forEach(column -> {
                match Map.get((row, column), br#tiles) {
                    case None => StringBuilder.append(" ", sb)
                    case Some(tile) => StringBuilder.append(tileStr(idColor, tile), sb)
                }
            });
            MutList.push(StringBuilder.toString(sb), lines)
        });
        MutList.toList(lines)
    }

    def tileStr(idColor: Int32 -> String -> String, t: Tile): String = match t {
        case Wall => "#"
        case Person(id, direction) => directionStr(direction) |> idColor(id)
    }

    def mkIdColorMap(_b: Board): Int32 -> String -> String =
        // all the ANSI colors
        id -> match (Int32.modulo(id, 12)) {
            case 0 => Chalk.magenta
            case 1 => Chalk.red
            case 2 => Chalk.yellow
            case 3 => Chalk.blue
            case 4 => Chalk.cyan
            case 5 => Chalk.green
            case 6 => Chalk.magentaBright
            case 7 => Chalk.redBright
            case 8 => Chalk.yellowBright
            case 9 => Chalk.blueBright
            case 10 => Chalk.cyanBright
            case _ => Chalk.greenBright
        }

    def directionStr(d: Direction): String = match d {
        case North => "^"
        case South => "v"
        case West => "<"
        case East => ">"
    }

}
