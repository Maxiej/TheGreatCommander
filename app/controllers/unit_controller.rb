class UnitController < ApplicationController
end
layout('image')
protect_from_forgery :only => [:create, :update, :destroy]

  #wyswietlenie zwyklego obrazka jednostki
  def show
    unit = Unit.find(params[:id]) 
    @image = unit.image
    send_data(@image,:type => "image/gif", :filename => unit.name + ".jpg",
      :disposition => 'inline')
  end
  
  #wyswietlanie obrazka zablokowanego, po dokonanym ruchu
  def show_blocked
    unit = Unit.find(params[:id]) 
    @image = unit.image_blocked
    send_data(@image,:type => "image/gif", :filename => "blocked_"+unit.name + ".png",
      :disposition => 'inline')
  end
  
  #wyswietlenie obrazka zaznaczonego
  def show_checked
    unit = Unit.find(params[:id]) 
    @image = unit.image_checked
    send_data(@image,:type => "image/gif", :filename => "checked_"+unit.name + ".png",
      :disposition => 'inline')
  end
  
  #wyswietlenie obrazka zaznaczonego - zablokowanego
  def show_blocked_checked
    unit = Unit.find(params[:id]) 
    @image = unit.image_blocked_checked
    send_data(@image,:type => "image/gif", :filename => "blocked_checked_" + unit.name + ".png",
      :disposition => 'inline')
  end
  
  
  def show_all
    @units = Unit.find(:all, :order=>"name")
  end
  
  #unit (juz zakupiona) jest przesuwana na planszy i jego pozycja zostaje zapisana w bazie
  def leave    
     #zabezpieczenie przed nieautoryzowanym wejsciem
    unless logged_in?
      flash[:error] = "You have to be logged in!"
      redirect_to :controller => 'news'
      return
     end
     #-------------------------------
    @unit = PlayerUnit.find(params[:unitid])
    @curr_player = Player.find(params[:curr_player_id])      

    @can_move = true
    @buy_area = true
    @attacked_unit = nil
    @on_other_your_unit = false

    redirect_to :controller => "news" if @curr_player.nil?     
         
    @opp_player = @curr_player.get_opponent      
     
    if @opp_player.nil?
      @opp_player_id = -1
    else 
      @opp_player_id = @opp_player.id
    end
    
    #new unit positions    
    x = params[:x].to_i 
    y = params[:y].to_i      
    
    #jesli nie da sie postawic na to miejsce
    @can_move = @curr_player.game.map.can_move?(x,y)
    return unless @can_move
    
    #jezeli uzytkownik jest w fazie ustawiania i przestawi jednostke za obszar
    # buy_area, to musi zostac cofnac
    unless @curr_player.is_ready
      @buy_area = @curr_player.game.map.buy_area?(y,@curr_player.is_owner)
      return unless @buy_area  
    end
      
    #uzytkownik moze ruszac jednostki do woli gdy nie jest ready, czyli jest 
    #faza ustawiania
    unless @curr_player.is_ready
      if (x >= 0) 
         @unit.x = x #jesli unit zmienil pozycje, jest juz na mapie
         @unit.y = y
         @unit.save
      else
         @curr_player.change_money(@unit.unit.id,true)
         @unit.destroy #jesli unit jest ustationy na tej samej pozycji co wczesniej
         return         
      end     
    else
    # jezeli uzytkownik jest ready, to oznacza ze toczy sie wlasciwa rozgrywka
    # czyli jednostka musi miec ruch i musi byc tura playera
        if (@unit.is_turn and @curr_player.is_turn )
          # tutaj powinnien byc revert, czyli sprawdzenie pozycji jesli zla cofniecie
          if (x >= 0) 
            #sprawdzenie czy nie nakladam swoje unity
             existing_unit = @unit.is_on_other_unit(@curr_player.id,@opp_player_id,x,y)
             if(!existing_unit.nil?)
               if(existing_unit.player_id == @curr_player.id)
                 @on_other_your_unit = true
                 @unit.is_turn = true
                 @unit.save!
                 return @on_other_your_unit
               else
                 #tutaj nastepuje walka          
                 #if unit change position on the map, is already on the map
                  @attacked_unit = existing_unit
                  @unit.is_turn = false
                  @unit.save!                  
                  @unit.attack(@attacked_unit)
                  if(@unit.is_alive?)&&(!@attacked_unit.is_alive?)
                    @unit.move_unit(x,y)
                  elsif !@unit.is_alive? && @attacked_unit.is_alive?
                      return @attacked_unit
                  elsif !@unit.is_alive? && !@attacked_unit.is_alive?
                      return @attacked_unit
                  end
                 end
             else
               @unit.move_unit(x,y)
             end
          else         
            render :update do |page|
              page.alert("error, leave, wrong")
            end    
          end      
        else
          render :update do |page|
            debug = "error, player.is_turn #{@curr_player.is_turn} " 
            debug += "player.is_ready #{@curr_player.is_ready}  "
            debug += "unit.is_turn #{@unit.is_turn}  "
            page.alert(debug)
          end    
        end      
    end  
          
  end
  
  #kupowanie jednostek i wrzucanie na plansze
  def buy   
    #zabezpieczenie przed nieautoryzowanym wejsciem
    unless logged_in?
      flash[:error] = "You have to be logged in!"
      redirect_to :controller => 'news'
      return
     end   
     #---------------------
     
    #zczytywanie parametrow
    @unit = Unit.find(params[:unitid])
    @curr_player = Player.find(params[:curr_player_id])    
    @offset = [params[:offsetX].to_i,params[:offsetY].to_i]    
    x = params[:x].to_i 
    y = params[:y].to_i    
    #------------------------
    
    #deklaracja zmiennych
    @can_move = true 
    @buy_area = true  
    @can_buy = true    
    @on_other_unit = false
    @player_units = []
    @opp_player = nil
    @counter_x = 0
    #--------------------------

    #ustawienie zmiennyc
    @player_units = @curr_player.player_units
    @opp_player = @curr_player.get_opponent
    
    @opp_player.nil? ? @opp_player_id = -1 : @opp_player_id = @opp_player.id    
    @counter_x = @curr_player.player_units.length  
    #---------------------------  
    
    #ustawianie coutera w zależnosci od tego czy jest faza ready czy nie
    unless @opp_player.nil?
      if (@opp_player.is_ready) and 
          (@opp_player.action_ready_received?(@curr_player.online_player.last_time_updated))
        @counter_x = @curr_player.game.units_quantity        
      end
    end    
    #----------------------------------   
       
    #czy jednostka zostala postawiona na innej jednostce    
    existing_unit = @unit.is_on_other_unit(@curr_player.id,@opp_player_id,x,y)
    unless existing_unit.nil?
      @on_other_unit = true
      return @on_other_unit
    end
    #-----------------------------
     
    #jesli player nie ma wystarczajacej srodkow na koncie
    @can_buy = @curr_player.can_buy?(@unit)
    return unless @can_buy    
             
    #jesli nie da sie postawic na to miejsce
    @can_move = @curr_player.game.map.can_move?(x,y)
    return unless @can_move    
    
    #jeΕ›li uΕΌytkownik siΔ™ w fazie ustawiania i przestawi jednostkΔ™ za obszar
    # buy_area, to musi zostac cofniΔ™ty
    unless @curr_player.is_ready
      @buy_area = @curr_player.game.map.buy_area?(y,@curr_player.is_owner)
      return unless @buy_area  
    end
    
    #ustawianie jednostki (tworzenie nowego player_unit, 
    #jestli jednostka jest na mapie
    if( (x >= 0) and (y >= 0) and (x <= @curr_player.game.map.size_x) and 
        (y <= @curr_player.game.map.size_y) )
    
        @curr_player.change_money(@unit.id,false)
        
        #tworzenie nowego player_unit
        @new_player_unit = PlayerUnit.new( :x => x, :y => y)
        @new_player_unit.hp_left = @unit.unit_property.hp
        @new_player_unit.player_id = @curr_player.id 
        @new_player_unit.unit_id = @unit.id                                   
        
        if  @curr_player.is_ready
          @new_player_unit.is_turn = false
          #trzeba zapisac kiedy player wykonac ruch          
          #trzeba zapisac ruch jaki wykonac 
          @curr_player.save_action(@new_player_unit, "buy", "bought")
        end
        
        @new_player_unit.save!     
        #------------------------------
        
    else 
      #jesli jednostka zostala postawina poza plansza
      render :update do |page|
        page.alert("FATAL error, unit is outside the game board")
      end        
    end         
    #-----------------------
     
  end
  
  def set_units
    #zabezpieczenie przed nieautoryzowanym wejsciem
    unless logged_in?
      flash[:error] = "You have to be logged in!"
      redirect_to :controller => 'news'
      return
     end
     #-----------------------------------------
    @curr_player = Player.find(params[:curr_player_id])
    if(params[:opp_player_id] != nil)
      @opp_player_id = params[:opp_player_id].to_i
    else
      @opp_player_id = -1
    end
  end
  
  #wlasciwosci jednostki sa pokazywane po kliknieciu przez usera
  def show_details
    @unit = Unit.find(params[:id])
    render :partial => 'unit/unit_info', :locals => { 
          :u_name => @unit.name,
          :u_strength => @unit.unit_property.strength.to_s, 
          :u_str_range => @unit.unit_property.range_strength.to_s,
          :u_atck_range => @unit.unit_property.range_attack.to_s,
          :u_move_range => @unit.unit_property.range_move.to_s,
          :u_armor => @unit.unit_property.armor.to_s,
          :u_price => @unit.unit_property.price.to_s,
          :u_hp => @unit.unit_property.hp.to_s,
          :u_is_flying => @unit.unit_property.is_flying,
          :u_is_shooting => @unit.unit_property.is_shooting
          } 
  end  
    
end
