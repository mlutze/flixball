namespace TestDisplay {
    use Flixball/Core.Board;
    use Flixball/Core.Board.{Board};
    use Flixball/Core.GameState;
    use Flixball/Core.GameState.{GameState};
    use Flixball/Core.Tile;
    use Flixball/Core.Tile.{Wall, Person};
    use Flixball/Core.Player;
    use Flixball/Core.Player.{Player};
    use Flixball/Core.Direction;
    use Flixball/Core.Direction.{North, West, South, East};
    use Flixball/Core.Move;
    use Flixball/Core.Move.{Turn, Shoot, Walk};
    use Flixball/Core.Position;
    use Flixball/Core.Position.{Position};
    use Flixball/Core.Rotation;
    use Flixball/Core.Rotation.{Clockwise, Counterclockwise};
    use Flixball/Core.MoveLogic;
    use Flixball/Core.MoveLogic.{MoveLogic};

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
            (2, 2) => Person(Player(0, South, Flixball/AiLibrary.walk())),
            (3, 3) => Person(Player(1, West, Flixball/AiLibrary.shoot()))
        }})

    pub def testDisplayBoard(): Unit & Impure =
        Flixball/Display.displayBoard(testBoard01())

    pub def shootInLineScenario(): Unit & Impure =
        Flixball/Display.runBoard(testBoard01())

}