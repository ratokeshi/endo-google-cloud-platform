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
https  = require 'https'
google = require 'googleapis'
compute = google.compute('v1')

#GcpRequest = require '../../gcp-request.coffee' #new module from gcp-request.coffee
###
#from google api
authorize (authClient) ->
  request =
    project: 'tokeshi-net-izen'
    auth: authClient
  compute.projects.get request, (err, response) ->
    if err
      console.log err
      return


    # TODO: Change code below to process the `response` object:
    console.log JSON.stringify(response, null, 2)
    return
  return
###
class GetProject
  constructor: ({@encrypted}) ->
    @github = new Github
      debug: true
    @github.authenticate type: 'oauth', token: @encrypted.secrets.credentials.secret
#adding call to GcpRequest module above
# also not sure about what is required from automated github references from generator-endo
    @googlecloudplatform = new GcpRequest
    @googlecloudplatform.authenticate type: 'oauth', token: @encrypted.secrets.credentials.secret



  do: ({data}, callback) =>
    return callback @_userError(422, 'data.projectname is required') unless data.projectname?

#raw http get request



    @github.activity.getEventsForUser {user: data.projectname}, (error, results) =>
      return callback error if error?
      return callback null, {
        metadata:
          code: 200
          status: http.STATUS_CODES[200]
        data: @_processResults results
      }

###
    @googlecloudplatform.request 'GET', "/compute/v1/projects/#{data.projectname}", null, null, (error, body) =>
      return callback error if error?
      return callback null, {
        metadata:
          code: 200
          status: http.STATUS_CODES[200]
        data: @_processResults results
      }
###
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

module.exports = GetProject
