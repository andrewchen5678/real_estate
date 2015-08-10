#encoding: utf-8
# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def rating_star_control(id)
<<eos
  <select id="#{id}" name="#{id}" class="rating">
      <option value="1">Did not like</option>
      <option value="2">Ok</option>
      <option value="3" selected="selected">Liked</option>
      <option value="4">Loved!</option>
      <option value="5">Excellent</option>
  </select>
eos
  end

  def stateobservefield(statefieldid,cityfieldid,forsearch=nil,inclass=false)
    withstr = forsearch.nil? ?
      "'statesel='+value + '&whichid=#{cityfieldid}'" :
      "'statesel='+value + '&whichid=#{cityfieldid}&forsearch=#{forsearch}'"
    if(inclass)
      withstr+="+'&inclass=1'"
    end
    observe_field(statefieldid, :on=>"changed",
       :url => { :controller => "city", :action => "getcitylist" },
       :with=>withstr)
  end

  def stateselector(selffieldname,statefieldid,whichstateselect,includebnk='please select')
    options=options_for_select(State.all.map{ |s| [s.name, s.id] }, whichstateselect )
    ret= "<select name=\"#{selffieldname}\" id=\"#{statefieldid}\" >"
    ret+= "<option value=''>#{includebnk}</option>" if(includebnk)
    ret+=options+'</select>'
  end


  def format_date dateobj
    return dateobj.to_s
  end

  def formatmultiplechoice(list,choice)
    ret=choice.map{|x| list[x] }.join(",")
    return ret
  end

  def getrightpicture pictureobj,type=:original
    case type
    when :original
      return pictureobj.nil? ? "dummy.png": pictureobj.public_filename
    when :thumb
      return pictureobj.nil? ? "dummy_th.png": pictureobj.public_filename(:thumb)
    else
      raise ArgumentError,"unrecognized type"
    end

  end

  def checkboxlist(fieldname,h,selectedlist=nil)
    ret=''
    h.each do |value,nameh|
      sel=(selectedlist && (selectedlist.include? value))
      ret+=check_box_tag(fieldname+'[]', value, sel)+nameh+'<br/>'
    end
    ret+=hidden_field_tag(fieldname+'[][0]')
    return ret
  end

  def better_page_entries_info(collection, options = {})
    entry_name = options[:entry_name] ||
      (collection.empty?? 'entry' : collection.first.class.name.underscore.sub('_', ' '))
    plural_name = options[:plural_name] || entry_name.pluralize
    if collection.total_pages < 2
      case collection.size
      when 0; "找不到#{plural_name}"
      when 1; "正在顯示第<b>1</b>个#{entry_name}"
      else;   "正在顯示<b>所有#{collection.size}</b>个#{plural_name}"
      end
    else
      %{正在顯示#{plural_name} <b>%d&nbsp;-&nbsp;%d</b> 共 <b>%d</b> 筆資料} % [
        collection.offset + 1,
        collection.offset + collection.length,
        collection.total_entries
      ]
    end
  end

  def sort_link(title, column, options = {})
    condition = options[:unless] if options.has_key?(:unless)
    sort_dir = params[:d] == 'up' ? 'down' : 'up'
    #logger.debug('column'+column)
    if(column.to_s == params[:c])
      if(params[:d] == 'down')
        title+='\\/'
      else
        title+='/\\'
      end
    end
    link_to_unless condition, title, request.parameters.merge( {:c => column, :d => sort_dir} )
  end

  def dispwelcome
    logger.debug('currentuser:'+current_user.inspect)
    if(current_user)
      'Welcome, '+current_user.nickname
    elsif(current_user_session)
      'Welcome, user'
    else
      'Welcome, guest'
    end
  end

  #no h needed
  def format_tarea text
    simple_format(h(text))
  end
  
  def get_thumb_image up
    if(up==true)
      return (image_tag 'thumbs_up.gif')
    elsif(up==false)
      return (image_tag 'thumbs_down.gif')
    end
  end
end

