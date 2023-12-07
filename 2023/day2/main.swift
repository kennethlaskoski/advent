//

import System
import Foundation
import RegexBuilder

enum Color: String {
  case red
  case blue
  case green
}

typealias Scalar = Int
typealias Vector = (red: Scalar, blue: Scalar, green: Scalar)

func power(_ vector: Vector) -> Scalar {
  vector.red * vector.blue * vector.green
}

let zero: Vector = (0, 0, 0)
let red: Vector = (1, 0, 0)
let blue: Vector = (0, 1, 0)
let green: Vector = (0, 0, 1)

func length(_ vector: Vector) -> Scalar {
  abs(vector.red) + abs(vector.blue) + abs(vector.green)
}

func distance(from lhs: Vector, to rhs: Vector) -> Scalar {
  abs(lhs.red - rhs.red) + abs(lhs.blue - rhs.blue) + abs(lhs.green - rhs.green)
}

precondition(length(zero) == 0)
precondition(length(red) == 1)
precondition(length(blue) == 1)
precondition(length(green) == 1)

func <= (_ lhs: Vector, _ rhs: Vector) -> Bool {
  lhs.red <= rhs.red && lhs.blue <= rhs.blue && lhs.green <= rhs.green
}

func + (_ lhs: Vector, _ rhs: Vector) -> Vector {
  (lhs.red + rhs.red, lhs.blue + rhs.blue, lhs.green + rhs.green)
}

typealias Draw = Vector

struct Game {
  let id: Int
  let draws: [Draw]
}

typealias Bag = Vector

let bag: Bag = (red: 12, blue: 14, green: 13)

extension Game {
  func isPossible(for bag: Bag) -> Bool {
    for draw in draws {
      if !(draw <= bag) {
        return false
      }
    }
    return true
  }
}

extension Game {
  var min: Bag {
    var bag: Bag = zero
    for draw in draws {
      bag = (max(bag.red, draw.red), max(bag.blue, draw.blue), max(bag.green, draw.green))
    }
    return bag
  }
}

func power(_ game: Game) -> Scalar {
  power(game.min)
}

var input = try! String(contentsOfFile: "input.txt")

//input = """
//Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
//Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue
//Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red
//Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red
//Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green
//"""

let numberEx = Regex {
  OneOrMore(.digit)
}

func idFrom(_ s: String) -> Int {
  let match = s.firstMatch(of: numberEx)
  return Int(match!.output)!
}

let colorEx = Regex {
  ChoiceOf {
    "red"
    "blue"
    "green"
  }
}

func drawFrom(_ s: String) -> Draw {
  let value = Scalar(s.firstMatch(of: numberEx)!.output)!
  let color = Color(rawValue: String(s.firstMatch(of: colorEx)!.output))!
  switch color {
  case .red:
    return (value, 0, 0)
  case .blue:
    return (0, value, 0)
  case .green:
    return (0, 0, value)
  }
}

var sum = 0
for line in input.components(separatedBy: .newlines) {
  if line.isEmpty {
    break
  }
  print(line)

  let gameLine = line.components(separatedBy: ":")
  var draws: [Draw] = []
  for gameDraw in gameLine[1].components(separatedBy: ";") {
    var draw = zero
    for gameHand in gameDraw.components(separatedBy: ",") {
      draw = draw + drawFrom(gameHand)
    }
    draws.append(draw)
  }

  let id = idFrom(gameLine[0])
  let game = Game(id: id, draws: draws)
  print(game, terminator: " ")
  print(game.isPossible(for: bag), terminator: " ")
  print(game.min, terminator: " ")
  print(power(game))

  sum += power(game)
}

print(sum)
