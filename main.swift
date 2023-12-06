//

import System
import Foundation
import RegexBuilder

enum DigitText: String, CaseIterable {
  case zero
  case one
  case two
  case three
  case four
  case five
  case six
  case seven
  case eight
  case nine
}

extension DigitText {
  var value: Int { Self.allCases.firstIndex(of: self)! }
  var number: String { self.value.description }
}

let firsts = DigitText.allCases.map { $0.rawValue }.joined(separator: "|")
let lasts = String(firsts.reversed())

let firstsRegex = try! Regex("\(firsts)", as: Substring.self)
let lastsRegex = try! Regex("\(lasts)", as: Substring.self)

let transform: (String) -> String = { s in DigitText(rawValue: String(s))?.number ?? s }

var input = try! String(contentsOfFile: "input.txt")

//input = """
//two1nine
//eightwothree
//abcone2threexyz
//xtwone3four
//4nineeightseven2
//zoneight234
//7pqrstsixteen
//"""

let forwards = Regex {
  ChoiceOf {
    .digit
    firstsRegex
  }
}

let backwards = Regex {
  ChoiceOf {
    .digit
    lastsRegex
  }
}

var sum = 0
for line in input.components(separatedBy: .newlines) {
  if line.isEmpty {
    break
  }
  print(line)

  let firstMatch = line.firstMatch(of: forwards)
  print(firstMatch!.output, terminator: " ")
  let first = transform(String(firstMatch!.output))
  print(first)

  let reversed = String(line.reversed())
  print(reversed)

  let lastMatch = reversed.firstMatch(of: backwards)
  print(lastMatch!.output, terminator: " ")
  let last = transform(String(lastMatch!.output.reversed()))
  print(last)

  let number = "\(first)\(last)"
  print(number, terminator: " ")
  sum += Int(number)!
  print(sum)
}

print(sum)
