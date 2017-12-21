//: [Previous](@previous)

import Foundation

class Node {
    var num: Int
    var next: Node?

    init(num: Int) { self.num = num }
}

func spinlock(steps: Int) -> Int {
    let head: Node = Node(num: 0)

    var cur = head

    for i in 1...2017 {

        for _ in 0..<steps {
            cur = cur.next ?? head
        }
        let new = Node(num: i)
        new.next = cur.next
        cur.next = new
        cur = new
    }

    let next = cur.next ?? head
    return next.num
}

//print(spinlock(steps: 3))
//print(spinlock(steps: 345))

func spinLock2(steps: Int, nodes: Int) -> Int {
    var nodeCount = 1
    var current = 0
    var afterFirst = -1

    for i in 1..<nodes {
        current = (current + steps) % nodeCount
        if current == 0 { afterFirst = i }
        nodeCount += 1
        current += 1
    }

    return afterFirst
}

print(spinLock2(steps: 3, nodes: 4))
print(spinLock2(steps: 345, nodes: 50_000_000))

//: [Next](@next)
