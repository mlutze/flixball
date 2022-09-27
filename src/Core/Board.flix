namespace Flixball/Core/Board {
    use Flixball/Core.Coordinates
    use Flixball/Core.Direction.East
    use Flixball/Core.Direction.North
    use Flixball/Core.Direction.South
    use Flixball/Core.Direction.West
    use Flixball/Core.PlayerId
    use Flixball/Core.Position
    use Flixball/Core.Position.Position
    use Flixball/Core.Tile
    use Flixball/Core.Tile.Person
    use Flixball/Core.Tile.Wall

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
    pub enum Board({rows :: Int32, cols :: Int32, tiles :: Map[Coordinates, Tile]})

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
    pub def randomBoard(seed: Int64, rows: {rows::Int32}, cols: Int32, density: Float64): Board = region r {
        let grid = Flixball/Noise.boolNoise2d(r, {width=rows.rows, height=cols}, seed, density);
        Board({rows=rows.rows, cols=cols, tiles=gridToMap(grid)}) |> addBorder
    }

    ///
    /// Cellular Automata Refinement.
    /// sensible defaults, prob=0.40, iterations=3
    ///
    pub def automataBoard(seed: Int64, rows: {rows::Int32}, cols: Int32, density: Float64, iterations: Int32): Board = region r {
        let grid = Flixball/Noise.cellularGeneration(r, {width=rows.rows, height=cols}, seed, density, iterations);
        Board({rows=rows.rows, cols=cols, tiles=gridToMap(grid)}) |> addBorder
    }

    def gridToMap(g: Array[Array[Bool, r], r]): Map[(Int32, Int32), Tile] \ Read(r) = {
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
    }

    pub def players(b: Board): List[(PlayerId, Position)] = {
        let Board(br) = b;
        br.tiles |> Map.toList |> List.filterMap(match (coords, t) -> match t {
            case Person(id, dir) => Some(id, Position(coords, dir))
            case _ => None
        })
    }

    pub def player(b: Board, id: PlayerId): Option[Position] =
        players(b) |>
            List.find(match (foundId, _) -> foundId == id) |>
            Option.map(match (_, pos) -> pos)

    ///
    /// Each line of the string is a row. If lines are of different
    /// lengths they will be interpreted as being right-padded with
    /// spaces. The board will have an surrounding edge added. Players
    /// are numbered from 0, top-to-bottom, left-to-right. 
    ///
    /// " " = empty tile
    /// "#" = wall tile
    /// {"<","^",">","v"} = player tile
    ///
    pub def fromString(s: String): Result[Board, String] = region r {
        let lines = String.lines(s);

        let rows = List.length(lines);
        let cols = lines |>
            List.map(String.length) |>
            List.maximum |>
            Option.getWithDefault(0);
        let tileMap = new MutMap(r);

        let availableId = ref 0 @ r;
        def freshId() = {
            let id = deref availableId;
            availableId := id + 1;
            id
        };

        let error = ref None @ r;
        def addError(msg: String) = {
            if (deref error == None) error := Some(msg)
            else ()
        };

        foreach((line, row) <- lines |> List.enumerator(r)) {
            let cells = String.toList(line);
            foreach((cell, col) <- cells |> List.enumerator(r)) {
                def addTile(tile) = MutMap.put!((row, col), tile, tileMap);
                match cell {
                    case ' ' => () // do nothing
                    case '<' => addTile(Person(freshId(), West))
                    case '^' => addTile(Person(freshId(), North))
                    case '>' => addTile(Person(freshId(), East))
                    case 'v' => addTile(Person(freshId(), South))
                    case '#' => addTile(Wall)
                    case c   => addError("Unexpected '${c}' at row ${row} column ${col}")
                }
            }
        };
        match deref error {
            case None => {
                let b = Board({cols = cols, rows = rows, tiles = MutMap.toMap(tileMap)});
                Ok(addBorder(b))
            }
            case Some(msg) =>
                Err(msg)
        }
    }
}
