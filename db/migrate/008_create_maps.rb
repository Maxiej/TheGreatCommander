class CreateMaps < ActiveRecord::Migration
  def self.up
    create_table :maps do |t|      
      t.column :name, :string
      t.column :size_x, :integer
      t.column :size_y, :integer
      t.timestamps
    end
  end

  def self.down
    drop_table :maps
  end
end
