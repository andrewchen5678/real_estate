# To change this template, choose Tools | Templates
# and open the template in the editor.

class Thumb < ActiveRecord::Base
  belongs_to :thumbable, :polymorphic => true, :counter_cache=>true
  belongs_to :user
  #validates_presence_of :thumbup
#  @updatecount=false
#
#  def before_save
#    if !new_record? && score_changed?
#      @updatecount=true
#    end
#  end

#  def score=(attr)
#    
#    write_attribute('score', attr)
#    #self.inside_component =
#  end

#  def after_save
#    thumbable.increment_counter(:thumbups, thumbable.id)
#  end
  def validate
    if(self.thumbup.nil?)
      errors.add(:thumbup, 'cant be nil')
    end
  end
end
