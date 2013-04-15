
class ChartParser
  constructor: (@chart) ->
    @chart.on "change:text", @onChangeText
    @chart.on "change:library", @onChangeLibrary
    @onChangeText()

  onChangeText: =>
    @_parse()

  onChangeLibrary: =>
    @_parse()

  _parse: ->
    @text = @chart.get "text"
    @line = 0
    @lineStart = 0
    @tokenLength = 1
    @offset = 0
    @warnings = []
    @errors = []
    actions = @_parseChart()
    @chart.transient.set({
      actions: actions
      errors: @errors
      warnings: @warnings
    })

  _addMessage: (list, message) ->
    list.push
      message: message
      offset: @offset - @tokenLength
      line: @line + 1
      column: ((@offset - @tokenLength) - @lineStart) + 1
      length: @tokenLength

  _eatWhitespace: ->
    @tokenLength = 0
    while @text[@offset] and /[ \t\r]/.test @text[@offset]
      @offset++

  _parseAction: ->
    library = @chart.get("library").get("data")

    @_eatWhitespace()
    start = @offset
    @tokenLength = 0
    while @text[@offset] and not /[, \t\r\n]/.test @text[@offset]
      ++@offset
      ++@tokenLength

    if @tokenLength is 0
      if (not @text[@offset]) or /\r\n/.test @text[@offset]
        # It's just a stray comma at the end of a line.
        return null
      else
        @_addMessage(@warnings, "Missing action.")
        return null

    text = @text[start ... (start + @tokenLength)]
    action =
      action: text
      width: 1
      textRow: @line
      textColumn: ((@offset - @tokenLength) - @lineStart)
      textOffset: @offset - @tokenLength
      textLength: @tokenLength

    # Try to strip a number off the end.
    [match, text, number] = /^(.*[^0-9])([0-9]*)$/.exec text
    action.action = text
    action.repetitions = parseInt(number) if number
    
    defaults = { width: 1, repetitions: 1 }
    found = false
    if library[text]
      action = _.extend(defaults, library[text], action)
      found = true
    else
      # Maybe this is like t2r -> t#r.
      match = /^([^0-9]*)([0-9]*)([^0-9]*)$/.exec text
      if match
        [match, prefix, number, suffix] = match
        altText = "#{prefix}##{suffix}"
        if match and library[altText]
          action = _.extend(defaults, library[altText], action)
          action.action = altText
          action.width = action.width * parseInt(number)
          found = true
    if not found
      @_addMessage(@errors, "Unknown action type: \"#{text}\".")
      action = _.extend(defaults, library.error, action, { action: "error" })
    return action

  _parseRow: ->
    row = []
    @_eatWhitespace()
    if (not @text[@offset]) or @text[@offset] is "\n"
      # It's an empty row.
      return row
    action = @_parseAction()
    row.push(action) if action
    @_eatWhitespace()
    until (not @text[@offset]) or @text[@offset] is "\n"
      if @text[@offset] is ","
        ++@offset
        action = @_parseAction()
        row.push(action) if action
        @_eatWhitespace()
      else
        start = @offset
        until (not @text[@offset]) or /[, \t\r\n]/.test @text[@offset]
          ++@offset
          ++@tokenLength
        token = @text[start ... (start + @tokenLength)]
        @_addMessage(@errors, "Stray text: \"#{token}\".")
        @_eatWhitespace()
    return row

  _parseChart: ->
    @_eatWhitespace()
    chart = []
    # Skip extra newlines at the beginning of the chart.
    while @text[@offset] and @text[@offset] is "\n"
      ++@offset
      @_eatWhitespace()
    if not @text[@offset]
      # It's an empty chart.
      return chart
    chart.push(@_parseRow())
    @_eatWhitespace()
    while @text[@offset]
      if @text[@offset] is "\n"
        ++@offset
        ++@line
        @lineStart = @offset
        # Check for blank line at the end of the chart.
        @_eatWhitespace()
        if not @text[@offset]
          return chart
        chart.push(@_parseRow())
        @_eatWhitespace()
      else
        @_addMessage(@errors, "Stray text after row.")
        ++@offset
    return chart

Knitplot.Models ?= {}
Knitplot.Models.ChartParser = ChartParser

