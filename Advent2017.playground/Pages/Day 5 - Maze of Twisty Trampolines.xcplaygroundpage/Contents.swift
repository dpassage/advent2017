//: [Previous](@previous)

import Foundation


struct Machine {
    var array: [Int]

    init(array: [Int]) {
        self.array = array
    }

    mutating func run() -> Int {
        var ip = 0
        var steps = 0

        while array.indices.contains(ip) {
            let newIP = ip + array[ip]
            array[ip] += 1
            steps += 1
            ip = newIP
        }

        return steps
    }

    mutating func run2() -> Int {
        var ip = 0
        var steps = 0

        while array.indices.contains(ip) {
            let newIP = ip + array[ip]
            if array[ip] >= 3 {
                array[ip] -= 1
            } else {
                array[ip] += 1
            }
            steps += 1
            ip = newIP
        }

        return steps
    }
}

var machine = Machine(array: [0, 3, 0,  1, -3])
machine.run2()

let day5 = try! String(contentsOfFile: "Resources/day5.input.txt", encoding: .ascii)
let day5lines = day5.components(separatedBy: "\n")

let array = day5lines.flatMap { Int($0) }
var newMachine = Machine(array: array)
//print(newMachine.run2())

//: [Next](@next)
