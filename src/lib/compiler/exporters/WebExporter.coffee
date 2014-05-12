BaseExporter = require("./BaseExporter")
toSource = require('tosource')
fs = require "fs"
path = require "path"

module.exports =
  class WebExporter extends BaseExporter

    compile: (options, callback) ->
      # Put app: manually in here because we dont want to export other stuff in @main
      compiled = "window.app = #{toSource @main.app}"
      fs.writeFile path.resolve(options.output, "main.js"), compiled, (err) ->
        throw err  if err
        callback()
        return
