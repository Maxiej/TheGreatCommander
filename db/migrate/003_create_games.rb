class CreateGames < ActiveRecord::Migration
  def self.up
    create_table :games do |t|
      t.column :map_id, :integer
      t.column :name, :string 
      t.column :password, :string
      t.column :started_at, :datetime
      t.column :whose_turn, :integer
      t.column :is_finished, :boolean
      t.column :security_no, :integer
      t.timestamps
    end
  end

  def self.down
    drop_table :games
  end
end
