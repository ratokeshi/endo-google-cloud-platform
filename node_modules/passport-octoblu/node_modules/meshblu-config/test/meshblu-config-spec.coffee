path = require 'path'
_    = require 'lodash'
MeshbluConfig = require '../lib/meshblu-config'

describe 'MeshbluConfig', ->
  describe 'toJSON->', ->
    describe 'passing in a filename', ->
      beforeEach ->
        @sut = new MeshbluConfig filename: path.join(__dirname, 'sample-meshblu.json')
        @result = @sut.toJSON()

      it 'should set the hostname', ->
        expect(@result.hostname).to.deep.equal 'localhost'

      it 'should set the server', ->
        expect(@result.server).to.deep.equal 'localhost'

      it 'should set the port', ->
        expect(@result.port).to.deep.equal '3000'

      it 'should set the host', ->
        expect(@result.host).to.deep.equal 'localhost:3000'

    describe 'passing in a file with no protocol', ->
      beforeEach ->
        @sut = new MeshbluConfig filename: path.join(__dirname, 'no-protocol-meshblu.json')
        @result = @sut.toJSON()

      it 'should not set the protocol', ->
        expect(@result.protocol).not.to.exist
        expect(@result).not.to.have.key 'protocol'
