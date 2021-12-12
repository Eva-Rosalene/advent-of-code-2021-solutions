# Day 11: Dumbo Octopus

parse = (input) ->
  input
    .split "\n"
    .map (line) -> line.trim()
    .filter (line) -> line.length
    .map (line) -> line.split('').map((i) -> +i)

adjacents = (i, j, maxI, maxJ) ->
  for di in [-1..1]
    for dj in [-1..1]
      continue if di is 0 and dj is 0
      continue if i + di < 0
      continue if j + dj < 0
      continue if i + di > maxI
      continue if j + dj > maxJ
      yield [i + di, j + dj]

indices = (data) ->
  for i in [0..data.length - 1]
    for j in [0..data[0].length - 1]
      yield [i, j]

class Model
  constructor: (data) ->
    @data = data
    @flashed = []
    @totalFlashes = 0
    for i in [0..data.length - 1]
      @flashed[i] = []
      for j in [0..data[0].length - 1]
        @flashed[i][j] = false
  
  inc: ->
    for [i, j] from indices @data
      @data[i][j] += 1

  fullFlash: ->
    for [i, j] from indices @data
      return false unless @flashed[i][j]
    true

  step: ->
    for [i, j] from indices @data
      @flashed[i][j] = false
    wereFlashes = true
    @inc()
    while wereFlashes
      wereFlashes = false
      for [i, j] from indices @data
        if @data[i][j] > 9 and not @flashed[i][j]
          wereFlashes = true
          @totalFlashes += 1
          @flashed[i][j] = true
          for [ai, aj] from adjacents i, j, @data.length - 1, @data[0].length - 1
            @data[ai][aj] += 1
    for [i, j] from indices @data
      @data[i][j] = 0 if @flashed[i][j]
    return @fullFlash()

solve1 = (input) ->
  model = new Model(parse input)
  for _ in [1..100]
    model.step()
  model.totalFlashes

solve2 = (input) ->
  model = new Model(parse input)
  wasFullFlash = false
  step = 0
  until wasFullFlash
    step += 1
    wasFullFlash = model.step()
  step
