#! /usr/bin/env coffee
###

app-granny
https://github.com/CodeBuffet/AppGranny

Copyright (c) 2014 Peter Wilemsen
Licensed under the GPLv2 license.

###

'use strict'

globals = require "../globals"
fs = require "fs"
path = require "path"
vm = require('vm')
mkdirp = require('mkdirp')
extend = require "extend"

# parse command line
opt = require("node-getopt").create([
  [
    "p"
    "platform=PLATFORM"
    "Compiles code to platform"
  ]
  [
    "i"
    "input=INPUT"
    "Specifies input AppGranny project-directory."
  ]
  [
    "o"
    "output=OUTPUT"
    "Specifies output directory. If not exists, it will be created."
  ]
  [
    "m"
    "mode=MODE"
    "Specifies mode, defaults to development, can be either development or production, when in production mode, more stripping will be done"
  ]
  [
    "h"
    "help"
    "Display this help"
  ]
]).setHelp(
    "Usage: grannyc [OPTION]\n" +
    "App Granny - Cross platform client-side backends!\n" +
    "\n" +
    "[[OPTIONS]]\n" +
    "\n" +
    "Installation: npm install app-granny\n" +
    "Repository:  https://github.com/CodeBuffet/AppGranny"
).bindHelp().parseSystem()

exporters = {
  web: "WebExporter"
}

compile = (options) ->
  inputFolder = path.resolve(opt.options.input)
  outputFolder = path.resolve(opt.options.output)

  mkdirp outputFolder, (err) ->
    if err
      console.error err
    else
      log "Compiling #{inputFolder}"
      mainFile = path.resolve(inputFolder, "main.js")
      log "executing mainFile: #{mainFile}"

      sandbox = {}
      sandbox.Granny = {
        platform: options.platform
      }
      Object.freeze sandbox.Granny

      fs.readFile(mainFile, (err, data) ->
        data = data.toString()
        vm.runInNewContext(data, sandbox)
        log "Sandbox: ", sandbox
        exporter = require("./exporters/#{exporters[options.platform]}")
        if exporter?
          callback = ->
            log "Compilation finished!"

          new exporter(sandbox).compile(options, callback)
      )

#if opt.options.output and opt.options.input and opt.options.platform
opt.options = extend({
  mode: COMPILER_MODE.development
}, opt.options)

log "options: ", opt.options
compile(opt.options)