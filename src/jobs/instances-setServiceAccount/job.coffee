###
need to create RESTapi call
    POST /compute/v1/projects/tokeshi-net-izen/zones/europe-west1-d/instances/instance-1/setServiceAccount HTTP/1.1
    Host: www.googleapis.com
    Authorization: Bearer -token-
    Cache-Control: no-cache
    Postman-Token: -token-

format is GET https://www.googleapis.com/compute/v1/projects/-name-of-GCP-project-/zones/-name-of-GCP-zone/instances/instance-1/setServiceAccount

https://cloud.google.com/compute/docs/reference/latest/instances/setServiceAccount
{
  "email": string,
  "scopes": [
    string
  ]
}
###


http   = require 'http'
_      = require 'lodash'
GcpRequest = require '../../gcp-request'

class ProjectsGet
  constructor: ({@encrypted}) ->
    accessToken = @encrypted.secrets.credentials.secret
    @gcpRequest = new GcpRequest accessToken

  do: ({data}, callback) =>
    return callback @_userError(422, 'data.projectname is required') unless data.projectname?

    path = "compute/v1/projects/#{data.projectname}"
    @gcpRequest.request 'GET', path, null, null, (error, code, results) =>
      return callback error if error?
      return callback null, {
        metadata:
          code: code
          status: http.STATUS_CODES[code]
        data: results
      }

  _userError: (code, message) =>
    error = new Error message
    error.code = code
    return error

module.exports = ProjectsGet
