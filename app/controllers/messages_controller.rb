class MessagesController < ApplicationController
	include ActionController::Live

  def new
  end

  def index
  end

  def show
  end

  def edit
  end

  # after_save :notify_slide_change
	def notify_slide_change
	  if current_slide_changed?
	    connection.execute "NOTIFY #{channel}, #{connection.quote current_slide.to_s}"
	  end
	end

	def on_slide_change
	  connection.execute "LISTEN #{channel}"
	  loop do
	    connection.raw_connection.wait_for_notify do |event, pid, slide|
	      yield slide
	    end
	  end
	ensure
	  connection.execute "UNLISTEN #{channel}"
	end

	private
	def channel
	  "decks_#{id}"
	end
end
