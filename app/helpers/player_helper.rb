module PlayerHelper
  
  def ready_color(player)
    
    if player.is_ready?
       return "green"
    else
      return "red"
    end   
    
  end
  
      
  def star_display(is_ready)
    if is_ready
      return "inline"
    else
      return "none"
    end
  end 
  
  def move_player_unit(unit,player)
    "changePlayerUnitPosition(#{unit.id.to_s},#{player.id.to_s},#{unit.x.to_s},#{unit.y.to_s})"
  end  
 
  def create_attack_tooltip(unit,player,opp_id)
    if opp_id != ""
      div = "<div id='bubble_tooltip_attack_#{unit.id.to_s}_#{player.id.to_s}' class='bubble_tooltip'>
            <div class='bubble_top'><span></span></div>
            <div class='bubble_middle'>
               <span id='bubble_tooltip_content_attack_#{unit.id.to_s}_#{player.id.to_s}' class='bubble_tooltip_content'>
               </span>
            </div>
            <div class='bubble_bottom'></div>
        </div>"
    end
    return div
  end

  def create_player_unit_checked_link( unit, player, opp_id )    
    
    if opp_id == ""      
      link_to_remote create_image_tag_for_opponent(unit,player),
            :url => {:controller => "player", :action => "checked",
            :id => unit.id , :opp => true} 
    else
      link_to_remote create_image_tag_for_player(unit,player,opp_id),
            :url => {:controller => "player", :action => "checked",
            :id => unit.id, :opp => false}       
    end    
    
  end
  
  def create_player_unit_div(unit,player,opponent_player_id,counter_x,counter_y,
      offset)
#     puts 'opponent_player ' + opponent_player_id.to_s
#     puts 'player ' + player.to_s
#     puts "unit " + unit.to_s
#     puts "unit.id " + unit.id.to_s
#     puts "unit.x " + unit.x.to_s
#     puts "unit.y " + unit.y.to_s
#     puts "counter_y " + counter_y.to_s
#     puts "counter_x " + counter_x.to_s
#     puts "offset[1] " + offset[1].to_s
#     puts "offset[0] " + offset[0].to_s
#     
#    puts 'x='+ offset[0].to_s
#    puts 'y='+ offset[1].to_s
    div = "<div id='[unit(#{unit.id.to_s},#{player.id.to_s})]' class='unit' 
          style='position: relative;
            top: #{get_unit_position_top(unit.y,counter_y + offset[1])}; 
            left: #{get_unit_position_left(unit.x,counter_x + offset[0])};
            visibility: #{unit_visibility(offset,unit)};'>" 

    div += (create_player_unit_checked_link unit, player, opponent_player_id).to_s   
#    div += (create_attack_tooltip unit, player, opponent_player_id).to_s
    div = div +  "</div>"     
    
    return div
  end    
 
  
  def create_image_tag_for_player(unit,player,opponent_player_id)
    if (is_blocked(unit,player) == "show_blocked") 
      is_block = true
    else
      is_block = false
    end
    if(is_block)
      image_tag("/unit/#{is_blocked(unit,player)}/#{unit.unit.id}",
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
            image_tag("/unit/#{is_blocked(unit,player)}/#{unit.unit.id}",
       :border => 2, 
       :style => "cursor:move; border-color: #{player.color};",                  
       :onclick => "hideMoveRange();",
#       :onmouseout => "hideMoveRange();",
       :onmousedown => "showMoveRange(#{unit.id},#{player.id},#{unit.unit.unit_property.range_move},
                        #{[player.game.map.size_x,player.game.map.size_y].to_json});
                        movePlayerUnit(#{unit.id},#{player.id},
                              #{opponent_player_id},
                              #{unit.unit.unit_property.range_move});")    

    end
  end
  
  def create_image_tag_for_opponent(unit,player)
    image_tag("/unit/show/#{unit.unit.id}",
                    :border => 2,
                    :style => "cursor:move; border-color: #{player.color};",
                    :onclick => "hideMoveRange();",
                    :onmouseout => "hideMoveRange();",
                    :onmousedown => "showMoveRange(#{unit.id},#{player.id},
                                #{unit.unit.unit_property.range_move},
                                #{[player.game.map.size_x,player.game.map.size_y].to_json});")    
  end
  
  
  def is_blocked(unit,player)    
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
   
  def attack_result_info(unit,attacked_unit)
    text = ""
    actn = Action.find(:first,
        :conditions => {:player_unit_id => unit.id, 
          :unit_attacked_id => attacked_unit.id, :action => "attack"})
     
    unless actn.nil?
      text += "<b><u>#{unit.unit.name.upcase} vs. #{attacked_unit.unit.name.upcase}</u></b><br/><br/>"
      if(!unit.is_alive? and !attacked_unit.is_alive?)
        text += "<b>Units #{unit.unit.name} and #{attacked_unit.unit.name} kill each other!!</b><br/>"
      else
        if(!unit.is_alive?)
          text +="<b> Your army #{unit.unit.name} was killed!! </b><br/>"
        end
        if(!attacked_unit.is_alive?)
          text +="<b> Your army #{unit.unit.name} killed #{attacked_unit.unit.name}!!</b><br/>"
        end
      end
      text +="hp taken: #{actn.hp_taken.to_s}<br/>"
      text +="hp recieved: #{actn.hp_received.to_s}<br/>"
    end
    text += create_link_close().to_s
    return text
  end
  
  def attack_opponent_result_info(unit,attacked_unit,hp_taken,hp_received)
    text = ""
     
      text += "<b><u>#{unit.unit.name.upcase} vs. #{attacked_unit.unit.name.upcase}</u></b><br/><br/>"
      if(!unit.is_alive? and !attacked_unit.is_alive?)
        text += "<b>Units #{unit.unit.name} and #{attacked_unit.unit.name} kill each other!!</b><br/>"
      else
        if(!unit.is_alive?)
          text +="<b> Your army #{attacked_unit.unit.name} killed attacking unit!! </b><br/>"
        end
        if(!attacked_unit.is_alive?)
          text +="<b> Your army #{attacked_unit.unit.name} was killed by #{unit.unit.name}!!</b><br/>"
        end
      end
      text +="hp taken: #{hp_received.to_s}<br/>"
      text +="hp recieved: #{hp_taken.to_s}<br/>"
      text += create_link_close().to_s
    return text
  end
  
  def create_link_close()
    div = link_to_function "close","hideAttackResultToolTip()"
    return div
  end
end

