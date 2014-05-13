mode = process.env.GRANNY_MODE or "release"

if mode == "debug"
  global.log = (msg) ->
    arguments_ = ['AppGranny >>']
    for arg in arguments
      arguments_.push arg

    console.log.apply console, arguments_
else
  global.log = -> # To the bitbucket!

global.COMPILER_MODE = {
  production: 'production'
  development: 'development'
}

Object.freeze(global.COMPILER_MODE)