module RatingsCommon
  def self.included(base)
    base.extend ClassMethods
  end

  module ClassMethods
    def landbook_rate(options = {})
      has_many :ratings, :as => :rateable, :dependent => :destroy
      belongs_to :rater, :class_name=>'User'
#      options[:stars]
#
#      options[:dimensions].each do |dimension|
#
#      end

      options[:dimensions].each do |dimension|
        has_many "#{dimension}_rates", :dependent => :destroy,
          :conditions => {:dimension => dimension.to_s}, :class_name => 'Rate', :as => :rateable
        #has_many "#{dimension}_raters", :through => "#{dimension}_rates", :source => :rater
      end if options[:dimensions].is_a?(Array)

#      class << self
#        def rating_config
#          @rating_config ||= {
#            :stars => 5,
#            :dimensions => []
#          }
#        end
#      end

      rating_config.update(options)
      
    end




  end
end
