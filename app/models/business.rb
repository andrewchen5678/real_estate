#encoding: utf-8
class Business < ActiveRecord::Base
  FRANCHISE_DESC={false=>'非加盟連鎖生意',true=>'加盟連鎖生意'}

  TYPE_OTHER=0
  TYPE_RESTAURANT=1
  TYPE_WHOLESALE=2
  TYPE_SERVICE=3
  TYPE_COSMETIC=4
  TYPE_EDUCATION=5
  TYPE_FACTORY=6
  #TYPE_OTHER=7
  BUSINESS_TYPE_DESC=ActiveSupport::OrderedHash[TYPE_RESTAURANT,"餐飲小吃",
    TYPE_WHOLESALE,"批發零售",
    TYPE_SERVICE,"專業服務",
    TYPE_COSMETIC,"美髮美容",
    TYPE_EDUCATION,"教育訓練",
    TYPE_FACTORY,"工廠",
    TYPE_OTHER,"其他"
  ]

  CAT_OTHER=0
  CAT_COMRET=1
  CAT_OFFICE=2
  CAT_WAREHOUSE=3
  BUSINESS_CAT_DESC=ActiveSupport::OrderedHash[CAT_COMRET,"商店/餐廳",
    CAT_OFFICE,"辦公大樓",
    CAT_WAREHOUSE,"廠房/倉庫",
    CAT_OTHER,"其他"
  ]

  belongs_to :user
  #belongs_to :businessType
  belongs_to :address
  include AttachmentsCommon
  include ThumbsCommon
  include CommentsCommon
  #has_many :assets, :as => :attachable, :dependent => :destroy
  #has_many :images, :as => :asset
  #belongs_to :frontpic, :class_name => "SingleImage", :dependent => :destroy
  #acts_as_polymorphic_paperclip
  #accepts_nested_attributes_for :singleImage, :allow_destroy => true

  before_validation :normalizephone
  validates_presence_of :businessName,:phone
  validates_presence_of :business_type_id,:business_cat_id
  validates_length_of :email, :within => Email::MIN_LENGTH..Email::MAX_LENGTH, :allow_blank=>true
  validates_as_email :email, :allow_blank=>true
  validates_numericality_of :business_type_id, :only_integer=>true, :allow_blank=>true
  #validates_existence_of :businessType
  #validates_numericality_of :rnumber, :only_integer=>true
  validates_price :monthlySalary,:annualIncome,:monthlyRent, :greater_than_or_equal_to=>BigDecimal.new('0.01'),:allow_blank=>true
  validates_format_of :phone, :with => /[0-9]{10}/
  #validate :franchise_before_type_cast_not_blank
  validates_inclusion_of :franchise, :in=>[true,false], :message=>'please select'
  validates_inclusion_of :business_type_id, :in=>BUSINESS_TYPE_DESC.keys
  validates_inclusion_of :business_cat_id, :in=>BUSINESS_CAT_DESC.keys
  validates_url_format_of :website,:allow_blank => true
  #validates_associated :images
  #has_attached_file :frontpic, :styles => { :original => "250x250>", :thumb => "100x100>" }
  attr_accessible 	:businessName,:year_started, :operateTime, :capitalQuota, :numEmployee, :monthlySalary,
    :annualIncome, :monthlyRent, :franchise, :business_type_id, :business_cat_id, :items, 
    :description, :phone, :fax, :phoneExt, :logo, :website, :email, :coverpic

  extend SinglePicCommon
  has_a_picture :coverpic
#  has_attached_file :coverpic,
#    :styles => { :original => "300x300>", :thumb => "100x100>" },
#    :default_url => '/images/dummy_:style.png'
#
#  validates_attachment_content_type :coverpic,
#    :content_type => ["image/gif", "image/jpeg", "image/pjpeg","image/png","image/x-png"]
#
#  validates_attachment_size :coverpic, :in => 1..2.megabytes

    #validate :validate_attachments

    #Max_Attachments = 5
    #Max_Attachment_Size = 1.megabyte



  protected

#  def validate_attachments
#    errors.add_to_base("Too many attachments - maximum is #{Max_Attachments}") if assets.length > Max_Attachments
#    #assets.each {|a| errors.add_to_base("#{a.name} is over #{Max_Attachment_Size/1.megabyte}MB") if a.file_size > Max_Attachment_Size}
#  end

  def franchise_before_type_cast_not_blank
    logger.debug("call franchise_before_type_cast_not_blank")
#     if franchise_before_type_cast.blank?
#       errors.add(:franchise, 'please select franchise')
#     elsif !(%w{true false}).include?(franchise_before_type_cast)
#       errors.add(:franchise, 'wrong selection')
#     end
  end

  def normalizephone
    logger.debug("call normalizephone")
    #self.address.street=address.street.split(/\s+/)
    self.phone = phone.gsub(/[^0-9]/, "")
  end

  def self.per_page
    10
  end

#  def after_validation
#    logger.debug("after validate business"+self.monthlySalary.inspect)
#  end

#  def business_type_in_db
#    if !BusinessType.exists?(business_type_id)
#      errors.add(:business_type_id, ' doesnt exist in db')
#    end
#  end

end
