# Style and Design Conventions
This document lists style and design choices that are not already a convention
of Flix.

<!-- OBS: keep this updated and ordered when changing content -->
## Table of Contents
* [Style Conventions](#style-conventions)
    * [Record Syntax](#record-syntax)
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

--------------------------------------------------------------------------------

## Design Conventions
Conventions related to programming patterns and use of language features.