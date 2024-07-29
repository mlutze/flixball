mod Flixball.Core.Board {
    use Flixball.Core.Coordinates
    use Flixball.Core.PlayerId
    use Flixball.Core.Position
    use Flixball.Core.Position.Position
    use Flixball.Core.Tile
    use Flixball.Core.Tile.Person

    use Board.Board

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
    pub enum Board({rows = Int32, cols = Int32, tiles = Map[Coordinates, Tile]})

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


    pub def players(b: Board): Map[PlayerId, Position] = {
        let Board(br) = b;
        br#tiles |> Map.toList |> List.filterMap(match (coords, t) -> match t {
            case Person(id, dir) => Some(id, Position(coords, dir))
            case _ => None
        }) |> List.toMap
    }

    pub def player(b: Board, id: PlayerId): Option[Position] =
        let Board(br) = b;
        br#tiles |> Utils.Map.findMap((coord, tile) -> match tile {
            case Person(id1, dir) if id1 == id => Some(Position(coord, dir))
            case _ => None
        })

}
