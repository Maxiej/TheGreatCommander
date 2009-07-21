class CreateUnits < ActiveRecord::Migration
  def self.up
    create_table :units do |t|
      t.column :name, :string
      t.column :image, :binary
      t.column :unit_property_id, :integer
      t.timestamps
    end
  end

  def self.down
    drop_table :units
  end
end
