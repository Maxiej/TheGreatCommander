class CreateMessages < ActiveRecord::Migration
  def self.up
    create_table :messages do |t|

      t.column :title, :string
      t.column :user_id, :integer
      t.column :to, :string
      t.column :content, :string
      t.timestamps
    end
  end

  def self.down
    drop_table :messages
  end
end
