namespace TestNoise {

    @test
    def testBoolNoise2d01(): Bool = region r {
        let ans = Flixball/Noise.boolNoise2d(r, {width=5, height=4}, 512i64, 0.0);
        ans |> Array.forAll(Array.forAll(b -> b == false))
    }

    @test
    def testBoolNoise2d02(): Bool = region r {
        let ans = Flixball/Noise.boolNoise2d(r, {width=5, height=4}, 512i64, 1.0);
        ans |> Array.forAll(Array.forAll(b -> b == true))
    }
}