class Api::V1::EventsController < ApplicationController
  def create
    event = Event.new(event_params)
    if event.save
      head :created
    else
      head :unprocessable_entity
    end
  end

  private

  def event_params
    params.permit(:name, :fingerprint, :user_id, :created_at)
  end
end
