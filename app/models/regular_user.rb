class RegularUser < User
  has_one :profile, :class_name=>'RegularUserProfile', :foreign_key=>'user_id'
  accepts_nested_attributes_for :profile
end
