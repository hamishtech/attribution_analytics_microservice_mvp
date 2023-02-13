# == Schema Information
#
# Table name: events
#
#  id          :bigint           not null, primary key
#  fingerprint :string           not null
#  name        :string           not null
#  created_at  :datetime         not null
#  user_id     :string           not null
#
# Indexes
#
#  index_events_on_user_id_and_name  (user_id,name) UNIQUE
#
FactoryBot.define do
  factory :event do
    name { 'signup' }
    fingerprint { Faker::Internet.uuid }
    user_id { Faker::Internet.uuid }
    created_at { Time.at(Faker::Time.between(from: DateTime.now - 1, to: DateTime.now).to_i).utc }

    trait :invalid do
      name { nil }
      fingerprint { nil }
      user_id { nil }
      created_at { nil }
    end
  end
end
