class Message < ActiveRecord::Base
  belongs_to :user  
  
  validates_presence_of  :title, :content, :to
  validates_length_of    :content, :within => 1..255
  
  def is_to?(user_id)
    u = User.find(user_id)
    
    if u.login.upcase == self.to.upcase
      return true 
    else 
      return false
    end
  end  
  
end
