namespace Flixball/Engine {
    use Flixball/Core.Board.Board;
    use Flixball/Core.Board;
    use Flixball/Core.Coordinates.Coordinates;
    use Flixball/Core.Coordinates;
    use Flixball/Core.Direction.East;
    use Flixball/Core.Direction.North;
    use Flixball/Core.Direction.South;
    use Flixball/Core.Direction.West;
    use Flixball/Core.Direction;
    use Flixball/Core.GameState.GameState;
    use Flixball/Core.GameState;
    use Flixball/Core.Move.Shoot;
    use Flixball/Core.Move.Turn;
    use Flixball/Core.Move.Walk;
    use Flixball/Core.Move;
    use Flixball/Core.MoveLogic.{MoveLogic};
    use Flixball/Core.MoveLogic;
    use Flixball/Core.PlayerId;
    use Flixball/Core.Position.Position;
    use Flixball/Core.Position;
    use Flixball/Core.Rotation.Clockwise;
    use Flixball/Core.Rotation.Counterclockwise;
    use Flixball/Core.Rotation;
    use Flixball/Core.Tile.Person;
    use Flixball/Core.Tile.Wall;
    use Flixball/Core.Tile;
    use Flixball/Core/Board.{get_, players};
    use Flixball/GridGraph.raytrace;
    use Flixball/GridGraph.step;

    ///
    /// resolves one step of the GameState.
    ///
    pub def runStep(gs: GameState): GameState = region r {
        let GameState(states0, moveLogics, playerPositions, board) = gs;
        let newStates = new MutMap(r);
        let moves = players(board) |>
            List.map(match (id, _) ->
                use Option.flatMap;
                let* MoveLogic(move) = Map.get(id, moveLogics);
                let* state0 = Map.get(id, states0);
                let (moveToDo, state) = move(gs, id, state0);
                MutMap.put!(id, state, newStates);
                Some((id, moveToDo))
            ) |>
            List.map(opt -> match opt {
                case Some(v) => v
                case None => ?unreachable
            }) |> List.toMap;
        // Everything in gamestate except the values in player states is handled in resolve.
        resolve(moves, GameState(MutMap.toMap(newStates), moveLogics, playerPositions, board))
    }
    
    ///
    /// Resolves the given moves on the gamestate in the order:
    ///     shoot
    ///     rotate
    ///     move
    ///
    def resolve(moves0: Map[PlayerId, Move], state0: GameState): GameState = {
        let shooters = moves0 
            |> Map.filter(Eq.eq(Shoot)) 
            |> Map.keysOf;
        let dead = resolveShots(state0, shooters);
        let state1 = (state0, dead) ||> Set.foldLeft((acc, id) -> Flixball/Core/GameState.removePlayer(id, acc));
        let moves1 = (moves0, dead) ||> Set.foldLeft((acc, p) -> Map.remove(p, acc));

        let rotators = moves1
            |> Map.filterMap(m -> match m {
                case Turn(r) => Some(r)
                case Shoot => None
                case Walk => None
            });
        let state2 = (state1, rotators) ||> Map.foldLeftWithKey((acc, id) -> rot -> Flixball/Core/GameState.rotatePlayer(id, rot, acc));
        let GameState(_, _, _, board2) = state2;

        let movers = moves1
            |> Map.filter(Eq.eq(Walk))
            |> Map.keysOf;
        let maybeNewPos = movers 
            |> Set.toList 
            |> List.filterMap(mover -> getPosition(mover, state2) |> Option.map(match Position(coords, dir) -> (mover, step(coords, dir))))
            |> List.toMap;
        let newPos = maybeNewPos 
            |> Map.filter(coords -> (board2 |> get_(coords)) |> Option.isEmpty)
            |> withUniqueValues;
        // a new position cannot be a wall, a previous player's position, or a new player's position
        let state3 = (state2, newPos) ||> Map.foldLeftWithKey((acc, id) -> coords -> Flixball/Core/GameState.movePlayer(id, coords, acc));
        
        state3
    }

    ///
    /// Returns the set where values that appear more than once are removed.
    ///
    def withUniqueValues(m: Map[k, v]): Map[k, v] with Order[k], Eq[v] = {
        // TODO terribly inefficient but I did not want to enforce order on the values
        m |> Map.filter(v1 -> Map.count((_, v2) -> v1 == v2, m) == 1)
    }

    ///
    /// Returns the set of dead players.
    ///
    def resolveShots(state: GameState, shooters: Set[PlayerId]): Set[PlayerId] = {
        shooters |> Set.flatMap(resolveShot(state) >> Option.toSet) 
    }

    ///
    /// Returns the player killed by the shot.
    ///
    def resolveShot(state: GameState, shooter: PlayerId): Option[PlayerId] = {
        let GameState(_, _, _, board) = state;
        use Option.flatMap;
        let* Position(coords0, dir) = getPosition(shooter, state);
        match raytrace(dir, coords0, board) {
            case Some(Person(id, _)) => Some(id)
            case Some(Wall) => None
            case None => None
        }
    }

    ///
    /// Gets the position of the given player.
    ///
    def getPosition(id: PlayerId, state: GameState): Option[Position] = {
        let GameState(_, _, playerPositions, _) = state;
        use Option.flatMap;
        playerPositions |> Map.get(id)
    }
}
