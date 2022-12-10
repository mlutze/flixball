namespace Utils {
    pub def |||>(triple: (a, b, c), f: (a, b, c) -> d): d = {
        let (a, b, c) = triple;
        f(a, b, c)
    }
    
    @Unsafe
    pub def dbg(x: a): a with ToString[a] = unsafe_cast {
        println(x);
        x
    } as _ \ {}
    
    @Unsafe
    pub def dbgMsg(msg: String, x: a): a with ToString[a] = unsafe_cast {
        println("${msg}: ${x}");
        x
    } as _ \ {}

    @Unsafe
    pub def dbgCond(msg: String, cond: a -> Bool \ ef, x: a): a \ ef with ToString[a] = {
        if (cond(x)) {
            unsafe_cast println("${msg}: ${x}") as _ \ ef;
            x
        } else x
    }

    @Unsafe
    pub def dbgAny(msg: String, cond: a -> Bool \ ef1, toStr: a -> String \ ef2, x: a): a \ {ef1, ef2} = {
        if (cond(x)) {
            unsafe_cast println("${msg}: ${toStr(x)}") as _ \ ef2;
            x
        } else x
    }

    namespace Option {
        @Unsafe
        pub def unsafeGet(o: Option[a]): a = match o {
            case None => ?unreachable
            case Some(v) => v
        }

        /// use `f` is `o` is `None`.
        pub def noneMap(f: Unit -> a \ ef, o: Option[a]): Option[a] \ ef = match o {
            case Some(v) => Some(v)
            case None => Some(f())
        }

        /// use `f` is `o` is `None`.
        pub def noneFlatMap(f: Unit -> Option[a] \ ef, o: Option[a]): Option[a] \ ef = match o {
            case Some(v) => Some(v)
            case None => f()
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

        pub def findMap(f: k -> v -> Option[a] \ ef, m: Map[k, v]): Option[a] \ ef = {
            use Utils/Option.noneFlatMap;
            Map.foldLeftWithKey((acc, k, v) -> noneFlatMap(_ -> f(k, v), acc), None, m)
        }
    }
}
