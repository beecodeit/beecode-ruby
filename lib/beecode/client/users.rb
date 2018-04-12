class Beecode::Client
  module Users
    # Errore 431 => request headers fields too large
    def authenticated_user
      response = check_response { authenticated_get('/v1/utente/profile') }
      parsed_response = JSON.parse(response.body)

      Beecode::Resource.new(parsed_response['result'])
    rescue JSON::ParserError
      raise Beecode::Error::InvalidResponse
    end

    def change_picture
      raise NoMethodError, 'this method is not implemented in this Gem. this is only a placeholder.'
    end
  end
end