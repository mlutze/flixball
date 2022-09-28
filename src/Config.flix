namespace Flixball/Config {
    use Flixball/Core.Strategy;
    use Flixball/Core/Board.Board;
    use Json.JsonElement.JsonArray;
    use Json.JsonElement.JsonObject;
    use Json.JsonElement;

    ///
    /// A run configuration holding a board and list of strategies.
    ///
    pub enum Config(Board, List[Strategy])

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
            ???
        }
        case _ => None
    }


    def readMap(json: JsonElement): Option[Board] = match json {
        case JsonObject(o) => {
            use Option.flatMap;
            let* id = Map.get("id", o);
            let* data = Map.get("data", o);
            ??? // delegate to map builders
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
            let* id = Map.get("id", o);
            let* data = Map.get("data", o);
            ??? // delegate to strategy builders
        }
        case _ => None
    }

}