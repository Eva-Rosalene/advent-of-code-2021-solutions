# Day 13: Transparent Origami

parsePoint = (line) ->
  [x, y] = line
    .split ','
    .map (i) -> +i
  { x, y }

parseCommand = (line) ->
  rexp = /fold along (.)=(\d+)/
  match = line.match(rexp)
  return null unless match
  axis = match[1]
  coordinate = +match[2]
  { axis, coordinate }

parse = (input) ->
  [pointsPart, commandsPart] = input
    .split '\n\n'
    .map (part) -> part.trim()
    .filter (part) -> part.length
  points = pointsPart
    .split '\n'
    .map (line) -> line.trim()
    .filter (line) -> line.length
    .map parsePoint
  commands = commandsPart
    .split '\n'
    .map (line) -> line.trim()
    .filter (line) -> line.length
    .map parseCommand
  { points, commands }

solve1 = (input) ->
  { points, commands } = parse input
  firstCommand = commands[0]
  result = new Set
  for point from points
    if point[firstCommand.axis] > firstCommand.coordinate
      point[firstCommand.axis] = 2 * firstCommand.coordinate - point[firstCommand.axis]
    result.add "#{point.x}:#{point.y}"
  result.size

solve2 = (input) ->
  { points, commands } = parse input
  firstCommand = commands[0]
  result = new Set
  for { axis, coordinate } from commands
    for point from points
      if point[axis] > coordinate
        point[axis] = 2 * coordinate - point[axis]
  for { x, y } from points
    result.add "#{x},#{y}"
  points =
    parsePoint point for point from result

  # rest of this function code isn't part of a solution but of presentation
  solutionURL = new URL "view-day-13.html", location.href
  solutionURL.hash = "#{points.map(({ x, y }) -> "#{x},#{y}").join(";")}"
  link = document.querySelector "#real-answer-2"
  link.href = solutionURL.href
  link.classList.remove "disabled-link"
  return null

# code below isn't part of a solution but of presentation

prepare = ->
  answer2 = document.querySelector "#answer-2"
  answer2.style.display = "none"

  realAnswer2 = document.createElement "a"
  realAnswer2.appendChild document.createTextNode "open in new window"
  realAnswer2.classList.add "disabled-link"
  realAnswer2.id = "real-answer-2"
  realAnswer2.target = "_blank"
  answer2.parentElement.insertBefore realAnswer2, answer2

prepare()
