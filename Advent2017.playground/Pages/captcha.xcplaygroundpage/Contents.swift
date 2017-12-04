//: [Previous](@previous)

import Foundation

let zero: Unicode.Scalar = "0"
let nine: Unicode.Scalar = "9"

extension String {
    var digitArray: [Int] {
        return unicodeScalars
            .filter { (zero.value...nine.value).contains($0.value) }
            .map { (scalar) -> Int in
                return Int(scalar.value - zero.value)
            }
    }
}

func captcha(input: [Int]) -> Int {
    var pairs: [(Int, Int)] = []
    for i in 0..<input.count {
        (pairs.append((input[i], input[ (i + 1) % input.count])))
    }
    let result = pairs.reduce(0) { (previous, pair) -> Int in
        if pair.0 == pair.1 {
            return previous + pair.0
        } else {
            return previous
        }
    }
    return result
}

func captcha2(input: [Int]) -> Int {
    var pairs: [(Int, Int)] = []
    let count = input.count
    let halfway = count / 2
    for i in 0..<input.count {
        (pairs.append((input[i], input[ (i + halfway) % input.count])))
    }
    let result = pairs.reduce(0) { (previous, pair) -> Int in
        if pair.0 == pair.1 {
            return previous + pair.0
        } else {
            return previous
        }
    }
    return result
}

captcha(input: [1, 1, 2, 2]) // 3
captcha(input: [1, 1, 1, 1]) // 4
captcha(input: [1, 2, 3, 4]) // 0
captcha(input: [9, 1, 2, 1, 2, 1, 2, 9]) // 9

captcha2(input: [1, 2, 1, 2]) // 3
captcha2(input: [1, 2, 2, 1]) // 4
captcha2(input: "123425".digitArray) // 4
captcha2(input: "123123".digitArray) // 12
captcha2(input: "12131415".digitArray) // 4

//: [Next](@next)
