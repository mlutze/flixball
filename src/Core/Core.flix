namespace Flixball/Core {
    use Flixball/Core/AiInfo.AiInfo

    use Direction.{North, East, South, West}
    use Rotation.{Clockwise, Counterclockwise}

    pub type alias PlayerId = Int32

    pub type alias Coordinates = (Int32, Int32)

    pub enum AiState {
        case Value(String)
        case Collection(List[AiState])
    }

    pub enum Direction with Eq, ToString, Order {
        case North
        case East
        case South
        case West
    }

    pub enum Rotation with Eq {
        case Clockwise
        case Counterclockwise
    }

    pub enum Move with Eq {
        case Turn(Rotation)
        case Shoot
        case Walk
    }

    pub enum Tile with Eq, ToString {
        case Wall
        case Person(PlayerId, Direction)
    }

    /// given a player id, the strategy determines a
    /// seed-parametric starting state and a move logic.
    pub type alias Strategy = PlayerId -> (Int64 -> AiState, MoveLogic)

    pub type alias MoveLogic = (AiInfo, AiState) -> (Move, AiState)

    pub enum Position(Coordinates, Direction) with Eq, Order

    namespace Position {
        use Flixball/Core.Position.Position

        pub def coordinates(p: Flixball/Core.Position): Flixball/Core.Coordinates = {
            let Position(c, _) = p;
            c
        }

        pub def direction(p: Flixball/Core.Position): Flixball/Core.Direction = {
            let Position(_, d) = p;
            d
        }
    }

    ///
    /// Returns the coordinates one step in the given direction.
    ///
    pub def step(coords: Coordinates, dir: Direction): Coordinates = {
        let (row, col) = coords;
        match dir {
            case North => (row - 1, col)
            case East  => (row, col + 1)
            case South => (row + 1, col)
            case West  => (row, col - 1)
        }
    }

    pub def rotateDir(rot: Rotation, dir: Direction): Direction = match (rot, dir) {
        case (Clockwise, North) => East
        case (Clockwise, East) => South
        case (Clockwise, South) => West
        case (Clockwise, West) => North

        case (Counterclockwise, North) => West
        case (Counterclockwise, West) => South
        case (Counterclockwise, South) => East
        case (Counterclockwise, East) => North
    }
}
