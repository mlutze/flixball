namespace TestDisplay {
    use Flixball/Core.Board;
    use Flixball/Core.Board.{Board};
    use Flixball/Core/Board.{randomBoard, automataBoard};
    use Flixball/Core.Direction;
    use Flixball/Core.Direction.{North, West, South, East};
    use Flixball/Core.GameState;
    use Flixball/Core.GameState.{GameState};
    use Flixball/Core.Move;
    use Flixball/Core.Move.{Turn, Shoot, Walk};
    use Flixball/Core.MoveLogic;
    use Flixball/Core.MoveLogic.{MoveLogic};
    use Flixball/Core.PlayerId;
    use Flixball/Core.Position;
    use Flixball/Core.Position.{Position};
    use Flixball/Core.Rotation;
    use Flixball/Core.Rotation.{Clockwise, Counterclockwise};
    use Flixball/Core.Tile;
    use Flixball/Core.Tile.{Wall, Person};
    use Flixball/Core/GameState.mkGameState;

    use Flixball/AiLibrary.{rotate, shoot, walk, spinAndShoot, goAndSpin, naiveSearchAndDestroy, wander};

    def testBoard01(): (Board, Map[PlayerId, MoveLogic]) =
        let board = Board({rows = 5, cols = 5, tiles = Map#{
            (2, 2) => Person(0, South),
            (3, 3) => Person(1, West)
        }}) |> Flixball/Core/Board.addBorder;
        let moveLogics = Map#{
            0 => walk(),
            1 => shoot()
        };
        (board, moveLogics)
    
    def testBoard02(): (Board, Map[PlayerId, MoveLogic]) =
        let board = Board({rows = 3, cols = 15, tiles = Map#{
            (1, 1) => Person(0, East),
            (1, 3) => Person(1, North),
            (1, 4) => Person(2, North),
            (1, 5) => Person(3, North),
            (1, 6) => Person(4, North),
            (1, 7) => Person(5, North),
            (1, 8) => Person(6, North),
            (1, 9) => Person(7, North),
            (1, 10) => Wall,
            (1, 12) => Person(8, West)
        }}) |> Flixball/Core/Board.addBorder;
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
        let board = Board({rows = 10, cols = 10, tiles = Map#{
            (0, 0) => Person(0, North),
            (0, 2) => Wall,
            (1, 2) => Wall,
            (2, 2) => Wall,
            (3, 2) => Wall,
            (5, 0) => Wall,
            (5, 1) => Wall,
            (5, 2) => Wall,
            (5, 3) => Wall,
            (5, 4) => Wall,
            (5, 5) => Wall,
            (5, 6) => Wall,
            (5, 7) => Wall,
            (4, 5) => Wall,
            (3, 5) => Wall,
            (7, 9) => Wall,
            (7, 8) => Wall
        }}) |> Flixball/Core/Board.addBorder;
        let moveLogics = Map#{0 => goAndSpin((10, 10))};
        (board, moveLogics)

    pub def testBoard04(): Board =
        randomBoard(719_657i64, rows=15, 10, 0.3)
    
    pub def testBoard05(): Board =
        automataBoard(285_041_125i64, rows=25, 40, 0.38, 3)

    pub def testBoard06(): (Board, Map[PlayerId, MoveLogic]) =
        let board = Board({rows = 10, cols = 10, tiles = Map#{
            (0, 0) => Person(0, North),
            (1, 1) => Person(1, South),
            (2, 2) => Person(2, West),
            (3, 3) => Person(3, East),
            (4, 4) => Person(4, West),
            (5, 5) => Person(5, South),
            (6, 6) => Person(6, North),
            (7, 7) => Person(7, West),
            (8, 8) => Person(8, South),
            (9, 9) => Person(9, East)
        }}) |> Flixball/Core/Board.addBorder;
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

    // Test Scenarios

    pub def testDisplayBoard01(): Unit \ IO =
        Flixball/Display.displayBoard(fst(testBoard01()))

    pub def testRunBoard01(): Unit \ IO =
        Flixball/Display.runGameState(500i64, testBoard01() ||> mkGameState)

    pub def testDisplayBoard02(): Unit \ IO =
        Flixball/Display.displayBoard(fst(testBoard02()))

    pub def testRunBoard02(): Unit \ IO =
        Flixball/Display.runGameState(500i64, testBoard02() ||> mkGameState)

    pub def testDisplayBoard03(): Unit \ IO =
        Flixball/Display.displayBoard(fst(testBoard03()))

    pub def testRunBoard03(): Unit \ IO =
        Flixball/Display.runGameState(500i64, testBoard03() ||> mkGameState)

    pub def testDisplayBoard04(): Unit \ IO =
        Flixball/Display.displayBoard(testBoard04())

    pub def testDisplayBoard05(): Unit \ IO =
        Flixball/Display.displayBoard(testBoard05())

    pub def testRunBoard06(): Unit \ IO =
        Flixball/Display.runGameState(500i64, testBoard06() ||> mkGameState)
}
