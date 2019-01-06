//: [Previous](@previous)

import Foundation


let input = """
set b 99      # 0: set b to 100
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
set g b       #25: g = b
sub g c       #26: g = g - c
jnz g 2       #27: if g != 0 jump to 29
jnz 1 3       #28: jump to 31 (halt)
sub b -17     #29: b = b + 17
jnz 1 -23     #30: jump to 7
"""

let instructions = input.components(separatedBy: "\n").compactMap(Instr.init)

let machine = Machine(name: "foo")
machine.load(program: instructions)
machine.registers["a"] = 0
machine.run()
print(machine.registers)

//: [Next](@next)
