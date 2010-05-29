class Company < ActiveRecord::Base
  #ajaxful_rateable :stars => 5, :dimensions => [:a, :b, :c, :d], :allow_update=>true

  belongs_to :user
  #has_many :picks, :as => :pickable, :dependent => :destroy
  belongs_to :rating
  has_many :rating_comments, :as => :rateable, :dependent => :destroy
  belongs_to :address
  belongs_to :video
  has_many :agents
  has_many :staff, :class_name => 'Agent', :conditions => ['staff = ?', true]
  has_many :rr_sales, :through=>:agents
  has_many :events
  #before_validation :normalizephone
  validates_presence_of :name,:phone
  #validates_presence_of :business_type_id,:business_cat_id
  validates_length_of :email, :within => Email::MIN_LENGTH..Email::MAX_LENGTH, :allow_blank=>true
  #validates_as_email :email, :allow_blank=>true
  #validates_numericality_of :business_type_id, :only_integer=>true, :allow_blank=>true
  #validates_existence_of :businessType
  validates_numericality_of :license_number, :only_integer=>true, :allow_blank=>true
  validates_format_of :phone, :with => /[0-9]{10}/
  #validate :franchise_before_type_cast_not_blank
  #validates_inclusion_of :business_type_id, :in=>BUSINESS_TYPE_DESC.keys, :allow_blank=>true
  #validates_inclusion_of :business_cat_id, :in=>BUSINESS_CAT_DESC.keys, :allow_blank=>true
  validates_url_format_of :website,:allow_blank => true

  include AttachmentsCommon
  include CommentsCommon
  include ThumbsCommon
  extend SinglePicCommon
  has_a_picture :coverpic

  accepts_nested_attributes_for :video
end
