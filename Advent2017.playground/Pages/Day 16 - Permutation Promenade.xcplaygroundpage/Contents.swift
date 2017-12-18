//: [Previous](@previous)

import Foundation

let starting = "abcdefghijklmnop"
func dancing(steps: String, s: String) -> String {
    var chars = [Character](s)

    let splitSteps = steps.split(whereSeparator: { [",","\n"].contains($0) })
    for step in splitSteps {
        guard let command = step.first else { continue }
        switch command {
        case "s":
            var remainder = step
            remainder.removeFirst()
            guard let size = Int(remainder) else { print("command \(step) size unknown"); break }
            let removed = chars.suffix(size)
            chars.removeLast(size)
            chars.insert(contentsOf: removed, at: 0)
        case "x":
            var remainder = step
            remainder.removeFirst()
            let positions = remainder.split(separator: "/")
            guard positions.count == 2 else { print("command \(step) not enough indices"); break }
            guard let from = Int(positions[0]), let to = Int(positions[1]) else { print("command \(step) indices unknown"); break }
            chars.swapAt(from, to)
        case "p":
            var remainder = step
            remainder.removeFirst()
            let positions = remainder.split(separator: "/")
            guard positions.count == 2 else { print("command \(step) not enough chars"); break}
            guard let fromChar = positions[0].first, let toChar = positions[1].first else { print("command \(step) not enough chars"); break }
            guard let from = chars.index(of: fromChar), let to = chars.index(of: toChar) else { print("command \(step) chars not found");  break }
            chars.swapAt(from, to)
        default:
            print("unknown command \(command)")
            break
        }
    }
    print(chars)

    return String(chars)
}

let testInput = "s1,x3/4,pe/b"

