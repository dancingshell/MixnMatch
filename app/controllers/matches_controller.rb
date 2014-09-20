class MatchesController < ApplicationController
  def new
  end

  def index
    match_json
  end

  def match_json
    @user_artists = current_user.artists.map(&:name)
    @users = User.all 

    @love_results = {}
    @users.each do |u|
      @count = u.artists.map(&:name) & @user_artists
      @love_results[u.id] = @count.count
    end
  end

  



end