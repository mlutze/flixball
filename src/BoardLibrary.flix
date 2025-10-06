mod Flixball.BoardLibrary {
    use Flixball.Core.Board.Board;
    use Flixball.Core.Board.Board.Board;
    use Flixball.Core.Direction.East
    use Flixball.Core.Direction.North
    use Flixball.Core.Direction.South
    use Flixball.Core.Direction.West
    use Flixball.Core.Tile
    use Flixball.Core.Tile.Person
    use Flixball.Core.Tile.Wall

    ///
    /// Adds a border around the board by increasing the size in each
    /// dimension by two and increasing each tile position by one in
    /// each dimension.
    ///
    pub def addBorder(b: Board): Board = region r {
        let Board(br) = b;
        let rows = br#rows+2;
        let cols = br#cols+2;
        let translatedMap = MutMap.empty(r);
        // Add translated existing tiles
        foreach(((x, y), tile) <- br#tiles |> Map.toList) { // TODO wasted traversal
            MutMap.put((x+1, y+1), tile, translatedMap)
        };
        // Add border walls
        foreach(i <- List.range(0, cols)) { // TODO wasted traversal
            MutMap.put((0, i), Wall, translatedMap);
            MutMap.put((rows-1, i), Wall, translatedMap)
        };
        foreach(i <- List.range(0, rows)) { // TODO wasted traversal
            MutMap.put((i, 0), Wall, translatedMap);
            MutMap.put((i, cols-1), Wall, translatedMap)
        };
        Board({rows = rows, cols = cols, tiles = MutMap.toMap(translatedMap)})
    }

    ///
    /// Creates a pseudo-random board from the seed with an average wall
    /// density of `density` in the range [0.0, 1.0]. The map will have
    /// an encompasing border.
    ///
    pub def randomBoard(seed: Int64, rows: {rows = Int32}, cols: Int32, density: Float64): Board = region r {
        let grid = Flixball.Noise.boolNoise2d(r, {width=rows#rows, height=cols}, seed, density);
        Board({rows=rows#rows, cols=cols, tiles=gridToMap(grid)}) |> addBorder
    }

    ///
    /// Cellular Automata Refinement.
    /// sensible defaults, prob=0.40, iterations=3
    ///
    pub def automataBoard(seed: Int64, rows: {rows = Int32}, cols: Int32, density: Float64, iterations: Int32): Board = region r {
        let grid = Flixball.Noise.cellularGeneration(r, {width=rows#rows, height=cols}, seed, density, iterations);
        Board({rows=rows#rows, cols=cols, tiles=gridToMap(grid)}) |> addBorder
    }

    ///
    /// Puts the players in random empty positions on the board.
    ///
    pub def sprinklePlayers(seed: Int64, n: Int32, b0: Board): Board = region r {
        let rand = RegionedRandom.newWithSeed(r, seed);
        let Board(rec) = b0;
        let rows = List.range(0, rec#rows);
        let cols = List.range(0, rec#cols);
        let options = {
            forM (
                row <- rows;
                col <- cols;
                if (Map.get((row, col), rec#tiles) == None)
            ) yield {
                (row, col)
            }
        };
        let choices = options |> RegionedRandom.shuffleList(rand) |> List.take(n);
        let choiceToPlayer = choices |> List.zipWithIndex;
        (b0, choiceToPlayer) ||> List.foldLeft(
            b -> match (id, coords) ->
                let dir = RegionedRandom.chooseNel(rand, Nel.Nel(North, East :: South :: West :: Nil));
                b |> Flixball.Core.Board.set_(coords, Some(Tile.Person(id, dir)))
        )
    }

    def gridToMap(g: Array[Array[Bool, r], r]): Map[(Int32, Int32), Tile] \ r = region rh {
        let mutTiles = MutMap.empty(rh);
        foreach(
            (x, arr) <- Array.iterator(rh, g) |> Iterator.zipWithIndex |> Iterator.toList; // TODO wasted traversal
            (y, b) <- Array.iterator(rh, arr) |> Iterator.zipWithIndex |> Iterator.toList  // TODO wasted traversal
        ) {
                if (b) mutTiles |> MutMap.put((x, y), Wall)
                else ()
        };
        MutMap.toMap(mutTiles)
    }

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
    pub def fromString(s: String): Result[String, Board] = region r {
        let lines = String.lines(s);

        let rows = List.length(lines);
        let cols = lines |>
            List.map(String.length) |>
            List.maximum |>
            Option.getWithDefault(0);
        let tileMap = MutMap.empty(r);

        let availableId = Ref.fresh(r, 0);
        def freshId() = {
            let id = Ref.get(availableId);
            Ref.put(id + 1, availableId);
            id
        };

        let error = Ref.fresh(r, None);
        def addError(msg: String) = {
            if (Ref.get(error) == None) Ref.put(Some(msg), error)
            else ()
        };

        foreach((row, line) <- lines |> List.zipWithIndex) { // TODO wasted traversal
            let cells = String.toList(line);
            foreach((col, cell) <- cells |> List.zipWithIndex) {  // TODO wasted traversal
                def addTile(tile) = MutMap.put((row, col), tile, tileMap);
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
        match Ref.get(error) {
            case None => {
                let b = Board({cols = cols, rows = rows, tiles = MutMap.toMap(tileMap)});
                Ok(addBorder(b))
            }
            case Some(msg) =>
                Err(msg)
        }
    }
}
