BaseExporter = require("./BaseExporter")
fs = require "fs"
path = require "path"
UglifyJS = require("uglify-js")
beautify = require('js-beautify').js_beautify
jsCompile = require("../js-compiler")
mkdirp = require('mkdirp')
async = require 'async'
toSource = require('tosource')

recursion = ""
recurseStr = "|__ "
depth = 0

generateBindings = (obj, skipKeys = []) ->
  result = ""
  keys = Object.keys(obj)
  keys.sort()
  log keys
  for k in keys
    if skipKeys.indexOf(k) != -1
      continue

    childObj = obj[k]
    childType = (typeof childObj)

    log recursion + k + " type: " + childType

    if childType == "number"
      result += "public static int #{k} = #{childObj};"

    if childType == "string"
      result += "#{k} = '#{childObj}';"

    if childType == "function"
      result +=
        result += "#{k} = #{toSource childObj};"

    if childType == "undefined"
      result += "#{k};"

    if childType == "object"
      result += "#{k} = #{toSource childObj};"


  return result

module.exports =
  class AndroidJavaExporter extends BaseExporter

    compile: (options, callback) ->
      compiled = jsCompile @main
      if options.mode == COMPILER_MODE.development
        compiled = beautify(compiled, { indent_size: 2 })
      else
        attrs = { fromString: yes, compress: { global_defs: { platform: options.platform } } }
        compiled = UglifyJS.minify(compiled, attrs).code;

      packageFolder = path.resolve(options.output, "org", "appgranny")

      async.series [
        (callback) ->
          mkdirp packageFolder, (err) ->
            callback(err, null)

        (callback) =>

          bindings = generateBindings @main.app
          bindings = """
package org.appgranny;
public class App
{
  #{bindings}
}
"""

          fs.writeFile path.resolve(packageFolder, "App.java"), bindings, (err) ->
            callback(err, null)

        (callback) ->
          fs.writeFile path.resolve(options.output, "main.js"), compiled, (err) ->
            callback(err, null)

      ], (err, results) ->

        log "Android export finished: ", results, err