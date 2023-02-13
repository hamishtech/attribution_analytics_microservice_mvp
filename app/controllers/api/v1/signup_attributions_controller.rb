class Api::V1::SignupAttributionsController < ApplicationController
  def show
    signup_event = find_signup_event
    return head :not_found unless signup_event

    pageviews = find_pageviews(signup_event)
    pageviews_from_ads = find_pageviews_from_ads(pageviews)

    render json: {
      signup_created_at: signup_event.created_at,
      first_interaction: first_interaction_details(pageviews.first),
      first_ad: ad_details(pageviews_from_ads.first),
      last_ad: ad_details(pageviews_from_ads.last),
      ad_count: pageviews_from_ads.count,
      pageview_count: pageviews.count,
      time_to_conversion_seconds: time_to_conversion(pageviews, signup_event)
    }
  end

  private

  def find_signup_event
    Event.find_by(user_id: params[:user_id], name: 'signup')
  end

  def find_pageviews(signup_event)
    Pageview
      .where(fingerprint: signup_event.fingerprint)
      .where('created_at < ?', signup_event.created_at)
      .order(created_at: :asc)
  end

  def find_pageviews_from_ads(pageviews)
    pageviews.where.not(utm_source: nil).order(created_at: :asc)
  end

  def first_interaction_details(first_interaction)
    return unless first_interaction

    {
      is_first_interaction_from_ad: first_interaction.utm_source.present?,
      first_interaction_url: first_interaction.url,
      first_interaction_source: first_interaction.referrer_source
    }
  end

  def ad_details(pageview)
    return unless pageview

    {
      source: pageview.utm_source,
      medium: pageview.utm_medium,
      campaign: pageview.utm_campaign,
      content: pageview.utm_content
    }
  end

  def time_to_conversion(pageviews, signup_event)
    pageviews.present? ? signup_event.created_at - pageviews.first.created_at : nil
  end
end