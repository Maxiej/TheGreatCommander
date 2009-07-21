class Map < ActiveRecord::Base  
  has_many :games
  has_many :map_terrain_positions
  
  
  def can_move?(x,y)
    
    map_pos = nil
    
    self.map_terrain_positions.find_all_by_x(x).each do |mp|
      map_pos = mp if mp.y == y
    end
    
    unless map_pos.nil?
       map_pos.terrain.terrain_property.can_move
    end
    
  end
  
  def buy_area?(y,is_owner)
    if is_owner 
      y < ConstValues::BUY_AREA_Y        
    else
      y >= (self.size_y - ConstValues::BUY_AREA_Y)        
    end
  end
  
end
