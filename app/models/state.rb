
class State < ActiveRecord::Base
  has_many :cities,:readonly=>true
end
