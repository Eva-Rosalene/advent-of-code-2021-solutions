main = () ->
  input = document.querySelector "#input"
  answers =
    answer1: document.querySelector "#answer-1"
    answer2: document.querySelector "#answer-2"
  
  readFile = () -> new Promise (resolve, reject) ->
    fr = new FileReader
    fr.onload = () -> resolve(fr.result)
    fr.onerror = (error) -> reject(error)
    fr.readAsText(input.files[0])

  input.addEventListener "change", () ->
    return unless input.files.length is 1
    data = await readFile()
    try
      answers.answer1.value = solve1 data
      answers.answer1.classList.toggle "error", false
    catch error
      answers.answer1.value = error.message
      answers.answer1.classList.toggle "error", true
    try
      answers.answer2.value = solve2 data
      answers.answer2.classList.toggle "error", false
    catch error
      answers.answer2.value = error.message
      answers.answer2.classList.toggle "error", true

main()
