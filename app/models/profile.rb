class Profile < ActiveRecord::Base
  belongs_to :user

  def age(user)
  	birth_year = user.profiles.first.birthday.year
  	birth_month = user.profiles.first.birthday.month
  	birth_day = user.profiles.first.birthday.day
  	today = Time.now
  	if birth_month <= today.month && birth_day <= today.day
  		@age = today.year - birth_year
  	elsif ((birth_month <= today.month && birth_day > today.day) || (birth_month > today.month))
  		@age = today.year - birth_year - 1
  	end
  	@age
  end

  def is_birthday(user, current_user)
  	birth_year = user.profiles.first.birthday.year
  	birth_month = user.profiles.first.birthday.month
  	birth_day = user.profiles.first.birthday.day
  	today = Time.now
  	if (birth_month == today.month) && (birth_day == today.day)
  		if user == current_user
  			@birthday = "It's your birthday!"
  		else
  			if user.gender == "Female"
  				@birthday = "It's her birthday!"
  			elsif user.gender == "Male"
  				@birthday = "It's his birthday!"
  			else
  				@birthday = "It's their birthday!"
  			end
  		end
  	end
  end
end
