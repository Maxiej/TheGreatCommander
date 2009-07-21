class AddCheckedBlockedColumnToUnits < ActiveRecord::Migration
  def self.up
    add_column "units", "image_blocked_checked", :binary
  end

  def self.down
    remove_column "units", "image_blocked_checked"
  end
end
