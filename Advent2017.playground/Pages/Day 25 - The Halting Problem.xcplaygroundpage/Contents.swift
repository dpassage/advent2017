//: [Previous](@previous)

import Foundation

var machine = Turing()
machine.step()
print(machine.checksum())
machine.run(steps: 12481997)
print(machine.checksum())


//: [Next](@next)
