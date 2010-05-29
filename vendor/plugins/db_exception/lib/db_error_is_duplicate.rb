# To change this template, choose Tools | Templates
# and open the template in the editor.

module ActiveRecord
   def self.db_error_is_duplicate? adapter
     return adapter.errno==1062 #ONLY for MySql
   end
end
