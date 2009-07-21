module MessageHelper
  
  def partial_name(tab)    
    
    case tab
      when 0 then
        partial_name = "inbox_messages" 
      when 1 then 
        partial_name = "show_sent"
      when 2 then 
        partial_name = "new"
      when -1 then
        partial_name = "view"
    else
      partial_name = "show"
    end
    
    return partial_name
  end
  
  def your_message?(message_id)  
    
    if Message.find(message_id).user == current_user 
      return true
    else
      return false
    end
    
  end
  
  def is_read(message_id)
    unless Message.find(message_id).is_read
      return "<b>"
    end
  end
  
  def end_is_read(message_id)
    unless Message.find(message_id).is_read
      return "</b>"
    end
  end
  
end
