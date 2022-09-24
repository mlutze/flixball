/// Keeps the log computational complexity of Set while removing
/// the `Order` constraint.
namespace HashSet {
    use Hash.hash

    /// invariants:
    /// <<A>> There are no mappings with empty chains
    /// <<B>> there are no duplicates in the chains
    pub opaque enum HashSet[t] with Eq {
        case HashSet(Map[Int32, Chain[t]])
    }

    pub def size(s: HashSet[t]): Int32 =
        // uses invariant <<B>>
        unwrap(s) |> Map.valuesOf |> List.sumWith(Chain.length)

    pub def empty(): HashSet[t] =
        HashSet(Map.empty())

    pub def insert(x: t, s: HashSet[t]): HashSet[t] with Eq[t], Hash[t] =
        let hashX = hash(x);
        let HashSet(m) = s;
        let newChain = match Map.get(hashX, m) {
            case None => Chain.singleton(x)
            case Some(chain) => chainSetAdd(x, chain)
        };
        HashSet(Map.insert(hashX, newChain, m))

    pub def remove(x: t, s: HashSet[t]): HashSet[t] with Eq[t], Hash[t] =
        let hashX = hash(x);
        let HashSet(m) = s;
        match Map.get(hashX, m) {
            case None =>
                s
            case Some(chain) =>
                let newChain = chainSetRemove(x, chain);
                if (Chain.isEmpty(newChain)) {
                    // uphold invariant <<A>>
                    HashSet(Map.remove(hashX, m))
                } else {
                    HashSet(Map.insert(hashX, newChain, m))
                }
        }

    pub def isEmpty(s: HashSet[a]): Bool =
        // Uses invariant <<A>>
        unwrap(s) |> Map.isEmpty

    pub def singleton(x: t): HashSet[t] with Eq[t], Hash[t]=
        HashSet(Map#{hash(x) => Chain.singleton(x)})

    // todo: range

    pub def memberOf(x: t, s: HashSet[t]): Bool with Eq[t], Hash[t] =
        let HashSet(m) = s;
        let hashX = hash(x);
        match Map.get(hashX, m) {
            case None => false
            case Some(chain) => Chain.memberOf(x, chain)
        }

    // private

    /// Alternative to let-match
    def unwrap(s: HashSet[t]): Map[Int32, Chain[t]] =
        let HashSet(m) = s; m

    // Add element to chain if not present already, upholding <<A>>.
    // Might reorder elements
    def chainSetAdd(x: t, c: Chain[t]): Chain[t] with Eq[t] =
        chainSetRemove(x, c) |> Chain.cons(x)

    def chainSetRemove(x: t, c: Chain[t]): Chain[t] with Eq[t] =
        // Could use invariant <<B>> for a little performance.
        Chain.filter(y -> y != x, c)
    
}