mod Flixball/Engine {
    use Flixball/Core.Move
    use Flixball/Core.Move.Shoot
    use Flixball/Core.Move.Turn
    use Flixball/Core.Move.Walk
    use Flixball/Core.MoveLogic
    use Flixball/Core.PlayerId
    use Flixball/Core.Position
    use Flixball/Core.Position.Position
    use Flixball/Core.step
    use Flixball/Core.Tile.Person
    use Flixball/Core.Tile.Wall
    use Flixball/Core/Board.get_
    use Flixball/Core/Board.players
    use Flixball/Core/GameState.{board => gsBoard}
    use Flixball/Core/GameState.computeMoveLogics
    use Flixball/Core/GameState.GameState
    use Flixball/Core/GameState.playerPosition
    use Flixball/GridGraph.raytraceEx

    ///
    /// Returns an iterator over the game states in this game.
    ///
    pub def runGame(r: Region[r], gs0: GameState): Iterator[GameState, r, r] \ r = {
        // TODO use pure unfold when that is added to stdlib
        let gs = ref gs0 @ r;
        def next() = {
            let res = deref gs;
            gs := runStep(res);
            Iterator.Step.Ans(res)
        };
        Iterator.Iterator(r, next)
    }
    
    ///
    /// Resolves one step of the GameState.
    ///
    pub def runStep(gs: GameState): GameState = {
        //
        // Resolves the given moves on the gamestate in the order:
        //     shoot
        //     rotate
        //     move
        //
        let (moves0, state0) = computeMoveLogics(gs);
        let shooters = moves0 
            |> Map.filter(Eq.eq(Shoot)) 
            |> Map.keysOf;
        let dead = resolveShots(state0, shooters);
        let moves1 = (moves0, dead) ||>
            Set.foldLeft((acc, p) -> Map.remove(p, acc));
        let state1 = (state0, dead) ||>
            Set.foldLeft((acc, id) ->
                Flixball/Core/GameState.removePlayer(id, acc)
            );

        let rotators = moves1
            |> Map.filterMap(m -> match m {
                case Turn(r) => Some(r)
                case Shoot => None
                case Walk => None
            });
        let state2 = (state1, rotators) ||>
            Map.foldLeftWithKey((acc, id) -> rot ->
                Flixball/Core/GameState.rotatePlayer(id, rot, acc)
            );
        let board2 = gsBoard(state2);

        let movers = moves1
            |> Map.filter(Eq.eq(Walk))
            |> Map.keysOf;
        let maybeNewPos = movers 
            |> Set.toList 
            |> List.filterMap(mover -> (
                playerPosition(mover, state2) |>
                    Option.map(match Position(coords, dir) -> (mover, step(coords, dir)))
                ))
            |> List.toMap;
        let newPos = maybeNewPos 
            |> Map.filter(coords -> (board2 |> get_(coords)) |> Option.isEmpty)
            |> withUniqueValues;
        // a new position cannot be a wall, a previous player's position, or a new player's position
        let state3 = (state2, newPos) ||>
            Map.foldLeftWithKey((acc, id) -> coords -> 
                Flixball/Core/GameState.movePlayer(id, coords, acc)
            );
        
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
        for (
            Position(coords0, dir) <- playerPosition(shooter, state);
            res <- match raytraceEx(dir, coords0, gsBoard(state)) {
                case Some(Person(id, _)) => Some(id)
                case Some(Wall) => None
                case None => None
            }
        ) yield {
            res
        }
    }

}
