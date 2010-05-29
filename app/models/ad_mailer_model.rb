class AdMailerModel < Tableless
    column :from_name, :string
    column :from_email, :string
    column :use_account, :boolean
    column :to_name, :string
    column :to_email, :string
    column :message, :string

    validates_presence_of :from_name, :from_email, :unless=> proc {|a| a.use_account}
    validates_presence_of :to_name, :to_email
    validates_as_email :from_email, :unless=> proc {|a| a.use_account}
    validates_as_email :to_email
end
