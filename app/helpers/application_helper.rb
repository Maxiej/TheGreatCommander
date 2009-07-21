# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
#  zwraca curren_id
   def current_id 
     if current_user 
        return current_user.id.to_s
      else 
        return ''
     end
   end    
   
  def change_tab(tab,no_of_tabs)
    changing = ""
    changing << "deactive_ajax_loading();"  
    changing << "change_tab(" + tab.to_s + "," + no_of_tabs.to_s + ");"
    changing << "reset_flash();"
    return changing
  end
  
  def periodically_call_remote(options = {})
    variable = options[:variable] ||= 'poller'
    frequency = options[:frequency] ||= 10
    code = "#{variable} = new PeriodicalExecuter(function() 
    {#{remote_function(options)}}, #{frequency})"
    javascript_tag(code)
  end
  
end
