# To change this template, choose Tools | Templates
# and open the template in the editor.

module AttachmentsCommon
  def self.included(base)
    base.instance_eval do
      has_many :assets, :as => :attachable, :dependent => :destroy
      validate :validate_attachments
    end
    #base.extend(ClassMethods)
  end

  #module ClassMethods
    Max_Attachments=10
  #end


  protected

  def validate_attachments
    logger.debug("assets.length:#{assets.length}: Max_Attachments#{Max_Attachments}")
    errors.add_to_base("Too many attachments - maximum is #{Max_Attachments}") if Max_Attachments.is_a?(Integer) && assets.size > Max_Attachments
    #assets.each {|a| errors.add_to_base("#{a.name} is over #{Max_Attachment_Size/1.megabyte}MB") if a.file_size > Max_Attachment_Size}
  end
end
