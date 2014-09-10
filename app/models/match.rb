class Match < ActiveRecord::Base
  belongs_to :matcher, class_name: "User", foreign_key: :matcher_id, inverse_of: :matchers
  belongs_to :matchee, class_name: "User", foreign_key: :matchee_id, inverse_of: :matchees
end
