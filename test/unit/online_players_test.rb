require File.dirname(__FILE__) + '/../test_helper'

class OnlinePlayersTest < ActiveSupport::TestCase
  fixtures :online_players, :players 
  # Replace this with your real tests.
  def test_creation
    op = OnlinePlayer.find(1)
    assert op.valid?
  end
  
  def test_relation_with_player
    p = Player.find(1)
    op = OnlinePlayer.find(1)
    p.online_player = op
    assert p.online_player.valid?
    assert_equal 1, p.online_player.id, "Incorrect online player" 
  end
end
