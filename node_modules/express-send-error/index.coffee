_ = require 'lodash'

module.exports = (options={}) => (request, response, next) =>
  { logFn } = options
  logFn ?= _.noop
  response.sendError = (error) =>
    throw new Error('[express-send-error] sendError called without an error') unless error?
    try
      throw new Error error.message
    catch stackerror
      logFn stackerror.stack
      code = 500
      code = error.code if _.isNumber error.code
      return response.sendStatus code unless error.message?
      return response.status(code).send error: error.message
  next()
