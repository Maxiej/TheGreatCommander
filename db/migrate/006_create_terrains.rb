class CreateTerrains < ActiveRecord::Migration
  def self.up
    create_table :terrains do |t|
      t.column :name, :string
      t.column :short_name, :string
      t.column :image, :binary
      t.column :terrain_property_id, :integer      
      t.timestamps
    end
  end

  def self.down
    drop_table :terrains
  end
end
