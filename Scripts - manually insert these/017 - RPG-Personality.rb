#==============================================================================
# ¡ RPG::Personality
#------------------------------------------------------------------------------
# @«Ši‚Ìî•ñB$data_personality["–¼‘O"]‚©‚çQÆ‰Â”\B
#==============================================================================
module RPG
  #--------------------------------------------------------------------------
  # ¡ «Ši‚Ì“o˜^
  #--------------------------------------------------------------------------
  class Personality_registration
    #--------------------------------------------------------------------------
    # œ ŒöŠJƒCƒ“ƒXƒ^ƒ“ƒX•Ï”
    #--------------------------------------------------------------------------
    attr_accessor :id              # id
    attr_accessor :name            # –¼‘O
    attr_accessor :attack_regist   # U‚ß‚ÌƒŒƒWƒXƒg•â³
    attr_accessor :defense_regist  # ó‚¯‚ÌƒŒƒWƒXƒg•â³
    attr_accessor :talk_pattern    # D‚Ş‰ï˜b‚Ìí—Ş
    attr_accessor :talk_difficulty # ‰ï˜b“ïˆÕ“x
    attr_accessor :special_attack  # “ÁêUŒ‚‚Ìg—pŠJ•úğŒ
    
    # ƒf[ƒ^’Ç‹L
    
    #--------------------------------------------------------------------------
    # œ ƒIƒuƒWƒFƒNƒg‰Šú‰»
    #--------------------------------------------------------------------------
    def initialize(personality_id)
      @id = personality_id
      @name = ""
      @attack_regist = []
      @defense_regist = []
      #‰ï˜bƒ^ƒCƒv‚Å[—v‹]‚ğˆø‚¢‚½ê‡‚Ìƒ‰ƒ“ƒ_ƒ€‘I‘ğB
      #["DˆÓ","ˆ¤•","’EˆßE","’EˆßA","‹Š­","•òd","‹z¸","‘}“ü","Œ_–ñ"]
      #‘Î‰‚·‚é”’l‚ªŒ»İ‚Ì$mood.pointˆÈ‰º‚È‚ç‘I‘ğˆ‚É“ü‚é
      @talk_pattern = [0,0,0,0,0,0,0,0,0]
      #‰ï˜b“ïˆÕ“xF‚»‚Ì‰ï˜b‚É‘Î‚·‚é—v‹‚Ì“x‡‚¢‚ğ•\‚·
      #ƒŒƒWƒXƒgƒQ[ƒW‚Ì–îˆó”‚Æ‚È‚é
      #’l‚ª‘å‚«‚¢‚Ù‚Ç‚»‚Ì‰ï˜b‚ª‘I‚Î‚ê‚½Û‚É’f‚è‚Ã‚ç‚­‚È‚é
      @talk_difficulty = [3,3,3,3,3,3,3,3,3]
      #ƒz[ƒ‹ƒh‚â“ÁêUŒ‚‚ğs‚¤ƒXƒCƒbƒ`
      #‚P`‚R’iŠK‚ ‚èA‹K’è”‚Éƒ€[ƒh’l‚ª’B‚·‚é‚Æg—p‚·‚é‚æ‚¤‚É‚È‚é
      @special_attack = [20,40,60]
      setup(personality_id)
    end
    #--------------------------------------------------------------------------
    # œ ƒZƒbƒgƒAƒbƒv
    #--------------------------------------------------------------------------
    def setup(personality_id)
      case personality_id
      when 0
        @name = "DF"
        @attack_regist = [2, 2, 3, 3, 4]
        @defense_regist = [0, 0, -1, -2, -3]
        #["DˆÓ","ˆ¤•","’EˆßE","’EˆßA","‹Š­","•òd","‹z¸","‘}“ü","Œ_–ñ"]
        @talk_pattern = [0, 0, 20, 20, 30, 20, 40, 60, 100]
        @talk_difficulty = [3, 4, 4, 4, 4, 3, 4, 6, 3]
        @special_attack = [15,30,45]
      when 1
        @name = "ã•i"
        @attack_regist = [0, 1, 1, 1, 2]
        @defense_regist = [2, 2, 1, 1, 0]
        #["DˆÓ","ˆ¤•","’EˆßE","’EˆßA","‹Š­","•òd","‹z¸","‘}“ü","Œ_–ñ"]
        @talk_pattern = [0, 0, 40, 40, 50, 30, 50, 70, 100]
        @talk_difficulty = [3, 4, 4, 4, 4, 3, 4, 6, 3]
        @special_attack = [25,45,65]
      when 2
        @name = "‚–"
        @attack_regist = [2, 2, 1, 1, 0]
        @defense_regist = [3, 2, 1, 0, -1]
        #["DˆÓ","ˆ¤•","’EˆßE","’EˆßA","‹Š­","•òd","‹z¸","‘}“ü","Œ_–ñ"]
        @talk_pattern = [0, 0, 10, 10, 20, 10, 40, 50, 100]
        @talk_difficulty = [3, 4, 4, 4, 4, 3, 4, 6, 3]
        @special_attack = [30,50,70]
      when 3
        @name = "’W”‘"
        @attack_regist = [0, 0, 0, 0, 1]
        @defense_regist = [0, 0, 0, 0, -1]
        #["DˆÓ","ˆ¤•","’EˆßE","’EˆßA","‹Š­","•òd","‹z¸","‘}“ü","Œ_–ñ"]
        @talk_pattern = [0, 0, 30, 30, 60, 40, 40, 70, 100]
        @talk_difficulty = [3, 4, 4, 4, 4, 3, 4, 6, 3]
        @special_attack = [30,50,70]
      when 4
        @name = "_˜a"
        @attack_regist = [0, 0, 0, 1, 3]
        @defense_regist = [-1, -1, -1, 0, 0]
        #["DˆÓ","ˆ¤•","’EˆßE","’EˆßA","‹Š­","•òd","‹z¸","‘}“ü","Œ_–ñ"]
        @talk_pattern = [0, 0, 10, 20, 30, 40, 40, 60, 100]
        @talk_difficulty = [3, 4, 4, 4, 4, 3, 4, 6, 3]
        @special_attack = [25,45,65]
      when 5
        @name = "Ÿ‚¿‹C"
        @attack_regist = [1, 1, 2, 2, 3]
        @defense_regist = [1, 1, 1, 0, -1]
        #["DˆÓ","ˆ¤•","’EˆßE","’EˆßA","‹Š­","•òd","‹z¸","‘}“ü","Œ_–ñ"]
        @talk_pattern = [0, 0, 40, 20, 30, 30, 40, 60, 100]
        @talk_difficulty = [3, 4, 4, 4, 4, 3, 4, 6, 3]
        @special_attack = [20,40,60]
      when 6
        @name = "“à‹C"
        @attack_regist = [-2, -2, -1, 0, 1]
        @defense_regist = [4, 3, 1, -1, -3]
        #["DˆÓ","ˆ¤•","’EˆßE","’EˆßA","‹Š­","•òd","‹z¸","‘}“ü","Œ_–ñ"]
        @talk_pattern = [0, 0, 50, 40, 60, 60, 60, 80, 100]
        @talk_difficulty = [3, 4, 4, 4, 4, 3, 4, 6, 3]
        @special_attack = [35,55,75]
      when 7
        @name = "—z‹C"
        @attack_regist = [1, 1, 1, 2, 2]
        @defense_regist = [0, 0, -1, -1, -2]
        #["DˆÓ","ˆ¤•","’EˆßE","’EˆßA","‹Š­","•òd","‹z¸","‘}“ü","Œ_–ñ"]
        @talk_pattern = [0, 0, 0, 0, 40, 30, 50, 70, 100]
        @talk_difficulty = [3, 4, 4, 4, 4, 3, 4, 6, 3]
        @special_attack = [20,40,60]
      when 8
        @name = "ˆÓ’nˆ«"
        @attack_regist = [0, 1, 1, 2, 3]
        @defense_regist = [2, 1, 0, -1, -2]
        #["DˆÓ","ˆ¤•","’EˆßE","’EˆßA","‹Š­","•òd","‹z¸","‘}“ü","Œ_–ñ"]
        @talk_pattern = [0, 0, 30, 0, 10, 10, 30, 50, 100]
        @talk_difficulty = [3, 4, 4, 4, 4, 3, 4, 6, 3]
        @special_attack = [25,45,65]
      when 9
        @name = "“V‘R"
        @attack_regist = [-1, -1, 0, 1, 2]
        @defense_regist = [0, 0, -1, -1, -2]
        #["DˆÓ","ˆ¤•","’EˆßE","’EˆßA","‹Š­","•òd","‹z¸","‘}“ü","Œ_–ñ"]
        @talk_pattern = [0, 0, 20, 20, 70, 50, 30, 70, 100]
        @talk_difficulty = [3, 4, 4, 4, 4, 3, 4, 6, 3]
        @special_attack = [20,40,60]
      when 10
        @name = "]‡"
        @attack_regist = [-1, -1, -1, 0, 1]
        @defense_regist = [-2, -2, -2, -3, -3]
        #["DˆÓ","ˆ¤•","’EˆßE","’EˆßA","‹Š­","•òd","‹z¸","‘}“ü","Œ_–ñ"]
        @talk_pattern = [0, 0, 60, 60, 60, 60, 40, 60, 100]
        @talk_difficulty = [3, 4, 4, 4, 4, 3, 4, 6, 3]
        @special_attack = [15,30,45]
      when 11
        @name = "‹•¨"
        @attack_regist = [3, 1, 0, -1, -2]
        @defense_regist = [3, 1, 0, -1, -2]
        #["DˆÓ","ˆ¤•","’EˆßE","’EˆßA","‹Š­","•òd","‹z¸","‘}“ü","Œ_–ñ"]
        @talk_pattern = [0, 0, 10, 30, 30, 30, 40, 60, 100]
        @talk_difficulty = [3, 4, 4, 4, 4, 3, 4, 6, 3]
        @special_attack = [20,45,70]
      when 12
        @name = "“|ö"
        @attack_regist = [2, 3, 3, 4, 4]
        @defense_regist = [-1, -2, -3, -4, -5]
        #["DˆÓ","ˆ¤•","’EˆßE","’EˆßA","‹Š­","•òd","‹z¸","‘}“ü","Œ_–ñ"]
        @talk_pattern = [0, 0, 0, 0, 0, 0, 50, 20, 100]
        @talk_difficulty = [3, 4, 4, 4, 4, 3, 4, 6, 3]
        @special_attack = [10,25,40]
      when 13
        @name = "ŠÃ‚¦«"
        @attack_regist = [-1, 2, 3, 3, 3]
        @defense_regist = [0, 0, 0, -1, -1]
        #["DˆÓ","ˆ¤•","’EˆßE","’EˆßA","‹Š­","•òd","‹z¸","‘}“ü","Œ_–ñ"]
        @talk_pattern = [0, 0, 20, 20, 40, 0, 50, 20, 100]
        @talk_difficulty = [3, 4, 4, 4, 4, 3, 4, 6, 3]
        @special_attack = [20,40,60]
      when 14
        @name = "•sv‹c"
        @attack_regist = [2, -3, 3, -4, 4]
        @defense_regist = [-2, 3, -3, 4, -4]
        #["DˆÓ","ˆ¤•","’EˆßE","’EˆßA","‹Š­","•òd","‹z¸","‘}“ü","Œ_–ñ"]
        @talk_pattern = [0, 0, 0, 0, 0, 0, 0, 0, 50]
        @talk_difficulty = [3, 4, 4, 4, 4, 3, 4, 6, 3]
        @special_attack = [10,20,30]
      when 15
        @name = "^–Ê–Ú"
        @attack_regist = [0, 1, 1, 2, 2]
        @defense_regist = [1, 1, 1, 0, 0]
        #["DˆÓ","ˆ¤•","’EˆßE","’EˆßA","‹Š­","•òd","‹z¸","‘}“ü","Œ_–ñ"]
        @talk_pattern = [0, 0, 20, 20, 30, 20, 40, 60, 100]
        @talk_difficulty = [3, 4, 4, 4, 4, 3, 4, 6, 3]
        @special_attack = [20,40,60]
      when 16
        @name = "˜r”’"
        @attack_regist = [1, 2, 2, 3, 4]
        @defense_regist = [0, 0, 0, -1, -1]
        #["DˆÓ","ˆ¤•","’EˆßE","’EˆßA","‹Š­","•òd","‹z¸","‘}“ü","Œ_–ñ"]
        @talk_pattern = [0, 0, 20, 20, 30, 20, 40, 60, 100]
        @talk_difficulty = [3, 4, 4, 4, 4, 3, 4, 6, 3]
        @special_attack = [20,40,60]
      when 17
        @name = "—âÃ"
        @attack_regist = [0, 0, 0, 1, 1]
        @defense_regist = [2, 2, 3, 3, 4]
        #["DˆÓ","ˆ¤•","’EˆßE","’EˆßA","‹Š­","•òd","‹z¸","‘}“ü","Œ_–ñ"]
        @talk_pattern = [0, 0, 20, 20, 30, 20, 40, 60, 100]
        @talk_difficulty = [3, 4, 4, 4, 4, 3, 4, 6, 3]
        @special_attack = [20,40,60]
      when 18
        @name = "“Æ‘P" # ¥ƒtƒ‹ƒrƒ…ƒA‚Ì«Ši
        @attack_regist = [2, 3, 3, 4, 4]
        @defense_regist = [3, 1, -2, -3, -3]
        #["DˆÓ","ˆ¤•","’EˆßE","’EˆßA","‹Š­","•òd","‹z¸","‘}“ü","Œ_–ñ"]
        @talk_pattern = [0, 0, 0, 0, 0, 0, 20, 50, 255]
        @talk_difficulty = [3, 4, 4, 4, 4, 3, 4, 6, 3]
        @special_attack = [20,40,60]
      when 19
        @name = "‹Cä" # ¥ƒŠƒWƒFƒI‚Ì«Ši@Ÿ‚¿‹Cƒx[ƒX
        @attack_regist = [1, 1, 2, 2, 3]
        @defense_regist = [1, 1, 1, 0, -1]
        #["DˆÓ","ˆ¤•","’EˆßE","’EˆßA","‹Š­","•òd","‹z¸","‘}“ü","Œ_–ñ"]
        @talk_pattern = [0, 0, 40, 20, 30, 30, 40, 60, 100]
        @talk_difficulty = [3, 4, 4, 4, 4, 3, 4, 6, 3]
        @special_attack = [20,40,60]
      when 20
        @name = "’¨‹C" # ¥ƒlƒCƒWƒ…ƒŒƒ“ƒW‚Ì«Ši@_˜aƒx[ƒX
        @attack_regist = [0, 0, 0, 1, 3]
        @defense_regist = [-1, -1, -1, 0, 0]
        #["DˆÓ","ˆ¤•","’EˆßE","’EˆßA","‹Š­","•òd","‹z¸","‘}“ü","Œ_–ñ"]
        @talk_pattern = [0, 0, 10, 20, 30, 40, 40, 60, 100]
        @talk_difficulty = [3, 4, 4, 4, 4, 3, 4, 6, 3]
        @special_attack = [25,45,65]
      when 21
        @name = "‰A‹C" # ¥ƒ†[ƒKƒmƒbƒg‚Ì«Ši@“V‘Rƒx[ƒX
        @attack_regist = [-1, -1, 0, 1, 2]
        @defense_regist = [0, 0, -1, -1, -2]
        #["DˆÓ","ˆ¤•","’EˆßE","’EˆßA","‹Š­","•òd","‹z¸","‘}“ü","Œ_–ñ"]
        @talk_pattern = [0, 0, 20, 20, 70, 50, 30, 70, 100]
        @talk_difficulty = [3, 4, 4, 4, 4, 3, 4, 6, 3]
        @special_attack = [20,40,60]
      when 22
        @name = "‘¸‘å" # ¥ƒMƒ‹ƒS[ƒ“‚Ì«Ši@‹•¨ƒx[ƒX
        @attack_regist = [3, 1, 0, -1, -2]
        @defense_regist = [3, 1, 0, -1, -2]
        #["DˆÓ","ˆ¤•","’EˆßE","’EˆßA","‹Š­","•òd","‹z¸","‘}“ü","Œ_–ñ"]
        @talk_pattern = [0, 0, 10, 30, 30, 30, 40, 60, 100]
        @talk_difficulty = [3, 4, 4, 4, 4, 3, 4, 6, 3]
        @special_attack = [20,45,70]
      when 23
        @name = "‚‹M" # ¥ƒVƒ‹ƒtƒF‚Ì«Ši@ã•iƒx[ƒX
        @attack_regist = [0, 1, 1, 1, 2]
        @defense_regist = [2, 2, 1, 1, 0]
        #["DˆÓ","ˆ¤•","’EˆßE","’EˆßA","‹Š­","•òd","‹z¸","‘}“ü","Œ_–ñ"]
        @talk_pattern = [0, 0, 40, 40, 50, 30, 50, 70, 100]
        @talk_difficulty = [3, 4, 4, 4, 4, 3, 4, 6, 3]
        @special_attack = [25,45,65]
      when 24
        @name = "Œ‰•È" # ¥ƒ‰[ƒ~ƒ‹‚Ì«Ši@^–Ê–Úƒx[ƒX
        @attack_regist = [0, 1, 1, 2, 2]
        @defense_regist = [1, 1, 1, 0, 0]
        #["DˆÓ","ˆ¤•","’EˆßE","’EˆßA","‹Š­","•òd","‹z¸","‘}“ü","Œ_–ñ"]
        @talk_pattern = [0, 0, 20, 20, 30, 20, 40, 60, 100]
        @talk_difficulty = [3, 4, 4, 4, 4, 3, 4, 6, 3]
        @special_attack = [20,40,60]
      when 25
        @name = "˜Iˆ«‹¶" # ¥ƒ”ƒFƒ‹ƒ~ƒB[ƒi‚Ì«Ši@“|öƒx[ƒX
        @attack_regist = [2, 3, 3, 4, 4]
        @defense_regist = [-1, -2, -3, -4, -5]
        #["DˆÓ","ˆ¤•","’EˆßE","’EˆßA","‹Š­","•òd","‹z¸","‘}“ü","Œ_–ñ"]
        @talk_pattern = [0, 0, 0, 0, 0, 0, 50, 20, 100]
        @talk_difficulty = [3, 4, 4, 4, 4, 3, 4, 6, 3]
        @special_attack = [10,25,40]
      else
        @name = "–¢İ’è"
        @attack_regist = [0, 0, 0, 1, 1]
        @defense_regist = [2, 2, 3, 3, 4]
        #["DˆÓ","ˆ¤•","’EˆßE","’EˆßA","‹Š­","•òd","‹z¸","‘}“ü","Œ_–ñ"]
        @talk_pattern = [0, 0, 20, 20, 30, 20, 40, 60, 100]
        @talk_difficulty = [3, 4, 4, 4, 4, 3, 4, 6, 3]
        @special_attack = [20,40,60]
      end
    end
  end
  #--------------------------------------------------------------------------
  # ¡ ‘f¿î•ñ‚Ü‚Æ‚ß
  #--------------------------------------------------------------------------
  class Personality
    #--------------------------------------------------------------------------
    # œ ŒöŠJƒCƒ“ƒXƒ^ƒ“ƒX•Ï”
    #--------------------------------------------------------------------------
    attr_accessor :data
    #--------------------------------------------------------------------------
    # œ ƒIƒuƒWƒFƒNƒg‰Šú‰»
    #--------------------------------------------------------------------------
    def initialize
      @data = []
      @max = 50 #«Ši‚Ì“o˜^”ãŒÀ
      for i in 0..@max
        @data[i] = Personality_registration.new(i)
      end
    end
    #--------------------------------------------------------------------------
    # œ «Ši‚Ìæ“¾
    # personality_name : «Ši–¼(id‚ğ“ü‚ê‚Ä‚à‘Î‰‰Â”\)
    #--------------------------------------------------------------------------
    def [](personality_name)
      # •¶š—ñˆÈŠO‚Ìê‡‚ªˆø”‚Ìê‡
      unless personality_name.is_a?(String)
        return @data[personality_name]
      end
      # ˆÈ‰ºA•¶š—ñŒŸõ
      for data in @data
        if data.name == personality_name
          return data
        end
      end
      # “o˜^‚³‚ê‚½–¼‘O‚ª–³‚¢ê‡
      return @data[0]
    end
    #--------------------------------------------------------------------------
    # œ «Šiid‚ÌŒŸõ
    #    type : ŒŸõw’è   variable : ŒŸõŒê
    #--------------------------------------------------------------------------
    def search(type, variable)
      case type
      when 0 # –¼‘O‚Å‚h‚c‚ğŒŸõ‚·‚é
        for data in @data
          if data.name == variable
            n = data.id
            break
          end
        end
      end
      return n
    end
  end
end