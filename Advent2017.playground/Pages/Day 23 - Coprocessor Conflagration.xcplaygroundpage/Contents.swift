//: [Previous](@previous)

import Foundation

enum Instr {
    case set(String, String)
    case sub(String, String)
    case mul(String, String)
    case jnz(String, String)

    init?(i: String) {
        let parts = i.split(separator: " ").map { String($0) }
        guard parts.count == 3 else { return nil }
        switch parts[0] {
        case "set":
            self = .set(parts[1], parts[2])
        case "sub":
            self = .sub(parts[1], parts[2])
        case "mul":
            self = .mul(parts[1], parts[2])
        case "jnz":
            self = .jnz(parts[1], parts[2])
        default:
            return nil
        }
    }
}

extension Instr: CustomStringConvertible {
    var description: String {
        switch self {
        case let .set(x, y): return "set \(x) \(y)"
        case let .sub(x, y): return "sub \(x) \(y)"
        case let .mul(x, y): return "mul \(x) \(y)"
        case let .jnz(x, y): return "jnz \(x) \(y)"
        }
    }
}

class Machine {
    enum Errors: Error {
        case illegalInstruction
    }

    var registers: [String: Int] = [:]
    var ip = 0
    var mulCount: Int = 0

    var instrs: [Instr] = []

    var name: String
    init(name: String) {
        self.name = name
    }

    func load(program: [Instr]) {
        instrs = program
        ip = 0
        mulCount = 0
    }

    private func val(_ s: String) -> Int {
        return Int(s) ?? registers[s] ?? 0
    }
    /*
     set X Y sets register X to the value of Y.
     sub X Y decreases register X by the value of Y.
     mul X Y sets register X to the result of multiplying the value contained in register X by the value of Y.
     jnz X Y jumps with an offset of the value of Y, but only if the value of X is not zero. (An offset of 2 skips the next instruction, an offset of -1 jumps to the previous instruction, and so on.)
     */

    func run() -> Int {
        var executed = 0
        while instrs.indices.contains(ip) {
            let instr = instrs[ip]
            if executed % 2000 == 0 {
                print(name, registers, ip, instr)
            }
            switch instr {
            case let .set(x, y):
                registers[x] = val(y)
                ip += 1
            case let .sub(x, y):
                registers[x] = val(x) - val(y)
                ip += 1
            case let .mul(x, y):
                registers[x] = val(x) * val(y)
                ip += 1
                mulCount += 1
            case let .jnz(x, y):
                if val(x) != 0 {
                    ip += val(y)
                } else {
                    ip += 1
                }
            }
            executed += 1
        }
        return executed
    }
}

let input = """
set b 99
set c b
jnz a 2
jnz 1 5
mul b 100
sub b -100000
set c b
sub c -17000
set f 1
set d 2
set e 2
set g d
mul g e
sub g b
jnz g 2
set f 0
sub e -1
set g e
sub g b
jnz g -8
sub d -1
set g d
sub g b
jnz g -13
jnz f 2
sub h -1
set g b
sub g c
jnz g 2
jnz 1 3
sub b -17
jnz 1 -23
"""

let instructions = input.components(separatedBy: "\n").compactMap(Instr.init)

let machine = Machine(name: "foo")
machine.load(program: instructions)
machine.run()
print(machine.mulCount)

//: [Next](@next)
