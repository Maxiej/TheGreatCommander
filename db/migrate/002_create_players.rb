class CreatePlayers < ActiveRecord::Migration
  def self.up
    create_table :players do |t|
      t.column :game_id, :integer      
      t.column :user_id, :integer
      t.column :color, :string
      t.column :gold, :integer
      t.column :no_of_mines, :integer
      t.column :online_player_id, :integer
      t.column :is_ready, :boolean
      t.column :is_owner, :boolean
      t.timestamps
    end
  end

  def self.down
    drop_table :players
  end
end
