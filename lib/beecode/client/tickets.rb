class Beecode::Client
  module Tickets
    def Tickets(campaign_id)
      response = check_response do
        authenticated_get('/v1/ticket/list',
                          { params: { id: campaign_id } })
      end

      parsed_response = JSON.parse(response.body)

      Beecode::Resource.wrap(parsed_response['result'])
    rescue JSON::ParserError
      raise Beecode::Error::InvalidResponse
    end

    def add_guest(email, beecode, quantity)
      payload = build_guest_payload(email, beecode, quantity)

      response = check_response { authenticated_post('/v1/ticket/addGuest', payload) }
      parsed_response = JSON.parse(response.body)

      Beecode::Resource.new(parsed_response['result'])
    rescue JSON::ParserError
      raise Beecode::Error::InvalidResponse
    end

    def show_ticket(ticket_id)
      response = check_response do
        authenticated_get('/v1/ticket/single',
                          { params: { id: ticket_id } })
      end

      parsed_response = JSON.parse(response.body)

      Beecode::Resource.wrap(parsed_response['result'])
    end

    def show_ticket_from_code(beecode)
      response = check_response do
        authenticated_get('/v1/ticket/single',
                          { params: { code: beecode } })
      end

      parsed_response = JSON.parse(response.body)

      Beecode::Resource.wrap(parsed_response['result'])
    end

    def ticket_checkin(ticket_code, read_code)
      payload = { code: ticket_code, code_letto: read_code }
      response = check_response { authenticated_post('/v1/ticket/check', payload) }
      parsed_response = JSON.parse(response.body)

      Beecode::Resource.new(parsed_response['result'])
    rescue JSON::ParserError
      raise Beecode::Error::InvalidResponse
    end

    def update_checkin(checkin_id, code, quantity)
      payload = { idingress: checkin_id, code: code, quantity: quantity }
      response = check_response { authenticated_post('/v1/ticket/updateingress', payload) }
      parsed_response = JSON.parse(response.body)

      Beecode::Resource.new(parsed_response['result'])
    rescue JSON::ParserError
      raise Beecode::Error::InvalidResponse
    end

    def build_guest_payload(email, beecode, quantity)
      {
        email: email,
        code: beecode,
        quantity: quantity.select { |h,k| h.is_a?(Fixnum) && k.is_a?(Fixnum) }
      }
    end
  end
end