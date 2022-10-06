namespace Flixball/Config {
    use Flixball/Core.Strategy;
    use Flixball/Core/Board.Board;
    use Json.JsonElement.JsonArray;
    use Json.JsonElement.JsonObject;
    use Json.JsonElement.JsonInt;
    use Json.JsonElement.JsonFloat;
    use Json.JsonElement.JsonString;
    use Json.JsonElement;

    ///
    /// A run configuration holding a board and list of strategies.
    ///
    pub enum Config(Int64 -> Board, List[Strategy])

    ///
    /// Reads the run configuration from a JSON string.
    ///
    pub def read(json: String): Option[Config] = {
        use Option.flatMap;
        let* obj = Json/Parse.parse(json);
        fromJson(obj)
    }

    def fromJson(json: JsonElement): Option[Config] = match json {
        case JsonObject(o) => {
            use Option.flatMap;
            let* mapJson = Map.get("map", o);
            let* playersJson = Map.get("players", o);
            let* map = readMap(mapJson);
            let* players = readPlayers(playersJson);
            Some(Config(map, players))
        }
        case _ => None
    }


    def readMap(json: JsonElement): Option[Int64 -> Board] = match json {
        case JsonObject(o) => {
            use Option.flatMap;
            let* id0 = Map.get("id", o);
            let* id = asString(id0);
            let data = Map.get("data", o);
            mkMap(id, data)
        }
        case _ => None
    }

    def readPlayers(json: JsonElement): Option[List[Strategy]] = match json {
        case JsonArray(a) => Option.traverse(readPlayer, a)
        case _ => None
    }

    def readPlayer(json: JsonElement): Option[Strategy] = match json {
        case JsonObject(o) => {
            use Option.flatMap;
            let* id0 = Map.get("id", o);
            let* id = asString(id0);
            let data = Map.get("data", o);
            mkPlayer(id, data)
        }
        case _ => None
    }

    ///
    /// Creates a map generating function from the ID and configuration data.
    ///
    def mkMap(id: String, data: Option[JsonElement]): Option[Int64 -> Board] = match (id, data) {
        case ("random", Some(JsonObject(o))) => {
            use Option.flatMap;
            let* rows0 = Map.get("rows", o);
            let* cols0 = Map.get("cols", o);
            let* density0 = Map.get("density", o);
            let* rows = asInt(rows0);
            let* cols = asInt(cols0);
            let* density = asFloat(density0);
            Some(seed -> Flixball/Core/Board.randomBoard(seed, rows = rows, cols, density))
        }
        case _ => None
    }

    ///
    /// Creates a player from the ID and configuration data.
    ///
    def mkPlayer(id: String, _data: Option[JsonElement]): Option[Strategy] = match id {
        case "shoot" => Some(Flixball/AiLibrary.shoot())
        case _ => None
    }

    def asString(json: JsonElement): Option[String] = match json {
        case JsonString(s) => Some(s)
        case _ => None
    }

    def asInt(json: JsonElement): Option[Int32] = match json {
        case JsonInt(i) => Some(i)
        case _ => None
    }

    def asFloat(json: JsonElement): Option[Float64] = match json {
        case JsonFloat(i) => Some(i)
        case _ => None
    }
}