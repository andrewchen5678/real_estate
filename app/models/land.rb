class Land < ActiveRecord::Base
  include MySerializer
  belongs_to :address
  VIEW_DESC=ActiveSupport::OrderedHash[
    1,'Ocean',
    2,'City',
    3,'Mountain',
  ]
  define_int_array_setters :view
end
