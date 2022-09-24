namespace Utils {
    pub def |||>(triple: (a, b, c), f: (a, b, c) -> d): d =
        let (a, b, c) = triple;
        f(a, b, c)
    
    @Unsafe
    pub def dbg(x: a): a with ToString[a] = {
        println(x);
        x
    } as \ {}
    
    @Unsafe
    pub def dbgMsg(msg: String, x: a): a with ToString[a] = {
        println("${msg}: ${x}");
        x
    } as \ {}

    @Unsafe
    pub def dbgCond(msg: String, cond: a -> Bool \ ef, x: a): a \ ef with ToString[a] = {
        if (cond(x)) {
            println("${msg}: ${x}") as \ ef;
            x
        } else x
    }

    @Unsafe
    pub def dbgAny(msg: String, cond: a -> Bool \ ef1, toStr: a -> String \ ef2, x: a): a \ {ef1, ef2} = {
        if (cond(x)) {
            println("${msg}: ${toStr(x)}") as \ ef2;
            x
        } else x
    }

    /// Returns `Some(f())` if `b == true`, otherwise `None`. 
    pub def boolMap(f: Unit -> t \ ef, b: Bool): Option[t] \ ef =
        if (b) Some(f()) else None

    namespace Option {
        @Unsafe
        pub def unsafeGet(o: Option[a]): a = match o {
            case None => ?unreachable
            case Some(v) => v
        }
    }

    namespace Map {
        pub def unzip(m: Map[k, (v1, v2)]): (Map[k, v1], Map[k, v2]) with Order[k] = region r {
            let m1 = new MutMap(r);
            let m2 = new MutMap(r);
            foreach((k, (v1, v2)) <- Map.iterator(r, m)) {
                MutMap.put!(k, v1, m1);
                MutMap.put!(k, v2, m2)
            };
            (MutMap.toMap(m1), MutMap.toMap(m2))
        }
    }
}
