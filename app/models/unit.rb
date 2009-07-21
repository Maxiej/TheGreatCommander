class Unit < ActiveRecord::Base
  validates_uniqueness_of :name
  has_one :unit_property
  has_many :player_units
  
  def get_unit_position(p_id)
    @unit_pos = PlayerUnit.find(:all)
    @unit_pos.each{|u_pos|
      if((u_pos.unit_id == self.id)&&(u_pos.player_id == p_id))
        return u_pos
      end
    }
    return nil
  end
  
  def get_prev_pos(x,y)
    unit_pos_prev = Array.new
    unit_pos_prev << [x, y, self.id]
#    puts unit_pos_prev.to_json
    return unit_pos_prev.to_json
  end
  
  
   def is_on_board(p_id)
    unit_positions = PlayerUnit.find(:all)
    unit_positions.each { |u_pos| 
      if((u_pos.unit_id == self.id)&&(u_pos.player_id == p_id))
        return true;
      end
    }
    return false;
  end 

  def is_on_other_unit(p_id,o_id,x,y)
     p = Player.find(p_id)   
     p_unit = p.player_units.find(:first, 
        :conditions => ["x = ? and y = ? and hp_left > ?", x, y , 0])
     if(o_id != -1) and (p_unit.nil?)
       o = Player.find(o_id)
       p_unit = o.player_units.find(:first, 
          :conditions => ["x = ? and y = ? and hp_left > ?", x, y , 0])
     end
     return p_unit
   end
  
end
