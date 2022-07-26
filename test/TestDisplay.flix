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

    use Flixball/AiLibrary.{rotate, shoot, walk, spinAndShoot};

    def testBoard01(): Board =
        Board({cols = 5, rows = 5, tiles = Map#{
            (0, 0) => Wall,
            (0, 1) => Wall,
            (0, 2) => Wall,
            (0, 3) => Wall,
            (0, 4) => Wall,
            (1, 0) => Wall,
            (1, 4) => Wall,
            (2, 0) => Wall,
            (2, 4) => Wall,
            (3, 0) => Wall,
            (3, 4) => Wall,
            (4, 0) => Wall,
            (4, 1) => Wall,
            (4, 2) => Wall,
            (4, 3) => Wall,
            (4, 4) => Wall,
            (2, 2) => Person(Player(0, South, walk())),
            (3, 3) => Person(Player(1, West, shoot()))
        }})
    
    def testBoard02(): Board =
        Board({cols = 15, rows = 3, tiles = Map#{
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
        }})


    pub def testDisplayBoard01(): Unit & Impure =
        Flixball/Display.displayBoard(testBoard01())

    pub def testDisplayBoard02(): Unit & Impure =
        Flixball/Display.displayBoard(testBoard02())

    pub def testRunBoard01(): Unit & Impure =
        Flixball/Display.runBoard(testBoard01())

    pub def testRunBoard02(): Unit & Impure =
        Flixball/Display.runBoard(testBoard02())
}
