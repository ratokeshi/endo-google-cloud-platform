###
need to create RESTapi call
    POST /compute/v1/projects/tokeshi-net-izen/zones/europe-west1-d/instances/instance-1 HTTP/1.1
    Host: www.googleapis.com
    Authorization: Bearer -token-
    Cache-Control: no-cache
    Postman-Token: -token-

format is GET https://www.googleapis.com/compute/v1/projects/-name-of-GCP-project-/zones/-name-of-GCP-zone/instances/instance-1

https://cloud.google.com/compute/docs/reference/latest/instances/insert#examples


###


http   = require 'http'
_      = require 'lodash'
GcpRequest = require '../../gcp-request'

class InstancesInsert
  constructor: ({@encrypted}) ->
    accessToken = @encrypted.secrets.credentials.secret
    @gcpRequest = new GcpRequest accessToken

  do: ({data}, callback) =>
    return callback @_userError(422, 'data.projectname is required') unless data.projectname?

#   only needed for network creation in an insterted instancename
    zone = data.zonename
    zonenetwork = zone
    zonenetwork = zonenetwork.substr(0, zone?.length - 2)

    body = {
      "name": "#{data.instancename}",
      "machineType": "projects/tokeshi-net-izen/zones/#{data.zonename}/machineTypes/f1-micro",
      "disks": [
        {
          "type": "PERSISTENT",
          "boot": true,
          "mode": "READ_WRITE",
          "autoDelete": true,
          "deviceName": "instance-500",
          "initializeParams": {
            "sourceImage": "projects/debian-cloud/global/images/debian-9-stretch-v20170829",
            "diskType": "projects/tokeshi-net-izen/zones/#{data.zonename}/diskTypes/pd-standard",
            "diskSizeGb": "10"
          }
        }
      ],
      "networkInterfaces": [
        {
          "network": "projects/tokeshi-net-izen/global/networks/default",
          "subnetwork": "projects/tokeshi-net-izen/regions/#{zonenetwork}/subnetworks/default",
          "accessConfigs": [
            {
              "name": "External NAT",
              "type": "ONE_TO_ONE_NAT"
            }
          ],
          "aliasIpRanges": []
        }
      ]
    }

    path = "compute/v1/projects/#{data.projectname}/zones/#{data.zonename}/instances"
    @gcpRequest.request 'POST', path, null, body, (error, code, results) =>
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

module.exports = InstancesInsert
