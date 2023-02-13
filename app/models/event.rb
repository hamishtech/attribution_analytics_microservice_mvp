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
class Event < ApplicationRecord
  # validation to ensure that the combination of user_id and name is unique, to avoid recording duplicate events
  validates :name, presence: true, uniqueness: { scope: :user_id }
  validates :fingerprint, presence: true
  validates :user_id, presence: true
  validates :created_at, presence: true
end
