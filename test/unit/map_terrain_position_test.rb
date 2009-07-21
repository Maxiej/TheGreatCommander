require File.dirname(__FILE__) + '/../test_helper'

class MapTerrainPositionTest < ActiveSupport::TestCase
  fixtures :map_terrain_positions, :terrains, :maps 
  # Replace this with your real tests.
  def test_creation
    mtp = MapTerrainPosition.create( :x => 400, :y => 300)
    assert mtp.valid?
    assert_equal 400, mtp.x, "Value x is not correct" 
  end
  
  def test_check_relation_with_terrain
    trn = Terrain.find(1)
    mtp = MapTerrainPosition.find(1)
    mtp.terrain = trn
    assert mtp.terrain.valid?, "#{mtp.terrain.name} incorrect"
    assert_equal "terrain1", mtp.terrain.name, "Terrain name is incorrect"
  end
  
  def test_check_relation_with_map
    m = Map.find(1)
    mtp = MapTerrainPosition.find(1)
    mtp.map = m
    assert mtp.map.valid?, "#{mtp.map.name} is incorrect"
    assert_equal "map1", mtp.map.name, "Map is incorrect"
  end
end
