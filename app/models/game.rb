class Game < ActiveRecord::Base
  validates_presence_of :name, :message => "Game should has name"
  
  has_many :players  
  has_many :users, :through => :players
  belongs_to :map
  
  def user_game?(user)
#TODO unimplemented
  end
  
  def user_take_part?(user)
    
    p = self.players.find_by_user_id(user.id)    
    if p 
      return true
    else
      return false
    end  
    
  end
  
  def can_join?
    if self.players.count == 2 
      return false
    else 
      return true
    end
  end
  
  def add_player(player,user)    
    
     player.is_owner = false
     player.is_ready = false    
     player.gold = ConstValues::GOLD_AT_START                   
     player.no_of_mines = 0 
     
      #player needs to create connection action
     player.connect   
     
     self.players << player
     user.players << player    
     player.save!   
     
    
     
  end
  
  def Game.find_owned_games(user_id)
    
     owned_games = []        
    
     u = User.find(user_id)             
    
     u.players.each{ |p|             
      
      if p.is_owner?
        unless p.game.nil?
          owned_games << p.game        
        end
      end
       
     }
    
    return owned_games

  end
  
  #kończy turę
  def end_turn(player_id)
    
    pl = self.players
    if pl.empty?
#      puts "FATAL ERROR end turn when there is no players"
    end
    
    if pl.count == 1
#      puts "FATAL ERROR only one player in game 'end turn'"
    end
    
    pl.each{ |p|      
      unless p.id.to_s == player_id
        self.whose_turn = p.id
        p.set_turn
#        puts("save " + p.id.to_s )
      end
    }
    p = Player.find(player_id)
    p.end_turn
   
    self.save!
  end
  
  # to oznacza że oboje playerów są ready, nie zmieniać
  def is_started
    unless self.players.nil?
      if self.players.count == 2 
        self.players.each { |p|  
          unless p.is_ready 
            return false
          end
        }
        return true
      end
    end
    
    return false
  end  
  
  def set_owner_next_turn
    self.players.each{ |p|
      if (p.is_owner)
         self.whose_turn = p.id
         p.unblock_all_units
      end
    }    
    self.save!
  end  
  
  #zwraca ilość wszystkich jednostek na planszy
  def units_quantity    
    
    counter = 0
    
    self.players.each do |p|
      counter += p.player_units.length
    end
    
#    puts "counter tralalala" + counter.to_s
    return counter
  end
  
  def get_player_id_by_user_id(user_id)
    self.players.each { |p| 
      if p.user_id == user_id
        return p.id
      end  
      }
    return nil
  end
  
  def get_looser_id
    self.players.each { |p| 
      if p.loose?
        return p.id
      end  
      }
    return nil
  end
  
  def is_player_by_user_id(user_id)
  is_player = false
  self.players.each { |p|
    if(p.user_id == user_id)
      return true
    else
      is_player = false
    end
  }
  return is_player
end

end

