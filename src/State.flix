namespace Flixball {
    use Flixball/Core.AiState;
    use Flixball/Core.AiState.{Value, Collection};

    pub class State[a] {
        pub def toState(x: a): AiState
        pub def fromState(x: AiState): Option[a]
    }

    pub class MutState[m: Region -> Type] {
        pub def toState(x: m[r]): AiState \ r
        pub def fromState(r: Region[r], x: AiState): Option[m[r]] \ r
    }

    instance State[Bool] {
        pub def toState(x: Bool): AiState = Value("${x}")

        pub def fromState(x: AiState): Option[Bool] = match x {
            case Value("true") => Some(true)
            case Value("false") => Some(false)
            case _ => None
        }
    }

    instance State[Int64] {
        pub def toState(x: Int64): AiState = Value("${x}")

        pub def fromState(x: AiState): Option[Int64] = match x {
            case Value(n) => Int64.fromString(n)
            case _ => None
        }
    }

    instance MutState[Ref[a]] with State[a] {
        pub def toState(x: Ref[a, r]): AiState \ r = Flixball/State.toState(deref x)
    
        pub def fromState(r: Region[r], x: AiState): Option[Ref[a, r]] \ r = Flixball/State.fromState(x) |> Option.map(y -> ref y @ r)
    }
    
}