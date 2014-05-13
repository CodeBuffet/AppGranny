BaseExporter = require("./BaseExporter")
toSource = require('tosource')
fs = require "fs"
path = require "path"
UglifyJS = require("uglify-js")
beautify = require('js-beautify').js_beautify

recursion = ""
recurseStr = "|__ "
depth = 0

compileObj = (obj, inApp = false, skipKeys = []) ->
  result = ""
  for k of obj
    if skipKeys.indexOf(k) != -1
      continue

    childObj = obj[k]
    childType = (typeof childObj)

    log recursion + k + " type: " + childType

    if ["number", "string", "function"].indexOf(childType) != -1
      if !inApp
        result += "var "

    if childType == "number"
      result += "#{k} = #{childObj};"

    if childType == "string"
      result += "#{k} = '#{childObj}';"

    if childType == "function"
      result += "#{k} = #{toSource childObj};"

    if childType == "undefined"
      result += "var #{k};"

    if childType == "object"
      if k == "app" and depth == 0
        recursion += recurseStr
        depth++
        result += "#{compileObj childObj, true}"
        depth--
        recursion = recursion.substring(0, recurseStr.length)
      else
        result += "var #{k} = #{toSource childObj};"

  return result

module.exports =
  class WebExporter extends BaseExporter

    compile: (options, callback) ->
      compiled = "(function() {#{compileObj @main}})();"
      if options.mode == COMPILER_MODE.development
        compiled = beautify(compiled, { indent_size: 2 })
      else
        attrs = { fromString: yes, compress: { global_defs: { platform: options.platform } } }
        compiled = UglifyJS.minify(compiled, attrs).code;

      fs.writeFile path.resolve(options.output, "main.js"), compiled, (err) ->
        throw err  if err
        callback()
        return
