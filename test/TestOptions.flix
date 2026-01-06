mod TestOptions {
    use Flixball.Options.parse;
    use Flixball.Options.Action;
    use Flixball.Options.RunOption;

    @Test
    def testEmpty(): Bool = {
        let input = Nil;
        parse(input) == Action.Run(Nil, Nil)
    }

    @Test
    def testRunWithConfig(): Bool = {
        let input = "--config" :: "flixball.cfg" :: Nil;
        parse(input) == Action.Run(RunOption.Config("flixball.cfg") :: Nil, Nil)
    }

    @Test
    def testRunWithSeed(): Bool = {
        let input = "--seed" :: "12345" :: Nil;
        parse(input) == Action.Run(RunOption.Seed(12345i64) :: Nil, Nil)
    }

    @Test
    def testVersion(): Bool = {
        let input = "--version" :: Nil;
        parse(input) == Action.Version
    }

    @Test
    def testHelp(): Bool = {
        let input = "--help" :: Nil;
        parse(input) == Action.Help
    }

}