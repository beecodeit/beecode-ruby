class Beecode::Client
  module Campaigns
    def campaigns
      response = check_response { authenticated_get('/v1/prodotto/list') }
      parsed_response = JSON.parse(response.body)

      Beecode::Resource.wrap(parsed_response['result'])
    rescue JSON::ParserError
      raise Beecode::Error::InvalidResponse
    end

    def show_campaign(campaign_id)
      response = check_response do
        authenticated_get('/v1/prodotto/single',
                          { params: { id: campaign_id } })
      end

      parsed_response = JSON.parse(response.body)

      Beecode::Resource.new(parsed_response['result'])
    rescue JSON::ParserError
      raise Beecode::Error::InvalidResponse
    end

    def create_campaign(name, description, date, cover = nil)
      payload = build_campaign_payload(name, description, date, cover)

      response = check_response { authenticated_post('/v1/prodotto/create', payload) }
      parsed_response = JSON.parse(response.body)

      Beecode::Resource.new(parsed_response['result'])
    rescue JSON::ParserError
      raise Beecode::Error::InvalidResponse
    end

    def update_campaign(campaign_id, name = nil, description = nil, date = nil, cover = nil)
      payload = build_campaign_payload(campaign_id, name, description, date, cover)

      response = check_response { authenticated_post('/v1/prodotto/update', payload) }
      parsed_response = JSON.parse(response.body)

      Beecode::Resource.new(parsed_response['result'])
    rescue JSON::ParserError
      raise Beecode::Error::InvalidResponse
    end

    def add_agents(campaign_id, users)
      users = check_users_param(users)
      response = check_response do
        authenticated_post('/v1/prodotto/addPr', { bcode: campaign_id, users: users })
      end

      parsed_response = JSON.parse(response.body)

      Beecode::Resource.wrap(parsed_response['result'])
    rescue JSON::ParserError
      raise Beecode::Error::InvalidResponse
    end

    # Manca la documentazione
    def remove_agents(campaign_id, *users)
      response = check_response do
        authenticated_post('/v1/prodotto/removePr',
                           { idcontent: campaign_id, users: users.join(',') })
      end

      parsed_response = JSON.parse(response.body)

      Beecode::Resource.wrap(parsed_response['result'])
    rescue JSON::ParserError
      raise Beecode::Error::InvalidResponse
    end

    def campaigns_tickets(campaign_id)
      response = check_response { authenticated_get('/v1/prodotto/tickets') }
      parsed_response = JSON.parse(response.body)

      Beecode::Resource.wrap(parsed_response['result'])
    rescue JSON::ParserError
      raise Beecode::Error::InvalidResponse
    end

    def campaigns_checkins(campaign_id)
      response = check_response { authenticated_get('/v1/prodotto/checkins') }
      parsed_response = JSON.parse(response.body)

      Beecode::Resource.wrap(parsed_response['result'])
    rescue JSON::ParserError
      raise Beecode::Error::InvalidResponse
    end

    def check_users_param(users)
      users = [users] if users.is_a?(Hash)

      unless users.is_a?(Array)
        raise ArgumentError, "the users provided is not an array: #{users}"
      end

      users
    end

    def build_campaign_payload(id = nil, name = nil, description = nil, date = nil, cover = nil)
      payload = {}

      payload['id'] = id unless id.nil? || id == ''
      payload['name'] = name unless name.nil? || name == ''
      payload['description'] = description unless description.nil? || description == ''
      payload['cover'] = cover unless cover.nil? || cover == ''

      unless date.nil? || date == ''
        Time.strptime(date, '%d/%m/%Y %H:%M')
        payload['data'] = date
      end

      payload
    rescue ArgumentError
      raise ArgumentError, "invalid date format provided: #{date}"
    end
  end
end