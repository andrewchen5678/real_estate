# To change this template, choose Tools | Templates
# and open the template in the editor.

class Comment < ActiveRecord::Base
  belongs_to :commentable, :polymorphic => true
  belongs_to :user

  validates_presence_of :content, :if => Proc.new {|c| c.thumbupdown.nil?}
  validates_length_of :content, :maximum=>512

  def self.per_page
    10
  end
end
