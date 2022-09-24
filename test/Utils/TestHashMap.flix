
// This file is taken from flix
// https://github.com/flix/flix/blob/master/main/test/ca/uwaterloo/flix/library/TestMap.flix


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

namespace TestHashMap {

    use ToString.toString
    use Hash.hash
    use HashMap.empty
    use HashMap.singleton

/////////////////////////////////////////////////////////////////////////////
// size                                                                    //
/////////////////////////////////////////////////////////////////////////////
@test
def size01(): Bool = HashMap.size(empty()) == 0

@test
def size02(): Bool = HashMap.size(singleton(1, 2)) == 1

@test
def size03(): Bool = HashMap.size(HashMap#{1 => 2, 2 => 4}) == 2

@test
def size04(): Bool = HashMap.size(HashMap#{1 => 2, 2 => 4, 3 => 6}) == 3

@test
def size05(): Bool = HashMap.size(HashMap#{1 => 2, 2 => 4, 3 => 6, 4 => 8}) == 4

@test
def size06(): Bool = HashMap.size(HashMap#{1 => 2, 2 => 4, 3 => 6, 4 => 8, 5 => 10}) == 5

/////////////////////////////////////////////////////////////////////////////
// empty                                                                   //
/////////////////////////////////////////////////////////////////////////////
@test
def empty01(): Bool = HashMap.empty(): HashMap[Unit, Unit] == empty()

/////////////////////////////////////////////////////////////////////////////
// singleton                                                               //
/////////////////////////////////////////////////////////////////////////////
@test
def singleton01(): Bool = HashMap.singleton(1, 2) == singleton(1, 2)

@test
def singleton02(): Bool = HashMap.singleton(3, -1) == singleton(3, -1)

@test
def singleton03(): Bool = HashMap.singleton(-99, -11) == singleton(-99, -11)

/////////////////////////////////////////////////////////////////////////////
// isEmpty                                                                 //
/////////////////////////////////////////////////////////////////////////////
@test
def isEmpty01(): Bool = HashMap.isEmpty(empty(): HashMap[Unit, Unit])

@test
def isEmpty02(): Bool = not HashMap.isEmpty(singleton(1, 2))

@test
def isEmpty03(): Bool = not HashMap.isEmpty(HashMap#{1 => 2, 2 => 4})

@test
def isEmpty04(): Bool = not HashMap.isEmpty(HashMap#{1 => 2, 2 => 4, 3 => 6})

@test
def isEmpty05(): Bool = not HashMap.isEmpty(HashMap#{1 => 2, 2 => 4, 3 => 6, 4 => 8})

/////////////////////////////////////////////////////////////////////////////
// get                                                                     //
/////////////////////////////////////////////////////////////////////////////
@test
def get01(): Bool = HashMap.get(2, empty(): HashMap[_, Unit]) == None

@test
def get02(): Bool = HashMap.get(2, singleton(1, 2)) == None

@test
def get03(): Bool = HashMap.get(2, singleton(2, 1)) == Some(1)

@test
def get04(): Bool = HashMap.get(5, HashMap#{2 => 1, 3 => 17}) == None

@test
def get05(): Bool = HashMap.get(5, HashMap#{2 => 1, 5 => 17}) == Some(17)

@test
def get06(): Bool = HashMap.get(5, HashMap#{5 => 1, 3 => 17}) == Some(1)

@test
def get07(): Bool = HashMap.get(-2, HashMap#{2 => 1, 3 => 17, -1 => -2}) == None

@test
def get08(): Bool = HashMap.get(-2, HashMap#{-2 => 1, 3 => 17, -1 => -2}) == Some(1)

@test
def get09(): Bool = HashMap.get(-2, HashMap#{2 => 1, -2 => 17, -1 => -2}) == Some(17)

@test
def get10(): Bool = HashMap.get(-2, HashMap#{2 => 1, 3 => 17, -2 => -2}) == Some(-2)

/////////////////////////////////////////////////////////////////////////////
// getWithDefault                                                          //
/////////////////////////////////////////////////////////////////////////////
@test
def getWithDefault01(): Bool = HashMap.getWithDefault(2, 34, empty()) == 34

@test
def getWithDefault02(): Bool = HashMap.getWithDefault(2, 34, singleton(1, 2)) == 34

@test
def getWithDefault03(): Bool = HashMap.getWithDefault(2, 34, singleton(2, 1)) == 1

@test
def getWithDefault04(): Bool = HashMap.getWithDefault(5, 34, HashMap#{2 => 1, 3 => 17}) == 34

@test
def getWithDefault05(): Bool = HashMap.getWithDefault(5, 34, HashMap#{2 => 1, 5 => 17}) == 17

@test
def getWithDefault06(): Bool = HashMap.getWithDefault(5, 34, HashMap#{5 => 1, 3 => 17}) == 1

@test
def getWithDefault07(): Bool = HashMap.getWithDefault(-2, 34, HashMap#{2 => 1, 3 => 17, -1 => -2}) == 34

@test
def getWithDefault08(): Bool = HashMap.getWithDefault(-2, 34, HashMap#{-2 => 1, 3 => 17, -1 => -2}) == 1

@test
def getWithDefault09(): Bool = HashMap.getWithDefault(-2, 34, HashMap#{2 => 1, -2 => 17, -1 => -2}) == 17

@test
def getWithDefault10(): Bool = HashMap.getWithDefault(-2, 34, HashMap#{2 => 1, 3 => 17, -2 => -2}) == -2

/////////////////////////////////////////////////////////////////////////////
// memberOf                                                                //
/////////////////////////////////////////////////////////////////////////////
@test
def memberOf01(): Bool = not HashMap.memberOf(2, empty(): HashMap[_, Unit])

@test
def memberOf02(): Bool = not HashMap.memberOf(2, singleton(1, 2))

@test
def memberOf03(): Bool = HashMap.memberOf(2, singleton(2, 1))

@test
def memberOf04(): Bool = not HashMap.memberOf(5, HashMap#{2 => 1, 3 => 17})

@test
def memberOf05(): Bool = HashMap.memberOf(5, HashMap#{2 => 1, 5 => 17})

@test
def memberOf06(): Bool = HashMap.memberOf(5, HashMap#{5 => 1, 3 => 17})

@test
def memberOf07(): Bool = not HashMap.memberOf(-2, HashMap#{2 => 1, 3 => 17, -1 => -2})

@test
def memberOf08(): Bool = HashMap.memberOf(-2, HashMap#{-2 => 1, 3 => 17, -1 => -2})

@test
def memberOf09(): Bool = HashMap.memberOf(-2, HashMap#{2 => 1, -2 => 17, -1 => -2})

@test
def memberOf10(): Bool = HashMap.memberOf(-2, HashMap#{2 => 1, 3 => 17, -2 => -2})

/////////////////////////////////////////////////////////////////////////////
// keysOf                                                                  //
/////////////////////////////////////////////////////////////////////////////
@test
def keysOf01(): Bool = HashMap.keysOf(empty(): HashMap[Unit, Unit]) == Set#{}

@test
def keysOf02(): Bool = HashMap.keysOf(singleton(1, 2)) == Set#{1}

@test
def keysOf03(): Bool = HashMap.keysOf(HashMap#{1 => 2, 2 => 4}) == Set#{1, 2}

@test
def keysOf04(): Bool = HashMap.keysOf(HashMap#{1 => 2, 2 => 4, 3 => 6}) == Set#{1, 2, 3}

@test
def keysOf05(): Bool = HashMap.keysOf(HashMap#{1 => 2, 2 => 4, 3 => 6, 4 => 8}) == Set#{1, 2, 3, 4}

@test
def keysOf06(): Bool = HashMap.keysOf(HashMap#{1 => 2, 2 => 4, 3 => 6, 4 => 8, 5 => 10}) == Set#{1, 2, 3, 4, 5}

/////////////////////////////////////////////////////////////////////////////
// valuesOf                                                                //
/////////////////////////////////////////////////////////////////////////////
@test
def valuesOf01(): Bool = HashMap.valuesOf(empty(): HashMap[Unit, Unit]) == Nil

@test
def valuesOf02(): Bool = HashMap.valuesOf(singleton(1, 2)) == 2 :: Nil

@test
def valuesOf03(): Bool = HashMap.valuesOf(HashMap#{1 => 2, 2 => 4}) == 2 :: 4 :: Nil

@test
def valuesOf04(): Bool = HashMap.valuesOf(HashMap#{1 => 2, 2 => 4, 3 => 6}) == 2 :: 4 :: 6 :: Nil

@test
def valuesOf05(): Bool = HashMap.valuesOf(HashMap#{1 => 2, 2 => 4, 3 => 6, 4 => 8}) == 2 :: 4 :: 6 :: 8 :: Nil

@test
def valuesOf06(): Bool = HashMap.valuesOf(HashMap#{1 => 2, 2 => 4, 3 => 6, 4 => 8, 5 => 10}) == 2 :: 4 :: 6 :: 8 :: 10 :: Nil

@test
def valuesOf07(): Bool = HashMap.valuesOf(HashMap#{1 => -11, 2 => 4, 3 => -5, 4 => 7, 5 => -5}) == -11 :: 4 :: -5 :: 7 :: -5 :: Nil

/////////////////////////////////////////////////////////////////////////////
// insert                                                                  //
/////////////////////////////////////////////////////////////////////////////
@test
def insert01(): Bool = HashMap.insert(1, 3, empty()) == singleton(1, 3)

@test
def insert02(): Bool = HashMap.insert(1, 3, singleton(1, 4)) == singleton(1, 3)

@test
def insert03(): Bool = HashMap.insert(2, 3, singleton(1, 4)) == HashMap#{1 => 4, 2 => 3}

@test
def insert04(): Bool = HashMap.insert(1, 1, HashMap#{1 => 4, 5 => -2}) == HashMap#{1 => 1, 5 => -2}

@test
def insert05(): Bool = HashMap.insert(5, 1, HashMap#{1 => 4, 5 => -2}) == HashMap#{1 => 4, 5 => 1}

@test
def insert06(): Bool = HashMap.insert(4, -2, HashMap#{1 => 4, 5 => -2}) == HashMap#{1 => 4, 5 => -2, 4 => -2}

/////////////////////////////////////////////////////////////////////////////
// insertWith                                                              //
/////////////////////////////////////////////////////////////////////////////
@test
def insertWith01(): Bool = HashMap.insertWith((v1, v2) -> v1 + v2, 1, 3, empty()) == singleton(1, 3)

@test
def insertWith02(): Bool = HashMap.insertWith((v1, v2) -> v1 + v2, 1, 3, singleton(1, 4)) == singleton(1, 7)

@test
def insertWith03(): Bool = HashMap.insertWith((v1, v2) -> v1 + v2, 2, 3, singleton(1, 4)) == HashMap#{1 => 4, 2 => 3}

@test
def insertWith04(): Bool = HashMap.insertWith((v1, v2) -> v1 + v2, 1, 1, HashMap#{1 => 4, 5 => -2}) == HashMap#{1 => 5, 5 => -2}

@test
def insertWith05(): Bool = HashMap.insertWith((v1, v2) -> v1 + v2, 5, 1, HashMap#{1 => 4, 5 => -2}) == HashMap#{1 => 4, 5 => -1}

@test
def insertWith06(): Bool = HashMap.insertWith((v1, v2) -> v1 + v2, 4, -2, HashMap#{1 => 4, 5 => -2}) == HashMap#{1 => 4, 5 => -2, 4 => -2}

/////////////////////////////////////////////////////////////////////////////
// insertWithKey                                                           //
/////////////////////////////////////////////////////////////////////////////
@test
def insertWithKey01(): Bool = HashMap.insertWithKey((k, v1, v2) -> k + v1 + v2, 1, 3, empty()) == singleton(1, 3)

@test
def insertWithKey02(): Bool = HashMap.insertWithKey((k, v1, v2) -> k + v1 + v2, 1, 3, singleton(1, 4)) == singleton(1, 8)

@test
def insertWithKey03(): Bool = HashMap.insertWithKey((k, v1, v2) -> k + v1 + v2, 2, 3, singleton(1, 4)) == HashMap#{1 => 4, 2 => 3}

@test
def insertWithKey04(): Bool = HashMap.insertWithKey((k, v1, v2) -> k + v1 + v2, 1, 1, HashMap#{1 => 4, 5 => -2}) == HashMap#{1 => 6, 5 => -2}

@test
def insertWithKey05(): Bool = HashMap.insertWithKey((k, v1, v2) -> k + v1 + v2, 5, 1, HashMap#{1 => 4, 5 => -2}) == HashMap#{1 => 4, 5 => 4}

@test
def insertWithKey06(): Bool = HashMap.insertWithKey((k, v1, v2) -> k + v1 + v2, 4, -2, HashMap#{1 => 4, 5 => -2}) == HashMap#{1 => 4, 5 => -2, 4 => -2}

/////////////////////////////////////////////////////////////////////////////
// adjust                                                                  //
/////////////////////////////////////////////////////////////////////////////
@test
def adjust01(): Bool = HashMap.adjust(v -> 2*v, 1, empty()) == empty()

@test
def adjust02(): Bool = HashMap.adjust(v -> 2*v, 1, singleton(1, 4)) == singleton(1, 8)

@test
def adjust03(): Bool = HashMap.adjust(v -> 2*v, 2, singleton(1, 4)) == singleton(1, 4)

@test
def adjust04(): Bool = HashMap.adjust(v -> 2*v, 1, HashMap#{1 => -14, 5 => -2}) == HashMap#{1 => -28, 5 => -2}

@test
def adjust05(): Bool = HashMap.adjust(v -> 2*v, 5, HashMap#{1 => 4, 5 => -2}) == HashMap#{1 => 4, 5 => -4}

@test
def adjust06(): Bool = HashMap.adjust(v -> 2*v, 4, HashMap#{1 => 4, 5 => -2}) == HashMap#{1 => 4, 5 => -2}

/////////////////////////////////////////////////////////////////////////////
// adjustWithKey                                                           //
/////////////////////////////////////////////////////////////////////////////
@test
def adjustWithKey01(): Bool = HashMap.adjustWithKey((k, v) -> k+v, 1, empty()) == empty()

@test
def adjustWithKey02(): Bool = HashMap.adjustWithKey((k, v) -> k+v, 1, singleton(1, 4)) == singleton(1, 5)

@test
def adjustWithKey03(): Bool = HashMap.adjustWithKey((k, v) -> k+v, 2, singleton(1, 4)) == singleton(1, 4)

@test
def adjustWithKey04(): Bool = HashMap.adjustWithKey((k, v) -> k+v, 1, HashMap#{1 => -14, 5 => -2}) == HashMap#{1 => -13, 5 => -2}

@test
def adjustWithKey05(): Bool = HashMap.adjustWithKey((k, v) -> k+v, 5, HashMap#{1 => 4, 5 => -2}) == HashMap#{1 => 4, 5 => 3}

@test
def adjustWithKey06(): Bool = HashMap.adjustWithKey((k, v) -> k+v, 4, HashMap#{1 => 4, 5 => -2}) == HashMap#{1 => 4, 5 => -2}

/////////////////////////////////////////////////////////////////////////////
// update                                                                  //
/////////////////////////////////////////////////////////////////////////////
@test
def update01(): Bool = HashMap.update(v -> if (v rem 2 != 0) Some(2*v) else None, 1, empty()) == empty()

@test
def update02(): Bool = HashMap.update(v -> if (v rem 2 != 0) Some(2*v) else None, 1, singleton(1, 3)) == singleton(1, 6)

@test
def update03(): Bool = HashMap.update(v -> if (v rem 2 != 0) Some(2*v) else None, 1, singleton(1, 4)) == singleton(1, 4)

@test
def update04(): Bool = HashMap.update(v -> if (v rem 2 != 0) Some(2*v) else None, 2, singleton(1, 4)) == singleton(1, 4)

@test
def update05(): Bool = HashMap.update(v -> if (v rem 2 != 0) Some(2*v) else None, 1, HashMap#{1 => -14, 5 => -2}) == HashMap#{1 => -14, 5 => -2}

@test
def update06(): Bool = HashMap.update(v -> if (v rem 2 != 0) Some(2*v) else None, 1, HashMap#{1 => -13, 5 => -2}) == HashMap#{1 => -26, 5 => -2}

@test
def update07(): Bool = HashMap.update(v -> if (v rem 2 != 0) Some(2*v) else None, 5, HashMap#{1 => 4, 5 => -2}) == HashMap#{1 => 4, 5 => -2}

@test
def update08(): Bool = HashMap.update(v -> if (v rem 2 != 0) Some(2*v) else None, 5, HashMap#{1 => 4, 5 => -1}) == HashMap#{1 => 4, 5 => -2}

@test
def update09(): Bool = HashMap.update(v -> if (v rem 2 != 0) Some(2*v) else None, 4, HashMap#{1 => 4, 5 => -2}) == HashMap#{1 => 4, 5 => -2}

/////////////////////////////////////////////////////////////////////////////
// updateWithKey                                                           //
/////////////////////////////////////////////////////////////////////////////
@test
def updateWithKey01(): Bool = HashMap.updateWithKey((k, v) -> if (v rem 2 != 0) Some(k+2*v) else None, 1, empty()) == empty()

@test
def updateWithKey02(): Bool = HashMap.updateWithKey((k, v) -> if (v rem 2 != 0) Some(k+2*v) else None, 1, singleton(1, 3)) == singleton(1, 7)

@test
def updateWithKey03(): Bool = HashMap.updateWithKey((k, v) -> if (v rem 2 != 0) Some(k+2*v) else None, 1, singleton(1, 4)) == singleton(1, 4)

@test
def updateWithKey04(): Bool = HashMap.updateWithKey((k, v) -> if (v rem 2 != 0) Some(k+2*v) else None, 2, singleton(1, 4)) == singleton(1, 4)

@test
def updateWithKey05(): Bool = HashMap.updateWithKey((k, v) -> if (v rem 2 != 0) Some(k+2*v) else None, 1, HashMap#{1 => -14, 5 => -2}) == HashMap#{1 => -14, 5 => -2}

@test
def updateWithKey06(): Bool = HashMap.updateWithKey((k, v) -> if (v rem 2 != 0) Some(k+2*v) else None, 1, HashMap#{1 => -13, 5 => -2}) == HashMap#{1 => -25, 5 => -2}

@test
def updateWithKey07(): Bool = HashMap.updateWithKey((k, v) -> if (v rem 2 != 0) Some(k+2*v) else None, 5, HashMap#{1 => 4, 5 => -2}) == HashMap#{1 => 4, 5 => -2}

@test
def updateWithKey08(): Bool = HashMap.updateWithKey((k, v) -> if (v rem 2 != 0) Some(k+2*v) else None, 5, HashMap#{1 => 4, 5 => -1}) == HashMap#{1 => 4, 5 => 3}

@test
def updateWithKey09(): Bool = HashMap.updateWithKey((k, v) -> if (v rem 2 != 0) Some(k+2*v) else None, 4, HashMap#{1 => 4, 5 => -2}) == HashMap#{1 => 4, 5 => -2}

/////////////////////////////////////////////////////////////////////////////
// remove                                                                  //
/////////////////////////////////////////////////////////////////////////////
@test
def remove01(): Bool = HashMap.remove(1, empty(): HashMap[_, Unit]) == empty()

@test
def remove02(): Bool = HashMap.remove(1, singleton(2, 4)) == singleton(2, 4)

@test
def remove03(): Bool = HashMap.remove(1, singleton(1, 4)) == empty()

@test
def remove04(): Bool = HashMap.remove(1, HashMap#{6 => 1, 2 => 4}) == HashMap#{6 => 1, 2 => 4}

@test
def remove05(): Bool = HashMap.remove(6, HashMap#{6 => 1, 2 => 4}) == singleton(2, 4)

@test
def remove06(): Bool = HashMap.remove(2, HashMap#{6 => 1, 2 => 4}) == singleton(6, 1)

@test
def remove07(): Bool = HashMap.remove(1, HashMap#{6 => 1, 2 => 4, 8 => 89}) == HashMap#{6 => 1, 2 => 4, 8 => 89}

@test
def remove08(): Bool = HashMap.remove(6, HashMap#{6 => 1, 2 => 4, 8 => 89}) == HashMap#{2 => 4, 8 => 89}

@test
def remove09(): Bool = HashMap.remove(2, HashMap#{6 => 1, 2 => 4, 8 => 89}) == HashMap#{6 => 1, 8 => 89}

@test
def remove10(): Bool = HashMap.remove(8, HashMap#{6 => 1, 2 => 4, 8 => 89}) == HashMap#{6 => 1, 2 => 4}

/////////////////////////////////////////////////////////////////////////////
// isSubmapOf                                                              //
/////////////////////////////////////////////////////////////////////////////
@test
def isSubmapOf01(): Bool = HashMap.isSubmapOf(empty(): HashMap[Unit, Unit], empty())

@test
def isSubmapOf02(): Bool = not HashMap.isSubmapOf(singleton(1, 2), empty())

@test
def isSubmapOf03(): Bool = not HashMap.isSubmapOf(singleton(3, 4), empty())

@test
def isSubmapOf04(): Bool = HashMap.isSubmapOf(singleton(1, 3), singleton(1, 3))

@test
def isSubmapOf05(): Bool = not HashMap.isSubmapOf(singleton(2, 3), singleton(1, 3))

@test
def isSubmapOf06(): Bool = not HashMap.isSubmapOf(singleton(1, 4), singleton(1, 3))

@test
def isSubmapOf07(): Bool = not HashMap.isSubmapOf(HashMap#{1 => 3, 2 => 3}, singleton(1, 3))

@test
def isSubmapOf08(): Bool = not HashMap.isSubmapOf(HashMap#{1 => 3, 2 => 3}, singleton(2, 3))

@test
def isSubmapOf09(): Bool = HashMap.isSubmapOf(empty(), HashMap#{2 => 4, 1 => 3})

@test
def isSubmapOf10(): Bool = HashMap.isSubmapOf(singleton(2, 4), HashMap#{2 => 4, 1 => 3})

@test
def isSubmapOf11(): Bool = HashMap.isSubmapOf(singleton(1, 3), HashMap#{2 => 4, 1 => 3})

@test
def isSubmapOf12(): Bool = HashMap.isSubmapOf(HashMap#{1 => 3, 2 => 4}, HashMap#{1 => 3, 2 => 4})

@test
def isSubmapOf13(): Bool = HashMap.isSubmapOf(HashMap#{2 => 4, 1 => 3}, HashMap#{1 => 3, 2 => 4})

@test
def isSubmapOf14(): Bool = not HashMap.isSubmapOf(HashMap#{2 => 5, 1 => 3}, HashMap#{1 => 3, 2 => 4})

@test
def isSubmapOf15(): Bool = not HashMap.isSubmapOf(HashMap#{2 => 4, 1 => -1}, HashMap#{1 => 3, 2 => 4})

@test
def isSubmapOf16(): Bool = not HashMap.isSubmapOf(HashMap#{3 => 4, 1 => 3}, HashMap#{1 => 3, 2 => 4})

@test
def isSubmapOf17(): Bool = not HashMap.isSubmapOf(HashMap#{2 => 4, 3 => 3}, HashMap#{1 => 3, 2 => 4})

@test
def isSubmapOf18(): Bool = not HashMap.isSubmapOf(HashMap#{2 => 4, 1 => 3, 8 => 9}, HashMap#{1 => 3, 2 => 4})

/////////////////////////////////////////////////////////////////////////////
// isProperSubmapOf                                                        //
/////////////////////////////////////////////////////////////////////////////
@test
def isProperSubmapOf01(): Bool = not HashMap.isProperSubmapOf(empty(): HashMap[Unit, Unit], empty())

@test
def isProperSubmapOf02(): Bool = not HashMap.isProperSubmapOf(singleton(1, 2), empty())

@test
def isProperSubmapOf03(): Bool = not HashMap.isProperSubmapOf(singleton(3, 4), empty())

@test
def isProperSubmapOf04(): Bool = not HashMap.isProperSubmapOf(singleton(1, 3), singleton(1, 3))

@test
def isProperSubmapOf05(): Bool = not HashMap.isProperSubmapOf(singleton(2, 3), singleton(1, 3))

@test
def isProperSubmapOf06(): Bool = not HashMap.isProperSubmapOf(singleton(1, 4), singleton(1, 3))

@test
def isProperSubmapOf07(): Bool = not HashMap.isProperSubmapOf(HashMap#{1 => 3, 2 => 3}, singleton(1, 3))

@test
def isProperSubmapOf08(): Bool = not HashMap.isProperSubmapOf(HashMap#{1 => 3, 2 => 3}, singleton(2, 3))

@test
def isProperSubmapOf09(): Bool = HashMap.isProperSubmapOf(empty(), HashMap#{2 => 4, 1 => 3})

@test
def isProperSubmapOf10(): Bool = HashMap.isProperSubmapOf(singleton(2, 4), HashMap#{2 => 4, 1 => 3})

@test
def isProperSubmapOf11(): Bool = HashMap.isProperSubmapOf(singleton(1, 3), HashMap#{2 => 4, 1 => 3})

@test
def isProperSubmapOf12(): Bool = not HashMap.isProperSubmapOf(HashMap#{1 => 3, 2 => 4}, HashMap#{1 => 3, 2 => 4})

@test
def isProperSubmapOf13(): Bool = not HashMap.isProperSubmapOf(HashMap#{2 => 4, 1 => 3}, HashMap#{1 => 3, 2 => 4})

@test
def isProperSubmapOf14(): Bool = not HashMap.isProperSubmapOf(HashMap#{2 => 5, 1 => 3}, HashMap#{1 => 3, 2 => 4})

@test
def isProperSubmapOf15(): Bool = not HashMap.isProperSubmapOf(HashMap#{2 => 4, 1 => -1}, HashMap#{1 => 3, 2 => 4})

@test
def isProperSubmapOf16(): Bool = not HashMap.isProperSubmapOf(HashMap#{3 => 4, 1 => 3}, HashMap#{1 => 3, 2 => 4})

@test
def isProperSubmapOf17(): Bool = not HashMap.isProperSubmapOf(HashMap#{2 => 4, 3 => 3}, HashMap#{1 => 3, 2 => 4})

@test
def isProperSubmapOf18(): Bool = not HashMap.isProperSubmapOf(HashMap#{2 => 4, 1 => 3, 8 => 9}, HashMap#{1 => 3, 2 => 4})

/////////////////////////////////////////////////////////////////////////////
// find                                                                    //
/////////////////////////////////////////////////////////////////////////////
@test
def find01(): Bool = HashMap.find((k, v) -> k == v, empty(): HashMap[Unit, Unit]) == None

@test
def find02(): Bool = HashMap.find((k, v) -> k == v, singleton(1, 2)) == None

@test
def find03(): Bool = HashMap.find((k, v) -> k == v, singleton(1, 1)) == Some((1, 1))

@test
def find04(): Bool = HashMap.find((k, v) -> k == v, HashMap#{1 => 2, 2 => 3}) == None

@test
def find05(): Bool = HashMap.find((k, v) -> k == v, HashMap#{1 => 1, 2 => 3}) == Some((1, 1))

@test
def find06(): Bool = HashMap.find((k, v) -> k == v, HashMap#{1 => 2, 2 => 2}) == Some((2, 2))

@test
def find07(): Bool = HashMap.find((k, v) -> k == v, HashMap#{1 => 1, 2 => 2}) == Some((1, 1))

/////////////////////////////////////////////////////////////////////////////
// findLeft                                                                //
/////////////////////////////////////////////////////////////////////////////
@test
def findLeft01(): Bool = HashMap.findLeft((k, v) -> k == v, empty(): HashMap[Unit, Unit]) == None

@test
def findLeft02(): Bool = HashMap.findLeft((k, v) -> k == v, singleton(1, 2)) == None

@test
def findLeft03(): Bool = HashMap.findLeft((k, v) -> k == v, singleton(1, 1)) == Some((1, 1))

@test
def findLeft04(): Bool = HashMap.findLeft((k, v) -> k == v, HashMap#{1 => 2, 2 => 3}) == None

@test
def findLeft05(): Bool = HashMap.findLeft((k, v) -> k == v, HashMap#{1 => 1, 2 => 3}) == Some((1, 1))

@test
def findLeft06(): Bool = HashMap.findLeft((k, v) -> k == v, HashMap#{1 => 2, 2 => 2}) == Some((2, 2))

@test
def findLeft07(): Bool = HashMap.findLeft((k, v) -> k == v, HashMap#{1 => 1, 2 => 2}) == Some((1, 1))

/////////////////////////////////////////////////////////////////////////////
// findRight                                                               //
/////////////////////////////////////////////////////////////////////////////
@test
def findRight01(): Bool = HashMap.findRight((k, v) -> k == v, empty(): HashMap[Unit, Unit]) == None

@test
def findRight02(): Bool = HashMap.findRight((k, v) -> k == v, singleton(1, 2)) == None

@test
def findRight03(): Bool = HashMap.findRight((k, v) -> k == v, singleton(1, 1)) == Some((1, 1))

@test
def findRight04(): Bool = HashMap.findRight((k, v) -> k == v, HashMap#{1 => 2, 2 => 3}) == None

@test
def findRight05(): Bool = HashMap.findRight((k, v) -> k == v, HashMap#{1 => 1, 2 => 3}) == Some((1, 1))

@test
def findRight06(): Bool = HashMap.findRight((k, v) -> k == v, HashMap#{1 => 2, 2 => 2}) == Some((2, 2))

@test
def findRight07(): Bool = HashMap.findRight((k, v) -> k == v, HashMap#{1 => 1, 2 => 2}) == Some((2, 2))

/////////////////////////////////////////////////////////////////////////////
// filter                                                                  //
/////////////////////////////////////////////////////////////////////////////
@test
def filter01(): Bool = HashMap.filter(v -> v rem 2 == 0, empty(): HashMap[Unit, _]) == empty()

@test
def filter02(): Bool = HashMap.filter(v -> v rem 2 == 0, singleton(1, 2)) == singleton(1, 2)

@test
def filter03(): Bool = HashMap.filter(v -> v rem 2 == 0, singleton(1, 3)) == empty()

@test
def filter04(): Bool = HashMap.filter(v -> v rem 2 == 0, HashMap#{1 => 8, 2 => 4}) == HashMap#{1 => 8, 2 => 4}

@test
def filter05(): Bool = HashMap.filter(v -> v rem 2 == 0, HashMap#{1 => 7, 2 => 4}) == singleton(2, 4)

@test
def filter06(): Bool = HashMap.filter(v -> v rem 2 == 0, HashMap#{1 => 8, 2 => 3}) == singleton(1, 8)

@test
def filter07(): Bool = HashMap.filter(v -> v rem 2 == 0, HashMap#{1 => -1, 2 => -3}) == empty()

/////////////////////////////////////////////////////////////////////////////
// filterWithKey                                                           //
/////////////////////////////////////////////////////////////////////////////
@test
def filterWithKey01(): Bool = HashMap.filterWithKey((k, v) -> k == v, empty(): HashMap[Unit, Unit]) == empty()

@test
def filterWithKey02(): Bool = HashMap.filterWithKey((k, v) -> k == v, singleton(1, 1)) == singleton(1, 1)

@test
def filterWithKey03(): Bool = HashMap.filterWithKey((k, v) -> k == v, singleton(1, 3)) == empty()

@test
def filterWithKey04(): Bool = HashMap.filterWithKey((k, v) -> k == v, HashMap#{1 => 1, 2 => 2}) == HashMap#{1 => 1, 2 => 2}

@test
def filterWithKey05(): Bool = HashMap.filterWithKey((k, v) -> k == v, HashMap#{1 => 7, 2 => 2}) == singleton(2, 2)

@test
def filterWithKey06(): Bool = HashMap.filterWithKey((k, v) -> k == v, HashMap#{1 => 1, 2 => 3}) == singleton(1, 1)

@test
def filterWithKey07(): Bool = HashMap.filterWithKey((k, v) -> k == v, HashMap#{1 => -1, 2 => -3}) == empty()

/////////////////////////////////////////////////////////////////////////////
// filterMap                                                               //
/////////////////////////////////////////////////////////////////////////////

@test
def filterMap01(): Bool = HashMap.filterMap(x -> if (x > 1) Some("${x}") else None, empty(): HashMap[Unit, _]) == empty()

@test
def filterMap02(): Bool = HashMap.filterMap(x -> if (x > 1) Some("${x}") else None, singleton(1, 1)) == empty()

@test
def filterMap03(): Bool =
    HashMap.filterMap(x -> if (x > 1) Some("${x}") else None, HashMap#{1 => 1, 2 => 2, 3 => 3, 4 => 4})
        == HashMap#{2 => "2", 3 => "3", 4 => "4"}

/////////////////////////////////////////////////////////////////////////////
// filterMapWithKey                                                        //
/////////////////////////////////////////////////////////////////////////////

@test
def filterMapWithKey01(): Bool = HashMap.filterMapWithKey((k, v) -> if (k == v and v > 1) Some("${v}") else None, empty(): HashMap[Int32, Int32]) == empty()

@test
def filterMapWithKey02(): Bool = HashMap.filterMapWithKey((k, v) -> if (k == v and v > 1) Some("${v}") else None, singleton(1, 1)) == empty()

@test
def filterMapWithKey03(): Bool =
    HashMap.filterMapWithKey((k, v) -> if (k == v and v > 1) Some("${v}") else None, HashMap#{1 => 1, 2 => 2, 3 => 3, 4 => 4})
        == HashMap#{2 => "2", 3 => "3", 4 => "4"}

/////////////////////////////////////////////////////////////////////////////
// map                                                                     //
/////////////////////////////////////////////////////////////////////////////
@test
def map01(): Bool = HashMap.map(v -> 3*v, empty(): HashMap[Unit, Int32]) == empty()

@test
def map02(): Bool = HashMap.map(v -> 3*v, singleton(1, 4)) == singleton(1, 12)

@test
def map03(): Bool = HashMap.map(v -> 3*v, HashMap#{2 => -1, 0 => 0}) == HashMap#{2 => -3, 0 => 0}

@test
def map04(): Bool = HashMap.map(v -> 3*v, HashMap#{2 => -1, 5 => 15, 11 => -9}) == HashMap#{2 => -3, 5 => 45, 11 => -27}

@test
def map05(): Bool = HashMap.map(v -> 3*v, HashMap#{2 => -1, 5 => 15, 11 => -9, 8 => 8}) == HashMap#{2 => -3, 5 => 45, 11 => -27, 8 => 24}

/////////////////////////////////////////////////////////////////////////////
// mapWithKey                                                              //
/////////////////////////////////////////////////////////////////////////////
@test
def mapWithKey01(): Bool = HashMap.mapWithKey((_, v) -> v, empty(): HashMap[Unit, Unit]) == empty()

@test
def mapWithKey02(): Bool = HashMap.mapWithKey((k, v) -> k + v, singleton(1, 4)) == singleton(1, 5)

@test
def mapWithKey03(): Bool = HashMap.mapWithKey((k, v) -> k + v, HashMap#{2 => -1, 0 => 0}) == HashMap#{2 => 1, 0 => 0}

@test
def mapWithKey04(): Bool = HashMap.mapWithKey((k, v) -> k + v, HashMap#{2 => -1, 5 => 15, 11 => -9}) == HashMap#{2 => 1, 5 => 20, 11 => 2}

@test
def mapWithKey05(): Bool = HashMap.mapWithKey((k, v) -> k + v, HashMap#{2 => -1, 5 => 15, 11 => -9, 8 => 8})
                                        == HashMap#{2 => 1, 5 => 20, 11 => 2, 8 => 16}

@test
def mapWithKey06(): Bool \ IO =
    let range = List.range(0, 2000);
    let m = List.zip(range, range) |> List.toMap;
    let a = new MutList(Static);
    discard HashMap.mapWithKey((k, v) -> { let b = new MutList(Static); MutList.push!(k, b); MutList.append!(MutList.toList(b), a); v }, m);
    MutList.toList(a) == range


/////////////////////////////////////////////////////////////////////////////
// foldWithKey                                                             //
/////////////////////////////////////////////////////////////////////////////
@test
def foldWithKey01(): Bool = HashMap.foldWithKey((k, s, v) -> k + s + v, 0, empty()) == 0

@test
def foldWithKey02(): Bool = HashMap.foldWithKey((k, s, v) -> k + s + v, 0, singleton(1, 2)) == 3

@test
def foldWithKey03(): Bool = HashMap.foldWithKey((k, s, v) -> k + s + v, 0, HashMap#{1 => 2, 3 => 4}) == 10

@test
def foldWithKey04(): Bool = HashMap.foldWithKey((k, s, v) -> k + s + v, 0, HashMap#{1 => 2, 3 => 4, 5 => 6}) == 21

/////////////////////////////////////////////////////////////////////////////
// foldLeft                                                                //
/////////////////////////////////////////////////////////////////////////////
@test
def foldLeft01(): Bool = HashMap.foldLeft((s, v) -> s + v, 0, empty()) == 0

@test
def foldLeft02(): Bool = HashMap.foldLeft((s, v) -> s + v, 0, singleton(1, 2)) == 2

@test
def foldLeft03(): Bool = HashMap.foldLeft((s, v) -> s + v, 0, HashMap#{1 => 2, 3 => 4}) == 6

@test
def foldLeft04(): Bool = HashMap.foldLeft((s, v) -> s + v, 0, HashMap#{1 => 2, 3 => 4, 5 => 6}) == 12

/////////////////////////////////////////////////////////////////////////////
// foldLeftWithKey                                                         //
/////////////////////////////////////////////////////////////////////////////
@test
def foldLeftWithKey01(): Bool = HashMap.foldLeftWithKey((s, k, v) -> k + s + v, 0, empty()) == 0

@test
def foldLeftWithKey02(): Bool = HashMap.foldLeftWithKey((s, k, v) -> k + s + v, 0, singleton(1, 2)) == 3

@test
def foldLeftWithKey03(): Bool = HashMap.foldLeftWithKey((s, k, v) -> k + s + v, 0, HashMap#{1 => 2, 3 => 4}) == 10

@test
def foldLeftWithKey04(): Bool = HashMap.foldLeftWithKey((s, k, v) -> k + s + v, 0, HashMap#{1 => 2, 3 => 4, 5 => 6}) == 21

/////////////////////////////////////////////////////////////////////////////
// foldRight                                                               //
/////////////////////////////////////////////////////////////////////////////
@test
def foldRight01(): Bool = HashMap.foldRight((v, acc) -> acc + v, 0, empty()) == 0

@test
def foldRight02(): Bool = HashMap.foldRight((v, acc) -> acc + v, 0, singleton(1, 2)) == 2

@test
def foldRight03(): Bool = HashMap.foldRight((v, acc) -> acc + v, 0, HashMap#{1 => 2, 3 => 4}) == 6

@test
def foldRight04(): Bool = HashMap.foldRight((v, acc) -> acc + v, 0, HashMap#{1 => 2, 3 => 4, 5 => 6}) == 12

/////////////////////////////////////////////////////////////////////////////
// foldRightWithKey                                                        //
/////////////////////////////////////////////////////////////////////////////
@test
def foldRightWithKey01(): Bool = HashMap.foldRightWithKey((k, v, acc) -> k + acc + v, 0, empty()) == 0

@test
def foldRightWithKey02(): Bool = HashMap.foldRightWithKey((k, v, acc) -> k + acc + v, 0, singleton(1, 2)) == 3

@test
def foldRightWithKey03(): Bool = HashMap.foldRightWithKey((k, v, acc) -> k + acc + v, 0, HashMap#{1 => 2, 3 => 4}) == 10

@test
def foldRightWithKey04(): Bool = HashMap.foldRightWithKey((k, v, acc) -> k + acc + v, 0, HashMap#{1 => 2, 3 => 4, 5 => 6}) == 21

/////////////////////////////////////////////////////////////////////////////
// foldRightWithCont                                                       //
/////////////////////////////////////////////////////////////////////////////
@test
def foldRightWithCont01(): Bool = HashMap.foldRightWithCont((v, k) -> k() + v, 0, empty()) == 0

@test
def foldRightWithCont02(): Bool = HashMap.foldRightWithCont((v, k) -> k() + v, 0, singleton(1, 2)) == 2

@test
def foldRightWithCont03(): Bool = HashMap.foldRightWithCont((v, k) -> k() + v, 0, HashMap#{1 => 2, 3 => 4}) == 6

@test
def foldRightWithCont04(): Bool = HashMap.foldRightWithCont((v, k) -> k() + v, 0, HashMap#{1 => 2, 3 => 4, 5 => 6}) == 12

/////////////////////////////////////////////////////////////////////////////
// foldRightWithKeyCont                                                    //
/////////////////////////////////////////////////////////////////////////////
@test
def foldRightWithKeyCont01(): Bool = HashMap.foldRightWithKeyCont((k, v, c) -> k + c() + v, 0, empty()) == 0

@test
def foldRightWithKeyCont02(): Bool = HashMap.foldRightWithKeyCont((k, v, c) -> k + c() + v, 0, singleton(1, 2)) == 3

@test
def foldRightWithKeyCont03(): Bool = HashMap.foldRightWithKeyCont((k, v, c) -> k + c() + v, 0, HashMap#{1 => 2, 3 => 4}) == 10

@test
def foldRightWithKeyCont04(): Bool = HashMap.foldRightWithKeyCont((k, v, c) -> k + c() + v, 0, HashMap#{1 => 2, 3 => 4, 5 => 6}) == 21

/////////////////////////////////////////////////////////////////////////////
// foldMapWithKey                                                          //
/////////////////////////////////////////////////////////////////////////////

@test
def foldMapWithKey01(): Bool = HashMap.foldMapWithKey((k, v) -> k + v, empty()) == 0

@test
def foldMapWithKey02(): Bool = HashMap.foldMapWithKey((k, v) -> k + v, HashMap#{1 => 2, 3 => 5}) == (1 + 2 + 3 + 5)

@test
def foldMapWithKey03(): Bool =
    HashMap.foldMapWithKey((k, v) -> 2 * (k + v), HashMap#{1 => 2, 3 => 5}) == (2 * (1 + 2) + 2 * (3 + 5))

@test
def foldMapWithKey04(): Bool = HashMap.foldMapWithKey((k, v) -> "${k}" + v, HashMap#{1 => "a", 2 => "b"}) == "1a2b"

/////////////////////////////////////////////////////////////////////////////
// foldMap                                                                 //
/////////////////////////////////////////////////////////////////////////////

@test
def foldMap01(): Bool =
    HashMap.foldMap(v -> v + 1, empty()) == 0

@test
def foldMap02(): Bool =
    HashMap.foldMap(v -> v + 1, HashMap#{1 => 2, 3 => 5}) == (2 + 1) + (5 + 1)

@test
def foldMap03(): Bool =
    HashMap.foldMap(v -> 2 * v, HashMap#{1 => 2, 3 => 5}) == (2 * 2) + (2 * 5)

@test
def foldMap04(): Bool =
    HashMap.foldMap(v -> "x" + v, HashMap#{1 => "a", 2 => "b"}) == "xaxb"

/////////////////////////////////////////////////////////////////////////////
// reduceLeft                                                              //
/////////////////////////////////////////////////////////////////////////////
@test
def reduceLeft01(): Bool = HashMap.reduceLeft((v1, v2) -> v1 - v2, empty(): HashMap[Int32, Int32]) == None

@test
def reduceLeft02(): Bool = HashMap.reduceLeft((v1, v2) -> v1 - v2, singleton(1, 2)) == Some(2)

@test
def reduceLeft03(): Bool = HashMap.reduceLeft((v1, v2) -> v1 - v2, HashMap#{1 => 2, 2 => 3}) == Some(-1)

@test
def reduceLeft04(): Bool = HashMap.reduceLeft((v1, v2) -> v1 - v2, HashMap#{1 => 2, 2 => 3, 3 => 4}) == Some(-5)

/////////////////////////////////////////////////////////////////////////////
// reduceLeftWithKey                                                       //
/////////////////////////////////////////////////////////////////////////////
@test
def reduceLeftWithKey01(): Bool = HashMap.reduceLeftWithKey((k1, v1, k2, v2) -> (k1 - k2, v1 - v2), empty(): HashMap[Int32, Int32]) == None

@test
def reduceLeftWithKey02(): Bool = HashMap.reduceLeftWithKey((k1, v1, k2, v2) -> (k1 - k2, v1 - v2), singleton(1, 2)) == Some((1, 2))

@test
def reduceLeftWithKey03(): Bool = HashMap.reduceLeftWithKey((k1, v1, k2, v2) -> (k1 - k2, v1 - v2), HashMap#{1 => 2, 2 => 3}) == Some((-1, -1))

@test
def reduceLeftWithKey04(): Bool = HashMap.reduceLeftWithKey((k1, v1, k2, v2) -> (k1 - k2, v1 - v2), HashMap#{1 => 2, 2 => 3, 3 => 4}) == Some((-4, -5))

/////////////////////////////////////////////////////////////////////////////
// reduceRight                                                             //
/////////////////////////////////////////////////////////////////////////////
@test
def reduceRight01(): Bool = HashMap.reduceRight((v1, v2) -> v1 - v2, empty(): HashMap[Int32, Int32]) == None

@test
def reduceRight02(): Bool = HashMap.reduceRight((v1, v2) -> v1 - v2, singleton(1, 2)) == Some(2)

@test
def reduceRight03(): Bool = HashMap.reduceRight((v1, v2) -> v1 - v2, HashMap#{1 => 2, 2 => 3}) == Some(-1)

@test
def reduceRight04(): Bool = HashMap.reduceRight((v1, v2) -> v1 - v2, HashMap#{1 => 2, 2 => 3, 3 => 4}) == Some(3)

/////////////////////////////////////////////////////////////////////////////
// reduceRightWithKey                                                      //
/////////////////////////////////////////////////////////////////////////////
@test
def reduceRightWithKey01(): Bool = HashMap.reduceRightWithKey((k1, v1, k2, v2) -> (k1 - k2, v1 - v2), empty(): HashMap[Int32, Int32]) == None

@test
def reduceRightWithKey02(): Bool = HashMap.reduceRightWithKey((k1, v1, k2, v2) -> (k1 - k2, v1 - v2), singleton(1, 2)) == Some((1, 2))

@test
def reduceRightWithKey03(): Bool = HashMap.reduceRightWithKey((k1, v1, k2, v2) -> (k1 - k2, v1 - v2), HashMap#{1 => 2, 2 => 3}) == Some((-1, -1))

@test
def reduceRightWithKey04(): Bool = HashMap.reduceRightWithKey((k1, v1, k2, v2) -> (k1 - k2, v1 - v2), HashMap#{1 => 2, 2 => 3, 3 => 4}) == Some((2 , 3))

/////////////////////////////////////////////////////////////////////////////
// count                                                                   //
/////////////////////////////////////////////////////////////////////////////
@test
def count01(): Bool = HashMap.count((k, v) -> k == v, empty(): HashMap[Unit, Unit]) == 0

@test
def count02(): Bool = HashMap.count((k, v) -> k == v, singleton(1, 2)) == 0

@test
def count03(): Bool = HashMap.count((k, v) -> k == v, singleton(1, 1)) == 1

@test
def count04(): Bool = HashMap.count((k, v) -> k == v, HashMap#{1 => 2, 2 => 3}) == 0

@test
def count05(): Bool = HashMap.count((k, v) -> k == v, HashMap#{1 => 1, 2 => 3}) == 1

@test
def count06(): Bool = HashMap.count((k, v) -> k == v, HashMap#{1 => 2, 2 => 2}) == 1

@test
def count07(): Bool = HashMap.count((k, v) -> k == v, HashMap#{1 => 1, 2 => 2}) == 2

@test
def count08(): Bool \ IO =
    let range = List.range(0, 2000);
    let m = List.zip(range, range) |> List.toMap;
    let a = new MutList(Static);
    discard HashMap.count((k, _) -> { let b = new MutList(Static); MutList.push!(k, b); MutList.append!(MutList.toList(b), a); true }, m);
    MutList.toList(a) == range


    /////////////////////////////////////////////////////////////////////////////
    // sumValues                                                               //
    /////////////////////////////////////////////////////////////////////////////

    @test
    def sumValues01(): Bool =
        HashMap.empty() |> HashMap.sumValues == 0

    @test
    def sumValues02(): Bool =
        singleton(1, 1) |>
            HashMap.sumValues == 1

    @test
    def sumValues03(): Bool =
        HashMap#{1 => 1, 2 => 2, 3 => 3} |>
            HashMap.sumValues == 6

    @test
    def sumValues04(): Bool =
        HashMap#{1 => 1, 2 => 2, 3 => 3, -3 => -3} |>
            HashMap.sumValues == 3

    @test
    def sumValues05(): Bool =
        HashMap#{-1 => -1, -2 => -2, -3 => -3, -4 => -4} |>
            HashMap.sumValues == -10

    @test
    def sumValues06(): Bool =
        HashMap#{10 => 10, -10 => -10} |>
            HashMap.sumValues == 0

    @test
    def sumValues07(): Bool =
        List.range(1, 101) |> List.zip(List.range(1, 101)) |> List.toMap |>
            HashMap.sumValues == 5050


    /////////////////////////////////////////////////////////////////////////////
    // sumKeys                                                                 //
    /////////////////////////////////////////////////////////////////////////////

    @test
    def sumKeys01(): Bool =
        HashMap.empty() |> HashMap.sumKeys == 0

    @test
    def sumKeys02(): Bool =
        singleton(1, 1) |>
            HashMap.sumKeys == 1

    @test
    def sumKeys03(): Bool =
        HashMap#{1 => 1, 2 => 2, 3 => 3} |>
            HashMap.sumKeys == 6

    @test
    def sumKeys04(): Bool =
        HashMap#{1 => 1, 2 => 2, 3 => 3, -3 => -3} |>
            HashMap.sumKeys == 3

    @test
    def sumKeys05(): Bool =
        HashMap#{-1 => -1, -2 => -2, -5 => -3, -4 => -4} |>
            HashMap.sumKeys == -12

    @test
    def sumKeys06(): Bool =
        HashMap#{10 => 10, -10 => -10} |>
            HashMap.sumKeys == 0

    @test
    def sumKeys07(): Bool =
        List.range(1, 101) |> List.zip(List.range(1, 101)) |> List.toMap |>
            HashMap.sumKeys == 5050


    /////////////////////////////////////////////////////////////////////////////
    // sumWith                                                                 //
    /////////////////////////////////////////////////////////////////////////////

    @test
    def sumWith01(): Bool =
        HashMap.empty() |> HashMap.sumWith((k, v) -> k + v) == 0

    @test
    def sumWith02(): Bool =
        singleton(1, 1) |>
            HashMap.sumWith((k, v) -> k + v) == 2

    @test
    def sumWith03(): Bool =
        HashMap#{1 => 1, 2 => 2, 3 => 3} |>
            HashMap.sumWith((k, v) -> k + v) == 12

    @test
    def sumWith04(): Bool =
        HashMap#{1 => 1, 2 => 2, 3 => 3, -3 => -3} |>
            HashMap.sumWith((k, v) -> k + v) == 6

    @test
    def sumWith05(): Bool =
        HashMap#{-1 => -1, -2 => -2, -3 => -3, -4 => -4} |>
            HashMap.sumWith((k, v) -> k + v) == -20

    @test
    def sumWith06(): Bool =
        HashMap#{10 => 10, -10 => -10} |>
            HashMap.sumWith((k, v) -> k + v) == 0

    @test
    def sumWith07(): Bool \ IO =
        let range = List.range(0, 2000);
        let m = List.zip(range, range) |> List.toMap;
        let a = new MutList(Static);
        discard HashMap.sumWith((k, _) -> { let b = new MutList(Static); MutList.push!(k, b); MutList.append!(MutList.toList(b), a); 1 }, m);
        MutList.toList(a) == range


    /////////////////////////////////////////////////////////////////////////////
    // productValues                                                           //
    /////////////////////////////////////////////////////////////////////////////

    @test
    def productValues01(): Bool =
        HashMap.empty() |> HashMap.productValues == 1

    @test
    def productValues02(): Bool =
        singleton(1, 1) |>
            HashMap.productValues == 1

    @test
    def productValues03(): Bool =
        HashMap#{1 => 1, 2 => 2, 3 => 3} |>
            HashMap.productValues == 6

    @test
    def productValues04(): Bool =
        HashMap#{1 => 1, 2 => 2, 3 => 3, -3 => -3} |>
            HashMap.productValues == -18

    @test
    def productValues05(): Bool =
        HashMap#{-1 => -1, -2 => -2, -5 => -3, -4 => -4} |>
            HashMap.productValues == 24

    @test
    def productValues06(): Bool =
        HashMap#{10 => 10, -10 => -10} |>
            HashMap.productValues == -100


    /////////////////////////////////////////////////////////////////////////////
    // productKeys                                                             //
    /////////////////////////////////////////////////////////////////////////////

    @test
    def productKeys01(): Bool =
        HashMap.empty() |> HashMap.productValues == 1

    @test
    def productKeys02(): Bool =
        singleton(1, 1) |>
            HashMap.productKeys == 1

    @test
    def productKeys03(): Bool =
        HashMap#{1 => 1, 2 => 2, 3 => 3} |>
            HashMap.productKeys == 6

    @test
    def productKeys04(): Bool =
        HashMap#{1 => 1, 2 => 2, 3 => 3, -3 => -3} |>
            HashMap.productKeys == -18

    @test
    def productKeys05(): Bool =
        HashMap#{-1 => -1, -2 => -2, -5 => -3, -4 => -4} |>
            HashMap.productKeys == 40

    @test
    def productKeys06(): Bool =
        HashMap#{10 => 10, -10 => -10} |>
            HashMap.productKeys == -100


    /////////////////////////////////////////////////////////////////////////////
    // productWith                                                             //
    /////////////////////////////////////////////////////////////////////////////

    @test
    def productWith01(): Bool =
        HashMap.empty() |> HashMap.productWith((k, v) -> k + v) == 1

    @test
    def productWith02(): Bool =
        singleton(1, 1) |>
            HashMap.productWith((k, v) -> k + v) == 2

    @test
    def productWith03(): Bool =
        HashMap#{1 => 1, 2 => 2, 3 => 3} |>
            HashMap.productWith((k, v) -> k + v) == 48

    @test
    def productWith04(): Bool =
        HashMap#{1 => 1, 2 => 2, 3 => 3, -3 => -3} |>
            HashMap.productWith((k, v) -> k + v) == -288

    @test
    def productWith05(): Bool =
        HashMap#{-1 => -1, -2 => -2, -3 => -3, -4 => -4} |>
            HashMap.productWith((k, v) -> k + v) == 384

    @test
    def productWith06(): Bool =
        HashMap#{10 => 10, -10 => -10} |>
            HashMap.productWith((k, v) -> k + v) == -400

    @test
    def productWith07(): Bool \ IO =
        let range = List.range(0, 2000);
        let m = List.zip(range, range) |> List.toMap;
        let a = new MutList(Static);
        discard HashMap.productWith((k, _) -> { let b = new MutList(Static); MutList.push!(k, b); MutList.append!(MutList.toList(b), a); 1 }, m);
        MutList.toList(a) == range


/////////////////////////////////////////////////////////////////////////////
// exists                                                                  //
/////////////////////////////////////////////////////////////////////////////
@test
def exists01(): Bool = not HashMap.exists((k, v) -> k == v, empty(): HashMap[Unit, Unit])

@test
def exists02(): Bool = not HashMap.exists((k, v) -> k == v, singleton(1, 2))

@test
def exists03(): Bool = HashMap.exists((k, v) -> k == v, singleton(1, 1))

@test
def exists04(): Bool = not HashMap.exists((k, v) -> k == v, HashMap#{1 => 2, 2 => 3})

@test
def exists05(): Bool = HashMap.exists((k, v) -> k == v, HashMap#{1 => 1, 2 => 3})

@test
def exists06(): Bool = HashMap.exists((k, v) -> k == v, HashMap#{1 => 2, 2 => 2})

@test
def exists07(): Bool = HashMap.exists((k, v) -> k == v, HashMap#{1 => 1, 2 => 2})

/////////////////////////////////////////////////////////////////////////////
// forall                                                                  //
/////////////////////////////////////////////////////////////////////////////
@test
def forall01(): Bool = HashMap.forall((k, v) -> k == v, empty(): HashMap[Unit, Unit])

@test
def forall02(): Bool = not HashMap.forall((k, v) -> k == v, singleton(1, 2))

@test
def forall03(): Bool = HashMap.forall((k, v) -> k == v, singleton(1, 1))

@test
def forall04(): Bool = not HashMap.forall((k, v) -> k == v, HashMap#{1 => 2, 2 => 3})

@test
def forall05(): Bool = not HashMap.forall((k, v) -> k == v, HashMap#{1 => 1, 2 => 3})

@test
def forall06(): Bool = not HashMap.forall((k, v) -> k == v, HashMap#{1 => 2, 2 => 2})

@test
def forall07(): Bool = HashMap.forall((k, v) -> k == v, HashMap#{1 => 1, 2 => 2})

/////////////////////////////////////////////////////////////////////////////
// union                                                                   //
/////////////////////////////////////////////////////////////////////////////
@test
def union01(): Bool = HashMap.union(empty(): HashMap[Unit, Unit], empty()) == empty()

@test
def union02(): Bool = HashMap.union(singleton(1, 2), empty()) == singleton(1, 2)

@test
def union03(): Bool = HashMap.union(empty(), singleton(1, 2)) == singleton(1, 2)

@test
def union04(): Bool = HashMap.union(empty(), HashMap#{1 => 2, 3 => 4}) == HashMap#{1 => 2, 3 => 4}

@test
def union05(): Bool = HashMap.union(HashMap#{1 => 2, 3 => 4}, empty()) == HashMap#{1 => 2, 3 => 4}

@test
def union06(): Bool = HashMap.union(singleton(1, 2), singleton(3, 4)) == HashMap#{1 => 2, 3 => 4}

@test
def union07(): Bool = HashMap.union(singleton(1, 2), singleton(1, 5)) == singleton(1, 2)

@test
def union08(): Bool = HashMap.union(empty(), HashMap#{1 => 2, 2 => 3, 3 => 4}) == HashMap#{1 => 2, 2 => 3, 3 => 4}

@test
def union09(): Bool = HashMap.union(HashMap#{1 => 2, 2 => 3, 3 => 4}, empty()) == HashMap#{1 => 2, 2 => 3, 3 => 4}

@test
def union10(): Bool = HashMap.union(HashMap#{1 => 2, 2 => 3}, singleton(3, 4)) == HashMap#{1 => 2, 2 => 3, 3 => 4}

@test
def union11(): Bool = HashMap.union(singleton(3, 4), HashMap#{1 => 2, 2 => 3}) == HashMap#{1 => 2, 2 => 3, 3 => 4}

@test
def union12(): Bool = HashMap.union(HashMap#{1 => 2, 2 => 3}, singleton(2, 8)) == HashMap#{1 => 2, 2 => 3}

@test
def union13(): Bool = HashMap.union(HashMap#{1 => 2, 2 => 3}, singleton(1, 8)) == HashMap#{1 => 2, 2 => 3}

@test
def union14(): Bool = HashMap.union(singleton(1, 4), HashMap#{1 => 2, 2 => 3}) == HashMap#{1 => 4, 2 => 3}

@test
def union15(): Bool = HashMap.union(singleton(2, 7), HashMap#{1 => 2, 2 => 3}) == HashMap#{1 => 2, 2 => 7}

@test
def union16(): Bool = HashMap.union(HashMap#{2 => 7, 11 => 14, 9 => 8, 15 => 22}, HashMap#{15 => 21, 1 => 2, 2 => 8, 44 => 33})
                                   == HashMap#{2 => 7, 11 => 14, 9 => 8, 15 => 22, 1 => 2, 44 => 33}

/////////////////////////////////////////////////////////////////////////////
// unionWith                                                               //
/////////////////////////////////////////////////////////////////////////////
@test
def unionWith01(): Bool = HashMap.unionWith((v1, v2) -> v1 - v2, empty(), empty()) == empty(): HashMap[Int32, Int32]

@test
def unionWith02(): Bool = HashMap.unionWith((v1, v2) -> v1 - v2, singleton(1, 2), empty()) == singleton(1, 2)

@test
def unionWith03(): Bool = HashMap.unionWith((v1, v2) -> v1 - v2, empty(), singleton(1, 2)) == singleton(1, 2)

@test
def unionWith04(): Bool = HashMap.unionWith((v1, v2) -> v1 - v2, empty(), HashMap#{1 => 2, 3 => 4}) == HashMap#{1 => 2, 3 => 4}

@test
def unionWith05(): Bool = HashMap.unionWith((v1, v2) -> v1 - v2, HashMap#{1 => 2, 3 => 4}, empty()) == HashMap#{1 => 2, 3 => 4}

@test
def unionWith06(): Bool = HashMap.unionWith((v1, v2) -> v1 - v2, singleton(1, 2), singleton(3, 4)) == HashMap#{1 => 2, 3 => 4}

@test
def unionWith07(): Bool = HashMap.unionWith((v1, v2) -> v1 - v2, singleton(1, 2), singleton(1, 5)) == singleton(1, -3)

@test
def unionWith08(): Bool = HashMap.unionWith((v1, v2) -> v1 - v2, empty(), HashMap#{1 => 2, 2 => 3, 3 => 4}) == HashMap#{1 => 2, 2 => 3, 3 => 4}

@test
def unionWith09(): Bool = HashMap.unionWith((v1, v2) -> v1 - v2, HashMap#{1 => 2, 2 => 3, 3 => 4}, empty()) == HashMap#{1 => 2, 2 => 3, 3 => 4}

@test
def unionWith10(): Bool = HashMap.unionWith((v1, v2) -> v1 - v2, HashMap#{1 => 2, 2 => 3}, singleton(3, 4)) == HashMap#{1 => 2, 2 => 3, 3 => 4}

@test
def unionWith11(): Bool = HashMap.unionWith((v1, v2) -> v1 - v2, singleton(3, 4), HashMap#{1 => 2, 2 => 3}) == HashMap#{1 => 2, 2 => 3, 3 => 4}

@test
def unionWith12(): Bool = HashMap.unionWith((v1, v2) -> v1 - v2, HashMap#{1 => 2, 2 => 3}, singleton(2, 8)) == HashMap#{1 => 2, 2 => -5}

@test
def unionWith13(): Bool = HashMap.unionWith((v1, v2) -> v1 - v2, HashMap#{1 => 2, 2 => 3}, singleton(1, 8)) == HashMap#{1 => -6, 2 => 3}

@test
def unionWith14(): Bool = HashMap.unionWith((v1, v2) -> v1 - v2, singleton(1, 4), HashMap#{1 => 2, 2 => 3}) == HashMap#{1 => 2, 2 => 3}

@test
def unionWith15(): Bool = HashMap.unionWith((v1, v2) -> v1 - v2, singleton(2, 7), HashMap#{1 => 2, 2 => 3}) == HashMap#{1 => 2, 2 => 4}

@test
def unionWith16(): Bool = HashMap.unionWith((v1, v2) -> v1 - v2, HashMap#{2 => 7, 11 => 14, 9 => 8, 15 => 22}, HashMap#{15 => 21, 1 => 2, 2 => 8, 44 => 33})
                                   == HashMap#{2 => -1, 11 => 14, 9 => 8, 15 => 1, 1 => 2, 44 => 33}

/////////////////////////////////////////////////////////////////////////////
// unionWithKey                                                            //
/////////////////////////////////////////////////////////////////////////////
@test
def unionWithKey01(): Bool = HashMap.unionWithKey((k, v1, v2) -> k + v1 - v2, empty(), empty()) == empty(): HashMap[Int32, Int32]

@test
def unionWithKey02(): Bool = HashMap.unionWithKey((k, v1, v2) -> k + v1 - v2, singleton(1, 2), empty()) == singleton(1, 2)

@test
def unionWithKey03(): Bool = HashMap.unionWithKey((k, v1, v2) -> k + v1 - v2, empty(), singleton(1, 2)) == singleton(1, 2)

@test
def unionWithKey04(): Bool = HashMap.unionWithKey((k, v1, v2) -> k + v1 - v2, empty(), HashMap#{1 => 2, 3 => 4}) == HashMap#{1 => 2, 3 => 4}

@test
def unionWithKey05(): Bool = HashMap.unionWithKey((k, v1, v2) -> k + v1 - v2, HashMap#{1 => 2, 3 => 4}, empty()) == HashMap#{1 => 2, 3 => 4}

@test
def unionWithKey06(): Bool = HashMap.unionWithKey((k, v1, v2) -> k + v1 - v2, singleton(1, 2), singleton(3, 4)) == HashMap#{1 => 2, 3 => 4}

@test
def unionWithKey07(): Bool = HashMap.unionWithKey((k, v1, v2) -> k + v1 - v2, singleton(1, 2), singleton(1, 5)) == singleton(1, -2)

@test
def unionWithKey08(): Bool = HashMap.unionWithKey((k, v1, v2) -> k + v1 - v2, empty(), HashMap#{1 => 2, 2 => 3, 3 => 4}) == HashMap#{1 => 2, 2 => 3, 3 => 4}

@test
def unionWithKey09(): Bool = HashMap.unionWithKey((k, v1, v2) -> k + v1 - v2, HashMap#{1 => 2, 2 => 3, 3 => 4}, empty()) == HashMap#{1 => 2, 2 => 3, 3 => 4}

@test
def unionWithKey10(): Bool = HashMap.unionWithKey((k, v1, v2) -> k + v1 - v2, HashMap#{1 => 2, 2 => 3}, singleton(3, 4)) == HashMap#{1 => 2, 2 => 3, 3 => 4}

@test
def unionWithKey11(): Bool = HashMap.unionWithKey((k, v1, v2) -> k + v1 - v2, singleton(3, 4), HashMap#{1 => 2, 2 => 3}) == HashMap#{1 => 2, 2 => 3, 3 => 4}

@test
def unionWithKey12(): Bool = HashMap.unionWithKey((k, v1, v2) -> k + v1 - v2, HashMap#{1 => 2, 2 => 3}, singleton(2, 8)) == HashMap#{1 => 2, 2 => -3}

@test
def unionWithKey13(): Bool = HashMap.unionWithKey((k, v1, v2) -> k + v1 - v2, HashMap#{1 => 2, 2 => 3}, singleton(1, 8)) == HashMap#{1 => -5, 2 => 3}

@test
def unionWithKey14(): Bool = HashMap.unionWithKey((k, v1, v2) -> k + v1 - v2, singleton(1, 4), HashMap#{1 => 2, 2 => 3}) == HashMap#{1 => 3, 2 => 3}

@test
def unionWithKey15(): Bool = HashMap.unionWithKey((k, v1, v2) -> k + v1 - v2, singleton(2, 7), HashMap#{1 => 2, 2 => 3}) == HashMap#{1 => 2, 2 => 6}

@test
def unionWithKey16(): Bool = HashMap.unionWithKey((k, v1, v2) -> k + v1 - v2, HashMap#{2 => 7, 11 => 14, 9 => 8, 15 => 22}, HashMap#{15 => 21, 1 => 2, 2 => 8, 44 => 33})
                                   == HashMap#{2 => 1, 11 => 14, 9 => 8, 15 => 16, 1 => 2, 44 => 33}

/////////////////////////////////////////////////////////////////////////////
// intersection                                                            //
/////////////////////////////////////////////////////////////////////////////
@test
def intersection01(): Bool = HashMap.intersection(empty(): HashMap[Unit, Unit], empty()) == empty()

@test
def intersection02(): Bool = HashMap.intersection(singleton(1, 2), empty()) == empty()

@test
def intersection03(): Bool = HashMap.intersection(empty(), singleton(1, 2)) == empty()

@test
def intersection04(): Bool = HashMap.intersection(empty(), HashMap#{1 => 2, 3 => 4}) == empty()

@test
def intersection05(): Bool = HashMap.intersection(HashMap#{1 => 2, 3 => 4}, empty()) == empty()

@test
def intersection06(): Bool = HashMap.intersection(singleton(1, 2), singleton(3, 4)) == empty()

@test
def intersection07(): Bool = HashMap.intersection(singleton(1, 2), singleton(1, 5)) == singleton(1, 2)

@test
def intersection08(): Bool = HashMap.intersection(empty(), HashMap#{1 => 2, 2 => 3, 3 => 4}) == empty()

@test
def intersection09(): Bool = HashMap.intersection(HashMap#{1 => 2, 2 => 3, 3 => 4}, empty()) == empty()

@test
def intersection10(): Bool = HashMap.intersection(HashMap#{1 => 2, 2 => 3}, singleton(3, 4)) == empty()

@test
def intersection11(): Bool = HashMap.intersection(singleton(3, 4), HashMap#{1 => 2, 2 => 3}) == empty()

@test
def intersection12(): Bool = HashMap.intersection(HashMap#{1 => 2, 2 => 3}, singleton(2, 8)) == singleton(2, 3)

@test
def intersection13(): Bool = HashMap.intersection(HashMap#{1 => 2, 2 => 3}, singleton(1, 8)) == singleton(1, 2)

@test
def intersection14(): Bool = HashMap.intersection(singleton(1, 4), HashMap#{1 => 2, 2 => 3}) == singleton(1, 4)

@test
def intersection15(): Bool = HashMap.intersection(singleton(2, 7), HashMap#{1 => 2, 2 => 3}) == singleton(2, 7)

@test
def intersection16(): Bool = HashMap.intersection(HashMap#{2 => 7, 11 => 14, 9 => 8, 15 => 22}, HashMap#{15 => 21, 1 => 2, 2 => 8, 44 => 33, 11 => 1})
                                   == HashMap#{2 => 7, 15 => 22, 11 => 14}

/////////////////////////////////////////////////////////////////////////////
// intersectionWith                                                        //
/////////////////////////////////////////////////////////////////////////////
@test
def intersectionWith01(): Bool = HashMap.intersectionWith((v1, v2) -> v1 - v2, empty(), empty()) == empty(): HashMap[Int32, Int32]

@test
def intersectionWith02(): Bool = HashMap.intersectionWith((v1, v2) -> v1 - v2, singleton(1, 2), empty()) == empty()

@test
def intersectionWith03(): Bool = HashMap.intersectionWith((v1, v2) -> v1 - v2, empty(), singleton(1, 2)) == empty()

@test
def intersectionWith04(): Bool = HashMap.intersectionWith((v1, v2) -> v1 - v2, empty(), HashMap#{1 => 2, 3 => 4}) == empty()

@test
def intersectionWith05(): Bool = HashMap.intersectionWith((v1, v2) -> v1 - v2, HashMap#{1 => 2, 3 => 4}, empty()) == empty()

@test
def intersectionWith06(): Bool = HashMap.intersectionWith((v1, v2) -> v1 - v2, singleton(1, 2), singleton(3, 4)) == empty()

@test
def intersectionWith07(): Bool = HashMap.intersectionWith((v1, v2) -> v1 - v2, singleton(1, 2), singleton(1, 5)) == singleton(1, -3)

@test
def intersectionWith08(): Bool = HashMap.intersectionWith((v1, v2) -> v1 - v2, empty(), HashMap#{1 => 2, 2 => 3, 3 => 4}) == empty()

@test
def intersectionWith09(): Bool = HashMap.intersectionWith((v1, v2) -> v1 - v2, HashMap#{1 => 2, 2 => 3, 3 => 4}, empty()) == empty()

@test
def intersectionWith10(): Bool = HashMap.intersectionWith((v1, v2) -> v1 - v2, HashMap#{1 => 2, 2 => 3}, singleton(3, 4)) == empty()

@test
def intersectionWith11(): Bool = HashMap.intersectionWith((v1, v2) -> v1 - v2, singleton(3, 4), HashMap#{1 => 2, 2 => 3}) == empty()

@test
def intersectionWith12(): Bool = HashMap.intersectionWith((v1, v2) -> v1 - v2, HashMap#{1 => 2, 2 => 3}, singleton(2, 8)) == singleton(2, -5)

@test
def intersectionWith13(): Bool = HashMap.intersectionWith((v1, v2) -> v1 - v2, HashMap#{1 => 2, 2 => 3}, singleton(1, 8)) == singleton(1, -6)

@test
def intersectionWith14(): Bool = HashMap.intersectionWith((v1, v2) -> v1 - v2, singleton(1, 4), HashMap#{1 => 2, 2 => 3}) == singleton(1, 2)

@test
def intersectionWith15(): Bool = HashMap.intersectionWith((v1, v2) -> v1 - v2, singleton(2, 7), HashMap#{1 => 2, 2 => 3}) == singleton(2, 4)

@test
def intersectionWith16(): Bool = HashMap.intersectionWith((v1, v2) -> v1 - v2, HashMap#{2 => 7, 11 => 14, 9 => 8, 15 => 22}, HashMap#{15 => 21, 1 => 2, 2 => 8, 44 => 33, 11 => 11})
                                   == HashMap#{2 => -1, 15 => 1, 11 => 3}

/////////////////////////////////////////////////////////////////////////////
// intersectionWithKey                                                     //
/////////////////////////////////////////////////////////////////////////////
@test
def intersectionWithKey01(): Bool = HashMap.intersectionWithKey((k, v1, v2) -> k + v1 - v2, empty(), empty()) == empty(): HashMap[Int32, Int32]

@test
def intersectionWithKey02(): Bool = HashMap.intersectionWithKey((k, v1, v2) -> k + v1 - v2, singleton(1, 2), empty()) == empty()

@test
def intersectionWithKey03(): Bool = HashMap.intersectionWithKey((k, v1, v2) -> k + v1 - v2, empty(), singleton(1, 2)) == empty()

@test
def intersectionWithKey04(): Bool = HashMap.intersectionWithKey((k, v1, v2) -> k + v1 - v2, empty(), HashMap#{1 => 2, 3 => 4}) == empty()

@test
def intersectionWithKey05(): Bool = HashMap.intersectionWithKey((k, v1, v2) -> k + v1 - v2, HashMap#{1 => 2, 3 => 4}, empty()) == empty()

@test
def intersectionWithKey06(): Bool = HashMap.intersectionWithKey((k, v1, v2) -> k + v1 - v2, singleton(1, 2), singleton(3, 4)) == empty()

@test
def intersectionWithKey07(): Bool = HashMap.intersectionWithKey((k, v1, v2) -> k + v1 - v2, singleton(1, 2), singleton(1, 5)) == singleton(1, -2)

@test
def intersectionWithKey08(): Bool = HashMap.intersectionWithKey((k, v1, v2) -> k + v1 - v2, empty(), HashMap#{1 => 2, 2 => 3, 3 => 4}) == empty()

@test
def intersectionWithKey09(): Bool = HashMap.intersectionWithKey((k, v1, v2) -> k + v1 - v2, HashMap#{1 => 2, 2 => 3, 3 => 4}, empty()) == empty()

@test
def intersectionWithKey10(): Bool = HashMap.intersectionWithKey((k, v1, v2) -> k + v1 - v2, HashMap#{1 => 2, 2 => 3}, singleton(3, 4)) == empty()

@test
def intersectionWithKey11(): Bool = HashMap.intersectionWithKey((k, v1, v2) -> k + v1 - v2, singleton(3, 4), HashMap#{1 => 2, 2 => 3}) == empty()

@test
def intersectionWithKey12(): Bool = HashMap.intersectionWithKey((k, v1, v2) -> k + v1 - v2, HashMap#{1 => 2, 2 => 3}, singleton(2, 8)) == singleton(2, -3)

@test
def intersectionWithKey13(): Bool = HashMap.intersectionWithKey((k, v1, v2) -> k + v1 - v2, HashMap#{1 => 2, 2 => 3}, singleton(1, 8)) == singleton(1, -5)

@test
def intersectionWithKey14(): Bool = HashMap.intersectionWithKey((k, v1, v2) -> k + v1 - v2, singleton(1, 4), HashMap#{1 => 2, 2 => 3}) == singleton(1, 3)

@test
def intersectionWithKey15(): Bool = HashMap.intersectionWithKey((k, v1, v2) -> k + v1 - v2, singleton(2, 7), HashMap#{1 => 2, 2 => 3}) == singleton(2, 6)

@test
def intersectionWithKey16(): Bool = HashMap.intersectionWithKey((k, v1, v2) -> k + v1 - v2, HashMap#{2 => 7, 11 => 14, 9 => 8, 15 => 22}, HashMap#{15 => 21, 1 => 2, 2 => 8, 44 => 33, 11 => 17})
                                  == HashMap#{2 => 1, 15 => 16, 11 => 8}

/////////////////////////////////////////////////////////////////////////////
// difference                                                              //
/////////////////////////////////////////////////////////////////////////////
@test
def difference01(): Bool = HashMap.difference(empty(): HashMap[Unit, Unit], empty(): HashMap[Unit, Unit]) == empty()

@test
def difference02(): Bool = HashMap.difference(singleton(1, 2), empty()) == singleton(1, 2)

@test
def difference03(): Bool = HashMap.difference(empty(), singleton(1, 2)) == empty()

@test
def difference04(): Bool = HashMap.difference(empty(), HashMap#{1 => 2, 3 => 4}) == empty()

@test
def difference05(): Bool = HashMap.difference(HashMap#{1 => 2, 3 => 4}, empty()) == HashMap#{1 => 2, 3 => 4}

@test
def difference06(): Bool = HashMap.difference(singleton(1, 2), singleton(3, 4)) == singleton(1, 2)

@test
def difference07(): Bool = HashMap.difference(singleton(1, 2), singleton(1, 5)) == empty()

@test
def difference08(): Bool = HashMap.difference(empty(), HashMap#{1 => 2, 2 => 3, 3 => 4}) == empty()

@test
def difference09(): Bool = HashMap.difference(HashMap#{1 => 2, 2 => 3, 3 => 4}, empty()) == HashMap#{1 => 2, 2 => 3, 3 => 4}

@test
def difference10(): Bool = HashMap.difference(HashMap#{1 => 2, 2 => 3}, singleton(3, 4)) == HashMap#{1 => 2, 2 => 3}

@test
def difference11(): Bool = HashMap.difference(singleton(3, 4), HashMap#{1 => 2, 2 => 3}) == singleton(3, 4)

@test
def difference12(): Bool = HashMap.difference(HashMap#{1 => 2, 2 => 3}, singleton(2, 8)) == singleton(1, 2)

@test
def difference13(): Bool = HashMap.difference(HashMap#{1 => 2, 2 => 3}, singleton(1, 8)) == singleton(2, 3)

@test
def difference14(): Bool = HashMap.difference(singleton(1, 4), HashMap#{1 => 2, 2 => 3}) == empty()

@test
def difference15(): Bool = HashMap.difference(singleton(2, 7), HashMap#{1 => 2, 2 => 3}) == empty()

@test
def difference16(): Bool = HashMap.difference(HashMap#{2 => 7, 11 => 14, 9 => 8, 15 => 22}, HashMap#{15 => 21, 1 => 2, 2 => 8, 44 => 33})
                                  == HashMap#{11 => 14, 9 => 8}

/////////////////////////////////////////////////////////////////////////////
// differenceWith                                                          //
/////////////////////////////////////////////////////////////////////////////
@test
def differenceWith01(): Bool = HashMap.differenceWith((v1, v2) -> if (v1 > v2) Some(v1) else None, empty(), empty()) == empty(): HashMap[Int32, Int32]

@test
def differenceWith02(): Bool = HashMap.differenceWith((v1, v2) -> if (v1 > v2) Some(v1) else None, singleton(1, 2), empty()) == singleton(1, 2)

@test
def differenceWith03(): Bool = HashMap.differenceWith((v1, v2) -> if (v1 > v2) Some(v1) else None, empty(), singleton(1, 2)) == empty()

@test
def differenceWith04(): Bool = HashMap.differenceWith((v1, v2) -> if (v1 > v2) Some(v1) else None, empty(), HashMap#{1 => 2, 3 => 4}) == empty()

@test
def differenceWith05(): Bool = HashMap.differenceWith((v1, v2) -> if (v1 > v2) Some(v1) else None, HashMap#{1 => 2, 3 => 4}, empty()) == HashMap#{1 => 2, 3 => 4}

@test
def differenceWith06(): Bool = HashMap.differenceWith((v1, v2) -> if (v1 > v2) Some(v1) else None, singleton(1, 2), singleton(3, 4)) == singleton(1, 2)

@test
def differenceWith07(): Bool = HashMap.differenceWith((v1, v2) -> if (v1 > v2) Some(v1) else None, singleton(1, 2), singleton(1, 5)) == empty()

@test
def differenceWith08(): Bool = HashMap.differenceWith((v1, v2) -> if (v1 > v2) Some(v1) else None, singleton(1, 5), singleton(1, 4)) == singleton(1, 5)

@test
def differenceWith09(): Bool = HashMap.differenceWith((v1, v2) -> if (v1 > v2) Some(v1) else None, empty(), HashMap#{1 => 2, 2 => 3, 3 => 4}) == empty()

@test
def differenceWith10(): Bool = HashMap.differenceWith((v1, v2) -> if (v1 > v2) Some(v1) else None, HashMap#{1 => 2, 2 => 3, 3 => 4}, empty()) == HashMap#{1 => 2, 2 => 3, 3 => 4}

@test
def differenceWith11(): Bool = HashMap.differenceWith((v1, v2) -> if (v1 > v2) Some(v1) else None, HashMap#{1 => 2, 2 => 3}, singleton(3, 4)) == HashMap#{1 => 2, 2 => 3}

@test
def differenceWith12(): Bool = HashMap.differenceWith((v1, v2) -> if (v1 > v2) Some(v1) else None, singleton(3, 4), HashMap#{1 => 2, 2 => 3}) == singleton(3, 4)

@test
def differenceWith13(): Bool = HashMap.differenceWith((v1, v2) -> if (v1 > v2) Some(v1) else None, HashMap#{1 => 2, 2 => 3}, singleton(2, 8)) == singleton(1, 2)

@test
def differenceWith14(): Bool = HashMap.differenceWith((v1, v2) -> if (v1 > v2) Some(v1) else None, HashMap#{1 => 2, 2 => 9}, singleton(2, 8)) == HashMap#{1 => 2, 2 => 9}

@test
def differenceWith15(): Bool = HashMap.differenceWith((v1, v2) -> if (v1 > v2) Some(v1) else None, HashMap#{1 => 2, 2 => 3}, singleton(1, 8)) == singleton(2, 3)

@test
def differenceWith16(): Bool = HashMap.differenceWith((v1, v2) -> if (v1 > v2) Some(v1) else None, HashMap#{1 => 9, 2 => 3}, singleton(1, 8)) == HashMap#{1 => 9, 2 => 3}

@test
def differenceWith17(): Bool = HashMap.differenceWith((v1, v2) -> if (v1 > v2) Some(v1) else None, singleton(1, 1), HashMap#{1 => 2, 2 => 3}) == empty()

@test
def differenceWith18(): Bool = HashMap.differenceWith((v1, v2) -> if (v1 > v2) Some(v1) else None, singleton(1, 4), HashMap#{1 => 2, 2 => 3}) == singleton(1, 4)

@test
def differenceWith19(): Bool = HashMap.differenceWith((v1, v2) -> if (v1 > v2) Some(v1) else None, singleton(2, -4), HashMap#{1 => 2, 2 => 3}) == empty()

@test
def differenceWith20(): Bool = HashMap.differenceWith((v1, v2) -> if (v1 > v2) Some(v1) else None, singleton(2, 7), HashMap#{1 => 2, 2 => 3}) == singleton(2, 7)

@test
def differenceWith21(): Bool = HashMap.differenceWith((v1, v2) -> if (v1 > v2) Some(v1) else None, HashMap#{2 => 7, 11 => 14, 9 => 8, 15 => 22}, HashMap#{15 => 21, 1 => 2, 2 => 8, 44 => 33})
                                  == HashMap#{11 => 14, 9 => 8, 15 => 22}

/////////////////////////////////////////////////////////////////////////////
// differenceWithKey                                                       //
/////////////////////////////////////////////////////////////////////////////
@test
def differenceWithKey01(): Bool = HashMap.differenceWithKey((k, v1, v2) -> if (v1 > v2) Some(v1 + k) else None, empty(), empty()) == empty(): HashMap[Int32, Int32]

@test
def differenceWithKey02(): Bool = HashMap.differenceWithKey((k, v1, v2) -> if (v1 > v2) Some(v1 + k) else None, singleton(1, 2), empty()) == singleton(1, 2)

@test
def differenceWithKey03(): Bool = HashMap.differenceWithKey((k, v1, v2) -> if (v1 > v2) Some(v1 + k) else None, empty(), singleton(1, 2)) == empty()

@test
def differenceWithKey04(): Bool = HashMap.differenceWithKey((k, v1, v2) -> if (v1 > v2) Some(v1 + k) else None, empty(), HashMap#{1 => 2, 3 => 4}) == empty()

@test
def differenceWithKey05(): Bool = HashMap.differenceWithKey((k, v1, v2) -> if (v1 > v2) Some(v1 + k) else None, HashMap#{1 => 2, 3 => 4}, empty()) == HashMap#{1 => 2, 3 => 4}

@test
def differenceWithKey06(): Bool = HashMap.differenceWithKey((k, v1, v2) -> if (v1 > v2) Some(v1 + k) else None, singleton(1, 2), singleton(3, 4)) == singleton(1, 2)

@test
def differenceWithKey07(): Bool = HashMap.differenceWithKey((k, v1, v2) -> if (v1 > v2) Some(v1 + k) else None, singleton(1, 2), singleton(1, 5)) == empty()

@test
def differenceWithKey08(): Bool = HashMap.differenceWithKey((k, v1, v2) -> if (v1 > v2) Some(v1 + k) else None, singleton(1, 5), singleton(1, 4)) == singleton(1, 6)

@test
def differenceWithKey09(): Bool = HashMap.differenceWithKey((k, v1, v2) -> if (v1 > v2) Some(v1 + k) else None, empty(), HashMap#{1 => 2, 2 => 3, 3 => 4}) == empty()

@test
def differenceWithKey10(): Bool = HashMap.differenceWithKey((k, v1, v2) -> if (v1 > v2) Some(v1 + k) else None, HashMap#{1 => 2, 2 => 3, 3 => 4}, empty()) == HashMap#{1 => 2, 2 => 3, 3 => 4}

@test
def differenceWithKey11(): Bool = HashMap.differenceWithKey((k, v1, v2) -> if (v1 > v2) Some(v1 + k) else None, HashMap#{1 => 2, 2 => 3}, singleton(3, 4)) == HashMap#{1 => 2, 2 => 3}

@test
def differenceWithKey12(): Bool = HashMap.differenceWithKey((k, v1, v2) -> if (v1 > v2) Some(v1 + k) else None, singleton(3, 4), HashMap#{1 => 2, 2 => 3}) == singleton(3, 4)

@test
def differenceWithKey13(): Bool = HashMap.differenceWithKey((k, v1, v2) -> if (v1 > v2) Some(v1 + k) else None, HashMap#{1 => 2, 2 => 3}, singleton(2, 8)) == singleton(1, 2)

@test
def differenceWithKey14(): Bool = HashMap.differenceWithKey((k, v1, v2) -> if (v1 > v2) Some(v1 + k) else None, HashMap#{1 => 2, 2 => 9}, singleton(2, 8)) == HashMap#{1 => 2, 2 => 11}

@test
def differenceWithKey15(): Bool = HashMap.differenceWithKey((k, v1, v2) -> if (v1 > v2) Some(v1 + k) else None, HashMap#{1 => 2, 2 => 3}, singleton(1, 8)) == singleton(2, 3)

@test
def differenceWithKey16(): Bool = HashMap.differenceWithKey((k, v1, v2) -> if (v1 > v2) Some(v1 + k) else None, HashMap#{1 => 9, 2 => 3}, singleton(1, 8)) == HashMap#{1 => 10, 2 => 3}

@test
def differenceWithKey17(): Bool = HashMap.differenceWithKey((k, v1, v2) -> if (v1 > v2) Some(v1 + k) else None, singleton(1, 1), HashMap#{1 => 2, 2 => 3}) == empty()

@test
def differenceWithKey18(): Bool = HashMap.differenceWithKey((k, v1, v2) -> if (v1 > v2) Some(v1 + k) else None, singleton(1, 4), HashMap#{1 => 2, 2 => 3}) == singleton(1, 5)

@test
def differenceWithKey19(): Bool = HashMap.differenceWithKey((k, v1, v2) -> if (v1 > v2) Some(v1 + k) else None, singleton(2, -4), HashMap#{1 => 2, 2 => 3}) == empty()

@test
def differenceWithKey20(): Bool = HashMap.differenceWithKey((k, v1, v2) -> if (v1 > v2) Some(v1 + k) else None, singleton(2, 7), HashMap#{1 => 2, 2 => 3}) == singleton(2, 9)

@test
def differenceWithKey21(): Bool = HashMap.differenceWithKey((k, v1, v2) -> if (v1 > v2) Some(v1 + k) else None, HashMap#{2 => 7, 11 => 14, 9 => 8, 15 => 22}, HashMap#{15 => 21, 1 => 2, 2 => 8, 44 => 33})
                                  == HashMap#{11 => 14, 9 => 8, 15 => 37}

/////////////////////////////////////////////////////////////////////////////
// toSet                                                                   //
/////////////////////////////////////////////////////////////////////////////
@test
def toSet01(): Bool = HashMap.toSet(empty(): HashMap[Unit, Unit]) == Set#{}

@test
def toSet02(): Bool = HashMap.toSet(singleton(1, 2)) == Set#{(1, 2)}

@test
def toSet03(): Bool = HashMap.toSet(HashMap#{1 => 2, 3 => 4}) == Set#{(1, 2), (3, 4)}

@test
def toSet04(): Bool = HashMap.toSet(HashMap#{1 => 2, 2 => 2, 3 => 4}) == Set#{(1, 2), (2, 2), (3, 4)}

/////////////////////////////////////////////////////////////////////////////
// toList                                                                  //
/////////////////////////////////////////////////////////////////////////////
@test
def toList01(): Bool = HashMap.toList(empty(): HashMap[Unit, Unit]) == Nil

@test
def toList02(): Bool = HashMap.toList(singleton(1, 2)) == (1, 2) :: Nil

@test
def toList03(): Bool = HashMap.toList(HashMap#{1 => 2, 3 => 4}) == (1, 2) :: (3, 4) :: Nil

@test
def toList04(): Bool = HashMap.toList(HashMap#{1 => 2, 2 => 2, 3 => 4}) == (1, 2) :: (2, 2) :: (3, 4) :: Nil

/////////////////////////////////////////////////////////////////////////////
// toMutDeque                                                              //
/////////////////////////////////////////////////////////////////////////////

@test
def toMutDeque01(): Bool = region r {
    let m: HashMap[Int32, Int32] = empty();
    let d1 = HashMap.toMutDeque(r, m);

    let d2 = new MutDeque(r);

    d1 `MutDeque.sameElements` d2
}

@test
def toMutDeque02(): Bool = region r {
    let m = singleton(1, 2);
    let d1 = HashMap.toMutDeque(r, m);

    let d2 = new MutDeque(r);
    MutDeque.pushBack((1, 2), d2);

    d1 `MutDeque.sameElements` d2
}

@test
def toMutDeque03(): Bool = region r {
    let m = HashMap#{1 => 2, 3 => 4, 5 => 6};
    let d1 = HashMap.toMutDeque(r, m);

    let d2 = new MutDeque(r);
    MutDeque.pushBack((3, 4), d2);
    MutDeque.pushBack((5, 6), d2);
    MutDeque.pushFront((1, 2), d2);

    d1 `MutDeque.sameElements` d2
}

@test
def toMutDeque04(): Bool = region r {
    let m = HashMap#{1 => 'a', 2 => 'b', 3 => 'c'};
    let d1 = HashMap.toMutDeque(r, m);

    let d2 = new MutDeque(r);
    MutDeque.pushFront((3, 'c'), d2);
    MutDeque.pushFront((2, 'b'), d2);
    MutDeque.pushFront((1, 'a'), d2);

    d1 `MutDeque.sameElements` d2
}

/////////////////////////////////////////////////////////////////////////////
// eq                                                                      //
/////////////////////////////////////////////////////////////////////////////
@test
def eq01(): Bool = empty(): HashMap[Unit, Unit] == empty()

@test
def eq02(): Bool = singleton(1, 2) != empty()

@test
def eq03(): Bool = empty() != singleton(1, 2)

@test
def eq04(): Bool = HashMap#{1 => 2, 3 => 4} != empty()

@test
def eq05(): Bool = empty() != HashMap#{1 => 2, 3 => 4}

@test
def eq06(): Bool = singleton(1, 2) == singleton(1, 2)

@test
def eq07(): Bool = singleton(1, 3) != singleton(1, 2)

@test
def eq08(): Bool = singleton(1, 2) != singleton(1, 3)

@test
def eq09(): Bool = singleton(2, 2) != singleton(1, 2)

@test
def eq10(): Bool = singleton(1, 2) != singleton(4, 2)

@test
def eq11(): Bool = HashMap#{1 => 2, 3 => 4} != singleton(1, 2)

@test
def eq12(): Bool = singleton(1, 2) != HashMap#{1 => 2, 3 => 4}

@test
def eq13(): Bool = HashMap#{1 => 2, 3 => 4} == HashMap#{1 => 2, 3 => 4}

@test
def eq14(): Bool = HashMap#{1 => 2, 3 => 4} == HashMap#{3 => 4, 1 => 2}

@test
def eq15(): Bool = HashMap#{1 => 1, 3 => 4} != HashMap#{1 => 2, 3 => 4}

@test
def eq16(): Bool = HashMap#{4 => 2, 3 => 4} != HashMap#{1 => 2, 3 => 4}

@test
def eq17(): Bool = HashMap#{1 => 2, 3 => 4} != HashMap#{1 => 2, 2 => 4}

@test
def eq18(): Bool = HashMap#{1 => 2, 3 => 4} != HashMap#{1 => 2, 3 => 8}

@test
def eq19(): Bool = HashMap#{1 => 2, 3 => 4, 5 => 6} != HashMap#{1 => 2, 3 => 4}

@test
def eq20(): Bool = HashMap#{1 => 2, 3 => 4} != HashMap#{1 => 2, 3 => 4, 5 => 6}

@test
def eq21(): Bool = HashMap#{1 => 2, 3 => 4, 5 => 6} == HashMap#{1 => 2, 3 => 4, 5 => 6}

@test
def eq22(): Bool = HashMap#{1 => 2, 3 => 4, 5 => 6} == HashMap#{1 => 2, 5 => 6, 3 => 4}

@test
def eq23(): Bool = HashMap#{1 => 2, 3 => 4, 5 => 6} == HashMap#{3 => 4, 5 => 6, 1 => 2}

@test
def eq24(): Bool = HashMap#{1 => 2, 3 => 4, 5 => 6} == HashMap#{5 => 6, 3 => 4, 1 => 2}

@test
def eq25(): Bool = HashMap#{1 => 2, 3 => 4, 5 => 6, 7 => 8, 9 => 10} == HashMap#{7 => 8, 1 => 2, 3 => 4, 9 => 10, 5 => 6}

/////////////////////////////////////////////////////////////////////////////
// foreach                                                                 //
/////////////////////////////////////////////////////////////////////////////

@test
def foreach01(): Bool \ IO =
    let r = ref 21;
    HashMap.foreach((k, _) -> r := k, empty());
    21 == deref r

@test
def foreach02(): Bool \ IO =
    let r = ref 21;
    HashMap.foreach((k, _) -> r := k, singleton(1, "Hello World!"));
    1 == deref r

/////////////////////////////////////////////////////////////////////////////
// unfold                                                                  //
/////////////////////////////////////////////////////////////////////////////

@test
def unfold01(): Bool =
    HashMap.unfold(s -> if (true) None else Some(s, Char.fromInt32(s + 48), s + 1), 0) == empty()

@test
def unfold02(): Bool =
    HashMap.unfold(s -> if (s > 0) None else Some(s, Char.fromInt32(s + 48), s + 1), 0) == singleton(0, '0')

@test
def unfold03(): Bool =
    HashMap.unfold(s -> if (s > 1) None else Some(s, Char.fromInt32(s + 48), s + 1), 0) == HashMap#{0 => '0', 1 => '1'}

@test
def unfold04(): Bool =
    HashMap.unfold(s -> if (s >= 10) None else Some(s, Char.fromInt32(s + 48), s + 1), 0) == HashMap#{0 => '0', 1 => '1', 2 => '2', 3 => '3', 4 => '4', 5 => '5', 6 => '6', 7 => '7', 8 => '8', 9 => '9'}

@test
def unfold05(): Bool =
    HashMap.unfold(s -> if (s >= 10) None else Some(s, Char.fromInt32(s + 48), s + 1), 5) == HashMap#{5 => '5', 6 => '6', 7 => '7', 8 => '8', 9 => '9'}

@test
def unfold06(): Bool =
    HashMap.unfold(s -> if (s >= 10) None else Some(s, Char.fromInt32(s + 48), s + 2), 0) == HashMap#{0 => '0', 2 => '2', 4 => '4', 6 => '6', 8 => '8'}

/////////////////////////////////////////////////////////////////////////////
// unfoldWithIter                                                          //
/////////////////////////////////////////////////////////////////////////////

@test
def unfoldWithIter01(): Bool \ IO =
    let x = ref 0;
    let step = () ->
        if (true)
            None
        else {
            let k = deref x;
            let v = Char.fromInt32(k + 48);
            x := deref x + 1;
            Some(k, v)
        };
    HashMap.unfoldWithIter(step) == empty()

@test
def unfoldWithIter02(): Bool \ IO =
    let x = ref 0;
    let step = () ->
        if (deref x > 0)
            None
        else {
            let k = deref x;
            let v = Char.fromInt32(k + 48);
            x := deref x + 1;
            Some(k, v)
        };
    HashMap.unfoldWithIter(step) == singleton(0, '0')

@test
def unfoldWithIter03(): Bool \ IO =
    let x = ref 0;
    let step = () ->
        if (deref x > 1)
            None
        else {
            let k = deref x;
            let v = Char.fromInt32(k + 48);
            x := deref x + 1;
            Some(k, v)
        };
    HashMap.unfoldWithIter(step) == HashMap#{0 => '0', 1 => '1'}

@test
def unfoldWithIter04(): Bool \ IO =
    let x = ref 0;
    let step = () ->
        if (deref x >= 10)
            None
        else {
            let k = deref x;
            let v = Char.fromInt32(k + 48);
            x := deref x + 1;
            Some(k, v)
        };
    HashMap.unfoldWithIter(step) == HashMap#{0 => '0', 1 => '1', 2 => '2', 3 => '3', 4 => '4', 5 => '5', 6 => '6', 7 => '7', 8 => '8', 9 => '9'}

@test
def unfoldWithIter05(): Bool \ IO =
    let x = ref 5;
    let step = () ->
        if (deref x >= 10)
            None
        else {
            let k = deref x;
            let v = Char.fromInt32(k + 48);
            x := deref x + 1;
            Some(k, v)
        };
    HashMap.unfoldWithIter(step) == HashMap#{5 => '5', 6 => '6', 7 => '7', 8 => '8', 9 => '9'}

@test
def unfoldWithIter06(): Bool \ IO =
    let x = ref 0;
    let step = () ->
        if (deref x >= 10)
            None
        else {
            let k = deref x;
            let v = Char.fromInt32(k + 48);
            x := deref x + 2;
            Some(k, v)
        };
    HashMap.unfoldWithIter(step) == HashMap#{0 => '0', 2 => '2', 4 => '4', 6 => '6', 8 => '8'}

/////////////////////////////////////////////////////////////////////////////
// inverse                                                                 //
/////////////////////////////////////////////////////////////////////////////

@test
def testInvert01(): Bool = HashMap.invert(singleton(1, "a")) == singleton("a", Set#{1)}

@test
def testInvert02(): Bool = HashMap.invert(HashMap#{1 => "a", 2 => "b"}) == singleton("a", Set#{1), "b" => Set#{2}}

@test
def testInvert03(): Bool = HashMap.invert(HashMap#{1 => "a", 2 => "a"}) == singleton("a", Set#{1, 2)}

@test
def testInvert04(): Bool = HashMap.invert(HashMap#{1 => "a", 2 => "b", 3 => "a"}) == singleton("a", Set#{1, 3), "b" => Set#{2}}

@test
def testInvert05(): Bool = HashMap.invert(HashMap#{1 => "a", 2 => "a", 3 => "a"}) == singleton("a", Set#{1, 2, 3)}

@test
def testInvert06(): Bool = HashMap.invert(HashMap#{1 => "a", 2 => "b", 3 => "a", 4 => "b"}) == singleton("a", Set#{1, 3), "b" => Set#{2, 4}}

/////////////////////////////////////////////////////////////////////////////
// query                                                                   //
/////////////////////////////////////////////////////////////////////////////

@test
def query01(): Bool =
    HashMap.query(_ -> EqualTo, empty(): HashMap[Unit, Unit]) == Nil

@test
def query02(): Bool =
    HashMap.query(_ -> EqualTo, HashMap#{1 => 101, 2 => 42}) == (1, 101) :: (2, 42) :: Nil

@test
def query03(): Bool =
    HashMap.query(x -> if (x < 2) LessThan else if (x > 2) GreaterThan else EqualTo, HashMap#{1 => 1, 2 => 2, 3 => 3}) == (2, 2) :: Nil

@test
def query04(): Bool =
    HashMap.query(x -> if (x < 'b') LessThan else if (x > 'c') GreaterThan else EqualTo, HashMap#{'a' => 0, 'b' => 1, 'c' => 2, 'd' => 3, 'e' => 4}) == ('b', 1) :: ('c', 2) :: Nil

@test
def query05(): Bool =
    let m = HashMap.unfold(s -> if (s > 10) None else Some(s, s, s + 1), 5);
    HashMap.query(x -> if (x < 5) LessThan else if (x >= 10) GreaterThan else EqualTo, m) == List.map(x -> (x, x), List.range(5, 10))

@test
def query06(): Bool =
    let m = HashMap.unfold(s -> if (s > 75) None else Some(s, Char.fromInt32(s + 48), s + 1), 25);
    HashMap.query(x -> if (x < 25) LessThan else if (x >= 75) GreaterThan else EqualTo, m) == List.map(x -> (x, Char.fromInt32(x + 48)), List.range(25, 75))

@test
def query07(): Bool =
    HashMap.query(x -> if (x < 42) LessThan else if (x > 42) GreaterThan else EqualTo, singleton(42, true)) == (42, true) :: Nil

@test
def query08(): Bool =
    HashMap.query(x -> if (x < 1) LessThan else if (x > 1) GreaterThan else EqualTo, HashMap#{1 => 2, 2 => 3, 3 => 4, 4 => 5}) == (1, 2) :: Nil

@test
def query09(): Bool =
    HashMap.query(x -> if (x < 2) LessThan else if (x > 3) GreaterThan else EqualTo, HashMap#{1 => 2, 2 => 3, 3 => 4, 4 => 5}) == (2, 3) :: (3, 4) :: Nil

@test
def query10(): Bool =
    HashMap.query(x -> if (x < 4) LessThan else if (x > 4) GreaterThan else EqualTo, HashMap#{1 => 2, 2 => 3, 3 => 4, 4 => 5}) == (4, 5) :: Nil

@test
def query11(): Bool =
    let m = HashMap#{(1, 2) => 0, (1, 3) => 1, (2, 1) => 2, (2, 2) => 3, (2, 3) => 4, (3, 1) => 5};
    HashMap.query(x -> if (fst(x) < 1) LessThan else if (fst(x) > 1) GreaterThan else EqualTo, m) == ((1, 2), 0) :: ((1, 3), 1) :: Nil

@test
def query12(): Bool =
    let m = HashMap#{(1, 2) => 0, (1, 3) => 1, (2, 1) => 2, (2, 2) => 3, (2, 3) => 4, (3, 1) => 5};
    HashMap.query(x -> if (fst(x) < 3) LessThan else if (fst(x) > 3) GreaterThan else EqualTo, m) == ((3, 1), 5) :: Nil

@test
def query13(): Bool =
    let m = HashMap#{(1, 2) => 0, (1, 3) => 1, (2, 1) => 2, (2, 2) => 3, (2, 3) => 4, (3, 1) => 5};
    HashMap.query(x -> if (fst(x) > 2) GreaterThan else EqualTo, m) == ((1, 2), 0) :: ((1, 3), 1) :: ((2, 1), 2) :: ((2, 2), 3) :: ((2, 3), 4) :: Nil

@test
def query14(): Bool =
    let m = HashMap#{(1, 2) => 0, (1, 3) => 1, (2, 1) => 2, (2, 2) => 3, (2, 3) => 4, (3, 1) => 5};
    HashMap.query(x -> if (fst(x) < 2) LessThan else EqualTo, m) == ((2, 1), 2) :: ((2, 2), 3) :: ((2, 3), 4) :: ((3, 1), 5) :: Nil

@test
def query15(): Bool =
    let m = HashMap#{(1, 2) => 0, (1, 3) => 1, (2, 1) => 2, (2, 2) => 3, (2, 3) => 4, (3, 1) => 5};
    let f = x -> {
        let cmp = x <=> (2, 2);
        if (cmp == GreaterThan)
            cmp
        else
            EqualTo
        };
    HashMap.query(f, m) == ((1, 2), 0) :: ((1, 3), 1) :: ((2, 1), 2) :: ((2, 2), 3) :: Nil

@test
def query16(): Bool =
    let m = HashMap#{(1, 2) => 0, (1, 3) => 1, (2, 1) => 2, (2, 2) => 3, (2, 3) => 4, (3, 1) => 5};
    let f = x -> {
        let cmp = x <=> (2, 2);
        if (cmp == LessThan)
            cmp
        else
            EqualTo
        };
    HashMap.query(f, m) == ((2, 2), 3) :: ((2, 3), 4) :: ((3, 1), 5) :: Nil

@test
def query17(): Bool =
    let m = HashMap#{(1, 2, 2) => 0, (1, 2, 3) => 1, (1, 2, 4) => 2, (2, 2, 4) => 3};
    let f = x -> {
        let cmp = x <=> (1, 2, 3);
        if (cmp == LessThan)
            cmp
        else
            EqualTo
        };
    HashMap.query(f, m) == ((1, 2, 3), 1) :: ((1, 2, 4), 2) :: ((2, 2, 4), 3) :: Nil

@test
def query18(): Bool =
    let m = HashMap#{(1, 2, 2) => 0, (1, 2, 3) => 1, (1, 2, 4) => 2, (2, 2, 4) => 3};
    let f = x -> {
        let cmp = x <=> (1, 2, 3);
        if (cmp == GreaterThan)
            cmp
        else
            EqualTo
        };
    HashMap.query(f, m) == ((1, 2, 2), 0) :: ((1, 2, 3), 1) :: Nil

    /////////////////////////////////////////////////////////////////////////////
    // toString                                                                //
    /////////////////////////////////////////////////////////////////////////////

    @test
    def toString01(): Bool =
        toString(singleton(1, 2)) == "singleton(1, 2)"

    @test
    def toString02(): Bool =
        toString(HashMap#{1 => 0, 2 => 1, 3 => 2}) == "HashMap#{1 => 0, 2 => 1, 3 => 2}"

    @test
    def toString03(): Bool =
        toString(HashMap#{1 => "b", 2 => "a"}) == "HashMap#{1 => b, 2 => a}"

    @test
    def toString04(): Bool =
        toString(HashMap#{97 => false, 2 => true, 3 => false, 4 => true, 0 => true}) == "HashMap#{0 => true, 2 => true, 3 => false, 4 => true, 97 => false}"

    @test
    def toString05(): Bool =
        toString(HashMap#{2 => HashMap#{1 => 0, 2 => 1}, 3 => HashMap#{3 => 2, 4 => 92}}) == "HashMap#{2 => HashMap#{1 => 0, 2 => 1}, 3 => HashMap#{3 => 2, 4 => 92}}"

    /////////////////////////////////////////////////////////////////////////////
    // hash                                                                    //
    /////////////////////////////////////////////////////////////////////////////

    @test
    def hash01(): Bool = hash(empty(): HashMap[Unit, Unit]) == hash(empty(): HashMap[Unit, Unit])

    @test
    def hash02(): Bool = hash(HashMap#{1 => true, 2 => false, 3 => false}) == hash(HashMap#{1 => true, 2 => false, 3 => false})

    @test
    def hash03(): Bool = hash(HashMap#{1 => 2, 1 => 2}) != hash(HashMap#{1 => 1, 2 => 2})

    @test
    def hash04(): Bool = hash(HashMap#{1 => 'a', 2 => 'b'}) != hash(HashMap#{'a' => 1, 'b' => 2})

    @test
    def hash05(): Bool = hash(HashMap#{1 => 'a', 2 => 'b', 3 => 'z', 4 => 'x'}) == hash(HashMap#{1 => 'a', 2 => 'b', 3 => 'z', 4 => 'x'})

    /////////////////////////////////////////////////////////////////////////////
    // minimumKey                                                              //
    /////////////////////////////////////////////////////////////////////////////

    @test
    def minimumKey01(): Bool = HashMap.minimumKey(empty(): HashMap[Int32, Int32]) == None

    @test
    def minimumKey02(): Bool = HashMap.minimumKey(HashMap#{1 => 2, 2 => 3, 3 => 4, 5 => 5}) == Some((1, 2))

    @test
    def minimumKey03(): Bool = HashMap.minimumKey(HashMap#{1 => 2, 2 => 3, 3 => 4, 5 => 5, 0 => 2}) == Some((0, 2))

    @test
    def minimumKey04(): Bool = HashMap.minimumKey(HashMap#{1 => 2, 2 => 3, -44 => 4, 5 => 5, 0 => 2}) == Some((-44, 4))

    /////////////////////////////////////////////////////////////////////////////
    // minimumBy                                                               //
    /////////////////////////////////////////////////////////////////////////////

    @test
    def minimumKeyBy01(): Bool =
        HashMap.minimumKeyBy((x, y) -> x <=> y, empty(): HashMap[Int32, Int32]) == None

    @test
    def minimumKeyBy02(): Bool =
        HashMap.minimumKeyBy((x, y) -> x <=> y, HashMap#{1 => 2, 2 => 3, 3 => 4, 5 => 5}) == Some((1, 2))

    @test
    def minimumKeyBy03(): Bool =
        HashMap.minimumKeyBy((x, y) -> x <=> y, HashMap#{1 => 2, 2 => 3, 3 => 4, 5 => 5, 0 => 2}) == Some((0, 2))

    @test
    def minimumKeyBy04(): Bool =
        HashMap.minimumKeyBy((x, y) -> x <=> y, HashMap#{1 => 2, 2 => 3, -44 => 4, 5 => 5, 0 => 2}) == Some((-44, 4))

    @test
    def minimumKeyBy05(): Bool \ IO =
        let range = List.range(0, 2000);
        let m = List.zip(range, range) |> List.toMap;
        let a = new MutList(Static);
        discard HashMap.minimumKeyBy((x, y) -> { let b = new MutList(Static); MutList.push!(y, b); MutList.append!(MutList.toList(b), a); x <=> y }, m);
        MutList.toList(a) == List.range(1, 2000) // The first / left most value is ignored


    /////////////////////////////////////////////////////////////////////////////
    // minimumValue                                                            //
    /////////////////////////////////////////////////////////////////////////////

    @test
    def minimumValue01(): Bool = HashMap.minimumValue(empty(): HashMap[Int32, Int32]) == None

    @test
    def minimumValue02(): Bool = HashMap.minimumValue(HashMap#{1 => 2, 2 => 3, 3 => 4, 5 => 5}) == Some((1, 2))

    @test
    def minimumValue03(): Bool = HashMap.minimumValue(HashMap#{1 => 2, 2 => 3, 3 => 4, 5 => 5, 0 => 2}) == Some((1, 2))

    @test
    def minimumValue04(): Bool = HashMap.minimumValue(HashMap#{1 => 2, 2 => 3, -44 => 4, 5 => 5, 0 => 2}) == Some((1, 2))

    @test
    def minimumValue05(): Bool = HashMap.minimumValue(HashMap#{1 => 2, 2 => 3, 4 => -44, 5 => 5, 0 => 2}) == Some((4, -44))

    /////////////////////////////////////////////////////////////////////////////
    // minimumBy                                                               //
    /////////////////////////////////////////////////////////////////////////////

    @test
    def minimumValueBy01(): Bool =
        HashMap.minimumValueBy((x, y) -> x <=> y, empty(): HashMap[Int32, Int32]) == None

    @test
    def minimumValueBy02(): Bool =
        HashMap.minimumValueBy((x, y) -> x <=> y, HashMap#{1 => 2, 2 => 3, 3 => 4, 5 => 5}) == Some((1, 2))

    @test
    def minimumValueBy03(): Bool =
        HashMap.minimumValueBy((x, y) -> x <=> y, HashMap#{1 => 2, 2 => 3, 3 => 4, 5 => 5, 0 => 2}) == Some((1, 2))

    @test
    def minimumValueBy04(): Bool =
        HashMap.minimumValueBy((x, y) -> x <=> y, HashMap#{1 => 2, 2 => 3, -44 => 4, 5 => 5, 0 => 2}) == Some((1, 2))

    @test
    def minimumValueBy05(): Bool =
        HashMap.minimumValueBy((x, y) -> x <=> y, HashMap#{1 => 2, 2 => 3, 4 => -44, 5 => 5, 0 => 2}) == Some((4, -44))

    @test
    def minimumValueBy06(): Bool \ IO =
        let range = List.range(0, 2000);
        let m = List.zip(range, List.reverse(range)) |> List.toMap;
        let a = new MutList(Static);
        discard HashMap.minimumValueBy((x, y) -> { let b = new MutList(Static); MutList.push!(x, b); MutList.append!(MutList.toList(b), a); x <=> y }, m);
        MutList.toList(a) == List.reverse(List.range(1, 2000)) // The first / left most value is ignored


    /////////////////////////////////////////////////////////////////////////////
    // maximumKey                                                              //
    /////////////////////////////////////////////////////////////////////////////

    @test
    def maximumKey01(): Bool = HashMap.maximumKey(empty(): HashMap[Int32, Int32]) == None

    @test
    def maximumKey02(): Bool = HashMap.maximumKey(HashMap#{1 => 2, 2 => 3, 3 => 4, 5 => 5}) == Some((5, 5))

    @test
    def maximumKey03(): Bool = HashMap.maximumKey(HashMap#{1 => 2, 2 => 3, 3 => 4, 5 => 5, 0 => 2}) == Some((5, 5))

    @test
    def maximumKey04(): Bool = HashMap.maximumKey(HashMap#{1 => 2, 2 => 3, 107 => -107, 5 => 5, 0 => 2}) == Some((107, -107))


    /////////////////////////////////////////////////////////////////////////////
    // maximumKeyBy                                                            //
    /////////////////////////////////////////////////////////////////////////////

    @test
    def maximumKeyBy01(): Bool = HashMap.maximumKeyBy((x, y) -> x <=> y, empty(): HashMap[Int32, Int32]) == None

    @test
    def maximumKeyBy02(): Bool = HashMap.maximumKeyBy((x, y) -> x <=> y, HashMap#{1 => 2, 2 => 3, 3 => 4, 5 => 5}) == Some((5, 5))

    @test
    def maximumKeyBy03(): Bool = HashMap.maximumKeyBy((x, y) -> x <=> y, HashMap#{1 => 2, 2 => 3, 3 => 4, 5 => 5, 0 => 2}) == Some((5, 5))

    @test
    def maximumKeyBy04(): Bool = HashMap.maximumKeyBy((x, y) -> x <=> y, HashMap#{1 => 2, 2 => 3, 107 => -107, 5 => 5, 0 => 2}) == Some((107, -107))

    @test
    def maximumKeyBy05(): Bool \ IO =
        let range = List.range(0, 2000);
        let m = List.zip(range, range) |> List.toMap;
        let a = new MutList(Static);
        discard HashMap.maximumKeyBy((x, y) -> { let b = new MutList(Static); MutList.push!(y, b); MutList.append!(MutList.toList(b), a); x <=> y }, m);
        MutList.toList(a) == List.range(1, 2000) // The first / left most value is ignored


    /////////////////////////////////////////////////////////////////////////////
    // maximumValue                                                            //
    /////////////////////////////////////////////////////////////////////////////

    @test
    def maximumValue01(): Bool = HashMap.maximumValue(empty(): HashMap[Int32, Int32]) == None

    @test
    def maximumValue02(): Bool = HashMap.maximumValue(HashMap#{1 => 2, 2 => 3, 3 => 4, 5 => 5}) == Some((5, 5))

    @test
    def maximumValue03(): Bool = HashMap.maximumValue(HashMap#{1 => 2, 2 => 3, 3 => 4, 5 => 5, 0 => 2}) == Some((5, 5))

    @test
    def maximumValue04(): Bool = HashMap.maximumValue(HashMap#{1 => 2, 2 => 3, -107 => 107, 0 => 2}) == Some((-107, 107))


    /////////////////////////////////////////////////////////////////////////////
    // maximumValueBy                                                          //
    /////////////////////////////////////////////////////////////////////////////

    @test
    def maximumValueBy01(): Bool = HashMap.maximumValueBy((x, y) -> x <=> y, empty(): HashMap[Int32, Int32]) == None

    @test
    def maximumValueBy02(): Bool = HashMap.maximumValueBy((x, y) -> x <=> y, HashMap#{1 => 2, 2 => 3, 3 => 4, 5 => 5}) == Some((5, 5))

    @test
    def maximumValueBy03(): Bool = HashMap.maximumValueBy((x, y) -> x <=> y, HashMap#{1 => 2, 2 => 3, 3 => 4, 5 => 5, 0 => 2}) == Some((5, 5))

    @test
    def maximumValueBy04(): Bool = HashMap.maximumValueBy((x, y) -> x <=> y, HashMap#{1 => 2, 2 => 3, -107 => 107,5 => 5, 0 => 2}) == Some((-107, 107))

    @test
    def maximumValueBy05(): Bool \ IO =
        let range = List.range(0, 2000);
        let m = List.zip(range, range) |> List.toMap;
        let a = new MutList(Static);
        discard HashMap.maximumValueBy((x, y) -> { let b = new MutList(Static); MutList.push!(y, b); MutList.append!(MutList.toList(b), a); x <=> y }, m);
        MutList.toList(a) == List.range(1, 2000) // The first / left most value is ignored


    /////////////////////////////////////////////////////////////////////////////
    // toDelayList                                                             //
    /////////////////////////////////////////////////////////////////////////////

    @test
    def toDelayList01(): Bool =
        HashMap.empty(): HashMap[Unit, Unit] |> HashMap.toDelayList == DelayList.empty()

    @test
    def toDelayList02(): Bool =
        HashMap.unfold(s -> if (s < 1000) Some((s, "a", s + 1)) else None, 0) |> HashMap.toDelayList == DelayList.repeat("a") |> DelayList.zip(DelayList.range(0, 1000))

    @test
    def toDelayList03(): Bool =
        HashMap.unfold(s -> if (s < 1000) Some((s, "a", s + 1)) else None, 0) |> HashMap.toDelayList |> DelayList.toMap == HashMap.unfold(s -> if (s < 1000) Some((s, "a", s + 1)) else None, 0)

    /////////////////////////////////////////////////////////////////////////////
    // toChain                                                                 //
    /////////////////////////////////////////////////////////////////////////////

    @test
    def toChain01(): Bool =
        HashMap.toChain(empty(): HashMap[Int32, Int32]) == Chain.empty(): Chain[(Int32, Int32)]

    @test
    def toChain02(): Bool =
        HashMap.toChain(singleton(1, 1)) == Chain.singleton((1, 1))

    @test
    def toChain03(): Bool =
        HashMap.toChain(HashMap#{1 => 1, 2 => 2}) == List.toChain((1, 1) :: (2, 2) :: Nil)

    @test
    def toChain04(): Bool =
        HashMap.toChain(HashMap#{1 => 1, 2 => 2, 3 => 3}) == List.toChain((1, 1) :: (2, 2) :: (3, 3) :: Nil)


    /////////////////////////////////////////////////////////////////////////////
    // toMultiMap                                                              //
    /////////////////////////////////////////////////////////////////////////////

    @test
    def toMultiMap01(): Bool =
        HashMap.toMultiMap(empty(): HashMap[Int32, Char]) |> MultiMap.toAscList == Nil

    @test
    def toMultiMap02(): Bool =
        HashMap.toMultiMap(singleton(1, 'a')) |> MultiMap.toAscList == (1, 'a') :: Nil

    @test
    def toMultiMap03(): Bool =
        HashMap.toMultiMap(HashMap#{1 => 'a', 2 => 'b'}) |> MultiMap.toAscList == (1, 'a') :: (2, 'b') :: Nil

    /////////////////////////////////////////////////////////////////////////////
    // iterator                                                                //
    /////////////////////////////////////////////////////////////////////////////

    @test
    def iterator01(): Bool = region r {
        HashMap.empty(): HashMap[Int32, Int32] |> HashMap.iterator(r) |> Iterator.toMap == HashMap.empty()
    }

    @test
    def iterator02(): Bool = region r {
        HashMap#{"a" => 1, "b" => 2, "c" => 3, "d" => 4} |> HashMap.iterator(r) |> Iterator.toMap == HashMap#{"a" => 1, "b" => 2, "c" => 3, "d" => 4}
    }

    @test
    def iterator03(): Bool = region r {
        let l = List.range(0, 100);
        List.zip(l, List.reverse(l)) |> List.toMap |> HashMap.iterator(r) |> Iterator.toMap |> HashMap.toList == List.zip(List.range(0, 100), List.reverse(List.range(0, 100)))
    }


    /////////////////////////////////////////////////////////////////////////////
    // iteratorKeys                                                            //
    /////////////////////////////////////////////////////////////////////////////

    @test
    def iteratorKeys01(): Bool = region r {
        HashMap.empty(): HashMap[Int32, Int32] |> HashMap.iteratorKeys(r) |> Iterator.toList == Nil
    }

    @test
    def iteratorKeys02(): Bool = region r {
        HashMap#{"a" => 1, "b" => 2, "c" => 3, "d" => 4} |> HashMap.iteratorKeys(r) |> Iterator.toList == "a" :: "b" :: "c" :: "d" :: Nil
    }

    @test
    def iteratorKeys03(): Bool = region r {
        let l = List.range(0, 100);
        List.zip(l, List.reverse(l)) |> List.toMap |> HashMap.iteratorKeys(r) |> Iterator.toList == List.range(0, 100)
    }


    /////////////////////////////////////////////////////////////////////////////
    // iteratorValues                                                          //
    /////////////////////////////////////////////////////////////////////////////

    @test
    def iteratorValues01(): Bool = region r {
        HashMap.empty(): HashMap[Int32, Int32] |> HashMap.iteratorValues(r) |> Iterator.toList == Nil
    }

    @test
    def iteratorValues02(): Bool = region r {
        HashMap#{"a" => 1, "b" => 2, "c" => 3, "d" => 4} |> HashMap.iteratorValues(r) |> Iterator.toList == 1 :: 2 :: 3 :: 4 :: Nil
    }

    @test
    def iteratorValues03(): Bool = region r {
        let l = List.range(0, 100);
        List.zip(l, List.reverse(l)) |> List.toMap |> HashMap.iteratorValues(r) |> Iterator.toList == List.range(0, 100) |> List.reverse
    }

    /////////////////////////////////////////////////////////////////////////////
    // sequence                                                                //
    /////////////////////////////////////////////////////////////////////////////

    @test
    def sequence01(): Bool =
        let m: HashMap[Int32, Identity[Char]] = empty();
        HashMap.sequence(m) == Identity(empty())

    @test
    def sequence02(): Bool =
        let m = singleton(1, Identity('a'));
        HashMap.sequence(m) == Identity(singleton(1, 'a'))

    @test
    def sequence03(): Bool =
        let m = HashMap#{1 => Identity('a'), 2 => Identity('b')};
        HashMap.sequence(m) == Identity(HashMap#{1 => 'a', 2 => 'b'})

    @test
    def sequence04(): Bool =
        let m = HashMap#{1 => Identity('a'), 2 => Identity('b'), 3 => Identity('c')};
        HashMap.sequence(m) == Identity(HashMap#{1 => 'a', 2 => 'b', 3 => 'c'})

    /////////////////////////////////////////////////////////////////////////////
    // traverse                                                                //
    /////////////////////////////////////////////////////////////////////////////

    @test
    def traverse01(): Bool = region r {
        let st = ref '#' @ r;
        let m: HashMap[Int32, Char] = empty();
        let ans = HashMap.traverse(x -> {st := x; Identity(x)}, m);
        ans == Identity(empty()) and deref st == '#'
    }

    @test
    def traverse02(): Bool = region r {
        let st = ref '#' @ r;
        let m = singleton(1, 'a');
        let ans = HashMap.traverse(x -> {st := x; Identity(x)}, m);
        ans == Identity(singleton(1, 'a')) and deref st == 'a'
    }

    @test
    def traverse03(): Bool = region r {
        let st = ref '#' @ r;
        let m = HashMap#{1 => 'a', 2 => 'b'};
        let ans = HashMap.traverse(x -> {st := x; Identity(x)}, m);
        ans == Identity(HashMap#{1 => 'a', 2 => 'b'}) and deref st == 'b'
    }

    @test
    def traverse04(): Bool = region r {
        let st = ref '#' @ r;
        let m = HashMap#{1 => 'a', 2 => 'b', 3 => 'c'};
        let ans = HashMap.traverse(x -> {st := x; Identity(x)}, m);
        ans == Identity(HashMap#{1 => 'a', 2 => 'b', 3 => 'c'}) and deref st == 'c'
    }

    /////////////////////////////////////////////////////////////////////////////
    // traverseWithKey                                                         //
    /////////////////////////////////////////////////////////////////////////////

    @test
    def traverseWithKey01(): Bool = region r {
        let st = ref (0, '#') @ r;
        let m: HashMap[Int32, Char] = empty();
        let ans = HashMap.traverseWithKey((k, v) -> {st := (k, v); Identity(v)}, m);
        ans == Identity(empty()) and deref st == (0, '#')
    }

    @test
    def traverseWithKey02(): Bool = region r {
        let st = ref (0, '#') @ r;
        let m = singleton(1, 'a');
        let ans = HashMap.traverseWithKey((k, v) -> {st := (k, v); Identity(v)}, m);
        ans == Identity(singleton(1, 'a')) and deref st == (1, 'a')
    }

    @test
    def traverseWithKey03(): Bool = region r {
        let st = ref (0, '#') @ r;
        let m = HashMap#{1 => 'a', 2 => 'b'};
        let ans = HashMap.traverseWithKey((k, v) -> {st := (k, v); Identity(v)}, m);
        ans == Identity(HashMap#{1 => 'a', 2 => 'b'}) and deref st == (2, 'b')
    }

    @test
    def traverseWithKey04(): Bool = region r {
        let st = ref (0, '#') @ r;
        let m = HashMap#{1 => 'a', 2 => 'b', 3 => 'c'};
        let ans = HashMap.traverseWithKey((k, v) -> {st := (k, v); Identity(v)}, m);
        ans == Identity(HashMap#{1 => 'a', 2 => 'b', 3 => 'c'}) and deref st == (3, 'c')
    }

    /////////////////////////////////////////////////////////////////////////////
    // joinKeys                                                                //
    /////////////////////////////////////////////////////////////////////////////

    @test
    def joinKeys01(): Bool =
        HashMap.empty(): HashMap[Int32, Int32] |> HashMap.joinKeys(",") == ""

    @test
    def joinKeys02(): Bool =
        singleton(1, 1) |> HashMap.joinKeys(",") == "1"

    @test
    def joinKeys03(): Bool =
        HashMap#{0 => 1, 1 => 2, 2 => 2} |> HashMap.joinKeys(",") == "0,1,2"

    @test
    def joinKeys04(): Bool =
        HashMap#{"0" => 1, "1" => 2, "2" => 2} |> HashMap.joinKeys(",") == "0,1,2"


    /////////////////////////////////////////////////////////////////////////////
    // joinValues                                                              //
    /////////////////////////////////////////////////////////////////////////////

    @test
    def joinValues01(): Bool =
        HashMap.empty(): HashMap[Int32, Int32] |> HashMap.joinValues(",") == ""

    @test
    def joinValues02(): Bool =
        singleton(1, 1) |> HashMap.joinValues(",") == "1"

    @test
    def joinValues03(): Bool =
        HashMap#{0 => 1, 1 => 2, 2 => 2} |> HashMap.joinValues(",") == "1,2,2"

    @test
    def joinValues04(): Bool =
        HashMap#{0 => "1", 1 => "2", 2 => "2"} |> HashMap.joinValues(",") == "1,2,2"


    /////////////////////////////////////////////////////////////////////////////
    // joinWith                                                                //
    /////////////////////////////////////////////////////////////////////////////

    @test
    def joinWith01(): Bool =
        HashMap.empty(): HashMap[Int32, Int32] |> HashMap.joinWith((k, v) -> "${k} => ${v}", ",") == ""

    @test
    def joinWith02(): Bool =
        singleton(1, 1) |>
            HashMap.joinWith((k, v) -> "${k} => ${v}", ", ") == "1 => 1"

    @test
    def joinWith03(): Bool =
        HashMap#{0 => 1, 1 => 2, 2 => 2} |>
            HashMap.joinWith((k, v) -> "${k} => ${v}", ", ") == "0 => 1, 1 => 2, 2 => 2"

    @test
    def joinWith04(): Bool =
        HashMap#{0 => "1", 1 => "2", 2 => "2"} |>
            HashMap.joinWith((k, v) -> "${k} => ${v}", ", ") == "0 => 1, 1 => 2, 2 => 2"


    /////////////////////////////////////////////////////////////////////////////
    // explode                                                                 //
    /////////////////////////////////////////////////////////////////////////////

    @test
    def explode01(): Bool =
        HashMap.explode(singleton(1, Set#{2, 3)}) == Set#{(1, 2), (1, 3)}

    @test
    def explode02(): Bool =
        HashMap.explode(singleton(1, Set#{2, 3), 2 => Set#{2, 3}}) == Set#{(1, 2), (1, 3), (2, 2), (2, 3)}

    @test
    def explode03(): Bool =
        HashMap.explode(singleton(1, Set#{2, 3), 2 => Set#{5, 6, 7}}) == Set#{(1, 2), (1, 3), (2, 5), (2, 6), (2, 7)}

    @test
    def explode04(): Bool =
        HashMap.explode(singleton(1, Set#{2, 3), 2 => Set#{5, 6, 7}, 3 => Set#{0}}) == Set#{(1, 2), (1, 3), (2, 5), (2, 6), (2, 7), (3, 0)}

    /////////////////////////////////////////////////////////////////////////////
    // LowerBound.minValue                                                     //
    /////////////////////////////////////////////////////////////////////////////

    @test
    def minValue01(): Bool =
        LowerBound.minValue(): HashMap[Int32, Int32] == HashMap.empty()

    /////////////////////////////////////////////////////////////////////////////
    // PartialOrder.lessEqual                                                  //
    /////////////////////////////////////////////////////////////////////////////

    @test
    def lessEqual01(): Bool = PartialOrder.lessEqual(HashMap.empty(): HashMap[Int32, Int32], HashMap.empty(): HashMap[Int32, Int32])

    @test
    def lessEqual02(): Bool = PartialOrder.lessEqual(HashMap.empty(): HashMap[Int32, Int32], HashMap.singleton(1, 1))

    @test
    def lessEqual03(): Bool = not PartialOrder.lessEqual(HashMap.singleton(1, 1), HashMap.empty(): HashMap[Int32, Int32])

    @test
    def lessEqual04(): Bool = PartialOrder.lessEqual(HashMap.singleton(1, 1), HashMap.singleton(1, 1))

    @test
    def lessEqual05(): Bool = not PartialOrder.lessEqual(HashMap.singleton(1, 1), HashMap.singleton(1, 10))

    /////////////////////////////////////////////////////////////////////////////
    // JoinLattice.leastUpperBound                                             //
    /////////////////////////////////////////////////////////////////////////////

    @test
    def leastUpperBound01(): Bool =
        JoinLattice.leastUpperBound(HashMap.empty(): HashMap[Int32, Int32], HashMap.empty(): HashMap[Int32, Int32]) == HashMap.empty(): HashMap[Int32, Int32]

    @test
    def leastUpperBound02(): Bool =
        JoinLattice.leastUpperBound(HashMap.empty(): HashMap[Int32, Int32], HashMap.singleton(1, 1)) == HashMap.singleton(1, 1)

    @test
    def leastUpperBound03(): Bool =
        JoinLattice.leastUpperBound(HashMap.singleton(1, 1), HashMap.empty(): HashMap[Int32, Int32]) == HashMap.singleton(1, 1)

    @test
    def leastUpperBound04(): Bool =
        JoinLattice.leastUpperBound(HashMap.singleton(1, 1), HashMap.singleton(1, 1)) == HashMap.singleton(1, 1)

    @test
    def leastUpperBound05(): Bool =
        JoinLattice.leastUpperBound(HashMap.singleton(1, 1), HashMap.singleton(1, 10)) == HashMap.singleton(1, 10)

    @test
    def leastUpperBound06(): Bool =
        JoinLattice.leastUpperBound(HashMap.singleton(1, 1), HashMap.singleton(2, 2)) == HashMap#{1 => 1, 2 => 2}

    @test
    def leastUpperBound07(): Bool =
        JoinLattice.leastUpperBound(HashMap.singleton(1, 1), HashMap#{1 => 10, 2 => 2}) == HashMap#{1 => 10, 2 => 2}

    /////////////////////////////////////////////////////////////////////////////
    // MeetLattice.greatestLowerBound                                          //
    /////////////////////////////////////////////////////////////////////////////

    @test
    def greatestLowerBound01(): Bool =
        MeetLattice.greatestLowerBound(HashMap.empty(): HashMap[Int32, Int32], HashMap.empty(): HashMap[Int32, Int32]) == HashMap.empty(): HashMap[Int32, Int32]

    @test
    def greatestLowerBound02(): Bool =
        MeetLattice.greatestLowerBound(HashMap.empty(): HashMap[Int32, Int32], HashMap.singleton(1, 1)) == HashMap.empty(): HashMap[Int32, Int32]

    @test
    def greatestLowerBound03(): Bool =
        MeetLattice.greatestLowerBound(HashMap.singleton(1, 1), HashMap.empty(): HashMap[Int32, Int32]) == HashMap.empty(): HashMap[Int32, Int32]

    @test
    def greatestLowerBound04(): Bool =
        MeetLattice.greatestLowerBound(HashMap.singleton(1, 1), HashMap.singleton(1, 1)) == HashMap.singleton(1, 1)

    @test
    def greatestLowerBound05(): Bool =
        MeetLattice.greatestLowerBound(HashMap.singleton(1, 1), HashMap.singleton(1, 10)) == HashMap.singleton(1, 1)

    @test
    def greatestLowerBound06(): Bool =
        MeetLattice.greatestLowerBound(HashMap.singleton(1, 1), HashMap.singleton(2, 2)) == HashMap.empty(): HashMap[Int32, Int32]

    @test
    def greatestLowerBound07(): Bool =
        MeetLattice.greatestLowerBound(HashMap.singleton(1, 1), HashMap#{1 => 10, 2 => 2}) == HashMap.singleton(1, 1)

}