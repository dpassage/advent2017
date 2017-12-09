//: [Previous](@previous)

import Foundation

struct PeekingIterator<T> {
    private var peeked: T? = nil
    private var nextMethod: () -> T?

    init<I: IteratorProtocol>(iterator: I) where I.Element == T {
        var iterator = iterator
        self.nextMethod = { iterator.next() }
    }

    mutating func peek() -> T? {
        if let peeked = peeked {
            return peeked
        }
        let next = nextMethod()
        peeked = next
        return next
    }

    mutating func consume() -> T? {
        if let peeked = peeked {
            self.peeked = nil
            return peeked
        } else {
            return nextMethod()
        }
    }
}

extension Sequence {
    func makePeekingIterator() -> PeekingIterator<Element> {
        return PeekingIterator(iterator: makeIterator())
    }
}

struct ParseError: Error {}

// consumes one piece of garbage from the stream
// throws if stream does not start with proper garbage
func consumeGarbage(iter: inout PeekingIterator<Character>) throws -> Int {
    var removed = 0

    guard let first = iter.peek(), first == "<" else {
        throw ParseError()
    }
    iter.consume()
    var atEnd = false
    while let next = iter.peek(), !atEnd {
        switch next {
        case ">":
            iter.consume()
            atEnd = true
        case "!":
            iter.consume()
            iter.consume()
        default:
            removed += 1
            iter.consume()
        }
    }

    if !atEnd { throw ParseError() }

    return removed
}

// true if input is properly-formed garbage, else false
func parseGarbage(input: String) -> Int {
    var peekIterator = input.makePeekingIterator()

    do {
        let removed = try consumeGarbage(iter: &peekIterator)
        if let _ = peekIterator.peek() { return -1 }
        return removed
    } catch {
        return -1
    }
}

parseGarbage(input: "<>a")
parseGarbage(input: "g<!!!>>")

parseGarbage(input: "<>") // 0
parseGarbage(input: "<random characters>") // 17
parseGarbage(input: "<<<<>") // 3
parseGarbage(input: "<{!>}>") // 2
parseGarbage(input: "<!!>") // 0
parseGarbage(input: "<!!!>>") // 0
parseGarbage(input: "<{o\"i!a,<{i<a>") // 10

func parse(input: String) throws -> (Int, Int) {
    var score = 0
    var garbageRemoved = 0
    var groupLevel = 0

    var iter = input.makePeekingIterator()

    while let next = iter.peek() {
        switch next {
        case ",", "\n": iter.consume()
        case "{":
            iter.consume()
            groupLevel += 1
        case "}":
            iter.consume()
            score += groupLevel
            groupLevel -= 1
            guard groupLevel >= 0 else { throw ParseError() }
        case "<":
            garbageRemoved += try consumeGarbage(iter: &iter)
        default:
            throw ParseError()
        }
    }

    guard groupLevel == 0 else { throw ParseError() }
    return (score, garbageRemoved)
}

try? parse(input: "{")
try? parse(input: "{}}")
try? parse(input: "{{{}}}")
try? parse(input: "{{},{}}")
try? parse(input: "{{{},{},{{}}}}")
try? parse(input: "{<a>,<a>,<a>,<a>}")
try? parse(input: "{{<ab>},{<ab>},{<ab>},{<ab>}}")
try? parse(input: "{{<!!>},{<!!>},{<!!>},{<!!>}}")
try? parse(input: "{{<a!>},{<a!>},{<a!>},{<ab>}}")


let input = try! String(contentsOf: #fileLiteral(resourceName: "day9.input.txt"))
do {
    print(try parse(input: input))
} catch {
    print(error)
}


//: [Next](@next)
