class AddIsReadColumn < ActiveRecord::Migration
  
  def self.up
    
    add_column "messages", "is_read","bool",:default => false
    remove_column "messages", "read"
    
  end

  def self.down
    
    remove_column "messages", "is_read"
    add_column "messages", "read","bool",:default => false
    
  end
end
