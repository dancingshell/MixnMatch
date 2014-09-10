class Group < ActiveRecord::Base
  belongs_to :event
  has_many :user_groups

end
