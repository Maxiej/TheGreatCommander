require File.dirname(__FILE__) + '/../test_helper'

class UnitTest < ActiveSupport::TestCase
  fixtures :units, :unit_properties, :unit_positions
  # Replace this with your real tests.
  def test_uniqueness_name
    u = Unit.find(2)
    u2 = Unit.create( :name => 'horsemen')
    assert !u2.valid?
  end
  
  def test_creation
    u = Unit.create(:name => 'pikemen')
    assert u.valid?
  end
  
  def test_relation_with_unit_property
    up = UnitProperty.find(2)
    u = Unit.find(1)
    u.unit_property = up
    up.unit = u #it doesnt work as i expected   
    assert_equal 'elephants', up.unit.name
    assert 400, u.unit_property.price
  end
  
  def test_relation_with_unit_positions
    up = UnitPosition.find(1)
    up2 = UnitPosition.find(2)
    u = Unit.find(2)
    u.unit_positions << up << up2
    assert_equal 'horsemen', up.unit.name
    assert_equal 2, u.unit_positions.count
  end
end
