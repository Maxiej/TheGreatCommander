require File.dirname(__FILE__) + '/../test_helper'

class GameTest < ActiveSupport::TestCase
  fixtures :games, :maps, :players, :users
  # Replace this with your real tests.
  def test_creation_game
    g = Game.create 
    assert !g.valid?
  end
  
  def test_creation_game_2
    g = Game.create( :name => 'simple game')
    assert g.valid?
  end
  
  def test_check_relation_with_map
    m = Map.find(1)
    g = Game.find(1)
    g.map = m
    assert g.map.valid?, "game #{g.name} doesn't has map name #{g.map.name}"  
  end
  
  def test_check_relation_with_players
    p = Player.find(1)
    p2= Player.find(2)
    g = Game.find(2)
    g.players << p << p2
    assert_equal 2, g.players.count, "Incorrect no of players in game #{g.name}" 
  end
  
   def test_check_relation_with_users
    u = User.find(1)
    u2= User.find(2)
    g = Game.find(2)
    g.users << u << u2
    assert_equal 2, g.users.count, "Incorrect no of users in game #{g.name}" 
    assert !g.users[1].email.empty?, "Email of user #{g.users[1].login} is empty"
  end
  
end
