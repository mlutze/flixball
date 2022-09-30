namespace Flixball/Main {
    use Flixball/Options.Action;
    use Flixball/Options.RunOption;
    use Flixball/Options.DisplayOption;
    use Flixball/Options.parse;
    use Flixball/Options.usage;
    use Flixball/Version.version;
    use Flixball/Config.Config;
    use Flixball/Config.{read => readConfig};

    pub def main(): Unit \ Impure = {
        let args = Environment.getArgs();
        match parse(args) {
            case Action.Version => println(version())
            case Action.Help => println(usage())
            case Action.Run(_) => println("Run not implemented")
            case Action.Replay(_) => println("Replay not implemented")
            case Action.Error => println(usage())
        }
    }

    def _mkRunConfig(runOpts: List[RunOption], dispOpts: List[DisplayOption]): Option[RunConfig] \ NonDet = {
        use Option.flatMap;
        let seed = runOpts
            |> List.findMap(x -> match x {
                case RunOption.Seed(s) => Some(s)
                case _ => None
            })
            |> Option.getWithDefault(Random.nextInt64(Random.new()));
        let* config = runOpts
            |> List.findMap(x -> match x {
                case RunOption.Config(c) =>
                    let* file = File.read(c) |> Result.toOption;
                    readConfig(file)
                case _ => None
            });
        let quiet = runOpts |> List.memberOf(RunOption.Quiet);
        let log = runOpts
            |> List.findMap(x -> match x {
                case RunOption.Log(l) => Some(l)
                case _ => None
            });
        let dimensions = dispOpts
            |> List.findMap(x -> match x {
                case DisplayOption.Dimensions(rows, cols) => Some((rows, cols))
                case _ => None
            })
            |> Option.getWithDefault(defaultDimensions());
        let period = dispOpts
            |> List.findMap(x -> match x {
                case DisplayOption.Period(ms) => Some(ms)
                case _ => None
            })
            |> Option.getWithDefault(1_000);
        Some({
            seed = seed,
            config = config,
            log = log,
            dimensions = dimensions,
            period = period,
            quiet = quiet
        })
    }

    type alias RunConfig = {
        seed = Int64,
        config = Config,
        quiet = Bool,
        log = Option[String],
        dimensions = (Int32, Int32),
        period = Int32
    }

    def defaultDimensions(): (Int32, Int32) = (24, 80)
}