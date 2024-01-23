
pub def main(): Unit \ IO = Flixball.Main.main()

mod Flixball.Main {
    use Flixball.Config.{read => readConfig}
    use Flixball.Config.Config
    use Flixball.Config.Config.Config
    use Flixball.Core.GameState.{board => gsBoard}
    use Flixball.Options.Action
    use Flixball.Options.DisplayOption
    use Flixball.Options.parse
    use Flixball.Options.RunOption
    use Flixball.Options.usage
    use Flixball.Version.version

    pub def main(): Unit \ IO = {
        let args = Environment.getArgs();
        match parse(args) {
            case Action.Version => println(version())
            case Action.Help => println(usage())
            case Action.Run(runOpts, dispOpts) => 
                match mkRunConfig(runOpts, dispOpts) {
                    case Ok(config) => run(config)
                    case Err(s) => println("Error: ${s}")
                }
            case Action.Replay(_) => println("Replay not implemented")
            case Action.Error => println(usage())
        }
    }

    def run(config: RunConfig): Unit \ IO = {
        import static java.lang.Thread.sleep(Int64): Unit \ IO;
        let Config(mkBoard, strats) = config.config;
        let stratMap = strats
            |> List.zipWithIndex
            |> List.toMap;
        let gs0 = Flixball.Core.GameState.mkGameState(config.seed, stratMap, mkBoard(config.seed));
        region r {
            let stream = Flixball.Engine.runGame(r, gs0);
            stream |> Iterator.forEach(gs -> {
                Flixball.Display.displayBoard(gsBoard(gs));
                sleep(config.period |> Int32.toInt64)
            })
        }
    }

    def mkRunConfig(runOpts: List[RunOption], dispOpts: List[DisplayOption]): Result[String, RunConfig] \ IO = {
        use Result.flatMap;
        let seed = runOpts
            |> List.findMap(x -> match x {
                case RunOption.Seed(s) => Some(s)
                case _ => None
            })
            |> Option.getWithDefault(Random.nextInt64(Random.new()));
        for (
            configPath <- runOpts
                |> List.findMap(x -> match x {
                    case RunOption.Config(c) => Some(c)
                    case _ => None
                })
                |> Option.toOk("missing config");
            file <- Files.read(configPath) |> Result.mapErr(ToString.toString);
            config <- readConfig(file)
        ) yield {
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
            {
                seed = seed,
                config = config,
                log = log,
                dimensions = dimensions,
                period = period,
                quiet = quiet
            }
        }
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