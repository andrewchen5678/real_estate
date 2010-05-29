class DropCompanyPicksCount < ActiveRecord::Migration
  def self.up
	remove_column :companies, :picks_count
  end

  def self.down
	add_column :companies, :picks_count, :integer, :default => 0, :null => false
  end
end
