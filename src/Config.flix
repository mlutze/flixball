namespace Flixball/Config {
    use Flixball/Core.Strategy;
    use Flixball/Core/Board.Board;
    use Json/FromJson.fromJsonAt;
    use Json.FromJson;
    use Json.JsonElement.JsonArray;
    use Json.JsonElement.JsonNumber;
    use Json.JsonElement.JsonObject;
    use Json.JsonElement.JsonString;
    use Json.JsonElement;
    use Json.JsonError;
    use Json.JsonError.JsonError;
    use Json.getAtKey;
    use Json/FromJson.fromJson;
    use Json/Path.Path;
    use Json/Path.{!!};

    ///
    /// A run configuration holding a board generator and list of strategies.
    ///
    pub enum Config(Int64 -> Board, List[Strategy])

    ///
    /// Builds a board from a number of players and a seed.
    ///
    enum BoardGen((Int32, Int64) -> Board)

    pub enum NamedStrategy(StrategyId, Strategy)

    enum MapId {
        case Random
    }

    enum StrategyId {
        case Shoot
        case Wander
        case Naive
        case Smart
    }

    ///
    /// Reads the run configuration from a JSON string.
    ///
    pub def read(json: String): Result[Config, String] = {
        use Result.flatMap;
        let* obj = Json/Parse.parse(json) |> Option.toOk("invalid JSON");
        fromJson(obj) |> Result.mapErr(match JsonError(path, opts) -> "Error at ${path}. Expected one of: ${opts}")
    }

    instance FromJson[Config] {
        pub def fromJsonAt(p: Path, x: JsonElement): Result[Config, JsonError] = {
            use Result.flatMap;
            let* obj = fromJsonAt(p, x);
            let* BoardGen(fromPlayers) = getAtKey(p, "map", obj);
            let* players = getAtKey(p, "players", obj);
            let strats = players |> List.map(match NamedStrategy(_, strat) -> strat);
            let boardGen = fromPlayers(List.length(players));
            Ok(Config(boardGen, strats))
        }
    }

    instance FromJson[BoardGen] {
        pub def fromJsonAt(p: Path, x: JsonElement): Result[BoardGen, JsonError] = {
            use Result.flatMap;
            let* o = fromJsonAt(p, x);
            let* id = getAtKey(p, "id", o);
            match id {
                case Random => {
                    let* data = getAtKey(p, "data", o);
                    let* obj = fromJsonAt(p, data);
                    let* rows = getAtKey(p, "rows", obj);
                    let* cols = getAtKey(p, "cols", obj);
                    let* density = getAtKey(p, "density", obj);
                    Ok(BoardGen((numPlayers, seed) -> Flixball/BoardLibrary.randomBoard(seed, rows = rows, cols, density) |> Flixball/BoardLibrary.sprinklePlayers(seed, numPlayers)))
                }
            }
        }
    }


    instance FromJson[MapId] {
        pub def fromJsonAt(p: Path, x: JsonElement): Result[MapId, JsonError] = {
            use Result.flatMap;
            let* name = fromJsonAt(p, x);
            let map = Map#{
                "random" => Random
            };
            match Map.get(name, map) {
                case Some(s) => Ok(s)
                case None => Err(JsonError(p, Map.keysOf(map)))
            }
        }
    }

    instance FromJson[StrategyId] {
        pub def fromJsonAt(p: Path, x: JsonElement): Result[StrategyId, JsonError] = {
            use Result.flatMap;
            let* name = fromJsonAt(p, x);
            let map = Map#{
                "shoot" => Shoot,
                "wander" => Wander,
                "naive" => Naive,
                "smart" => Smart
            };
            match Map.get(name, map) {
                case Some(s) => Ok(s)
                case None => Err(JsonError(p, Map.keysOf(map)))
            }
        }
    }

    instance FromJson[NamedStrategy] {
        pub def fromJsonAt(p: Path, x: JsonElement): Result[NamedStrategy, JsonError] = {
            use Result.flatMap;
            let* obj = fromJsonAt(p, x);
            let* id = getAtKey(p, "id", obj);
            let strat = match id {
                case Shoot => Flixball/AiLibrary.shoot()
                case Wander => Flixball/AiLibrary.wander()
                case Naive => Flixball/AiLibrary.naiveSearchAndDestroy()
                case Smart => Flixball/AiLibrary.smartSearchAndDestroy()
            };
            Ok(NamedStrategy(id, strat))
        }
    }
}