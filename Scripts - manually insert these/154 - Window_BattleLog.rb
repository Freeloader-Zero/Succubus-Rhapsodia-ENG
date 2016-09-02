#==============================================================================
# ¡ Window_BattleLog
#------------------------------------------------------------------------------
# @í“¬’†‚ÌƒƒbƒZ[ƒW•\¦—pƒEƒBƒ“ƒhƒE‚Å‚·B(Window_Message‚ğŒ³è‚É‚µ‚Ä‚Ü‚·)
#
#   ¦–ÚˆÀ‚Æ‚µ‚ÄA‘SŠp•¶š20š~4sB
#
#==============================================================================
class Window_BattleLog < Window_Base
  #--------------------------------------------------------------------------
  # œ ŒöŠJƒCƒ“ƒXƒ^ƒ“ƒX•Ï”
  #--------------------------------------------------------------------------
    attr_accessor   :bgframe_sprite         # ƒoƒgƒ‹ƒƒO‚ÌƒEƒBƒ“ƒhƒE‰æ‘œ
    attr_accessor   :wait_count             # ƒEƒFƒCƒgƒJƒEƒ“ƒg
    attr_accessor   :keep_flag              # ƒL[ƒvƒtƒ‰ƒO
    attr_accessor   :clear_flag             # ƒNƒŠƒAƒtƒ‰ƒO
    attr_accessor   :last_x                 # ÅIæ“¾‚wÀ•W
    attr_accessor   :last_y                 # ÅIæ“¾‚xÀ•W
    attr_accessor   :stay_flag              # ˆÛƒtƒ‰ƒO
    attr_accessor   :pause                  # ˆÛƒtƒ‰ƒO
  #--------------------------------------------------------------------------
  # œ ƒIƒuƒWƒFƒNƒg‰Šú‰»
  #--------------------------------------------------------------------------
  def initialize
    #super(100, 280, 540, 150)
    super(100, 280, 418, 150)
    @bgframe_sprite = Sprite.new
    @bgframe_sprite.x = 0
    @bgframe_sprite.y = -12
    @bgframe_sprite.z = 1
    @wait_count = 0
    @keep_flag = false
    @clear_flag = false
    @last_x = 0
    @last_y = 0
    self.contents = Bitmap.new(width - 32, height - 32)
    self.opacity = 0
    self.visible = false
    bitmap = RPG::Cache.windowskin($game_system.battlelog_back_name)
    @bgframe_sprite.bitmap = bitmap
    @bgframe_sprite.visible = false
    # ƒ|[ƒYƒTƒCƒ“‚Ìì¬
    @pause = Sprite_Pause.new
    # ƒ|[ƒYƒTƒCƒ“‚Ìİ’è
    @pause.visible = false
    # ZÀ•W‚Ìİ’è
    @pause.z = self.z + 1
    # ƒ|[ƒYƒTƒCƒ“ˆÊ’u
    @pause.x = self.x + self.width / 2 + 8
    @pause.y = self.y + self.height - 24
    # ’â~ƒtƒ‰ƒO
    @stay_flag = false
  end
  #--------------------------------------------------------------------------
  # œ ƒeƒLƒXƒgİ’è
  #     text  : ƒEƒBƒ“ƒhƒE‚É•\¦‚·‚é•¶š—ñ(•¶š“ü‚è‚Ì”z—ñ‚²‚Æ“n‚µ‚Ä‚àOK)
  #     align : ƒAƒ‰ƒCƒ“ƒƒ“ƒg (0..¶‘µ‚¦A1..’†‰›‘µ‚¦A2..‰E‘µ‚¦)
  #--------------------------------------------------------------------------
  def refresh
    text = $game_temp.battle_log_text
    
    #p $game_temp.battle_log_text
    
    
    
    
