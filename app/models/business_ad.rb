
class BusinessAd < ActiveRecord::Base
  AD_TYPE_DESC=ActiveSupport::OrderedHash['Sale',"Business for sale",
    'Partnership',"Business partnership",
    'Franchise',"Business franchise",
  ]

  STATUS_DESC=ActiveSupport::OrderedHash[
    AdsCommon::STATUS_ACTIVE,'Active',
    AdsCommon::STATUS_PENDING,'Pending',
    AdsCommon::STATUS_SOLD,'Sold',
    AdsCommon::STATUS_CANCELLED,'Cancelled',
  ]

  validates_inclusion_of :ad_type, :in => AD_TYPE_DESC.keys
  validates_inclusion_of :status, :in => STATUS_DESC.keys
  validates_presence_of :price
  validates_presence_of :partnership_percent, :if => Proc.new {|ad| ad.ad_type=='Partnership'}
  validates_presence_of :annual_fee, :if => Proc.new {|ad| ad.ad_type=='Franchise'}
  belongs_to :business
  belongs_to :commercial_realty
  include AdExpiration
end
