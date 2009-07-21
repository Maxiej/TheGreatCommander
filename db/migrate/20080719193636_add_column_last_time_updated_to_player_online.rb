class AddColumnLastTimeUpdatedToPlayerOnline < ActiveRecord::Migration
  def self.up
    add_column "online_players","last_time_updated", :datetime
  end

  def self.down
    remove_column "online_players","last_time_updated"
  end
end
