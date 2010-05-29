
module ThumbsCommon
  def self.included(base)
    base.instance_eval do
      has_many :thumbs, :as => :thumbable, :dependent => :destroy
    end
  end

  def thumbup! userid
#    tb=thumbs.find_or_initialize_by_user_id(userid,:limit => 1)
#    tb.thumbup=true
#    tb.save!
    helper_thumbupdown userid,true
  end

  def thumbdown! userid
#    tb=thumbs.find_or_initialize_by_user_id(userid,:limit => 1)
#    #tb.thumbable.class.decrement_counter(:thumbs_up, tb.thumbable.id)
#    tb.thumbup=false
#    tb.save!
    helper_thumbupdown userid,false
  end

  def total_thumbups
    #thumbs.count(:conditions=>{:thumbup=>true})
    thumbs_up
  end
  
  def total_thumbdowns
    thumbs.size-total_thumbups
  end

  def total_thumbs
    thumbs.size
  end
  
  def percent_thumbs
    if total_thumbs==0
      0
    else
      total_thumbups*100/total_thumbs
    end
  end

  private
  def helper_thumbupdown userid,do_up
    ActiveRecord::Base.transaction do
      tb=thumbs.find_by_user_id(userid, :lock => true)
      if(!tb)
        tb=thumbs.new :user_id=>userid
      end
      if do_up
        tb.thumbable.class.increment_counter(:thumbs_up, tb.thumbable.id) if tb.new_record? || tb.thumbup!=do_up
      else
        tb.thumbable.class.decrement_counter(:thumbs_up, tb.thumbable.id) if !tb.new_record? && tb.thumbup!=do_up
      end
      tb.thumbup=do_up
      tb.save!
      ActiveRecord::Base.connection.update_sql("update #{tb.thumbable.class.table_name} set thumbs_rate = thumbs_up*2 - thumbs_count where id = #{tb.thumbable.id.to_i}")
    end
  end
end
