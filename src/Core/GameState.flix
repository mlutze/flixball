namespace Flixball/Core/GameState {
    use Flixball/Core.AiState
    use Flixball/Core.Coordinates
    use Flixball/Core.MoveLogic
    use Flixball/Core.PlayerId
    use Flixball/Core.Position
    use Flixball/Core.Position.Position
    use Flixball/Core.rotateDir
    use Flixball/Core.Rotation
    use Flixball/Core.Strategy
    use Flixball/Core.Tile.Person
    use Flixball/Core/Board.adjust
    use Flixball/Core/Board.Board
    use Flixball/Core/Board.get_
    use Flixball/Core/Board.set_

    pub opaque enum GameState(GameStateRecord)

    type alias GameStateRecord = {
        aiStates   = Map[PlayerId, AiState],
        moveLogics = Map[PlayerId, MoveLogic],
        players    = Map[PlayerId, Position],
        board      = Board
    }

    def rec(gs: GameState): GameStateRecord = {
        let GameState(r) = gs;
        r
    }

    pub def board(gs: GameState): Board = rec(gs).board

    pub def init(seed: Int64, strategies: Map[PlayerId, Strategy], b: Board): GameState = {
        let playerMap = Flixball/Core/Board.players(b) |> List.toMap;
        let (states, moveLogics) = strategies |> Map.mapWithKey((id, strat) -> {
            let (stateGen, ml) = strat(id);
            (stateGen(seed), ml)
        }) |> Utils/Map.unzip;
        GameState({aiStates = states, moveLogics = moveLogics, players = playerMap, board = b})
    }

    /// Removes a player from the game.
    /// Does nothing if the player does not exist in the game.
    pub def removePlayer(id: PlayerId, state0: GameState): GameState = {
        match (rec(state0).players |> Map.get(id)) {
            // Case 1: No such player. Do nothing.
            case None => state0

            // Case 2: Found the player. Remove from the map, the board, and the states.
            case Some(Position(coords, _)) => {
                let playerPositions = rec(state0).players |> Map.remove(id);
                let states = rec(state0).aiStates |> Map.remove(id);
                let board = rec(state0).board |> set_(coords, None);
                GameState({
                    aiStates = states,
                    players  = playerPositions,
                    board    = board |
                    rec(state0)
                })
            }
        }
    }

    /// Rotates a player with the given rotation.
    /// Does nothing if the player does not exist in the game.
    pub def rotatePlayer(id: PlayerId, rot: Rotation, state0: GameState): GameState = {
        match (rec(state0).players |> Map.get(id)) {
            // Case 1: No such player. Do nothing.
            case None => state0

            // Case 2: Found the player. Change their direction in the map and the board.
            case Some(Position(coords, dir0)) => {
                let dir = dir0 |> rotateDir(rot);
                let playerPositions = rec(state0).players |> Map.insert(id, Position(coords, dir));
                let board = (coords, rec(state0).board) ||> adjust(tileOpt -> match tileOpt {
                        case Some(Person(_, _)) => Some(Person(id, dir))
                        case other => other
                    }
                );
                GameState({
                    players  = playerPositions,
                    board    = board |
                    rec(state0)
                })
            }
        }
    }

    /// Moves a player to a new position.
    /// Does not change the direction of the player.
    pub def movePlayer(id: PlayerId, coords: Coordinates, state0: GameState): GameState = {
        match (rec(state0).players |> Map.get(id)) {
            // Case 1: No such player. Do nothing.
            case None => state0

            // Case 2: Found the player. Change their position in the map and the board.
            case Some(Position(coords0, dir)) => {
                let playerPositions = rec(state0).players |> Map.insert(id, Position(coords, dir));
                match get_(coords0, rec(state0).board) {
                    case None => bug!("invalid game state")
                    case Some(person) => {
                        let board = rec(state0).board |> set_(coords0, None) |> set_(coords, Some(person));
                        GameState({
                            players  = playerPositions,
                            board    = board |
                            rec(state0)
                        })
                    }
                }
            }
        }
    }

    ///
    /// Gets the position of the given player.
    ///
    def getPosition(id: PlayerId, state: GameState): Option[Position] =
        rec(state).players |> Map.get(id)
}
