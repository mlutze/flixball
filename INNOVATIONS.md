# Innovations

Flixball serves as a testbed for the Flix programming language.
Below are a few innovations either conceived for use with Flixball
or primarily explored in the Flixball repository.

## ANSI Terminal API

Flixball uses ANSI terminal codes to display the game on the screen.
The ANSI terminal API was originally directly a part of the Flixball implementation.
It is now an independent library at [JonathanStarup/Flix-ANSI-Terminal](https://github.com/JonathanStarup/Flix-ANSI-Terminal).

## Regioned Random

Flixball requires purely-generated pseudorandom numbers.
In order for Flix to understand that the seeded pseudorandom number generation is not (from the outside) effectful,
we keep the `Random` object in a region.
This idea was originally explored by [JonathanStarup](https://github.com/JonathanStarup/) and is currently incorporated into the Flixball codebase.

## Hash-based collections

In the Flix standard library, sorted sets and maps are the standard.
In Flixball, we are exploring the use of hashsets and hashmaps as the standard, to eliminate the dependency on the `Order` type class.

## Hall of Bugs
Bugs found through flixball (newest at the top)
* 22, Oct 14 - [Record restriction is a mutating operation](https://github.com/flix/flix/issues/4704)
* 22, Aug 09 - [bug using `let _ =` in entrypoint](https://github.com/flix/flix/issues/4440)
* 22, Jun 15 - [use does not allow whitespace before initial multiuse](https://github.com/flix/flix/issues/3975)