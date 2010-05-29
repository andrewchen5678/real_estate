class Video < ActiveRecord::Base

#  def vid_url_input
#    if @urlvalid
#      'http://www.youtube.com/watch?v='+self.vid
#    else
#      @urlinput
#    end
#  end

  def url_input
    if(@url_input)
      @url_input
    elsif self.vid
      'http://www.youtube.com/watch?v='+self.vid
    else
      nil
    end
  end

  def url_input=(url)
    @url_input=url
  end

  def vid=(vidid)
    @url_input=nil
    write_attribute('vid', vidid)
  end
#  def vid_url_input=(url)
#    @urlobj= URI.parse(url)
#    if(!@urlobj.query)
#      @urlvalid=false
#      return
#    end
#    tmpobj=CGI::parse(@urlobj.query)
#    if !tmpobj.kind_of(Hash) && tmpobj.has_key?('v')
#      @urlvalid=false
#    else
#      self.vid=['v'][0]
#      @urlvalid=true
#    end
#  rescue URI::InvalidURIError
#    @urlvalid=false
#    @urlinput=url
#  end

  before_validation :parseurl
  validate :ifurlvalid
  validates_format_of :vid, :with => /^[0-9a-zA-Z_-]+$/
  
  private

  def ifurlvalid
    if @url_input && !@urlvalid
      errors.add('url_input','video url is not valid')
    end
  end

  def parseurl
    if(@url_input)
      urlobj= URI.parse(@url_input)
      if(!urlobj.query)
        @urlvalid=false
        return
      end
      tmpobj=CGI::parse(urlobj.query)
      if !tmpobj.kind_of?(Hash) || !tmpobj.has_key?('v')
        @urlvalid=false
        return
      else
        self.vid=tmpobj['v'][0]
        @urlvalid=true
      end
    end
  rescue URI::InvalidURIError
    @urlvalid=false
  end
end
