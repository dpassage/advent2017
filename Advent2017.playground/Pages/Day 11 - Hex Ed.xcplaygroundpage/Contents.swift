//: [Previous](@previous)

import Foundation

extension Int {
    var isOdd: Bool { return self & 1 == 1 }
}

enum Move: String {
    case n
    case ne
    case se
    case s
    case sw
    case nw

    static let allValues: [Move] = [.n, .ne, .se, .s, .sw, .nw]
}

struct HexLoc {
    var x: Int
    var y: Int
    var z: Int

    mutating func move(_ dir: Move)  {
        switch dir {
        case .n:
            y += 1
            z -= 1
        case .s:
            y -= 1
            z += 1
        case .ne:
            x += 1
            z -= 1
        case .sw:
            x -= 1
            z += 1
        case .se:
            x += 1
            y -= 1
        case .nw:
            x -= 1
            y += 1
        }
    }

    func moving(_ dir: Move) -> HexLoc {
        var new = self
        new.move(dir)
        return new
    }

    func cartesian(from: HexLoc) -> Int {
        return max(abs(self.x - from.x), abs(self.y - from.y), abs(self.z - from.z))
    }

    static let origin = HexLoc(x: 0, y: 0, z: 0)

    func movesToOrigin() -> Int {
        return cartesian(from: HexLoc.origin)
    }
}

extension HexLoc: Equatable {
    static func ==(lhs: HexLoc, rhs: HexLoc) -> Bool {
        return lhs.x == rhs.x && lhs.y == rhs.y
    }
}

func distance(input: String) -> (Int, Int) {
    var location = HexLoc.origin

    let moves = input.split { (c) -> Bool in
        let chars: [Character] = ["n", "s", "e", "w"]
        return !chars.contains(c)
    }

    var furthest = 0
    for move in moves {
        guard let m = Move(rawValue: String(move)) else {
            print("BAD MOVE: \(move)")
            continue
        }
        location.move(m)
        furthest = max(furthest, location.movesToOrigin())
    }

    print(location)

    let distance = location.movesToOrigin()
    return (distance, furthest)
}

print(distance(input: "ne,ne,ne"))
print(distance(input: "ne,ne,sw,sw"))
print(distance(input: "ne,ne,s,s"))
print(distance(input: "se,sw,se,sw,sw"))

let input = try! String(contentsOf: #fileLiteral(resourceName: "day11.input.txt"))
print(distance(input: input))
//: [Next](@next)
