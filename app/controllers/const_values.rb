# 
# To change this template, choose Tools | Templates
# and open the template in the editor.
 

module ConstValues
    SIZE_OF_ELEMENT = 30 
    SIZE_OF_BOARD = 600;  # 20 times 30px
    WIDTH_OF_WRAPPER = 900;
    HEIGHT_OF_HEADER = 75;
    HEIGHT_OF_FOOTER = 75;
    WIDTH_OF_LEFTPANEL = 150;
    WIDTH_OF_RIGHTPANEL = 150; 
   
    #--Maciek-------------------------------------------------------------------
    
    GOLD_AT_START = 1500;  
  
    SIZE_OF_BOARD_EL = 20;
    SIZE_OF_ARROWS = 30;    
  
    SIZE_OF_SIGNUP_FIELDS = 40;
  
    #--avatar size
    AVATAR_SIZE_X = 144
    AVATAR_SIZE_Y = 192
    
    #--avatar size for player profil - left panel
    AVA_PROFILE_SIZE_X = 105
    AVA_PROFILE_SIZE_Y = 140
  
    AVATAR_THUMBNAIL_SIZE_X = 24
    AVATAR_THUMBNAIL_SIZE_Y = 32
    
    SHOW_USER_WIDTH = AVATAR_SIZE_X + 15
    
    #buy area - how many terrains images horizontaly
    BUY_AREA_Y = 11; 
      
    #--hokus pokus, ustaw się strzałko
    POS_ARROW_UP = [-SIZE_OF_BOARD,SIZE_OF_BOARD - (2 * SIZE_OF_ARROWS)]
    POS_ARROW_DOWN = [-(SIZE_OF_BOARD - (2 * SIZE_OF_ARROWS)),
      SIZE_OF_BOARD - (3 * SIZE_OF_ARROWS)]
    POS_ARROW_LEFT = [-(SIZE_OF_BOARD - SIZE_OF_ARROWS),
      SIZE_OF_BOARD - (5 * SIZE_OF_ARROWS)]
    POS_ARROW_RIGHT = [-(SIZE_OF_BOARD - SIZE_OF_ARROWS),
      SIZE_OF_BOARD - (4 * SIZE_OF_ARROWS)]
    #---------------------------------------------------------------------------
end
