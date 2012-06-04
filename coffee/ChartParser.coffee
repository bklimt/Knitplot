
class ChartParser
  parse: (text) =>
    @text = text
    @line = 0
    @lineStart = 0
    @tokenLength = 1
    @offset = 0
    @warnings = []
    @errors = []
    chart = @_parseChart()
    return {
      chart: chart
      errors: @errors
      warnings: @warnings
    }

  _addMessage: (list, message) =>
    list.push
      message: message
      offset: @offset - @tokenLength
      line: @line + 1
      column: ((@offset - @tokenLength) - @lineStart) + 1
      length: @tokenLength

  _eatWhitespace: =>
    @tokenLength = 0
    while @text[@offset] and /[ \t\r]/.test @text[@offset]
      @offset++

  _parseAction: =>
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

    text = @text[start .. (start + @tokenLength - 1)]
    action =
      action: text
      width: 1
      textOffset: @offset - @tokenLength
      textLength: @tokenLength

    # Try to strip a number off the end.
    [match, text, number] = /^(.*[^0-9])([0-9]*)$/.exec text
    action.action = text
    action.repetitions = parseInt(number) if number
    
    defaults = { width: 1, repetitions: 1 }
    if Library[text]
      action = _.extend(defaults, Library[text], action)
    else
      @_addMessage(@errors, "Unknown action type: \"#{text}\".")
      action = _.extend(defaults, Library.error, action, { action: "error" })
    return action

  _parseRow: =>
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
        token = @text[start .. (start + @tokenLength - 1)]
        @_addMessage(@errors, "Stray text: \"#{token}\".")
    return row

  _parseChart: =>
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
