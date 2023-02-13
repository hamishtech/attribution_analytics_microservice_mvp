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

# Table name: pageviews

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

# Indexes

#  index_pageviews_on_created_at   (created_at)
#  index_pageviews_on_fingerprint  (fingerprint)
#  index_pageviews_on_user_id      (user_id)

RSpec.describe Pageview, type: :model do
  subject { FactoryBot.build(:pageview) }
  describe 'validations' do
    it { is_expected.to validate_presence_of(:url) }
    it { is_expected.to validate_presence_of(:fingerprint) }
    it { is_expected.to validate_presence_of(:created_at) }
    it { is_expected.to validate_uniqueness_of(:created_at).scoped_to(:fingerprint) }
  end

  describe '#set_utm_fields' do
    let(:pageview) { create(:pageview, url:) }

    context 'when url contains utm params' do
      let(:url) { 'https://www.example.com?utm_source=source&utm_medium=medium&utm_campaign=campaign&utm_content=content' }

      it 'extracts the utm params and sets them on the pageview' do
        expect(pageview.utm_source).to eq('source')
        expect(pageview.utm_medium).to eq('medium')
        expect(pageview.utm_campaign).to eq('campaign')
        expect(pageview.utm_content).to eq('content')
      end
    end

    context 'when url does not contain utm params' do
      let(:url) { 'https://www.example.com' }

      it 'does not set the utm params on the pageview' do
        expect(pageview.utm_source).to be_nil
        expect(pageview.utm_medium).to be_nil
        expect(pageview.utm_campaign).to be_nil
        expect(pageview.utm_content).to be_nil
      end
    end
  end
end
