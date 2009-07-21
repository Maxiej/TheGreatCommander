module NewHelper
  
  def available_news
    news = New.find(:all)
    return news
  end
  
end
