NodeRSA = require 'node-rsa'
_       = require 'lodash'

class Encryption
  constructor: ({nodeRsa}) ->
    @key = nodeRsa

  toEnvironmentValue: =>
    @toDer()

  toDer: =>
    @key.exportKey('private-der').toString 'base64'

  toPublicEnvironmentValue: =>
    @toPublicDer()

  toPublicDer: =>
    @key.exportKey('public-der').toString 'base64'

  toOldEnvironmentValue: =>
    pem = @key.exportKey()
    new Buffer(pem).toString 'base64'

  toPublicOldEnvironmentValue: =>
    pem = @key.exportKey 'public'
    new Buffer(pem).toString 'base64'

  toPem: () =>
    @key.exportKey()

  toPublicPem: () =>
    @key.exportKey 'public'

  authToCode: ({uuid, token}) =>
    newAuth = "#{uuid}:#{token}"
    verifier =
      auth: newAuth
      signature: @sign newAuth

    return new Buffer(JSON.stringify(verifier)).toString('base64')

  codeToAuth: (code) =>
    {auth, signature} = JSON.parse(new Buffer(code, 'base64').toString())
    verified = @verify auth, signature
    [uuid, token] = auth.split ':'

    return {uuid, token, verified}

  encrypt: (options) =>
    @key.encrypt(JSON.stringify options).toString 'base64'

  decrypt: (options) =>
    decryptedOptions = JSON.parse @key.decrypt(options)

  sign: (options) =>
    optionsString = JSON.stringify(options)
    @key.sign(optionsString).toString 'base64'

  verify: (options, signature) =>
    optionsString = JSON.stringify options
    signatureBuffer = new Buffer signature, 'base64'

    @key.verify optionsString, signatureBuffer

  @fromPem: (pem) =>
    nodeRsa = new NodeRSA pem
    encryption = new Encryption {nodeRsa}

  @fromDer: (der) =>
    keyBinary = new Buffer der, 'base64'
    nodeRsa = new NodeRSA keyBinary, 'pkcs1-der'
    encryption = new Encryption {nodeRsa}

  @fromOldEnvironmentValue: (oldEnv) =>
    pem = new Buffer(oldEnv, 'base64').toString()
    Encryption.fromPem pem

  @fromEnvironmentValue: (env) =>
    Encryption.fromDer env

  @fromJustGuess: (thing) =>
    return new Encryption nodeRsa: thing if thing instanceof NodeRSA
    return Encryption.fromPem thing if Encryption.isPem thing
    return Encryption.fromOldEnvironmentValue thing if Encryption.isOldEnvironmentValue thing
    @fromDer thing

  @isPem: (thing) =>
    thing = _.trim thing
    _.startsWith(thing, '-----') && _.endsWith(thing, '-----')

  @isOldEnvironmentValue: (thing) =>
    thing = _.trim thing
    decoded = new Buffer(thing, 'base64').toString()
    @isPem decoded

module.exports = Encryption
