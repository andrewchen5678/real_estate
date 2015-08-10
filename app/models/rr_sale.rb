#encoding: utf-8
class RrSale < ActiveRecord::Base
  include AdsCommon

  SALE_CATEGORY_DESC=ActiveSupport::OrderedHash[
    1,'普通銷售',
    2,'銀行屋',
    3,'短售屋',
    4,'預售屋'
  ]
  
  belongs_to :residential_realty
  belongs_to :user
  belongs_to :seller, :class_name => 'User'
  validates_presence_of :topic
  validates_inclusion_of :status, :in=>STATUS_DESC.keys
  validates_inclusion_of :sale_category, :in=>SALE_CATEGORY_DESC.keys
  validates_existence_of :residential_realty, :allow_nil=>false
  validates_price :price, :greater_than_or_equal_to=>BigDecimal.new('0.01')
  validate :check_seller
  has_many :favorites, :as => :favoritable, :dependent => :destroy
  include CommentsCommon
  include ThumbsCommon
  include OrderScope
  def self.per_page
    10
  end

  def check_seller
    seller=self.seller
    if(!seller)
      errors.add(:seller_id,"seller doesn't exist")
    elsif(seller.id!=self.user.id && self.user.instance_of?(RegularUser) && !seller.instance_of?(Agent))
      errors.add(:seller_id,"seller has to be either user itself or agent")
    end
    #validates_existence_of :seller
  end
end
