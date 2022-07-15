namespace TestDisplay {
    use Flixball.Board;
    use Flixball.Board.{Board};
    use Flixball.GameState;
    use Flixball.GameState.{GameState};
    use Flixball.Tile;
    use Flixball.Tile.{Wall, Person};
    use Flixball.Player;
    use Flixball.Player.{Player};
    use Flixball.Direction;
    use Flixball.Direction.{North, West, South, East};
    use Flixball.Move;
    use Flixball.Move.{Turn, Shoot, Walk};

    /// def testBoard01(): Board =
    ///     Board({cols = 4, rows = 4, tiles = Map#{
    ///         (0, 0) => Wall,
    ///         (0, 1) => Wall,
    ///         (0, 2) => Wall,
    ///         (0, 3) => Wall,
    ///         (1, 0) => Wall,
    ///         (1, 3) => Wall,
    ///         (2, 0) => Wall,
    ///         (2, 3) => Wall,
    ///         (3, 0) => Wall,
    ///         (3, 1) => Wall,
    ///         (3, 2) => Wall,
    ///         (3, 3) => Wall,
    ///         (2, 2) => Person(Player(0, South, gs -> {
    ///             let GameState(playerMap, _) = gs;
    ///             match Map.get(0, playerMap) {
    ///                 case Some(p) => match p {
    ///                     case (1, 1) => ??? //Move(1, 2)
    ///                 }
    ///                 case None => Shoot()
    ///             }
    ///         })),
    ///         (1, 1) => Person(Player(1, West, x -> ???))
    ///     }})

    /// pub def test01(): Unit & Impure =
    ///     Flixball/Display.displayBoard(testBoard01())
}