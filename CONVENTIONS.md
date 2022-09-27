# Style and Design Conventions
This document lists style and design choices that are not already a convention
of Flix.

<!-- OBS: keep this updated and ordered when changing content -->
## Table of Contents
* [Style Conventions](#style-conventions)
    * [Record Syntax](#record-syntax)
    * [Code Blocks](#code-blocks)
* [Design Conventions](#design-conventions)

--------------------------------------------------------------------------------

## Style Conventions
Conventions purely related to syntax and layout.

### Record Syntax
Records should be written without whitespace inside the curly-braces and with
whitespace around the '`=`' symbol. If line breaks are needed, put each field on
its own line. This holds for types and values.

### Examples
Record Values

```scala
{field1 = 32, field2 = "hello"}
```
```scala
{
    field1 = 32,
    field2 = "hello"
}
```
Record Types
```scala
{field1 = Int32, field2 = String}
```
```scala
{
    field1 = Int32,
    field2 = "String"
}
```

### Code Blocks
An expression must be enclosed in braces (`{...}`) when it contains:
* a binder (`let`/`def`/...),
* a statement (`...; ...`), or
* a `use` or `import`

Additionally, a multiline nested definition implementation must be wrapped in
braces. This helps with nicer parser errors and scanability.

### Examples
Defs
```scala
def add(x: Int32, y: Int32): Int32 =
    x + y
```
```scala
def add(x: Int32, y: Int32): Int32 = {
    let addToX = term -> term + x;
    addToX(y)
}
```
```scala
def add(x: Int32, y: Int32): Int32 = {
    def addOne(z) = z + 1;
    def subtractOne(z) = {
        z - 5 |>
            addOne |>
            addOne |>
            addOne |>
            addOne
    };
    x + y |> addOne |> subtractOne
}
```
```scala
def add(x: Int32, y: Int32): Int32 = {
    def addOne(z) = {
        let one = 1;
        let zed = z;
        zed + one;
    };
    def subtractOne(z) = {
        z - 5 |>
            addOne |>
            addOne |>
            addOne |>
            addOne
    };
    x + y |> addOne |> subtractOne
}
```
```scala
def add(x: Int32, y: Int32): Int32 =
    List.range(0, 13) |>
        List.map(Add.add(1)) |>
        List.find(PartialOrder.lessEqual(-13)) |>
        Option.getWithDefault(x+y)
```

Other
```scala
if (b)
    42 + 53 / 12
else {
    let a = 123 + 542353 * 2;
    let b = 12 / 555;
    a * b * (b + b)
}
```
```scala
List.range(0, k) |> List.map(e -> {
    let something = true;
    let otherThing = false;
    something or otherThing
})
```

--------------------------------------------------------------------------------

## Design Conventions
Conventions related to programming patterns and use of language features.