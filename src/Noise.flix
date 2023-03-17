namespace Flixball/Noise {

    pub type alias Grid[t: Type, r: Region] = Array[Array[t, r], r]

    pub type alias Dimensions = {width = Int32, height = Int32} 

    def createGrid(r: Region[r], f: (Int32, Int32) -> t \ ef, d: Dimensions): Grid[t, r] \ {Write(r), ef} = {
        use Array.init;
        init(r, x -> init(r, y -> f(x, y), d.height), d.width)
    }

    ///
    /// Returns a two-dimensional array of random values >= 0.
    ///
    pub def int32Noise2d(r: Region[r], d: Dimensions, seed: Int64): Grid[Int32, r] \ Write(r) = region r1 {
        use RegionedRandom.nextInt32;
        let rand = RegionedRandom.newWithSeed(r1, seed);
        createGrid(r, (_, _) -> Int32.abs(nextInt32(rand)), d)
    }

    ///
    /// boolean noise with `prob` probability of `true`.
    /// prob is between 0 and 1 inclusive.
    ///
    pub def boolNoise2d(r: Region[r], d: Dimensions, seed: Int64, prob: Float64): Grid[Bool, r] \ Write(r) = region r1 {
        use RegionedRandom.nextFloat64;
        let rand = RegionedRandom.newWithSeed(r1, seed);

        // sample function
        let clampedProb = prob |> Float64.min(1.0) |> Float64.max(0.0);
        def sample() = {
            let randPosFloat = nextFloat64(rand) |> Float64.abs;
            randPosFloat < clampedProb
        };
        createGrid(r, (_, _) -> sample(), d)
    }

    ///
    /// Cellular Automata Refinement.
    /// sensible defaults, prob=0.40, iterations=3
    ///
    pub def cellularGeneration(r: Region[r], d: Dimensions, seed: Int64, prob: Float64, iterations: Int32): Grid[Bool, r] \ Write(r) = region r1 {
        let floorToWallReq = 4;
        let wallToFloorReq = 3;

        let current = ref boolNoise2d(r, d, seed, prob) @ r1;
        let isWall = p -> (deref current) |> Utils.Array.unsafeNth(p.x) |> Utils.Array.unsafeNth(p.y);
        let swap = ref createGrid(r, (_, _) -> false, d) @ r1;
        // perform automation step in current, storing the result in swap,
        // and the swapping them.
        def simulationStep(iteration) = if (iteration <= 0) () else {
            foreach(
                (x, arr) <- Array.enumerator(r1, deref current) |> Iterator.toList; // TODO wasted traversal
                (y, _) <- Array.enumerator(r1, arr) |> Iterator.toList) // TODO wasted traversal
            {
                let p = {x = x, y = y};
                let nbh = mooreNeighborhood(p, d);
                let oob = 8 - List.length(nbh);
                let wallCount = nbh |> List.count(isWall);
                if (isWall(p)) {
                    // stays true/wall if there is enough nearby walls
                    // and vice versa
                    (deref swap) |> Utils.Array.unsafeNth(x) |> Array.put(oob+wallCount >= wallToFloorReq, y)
                } else {
                    // floor/false swaps to wall if there are enough nearby
                    // walls and vice versa
                    (deref swap) |> Utils.Array.unsafeNth(x) |> Array.put(oob+wallCount > floorToWallReq, y)
                }
            };
            let tmp = deref current;
            current := deref swap;
            swap := tmp;
            simulationStep(iteration-1)
        };
        simulationStep(iterations);
        deref current
    }

    def mooreNeighborhood(p: {x = Int32, y = Int32}, d: Dimensions): List[{x = Int32, y = Int32}] = {
        let inbound = px -> px.x >= 0 and px.x < d.width and px.y >= 0 and px.y < d.height;
        let self = px -> px.x == p.x and px.y == p.y;
        let offsets = List.range(-1, 2);
        offsets |> List.flatMap(xset ->
            offsets |> List.filterMap(yset -> {
                let nb = {x=p.x + xset, y=p.y + yset};
                if (inbound(nb) and not self(nb)) Some(nb) else None
            })
        )
    }
}
