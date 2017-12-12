//: [Previous](@previous)

import Foundation

func countGroupZero(input: String) -> Int {
    var pipes: [Int: [Int]] = [:]

    for line in input.split(separator: "\n") {
        let pair = String(line).components(separatedBy: " <-> ")
        guard pair.count == 2 else { continue }

        guard let leftSide = Int(pair[0]) else { continue }
        let rightSide = pair[1].components(separatedBy: ", ").flatMap { Int($0) }

        pipes[leftSide] = rightSide
    }

    var groupOne: Set<Int> = [0]
    var queue: [Int] = [0]
    while !queue.isEmpty {
        let next = queue.removeFirst()
        guard let dests = pipes[next] else { continue }
        for dest in dests {
            if !groupOne.contains(dest) {
                groupOne.insert(dest)
                queue.append(dest)
            }
        }
    }

    return groupOne.count
}

let test = """
0 <-> 2
1 <-> 1
2 <-> 0, 3, 4
3 <-> 2, 4
4 <-> 2, 3, 6
5 <-> 6
6 <-> 4, 5
"""

print(countGroupZero(input: test))

let input = try! String(contentsOf: #fileLiteral(resourceName: "day12.input.text"))
print(countGroupZero(input: input))


func countGroups(input: String) -> Int {
    var pipes: [Int: [Int]] = [:]

    for line in input.split(separator: "\n") {
        let pair = String(line).components(separatedBy: " <-> ")
        guard pair.count == 2 else { continue }

        guard let leftSide = Int(pair[0]) else { continue }
        let rightSide = pair[1].components(separatedBy: ", ").flatMap { Int($0) }

        pipes[leftSide] = rightSide
    }

    var groups = 0

    while let nextKey = pipes.keys.first {
        groups += 1
        var groupMembers: Set<Int> = [nextKey]
        var queue: [Int] = [nextKey]

        while !queue.isEmpty {
            let key = queue.removeFirst()
            let dests = pipes.removeValue(forKey: key) ?? []
            for dest in dests {
                if !groupMembers.contains(dest) {
                    groupMembers.insert(dest)
                    queue.append(dest)
                }
            }
        }

    }

    return groups
}

print(countGroups(input: test))
print(countGroups(input: input))

//: [Next](@next)
