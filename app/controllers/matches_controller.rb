class MatchesController < ApplicationController
  def new
  end

  def show
    @match = Match.find(params[:id])
    @messages = Message.where(match_id: @match.id)
  end

  def index
    @matches = Match.where(:matchee_id => current_user, status: "requested") 
    @accepted = Match.where(:matchee_id => current_user, status: "accepted")
    @accepted2 = Match.where(:matcher_id => current_user, status: "accepted")
  end

  def match_json
    @user_artists = current_user.artists.map(&:name)
    @users = User.all 
    
    @love_results = {}
    @final_results = Hash.new
  
    @users.each do |u|
      @count = u.artists.map(&:name) & @user_artists
      @profile = Profile.find_by(user_id: u.id)
      @love_results[u] = [@count.count, @profile, u.profiles[0].age(u)]
      @sorted_results = @love_results.sort_by{|k, v| v[0]}.reverse       
    end
    render json: @sorted_results
  end

  def create
    match = Match.new(match_params)
    if match.save

      redirect_to :back
    end
  end

  def update
    match = Match.find(params[:id])
    match.update!(match_params)
    if match.save
      redirect_to :back
    end

  end

  
private
  def match_params
    params.require(:match).permit(:matchee_id, :matcher_id, :status)
  end

  def message_params
    params.require(:message).permit(:content, :match_id)
  end



end