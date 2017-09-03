Github = require 'github'
http   = require 'http'
_      = require 'lodash'

class ListEventsByUser
  constructor: ({@encrypted}) ->
    @github = new Github
      debug: true
    @github.authenticate type: 'oauth', token: @encrypted.secrets.credentials.secret


  do: ({data}, callback) =>
    return callback @_userError(422, 'data.projectname is required') unless data.projectname?

    @github.activity.getEventsForUser {user: data.projectname}, (error, results) =>
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
