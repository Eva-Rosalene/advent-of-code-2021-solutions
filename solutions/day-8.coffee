# Day 8: Seven Segment Search

parsePart = (part) ->
  part
    .split /\s+/g
    .map (entry) -> entry.trim()
    .filter (entry) -> entry.length

parseLine = (line) ->
  [patterns, values] = line
    .split "|"
    .map (part) -> part.trim()
    .map parsePart
  { patterns, values }

parse = (input) ->
  lines = input
    .split "\n"
    .map (line) -> line.trim()
    .filter (line) -> line.length
  lines.map parseLine

solve1 = (input) ->
  lines = parse input
  counter = 0
  for { values } from lines
    for value from values
      counter += 1 if [2, 3, 4, 7].includes value.length
  counter

decode = (patterns) ->
  letters = new Map
  for pattern from patterns
    for segment from pattern
      letters.set segment, (letters.get(segment) || 0) + 1
  mappings = new Map
  eights = new Set
  sevens = new Set
  for [segment, counter] from letters
    switch counter
      when 6 then mappings.set segment, "b"
      when 4 then mappings.set segment, "e"
      when 9 then mappings.set segment, "f"
      when 8 then eights.add segment
      when 7 then sevens.add segment
      else throw new Error "impossible count of segments: segment #{segment} appeared #{counter} times"
  one = patterns.find (pattern) -> pattern.length is 2
  for item from [...eights]
    if one.includes item
      mappings.set item, "c"
      eights.delete item
  throw new Error "eights must be of size 1 at this point" unless eights.size is 1
  mappings.set [...eights][0], "a"
  four = patterns.find (pattern) -> pattern.length is 4
  for item from [...sevens]
    if four.includes item
      mappings.set item, "d"
      sevens.delete item
  throw new Error "sevens must be of size 1 at this point" unless sevens.size is 1
  mappings.set [...sevens][0], "g"
  throw new Error "mappings should be finished at this point" unless mappings.size is 7
  mappings

applySingleReplacement = (replacement, value) ->
  answer = []
  for item from value
    answer.push replacement.get(item)
  answer.sort().join("")

applyReplacement = (replacement, values) ->
  values.map (value) -> applySingleReplacement replacement, value

getNumeric = (value) ->
  switch value
    when "abcefg" then 0
    when "cf" then 1
    when "acdeg" then 2
    when "acdfg" then 3
    when "bcdf" then 4
    when "abdfg" then 5
    when "abdefg" then 6
    when "acf" then 7
    when "abcdefg" then 8
    when "abcdfg" then 9
    else throw new Error "Illegal value: #{value}"

solve2 = (input) ->
  lines = parse input
  sum = 0
  for { patterns, values } from lines
    replacement = decode patterns
    realValues = applyReplacement replacement, values
    numericValues = realValues.map getNumeric
    number = +numericValues.join("")
    sum += number
  sum
