import Foundation


public struct Turing {
    var tape: [Int: Int] = [:]
    var cursor: Int = 0
    var steps = 0

    enum State {
        case a
        case b
        case c
        case d
        case e
        case f
    }
    var state: State = .a

    public init() {}

    public mutating func step() {
        steps += 1
        let currentValue = tape[cursor, default: 0]
        switch state {
        case .a:
            if currentValue == 0 {
                tape[cursor] = 1
                cursor += 1
                state = .b
            } else {
                tape[cursor] = 0
                cursor -= 1
                state = .c
            }
        case .b:
            if currentValue == 0 {
                tape[cursor] = 1
                cursor -= 1
                state = .a
            } else {
                tape[cursor] = 1
                cursor += 1
                state = .d
            }
        case .c:
            if currentValue == 0 {
                tape[cursor] = 0
                cursor -= 1
                state = .b
            } else {
                tape[cursor] = 0
                cursor -= 1
                state = .e
            }
        case .d:
            if currentValue == 0 {
                tape[cursor] = 1
                cursor += 1
                state = .a
            } else {
                tape[cursor] = 0
                cursor += 1
                state = .b
            }
        case .e:
            if currentValue == 0 {
                tape[cursor] = 1
                cursor -= 1
                state = .f
            } else {
                tape[cursor] = 1
                cursor -= 1
                state = .c
            }
        case .f:
            if currentValue == 0 {
                tape[cursor] = 1
                cursor += 1
                state = .d
            } else {
                tape[cursor] = 1
                cursor += 1
                state = .a
            }
        }
    }

    public mutating func run(steps: Int) {
        while self.steps < steps {
            step()
        }
    }

    public func checksum() -> Int {
        return tape.values.reduce(0, +)
    }
}
