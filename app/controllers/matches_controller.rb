class MatchesController < ApplicationController
  def new
  end

  def index
    @user_artists = current_user.artists.map(&:name)
    @users = User.all 

    @love_results = []
    @users.each do |u|
    @count = u.artists.map(&:name) & @user_artists
    @love_results << @count.count
    end




  end

  def show
  end

  def edit
  end
end
