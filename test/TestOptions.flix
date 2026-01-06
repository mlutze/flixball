mod TestOptions {
    use Flixball.Options.parse;
    use Flixball.Options.Action;
    use Flixball.Options.RunOption;

    @Test
    def testEmpty(): Unit \ Assert = {
        let input = Nil;
        if (parse(input) == Action.Run(Nil, Nil))
            ()
        else
            Assert.fail("expected Action.Run(Nil, Nil)")
    }

    @Test
    def testRunWithConfig(): Unit \ Assert = {
        let input = "--config" :: "flixball.cfg" :: Nil;
        if (parse(input) == Action.Run(RunOption.Config("flixball.cfg") :: Nil, Nil))
            ()
        else
            Assert.fail("expected Action.Run with Config")
    }

    @Test
    def testRunWithSeed(): Unit \ Assert = {
        let input = "--seed" :: "12345" :: Nil;
        if (parse(input) == Action.Run(RunOption.Seed(12345i64) :: Nil, Nil))
            ()
        else
            Assert.fail("expected Action.Run with Seed")
    }

    @Test
    def testVersion(): Unit \ Assert = {
        let input = "--version" :: Nil;
        if (parse(input) == Action.Version)
            ()
        else
            Assert.fail("expected Action.Version")
    }

    @Test
    def testHelp(): Unit \ Assert = {
        let input = "--help" :: Nil;
        if (parse(input) == Action.Help)
            ()
        else
            Assert.fail("expected Action.Help")
    }

}