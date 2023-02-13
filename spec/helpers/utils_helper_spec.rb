require 'rails_helper'

RSpec.describe UtilsHelper, type: :helper do
  describe '#parse_utm_params' do
    let(:url) { 'https://www.blinkist.com/en/landing-pages/meet-blinkist?utm_source=facebook&utm_campaign=202301_US_NY_Resolutions&utm_medium=paid&utm_content=19284192381935' }

    it 'returns a hash of utm parameters' do
      utms = helper.parse_utm_params(url)
      expect(utms).to eq({
                           'utm_source' => 'facebook',
                           'utm_campaign' => '202301_US_NY_Resolutions',
                           'utm_medium' => 'paid',
                           'utm_content' => '19284192381935'
                         })
    end

    context "when the url doesn't contain utm and query params" do
      let(:url) { 'http://example.com' }

      it 'returns an empty hash' do
        expect(helper.parse_utm_params(url)).to eq({})
      end
    end

    context 'when the url is blank' do
      let(:url) { '' }

      it 'returns an empty hash' do
        expect(helper.parse_utm_params(url)).to eq({})
      end
    end
  end

  describe '#parse_domain' do
    context 'when the URL is not nil' do
      it 'returns the domain name from the URL' do
        url = 'https://www.google.com/some/path'
        expect(helper.parse_domain(url)).to eq('google.com')
      end
    end

    context 'when the URL is nil' do
      it 'returns nil' do
        expect(helper.parse_domain(nil)).to be_nil
      end
    end

    context 'when the URL is not valid' do
      it 'returns nil' do
        expect(helper.parse_domain('goo.co')).to be_nil
      end
    end
  end
end
