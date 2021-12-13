# Day 12: Passage Pathing

append = (mapping, a, b) ->
  set = mapping.get a
  unless set
    set = new Set
    mapping.set a, set
  set.add b

parse = (input) ->
  result = new Map
  lines = input
    .split '\n'
    .map (line) -> line.trim()
    .filter (line) -> line.length
  for line from lines
    [a, b] = line.split('-').map((i) -> i.trim())
    append result, a, b
    append result, b, a
  result

getWays1 = (mapping, path) ->
  lastPoint = path[path.length - 1]
  if lastPoint is 'end'
    yield path.join(',')
    return
  for adj from mapping.get lastPoint
    continue if /^[a-z]/.test(adj) and path.includes(adj)
    yield from getWays1 mapping, [...path, adj]

canVisit2 = (point, path) ->
  return true unless /^[a-z]/.test point
  return false if point is 'start'
  counts = {}
  for p from path
    continue unless /^[a-z]/.test p
    counts[p] = (counts[p] || 0) + 1
  counts[point] = (counts[point] || 0) + 1
  twices = 0
  for v from Object.values counts
    return false if v > 2
    twices += 1 if v is 2
    return false if twices > 1
  true

getWays2 = (mapping, path) ->
  lastPoint = path[path.length - 1]
  if lastPoint is 'end'
    yield path.join(',')
    return
  for adj from mapping.get lastPoint
    continue unless canVisit2 adj, path
    yield from getWays2 mapping, [...path, adj]

solve1 = (input) ->
  mapping = parse input
  result = [...getWays1 mapping, ["start"]]
  result.length

solve2 = (input) ->
  mapping = parse input
  result = [...getWays2 mapping, ["start"]]
  result.length
