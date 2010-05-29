module UserHelper
  def canshowinfo? u
    return u.kind_of?(Agent) || !u.hide_info || current_user.id==u.id
  end
end
