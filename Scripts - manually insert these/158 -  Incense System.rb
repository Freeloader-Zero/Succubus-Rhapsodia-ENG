#==============================================================================
# ¡ Incense_System
#------------------------------------------------------------------------------
# @ƒCƒ“ƒZƒ“ƒX
#==============================================================================

class Incense
  #--------------------------------------------------------------------------
  # œ ŒöŠJƒCƒ“ƒXƒ^ƒ“ƒX•Ï”
  #--------------------------------------------------------------------------
  attr_accessor :name                        # –¼‘O
  attr_accessor :remaining_turn              # c‚èƒ^[ƒ“
  attr_accessor :start_text                  # ŠJnƒeƒLƒXƒg
  attr_accessor :fragranting_text            # Œp‘±’†ƒeƒLƒXƒg
  attr_accessor :end_text                    # I—¹ƒeƒLƒXƒg
  # ƒXƒe[ƒ^ƒX•â³
  attr_accessor :atk_rate
  attr_accessor :pdef_rate
  attr_accessor :str_rate                    
  attr_accessor :dex_rate                     
  attr_accessor :agi_rate
  attr_accessor :int_rate
  attr_accessor :plus_rate
  #--------------------------------------------------------------------------
  # œ ƒIƒuƒWƒFƒNƒg‰Šú‰»
  #--------------------------------------------------------------------------
  def initialize(incense_name)
    
    @name = incense_name
    @remaining_turn = 5
    @start_text       = ""
    @fragranting_text = ""
    @end_text         = ""
    @plus_rate = [0,0,0,0,0,0]
    
    @atk_rate  = 100
    @pdef_rate = 100
    @str_rate  = 100
    @dex_rate  = 100
    @agi_rate  = 100
    @int_rate  = 100
    
    actors_word  = "–¡•û"
    enemies_word = "–¡•û" # Œã‚Å‰ü•Ï‚·‚é
    field_word   = "üˆÍ"
    brk_word   = "brk"
    
    case incense_name
    
    #--------------------------------------------------------------------------
    # ©wŒø‰Ê
    #-------------------------------------------------------------------|------
    when "ƒŠƒ‰ƒbƒNƒXƒ^ƒCƒ€" # Y
      @start_text       = "#{actors_word}‚ÉˆÀ‘§‚Ì‚ª–K‚ê‚½I"
      @fragranting_text = "#{actors_word}‚ÉˆÀ‘§‚Ì‚ª—¬‚ê‚Ä‚¢‚éccI"
      @end_text         = "#{actors_word}‚ÌˆÀ‘§‚Ì‚ªI‚í‚Á‚½I"
      # –ˆƒ^[ƒ“I—¹‚É¬‰ñ•œ
    #-------------------------------------------------------------------|------
    when "ƒXƒC[ƒgƒAƒƒ}" # Y
#      @start_text       = "#{actors_word}‚ÉŠÃ‚¢‚è‚ª—§‚¿‚ß‚½I"
      @start_text       = "#{actors_word}‚Ì–£—Í‚ªã¸‚µ‚½I"
      @fragranting_text = "#{actors_word}‚ÍŠÃ‚¢‚è‚É•ï‚Ü‚ê‚Ä‚¢‚éccI"
      @end_text         = "#{actors_word}‚©‚çŠÃ‚¢‚è‚ª”–‚ê‚½I"
      @plus_rate[0] = 50
      @atk_rate  = 150
      # –£—Í‹­‰»
    #-------------------------------------------------------------------|------
    when "ƒpƒbƒVƒ‡ƒ“ƒr[ƒg" # Y
#      @start_text       = "#{actors_word}‚Ì‚â‚é‹C‚ª‚‚Ü‚Á‚½I"
      @start_text       = "#{actors_word}‚Ì¸—Í‚Æ‘f‘‚³‚ªã¸‚µ‚½I"
      @fragranting_text = "#{actors_word}‚Ì‚â‚é‹C‚Í‚‚Ü‚Á‚Ä‚¢‚éccI"
      @end_text         = "#{actors_word}‚Ì‚â‚é‹C‚ª—‚¿’…‚¢‚½I"
      @plus_rate[2] = 130
      @plus_rate[4] = 130
      # ¸—ÍA‘f‘‚³‹­‰»
    #-------------------------------------------------------------------|------
    when "ƒ}ƒCƒ‹ƒhƒpƒtƒ…[ƒ€" # Y
