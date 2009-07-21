require 'digest/sha1'
require 'RMagick'
 
class User < ActiveRecord::Base
  # Virtual attribute for the unencrypted password
  
  attr_accessor :password

  validates_presence_of     :login, :email
  validates_presence_of     :password,                   :if => :password_required?
  validates_presence_of     :password_confirmation,      :if => :password_required?
  validates_length_of       :password, :within => 4..40, :if => :password_required?
  validates_confirmation_of :password,                   :if => :password_required?
  validates_length_of       :login,    :within => 3..40
  validates_length_of       :email,    :within => 3..100
  validates_uniqueness_of   :login, :email, :case_sensitive => false  
  validates_length_of :avatar, :in => 5.kilobytes..128.kilobytes, :allow_nil => :true,
      :too_long => "is to big, should be smaller than 128kb",
      :too_short => "is to small, should be bigger than 5kb"
  validates_format_of :avatar_content_type, :with => /[i][m][a][g][e]/, :on => :create, :allow_nil => :true
  validates_format_of :avatar_content_type, :with => /[i][m][a][g][e]/, :on => :update, :allow_nil => :true
  
  before_save :encrypt_password
  
  has_many :players
  has_many :games, :through => :players
  has_many :messages
  has_many :news
  
  # prevents a user from submitting a crafted form that bypasses activation
  # anything else you want your user to change should be added here.
  attr_accessible :login, :email, :password, :password_confirmation,:gender,
                  :date_of_birth, :avatar, :avatar_content_type, 

  # Authenticates a user by their login name and unencrypted password.  Returns the user or nil.
  def self.authenticate(login, password)
    u = find_by_login(login) # need to get the salt
    u && u.authenticated?(password) ? u : nil
  end

  # Encrypts some data with the salt.
  def self.encrypt(password, salt)
    Digest::SHA1.hexdigest("--#{salt}--#{password}--")
  end

  # Encrypts the password with the user salt
  def encrypt(password)
    self.class.encrypt(password, salt)
  end

  def authenticated?(password)
    crypted_password == encrypt(password)
  end

  def remember_token?
    remember_token_expires_at && Time.now.utc < remember_token_expires_at 
  end

  # These create and unset the fields required for remembering users between browser closes
  def remember_me
    remember_me_for 2.weeks
  end

  def remember_me_for(time)
    remember_me_until time.from_now.utc
  end

  def remember_me_until(time)
    self.remember_token_expires_at = time
    self.remember_token            = encrypt("#{email}--#{remember_token_expires_at}")
    save(false)
  end

  def forget_me
    self.remember_token_expires_at = nil
    self.remember_token            = nil
    save(false)
  end

  # Returns true if the user has just been activated.
  def recently_activated?
    @activated
  end
  
  def filename
    @ext = self.avatar_content_type
    @ext = @ext[(@ext.rindex("/") + 1)..(@ext.length - 1)]
    return self.login + "." + @ext
  end
  
  def age    
    return DateTime.now.year - self.date_of_birth.year    
  end
  
  def inbox_messages      
      
      return_messages = []
      messages = Message.find(:all)
      messages.each{ |m|
        if m.to.upcase == self.login.upcase
          return_messages << m
        end          
      }
      
      return return_messages
    end

  protected
    # before filter 
    def encrypt_password
      return if password.blank?
      self.salt = Digest::SHA1.hexdigest("--#{Time.now.to_s}--#{login}--") if new_record?
      self.crypted_password = encrypt(password)
    end
      
    def password_required?
      crypted_password.blank? || !password.blank?
    end
  
    # uploading file    
    def avatar=(uploaded_file)      
      @uploaded_file = uploaded_file    
      unless (@uploaded_file == "")    
        img = Magick::Image.from_blob(uploaded_file.read).first             
        img.scale!(ConstValues::AVATAR_SIZE_X,ConstValues::AVATAR_SIZE_X)
        @content_type = @uploaded_file.content_type.chomp      
        write_attribute("avatar_content_type",@content_type)     
        write_attribute("avatar", img.to_blob)
      end
    end     
    
    public
    
    def is_owner?(game_id)
        
        game = nil  
      
        if self.games.empty?
          return false
        end
        self.games.each { |g|
          if g.id == game_id
            game = g
          end          
        }
        
        unless game.nil? or game.players.empty? 
          p = game.players.find_by_is_owner(true)
          unless p.nil? 
            if p.user == self 
              return true
            else 
              return false
            end
          else 
            return false
          end          
        else 
          return false
        end           
      
    end
    
    def can_delete?(game_id)
      
      g = Game.find(game_id)               
      
      if (g.nil?) or (g.players.empty?)or(g.players.count != 1)        
        return false           
      else
      end
      if is_owner?(game_id) 
        return true
      end
      
    end
    
    def how_many_unread
      counter = 0
      messages = Message.find(:all)
      messages.each{ |m|
        if m.to.upcase == self.login.upcase and !m.is_read
          counter += 1
        end
      }      
      return counter.to_s
    end
    
end
