namespace TestBoard {
    use Flixball/Core/Board.Board;
    use Flixball/Core/Board.Board.Board;
    use Flixball/Core.Tile;
    use Flixball/Core.Direction;

    /// Returns `true` if the board has a border of walls.
    def hasBorder(b: Board): Bool = region r {
        let Board(br) = b;
        let lastCol = br.cols-1;
        let lastRow = br.rows-1;
        def isWall(row, col) = match Map.get((row, col), br.tiles) {
            case Some(Tile.Wall) => true
            case _ => false
            };
        let cols = Iterator.range(r, 0, br.rows) |>
            Iterator.foldLeft((acc, row) -> {
                acc and isWall(row, 0) and isWall(row, lastCol)
            }, true);
        let rows = Iterator.range(r, 0, br.cols) |>
            Iterator.foldLeft((acc, col) -> {
                acc and isWall(0, col) and isWall(lastRow, col)
            }, true);
        cols and rows
    }

    def inboundTiles(b: Board): Bool =
        let Board(br) = b;
        let inbound = match (row, col) ->
            0 <= row and row < br.rows and
            0 <= col and col < br.cols;
        br.tiles |> Map.keysOf |> Set.forAll(inbound)

    def testBoard01(): Result[String, Board] =
        let rowStrings =
            "      " ::
            " #  v   # " ::
            " ######## " ::
            " #  ^   # " ::
            " " ::
            Nil;
        let boardString = rowStrings |> String.unlines;
        Flixball/BoardLibrary.fromString(boardString)

    @test
    def testDimensions(): Bool = match testBoard01() {
        case Err(_) => false 
        case Ok(Board(br)) =>
            br.rows == 5+2 and br.cols == 10+2
    }

    @test
    def testTiles(): Bool = match testBoard01() {
        case Err(_) => false
        case Ok(Board(br)) => 
            // offset by 1 for the border
            def check(row, col, tile) =
                tile == Map.get((row+1, col+1), br.tiles);
            check(1, 4, Tile.Person(0, Direction.South) |> Some) and
            check(3, 4, Tile.Person(1, Direction.North) |> Some) and
            check(2, 4, Tile.Wall |> Some) and
            check(1, 8, Tile.Wall |> Some) and
            check(3, 5, None)
    }

    @test
    def testBorder(): Bool = match testBoard01() {
        case Err(_) => false
        case Ok(b) => hasBorder(b)
    }

    @test
    def testInboundCoordinates(): Bool = match testBoard01() {
        case Err(_) => false
        case Ok(b) => inboundTiles(b)
    }

    @test
    def testError(): Bool =
        match "  #  \n  v  \n#  Q  " |> Flixball/BoardLibrary.fromString {
            case Err(_) => true
            case Ok(_) => false
        }

}
