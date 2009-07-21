 class TerrainProperty < ActiveRecord::Base
  validates_presence_of :name, :message => "can't be empty"
  validates_uniqueness_of :name
  has_many :terrains 
end
