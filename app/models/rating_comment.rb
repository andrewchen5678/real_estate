class RatingComment < ActiveRecord::Base
  belongs_to :user
  belongs_to :rateable, :polymorphic => true

  #attr_accessible :rate, :dimension
end
