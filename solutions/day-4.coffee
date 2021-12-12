# Day 4: Giant Squid

iterateNumbers = (lines) ->
  for line from lines
    numbers = line
      .split /\s+/g
      .filter (number) => number.length
      .map (number) => +number
    for number from numbers
      yield number

iterateBoards = (numbers) ->
  boards = [[]]
  for number from numbers
    boards[boards.length - 1].push number
    if boards[boards.length - 1].length >= 25
      yield new Board boards[boards.length - 1]
      boards.push []
  return

class Board
  constructor: (numbers) ->
    @last = 0
    @data = []
    for i in [0..4]
      @data[i] = []
      for j in [0..4]
        @data[i][j] = numbers[i * 5 + j]

    @marked = []
    for i in [0..4]
      @marked[i] = []
      for j in [0..4]
        @marked[i][j] = false

  mark: (number) ->
    @last = number
    for i in [0..4]
      for j in [0..4]
        @marked[i][j] = true if @data[i][j] is number

  isComplete: ->
    for i in [0..4]
      rowComplete = true
      for j in [0..4]
        rowComplete = false unless @marked[i][j]
      return true if rowComplete

    for j in [0..4]
      columnComplete = true
      for i in [0..4]
        columnComplete = false unless @marked[i][j]
      return true if columnComplete
    false

  getScore: ->
    unmarkedSum = 0
    for i in [0..4]
      for j in [0..4]
        unmarkedSum += @data[i][j] unless @marked[i][j]
    @last * unmarkedSum

parse = (input) ->
  [header, ...rest] = input
    .split '\n'
    .map (line) => line.trim()
    .filter (line) => line.length

  tokens = header
    .split ','
    .map (token) => token.trim()
    .filter (token) => token.length
    .map (token) => +token

  boards = [...iterateBoards(iterateNumbers rest)]
  { tokens, boards }

getWinningBoard = (boards, tokens) ->
  for token from tokens
    for board from boards
      board.mark token
      return board if board.isComplete()
  null

getLastWinningBoard = (boards, tokens) ->
  indicesToRemove = []
  lastWinner = null
  for token from tokens
    indicesToRemove.sort (a, b) -> b - a
    for index from indicesToRemove
      boards.splice index, 1
    indicesToRemove = []
    if boards.length
      for i in [0..(boards.length - 1)]
        board = boards[i]
        board.mark token
        if board.isComplete()
          lastWinner = board
          indicesToRemove.push i
  lastWinner

solve1 = (input) ->
  { boards, tokens } = parse input
  winner = getWinningBoard boards, tokens
  throw new Error 'No winning board :(' unless winner?
  winner.getScore()

solve2 = (input) ->
  { boards, tokens } = parse input
  lastWinner = getLastWinningBoard boards, tokens
  throw new Error 'No last-winning board :(' unless lastWinner?
  lastWinner.getScore()
