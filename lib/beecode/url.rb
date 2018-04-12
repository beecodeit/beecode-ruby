module Beecode
  class URL
    attr_accessor :auth_token, :access_token, :refresh_token

    def initialize
      @beecode_api_url = if Beecode::API.configuration.sandbox
                           'https://sandbox.beecode.it'
                         else
                           'https://api.beecode.it'
                         end
    end

    def build(path)
      "#{@beecode_api_url}#{path}"
    end
  end
end