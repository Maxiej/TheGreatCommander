class DeleteAndAddNews < ActiveRecord::Migration
  def self.up
    self.drop_table("news")
    create_table :news do |t|
      t.column :title, :string, :null => true
      t.column :content, :string
      t.column :user_id, :int
      t.column :publication_date, :datetime, :null => true
      t.timestamps
    end
  end

  def self.down
    self.drop_table("news")
     create_table :news do |t|
      t.column :title, :string, :null => true
      t.column :content, :string
      t.column :author, :string , :null => true
      t.column :publication_date, :datetime, :null => true
      t.timestamps
     end
  end
end
