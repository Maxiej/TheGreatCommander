# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of ActiveRecord to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20080714105708) do

  create_table "games", :force => true do |t|
    t.integer  "map_id",      :limit => 11
    t.string   "name"
    t.string   "password"
    t.datetime "started_at"
    t.integer  "whose_turn",  :limit => 11
    t.boolean  "is_finished"
    t.integer  "security_no", :limit => 11
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "map_terrain_positions", :force => true do |t|
    t.integer  "x",          :limit => 11
    t.integer  "y",          :limit => 11
    t.integer  "map_id",     :limit => 11
    t.integer  "terrain_id", :limit => 11
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "maps", :force => true do |t|
    t.string   "name"
    t.integer  "size_x",     :limit => 11
    t.integer  "size_y",     :limit => 11
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "messages", :force => true do |t|
    t.string   "title"
    t.integer  "user_id",    :limit => 11
    t.string   "to",         :limit => 11
    t.string   "content"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_read",                  :default => false
  end

  create_table "news", :force => true do |t|
    t.string   "title"
    t.string   "content"
    t.integer  "user_id",          :limit => 11
    t.datetime "publication_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "online_players", :force => true do |t|
    t.integer  "player_id",        :limit => 11
    t.datetime "last_time_online"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "player_units", :force => true do |t|
    t.integer  "x",          :limit => 11
    t.integer  "y",          :limit => 11
    t.integer  "unit_id",    :limit => 11
    t.integer  "player_id",  :limit => 11
    t.integer  "hp_left",    :limit => 11
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "players", :force => true do |t|
    t.integer  "game_id",          :limit => 11
    t.integer  "user_id",          :limit => 11
    t.string   "color"
    t.integer  "gold",             :limit => 11
    t.integer  "no_of_mines",      :limit => 11
    t.integer  "online_player_id", :limit => 11
    t.boolean  "is_ready"
    t.boolean  "is_owner"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "terrain_properties", :force => true do |t|
    t.string   "name"
    t.boolean  "can_move",                    :default => true
    t.float    "move_ratio",                  :default => 1.0
    t.float    "defend_rate"
    t.boolean  "is_mine",                     :default => false
    t.integer  "gold_per_turn", :limit => 11, :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "terrains", :force => true do |t|
    t.string   "name"
    t.string   "short_name"
    t.binary   "image"
    t.integer  "terrain_property_id", :limit => 11
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "unit_properties", :force => true do |t|
    t.integer  "strength",       :limit => 11, :default => 1
    t.integer  "range_strength", :limit => 11, :default => 1
    t.integer  "range_attack",   :limit => 11, :default => 1
    t.integer  "range_move",     :limit => 11, :default => 1
    t.integer  "armor",          :limit => 11, :default => 1
    t.integer  "price",          :limit => 11, :default => 50
    t.integer  "hp",             :limit => 11, :default => 1
    t.boolean  "is_flying",                    :default => false
    t.boolean  "is_shooting",                  :default => false
    t.integer  "unit_id",        :limit => 11
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "units", :force => true do |t|
    t.string   "name"
    t.binary   "image"
    t.integer  "unit_property_id", :limit => 11
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "login"
    t.string   "email"
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token"
    t.datetime "remember_token_expires_at"
    t.string   "gender"
    t.integer  "no_of_wins",                :limit => 11
    t.integer  "no_of_losses",              :limit => 11
    t.integer  "scores",                    :limit => 11
    t.binary   "avatar",                    :limit => 2147483647
    t.string   "avatar_content_type"
    t.date     "date_of_birth"
    t.datetime "last_time_online"
  end

end
