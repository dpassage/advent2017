//: [Previous](@previous)

import Foundation

struct Generator {
    var last: Int
    var factor: Int

    init(seed: Int, factor: Int) {
        self.last = seed
        self.factor = factor
    }

    mutating func next() -> Int {
        let n = (last * factor) % 2147483647
        self.last = n
        return n
    }

    mutating func next(div: Int) -> Int {
        while true {
            let n = next()
            if (n % div) == 0 { return n }
        }
    }
}

func generatorFight(iterations: Int) -> Int {
    var matches = 0

    var genA = Generator(seed: 116, factor: 16807)
    var genB = Generator(seed: 299, factor: 48271)

    for i in 0..<iterations {
        if (i % 10_000) == 0 { print(i) }
        let a = genA.next(div: 4)
        let b = genB.next(div: 8)
        if (a & 0xffff) == (b & 0xffff) {
            matches += 1
        }
    }

    return matches
}

print(generatorFight(iterations: 5_000_000))



//: [Next](@next)
