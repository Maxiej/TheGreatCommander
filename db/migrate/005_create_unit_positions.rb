class CreateUnitPositions < ActiveRecord::Migration
  def self.up
    create_table :unit_positions do |t|
      t.column :x, :integer
      t.column :y, :integer 
      t.column :unit_id, :integer
      t.column :player_id, :integer
      t.timestamps
    end
  end

  def self.down
    drop_table :unit_positions
  end
end
