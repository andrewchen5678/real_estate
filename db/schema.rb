# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20100521222326) do

  create_table "addresses", :force => true do |t|
    t.integer  "streetNumber",                                                                 :null => false
    t.string   "streetWay",    :limit => 1,                                                    :null => false
    t.string   "street",       :limit => 64,                                                   :null => false
    t.string   "streetRoad",   :limit => 5,                                                    :null => false
    t.string   "unit",         :limit => 8,                                                    :null => false
    t.string   "city_name",                                                                    :null => false
    t.string   "state_id",     :limit => 2,                                                    :null => false
    t.string   "zip",          :limit => 5,                                                    :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "lat",                        :precision => 10, :scale => 6, :default => 0.0,   :null => false
    t.decimal  "lng",                        :precision => 10, :scale => 6, :default => 0.0,   :null => false
    t.boolean  "latlngon",                                                  :default => false, :null => false
  end

  add_index "addresses", ["city_name", "state_id"], :name => "city_state"
  add_index "addresses", ["city_name"], :name => "city_id"
  add_index "addresses", ["streetNumber", "streetWay", "street", "streetRoad", "unit", "city_name", "zip", "state_id"], :name => "uniqueaddress", :unique => true

  create_table "agent_profiles", :force => true do |t|
    t.integer  "user_id"
    t.string   "license_number", :limit => 20
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "assets", :force => true do |t|
    t.string   "data_file_name"
    t.string   "data_content_type"
    t.integer  "data_file_size"
    t.integer  "attachable_id"
    t.string   "attachable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "description"
  end

  add_index "assets", ["attachable_id", "attachable_type"], :name => "index_assets_on_attachable_id_and_attachable_type"

  create_table "business_ads", :force => true do |t|
    t.integer  "user_id",                                                          :null => false
    t.integer  "business_id"
    t.integer  "commercial_realty_id"
    t.string   "topic"
    t.text     "introduction"
    t.decimal  "price",                             :precision => 16, :scale => 2
    t.boolean  "immigration",                                                      :null => false
    t.string   "ad_type"
    t.integer  "partnership_percent",  :limit => 2
    t.decimal  "annual_fee",                        :precision => 16, :scale => 2
    t.integer  "ad_status",            :limit => 2
    t.date     "expiration_date",                                                  :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "businesses", :force => true do |t|
    t.integer  "user_id",                                                                              :null => false
    t.string   "businessName",          :limit => 32,                                                  :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "year_started",          :limit => 3
    t.string   "operateTime",           :limit => 48
    t.decimal  "capitalQuota",                         :precision => 16, :scale => 2
    t.integer  "numEmployee"
    t.decimal  "monthlySalary",                        :precision => 16, :scale => 2
    t.decimal  "annualIncome",                         :precision => 16, :scale => 2
    t.decimal  "monthlyRent",                          :precision => 10, :scale => 2
    t.boolean  "franchise",                                                                            :null => false
    t.integer  "business_type_id",                                                                     :null => false
    t.integer  "business_cat_id"
    t.text     "items",                                                                                :null => false
    t.text     "description",                                                                          :null => false
    t.integer  "address_id",                                                                           :null => false
    t.string   "phone",                 :limit => 10,                                                  :null => false
    t.string   "fax",                   :limit => 10
    t.string   "phoneExt",              :limit => 10
    t.integer  "frontpic_id"
    t.decimal  "rating",                               :precision => 3,  :scale => 2, :default => 0.0, :null => false
    t.string   "website",               :limit => 256
    t.string   "email",                 :limit => 64
    t.integer  "thumbs_count"
    t.string   "coverpic_file_name"
    t.string   "coverpic_content_type"
    t.integer  "coverpic_file_size"
    t.datetime "coverpic_updated_at"
  end

  add_index "businesses", ["address_id"], :name => "addressID"
  add_index "businesses", ["businessName"], :name => "businessName", :unique => true
  add_index "businesses", ["business_type_id"], :name => "businessType"
  add_index "businesses", ["user_id"], :name => "userID"

  create_table "cities", :force => true do |t|
    t.string "state_id", :limit => 2,  :null => false
    t.string "name",     :limit => 32, :null => false
  end

  add_index "cities", ["name", "state_id"], :name => "city_state", :unique => true
  add_index "cities", ["state_id"], :name => "state_id"

  create_table "comments", :force => true do |t|
    t.text     "content"
    t.integer  "user_id",          :null => false
    t.integer  "commentable_id"
    t.string   "commentable_type"
    t.boolean  "thumbupdown"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comments", ["commentable_id", "commentable_type"], :name => "index_comments_on_commentable_id_and_commentable_type"

  create_table "commercial_realties", :force => true do |t|
    t.integer  "address_id",                                     :null => false
    t.integer  "user_id"
    t.decimal  "building_area_w",  :precision => 8, :scale => 2
    t.decimal  "building_area_h",  :precision => 8, :scale => 2
    t.integer  "building_year"
    t.integer  "num_room"
    t.string   "realty_type"
    t.string   "main_entrance"
    t.integer  "num_floor"
    t.integer  "num_unit"
    t.integer  "num_bath"
    t.integer  "num_partial_bath"
    t.string   "inside_component"
    t.string   "public_facility"
    t.string   "heater"
    t.string   "ac"
    t.integer  "num_unload"
    t.integer  "reserved_parking"
    t.integer  "public_parking"
    t.string   "county"
    t.string   "neighbor"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "companies", :force => true do |t|
    t.integer  "user_id"
    t.string   "name"
    t.string   "other_language_name"
    t.integer  "license_number"
    t.integer  "address_id"
    t.string   "phone"
    t.string   "fax"
    t.string   "email"
    t.string   "website"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "coverpic_file_name"
    t.integer  "coverpic_file_size"
    t.integer  "num_views",           :default => 0, :null => false
    t.integer  "video_id"
    t.integer  "rating_id"
    t.integer  "thumbs_up",           :default => 0, :null => false
    t.integer  "thumbs_rate",         :default => 0, :null => false
    t.integer  "thumbs_count",        :default => 0, :null => false
  end

  create_table "events", :force => true do |t|
    t.integer  "company_id"
    t.integer  "user_id",    :null => false
    t.string   "title",      :null => false
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "favorites", :force => true do |t|
    t.integer  "user_id",          :null => false
    t.integer  "favoritable_id"
    t.string   "favoritable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "favorites", ["favoritable_id", "favoritable_type"], :name => "index_comments_on_commentable_id_and_commentable_type"

  create_table "lands", :force => true do |t|
    t.integer  "user_id"
    t.integer  "address_id"
    t.string   "zoning"
    t.integer  "lot_size"
    t.string   "lot_size_unit",   :limit => 1
    t.text     "description"
    t.string   "school_district"
    t.string   "view"
    t.string   "county"
    t.string   "cross_street"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "rating_comments", :force => true do |t|
    t.integer  "user_id"
    t.integer  "rateable_id"
    t.string   "rateable_type"
    t.integer  "a_star"
    t.integer  "b_star"
    t.integer  "c_star"
    t.integer  "d_star"
    t.text     "comment"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "ratings", :force => true do |t|
    t.integer  "a_star_total"
    t.integer  "b_star_total"
    t.integer  "c_star_total"
    t.integer  "d_star_total"
    t.integer  "rate_count"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "rc_rents", :force => true do |t|
    t.integer  "user_id"
    t.integer  "residential_realty_id"
    t.integer  "business_id"
    t.string   "title"
    t.decimal  "rent_price",            :precision => 8, :scale => 2
    t.string   "term"
    t.decimal  "deposit",               :precision => 8, :scale => 2
    t.string   "this_term"
    t.integer  "status"
    t.integer  "rent_type"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "rc_sales", :force => true do |t|
    t.integer  "user_id"
    t.integer  "residential_realty_id"
    t.integer  "business_id"
    t.string   "title"
    t.decimal  "price",                 :precision => 8, :scale => 2
    t.integer  "mls_number"
    t.integer  "status"
    t.integer  "sale_type"
    t.string   "open_house_schedule"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "regular_user_profiles", :force => true do |t|
    t.integer  "user_id"
    t.string   "company_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "residential_realties", :force => true do |t|
    t.integer  "address_id",                                                       :null => false
    t.integer  "user_id"
    t.integer  "square_feet"
    t.integer  "building_year"
    t.integer  "num_room"
    t.integer  "num_bath"
    t.integer  "num_partial_bath"
    t.string   "zoning"
    t.integer  "lot_size"
    t.integer  "num_of_beds"
    t.string   "realty_type"
    t.decimal  "hoa_fee",            :precision => 16, :scale => 2
    t.string   "hoa_frequency"
    t.string   "school_district"
    t.string   "elementary_school"
    t.string   "middle_school"
    t.string   "high_school"
    t.text     "story_description"
    t.string   "bedroom"
    t.string   "floor_covering"
    t.string   "kitchen"
    t.string   "dinning"
    t.string   "laundry"
    t.string   "fire_place"
    t.string   "interior_others"
    t.integer  "num_of_stories"
    t.integer  "main_access"
    t.string   "roof"
    t.string   "parking"
    t.string   "view_types"
    t.string   "lot_description"
    t.string   "exterior_others"
    t.integer  "num_of_units"
    t.string   "community_others"
    t.string   "heating"
    t.string   "cooling"
    t.string   "water"
    t.string   "sewer"
    t.string   "cross_street"
    t.string   "county"
    t.string   "assessment"
    t.string   "handicap_features"
    t.string   "coverpic_file_name"
    t.integer  "coverpic_file_size"
    t.string   "video_id"
    t.integer  "num_views",                                         :default => 0, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "rr_rents", :force => true do |t|
    t.integer  "user_id"
    t.integer  "residential_realty_id"
    t.string   "title"
    t.decimal  "price",                 :precision => 8, :scale => 2
    t.string   "term"
    t.decimal  "deposit",               :precision => 8, :scale => 2
    t.string   "this_term"
    t.integer  "status"
    t.integer  "rent_category"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "furnished"
    t.integer  "pets"
    t.integer  "bedrooms"
  end

  create_table "rr_sales", :force => true do |t|
    t.integer  "user_id",                                                                         :null => false
    t.integer  "residential_realty_id"
    t.string   "topic"
    t.decimal  "price",                              :precision => 8, :scale => 2
    t.integer  "mls_number"
    t.integer  "status"
    t.integer  "sale_category"
    t.text     "description"
    t.date     "expiration_date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "ad_status",             :limit => 2
    t.integer  "num_views",                                                        :default => 0, :null => false
    t.integer  "seller_id",                                                                       :null => false
    t.integer  "thumbs_up",                                                        :default => 0, :null => false
    t.integer  "thumbs_rate",                                                      :default => 0, :null => false
    t.integer  "thumbs_count",                                                     :default => 0, :null => false
  end

  create_table "states", :force => true do |t|
    t.string "name", :limit => 32, :null => false
  end

  create_table "thumbs", :force => true do |t|
    t.boolean  "thumbup",        :default => false, :null => false
    t.integer  "user_id"
    t.integer  "thumbable_id",                      :null => false
    t.string   "thumbable_type",                    :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "thumbs", ["thumbable_id", "thumbable_type"], :name => "index_thumbs_on_thumbable_id_and_thumbable_type"
  add_index "thumbs", ["user_id", "thumbable_id", "thumbable_type"], :name => "NewIndex1", :unique => true

  create_table "user_auths", :force => true do |t|
    t.string   "email",                              :null => false
    t.string   "crypted_password",                   :null => false
    t.string   "password_salt",                      :null => false
    t.string   "persistence_token",                  :null => false
    t.string   "single_access_token",                :null => false
    t.string   "perishable_token",                   :null => false
    t.integer  "login_count",         :default => 0, :null => false
    t.integer  "failed_login_count",  :default => 0, :null => false
    t.datetime "last_request_at"
    t.datetime "current_login_at"
    t.datetime "last_login_at"
    t.string   "current_login_ip"
    t.string   "last_login_ip"
  end

  add_index "user_auths", ["id", "email"], :name => "id", :unique => true

  create_table "users", :force => true do |t|
    t.string   "email",                                                :null => false
    t.string   "type"
    t.string   "city_name"
    t.string   "state_id",            :limit => 2
    t.string   "first_name"
    t.string   "last_name"
    t.string   "nickname"
    t.string   "other_language_name"
    t.string   "gender",              :limit => 1
    t.date     "birthday"
    t.integer  "company_id"
    t.boolean  "staff",                             :default => false, :null => false
    t.string   "position"
    t.string   "office_phone",        :limit => 10
    t.string   "office_ext"
    t.string   "mobile_phone",        :limit => 10
    t.string   "website"
    t.string   "language"
    t.boolean  "hide_info",                         :default => false, :null => false
    t.string   "coverpic_file_name"
    t.integer  "coverpic_file_size"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["city_name", "state_id"], :name => "FK_users"
  add_index "users", ["id", "email", "type"], :name => "id", :unique => true

  create_table "videos", :force => true do |t|
    t.string "vid"
    t.string "description"
  end

end
