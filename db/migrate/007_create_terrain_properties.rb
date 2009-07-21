class CreateTerrainProperties < ActiveRecord::Migration
  def self.up
    create_table :terrain_properties do |t|
      t.column :name, :string
      t.column :can_move, :boolean, :default => true
      t.column :move_ratio, :float,  :default => 1
      t.column :defend_rate, :float, :defalut => 1
      t.column :is_mine, :boolean, :default => false
      t.column :gold_per_turn, :integer, :default => 0
      t.timestamps
    end
  end

  def self.down
    drop_table :terrain_properties
  end
end
