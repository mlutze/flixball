mod Flixball.Options {
    use GetOpt.{getOpt, usageInfo};
    use GetOpt.OptionDescr;
    use GetOpt.ArgDescr.{NoArg, ReqArg};
    use GetOpt.ArgOrder.Permute;

    use Action.{Error, Help, Replay, Run, Version}

    ///
    /// The action to run after parsing the arguments
    ///
    pub enum Action with Eq {
        case Error
        case Help
        case Replay(String, List[DisplayOption])
        case Run(List[RunOption], List[DisplayOption])
        case Version
    }

    ///
    /// Options to use for running Flixball
    ///
    pub enum RunOption with Eq {
        case Config(String)
        case Seed(Int64)
        case Quiet
        case Log(String)
    }

    ///
    /// Options for the display of the game.
    ///
    pub enum DisplayOption with Eq {
        case Dimensions(Int32, Int32)
        case Period(Int32)
    }

    ///
    /// Parses the given command line options.
    ///
    pub def parse(args: List[String]): Action = {
        match getOpt(Permute, options(), args) {
            case Validation.Success(flags) =>
                if (flags.nonOptions != Nil)
                    Error
                else
                    flagsToAction(flags.options)
            case Validation.Failure(_) => Error
        }
    }

    ///
    /// Returns the usage string.
    ///
    pub def usage(): String = {
        let header = "Usage: flixball [options]";
        usageInfo(header, options())
    }

    ///
    /// Flags passed in as command line arguments.
    ///
    enum Flag with Eq {
        case Config(String)
        case Dimensions(Int32, Int32)
        case Help
        case Log(String)
        case Period(Int32)
        case Quiet
        case Replay(String)
        case Seed(Int64)
        case Version
    }

    ///
    /// Flixball's command line options
    ///
    def options(): List[OptionDescr[Flag]] =
           {optionIds = 'c' :: Nil, optionNames = "config" :: Nil,      argDescriptor = ReqArg(config, "<path>"),               explanation = "uses a configuration file"}
        :: {optionIds = 'd' :: Nil, optionNames = "dimensions" :: Nil,  argDescriptor = ReqArg(dimensions, "<rows>x<cols>"),    explanation = "sets the dimensions of the display"}
        :: {optionIds = 'h' :: Nil, optionNames = "help" :: Nil,        argDescriptor = NoArg(Flag.Help),                       explanation = "prints this usage information"}
        :: {optionIds = 'l' :: Nil, optionNames = "log" :: Nil,         argDescriptor = ReqArg(log, "<path>"),                  explanation = "logs game states to a file"}
        :: {optionIds = 'p' :: Nil, optionNames = "period" :: Nil,      argDescriptor = ReqArg(period, "<period>"),             explanation = "sets the period each game state is shown (in milliseconds)"}
        :: {optionIds = 'q' :: Nil, optionNames = "quiet" :: Nil,       argDescriptor = NoArg(Flag.Quiet),                      explanation = "disables the display and only reports the winner"}
        :: {optionIds = 'r' :: Nil, optionNames = "replay" :: Nil,      argDescriptor = ReqArg(replay, "<path>"),               explanation = "replays a game from a log file"}
        :: {optionIds = 's' :: Nil, optionNames = "seed" :: Nil,        argDescriptor = ReqArg(seed, "<seed>"),                 explanation = "sets the seed for random operations"}
        :: {optionIds = 'v' :: Nil, optionNames = "version" :: Nil,     argDescriptor = NoArg(Flag.Version),                    explanation = "prints the version number"}
        :: Nil

    ///
    /// Parses a path to use for configuration.
    ///
    def config(path: String): Option[Flag] = Some(Flag.Config(path))

    ///
    /// Parses a pair of dimensions.
    ///
    def dimensions(d: String): Option[Flag] = {
        match String.splitOn(substr = "x", d) {
            case rows0 :: cols0 :: Nil => {
                forM (
                    rows <- Int32.fromString(rows0);
                    cols <- Int32.fromString(cols0)
                ) yield {
                    Flag.Dimensions(rows, cols)
                }
            }
            case _ => None
        }
    }

    ///
    /// Parses a path to use for logging.
    ///
    def log(path: String): Option[Flag] = Some(Flag.Log(path))

    ///
    /// Parses an integer for the period that frames are displayed.
    ///
    def period(i: String): Option[Flag] = Int32.fromString(i) |> Option.map(Flag.Period)

    ///
    /// Parses a path for replaying a game.
    ///
    def replay(path: String): Option[Flag] = Some(Flag.Replay(path))

    ///
    /// Parses an integer to use as the seed.
    ///
    def seed(i: String): Option[Flag] = Int64.fromString(i) |> Option.map(Flag.Seed)

    ///
    /// Converts the given list of flags to an action.
    ///
    def flagsToAction(flags: List[Flag]): Action = match flags {
        // override flags: Version and Help ignore the remaining options
        case Flag.Version :: _ => Action.Version
        case Flag.Help :: _ => Action.Help

        // display flags
        case Flag.Dimensions(rows, cols) :: tl => flagsToAction(tl) |> mapDisplay(opts -> DisplayOption.Dimensions(rows, cols) :: opts)
        case Flag.Period(period) :: tl => flagsToAction(tl) |> mapDisplay(opts -> DisplayOption.Period(period) :: opts)

        // run flags
        case Flag.Config(path) :: tl => flagsToAction(tl) |> mapRun(opts -> RunOption.Config(path) :: opts)
        case Flag.Log(path) :: tl => flagsToAction(tl) |> mapRun(opts -> RunOption.Log(path) :: opts)
        case Flag.Quiet :: tl => flagsToAction(tl) |> mapRun(opts -> RunOption.Quiet :: opts)
        case Flag.Seed(seed) :: tl => flagsToAction(tl) |> mapRun(opts -> RunOption.Seed(seed) :: opts)

        // action flags
        case Flag.Replay(path) :: tl => flagsToAction(tl) |> toReplay(path)

        case Nil => Action.Run(Nil, Nil)
    }

    ///
    /// Maps over the run options, leaving other options unchanged.
    ///
    def mapRun(f: List[RunOption] -> List[RunOption], a: Action): Action = match a {
        case Action.Error => Action.Error
        case Action.Help => Action.Help
        case Action.Replay(dispOpts) => Action.Replay(dispOpts)
        case Action.Run(runOpts, dispOpts) => Action.Run(f(runOpts), dispOpts)
        case Action.Version => Action.Version
    }

    ///
    /// Maps over the display options, leaving other options unchanged.
    ///
    def mapDisplay(f: List[DisplayOption] -> List[DisplayOption], a: Action): Action = match a {
        case Action.Error => Action.Error
        case Action.Help => Action.Help
        case Action.Replay(path, dispOpts) => Action.Replay(path, f(dispOpts))
        case Action.Run(runOpts, dispOpts) => Action.Run(runOpts, f(dispOpts))
        case Action.Version => Action.Version
    }

    ///
    /// Converts the action to a replay action, preserving display options.
    ///
    def toReplay(path: String, a: Action): Action = match a {
        case Action.Error => Action.Error
        case Action.Help => Action.Help
        case Action.Replay(_, dispOpts) => Action.Replay(path, dispOpts)
        case Action.Run(_, dispOpts) => Action.Replay(path, dispOpts)
        case Action.Version => Action.Version
    }

}
