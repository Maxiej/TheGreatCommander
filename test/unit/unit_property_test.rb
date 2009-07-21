require File.dirname(__FILE__) + '/../test_helper'

class UnitPropertyTest < ActiveSupport::TestCase
  fixtures :units, :unit_properties
  # Replace this with your real tests.
  def test_creation
    uprop = UnitProperty.create(:strength => 20, :is_flying => true)
    assert !uprop.valid?
  end
   def test_validace
    uprop = UnitProperty.create(:strength => 20, :is_flying => true, :unit_id => 1)
    assert uprop.valid?
  end
   def test_relation_with_unit
    uprop = UnitProperty.find(1)
    u = Unit.find(1)
    uprop.unit = u
    assert_equal 'elephants', uprop.unit.name
    assert_equal 20, u.unit_property.strength
  end
end
