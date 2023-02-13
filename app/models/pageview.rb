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
class Pageview < ApplicationRecord
  include UtilsHelper
  before_save :add_utm_params, :add_refferer_source_param

  validates :url, presence: true
  validates :fingerprint, presence: true
  # validation to ensure that the combination of created_at and fingerprint is unique, to avoid recording duplicate pageviews
  validates :created_at, presence: true, uniqueness: { scope: %i[fingerprint] }

  def add_utm_params
    utms = parse_utm_params(url)

    self.utm_source = utms['utm_source']
    self.utm_medium = utms['utm_medium']
    self.utm_campaign = utms['utm_campaign']
    self.utm_content = utms['utm_content']
  end

  def add_refferer_source_param
    self.referrer_source = parse_domain(referrer_url)
  end
end
