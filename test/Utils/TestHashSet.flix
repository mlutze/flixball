
// This file is taken from flix
// https://github.com/flix/flix/blob/master/main/test/ca/uwaterloo/flix/library/TestSet.flix

/*
 * Copyright 2017 Liam Palmer
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

namespace TestHashSet {
    use Hash.hash
    use HashSet.empty
    use HashSet.fromList
    use HashSet.HashSet
    use HashSet.singleton
    use HashSet.size
    use ToString.toString

/////////////////////////////////////////////////////////////////////////////
// size                                                                    //
/////////////////////////////////////////////////////////////////////////////
@test
def size01(): Bool = size(empty()) == 0

@test
def size02(): Bool = size(singleton(1)) == 1

@test
def size03(): Bool = size(fromList(1 :: 2 :: Nil)) == 2

@test
def size04(): Bool = size(fromList(1 :: 2 :: 3 :: Nil)) == 3

@test
def size05(): Bool = size(fromList(14 :: List.range(1,13))) == 13

/////////////////////////////////////////////////////////////////////////////
// insert                                                                  //
/////////////////////////////////////////////////////////////////////////////
@test
def insert01(): Bool =
    HashSet.insert(1, empty()) ==
    singleton(1)

@test
def insert02(): Bool =
    HashSet.insert(1, singleton(1)) ==
    singleton(1)

@test
def insert03(): Bool =
    HashSet.insert(1, singleton(2)) ==
    fromList(1 :: 2 :: Nil)

@test
def insert04(): Bool =
    HashSet.insert(1, fromList(2 :: 3 :: Nil)) ==
    fromList(1 :: 2 :: 3 :: Nil)

@test
def insert05(): Bool =
    HashSet.insert(1, fromList(1 :: 2 :: 3 :: Nil)) ==
    fromList(1 :: 2 :: 3 :: Nil)

@test
def insert06(): Bool =
    HashSet.insert(1, fromList(2 :: 1 :: 3 :: Nil)) ==
    fromList(2 :: 1 :: 3 :: Nil)

@test
def insert07(): Bool =
    HashSet.insert(1, fromList(2 :: 1 :: 3 :: 7 :: 8 :: 9 :: 10 :: Nil)) ==
    fromList(2 :: 1 :: 3 :: 7 :: 8 :: 9 :: 10 :: Nil)

@test
def insert08(): Bool =
    HashSet.insert(11,fromList(2 :: 1 :: 3 :: 7 :: 8 :: 9 :: 10 :: 35 :: Nil)) ==
    fromList(11 :: 2 :: 1 :: 3 :: 7 :: 8 :: 9 :: 10 :: 35 :: Nil)

/////////////////////////////////////////////////////////////////////////////
// remove                                                                  //
/////////////////////////////////////////////////////////////////////////////
@test
def remove01(): Bool = HashSet.remove(1, empty()) == empty()

@test
def remove02(): Bool = HashSet.remove(1, singleton(1)) == empty()

@test
def remove03(): Bool = HashSet.remove(1, singleton(2)) == singleton(2)

@test
def remove04(): Bool = HashSet.remove(2, fromList(2 :: 3 :: Nil)) == singleton(3)

@test
def remove05(): Bool = HashSet.remove(3, fromList(2 :: 3 :: Nil)) == singleton(2)

@test
def remove06(): Bool = HashSet.remove(1, fromList(2 :: 3 :: Nil)) == fromList(2 :: 3 :: Nil)

@test
def remove07(): Bool =
    HashSet.remove(0, fromList(1 :: 2 :: 3 :: 4 :: 5 :: 6 :: 7 :: Nil)) ==
    fromList(1 :: 2 :: 3 :: 4 :: 5 :: 6 :: 7 :: Nil)

@test
def remove08(): Bool =
    HashSet.remove(1, fromList(1 :: 2 :: 3 :: 4 :: 5 :: 6 :: 7 :: Nil)) ==
    fromList(2 :: 3 :: 4 :: 5 :: 6 :: 7 :: Nil)

@test
def remove09(): Bool =
    HashSet.remove(2, fromList(1 :: 2 :: 3 :: 4 :: 5 :: 6 :: 7 :: Nil)) ==
    fromList(1 :: 3 :: 4 :: 5 :: 6 :: 7 :: Nil)

@test
def remove10(): Bool =
    HashSet.remove(6, fromList(1 :: 2 :: 3 :: 4 :: 5 :: 6 :: 7 :: Nil)) ==
    fromList(1 :: 2 :: 3 :: 4 :: 5 :: 7 :: Nil)

@test
def remove11(): Bool =
    HashSet.remove(7, fromList(1 :: 2 :: 3 :: 4 :: 5 :: 6 :: 7 :: Nil)) ==
    fromList(1 :: 2 :: 3 :: 4 :: 5 :: 6 :: Nil)

@test
def remove12(): Bool =
    HashSet.remove(8, fromList(1 :: 2 :: 3 :: 4 :: 5 :: 6 :: 7 :: Nil)) ==
    fromList(1 :: 2 :: 3 :: 4 :: 5 :: 6 :: 7 :: Nil)

/////////////////////////////////////////////////////////////////////////////
// isEmpty                                                                 //
/////////////////////////////////////////////////////////////////////////////
@test
def isEmpty01(): Bool = HashSet.isEmpty(empty(): HashSet[Unit]) == true

@test
def isEmpty02(): Bool = HashSet.isEmpty(singleton(1)) == false

@test
def isEmpty03(): Bool = HashSet.isEmpty(fromList(1 :: 2 :: Nil)) == false

@test
def isEmpty04(): Bool = HashSet.isEmpty(fromList(1 :: 2 :: 3 :: Nil)) == false

@test
def isEmpty05(): Bool = HashSet.isEmpty(fromList(1 :: 2 :: 3 :: 4 :: 5 :: 6 :: 7 :: 8:: Nil)) == false

/////////////////////////////////////////////////////////////////////////////
// memberOf                                                                //
/////////////////////////////////////////////////////////////////////////////
@test
def memberOf01(): Bool = HashSet.memberOf(1, empty()) == false

@test
def memberOf02(): Bool = HashSet.memberOf(1, singleton(2)) == false

@test
def memberOf03(): Bool = HashSet.memberOf(1, singleton(1)) == true

@test
def memberOf04(): Bool = HashSet.memberOf(1, fromList(1 :: 2 :: Nil)) == true

@test
def memberOf05(): Bool = HashSet.memberOf(2, fromList(1 :: 2 :: Nil)) == true

@test
def memberOf06(): Bool = HashSet.memberOf(0, fromList(1 :: 2 :: Nil)) == false

@test
def memberOf07(): Bool = HashSet.memberOf(3, fromList(1 :: 2 :: Nil)) == false

@test
def memberOf08(): Bool =
    HashSet.memberOf(0, fromList(1 :: 2 :: 3 :: 4 :: 5 :: 6 :: 7 :: 8 :: 9 :: 10 :: Nil)) == false

@test
def memberOf09(): Bool =
    HashSet.memberOf(1, fromList(1 :: 2 :: 3 :: 4 :: 5 :: 6 :: 7 :: 8 :: 9 :: 10 :: Nil)) == true

@test
def memberOf10(): Bool =
    HashSet.memberOf(2, fromList(1 :: 2 :: 3 :: 4 :: 5 :: 6 :: 7 :: 8 :: 9 :: 10 :: Nil)) == true

@test
def memberOf11(): Bool =
    HashSet.memberOf(10, fromList(1 :: 2 :: 3 :: 4 :: 5 :: 6 :: 7 :: 8 :: 9 :: 10 :: Nil)) == true

@test
def memberOf12(): Bool =
    HashSet.memberOf(12, fromList(1 :: 2 :: 3 :: 4 :: 5 :: 6 :: 7 :: 8 :: 9 :: 10 :: Nil)) == false

// /////////////////////////////////////////////////////////////////////////////
// // find                                                                    //
// /////////////////////////////////////////////////////////////////////////////
// @test
// def find01(): Bool = HashSet.find(i -> i > 2, empty()) == None

// @test
// def find02(): Bool = HashSet.find(i -> i > 2, singleton(1)) == None

// @test
// def find03(): Bool = HashSet.find(i -> i > 2, singleton(3)) == Some(3)

// @test
// def find04(): Bool = HashSet.find(i -> i > 2, fromList(2 :: 1 :: Nil)) == None

// @test
// def find05(): Bool = HashSet.find(i -> i > 2, fromList(-6 :: 6 :: Nil)) == Some(6)

// @test
// def find06(): Bool = HashSet.find(i -> i > 2, fromList(6 :: -6 :: Nil)) == Some(6)

// @test
// def find07(): Bool = HashSet.find(i -> i > 2, fromList(7 :: 6 :: Nil)) == Some(6)

// /////////////////////////////////////////////////////////////////////////////
// // findLeft                                                                //
// /////////////////////////////////////////////////////////////////////////////
// @test
// def findLeft01(): Bool = HashSet.findLeft(i -> i > 2, empty()) == None

// @test
// def findLeft02(): Bool = HashSet.findLeft(i -> i > 2, singleton(1)) == None

// @test
// def findLeft03(): Bool = HashSet.findLeft(i -> i > 2, singleton(3)) == Some(3)

// @test
// def findLeft04(): Bool = HashSet.findLeft(i -> i > 2, fromList(2 :: 1 :: Nil)) == None

// @test
// def findLeft05(): Bool = HashSet.findLeft(i -> i > 2, fromList(-6 :: 6 :: Nil)) == Some(6)

// @test
// def findLeft06(): Bool = HashSet.findLeft(i -> i > 2, fromList(6 :: -6 :: Nil)) == Some(6)

// @test
// def findLeft07(): Bool = HashSet.findLeft(i -> i > 2, fromList(7 :: 6 :: Nil)) == Some(6)

// /////////////////////////////////////////////////////////////////////////////
// // findRight                                                               //
// /////////////////////////////////////////////////////////////////////////////
// @test
// def findRight01(): Bool = HashSet.findRight(i -> i > 2, empty()) == None

// @test
// def findRight02(): Bool = HashSet.findRight(i -> i > 2, singleton(1)) == None

// @test
// def findRight03(): Bool = HashSet.findRight(i -> i > 2, singleton(3)) == Some(3)

// @test
// def findRight04(): Bool = HashSet.findRight(i -> i > 2, fromList(2 :: 1 :: Nil)) == None

// @test
// def findRight05(): Bool = HashSet.findRight(i -> i > 2, fromList(-6 :: 6 :: Nil)) == Some(6)

// @test
// def findRight06(): Bool = HashSet.findRight(i -> i > 2, fromList(6 :: -6 :: Nil)) == Some(6)

// @test
// def findRight07(): Bool = HashSet.findRight(i -> i > 2, fromList(7 :: 6 :: Nil)) == Some(7)

// /////////////////////////////////////////////////////////////////////////////
// // isSubsetOf                                                              //
// /////////////////////////////////////////////////////////////////////////////
// @test
// def isSubsetOf01(): Bool = HashSet.isSubsetOf(empty(): HashSet[Unit], empty()) == true

// @test
// def isSubsetOf02(): Bool = HashSet.isSubsetOf(empty(), singleton(1)) == true

// @test
// def isSubsetOf03(): Bool = HashSet.isSubsetOf(singleton(1), singleton(1)) == true

// @test
// def isSubsetOf04(): Bool = HashSet.isSubsetOf(singleton(1), singleton(2)) == false

// @test
// def isSubsetOf05(): Bool = HashSet.isSubsetOf(empty(), fromList(1 :: 2 :: Nil)) == true

// @test
// def isSubsetOf06(): Bool = HashSet.isSubsetOf(singleton(1), fromList(1 :: 2 :: Nil)) == true

// @test
// def isSubsetOf07(): Bool = HashSet.isSubsetOf(singleton(2), fromList(1 :: 2 :: Nil)) == true

// @test
// def isSubsetOf08(): Bool = HashSet.isSubsetOf(singleton(3), fromList(1 :: 2 :: Nil)) == false

// @test
// def isSubsetOf09(): Bool = HashSet.isSubsetOf(fromList(1 :: 2 :: Nil), fromList(1 :: 2 :: Nil)) == true

// @test
// def isSubsetOf10(): Bool = HashSet.isSubsetOf(fromList(2 :: 1 :: Nil), fromList(1 :: 2 :: Nil)) == true

// @test
// def isSubsetOf11(): Bool = HashSet.isSubsetOf(fromList(3 :: 1 :: Nil), fromList(1 :: 2 :: Nil)) == false

// @test
// def isSubsetOf12(): Bool = HashSet.isSubsetOf(fromList(1 :: 2 :: 3 :: Nil), fromList(1 :: 2 :: Nil)) == false

// @test
// def isSubsetOf13(): Bool = HashSet.isSubsetOf(singleton(10), fromList(1 :: 2 :: 3 :: 4 :: 5 :: 6 :: 7 :: 8 :: 9 :: 10 :: Nil)) == true

// @test
// def isSubsetOf14(): Bool = HashSet.isSubsetOf(fromList(9 :: 1 :: Nil), fromList(1 :: 2 :: 3 :: 4 :: 5 :: 6 :: 7 :: 8 :: 9 :: 10 :: Nil)) == true

// @test
// def isSubsetOf15(): Bool = HashSet.isSubsetOf(fromList(6 :: 5 :: 8 :: Nil), fromList(1 :: 2 :: 3 :: 4 :: 5 :: 6 :: 7 :: 8 :: 9 :: 10 :: Nil)) == true

// @test
// def isSubsetOf16(): Bool = HashSet.isSubsetOf(fromList(10 :: 2 :: 3 :: 6 :: -1 :: 4 :: Nil), fromList(1 :: 2 :: 3 :: 4 :: 5 :: 6 :: 7 :: 8 :: 9 :: 10 :: Nil)) == false

// /////////////////////////////////////////////////////////////////////////////
// // isProperSubsetOf                                                        //
// /////////////////////////////////////////////////////////////////////////////
// @test
// def isProperSubsetOf01(): Bool = HashSet.isProperSubsetOf(empty(): HashSet[Unit], empty()) == false

// @test
// def isProperSubsetOf02(): Bool = HashSet.isProperSubsetOf(empty(), singleton(1)) == true

// @test
// def isProperSubsetOf03(): Bool = HashSet.isProperSubsetOf(singleton(1), singleton(1)) == false

// @test
// def isProperSubsetOf04(): Bool = HashSet.isProperSubsetOf(singleton(1), singleton(2)) == false

// @test
// def isProperSubsetOf05(): Bool = HashSet.isProperSubsetOf(empty(), fromList(1 :: 2 :: Nil)) == true

// @test
// def isProperSubsetOf06(): Bool = HashSet.isProperSubsetOf(singleton(1), fromList(1 :: 2 :: Nil)) == true

// @test
// def isProperSubsetOf07(): Bool = HashSet.isProperSubsetOf(singleton(2), fromList(1 :: 2 :: Nil)) == true

// @test
// def isProperSubsetOf08(): Bool = HashSet.isProperSubsetOf(singleton(3), fromList(1 :: 2 :: Nil)) == false

// @test
// def isProperSubsetOf09(): Bool = HashSet.isProperSubsetOf(fromList(1 :: 2 :: Nil), fromList(1 :: 2 :: Nil)) == false

// @test
// def isProperSubsetOf10(): Bool = HashSet.isProperSubsetOf(fromList(2 :: 1 :: Nil), fromList(1 :: 2 :: Nil)) == false

// @test
// def isProperSubsetOf11(): Bool = HashSet.isProperSubsetOf(fromList(3 :: 1 :: Nil), fromList(1 :: 2 :: Nil)) == false

// @test
// def isProperSubsetOf12(): Bool = HashSet.isProperSubsetOf(fromList(1 :: 2 :: 3 :: Nil), fromList(1 :: 2 :: Nil)) == false

// @test
// def isProperSubsetOf13(): Bool =
//     HashSet.isProperSubsetOf(
//         singleton(10), 
//         fromList(1 :: 2 :: 3 :: 4 :: 5 :: 6 :: 7 :: 8 :: 9 :: 10 :: Nil)
//     ) == true

// @test
// def isProperSubsetOf14(): Bool =
//     HashSet.isProperSubsetOf(
//         fromList(9 :: 1 :: Nil), 
//         fromList(1 :: 2 :: 3 :: 4 :: 5 :: 6 :: 7 :: 8 :: 9 :: 10 :: Nil)
//     ) == true

// @test
// def isProperSubsetOf15(): Bool =
//     HashSet.isProperSubsetOf(
//         fromList(6 :: 5 :: 8 :: Nil), 
//         fromList(1 :: 2 :: 3 :: 4 :: 5 :: 6 :: 7 :: 8 :: 9 :: 10 :: Nil)
//     ) == true

// @test
// def isProperSubsetOf16(): Bool =
//     HashSet.isProperSubsetOf(
//         fromList(10 :: 2 :: 3 :: 6 :: -1 :: 4 :: Nil), 
//         fromList(1 :: 2 :: 3 :: 4 :: 5 :: 6 :: 7 :: 8 :: 9 :: 10 :: Nil)
//     ) == false

// @test
// def isProperSubsetOf17(): Bool =
//     HashSet.isProperSubsetOf(
//         fromList(10 :: 2 :: 3 :: 6 :: 1 :: 4 :: 5 :: 9 :: 8 :: 7 :: Nil) :: 
//         fromList(1 :: 2 :: 3 :: 4 :: 5 :: 6 :: 7 :: 8 :: 9 :: 10 :: Nil)
//     ) == false

// /////////////////////////////////////////////////////////////////////////////
// // fold                                                                    //
// /////////////////////////////////////////////////////////////////////////////

// @test
// def fold01(): Bool = HashSet.fold(empty(): HashSet[String]) == ""

// @test
// def fold02(): Bool = HashSet.fold(empty(): HashSet[Unit]) == ()

// @test
// def fold03(): Bool = HashSet.fold(fromList("a" :: "b" :: "c" :: Nil)) == "abc"

// @test
// def fold04(): Bool = HashSet.fold(fromList(("a", "b") :: ("c", "d") :: Nil)) == ("ac", "bd")

// /////////////////////////////////////////////////////////////////////////////
// // foldLeft                                                                //
// /////////////////////////////////////////////////////////////////////////////
// @test
// def foldLeft01(): Bool = HashSet.foldLeft((i, e) -> (i - e)*(e rem 2 + 1), 100, empty()) == 100

// @test
// def foldLeft02(): Bool = HashSet.foldLeft((i, e) -> (i - e)*(e rem 2 + 1), 100, singleton(1)) == 198

// @test
// def foldLeft03(): Bool = HashSet.foldLeft((i, e) -> (i - e)*(e rem 2 + 1), 100, fromList(2 :: 1 :: Nil)) == 196

// @test
// def foldLeft04(): Bool = HashSet.foldLeft((i, e) -> (i - e)*(e rem 2 + 1), 100, fromList(3 :: 2 :: 1 :: Nil)) == 386

// /////////////////////////////////////////////////////////////////////////////
// // foldRight                                                               //
// /////////////////////////////////////////////////////////////////////////////
// @test
// def foldRight01(): Bool = HashSet.foldRight((e, acc) -> (acc - e) * (e rem 2 + 1), 100, empty()) == 100

// @test
// def foldRight02(): Bool = HashSet.foldRight((e, acc) -> (acc - e) * (e rem 2 + 1), 100, singleton(1)) == 198

// @test
// def foldRight03(): Bool = HashSet.foldRight((e, acc) -> (acc - e) * (e rem 2 + 1), 100, fromList(2 :: 1 :: Nil)) == 194

// @test
// def foldRight04(): Bool = HashSet.foldRight((e, acc) -> (acc - e) * (e rem 2 + 1), 100, fromList(3 :: 2 :: 1 :: Nil)) == 382

// /////////////////////////////////////////////////////////////////////////////
// // foldRightWithCont                                                       //
// /////////////////////////////////////////////////////////////////////////////
// @test
// def foldRightWithCont01(): Bool = HashSet.foldRightWithCont((e, k) -> (k() - e) * (e rem 2 + 1), 100, empty()) == 100

// @test
// def foldRightWithCont02(): Bool = HashSet.foldRightWithCont((e, k) -> (k() - e) * (e rem 2 + 1), 100, singleton(1)) == 198

// @test
// def foldRightWithCont03(): Bool = HashSet.foldRightWithCont((e, k) -> (k() - e) * (e rem 2 + 1), 100, fromList(2 :: 1 :: Nil)) == 194

// @test
// def foldRightWithCont04(): Bool = HashSet.foldRightWithCont((e, k) -> (k() - e) * (e rem 2 + 1), 100, fromList(3 :: 2 :: 1 :: Nil)) == 382

// /////////////////////////////////////////////////////////////////////////////
// // foldMap                                                                 //
// /////////////////////////////////////////////////////////////////////////////

// @test
// def foldMap01(): Bool = HashSet.foldMap(x -> 2 * x, empty()) == 0

// @test
// def foldMap02(): Bool = HashSet.foldMap(x -> 2 * x, fromList(1 :: 2 :: Nil)) == 6

// @test
// def foldMap03(): Bool = HashSet.foldMap(x -> if (x == "a") "b" else x, singleton("a")) == "b"

// @test
// def foldMap04(): Bool = HashSet.foldMap(x -> if (x == "c") "b" else x, fromList("a" :: "b" :: "c" :: Nil)) == "abb"

// @test
// def foldMap05(): Bool = HashSet.foldMap(Int32.toString, fromList(1 :: 2 :: 3 :: Nil)) == "123"

// /////////////////////////////////////////////////////////////////////////////
// // reduceLeft                                                              //
// /////////////////////////////////////////////////////////////////////////////
// @test
// def reduceLeft01(): Bool = HashSet.reduceLeft((a, b) -> a-b, empty(): HashSet[Int32]) == None

// @test
// def reduceLeft02(): Bool = HashSet.reduceLeft((a, b) -> a-b, singleton(1)) == Some(1)

// @test
// def reduceLeft03(): Bool = HashSet.reduceLeft((a, b) -> a-b, fromList(2 :: 1 :: Nil)) == Some(-1)

// @test
// def reduceLeft04(): Bool = HashSet.reduceLeft((a, b) -> a-b, fromList(3 :: 2 :: 1 :: Nil)) == Some(-4)

// @test
// def reduceLeft05(): Bool = HashSet.reduceLeft((a, b) -> a-b, fromList(4 :: 3 :: 2 :: 1 :: Nil)) == Some(-8)

// /////////////////////////////////////////////////////////////////////////////
// // reduceRight                                                             //
// /////////////////////////////////////////////////////////////////////////////
// @test
// def reduceRight01(): Bool = HashSet.reduceRight((a, b) -> a-b, empty(): HashSet[Int32]) == None

// @test
// def reduceRight02(): Bool = HashSet.reduceRight((a, b) -> a-b, singleton(1)) == Some(1)

// @test
// def reduceRight03(): Bool = HashSet.reduceRight((a, b) -> a-b, fromList(2 :: 1 :: Nil)) == Some(-1)

// @test
// def reduceRight04(): Bool = HashSet.reduceRight((a, b) -> a-b, fromList(3 :: 2 :: 1 :: Nil)) == Some(2)

// @test
// def reduceRight05(): Bool = HashSet.reduceRight((a, b) -> a-b, fromList(4 :: 3 :: 2 :: 1 :: Nil)) == Some(-2)

// /////////////////////////////////////////////////////////////////////////////
// // count                                                                   //
// /////////////////////////////////////////////////////////////////////////////
// @test
// def count01(): Bool = HashSet.count(i -> i > 3, empty()) == 0

// @test
// def count02(): Bool = HashSet.count(i -> i > 3, singleton(1)) == 0

// @test
// def count03(): Bool = HashSet.count(i -> i > 3, singleton(4)) == 1

// @test
// def count04(): Bool = HashSet.count(i -> i > 3, fromList(2 :: 1 :: Nil)) == 0

// @test
// def count05(): Bool = HashSet.count(i -> i > 3, fromList(8 :: 1 :: Nil)) == 1

// @test
// def count06(): Bool = HashSet.count(i -> i > 3, fromList(1 :: 8 :: Nil)) == 1

// @test
// def count07(): Bool = HashSet.count(i -> i > 3, fromList(7 :: 6 :: Nil)) == 2

// @test
// def count08(): Bool \ IO =
//     let range = List.range(0, 2000);
//     let s = range |> List.toSet;
//     let a = new MutList(Static);
//     discard HashSet.count(x -> ( let b = new MutList(Static); MutList.push!(x, b); MutList.append!(MutList.toList(b), a); true ), s);
//     MutList.toList(a) == range


// /////////////////////////////////////////////////////////////////////////////
// // sum                                                                     //
// /////////////////////////////////////////////////////////////////////////////

// @test
// def sum01(): Bool =
//     empty() |> HashSet.sum == 0

// @test
// def sum02(): Bool =
//     singleton(1) |> HashSet.sum == 1

// @test
// def sum03(): Bool =
//     fromList(1 :: 2 :: 3 :: Nil) |> HashSet.sum == 6

// @test
// def sum04(): Bool =
//     fromList(1 :: 2 :: 3 :: -3 :: Nil) |> HashSet.sum == 3

// @test
// def sum05(): Bool =
//     fromList(1 :: 2 :: -3 :: -4 :: Nil) |> HashSet.sum == -4

// @test
// def sum06(): Bool =
//     fromList(10 :: -10 :: Nil) |> HashSet.sum == 0

// @test
// def sum07(): Bool =
//     HashSet.range(1, 101) |> HashSet.sum == 5050


// /////////////////////////////////////////////////////////////////////////////
// // sumWith                                                                 //
// /////////////////////////////////////////////////////////////////////////////

// @test
// def sumWith01(): Bool =
//     empty() |> HashSet.sumWith(x -> x + 1) == 0

// @test
// def sumWith02(): Bool =
//     singleton(1) |> HashSet.sumWith(x -> x + 1) == 2

// @test
// def sumWith03(): Bool =
//     fromList(1 :: 2 :: 3 :: Nil) |> HashSet.sumWith(x -> x + 1) == 9

// @test
// def sumWith04(): Bool =
//     fromList(1 :: 2 :: 3 :: -3 :: Nil) |> HashSet.sumWith(x -> x + 1) == 7

// @test
// def sumWith05(): Bool =
//     fromList(-1 :: -2 :: -3 :: -4 :: Nil) |> HashSet.sumWith(x -> x + 1) == -6

// @test
// def sumWith06(): Bool =
//     fromList(10 :: -10 :: Nil) |> HashSet.sumWith(x -> x + 1) == 2

// @test
// def sumWith08(): Bool \ IO =
//     let range = List.range(0, 2000);
//     let m = range |> List.toSet;
//     let a = new MutList(Static);
//     discard HashSet.sumWith(k -> ( let b = new MutList(Static); MutList.push!(k, b); MutList.append!(MutList.toList(b), a); 1 ), m);
//     MutList.toList(a) == range


// /////////////////////////////////////////////////////////////////////////////
// // product                                                                 //
// /////////////////////////////////////////////////////////////////////////////

// @test
// def product01(): Bool =
//     HashSet.product(empty()) == 1

// @test
// def product02(): Bool =
//     singleton(1) |> HashSet.product == 1

// @test
// def product03(): Bool =
//     fromList(1 :: 2 :: 3 :: Nil) |> HashSet.product == 6

// @test
// def product04(): Bool =
//     fromList(1 :: 2 :: 3 :: -3 :: Nil) |> HashSet.product == -18

// @test
// def product05(): Bool =
//     fromList(-1 :: -2 :: -3 :: -4 :: Nil) |> HashSet.product == 24

// @test
// def product06(): Bool =
//     fromList(10 :: -10 :: Nil) |> HashSet.product == -100


// /////////////////////////////////////////////////////////////////////////////
// // productWith                                                             //
// /////////////////////////////////////////////////////////////////////////////

// @test
// def productWith01(): Bool =
//     empty() |> HashSet.productWith(x -> x + 1) == 1

// @test
// def productWith02(): Bool =
//     singleton(1) |> HashSet.productWith(x -> x + 1) == 2

// @test
// def productWith03(): Bool =
//     fromList(1 :: 2 :: 3 :: Nil) |> HashSet.productWith(x -> x + 1) == 24

// @test
// def productWith04(): Bool =
//     fromList(1 :: 2 :: 3 :: -3 :: Nil) |> HashSet.productWith(x -> x + 1) == -48

// @test
// def productWith05(): Bool =
//     fromList(-2 :: -3 :: -4 :: -5 :: Nil) |> HashSet.productWith(x -> x + 1) == 24

// @test
// def productWith06(): Bool =
//     fromList(10 :: -10 :: Nil) |> HashSet.productWith(x -> x + 1) == -99

// @test
// def productWith08(): Bool \ IO =
//     let range = List.range(0, 2000);
//     let m = range |> List.toSet;
//     let a = new MutList(Static);
//     discard HashSet.productWith(k -> ( let b = new MutList(Static); MutList.push!(k, b); MutList.append!(MutList.toList(b), a); 1 ), m);
//     MutList.toList(a) == range


// /////////////////////////////////////////////////////////////////////////////
// // flatten                                                                 //
// /////////////////////////////////////////////////////////////////////////////
// @test
// def flatten01(): Bool = HashSet.flatten(empty()): HashSet[Unit] == empty()

// @test
// def flatten02(): Bool = HashSet.flatten(singleton(empty()): HashSet[HashSet[Unit]]) == empty()

// @test
// def flatten03(): Bool = HashSet.flatten(singleton(singleton(1))) == singleton(1)

// @test
// def flatten04(): Bool = HashSet.flatten(singleton(fromList(1 :: 2 :: Nil))) == fromList(1 :: 2 :: Nil)

// @test
// def flatten05(): Bool = HashSet.flatten(fromList(empty() :: empty() :: Nil)): HashSet[Unit] == empty()

// @test
// def flatten06(): Bool = HashSet.flatten(fromList(singleton(1) :: empty())) == singleton(1)

// @test
// def flatten07(): Bool = HashSet.flatten(fromList(empty() :: singleton(1))) == singleton(1)

// @test
// def flatten08(): Bool = HashSet.flatten(fromList(singleton(1) :: singleton(2))) == fromList(1 :: 2 :: Nil)

// @test
// def flatten09(): Bool = HashSet.flatten(fromList(singleton(1) :: singleton(1))) == singleton(1)

// @test
// def flatten10(): Bool = HashSet.flatten(fromList(fromList(1 :: 2 :: Nil) :: fromList(3 :: 4 :: 5 :: Nil))) == fromList(1 :: 2 :: 3 :: 4 :: 5 :: Nil)

// @test
// def flatten11(): Bool = HashSet.flatten(fromList(fromList(1 :: 2 :: Nil) :: fromList(3 :: 4 :: 3 :: Nil))) == fromList(1 :: 2 :: 3 :: 4 :: Nil)

// @test
// def flatten12(): Bool = HashSet.flatten(fromList(fromList(1 :: 2 :: Nil) :: fromList(3 :: 4 :: 1 :: Nil))) == fromList(1 :: 2 :: 3 :: 4 :: Nil)

// @test
// def flatten13(): Bool = HashSet.flatten(fromList(singleton(1) :: fromList(2 :: 3 :: Nil) :: singleton(4))) == fromList(1 :: 2 :: 3 :: 4 :: Nil)

// @test
// def flatten14(): Bool = HashSet.flatten(fromList(singleton(1) :: fromList(2 :: 3 :: Nil) :: singleton(1))) == fromList(1 :: 2 :: 3 :: Nil)

// /////////////////////////////////////////////////////////////////////////////
// // exists                                                                  //
// /////////////////////////////////////////////////////////////////////////////
// @test
// def exists01(): Bool = HashSet.exists(x -> x rem 8 == 7, empty()) == false

// @test
// def exists02(): Bool = HashSet.exists(x -> x rem 8 == 7, singleton(5)) == false

// @test
// def exists03(): Bool = HashSet.exists(x -> x rem 8 == 7, singleton(7)) == true

// @test
// def exists04(): Bool = HashSet.exists(x -> x rem 8 == 7, singleton(15)) == true

// @test
// def exists05(): Bool = HashSet.exists(x -> x rem 8 == 7, fromList(1 :: 44 :: Nil)) == false

// @test
// def exists06(): Bool = HashSet.exists(x -> x rem 8 == 7, fromList(11 :: 71 :: Nil)) == true

// @test
// def exists07(): Bool = HashSet.exists(x -> x rem 8 == 7, fromList(71 :: 12 :: Nil)) == true

// @test
// def exists08(): Bool = HashSet.exists(x -> x rem 8 == 7, fromList(71 :: 79 :: Nil)) == true

// @test
// def exists09(): Bool = HashSet.exists(x -> x rem 8 == 7, fromList(11 :: -1 :: -14 :: -2 :: 84 :: 113 :: Nil)) == false

// @test
// def exists10(): Bool = HashSet.exists(x -> x rem 8 == 7, fromList(11 :: -1 :: 31 :: -14 :: -2 :: 84 :: 111 :: Nil)) == true

// @test
// def exists11(): Bool = HashSet.exists(x -> x rem 8 == 7, fromList(11 :: -1 :: -14 :: -2 :: 84 :: 111 :: 38 :: Nil)) == true

// /////////////////////////////////////////////////////////////////////////////
// // forall                                                                  //
// /////////////////////////////////////////////////////////////////////////////
// @test
// def forall01(): Bool = HashSet.forall(x -> x rem 8 == 7, empty()) == true

// @test
// def forall02(): Bool = HashSet.forall(x -> x rem 8 == 7, singleton(5)) == false

// @test
// def forall03(): Bool = HashSet.forall(x -> x rem 8 == 7, singleton(7)) == true

// @test
// def forall04(): Bool = HashSet.forall(x -> x rem 8 == 7, singleton(15)) == true

// @test
// def forall05(): Bool = HashSet.forall(x -> x rem 8 == 7, fromList(1 :: 44 :: Nil)) == false

// @test
// def forall06(): Bool = HashSet.forall(x -> x rem 8 == 7, fromList(11 :: 71 :: Nil)) == false

// @test
// def forall07(): Bool = HashSet.forall(x -> x rem 8 == 7, fromList(71 :: 12 :: Nil)) == false

// @test
// def forall08(): Bool = HashSet.forall(x -> x rem 8 == 7, fromList(71 :: 79 :: Nil)) == true

// @test
// def forall09(): Bool = HashSet.forall(x -> x rem 8 == 7, fromList(7 :: 15 :: 23 :: 84 :: 111 :: Nil)) == false

// @test
// def forall10(): Bool = HashSet.forall(x -> x rem 8 == 7, fromList(7 :: 15 :: 23 :: 111 :: 3 :: Nil)) == false

// @test
// def forall11(): Bool = HashSet.forall(x -> x rem 8 == 7, fromList(7 :: 15 :: 23 :: 119 :: 111 :: Nil)) == true

// /////////////////////////////////////////////////////////////////////////////
// // union                                                                   //
// /////////////////////////////////////////////////////////////////////////////
// @test
// def union01(): Bool = HashSet.union(empty(): HashSet[Unit], empty()) == empty()

// @test
// def union02(): Bool = HashSet.union(singleton(1), empty()) == singleton(1)

// @test
// def union03(): Bool = HashSet.union(empty(), singleton(2)) == singleton(2)

// @test
// def union04(): Bool = HashSet.union(singleton(1), singleton(1)) == singleton(1)

// @test
// def union05(): Bool = HashSet.union(singleton(1), singleton(-1)) == fromList(1 :: -1 :: Nil)

// @test
// def union06(): Bool = HashSet.union(empty(), fromList(-1 :: 9 :: Nil)) == fromList(-1 :: 9 :: Nil)

// @test
// def union07(): Bool = HashSet.union(singleton(9), fromList(-1 :: 9 :: Nil)) == fromList(-1 :: 9 :: Nil)

// @test
// def union08(): Bool = HashSet.union(singleton(4), fromList(-1 :: 9 :: Nil)) == fromList(4 :: -1 :: 9 :: Nil)

// @test
// def union09(): Bool = HashSet.union(fromList(9 :: -1 :: Nil), fromList(-1 :: 9 :: Nil)) == fromList(-1 :: 9 :: Nil)

// @test
// def union10(): Bool = HashSet.union(fromList(9 :: 5 :: Nil), fromList(-1 :: 9 :: Nil)) == fromList(5 :: -1 :: 9 :: Nil)

// @test
// def union11(): Bool = HashSet.union(fromList(6 :: 5 :: Nil), fromList(-1 :: 9 :: Nil)) == fromList(6 :: 5 :: -1 :: 9 :: Nil)

// @test
// def union12(): Bool = HashSet.union(fromList(6 :: -99 :: Nil), fromList(6 :: 5 :: -1 :: 9 :: 43 :: 7 :: 8 :: -99 :: Nil)) == fromList(6 :: 5 :: -1 :: 9 :: 43 :: 7 :: 8 :: -99 :: Nil)

// @test
// def union13(): Bool = HashSet.union(fromList(6 :: -99 :: -1 :: 5 :: 22 :: Nil), fromList(6 :: 5 :: -1 :: 9 :: 43 :: 7 :: 8 :: -99 :: Nil)) == fromList(22 :: 6 :: 5 :: -1 :: 9 :: 43 :: 7 :: 8 :: -99 :: Nil)

// @test
// def union14(): Bool = HashSet.union(fromList(-2 :: -3 :: -4 :: Nil), fromList(6 :: 5 :: -1 :: 9 :: 43 :: 7 :: 8 :: -99 :: Nil)) == fromList(-2 :: -3 :: -4 :: 6 :: 5 :: -1 :: 9 :: 43 :: 7 :: 8 :: -99 :: Nil)

// /////////////////////////////////////////////////////////////////////////////
// // intersection                                                            //
// /////////////////////////////////////////////////////////////////////////////
// @test
// def intersection01(): Bool = HashSet.intersection(empty(): HashSet[Unit], empty()) == empty()

// @test
// def intersection02(): Bool = HashSet.intersection(singleton(1), empty()) == empty()

// @test
// def intersection03(): Bool = HashSet.intersection(empty(), singleton(2)) == empty()

// @test
// def intersection04(): Bool = HashSet.intersection(singleton(1), singleton(2)) == empty()

// @test
// def intersection05(): Bool = HashSet.intersection(singleton(1), singleton(1)) == singleton(1)

// @test
// def intersection06(): Bool = HashSet.intersection(empty(), fromList(1 :: 2 :: Nil)) == empty()

// @test
// def intersection07(): Bool = HashSet.intersection(fromList(1 :: 2 :: Nil), empty()) == empty()

// @test
// def intersection08(): Bool = HashSet.intersection(singleton(2), fromList(1 :: 2 :: Nil)) == singleton(2)

// @test
// def intersection09(): Bool = HashSet.intersection(singleton(1), fromList(1 :: 2 :: Nil)) == singleton(1)

// @test
// def intersection10(): Bool = HashSet.intersection(fromList(2 :: 1 :: Nil), fromList(1 :: 2 :: Nil)) == fromList(2 :: 1 :: Nil)

// @test
// def intersection11(): Bool = HashSet.intersection(fromList(1 :: 2 :: Nil), fromList(1 :: 2 :: Nil)) == fromList(1 :: 2 :: Nil)

// @test
// def intersection12(): Bool = HashSet.intersection(fromList(3 :: 2 :: Nil), fromList(1 :: 2 :: Nil)) == singleton(2)

// @test
// def intersection13(): Bool = HashSet.intersection(fromList(3 :: 55 :: Nil), fromList(1 :: 2 :: Nil)) == empty()

// @test
// def intersection14(): Bool = HashSet.intersection(fromList(3 :: 55 :: 11 :: 87 :: 22 :: 34 :: -87 :: 23 :: Nil), fromList(1 :: 2 :: 84 :: -87 :: 87 :: 3 :: 44 :: Nil)) == fromList(3 :: 87 :: -87 :: Nil)

// @test
// def intersection15(): Bool = HashSet.intersection(fromList(3 :: 55 :: 11 :: 87 :: 22 :: 34 :: -87 :: 23 :: Nil), fromList(23 :: 1 :: 2 :: 84 :: 87 :: 3 :: Nil)) == fromList(3 :: 87 :: 23 :: Nil)

// /////////////////////////////////////////////////////////////////////////////
// // difference                                                              //
// /////////////////////////////////////////////////////////////////////////////
// @test
// def difference01(): Bool = HashSet.difference(empty(): HashSet[Unit], empty()) == empty()

// @test
// def difference02(): Bool = HashSet.difference(empty(), singleton(2)) == empty()

// @test
// def difference03(): Bool = HashSet.difference(singleton(1), empty()) == singleton(1)

// @test
// def difference04(): Bool = HashSet.difference(singleton(1), singleton(2)) == singleton(1)

// @test
// def difference05(): Bool = HashSet.difference(singleton(1), singleton(1)) == empty()

// @test
// def difference06(): Bool = HashSet.difference(fromList(1 :: 2 :: Nil), empty()) == fromList(1 :: 2 :: Nil)

// @test
// def difference07(): Bool = HashSet.difference(fromList(1 :: 2 :: Nil), singleton(1)) == singleton(2)

// @test
// def difference08(): Bool = HashSet.difference(fromList(1 :: 2 :: Nil), singleton(2)) == singleton(1)

// @test
// def difference09(): Bool = HashSet.difference(fromList(1 :: 2 :: Nil), fromList(8 :: 2 :: 4 :: Nil)) == singleton(1)

// @test
// def difference10(): Bool = HashSet.difference(fromList(1 :: 2 :: Nil), fromList(3 :: 1 :: 2 :: 4 :: Nil)) == empty()

// @test
// def difference11(): Bool = HashSet.difference(fromList(1 :: 2 :: Nil), fromList(3 :: 11 :: 21 :: 4 ::Nil)) == fromList(1 :: 2 :: Nil)

// @test
// def difference12(): Bool = HashSet.difference(fromList(1 :: 2 :: 87 :: 4 :: 5 :: 6 :: 86 :: 92 :: 111 :: -1 :: Nil), fromList(-1 :: 92 :: 4 :: 5 :: 1 :: 2 :: 86 :: Nil)) == fromList(87 :: 6 :: 111 :: Nil)

// @test
// def difference13(): Bool = HashSet.difference(fromList(1 :: 2 :: 87 :: 4 :: 5 :: 6 :: 86 :: 92 :: 111 :: -1 :: Nil), fromList(-1 :: 92 :: 4 :: 5 :: 1 :: 2 :: 86 :: 99 :: 6 :: Nil)) == fromList(87 :: 111 :: Nil)

// /////////////////////////////////////////////////////////////////////////////
// // subsets                                                                 //
// /////////////////////////////////////////////////////////////////////////////
// @test
// def subsets01(): Bool = HashSet.subsets(empty(): HashSet[Unit]) == fromList(empty())

// @test
// def subsets02(): Bool = HashSet.subsets(singleton(1)) == fromList(singleton(1), empty())

// @test
// def subsets03(): Bool = HashSet.subsets(fromList(1 :: 2 :: Nil)) == fromList(fromList(1 :: 2 :: Nil), singleton(1), singleton(2), empty())

// @test
// def subsets04(): Bool = HashSet.subsets(fromList(1 :: 2 :: 3 :: Nil)) == fromList(fromList(1 :: 2 :: 3 :: Nil), fromList(1 :: 2 :: Nil), fromList(1 :: 3 :: Nil), singleton(1), fromList(2 :: 3 :: Nil), singleton(2), singleton(3), empty())

// /////////////////////////////////////////////////////////////////////////////
// // filter                                                                  //
// /////////////////////////////////////////////////////////////////////////////
// @test
// def filter01(): Bool = HashSet.filter(x -> x rem 2 == 0, empty()) == empty()

// @test
// def filter02(): Bool = HashSet.filter(x -> x rem 2 == 0, singleton(1)) == empty()

// @test
// def filter03(): Bool = HashSet.filter(x -> x rem 2 == 0, singleton(2)) == singleton(2)

// @test
// def filter04(): Bool = HashSet.filter(x -> x rem 2 == 0, fromList(1 :: 3 :: Nil)) == empty()

// @test
// def filter05(): Bool = HashSet.filter(x -> x rem 2 == 0, fromList(8 :: 3 :: Nil)) == singleton(8)

// @test
// def filter06(): Bool = HashSet.filter(x -> x rem 2 == 0, fromList(-1 :: 32 :: Nil)) == singleton(32)

// @test
// def filter07(): Bool = HashSet.filter(x -> x rem 2 == 0, fromList(12 :: 34 :: Nil)) == fromList(12 :: 34 :: Nil)

// @test
// def filter08(): Bool = HashSet.filter(x -> x rem 2 == 0, fromList(-33 :: -1 :: 12 :: 1 :: 34 :: 88 :: 7 :: 77 :: 31 :: Nil)) == fromList(12 :: 34 :: 88 :: Nil)

// @test
// def filter09(): Bool = HashSet.filter(x -> x rem 2 == 0, fromList(-33, -1, 12, 1, 34, 88, 7, 77, 31, 7, -92, 841)) == fromList(12 :: 34 :: 88 :: -92 ::Nil)

// /////////////////////////////////////////////////////////////////////////////
// // map                                                                     //
// /////////////////////////////////////////////////////////////////////////////
// @test
// def map01(): Bool = HashSet.map(x -> x rem 2 == 0, empty()) == empty()

// @test
// def map02(): Bool = HashSet.map(x -> x rem 2 == 0, singleton(1)) == fromList(false)

// @test
// def map03(): Bool = HashSet.map(x -> x rem 2 == 0, singleton(2)) == fromList(true)

// @test
// def map04(): Bool = HashSet.map(x -> x rem 2 == 0, fromList(1 :: -1 :: Nil)) == fromList(false)

// @test
// def map05(): Bool = HashSet.map(x -> x rem 2 == 0, fromList(1 :: -12 :: Nil)) == fromList(false, true)

// @test
// def map06(): Bool = HashSet.map(x -> x rem 2 == 0, fromList(16 :: -1 :: Nil)) == fromList(true, false)

// @test
// def map07(): Bool = HashSet.map(x -> x rem 2 == 0, fromList(12 :: -12 :: Nil)) == fromList(true)

// @test
// def map08(): Bool = HashSet.map(x -> x rem 2 == 0, fromList(12 :: -12 :: Nil)) == fromList(true)

// @test
// def map09(): Bool = HashSet.map(x -> x rem 2 == 0, fromList(12 :: -12 :: 1 :: 14 ::Nil)) == fromList(false, true)

// @test
// def map10(): Bool = HashSet.map(x -> x rem 2 == 0, fromList(12 :: -12 :: 1 :: 14 :: 7 :: 88 :: -91 :: Nil)) == fromList(true, false)

// @test
// def map11(): Bool = HashSet.map(x -> x rem 2 == 0, fromList(12 :: -12 :: 122 :: 14 ::Nil)) == fromList(true)

// @test
// def map12(): Bool = HashSet.map(x -> x rem 2 == 0, fromList(123 :: -123 :: 1223 :: 141 ::Nil)) == fromList(false)

// @test
// def map13(): Bool = HashSet.map(x -> x rem 9, fromList(11 :: 5 :: 16 :: 4 ::Nil)) == fromList(2 :: 5 :: 7 :: 4 :: Nil)

// @test
// def map14(): Bool = HashSet.map(x -> x rem 9, fromList(0 :: 5 :: 1 :: -9 :: -8 :: Nil)) == fromList(5 :: 1 :: 0 :: -8 :: Nil)

// @test
// def map15(): Bool = HashSet.map(x -> x rem 9, fromList(0 :: 5 :: 1 :: 10 :: 7 :: 19 :: 28 :: 2 :: Nil)) == fromList(0 :: 5 :: 7 :: 1 :: 2 :: Nil)

// @test
// def map16(): Bool \ IO =
//     let range = List.range(0, 2000);
//     let s = List.toSet(range);
//     let a = new MutList(Static);
//     discard HashSet.map(x -> ( let b = new MutList(Static); MutList.push!(x, b); MutList.append!(MutList.toList(b), a); x ), s);
//     MutList.toList(a) == range


// /////////////////////////////////////////////////////////////////////////////
// // flatMap                                                                 //
// /////////////////////////////////////////////////////////////////////////////

// @test
// def flatMap01(): Bool = HashSet.flatMap(x -> if (x rem 2 == 0) empty() else fromList(x), empty()) == empty()

// @test
// def flatMap02(): Bool = HashSet.flatMap(x -> if (x rem 2 == 0) empty() else fromList(x), singleton(2)) == empty()

// @test
// def flatMap03(): Bool = HashSet.flatMap(x -> if (x rem 2 == 0) empty() else fromList(x), singleton(1)) == singleton(1)

// @test
// def flatMap04(): Bool = HashSet.flatMap(x -> if (x rem 2 == 0) empty() else fromList(x), fromList(2 :: 4 :: Nil)) == empty()

// @test
// def flatMap05(): Bool = HashSet.flatMap(x -> if (x rem 2 == 0) empty() else fromList(x), fromList(2 :: 13 :: Nil)) == singleton(13)

// @test
// def flatMap06(): Bool = HashSet.flatMap(x -> if (x rem 2 == 0) empty() else fromList(x), fromList(15 :: -8 :: Nil)) == singleton(15)

// @test
// def flatMap07(): Bool = HashSet.flatMap(x -> if (x rem 2 == 0) empty() else fromList(x), fromList(1 :: 11 :: Nil)) == fromList(1 :: 11 :: Nil)

// @test
// def flatMap08(): Bool = HashSet.flatMap(x -> fromList(x, 2*x), fromList(1 :: 4 :: 8 :: 2 :: Nil)) == fromList(1 :: 8 :: 16 :: 2 :: 4 :: Nil)

// @test
// def flatMap09(): Bool = HashSet.flatMap(x -> fromList(x, 3*x), fromList(1 :: 8 :: 3 :: 2 :: 9 :: -5 :: -1 :: Nil)) == fromList(1, 8, 24, 3, 2, 6, 9, 27, -5, -15, -1, -3)

// @test
// def flatMap10(): Bool = HashSet.flatMap(x -> fromList(x, 2*x, 3*x), fromList(1 :: 4 :: 3 :: 2 :: Nil)) == fromList(1 :: 8 :: 12 :: 3 :: 9 :: 2 :: 4 :: 6 :: Nil)

// /////////////////////////////////////////////////////////////////////////////
// // filterMap                                                               //
// /////////////////////////////////////////////////////////////////////////////

// @test
// def filterMap01(): Bool =
//     HashSet.filterMap(i -> if (i rem 2 == 0) Some(i/2) else None, empty()) == empty()

// @test
// def filterMap02(): Bool =
//     HashSet.filterMap(i -> if (i rem 2 == 0) Some(i/2) else None, singleton(1)) == empty()

// @test
// def filterMap03(): Bool =
//     HashSet.filterMap(i -> if (i rem 2 == 0) Some(i/2) else None, singleton(2)) == singleton(1)

// @test
// def filterMap04(): Bool =
//     HashSet.filterMap(i -> if (i rem 2 == 0) Some(i/2) else None, fromList(1 :: 3 :: Nil)) == empty()

// @test
// def filterMap05(): Bool =
//     HashSet.filterMap(i -> if (i rem 2 == 0) Some(i/2) else None, fromList(1 :: 4 :: Nil)) == singleton(2)

// @test
// def filterMap06(): Bool =
//     HashSet.filterMap(i -> if (i rem 2 == 0) Some(i/2) else None, fromList(-1 :: 6 :: Nil)) == singleton(3)

// @test
// def filterMap07(): Bool =
//     HashSet.filterMap(i -> if (i rem 2 == 0) Some(i/2) else None, fromList(6 :: 8 :: Nil)) == fromList(3 :: 4 :: Nil)

// @test
// def filterMap08(): Bool =
//     let s1 = fromList(0 :: 1 :: 2 :: 3 :: 4 :: 5 :: 10 :: Nil);
//     let s2 = fromList(0 :: 1 :: 2 :: 5 :: Nil);
//     HashSet.filterMap(i -> if (i rem 2 == 0) Some(i/2) else None, s1) == s2

// /////////////////////////////////////////////////////////////////////////////
// // replace                                                                 //
// /////////////////////////////////////////////////////////////////////////////
// @test
// def replace01(): Bool = HashSet.replace(from = 3, to = 4, empty()) == empty()

// @test
// def replace02(): Bool = HashSet.replace(from = 3, to = 4, singleton(1)) == singleton(1)

// @test
// def replace03(): Bool = HashSet.replace(from = 3, to = 4, singleton(3)) == singleton(4)

// @test
// def replace04(): Bool = HashSet.replace(from = 3, to = 4, singleton(4)) == singleton(4)

// @test
// def replace05(): Bool = HashSet.replace(from = 3, to = 4, fromList(1 :: 2 :: Nil)) == fromList(1 :: 2 :: Nil)

// @test
// def replace06(): Bool = HashSet.replace(from = 3, to = 4, fromList(1 :: 3 :: Nil)) == fromList(1 :: 4 :: Nil)

// @test
// def replace07(): Bool = HashSet.replace(from = 3, to = 4, fromList(3 :: 2 :: Nil)) == fromList(4 :: 2 :: Nil)

// @test
// def replace08(): Bool = HashSet.replace(from = 3, to = 4, fromList(3 :: 4 :: Nil)) == singleton(4)

// /////////////////////////////////////////////////////////////////////////////
// // partition                                                               //
// /////////////////////////////////////////////////////////////////////////////
// @test
// def partition01(): Bool = HashSet.partition(x -> x rem 2 == 0, empty()) == (empty(), empty())

// @test
// def partition02(): Bool = HashSet.partition(x -> x rem 2 == 0, singleton(1)) == (empty(), singleton(1))

// @test
// def partition03(): Bool = HashSet.partition(x -> x rem 2 == 0, singleton(2)) == (singleton(2), empty())

// @test
// def partition04(): Bool = HashSet.partition(x -> x rem 2 == 0, fromList(1 :: 3 :: Nil)) == (empty(), fromList(1 :: 3 :: Nil))

// @test
// def partition05(): Bool = HashSet.partition(x -> x rem 2 == 0, fromList(1 :: 2 :: Nil)) == (singleton(2), singleton(1))

// @test
// def partition06(): Bool = HashSet.partition(x -> x rem 2 == 0, fromList(2 :: 1 :: Nil)) == (singleton(2), singleton(1))

// @test
// def partition07(): Bool = HashSet.partition(x -> x rem 2 == 0, fromList(2 :: -4 :: Nil)) == (fromList(2 :: -4 :: Nil), empty())

// @test
// def partition08(): Bool = HashSet.partition(x -> x rem 2 == 0, fromList(2 :: -11 :: 89 :: -4 :: 11 :: -6 :: 84 :: Nil)) == (fromList(2 :: -4 :: -6 :: 84 ::Nil), fromList(-11 :: 89 :: 11 :: Nil))

// @test
// def partition09(): Bool = HashSet.partition(x -> x rem 2 == 0, fromList(84 :: -6 :: 11 :: -4 :: 89 :: -11 :: 2 :: Nil)) == (fromList(84 :: -6 :: -4 :: 2 ::Nil), fromList(11 :: 89 :: -11 :: Nil))

// @test
// def partition10(): Bool = HashSet.partition(x -> x rem 2 == 0, fromList(1 :: 2 :: 3 :: 4 :: 5 :: 6 :: 7 :: 8:: Nil)) == (fromList(2 :: 4 :: 6 :: 8 :: Nil), fromList(1 :: 3 :: 5 :: 7 :: Nil))

// /////////////////////////////////////////////////////////////////////////////
// // toList                                                                  //
// /////////////////////////////////////////////////////////////////////////////
// @test
// def toList01(): Bool = HashSet.toList(empty(): HashSet[Unit]) == Nil

// @test
// def toList02(): Bool = HashSet.toList(singleton(1)) == 1 :: Nil

// @test
// def toList03(): Bool = HashSet.toList(fromList(1 :: 2 :: Nil)) == 2 :: 1 :: Nil

// @test
// def toList04(): Bool = HashSet.toList(fromList(1 :: 2 :: 3 :: Nil)) == 3 :: 2 :: 1 :: Nil

// /////////////////////////////////////////////////////////////////////////////
// // toChain                                                                 //
// /////////////////////////////////////////////////////////////////////////////

// @test
// def toChain01(): Bool =
//     HashSet.toChain(empty(): HashSet[Int32]) == Chain.empty(): Chain[Int32]

// @test
// def toChain02(): Bool =
//     HashSet.toChain(singleton(1)) == Chain.singleton(1)

// @test
// def toChain03(): Bool =
//     HashSet.toChain(fromList(1 :: 2 :: Nil)) == List.toChain(1 :: 2 :: Nil)

// @test
// def toChain04(): Bool =
//     HashSet.toChain(fromList(1 :: 2 :: 3 :: Nil)) == List.toChain(1 :: 2 :: 3 :: Nil)

// /////////////////////////////////////////////////////////////////////////////
// // toMap                                                                   //
// /////////////////////////////////////////////////////////////////////////////
// @test
// def toMap01(): Bool = HashSet.toMap(empty(): HashSet[(Unit, Unit)]) == Map#{}

// @test
// def toMap02(): Bool = HashSet.toMap(fromList((1, true))) == Map#{1 => true}

// @test
// def toMap03(): Bool = HashSet.toMap(fromList((1, true), (2, false))) == Map#{1 => true, 2 => false}

// @test
// def toMap04(): Bool = HashSet.toMap(fromList((1, true), (1, false))) == Map#{1 => false}

// @test
// def toMap05(): Bool = HashSet.toMap(fromList((1, true), (2, false), (3, true))) == Map#{1 => true, 2 => false, 3 => true}


// /////////////////////////////////////////////////////////////////////////////
// // toMapWith                                                               //
// /////////////////////////////////////////////////////////////////////////////

// @test
// def toMapWith02(): Bool =
//     HashSet.toMapWith(x -> 0 * x, empty()) == Map#{}

// @test
// def toMapWith03(): Bool =
//     HashSet.toMapWith(x -> 2 * x, fromList(1 :: 3 :: 6 :: Nil)) == Map#{1 => 2, 3 => 6, 6 => 12}

// @test
// def toMapWith04(): Bool =
//     HashSet.toMapWith(x -> x + 10, fromList(1 :: 3 :: 6 :: Nil)) == Map#{1 => 11, 3 => 13, 6 => 16}

// @test
// def toMapWith05(): Bool =
//     HashSet.toMapWith(x -> x + 10, fromList(7 :: 1 :: 3 :: 6 :: Nil)) == Map#{1 => 11, 3 => 13, 6 => 16, 7 => 17}

// /////////////////////////////////////////////////////////////////////////////
// // toMutDeque                                                              //
// /////////////////////////////////////////////////////////////////////////////

// @test
// def toMutDeque01(): Bool = region r {
//     let s: HashSet[Int32] = empty();
//     let d1 = HashSet.toMutDeque(r, s);

//     let d2 = new MutDeque(r);

//     d1 `MutDeque.sameElements` d2
// }

// @test
// def toMutDeque02(): Bool = region r {
//     let s = singleton(1);
//     let d1 = HashSet.toMutDeque(r, s);

//     let d2 = new MutDeque(r);
//     MutDeque.pushBack(1, d2);

//     d1 `MutDeque.sameElements` d2
// }

// @test
// def toMutDeque03(): Bool = region r {
//     let s = fromList(1 :: 3 :: 6 :: Nil);
//     let d1 = HashSet.toMutDeque(r, s);

//     let d2 = new MutDeque(r);
//     MutDeque.pushBack(3, d2);
//     MutDeque.pushBack(6, d2);
//     MutDeque.pushFront(1, d2);

//     d1 `MutDeque.sameElements` d2
// }

// @test
// def toMutDeque04(): Bool = region r {
//     let s = fromList(7 :: 1 :: 3 :: 6 :: Nil);
//     let d1 = HashSet.toMutDeque(r, s);

//     let d2 = new MutDeque(r);
//     MutDeque.pushFront(7, d2);
//     MutDeque.pushFront(6, d2);
//     MutDeque.pushFront(3, d2);
//     MutDeque.pushFront(1, d2);

//     d1 `MutDeque.sameElements` d2
// }

/////////////////////////////////////////////////////////////////////////////
// eq                                                                      //
/////////////////////////////////////////////////////////////////////////////
@test
def eq01(): Bool = empty(): HashSet[Unit] == empty()

@test
def eq02(): Bool = singleton(1) != empty()

@test
def eq03(): Bool = empty() != singleton(1)

@test
def eq04(): Bool = fromList(1 :: 2 :: Nil) != empty()

@test
def eq05(): Bool = empty() != fromList(1 :: 2 :: Nil)

@test
def eq06(): Bool = singleton(1) != singleton(2)

@test
def eq07(): Bool = singleton(1) == singleton(1)

@test
def eq08(): Bool = fromList(1 :: 2 :: 3 :: Nil) != empty()

@test
def eq09(): Bool = fromList(1 :: 2 :: Nil) != singleton(1)

@test
def eq10(): Bool = singleton(1) != fromList(1 :: 2 :: Nil)

@test
def eq11(): Bool = empty() != fromList(1 :: 2 :: 3 :: Nil)

@test
def eq12(): Bool = fromList(1 :: 2 :: Nil) != fromList(1 :: 3 :: Nil)

@test
def eq13(): Bool = fromList(1 :: 2 :: Nil) == fromList(2 :: 1 :: Nil)

@test
def eq14(): Bool = fromList(1 :: 2 :: Nil) == fromList(1 :: 2 :: Nil)

@test
def eq15(): Bool = fromList(1 :: 2 :: 3 :: Nil) != fromList(1 :: 2 :: 4 :: Nil)

@test
def eq16(): Bool = fromList(1 :: 2 :: 3 :: Nil) == fromList(1 :: 2 :: 3 :: Nil)

@test
def eq17(): Bool = fromList(1 :: 2 :: 3 :: Nil) == fromList(2 :: 3 :: 1 :: Nil)

@test
def eq18(): Bool = fromList(1 :: 2 :: 3 :: Nil) == fromList(3 :: 1 :: 2 :: Nil)

@test
def eq19(): Bool = fromList(1 :: 2 :: 3 :: Nil) == fromList(2 :: 1 :: 3 :: Nil)

// /////////////////////////////////////////////////////////////////////////////
// // foreach                                                                 //
// /////////////////////////////////////////////////////////////////////////////

// @test
// def foreach01(): Bool \ IO =
//     let r = ref 21;
//     HashSet.foreach(x -> r := x, empty());
//     21 == deref r

// @test
// def foreach02(): Bool \ IO =
//     let r = ref 21;
//     HashSet.foreach(x -> r := x, singleton(42));
//     42 == deref r

// /////////////////////////////////////////////////////////////////////////////
// // unfold                                                                  //
// /////////////////////////////////////////////////////////////////////////////

// @test
// def unfold01(): Bool =
//     HashSet.unfold(s -> if (true) None else Some(Char.fromInt32(s + 48), s + 1), 0) == empty()

// @test
// def unfold02(): Bool =
//     HashSet.unfold(s -> if (s > 0) None else Some(Char.fromInt32(s + 48), s + 1), 0) == fromList('0')

// @test
// def unfold03(): Bool =
//     HashSet.unfold(s -> if (s > 1) None else Some(Char.fromInt32(s + 48), s + 1), 0) == fromList('0', '1')

// @test
// def unfold04(): Bool =
//     HashSet.unfold(s -> if (s >= 10) None else Some(Char.fromInt32(s + 48), s + 1), 0) == fromList('0', '1', '2', '3', '4', '5', '6', '7', '8', '9')

// @test
// def unfold05(): Bool =
//     HashSet.unfold(s -> if (s >= 10) None else Some(Char.fromInt32(s + 48), s + 1), 5) == fromList('5', '6', '7', '8', '9')

// @test
// def unfold06(): Bool =
//     HashSet.unfold(s -> if (s >= 10) None else Some(Char.fromInt32(s + 48), s + 2), 0) == fromList('0', '2', '4', '6', '8')

// /////////////////////////////////////////////////////////////////////////////
// // unfoldWithIter                                                          //
// /////////////////////////////////////////////////////////////////////////////

// @test
// def unfoldWithIter01(): Bool \ IO =
//     let x = ref 0;
//     let step = () ->
//         if (true)
//             None
//         else (
//             let c = Char.fromInt32(deref x + 48);
//             x := deref x + 1;
//             Some(c)
//         );
//     HashSet.unfoldWithIter(step) == empty()

// @test
// def unfoldWithIter02(): Bool \ IO =
//     let x = ref 0;
//     let step = () ->
//         if (deref x > 0)
//             None
//         else (
//             let c = Char.fromInt32(deref x + 48);
//             x := deref x + 1;
//             Some(c)
//         );
//     HashSet.unfoldWithIter(step) == fromList('0')

// @test
// def unfoldWithIter03(): Bool \ IO =
//     let x = ref 0;
//     let step = () ->
//         if (deref x > 1)
//             None
//         else (
//             let c = Char.fromInt32(deref x + 48);
//             x := deref x + 1;
//             Some(c)
//         );
//     HashSet.unfoldWithIter(step) == fromList('0', '1')

// @test
// def unfoldWithIter04(): Bool \ IO =
//     let x = ref 0;
//     let step = () ->
//         if (deref x >= 10)
//             None
//         else (
//             let c = Char.fromInt32(deref x + 48);
//             x := deref x + 1;
//             Some(c)
//         );
//     HashSet.unfoldWithIter(step) == fromList('0', '1', '2', '3', '4', '5', '6', '7', '8', '9')

// @test
// def unfoldWithIter05(): Bool \ IO =
//     let x = ref 5;
//     let step = () ->
//         if (deref x >= 10)
//             None
//         else (
//             let c = Char.fromInt32(deref x + 48);
//             x := deref x + 1;
//             Some(c)
//         );
//     HashSet.unfoldWithIter(step) == fromList('5', '6', '7', '8', '9')

// @test
// def unfoldWithIter06(): Bool \ IO =
//     let x = ref 0;
//     let step = () ->
//         if (deref x >= 10)
//             None
//         else (
//             let c = Char.fromInt32(deref x + 48);
//             x := deref x + 2;
//             Some(c)
//         );
//     HashSet.unfoldWithIter(step) == fromList('0', '2', '4', '6', '8')

// /////////////////////////////////////////////////////////////////////////////
// // toString                                                                //
// /////////////////////////////////////////////////////////////////////////////

// @test
// def toString01(): Bool =
//     toString(singleton(1)) == "singleton(1)"

// @test
// def toString02(): Bool =
//     toString(fromList(1 :: 2 :: 3 :: Nil)) == "fromList(1 :: 2 :: 3 :: Nil)"

// @test
// def toString03(): Bool =
//     toString(fromList(1 :: 2 :: Nil)) == "fromList(1 :: 2 :: Nil)"

// @test
// def toString04(): Bool =
//     toString(fromList(97 :: 2 :: 3 :: 4 :: 0 :: Nil)) == "fromList(0 :: 2 :: 3 :: 4 :: 97 :: Nil)"

// @test
// def toString05(): Bool =
//     toString(fromList(fromList(1 :: 2 :: Nil) :: fromList(4 :: 6 :: Nil) :: Nil)) == "fromList(fromList(1 :: 2 :: Nil), fromList(4 :: 6 :: Nil))"

/////////////////////////////////////////////////////////////////////////////
// hash                                                                    //
/////////////////////////////////////////////////////////////////////////////

@test
def hash01(): Bool = hash(empty(): HashSet[Unit]) == hash(empty(): HashSet[Unit])

@test
def hash02(): Bool = hash(fromList(1 :: 2 :: Nil)) == hash(fromList(1 :: 2 :: Nil))

@test
def hash03(): Bool = hash(fromList('a' :: 'b' :: 'c' :: 'd' :: Nil)) == hash(fromList('a' :: 'b' :: 'c' :: 'd' :: Nil))

@test
def hash04(): Bool = hash(fromList('a' :: 'b' :: 'c' :: 'e' :: Nil)) != hash(fromList('a' :: 'b' :: 'c' :: 'd' :: Nil))

@test
def hash05(): Bool = hash(singleton(false)) != hash(singleton(true))

// /////////////////////////////////////////////////////////////////////////////
// // minimum                                                                 //
// /////////////////////////////////////////////////////////////////////////////

// @test
// def minimum01(): Bool = HashSet.minimum(empty(): HashSet[Int32]) == None

// @test
// def minimum02(): Bool = HashSet.minimum(singleton(1)) == Some(1)

// @test
// def minimum03(): Bool = HashSet.minimum(fromList(1 :: 2 :: 3 :: 0 :: Nil)) == Some(0)

// @test
// def minimum04(): Bool = HashSet.minimum(HashSet.range(5, 55)) == Some(5)

// /////////////////////////////////////////////////////////////////////////////
// // minimumBy                                                               //
// /////////////////////////////////////////////////////////////////////////////

// @test
// def minimumBy01(): Bool = HashSet.minimumBy((x, y) -> x <=> y, empty(): HashSet[Int32]) == None

// @test
// def minimumBy02(): Bool = HashSet.minimumBy((x, y) -> x <=> y, singleton(1)) == Some(1)

// @test
// def minimumBy03(): Bool = HashSet.minimumBy((x, y) -> x <=> y, fromList(1 :: 2 :: 3 :: 0 :: Nil)) == Some(0)

// @test
// def minimumBy04(): Bool = HashSet.minimumBy((x, y) -> x <=> y, HashSet.range(5, 55)) == Some(5)

// @test
// def minimumBy05(): Bool \ IO =
//     let s = List.range(0, 2000) |> List.toSet;
//     let a = new MutList(Static);
//     discard HashSet.minimumBy((x, y) -> ( let b = new MutList(Static); MutList.push!(y, b); MutList.append!(MutList.toList(b), a); x <=> y ), s);
//     MutList.toList(a) == List.range(1, 2000) // The first / left most value is ignored


// /////////////////////////////////////////////////////////////////////////////
// // maximum                                                                 //
// /////////////////////////////////////////////////////////////////////////////

// @test
// def maximum01(): Bool = HashSet.maximum(empty(): HashSet[Int32]) == None

// @test
// def maximum02(): Bool = HashSet.maximum(singleton(1)) == Some(1)

// @test
// def maximum03(): Bool = HashSet.maximum(fromList(1 :: 2 :: 3 :: 0 :: Nil)) == Some(3)

// @test
// def maximum04(): Bool = HashSet.maximum(HashSet.range(5, 55)) == Some(54)

// /////////////////////////////////////////////////////////////////////////////
// // maximumBy                                                               //
// /////////////////////////////////////////////////////////////////////////////

// @test
// def maximumBy01(): Bool = HashSet.maximumBy((x, y) -> x <=> y, empty(): HashSet[Int32]) == None

// @test
// def maximumBy02(): Bool = HashSet.maximumBy((x, y) -> x <=> y, singleton(1)) == Some(1)

// @test
// def maximumBy03(): Bool = HashSet.maximumBy((x, y) -> x <=> y, fromList(1 :: 2 :: 3 :: 0 :: Nil)) == Some(3)

// @test
// def maximumBy04(): Bool = HashSet.maximumBy((x, y) -> x <=> y, HashSet.range(5, 55)) == Some(54)


// /////////////////////////////////////////////////////////////////////////////
// // toDelayList                                                             //
// /////////////////////////////////////////////////////////////////////////////

// @test
// def toDelayList01(): Bool =
//     empty(): HashSet[Unit] |> HashSet.toDelayList == DelayList.empty()

// @test
// def toDelayList02(): Bool =
//     HashSet.range(-1000, 1000) |> HashSet.toDelayList == DelayList.range(-1000, 1000)

// @test
// def toDelayList03(): Bool =
//     HashSet.range(-1000, 1000) |> HashSet.toDelayList |> DelayList.toSet == HashSet.range(-1000, 1000)


// /////////////////////////////////////////////////////////////////////////////
// // iterator                                                              //
// /////////////////////////////////////////////////////////////////////////////

// @test
// def iterator01(): Bool = region r {
//     empty(): HashSet[Int32] |> HashSet.iterator(r) |> Iterator.toSet == empty()
// }

// @test
// def iterator02(): Bool = region r {
//     fromList(1 :: 2 :: 3 :: 4 :: Nil) |> HashSet.iterator(r) |> Iterator.toSet == fromList(1 :: 2 :: 3 :: 4 :: Nil)
// }

// @test
// def iterator03(): Bool = region r {
//     HashSet.range(0, 100) |> HashSet.iterator(r) |> Iterator.toSet == HashSet.range(0, 100)
// }


// /////////////////////////////////////////////////////////////////////////////
// // join                                                                    //
// /////////////////////////////////////////////////////////////////////////////

// @test
// def join01(): Bool =
//     HashSet.join(",", empty(): HashSet[Int32]) == ""

// @test
// def join02(): Bool =
//     HashSet.join(",", singleton(1)) == "1"

// @test
// def join03(): Bool =
//     HashSet.join(",", fromList(1 :: 2 :: 3 :: Nil)) == "1,2,3"

// @test
// def join04(): Bool =
//     HashSet.join(",", fromList("1", "2", "3")) == "1,2,3"


// /////////////////////////////////////////////////////////////////////////////
// // joinWith                                                                //
// /////////////////////////////////////////////////////////////////////////////

// @test
// def joinWith01(): Bool =
//     (Nil: List[Int32]) |> List.toSet |>
//         HashSet.joinWith(x -> "$(x + 1)", ",") == ""

// @test
// def joinWith02(): Bool =
//     (1 :: Nil) |> List.toSet |>
//         HashSet.joinWith(x -> "$(x + 1)", ",") == "2"

// @test
// def joinWith03(): Bool =
//     (1 :: 2 :: 3 :: Nil) |> List.toSet |>
//         HashSet.joinWith(x -> "$(x + 1)", ",") == "2,3,4"

// @test
// def joinWith04(): Bool =
//     ("1" :: "2" :: "3" :: Nil) |> List.toSet |>
//         HashSet.joinWith(x -> x + x, ",") == "11,22,33"

}