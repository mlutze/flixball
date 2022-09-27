namespace Flixball/Core/AiInfo {
    use Flixball/Core.Coordinates
    use Flixball/Core/GameState.GameState
    use Flixball/Core.PlayerId
    use Flixball/Core.Position
    use Flixball/Core.Tile
    use Flixball/Core/Board.Board
    use Flixball/Core/Board.Board.Board

    pub opaque enum AiInfo(Board, Map[PlayerId, Position])

    pub def init(board: Board, players: Map[PlayerId, Position]): AiInfo = {
        AiInfo(board, players)
    }

    pub def getTiles(i: AiInfo): Map[Coordinates, Tile] = {
        let AiInfo(Board(br), _) = i;
        br.tiles
    }

    pub def getRows(i: AiInfo): Int32 = {
        let AiInfo(Board(br), _) = i;
        br.rows
    }

    pub def getColumns(i: AiInfo): Int32 = {
        let AiInfo(Board(br), _) = i;
        br.cols
    }

    pub def getPlayers(i: AiInfo): Map[PlayerId, Position] = {
        let AiInfo(_, players) = i;
        players
    }
}