#      @start_text       = "#{actors_word}‚É_‚©‚È‚è‚ª—§‚¿‚ß‚éI"
      @start_text       = "#{actors_word}‚Íó‘ÔˆÙí‚É‹­‚­‚È‚Á‚½I"
      @fragranting_text = "#{actors_word}‚Í_‚©‚È‚è‚ğ“Z‚Á‚Ä‚¢‚éccI"
      @end_text         = "#{actors_word}‚©‚ç_‚©‚È‚è‚ª”–‚ê‚½I"
      # ƒoƒXƒe‘Ï«’l‘‰Á
    #-------------------------------------------------------------------|------
    when "ƒŒƒbƒhƒJ[ƒyƒbƒg" # Y
      @start_text       = "#{actors_word}‚Í’‡ŠÔ‚Ìo”Ô‚Ì€”õ‚ğ®‚¦‚½I"
      @fragranting_text = "#{actors_word}‚Í#{brk_word}’‡ŠÔ‚Ìo”Ô‚Ì€”õ‚ª®‚Á‚Ä‚¢‚éI"
      @end_text         = "#{actors_word}‚Ì#{brk_word}ƒŒƒbƒhƒJ[ƒyƒbƒg‚ª–³‚­‚È‚Á‚½I"
      # Œğ‘ã‚Åo‚Ä‚«‚½–²–‚‚Ì–£—ÍE‘f‘‚³‹­‰»
    #-------------------------------------------------------------------|------
    when "ˆÀ‰¸‚Ì" # i–vj
      @fragranting_text = "#{actors_word}‚Íg‘Ì‚ğ‹x‚ß‚Ä‚¢‚éccI"
      # ‰ñ•œ—ÊƒAƒbƒv
    #-------------------------------------------------------------------|------

#      @start_text       = "#{field_word}‚ÉŠ¯”\“I‚È‚è‚ª—§‚¿‚ß‚éI"
    #--------------------------------------------------------------------------
    # “GwŒø‰Ê
    #--------------------------------------------------------------------|------
    when "ƒXƒgƒŒƒ“ƒWƒXƒ|ƒA" # Y
#      @start_text       = "#{enemies_word}‚ÉŠï–­‚È–Eq‚ª•Y‚¢n‚ß‚½I"
      @start_text       = "#{enemies_word}‚Íó‘ÔˆÙí‚Éã‚­‚È‚Á‚½I"
      @fragranting_text = "#{enemies_word}‚ÉŠï–­‚È–Eq‚ª•Y‚Á‚Ä‚¢‚éccI"
      @end_text         = "#{enemies_word}‚É•Y‚¤Šï–­‚È–Eq‚ª–³‚­‚È‚Á‚½I"
      # ƒoƒXƒe‘Ï«’lŒ¸­
    #--------------------------------------------------------------------|------
    when "ƒEƒB[ƒNƒXƒ|ƒA" # Y
#      @start_text       = "#{enemies_word}‚ÉˆÃ‚¢–Eq‚ª•Y‚¢n‚ß‚½I"
      @start_text       = "#{enemies_word}‚É”–ˆÃ‚­–Eq‚ª•Y‚¢n‚ß‚½I"
      @fragranting_text = "#{enemies_word}‚É”–ˆÃ‚­–Eq‚ª•Y‚Á‚Ä‚¢‚éccI"
      @end_text         = "#{enemies_word}‚É”–ˆÃ‚­•Y‚¤–Eq‚ª–³‚­‚È‚Á‚½I"
      # ó‘ÔˆÙíA”í‚r‚r—¦ƒAƒbƒvB
    #--------------------------------------------------------------------|------
    when "íœÉ‚«" # i–vj
      @fragranting_text = "#{enemies_word}‚Í‹Ù’£Š´‚É•ï‚Ü‚ê‚Ä‚¢‚éccI"
      # ˆØ•|A¸_—Í‚ª1/2‚É‚È‚é
    #--------------------------------------------------------------------|------
    when "ˆĞ”—" # Y
