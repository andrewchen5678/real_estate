class AddCompanyThumbfields < ActiveRecord::Migration
  def self.up
	add_column :companies, :thumbs_up, :integer, :default => 0, :null => false
	add_column :companies, :thumbs_rate, :integer, :default => 0, :null => false
	add_column :companies, :thumbs_count, :integer, :default => 0, :null => false
  end

  def self.down
	remove_column :companies, :thumbs_up
	remove_column :companies, :thumbs_rate
	remove_column :companies, :thumbs_count
  end
end
