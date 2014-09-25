class StaticController < ApplicationController

  def index
    if current_user

      #####

     

      #####

      # Artists
      @artists = current_artists.sort_by{ |alpha| url_encode(alpha.name.downcase) }
      @add_artist = UserArtist.new

      # Matches
      @matches = Match.where(:matchee_id => current_user, status: "requested") 
      @accepted = Match.where(:matchee_id => current_user, status: "accepted")
      @accepted2 = Match.where(:matcher_id => current_user, status: "accepted")

    else
      redirect_to welcome_path
    end
  end

  # privacy policy for facebook
  def privacy
  end

end
