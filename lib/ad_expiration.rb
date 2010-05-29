# To change this template, choose Tools | Templates
# and open the template in the editor.

module AdExpiration
  def self.included(base)
    base.instance_eval do
      before_create :extend_expire
    end
    base.send :define_method, 'show_ad_status' do
      if status != AdsCommon::STATUS_SOLD && status != AdsCommon::STATUS_CANCELLED && expired?
        'Expired'
      else
        base::STATUS_DESC[status]
      end
    end
  end

  def extend_expire!
    self.expiration_date=30.days.to_i.from_now
  end

  def expire!
    self.expiration_date=Date.today if self.expiration_date > Date.today
  end

  def expired?
    return self.expiration_date <= Date.today
  end

  def valid?
    return self.status != AdsCommon::STATUS_SOLD && status != AdsCommon::STATUS_CANCELLED && !expired?
  end
end
