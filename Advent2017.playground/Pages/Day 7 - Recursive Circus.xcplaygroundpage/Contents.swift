//: [Previous](@previous)

import Foundation

let lineRegex = try Regex(pattern: "([a-z]+) \\((\\d+)\\)( -> )?([a-z, ]+)?")

lineRegex.match(input: "pbga (66)")
lineRegex.match(input: "fwft (72) -> ktlj, cntj, xhth")

func findRoot(input: String) -> String {
    var leftItems = Set<String>()
    var rightItems = Set<String>()

    let lines = input.split(separator: "\n")
    for line in lines {
        let line = String(line)
        guard let matches = lineRegex.match(input: line) else { continue }
        leftItems.insert(matches[0])
        if matches.count == 4 {
            let newRightItems = matches[3].components(separatedBy: ", ")
            rightItems.formUnion(newRightItems)
        }
    }

    print(leftItems)
    print(rightItems)

    let diff = leftItems.subtracting(rightItems)

    print(diff)
    /*
 For each line:
 If it matches the singleton regex, add the name to the left items
 if it matches the complex line, add the base name to the left items, and the others to the
 right items.

     After all that: Confirm that rightItems is a subset of leftItems, then subtract leftItems from rightItems. The
     result should have one item, our answer.
 */

    return diff.first!
}

let testInput = """
pbga (66)
xhth (57)
ebii (61)
havc (66)
ktlj (57)
fwft (72) -> ktlj, cntj, xhth
qoyq (66)
padx (45) -> pbga, havc, qoyq
tknk (41) -> ugml, padx, fwft
jptl (61)
ugml (68) -> gyxo, ebii, jptl
gyxo (61)
cntj (57)
"""

findRoot(input: testInput)

let input = try! String(contentsOf: #fileLiteral(resourceName: "day7.input.txt"))
//findRoot(input: input)

class Node: CustomStringConvertible {
    var weight: Int
    var children: [String]
    var totalWeight: Int = -1

    init(weight: Int, children: [String]) {
        self.weight = weight
        self.children = children
    }

    var description: String {
        return "\(weight) \(children)"
    }
}

func buildTree(input: String) -> [String: Node] {
    var result = [String: Node]()

    let lines = input.split(separator: "\n")
    for line in lines {
        let line = String(line)
        guard let matches = lineRegex.match(input: line) else { continue }

        let name = matches[0]
        let weight = Int(matches[1])!
        let children: [String]
        if matches.count == 4 {
            children = matches[3].components(separatedBy: ", ")
        } else {
            children = []
        }
        result[name] = Node(weight: weight, children: children)
    }
    return result
}

let testTree = buildTree(input: testInput)

func root(tree: [String: Node]) -> String {
    var parents: Set<String> = []
    var children: Set<String> = []

    for (name, node) in tree {
        parents.insert(name)
        children.formUnion(node.children)
    }

    return parents.subtracting(children).first!

}

let rootName = root(tree: testTree)

func totalWeight(nodeName: String, tree: [String: Node]) -> Int {
    guard let node = tree[nodeName] else { return -1 }
    if node.totalWeight != -1 { return node.totalWeight }

    let childWeights: Int = node.children.map { totalWeight(nodeName: $0, tree: tree) }.reduce(0, +)

    let total = childWeights + node.weight
    node.totalWeight = total
    return total
}

totalWeight(nodeName: rootName, tree: testTree)

extension Array where Element: Equatable {
    func allTheSame() -> Bool {
        guard count > 1 else { return true }
        for i in 1..<count {
            if self[0] != self[i] { return false }
        }
        return true
    }
}

// returns the index of
func uniqueIfAny(_ nums: [Int]) -> Int? {
    guard !nums.isEmpty else { return nil }
    if nums.count == 1 { return 0 }
    if nums.count == 2 { return nil } // weird case, both are "unique"

    let uniqued = Set(nums)
    if uniqued.count == 1 { return nil }
    for unique in uniqued {
        if (nums.filter { $0 == unique }.count == 1) {
            return nums.index(of: unique)
        }
    }
    return nil
}

uniqueIfAny([0, 0, 0, 0])

func findUnbalanced(nodeName: String, tree: [String: Node]) -> String? {
    guard let node = tree[nodeName] else { return nil }

    if node.children.isEmpty { return nil }

    for child in node.children {
        if let answer = findUnbalanced(nodeName: child, tree: tree) {
            print(nodeName)
            return answer
        }
    }

    // none of my subnodes is unbalanced. figure if if there's a node with a different total
    // weight than the others.
    let totalWeights = node.children.map { totalWeight(nodeName: $0, tree: tree) }
    if let unbalancedIndex = uniqueIfAny(totalWeights) {
        return node.children[unbalancedIndex]
    }

    return nil
}


findUnbalanced(nodeName: rootName, tree: testTree)

let realTree = buildTree(input: input)
let realRoot = "xegshds"

findUnbalanced(nodeName: realRoot, tree: realTree)

func findUnbalancedWithWeight(nodeName: String, tree: [String: Node]) -> (String, Int)? {
    guard let node = tree[nodeName] else { return nil }

    if node.children.isEmpty { return nil }

    for child in node.children {
        if let answer = findUnbalancedWithWeight(nodeName: child, tree: tree) {
            print(nodeName)
            return answer
        }
    }

    // none of my subnodes is unbalanced. figure if if there's a node with a different total
    // weight than the others.
    let totalWeights = node.children.map { totalWeight(nodeName: $0, tree: tree) }
    if let unbalancedIndex = uniqueIfAny(totalWeights) {
        let target = totalWeights.first { $0 != totalWeights[unbalancedIndex] }!
        let unbalancedName = node.children[unbalancedIndex]
        let unbalancedWeight = totalWeights[unbalancedIndex]

        let diff = unbalancedWeight - target
        let nodeWeight = tree[unbalancedName]!.weight - diff
        return (node.children[unbalancedIndex], nodeWeight)
    }

    return nil
}

findUnbalancedWithWeight(nodeName: realRoot, tree: realTree)

// anygv (3678) -> tghfe, ybzqi, fabacam

// tghfe: 89
// yzvqi: 3
//: [Next](@next)
