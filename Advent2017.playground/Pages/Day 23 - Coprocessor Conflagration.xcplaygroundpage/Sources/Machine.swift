import Foundation



public enum Instr {
    case set(String, String)
    case sub(String, String)
    case mul(String, String)
    case jnz(String, String)

    public init?(i: String) {
        let parts = i.split(separator: " ").map { String($0) }
        guard parts.count >= 3 else { return nil }
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
    public var description: String {
        switch self {
        case let .set(x, y): return "set \(x) \(y)"
        case let .sub(x, y): return "sub \(x) \(y)"
        case let .mul(x, y): return "mul \(x) \(y)"
        case let .jnz(x, y): return "jnz \(x) \(y)"
        }
    }
}

public class Machine {
    enum Errors: Error {
        case illegalInstruction
    }

    public var registers: [String: Int] = [:]
    var ip = 0
    public var mulCount: Int = 0

    var instrs: [Instr] = []

    var name: String
    public var debug = false
    public init(name: String) {
        self.name = name
    }

    public func load(program: [Instr]) {
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

    public func run() -> Int {
        var executed = 0
        while instrs.indices.contains(ip) {
            let instr = instrs[ip]
            if (executed % 20_000_000 == 0) || debug {
                print(executed, registers, ip, instr)
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
