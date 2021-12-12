# Day 5: Hydrothermal Venture

parseLine = (line) ->
  [lineFrom, lineTo] = line
    .split '->'
    .map (part) -> part.trim()
  [fromX, fromY] = lineFrom
    .split ','
    .map (part) -> +part.trim()
  [toX, toY] = lineTo
    .split ','
    .map (part) -> +part.trim()
  return
    from:
      x: fromX
      y: fromY
    to:
      x: toX
      y: toY

iterate1 = (line) ->
  if line.from.x is line.to.x
    for y in [line.from.y..line.to.y]
      yield "#{line.from.x}:#{y}"
  else if line.from.y is line.to.y
    for x in [line.from.x..line.to.x]
      yield "#{x}:#{line.from.y}"

iterate2 = (line) ->
  if line.from.x is line.to.x
    for y in [line.from.y..line.to.y]
      yield "#{line.from.x}:#{y}"
  else if line.from.y is line.to.y
    for x in [line.from.x..line.to.x]
      yield "#{x}:#{line.from.y}"
  else
    diffX = line.to.x - line.from.x
    diffY = line.to.y - line.from.y
    stepX = if diffX > 0 then 1 else -1
    stepY = if diffY > 0 then 1 else -1
    distance = Math.abs diffX
    for step in [0..distance]
      yield "#{line.from.x + stepX * step}:#{line.from.y + stepY * step}"

parse = (input) ->
  lines = input
    .split '\n'
    .map (i) => i.trim()
    .filter (i) => i.length
  lines.map parseLine

solve1 = (input) ->
  lines = parse input
  covered = new Set()
  twice = new Set()
  for line from lines
    for point from iterate1 line
      if covered.has point
        twice.add point
      else
        covered.add point
  twice.size

solve2 = (input) ->
  lines = parse input
  covered = new Set()
  twice = new Set()
  for line from lines
    for point from iterate2 line
      if covered.has point
        twice.add point
      else
        covered.add point
  twice.size
