points = location.hash
  .slice 1
  .split ";"
  .map (point) ->
    [x, y] = point
      .split ","
      .map (coord) -> +coord
    { x, y }

showAnswer = (points) ->
  maxX = -Infinity
  maxY = -Infinity
  for { x, y } from points
    maxX = Math.max x, maxX
    maxY = Math.max y, maxY
  field = []
  for y in [0..maxY]
    field[y] = []
    for x in [0..maxX]
      field[y][x] = false
  for { x, y } from points
    field[y][x] = true

  result = document.createElement "table"
  result.classList.add "view-day-13-table"

  tbody = document.createElement "tbody"
  result.appendChild tbody

  for y in [0..maxY]
    tr = document.createElement "tr"
    for x in [0..maxX]
      td = document.createElement "td"
      td.classList.add "view-day-13-square"
      td.classList.toggle "view-day-13-square-active", field[y][x]
      tr.appendChild td
    tbody.appendChild tr

  document.querySelector "#root"
    .appendChild result

showAnswer points
