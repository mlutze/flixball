namespace Flixball/GridGraph {

    use Flixball/Core.Coordinates;
    use Flixball/Core.Coordinates.Coordinates;

    ///
    /// It is assumed that `available` keeps the search space finite.
    /// This function might otherwise not halt.
    ///
    pub def findShortestPath(available: Coordinates -> Bool \ ef,
        start: {start :: Coordinates}, end: Coordinates): Option[List[Coordinates]] \ ef =
    region r { if (start.start == end) Some(Nil) else {
        // bfs
        let dists: MutMap[Coordinates, Int32, r] = new MutMap(r);
        MutMap.put!(start.start, 0, dists);
        let taskList = new MutDeque(r);
        MutDeque.pushBack(start.start, taskList);
        def bfsLoop() = match MutDeque.popFront(taskList) {
            case Some(current) =>
                foreach(next <- possibleMoves(r, current)) {
                    if (available(next)) {
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
                bfsLoop()
            case None => ()
        };
        bfsLoop();

        // return none if not reachable
        if (MutMap.get(end, dists) |> Option.isEmpty) None else
        
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
    }}

    def possibleMoves(r: Region[r], c: Coordinates): Iterator[Coordinates, r] \ r =
        let x = fst(c);
        let y = snd(c);
        let coordinates = (x, y+1) :: (x, y-1) :: (x+1, y) :: (x-1, y) :: Nil;
        List.iterator(r, coordinates)

}
