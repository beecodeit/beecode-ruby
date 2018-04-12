module Beecode
  class API
    class << self
      attr_accessor :configuration
    end

    def self.configure
      self.configuration ||= Configuration.new
      yield(configuration)

      configuration
    end

    class Configuration
      attr_accessor :client_id, :client_secret, :username, :password,
                    :auth_token, :api_tokens, :sandbox, :validate_input

      def initialize
        @api_tokens = Beecode::APITokens.new(
          access_token: '',
          refresh_token: '',
          expires_at: Time.now
        )
      end

      def base_headers
        return {} if @api_tokens.access_token == ''
        { 'Authorization' => "Bearer #{@api_tokens.access_token}" }
      end

      def auth_token_params
        client_params('response_type': 'code',
                      'username': @username,
                      'password': @password,
                      'state': 'nope')
      end

      def access_token_params
        client_params('grant_type': 'authorization_code',
                      'code': @auth_token)
      end

      def refresh_token_params
        client_params('grant_type': 'refresh_token',
                      'refresh_token': @api_tokens.refresh_token)
      end

      def client_params(params = {})
        { 'client_id': @client_id, 'client_secret': @client_secret }.merge(params)
      end
    end
  end
end