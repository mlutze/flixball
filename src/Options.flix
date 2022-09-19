namespace Flixball/Options {
    use GetOpt.{getOpt, usageInfo};
    use GetOpt.OptionDescr;
    use GetOpt.ArgDescr.{NoArg, ReqArg};
    use GetOpt.ArgOrder.Permute;

    ///
    /// The action to run after parsing the arguments
    ///
    pub enum Action with Eq {
        case Version
        case Help
        case Error
        case Run(List[RunOption])
    }

    ///
    /// Options to use for running Flixball
    ///
    pub enum RunOption with Eq {
        case Config(String)
        case Seed(Int64)
    }

    ///
    /// Parses the given command line options.
    ///
    pub def parse(args: List[String]): Action = {
        match getOpt(Permute, options(), args) {
            case Success(flags) =>
                if (flags.nonOptions != Nil) {
                    Error
                } else {
                    flagsToAction(flags.options)
                }
            case Failure(_) => Error
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
        case Version
        case Help
        case Config(String)
        case Seed(Int64)
    }

    ///
    /// Flixball's command line options
    ///
    def options(): List[OptionDescr[Flag]] =
           {optionIds = 'v' :: Nil, optionNames = "version" :: Nil, argDescriptor = NoArg(Flag.Version),        explanation = "prints the version number"}
        :: {optionIds = 'h' :: Nil, optionNames = "help" :: Nil,    argDescriptor = NoArg(Flag.Help),           explanation = "prints this usage information"}
        :: {optionIds = 'c' :: Nil, optionNames = "config" :: Nil,  argDescriptor = ReqArg(config, "<path>"),   explanation = "uses a configuration file"}
        :: {optionIds = 's' :: Nil, optionNames = "seed" :: Nil,    argDescriptor = ReqArg(seed, "<seed>"),     explanation = "sets the seed for random operations"}
        :: Nil

    ///
    /// Parses a path to use for configuration.
    ///
    def config(path: String): Option[Flag] = Some(Flag.Config(path))

    ///
    /// Parses an integer to use as the seed.
    ///
    def seed(i: String): Option[Flag] = Int64.fromString(i) |> Option.map(Flag.Seed)

    ///
    /// Converts the given list of flags to an action.
    ///
    def flagsToAction(flags: List[Flag]): Action = match flags {
        case Flag.Version :: _ => Action.Version
        case Flag.Help :: _ => Action.Help
        case Flag.Config(path) :: tl => flagsToAction(tl) |> mapRun(opts -> RunOption.Config(path) :: opts)
        case Flag.Seed(seed) :: tl => flagsToAction(tl) |> mapRun(opts -> RunOption.Seed(seed) :: opts)
        case Nil => Action.Run(Nil)
    }

    ///
    /// Maps over the Run action, leaving other actions unchanged.
    ///
    def mapRun(f: List[RunOption] -> List[RunOption], a: Action): Action = match a {
        case Action.Version => Action.Version
        case Action.Help => Action.Help
        case Action.Error => Action.Error
        case Action.Run(opts) => Action.Run(f(opts))
    }

}