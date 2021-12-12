# Day 10: Syntax Scoring

parse = (input) ->
  input
    .split '\n'
    .map (item) -> item.trim()
    .filter (item) -> item.length

OPENING = ["(", "{", "[", "<"]
CLOSING = [")", "}", "]", ">"]

SCORE_MAP_1 =
  ")": 3
  "]": 57
  "}": 1197
  ">": 25137

SCORE_MAP_2 =
  ")": 1
  "]": 2
  "}": 3
  ">": 4

getScore1 = (line) ->
  stack = []
  for symbol from line
    if OPENING.includes symbol
      stack.push symbol
      continue
    if CLOSING.includes symbol
      closingId = CLOSING.indexOf symbol
      openingId = OPENING.indexOf stack[stack.length - 1]
      return SCORE_MAP_1[symbol] unless closingId is openingId
      stack.pop()
  return 0

complete = (line) ->
  stack = []
  for symbol from line
    if OPENING.includes symbol
      stack.push symbol
      continue
    if CLOSING.includes symbol
      closingId = CLOSING.indexOf symbol
      openingId = OPENING.indexOf stack[stack.length - 1]
      return 0 unless closingId is openingId
      stack.pop()
  score = 0
  while stack.length
    symbol = stack.pop()
    openingId = OPENING.indexOf symbol
    closingSymbol = CLOSING[openingId]
    score = score * 5 + SCORE_MAP_2[closingSymbol]
  score

solve1 = (input) ->
  lines = parse input
  score = 0
  score += getScore1 line for line from lines
  score

solve2 = (input) ->
  lines = parse input
  results = []
  for line from lines
    result = complete line
    results.push result if result > 0
  results.sort (a, b) -> a - b
  throw new Error "result count is even while must be odd" unless results.length % 2
  results[(results.length - 1) / 2]
