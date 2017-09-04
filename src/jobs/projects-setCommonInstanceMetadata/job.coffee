###
need to create RESTapi call https://cloud.google.com/compute/docs/reference/latest/projects/setCommonInstanceMetadata
    POST /compute/v1/projects/tokeshi-net-izen/setCommonInstanceMetadata HTTP/1.1
    Host: www.googleapis.com
    Authorization: Bearer -token-
    Cache-Control: no-cache
    Postman-Token: -token
format is string/-name-of-GCP-project-

body
{
  "kind": "compute#metadata",
  "fingerprint": bytes,
  "items": [
    {
      "key": string,
      "value": string
    }
  ]
}

###

Github = require 'github'
http   = require 'http'
_      = require 'lodash'

class ListEventsByUser
  constructor: ({@encrypted}) ->
    @github = new Github
      debug: true
    @github.authenticate type: 'oauth', token: @encrypted.secrets.credentials.secret


  do: ({data}, callback) =>
    return callback @_userError(422, 'data.username is required') unless data.username?

    @github.activity.getEventsForUser {user: data.username}, (error, results) =>
      return callback error if error?
      return callback null, {
        metadata:
          code: 200
          status: http.STATUS_CODES[200]
        data: @_processResults results
      }

  _processResult: (result) =>
    {
      createdAt:   result.created_at
      description: result.payload.description
      type:        result.type
      username:    result.actor.display_login
    }

  _processResults: (results) =>
    _.map results, @_processResult

  _userError: (code, message) =>
    error = new Error message
    error.code = code
    return error

module.exports = ListEventsByUser
