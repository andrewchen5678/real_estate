# To change this template, choose Tools | Templates
# and open the template in the editor.

class Favorite < ActiveRecord::Base
  belongs_to :favoritable, :polymorphic => true
  belongs_to :user
end
