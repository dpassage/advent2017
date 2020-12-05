//
//  Day21FractalArt.swift
//  
//
//  Created by David Paschich on 12/3/20.
//

import Foundation
import AdventLib


struct Rule {
    var pattern: Rect<Bool>
    var result: Rect<Bool>

    init(_ input: String) {
        let strings = (input as NSString).components(separatedBy: " => ")
        pattern = Rect(pattern: strings[0], separator: "/")
        result = Rect(pattern: strings[1], separator: "/")
    }
}

struct RuleSet {
    var table: [Rect<Bool>: Rect<Bool>] = [:]

    mutating func insertRules(_ rules: String) {
        for line in rules.split(separator: "\n") {
            insert(Rule(String(line)))
        }
    }
    
    mutating func insert(_ rule: Rule) {
        table[rule.pattern] = rule.result
        table[rule.pattern.flippedHorizontally()] = rule.result
        table[rule.pattern.flippedVertically()] = rule.result

        var rotated = rule.pattern
        for _ in 0..<3 {
            rotated = rotated.rotated()
            table[rotated] = rule.result
        }
    }

    func apply(input: Rect<Bool>) -> Rect<Bool> {
        precondition(input.width == input.height)
        if input.width % 2 == 0 { return apply2(input: input) }
        if input.width % 3 == 0 { return apply3(input: input) }
        fatalError("input width \(input.width) not divisible by 2 or 3")
    }

    func apply2(input: Rect<Bool>) -> Rect<Bool> {
        let chunked = input.chunkedBy(2)

        let resultSize = chunked.width * 3
        var result = Rect<Bool>(width: resultSize, height: resultSize, defaultValue: false)

        for row in 0..<chunked.height {
            for column in 0..<chunked.width {
                guard let replacement = table[chunked[column, row]] else {
                    fatalError("pattern \(chunked[column, row]) not found")
                }
                for x in 0..<3 {
                    for y in 0..<3 {
                        result[(column * 3) + x, (row * 3) + y] = replacement[x, y]
                    }
                }
            }
        }

        return result
    }

    func apply3(input: Rect<Bool>) -> Rect<Bool> {
        let chunked = input.chunkedBy(3)

        let resultSize = chunked.width * 4
        var result = Rect<Bool>(width: resultSize, height: resultSize, defaultValue: false)

        for row in 0..<chunked.height {
            for column in 0..<chunked.width {
                guard let replacement = table[chunked[column, row]] else {
                    fatalError("pattern \(chunked[column, row]) not found")
                }
                for x in 0..<4 {
                    for y in 0..<4 {
                        result[(column * 4) + x, (row * 4) + y] = replacement[x, y]
                    }
                }
            }
        }

        return result
    }
}
