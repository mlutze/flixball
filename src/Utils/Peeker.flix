namespace Peeker {

    pub opaque enum Peeker[a: Type, r: Region](Ref[Option[Option[a]], r], Iterator[a, r])

    instance Scoped[Peeker[a]] {
        pub def regionOf(_: Peeker[a, r]): Region[r] = () as Region[r]
    }
    

    ///
    /// Builds a Peeker from the given Iterator.
    /// The given Iterator must not be reused.
    ///
    pub def fromIterator(iter: Iterator[a, r]): Peeker[a, r] \ {Read(r), Write(r)} = {
        let r = Scoped.regionOf(iter);
        Peeker(ref None @ r, iter)
    }

    ///
    /// Returns the first element in the iterator without consuming it.
    ///
    pub def peek(p: Peeker[a, r]): Option[a] \ {Read(r), Write(r)} = {
        let Peeker(hd, tl) = p;
        match deref hd {
            case None =>
                let res = Iterator.next(tl);
                hd := Some(res);
                res
            case Some(x) => x
        }
    }

    ///
    /// Builds an Iterator from the given Peeker.
    /// The given Peeker must not be reused.
    ///
    pub def toIterator(p: Peeker[a, r]): Iterator[a, r] \ {Read(r), Write(r)} = {
        let r = Scoped.regionOf(p);
        let Peeker(hd, tl) = p;
        match deref hd {
            case None => tl
            case Some(None) => tl
            case Some(Some(x)) => Iterator.append(Iterator.singleton(r, x), tl)
        }
    }
}