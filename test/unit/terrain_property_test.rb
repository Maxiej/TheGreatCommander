require File.dirname(__FILE__) + '/../test_helper'

class TerrainPropertyTest < ActiveSupport::TestCase
  fixtures :terrain_properties, :terrains
  def test_validance
    tp = TerrainProperty.find(1)        
    assert_equal(tp.id, 1,tp.id)
    assert tp.valid?
  end
  def test_uniqueness_name
    tp = TerrainProperty.find(1)
    tp2 = TerrainProperty.create(:name => 'grass')
    assert !tp2.valid?
  end
  def test_creation
    tp = TerrainProperty.create        
    assert !tp.valid?
  end
  def test_relation_with_terrain
    tp = TerrainProperty.find(1)
    t = Terrain.find(1)
    t2 = Terrain.find(2)
    t.terrain_property = tp
    tp.terrains << t2 
    assert_equal 1,tp.terrains.count
    assert t.terrain_property.valid?
  end
end
