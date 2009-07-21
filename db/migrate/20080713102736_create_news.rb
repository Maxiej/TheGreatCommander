class CreateNews < ActiveRecord::Migration
  
  def self.up
    create_table :news do |t|
      t.column :title, :string, :null => true
      t.column :content, :string
      t.column :author, :string , :null => true
      t.column :publication_date, :datetime, :null => true
      t.timestamps
    end
  end

  def self.down
    drop_table :news
  end
end
