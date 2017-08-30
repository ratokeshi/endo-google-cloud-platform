fs         = require 'fs'
Encryption = require '..'

pem           = fs.readFileSync './test/data/test-key.pem', 'utf8'
encryptedText = fs.readFileSync './test/data/encrypted.txt', 'utf8'

describe 'Encryption', ->
  it 'should exist', ->
    expect(Encryption).to.exist

  describe 'Encryption.fromPem', ->

    context 'when given a pem file', ->
      beforeEach ->
        @sut = Encryption.fromPem pem

      context '->decrypt', ->
        beforeEach ->
          @decrypted = @sut.decrypt encryptedText

        it 'should decrypt the encrypted file noooo problem', ->
          expect(@decrypted).to.deep.equal 'yet-another-secret': 'you-must-have-a-lot-to-hide'

      context '->encrypt', ->
        beforeEach ->
          @encrypted = @sut.encrypt 'yet-another-secret': 'you-must-have-a-lot-to-hide'

        it 'should be able to decrypt the encrypted back to the original object', ->
          expect(@sut.decrypt @encrypted).to.deep.equal 'yet-another-secret': 'you-must-have-a-lot-to-hide'
