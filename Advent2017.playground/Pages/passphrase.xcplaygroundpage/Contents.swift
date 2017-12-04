//: [Previous](@previous)

import Foundation

var str = "Hello, playground"

func valid(passphrase: String) -> Bool {
    let words = passphrase.split(separator: " ")
    let set = Set(words)
    return set.count == words.count
}

valid(passphrase: "aa bb cc dd ee")
valid(passphrase: "aa bb cc dd aa")
valid(passphrase: "aa bb cc dd aaa")


func valid2(_ passphrase: String) -> Bool {
    let words = passphrase.split(separator: " ")
    let sortedWords = words.map { String($0.sorted()) }
    let set = Set(sortedWords)
    return set.count == words.count
}

valid2("abcde fghij")
valid2("abcde xyz ecdab") //is not valid - the letters from the third word can be rearranged to form the first word.
valid2("a ab abc abd abf abj")// is a valid passphrase, because all letters need to be used when forming another word.
valid2("iiii oiii ooii oooi oooo") //is valid.
valid2("oiii ioii iioi iiio")// is not valid - any of these words can be rearranged to form any other wor

let testInput = """
aa bb cc dd ee
aa bb cc dd aa
aa bb cc dd aaa
"""

func countValid(file: String, validator: (String) -> Bool) -> Int {
    let lines = file.split(separator: "\n")
    return lines.map(String.init).filter(validator).count
}

countValid(file: testInput, validator: valid(passphrase:))
countValid(file: testInput, validator: valid2(_:))

//: [Next](@next)
