namespace TestDisplay {
    use Flixball/Core.Board;
    use Flixball/Core.Board.{Board};
    use Flixball/Core.Direction;
    use Flixball/Core.Direction.{North, West, South, East};
    use Flixball/Core.GameState;
    use Flixball/Core.GameState.{GameState};
    use Flixball/Core.Move;
    use Flixball/Core.Move.{Turn, Shoot, Walk};
    use Flixball/Core.MoveLogic;
    use Flixball/Core.MoveLogic.{MoveLogic};
    use Flixball/Core.Player;
    use Flixball/Core.Player.{Player};
    use Flixball/Core.Position;
    use Flixball/Core.Position.{Position};
    use Flixball/Core.Rotation;
    use Flixball/Core.Rotation.{Clockwise, Counterclockwise};
    use Flixball/Core.Tile;
    use Flixball/Core.Tile.{Wall, Person};

    use Flixball/AiLibrary.{rotate, shoot, walk, spinAndShoot, goAndSpin};

    def testBoard01(): Board =
        Board({rows = 5, cols = 5, tiles = Map#{
            (2, 2) => Person(Player(0, South, walk())),
            (3, 3) => Person(Player(1, West, shoot()))
        }}) |> Flixball/Core/Board.addBorder
    
    def testBoard02(): Board =
        Board({rows = 3, cols = 15, tiles = Map#{
            (1, 1) => Person(Player(0, East, shoot())),
            (1, 3) => Person(Player(1, North, rotate(Clockwise))),
            (1, 4) => Person(Player(2, North, rotate(Counterclockwise))),
            (1, 5) => Person(Player(3, North, rotate(Clockwise))),
            (1, 6) => Person(Player(4, North, rotate(Counterclockwise))),
            (1, 7) => Person(Player(5, North, rotate(Clockwise))),
            (1, 8) => Person(Player(6, North, rotate(Counterclockwise))),
            (1, 9) => Person(Player(7, North, rotate(Clockwise))),
            (1, 10) => Wall,
            (1, 12) => Person(Player(8, West, spinAndShoot(Clockwise)))
        }}) |> Flixball/Core/Board.addBorder

    def testBoard03(): Board =
        Board({rows = 10, cols = 10, tiles = Map#{
            (0, 0) => Person(Player(0, North, goAndSpin(id = 0, x = 10, 10)))
        }}) |> Flixball/Core/Board.addBorder


    pub def testDisplayBoard01(): Unit & Impure =
        Flixball/Display.displayBoard(testBoard01())

    pub def testDisplayBoard02(): Unit & Impure =
        Flixball/Display.displayBoard(testBoard02())

    pub def testDisplayBoard03(): Unit & Impure =
        Flixball/Display.displayBoard(testBoard03())

    pub def testRunBoard01(): Unit & Impure =
        Flixball/Display.runBoard(1000i64, testBoard01())

    pub def testRunBoard02(): Unit & Impure =
        Flixball/Display.runBoard(1000i64, testBoard02())

    pub def testRunBoard03(): Unit & Impure =
        Flixball/Display.runBoard(1000i64, testBoard03())
}
