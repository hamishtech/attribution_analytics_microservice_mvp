require 'rails_helper'

RSpec.describe 'POST /api/v1/events', type: :request do
  let(:valid_attributes) { attributes_for(:event) }
  let(:invalid_attributes) { attributes_for(:event, :invalid) }

  context 'when the request is valid' do
    before { post '/api/v1/events', params: valid_attributes }

    it 'returns status code 201' do
      expect(response).to have_http_status(201)
    end

    it 'creates a new Event' do
      expect(Event.count).to eq(1)
    end
  end

  context 'when the Event is a duplicate (i.e two same signup Events)' do
    before do
      post '/api/v1/events', params: valid_attributes
      post '/api/v1/events', params: valid_attributes
    end

    it 'returns status code 422' do
      expect(response).to have_http_status(422)
    end

    it 'does not create a new Event' do
      expect(Event.count).to eq(1)
    end
  end

  context 'when the request is invalid' do
    before { post '/api/v1/events', params: invalid_attributes }

    it 'returns status code 422' do
      expect(response).to have_http_status(422)
    end

    it 'does not create a new Event' do
      expect(Event.count).to eq(0)
    end
  end
end
