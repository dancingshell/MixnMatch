class MessagesController < ApplicationController
	# include ActionController::Live

  def index
    @messages = Message.all
  end

  def create
  
    @message = Message.create!(message_params)
    
     #PrivatePub.publish_to("/messages/new", message: @message)
    PrivatePub.publish_to("/messages/new", "console.log('#{@message.content}');")
    
  end


  def new
  end

  

  def show
  end

  def edit
  end


  private

  def message_params
    params.require(:message).permit(:content, :match_id, :user_id, :name)
  end

 #  after_save :notify_slide_change
	# def notify_slide_change
	#   if current_slide_changed?
	#     connection.execute "NOTIFY #{channel}, #{connection.quote current_slide.to_s}"
	#   end
	# end

	# def on_slide_change
	#   connection.execute "LISTEN #{channel}"
	#   loop do
	#     connection.raw_connection.wait_for_notify do |event, pid, slide|
	#       yield slide
	#     end
	#   end
	# ensure
	#   connection.execute "UNLISTEN #{channel}"
	# end

	# private
	# def channel
	#   "decks_#{id}"
	# end
end
