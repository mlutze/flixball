/// Keeps the log computational complexity of Set while removing
/// the `Order` constraint.
namespace HashSet {
    use Hash.hash

    /// invariants:
    /// <<A>> There are no mappings with empty lists
    /// <<B>> there are no duplicates in the lists
    pub opaque enum HashSet[t] with Eq {
        case HashSet(Map[Int32, List[t]])
    }

    pub def size(s: HashSet[t]): Int32 =
        // uses invariant <<B>>
        unwrap(s) |> Map.valuesOf |> List.sumWith(List.length)

    pub def empty(): HashSet[t] =
        HashSet(Map.empty())

    pub def insert(x: t, s: HashSet[t]): HashSet[t] with Eq[t], Hash[t] =
        let hashX = hash(x);
        let HashSet(m) = s;
        let newList = match Map.get(hashX, m) {
            case None => List.point(x)
            case Some(list) => listSetAdd(x, list)
        };
        HashSet(Map.insert(hashX, newList, m))

    pub def remove(x: t, s: HashSet[t]): HashSet[t] with Eq[t], Hash[t] =
        let hashX = hash(x);
        let HashSet(m) = s;
        match Map.get(hashX, m) {
            case None =>
                s
            case Some(list) =>
                let newList = listSetRemove(x, list);
                if (List.isEmpty(newList)) {
                    // uphold invariant <<A>>
                    HashSet(Map.remove(hashX, m))
                } else {
                    HashSet(Map.insert(hashX, newList, m))
                }
        }

    pub def isEmpty(s: HashSet[a]): Bool =
        // Uses invariant <<A>>
        unwrap(s) |> Map.isEmpty

    pub def singleton(x: t): HashSet[t] with Eq[t], Hash[t]=
        HashSet(Map#{hash(x) => List.point(x)})

    // todo: range

    pub def memberOf(x: t, s: HashSet[t]): Bool with Eq[t], Hash[t] =
        let HashSet(m) = s;
        let hashX = hash(x);
        match Map.get(hashX, m) {
            case None => false
            case Some(list) => List.memberOf(x, list)
        }

    // private

    /// Alternative to let-match
    def unwrap(s: HashSet[t]): Map[Int32, List[t]] =
        let HashSet(m) = s; m

    // Add element to list if not present already, upholding <<A>>.
    // Might reorder elements
    def listSetAdd(x: t, c: List[t]): List[t] with Eq[t] =
        x :: listSetRemove(x, c)

    def listSetRemove(x: t, c: List[t]): List[t] with Eq[t] =
        // Could maybe use invariant <<B>> for a little performance
        // if a linked list like datastructure is used.
        List.filter(y -> y != x, c)
    
}
