namespace Flixball {
    namespace Core {

        pub type alias PlayerId = Int32

        pub type alias Coordinates = (Int32, Int32)

        pub type alias AiState = (Int32, Map[String, String])


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
        pub enum Board({rows = Int32, cols = Int32, tiles = Map[Coordinates, Tile]})

        pub enum Direction with Eq, ToString {
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

        pub enum Tile with Eq, ToString {
            case Wall
            case Person(PlayerId, Direction)
        }

        pub enum MoveLogic(
            (GameState, PlayerId, AiState) ->
            (Move, AiState)
        )

        pub enum Position(Coordinates, Direction)

        pub enum GameState(
            Map[PlayerId, AiState],
            Map[PlayerId, MoveLogic],
            Map[PlayerId, Position],
            Board
        )

        pub def initialPlayerState(): AiState = (0, Map.empty())

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
            use Flixball/Core.AiState;
            use Flixball/Core.Board;
            use Flixball/Core.Coordinates.Coordinates;
            use Flixball/Core.Coordinates;
            use Flixball/Core.GameState.GameState;
            use Flixball/Core.GameState;
            use Flixball/Core.MoveLogic;
            use Flixball/Core.PlayerId;
            use Flixball/Core.Position.{Position};
            use Flixball/Core.Position;
            use Flixball/Core.Rotation;
            use Flixball/Core.Tile.Person;
            use Flixball/Core.Tile;
            use Flixball/Core.rotateDir;
            use Flixball/Core/Board.adjust;
            use Flixball/Core/Board.get_;
            use Flixball/Core/Board.set_;

            /// Removes a player from the game.
            /// Does nothing if the player does not exist in the game.
            pub def removePlayer(id: PlayerId, state0: GameState): GameState = {
                let GameState(states0, moveLogics, playerPositions0, board0) = state0;
                match (playerPositions0 |> Map.get(id)) {
                    // Case 1: No such player. Do nothing.
                    case None => state0

                    // Case 2: Found the player. Remove from the map, the board, and the states.
                    case Some(Position(coords, _)) =>
                        let playerPositions = playerPositions0 |> Map.remove(id);
                        let states = states0 |> Map.remove(id);
                        let board = board0 |> set_(coords, None);
                        GameState(states, moveLogics, playerPositions, board)
                }
            }

            /// Rotates a player with the given rotation.
            /// Does nothing if the player does not exist in the game.
            pub def rotatePlayer(id: PlayerId, rot: Rotation, state0: GameState): GameState = {
                let GameState(states, moveLogics, playerPositions0, board0) = state0;
                match (playerPositions0 |> Map.get(id)) {
                    // Case 1: No such player. Do nothing.
                    case None => state0

                    // Case 2: Found the player. Change their direction in the map and the board.
                    case Some(Position(coords, dir0)) =>
                        let dir = dir0 |> rotateDir(rot);
                        let playerPositions = playerPositions0 |> Map.insert(id, Position(coords, dir));
                        let board = (coords, board0) ||> adjust(tileOpt -> match tileOpt {
                                case Some(Person(_, _)) => Some(Person(id, dir))
                                case other => other
                            }
                        );
                        GameState(states, moveLogics, playerPositions, board)
                }
            }

            /// Moves a player to a new position.
            /// Does not change the direction of the player.
            pub def movePlayer(id: PlayerId, coords: Coordinates, state0: GameState): GameState = {
                let GameState(states, moveLogics, playerPositions0, board0) = state0;
                match (playerPositions0 |> Map.get(id)) {
                    // Case 1: No such player. Do nothing.
                    case None => state0

                    // Case 2: Found the player. Change their position in the map and the board.
                    case Some(Position(coords0, dir)) =>
                        let playerPositions = playerPositions0 |> Map.insert(id, Position(coords, dir));
                        match get_(coords0, board0) {
                            case None => bug!("invalid game state")
                            case Some(person) =>
                                let board = board0 |> set_(coords0, None) |> set_(coords, Some(person));
                                GameState(states, moveLogics, playerPositions, board)
                        }
                }
            }

