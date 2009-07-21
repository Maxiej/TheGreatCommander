require File.dirname(__FILE__) + '/../test_helper'

class TerrainTest < ActiveSupport::TestCase
  fixtures :terrains, :map_terrain_positions, :terrain_properties
  # Replace this with your real tests.
  def test_uniqueness_name
    t = Terrain.find(1)
    t2 = Terrain.create(:name => 'terrain1')
    assert !t2.valid?
  end
  
  def test_relation_with_map_terrain_positions
    mtp = MapTerrainPosition.find(1)
    mtp2 = MapTerrainPosition.find(2)
    t = Terrain.find(1)
    t.map_terrain_positions << mtp << mtp2
    assert mtp.terrain.valid?
    assert_equal 'terrain1', mtp.terrain.name
    assert_equal 2, t.map_terrain_positions.count
  end
  
  def test_relation_with_terrain_property
    tp = TerrainProperty.find(2)
    t = Terrain.find(1)
    tp.terrains << t
    assert_equal 'sand', t.terrain_property.name
    assert_equal 1, tp.terrains.count
  end
end
