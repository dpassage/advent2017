//: [Previous](@previous)

import Foundation

let hyphen = CharacterSet(charactersIn: "-")
let digits = CharacterSet.decimalDigits
let integerLegal = hyphen.union(digits)
let integerIllegal = integerLegal.inverted

struct Vec {
    var x: Int
    var y: Int
    var z: Int

    // x=<3,0,-7>
    init?(s: String) {
        let parts = s.components(separatedBy: integerIllegal)
        let ints = parts.flatMap { Int($0) }
        guard ints.count == 3 else { return nil }
        x = ints[0]
        y = ints[1]
        z = ints[2]
    }

    init(x: Int, y: Int, z: Int) { self.x = x; self.y = y; self.z = z }
    var magnitude: Int {
        return abs(x) + abs(y) + abs(z)
    }

    static func + (lhs: Vec, rhs: Vec) -> Vec {
        return Vec(x: lhs.x + rhs.x, y: lhs.y + rhs.y, z: lhs.z + rhs.z)
    }
}

extension Vec: Hashable {
    var hashValue: Int {
        return x.hashValue ^ y.hashValue ^ z.hashValue
    }

    static func ==(lhs: Vec, rhs: Vec) -> Bool {
        return lhs.x == rhs.x && lhs.y == rhs.y && lhs.z == rhs.z
    }
}

extension Vec: CustomStringConvertible {
    var description: String {
        return "<\(x),\(y),\(z)>"
    }
}

struct Particle {
    var position: Vec
    var velocity: Vec
    var acceleration: Vec
    var num: Int

    // p=<1556,2084,1247>, v=<-97,-115,-45>, a=<0,-2,-4>
    init?(s: String, num: Int = -1) {
        let parts = s.components(separatedBy: ", ")
        let vectors = parts.flatMap { Vec(s: $0) }
        guard vectors.count == 3 else { return nil }
        self.position = vectors[0]
        self.velocity = vectors[1]
        self.acceleration = vectors[2]
        self.num = num
    }

    init(position: Vec, velocity: Vec, acceleration: Vec, num: Int) {
        self.position = position
        self.velocity = velocity
        self.acceleration = acceleration
        self.num = num
    }

    func next() -> Particle {
        let newVel = velocity + acceleration
        let newPos = position + newVel
        return Particle(position: newPos, velocity: newVel, acceleration: acceleration, num: self.num)
    }

    func adding(num: Int) -> Particle {
        var ret = self
        ret.num = num
        return ret
    }
}

extension Particle: CustomStringConvertible {
    var description: String {
        return "n = \(num), p=\(position), v=\(velocity), a=\(acceleration)"
    }
}

let testInput = """
p=<3,0,0>, v=<2,0,0>, a=<-1,0,0>
p=<4,0,0>, v=<0,0,0>, a=<-2,0,0>
"""

let testParticles = testInput.components(separatedBy: "\n").flatMap { Particle(s: $0) }.enumerated().map { (x) -> Particle in
    var next = x.element
    next.num = x.offset
    return next
}

let smallestAcceleration = testParticles.enumerated().min { (lhs, rhs) -> Bool in
    return lhs.element.acceleration.magnitude < rhs.element.acceleration.magnitude
}
let input = try! String(contentsOfFile: "/Users/dpassage/dev/advent2017/Advent2017.playground/Pages/Day 20 - Particle Swarm.xcplaygroundpage/Resources/day20.input.txt")

class GPU {

    init(input: String) {
        self.particles = input.components(separatedBy: "\n").flatMap { Particle(s: $0) }.enumerated().map { (n) -> Particle in
            return n.element.adding(num: n.offset)
        }
    }

    var particles: [Particle]

    func iterate() {
        let iteratedParticles = particles.map { $0.next() }
        var positionCounts: [Vec: Int] = [:]
        for particle in iteratedParticles {
            positionCounts[particle.position] = 1 + (positionCounts[particle.position] ?? 0)
        }

        let dupedPositions = positionCounts.filter { (kv) -> Bool in
            kv.value != 1
        }.keys
        if dupedPositions.count == particles.count {
            particles = iteratedParticles
        } else {
            particles = iteratedParticles.filter { !dupedPositions.contains($0.position) }
        }
    }

    func run() -> Int {
        var iteration = 0
        while particles.count > 1 {
            let beforeIterate = particles.count
            iterate()
            let afterIterate = particles.count
            if beforeIterate != afterIterate || (iteration % 1_000) == 0 {
                print(iteration, beforeIterate, afterIterate)
            }
            iteration += 1
        }
        return particles.first?.num ?? -1
    }
}

let gpuTestInput = """
p=<-6,0,0>, v=<3,0,0>, a=<0,0,0>
p=<-4,0,0>, v=<2,0,0>, a=<0,0,0>
p=<-2,0,0>, v=<1,0,0>, a=<0,0,0>
p=<3,0,0>, v=<-1,0,0>, a=<0,0,0>
"""

// on Xcode 9.2, the below crashes in a playground but works fine as a command-line compile.
let testGPU = GPU(input: gpuTestInput)
print(testGPU.run())

let gpu = GPU(input: input)
print(gpu.run())

//: [Next](@next)
