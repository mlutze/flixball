/// Keeps the log computational complexity of Set while removing
/// the `Order` constraint.
namespace HashMap {
    use Hash.hash
    use HashSet.HashSet

    /// invariants:
    /// <<A>> There are no mappings with empty lists
    /// <<B>> there are no duplicates in the lists
    pub opaque enum HashMap[k, v] with Eq, Hash {
        case HashMap(Map[Int32, List[(k, v)]])
    }

    pub def size(hm: HashMap[k, v]): Int32 =
        // uses invariant <<B>>
        unwrap(hm) |> Map.valuesOf |> List.sumWith(List.length)

    pub def empty(): HashMap[k, v] =
        HashMap(Map.empty())

    pub def insert(k: k, v: v, hm: HashMap[k, v]): HashMap[k, v] with Eq[k], Hash[k] =
        let hashK = hash(k);
        let HashMap(m) = hm;
        let newList = match Map.get(hashK, m) {
            case None => List.point((k, v))
            case Some(list) => listMapAdd(k, v, list)
        };
        HashMap(Map.insert(hashK, newList, m))

    pub def remove(x: k, hm: HashMap[k, v]): HashMap[k, v] with Eq[k], Hash[k] =
        let hashK = hash(x);
        let HashMap(m) = hm;
        match Map.get(hashK, m) {
            case None =>
                hm
            case Some(list) =>
                let newList = listMapRemove(x, list);
                if (List.isEmpty(newList)) {
                    // uphold invariant <<A>>
                    HashMap(Map.remove(hashK, m))
                } else {
                    HashMap(Map.insert(hashK, newList, m))
                }
        }

    pub def isEmpty(hm: HashMap[k, v]): Bool =
        // Uses invariant <<A>>
        unwrap(hm) |> Map.isEmpty

    pub def singleton(k: k, v: v): HashMap[k, v] with Eq[k], Hash[k]=
        HashMap(Map#{hash(k) => List.point((k, v))})

    // todo: range

    pub def get(k: k, hm: HashMap[k, v]): Option[v] with Eq[k], Hash[k] =
        let HashMap(m) = hm;
        let hashK = hash(k);
        match Map.get(hashK, m) {
            case None =>
                None
            case Some(list) =>
                list |> List.findMap(match (k0, v) ->
                    (k0 == k) |> Utils.boolMap(_ -> v)
                )
        }

    pub def getWithDefault(k: k, d: v, hm: HashMap[k, v]): v with Eq[k], Hash[k] =
        get(k, hm) |> Option.getWithDefault(d)
    
    pub def memberOf(k: k, hm: HashMap[k, v]): Bool with Eq[k], Hash[k] =
        let HashMap(m) = hm;
        let hashK = hash(k);
        match Map.get(hashK, m) {
            case None =>
                false
            case Some(list) =>
                List.exists(match (k0, _) -> k0 == k, list)
        }

    pub def keysOf(hm: HashMap[k, v]): HashSet[k] with Eq[k], Hash[k] =
        let HashMap(m) = hm;
        Map.valuesOf(m) |>
            List.flatten |>
            List.foldLeft(
                (acc, mapping) -> HashSet.insert(fst(mapping), acc),
                HashSet.empty()
            )

    pub def valuesOf(hm: HashMap[k, v]): List[v] =
        let HashMap(m) = hm;
        Map.valuesOf(m) |> List.flatMap(List.map(snd))
    
    pub def fromList(l: List[(k, v)]): HashMap[k, v] with Eq[k], Hash[k] =
        List.foldLeft(acc -> match (k, v) -> HashMap.insert(k, v, acc), HashMap.empty(), l)

    // filterWithKey, mapWithKey, unzip, toList, filter, filterMap

    // private

    /// Alternative to let-match
    def unwrap(hm: HashMap[k, v]): Map[Int32, List[(k, v)]] =
        let HashMap(m) = hm; m

    // Add mapping to list if key not present already, upholding <<A>>.
    // Might reorder elements
    def listMapAdd(k: k, v: v, c: List[(k, v)]): List[(k, v)] with Eq[k] =
        (k, v) :: listMapRemove(k, c)

    def listMapRemove(k: k, l: List[(k, v)]): List[(k, v)] with Eq[k] =
        // Could maybe use invariant <<B>> for a little performance
        // if a linked list like datastructure is used.
        List.filter(match (k0, _) -> k != k0, l)
    
}
