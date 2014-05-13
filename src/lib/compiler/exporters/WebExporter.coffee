BaseExporter = require("./BaseExporter")
fs = require "fs"
path = require "path"
UglifyJS = require("uglify-js")
beautify = require('js-beautify').js_beautify
jsCompile = require("../js-compiler")

module.exports =
  class WebExporter extends BaseExporter

    compile: (options, callback) ->
      compiled = jsCompile @main
      if options.mode == COMPILER_MODE.development
        compiled = beautify(compiled, { indent_size: 2 })
      else
        attrs = { fromString: yes, compress: { global_defs: { platform: options.platform } } }
        compiled = UglifyJS.minify(compiled, attrs).code;

      fs.writeFile path.resolve(options.output, "main.js"), compiled, (err) ->
        throw err  if err
        callback()
        return
