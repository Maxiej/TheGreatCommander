class AddImagesColumnToUnit < ActiveRecord::Migration
  
  def self.up
    add_column "units", "image_blocked", :binary
    add_column "units", "image_checked", :binary
  end

  def self.down
    remove_column "units","image_blocked"
    remove_column "units","image_checked"
  end
  
end
