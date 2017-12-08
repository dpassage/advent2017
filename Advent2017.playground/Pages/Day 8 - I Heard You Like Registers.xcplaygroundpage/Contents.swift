//: [Previous](@previous)

import Foundation

let regex = try! Regex(pattern: "([a-z]+) (inc|dec) (-?[0-9]+) if ([a-z]+) ([!=<>]+) (-?[0-9]+)")

struct DefaultDictionary<K, V> where K: Hashable {
    var d: [K : V] = [:]
    var def: V

    init(default: V) {
        self.def = `default`
    }

    subscript(key: K) -> V {
        get {
            return d[key] ?? def
        }
        set {
            d[key] = newValue
        }
    }

    var values: Dictionary<K, V>.Values { return d.values }
}

func incOp(_ s: String) -> (Int, Int) -> Int {
    switch s {
    case "inc":
        return { $0 + $1 }
    case "dec":
        return { $0 - $1 }
    default:
        fatalError("unknown op \(s)")
    }
}

func compareOp(_ s: String) -> (Int, Int) -> Bool {
    switch s {
    case ">": return { $0 > $1 }
    case "<": return { $0 < $1 }
    case ">=": return { $0 >= $1 }
    case "==": return { $0 == $1 }
    case "!=": return { $0 != $1 }
    case "<=": return { $0 <= $1 }
    default:
        fatalError("unknown op \(s)")
    }
}

func run(input: String) -> (Int, Int) {
    var registers = DefaultDictionary<String, Int>(default: 0)
    let lines = input.components(separatedBy: "\n")
    var maxValue = Int.min

    for line in lines {
        print(line)
        guard let match = regex.match(input: line) else { continue }
        print(match)
        // (b) (inc) (5) if (a) (>) (1)
        let testReg = match[3]
        let testValue = Int(match[5])!
        let op = compareOp(match[4])
        if op(registers[testReg], testValue) {
            let target = match[0]
            let op = incOp(match[1])
            let val = Int(match[2])!
            let result = op(registers[target], val)
            registers[target] = result
            maxValue = max(result, maxValue)
        }
    }

    return (registers.values.max()!, maxValue)
}

let testInput = """
b inc 5 if a > 1
a inc 1 if b < 5
c dec -10 if a >= 1
c inc -20 if c == 10
"""

print(run(input: testInput))

let realInput = try! String(contentsOf: #fileLiteral(resourceName: "day8.input.txt"))

print(run(input: realInput))

//: [Next](@next)
