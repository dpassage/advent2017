//: [Previous](@previous)

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
struct Grid: CustomStringConvertible {
    var nodes: [Point: Bool] = [:] // true if infected
    var virusLocation: Point
    var virusDirection: Direction
    var causedInfection = 0
    init(input: String) {
        let lines = input.components(separatedBy: "\n").filter { !$0.isEmpty }
        let height = lines.count
        let width = lines.map { $0.count }.max()!

        self.virusLocation = Point(x: width / 2, y: height / 2)
        self.virusDirection = .north

        for (y, line) in lines.enumerated() {
            for (x, char) in line.enumerated() {
                nodes[Point(x: x, y: y)] = char == "#"
            }
        }
    }

    mutating func burst() {
        let infected = nodes[virusLocation, default: false]
        if infected {
            virusDirection = virusDirection.turningRight()
        } else {
            causedInfection += 1
            virusDirection = virusDirection.turningLeft()
        }
        nodes[virusLocation] = !infected
        virusLocation = virusDirection.move(virusLocation)
    }

    var description: String {
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
                    let char = nodes[Point(x: x, y: y), default: false] ? "#" : "."
                    result.append(char)
                }
            }
            result.append("\n")
        }
        return result
    }
}

let testInput = """
..#
#..
...
"""

var testGrid = Grid(input: testInput)
print(testGrid)
for i in 0..<70 {
    testGrid.burst()
    print(i)
    print(testGrid)
}
print(testGrid.causedInfection)

let url = Bundle.main.url(forResource: "day22.input", withExtension: "txt")!
let day22input = try! String(contentsOf: url)
var day22grid = Grid(input: day22input)
print(day22grid)
for i in 0..<10_000 {
    day22grid.burst()
}
print(day22grid.causedInfection)

//: [Next](@next)
