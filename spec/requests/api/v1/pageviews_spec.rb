require 'rails_helper'

RSpec.describe 'POST /api/v1/pageviews', type: :request do
  include UtilsHelper

  let(:valid_attributes) { attributes_for(:pageview) }
  let(:facebook_ad_attributes) { attributes_for(:pageview, :facebook_ad) }
  let(:invalid_attributes) { attributes_for(:pageview, :invalid) }

  context 'with valid params' do
    before { post '/api/v1/pageviews', params: valid_attributes }

    it 'creates a Pageview' do
      expect(Pageview.count).to eq(1)
    end

    it 'returns a success response' do
      expect(response).to have_http_status(201)
    end

    it 'saves the Pageview attributes' do
      expect(Pageview.last.fingerprint).to eq(valid_attributes[:fingerprint])
      expect(Pageview.last.user_id).to eq(valid_attributes[:user_id])
      expect(Pageview.last.url).to eq(valid_attributes[:url])
      expect(Pageview.last.referrer_url).to eq(valid_attributes[:referrer_url])
    end
  end

  context 'with a facebook ad url including utm query params' do
    before { post '/api/v1/pageviews', params: facebook_ad_attributes }
    let(:utms) { parse_utm_params(facebook_ad_attributes[:url]).with_indifferent_access }

    it 'creates a Pageview' do
      expect(Pageview.count).to eq(1)
    end

    it 'returns a success response' do
      expect(response).to have_http_status(201)
    end

    it 'saves the UTM attributes' do
      expect(Pageview.last.utm_source).to eq(utms[:utm_source])
      expect(Pageview.last.utm_medium).to eq(utms[:utm_medium])
      expect(Pageview.last.utm_campaign).to eq(utms[:utm_campaign])
      expect(Pageview.last.utm_content).to eq(utms[:utm_content])
    end
  end

  context 'when the Pageview is a duplicate (i.e when the webhook is fired twice)' do
    before do
      post '/api/v1/pageviews', params: valid_attributes
      post '/api/v1/pageviews', params: valid_attributes
    end

    it 'does not create a Pageview' do
      expect(Pageview.count).to eq(1)
    end

    it 'returns a unprocessable entity response' do
      expect(response).to have_http_status(422)
    end
  end

  context 'with invalid params' do
    before { post '/api/v1/pageviews', params: invalid_attributes }

    it 'does not create a Pageview' do
      expect(Pageview.count).to eq(0)
    end

    it 'returns a unprocessable entity response' do
      expect(response).to have_http_status(422)
    end
  end
end
