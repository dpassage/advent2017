//: [Previous](@previous)

import Foundation

var str = "Hello, playground"

let bitCount: [Int] = [
    0, // 0
    1, // 1
    1, // 2
    2, // 3
    1, // 4
    2, // 5
    2, // 6
    3, // 7
    1, // 8
    2, // 9
    2, // 10
    3, // 11
    2, // 12
    3, // 13
    3, // 14
    4, // 15
]

extension UInt8 {
    var bitsSet: Int {
        let high = bitCount[Int(self >> 4)]
        let low = bitCount[Int(self & 0xf)]
        return low + high
    }

    var bits: [Bool] {
        var result = [Bool]()
        for i in 0..<8 {
            let bit = (self >> i) & 1 == 1
            result.insert(bit, at: 0)
        }
        return result
    }
}

let byte: UInt8 = 37
print(byte.bits)

func countBits(input: String) -> Int {
    var bits: Int = 0

    for i in 0..<128 {
        let line = "\(input)-\(i)"
        let hash = knotHash(bytes: [UInt8](line.utf8))
        for byte in hash {
            bits += byte.bitsSet
        }
    }

    return bits
}

//print(countBits(input: "amgozmfv"))

func buildGrid(input: String) -> [[Bool]] {
    var grid: [[Bool]] = []

    for i in 0..<128 {
        let s = "\(input)-\(i)"
        let hash = knotHash(bytes: [UInt8](s.utf8))
        var gridLine: [Bool] = []
        for byte in hash {
            gridLine.append(contentsOf: byte.bits)
        }
        grid.append(gridLine)
    }

    return grid
}

//var testGrid = buildGrid(input: "flqrgnkx")

func removeRegion(grid: inout [[Bool]]) -> Bool {
    var x = -1; var y = -1

    let range = 0..<128
    outside:
    for i in range {
        for j in range {
            if grid[i][j] {
                x = i
                y = j
                break outside
            }
        }
    }

    guard x != -1 && y != -1 else { return false }

    var queue: [(Int, Int)] = [(x, y)]
    grid[x][y] = false
    let deltas = [(0, 1), (1, 0), (-1, 0), (0, -1)]
    while !queue.isEmpty {
        let (currentX, currentY) = queue.removeFirst()
        for delta in deltas {
            let newX = currentX + delta.0
            let newY = currentY + delta.1
            guard range.contains(newX) && range.contains(newY) else { continue }
            if grid[newX][newY] {
                grid[newX][newY] = false
                queue.append((newX, newY))
            }
        }
    }

    return true
}

//removeRegion(grid: &testGrid)
//print(testGrid)

func countRegions(input: String) -> Int {
    var count = 0
    var grid = buildGrid(input: input)

    while removeRegion(grid: &grid) {
        count += 1
    }

    return count
}

print(countRegions(input: "amgozmfv"))

//: [Next](@next)

