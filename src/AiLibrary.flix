mod Flixball.AiLibrary {
    use Flixball.State.{toState, fromState};
    use Flixball.Core.AiInfo.AiInfo;
    use Flixball.Core.AiInfo.getColumns;
    use Flixball.Core.AiInfo.playerPosition;
    use Flixball.Core.AiInfo.playerPositions;
    use Flixball.Core.AiInfo.getRows;
    use Flixball.Core.AiInfo.getTiles;
    use Flixball.Core.Board.Board.Board;
    use Flixball.Core.Direction.{East, North, South, West};
    use Flixball.Core.Move.{Shoot, Turn, Walk};
    use Flixball.Core.Position.Position;
    use Flixball.Core.Rotation.Clockwise;
    use Flixball.Core.Rotation.Counterclockwise;
    use Flixball.Core.Tile.{Person, Wall};
    use Flixball.Core.{Coordinates, Direction, Move,
        MoveLogic, PlayerId, Position, Rotation, Strategy, Tile};
    use Flixball.GridGraph.{findShortestPath, raytraceEx};
    use Flixball.State

    def statelessMoveLogic(logic: AiInfo -> Move): MoveLogic =
        (info, state) -> (logic(info), state)

    def statelessStrategy(s: PlayerId -> AiInfo -> Move): Strategy =
        mkStrategy(id -> (
            _ -> toState(()), statelessMoveLogic(s(id))
        ))

    def constantStrategy(m: Move): Strategy =
        statelessStrategy((_, _) -> m)

    /// converts a strategy with arbitrary state to a state with AiState.
    /// On state parsing error state is reset with seed `0i64`.
    def mkStrategy(
        s: PlayerId -> (Int64 -> state, (AiInfo, state) -> (Move, state))
    ): Strategy with State[state] =
        id -> {
            let (stateGen0, ml0) = s(id);
            let stateGen = seed -> stateGen0(seed) |> toState;
            let ml = (info, state) -> {
                let s0 = fromState(state) |>
                    Option.getWithDefault(stateGen0(0i64));
                let (move, s1) = ml0(info, s0);
                (move, toState(s1))
            };
            (stateGen, ml)
        }

    pub def shoot(): Strategy = constantStrategy(Shoot)

    pub def walk(): Strategy = constantStrategy(Walk)

    pub def rotate(r: Rotation): Strategy = constantStrategy(Turn(r))

    pub def wander(): Strategy = mkStrategy(_id -> {
        use RegionedRandom.{newWithSeed, nextInt64};
        let stateGen = seed -> seed;
        let moveLogic = (_, state) -> region r {
            let ran = newWithSeed(r, state);
            let choices = Nel.Nel(
                Walk,
                Walk ::
                Turn(Clockwise) ::
                Turn(Counterclockwise) :: Nil
            );
            let move = RegionedRandom.chooseNel(ran, choices);
            (move, nextInt64(ran))
        };
        (stateGen, moveLogic)
    })

    pub def spinAndShoot(r: Rotation): Strategy = mkStrategy(_id -> {
        let stateGen = seed -> Int64.modulo(seed, 2i64) == 0i64;
        let moveLogic = (_, shoot) -> {
            if (shoot) (Shoot, false)
            else (Turn(r), true)
        };
        (stateGen, moveLogic)
    })

    pub def goAndSpin(coords: Coordinates): Strategy =
        statelessStrategy((id, info) -> {
            let currentPosition = playerPosition(id, info) |>
                Utils.Option.unsafeGet;
            let goal = match Position(c, _) -> c == coords;
            goTo(
                currentPosition,
                goal,
                playersUnpassable,
                getTiles(info)
            ) |> Option.getWithDefault(Turn(Clockwise))
        })

    ///
    /// Go to the next player on the list and shoot them.
    /// Doesn't necessarily take the shortest path to find a shooting angle.
    ///
    pub def naiveSearchAndDestroy(): Strategy =
        statelessStrategy((id, info) -> {
            let playerMap = playerPositions(info);
            let tiles = getTiles(info);
            let board = Board({
                rows = getRows(info),
                cols = getColumns(info),
                tiles = tiles
            });
            // Pick a target from among the players (lowest ID except me)
            let target = playerMap
                |> Map.filterWithKey((id2, _) -> id != id2)
                |> Map.toList
                |> List.head;

            // Get my own position
            let Position(coords, dir) = playerPosition(id, info) |> Utils.Option.unsafeGet;

            // Pick a move
            match target {
                // Case 1: No target. Just spin for fun.
                case None => Turn(Clockwise)

                // Case 2: Some target. Hunt them down.
                case Some((targetId, Position(targetCoords, _))) =>
                    let goal = match Position(c, _) -> c == targetCoords;
                    match raytraceEx(dir, coords, board) {
                        // Case 2.1: Looking at my target. Shoot.
                        case Some(Person(viewId, _)) if viewId == targetId =>
                            Shoot
                        // Case 2.2: Not looking at my target. Keep moving.
                        case _ =>
                            goTo(
                                Position(coords, dir),
                                goal,
                                playersPassable,
                                tiles
                            ) |> Option.getWithDefault(Turn(Counterclockwise))
                            // TODO pick another target if inaccessible
                    }
            }
        })

    pub def smartSearchAndDestroy(): Strategy =
        statelessStrategy((id, info) -> {
            let tiles = getTiles(info);
            let board = Board({
                rows = getRows(info),
                cols = getColumns(info),
                tiles = tiles
            });
            // Get my own position
            let Position(coords, dir) = playerPosition(id, info) |> Utils.Option.unsafeGet;

            match raytraceEx(dir, coords, board) {
                case Some(Person(_, _)) =>
                    // Shoot first, ask questions later!
                    Shoot
                case _ => {
                    // optimization possibility: precompute the set of spaces
                    // where this predicate is true in n^2 time, instead of
                    // on-demand evaluation (n^3)

                    // find a position where somebody else can be shot
                    let goal = match Position(c, d) -> {
                        match raytraceEx(d, c, board) {
                            case Some(Person(seenId, _)) => seenId != id
                            case _ => false
                        }
                    };
                    // go to such a position, otherwise do a victory spin
                    goTo(
                        Position(coords, dir),
                        goal,
                        playersUnpassable,
                        tiles
                    ) |> Option.getWithDefault(Turn(Counterclockwise))
                }
            }
        })

    ///
    /// Like `smartSearchAndDestroy`, but prefers positions from which it can
    /// shoot an opponent AND no opponent currently has line of sight to that
    /// position. Falls back to any shooting position if no safe position is
    /// reachable.
    ///
    pub def tacticalSearchAndDestroy(): Strategy =
        statelessStrategy((id, info) -> {
            let tiles = getTiles(info);
            let board = Board({
                rows = getRows(info),
                cols = getColumns(info),
                tiles = tiles
            });
            let Position(coords, dir) = playerPosition(id, info) |> Utils.Option.unsafeGet;

            match raytraceEx(dir, coords, board) {
                case Some(Person(seenId, _)) if seenId != id =>
                    Shoot
                case _ => {
                    let canShootFrom = match Position(c, d) -> {
                        match raytraceEx(d, c, board) {
                            case Some(Person(seenId, _)) => seenId != id
                            case _ => false
                        }
                    };
                    let isSafeAt = c -> {
                        let dirs = North :: East :: South :: West :: Nil;
                        dirs |> List.forAll(d -> match raytraceEx(d, c, board) {
                            case Some(Person(otherId, otherDir)) =>
                                otherId == id or otherDir != oppositeDir(d)
                            case _ => true
                        })
                    };
                    let safeAndShoot = match Position(c, d) ->
                        canShootFrom(Position(c, d)) and isSafeAt(c);
                    let safeMove = goTo(
                        Position(coords, dir),
                        safeAndShoot,
                        playersUnpassable,
                        tiles
                    );
                    match safeMove {
                        case Some(m) => m
                        case None =>
                            goTo(
                                Position(coords, dir),
                                canShootFrom,
                                playersUnpassable,
                                tiles
                            ) |> Option.getWithDefault(Turn(Counterclockwise))
                    }
                }
            }
        })

    def oppositeDir(d: Direction): Direction = match d {
        case North => South
        case South => North
        case East => West
        case West => East
    }

    ///
    /// Rushes to the nearest cell with walls (or board edges) on three of
    /// four sides, then turns to face the open side and shoots from cover.
    ///
    pub def camper(): Strategy =
        statelessStrategy((id, info) -> {
            let tiles = getTiles(info);
            let rows = getRows(info);
            let cols = getColumns(info);
            let Position(coords, dir) = playerPosition(id, info) |> Utils.Option.unsafeGet;

            let dirs = North :: East :: South :: West :: Nil;
            def isBlocked(c, d) = {
                let (r0, c0) = Flixball.Core.step(c, d);
                if (r0 < 0 or r0 >= rows or c0 < 0 or c0 >= cols) true
                else match Map.get((r0, c0), tiles) {
                    case Some(Wall) => true
                    case _ => false
                }
            };
            def openSides(c) = dirs |> List.filter(d -> not isBlocked(c, d));
            def isCamp(c) = match openSides(c) {
                case _ :: Nil => true
                case _ => false
            };

            if (isCamp(coords)) {
                let openDir = openSides(coords) |> List.head |> Utils.Option.unsafeGet;
                if (dir == openDir) Shoot
                else if (Flixball.Core.rotateDir(Clockwise, dir) == openDir) Turn(Clockwise)
                else Turn(Counterclockwise)
            } else {
                let goal = match Position(c, _) -> isCamp(c);
                goTo(
                    Position(coords, dir),
                    goal,
                    playersUnpassable,
                    tiles
                ) |> Option.getWithDefault(Turn(Clockwise))
            }
        })

    // Utilities

    ///
    /// Selects a move based on the shortest path from position p to a
    /// coordinate where `goal` is true. Considers players obstacles if
    /// `passablePlayers` is `false`.
    ///
    def goTo(
        p: Position, goal: Position -> Bool \ ef1,
        isPassable: Option[Tile] -> Bool \ ef2,
        tiles: Map[Coordinates, Tile]
    ): Option[Move] \ ef1 + ef2 = {
        use Option.flatMap;

        // todo: this predicate should just be caller supplied
        def availablePosition(c: Coordinates) = {
            isPassable(Map.get(c, tiles))
        };
        forM (
            moves <- findShortestPath(availablePosition, p, goal);
            res <- List.head(moves)
        ) yield {
            res
        }
    }

    def playersPassable(tile: Option[Tile]): Bool = match tile {
        case None => true
        case Some(Wall) => false
        case Some(Person(_, _)) => true
    }

    def playersUnpassable(tile: Option[Tile]): Bool = match tile {
        case None => true
        case Some(Wall) => false
        case Some(Person(_, _)) => false
    }

}
