//: [Previous](@previous)

import Foundation

enum Direction: String {
    case up
    case down
    case left
    case right

    var delta: (Int, Int) {
        switch self {
        case .up: return (0, -1)
        case .down: return (0, 1)
        case .left: return (-1, 0)
        case .right: return (1, 0)
        }
    }
}

struct Position {
    var x: Int
    var y: Int
    var dir: Direction

    func moving() -> Position {
        let delta = dir.delta
        return Position(x: x + delta.0, y: y + delta.1, dir: dir)
    }

    func turning(_ direction: Direction) -> Position {
        return Position(x: x, y: y, dir: direction)
    }

    func sides() -> [Position] {
        switch dir {
        case .left, .right:
            return [self.turning(.up).moving(), self.turning(.down).moving()]
        case .up, .down:
            return [self.turning(.left).moving(), self.turning(.right).moving()]
        }
    }
}

//extension Position: CustomStringConvertible {
//    var description: String {
//        return "(x: \(x), y: \(y), dir: \(dir))"
//    }
//}
class Maze {
    var current: Position
    var maze: [[Character]]
    var path: [Character] = []
    var steps = 0

    private func charAt(position: Position) -> Character {
        guard maze.indices.contains(position.y) else { return " " }
        let line = maze[position.y]
        guard line.indices.contains(position.x) else { return " " }
        return line[position.x]
    }

    init(s: String) {
        maze = s.split(separator: "\n").map { [Character]($0) }
        for (i, c) in maze[0].enumerated() {
            if c == "|" {
                current = Position(x: i, y: 0, dir: .down)
                return
            }
        }
        current = Position(x: -1, y: -1, dir: .down)
    }

    func run() -> (String, Int) {
        loop:
        while true {
            let c = (charAt(position: current))
            switch c {
            case " ": break loop
            case "A"..."Z":
                path.append(c)
                current = current.moving()
                steps += 1
            case "+":
                let sides = current.sides()
                if charAt(position: sides[0]) != " " { current = sides[0]; steps += 1; continue loop }
                if charAt(position: sides[1]) != " " { current = sides[1]; steps += 1; continue loop }
                break loop
            default:
                current = current.moving()
                steps += 1
            }
        }
        return (String(path), steps)
    }
}

let testInput = """
    |
    |  +--+
    A  |  C
F---|----E|--+
    |  |  |  D
    +B-+  +--+
"""

let testMaze = Maze(s: testInput)
print(testMaze.run())

let input = try! String(contentsOf: #fileLiteral(resourceName: "day19.input.txt"))
let maze = Maze(s: input)
print(maze.run())

//: [Next](@next)
