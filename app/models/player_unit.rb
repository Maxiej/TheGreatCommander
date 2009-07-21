class PlayerUnit < ActiveRecord::Base
  belongs_to :unit
  belongs_to :player
  has_many :actions
  
  def move_unit(x,y)   
     self.x = x #if unit change position on the map, is already on the map
     self.y = y
     self.is_turn = false
     self.save!   
     p = Player.find(self.player_id)
     p.save_action(self,"move","moved")
  end
  
  def attack(a_unit)
    if a_unit != nil
      
        hp_taken = self.unit.unit_property.strength - a_unit.unit.unit_property.armor
        hp_recieved = a_unit.unit.unit_property.strength - self.unit.unit_property.strength 
        
        if(hp_taken > 0)
           a_unit.hp_left -= hp_taken
           if(a_unit.hp_left <0)
              a_unit.hp_left = 0 
           end
           a_unit.save!
        else
          hp_taken = 0
        end
        
        if (hp_recieved > 0)
          self.hp_left -= hp_recieved
          if(self.hp_left <0)
              self.hp_left = 0 
           end
          self.save!
        else
          hp_recieved = 0
        end
        
        curr_p = Player.find(self.player_id)
        curr_p.save_attack_action(self.id,a_unit.id, hp_recieved, hp_taken)
        return true
      
      else
#        puts 'nil'
        return false
      end
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
  
  def is_alive?
    self.hp_left > 0
  end
  
end
