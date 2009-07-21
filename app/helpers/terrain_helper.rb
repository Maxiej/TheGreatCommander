module TerrainHelper
  
    
  def show_description(t_id)
    terrain = Terrain.find(t_id)
    info = '<b>'+terrain.terrain_property.name.to_s + '</b><br/>' 
#           '<p2>Can move?: </p2>'
    if(terrain.terrain_property != nil)
      if(terrain.terrain_property.can_move)
#        info +=  'You can move your units' + '<br/>'
      else
        info += 'You <b>cannot</b> move on this terrain.' + '<br/>'
      end
#      info += '<p2>Move ratio: </p2>' + terrain.terrain_property.move_ratio.to_s + '<br/>'

#      if(terrain.terrain_property.defend_rate != nil)
#          info +='<p2>Defend rate: </p2>' + terrain.terrain_property.defend_rate.to_s + '<br/>'
#      end

#      info +='<p2>Is mine?: </p2>' 
#      if(terrain.terrain_property.is_mine)
#        info +=  'Yes' + '<br/>' + 
#          '<p2>Gold per turn: </p2>' +terrain.terrain_property.gold_per_turn.to_s + '$'
#      else
#        info += 'No' + '<br/>'
#      end
    end
    return info
  end
  
  def display(offset,x,y)
    if ((x >= offset[0]) and (x < offset[0] + ConstValues::SIZE_OF_BOARD_EL)) and 
       ((y >= offset[1]) and (y < offset[1] + ConstValues::SIZE_OF_BOARD_EL)) 
       return "inline"
    end 
    return "none"
  end
  
  
end
