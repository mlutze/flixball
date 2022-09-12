namespace Flixball/GridGraph {

    use Flixball/Core.Board;
    use Flixball/Core.Board.Board;
    use Flixball/Core.Coordinates;
    use Flixball/Core.Coordinates.Coordinates;
    use Flixball/Core.Direction;
    use Flixball/Core.Direction.{North, East, South, West};
    use Flixball/Core.Tile;

    ///
    /// It is assumed that `available` keeps the search space finite or
    /// that `goal` returns true for a reachable coordinate.
    /// This function might otherwise not halt.
    ///
    pub def findShortestPath(available: Coordinates -> Bool \ ef1,
        start: {start :: Coordinates}, goal: Coordinates -> Bool \ ef2): Option[List[Coordinates]] \ {ef1, ef2} =
    region r { if (goal(start.start)) Some(Nil) else {
        // bfs
        let dists: MutMap[Coordinates, Int32, r] = new MutMap(r);
        MutMap.put!(start.start, 0, dists);
        let taskList = new MutDeque(r);
        let foundGoal = ref None;
        MutDeque.pushBack(start.start, taskList);
        def bfsLoop() = match MutDeque.popFront(taskList) {
            case Some(current) =>
                foreach(next <- possibleMoves(r, current)) {
                    if (available(next)) {
                        if (goal(next)) foundGoal := Some(next) else ();
                        let currentLength = match MutMap.get(current, dists) {
                            case None => ?unreachable
                            case Some(v) => v
                        };
                        if (MutMap.get(next, dists) |> Option.isEmpty) {
                            MutMap.put!(next, currentLength + 1, dists);
                            MutDeque.pushBack(next, taskList)
                        } else ()
                    } else ()
                };
                if (Option.isEmpty(deref foundGoal)) bfsLoop() else ()
            case None => ()
        };
        bfsLoop();

        // return none if not reachable
        match deref foundGoal {
            case None => None // no reachable goal
            case Some(end) =>
                // construct the path list, end to start
                def stepBack(c) = {
                    let cLength = match MutMap.get(c, dists) {
                        case None => ?unreachable
                        case Some(l) => l
                    };
                    if (cLength == 1) None else

                    let res = ref None;
                    foreach(next <- possibleMoves(r, c)) {
                        MutMap.get(next, dists) |>
                            Option.foreach(d -> if (d == cLength - 1) res := Some(next) else ())
                    };
                    match deref res {
                        case None => ?unreachable
                        case Some(value) => Some(value)
                    }
                };
                let revPathList = List.unfold(c ->  stepBack(c) |> Option.map(next -> (next, next)), end);
                Some(List.reverse(end :: revPathList))
        }
    }}

    def possibleMoves(r: Region[r], c: Coordinates): Iterator[Coordinates, r] \ r =
        let x = fst(c);
        let y = snd(c);
        let coordinates = (x, y+1) :: (x, y-1) :: (x+1, y) :: (x-1, y) :: Nil;
        List.iterator(r, coordinates)


    ///
    /// Finds the first nonempty tile tracing in the given direction.
    /// Excludes the given tile.
    ///
    // TODO: make it board-agnostic
    pub def raytraceEx(dir: Direction, coords0: Coordinates, board: Board): Option[Tile] = {
        raytraceIn(dir, step(coords0, dir), board)
    }

    ///
    /// Finds the first nonempty tile tracing in the given direction.
    /// Includes the given tile.
    ///
    pub def raytraceIn(dir: Direction, coords0: Coordinates, board: Board): Option[Tile] = {
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
                case None =>
                    let coords = step(coords0, dir);
                    raytraceIn(dir, coords, board)
                case Some(tile) => Some(tile)
            }
        }
    }

    ///
    /// Returns the coordinates one step in the given direction.
    ///
    pub def step(coords: Coordinates, dir: Direction): (Int32, Int32) = {
        let (row, col) = coords;
        match dir {
            case North => (row - 1, col)
            case East => (row, col + 1)
            case South => (row + 1, col)
            case West => (row, col - 1)
        }
    }

}
