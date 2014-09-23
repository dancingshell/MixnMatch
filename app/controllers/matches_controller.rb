class MatchesController < ApplicationController
  def new
  end

  def index
 
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



  



end