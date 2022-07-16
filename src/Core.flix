namespace Flixball {
    namespace Core {

        pub enum Board({rows :: Int32, cols :: Int32, tiles :: Map[(Int32, Int32), Tile]})

        pub enum Direction with Eq {
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

        pub enum Tile {
            case Wall
            case Person(Player)
        }

        // id
        pub enum Player(Int32, Direction, GameState -> Move)


        instance Eq[Player] {

            pub def eq(x: Player, y: Player): Bool =
                let Player.Player((p1, _, _)) = x;
                let Player.Player((p2, _, _)) = y;
                p1 == p2

        }


        instance Order[Player] {

            pub def compare(x: Player, y: Player): Comparison =
                let Player.Player((p1, _, _)) = x;
                let Player.Player((p2, _, _)) = y;
                p1 <=> p2

        }

        pub enum Position(Int32, Int32, Direction)

        pub enum GameState(Map[Int32, Position], Board)
    }
}