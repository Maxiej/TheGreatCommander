class UsersController < ApplicationController
  protect_from_forgery :only => [:create, :update, :destroy]     
  
  auto_complete_for :user, :login  
  
  @@ONLINE_TIME = 30
 
  # render new.rhtml
  def new
  end

  def create
    cookies.delete :auth_token    
    # protects against session fixation attacks, wreaks havoc with 
    # request forgery protection.
    # uncomment at your own risk
    # reset_session
    @user = User.new(params[:user])
    @user.no_of_losses = 0
    @user.no_of_wins = 0
    @user.save
    if @user.errors.empty?
      self.current_user = @user
      redirect_back_or_default('/')
      flash[:notice] = "Thanks for signing up!"
    else
      render :action => 'new'
    end
  end
  
  
   def check_login    
    @is_available = !User.find_by_login(params[:login])
   end
   
   def avatar
    user = User.find(params[:id]) 
    @image = user.avatar
    send_data(@image,:type => user.avatar_content_type, 
      :filename => user.filename,:disposition => 'inline')
   end
   
   def show            
     if logged_in?
       @active_tab = 0
       @user = User.find(params[:id])  
       if @user.id != current_user.id
         redirect_to :action => 'view', :id => @user.id
       else
         @games = Game.find_owned_games(@user.id)           
       end             
     else
       redirect_to :controller => 'news'
     end      
   end
   
   def show_user    
     @login = params[:login]     
     @user = User.find_by_login(@login)         
     unless @user.nil?
      @games = Game.find_owned_games(@user.id) 
     end
   end
   
   def edit 
     cookies.delete :auth_token    
    # protects against session fixation attacks, wreaks havoc with 
    # request forgery protection.
    # uncomment at your own risk
    # reset_session
    @user = User.find(params[:id])
    @user.save
    if @user.errors.empty?
      self.current_user = @user
#      redirect_back_or_default('/')
      render :action => 'edit'
      flash[:notice] = "Profile updated!"
    else
      render :action => 'edit'
    end
   end

   def find
     
   end 
   
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
   
   def i_am_online
     
     @user = User.find(params[:id])
     @user.last_time_online = Time.now    
     @user.save!
     
   end  
   
   def change_password
     
     @user = User.find(params[:id])
     @games = Game.find_owned_games(@user.id)  
     @active_tab = 1
    
     if (@user.authenticated?(params[:password]))
       @user.password = params[:new_password]
       @user.password_confirmation = params[:password_confirmation]
       @user.crypted_password = @user.encrypt(params[:new_password])
       if @user.password.length == 0
          flash[:error] = "Password can not be blank"          
       else
         if @user.save
            flash[:notice] = "Password has been changed successfully"          
         else
            flash[:error] = "Password has been not changed successfully"          
         end
       end
     else
       flash.now[:error] = "Invalid old password."
     end
     render :action => 'show', :id => @user.id, @tab => 1
   end
   
   def change_profile
     
     user_changed = User.new(params[:user])
     @user = User.find(params[:id])
     @user.email = user_changed.email
     @user.gender = user_changed.gender
     @user.date_of_birth = user_changed.date_of_birth
     @games = Game.find_owned_games(@user.id) 
     @active_tab = 2
     
     unless logged_in?
      flash[:error] = "You have to be logged in!"
      redirect_to :controller => 'news'
      return
     end
     
    if @user.save
         flash.now[:notice] = "User profile has been changed successfully."
       else
         flash.now[:error] = "Wrong changes."
    end
    render :action => 'show', :id => @user.id, @tab => 2
   end
   
   def change_photo
     user_changed = User.new(params[:user])
     @user = User.find(params[:id])
     @user.avatar = user_changed.avatar
     @games = Game.find_owned_games(@user.id) 
     @active_tab = 3
     if @user.save
       flash[:notice] = "Photo has been changed successfully."
     else
       flash[:error] = "Photo has been not changed successfully."
     end
     render :action => 'show', :id => @user.id, @tab => 3
   end
   
   def password
     
     unless logged_in?
      flash[:error] = "You have to be logged in!"
      redirect_to :controller => 'news'
      return
     end
     
     @user = User.find(params[:id])
     return unless request.xhr?
     render :partial => 'password'
     
   end
   
   def profile
     
     unless logged_in?
      flash[:error] = "You have to be logged in!"
      redirect_to :controller => 'news'
      return
     end
    
     @user = User.find(params[:id])
     return unless request.xhr?
     render :partial => 'profile'
     
   end
   
    def messages
     
     unless logged_in?
      flash[:error] = "You have to be logged in!"
      redirect_to :controller => 'news'
      return
     end
    
     @user = User.find(params[:id])
     return unless request.xhr?
     render :partial => 'messages'
     
   end
   
   def photo
     
     unless logged_in?
      flash[:error] = "You have to be logged in!"
      redirect_to :controller => 'news'
      return
     end
     
     @user = User.find(params[:id])
     return unless request.xhr?
     render :partial => 'photo'
     
   end
   
   def view 
     @user = User.find(params[:id])
     @games = Game.find_owned_games(@user.id)  
     @active_tab = 0
     
     if @user.nil?
       flash[:error] = "This user does not exists!"
       redirect :controller => 'news'
     end
   end
   
   def index
       flash[:error] = "This user does not exists!"
       redirect_to :controller => 'news'
   end
   
end
