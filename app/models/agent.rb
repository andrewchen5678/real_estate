class Agent < User
  has_one :profile, :class_name=>'AgentProfile', :foreign_key=>'user_id'
  belongs_to :company
  validates_presence_of :position, :if=>Proc.new{|p| p.staff }
  validates_existence_of :company
  accepts_nested_attributes_for :profile
  include CommentsCommon
  include ThumbsCommon
end
