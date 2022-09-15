namespace Flixball {
    use Flixball/Core.AiState;
    use Flixball/Core.AiState.{Value, Collection};

    pub class State[a] {
        pub def toState(x: a): AiState
        pub def fromState(x: AiState): Option[a]
    }

    pub class MutState[m: Region -> Type] {
        pub def toState(x: m[r]): AiState \ Read(r)
        pub def fromState(r: Region[r], x: AiState): Option[m[r]] \ Write(r)
    }

    instance State[Bool] {
        pub def toState(x: Bool): AiState = Value("${x}")

        pub def fromState(x: AiState): Option[Bool] = match x {
            case Value(b) => FromString.fromString(b)
            case _ => None
        }
    }

    instance State[Int64] {
        pub def toState(x: Int64): AiState = Value("${x}")

        pub def fromState(x: AiState): Option[Int64] = match x {
            case Value(n) => FromString.fromString(n)
            case _ => None
        }
    }

    instance MutState[Ref[a]] with State[a] {
        pub def toState(x: Ref[a, r]): AiState \ Read(r) = Flixball/State.toState(deref x)
    
        pub def fromState(r: Region[r], x: AiState): Option[Ref[a, r]] \ Write(r) = Flixball/State.fromState(x) |> Option.map(y -> ref y @ r)
    }
    
}