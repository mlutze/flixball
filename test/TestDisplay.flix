namespace TestDisplay {
    use Flixball/Core.{Board, MoveLogic, PlayerId};
    use Flixball/Core.Board.Board;
    use Flixball/Core.Direction.{East, North, South, West};
    use Flixball/Core.Rotation.{Clockwise, Counterclockwise};
    use Flixball/Core.Tile.{Person, Wall};
    use Flixball/Core/Board.{automataBoard, randomBoard};
    use Flixball/Core/GameState.mkGameState;
    use Flixball/AiLibrary.{
        rotate, shoot, walk, spinAndShoot, goAndSpin, naiveSearchAndDestroy,
        wander, smartSearchAndDestroy
    };

    def testBoard01(): (Board, Map[PlayerId, MoveLogic]) =
        let board = match Flixball/Core/Board.fromString(String.unlines(
            "     " ::
            "     " ::
            "  v  " ::
            "   < " ::
            Nil
        )) {
            case Ok(b) => b
            case Err(msg) => bug!(msg)
        };
        let moveLogics = Map#{
            0 => walk(),
            1 => shoot()
        };
        (board, moveLogics)
    
    def testBoard02(): (Board, Map[PlayerId, MoveLogic]) =
        let board = match Flixball/Core/Board.fromString(String.unlines(
            "                  " ::
            " >  ^^^^^^^#  <   " ::
            "                  " ::
            Nil
        )) {
            case Ok(b) => b
            case Err(msg) => bug!(msg)
        };
        let moveLogics = Map#{
            0 => shoot(),
            1 => rotate(Clockwise),
            2 => rotate(Counterclockwise),
            3 => rotate(Clockwise),
            4 => rotate(Counterclockwise),
            5 => rotate(Clockwise),
            6 => rotate(Counterclockwise),
            7 => rotate(Clockwise),
            8 => spinAndShoot(Clockwise)
        };
        (board, moveLogics)

    def testBoard03(): (Board, Map[PlayerId, MoveLogic]) =
        let board = match Flixball/Core/Board.fromString(String.unlines(
            "^ #       " ::
            "  #       " ::
            "  #       " ::
            "  #  #    " ::
            "     #    " ::
            "########< " ::
            "          " ::
            "        ##" ::
            "          " ::
            "          " ::
            Nil
        )) {
            case Ok(b) => b
            case Err(msg) => bug!(msg)
        };
        let moveLogics = Map#{
            0 => goAndSpin((10, 10)),
            1 => walk()};
        (board, moveLogics)

    def testBoard04(): Board =
        randomBoard(719_657i64, rows=15, 10, 0.3)
    
    def testBoard05(): Board =
        automataBoard(285_041_125i64, rows=25, 40, 0.38, 3)

    def testBoard06(): (Board, Map[PlayerId, MoveLogic]) =
        let board = match Flixball/Core/Board.fromString(String.unlines(
            "^         " ::
            " v        " ::
            "  <       " ::
            "   >      " ::
            "    <     " ::
            "     v    " ::
            "      ^   " ::
            "       <  " ::
            "        v " ::
            "         >" ::
            Nil
        )) {
            case Ok(b) => b
            case Err(msg) => bug!(msg)
        };
        let moveLogics = Map#{
            0 => naiveSearchAndDestroy(), 
            1 => wander(), 
            2 => wander(),
            3 => wander(),
            4 => wander(),
            5 => wander(),
            6 => wander(),
            7 => wander(),
            8 => wander(),
            9 => wander()
        };
        (board, moveLogics)

    def testBoard07(): (Board, Map[PlayerId, MoveLogic]) =
        let board = match Flixball/Core/Board.fromString(String.unlines(
            "^   #    <" ::
            "    #  ###" ::
            "#   #  #  " ::
            "v      >  " ::
            "   #### ##" ::
            "     ^    " ::
            "###  #  # " ::
            "  <###  ##" ::
            "       >  " ::
            "    ##    " ::
            Nil
        )) {
            case Ok(b) => b
            case Err(msg) => bug!(msg)
        };
        let moveLogics = Map#{
            0 => smartSearchAndDestroy(), 
            1 => wander(), 
            2 => wander(),
            3 => wander(),
            4 => wander(),
            5 => wander(),
            6 => wander()
        };
        (board, moveLogics)

    // Test Scenarios

    pub def testDisplayBoard01(): Unit & Impure =
        Flixball/Display.displayBoard(fst(testBoard01()))

    pub def testRunBoard01(): Unit & Impure =
        Flixball/Display.runGameState(500i64, testBoard01() ||> mkGameState)

    pub def testDisplayBoard02(): Unit & Impure =
        Flixball/Display.displayBoard(fst(testBoard02()))

    pub def testRunBoard02(): Unit & Impure =
        Flixball/Display.runGameState(500i64, testBoard02() ||> mkGameState)

    pub def testDisplayBoard03(): Unit & Impure =
        Flixball/Display.displayBoard(fst(testBoard03()))

    pub def testRunBoard03(): Unit & Impure =
        Flixball/Display.runGameState(200i64, testBoard03() ||> mkGameState)

    pub def testDisplayBoard04(): Unit & Impure =
        Flixball/Display.displayBoard(testBoard04())

    pub def testDisplayBoard05(): Unit & Impure =
        Flixball/Display.displayBoard(testBoard05())

    pub def testRunBoard06(): Unit & Impure =
        Flixball/Display.runGameState(500i64, testBoard06() ||> mkGameState)

    pub def testRunBoard07(): Unit & Impure =
        Flixball/Display.runGameState(500i64, testBoard07() ||> mkGameState)
}
