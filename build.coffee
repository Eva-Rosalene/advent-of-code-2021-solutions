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

getTags = (day) ->
  data = await fsp.readFile "solutions/#{day}", "utf-8"
  lines = data.split('\n').map((line) => line.trim()).filter((line) => line.length)
  tagsLine = lines.find((line) -> /^#\s*@/.test line)
  return [] unless tagsLine?
  tagsStr = tagsLine.split("@")[1].trim()
  tagsStr.split(',').map((line) => line.trim()).filter((line) => line.length)

compile = (day, ghIcon) ->
  tags = await getTags day
  return if ["under-construction", "unreleased"].some (tag) => tags.includes(tag)
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
    ghIcon: ghIcon
  await fsp.writeFile "dist/day-#{dayIndex}.html", dayHtml
  await fsp.writeFile "dist/solution-day-#{dayIndex}.js", solutionJS

prepareDay = (day) ->
  index = getIndex day
  name = await getDayName day
  tags = await getTags day
  noLink = ["under-construction", "unreleased"].some (tag) => tags.includes(tag)
  underConstructionMessage = tags.includes("under-construction")
  return { index, name, noLink, underConstructionMessage }

compileIndex = (days, ghIcon) ->
  indexTemplate = await fsp.readFile "templates/index.html", "utf-8"
  preparedDays = await Promise.all days.map prepareDay
  indexHtml = mustache.render indexTemplate,
    days: preparedDays
    ghIcon: ghIcon
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

  ghIcon = await fsp.readFile "node_modules/@fortawesome/fontawesome-free/svgs/brands/github.svg", "utf-8"
  ghIcon = ghIcon.replace /<path\s/gi, '<path fill="#eee" '

  for day from days
    await compile day, ghIcon
  await compileIndex days, ghIcon

  for publicEntry from await fsp.readdir "public"
    await fsp.copyFile "public/#{publicEntry}", "dist/#{publicEntry}"

  selectAllSource = await fsp.readFile "common/select-all.coffee", "utf-8"
  selectAllJS = coffee.compile selectAllSource
  await fsp.writeFile "dist/select-all.js", selectAllJS

  viewerTemplate = await fsp.readFile "templates/view-day-13.html", "utf-8"
  viewerHTML = mustache.render viewerTemplate,
    ghIcon: ghIcon
  await fsp.writeFile "dist/view-day-13.html", viewerHTML

  viewerCoffee = await fsp.readFile "common/view-day-13.coffee", "utf-8"
  viewerJS = coffee.compile viewerCoffee
  await fsp.writeFile "dist/view-day-13.js", viewerJS

  await minify() unless process.env.NODE_ENV is "development"

main().catch (error) ->
  console.error error
  process.exit 1
