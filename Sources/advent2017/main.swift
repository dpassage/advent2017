import Advent2017Kit
import Darwin

if CommandLine.arguments.count < 2 {
    print("Specify a day")
    exit(1)
}

let command = CommandLine.arguments[1]

switch command {

default:
    print("Unknown command")
    exit(1)
}
