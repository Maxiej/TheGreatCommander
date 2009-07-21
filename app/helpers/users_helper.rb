module UsersHelper    
  
  def avatar_path(id)
    return "/users/avatar/#{id}"
  end
  
  def user_path_by_login(login)
    u = User.find_by_login(login)
    if u.nil?
      return user_path("")
    else      
      return user_path(u.id)
    end
  end
  
  def height_of_show_user(user_id,current_user_id)
    if user_id != current_user_id
      return "height: 285px"
    else 
      return "height: 251px"
    end
  end
  
  def users_partial_name(tab)    
    
    case tab
      when 0 then
        partial_name = "game/owned_games" 
      when 1 then 
        partial_name = "password"
      when 2 then 
        partial_name = "profile"
      when 3 then
        partial_name = "photo"
      when 4 then
        partial_name = "messages"
    else
      partial_name = "game/owned_games"
    end
    
    return partial_name
  end
  
  def email_unique?(email)
    user = User.find_by_email(email)
    if user != nil
      return false
    end
    return true
  end
 
  def get_top_users    
    users = User.find(:all)
    top_users = Array.new
    users.each {|u|
      
      u.no_of_wins = 0 if(u.no_of_wins.nil?)        
      u.no_of_losses = 0 if(u.no_of_losses.nil?)         
      
      top_users << [u.no_of_wins - u.no_of_losses,u.id]
    }
    top_users.sort!{|x,y| y <=> x}
    top = []
    ctr = 1
    top_users.each{|i|
      if(ctr <= 10)
        top << User.find(i[1])
      else
        return top
      end
        ctr += 1
      }
    return top
  end
end