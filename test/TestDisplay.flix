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
            (2, 2) => Person(Player(0, South, gs -> {
                let GameState(playerMap, _) = gs;
                match Map.get(0, playerMap) {
                    case Some(Position(x, y, direction)) => match (x, y, direction) {
                        case (1, 1, East) => Walk
                        case (1, 2, South) => Walk
                        case (2, 2, West) => Walk
                        case (2, 1, North) => Walk
                        case _ => Turn(Clockwise)
                    }
                    case None => Turn(Counterclockwise)
                }
            })),
            (3, 3) => Person(Player(1, West, _ -> Shoot))
        }})

    pub def test01(): Unit & Impure =
        Flixball/Display.displayBoard(testBoard01())

    pub def test02(): Unit & Impure =
        Flixball/Display.runBoard(testBoard01())

}