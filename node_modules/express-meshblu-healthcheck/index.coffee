module.exports = ->
  middleware = (request, response, next) ->
    if request.path == '/healthcheck'
      return response.send online: true
      
    next()

  middleware
