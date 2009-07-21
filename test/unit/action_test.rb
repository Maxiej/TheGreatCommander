require File.dirname(__FILE__) + '/../test_helper'

class ActionTest < ActiveSupport::TestCase  
  fixtures :players, :actions
  
  def test_get_actions
    p = Player.find(1)      
        
    time = "2008-07-19 11:52:11"
    act = p.get_actions(time)
    puts(act.length)
    assert_equal act.length,2
    
    time = Time.utc(2008, 07, 19, 12, 00, 11, 00)
    act = p.get_actions(time)
    puts(act.length)
    assert_equal act.length,2
    
    time = "2008-07-21 11:52:11"
    act = p.get_actions(time)
    puts(act.length)
    assert_equal act.length,0
    
    
    time = "2008-07-20 12:00:11"
#    time = Time.utc(2008, 07, 19, 12, 00, 11, 00)
    act = p.get_actions(time)
    puts(act.length)
    assert_equal act.length,1
    
    
    time = Time.utc(2008, 07, 20, 12, 00, 11, 00)
    act = p.get_actions(time)
    puts(act.length)
    assert_equal act.length,1
    
  end
end
