namespace Flixball/Main {
    use Flixball/Options.parse;
    use Flixball/Options.usage;
    use Flixball/Options.Action;
    use Flixball/Version.version;

    pub def main(): Unit \ Impure = {
        let args = Environment.getArgs();
        match parse(args) {
            case Action.Version => println(version())
            case Action.Help => println(usage())
            case Action.Run(_) => println("Run not implemented")
            case Action.Error => println(usage())
        }
    }
}