module GameHelper 
  
  def join_game?(game, player)
    if game.players.find(player.id)      
      
      return true
    end
    return false
  end
  
  def get_game_name_by_id(game_id)
    game = Game.find(game_id)
    return game.name
  end
  
  def active_tab(ac_tab,cur_tab)
    if ac_tab == cur_tab 
      return "active_tab"
    else 
      return "nonactive_tab"
    end
  end   
  
  def button_display(is_ready)
    if is_ready
      return "none"
    else
      return "inline"
    end
  end  
    
  def message(game,player)
    message = ""
    unless game.is_started
      if game.players.count == 1
        message = "Waiting for player ... <br/>"
      else
        if player.is_ready
          message = "Waiting for other player ... <br/>"
        else 
          message = "To start game press ready button."
        end
      end
    end
    return message
  end 
  
  #console
  def console_move(player_unit)
   Time.now.asctime.to_s + ": <b>" +  player_unit.unit.name + "</b> moved. <br/>"   
  end
  
  def console_buy(player_unit)
   Time.now.asctime.to_s + ": Oponent bought <b>" +  player_unit.unit.name + "</b>." + "<br/>"  
  end
  
  def console_attack(pu, pu_attacked)
    mes = "<font color= 'blue'>" + Time.now.asctime.to_s + ": Your " + pu_attacked.unit.name + " has been attacked by " 
    mes += "<b>" +  pu.unit.name + "</b>" + ".<br/></font>"
    return mes
  end
  
  def console_attacking(unit, attacked)
     mes = "<font color= 'blue'>"+Time.now.asctime.to_s + ": Your " + unit.unit.name + " attacked " 
    mes += "<b>" +  attacked.unit.name + ".</b>" + "<br/></font>"
    return mes
  end
  
  def console_unit_on_your_unit(unit)
    return "<font color= 'green'>"+Time.now.asctime.to_s + ": <b>" + unit.unit.name + "</b> cannot be on other your unit. </font><br/>"
  end
  
  def console_unit_on_other_unit
    return "<font color= 'green'>"+Time.now.asctime.to_s + ": You cannot put your unit on other unit during buying.</font><br/>"
  end
  
  def console_endturn(op_player)
    Time.now.asctime.to_s + ": <b>" + op_player.user.login + "</b>" + " has ended turn. <br/>"    
  end
  
  def console_yourturn
    Time.now.asctime.to_s + ": Now it is your turn. <br/>"
  end
  
  def console_ready(op_player)
   Time.now.asctime.to_s + ": " + op_player.user.login + " is ready. <br/>"   
  end
  
  def console_money_changed(op_player)
    Time.now.asctime.to_s + ": " + op_player.user.login + " now has #{op_player.gold} gold. <br/>"   
  end
  
  def console_connected(op_player)
    Time.now.asctime.to_s + ": " + op_player.user.login + " has connected. <br/>"   
  end
  
  def console_cannot_move(unit)
    "<font color= 'green'>"+Time.now.asctime.to_s + ": <b>" + unit.name + "</b> cannot move on this type of terrain. </font><br/>"
  end
  
  def console_unit_destroy(unit, unit_attacked)
    "<font color= 'red'>"+Time.now.asctime.to_s + ": <b>" + unit.unit.name + "</b> destroyed unit " + unit_attacked.unit.name+ ".</font><br/>"
  end

  def console_all_destroyed(unit,unit_attacked)
    "<font color= 'red'>"+Time.now.asctime.to_s + ": " + unit.unit.name + " and " + unit_attacked.unit.name + " destroyed each other.</font><br/>"
  end
  
  def update_console(text)
    "appendConsole(\"#{text.to_s}\");"
  end
  
  def console_not_buy_area
    "<font color= 'green'>"+Time.now.asctime.to_s + ": You cannot move unit outside buy area, when you are not read </font><br/>"
  end
  
  def console_afford(unit)
    "<font color= 'red'>"+Time.now.asctime.to_s + ": You don't have enough money to buy <b> #{unit.name} </b> </font><br/>"
  end
  #==============================
  
end
