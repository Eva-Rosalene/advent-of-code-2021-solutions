# Day 1: Sonar Sweep
parse = (input) ->
  input
    .split '\n'
    .map (i) => i.trim()
    .filter (i) => i.length
    .map (i) => +i

solve1 = (input) ->
  depths = parse input
  increases = 0
  for index in [1..(depths.length - 1)]
    increases += 1 if depths[index] > depths[index - 1]
  increases

solve2 = (input) ->
  depths = parse input
  slidingSums =
    depths[i] + depths[i + 1] + depths[i + 2] for i in [0..(depths.length - 3)]
  increases = 0
  for index in [1..(slidingSums.length - 1)]
    increases += 1 if slidingSums[index] > slidingSums[index - 1]
  increases
