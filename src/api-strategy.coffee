_ = require 'lodash'
PassportGoogleCloudPlatform = require 'passport-google-oauth2'

class GoogleCloudPlatformStrategy extends PassportGoogleCloudPlatform
  constructor: (env) ->
    throw new Error('Missing required environment variable: ENDO_GOOGLE_CLOUD_PLATFORM_GOOGLE_CLOUD_PLATFORM_CLIENT_ID')     if _.isEmpty process.env.ENDO_GOOGLE_CLOUD_PLATFORM_GOOGLE_CLOUD_PLATFORM_CLIENT_ID
    throw new Error('Missing required environment variable: ENDO_GOOGLE_CLOUD_PLATFORM_GOOGLE_CLOUD_PLATFORM_CLIENT_SECRET') if _.isEmpty process.env.ENDO_GOOGLE_CLOUD_PLATFORM_GOOGLE_CLOUD_PLATFORM_CLIENT_SECRET
    throw new Error('Missing required environment variable: ENDO_GOOGLE_CLOUD_PLATFORM_GOOGLE_CLOUD_PLATFORM_CALLBACK_URL')  if _.isEmpty process.env.ENDO_GOOGLE_CLOUD_PLATFORM_GOOGLE_CLOUD_PLATFORM_CALLBACK_URL

    options = {
      clientID:     process.env.ENDO_GOOGLE_CLOUD_PLATFORM_GOOGLE_CLOUD_PLATFORM_CLIENT_ID
      clientSecret: process.env.ENDO_GOOGLE_CLOUD_PLATFORM_GOOGLE_CLOUD_PLATFORM_CLIENT_SECRET
      callbackURL:  process.env.ENDO_GOOGLE_CLOUD_PLATFORM_GOOGLE_CLOUD_PLATFORM_CALLBACK_URL
      scope:        ['https://www.googleapis.com/auth/cloud-platform', 'https://www.googleapis.com/auth/userinfo.profile']
    }

    super options, @onAuthorization

  onAuthorization: (accessToken, refreshToken, profile, callback) =>
    callback null, {
      id: profile.id
      username: profile.username
      secrets:
        credentials:
          secret: accessToken
          refreshToken: refreshToken
    }

module.exports = GoogleCloudPlatformStrategy
