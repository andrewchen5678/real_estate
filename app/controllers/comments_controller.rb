#encoding: utf-8
# To change this template, choose Tools | Templates
# and open the template in the editor.

class CommentsController  < PolyController
  before_filter :find_right_obj
  before_filter :require_user, :only => [:new, :create]

  def index
    #logger.debug('params inspect:'+params.inspect)
    @newcomment=@parentobj.comments.build
    showcommentlist
  end

  def create
    @newcomment=@parentobj.comments.build(params[:comment])
    #@newcomment.thumbupdown=nil if(params[:comment][:thumbupdown]=='')
    @newcomment.user_id=current_user.id
    if(@newcomment.save)
      if(@newcomment.thumbupdown==true)
        @parentobj.thumbup! current_user.id
      elsif (@newcomment.thumbupdown==false)
        @parentobj.thumbdown! current_user.id
      end
      flash[:notice] = 'Comment posted.'
      redirect_to polymorphic_url([@parentobj,:comments],:view=>params[:view])
    else
      showcommentlist
    end
    
  end

  private
#  def edit
#    #logger.debug('params inspect:'+params.inspect)
#    @comments=@parentobj.assets.find(params[:id])
#    #logger.debug(@pic.inspect)
#    render 'assets/editdesc'
#  end

#  def update
#    #logger.debug('params inspect:'+params.inspect)
#    @comments=@parentobj.assets.find(params[:id])
#    @comments.description=params[:asset][:description]
#    #logger.debug(@pic.inspect)
#    #logger.debug(polymorphic_url([:updatepics,@parentobj]))
#    if(@pic.save)
#      flash[:notice]='picture '+@pic.name+'\'s description updated'
#      redirect_to polymorphic_url([:updatepics,@parentobj])
#    else
#      render 'assets/editdesc'
#    end
#  end

  def showcommentlist
    if(@parentobj.instance_of?(Business))
      @headerdesc='留言板 for 生意 B'+@parentobj.id.to_s
    elsif(@parentobj.instance_of?(ResidentialRealty))
      @headerdesc='留言板 for residential realty RR#'+@parentobj.id.to_s
    end
    @comments=@parentobj.comments.paginate :page => params[:comment_page], :order => 'created_at DESC', :include=>:user
    #logger.debug(@pic.inspect)
    if(params[:view]=='plain')
      render :index,:layout=>'plain'
    else
      render :index
    end
    
  end
end
