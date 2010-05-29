# To change this template, choose Tools | Templates
# and open the template in the editor.

module SinglePicCommon
    def has_a_picture name
      has_attached_file name,
        :styles => { :original => "300x300>", :thumb => "100x100>" },
        :url => '/system/:class/:attachment/:id/:style/:filename',
        :default_url => '/images/dummy_:style.png'

      validates_attachment_content_type name,
        :content_type => ["image/gif", "image/jpeg", "image/pjpeg","image/png","image/x-png"]

      validates_attachment_size name, :in => 1..2.megabytes
    end
end

