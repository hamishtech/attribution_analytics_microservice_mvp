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

# Table name: events

#  id          :bigint           not null, primary key
#  fingerprint :string           not null
#  name        :string           not null
#  created_at  :datetime         not null
#  user_id     :string           not null

# Indexes

#  index_events_on_user_id_and_name  (user_id,name) UNIQUE

RSpec.describe Event, type: :model do
  subject { FactoryBot.build(:event) }
  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:fingerprint) }
    it { should validate_presence_of(:user_id) }
    it { should validate_presence_of(:created_at) }
    it { should validate_uniqueness_of(:name).scoped_to(:user_id) }
  end
end
