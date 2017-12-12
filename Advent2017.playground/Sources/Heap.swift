import Foundation

// Stolen from https://www.raywenderlich.com/160631/swift-algorithm-club-heap-and-priority-queue-data-structure

public struct Heap<Element> {
    var elements: [Element] = []

    let priorityFunction: (Element, Element) -> Bool

    /// Create a new heap
    ///
    /// - Parameter priorityFunction: returns true if the first argument sorts before the second
    public init(priorityFunction: @escaping (Element, Element) -> Bool) {
        self.priorityFunction = priorityFunction
    }

    public var isEmpty: Bool {
        return elements.isEmpty
    }

    public var count: Int {
        return elements.count
    }

    /// Returns the element which sorts first out of all elements
    public func peek() -> Element? {
        return elements.first
    }

    /// Inserts an element
    public mutating func enqueue(_ element: Element) {
        elements.append(element)
        siftUp(elementAtIndex: count - 1)
    }

    /// Removes and returns the element which sorts first out of all elements
    public mutating func dequeue() -> Element? {
        guard !isEmpty // 1
            else { return nil }
        swapElement(at: 0, with: count - 1) // 2
        let element = elements.removeLast() // 3
        if !isEmpty { // 4
            siftDown(elementAtIndex: 0) // 5
        }
        return element // 6
    }

    // helpers
    private func isRoot(_ index: Int) -> Bool {
        return (index == 0)
    }

    private func leftChildIndex(of index: Int) -> Int {
        return (2 * index) + 1
    }

    private func rightChildIndex(of index: Int) -> Int {
        return (2 * index) + 2
    }

    private func parentIndex(of index: Int) -> Int {
        return (index - 1) / 2
    }

    private func isHigherPriority(at firstIndex: Int, than secondIndex: Int) -> Bool {
        return priorityFunction(elements[firstIndex], elements[secondIndex])
    }

    private func highestPriorityIndex(of parentIndex: Int, and childIndex: Int) -> Int {
        guard childIndex < count && isHigherPriority(at: childIndex, than: parentIndex)
            else { return parentIndex }
        return childIndex
    }

    private func highestPriorityChildIndex(for parent: Int) -> Int {
        return highestPriorityIndex(
            of: highestPriorityIndex(
                of: parent,
                and: leftChildIndex(of: parent)
            ),
            and: rightChildIndex(of: parent)
        )
    }

    private mutating func swapElement(at firstIndex: Int, with secondIndex: Int) {
        guard firstIndex != secondIndex
            else { return }
        elements.swapAt(firstIndex, secondIndex)
    }

    private mutating func siftUp(elementAtIndex index: Int) {
        let parent = parentIndex(of: index) // 1
        guard !isRoot(index), // 2
            isHigherPriority(at: index, than: parent) // 3
            else { return }
        swapElement(at: index, with: parent) // 4
        siftUp(elementAtIndex: parent) // 5
    }

    private mutating func siftDown(elementAtIndex index: Int) {
        let childIndex = highestPriorityChildIndex(for: index) // 1
        if index == childIndex { // 2
            return
        }
        swapElement(at: index, with: childIndex) // 3
        siftDown(elementAtIndex: childIndex)
    }
}
