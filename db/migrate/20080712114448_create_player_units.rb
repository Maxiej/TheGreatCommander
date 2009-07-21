class CreatePlayerUnits < ActiveRecord::Migration
  def self.up
    create_table :player_units do |t|
      t.column :x, :integer
      t.column :y, :integer 
      t.column :unit_id, :integer
      t.column :player_id, :integer
      t.column :hp_left, :integer
      t.timestamps
      t.timestamps
    end
  end

  def self.down
    drop_table :player_units
  end
end
