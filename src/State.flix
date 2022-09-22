namespace Flixball {
    use Flixball/Core.AiState;
    use Flixball/Core.AiState.{Value, Collection};

    pub lawful class State[a] {
        pub def toState(x: a): AiState
        pub def fromState(x: AiState): Option[a]

        law inverse: forall (x: a) with Eq[a] . Flixball/State.fromState(Flixball/State.toState(x)) == Some(x)
    }

    pub class MutState[m: Region -> Type] {
        pub def toState(x: m[r]): AiState \ Read(r)
        pub def fromState(r: Region[r], x: AiState): Option[m[r]] \ Write(r)
    }

    instance State[AiState] {
        pub def toState(x: AiState): AiState = x
    
        pub def fromState(x: AiState): Option[AiState] = Some(x)
    }

    instance State[Unit] {
        pub def toState(): AiState = Value("")
    
        pub def fromState(x: AiState): Option[Unit] = match x {
            case Value("") => Some(())
            case _ => None
        }
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

    instance State[String] {
        pub def toState(x: String): AiState = Value(x)

        pub def fromState(x: AiState): Option[String] = match x {
            case Value(n) => Some(n)
            case _ => None
        }
    }

    instance State[(a, b)] with State[a], State[b] {
        pub def toState(x: (a, b)): AiState = {
            let (a0, b0) = x;
            let a = Flixball/State.toState(a0);
            let b = Flixball/State.toState(b0);
            Collection(a :: b :: Nil)
        }

        pub def fromState(x: AiState): Option[(a, b)] = match x {
            case Collection(a0 :: b0 :: Nil) =>
                let a = Flixball/State.fromState(a0);
                let b = Flixball/State.fromState(b0);
                Applicative.product(a, b)
            case _ => None
        }
    }

    instance State[Map[k, v]] with State[k], State[v], Order[k] {
        pub def toState(x: Map[k, v]): AiState = {
            x |> Map.toList |> Flixball/State.toState
        }

        pub def fromState(x: AiState): Option[Map[k, v]] = {
            use Option.flatMap;
            let* list = Flixball/State.fromState(x);
            Some(List.toMap(list))
        }
    }

    instance State[List[a]] with State[a] {
        pub def toState(x: List[a]): AiState = {
            let vals = x |> List.map(Flixball/State.toState);
            Collection(vals)
        }

        pub def fromState(x: AiState): Option[List[a]] = match x {
            case Collection(vals) => vals |> List.traverse(Flixball/State.fromState)
            case _ => None
        }
    }

    instance MutState[Ref[a]] with State[a] {
        pub def toState(x: Ref[a, r]): AiState \ Read(r) = Flixball/State.toState(deref x)
    
        pub def fromState(r: Region[r], x: AiState): Option[Ref[a, r]] \ Write(r) = Flixball/State.fromState(x) |> Option.map(y -> ref y @ r)
    }
    
}