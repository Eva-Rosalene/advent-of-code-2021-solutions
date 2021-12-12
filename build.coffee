minifier      = require "minify"
fs            = require "fs"
coffee        = require "coffeescript"
mustache      = require "mustache"
prism         = require "prismjs"
loadLanguages = require "prismjs/components/"
tryToCatch    = require "try-to-catch"

fsp = fs.promises
loadLanguages ["coffee"]

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
  commonCoffee = await fsp.readFile "common/common.coffee", "utf-8"
  solutionCoffee = await fsp.readFile "solutions/#{day}", "utf-8"
  fullCoffee = solutionCoffee + "\n\n" + commonCoffee
  solutionJS = coffee.compile fullCoffee
  dayTemplate = await fsp.readFile "templates/day.html", "utf-8"
  dayIndex = getIndex day
  dayHtml = mustache.render dayTemplate,
    day:
      name: await getDayName day
      index: dayIndex
    code: prism.highlight(solutionCoffee, prism.languages.coffee, 'coffee')
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

minify = () ->
  files = await fsp.readdir "dist"
  for file from files
    continue unless /\.(css|js|html)$/i.test file
    [error, data] = await tryToCatch minifier, "dist/#{file}",
      html:
        removeAttributeQuotes: false
    throw error if error?
    await fsp.writeFile "dist/#{file}", data

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
  selectAllSource = await fsp.readFile "common/select-all.coffee", "utf-8"
  selectAllJS = coffee.compile selectAllSource
  await fsp.writeFile "dist/select-all.js", selectAllJS
  await minify()

main().catch (error) ->
  console.error error
  process.exit 1
