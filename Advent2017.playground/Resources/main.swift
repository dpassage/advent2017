//: [Previous](@previous)

import Foundation

import Foundation

public class Regex {
    let regex: NSRegularExpression

    public init(pattern: String) throws {
        regex = try NSRegularExpression(pattern: pattern, options: [])
    }

    // returns nil if match failed, otherwise returns array of groups matched.
    // if no groups in pattern, returns empty array on match
    public func match(input: String) -> [String]? {
        let inputString = input as NSString
        guard let match = regex.matches(
            in: input, options: [],
            range: NSRange(location: 0, length: inputString.length)
            ).first else { return nil }

        var result = [String]()
        let results = match.numberOfRanges

        for i in 1..<results {
            result.append(inputString.substring(with: match.range(at: i)))
        }

        return result
    }
}

let ascii: [UInt8] = [
    48,
    49,
    50,
    51,
    52,
    53,
    54,
    55,
    56,
    57,
    97,
    98,
    99,
    100,
    101,
    102
]

extension Data {
    var md5String: String {
//        if self.count == 0 {
//            return "d41d8cd98f00b204e9800998ecf8427e"
//        }
//
//        var ctx = CC_MD5_CTX()
//        var digest = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
//
//        CC_MD5_Init(&ctx)
//        // https://bugs.swift.org/browse/SR-4028 means that we can't trust
//        // the second argument to the block taken by `enumerateBytes`.
//        enumerateBytes { (data, _, _) -> Void in
//            let dataPointer = UnsafeRawPointer(data.baseAddress!)
//            CC_MD5_Update(&ctx, dataPointer, CC_LONG(data.count))
//        }
//        CC_MD5_Final(&digest, &ctx)
//
//        var digestHex = ""
//        for index in 0..<Int(CC_MD5_DIGEST_LENGTH) {
//            digestHex += String(format: "%02x", digest[index])
//        }
//
//        return digestHex
        let result = md5data
        return String(data: result, encoding: .ascii)!
    }

    // Returns the digest as ASCII data
    var md5data: Data {
        var ctx = CC_MD5_CTX()
        var digestData = Data(count: Int(CC_MD5_DIGEST_LENGTH))

        CC_MD5_Init(&ctx)
        digestData.withUnsafeMutableBytes { (digestData: UnsafeMutablePointer<UInt8>) -> Void in
            self.enumerateBytes { (data, _, _) in
                let dataPointer = UnsafeRawPointer(data.baseAddress)
                CC_MD5_Update(&ctx, dataPointer, CC_LONG(data.count))
            }

            CC_MD5_Final(digestData, &ctx)
        }

        var result = Data(count: 2 * Int(CC_MD5_DIGEST_LENGTH))

        for (index, byte) in digestData.enumerated() {
            let word = Int(byte)
            let low = ascii[word & 0xf]
            let high = ascii[(word >> 4) & 0xf]
            result[2 * index] = high
            result[(2 * index) + 1] = low
        }

        return result
    }
    func hexDump(limit: Int = 100) -> String {
        let length = Swift.min(limit, self.count)

        let end = length < self.count ? "…" : ""

        var digest = ""

        self.withUnsafeBytes { (bytes: UnsafePointer<UInt8>) -> Void in
            for index in 0..<length {
                digest.append(String(format: "%02x", bytes[index]))
            }
        }

        digest.append(end)

        return digest
    }
}

func md5(input: String, rounds: Int = 1) -> String {
    var inputData = input.data(using: .ascii)!

    for _ in 0..<rounds {
        inputData = inputData.md5data
    }

    return String(data: inputData, encoding: .ascii)!
}

let test = "abc18"
print(md5(input: test))

let threeRegex = try! Regex(pattern: "(.)\\1{2}")
let fiveRegex = try! Regex(pattern: "(.)\\1{4}")

struct Candidate {
    var index: Int
    var char: Character
    var hash: String
    var fiveHashIndex: Int?
}

func findHashes(salt: String, limit: Int, rounds: Int) {
    var candidates: [Candidate] = []
    var found = 0
    var index = 0

    while found < limit {
        let key = "\(salt)\(index)"
        let hash = md5(input: key, rounds: rounds)

        while let first = candidates.first, (first.index + 1000) < index {
            candidates.removeFirst()
        }

        while let first = candidates.first, let _ = first.fiveHashIndex {
            let candidate = candidates.removeFirst()
            print(found, candidate)
            found += 1
        }

        if let match = threeRegex.match(input: hash) {
            let char = match[0].first!
            let candidate = Candidate(index: index, char: char, hash: hash, fiveHashIndex: nil)
            candidates.append(candidate)
        }

        if let match = fiveRegex.match(input: hash) {
            let char = match[0].first!
            for i in 0..<candidates.count {
                if candidates[i].char == char && candidates[i].fiveHashIndex == nil && candidates[i].index != index {
                    candidates[i].fiveHashIndex = index
                }
            }

        }
        index += 1
    }
    print(found)
}

findHashes(salt: "yjdafjpo", limit: 64, rounds: 2017)

//: [Next](@next)
