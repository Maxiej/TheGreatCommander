require 'test_helper'

class PlayerUnitTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  def test_truth
    assert true
  end
  
  def test_calling_method_create
    unit = PlayerUnit.find(:first)
    player = Player.find(15)
    opponent_player_id = ''
    counter_x = 10
    counter_y = 1
    offset = [0,2]
    test_create_player_unit_div(unit,player,opponent_player_id,counter_x,counter_y,
      offset) 
  end
  
  def test_create_player_unit_div(unit,player,opponent_player_id,counter_x,counter_y,
      offset)
    
    div = "<div id='[unit(#{unit.id.to_s},#{player.id.to_s})]' class='unit' 
          style='position: relative;
            top: #{test_get_unit_position_top(unit.y,counter_y + offset[1])}; 
            left: #{test_get_unit_position_left(unit.x,counter_x + offset[0])};
            visibility: #{test_visibility(offset,unit)};'>" 
#    puts 'opponent_player ' + opponent_player_id.to_s
#    puts "warunek " + (opponent_player_id == "").to_s   

    div += (test_create_player_unit_checked_link_ unit, player, opponent_player_id).to_s   
      
    div = div +  "</div>"     

    return div
  end    
  
  
  def test_create_image_tag_for_player(unit,player,opponent_player_id)
    if (test_is_blocked(unit,player) == "show_blocked") 
      is_block = true
    else
      is_block = false
    end
    if(is_block)
      image_tag("/unit/#{test_is_blocked(unit,player)}/#{unit.unit.id}",
       :border => 2, 
       :style => "cursor:move; border-color: #{player.color};",                  
       :onclick => "hideMoveRange();",
       :onmouseout => "hideMoveRange();",
       :onmousedown => "showMoveRange(#{unit.id},#{player.id},#{unit.unit.unit_property.range_move},
                        #{[player.game.map.size_x,player.game.map.size_y].to_json});
                        movePlayerUnit(#{unit.id},#{player.id},
                              #{opponent_player_id},
                              #{unit.unit.unit_property.range_move});")    

    else
            image_tag("/unit/#{test_is_blocked(unit,player)}/#{unit.unit.id}",
       :border => 2, 
       :style => "cursor:move; border-color: #{player.color};",                  
       :onclick => "hideMoveRange();",
       :onmousedown => "showMoveRange(#{unit.id},#{player.id},#{unit.unit.unit_property.range_move},
                        #{[player.game.map.size_x,player.game.map.size_y].to_json});
                        movePlayerUnit(#{unit.id},#{player.id},
                              #{opponent_player_id},
                              #{unit.unit.unit_property.range_move});")    

    end
  end
  
  def test_create_image_tag_for_opponent(unit,player)
    image_tag("/unit/show/#{unit.unit.id}",
                    :border => 2,
                    :style => "cursor:move; border-color: #{player.color};",
                    :onclick => "hideMoveRange();",
                    :onmouseout => "hideMoveRange();",
                    :onmousedown => "showMoveRange(#{unit.id},#{player.id},
                                #{unit.unit.unit_property.range_move},
                                #{[player.game.map.size_x,player.game.map.size_y].to_json});")    
  end
  
  
  def test_is_blocked(unit,player)    
    #jesli nie jest ready to znaczy jest faza kupowania, czyli ma byc przestawialny
    unless player.is_ready 
      return "show"
    end
    unless player.is_turn
      return "show_blocked"
    else
      unless unit.is_turn
        return "show_blocked"
      end
    end
    
    return "show"
  end
  
  def test_create_player_unit_checked_link( unit, player, opp_id )    
    
    if opp_id == ""      
      link_to_remote test_create_image_tag_for_opponent(unit,player),
            :url => {:controller => "player", :action => "checked",
            :id => unit.id , :opp => true} 
    else
      link_to_remote test_create_image_tag_for_player(unit,player,opp_id),
            :url => {:controller => "player", :action => "checked",
            :id => unit.id, :opp => false}       
    end    
    
  end
  def test_get_unit_position_left(x, k)
    
    left = 0    
    if(x >= 0)
      left = (x * ConstValues::SIZE_OF_ELEMENT) - ConstValues::WIDTH_OF_LEFTPANEL - (k * ConstValues::SIZE_OF_ELEMENT) + ConstValues::SIZE_OF_ELEMENT
    end
    value = left.to_s + "px"
    return value
    
  end
  
  def test_get_unit_position_top(y,k)
    
    top = 0    
    if(y >= 0)
      top = (y * ConstValues::SIZE_OF_ELEMENT) - ConstValues::SIZE_OF_BOARD - (k * ConstValues::SIZE_OF_ELEMENT)
    end
    value = top.to_s + "px"
    return value
  end
  
  def test_unit_visibility(offset,unit)
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
