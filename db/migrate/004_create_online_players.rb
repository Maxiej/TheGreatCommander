class CreateOnlinePlayers < ActiveRecord::Migration
  def self.up
    create_table :online_players do |t|
      t.column :player_id, :integer 
      t.column :last_time_online, :datetime
      t.timestamps
    end
  end

  def self.down
    drop_table :online_players
  end
end
