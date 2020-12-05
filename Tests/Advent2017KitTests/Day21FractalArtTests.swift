//
//  Day21FractalArtTests.swift
//  
//
//  Created by David Paschich on 12/3/20.
//

import XCTest
@testable import Advent2017Kit
import AdventLib

class Day21FractalArtTests: XCTestCase {
    func testRuleParsing() {
        let input = "../.# => ##./#../..."
        let rule = Rule(input)
        XCTAssertEqual(rule.pattern, Rect(pattern: "../.#", separator: "/"))
        XCTAssertEqual(rule.result, Rect(pattern: "##./#../...", separator: "/"))
    }

    let sample =
    """
    ../.# => ##./#../...
    .#./..#/### => #..#/..../..../#..#
    """

    func testSample() {
        var ruleSet = RuleSet()

        ruleSet.insertRules(sample)

        let pattern = Rect(pattern: ".#./..#/###", separator: "/")
        let result = ruleSet.apply(input: pattern)
        XCTAssertEqual(result, Rect(pattern: "#..#/..../..../#..#", separator: "/"))
        let nextResult = ruleSet.apply(input: result)
        XCTAssertEqual(nextResult, Rect(pattern: "##.##./#..#../....../##.##./#..#../......", separator: "/"))
    }
}
