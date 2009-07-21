class MessagesController < ApplicationController
  protect_from_forgery :only => []   
  
  def destroy
    
    unless logged_in?
      flash[:error] = "You have to be logged in!"
      redirect_to :controller => 'news'
      return
    end
    
    message = Message.find(params[:id])
    flash[:notice] = "Message '" + message.title + "' was deleted succesfully" 
    message.destroy           
    redirect_to :action => 'inbox', :tab => 0
    
  end
  
  def inbox                    
        
    @active_tab = params[:tab].to_i   
    @user = current_user
    
    unless logged_in?
      flash[:error] = "You have to be logged in!"
      redirect_to :controller => 'news'
      return
    end   
         
    case @active_tab
      when 0 then
        @messages = current_user.inbox_messages
      when 1 then 
        @messages = current_user.messages
      when 2 then                  
         unless params[:to].nil?
            @message = Message.new
            @message.to = User.find(params[:to]).login         
         end           
      when -1 then
          @message = Message.find(params[:id])    
          
          if @message.is_to?(current_user.id)
            @message.is_read = true
            @message.save!
          end
    end
      
  end
  
  def inbox_messages          
    
    unless logged_in?
      flash[:error] = "You have to be logged in!"
      redirect_to :controller => 'news'
      return
    end
    
    @messages = current_user.inbox_messages
    return unless request.xhr?
    render :partial => 'inbox_messages'
    
  end
  
  def view     
    
    unless logged_in?
      flash[:error] = "You have to be logged in!"
      redirect_to :controller => 'news'
      return
    end
    
    @message = Message.find(params[:id])
    if @message.nil?
      flash[:error] = "Message has been already deleted!"
      redirect_to :controller => 'news'
    else
      return unless request.xhr?
      
      if @message.is_to?(current_user.id)
        @message.is_read = true
        @message.save!
      end
      
      render :partial => 'view'  
    end   
    
  end
  
  def show_sent  

    unless logged_in?
      flash[:error] = "You have to be logged in!"
      redirect_to :controller => 'news'
      return
    end    
     
    @messages = current_user.messages    
    return unless request.xhr?
    render :partial => 'show_sent'
    
  end
  
  def show    
    
    unless logged_in?
      flash[:error] = "You have to be logged in!"
      redirect_to :controller => 'news'
      return
    end         

    redirect_to :action => 'inbox', :id => params[:id], :tab => -1                
    
  end
  
  def new
    
    unless logged_in?
      flash[:error] = "You have to be logged in!"
      redirect_to :controller => 'news'
      return
    end    
    
    unless (params[:to].nil?)
      @message = Message.new
      @message.to = User.find(params[:to]).login           
    end
    return unless request.xhr?
    render :partial => 'new'
    
  end
  
  def create     
    
    unless logged_in?
      flash[:error] = "You have to be logged in!"
      redirect_to :controller => 'news'
      return
    end    
  
    @message = Message.new(params[:message])
    @message.user = current_user
    u = User.find_by_login(@message.to)   
      
    if u.nil?      
      
      flash[:error] = "User " + @message.to + " not found!"           
      
      @active_tab = 2      
      render :action => 'inbox'
            
    else     
           
      @message.save    
    
      if @message.errors.empty?                      
        
        redirect_to :action => 'inbox', :id => @message.id, :tab => 1
        flash[:notice] = "Your message to " + @message.to +  " has been sent"
        
      else               
        
        flash[:error] = "Something gone wrong!"          

        @active_tab = 2  
        render :action => 'inbox'              

      end 
      
    end
    
  end  

end
