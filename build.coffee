fs       = require "fs"
coffee   = require "coffeescript"
mustache = require "mustache"

fsp = fs.promises

getIndex = (day) ->
  rExp = /^day-(\d+).coffee$/
  match = day.match(rExp)
  return null unless match?
  +match[1]

getDayName = (day) ->
  data = await fsp.readFile "solutions/#{day}", "utf-8"
  lines = data.split('\n').map((line) => line.trim()).filter((line) => line.length)
  firstLine = lines[0]
  isComment = Boolean(firstLine and firstLine.startsWith('#'))
  return "Day #{getIndex(day)}" unless isComment
  firstLine.slice(2).trim()

getIsUnderConstruction = (day) ->
  data = await fsp.readFile "solutions/#{day}", "utf-8"
  lines = data.split('\n').map((line) => line.trim()).filter((line) => line.length)
  lines.indexOf("# @under-construction") > -1

compile = (day) ->
  return if await getIsUnderConstruction day
  dayTemplate = await fsp.readFile "templates/day.html", "utf-8"
  dayIndex = getIndex day
  dayHtml = mustache.render dayTemplate,
    day:
      name: await getDayName day
      index: dayIndex
  commonCoffee = await fsp.readFile "common/common.coffee", "utf-8"
  solutionCoffee = await fsp.readFile "solutions/#{day}", "utf-8"
  fullCoffee = solutionCoffee + "\n\n" + commonCoffee
  solutionJS = coffee.compile fullCoffee
  await fsp.writeFile "dist/day-#{dayIndex}.html", dayHtml
  await fsp.writeFile "dist/solution-day-#{dayIndex}.js", solutionJS

compileIndex = (days) ->
  indexTemplate = await fsp.readFile "templates/index.html", "utf-8"
  preparedDays = await Promise.all days.map (day) ->
    index: getIndex day
    name: await getDayName day
    underConstruction: await getIsUnderConstruction day
  indexHtml = mustache.render indexTemplate,
    days: preparedDays
  await fsp.writeFile "dist/index.html", indexHtml

main = () ->
  entries = await fsp.readdir "solutions"
  days = entries.filter (entry) => entry.startsWith("day-") and entry.endsWith(".coffee")
  days.sort (a, b) ->
    getIndex(a) - getIndex(b)
  await fsp.mkdir "dist",
    recursive: true
  for day from days
    await compile day
  await compileIndex days
  for publicEntry from await fsp.readdir "public"
    await fsp.copyFile "public/#{publicEntry}", "dist/#{publicEntry}"

main().catch (error) ->
  console.error error
  process.exit 1
