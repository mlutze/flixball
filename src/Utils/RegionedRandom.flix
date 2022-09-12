namespace RegionedRandom {

    ///
    /// Returns a fresh random number generator initialized with the given seed `s`.
    ///
    pub def newWithSeed(_r: Region[r], s: Int64): Random[r] \ Write(r) =
        import new java.util.Random(Int64): ##java.util.Random \ Write(r) as newRandom;
        Random(newRandom(s))

    ///
    /// Returns a pseudorandom element from the given array `a` using the random / number generator
    /// `r`.
    ///
    /// Returns `None` if the given array `a` is empty.
    ///
    pub def chooseArray(ran: Random[r1], a: Array[a, r2]): Option[a] \ {Read(r1, r2), Write(r1)} =
        if (a.length == 0) {
            None
        } else {
            let m = a.length;
            let i = nextNatWithMax(ran, m);
            Some(a[i])
        }

    ///
    /// Returns a pseudorandom element from the given non-empty list `l` using the random number
    /// generator `ran`.
    ///
    pub def chooseNel(ran: Random[r], l: Nel[a]): a \ {Read(r), Write(r)} =
        let m = Nel.length(l);
        let i = nextNatWithMax(ran, m);
        l |> nelUnsafeNth(i)

    def nelUnsafeNth(n: Int32, l: Nel[a]): a =
        if (n <= 0)
            Nel.head(l)
        else match Nel.tail(l) {
            case hd :: tl => Nel(hd, tl) |> nelUnsafeNth(n-1)
            case Nil => ?unreachable
        }

    ///
    /// Shuffles `a` to a random permutation.
    ///
    pub def shuffleArray(ran: Random[r1], a: Array[a, r2]): Unit \ {Read(r1, r2), Write(r1)} =
        use Random.Random.{Random => FlixRandom};
        let Random(javaRandom) = ran;
        Array.shuffle(FlixRandom(javaRandom), a) as \ {Read(r1, r2), Write(r1)}

    ///
    /// Returns a random permutation of `l`.
    ///
    pub def shuffleList(ran: Random[r], l: List[a]): List[a] \ {Read(r), Write(r)} =
        use Random.Random.{Random => FlixRandom};
        let Random(javaRandom) = ran;
        List.shuffle(FlixRandom(javaRandom), l) as \ {Read(r), Write(r)}

    ///
    /// Returns the next pseudorandom boolean from the given random number generator `r`.
    ///
    pub def nextBool(ran: Random[r]): Bool \ {Read(r), Write(r)} =
        import java.util.Random.nextBoolean(): Bool \ {Read(r), Write(r)};
        let Random(o) = ran;
        nextBoolean(o)

    ///
    /// Returns the next pseudorandom 32-bit floating point number from the given random number generator `r`.
    ///
    pub def nextFloat32(ran: Random[r]): Float32 \ {Read(r), Write(r)} =
        import java.util.Random.nextFloat(): Float32 \ {Read(r), Write(r)};
        let Random(o) = ran;
        nextFloat(o)

    ///
    /// Returns the next pseudorandom 64-bit floating point number from the given random number generator `r`.
    ///
    pub def nextFloat64(ran: Random[r]): Float64 \ {Read(r), Write(r)} =
        import java.util.Random.nextDouble(): Float64 \ {Read(r), Write(r)};
        let Random(o) = ran;
        nextDouble(o)

    ///
    /// Returns the next pseudorandom 32-bit integer value from the given random number generator `r`.
    ///
    pub def nextInt32(ran: Random[r]): Int32 \ {Read(r), Write(r)} =
        import java.util.Random.nextInt(): Int32 \ {Read(r), Write(r)};
        let Random(o) = ran;
        nextInt(o)

    ///
    /// Returns the next pseudorandom 64-bit integer value from the given random number generator `r`.
    ///
    pub def nextInt64(ran: Random[r]): Int64 \ {Read(r), Write(r)} =
        import java.util.Random.nextLong(): Int64 \ {Read(r), Write(r)};
        let Random(o) = ran;
        nextLong(o)

    ///
    /// Returns the next pseudorandom Gaussian distributed 64-bit floating point number.
    ///
    pub def nextGaussian(ran: Random[r]): Float64 \ {Read(r), Write(r)} =
        import java.util.Random.nextGaussian(): Float64 \ {Read(r), Write(r)};
        let Random(o) = ran;
        nextGaussian(o)

    ///
    /// Returns the next pseudorandom 32-bit integer value between `0` and `m` (exclusive) using the given random number generator `r`.
    ///
    pub def nextNatWithMax(ran: Random[r], m: Int32): Int32 \ {Read(r), Write(r)} =
        import java.util.Random.nextInt(Int32): Int32 \ {Read(r), Write(r)};
        let Random(o) = ran;
        nextInt(o, m)

    ///
    /// Represents a random number generator.
    ///
    pub enum Random[_r: Region] {
        case Random(##java.util.Random)
    }

    instance Scoped[Random] {
        pub def regionOf(_x: Random[r]): Region[r] = () as Region[r]
    }

}
