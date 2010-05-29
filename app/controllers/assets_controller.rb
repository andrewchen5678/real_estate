class AssetsController < PolyController
  before_filter :find_right_obj

  def index
    #logger.debug('params inspect:'+params.inspect)
    @pics=@parentobj.assets.all
    #logger.debug(@pic.inspect)
    render 'assets/index'
  end

  def edit
    #logger.debug('params inspect:'+params.inspect)
    @pic=@parentobj.assets.find(params[:id])
    #logger.debug(@pic.inspect)
    render 'assets/editdesc'
  end

  def update
    #logger.debug('params inspect:'+params.inspect)
    @pic=@parentobj.assets.find(params[:id])
    @pic.description=params[:asset][:description]
    #logger.debug(@pic.inspect)
    #logger.debug(polymorphic_url([:updatepics,@parentobj]))
    if(@pic.save)
      flash[:notice]='picture '+@pic.name+'\'s description updated'
      redirect_to polymorphic_url([:updatepics,@parentobj])
    else
      render 'assets/editdesc'
    end
  end

end
