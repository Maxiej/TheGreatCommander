class CreateMapTerrainPositions < ActiveRecord::Migration
  def self.up
    create_table :map_terrain_positions do |t|
      t.column :x, :integer
      t.column :y, :integer
      t.column :map_id, :integer
      t.column :terrain_id, :integer
      t.timestamps
    end
  end

  def self.down
    drop_table :map_terrain_positions
  end
end
