# == Schema Information
#
# Table name: pageviews
#
#  id              :bigint           not null, primary key
#  fingerprint     :string           not null
#  referrer_source :string
#  referrer_url    :string
#  url             :string           not null
#  utm_campaign    :string
#  utm_content     :string
#  utm_medium      :string
#  utm_source      :string
#  created_at      :datetime         not null
#  user_id         :string
#
# Indexes
#
#  index_pageviews_on_fingerprint_and_created_at  (fingerprint,created_at) UNIQUE
#
FactoryBot.define do
  factory :pageview do
    fingerprint { Faker::Internet.uuid }
    user_id { nil }
    url { 'https://www.blinkist.com/en/books/lives-of-the-stoics-en' }
    referrer_url { 'https://www.google.de/' }
    created_at { Time.at(Faker::Time.between(from: DateTime.now - 1, to: DateTime.now).to_i).utc }

    trait :invalid do
      fingerprint { nil }
    end

    trait :facebook_ad do
      url { 'https://www.blinkist.com/en/landing-pages/meet-blinkist?utm_source=facebook&utm_campaign=202301_US_NY_Resolutions&utm_medium=paid&utm_content=19284192381935' }
    end

    trait :facebook_ad_with_utm_data do
      url { 'https://www.blinkist.com/en/landing-pages/meet-blinkist?utm_source=facebook&utm_campaign=202301_US_NY_Resolutions&utm_medium=paid&utm_content=19284192381935' }
      utm_source { 'facebook' }
      utm_campaign { '202301_US_NY_Resolutions' }
      utm_medium { 'paid' }
      utm_content { '19284192381935' }
    end
  end
end
