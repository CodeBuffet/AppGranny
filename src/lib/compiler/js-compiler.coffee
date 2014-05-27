toSource = require('tosource')

recursion = ""
recurseStr = "|__ "
depth = 0

compileObj = (obj, inApp = false, skipKeys = []) ->
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

    if !inApp and k != "app"
      result += "var "

    if childType == "number"
      result += "#{k} = #{childObj};"

    if childType == "string"
      result += "#{k} = '#{childObj}';"

    if childType == "function"
      result += "#{k} = #{toSource childObj};"
      for k2 of childObj.prototype
        result += "#{k}.prototype.#{k2} = #{toSource childObj.prototype[k2]}"

    if childType == "undefined"
      result += "#{k};"

    if childType == "object"
      if k == "app" and depth == 0
        recursion += recurseStr
        depth++
        result += "#{compileObj childObj, true}"
        depth--
        recursion = recursion.substring(0, recurseStr.length)
      else
        result += "#{k} = #{toSource childObj};"
        #Todo, fix prototypes here

  return result

module.exports = (sandbox) -> return "(function() {#{compileObj sandbox}})();"