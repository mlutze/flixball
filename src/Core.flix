namespace Flixball {
    namespace Core {

        pub type alias PlayerId = Int32


        ///
        /// Board uses matrix-like index ordering. Map entries should not be out
        /// of bounds and the outer border of the board should be wall to avoid
        /// out-of-bounds checking.
        ///
        /// Example: `{rows=5, cols=4, tiles = Map#{(0, 0) => Wall, (3,1) =>
        /// Wall}}`
        /// # := wall, @ := empty
        ///
        /// #@@@
        /// @@@@
        /// @@@@
        /// #@@@
        /// @@@@
        ///
        /// North, East, South, West correspond to the drawing above, likewise
        /// with Clockwise and Counterclockwise.
        /// 
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

        pub enum MoveLogic(
            (GameState, Int32, Map[String, String]) ->
            (Move, Int32, Map[String, String])
        )

        // id
        pub enum Player(PlayerId, Direction, MoveLogic)

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

        pub enum GameState(
            Map[PlayerId, (Int32, Map[String, String])],
            Map[PlayerId, Position],
            Board
        )

        pub def initialPlayerState(): (Int32, Map[String, String]) = (0, Map.empty())

        pub def rotateDir(rot: Rotation, dir: Direction): Direction = match (rot, dir) {
            case (Clockwise, North) => East
            case (Clockwise, East) => South
            case (Clockwise, South) => West
            case (Clockwise, West) => North

            case (Counterclockwise, North) => West
            case (Counterclockwise, West) => South
            case (Counterclockwise, South) => East
            case (Counterclockwise, East) => North
        }

        namespace GameState {
            use Flixball/Core.Board;
            use Flixball/Core.GameState;
            use Flixball/Core.GameState.GameState;
            use Flixball/Core.Player.Player;
            use Flixball/Core.PlayerId;
            use Flixball/Core.Position;
            use Flixball/Core.Position.{Position};
            use Flixball/Core.rotateDir;
            use Flixball/Core.Rotation;
            use Flixball/Core.Tile;
            use Flixball/Core.Tile.Person;
            use Flixball/Core/Board.adjust;
            use Flixball/Core/Board.set_;
            use Flixball/Core/Board.get_;
            use Utils.{|||>};

            /// Removes a player from the game.
            /// Does nothing if the player does not exist in the game.
            pub def removePlayer(id: PlayerId, state0: GameState): GameState = {
                let GameState(states0, map0, board0) = state0;
                match (map0 |> Map.get(id)) {
                    // Case 1: No such player. Do nothing.
                    case None => state0

                    // Case 2: Found the player. Remove from the map, the board, and the states.
                    case Some(Position(row, col, _)) =>
                        let map = map0 |> Map.remove(id);
                        let states = states0 |> Map.remove(id);
                        let board = board0 |> set_(row, col, None);
                        GameState(states, map, board)
                }
            }

            /// Rotates a player with the given rotation.
            /// Does nothing if the player does not exist in the game.
            pub def rotatePlayer(id: PlayerId, rot: Rotation, state0: GameState): GameState = {
                let GameState(states, map0, board0) = state0;
                match (map0 |> Map.get(id)) {
                    // Case 1: No such player. Do nothing.
                    case None => state0

                    // Case 2: Found the player. Change their direction in the map and the board.
                    case Some(Position(row, col, dir0)) =>
                        let dir = dir0 |> rotateDir(rot);
                        let map = map0 |> Map.insert(id, Position(row, col, dir));
                        let board = (row, col, board0) |||> adjust(tileOpt -> match tileOpt {
                                case Some(Person(Player(_, _, logic))) => Some(Person(Player(id, dir, logic)))
                                case other => other
                            }
                        );
                        GameState(states, map, board)
                }
            }

            /// Moves a player to a new position.
            /// Does not change the direction of the player.
            pub def movePlayer(id: PlayerId, row: Int32, col: Int32, state0: GameState): GameState = {
                let GameState(states, map0, board0) = state0;
                match (map0 |> Map.get(id)) {
                    // Case 1: No such player. Do nothing.
                    case None => state0

                    // Case 2: Found the player. Change their position in the map and the board.
                    case Some(Position(row0, col0, dir)) =>
                        let map = map0 |> Map.insert(id, Position(row, col, dir));
                        match get_(row0, col0, board0) {
                            case None => bug!("invalid game state")
                            case Some(person) =>
                                let board = board0 |> set_(row0, col0, None) |> set_(row, col, Some(person));
                                GameState(states, map, board)
                        }
                }
            }

            pub def initialStates(players: List[PlayerId]): Map[PlayerId, (Int32, Map[String, String])] =
                players |> List.map(p -> {
                    (p, Flixball/Core.initialPlayerState())
                }) |> List.toMap
            
            pub def mkGameState(b: Board): GameState =
                let states = b |>
                    Flixball/Core/Board.players |>
                    List.map(match Player(id, _, _) -> id) |>
                    Flixball/Core/GameState.initialStates;
                let players = Flixball/Core/Board.playerMap(b);
                GameState(states, players, b)
        }

        namespace Board {
            use Flixball/Core.Board;
            use Flixball/Core.Board.Board;
            use Flixball/Core.Player;
            use Flixball/Core.Player.{Player};
            use Flixball/Core.PlayerId;
            use Flixball/Core.Position;
            use Flixball/Core.Position.{Position};
            use Flixball/Core.Tile;
            use Flixball/Core.Tile.{Person, Wall};

            pub def set_(row: Int32, col: Int32, tile: Option[Tile], board0: Board): Board = {
                let Board(rec0) = board0;
                let tiles = match tile {
                    case None => rec0.tiles |> Map.remove((row, col))
                    case Some(t) => rec0.tiles |> Map.insert((row, col), t)
                };
                Board({tiles = tiles | rec0})
            }

            pub def get_(row: Int32, col: Int32, board: Board): Option[Tile] = {
                let Board(rec) = board;
                rec.tiles |> Map.get((row, col))
            }

            pub def adjust(f: Option[Tile] -> Option[Tile], row: Int32, col: Int32, board: Board): Board = {
                let tile = get_(row, col, board);
                set_(row, col, f(tile), board)
            }

            ///
            /// Adds a border around the board by increasing the size in each
            /// dimension by two and increasing each tile position by one in
            /// each dimension.
            /// 
            pub def addBorder(b: Board): Board = region r {
                let Board(br) = b;
                let rows = br.rows+2;
                let cols = br.cols+2;
                let translatedMap = new MutMap(r);
                // Add translated existing tiles
                foreach(((x, y), tile) <- Map.iterator(r, br.tiles)) {
                    MutMap.put!((x+1, y+1), tile, translatedMap)
                };
                // Add border walls
                foreach(i <- Iterator.range(r, 0, cols)) {
                    MutMap.put!((i, 0), Wall, translatedMap);
                    MutMap.put!((i, cols-1), Wall, translatedMap);
                    MutMap.put!((0, i), Wall, translatedMap);
                    MutMap.put!((rows-1, i), Wall, translatedMap)
                };
                Board({rows = rows, cols = cols, tiles = MutMap.toMap(translatedMap)})
            }

            pub def players(b: Board): List[Player] =
                let Board(br) = b;
                br.tiles |> Map.valuesOf |> List.filterMap(t -> match t {
                    case Person(player) =>
                        Some(player)
                    case _ => None
                })

            pub def playerMap(b: Board): Map[PlayerId, Position] =
                let Board(br) = b;
                br.tiles |> Map.toList |> List.filterMap(match ((x, y), t) -> match t {
                    case Person(Player(id, direction, _)) =>
                        Some((id, Position(x, y, direction)))
                    case _ => None
                }) |> List.toMap
        }
    }
}
