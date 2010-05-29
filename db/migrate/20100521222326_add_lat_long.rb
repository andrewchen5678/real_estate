class AddLatLong < ActiveRecord::Migration
  def self.up
    add_column :addresses, :lat, :decimal, :default => 0.0, :precision=>10, :scale=>6, :null => false
    add_column :addresses, :lng, :decimal, :default => 0.0, :precision=>10, :scale=>6, :null => false
    add_column :addresses, :latlngon, :boolean, :default => 0, :null => false
  end

  def self.down
    remove_column :addresses, :lat
    remove_column :addresses, :lng
    remove_column :addresses, :latlngon
  end
end
