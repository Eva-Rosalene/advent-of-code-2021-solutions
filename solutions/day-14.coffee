# Day 14: Extended Polymerization

parseRules = (rulesPart) ->
  lines = rulesPart
    .split '\n'
    .map (line) -> line.trim()
    .filter (line) -> line.length

  result = new Map
  for line from lines
    [pair, insertion] = line
      .split '->'
      .map (part) -> part.trim()
    result.set pair, insertion
  result

parse = (input) ->
  [template, rules] = input
    .split '\n\n'
    .map (part) -> part.trim()
    .filter (part) -> part.length
  { template, rules: parseRules rules }

toPairsCounts = (string) ->
  counts = {}
  for i in [1..string.length - 1]
    pair = string.slice i - 1, i + 1
    counts[pair] = (counts[pair] or 0) + 1
  counts

processRules = (rules) ->
  result = {}
  for [pair, insertion] from rules
    result[pair] = ["#{pair[0]}#{insertion}", "#{insertion}#{pair[1]}"]
  result

step = (counts, rules) ->
  next = {}
  for [pair, count] from Object.entries counts
    [a, b] = rules[pair]
    next[a] = (next[a] or 0) + count
    next[b] = (next[b] or 0) + count
  next

countElements = (counts, template) ->
  result = {}
  for [pair, count] from Object.entries counts
    result[pair[0]] = (result[pair[0]] or 0) + count
    result[pair[1]] = (result[pair[1]] or 0) + count
  result[template[0]] += 1
  result[template[template.length - 1]] += 1
  for key from Object.keys result
    result[key] /= 2
  result

solve1 = (input) ->
  model = parse input
  processedRules = processRules model.rules
  counts = toPairsCounts model.template
  for i in [1..10]
    counts = step counts, processedRules
  elementCounts = countElements counts, model.template
  maxElement = -Infinity
  minElement = Infinity
  for v from Object.values elementCounts
    maxElement = Math.max maxElement, v
    minElement = Math.min minElement, v
  maxElement - minElement


solve2 = (input) ->
  model = parse input
  processedRules = processRules model.rules
  counts = toPairsCounts model.template
  for i in [1..40]
    counts = step counts, processedRules
  elementCounts = countElements counts, model.template
  maxElement = -Infinity
  minElement = Infinity
  for v from Object.values elementCounts
    maxElement = Math.max maxElement, v
    minElement = Math.min minElement, v
  maxElement - minElement
