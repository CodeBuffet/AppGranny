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

module.exports = (sandbox) -> return "(function() {#{compileObj sandbox}})();"