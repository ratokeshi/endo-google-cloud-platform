_ = require 'lodash'
dashdash = require 'dashdash'
Encryption = require '.'
fs = require 'fs'

getCommands = (thing, prefix) ->
  _.chain(thing)
    .keys()
    .filter (key) => _.startsWith key, prefix
    .map (command) => _.kebabCase _.trimLeft command, prefix
    .value()

getFromCommands = ->
  getCommands Encryption, 'from'

getToCommands = ->
  getCommands Encryption.prototype, 'to'

getEncryptionFromCommand = (fromCommand, value) ->
  fromFunction = "from#{_.capitalize _.camelCase fromCommand}"
  Encryption[fromFunction] value

runToCommand = (toCommand, encryption) ->
  toFunction = "to#{_.capitalize _.camelCase toCommand}"
  encryption[toFunction]()

fromCommands = getFromCommands()
toCommands   =  getToCommands()

[..., from, to, file] = process.argv

return console.log "must be from", fromCommands unless from in fromCommands
return console.log "must be to", toCommands unless to in toCommands
value = fs.readFileSync file, 'utf8'

encryption = getEncryptionFromCommand from, value
result = runToCommand to, encryption
console.log result
