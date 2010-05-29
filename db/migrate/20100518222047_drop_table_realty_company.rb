class DropTableRealtyCompany < ActiveRecord::Migration
  def self.up
    drop_table :realty_companies
  end

end
