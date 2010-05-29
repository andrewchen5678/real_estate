
class User < ActiveRecord::Base
#  acts_as_authentic do |c|
#    #c.login_field = :email # for available options see documentation in: Authlogic::ActsAsAuthentic
#    #c.validate_login_field=false
#  end # block optional
    #ajaxful_rater


    validates_inclusion_of :type, :in =>%w(RegularUser Agent)


    validates_presence_of :first_name,:last_name,:nickname
    validates_inclusion_of :gender, :in =>%w(M F)
    validates_format_of :office_phone,:mobile_phone, :with => /[0-9]{10}/,:allow_blank => true
    validates_url_format_of :website,:allow_blank => true

  
  #if regcomplete?
    include CheckCityState
    #do_check_city_state :if=>Proc.new{|p| p.regcomplete}
    do_check_city_state
  #end
  #acts_as_authorization_subject

  attr_protected :id,:type
  has_many :businesses
  has_many :favorites
  has_many :rr_sales
  has_many :residential_realties
  #has_one :company_pick, :class_name=>'Pick'
  #has_one :user_auth, :foreign_key=>:id

  include AttachmentsCommon
  extend SinglePicCommon
  has_a_picture :coverpic
  

  def self.model_name
    name = "user"
    name.instance_eval do
      def plural;   pluralize;   end
      def singular; singularize; end
    end
    return name
  end



  LANGUAGE_DESC=ActiveSupport::OrderedHash[1,'Burmese',
    2,'Cantonese',
    3,'English',
    4,'French',
    5,'Indonesian',
    6,'Italian',
    7,'Japanese',
    8,'Korean',
    9,'Mandarin',
    10,'Spanish',
    11,'Taiwanese',
    12,'Vietnamese',
    ]

  include MySerializer
  define_int_array_setters :language

  def validate
    if(self.language.empty?)
      errors.add('language','please select at least one language')
    end
  end

end
