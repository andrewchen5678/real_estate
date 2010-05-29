# To change this template, choose Tools | Templates
# and open the template in the editor.

class Pick < ActiveRecord::Base
  belongs_to :user
  belongs_to :pickable, :polymorphic => true, :counter_cache=>true
  #belongs_to :company
end
