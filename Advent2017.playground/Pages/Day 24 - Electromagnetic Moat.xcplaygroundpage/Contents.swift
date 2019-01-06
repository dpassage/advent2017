//: [Previous](@previous)

import Foundation


let testInput = """
0/2
2/2
2/3
3/4
3/5
0/1
10/1
9/10
"""

let beams = testInput.components(separatedBy: "\n").compactMap(Beam.init)
let bridge = Bridge(beams: beams)
print(bridge.nextOnes().map { $0.nextOnes() })

let solver = Solver(beams: beams)
print(solver.solve())

let url = Bundle.main.url(forResource: "day24.input", withExtension: "txt")!
let day24input = try! String(contentsOf: url)
let day24beams = day24input.components(separatedBy: "\n").compactMap(Beam.init)
let day24solver = Solver(beams: day24beams)
//print(day24solver.solve())


let testLongSolver = LongSolver(beams: beams)
print(testLongSolver.solve())

let day24longsolver = LongSolver(beams: day24beams)
print(day24longsolver.solve())

//: [Next](@next)
