BaseExporter = require("./BaseExporter")
toSource = require('tosource')
fs = require "fs"
path = require "path"
UglifyJS = require("uglify-js")
beautify = require('js-beautify').js_beautify

recursion = ""
recurseStr = "|__ "
depth = 0

compileObj = (obj) ->
  result = ""
  for k of obj
    childObj = obj[k]
    childType = (typeof childObj)
    log recursion + k + " type: " + childType

    if childType == "number"
      result += "#{k} = #{childObj};"

    if childType == "string"
      result += "#{k} = '#{childObj}';"

    if childType == "function"
      result += "#{k} = #{toSource childObj};"

    if childType == "object"
      recursion += recurseStr
      depth++
      if k == "app" and depth == 0
        result += "#{compileObj childObj}"
      else
        result += "#{k} = #{toSource childObj}"

      recursion = recursion.substring(0, recurseStr.length)
      depth--

  return result

module.exports =
  class WebExporter extends BaseExporter

    compile: (options, callback) ->
      # Put app: manually in here because we dont want to export other stuff in @main
      compiled = compileObj @main
      if options.mode == COMPILER_MODE.development
        compiled = beautify(compiled, { indent_size: 2 })
      else
        attrs = { fromString: yes }
        compiled = UglifyJS.minify(compiled, attrs).code;

      fs.writeFile path.resolve(options.output, "main.js"), compiled, (err) ->
        throw err  if err
        callback()
        return
