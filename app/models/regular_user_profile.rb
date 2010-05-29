class RegularUserProfile < ActiveRecord::Base
  belongs_to :regular_user, :foreign_key=>'user_id'
end
