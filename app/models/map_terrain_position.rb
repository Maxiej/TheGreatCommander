class MapTerrainPosition < ActiveRecord::Base
  belongs_to :terrain
  belongs_to :map
end
