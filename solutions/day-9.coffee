# Day 9: Smoke Basin

parse = (input) ->
  input
    .split '\n'
    .map (line) -> line.trim()
    .filter (line) -> line.length
    .map (line) -> line.split ''
    .map (line) ->
      line.map (number) -> +number

adjacents = (i, j, maxI, maxJ) ->
  possible = []
  possible.push [i - 1, j]
  possible.push [i + 1, j]
  possible.push [i, j - 1]
  possible.push [i, j + 1]
  for point from possible
    continue if point[0] < 0
    continue if point[1] < 0
    continue if point[0] > maxI
    continue if point[1] > maxJ
    yield point

isLocalLowest = (data, i, j) ->
  for [adjI, adjJ] from adjacents i, j, data.length - 1, data[0].length - 1
    return false unless data[i][j] < data[adjI][adjJ]
  true

solve1 = (input) ->
  data = parse input
  riskSum = 0
  for i in [0..data.length - 1]
    for j in [0..data[0].length - 1]
      riskSum += data[i][j] + 1 if isLocalLowest data, i, j
  riskSum

generateBasin = (data, point) ->
  basin = [point]
  nextPoints = [point]

  visited = new Set ["#{point[0]}:#{point[1]}"]

  while nextPoints.length
    nextNextPoints = []
    for point from nextPoints
      for [i, j] from adjacents point[0], point[1], data.length - 1, data[0].length - 1
        unless data[i][j] is 9 or visited.has "#{i}:#{j}"
          nextNextPoints.push [i, j]
          basin.push [i, j]
          visited.add "#{i}:#{j}"
    nextPoints = nextNextPoints
  basin

solve2 = (input) ->
  data = parse input
  lowestPoints = []
  for i in [0..data.length - 1]
    for j in [0..data[0].length - 1]
      lowestPoints.push [i, j] if isLocalLowest data, i, j
  basins = lowestPoints.map (point) ->
    generateBasin data, point
  basinSizes = basins.map (basin) -> basin.length
  basinSizes.sort (a, b) ->
    b - a
  [a, b, c] = basinSizes
  a * b * c
