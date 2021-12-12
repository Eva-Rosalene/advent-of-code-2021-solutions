# Day 2: Dive!
parse = (input) ->
  input
    .split '\n'
    .map (i) => i.trim()
    .filter (i) => i.length

solve1 = (input) ->
  commands = parse input
  depth = 0
  horizontal = 0
  for command from commands
    [name, arg] = command.split /\s+/g
    arg = +arg
    switch name
      when 'forward' then horizontal += arg
      when 'down' then depth += arg
      when 'up' then depth -= arg
  depth * horizontal

solve2 = (input) ->
  commands = parse input
  aim = 0
  depth = 0
  horizontal = 0

  for command from commands
    [name, arg] = command.split /\s+/g
    arg = +arg
    switch name
      when 'forward'
        horizontal += arg
        depth += arg * aim
      when 'down' then aim += arg
      when 'up' then aim -= arg
  depth * horizontal
