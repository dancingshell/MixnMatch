class EventsController < ApplicationController
  def new
  end

  def index
    @events = Event.all

  end

  def show
  end

  def edit
  end

  def event_json
    render json: Event.all
  end
end


