class Beecode::Client
  module Utils
    def translations(lang = 'it')
      response = check_response { authenticated_get('/v1/lingua/label', params: { lang: lang }) }
      parsed_response = JSON.parse(response.body)
      puts parsed_response

      Beecode::Resource.new(parsed_response['result'])
    rescue JSON::ParserError
      raise Beecode::Error::InvalidResponse
    end
  end
end