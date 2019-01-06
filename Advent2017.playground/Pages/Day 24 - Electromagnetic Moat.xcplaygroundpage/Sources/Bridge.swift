import Foundation

public struct Beam: Hashable, CustomStringConvertible {
    var first: Int
    var second: Int

    public var description: String {
        return "\(first),\(second)"
    }

    public init?(line: String) {
        let parts = line.components(separatedBy: "/").compactMap { Int($0) }
        guard parts.count == 2 else { return nil }
        first = parts[0]
        second = parts[1]
    }

    var strength: Int { return first + second }
}

public struct Bridge {
    public var used: [Beam] = []
    var available: Set<Beam>
    var next = 0

    public init(beams: [Beam]) {
        self.available = Set(beams)
    }

    public func nextOnes() -> [Bridge] {
        var result = [Bridge]()

        for nextBeam in available {
            if nextBeam.first == next {
                var newBridge = self
                newBridge.used.append(nextBeam)
                newBridge.next = nextBeam.second
                newBridge.available.remove(nextBeam)
                result.append(newBridge)
            } else if nextBeam.second == next {
                var newBridge = self
                newBridge.used.append(nextBeam)
                newBridge.next = nextBeam.first
                newBridge.available.remove(nextBeam)
                result.append(newBridge)
            }
        }
        return result
    }

    public var strength: Int {
        return used.map { $0.strength }.reduce(0, +)
    }
}


public struct Solver {
    var longest = -1
    var beams: [Beam]

    public init(beams: [Beam]) {
        self.beams = beams
    }

    func strongest(current: Bridge) -> Int {
        var result = -1
        for next in current.nextOnes() {
            result = max(result, next.strength)
            result = max(result, strongest(current: next))
        }
        return result
    }

    public func solve() -> Int {
        let firstBridge = Bridge(beams: beams)
        return strongest(current: firstBridge)
    }
}


public struct Rec {
    public var length: Int
    public var strength: Int
}

extension Rec: Comparable {
    public static func < (lhs: Rec, rhs: Rec) -> Bool {
        if lhs.length == rhs.length {
            return lhs.strength < rhs.strength
        }
        return lhs.length < rhs.length
    }
}

extension Bridge {
    public var length: Rec {
        return Rec(length: used.count, strength: strength)
    }
}
public struct LongSolver {

    var beams: [Beam]
    public init(beams: [Beam]) {
        self.beams = beams
    }

    func longest(current: Bridge) -> Rec {
        var result = Rec(length: -1, strength: -1)
        for next in current.nextOnes() {
            result = max(result, next.length)
            result = max(result, longest(current: next))
        }
        return result
    }

    public func solve() -> Rec {
        let firstBridge = Bridge(beams: beams)
        return longest(current: firstBridge)
    }
}
