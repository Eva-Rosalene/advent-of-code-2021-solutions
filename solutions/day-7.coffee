# Day 7: The Treachery of Whales
parse = (input) ->
  input
    .split(',')
    .map((i) => i.trim())
    .filter((i) => i.length)
    .map((i) => +i)

intake1 = (x, positions) ->
  result = 0
  for pos from positions
    result += Math.abs(x - pos)
  result

cost2 = (x) -> (1 + x) / 2 * x;

intake2 = (x, positions) ->
  result = 0
  for pos from positions
    result += cost2 Math.abs(x - pos)
  result

prepareField = (positions) ->
  maxPos = Math.max ...positions
  minPos = Math.min ...positions
  x for x in [minPos..maxPos]

solve1 = (input) ->
  positions = parse input
  field = prepareField positions
  intakes = field.map (x) => intake1(x, positions)
  Math.min ...intakes

solve2 = (input) ->
  positions = parse input
  field = prepareField positions
  intakes = field.map (x) => intake2(x, positions)
  Math.min ...intakes
