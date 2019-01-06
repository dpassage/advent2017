import Foundation
import AdventLib

enum Direction {
    case north
    case south
    case east
    case west

    func turningLeft() -> Direction {
        switch self {
        case .north: return .west
        case .south: return .east
        case .east: return .north
        case .west: return .south
        }
    }

    func turningRight() -> Direction {
        switch self {
        case .north: return .east
        case .south: return .west
        case .east: return .south
        case .west: return .north
        }
    }

    func reversed() -> Direction {
        switch self {
        case .north: return .south
        case .south: return .north
        case .east: return .west
        case .west: return .east
        }
    }

    func move(_ point: Point) -> Point {
        switch self {
        case .north: return Point(x: point.x, y: point.y - 1)
        case .south: return Point(x: point.x, y: point.y + 1)
        case .east: return Point(x: point.x + 1, y: point.y)
        case .west: return Point(x: point.x - 1, y: point.y)
        }
    }

    func char() -> Character {
        switch self {
        case .north: return "^"
        case .south: return "v"
        case .east: return ">"
        case .west: return "<"
        }
    }
}

enum State: CustomStringConvertible {
    case clean
    case weakened
    case infected
    case flagged

    var description: String {
        switch self {
        case .clean: return "."
        case .weakened: return "W"
        case .infected: return "#"
        case .flagged: return "F"
        }
    }

    func next() -> State {
        switch self {
        case .clean: return .weakened
        case .weakened: return .infected
        case .infected: return .flagged
        case .flagged: return .clean
        }
    }
}

public struct Grid: CustomStringConvertible {
    var nodes: [Point: State] = [:] // true if infected
    var virusLocation: Point
    var virusDirection: Direction
    public var causedInfection = 0

    public init(input: String) {
        let lines = input.components(separatedBy: "\n").filter { !$0.isEmpty }
        let height = lines.count
        let width = lines.map { $0.count }.max()!

        self.virusLocation = Point(x: width / 2, y: height / 2)
        self.virusDirection = .north

        for (y, line) in lines.enumerated() {
            for (x, char) in line.enumerated() {
                nodes[Point(x: x, y: y)] = char == "#" ? .infected : .clean
            }
        }
    }

    public mutating func burstALot(times: Int) {
        for _ in 0..<times {
            burst()
        }
    }

    public mutating func burst() {
        let currentState = nodes[virusLocation, default: .clean]
        switch currentState {
        case .clean:
            virusDirection = virusDirection.turningLeft()
        case .weakened:
            // does not turn, will infect
            causedInfection += 1
        case .infected:
            virusDirection = virusDirection.turningRight()
        case .flagged:
            virusDirection = virusDirection.reversed()
        }
        nodes[virusLocation] = currentState.next()
        virusLocation = virusDirection.move(virusLocation)
    }

    public var description: String {
        let xes = nodes.keys.map { $0.x }
        let minX = min(xes.min()!, virusLocation.x)
        let maxX = max(xes.max()!, virusLocation.x)

        let ys = nodes.keys.map { $0.y }
        let minY = min(ys.min()!, virusLocation.y)
        let maxY = max(ys.max()!, virusLocation.y)

        var result = ""
        for y in minY...maxY {
            for x in minX...maxX {
                let here = Point(x: x, y: y)
                if here == virusLocation {
                    result.append(virusDirection.char())
                } else {
                    let char = nodes[Point(x: x, y: y), default: .clean].description
                    result.append(char)
                }
            }
            result.append("\n")
        }
        return result
    }
}
