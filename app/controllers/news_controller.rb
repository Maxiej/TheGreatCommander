class NewsController < ApplicationController
  
  protect_from_forgery :only => []  
  
  def new_content
    update_span = params[:updateelem]
    span = update_span.to_s.split("_")
    @new = New.find(span[1].to_i)
  end
  
  def index    
    @news = New.find(:all)
  end

  def add_comment
    unless logged_in?
      flash[:error] = "You have to be logged in!"
      redirect_to :controller => 'news'
      return
    end    
  
    @new = New.new(params[:new])
    @new.publication_date = DateTime.now
    @new.user_id = current_user.id
    if @new.save  
        flash[:notice] = "Your comment has been added"       
    else                       
        flash[:error] = "Something is wrong! Remember that content can not be empty."                 
    end 
    redirect_to :controller => 'news'
  end
  
  def get_time
     render :text => Time.now.to_s
   end
   
   def show_news
     render :text => "Witamy na stronie gry Great Commander! Wersja beta już wkrótce!"
   end
end
