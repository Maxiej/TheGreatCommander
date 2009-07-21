require File.dirname(__FILE__) + '/../test_helper'

class PlayerTest < ActiveSupport::TestCase
   fixtures :games, :players
  # Replace this with your real tests.
  def test_creation_player
    p = Player.find(1) 
    assert p.valid?
  end
  def test_creation_player2
    p = Player.create 
    assert !p.valid?
  end
  def test_check_relation_with_user
    u = User.find(1)
    p = Player.find(1)
    p2 = Player.find(2)
    p.user = u
    u.players << p << p2
    assert_equal 1, p.user.id, "Incorrrect user id for player #{p.color}"
    assert p.user.valid?, "player #{p.color} doesn't belong to user #{u.login}"  
    assert_equal 2,u.players.count,"Incorrect no of players in user #{p.user.login}"
  end
  
  def test_check_relation_with_game
    g = Game.find(1)
    p = Player.find(1)
    p2 = Player.find(2)
    g.players << p << p2 
    assert_equal 1, p.game.id, "Incorrrect game id"
    assert_equal 2,g.players.count,"Incorrect no of players in game #{g.name}"
  end
  
   
end
