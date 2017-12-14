import Foundation

struct KnotHashState {
    var buffer: [UInt8]
    var current: Int
    var skip: Int
    let lengths: [UInt8]

    init(lengths: [UInt8]) {
        self.current = 0
        self.skip = 0
        self.buffer = Array<UInt8>(repeating: 0, count: 256)
        for i in 0..<self.buffer.count {
            self.buffer[i] = UInt8(i)
        }
        self.lengths = lengths + [17, 31, 73, 47, 23]
    }

    mutating func doRound() {
        for l in lengths {
            let length = Int(l)
            let swaps = length / 2
            for i in 0..<swaps {
                let low = ((current + i) % buffer.count)
                let high = (current + (length - 1) - i) % buffer.count
                (buffer.swapAt(low, high))
            }

            current = (current + length + skip) % buffer.count
            skip += 1
        }
    }
}

let hexToAscii: [UInt8] = [
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

public func knotHash(bytes: [UInt8]) -> [UInt8] {

    var hashState = KnotHashState(lengths: bytes)
    for _ in 0..<64 {
        hashState.doRound()
    }

    var denseHash = [UInt8](repeating: 0, count: 16)
    for i in 0..<16 {
        let slice = hashState.buffer[(i * 16)..<((i + 1) * 16)]
        let xor = slice.reduce(0, { $0 ^ $1 })
        denseHash[i] = xor
    }

    return denseHash
}

public func knotHash(s: String) -> String {
    let denseHash = knotHash(bytes: Array<UInt8>(s.utf8))

    var result = [UInt8](repeating: 0, count: 32)
    for i in 0..<16 {
        let byte = denseHash[i]
        result[2 * i] = hexToAscii[Int(byte >> 4)]
        result[(2 * i) + 1] = hexToAscii[Int(byte & 0xf)]
    }

    return String(bytes: result, encoding: .utf8)!
}
