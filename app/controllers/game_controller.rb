class GameController < ApplicationController  
   protect_from_forgery :only => [:create, :update, :destroy]  
    
 @@ONLINE_TIME = 30
 
  # sprawdza czy użytkownik o danym loginie jest online 
   def online 

     @online = false
     @login = params[:login]     
     @user = User.find_by_login(@login)         

     if @user && @user.last_time_online
       
       @login = @user.login       
       @online = is_online(@user.last_time_online)     
       
     else
       
       @login = ""
       
     end
     
     render :partial =>  'online'
     
   end

def is_online(time1)
    
      return if (time1.getutc.year - Time.now.getutc.year) != 0
      return if (time1.getutc.month - Time.now.getutc.month) != 0
      return if (time1.getutc.day - Time.now.getutc.day) != 0
      return if (time1.getutc.hour - Time.now.getutc.hour) != 0
      return if (time1.getutc.min - Time.now.getutc.min) != 0
      return if (time1.getutc.sec - Time.now.getutc.sec) > @@ONLINE_TIME
      return true         
     
   end   
   
  def play
    unless logged_in?
      flash[:error] = "You have to be logged in!"
      redirect_to :controller => 'news'
      return
     end
     
    @game = Game.find(params[:id])
    if @game.is_finished
      redirect_to :action => "finish_game", :id => @game.get_looser_id
    end
    
    @map = @game.map
    @map_positions = @map.map_terrain_positions
    @available_units = Unit.find(:all)
    @new_unit_counter = 0
    
    @current_player = nil
    @opponent_player = nil
    if(@game.players.count > 0)
      @game.players.each {|p|  
        if(p.user.id == current_user.id)
          @current_player = p          
          @units = @current_player.player_units          
        else
          @opponent_player = p
        end
      }
    end
    if(@current_player.is_owner)
      @offset = [0,0]
    else
      @offset = [0,@current_player.game.map.size_y - ConstValues::SIZE_OF_BOARD_EL]
    end
    
    #stworzenie online player 
    @current_player.create_online
    
#    if(@current_player == nil)
#      @current_player = Player.create
#      @current_player.user = User.find(current_user.id)
#      @current_player.gold = ConstGame::START_GAME_MONEY
#      @current_player.game_id = @game.id
#      @current_player.save
#    end

    if(@opponent_player != nil)
      @opponent_player_id = @opponent_player.id
      @opp_units = @opponent_player.player_units
    else
      @opponent_player_id = -1
    end
#    puts "play"    
  end     

  def show
    
  end
  
  def finish_game
    @is_winner = false
    @looser = Player.find(params[:id])
    @winner = @looser.get_opponent
    game = Game.find(@looser.game_id)
    if(!game.is_finished) #ustawiamy losses i wins tylko za pierwszym raziem
      @looser.set_no_of_losses
      @winner.set_no_of_wins
      game.is_finished = 1
      game.save!
    end
    @is_player = game.is_player_by_user_id(current_user.id)
    if(@is_player)
      if(@looser.user_id == current_user.id)  
          flash.now[:error] = "You are the looser of game <b>"  + game.name + "</b>!!"
          @is_winner = false 
      else
        flash.now[:notice] = "You are the winner of game <b>" + game.name + "</b>!!"
        @is_winner = true 
      end
    end
#    render :partial => 'player/statistics'
  end
  
  def show_yours
    unless logged_in?
      flash[:error] = "You have to be logged in!"
      redirect_to :controller => 'news'
      return
     end
     
    @counter = 0
    @active_tab = 0
    @user = User.find(params[:id])
    @players = Player.find_all_by_user_id(params[:id])    
    @games = []
    
    unless @players.nil? 
      @players.each{ |player|
        if player.game 
          @games << player.game        
        end                 
      }      
    end       
    
    @games = @games.paginate :per_page => 10, :page => params[:page]
    
    render :action => "show"
    
  end
  
  def show_all
    
    @games = Game.find(:all).paginate :per_page => 10, :page => params[:page]
    @user = User.find(params[:id])
#    @user.check
    @active_tab = 1
    render :action => "show"
  end
  
  def create
    unless logged_in?
      flash[:error] = "You have to be logged in!"
      redirect_to :controller => 'news'
      return
     end
     
    @game = Game.new(params[:game])  
    @player = Player.new(params[:player])    
    @player.user_id = current_user.id
    @player.gold = ConstValues::GOLD_AT_START
    @player.is_owner = true
    @player.no_of_mines = 0    
