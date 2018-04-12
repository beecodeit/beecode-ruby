require_relative 'errors'

module Beecode
  class APITokens
    attr_reader :expire_at

    TOKEN_KEYS = %w(access_token expires_in refresh_token)

    def self.from_json(input = {})
      return nil if input['result'].nil?
      __validate_result(input['result'])
    end

    def initialize(access_token:, expires_at:, refresh_token:)
      @access_token = access_token
      @expires_at = expires_at
      @refresh_token = refresh_token
    end

    def access_token
      raise Beecode::Error::ExpiredToken if Time.now >= @expires_at
      @access_token
    end

    def refresh_token
      raise Beecode::Error::ExpiredToken if Time.now >= @expires_at
      @access_token
    end

    private

    def self.__validate_result(result = {})
      key_set = TOKEN_KEYS - (result.keys & TOKEN_KEYS)
      puts(key_set)
      return nil unless key_set.empty?

      self.new(
        access_token: result['access_token'],
        refresh_token: result['refresh_token'],
        expires_at: Time.now + result['expires_in']
      )
    end
  end
end