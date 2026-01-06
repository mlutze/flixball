mod TestNoise {

    @Test
    def testBoolNoise2d01(): Unit \ Assert = region r {
        let ans = Flixball.Noise.boolNoise2d(r, {width=5, height=4}, 512i64, 0.0);
        Assert.assertEq(expected = true, ans |> Array.forAll(Array.forAll(b -> b == false)))
    }

    @Test
    def testBoolNoise2d02(): Unit \ Assert = region r {
        let ans = Flixball.Noise.boolNoise2d(r, {width=5, height=4}, 512i64, 1.0);
        Assert.assertEq(expected = true, ans |> Array.forAll(Array.forAll(b -> b == true)))
    }
}