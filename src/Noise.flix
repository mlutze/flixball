namespace Flixball/Noise {

    ///
    /// Returns a two-dimensional array of random values >= 0.
    ///
    pub def noise2d(r: Region[r], width: {width::Int32}, height: {height::Int32}, seed: Int64): Array[Array[Int32, r], r] \ r = region r1 {
        let w = width.width; let h = height.height;
        // avoid r1 being unused
        let _ = r1;
        // This is a safe cast to r since the call sequence to rand is fixed.
        let rand = Random.newWithSeed(seed) as \ r1;
        let nextInt = Random.nextInt32 as Random.Random -> Int32 \ r1;
        let arr = Array.init(r, _ -> Array.repeat(r, h, 0), w);
        foreach(
            x <- Iterator.range(r, 0, w);
            y <- Iterator.range(r, 0, h))
        {
            arr[x][y] = nextInt(rand) |> Int32.abs
        };
        arr
    }

}
