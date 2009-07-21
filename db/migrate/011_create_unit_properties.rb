class CreateUnitProperties < ActiveRecord::Migration
  def self.up
    create_table :unit_properties do |t|
      t.column :strength, :integer, :default => 1
      t.column :range_strength, :integer, :default => 1
      t.column :range_attack, :integer, :default => 1
      t.column :range_move, :integer, :default => 1
      t.column :armor, :integer, :default => 1
      t.column :price, :integer, :default => 50
      t.column :hp, :integer, :default => 1
      t.column :is_flying, :boolean, :default => false
      t.column :is_shooting, :boolean, :default => false  
      t.column :unit_id, :integer
      t.timestamps
    end
  end

  def self.down
    drop_table :unit_properties
  end
end
