module UnitHelper
  
   #informations regarding a clicked unit
   def get_unit_info (id_u)
    unit = Unit.find(id_u)
    info = '<p2> Name: </p2>' + unit.name + '<br/>' +
        '<p2> Strength: </p2>'+ unit.unit_property.strength.to_s + '<br/>' +
        '<p2> Strength range: </p2>' + unit.unit_property.range_strength.to_s + '<br/>' + 
        '<p2> Move range: </p2>' + unit.unit_property.range_move.to_s + '<br/>' +
        '<p2> Price: </p2>' + unit.unit_property.price.to_s + '$' +  '<br/>'+
        '=> Click to see more...'
    return info
  end
  
  def get_unit_position_left(x, k)
    
    left = 0    
    if(x >= 0)
      left = (x * ConstValues::SIZE_OF_ELEMENT) - ConstValues::WIDTH_OF_LEFTPANEL - (k * ConstValues::SIZE_OF_ELEMENT) + ConstValues::SIZE_OF_ELEMENT
    end
    value = left.to_s + "px"
    return value
    
  end
  
  def get_unit_position_top(y,k)
    
    top = 0    
    if(y >= 0)
      top = (y * ConstValues::SIZE_OF_ELEMENT) - ConstValues::SIZE_OF_BOARD - (k * ConstValues::SIZE_OF_ELEMENT)
    end
    value = top.to_s + "px"
    return value
  end
  
  #get current player's and opponent's units positions list in json format
  def set_all_units_pos(curr_p_id, opp_p_id)
    units = Array.new
    player_units = PlayerUnit.find(:all)
      player_units.each { |u| 
        if(u.player_id == curr_p_id)
          if(u.x >= 0) and u.is_alive?
            units << [u.x, u.y, u.id, u.player_id]
          end
        end  
        }
    #jesli curr_player nie jest ready nie ma wyswietlonych unitow przeciwnika
    curr_player = Player.find(curr_p_id)
    if(opp_p_id != -1)
      opp_player = Player.find(opp_p_id)
      if(opp_player.is_ready)and(curr_player.is_ready)
        player_units.each { |u| 
          if(u.player_id == opp_p_id)
            if(u.x >= 0) and u.is_alive?
              units << [u.x, u.y, u.id, u.player_id]
            end
          end  
          }
      end
    end
#    puts units.to_json
    return units.to_json
  end
  
  
  def create_unit_div(unit,player,opponent_player_id)    
    div = "<div id='[availunit(#{unit.id.to_s},#{player.id.to_s})]' 
          class='unit' 
          style='cursor:move; position:relative;'>"          
    
    div += create_properties_info_link(unit,player,opponent_player_id).to_s
    div = div +  "</div>"
    
#    puts div
    return div
  end
  
  def create_properties_info_link(unit,player,opponent_player_id)    
      
      link_to_remote create_image_tag_for_unit(unit,player,opponent_player_id),
            :url => {:controller => "unit", :action => "show_details",
            :id => unit.id}, :update => "unit_info_left"    
    
  end

  def create_image_tag_for_unit(unit,player,opponent_player_id)    
    img_tag = image_tag("/unit/#{is_blocked_unit(player)}/#{unit.id}",
                :border => 2, :style => "cursor:move; border-color: #{player.color};",
                :onmousedown => "buyPlayerUnit(#{unit.id},#{player.id},
                                  #{opponent_player_id}); 
                                showBuyArea(#{ConstValues::BUY_AREA_Y},
                                #{player.game.map.size_y},#{player.is_owner})",
                :onclick =>  "hideBuyArea();")
    return img_tag
  end   
  
  def is_blocked_unit(player)    
    #jesli nie jest ready to znaczy jest faza kupowania, czyli ma byc przestawialny
    unless player.is_ready 
      return "show"
    end
    
    unless player.is_turn
      return "show_blocked"
    end          
    
    return "show"
  end
  
  
  
  def create_draggable_element(unit_id,current_player_id)
#   drag_el = "var drag_#{unit_id.to_s}_#{current_player_id.to_s} = "     
#   drag_el += "new Draggable('[unit(#{unit_id.to_s},#{current_player_id.to_s})]',"
#   drag_el += "{ revert: function(el){return ((Position.page(el)[1] < #{ConstValues::HEIGHT_OF_HEADER})||(Position.page(el)[1] > #{ConstValues::SIZE_OF_BOARD-ConstValues::HEIGHT_OF_HEADER - ConstValues::SIZE_OF_ELEMENT}) ||(Position.page(el)[0] < #{ConstValues::WIDTH_OF_LEFTPANEL}) || (Position.page(el)[0]> #{ConstValues::SIZE_OF_BOARD + ConstValues::WIDTH_OF_LEFTPANEL*2 + ConstValues::SIZE_OF_ELEMENT})) };});"

    drag_el = "dragElements[#{unit_id.to_s}] = "
    drag_el += draggable_element_js("[unit(#{unit_id.to_s},#{current_player_id.to_s})]", 
                  :snap => ConstValues::SIZE_OF_ELEMENT,         
                  :revert => "function(el){
                          return ((Position.page(el)[1] < 
                                  #{ConstValues::HEIGHT_OF_HEADER})
                          ||(Position.page(el)[1] > 
                                  #{ConstValues::SIZE_OF_BOARD-ConstValues::HEIGHT_OF_HEADER - ConstValues::SIZE_OF_ELEMENT}) 
                          ||(Position.page(el)[0] < 
                                  #{ConstValues::WIDTH_OF_LEFTPANEL}) 
                          || (Position.page(el)[0]> 
                                  #{ConstValues::SIZE_OF_BOARD + ConstValues::WIDTH_OF_LEFTPANEL*2 + ConstValues::SIZE_OF_ELEMENT})) }")
    
   
#   drag_el += draggable_element( "[unit(#{unit_id.to_s},#{current_player_id.to_s})]" , 
#                  :snap => ConstValues::SIZE_OF_ELEMENT,         
#                  :revert => "function(el){
#                          return ((Position.page(el)[1] < 
#                                  #{ConstValues::HEIGHT_OF_HEADER})
#                          ||(Position.page(el)[1] > 
#                                  #{ConstValues::SIZE_OF_BOARD-ConstValues::HEIGHT_OF_HEADER - ConstValues::SIZE_OF_ELEMENT}) 
#                          ||(Position.page(el)[0] < 
#                                  #{ConstValues::WIDTH_OF_LEFTPANEL}) 
#                          || (Position.page(el)[0]> 
#                                  #{ConstValues::SIZE_OF_BOARD + ConstValues::WIDTH_OF_LEFTPANEL*2 + ConstValues::SIZE_OF_ELEMENT})) }")
#    
    drag_el = javascript_tag(drag_el)
#    drag_el = javascript_tag("createDraggableElement(#{unit_id},#{playerId})")
    return drag_el
  end
  
  def get_counter_x(counter_x)
    if (counter_x >= 16)
      counter_x = counter_x - 20*(((counter_x-16)/20) + 1)
    end
    return counter_x;
  end
  
  def get_counter_y(counter_x)
    counter_y = 0;
    if (counter_x >= 16) 
      counter_y = (counter_x-16)/20 + 1
    end
    return counter_y;
  end
  
  def unit_visibility(offset,unit)
    if(unit.x >= ConstValues::SIZE_OF_BOARD_EL + offset[0]) or 
        (unit.y >= ConstValues::SIZE_OF_BOARD_EL + offset[1]) or
        (unit.y < offset[1]) or
        (unit.x < offset[0]) or !unit.is_alive?
      return "hidden"
    else
      return "visible"
    end
  end
  
end