            pub def initialStates(players: List[PlayerId]): Map[PlayerId, AiState] =
                players |> List.map(p -> {
                    (p, Flixball/Core.initialPlayerState())
                }) |> List.toMap
            
            pub def mkGameState(b: Board, moveLogics: Map[PlayerId, MoveLogic]): GameState =
                let states = b |>
                    Flixball/Core/Board.players |>
                    List.map(match (id, _) -> id) |>
                    initialStates;
                let playerMap = Flixball/Core/Board.players(b) |> List.toMap;
                GameState(states, moveLogics, playerMap, b)
        }

        namespace Board {
            use Flixball/Core.Board;
            use Flixball/Core.Board.Board;
            use Flixball/Core.Coordinates;
            use Flixball/Core.Coordinates.Coordinates;
            use Flixball/Core.Direction;
            use Flixball/Core.PlayerId;
            use Flixball/Core.Position;
            use Flixball/Core.Position.{Position};
            use Flixball/Core.Tile;
            use Flixball/Core.Tile.{Person, Wall};

            pub def set_(coords: Coordinates, tile: Option[Tile], board0: Board): Board = {
                let Board(rec0) = board0;
                let tiles = match tile {
                    case None => rec0.tiles |> Map.remove(coords)
                    case Some(t) => rec0.tiles |> Map.insert(coords, t)
                };
                Board({tiles = tiles | rec0})
            }

            pub def get_(coords: Coordinates, board: Board): Option[Tile] = {
                let Board(rec) = board;
                rec.tiles |> Map.get(coords)
            }

            pub def adjust(f: Option[Tile] -> Option[Tile], coords: Coordinates, board: Board): Board = {
                let tile = get_(coords, board);
                set_(coords, f(tile), board)
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
                    MutMap.put!((0, i), Wall, translatedMap);
                    MutMap.put!((rows-1, i), Wall, translatedMap)
                };
                foreach(i <- Iterator.range(r, 0, rows)) {
                    MutMap.put!((i, 0), Wall, translatedMap);
                    MutMap.put!((i, cols-1), Wall, translatedMap)
                };
                Board({rows = rows, cols = cols, tiles = MutMap.toMap(translatedMap)})
            }

            ///
            /// Creates a pseudo-random board from the seed with an average wall
            /// density of `density` in the range [0.0, 1.0]. The map will have
            /// an encompasing border.  
            ///
            pub def randomBoard(seed: Int64, rows: {rows=Int32}, cols: Int32, density: Float64): Board = region r {
                let grid = Flixball/Noise.boolNoise2d(r, {width=rows.rows, height=cols}, seed, density);
                Board({rows=rows.rows, cols=cols, tiles=gridToMap(grid)}) |> addBorder
            }

            ///
            /// Cellular Automata Refinement.
            /// sensible defaults, prob=0.40, iterations=3
            ///
            pub def automataBoard(seed: Int64, rows: {rows=Int32}, cols: Int32, density: Float64, iterations: Int32): Board = region r {
                let grid = Flixball/Noise.cellularGeneration(r, {width=rows.rows, height=cols}, seed, density, iterations);
                Board({rows=rows.rows, cols=cols, tiles=gridToMap(grid)}) |> addBorder
            }

            def gridToMap(g: Array[Array[Bool, r], r]): Map[(Int32, Int32), Tile] \ Read(r) =
                let r = Scoped.regionOf(g);
                let mutTiles = new MutMap(r);
                foreach(
                    (arr, x) <- Array.enumerator(g);
                    (b, y) <- Array.enumerator(arr))
                {
                    if (b) mutTiles |> MutMap.put!((x, y), Wall)
                    else ()
                };
                MutMap.toMap(mutTiles)

            pub def players(b: Board): List[(PlayerId, Position)] =
                let Board(br) = b;
                br.tiles |> Map.toList |> List.filterMap(match (coords, t) -> match t {
                    case Person(id, dir) => Some(id, Position(coords, dir))
                    case _ => None
                })

            pub def player(b: Board, id: PlayerId): Option[Position] =
                players(b) |>
                    List.find(match (foundId, _) -> foundId == id) |>
                    Option.map(match (_, pos) -> pos)

        }
    }
}
