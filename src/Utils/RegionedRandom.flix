import java.util.Random
///
/// Represents a random number generator.
///
pub enum RegionedRandom[_r: Region] {
    case RegionedRandom(Random)
}

mod RegionedRandom {
    import java.util.Random

    ///
    /// Returns a fresh random number generator initialized with the given seed `s`.
    ///
    pub def newWithSeed(_r: Region[r], s: Int64): RegionedRandom[r] \ r = {
        RegionedRandom(checked_ecast(unsafe new Random(s)))
    }

    ///
    /// Returns a pseudorandom element from the given array `a` using the random number generator `r`.
    ///
    /// Returns `None` if the given array `a` is empty.
    ///
    pub def chooseArray(ran: RegionedRandom[r1], a: Array[a, r2]): Option[a] \ {r1, r2} = {
        if (Array.length(a) == 0) {
            None
        } else {
            let m = Array.length(a);
            let i = nextNatWithMax(ran, m);
            Some(Utils.Array.unsafeNth(i, a))
        }
    }

    ///
    /// Returns a pseudorandom element from the given non-empty list `l` using the random number generator `r`.
    ///
    pub def chooseNel(ran: RegionedRandom[r1], l: Nel[a]): a \ r1 = {
        let m = Nel.length(l);
        let i = nextNatWithMax(ran, m);
        l |> nelUnsafeNth(i)
    }

    def nelUnsafeNth(n: Int32, l: Nel[a]): a = {
        if (n <= 0)
            Nel.head(l)
        else match Nel.tail(l) {
            case hd :: tl => Nel.Nel(hd, tl) |> nelUnsafeNth(n-1)
            case Nil => ?unreachable
        }
    }

    ///
    /// Shuffles `a` to a random permutation.
    ///
    pub def shuffleArray(ran: RegionedRandom[r1], a: Array[a, r2]): Unit \ {r1, r2} = {
        use Random.{Random => FlixRandom};
        let RegionedRandom(javaRandom) = ran;
        unchecked_cast(Utils.Array.shuffle(javaRandom, a) as _ \ {r1, r2})
    }

    ///
    /// Returns a random permutation of `l`.
    ///
    pub def shuffleList(ran: RegionedRandom[r], l: List[a]): List[a] \ r = {
        use Random.{Random => FlixRandom};
        let RegionedRandom(javaRandom) = ran;
        unchecked_cast(region rc {
            l |> List.toArray(rc) !> Utils.Array.shuffle(javaRandom) |> Array.toList
        } as _ \ r)
    }

    ///
    /// Returns the next pseudorandom boolean from the given random number generator `r`.
    ///
    pub def nextBool(ran: RegionedRandom[r]): Bool \ r = {
        let RegionedRandom(o) = ran;
        checked_ecast(unsafe o.nextBoolean())
    }

    ///
    /// Returns the next pseudorandom 32-bit floating point number from the given random number generator `r`.
    ///
    pub def nextFloat32(ran: RegionedRandom[r]): Float32 \ r = {
        let RegionedRandom(o) = ran;
        checked_ecast(unsafe o.nextFloat())
    }

    ///
    /// Returns the next pseudorandom 64-bit floating point number from the given random number generator `r`.
    ///
    pub def nextFloat64(ran: RegionedRandom[r]): Float64 \ r = {
        let RegionedRandom(o) = ran;
        checked_ecast(unsafe o.nextDouble())
    }

    ///
    /// Returns the next pseudorandom 32-bit integer value from the given random number generator `r`.
    ///
    pub def nextInt32(ran: RegionedRandom[r]): Int32 \ r = {
        let RegionedRandom(o) = ran;
        checked_ecast(unsafe o.nextInt())
    }

    ///
    /// Returns the next pseudorandom 64-bit integer value from the given random number generator `r`.
    ///
    pub def nextInt64(ran: RegionedRandom[r]): Int64 \ r = {
        let RegionedRandom(o) = ran;
        checked_ecast(unsafe o.nextLong())
    }

    ///
    /// Returns the next pseudorandom Gaussian distributed 64-bit floating point number.
    ///
    pub def nextGaussian(ran: RegionedRandom[r]): Float64 \ r = {
        let RegionedRandom(o) = ran;
        checked_ecast(unsafe o.nextGaussian())
    }

    ///
    /// Returns the next pseudorandom 32-bit integer value between `0` and `m` (exclusive) using the given random number generator `r`.
    ///
    pub def nextNatWithMax(ran: RegionedRandom[r], m: Int32): Int32 \ r = {
        let RegionedRandom(o) = ran;
        checked_ecast(unsafe o.nextInt(m))
    }
}
