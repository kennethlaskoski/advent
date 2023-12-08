//

import System
import Foundation
import RegexBuilder

let number = Regex {
  OneOrMore {
    .digit
  }
}

let symbol = Regex {
  .any.subtracting(.anyOf(".").union(.digit))
}

func checker(for range: Range<String.Index>) -> (String) -> Bool {
  { line in
    let range = range.relative(to: line)
    for match in line.matches(of: symbol) {
      if match.endIndex == range.lowerBound || match.startIndex == range.upperBound || range.contains(match.startIndex) {
        return true
      }
    }
    return false
  }
}

func numbers(for gear: Range<String.Index>) -> (String) -> [Int] {
  { line in
    var result: [Int] = []
    let range = gear.relative(to: line)
    for match in line.matches(of: number) {
      if match.endIndex == range.lowerBound || match.startIndex == range.upperBound || match.range.contains(range.lowerBound) {
        result.append(Int(match.output)!)
      }
    }
    return result
  }
}

var input = try! String(contentsOfFile: "input.txt")

//input = """
//467..114..
//...*......
//..35..633.
//......#...
//617*......
//.....+.58.
//..592.....
//......755.
//...$.*....
//.664.598..
//"""

var sum = 0
var previousLine = String()

let lines = input.components(separatedBy: .newlines)

for (index, line) in lines.enumerated() {
  if line.isEmpty {
    break
  }
  print(line)

  let nextLine = index+1 < lines.count ? lines[index+1] : ""
  let numberMatches = line.matches(of: symbol)
  for match in numberMatches {
    if match.output == "*" {
      let numbers = numbers(for: match.range)
      var factors: [Int] = numbers(line)
      factors.append(contentsOf: numbers(previousLine))
      factors.append(contentsOf: numbers(nextLine))
      if factors.count > 1 {
        sum += factors.reduce(1) { $0 * $1 }
      }
    }
  }
  previousLine = line
}

print(sum)
