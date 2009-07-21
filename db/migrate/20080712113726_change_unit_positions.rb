class ChangeUnitPositions < ActiveRecord::Migration
  def self.up
    self.drop_table("unit_positions")
  end

  def self.down
    create_table :unit_positions do |t|
      t.column :x, :integer
      t.column :y, :integer 
      t.column :unit_id, :integer
      t.column :player_id, :integer
      t.timestamps
    end
  end
end