#      @start_text       = "#{enemies_word}‚ÍˆĞ”—‚³‚ê‚Ä‚µ‚Ü‚Á‚½I"
      @start_text       = "#{enemies_word}‚ÍƒŒƒWƒXƒg‚Éã‚­‚È‚Á‚½I"
      @fragranting_text = "#{enemies_word}‚ÍˆĞ”—‚³‚ê‚Ä‚¢‚éccI"
      @end_text         = "#{enemies_word}‚ÌˆĞ”—‚ÌŒø‰Ê‚ª–³‚­‚È‚Á‚½I"
      # ƒŒƒWƒXƒg“ïˆÕ“x‘‰Á
    #--------------------------------------------------------------------|------
    when "S’Í‚İ" # Y
      @start_text       = "#{enemies_word}‚Í“¦‚°‚ç‚ê‚È‚­‚È‚Á‚½I"
      @fragranting_text = "#{enemies_word}‚ÍŒã‚ë”¯‚ğˆø‚©‚ê‚Ä‚¢‚éI"
      @end_text         = "#{enemies_word}‚ÌS’Í‚İ‚ÌŒø‰Ê‚ª–³‚­‚È‚Á‚½I"
      # “¦‚°‚ç‚ê‚È‚¢B
    #--------------------------------------------------------------------|----
    when "‘S‚Ä‚ÍŒ»" # Y
      @start_text       = "#{enemies_word}‚ÌŠ´Šo‚ª‹}Œƒ‚É‘N–¾‚É‚È‚éI"
      @fragranting_text = "#{enemies_word}‚ÌŠ´Šo‚ª‘N–¾‚É‚È‚Á‚Ä‚¢‚éccI"
      @end_text         = "#{enemies_word}‚Ì‘N–¾‚³‚ªã‚Ü‚Á‚½I"
      # ”í‚r‚r—¦ƒAƒbƒv
    #--------------------------------------------------------------------|------
      
    # ‘S‘ÌŒø‰Ê
    #-------------------------------------------------------------------------
    when "ƒ‰ƒuƒtƒŒƒOƒ‰ƒ“ƒX" # Y
      @start_text       = "#{field_word}‚ÉŠ¯”\“I‚È‚è‚ª—§‚¿‚ß‚éI"
      @fragranting_text = "#{field_word}‚ÍŠ¯”\“I‚È‚è‚É•ï‚Ü‚ê‚Ä‚¢‚éccI"
      @end_text         = "#{field_word}‚©‚çŠ¯”\“I‚È‚è‚ª”–‚ê‚½I"
      # –ˆƒ^[ƒ“ŠJn‚Éƒ€[ƒhƒAƒbƒv
    #-------------------------------------------------------------------------
    when "ƒXƒ‰ƒCƒ€ƒtƒB[ƒ‹ƒh" # Y
      @start_text       = "#{field_word}‚É”S‰t‚ªL‚ª‚Á‚½I"
      @fragranting_text = "#{field_word}‚Í”S‰t‚ªL‚ª‚Á‚Ä‚¢‚éccI"
      @end_text         = "#{field_word}‚ÉL‚ª‚Á‚Ä‚¢‚½”S‰t‚ª–³‚­‚È‚Á‚½I"
      # UŒ‚‚Åã¸‚·‚éŠŠ“x—Ê‚ªã‚ª‚é
    #--------------------------------------------------------------------------
    
    # ‚»‚êˆÈŠO‚Í–¼‘O‚ğƒŠƒZƒbƒg‚µAŒã‚Å‚±‚ê‚Ü‚é‚²‚ÆÁ‚µ‚Ä‚à‚ç‚¤
    else 
      @name = ""
    end
  end
end

