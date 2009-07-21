require File.dirname(__FILE__) + '/../test_helper'

class MapTest < ActiveSupport::TestCase
 fixtures :games, :maps, :map_terrain_positions
  # Replace this with your real tests.
  def test_creation
    m = Map.find(1)
    assert m.valid?
    m2 = Map.create( :name => "map3", :size_x => 20, :size_y => 30)
    assert m2.valid?
  end
  
  def test_relation_with_games
    g = Game.find(1)
    g2 = Game.find(2)
    m = Map.find(2)
    m.games << g << g2
    assert_equal 2, m.games.count , "Incorrect number of games" 
  end
  
  def test_relation_with_mapterrainposition
    mtp = MapTerrainPosition.find(1)
    mtp2 = MapTerrainPosition.find(2)
    m = Map.find(1)
    m.map_terrain_positions << mtp << mtp2
    assert_equal 2, m.map_terrain_positions.count , "Incorrect number of map terrain posistions" 
  end
end
