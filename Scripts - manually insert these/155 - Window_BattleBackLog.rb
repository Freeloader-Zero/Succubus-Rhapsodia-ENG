#==============================================================================
# ¡ Window_BattleBackLog
#==============================================================================
class Window_BattleBackLog < Window_Base
  #--------------------------------------------------------------------------
  # œ ŒöŠJƒCƒ“ƒXƒ^ƒ“ƒX•Ï”
  #--------------------------------------------------------------------------
  #--------------------------------------------------------------------------
  # œ ƒIƒuƒWƒFƒNƒg‰Šú‰»
  #--------------------------------------------------------------------------
  def initialize
#    super(-64, -64, 720, 640)
    super(-64, -64, 720, 640)
    self.contents = Bitmap.new(width - 32, height - 32)
    self.back_opacity = 150
    self.z = 1100
    @log_text = ""
    @index = 0
    
    # ¤‰Šúİ’è
    #--------------------------------------------------------------------------
    @start_x = 164 # ŠJn‚wÀ•W
    @start_y = 64  # ŠJn‚xÀ•W
    @max_line = 18 # Å‘å•\¦s”
    @scroll_speed = 24
  end
  #--------------------------------------------------------------------------
  # œ ƒƒOƒeƒLƒXƒg‚ÌƒŠƒtƒŒƒbƒVƒ…
  #--------------------------------------------------------------------------
  def log_text_refresh
    # ƒƒOƒeƒLƒXƒg•Ï”‚ÉV‚µ‚¢•¶Í‚ğ’Ç‰Á
    @log_text += $game_temp.battle_back_log
    $game_temp.battle_back_log = ""
    # ‰üs‚Ìd•¡‚ğ’¼‚·
    @log_text.gsub!("\n\n","\n")
    
    # ¤ƒƒOƒeƒLƒXƒg‚Ìs”‚ª‹K’è’l‚ğ’´‚¦‚½ê‡A‘O‚Ìs‚ğí‚éˆ—
    #--------------------------------------------------------------------------
    # ‚Ü‚¸s‚Å‹æ•ª‚¯‚ğs‚¤
    @log_text.gsub!("\n","\n/")
    text_lines = @log_text.split(/\//)
    # ‹ó”’‚â‰üs‚Ì‚İ‚É‚È‚Á‚Ä‚¢‚és‚Ííœ‚·‚é
    for i in 0...text_lines.size
      if text_lines[i] == "" or text_lines[i] == "\n"
        text_lines[i] = nil
      end
    end
    text_lines.compact!
    # ’´‰ß‚µ‚½s‚ª‚ ‚éê‡A‚»‚Ì•ª‘O‚©‚çíœ‚·‚é
    over_lines = text_lines.size - @max_line
    if over_lines > 0
      for i in 0...over_lines
        text_lines.shift
      end
    end
    # ƒeƒLƒXƒg‚ğ“ü‚ê‚È‚¨‚·
    new_text = ""
    for text_one in text_lines
      new_text += text_one
    end
    @log_text = new_text
  end
  #--------------------------------------------------------------------------
  # œ ƒeƒLƒXƒgİ’è
  #--------------------------------------------------------------------------
  def refresh
    # ‰Šú‰»
    self.contents.clear
    x = @start_x
    line_deep = 0
    # ƒƒOƒeƒLƒXƒg‚Ì•¡»‚ğŠi”[
    text = @log_text.clone
    # c ‚É 1 •¶š‚ğæ“¾ (•¶š‚ªæ“¾‚Å‚«‚È‚­‚È‚é‚Ü‚Åƒ‹[ƒv)
    while ((c = text.slice!(/./m)) != nil)
      # ŠOš‚Ìê‡
      if c == "\H"
        heart = RPG::Cache.picture("heart")
        self.contents.blt(x + 6 , 24 * line_deep + @start_y + 9, heart, Rect.new(0, 0, 16, 16))
        x += 16
        next
      end
      # ‰üs•¶š‚Ìê‡
      if c == "\n"
        x = @start_x
        line_deep += 1
        next
      end
      # •¶š‚ğ•`‰æ
      self.contents.draw_text(4 + x, 24 * line_deep + @start_y, 40, 32, c)
      # x ‚É•`‰æ‚µ‚½•¶š‚Ì•‚ğ‰ÁZ
      x += self.contents.text_size(c).width #+ 2
      if c == "\"
        x = @start_x
        line_deep += 1
        next
      end
      # •¶š‚ğ•`‰æ
      self.contents.draw_text(4 + x, 24 * line_deep + @start_y, 40, 32, c)
      # x ‚É•`‰æ‚µ‚½•¶š‚Ì•‚ğ‰ÁZ
      x += self.contents.text_size(c).width #+ 2
    end
    # ˆê”Ô‰º‚Ìs‚ª•\¦‚³‚ê‚é‚æ‚¤‚É•\¦
  end
  #--------------------------------------------------------------------------
  # œ ƒtƒŒ[ƒ€XV
  #--------------------------------------------------------------------------
  def update
    # ƒƒbƒZ[ƒW‚ª‚ ‚ê‚ÎƒƒOƒeƒLƒXƒg‚ğƒŠƒtƒŒƒbƒVƒ…
    if $game_temp.battle_back_log != ""
      log_text_refresh
    end
    # •\¦’†‚Å‚È‚¢ê‡A‘€ì‚ğó‚¯•t‚¯‚È‚¢
    return unless self.visible
=begin    
    # •ûŒüƒ{ƒ^ƒ“‚Ìã‚ª‰Ÿ‚³‚ê‚½ê‡
    if Input.repeat?(Input::UP)
      self.oy += @scroll_speed
      return
    end
    # •ûŒüƒ{ƒ^ƒ“‚Ì‰º‚ª‰Ÿ‚³‚ê‚½ê‡
    if Input.repeat?(Input::DOWN)
      self.oy -= @scroll_speed
      return
    end
=end
  end
  #--------------------------------------------------------------------------
  # œ •\¦‚ÉƒŠƒtƒŒƒbƒVƒ…‚ğ‚©‚¯‚é
  #--------------------------------------------------------------------------
  def visible=(visible)
    refresh if visible == true
    super
  end
end