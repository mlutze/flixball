namespace RegionedRandom {

    ///
    /// Returns a fresh random number generator initialized with the given seed `s`.
    ///
    pub def newWithSeed(_r: Region[r], s: Int64): Random[r] & r =
        import new java.util.Random(Int64): ##java.util.Random & r as newRandom;
        Random(newRandom(s))

    ///
    /// Returns a pseudorandom element from the given array `a` using the random number generator `r`.
    ///
    /// Returns `None` if the given array `a` is empty.
    ///
    pub def choose(ran: Random[r1], a: Array[a, r2]): Option[a] & r1 and r2 =
        if (a.length == 0) {
            None
        } else {
            let m = a.length;
            let i = nextNatWithMax(ran, m);
            Some(a[i])
        }

    ///
    /// Shuffles `a` to a random permutation.
    ///
    pub def shuffleArray(ran: Random[r1], a: Array[a, r2]): Unit & r1 and r2 =
        use Random.Random.{Random => FlixRandom};
        let Random(javaRandom) = ran;
        Array.shuffle(FlixRandom(javaRandom), a) as & r1 and r2

    ///
    /// Returns a random permutation of `l`.
    ///
    pub def shuffleList(ran: Random[r], l: List[a]): List[a] & r =
        use Random.Random.{Random => FlixRandom};
        let Random(javaRandom) = ran;
        List.shuffle(FlixRandom(javaRandom), l) as & r

    ///
    /// Returns the next pseudorandom boolean from the given random number generator `r`.
    ///
    pub def nextBool(ran: Random[r]): Bool & r =
        import java.util.Random.nextBoolean(): Bool & r;
        let Random(o) = ran;
        nextBoolean(o)

    ///
    /// Returns the next pseudorandom 32-bit floating point number from the given random number generator `r`.
    ///
    pub def nextFloat32(ran: Random[r]): Float32 & r =
        import java.util.Random.nextFloat(): Float32 & r;
        let Random(o) = ran;
        nextFloat(o)

    ///
    /// Returns the next pseudorandom 64-bit floating point number from the given random number generator `r`.
    ///
    pub def nextFloat64(ran: Random[r]): Float64 & r =
        import java.util.Random.nextDouble(): Float64 & r;
        let Random(o) = ran;
        nextDouble(o)

    ///
    /// Returns the next pseudorandom 32-bit integer value from the given random number generator `r`.
    ///
    pub def nextInt32(ran: Random[r]): Int32 & r =
        import java.util.Random.nextInt(): Int32 & r;
        let Random(o) = ran;
        nextInt(o)

    ///
    /// Returns the next pseudorandom 64-bit integer value from the given random number generator `r`.
    ///
    pub def nextInt64(ran: Random[r]): Int64 & r =
        import java.util.Random.nextLong(): Int64 & r;
        let Random(o) = ran;
        nextLong(o)

    ///
    /// Returns the next pseudorandom Gaussian distributed 64-bit floating point number.
    ///
    pub def nextGaussian(ran: Random[r]): Float64 & r =
        import java.util.Random.nextGaussian(): Float64 & r;
        let Random(o) = ran;
        nextGaussian(o)

    ///
    /// Returns the next pseudorandom 32-bit integer value between `0` and `m` (exclusive) using the given random number generator `r`.
    ///
    pub def nextNatWithMax(ran: Random[r], m: Int32): Int32 & r =
        import java.util.Random.nextInt(Int32): Int32 & r;
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
