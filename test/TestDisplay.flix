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
    
    def testBoard02(): Board =
        let shootSpam = _ -> Shoot;
        Board({cols = 15, rows = 3, tiles = Map#{
            (1, 1) => Person(Player(0, East, shootSpam)),
            (1, 3) => Person(Player(1, North, shootSpam)),
            (1, 4) => Person(Player(2, North, shootSpam)),
            (1, 5) => Person(Player(3, North, shootSpam)),
            (1, 6) => Person(Player(4, North, shootSpam)),
            (1, 7) => Person(Player(5, North, shootSpam)),
            (1, 8) => Person(Player(6, North, shootSpam)),
            (1, 9) => Person(Player(7, North, shootSpam)),
            (1, 10) => Wall,
            (1, 12) => Person(Player(8, West, shootSpam))
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
