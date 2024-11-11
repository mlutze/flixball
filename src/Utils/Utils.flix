mod Utils {
    pub def |||>(triple: (a, b, c), f: (a, b, c) -> d): d = {
        let (a, b, c) = triple;
        f(a, b, c)
    }

    mod Option {
        // @Unsafe
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

    mod Map {

        pub def unzip(m: Map[k, (v1, v2)]): (Map[k, v1], Map[k, v2]) with Order[k] = region r {
            let m1 = MutMap.empty(r);
            let m2 = MutMap.empty(r);
            foreach((k, (v1, v2)) <- m |> Map.toList) { // TODO wasted traversal
                MutMap.put(k, v1, m1);
                MutMap.put(k, v2, m2)
            };
            (MutMap.toMap(m1), MutMap.toMap(m2))
        }

        pub def findMap(f: k -> v -> Option[a] \ ef, m: Map[k, v]): Option[a] \ ef = {
            use Utils.Option.noneFlatMap;
            Map.foldLeftWithKey((acc, k, v) -> noneFlatMap(_ -> f(k, v), acc), None, m)
        }
    }

    mod Array {

        import java.util.Random

        // @Unsafe
        pub def unsafeNth(n: Int32, x: Array[a, r]): a \ r = {
            Array.nth(n, x) |> Utils.Option.unsafeGet
        }

        ///
        /// Shuffles `a` using the Fisher–Yates shuffle.
        ///
        pub def shuffle(r: Random, a: Array[a, r]): Unit \ r + IO = {
            let len = Array.length(a);
            def loop(i) = {
                if (i > 0) {
                    let j = r.nextInt(i + 1);
                    Array.swap(i, j, a);
                    loop(i - 1)
                }
                else
                    ()
            };
            loop(len - 1)
        }

    }
}
