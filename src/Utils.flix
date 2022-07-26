namespace Utils {
    pub def |||>(triple: (a, b, c), f: (a, b, c) -> d): d =
        let (a, b, c) = triple;
        f(a, b, c)
}