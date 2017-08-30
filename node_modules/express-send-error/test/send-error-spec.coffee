httpMocks = require 'node-mocks-http'
SendError = require '../'

describe 'SendError', ->
  beforeEach ->
    @consoleError = sinon.spy()
    @sut = SendError(logFn: @consoleError)

  describe 'called with a request response', ->
    beforeEach (done) ->
      @request = null
      @response = httpMocks.createResponse()
      @sut @request, @response, done

    it 'should add the sendError method to the response object', ->
      expect(@response.sendError).to.be.a 'function'

    describe 'when the sendError function is called with a generic error', ->
      beforeEach ->
        @response.sendError new Error 'random error'

      it 'should yield a 500 and the message', ->
        expect(@response.statusCode).to.equal 500
        expect(@response._getData()).to.deep.equal error: 'random error'

      it 'should log the error', ->
        expect(@consoleError).to.have.been.called

    describe 'when the sendError function is called with a error with status', ->
      beforeEach ->
        error = new Error 'its a 123 error'
        error.code = 123
        @response.sendError error

      it 'should yield a 123 and the message', ->
        expect(@response.statusCode).to.equal 123
        expect(@response._getData()).to.deep.equal error: 'its a 123 error'

      it 'should log the error', ->
        expect(@consoleError).to.have.been.called

    describe 'when the sendError function is called without an', ->
      it 'should throw an exception', ->
        expect(=> @response.sendError null).to.throw '[express-send-error] sendError called without an error'
