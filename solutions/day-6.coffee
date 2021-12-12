# Day 6: Lanternfish

parse = (input) ->
  fishes = input
    .split(',')
    .map((i) => i.trim())
    .filter((i) => i.length)
    .map((i) => +i)
  model = (0 for _ in [0..8])
  for fish from fishes
    throw new Error("Forbidden fish: #{fish}") if fish < 0 or fish > 8
    model[fish] += 1
  model

step = (model) ->
  next = (0 for _ in [0..8])
  for i in [1..8]
    next[i - 1] = model[i]
  next[8] = model[0]
  next[6] += model[0]
  next

solveDays = (input, days) ->
  model = parse input
  for _ in [1..days]
    model = step model
  result = 0
  result += group for group from model
  result

solve1 = (input) ->
  solveDays(input, 80)

solve2 = (input) ->
  solveDays(input, 256)
