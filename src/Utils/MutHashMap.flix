/// Keeps the log computational complexity of Set while removing
/// the `Order` constraint.
namespace MutHashMap {
    use Hash.hash
    use HashSet.HashSet

    /// invariants:
    /// <<A>> There are no mappings with empty lists
    /// <<B>> there are no duplicates in the lists
    pub opaque enum MutHashMap[k: Type, v: Type, r: Region] {
        case MutHashMap(MutMap[Int32, MutList[(k, v), r], r])
    }

    instance Newable[MutHashMap[k, v]] {
        pub def new(r: Region[r]): MutHashMap[k, v, r] & r = MutHashMap.new(r)
    }

    instance Scoped[MutHashMap[k, v]] {
        pub def regionOf(_: MutHashMap[k, v, r]): Region[r] = () as Region[r]
    }

    pub def size(hm: MutHashMap[k, v, r]): Int32 \ Read(r) =
        // uses invariant <<B>>
        unwrap(hm) |> MutMap.valuesOf |> List.sumWith(MutList.length)

    pub def new(r: Region[r]): MutHashMap[k, v, r] \ Write(r) =
        MutHashMap(MutMap.new(r))

    pub def put!(k: k, v: v, hm: MutHashMap[k, v, r]): Unit \ {Read(r), Write(r)} with Eq[k], Hash[k] =
        let hashK = hash(k);
        let MutHashMap(m) = hm;
        let r = Scoped.regionOf(hm);
        match MutMap.get(hashK, m) {
            case None => MutMap.put!(hashK, Utils/MutList.point(r, (k, v)), m)
            case Some(list) => mutListMapAdd!(k, v, list)
        }

    pub def remove!(x: k, hm: MutHashMap[k, v, r]): Unit \ {Read(r), Write(r)} with Eq[k], Hash[k] =
        let hashK = hash(x);
        let MutHashMap(m) = hm;
        match MutMap.get(hashK, m) {
            case None =>
                ()
            case Some(list) =>
                mutListMapRemove!(x, list);
                // uphold invariant <<A>>
                MutList.isEmpty(list) |>
                    Utils.boolForeach(_ -> MutMap.remove!(hashK, m))
        }

    pub def isEmpty(hm: MutHashMap[k, v, r]): Bool \ Read(r) =
        // Uses invariant <<A>>
        unwrap(hm) |> MutMap.isEmpty

    pub def singleton(r: Region[r], k: k, v: v): MutHashMap[k, v, r] \ Write(r) with Eq[k], Hash[k] =
        MutHashMap(MutMap.singleton(r, hash(k), Utils/MutList.point(r, (k, v))))

    // todo: range

    pub def get(k: k, hm: MutHashMap[k, v, r]): Option[v] \ Read(r) with Eq[k], Hash[k] =
        let MutHashMap(m) = hm;
        let hashK = hash(k);
        match MutMap.get(hashK, m) {
            case None =>
                None
            case Some(list) =>
                list |>
                    MutList.find(match (k0, _) -> (k0 == k)) |>
                    Option.map(snd)
        }

    pub def getWithDefault(k: k, d: v, hm: MutHashMap[k, v, r]): v \ Read(r) with Eq[k], Hash[k] =
        get(k, hm) |> Option.getWithDefault(d)
    
    pub def memberOf(k: k, hm: MutHashMap[k, v, r]): Bool \ Read(r) with Eq[k], Hash[k] =
        let MutHashMap(m) = hm;
        let hashK = hash(k);
        match MutMap.get(hashK, m) {
            case None =>
                false
            case Some(list) =>
                MutList.exists(match (k0, _) -> k0 == k, list)
        }

    pub def keysOf(hm: MutHashMap[k, v, r]): HashSet[k] \ Read(r) with Eq[k], Hash[k] =
        let MutHashMap(m) = hm;
        MutMap.valuesOf(m) |>
            List.map(MutList.toList) |>
            List.flatten |>
            List.foldLeft(
                (acc, mapping) -> HashSet.insert(fst(mapping), acc),
                HashSet.empty()
            )

    pub def valuesOf(hm: MutHashMap[k, v, r]): List[v] \ Read(r) =
        let MutHashMap(m) = hm;
        MutMap.valuesOf(m) |> List.flatMap(ml -> ml |> MutList.toList |> List.map(snd))

    // filterWithKey, mapWithKey, unzip, toList, filter, filterMap

    // private

    /// Alternative to let-match
    def unwrap(hm: MutHashMap[k, v, r]): MutMap[Int32, MutList[(k, v), r], r] =
        let MutHashMap(m) = hm; m

    // Add mapping to list if key not present already, upholding <<A>>.
    // Might reorder elements
    def mutListMapAdd!(k: k, v: v, l: MutList[(k, v), r]): Unit \ Write(r) with Eq[k] =
        mutListMapRemove!(k, l);
        MutList.push!((k, v), l)

    def mutListMapRemove!(k: k, l: MutList[(k, v), r]): Unit \ {Read(r), Write(r)} with Eq[k] =
        // Could maybe use invariant <<B>> for a little performance
        // if a linked list like datastructure is used.
        MutList.retain!(match (k0, _) -> k != k0, l)
    
}
