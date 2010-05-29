# To change this template, choose Tools | Templates
# and open the template in the editor.

module AdsCommon
    STATUS_ACTIVE=2
    STATUS_PENDING=3
    STATUS_SOLD=4
    STATUS_EXPIRED=1
    STATUS_CANCELLED=0
  
    STATUS_DESC=ActiveSupport::OrderedHash[
      AdsCommon::STATUS_ACTIVE,'Active',
      AdsCommon::STATUS_PENDING,'Pending',
      AdsCommon::STATUS_SOLD,'Sold',
      AdsCommon::STATUS_CANCELLED,'Cancelled',
      AdsCommon::STATUS_EXPIRED,'Expired',
    ]

    ARRAY_AD_INVALID=[STATUS_EXPIRED,STATUS_CANCELLED]

    def ad_valid?
      return self.status!= STATUS_EXPIRED && self.status!= STATUS_CANCELLED
    end
end
