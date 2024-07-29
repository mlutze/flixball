mod Flixball.Core.AiInfo {
    use Flixball.Core.Coordinates
    use Flixball.Core.PlayerId
    use Flixball.Core.Position
    use Flixball.Core.Tile
    use Flixball.Core.Board.Board
    use Flixball.Core.Board.Board.Board
    use Flixball.Core.Board.{players => boardPlayers}

    use AiInfo.AiInfo

    pub enum AiInfo(Board, Map[PlayerId, Position])

    pub def getTiles(i: AiInfo): Map[Coordinates, Tile] = {
        let AiInfo(Board(br), _) = i;
        br#tiles
    }

    pub def getRows(i: AiInfo): Int32 = {
        let AiInfo(Board(br), _) = i;
        br#rows
    }

    pub def getColumns(i: AiInfo): Int32 = {
        let AiInfo(Board(br), _) = i;
        br#cols
    }

    pub def playerPositions(i: AiInfo): Map[PlayerId, Position] = {
        let AiInfo(_, pm) = i;
        pm
    }

    pub def playerPosition(id: PlayerId, i: AiInfo): Option[Position] = {
        let AiInfo(_, pm) = i;
        Map.get(id, pm)
    }

    pub def fromBoard(b: Board): AiInfo =
        AiInfo(b, boardPlayers(b))

}
