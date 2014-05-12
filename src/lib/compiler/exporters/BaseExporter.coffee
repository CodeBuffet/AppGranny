module.exports =
  class BaseExporter
      constructor: (@main) ->

      compile: (options, callback) ->

        throw new Error("Dont call BaseExporter.compile directly!")