class Incense_System
  #--------------------------------------------------------------------------
  # œ ŒöŠJƒCƒ“ƒXƒ^ƒ“ƒX•Ï”
  #--------------------------------------------------------------------------
  attr_accessor :data
  #--------------------------------------------------------------------------
  # œ ƒIƒuƒWƒFƒNƒg‰Šú‰»
  #--------------------------------------------------------------------------
  def initialize
    @data = [[],[],[]]
  end
  #--------------------------------------------------------------------------
  # œ ƒXƒe[ƒ^ƒX•â³”’l
  #--------------------------------------------------------------------------
  def inc_adjusted_value(battler, type)
    n = 0
    value = 100
    n = 0 if battler.is_a?(Game_Actor)
    n = 1 if battler.is_a?(Game_Enemy)
    n = battler if battler.is_a?(Integer)
    for i in [n, 2].uinq!
      for inc_one in @data[n]
        value += inc_one.plus_rate[type]
      end
    end
    return value
  end
  #--------------------------------------------------------------------------
  # œ ‚±‚ÌƒCƒ“ƒZƒ“ƒX‚ª‚ ‚é‚©H
  #--------------------------------------------------------------------------
  def actors_inc
    return @data[0][0]
  end
  def enemies_inc
    return @data[1][0]
  end
  def all_inc
    return @data[2][0]
  end
  #--------------------------------------------------------------------------
  # œ ‚±‚ÌƒCƒ“ƒZƒ“ƒX‚ª‚ ‚é‚©
  #--------------------------------------------------------------------------
  def exist?(name, battler)
    result = false
    n = 0
    n = 0 if battler.is_a?(Game_Actor)
    n = 1 if battler.is_a?(Game_Enemy)
    n = battler if battler.is_a?(Integer)
    for i in [n, 2].uinq!
      for incense in @data[i]
        result = true if incense.name == name
      end
    end
    return result 
  end
  #--------------------------------------------------------------------------
  # œ g—pÒ‚Æ”­¶Œ¹‚©‚çƒCƒ“ƒZƒ“ƒX‚ğ’Ç‰Á‚·‚é
  #--------------------------------------------------------------------------
  def use_incense(user, val)
    result = false
    # val‚ªƒXƒLƒ‹‚à‚µ‚­‚ÍƒAƒCƒeƒ€‚Å‚È‚¢ê‡I—¹
    unless val.is_a?(RPG::Skill) or val.is_a?(RPG::Item)
      return false
    end
    # Œø‰Ê”ÍˆÍ‚©‚ç“KØ‚È‰ÓŠ‚É’Ç‰Á
    case val.scope
    when 2 # “G‘S‘Ì@¨“GŒR
      result = add_incense(val.name, 1) if user.is_a?(Game_Actor)
      result = add_incense(val.name, 0) if user.is_a?(Game_Enemy)
    when 4 # –¡•û‘S‘Ì@¨©ŒR
      result = add_incense(val.name, 0) if user.is_a?(Game_Actor)
      result = add_incense(val.name, 1) if user.is_a?(Game_Enemy)
    when 7 # g—pÒ@¨‘S‘Ì
      result = add_incense(val.name, 2)
    end
    return result
  end
  #--------------------------------------------------------------------------
  # œ ƒCƒ“ƒZƒ“ƒX‚ğ’Ç‰Á
  #--------------------------------------------------------------------------
  def add_incense(name, box_number)
    # ‚·‚Å‚É‚ ‚éê‡‚ÍI—¹
    return false if exist?(name, box_number)
    # ƒCƒ“ƒZƒ“ƒX‚Ì’Ç‰Á
    @data[box_number].push(Incense.new(name))
    # İ’è‚³‚ê‚Ä‚¢‚È‚¢ƒCƒ“ƒZƒ“ƒX‚Ìê‡Aíœ‚·‚é
    if @data[box_number][@data[box_number].size - 1].name == ""
      @data[box_number].delete(@data[box_number][@data[box_number].size - 1])
      return false
    end
    add_text(name, box_number)
    return true
  end
  #--------------------------------------------------------------------------
  # œ ƒCƒ“ƒZƒ“ƒX‚ğíœ
  #--------------------------------------------------------------------------
  def delete_incense(name, box_number)
    for incense in @data[box_number]
      if incense.name == name
        remove_text(name, box_number)
        @data[box_number].delete(incense)
