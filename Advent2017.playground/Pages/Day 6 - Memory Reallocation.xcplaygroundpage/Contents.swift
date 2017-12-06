//: [Previous](@previous)

import Foundation

func reallocate(memory: [Int]) -> Int {
    var memory = memory
    var seen: [String: Int] = ["\(memory)": 0]

    var count = 0
    while true {
        count += 1
        print(memory)
        var biggest = memory.max()!
        var index = memory.index(of: biggest)!
        memory[index] = 0

        index = (index + 1) % memory.count
        while biggest > 0 {
            memory[index] += 1
            index = (index + 1) % memory.count
            biggest -= 1
        }
        let result = "\(memory)"
        if let previous = seen[result] {
            return count - previous
        } else {
            seen[result] = count
        }
    }
}

print(reallocate(memory: [0, 2, 7, 0]))

print(reallocate(memory: [10,    3,    15,    10,    5,    15,    5,    15,    9,    2,    5,    8,    5,    2,    3,    6]))

//: [Next](@next)
