class Api::V1::PageviewsController < ApplicationController
  def create
    pageview = Pageview.new(pageview_params)
    if pageview.save
      head :created
    else
      head :unprocessable_entity
    end
  end

  private

  def pageview_params
    params.permit(:fingerprint, :user_id, :url, :referrer_url, :created_at)
  end
end
