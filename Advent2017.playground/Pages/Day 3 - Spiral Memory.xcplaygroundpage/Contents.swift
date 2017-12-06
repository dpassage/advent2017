//: [Previous](@previous)

import Foundation
/*
 const steps = n => {
 const root = Math.ceil(Math.sqrt(n));
 const curR = root % 2 !== 0 ? root : root + 1;
 const numR = (curR - 1) / 2;
 const cycle = n - ((curR - 2) ** 2);
 const innerOffset = cycle % (curR - 1);

 return numR + Math.abs(innerOffset - numR);
 };
 */

func steps(_ n: Int) -> Int {
    let root = Int(ceil(sqrt(Double(n))))
    let curR = (root % 2) == 0 ? root + 1 : root
    let numR = (curR - 1) / 2
    let cycle = n - ((curR - 2) * (curR - 2))
    let innerOffset = cycle % (curR - 1)

    return numR + abs(innerOffset - numR)
}

steps(12)
steps(1024)
steps(289326)


// part 2 i cheated and used https://oeis.org/A141481

//: [Next](@next)
