//: [Previous](@previous)

import Foundation


let input = """
set b 5      # 0: set b to 100
set c b       # 1: set c to b
jnz a 2       # 2: if a != 0 jump to 4
jnz 1 5       # 3: jump to 8
mul b 100     # 4: b = b * 100
sub b -100000 # 5: b = b + 100_000
set c b       # 6: c = b
sub c -17000  # 7: c = c + 17_000

set f 1       # 8: f = 1
set d 2       # 9: d = 2
set e 2       #10: e = 2
set g d       #11: g = d
mul g e       #12: g = g * e
sub g b       #13: g = g - b
jnz g 2       #14: if g != 0 jump to 16
set f 0       #15: f = 0
sub e -1      #16: e = e + 1
set g e       #17: g = e
sub g b       #18: g = g - b
jnz g -8      #19: if g != 0 jump to 11
sub d -1      #20: d = d + 1
set g d       #21: g = d
sub g b       #22: g = g - b
jnz g -13     #23: if g != 0 jump to 10
jnz f 2       #24: if f != 0 jump to 26
sub h -1      #25: h = h + 1
set g b       #26: g = b
sub g c       #27: g = g - c
jnz g 2       #28: if g != 0 jump to 30
jnz 1 3       #29: jump to 32 (halt)
sub b -17     #30: b = b + 17
jnz 1 -23     #31: jump to 8
"""

let instructions = input.components(separatedBy: "\n").compactMap(Instr.init)

let machine = Machine(name: "foo")
machine.load(program: instructions)
machine.registers["a"] = 1
machine.debug = true
machine.run(limit: 100)
print(machine.registers)

// program analysis is:
// start with numbers from b to c stride 17 inclusive
// count how many are _not_ prime
// if a is 1, then my b = 100500 and c = 117500

extension Int {
    func isPrime() -> Bool {
        if self == 2 { return true }
        if self == 3 { return true }
        for f in 2..<(self / 2) {
            if self % f == 0 { return false }
        }
        return true
    }
}

print(5.isPrime())
print(6.isPrime())

let numbers = stride(from: 100500, through: 117500, by: 17)
let notPrime = numbers.filter { !$0.isPrime() }.count
print(notPrime)

//: [Next](@next)