let input = try! String(contentsOf: #fileLiteral(resourceName: "day16.input.txt"))

func danceJustSpinExchange(steps: String, input: String) -> String {
    var chars = [Character](input)
    guard chars.count == 16 else { fatalError() }
    print(chars)
    let splitSteps = steps.split(whereSeparator: { [",","\n"].contains($0) })
    for step in splitSteps {
        guard let command = step.first else { continue }
        switch command {
        case "s":
            var remainder = step
            remainder.removeFirst()
            guard let size = Int(remainder) else { print("command \(step) size unknown"); break }
            let removed = chars.suffix(size)
            chars.removeLast(size)
            chars.insert(contentsOf: removed, at: 0)
        case "x":
            var remainder = step
            remainder.removeFirst()
            let positions = remainder.split(separator: "/")
            guard positions.count == 2 else { print("command \(step) not enough indices"); break }
            guard let from = Int(positions[0]), let to = Int(positions[1]) else { print("command \(step) indices unknown"); break }
            chars.swapAt(from, to)
        default:
            break
        }
    }
    print(chars)
    return String(chars)
}


// Given an input function, returns a new function which applies the same
// position-based transform
func createPositionMap(input: (String) -> String) -> (String) -> String {
    let testInput = "abcdefghijklmnop"
    let result = input(testInput)

    var map: [Int: Int] = [:]

    let a: UnicodeScalar = "a"
    for (i, scalar) in result.unicodeScalars.enumerated() {
        let fromIndex = Int(scalar.value - a.value)
        map[fromIndex] = i
    }

    return { input -> String in
        let chars = [Character](input)
        var result = [Character](repeating: "0", count: 16)

        for (i, char) in chars.enumerated() {
            let dest = map[i]!
            result[dest] = char
        }
        return String(result)
    }
}


let positionInput: (String) -> String = { s in
    return danceJustSpinExchange(steps: input, input: s)
}

let positionMapOnce = createPositionMap(input: positionInput)

print(positionMapOnce("abcdefghijklmnop"))


func danceJustPartner(steps: String, input: String) -> String {
    var chars = [Character](input)
    print(chars)
    for step in steps.split(whereSeparator: { [",","\n"].contains($0) }) {
        guard let command = step.first else { continue }
        switch command {
        case "p":
            var remainder = step
            remainder.removeFirst()
            let positions = remainder.split(separator: "/")
            guard positions.count == 2 else { print("command \(step) not enough chars"); break}
            guard let fromChar = positions[0].first, let toChar = positions[1].first else { print("command \(step) not enough chars"); break }
            guard let from = chars.index(of: fromChar), let to = chars.index(of: toChar) else { print("command \(step) chars not found");  break }
            chars.swapAt(from, to)

        default:
            break
        }
    }
    print(chars)
    return String(chars)
}


// Given an input function, returns a new function which applies the same
// character-based transform
func createCharacterMap(input: (String) -> String) -> (String) -> String {
    let testInput = "abcdefghijklmnop"
    let result = input(testInput)

    var map: [Character: Character] = [:]

    for (input, output) in zip(testInput, result) {
        map[input] = output
    }
    return { input -> String in
        let chars = [Character](input)
        let result = chars.map { (char) -> Character in
            return map[char] ?? "0"
        }
        return String(result)
    }
}

let charInput: (String) -> String = { test -> String in
    return danceJustPartner(steps: input, input: test)
}

let charMapOnce = createCharacterMap(input: charInput)

print(danceJustPartner(steps: input, input: "abcdefghijklmnop"))
print(charMapOnce("abcdefghijklmnop"))

typealias StringMap = (String) -> String

func apply(fn: StringMap, to: String, times: Int) -> String {
    if times == 0 { return to }
    return apply(fn: fn, to: fn(to), times: times - 1)
}

let charMapx10 = createCharacterMap { (s) -> String in
    return apply(fn: charMapOnce, to: s, times: 10)
}
let charMapx100 = createCharacterMap { (s) -> String in
    return apply(fn: charMapx10, to: s, times: 10)
}
let charMapx1000 = createCharacterMap { (s) -> String in
    return apply(fn: charMapx100, to: s, times: 10)
}
let charMapx10_000 = createCharacterMap { (s) -> String in
    return apply(fn: charMapx100, to: s, times: 10)
}
let charMapx100_000 = createCharacterMap { (s) -> String in
    return apply(fn: charMapx10_000, to: s, times: 10)
}
let charMapx1_000_000 = createCharacterMap { (s) -> String in
    return apply(fn: charMapx100_000, to: s, times: 10)
}
let charMapx10_000_000 = createCharacterMap { (s) -> String in
    return apply(fn: charMapx1_000_000, to: s, times: 10)
}
let charMapx100_000_000 = createCharacterMap { (s) -> String in
    return apply(fn: charMapx10_000_000, to: s, times: 10)
}
let charMapx1Billion = createCharacterMap { (s) -> String in
    return apply(fn: charMapx100_000_000, to: s, times: 10)
}

let positionMapx10 = createPositionMap { (s) -> String in
    return apply(fn: positionMapOnce, to: s, times: 10)
}
let positionMapx100 = createPositionMap { (s) -> String in
    return apply(fn: positionMapx10, to: s, times: 10)
}
let positionMapx1000 = createPositionMap { (s) -> String in
    return apply(fn: positionMapx100, to: s, times: 10)
}
let positionMapx10_000 = createPositionMap { (s) -> String in
    return apply(fn: positionMapx1000, to: s, times: 10)
}
let positionMapx100_000 = createPositionMap { (s) -> String in
    return apply(fn: positionMapx10_000, to: s, times: 10)
}
let positionMapx1_000_000 = createPositionMap { (s) -> String in
    return apply(fn: positionMapx100_000, to: s, times: 10)
}
let positionMapx10_000_000 = createPositionMap { (s) -> String in
    return apply(fn: positionMapx1_000_000, to: s, times: 10)
}
let positionMapx100_000_000 = createPositionMap { (s) -> String in
    return apply(fn: positionMapx10_000_000, to: s, times: 10)
}
let positionMapx1Billion = createPositionMap { (s) -> String in
    return apply(fn: positionMapx100_000_000, to: s, times: 10)
}

print(charMapx1Billion(positionMapx1Billion(starting)))