#        text =
#          case box_number
#          when 0;"–¡•û‚Ì#{incense.name}‚ÌŒø‰Ê‚ª–³‚­‚È‚Á‚½"
#          when 1;"“G‚Ì#{incense.name}‚ÌŒø‰Ê‚ª–³‚­‚È‚Á‚½"
#          when 2;"ê‚Ì#{incense.name}‚ÌŒø‰Ê‚ª–³‚­‚È‚Á‚½"
#          end
      end
    end
  end
  #--------------------------------------------------------------------------
  # œ ƒCƒ“ƒZƒ“ƒX‚ğ‘S‚ÄƒŠƒZƒbƒgi‰½‚©‚Ğ‚Æ‚Â‚Å‚à‚ ‚Á‚½‚È‚ç‚Îtrue‚ğ•Ô‚·j
  #--------------------------------------------------------------------------
  def delete_incense_all
    result = false
    result = true if @data != [[],[],[]]
    @data = [[],[],[]]
    return result
  end
  #--------------------------------------------------------------------------
  # œ ƒ^[ƒ“I—¹‚ÌŒ¸­
  #--------------------------------------------------------------------------
  def turn_end_reduction
    index = 0
    for data_one in @data
      for incense in data_one
        incense.remaining_turn -= 1
        delete_incense(incense.name, index) if incense.remaining_turn <= 0
      end
      index += 1
    end
  end
  #--------------------------------------------------------------------------
  # œ ƒCƒ“ƒZƒ“ƒX•t—^ƒeƒLƒXƒg
  #--------------------------------------------------------------------------
  def add_text(name, box_number)
    txt = ""
    if $incense.data[box_number] != []
      for incense_one in $incense.data[box_number]
        if incense_one.name == name
          txt += text_alter(incense_one.start_text + "\\", box_number)
        end
      end
    end
    if txt != ""
      if $game_system.system_read_mode != 0
        txt += "CLEAR"
        txt.sub!("\\CLEAR","")
      end
      $game_temp.battle_log_text += txt
    else
      return ""
    end
  end
  #--------------------------------------------------------------------------
  # œ ƒCƒ“ƒZƒ“ƒX‰ğœƒeƒLƒXƒg
  #--------------------------------------------------------------------------
  def remove_text(name, box_number)
    txt = ""
    if $incense.data[box_number] != []
      for incense_one in $incense.data[box_number]
        if incense_one.name == name
          txt += text_alter(incense_one.end_text + "\\", box_number)
        end
      end
    end
    if txt != ""
      if $game_system.system_read_mode != 0
        txt += "CLEAR"
        txt.sub!("\\CLEAR","")
      end
      # –‘O‚ÉƒeƒLƒXƒg‚ª‚ ‚Á‚½ê‡‚Í‰üs‚ğ‘}‚·
      txt = "\\" + txt if $game_temp.battle_log_text != "" 
      $game_temp.battle_log_text += txt
    else
      return ""
    end
  end
  #--------------------------------------------------------------------------
  # œ ƒCƒ“ƒZƒ“ƒXŒp‘±ƒeƒLƒXƒg
  #--------------------------------------------------------------------------
  def keep_text_call
    txt = ""
    for i in 0..2
      if $incense.data[i] != []
        for incense_one in $incense.data[i]
          txt += text_alter(incense_one.fragranting_text + "\\", i)
        end
      end
    end
    if txt != ""
      if $game_system.system_read_mode != 0
        txt += "CLEAR"
        txt.sub!("\\CLEAR","")
      end
      $game_temp.battle_log_text += txt
    else
      return ""
    end
  end
  #--------------------------------------------------------------------------
  # œ ƒeƒLƒXƒg’†‚Ì‰ü•Ï
  #--------------------------------------------------------------------------
  def text_alter(text, box_number)
    count = 0
    delegate = nil
    text.gsub!("–¡•û", "‘Šè") if box_number == 1
    
    for actor in $game_party.battle_actors
      if actor.exist?
        delegate = actor if delegate == nil
        count += 1
      end
    end
    if delegate != nil
      s1 = delegate.name
      s1 += "‚½‚¿" if count > 1
      change_flag = text.gsub!("–¡•û", s1)
      text.gsub!("brk", "\\n") if change_flag != nil and s1.size > 10 * 3
    end
    count = 0
    delegate = nil  
    for enemy in $game_troop.enemies
      if enemy.exist?
        delegate = enemy if delegate == nil
        count += 1
      end
    end
    if delegate != nil
      s2 = delegate.name
      s2 += "‚½‚¿" if count > 1
      change_flag = text.gsub!("‘Šè", s2)
      text.gsub!("brk", "\\n") if change_flag != nil and  s2.size > 10 * 3
    end
    text.gsub!("brk", "")
    return text
  end
end