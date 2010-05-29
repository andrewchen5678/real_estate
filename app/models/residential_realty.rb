class ResidentialRealty < ActiveRecord::Base
    REALTY_TYPE_DESC=["SFR",
      "Condo",
      "Town House",
      "PUD",
      "MFR",
    ]

    attr_protected :id,:user_id,:address_id,:num_views

      belongs_to :user
      belongs_to :address
      belongs_to :video
      has_many :rr_sales
      has_many :favorites, :as => :favoritable, :dependent => :destroy

      validates_presence_of :building_year
      validates_numericality_of :building_year, :only_integer=>true, :greater_than_or_equal_to=>1
      validates_numericality_of :square_feet, :only_integer=>true, :greater_than_or_equal_to=>1
      validates_numericality_of :num_room,:num_bath,:num_partial_bath,:lot_size,:num_of_beds,:num_of_stories,:main_access,:num_of_units,
        :only_integer=>true, :greater_than_or_equal_to=>0
      validates_price :hoa_fee, :greater_than_or_equal_to=>BigDecimal.new('0.01'),:allow_nil=>true

    accepts_nested_attributes_for :video, :reject_if => proc { |attrs| attrs.all? { |k, v| v.blank? } }
  #validates_associated :r_pud
  #accepts_nested_attributes_for :r_pud,:r_condo,:r_apartment

  validates_format_of :realty_type, :with => /^[A-Za-z0-9]+$/

  extend SinglePicCommon
  has_a_picture :coverpic

  include AttachmentsCommon

  def self.per_page
    10
  end
end
