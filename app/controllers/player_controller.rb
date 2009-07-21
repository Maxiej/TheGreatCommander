class PlayerController < ApplicationController
  protect_from_forgery :only => [:create, :update, :destroy]    
  
  def show
  end
  
  def set_ready    
    unless logged_in?
      flash[:error] = "You have to be logged in!"
      redirect_to :controller => 'news'
      return
     end
    @p = Player.find(params[:id])
    @p.is_ready = true       
    
    #obydwaj gracze sa ready wiec nalezy pokazac nasze unity opponentowi
    @op = @p.get_opponent  
    if !@op.nil? and @op.is_ready
      a = Action.new
      a.action = "show opp units"
      @p.actions << a
      a.save!
    end
    
    #create action 
    a = Action.new
    a.action = "ready"
    @p.actions << a
    @p.save!
    
    #zczytanie offsetu
    @offset = []
    @offset << params[:offset_x].to_i << params[:offset_y].to_i   
    
    # tworzy online player i zapisuje w nim Ξ•Ξ�e ostatnio wykonaΞ•β€� ruch teraz
    if @p.online_player.nil?
      @p.online_player = OnlinePlayer.new(:last_time_online => Time.now);
    else
      @p.online_player.last_time_online = Time.now
      @p.online_player.save
    end    
      
    
    if !@op.nil? and (@p.is_ready and @op.is_ready)
      # jeΞ•β€Ίli drugi gracz jest ready       
       if (@p.is_owner)
         # jeΞ•β€Ίli drugi gracze jest ready a uΞ•Ξ�ytkownik jest wΞ•β€�aΞ•β€Ίcicielem,
         # to jego tura jest pierwsza
         @p.game.whose_turn = @p.id
         # zapisuje rezultat akcji jΞ”β€¦kΞ”β€¦ podjΞ”β€¦Ξ•β€�
         a.result = "my turn"                 
         # oodblokowywuje wszystkie jednostki, 
         @p.unblock_all_units
       else
         # ustaw jako pierwszy, tura bΞ”β„Άdzie mial przeciwnik
         @p.game.set_owner_next_turn
         # zablokuj wszystkie jednostki
         @p.block_all_units  
         #zapisuje rezultat akcji jakΞ”β€¦ podjΞ”β€¦Ξ•β€�
         a.result = "your turn"
       end
       @p.game.started_at = Time.now 
       @p.game.save!
    else
      # jeΞ•β€Ίli nie jest ready to zablokuj wszystkie jednostki
      @p.block_all_units
      # ustaw na wszelki wypadek whose turn na null
      @p.game.whose_turn = nil
    end      

    # zapisywane sΞ”β€¦ dane
    @p.save! 
    @p.game.save!
    a.save!
    
  end
  
  def opponent_move
    
    #zmienne potrzebne w rjs
    
    @units_moved = []
   
    @units_bought = []
    
    #tablica 2 wymiarowa [atakujacy,atakowany]
    @units_attacked = []       
        
    @your_turn = false
    
    @end_turn = false
    
    @is_ready = false
    
    @is_connected = false
    
    @show_opp_units = false
    
    @money_changed = nil
    #czy wystapil blad
    @error = nil
    
    @console = ""
    
    #==============================
        
    @p = Player.find(params[:id])
    @g = @p.game
    @op = @p.get_opponent
    
    #zczytanie offsetu
    @offset = []
    @offset << params[:offset_x].to_i << params[:offset_y].to_i    
#    puts " @offset  "  + @offset.to_s
#    puts "@op " + @op.id.to_s
    #czy jest oponent
    unless @op.nil?
     
      #sprawdzenie czy sΞ”β€¦ nowe akcjΞ”β„Ά
      actions = @op.get_actions(@p.online_player.last_time_updated)      
      
      unless actions.nil?
        
        #proces synchronizacji
        
        actions.each{ |a|
          
          if a.action == "move"
            
            @units_moved << a.player_unit           
            
          else
            if a.action == "buy"
              
              @units_bought << a.player_unit 
              p = Player.find(a.player_id)
              @money_changed = p.gold
#              puts("length" + @units_bought.length.to_s)
              
            else              
              if a.action == "attack"
                
                 plu = PlayerUnit.find(a.unit_attacked_id)
                 
                 @units_attacked << [a.player_unit , plu, a.hp_taken, a.hp_received]                                               
                
              else
                if a.action == "end turn"
                  
                  @end_turn = true    
                  @your_turn = true                     
                  
                else 
                  if a.action == "ready"
                    
                    if a.result == "your turn"
                      @your_turn = true                     
                    end
                    @is_ready = true
                  else
                    
                    if a.action == "connect"
#                      puts "connect"
                      @is_connected = true                    
                    else 
                      if a.action == "show opp units"
                        @show_opp_units = true
                      else
                        @error = "Incorrect action <br/>" 
                      end
                    end                                                      
                  end
                end
              end              
            end            
          end          
          
        }
        
        #updatuje, odczytal akcje
        @p.action_updated
        
      else        
        @error = "Action not taken <br/>"        
      end
      
    else
#      @error = "Waiting for player"
    end
    
    #zle
#    render :update do |page|
#      unless op.nil? or op.online_player.nil? 
#        if op.is_online()  
#         page.alert("oponent is online") 
#        end      
#      end
#    end
    
    # no tak najpierw sprawdz czy online_player.last_time_updated jest nullem
    # jesli jest nullem to rozpoczyna sie proces synchronizacji
    # wpp sprawdza czy last_time_online > last_time_updated, jesli tak 
    # to zapisuje do bazy now i rozpoczyna proces synchronizacji
    
    
    #proces synchronizacji
    # 1. odpowiedni wpis w console
    # 2. sprawdzenie wszystkich jednostek oppeneta, ruszenie ich, pokazanie nowych
    # najlepiej zeby migaly, te ktory sie zmienily
    # 3 sprawdzenie czy nie zaatakowal jesli tak to zmniejszenie energi i miganie,
    # zaatakowanych jednostek
    # 4. sprawdzenie czy nie nacisnal end turn, jest tak to trzebe odblokowac wszystkie
    # jednostki
    # 5. sprawdzenie czy to nie koniec gry
    # 6. na przyszosc sprawdznie wiadomosci z czata
  end  
  
  def checked
    unless logged_in?
      flash[:error] = "You have to be logged in!"
      redirect_to :controller => 'news'
      return
     end
    @player_unit = PlayerUnit.find(params[:id])      
    @player = @player_unit.player    
    @opp = params[:opp]    
  end

end
