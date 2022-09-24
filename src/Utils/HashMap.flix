/// Keeps the log computational complexity of Set while removing
/// the `Order` constraint.
namespace HashMap {
    use Hash.hash

    /// invariants:
    /// <<A>> There are no mappings with empty lists
    /// <<B>> there are no duplicates in the lists
    pub opaque enum HashMap[t] with Eq {
        case HashMap(Map[Int32, List[t]])
    }

    pub def size(s: HashMap[t]): Int32 =
        // uses invariant <<B>>
        unwrap(s) |> Map.valuesOf |> List.sumWith(List.length)

    pub def empty(): HashMap[t] =
        HashMap(Map.empty())

    pub def insert(x: t, s: HashMap[t]): HashMap[t] with Eq[t], Hash[t] =
        let hashX = hash(x);
        let HashMap(m) = s;
        let newList = match Map.get(hashX, m) {
            case None => List.point(x)
            case Some(list) => listSetAdd(x, list)
        };
        HashMap(Map.insert(hashX, newList, m))

    pub def remove(x: t, s: HashMap[t]): HashMap[t] with Eq[t], Hash[t] =
        let hashX = hash(x);
        let HashMap(m) = s;
        match Map.get(hashX, m) {
            case None =>
                s
            case Some(list) =>
                let newList = listSetRemove(x, list);
                if (List.isEmpty(newList)) {
                    // uphold invariant <<A>>
                    HashMap(Map.remove(hashX, m))
                } else {
                    HashMap(Map.insert(hashX, newList, m))
                }
        }

    pub def isEmpty(s: HashMap[a]): Bool =
        // Uses invariant <<A>>
        unwrap(s) |> Map.isEmpty

    pub def singleton(x: t): HashMap[t] with Eq[t], Hash[t]=
        HashMap(Map#{hash(x) => List.point(x)})

    // todo: range

    pub def memberOf(x: t, s: HashMap[t]): Bool with Eq[t], Hash[t] =
        let HashMap(m) = s;
        let hashX = hash(x);
        match Map.get(hashX, m) {
            case None => false
            case Some(list) => List.memberOf(x, list)
        }

    // private

    /// Alternative to let-match
    def unwrap(s: HashMap[t]): Map[Int32, List[t]] =
        let HashMap(m) = s; m

    // Add element to list if not present already, upholding <<A>>.
    // Might reorder elements
    def listSetAdd(x: t, c: List[t]): List[t] with Eq[t] =
        x :: listSetRemove(x, c)

    def listSetRemove(x: t, c: List[t]): List[t] with Eq[t] =
        // Could maybe use invariant <<B>> for a little performance
        // if a linked list like datastructure is used.
        List.filter(y -> y != x, c)
    
}