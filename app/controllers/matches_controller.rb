class MatchesController < ApplicationController
  def new
  end

  def show
    @match = Match.find(params[:id])
    @messages = Message.where(match_id: @match.id)
  end

  # Delete after testing (transferred to static#index)
  def index
    @matches = Match.where(:matchee_id => current_user, status: "requested") 
    @accepted = Match.where(:matchee_id => current_user, status: "accepted")
    @accepted2 = Match.where(:matcher_id => current_user, status: "accepted")
    @profile = Profile.where(:user_id => current_user).first
  end

  def match_json
    @current_user_artists = current_user.artists.map(&:name)
    # compares current user to all other users (self excluded)
    @users = User.all - [current_user]
   
    @love_results = {}
    @final_results = Hash.new

    @users.each do |u|
      if u.artists.length > 0
        @user_artists = u.artists.map(&:name)
        # finds artists that are common between current user and other users
        @count = @user_artists & @current_user_artists
        @profile = Profile.find_by(user_id: u.id)
    
        # secret match potion
        if @current_user_artists.length > @user_artists.length
          @large_count = @count.length.to_f / @current_user_artists.length
          @small_count = @count.length.to_f / @user_artists.length
        else
          @large_count = @count.length.to_f / @user_artists.length
          @small_count = @count.length.to_f / @current_user_artists.length
        end
        
        @large_count = (@large_count + @small_count) / 2
        @large_count *= 100
        @small_count *= 100
        @match_percent = (@large_count + @small_count) / 2 

        # if number is devided by 0 (returns NaN) change to 0
        @match_percent = 0 if @match_percent.nan?

        # create hash of match% and profile info
        @love_results[u] = [@match_percent.floor, @profile, u.profiles[0].age(u)]
        # rank matches, highest first
        @sorted_results = @love_results.sort_by{|k, v| v[0]}.reverse  
      end     
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
    params.require(:match).permit(:matchee_id, :matcher_id, :status, :message_status)
  end

  def message_params
    params.require(:message).permit(:content, :match_id)
  end



end