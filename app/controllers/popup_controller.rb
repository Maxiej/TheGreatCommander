class PopupController < ApplicationController
   layout 'empty'
   protect_from_forgery :only => [:create, :update, :destroy]
  
  def authenticate_game
    @game = Game.find(params[:id])       
  end
  
  def join_game
    @game = Game.find(params[:id])
  end
  
  def delete_game
    @game = Game.find(params[:id])
  end
  
  def attack_result
#    @unit = PlayerUnit.find(params[:id])
    @player = Player.find(params[:id])
  end

end
