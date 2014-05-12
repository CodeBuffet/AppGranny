#! /usr/bin/env coffee
###

app-granny
https://github.com/CodeBuffet/AppGranny

Copyright (c) 2014 Peter Wilemsen
Licensed under the GPLv2 license.

###

'use strict'

# parse command line
opt = require("node-getopt").create([
  [
    "c"
    "create"
    "Create a new project"
  ]
  [
    "o"
    "output"
    "Specifies output directory. If not exists, it will be created."
  ]
  [
    "h"
    "help"
    "Display this help"
  ]
]).setHelp(
    "Usage: granny [OPTION]\n" +
    "App Granny - Cross platform client-side backends!\n" +
    "\n" +
    "[[OPTIONS]]\n" +
    "\n" +
    "Installation: npm install app-granny\n" +
    "Repository:  https://github.com/CodeBuffet/AppGranny"
).bindHelp().parseSystem()
console.info opt