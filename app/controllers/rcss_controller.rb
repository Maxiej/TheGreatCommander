class RcssController < ApplicationController
  layout nil
  session :off
  # serve dynamic stylesheet with name defined
  # by filename on incoming URL parameter :rcss
  def rcss
    # :rcssfile is defined in routes.rb
    if @stylefile = params[:rcssfile]
      #prep stylefile with relative path and correct extension
      @stylefile.gsub!(/.css$/, '')
      
      @color = "#EBC2AF"     
      @wrapper_width = ConstValues::WIDTH_OF_WRAPPER
      @header_height = ConstValues::HEIGHT_OF_HEADER
      @footer_height = ConstValues::HEIGHT_OF_FOOTER
      @board_size = ConstValues::SIZE_OF_BOARD
      @leftpanel_width = ConstValues::WIDTH_OF_LEFTPANEL
      @rightpanel_width = ConstValues::WIDTH_OF_RIGHTPANEL
      @element_size = ConstValues::SIZE_OF_ELEMENT
      
      
      
      #---Maciek----------------------------------------------------------------------
      @arrow_up = ConstValues::POS_ARROW_UP
      @arrow_down = ConstValues::POS_ARROW_DOWN
      @arrow_left = ConstValues::POS_ARROW_LEFT
      @arrow_right = ConstValues::POS_ARROW_RIGHT
      @size_of_arrows = ConstValues::SIZE_OF_ARROWS
      
      @color_ecru = "#C2B280"  #jakiś taki biało żółty
      @color_yellow_mist = "#FFFFE0"
      @color_old_lace = "#F5F5DC"
      @color_light_khaki = "#F0E68C"
      @color_desert_sand = "#EDC9AF"
      @color_light_red ="#FF0000"
      
      @SHOW_USER_WIDTH = ConstValues::SHOW_USER_WIDTH
      @DEFAULT_BORDER = 5
      @SHOW_USER_RIGHT_WIDTH = @DEFAULT_BORDER * 2 + @SHOW_USER_WIDTH 
      @AVATAR_SIZE_X = ConstValues::AVATAR_SIZE_X
      @TABS_HEIGHT = 35
      #-------------------------------------------------------------------------------

      @LEFT_S_PANEL_WIDTH = @SHOW_USER_WIDTH - @DEFAULT_BORDER * 4 + 1
      @AVA_PROFILE_SIZE_X = ConstValues::AVA_PROFILE_SIZE_X
      
      @stylefile = @stylefile = "/rcss/" + @stylefile + ".rcss.erb"
      render(:file => @stylefile, :use_full_path => true, :content_type => "text/css")
    else #no method/action specified
      render(:nothing => true, :status => 404)
    end #if @stylefile..
  end #rcss
end

