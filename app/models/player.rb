class Player < ActiveRecord::Base
  validates_presence_of :game_id, :message => "Player should has gameid"
  belongs_to :user
  belongs_to :game
  has_many :player_units
  has_one :online_player
  has_many :actions
  
  @@ONLINE_TIME = 10
  
  
  #zmiana pieniedzy playera po zakupie jednostki
  def change_money(u_id, is_back)
    @unit = Unit.find(u_id)
    if(!is_back)
      if(self.gold >= @unit.unit_property.price)
        self.gold = self.gold - @unit.unit_property.price
      else
        #puts 'You do not have enough money'
      end
    else
      self.gold = self.gold + @unit.unit_property.price
    end
    self.save!
  end
  
  #pobranie pozycji jednostki playera
  def get_unit_pos(u_id)
    unit_positions = PlayerUnit.find(:all)
    unit_positions.each { |unit_p|  
          if((unit_p.unit_id == u_id) && (unit_p.player_id == self.id))
            return unit_p
          end
      }
    return nil
  end
  
  #pobranie pozycji x jednostki playera
  def get_unit_pos_x(u_id)
    unit_positions = PlayerUnit.find(:all)
    unit_positions.each { |unit_p|  
          if((unit_p.unit_id == u_id) && (unit_p.player_id == self.id))
            return unit_p.x
          end
      }
    return nil
  end
  
  #pobranie pozycji y jednostki playera
  def get_unit_pos_y(u_id)
    unit_positions = PlayerUnit.find(:all)
    unit_positions.each { |unit_p|  
          if((unit_p.unit_id == u_id) && (unit_p.player_id == self.id))
            return unit_p.y
          end
      }
    return nil
  end
  
  #sprawdzenie czy player ma teraz ture
  def is_turn    
    if self.game.whose_turn == self.id
      return true
    else 
      return false
    end
  end
  
  #zablokowanie ruchu wszystkich jednostek playera
  def block_all_units
     self.player_units.each{ |u|
        u.is_turn = false
        u.save!
     }
  end
    
  #odblokowanie ruchu wszystkich jednostek playera
  def unblock_all_units
      self.player_units.each{ |u|
        u.is_turn = true
        u.save!
      }
  end
  
  #pobranie przeciwnika
  def get_opponent
    self.game.players.each{ |p|
      unless p.id == self.id
        return p
      end
    }
    return nil
  end
  
  #sprawdzanie czy player jest online
  def is_online()
    
      time1 = self.online_player.last_time_online
      return if (time1.getutc.year - Time.now.getutc.year) != 0
      return if (time1.getutc.month - Time.now.getutc.month) != 0
      return if (time1.getutc.day - Time.now.getutc.day) != 0
      return if (time1.getutc.hour - Time.now.getutc.hour) != 0
      return if (time1.getutc.min - Time.now.getutc.min) != 0
      return if (time1.getutc.sec - Time.now.getutc.sec) > @@ONLINE_TIME
      return true         
     
  end
  
  #stworzenie onlineplayera
  def create_online
    if self.online_player.nil?
      online_p = OnlinePlayer.new
    else 
      online_p = self.online_player
    end  
    online_p.last_time_online = Time.now
    online_p.last_time_updated = Time.now
    self.online_player = online_p
    self.online_player.save!
  end
  
  #ukonczenie tury przez playera
  def end_turn()
    
     if self.is_ready
        #trzeba zapisac kiedy player wykonal‚ ruch
        self.online_player.last_time_online = Time.now
        self.online_player.save
        self.player_units.each do |u|
          u.is_turn = false
          u.save!
        end                
    end
    
    #zapisuje akcjΔ™ jakΔ… wykonaΕ‚
    a = Action.new
    a.action = "end turn"
    
    if self.is_turn
      a.result = "my turn"
    else
      a.result = "opponent turn"
    end
    
    self.actions << a
    a.save!
    self.save!
    
  end
  
  #pobiera akcji tych ktorych nie updatowalismy
  def get_actions(time)        
    actions = self.actions.find(:all, :conditions => ["created_at > ?",time])
    return actions
  end
  
  #sprawdza czy otrzymalem akcje ready, czyli wstawilem jednoski przeciwnika
  def action_ready_received?(time)    
    get_actions(time).each do |a|
      if a.action == "ready" 
        return false
      end        
    end
    return true
  end
  
  def action_updated
    self.online_player.last_time_updated = Time.now
    self.online_player.save!
  end
  
  #ustawienie tury playera
  def set_turn
    unless self.player_units.empty?
      self.player_units.each do |u| 
        u.is_turn = true
        u.save
      end
    end
  end
  
  #przylaczenie sie do gry
  def connect
    a = Action.new
    a.action = "connect"
    a.result = "connected"    
    self.actions << a
    a.save
  end
 
  #zapisanie akcji
  def save_action (unit, action_name, action_result)
    #trzeba zapisac kiedy player wykonal ruch
     action_updated

     #trzeba zapisaΔ‡ ruch jaki wykonaΕ‚ 
     a = Action.new()
     a.action = action_name
     a.result = action_result
     a.player_unit = unit
     self.actions << a
     a.save!
  end
  
  #zapisanie akcji ataku palyera
  def save_attack_action(p_unit_id,unit_attacked_id,hp_recieved,hp_taken)
    action_updated
    a = Action.new()
    a.action = "attack"
    a.result = "attacked"
    a.hp_received = hp_recieved
    a.hp_taken = hp_taken
    a.player_unit_id = p_unit_id
    a.unit_attacked_id = unit_attacked_id
    self.actions << a
    a.save!
    
  end

  #pobranie zywych jednostek playera
  def alive_units
    a_units =  self.player_units.find(:all, :conditions => ["hp_left > ?",0])
    return a_units
  end
  
  #pobranie zabitych jednostek
  def dead_units
    d_units =  self.player_units.find(:all, :conditions => ["hp_left <= ?",0])
    return d_units
  end
  
  #sprawdzenie czy ma fundusze aby kupic jednostke
  def can_buy?(unit)
    self.gold >= unit.unit_property.price    
  end
  
  #sprawdzenie czy palyer przegral (czy ma jakies jednostki)
  def loose?
    self.player_alive_units.length <= 0 
  end
  
  #ustawienie liczby przegranych
  def set_no_of_losses
    user = User.find(self.user_id)
    if user.no_of_losses.nil?
      user.no_of_losses = 0
      user.no_of_losses = 1
    else
      user.no_of_losses += 1
    end
    user.save!
  end
  
  #ustawienie liczby wygranych
  def set_no_of_wins
    user = User.find(self.user_id)
    if user.no_of_wins.nil?
      user.no_of_wins = 0
      user.no_of_wins = 1
    else
      user.no_of_wins += 1
    end
    user.save!
  end
  
end
