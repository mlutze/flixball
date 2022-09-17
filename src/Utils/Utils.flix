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

    namespace Option {
        pub def unsafeGet(o: Option[a]): a = match o {
            case None => ?unreachable
            case Some(v) => v
        }
    }
}
