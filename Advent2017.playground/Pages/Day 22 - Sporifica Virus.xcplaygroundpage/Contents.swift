//: [Previous](@previous)

import Foundation
import AdventLib


let testInput = """
..#
#..
...
"""

var testGrid = Grid(input: testInput)
print(testGrid)
for i in 0..<100 {
    testGrid.burst()
    print(i)
    print(testGrid)
}
print(testGrid.causedInfection)

let url = Bundle.main.url(forResource: "day22.input", withExtension: "txt")!
let day22input = try! String(contentsOf: url)
var day22grid = Grid(input: day22input)
print(day22grid)
day22grid.burstALot(times: 10_000_000)
print(day22grid.causedInfection)

//: [Next](@next)