# TODO create online player    
    @player.is_ready = false     
    
    @game.whose_turn = @player.id
    
    @game.save
    @player.game_id = @game.id
    @player.save
    
    if @game.errors.empty? && @player.errors.empty?      
      redirect_to :action => "play", :id => @game.id 
#      flash[:notice] = "Game #{@game.name} created!"
    else
      flash[:error] = "Game cannot be created!"
      render :action => 'new'
    end     
    
  end 
  
  def div_element_id(x,y)
    return ((x-1)*ConstValues::SIZE_OF_BOARD_EL + y).to_s
  end  
    
  def move
    pos = find_logic_position(params[:x].to_i, params[:y].to_i)    
    @id = div_element_id(pos[0] + 1,pos[1] + 1)      
  end  
   
  def authenticate    
     password = params[:Password]
     game = Game.find(params[:id])
     
     render :update do |page|
       if password != game.password
        page[:Password].value = ""
        page[:bad_password ].hide()        
        page[:bad_password ].innerHTML = "Invalid"
        page.visual_effect :BlindDown, :bad_password        
        page[:password_checking].hide();
       else
        page.redirect_to :action => 'play', :id => game.id
       end
     end
  end
  
  def join
     unless logged_in?
      flash[:error] = "You have to be logged in!"
      redirect_to :controller => 'news'
      return
     end
     
     if params[:Password]
        password = params[:Password]
     end 
     game = Game.find(params[:id])     
      
     render :update do |page|       
       if (game.password != "" or game.password.nil?) and password != game.password
        page[:Password].value = ""
        page[:bad_password ].hide()        
        page[:bad_password ].innerHTML = "Invalid"
        page.visual_effect :BlindDown, :bad_password        
        page[:password_checking].hide();
       else
        if game.players.count == 2           
          page[:bad_password ].hide()        
          page[:bad_password ].innerHTML = "Sorry, Someone else has already joined game."
          page.visual_effect :BlindDown, :bad_password        
          page[:password_checking].hide();
        else
          game.add_player(Player.new(params[:player]),current_user)          
          page.redirect_to :action => 'play', :id => game.id
        end        
       end
    end    
    
  end
  
  def owned_games
    unless logged_in?
      flash[:error] = "You have to be logged in!"
      redirect_to :controller => 'news'
      return
     end
     
    @user = User.find(params[:id])  
    @games = Game.find_owned_games(@user.id)    
    
    return unless request.xhr?
    render :partial => 'owned_games'
    
  end
  
  def delete
    unless logged_in?
      flash[:error] = "You have to be logged in!"
      redirect_to :controller => 'news'
      return
     end
    g = Game.find(params[:id])    
    unless g.nil?
      name = g.name
      g.players.each{ |p|
        p.destroy
      }
      g.destroy
      flash[:notice] = "Game #{name} has been deleted!"     
      
    else
      flash[:notice] = "Game has already been deleted!"
           
    end
    
    redirect_to( :controller => 'users', :action => 'show',
                :id => current_user.id, :tab => 0 ) 
  end
  
  def end_turn()    
    unless logged_in?
      flash[:error] = "You have to be logged in!"
      redirect_to :controller => 'news'
      return
     end
    g = Game.find(params[:id])
    p = Player.find(params[:player_id])  
        
#    puts "p.is_turn " + p.is_turn.to_s
    if p.is_turn      
      g.end_turn(params[:player_id])      
    end 
    
    render :update do |page|
      page['end_turn_commit'].disabled = true
      #zablokowac wszystkie jednostki
      unless p.player_units.nil?
        p.player_units.each do |u|
          if u.is_alive?
            page << "destroyDraggableElement(#{u.id.to_s},#{p.id.to_s},true);"
            page << "changeDivImageToBlocked(#{u.id.to_s},#{p.id.to_s},#{u.unit.id});"
            page << "hideAttackResultToolTip(#{u.id.to_s},#{p.id.to_s});"
          end
        end
        
        Unit.all.each do |u|
          page << "destroyDraggableElement(#{u.id.to_s},#{p.id.to_s},false);"
          page << "changeUnitImageToBlocked(#{u.id.to_s},#{p.id.to_s});"    
        end
      end
      
      
    end
    
  end       
    
end
