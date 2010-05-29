class Asset < ActiveRecord::Base
  has_attached_file :data, :styles => { :original => "300x300>", :thumb => "100x100>" },
        :default_url => '/images/dummy_:style.png'

  belongs_to :attachable, :polymorphic => true

  validates_attachment_content_type :data,
    :content_type => ["image/gif", "image/jpeg", "image/pjpeg","image/png","image/x-png"]

  validates_attachment_size :data, :in => 1..2.megabytes

  validates_length_of :description,:maximum=>128,:allow_blank=>true

  def url(*args)
    data.url(*args)
  end

  def name
    data_file_name
  end

  def content_type
    data_content_type
  end

  def file_size
    data_file_size
  end
end