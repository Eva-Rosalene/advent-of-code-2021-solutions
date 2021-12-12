# Day 3: Binary Diagnostic
parse = (input) ->
  input
    .split("\n")
    .map((i) => i.trim())
    .filter((i) => i.length)

solve1 = (input) ->
  numbers = parse input
  gamma =
    "X" for _ in [0..numbers[0].length - 1]
  epsilon =
    "X" for _ in [0..numbers[0].length - 1]
  for i in [0..numbers[0].length - 1]
    ones = 0
    zeroes = 0
    for j in [0..numbers.length - 1]
      switch numbers[j][i]
        when "0" then zeroes += 1
        when "1" then ones += 1
        else throw new Error("Wrong input: #{numbers[j][i]}")
    gamma[i] = if ones > zeroes then "1" else "0"
    epsilon[i] = if ones > zeroes then "0" else "1"
  gammaNumeric = parseInt gamma.join(""), 2
  epsilonNumeric = parseInt epsilon.join(""), 2
  gammaNumeric * epsilonNumeric

oxygenCriteria = (numbers, position) ->
  ones = 0
  zeroes = 0
  for number from numbers
    bit = number[position]
    switch bit
      when "0" then zeroes += 1
      when "1" then ones += 1
      else throw new Error("Wrong input: #{bit}")
  mostCommon = if zeroes > ones then "0" else "1"
  numbers.filter (number) ->
    number[position] is mostCommon

co2Criteria = (numbers, position) ->
  ones = 0
  zeroes = 0
  for number from numbers
    bit = number[position]
    switch bit
      when "0" then zeroes += 1
      when "1" then ones += 1
      else throw new Error("Wrong input: #{bit}")
  leastCommon = if zeroes > ones then "1" else "0"
  numbers.filter (number) ->
    number[position] is leastCommon

solve2 = (input) ->
  numbers = parse input
  oxygenCandidates = [...numbers]
  co2Candidates = [...numbers]

  for i in [0..numbers[0].length - 1]
    oxygenCandidates = oxygenCriteria oxygenCandidates, i
    if oxygenCandidates.length is 1
      break
  for i in [0..numbers[0].length - 1]
    co2Candidates = co2Criteria co2Candidates, i
    if co2Candidates.length is 1
      break
  
  oxygenNumeric = parseInt oxygenCandidates[0], 2
  co2Numeric = parseInt co2Candidates[0], 2
  oxygenNumeric * co2Numeric
