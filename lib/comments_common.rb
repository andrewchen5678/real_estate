# To change this template, choose Tools | Templates
# and open the template in the editor.

module CommentsCommon
  def self.included(base)
    base.instance_eval do
      has_many :comments, :as => :commentable, :dependent => :destroy
    end
  end
end
