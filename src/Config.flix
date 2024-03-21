mod Flixball.Config {
    use Flixball.Core.Strategy;
    use Flixball.Core.Board.Board;
    use Json.JsonElement.JsonArray;
    use Json.JsonElement.JsonObject;
    use Json.JsonElement.JsonNumber;
    use Json.JsonElement.JsonString;
    use Json.JsonElement;

    ///
    /// A run configuration holding a board and list of strategies.
    ///
    pub enum Config(Int64 -> Board, List[Strategy])

    ///
    /// Reads the run configuration from a JSON string.
    ///
    pub def read(json: String): Result[String, Config] = {
        forM (
            obj <- Json.Parse.parse(json) |> Option.toOk("invalid JSON");
            res <- fromJson(obj)
        ) yield {
            res
        }
    }

    def fromJson(json: JsonElement): Result[String, Config] = {
        forM (
            o <- asObject(".", json);
            mapJson <- Map.get("map", o) |> Option.toOk("missing key 'map'");
            playersJson <- Map.get("players", o) |> Option.toOk("missing key 'players'");
            map0 <- readMap(mapJson);
            players <- readPlayers(playersJson)
        ) yield {
            // apply the map generator to the number of players
            let map = map0(List.length(players));
            Config.Config(map, players)
        }
    }


    def readMap(json: JsonElement): Result[String, (Int32, Int64) -> Board] = match json {
        case JsonObject(o) => {
            forM (
                id0 <- Map.get("id", o) |> Option.toOk("missing key 'map.id'");
                id <- asString(".map", id0);
                data <- Map.get("data", o) |> Ok;
                res <- mkMap(id, data)
            ) yield res
        }
        case _ => Err("non-object")
    }

    def readPlayers(json: JsonElement): Result[String, List[Strategy]] = {
        forM (
            a <- asArray(".players", json);
            res <- Result.traverse(readPlayer, a)
        ) yield {
            res
        }
    }

    def readPlayer(json: JsonElement): Result[String, Strategy] = {
        forM (
            o <- asObject(".players[_]", json);
            id0 <- Map.get("id", o) |> Option.toOk("missing key 'players[_].id'");
            id <- asString(".players[_]", id0);
            data <- Map.get("data", o) |> Ok;
            res <- mkPlayer(id, data)
        ) yield {
            res
        }
    }

    ///
    /// Creates a map generating function from the ID and configuration data.
    ///
    def mkMap(id: String, data: Option[JsonElement]): Result[String, (Int32, Int64) -> Board] = match id {
        case "random" => match data {
            case Some(json) => {
                forM (
                o <- asObject("map.data", json);
                rows0 <- Map.get("rows", o) |> Option.toOk("missing key 'map.data.rows'");
                cols0 <- Map.get("cols", o) |> Option.toOk("missing key 'map.data.cols'");
                density0 <- Map.get("density", o) |> Option.toOk("missing key 'map.data.density'");
                rows <- asInt("map.data.rows", rows0);
                cols <- asInt("map.data.cols", cols0);
                density <- asFloat("map.data.density", density0)
                ) yield {
                    (numPlayers, seed) -> Flixball.BoardLibrary.randomBoard(seed, rows = rows, cols, density) |> Flixball.BoardLibrary.sprinklePlayers(seed, numPlayers)
                }
            }
            case None => Err("missing key 'map.data'")
        }
        case unknownId => Err("unknown map ID ${unknownId}")
    }

    ///
    /// Creates a player from the ID and configuration data.
    ///
    def mkPlayer(id: String, _data: Option[JsonElement]): Result[String, Strategy] = match id {
        case "shoot" => Ok(Flixball.AiLibrary.shoot())
        case "wander" => Ok(Flixball.AiLibrary.wander())
        case "naive" => Ok(Flixball.AiLibrary.naiveSearchAndDestroy())
        case "smart" => Ok(Flixball.AiLibrary.smartSearchAndDestroy())
        case unknownId => Err("unknown player ID ${unknownId}")
    }

    def asArray(path: String, json: JsonElement): Result[String, List[JsonElement]] = match json {
        case JsonArray(a) => Ok(a)
        case _ => Err("non-array at ${path}")
    }

    def asString(path: String, json: JsonElement): Result[String, String] = match json {
        case JsonString(s) => Ok(s)
        case _ => Err("non-string at ${path}")
    }

    def asInt(path: String, json: JsonElement): Result[String, Int32] = match json {
        case JsonNumber(i) => BigDecimal.tryToInt32(i) |> Option.toOk("non-float at ${path}")
        case _ => Err("non-int at ${path}")
    }

    def asFloat(path: String, json: JsonElement): Result[String, Float64] = match json {
        case JsonNumber(i) => BigDecimal.tryToFloat64(i) |> Option.toOk("non-float at ${path}")
        case _ => Err("non-float at ${path}")
    }

    def asObject(path: String, json: JsonElement): Result[String, Map[String, JsonElement]] = match json {
        case JsonObject(m) => Ok(m)
        case _ => Err("non-object at ${path}")
    }
}
