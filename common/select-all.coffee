selectButton = document.querySelector "#select-button"
sourceCode = document.querySelector "#source"

selectButton.addEventListener "click", () ->
  range = new Range
  range.selectNode sourceCode
  document.getSelection().empty()
  document.getSelection().addRange range
