namespace Flixball/GridGraph {
    use Flixball/Core.Coordinates;
    use Flixball/Core.Direction;
    use Flixball/Core.Direction.{East, North, South, West};
    use Flixball/Core.Move;
    use Flixball/Core.Move.{Walk, Shoot, Turn};
    use Flixball/Core.Position;
    use Flixball/Core.Position.Position;
    use Flixball/Core.Rotation;
    use Flixball/Core.step;
    use Flixball/Core.Tile;
    use Flixball/Core/Board.Board;
    use Flixball/Core/Board.Board.Board;

    ///
    /// It is assumed that `available` keeps the search space finite or
    /// that `goal` returns true for a reachable coordinate.
    /// This function might otherwise not halt.
    /// The start coordinate will always be available no matter `available`.
    ///
    pub def findShortestPath(available: Coordinates -> Bool \ ef1,
        start: Position, goal: Position -> Bool \ ef2): Option[List[Move]] \ {ef1, ef2} =
    region r { if (goal(start)) Some(Nil) else {
        // bfs
        let Position(startCoord, _) = start;
        let dists: MutMap[Position, Int32, r] = new MutMap(r);
        let backtracking: MutMap[Position, (Position, Move), r] = new MutMap(r);
        MutMap.put!(start, 0, dists);
        let taskList = new MutDeque(r);
        let foundGoal = ref None;
        MutDeque.pushBack(start, taskList);
        def bfsLoop() = match MutDeque.popFront(taskList) {
            case Some(current) => {
                foreach((next, move) <- possibleMoves(r, current) |> Iterator.toList) { // TODO wasted traversal
                    let Position(nextCoord, _) = next;
                    if (nextCoord == startCoord or available(nextCoord)) {
                        if (goal(next)) foundGoal := Some(next) else ();
                        let currentLength = MutMap.get(current, dists) |> Utils/Option.unsafeGet;
                        if (MutMap.get(next, dists) |> Option.isEmpty) {
                            MutMap.put!(next, currentLength + 1, dists);
                            MutMap.put!(next, (current, move), backtracking);
                            MutDeque.pushBack(next, taskList)
                        } else ()
                    } else ()
                };
                if (Option.isEmpty(deref foundGoal)) bfsLoop() else ()
            }
            case None => ()
        };
        bfsLoop();

        // return none if not reachable
        match deref foundGoal {
            case None => None // no reachable goal
            case Some(end) => {
                // construct the path list, end to start
                def stepBack(pos) = {
                    let pathLength = MutMap.get(pos, dists) |> Utils/Option.unsafeGet;
                    if (pathLength == 0) None else
                    MutMap.get(pos, backtracking) |> Utils/Option.unsafeGet |> Some
                };
                let revPathList = List.unfold(c -> stepBack(c) |> Option.map(match (prev, move) -> (move, prev)), end);
                Some(List.reverse(revPathList))
            }
        }
    }}

    /// Returns the three possibles movement moves from `p` and their new position.
    def possibleMoves(r: Region[r], p: Position): Iterator[(Position, Move), r] \ Write(r) = {
        use Flixball/Core.rotateDir;
        let Position(coord, dir) = p;
        let clockwise = (
            Position(coord, rotateDir(Rotation.Clockwise, dir)),
            Turn(Rotation.Clockwise)
        );
        let counterclockwise = (
            Position(coord, rotateDir(Rotation.Counterclockwise, dir)),
            Turn(Rotation.Counterclockwise)
        );
        let move = (
            Position(Flixball/Core.step(coord, dir), dir),
            Walk
        );
        (clockwise :: counterclockwise :: move :: Nil) |> List.iterator(r)
    }

    ///
    /// Finds the first nonempty tile tracing in the given direction.
    /// Excludes the given tile.
    ///
    // TODO: make it board-agnostic
    pub def raytraceEx(dir: Direction, coords0: Coordinates, board: Board): Option[Tile] =
        raytraceIn(dir, step(coords0, dir), board)

    ///
    /// Finds the first nonempty tile tracing in the given direction.
    /// Includes the given tile.
    ///
    pub def raytraceIn(dir: Direction, coords0: Coordinates, board: Board): Option[Tile] = {
        // todo: by the border requirement of boards, this does not need the bounds.
        let (row, col) = coords0;
        let Board(rec) = board;
        let rows = rec.rows;
        let cols = rec.cols;
        let tiles = rec.tiles;
        if (row < 0 or row >= rows) {
            None
        } else if (col < 0 or col >= cols) {
            None
        } else {
            match (tiles |> Map.get(coords0)) {
                case None => {
                    let coords = step(coords0, dir);
                    raytraceIn(dir, coords, board)
                }
                case Some(tile) => Some(tile)
            }
        }
    }

}
