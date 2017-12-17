//: [Previous](@previous)

import Foundation

func dancing(steps: String, length: Int) -> String {
    let start: UnicodeScalar = "a"
    var chars: [Character] = []
    for i in 0..<length {
        let c = Character(UnicodeScalar(start.value + UInt32(i))!)
        chars.append(c)
    }
    print(chars)
    let splitSteps = steps.split(whereSeparator: { [",","\n"].contains($0) })
    for _ in 0..<10 {
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
    }

    return String(chars)
}

let testInput = "s1,x3/4,pe/b"

//dancing(steps: testInput, length: 5)
//dancing(steps: testInput, length: 16)

let input = try! String(contentsOf: #fileLiteral(resourceName: "day16.input.txt"))

print(dancing(steps: input, length: 16))
//
//func danceJustSpinExchange(steps: String) -> String {
//    let start: UnicodeScalar = "a"
//    var chars: [Character] = []
//    for i in 0..<16 {
//        let c = Character(UnicodeScalar(start.value + UInt32(i))!)
//        chars.append(c)
//    }
//    print(chars)
//    let splitSteps = steps.split(whereSeparator: { [",","\n"].contains($0) })
//    for _ in 0..<5 {
//    for step in splitSteps {
//        guard let command = step.first else { continue }
//        switch command {
//        case "s":
//            var remainder = step
//            remainder.removeFirst()
//            guard let size = Int(remainder) else { print("command \(step) size unknown"); break }
//            let removed = chars.suffix(size)
//            chars.removeLast(size)
//            chars.insert(contentsOf: removed, at: 0)
//        case "x":
//            var remainder = step
//            remainder.removeFirst()
//            let positions = remainder.split(separator: "/")
//            guard positions.count == 2 else { print("command \(step) not enough indices"); break }
//            guard let from = Int(positions[0]), let to = Int(positions[1]) else { print("command \(step) indices unknown"); break }
//            chars.swapAt(from, to)
//        default:
//            break
//        }
//        }
//        print(chars)
//    }
//    return String(chars)
//}
//
//func danceJustPartner(steps: String) -> String {
//    let start: UnicodeScalar = "a"
//    var chars: [Character] = []
//    for i in 0..<16 {
//        let c = Character(UnicodeScalar(start.value + UInt32(i))!)
//        chars.append(c)
//    }
//    print(chars)
//    for _ in 0..<5 {
//        for step in steps.split(whereSeparator: { [",","\n"].contains($0) }) {
//            guard let command = step.first else { continue }
//            switch command {
//            case "p":
//                var remainder = step
//                remainder.removeFirst()
//                let positions = remainder.split(separator: "/")
//                guard positions.count == 2 else { print("command \(step) not enough chars"); break}
//                guard let fromChar = positions[0].first, let toChar = positions[1].first else { print("command \(step) not enough chars"); break }
//                guard let from = chars.index(of: fromChar), let to = chars.index(of: toChar) else { print("command \(step) chars not found");  break }
//                chars.swapAt(from, to)
//
//            default:
//                break
//            }
//        }
//        print(chars)
//    }
//    return String(chars)
//}
//
//print("danceJustPartner:")
//print(danceJustPartner(steps: input)) // jdacklenhobmfpgi
//print("danceJustSpinExchange:")
//print(danceJustSpinExchange(steps: input))
//
//
//func spinExchange(in: [Character]) -> [Character] {
//    let map: [Int: Int] = [
//        0: 2
//    ]
//    return []
//}
//: [Next](@next)
