class CreateActions < ActiveRecord::Migration
  def self.up
    create_table "actions", :force => true do |t|        
        t.column :player_id,:integer
        t.column :action, :string
        t.column :player_unit_id, :integer
        t.column :unit_attacked_id, :integer
        t.column :hp_taken, :integer
        t.column :hp_received, :integer
        t.column :result, :string
        t.timestamps        
    end
  end

  def self.down
     drop_table "actions"
  end
end
