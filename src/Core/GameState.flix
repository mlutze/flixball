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

    pub enum GameState(
        Map[PlayerId, AiState],
        Map[PlayerId, MoveLogic],
        Map[PlayerId, Position],
        Board
    )

    /// Removes a player from the game.
    /// Does nothing if the player does not exist in the game.
    pub def removePlayer(id: PlayerId, state0: GameState): GameState = {
        let GameState(states0, moveLogics, playerPositions0, board0) = state0;
        match (playerPositions0 |> Map.get(id)) {
            // Case 1: No such player. Do nothing.
            case None => state0

            // Case 2: Found the player. Remove from the map, the board, and the states.
            case Some(Position(coords, _)) => {
                let playerPositions = playerPositions0 |> Map.remove(id);
                let states = states0 |> Map.remove(id);
                let board = board0 |> set_(coords, None);
                GameState(states, moveLogics, playerPositions, board)
            }
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
            case Some(Position(coords, dir0)) => {
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
    }

    /// Moves a player to a new position.
    /// Does not change the direction of the player.
    pub def movePlayer(id: PlayerId, coords: Coordinates, state0: GameState): GameState = {
        let GameState(states, moveLogics, playerPositions0, board0) = state0;
        match (playerPositions0 |> Map.get(id)) {
            // Case 1: No such player. Do nothing.
            case None => state0

            // Case 2: Found the player. Change their position in the map and the board.
            case Some(Position(coords0, dir)) => {
                let playerPositions = playerPositions0 |> Map.insert(id, Position(coords, dir));
                match get_(coords0, board0) {
                    case None => bug!("invalid game state")
                    case Some(person) => {
                        let board = board0 |> set_(coords0, None) |> set_(coords, Some(person));
                        GameState(states, moveLogics, playerPositions, board)
                    }
                }
            }
        }
    }
    
    pub def mkGameState(seed: Int64, strategies: Map[PlayerId, Strategy], b: Board): GameState = {
        let playerMap = Flixball/Core/Board.players(b) |> List.toMap;
        let (states, moveLogics) = strategies |> Map.mapWithKey((id, strat) -> {
            let (stateGen, ml) = strat(id);
            (stateGen(seed), ml)
        }) |> Utils/Map.unzip;
        GameState(states, moveLogics, playerMap, b)
    }
}
