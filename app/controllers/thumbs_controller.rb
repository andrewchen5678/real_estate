# To change this template, choose Tools | Templates
# and open the template in the editor.

class ThumbsController  < PolyController
  before_filter :find_right_obj

  def index
    @thumbs=@parentobj.thumbs.paginate :page => params[:page],:include=>:user
  end

end
