class Terrain < ActiveRecord::Base
  validates_uniqueness_of :name
  belongs_to :terrain_property
  has_many :map_terrain_positions
end
