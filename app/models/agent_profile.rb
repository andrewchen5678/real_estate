class AgentProfile < ActiveRecord::Base
  belongs_to :agent, :foreign_key=>'user_id'
  belongs_to :company
  attr_accessible :license_number
end
