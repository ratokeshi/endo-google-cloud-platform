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

    body = JSON.stringify({
  "name": "instance-4",
  "zone": "projects/tokeshi-net-izen/zones/us-central1-f",
  "machineType": "projects/tokeshi-net-izen/zones/us-central1-f/machineTypes/f1-micro",
  "metadata": {
    "items": []
  },
  "tags": {
    "items": []
  },
  "disks": [
    {
      "type": "PERSISTENT",
      "boot": true,
      "mode": "READ_WRITE",
      "autoDelete": true,
      "deviceName": "instance-4",
      "initializeParams": {
        "sourceImage": "projects/debian-cloud/global/images/debian-9-stretch-v20170829",
        "diskType": "projects/tokeshi-net-izen/zones/us-central1-f/diskTypes/pd-standard",
        "diskSizeGb": "10"
      }
    }
  ],
  "canIpForward": false,
  "networkInterfaces": [
    {
      "network": "projects/tokeshi-net-izen/global/networks/default",
      "subnetwork": "projects/tokeshi-net-izen/regions/us-central1/subnetworks/default",
      "accessConfigs": [
        {
          "name": "External NAT",
          "type": "ONE_TO_ONE_NAT"
        }
      ],
      "aliasIpRanges": []
    }
  ],
  "description": "",
  "labels": {},
  "scheduling": {
    "preemptible": false,
    "onHostMaintenance": "MIGRATE",
    "automaticRestart": true
  },
  "serviceAccounts": [
    {
      "email": "855419811239-compute@developer.gserviceaccount.com",
      "scopes": [
        "https://www.googleapis.com/auth/devstorage.read_only",
        "https://www.googleapis.com/auth/logging.write",
        "https://www.googleapis.com/auth/monitoring.write",
        "https://www.googleapis.com/auth/servicecontrol",
        "https://www.googleapis.com/auth/service.management.readonly",
        "https://www.googleapis.com/auth/trace.append"
      ]
    }
  ]
})

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
