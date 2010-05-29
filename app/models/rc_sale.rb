
class RcSale < ActiveRecord::Base
  STATUS_DESC=ActiveSupport::OrderedHash[
    AdsCommon::STATUS_ACTIVE,'Active',
    AdsCommon::STATUS_PENDING,'Pending',
    AdsCommon::STATUS_SOLD,'Sold',
    AdsCommon::STATUS_CANCELLED,'Cancelled',
  ]

  SALE_TYPE_DESC=ActiveSupport::OrderedHash[
    1,'普通銷售',
    2,'銀行屋',
    3,'短售屋',
    4,'預售屋'
  ]

  belongs_to :commercial_realty
end
