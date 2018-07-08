//: [Previous](@previous)

import Foundation

/*

 A pattern like `../.#` represents:

 ..
 .#

 This can be represented as a binary number, with the MSB first:

 8 4
 2 1

 A pattern like `.#./..#/###` is a 9-bit number; `#..#/..../#..#/.##.` is a 16-bit number.

 Rotation for 4 can be a simple lookup table:

 0
 1, 2, 4, 8
 3, 5, 10, 12
 6, 9
 7, 11, 14, 13
 15

*/

func rotate2(n: Int) -> Int {
    switch n {
    case 0: return 0
    case 1: return 2
    case 2: return 4
    case 3: return 5
    case 4: return 8
    case 5: return 10
    case 6: return 9
    case 7: return 11
    case 8: return 3
    case 9: return 6
    case 10: return 12
    case 11: return 14
    case 12: return 3
    case 13: return 7
    case 14: return 13
    case 15: return 15
    default: return -1
    }
}


func rotate3(n: Int) -> Int {
    // swift gets mad if this is one expression
    let a = ((n & 256) >> 2)
    let b = ((n & 128) >> 4)
    let c = ((n &  64) >> 6)
    let d = ((n &  32) << 2)
    let e =  (n &  16)
    let f = ((n &   8) >> 2)
    let g = ((n &   4) << 6)
    let h = ((n &   2) << 4)
    let i = ((n &   1) << 2)

    return a | b | c | d | e | f | g | h | i
}

/*
 So we can read in the rules, and construct lookup tables which do the mapping. The initial state
 is `.#./..#/###`, which becomes 143 in our schema. Each 2x cell can be representd by an integer, which maps
 to a new integer representing a 3x cell. Each 3x cell maps to an integer which represents a 4x cell.


 */

struct TwoGrid {
    private let n: Int

    init(n: Int) {
        guard (0..<16).contains(n) else { fatalError() }
        self.n = n
    }

    init?(s: String) {
        guard s.count == 5 else { return nil }
        var n = 0
        loop:
        for char in s {
            switch char {
            case "/": continue
            case ".": n = n << 1
            case "#": n = (n << 1) + 1
            default: break loop
            }
        }
        self.init(n: n)
    }

    func rotated() -> TwoGrid {
        switch n {
        case 0: return TwoGrid(n: 0)
        case 1: return TwoGrid(n: 2)
        case 2: return TwoGrid(n: 4)
        case 3: return TwoGrid(n: 5)
        case 4: return TwoGrid(n: 8)
        case 5: return TwoGrid(n: 10)
        case 6: return TwoGrid(n: 9)
        case 7: return TwoGrid(n: 11)
        case 8: return TwoGrid(n: 3)
        case 9: return TwoGrid(n: 6)
        case 10: return TwoGrid(n: 12)
        case 11: return TwoGrid(n: 14)
        case 12: return TwoGrid(n: 3)
        case 13: return TwoGrid(n: 7)
        case 14: return TwoGrid(n: 13)
        case 15: return TwoGrid(n: 15)
        default: fatalError()
        }
    }

    func matches(_ other: TwoGrid) -> Bool {
        var other = other
        if self.n == other.n { return true }
        for _ in 0..<3 {
            other = other.rotated()
            if self.n == other.n { return true }
        }
        return false
    }
}

struct ThreeGrid {
    private let n: Int

    init(n: Int) {
        guard (0..<512).contains(n) else { fatalError() }
        self.n = n
    }

    init?(s: String) {
        guard s.count == 11 else { return nil }
        var n = 0
        loop:
            for char in s {
                switch char {
                case "/": continue
                case ".": n = n << 1
                case "#": n = (n << 1) + 1
                default: break loop
                }
        }
        self.init(n: n)
    }

    /*
     Rotation for 9 is trickier; there are 512 possible numbers.

     8 7 6
     5 4 3
     2 1 0
     Rotating 90 degrees clockwise means:

     bit 256 becomes bit  64
     bit 128 becomes bit   8
     bit  64 becomes bit   1
     bit  32 becomes bit 128
     bit  16 becomes bit  16
     bit   8 becomes bit   2
     bit   4 becomes bit 256
     bit   2 becomes bit  32
     bit   1 becomes bit   4

     */

    func rotated() -> ThreeGrid {
        // swift gets mad if this is one expression
        let a = ((n & (1 << 8)) >> 2)
        let b = ((n & (1 << 7)) >> 4)
        let c = ((n & (1 << 6)) >> 6)
        let d = ((n & (1 << 5)) << 2)
        let e =  (n & (1 << 4))
        let f = ((n & (1 << 3)) >> 2)
        let g = ((n & (1 << 2)) << 6)
        let h = ((n & (1 << 1)) << 4)
        let i = ((n &  1      ) << 2)

        let newN = a | b | c | d | e | f | g | h | i
        return ThreeGrid(n: newN)
    }

    func matches(_ other: ThreeGrid) -> Bool {
        var other = other
        if self.n == other.n { return true }
        for _ in 0..<3 {
            other = other.rotated()
            if self.n == other.n { return true }
        }
        return false
    }
}

struct FourGrid {
    private let n: Int

    init(n: Int) {
        let limit = 1 << 16
        guard (0..<limit).contains(n) else { fatalError() }
        self.n = n
    }

    init?(s: String) {
        guard s.count == 19 else { return nil }
        var n = 0
        loop:
            for char in s {
                switch char {
                case "/": continue
                case ".": n = n << 1
                case "#": n = (n << 1) + 1
                default: break loop
                }
        }
        self.init(n: n)
    }

    /*
     Last step is converting a 4x cell into 4 2x cells.

     15 14 13 12
     11 10  9  8
      7  6  5  4
      3  2  1  0

     becomes

     3 2
     1 0

     where the digits are bit numbers.

     result is left to right, top to bottom, 0 at top left
     */
    func split() -> [[TwoGrid]] {
        let tl: Int = (n & (3 << 14)) >> 12 |
                      (n & (3 << 10)) >> 10
        let tr: Int = (n & (3 << 12)) >> 10 |
                      (n & (3 <<  8)) >>  8
        let bl: Int = (n & (3 <<  6)) >>  4 |
                      (n & (3 <<  2)) >>  2
        let br: Int = (n & (3 <<  4)) >>  2 |
                      (n &  3       )

        return [[TwoGrid(n: tl), TwoGrid(n: tr)], [TwoGrid(n: bl), TwoGrid(n: br)]]
    }
}

struct TwoToThreeRule {
    var input: TwoGrid
    var output: ThreeGrid

    init?(s: String) {
        let parts = s.components(separatedBy: " => ")
        guard parts.count == 2,
            let input = TwoGrid(s: parts[0]),
            let output = ThreeGrid(s: parts[1]) else { return nil }

        self.input = input
        self.output = output
    }

    func apply(to grid: TwoGrid) -> ThreeGrid? {
        return input.matches(grid) ? output : nil
    }
}

struct ThreeToFourRule {
    var input: ThreeGrid
    var output: FourGrid

    func apply(to grid: ThreeGrid) -> FourGrid? {
        return input.matches(grid) ? output : nil
    }
}


//: [Next](@next)
