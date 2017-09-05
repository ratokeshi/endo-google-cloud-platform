request = require 'request'

class GcpRequest
  constructor: (access_token) ->
    @access_token = access_token
    @_request = request.defaults {
      baseUrl: 'https://www.googleapis.com/'
      auth:
        bearer: access_token
      json: true
    }

  request: (method, path, qs, body, callback) =>
    options = {
      uri: path
      method: method
    }

    options.qs = qs if qs?
    options.json = body if body?

    @_request options, (error, res, body) =>
      callback error, res.statusCode, body

module.exports = GcpRequest
