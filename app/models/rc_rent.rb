#encoding: utf-8
class RcRent < ActiveRecord::Base
  STATUS_DESC=ActiveSupport::OrderedHash[
    AdsCommon::STATUS_ACTIVE,'Active',
    AdsCommon::STATUS_CANCELLED,'Cancelled',
  ]

  RENT_TYPE_DESC=ActiveSupport::OrderedHash[
    1,'地產管理公司代租',
    2,'屋主出租',
    3,'Resident Manager管理出租',
  ]

  belongs_to :commercial_realty
end
