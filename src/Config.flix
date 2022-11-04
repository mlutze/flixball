namespace Flixball/Config {
    use Flixball/Core.Strategy;
    use Flixball/Core/Board.Board;
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
    pub def read(json: String): Result[Config, String] = {
        use Result.flatMap;
        let* obj = Json/Parse.parse(json) |> Option.toOk("invalid JSON");
        fromJson(obj)
    }

    def fromJson(json: JsonElement): Result[Config, String] = {
        use Result.flatMap;
        let* o = asObject(".", json);
        let* mapJson = Map.get("map", o) |> Option.toOk("missing key 'map'");
        let* playersJson = Map.get("players", o) |> Option.toOk("missing key 'players'");
        let* map0 = readMap(mapJson);
        let* players = readPlayers(playersJson);
        // apply the map generator to the number of players
        let map = map0(List.length(players));
        Ok(Config(map, players))
    }


    def readMap(json: JsonElement): Result[(Int32, Int64) -> Board, String] = match json {
        case JsonObject(o) => {
            use Result.flatMap;
            let* id0 = Map.get("id", o) |> Option.toOk("missing key 'map.id'");
            let* id = asString(".map", id0);
            let data = Map.get("data", o);
            mkMap(id, data)
        }
        case _ => Err("non-object")
    }

    def readPlayers(json: JsonElement): Result[List[Strategy], String] = {
        use Result.flatMap;
        let* a = asArray(".players", json);
        Result.traverse(readPlayer, a)
    }

    def readPlayer(json: JsonElement): Result[Strategy, String] = {
        use Result.flatMap;
        let* o = asObject(".players[_]", json);
        let* id0 = Map.get("id", o) |> Option.toOk("missing key 'players[_].id'");
        let* id = asString(".players[_]", id0);
        let data = Map.get("data", o);
        mkPlayer(id, data)
    }

    ///
    /// Creates a map generating function from the ID and configuration data.
    ///
    def mkMap(id: String, data: Option[JsonElement]): Result[(Int32, Int64) -> Board, String] = match id {
        case "random" => match data {
            case Some(json) => {
                use Result.flatMap;
                let* o = asObject("map.data", json);
                let* rows0 = Map.get("rows", o) |> Option.toOk("missing key 'map.data.rows'");
                let* cols0 = Map.get("cols", o) |> Option.toOk("missing key 'map.data.cols'");
                let* density0 = Map.get("density", o) |> Option.toOk("missing key 'map.data.density'");
                let* rows = asInt("map.data.rows", rows0);
                let* cols = asInt("map.data.cols", cols0);
                let* density = asFloat("map.data.density", density0);
                Ok((numPlayers, seed) -> Flixball/BoardLibrary.randomBoard(seed, rows = rows, cols, density) |> Flixball/BoardLibrary.sprinklePlayers(seed, numPlayers))
            }
            case None => Err("missing key 'map.data'")
        }
        case unknownId => Err("unknown map ID ${unknownId}")
    }

    ///
    /// Creates a player from the ID and configuration data.
    ///
    def mkPlayer(id: String, _data: Option[JsonElement]): Result[Strategy, String] = match id {
        case "shoot" => Ok(Flixball/AiLibrary.shoot())
        case "wander" => Ok(Flixball/AiLibrary.wander())
        case "naive" => Ok(Flixball/AiLibrary.naiveSearchAndDestroy())
        case "smart" => Ok(Flixball/AiLibrary.smartSearchAndDestroy())
        case unknownId => Err("unknown player ID ${unknownId}")
    }

    def asArray(path: String, json: JsonElement): Result[List[JsonElement], String] = match json {
        case JsonArray(a) => Ok(a)
        case _ => Err("non-array at ${path}")
    }

    def asString(path: String, json: JsonElement): Result[String, String] = match json {
        case JsonString(s) => Ok(s)
        case _ => Err("non-string at ${path}")
    }

    def asInt(path: String, json: JsonElement): Result[Int32, String] = match json {
        case JsonNumber(i) => BigDecimal.tryToInt32(i) |> Option.toOk("non-float at ${path}")
        case _ => Err("non-int at ${path}")
    }

    def asFloat(path: String, json: JsonElement): Result[Float64, String] = match json {
        case JsonNumber(i) => BigDecimal.tryToFloat64(i) |> Option.toOk("non-float at ${path}")
        case _ => Err("non-float at ${path}")
    }

    def asObject(path: String, json: JsonElement): Result[Map[String, JsonElement], String] = match json {
        case JsonObject(m) => Ok(m)
        case _ => Err("non-object at ${path}")
    }
}