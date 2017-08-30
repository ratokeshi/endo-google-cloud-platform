_ = require 'lodash'
fs = require 'fs'

class MeshbluConfig
  constructor: (@auth={}, options={}, dependencies={}) ->
    @env ?= dependencies.env ? process.env
    @filename = options.filename ? './meshblu.json'

    @uuid_env_name = options.uuid_env_name ? 'MESHBLU_UUID'
    @token_env_name = options.token_env_name ? 'MESHBLU_TOKEN'

    @protocol_env_name = options.protocol_env_name ? 'MESHBLU_PROTOCOL'
    @hostname_env_name = options.hostname_env_name ? 'MESHBLU_HOSTNAME'
    @port_env_name = options.port_env_name ? 'MESHBLU_PORT'

    @service_env_name = options.service_env_name ? 'MESHBLU_SERVICE'
    @domain_env_name  = options.domain_env_name  ? 'MESHBLU_DOMAIN'
    @secure_env_name  = options.secure_env_name  ? 'MESHBLU_SECURE'

    @private_key_env_name = options.private_key_env_name ? 'MESHBLU_PRIVATE_KEY'
    @resolve_srv_env_name = options.private_key_env_name ? 'MESHBLU_RESOLVE_SRV'

  parseMeshbluJSON: ->
    JSON.parse fs.readFileSync @filename

  toJSON: =>
    try meshbluJSON = @parseMeshbluJSON()

    meshbluJSON = _.defaults @auth, {
      uuid:  @env[@uuid_env_name]
      token: @env[@token_env_name]

      protocol: @env[@protocol_env_name]
      hostname: @env[@hostname_env_name]
      port:     @env[@port_env_name]

      service: @env[@service_env_name]
      domain:  @env[@domain_env_name]
      secure:  @env[@secure_env_name] && @env[@secure_env_name] != 'false'

      privateKey: @env[@private_key_env_name]
      resolveSrv: @env[@resolve_srv_env_name] && @env[@resolve_srv_env_name] == 'true'
    }, meshbluJSON

    return @compact meshbluJSON

  compact: (obj) =>
    compactedObj = {}

    _.each obj, (value, key) =>
      compactedObj[key] = value if value?
      compactedObj[key] = value.trim() if value?.trim?

    compactedObj

module.exports = MeshbluConfig
