require 'rails_helper'

RSpec.describe 'GET api/v1/signup_attributions/:user_id', type: :request do
  let(:signup_event) { create(:event) }
  let!(:pageviews) do
    5.times.map do
      create(:pageview, fingerprint: signup_event.fingerprint,
                        created_at: Faker::Time.between(from: 2.days.ago, to: signup_event.created_at))
    end
  end

  context 'when signup event is found for a user_id' do
    before { get "/api/v1/signup_attributions/#{signup_event.user_id}" }

    it 'returns http success' do
      expect(response).to have_http_status(:ok)
    end

    it 'returns the correct content type' do
      expect(response.content_type).to eq('application/json; charset=utf-8')
    end

    it 'returns signup attribution details' do
      json = JSON.parse(response.body)
      first_interaction = pageviews.min_by(&:created_at)
      time_to_conversion_seconds = (signup_event.created_at - first_interaction.created_at)

      expect(json).to include({
                                'signup_created_at' => signup_event.created_at,
                                'first_interaction' => {
                                  'first_interaction_source' => first_interaction['referrer_source'],
                                  'first_interaction_url' => first_interaction['url'],
                                  'is_first_interaction_from_ad' => false
                                },
                                'first_ad' => nil,
                                'last_ad' => nil,
                                'ad_count' => 0,
                                'pageview_count' => pageviews.count,
                                'time_to_conversion_seconds' => time_to_conversion_seconds
                              })
    end
  end

  context 'when user was exposed to marketing campaigns' do
    before { get "/api/v1/signup_attributions/#{signup_event.user_id}" }

    let!(:pageviews) do
      5.times.map do
        create(:pageview, :facebook_ad_with_utm_data, fingerprint: signup_event.fingerprint,
                                                      created_at: Faker::Time.between(
                                                        from: 2.days.ago, to: signup_event.created_at
                                                      ))
      end
    end

    it 'returns http success' do
      expect(response).to have_http_status(:ok)
    end

    it 'returns the correct content type' do
      expect(response.content_type).to eq('application/json; charset=utf-8')
    end

    it 'correctly returns signup attribution details when ads are present' do
      json = JSON.parse(response.body)
      first_interaction = pageviews.min_by(&:created_at)
      last_interaction = pageviews.max_by(&:created_at)

      expect(json).to include({
                                'first_ad' => { 'source' => first_interaction.utm_source,
                                                'medium' => first_interaction.utm_medium,
                                                'campaign' => first_interaction.utm_campaign,
                                                'content' => first_interaction.utm_content },
                                'last_ad' => { 'source' => last_interaction.utm_source,
                                               'medium' => last_interaction.utm_medium,
                                               'campaign' => last_interaction.utm_campaign,
                                               'content' => last_interaction.utm_content },
                                'ad_count' => 5
                              })
    end
  end

  context 'when there are no previous pageviews for a signup event' do
    before { get "/api/v1/signup_attributions/#{signup_event.user_id}" }

    let!(:pageviews) { [] }

    it 'returns http success' do
      expect(response).to have_http_status(:ok)
    end

    it 'returns the correct content type' do
      expect(response.content_type).to eq('application/json; charset=utf-8')
    end

    it 'correctly returns signup attribution details when ads are present' do
      json = JSON.parse(response.body)

      expect(json).to include({
                                'signup_created_at' => signup_event.created_at,
                                'first_interaction' => nil,
                                'first_ad' => nil,
                                'last_ad' => nil,
                                'ad_count' => 0,
                                'pageview_count' => 0,
                                'time_to_conversion_seconds' => nil
                              })
    end
  end

  context 'when signup event is not found' do
    before { get '/api/v1/signup_attributions/non-existing-user-id' }

    it 'returns http not found' do
      expect(response).to have_http_status(:not_found)
    end
  end
end
