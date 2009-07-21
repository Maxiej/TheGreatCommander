require File.dirname(__FILE__) + '/../test_helper'

class UnitPositionTest < ActiveSupport::TestCase
  fixtures :units, :unit_positions, :players
  # Replace this with your real tests.
  def test_creation
    up = UnitPosition.create(:x => 60, :y => 70)
    assert up.valid?
  end
  
  def test_relation_with_unit
    u = Unit.find(1)
    up = UnitPosition.find(1)
    u.unit_positions << up
    assert_equal 'elephants',up.unit.name
    assert_equal 1, u.unit_positions.count
  end
  
  def test_relation_with_player
    p = Player.find(1)
    up = UnitPosition.find(1)
    up2 = UnitPosition.find(2)
    p.unit_positions << up << up2
    assert_equal 'white', up.player.color
    assert_equal 2, p.unit_positions.count
  end
end
