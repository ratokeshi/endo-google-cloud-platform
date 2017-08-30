fs         = require 'fs'
Encryption = require '..'

pem                   = fs.readFileSync './test/data/test-key.pem', 'utf8'
testEncryptedOptions  = fs.readFileSync './test/data/encrypted-options.txt', 'utf8'

describe 'Encryption', ->
  it 'should exist', ->
    expect(Encryption).to.exist

  describe 'Encryption.fromPem', ->

    context 'when given a pem file', ->
      beforeEach ->
        @sut = Encryption.fromPem pem

      context '->decryptOptions', ->
        beforeEach ->
          @decryptedOptions = @sut.decryptOptions testEncryptedOptions

        it 'should decrypt the encrypted file noooo problem', ->
          expect(@decryptedOptions).to.deep.equal 'this-is-secret': 'omg-so-secret'

      context '->encryptOptions', ->
        beforeEach ->
          @encryptedOptions = @sut.encryptOptions 'yet-another-secret': 'you-must-have-a-lot-to-hide'

        it 'should be able to decrypt the encryptedOptions back to the original object', ->
          decryptedOptions = @sut.decryptOptions @encryptedOptions
          expect(decryptedOptions).to.deep.equal 'yet-another-secret': 'you-must-have-a-lot-to-hide'
          
