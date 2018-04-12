class Beecode::Client
  module Prices
    def campaign_prices(campaign_id)
      response = check_response do
        authenticated_get('/v1/tariffa/list',
                          { params: { idcontent: campaign_id } })
      end

      parsed_response = JSON.parse(response.body)

      Beecode::Resource.wrap(parsed_response['result'])
    rescue JSON::ParserError
      raise Beecode::Error::InvalidResponse
    end

    def create_price(campaign_id, name, payment_type, gender, quantity, slot)
      payload = build_new_price_payload(nil, campaign_id, name, payment_type, gender, quantity, slot)

      response = check_response { authenticated_post('/v1/tariffa/create', payload) }
      parsed_response = JSON.parse(response.body)

      Beecode::Resource.new(parsed_response['result'])
    rescue JSON::ParserError
      raise Beecode::Error::InvalidResponse
    end

    def modify_price(price_id, name, payment_type, gender, quantity, slot)
      payload = build_new_price_payload(price_id, nil, name, payment_type, gender, quantity, slot)

      response = check_response { authenticated_post('/v1/tariffa/update', payload) }
      parsed_response = JSON.parse(response.body)

      Beecode::Resource.new(parsed_response['result'])
    rescue JSON::ParserError
      raise Beecode::Error::InvalidResponse
    end

    def enable_price(price_id)
      response = check_response { authenticated_post('/v1/tariffa/enable', { id: price_id }) }
      parsed_response = JSON.parse(response.body)

      Beecode::Resource.new(parsed_response['result'])
    rescue JSON::ParserError
      raise Beecode::Error::InvalidResponse
    end

    def disable_price(price_id)
      response = check_response { authenticated_post('/v1/tariffa/disable', { id: price_id }) }
      parsed_response = JSON.parse(response.body)

      Beecode::Resource.new(parsed_response['result'])
    rescue JSON::ParserError
      raise Beecode::Error::InvalidResponse
    end

    def build_new_price_payload(price_id, campaign_id, name, payment_type, gender, quantity, slot)
      params = {
        id: price_id,
        idcontent: campaign_id,
        name: name,
        payment_type: payment_type,
        gender: gender
      }

      params.delete(:id) if params[:id].nil?
      params.delete(:idcontend) if params[:idcontent].nil?

      if quantity == Float::INFINITY
        params[:unlimited] = Beecode::Quantity::UNLIMITED
      else
        params[:unlimited] = Beecode::Quantity::LIMITED
        params[:total] = quantity
      end

      params[:slot] = slot.serialize
    end
  end
end