=begin
      # ƒƒO‹¸³
      if ["\\","\\\","\\\","\\y\"].include?($game_temp.battle_back_log)
        $game_temp.battle_back_log += "CLEAR"
        $game_temp.battle_back_log.gsub!("\CLEAR","")
      elsif $game_temp.battle_back_log == "\n"
        $game_temp.battle_back_log = ""
      end
=end
    
    
=begin
    # ƒ}ƒjƒ…ƒAƒ‹ƒ‚[ƒh‚Í––”ö‚É\‚ğ‚Â‚¯‚é
    if $game_system.system_read_mode == 0
      text += "CHECK"
      if text.match("\\CHECK")
        text.gsub!("CHECK","")
      else
        text.gsub!("CHECK","\\")
      end
    end
=end

=begin    
    # ƒƒO‹¸³
    if ["\n","\"].include?(text)
      $game_temp.battle_log_text = ""
      return
    end
=end
    # ƒL[ƒv’†‚È‚çÅŒã‚Éæ“¾‚µ‚½À•W‚ğ“Ç‚İ‚İ
    if @keep_flag == true
      x = @last_x
      y = @last_y
      @keep_flag = false
    else
      # ƒL[ƒv‚µ‚Ä‚È‚¢‚ÍÀ•W‚ğƒNƒŠƒA
      x = y = 0
      # ƒoƒbƒNƒƒO‚É‰üsw’è‚ğ’Ç‰Á
      $game_temp.battle_back_log += "\n"
    end

    # §Œä•¶šˆ—
    begin
      last_text = text.clone
      text.gsub!(/\\[Vv]\[([0-9]+)\]/) { $game_variables[$1.to_i] }
    end until text == last_text
    text.gsub!(/\\[Nn]\[([0-9]+)\]/) do
      $game_actors[$1.to_i] != nil ? $game_actors[$1.to_i].name : ""
    end
    # •Ö‹XãA"\\\\" ‚ğ "\000" ‚É•ÏŠ·
    text.gsub!(/\\\\/) { "\000" }
    # "\\C" ‚ğ "\001" ‚ÉA"\\G" ‚ğ "\002" ‚É•ÏŠ·
    text.gsub!(/\\[Cc]\[([0-9]+)\]/) { "\001[#{$1}]" }
    text.gsub!(/\\[Gg]/) { "\002" }
    # c ‚É 1 •¶š‚ğæ“¾ (•¶š‚ªæ“¾‚Å‚«‚È‚­‚È‚é‚Ü‚Åƒ‹[ƒv)
    while ((c = text.slice!(/./m)) != nil)
      # \\ ‚Ìê‡
      if c == "\000"
        # –{—ˆ‚Ì•¶š‚É–ß‚·
        c = "\\"
      end
      # \C[n] ‚Ìê‡
      if c == "\001"
        # •¶šF‚ğ•ÏX
        text.sub!(/\[([0-9]+)\]/, "")
        color = $1.to_i
        if color >= 0 and color <= 7
          self.contents.font.color = text_color(color)
        end
        # Ÿ‚Ì•¶š‚Ö
        next
      end
      if c == "\H"
        heart = RPG::Cache.picture("heart")
        self.contents.blt(x + 6 , 24 * y + 10, heart, Rect.new(0, 0, 16, 16))
        x += 16
        # Ÿ‚Ì•¶š‚Ö
        next
      end
      # ƒEƒFƒCƒg•¶š(’·ŠÔ)‚Ìê‡
      if c == "\"
        # ƒEƒFƒCƒg‚ğ“ü‚ê‚é
        case $game_system.ms_skip_mode
        when 3 #è“®‘—‚èƒ‚[ƒh
          @wait_count = 1
        when 2 #ƒfƒoƒbƒOƒ‚[ƒh
          @wait_count = 3
        when 1 #‰õ‘¬ƒ‚[ƒh
          @wait_count = 4
        else
          @wait_count = ($game_system.battle_speed_time(1) * 3)
        end
        $game_temp.battle_log_wait_flag = true
        # ¡‚ÌÀ•W‚ğˆÛ‚µ‚Ä•Ô‚·
        @keep_flag = true
        @last_x = x
        @last_y = y
        return
      end
      # ƒEƒFƒCƒg•¶š(’ZŠÔ)‚Ìê‡
      if c == "\"
        # ƒEƒFƒCƒg‚ğ“ü‚ê‚é
        case $game_system.ms_skip_mode
        when 3 #è“®‘—‚èƒ‚[ƒh
          @wait_count = 1
        when 2 #ƒfƒoƒbƒOƒ‚[ƒh
          @wait_count = 1
        when 1 #‰õ‘¬ƒ‚[ƒh
          @wait_count = 2
        else
          @wait_count = $game_system.battle_speed_time(1)
        end
        $game_temp.battle_log_wait_flag = true
        # ¡‚ÌÀ•W‚ğˆÛ‚µ‚Ä•Ô‚·
        @keep_flag = true
        @last_x = x
        @last_y = y
        return
      end
      # ƒEƒFƒCƒg•¶š(ƒVƒXƒeƒ€)‚Ìê‡
      #if c == "\y"
      #  # ƒEƒFƒCƒg‚ğ“ü‚ê‚é
      #  case $game_system.ms_skip_mode
      #  when 3 #è“®‘—‚èƒ‚[ƒh
      #    @wait_count = 1
      #  when 2 #ƒfƒoƒbƒOƒ‚[ƒh
      #    @wait_count = 8
      #  when 1 #‰õ‘¬ƒ‚[ƒh
      #    @wait_count = 12
      #  else
      #    @wait_count = $game_system.battle_speed_time(0)
      #  end
      #  $game_temp.battle_log_wait_flag = true
      #  # ¡‚ÌÀ•W‚ğˆÛ‚µ‚Ä•Ô‚·
      #  @keep_flag = true
      #  @last_x = x
      #  @last_y = y
      #  return
      #end
      # ‰üs•¶š‚Ìê‡
      if c == "\n"
        # y ‚É 1 ‚ğ‰ÁZ
        y += 1
        x = 0
        @keep_flag = true
        @last_x = x
        @last_y = y
        # ƒoƒbƒNƒƒO‚É‰üsw’è‚ğ’Ç‰Á
        $game_temp.battle_back_log += "\n"
        # ƒƒO‚ª‚¢‚Á‚Ï‚¢‚È‚çƒNƒŠƒAƒtƒ‰ƒO‚ğ“ü‚ê‚Ä•Ô‚·
        if y > 3 #and text != ""
#          if Input.trigger?(Input::C)
            @clear_flag = true
            $game_temp.battle_log_wait_flag = true
            @keep_flag = false
            #šè“®‘—‚è‚Ìê‡‚Ì‚İƒXƒeƒCƒtƒ‰ƒO‚ğ“ü‚ê‚é
            if $game_system.system_read_mode == 0
              @stay_flag = true
            end
            case $game_system.ms_skip_mode
            when 3 #è“®‘—‚èƒ‚[ƒh
              @wait_count = 4
            when 2 #ƒfƒoƒbƒOƒ‚[ƒh
              @wait_count = 8
            when 1 #‰õ‘¬ƒ‚[ƒh
              @wait_count = 12
            else
              @wait_count = $game_system.battle_speed_time(0) + $game_system.important_wait_time
            end
#          end
          return
        end
        # Ÿ‚Ì•¶š‚Ö
        next
      end
      # è“®‰üs•¶š‚Ìê‡
      if c == "\"
        # y ‚É 1 ‚ğ‰ÁZ
        y += 1
        x = 0
        @keep_flag = true
        @last_x = x
        @last_y = y
        #šè“®‘—‚è‚Ìê‡‚Ì‚İƒXƒeƒCƒtƒ‰ƒO‚ğ“ü‚ê‚é
        if $game_system.system_read_mode == 0
          @stay_flag = true
          @wait_count = 1
        end
        # ƒoƒbƒNƒƒO‚É‰üsw’è‚ğ’Ç‰Á
        $game_temp.battle_back_log += "\n"
        # ƒƒO‚ª‚¢‚Á‚Ï‚¢‚È‚çƒNƒŠƒAƒtƒ‰ƒO‚ğ“ü‚ê‚Ä•Ô‚·
        if y > 3 #and text != ""
#          if Input.trigger?(Input::C)
            @clear_flag = true
            $game_temp.battle_log_wait_flag = true
            @keep_flag = false
            case $game_system.ms_skip_mode
            when 3 #è“®‘—‚èƒ‚[ƒh
              @wait_count = 4
            when 2 #ƒfƒoƒbƒOƒ‚[ƒh
              @wait_count = 8
            when 1 #‰õ‘¬ƒ‚[ƒh
              @wait_count = 12
            else
              @wait_count = $game_system.battle_speed_time(0) + $game_system.important_wait_time
            end
#          end
          return
#        elsif y > 3 and text == ""
#          @stay_flag = false
        end
        # Ÿ‚Ì•¶š‚Ö
        if $game_system.system_read_mode == 0
          return
        else
          next
        end
      end
      # •¶š‚ğ•`‰æ
#      self.contents.font.name = ["ƒƒCƒŠƒI"]
      self.contents.draw_text(4 + x, 24 * y, 40, 32, c)
      # x ‚É•`‰æ‚µ‚½•¶š‚Ì•‚ğ‰ÁZ
      x += self.contents.text_size(c).width #+ 2
      # ƒfƒoƒbƒO—pA‰¡•¶š”Šm”F
      if 4 + x > self.contents.width and $DEBUG
        Audio.se_play("Audio/SE/069-Animal04", 80, 100)
        print "ƒGƒ‰[F‚±‚Ìs‚Í‰¡•¶š”‚ğ’´‰ß‚µ‚Ä‚¢‚Ü‚·B\n•¶š”F#{(x/14)-1}/26@‰¡•F#{4 + x}/#{self.contents.width}"
      end
      # ƒoƒbƒNƒƒO‚É•¶š‚ğ’Ç‰Á
      $game_temp.battle_back_log += c
    end
   self.visible = true
   @bgframe_sprite.visible = true

   
   
  end
  #--------------------------------------------------------------------------
  # œ ƒtƒŒ[ƒ€XV
  #--------------------------------------------------------------------------
  def update
    # oŒ»ˆ—
    if @bgframe_sprite.opacity < 255
      @bgframe_sprite.opacity += 51
    end
    if @bgframe_sprite.y > -20
      @bgframe_sprite.y -= 1
      return
    end
    
    # ƒXƒeƒCƒtƒ‰ƒO‚ª—§‚Á‚Ä‚¢‚éê‡Š‚ÂAƒ}ƒjƒ…ƒAƒ‹ƒ‚[ƒh‚Ì‚İ’â~ó‘Ô‚É‚·‚é
    if @stay_flag
      @wait_count = 2
      $game_temp.battle_log_wait_flag = true
      @pause.visible = true
    end

    # ƒ|[ƒYƒTƒCƒ“
    @pause.update if @pause.visible

    if Input.trigger?(Input::C)
      @wait_count = 1
      if @stay_flag
        $game_temp.battle_log_wait_flag = false
        @stay_flag = false
        @pause.visible = false
      end
    end

    if @stay_flag and $game_system.system_read_mode != 0
      $game_temp.battle_log_wait_flag = false
      @stay_flag = false
      @pause.visible = false
      @wait_count = 1 if @wait_count == 0
    end
    
    if @wait_count > 0
      @wait_count -= 1
      if @wait_count == 0 and @clear_flag == true
        self.contents.clear
        @keep_flag = false
        @clear_flag = false
      end
      return
    end
    
    # ƒƒO‹¸³
    if $game_temp.battle_log_text != ""
      log_correction 
    end
    
    # ƒƒbƒZ[ƒW‚ª‚ ‚ê‚ÎƒŠƒtƒŒƒbƒVƒ…
    if $game_temp.battle_log_text != ""
      if $game_temp.battle_log_text == "\n"
        $game_temp.battle_log_text = ""
        return
      end
      refresh
    end
  end
  #--------------------------------------------------------------------------
  # œ ƒƒO‹¸³
  #--------------------------------------------------------------------------
  def log_correction

    # ƒEƒFƒCƒg‚Ì‡˜‚ğ’¼‚·
    $game_temp.battle_log_text.gsub!("\n\","\\n")
    $game_temp.battle_log_text.gsub!("\\","\\")
    
    # ‰üs‚ªd•¡‚µ‚Ä‚¢‚éê‡A‚P‚Â‚É‚·‚é
    $game_temp.battle_log_text.gsub!(/(\\\\n)+/,"\\n")
    $game_temp.battle_log_text.gsub!(/(\\\\)+/,"\\")
    
    # \\nE\\‚¾‚¯‚Ìê‡AƒeƒLƒXƒg‚ğÁ‚·
    if ["\\n","\\"].include?($game_temp.battle_log_text)
      $game_temp.battle_log_text = ""
    end

  end
  #--------------------------------------------------------------------------
  # œ ‰ğ•ú
  #--------------------------------------------------------------------------
  def dispose
    super
    @bgframe_sprite.dispose
    # ƒ|[ƒYƒTƒCƒ“
    @pause.dispose
  end
end
#==============================================================================
# ƒƒbƒZ[ƒW”wŒi
#==============================================================================
class Game_System
  attr_accessor :battlelog_back_name
  def battlelog_back_name
    return @battlelog_back_name.nil? ? "battle_message" : @battlelog_back_name
  end
end
