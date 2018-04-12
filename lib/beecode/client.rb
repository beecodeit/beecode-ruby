module Beecode
  class Client
    Dir[File.expand_path('../client/*.rb', __FILE__)].each { |f| require f }

    include Campaigns
    include Rates
    include Tickets
    include Users
    include Utils

    def initialize
      @authenticated = false
      @urls = Beecode::URL.new
    end

    def authenticate!
      authenticated! if obtain_auth_code && obtain_access_code
      self
    end

    def refresh!
      if obtain_access_code(true)
        authenticated!
      end

      self
    end

    private

    def get(path, headers = {})
      RestClient.get(@urls.build(path), headers)
    end

    def authenticated_get(path, headers = {})
      raise(Beecode::Error::AuthenticationFailed, 'the client is not authenticated') unless @authenticated
      headers.merge(config.base_headers)
      get(path, headers)
    end

    def post(path, payload, headers = {})
      RestClient.post(@urls.build(path), payload, headers)
    end

    def authenticated_post(path, payload, headers = {})
      raise(Beecode::Error::AuthenticationFailed, 'the client is not authenticated') unless @authenticated
      headers.merge(config.base_headers)
      post(path, payload, headers)
    end

    def check_response(&block)
      block.call
    rescue RestClient::BadRequest => e
      not_authenticated!
      raise Beecode::Error::BadRequest, e.message
    rescue RestClient::Unauthorized => e
      not_authenticated!
      raise Beecode::Error::Unauthorized, e.message
    rescue RestClient::Forbidden => e
      not_authenticated!
      raise Beecode::Error::Forbidden, e.message
    rescue RestClient::NotFound => e
      not_authenticated!
      raise Beecode::Error::NotFound, e.message
    rescue RestClient::MethodNotAllowed => e
      not_authenticated!
      raise Beecode::Error::MethodNotAllowed, e.message
    rescue RestClient::InternalServerError => e
      not_authenticated!
      raise Beecode::Error::InternalServerError, e.message
    rescue RestClient::ServiceUnavailable => e
      not_authenticated!
      raise Beecode::Error::ServiceUnavailable, e.message
    end

    def authenticated!
      @authenticated = true
    end

    def not_authenticated!
      @authenticated = false
    end

    def obtain_auth_code
      auth_resp = check_response {
        post('/v1/oauth/login', config.auth_token_params)
      }

      config.auth_token = extract_auth_token(auth_resp)

      if config.auth_token.nil?
        not_authenticated!
        raise Beecode::Error::AuthenticationFailed,
              'impossible to obtain the authentication token'
      end

      config.auth_token
    end

    def obtain_access_code(refresh = false)
      access_resp = check_response {
        if refresh
          post('/v1/oauth/refresh', config.refresh_token_params)
        else
          post('/v1/oauth/token', config.access_token_params)
        end
      }

      config.api_tokens = extract_access_tokens(access_resp)

      if config.api_tokens.nil?
        not_authenticated!
        raise Beecode::Error::AuthenticationFailed,
              'impossible to obtain the access token'
      end

      config.api_tokens
    end

    def extract_auth_token(response)
      json_resp = JSON.parse(response.body)
      json_resp['result'] && json_resp['result']['auth_token']
    rescue JSON::ParserError
      nil
    end

    def extract_access_tokens(response)
      json_resp = JSON.parse(response.body)
      Beecode::APITokens.from_json(json_resp)
    rescue JSON::ParserError
      nil
    end

    def config
      Beecode::API.configuration
    end
  end
end