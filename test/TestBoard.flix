mod TestBoard {
    use Flixball.Core.Board.Board;
    use Flixball.Core.Board.Board.Board;
    use Flixball.Core.Tile;
    use Flixball.Core.Direction;

    /// Asserts that the board has a border of walls.
    def hasBorder(b: Board): Unit \ Assert = region r {
        let Board(br) = b;
        let lastCol = br#cols-1;
        let lastRow = br#rows-1;
        def isWall(row, col) = match Map.get((row, col), br#tiles) {
            case Some(Tile.Wall) => true
            case _ => false
            };
        let cols = Iterator.range(r, 0, br#rows) |>
            Iterator.foldLeft((acc, row) -> {
                acc and isWall(row, 0) and isWall(row, lastCol)
            }, true);
        let rows = Iterator.range(r, 0, br#cols) |>
            Iterator.foldLeft((acc, col) -> {
                acc and isWall(0, col) and isWall(lastRow, col)
            }, true);
        Assert.assertEq(expected = true, cols and rows)
    }

    def inboundTiles(b: Board): Unit \ Assert =
        let Board(br) = b;
        let inbound = match (row, col) ->
            0 <= row and row < br#rows and
            0 <= col and col < br#cols;
        Assert.assertEq(expected = true, br#tiles |> Map.keysOf |> Set.forAll(inbound))

    def testBoard01(): Result[String, Board] =
        let rowStrings =
            "      " ::
            " #  v   # " ::
            " ######## " ::
            " #  ^   # " ::
            " " ::
            Nil;
        let boardString = rowStrings |> String.unlines;
        Flixball.BoardLibrary.fromString(boardString)

    @Test
    def testDimensions(): Unit \ Assert = match testBoard01() {
        case Err(_) => Assert.fail("expected Ok")
        case Ok(Board(br)) =>
            Assert.assertEq(expected = 5 + 2, br#rows);
            Assert.assertEq(expected = 10 + 2, br#cols)
    }

    @Test
    def testTiles(): Unit \ Assert = match testBoard01() {
        case Err(_) => Assert.fail("expected Ok")
        case Ok(Board(br)) =>
            // offset by 1 for the border
            def check(row, col, tile) =
                Assert.assertEq(expected = tile, Map.get((row+1, col+1), br#tiles));
            check(1, 4, Tile.Person(0, Direction.South) |> Some);
            check(3, 4, Tile.Person(1, Direction.North) |> Some);
            check(2, 4, Tile.Wall |> Some);
            check(1, 8, Tile.Wall |> Some);
            check(3, 5, None)
    }

    @Test
    def testBorder(): Unit \ Assert = match testBoard01() {
        case Err(_) => Assert.fail("expected Ok")
        case Ok(b) => hasBorder(b)
    }

    @Test
    def testInboundCoordinates(): Unit \ Assert = match testBoard01() {
        case Err(_) => Assert.fail("expected Ok")
        case Ok(b) => inboundTiles(b)
    }

    @Test
    def testError(): Unit \ Assert =
        match "  #  \n  v  \n#  Q  " |> Flixball.BoardLibrary.fromString {
            case Err(_) => ()
            case Ok(_) => Assert.fail("expected Err")
        }

}
