class AddIsTurnColumnToPlayerUnits < ActiveRecord::Migration
  def self.up
    add_column "player_units", "is_turn", "bool", :default => false
  end

  def self.down
    remove_column "player_units", "is_turn"
  end
end
