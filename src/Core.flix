namespace Flixball/Core {
    pub type alias PlayerId = Int32

    pub enum Board({rows :: Int32, cols :: Int32, tiles :: Map[(Int32, Int32), Tile]})

    pub enum Direction with Eq {
        case North
        case East
        case South
        case West
    }

    pub enum Rotation with Eq {
        case Clockwise
        case Counterclockwise
    }

    pub enum Move with Eq {
        case Turn(Rotation)
        case Shoot
        case Walk
    }

    pub enum Tile {
        case Wall
        case Person(Player)
    }

    // id
    pub enum Player(PlayerId, Direction, GameState -> Move)


    instance Eq[Player] {

        pub def eq(x: Player, y: Player): Bool =
            let Player.Player((p1, _, _)) = x;
            let Player.Player((p2, _, _)) = y;
            p1 == p2

    }


    instance Order[Player] {

        pub def compare(x: Player, y: Player): Comparison =
            let Player.Player((p1, _, _)) = x;
            let Player.Player((p2, _, _)) = y;
            p1 <=> p2

    }

    pub enum Position(Int32, Int32, Direction)

    pub enum GameState(Map[PlayerId, Position], Board)

    namespace GameState {
        use Flixball/Core.GameState.GameState;
        use Flixball/Core.Position;
        use Flixball/Core.Position.Position;
        use Flixball/Core.GameState;
        use Flixball/Core.PlayerId;
        use Flixball/Core/Board.set_;

        /// Removes a player from the game.
        /// Does nothing if the player does not exist in the game.
        pub def removePlayer(id: PlayerId, state0: GameState): GameState = {
            let GameState(map0, board0) = state0;
            match (map0 |> Map.get(id)) {
                // Case 1: No such player. Do nothing.
                case None => state0

                // Case 2: Found the player. Remove from both the map and the board.
                case Some(Position(row, col, _)) =>
                    let map = map0 |> Map.remove(id);
                    let board = board0 |> set_(row, col, None);
                    GameState(map, board)
            }
        }

    }

    namespace Board {
        use Flixball/Core.Board;
        use Flixball/Core.Board.Board;
        use Flixball/Core.Tile;

        pub def set_(row: Int32, col: Int32, tile: Option[Tile], board0: Board): Board = {
            let Board(rec0) = board0;
            let tiles = match tile {
                case None => rec0.tiles |> Map.remove((row, col))
                case Some(t) => rec0.tiles |> Map.insert((row, col), t)
            };
            Board({tiles = tiles | rec0})
        }
    }
}