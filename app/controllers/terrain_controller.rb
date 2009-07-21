class TerrainController < ApplicationController
  layout('image')  
  
  def show
    terrain = Terrain.find(params[:id]) 
    @image = terrain.image
    send_data(@image,:type => "image/gif", :filename => terrain.name + ".jpg",:disposition => 'inline')
  end
end
