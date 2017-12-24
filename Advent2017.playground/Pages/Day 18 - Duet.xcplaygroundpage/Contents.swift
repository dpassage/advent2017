//: [Previous](@previous)

import Foundation


enum Instr {
    case snd(String)
    case set(String, String)
    case add(String, String)
    case mul(String, String)
    case mod(String, String)
    case rcv(String)
    case jgz(String, String)

    init?<S: StringProtocol>(i: S) {
        let parts = i.split(separator: " ").map(String.init)
        switch parts[0] {
        case "snd":
            self = .snd(parts[1])
        case "set":
            self = .set(parts[1], parts[2])
        case "add":
            self = .add(parts[1], parts[2])
        case "mul":
            self = .mul(parts[1], parts[2])
        case "mod":
            self = .mod(parts[1], parts[2])
        case "rcv":
            self = .rcv(parts[1])
        case "jgz":
            self = .jgz(parts[1], parts[2])
        default:
            return nil
        }
    }
}

extension Instr: CustomStringConvertible {
    var description: String {
        switch self {
        case let .snd(x): return "snd \(x)"
        case let .rcv(x): return "rcv \(x)"
        case let .set(x, y): return "set \(x) \(y)"
        case let .add(x, y): return "add \(x) \(y)"
        case let .mul(x, y): return "mul \(x) \(y)"
        case let .mod(x, y): return "mod \(x) \(y)"
        case let .jgz(x, y): return "jgz \(x) \(y)"
        }
    }
}

class Machine {
    enum Errors: Error {
        case illegalInstruction
    }

    var registers: [String: Int] = [:]
    var ip = 0
    var receiveQueue: [Int] = []
    var sendCount: Int = 0

    var instrs: [Instr] = []

    var send: (Int) -> Void = { x in }

    var name: String
    init(name: String) {
        self.name = name
    }

    func load(program: [Instr], p: Int) {
        instrs = program
        registers = ["p": p]
        ip = 0
        receiveQueue = []
        sendCount = 0
    }

    private func val(_ s: String) -> Int {
        return Int(s) ?? registers[s] ?? 0
    }
    /*
     snd X sends value on the channel
     set X Y sets register X to the value of Y.
     add X Y increases register X by the value of Y.
     mul X Y sets register X to the result of multiplying the value contained in register X by the value of Y.
     mod X Y sets register X to the remainder of dividing the value contained in register X by the value of Y (that is, it sets X to the result of X modulo Y).
     rcv X receives the next value on the channel into X
     jgz X Y jumps with an offset of the value of Y, but only if the value of X is greater than zero. (An offset of 2 skips the next instruction, an offset of -1 jumps to the previous instruction, and so on.)
     */

    func run() -> Int {
        var executed = 0
        instrLoop:
        while instrs.indices.contains(ip) {
            let instr = instrs[ip]
            print(name, receiveQueue.count, registers, ip, instr)
            switch instr {
            case let .snd(x):
                send(val(x))
                sendCount += 1
                ip += 1
            case let .rcv(x):
                guard !receiveQueue.isEmpty else { break instrLoop }
                registers[x] = receiveQueue.removeFirst()
                ip += 1
            case let .set(x, y):
                registers[x] = val(y)
                ip += 1
            case let .add(x, y):
                registers[x] = val(x) + val(y)
                ip += 1
            case let .mul(x, y):
                registers[x] = val(x) * val(y)
                ip += 1
            case let .mod(x, y):
                registers[x] = val(x) % val(y)
                ip += 1
            case let .jgz(x, y):
                if val(x) > 0 {
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

class Duet {
    let machine0: Machine
    let machine1: Machine
    init() {
        machine0 = Machine(name: "machine0")
        machine1 = Machine(name: "machine1")
        machine0.send = { x in self.machine1.receiveQueue.append(x) }
        machine1.send = { x in self.machine0.receiveQueue.append(x) }
    }

    func run() -> Int {
        while (machine0.run() + machine1.run() > 0) {
        }
        return machine1.sendCount
    }

    func load(p: String) {
        let instrs = p.split(separator: "\n").flatMap(Instr.init)
        machine0.load(program: instrs, p: 0)
        machine1.load(program: instrs, p: 1)
    }
}

let testInput = """
snd 1
snd 2
snd p
rcv a
rcv b
rcv c
rcv d
"""

let duet = Duet()
duet.load(p: testInput)
print(duet.run())
let input = """
set i 31
set a 1
mul p 17
jgz p p
mul a 2
add i -1
jgz i -2
add a -1
set i 127
set p 952
mul p 8505
mod p a
mul p 129749
add p 12345
mod p a
set b p
mod b 10000
snd b
add i -1
jgz i -9
jgz a 3
rcv b
jgz b -1
set f 0
set i 126
rcv a
rcv b
set p a
mul p -1
add p b
jgz p 4
snd a
set a b
jgz 1 3
snd b
set f 1
add i -1
jgz i -11
snd a
jgz f -16
jgz a -19
"""

let realDuet = Duet()
realDuet.load(p: input)
print(realDuet.run())

// 13716: too high

//: [Next](@next)
