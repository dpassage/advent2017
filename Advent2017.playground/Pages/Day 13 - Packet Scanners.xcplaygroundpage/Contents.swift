//: [Previous](@previous)

import Foundation

let testInput = """
0: 3
1: 2
4: 4
6: 4
"""

func parse(input: String) -> [(Int, Int)] {
    var result = [(Int, Int)]()

    for line in input.components(separatedBy: "\n") {
        let parts = line.components(separatedBy: ": ")
        guard let layer = Int(parts[0]), let range = Int(parts[1]) else { continue }
        result.append((layer, range))
    }

    return result
}

func isCaught(layer: Int, range: Int, delay: Int) -> Bool {
    let period = (range - 1) * 2
    return (layer + delay) % period == 0
}

func computeSeverity(config: [(Int, Int)], delay: Int) -> Int {
    var severity = 0
    for (layer, range) in config {
        if isCaught(layer: layer, range: range, delay: delay) {
            severity += layer * range
        }
    }

    return severity
}

func severity(input: String, startingAt: Int = 0) -> Int {
    let config = parse(input: input)
    return computeSeverity(config: config, delay: startingAt)
}

print(severity(input: testInput))
print(severity(input: testInput, startingAt: 10))

func findSafeDelay(input: String) -> Int {
    let config = parse(input: input)
    var delay = 0
    while true {
        let caught = config.map({ (line) -> Bool in
            return isCaught(layer: line.0, range: line.1, delay: delay)
        }).reduce(false, { (soFar, next) -> Bool in
            return soFar || next
        })
        if !caught { return delay } else { delay += 1 }
    }
}

print(findSafeDelay(input: testInput))

let input = """
0: 3
1: 2
2: 4
4: 8
6: 5
8: 6
10: 6
12: 4
14: 6
16: 6
18: 9
20: 8
22: 8
24: 8
26: 8
28: 10
30: 8
32: 12
34: 10
36: 14
38: 12
40: 12
42: 12
44: 12
46: 12
48: 12
50: 14
52: 12
54: 14
56: 12
58: 12
60: 14
62: 18
64: 14
68: 14
70: 14
72: 14
74: 14
78: 14
80: 20
82: 14
84: 14
90: 17
"""

print(severity(input: input))
print(findSafeDelay(input: input))



//: [Next](@next)
