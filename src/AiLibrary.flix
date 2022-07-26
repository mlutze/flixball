namespace Flixball/AiLibrary {
    use Flixball/Core.GameState;
    use Flixball/Core.GameState.{GameState};
    use Flixball/Core.Move;
    use Flixball/Core.Move.{Turn, Shoot, Walk};
    use Flixball/Core.MoveLogic;
    use Flixball/Core.MoveLogic.{MoveLogic};
    use Flixball/Core.Rotation;

    def constantAction(m: Move): MoveLogic =
        ((_, i, map) -> (m, i, map)) |> MoveLogic

    pub def shoot(): MoveLogic = constantAction(Shoot)

    pub def walk(): MoveLogic = constantAction(Walk)

    pub def rotate(r: Rotation): MoveLogic = constantAction(Turn(r))

}
