#==============================================================================
# ¡ Talk_Sys(•ªŠ„’è‹` 2)
#------------------------------------------------------------------------------
#   –²–‚‚ÌŒûã‚ğŒŸõA•\¦‚·‚é‚½‚ß‚ÌƒNƒ‰ƒX‚Å‚·B
#   ‚±‚ÌƒNƒ‰ƒX‚ÌƒCƒ“ƒXƒ^ƒ“ƒX‚Í $msg ‚ÅQÆ‚³‚ê‚Ü‚·B
#   ‚±‚±‚Å‚Í‰ï˜b‚ğs‚¤ƒLƒƒƒ‰ƒNƒ^[‚Ì‘I’èAƒXƒLƒ‹wƒg[ƒNx‚Ì§Œä‚ğs‚¢‚Ü‚·B
#==============================================================================
class Talk_Sys
  #============================================================================
  # œƒRƒ}ƒ“ƒh‘I‘ğˆ¦—v‹ƒpƒ^[ƒ“‚ğˆø‚«“–‚Ä‚½‚És‚¤ƒ‹[ƒŒƒbƒg
  #============================================================================
  def talk_choice
    $msg.tag = $msg.at_type = $msg.at_parts = ""
    @talk_command_type = ""
    #ƒz[ƒ‹ƒh’†‰ï˜bƒtƒ‰ƒO‚ğƒNƒŠƒA
    holding_talk = false
    #ƒGƒ“ƒuƒŒƒCƒX‘Šè‚Ìb’èˆ—
    # if #$msg.t_enemy.bind? or $msg.t_enemy.riding? 
    # ƒCƒ“ƒT[ƒgˆÈŠO‚Ìƒz[ƒ‹ƒh‚ğó‚¯‚Ä‚¢‚é‘Šè‚Í•s¬—§‚É‚È‚é
    if $msg.t_enemy.can_struggle? or $msg.t_enemy.shellmatch? 
      $msg.tag = "•s¬—§"
      $msg.at_type = "–²–‚œ’›’†"
      return
    end
    #ƒxƒbƒhƒCƒ“ˆÈŠO‚ÅA‰ï˜bƒtƒ‰ƒO‚ªˆê’è”ˆÈã‚Ìê‡‘Å‚¿Ø‚ç‚ê‚é(‚½‚¾‚µƒz[ƒ‹ƒh’†‚Íœ‚­)
    if $game_switches[85] == false and $msg.t_enemy.pillowtalk > 4
      #ålŒö‚ª‰ï˜b‘ÎÛ‚Æƒz[ƒ‹ƒh’†‚Ìê‡‚ÍŒp‘±
      if $game_actors[101].holding_now?
        holding_talk = true
      #ƒz[ƒ‹ƒh’†‚Å‚È‚¯‚ê‚Î‰ï˜b•s‰Â
      else
        $msg.tag = "•s¬—§"
        $msg.at_type = "s‰ß‘½"
        return
      end
    #ålŒö‚ªƒNƒ‰ƒCƒVƒX‚Ìê‡
    elsif $game_actors[101].crisis?
      #ålŒö‚ª‰ï˜b‘ÎÛ‚Æƒz[ƒ‹ƒh’†‚Ìê‡‚ÍŒp‘±
      if $game_actors[101].holding_now?
        holding_talk = true
      #ƒz[ƒ‹ƒh’†‚Å‚È‚¯‚ê‚Î‰ï˜b•s‰Â
      else
#        unless $msg.t_enemy.friendly > 70
          $msg.tag = "•s¬—§"
          $msg.at_type = "ålŒöƒNƒ‰ƒCƒVƒX"
          return
#        else
          #¥Œğ‡‚Í—¼Ò’Eˆßó‘ÔA‚©‚Â—¼Ò”ñƒz[ƒ‹ƒh‚Å‚È‚¢‚Æ”­¶‚µ‚È‚¢
#          if $game_actors[101].insertable_half_nude? or $game_actors[101].full_nude?
#            if not $game_actors[101].holding? and not $msg.t_enemy.holding? #ƒz[ƒ‹ƒh’†‚Í‘I‘ğˆ‚©‚çœŠO
#              $msg.tag = "Œğ‡" if ($msg.t_enemy.friendly > 70 or $game_switches[85] == true)
#              b = []
#              b.push("Š‘}“ü") if $msg.t_enemy.insertable_half_nude? or $msg.t_enemy.full_nude?
#              if b == []
#                $msg.tag = "•s¬—§"
#                $msg.at_type = "ålŒöƒNƒ‰ƒCƒVƒX"
#                return
#              end
#              $msg.at_parts = b[rand(b.size)]
#              @talk_command_type = "¬”Ûƒ^ƒCƒv"
#              return
#            end
#          end
#        end
      end
    #‰ï˜b‘ÎÛ‚ªƒNƒ‰ƒCƒVƒX‚Ìê‡
    elsif $msg.t_enemy.crisis?
      #ålŒö‚ª‰ï˜b‘ÎÛ‚Æƒz[ƒ‹ƒh’†‚Ìê‡‚ÍŒp‘±
      if $game_actors[101].holding_now?
        holding_talk = true
      #ƒz[ƒ‹ƒh’†‚Å‚È‚¯‚ê‚Î‰ï˜b•s‰Â
      else
        $msg.tag = "•s¬—§"
        $msg.at_type = "–²–‚ƒNƒ‰ƒCƒVƒX"
        return
      end
    #‰ï˜b‘ÎÛ‚ªâ’¸’†‚Ìê‡
    elsif $msg.t_enemy.weaken?
      $msg.tag = "•s¬—§"
      $msg.at_type = "–²–‚â’¸’†"
      return
    #‰ï˜b‘ÎÛ‚ªœ’›ó‘Ô(34)‚Ìê‡
    elsif $msg.t_enemy.states.include?(34)
      $msg.tag = "•s¬—§"
      $msg.at_type = "–²–‚œ’›’†"
      return
    #‰ï˜b‘ÎÛ‚ª–\‘–ó‘Ô(36)‚Ìê‡i–{‹Có‘Ô‚ÌÛ‚à‚±‚ê‚É‚È‚éj
    elsif $msg.t_enemy.states.include?(36) or $msg.t_enemy.earnest == true
      $msg.tag = "•s¬—§"
      $msg.at_type = "–²–‚–\‘–’†"
      return
    #ã‹L‚¢‚¸‚ê‚Å‚à‚È‚¢ó‘Ô‚ÅålŒö‚ªƒz[ƒ‹ƒhA‚©‚Â‰ï˜b‘ÎÛ‚Æƒz[ƒ‹ƒh’†‚Ìê‡
    elsif $game_actors[101].holding_now?
      holding_talk = true
    end
    #œ‚±‚±‚©‚çƒg[ƒN¬—§‚Ì§Œä•”•ª
    #["ˆ¤•","ålŒö’Eˆß","’‡ŠÔ’Eˆß","–²–‚’Eˆß","•òd","‹Š­","‹z¸","Œğ‡","Œ_–ñ"]
    #‘OŒûãŒÄ‚Ño‚µ
    #ƒ€[ƒh‚ª‚Q‚OˆÈ‰º‚Ìê‡‚ÍƒRƒ‚ƒ“ƒCƒxƒ“ƒg‚Åƒg[ƒNI—¹ˆ—‚ğs‚¤
    if $msg.talk_step == 0
      $msg.tag = "‘OŒûã"
    #ƒXƒeƒbƒv‚PˆÈã‚È‚ç’Êíˆ—
    else
      #ƒz[ƒ‹ƒh‰ï˜bƒtƒ‰ƒO‚ª—§‚Á‚Ä‚¢‚éê‡‚Íê—pƒ^ƒO‚É‚·‚é
      if holding_talk == true and not bitter_talk?($msg.t_enemy)
        $msg.tag = "ˆ¤•E«Œğ"
        $msg.at_type = "ƒz[ƒ‹ƒhUŒ‚"
        #‚Ï‚Ó‚Ï‚ÓAŠç–Ê‹RæAƒLƒbƒX‚Íƒg[ƒN‚»‚Ì‚à‚Ì‚ª••‚¶‚ç‚ê‚é‚½‚ßœŠO
        #UŒ‚è’i‚ğİ’è(•¡”ƒz[ƒ‹ƒh‚ª”­¶‚·‚éê‡‚Í‘Šè‚Æ‚Ì•¨‚Ì‚İ‚ğ‘I‘ğ)
        #¥ƒCƒ“ƒT[ƒgorƒAƒNƒZƒvƒg(Š‘}“üó‘Ô)
        if $game_actors[101].inserting_now?
          $msg.at_parts = "Š‘}“üFƒAƒ\ƒR‘¤"
        #¥ƒI[ƒ‰ƒ‹ƒCƒ“ƒT[ƒgorƒI[ƒ‰ƒ‹ƒAƒNƒZƒvƒg(Œû‘}“üó‘Ô)
        elsif $game_actors[101].oralsex_now?
          $msg.tag = "ˆ¤•E’Êí"
          $msg.at_parts = "Œû‘}“üFŒû‘¤"
        #¥ƒoƒbƒNƒCƒ“ƒT[ƒgorƒoƒbƒNƒAƒNƒZƒvƒg(K‘}“üó‘Ô)
        elsif $game_actors[101].analsex_now?
          $msg.tag = "ˆ¤•E’Êí"
          $msg.at_parts = "K‘}“üFK‘¤"
        #¥ƒGƒ“ƒuƒŒƒCƒX(–§’…ó‘Ô)
        elsif $msg.t_enemy.binding_now?
          $msg.tag = "ˆ¤•E’Êí"
          $msg.at_parts = "”w–ÊS‘©"
        #¥ƒyƒŠƒXƒR[ƒv(ƒpƒCƒYƒŠó‘Ô)
        elsif $msg.t_enemy.paizuri_now?
          $msg.tag = "ˆ¤•E’Êí"
          $msg.at_parts = "ƒpƒCƒYƒŠ"
        else
          $msg.tag = "ˆ¤•E’Êí"
        end
        @talk_command_type = "Œp‘±ƒ^ƒCƒv"
        return
      end
      return if $mood.point < 20 #ƒ€[ƒh‚Q‚OˆÈ‰º‚È‚ç‚±‚±‚Ü‚Å
      a = []
      #¥ålŒö‚ªƒz[ƒ‹ƒhó‘Ô‚¾‚Æ”­¶‚µ‚È‚¢‚à‚Ì‘½”
      unless $game_actors[101].holding?
        #¥ålŒö’Eˆß‚ÍŠù‚ÉålŒö‚ª’E‚¢‚Å‚¢‚é‚Æ”­¶‚µ‚È‚¢
        a.push("ålŒö’Eˆß") unless $game_actors[101].full_nude?
        # œ‚ƒ€[ƒhœ
        if $mood.point >= 40
          #¥•òd‚Í‘Šè‚ª’Eˆß‚Ì‚İA‚©‚Â”ñƒz[ƒ‹ƒh‚Å‚È‚¢‚Æ”­¶‚µ‚È‚¢
          a.push("•òd") if not $msg.t_enemy.holding? and $msg.t_enemy.full_nude?
          #¥‹z¸P‚ÍålŒö‚ÌVP‚ªˆê’èˆÈãA‚©‚ÂålŒö‚ª‘S—‡A”ñPƒz[ƒ‹ƒh‚Å‚È‚¢‚Æ”­¶‚µ‚È‚¢
          if $game_actors[101].spp > 10 and $game_switches[85] == false
            a.push("‹z¸E«Ší") if $game_actors[101].hold.penis.battler == nil and $game_actors[101].full_nude?
          end
          #¥Œğ‡‚Í—¼Ò’Eˆßó‘ÔA‚©‚Â—¼Ò”ñƒz[ƒ‹ƒh‚Å‚È‚¢‚Æ”­¶‚µ‚È‚¢
          if $game_actors[101].insertable_half_nude? or $game_actors[101].full_nude?
            if not $game_actors[101].holding? and not $msg.t_enemy.holding? #ƒz[ƒ‹ƒh’†‚Í‘I‘ğˆ‚©‚çœŠO
              a.push("Œğ‡") if $msg.t_enemy.friendly > 70
            end
          end
        end
      end
      #¥‘Šè‚ªƒz[ƒ‹ƒhó‘Ô‚¾‚Æ”­¶‚µ‚È‚¢‚à‚Ì
      unless $msg.t_enemy.holding?
        #¥–²–‚’Eˆß‚ÍŠù‚É–²–‚‚ª’E‚¢‚Å‚¢‚éA‚à‚µ‚­‚Í–²–‚‚ªƒz[ƒ‹ƒh’†‚¾‚Æ”­¶‚µ‚È‚¢
        a.push("–²–‚’Eˆß") unless $msg.t_enemy.full_nude?
        #¥ˆ¤•‚ÍålŒö‚ª”ñPƒz[ƒ‹ƒhA‚©‚Â‘Šè‚ª”ñƒz[ƒ‹ƒh‚Å‚È‚¢‚Æ”­¶‚µ‚È‚¢
        if $game_actors[101].hold.penis.battler == nil
          a.push("ˆ¤•E’Êí") if $game_actors[101].nude?
        end
        #ƒ€[ƒh‚ŒÀ’è
        if $mood.point >= 40
          #¥‹Š­‚Í‘Šè‚ª‘S—‡‚Å‚È‚¢‚Æ”­¶‚µ‚È‚¢
          a.push("‹Š­") if $msg.t_enemy.full_nude?
          if $game_actors[101].spp > 10 and $game_switches[85] == false
            #¥‹z¸Œû‚ÍŒû‚ªÇ‚ª‚ê‚Ä‚¢‚é‚Æ”­¶‚µ‚È‚¢
            a.push("‹z¸EŒû") if $game_actors[101].hold.mouth.battler == nil
          end
        end
      end
#      a.push("Œ_–ñ") if $mood.point >= 100
      #œƒ‹[ƒŒƒbƒg(‘I‘ğˆ‚ª–³‚¢ê‡‚Ì‚İuDˆÓv‚ª‘I‚Î‚ê‚é)
      a.push("DˆÓ") if a == []
      
      #œDˆÓˆÈŠO‚Ì‘I‘ğˆ‚ğæ‚ç‚È‚¢–²–‚‚Ìê‡
      if bitter_talk?($msg.t_enemy)
        a = ["DˆÓ"] # DˆÓ‚Ì‚İ‚ğŠî€‚É‚·‚é
        # 50“‚Å•s¬—§‚É•ÏX
        if rand(100) < 50
          $msg.tag = "•s¬—§"
          $msg.at_type = "s‰ß‘½" 
          # ªƒ^ƒCƒv•ª‚¯‚·‚éê‡‚Í‚±‚±‚ğ•ÏX‚µ‚ÄŒûãrb‘¤‚É‰Á•M
          return
        end
      end
      
      $msg.tag = a[rand(a.size)]
      #ƒz[ƒ‹ƒh—v‹‚Ìê‡A‚Ç‚Ìƒz[ƒ‹ƒh‚ğs‚¤‚©‘I’è
      if $msg.tag == "Œğ‡"
        b = []
        b.push("Š‘}“ü") if $msg.t_enemy.insertable_half_nude? or $msg.t_enemy.full_nude?
#        b.push("Œû‘}“ü")
#        b.push("ƒLƒbƒX")
#        b.push("K‘}“ü") if $msg.t_enemy.insertable_half_nude? or $msg.t_enemy.full_nude?
#        b.push("ƒpƒCƒYƒŠ") if $msg.t_enemy.full_nude?
        if b == []
          $msg.tag = "DˆÓ"
          return
        end
        $msg.at_parts = b[rand(b.size)]
      end
      case $msg.tag
      when "ˆ¤•E’Êí","ˆ¤•E«Œğ","‹Š­","•òd"
        @talk_command_type = "Œp‘±ƒ^ƒCƒv"
      when "ålŒö’Eˆß","’‡ŠÔ’Eˆß","–²–‚’Eˆß","‹z¸EŒû","‹z¸E«Ší","Œğ‡"
        @talk_command_type = "¬”Ûƒ^ƒCƒv"
      end
    end
  end
  #============================================================================
  # œƒŒƒfƒB(ŒÂ•Êƒg[ƒN‚Ì–‘O€”õ‚ğo—Í‚·‚éˆ—)
  #============================================================================
  def talk_ready
    case $msg.tag
    when "ˆ¤•E’Êí","ˆ¤•E«Œğ","‹Š­","•òd"
      #UŒ‚ŒŸØƒŠƒZƒbƒg
      @befor_talk_action = []
      talk_attack_pattern
      make_text_pretalk
    else
      make_text_pretalk
    end
  end
  #============================================================================
  # œƒŠƒUƒ‹ƒg(ŒÂ•Êƒg[ƒN‚ÌŒ‹‰Ê‚ğo—Í‚·‚éˆ—)
  #============================================================================
  def talk_result
#    p "ƒ^ƒOF#{@tag}^•ª—ŞF#{@talk_command_type}"
    case $msg.tag
    when "ˆ¤•E’Êí","ˆ¤•E«Œğ","‹Š­","•òd"
      unless $msg.talk_step >= 77
        talk_critical
        make_text_aftertalk
        talk_damage
        talk_states_change
        #“Ç‚İ‚ñ‚¾ƒeƒLƒXƒg’·‚©‚çƒEƒFƒCƒg‚ğZo
        SR_Util.talk_log_wait_make
        #ƒAƒ^ƒbƒNƒpƒ^[ƒ“Ä“x“Ç‚İ‚İ
        talk_attack_pattern
        #’¼‘Os“®‚Æ‚Ì®‡«‚ğŒŸØ
        if @befor_talk_action[0] == @befor_talk_action[1]
          @chain_attack = true
        else
          @chain_attack = false
        end
        #æ“ª‚ğÁ‹
        a = @befor_talk_action[1]
        @befor_talk_action = []
        @befor_talk_action.push(a)
      end
    when "‹z¸EŒû","‹z¸E«Ší"
      unless $msg.talk_step >= 77
        make_text_aftertalk
        talk_damage
        talk_states_change
      end
    when "ålŒö’Eˆß","’‡ŠÔ’Eˆß","–²–‚’Eˆß","Œğ‡"
      make_text_aftertalk
      unless $msg.talk_step >= 77
        talk_states_change
      end
    when "DˆÓ","•s¬—§"
      make_text_aftertalk
    end
  end
  #============================================================================
  # œƒAƒ^ƒbƒNƒpƒ^[ƒ“(ˆ¤•‘I‘ğ‚És‚¤ƒ‹[ƒŒƒbƒgˆ—)
  #============================================================================
  def talk_attack_pattern
    if $msg.tag == "ˆ¤•E’Êí"
      #ƒ‹[ƒŒƒbƒgì¬
      pattern = ["è","è","è","Œû","Œû","Œû","‘«"]
      pattern.push("‹¹","‹¹","Š","Š") if $msg.t_enemy.full_nude?
      pattern.push("K”ö") if $data_SDB[$msg.t_enemy.class_id].tail == true
      #’‡ŠÔí‚âƒ`ƒFƒbƒNƒXƒLƒ‹‚ğg‚í‚ê‚½ê‡‚Í—\‚ßã“_‚ğ“Ë‚©‚ê‚â‚·‚­‚È‚é
      if $msg.t_enemy.checking == 1
        pattern.push("è","è","è","è","è") if $game_actors[101].have_ability?("èU‚ß‚Éã‚¢")
        pattern.push("Œû","Œû","Œû","Œû","Œû") if $game_actors[101].have_ability?("ŒûU‚ß‚Éã‚¢")
        pattern.push("‘«","‘«","‘«","‘«","‘«") if $game_actors[101].have_ability?("šn‹sU‚ß‚Éã‚¢")
        pattern.push("‹¹","‹¹","‹¹","‹¹","‹¹") if $game_actors[101].have_ability?("‹¹U‚ß‚Éã‚¢")
        pattern.push("Š","Š","Š","Š","Š") if $game_actors[101].have_ability?("—‰AU‚ß‚Éã‚¢")
        pattern.push("K”ö","K”ö","K”ö","K”ö","K”ö") if $game_actors[101].have_ability?("ˆÙŒ`U‚ß‚Éã‚¢")
      end
      #‚±‚êˆÈ~‚Íã“_‚ğ’m‚ç‚ê‚½ê‡‚É’Ç‰Á‚·‚é€–Ú
      if $msg.t_enemy.talk_weak_check.include?("è")
        pattern.push("è","è","è","è","è") 
        pattern.push("è","è","è","è","è","è","è","è","è","è") if $game_actors[101].have_ability?("èU‚ß‚Éã‚¢")
      end
      if $msg.t_enemy.talk_weak_check.include?("Œû")
        pattern.push("Œû","Œû","Œû","Œû","Œû") 
        pattern.push("Œû","Œû","Œû","Œû","Œû","Œû","Œû","Œû","Œû","Œû") if $game_actors[101].have_ability?("ŒûU‚ß‚Éã‚¢")
      end
      if $msg.t_enemy.talk_weak_check.include?("‘«")
        pattern.push("‘«","‘«","‘«","‘«","‘«","‘«","‘«") 
        pattern.push("‘«","‘«","‘«","‘«","‘«","‘«","‘«","‘«","‘«","‘«") if $game_actors[101].have_ability?("šn‹sU‚ß‚Éã‚¢")
      end
      if $msg.t_enemy.talk_weak_check.include?("‹¹")
        pattern.push("‹¹","‹¹","‹¹","‹¹","‹¹","‹¹") 
        pattern.push("‹¹","‹¹","‹¹","‹¹","‹¹","‹¹","‹¹","‹¹","‹¹","‹¹") if $game_actors[101].have_ability?("‹¹U‚ß‚Éã‚¢")
      end
      if $msg.t_enemy.talk_weak_check.include?("Š")
        pattern.push("Š","Š","Š","Š","Š","Š") 
        pattern.push("Š","Š","Š","Š","Š","Š","Š","Š","Š","Š") if $game_actors[101].have_ability?("—‰AU‚ß‚Éã‚¢")
      end
      if $msg.t_enemy.talk_weak_check.include?("K”ö")
        pattern.push("K”ö","K”ö","K”ö","K”ö","K”ö") 
        pattern.push("K”ö","K”ö","K”ö","K”ö","K”ö","K”ö","K”ö","K”ö","K”ö","K”ö") if $game_actors[101].have_ability?("ˆÙŒ`U‚ß‚Éã‚¢")
      end
      $msg.at_type = pattern[rand(pattern.size)]
      @befor_talk_action.push($msg.at_type)
    elsif $msg.tag == "•òd" or $msg.tag == "‹Š­"
      #ƒ‹[ƒŒƒbƒgì¬
      pattern = ["Œû","‹¹","K","ƒAƒ\ƒR"]
      pattern.push("‰AŠj","ƒAƒiƒ‹") if $msg.t_enemy.full_nude?
      #’‡ŠÔí‚âƒ`ƒFƒbƒNƒXƒLƒ‹‚ğg‚Á‚½ê‡‚Íã“_‚ğ“Ë‚«‚â‚·‚­‚È‚é
      if $msg.t_enemy.checking == 1
        pattern.push("Œû","Œû","Œû","Œû","Œû") if $msg.t_enemy.have_ability?("Œû‚ª«Š´‘Ñ") or $msg.t_enemy.have_ability?("ˆúO")
        pattern.push("‹¹","‹¹","‹¹","‹¹","‹¹") if $msg.t_enemy.have_ability?("‹¹‚ª«Š´‘Ñ") or $msg.t_enemy.have_ability?("ˆú“û")
        pattern.push("K","K","K","K","K") if $msg.t_enemy.have_ability?("‚¨K‚ª«Š´‘Ñ") or $msg.t_enemy.have_ability?("ˆúK")
        pattern.push("ƒAƒ\ƒR","ƒAƒ\ƒR","ƒAƒ\ƒR","ƒAƒ\ƒR","ƒAƒ\ƒR") if $msg.t_enemy.have_ability?("—‰A‚ª«Š´‘Ñ") or $msg.t_enemy.have_ability?("ˆúšâ")
        pattern.push("‰AŠj","‰AŠj","‰AŠj","‰AŠj","‰AŠj") if $msg.t_enemy.have_ability?("‰AŠj‚ª«Š´‘Ñ") or $msg.t_enemy.have_ability?("ˆúŠj")
        pattern.push("ƒAƒiƒ‹","ƒAƒiƒ‹","ƒAƒiƒ‹","ƒAƒiƒ‹","ƒAƒiƒ‹") if $msg.t_enemy.have_ability?("‹eÀ‚ª«Š´‘Ñ") or $msg.t_enemy.have_ability?("ˆú‰Ô")
      end
      if $msg.t_enemy.talk_weak_check.include?("‘ÎÛFŒû")
        pattern.push("Œû","Œû","Œû","Œû","Œû") 
        pattern.push("Œû","Œû","Œû","Œû","Œû","Œû","Œû","Œû","Œû","Œû") if $msg.t_enemy.have_ability?("Œû‚ª«Š´‘Ñ") or $msg.t_enemy.have_ability?("ˆúO")
      end
      if $msg.t_enemy.talk_weak_check.include?("‘ÎÛF‹¹")
        pattern.push("‹¹","‹¹","‹¹","‹¹","‹¹") 
        pattern.push("‹¹","‹¹","‹¹","‹¹","‹¹","‹¹","‹¹","‹¹","‹¹","‹¹") if $msg.t_enemy.have_ability?("‹¹‚ª«Š´‘Ñ") or $msg.t_enemy.have_ability?("ˆú“û")
      end
      if $msg.t_enemy.talk_weak_check.include?("‘ÎÛFK")
        pattern.push("K","K","K","K","K") 
        pattern.push("K","K","K","K","K","K","K","K","K","K") if $msg.t_enemy.have_ability?("‚¨K‚ª«Š´‘Ñ") or $msg.t_enemy.have_ability?("ˆúK")
      end
      if $msg.t_enemy.talk_weak_check.include?("‘ÎÛFƒAƒ\ƒR")
        pattern.push("ƒAƒ\ƒR","ƒAƒ\ƒR","ƒAƒ\ƒR","ƒAƒ\ƒR","ƒAƒ\ƒR") 
        pattern.push("ƒAƒ\ƒR","ƒAƒ\ƒR","ƒAƒ\ƒR","ƒAƒ\ƒR","ƒAƒ\ƒR","ƒAƒ\ƒR","ƒAƒ\ƒR","ƒAƒ\ƒR","ƒAƒ\ƒR","ƒAƒ\ƒR") if $msg.t_enemy.have_ability?("—‰A‚ª«Š´‘Ñ") or $msg.t_enemy.have_ability?("ˆúšâ")
      end
      if $msg.t_enemy.talk_weak_check.include?("‘ÎÛF‰AŠj")
        pattern.push("‰AŠj","‰AŠj","‰AŠj","‰AŠj","‰AŠj") 
        pattern.push("‰AŠj","‰AŠj","‰AŠj","‰AŠj","‰AŠj","‰AŠj","‰AŠj","‰AŠj","‰AŠj","‰AŠj") if $msg.t_enemy.have_ability?("‰AŠj‚ª«Š´‘Ñ") or $msg.t_enemy.have_ability?("ˆúŠj")
      end
      if $msg.t_enemy.talk_weak_check.include?("‘ÎÛFƒAƒiƒ‹")
        pattern.push("ƒAƒiƒ‹","ƒAƒiƒ‹","ƒAƒiƒ‹","ƒAƒiƒ‹","ƒAƒiƒ‹") 
        pattern.push("ƒAƒiƒ‹","ƒAƒiƒ‹","ƒAƒiƒ‹","ƒAƒiƒ‹","ƒAƒiƒ‹","ƒAƒiƒ‹","ƒAƒiƒ‹","ƒAƒiƒ‹","ƒAƒiƒ‹","ƒAƒiƒ‹") if $msg.t_enemy.have_ability?("‹eÀ‚ª«Š´‘Ñ") or $msg.t_enemy.have_ability?("ˆú‰Ô")
      end
      $msg.at_parts = "‘ÎÛF" + pattern[rand(pattern.size)]
      @befor_talk_action.push($msg.at_parts)
    #’Êíˆ¤•‚Æ•òd‚Å–³‚¢ê‡‚Í–ß‚·
    else
      return
    end
  end
  #============================================================================
  # œƒNƒŠƒeƒBƒJƒ‹(ƒg[ƒN‚Éƒ_ƒ[ƒW‚ğZo‚·‚éÛ‚ÌƒNƒŠƒeƒBƒJƒ‹‚Ìˆ—)
  #   •K‚¸$msg.t_target‚ÍålŒö‚É‚È‚Á‚Ä‚¢‚é(‚Í‚¸)
  #============================================================================
  def talk_critical
    case $msg.tag
    when "•òd","‹Š­"
      damage_target = $msg.t_enemy
    else
      damage_target = $game_actors[101]
    end
    damage_target.critical = false
    #‘ÎÛ‚Ìã“_‚ğ—\‚ßƒT[ƒ`
    talk_weakpoint
    #«•È‚İ‚Ìã“_‚ğŠÅ”j‚³‚ê‚½ê‡
    case @weakpoints
    #«•È(«Š´‘Ñ)‚ğ“Ë‚¢‚½ê‡(‚·‚Å‚ÉŠÅ”jÏ‚İ)
    when 20
      perc = 60
    #«•È(«Š´‘Ñ)‚ğ“Ë‚¢‚½ê‡(”­Œ©‚³‚ê‚½)
    when 10
      perc = [($msg.talk_step * 3),30].min + 20
    #«•È(«Š´‘Ñ)‚ğU‚ß‚ç‚ê‚½ê‡
    when 2
      perc = [($msg.talk_step * 3),30].min + 10
    #’Êí
    else
      perc = [$msg.talk_step,10].min + 10
    end
    #œŠm—¦ŒvZ
    if perc > rand(100)
      damage_target.critical = true
    else
      damage_target.critical = false
    end
  end
  #============================================================================
  # œƒ_ƒ[ƒW(ƒg[ƒN‚Éˆ¤•“™‚ÅÀƒ_ƒ[ƒW‚ğZo‚·‚éÛ‚Ìˆ—)
  #   •K‚¸$msg.t_target‚ÍålŒö‚É‚È‚Á‚Ä‚¢‚é(‚Í‚¸)
  #============================================================================
  def talk_damage
    text = ""
    #ƒ_ƒ[ƒW‚ğ—^‚¦‚é‘ÎÛ‚ğƒ^ƒO‚²‚Æ‚É•ÏX
    if $msg.tag == "•òd"
      damage_target = $msg.t_enemy
      #ƒ_ƒ[ƒW‚ğZo
      base_dmg = [($game_actors[101].dex / 2).ceil, 40].min
      base_dmg += [[(($game_actors[101].level * 2) - damage_target.level),0].max,30].min
      base_dmg += rand(($mood.point / 5).round)
      base_dmg += rand($msg.talk_step * 3) if $msg.talk_step > 0
    elsif $msg.tag == "‹Š­"
      damage_target = $msg.t_enemy
      #ƒ_ƒ[ƒW‚ğZo
      base_dmg = [($msg.t_enemy.dex / 2).ceil, 40].min
      base_dmg += rand(($mood.point / 5).round)
      base_dmg += rand($msg.talk_step * 3) if $msg.talk_step > 0
    else
      damage_target = $game_actors[101]
      #ƒ_ƒ[ƒW‚ğZo
      base_dmg = [($msg.t_enemy.dex / 2).ceil, 80].min
      base_dmg += [(($msg.t_enemy.level * 2) - damage_target.level),0].max
      base_dmg += rand(($mood.point / 4).round)
      base_dmg += rand($msg.talk_step * 5) if $msg.talk_step > 0
    end
    #‚ ‚Ü‚è‚É’á‚·‚¬‚½‚çC³‚·‚é
    base_dmg = 20 + rand(10) - rand(5) if base_dmg <= 20
    #œSS”­¶‹y‚ÑƒAƒjƒ[ƒVƒ‡ƒ“‚Ìİ’è
    #‹Š­‚É‚ÍSS‚Í”­¶‚µ‚È‚¢
    case $msg.tag
    when "ˆ¤•E’Êí","ˆ¤•E«Œğ","•òd"
      #ƒNƒŠƒeƒBƒJƒ‹ˆ—
      if damage_target.critical == true
        text += "Sensual StrokeI\\"
        damage_target.animation_id = 103
        damage_target.animation_hit = true
        base_dmg = (base_dmg * 5 / 4).round
        #œˆ¤•A«Œğ‚Ìê‡‚Í“Ë‚¢‚½ã“_‚ğŠm•Û‚µ‚Ä‚¨‚­
        if $msg.tag == "ˆ¤•E’Êí"
          unless $msg.t_enemy.talk_weak_check.include?($msg.at_type)
            $msg.t_enemy.talk_weak_check.push($msg.at_type)
          end
        elsif $msg.tag == "ˆ¤•E«Œğ"
          unless $msg.t_enemy.talk_weak_check.include?($msg.at_type)
            $msg.t_enemy.talk_weak_check.push($msg.at_type)
          end
          @hold_initiative_refresh.push($msg.t_enemy,$game_actors[101])
        #œ•òd‚Ìê‡‚Í“Ë‚©‚ê‚½ã“_‚ğŠm•Û‚µ‚Ä‚¨‚­
        elsif $msg.tag == "•òd"
          unless $msg.t_enemy.talk_weak_check.include?($msg.at_parts)
            $msg.t_enemy.talk_weak_check.push($msg.at_parts)
          end
        end
      #ƒNƒŠƒeƒBƒJƒ‹‚Å–³‚¢ê‡‚ÍUŒ‚‚²‚Æ‚ÉƒAƒjƒ[ƒVƒ‡ƒ“‚ğ•\¦
      else
        if $msg.at_type == "K”ö"
          damage_target.animation_id = 46
        elsif $msg.tag == "ˆ¤•E«Œğ"
          damage_target.animation_id = 107
        else
          damage_target.animation_id = 45
        end
        damage_target.animation_hit = true
      end
    when "‹z¸EŒû","‹z¸E«Ší"
      damage_target.animation_id = 85
    when "‹Š­"
      damage_target.animation_id = 52
    end
    #ƒ_ƒ[ƒW’lC³(ˆ¤•‚ğ‚P‚Æ‚µ‚½ê‡)
    case $msg.tag
    when "ˆ¤•E«Œğ"
      unless $msg.at_parts == "”w–ÊS‘©"
        base_dmg = (base_dmg * 3 / 2).round
        if damage_target.shake_tate?
          # ‰æ–Ê‚ÌcƒVƒFƒCƒN
          $game_screen.start_flash(Color.new(255,210,225,220), 8)
          $game_screen.start_shake2(7, 15, 15)
        # ƒOƒ‰ƒCƒ“ƒhŒn
        elsif damage_target.shake_yoko?
          # ‰æ–Ê‚Ì‰¡ƒVƒFƒCƒN
          $game_screen.start_flash(Color.new(255,210,225,220), 8)
          $game_screen.start_shake(7, 15, 15)
        end
      else
        if damage_target.critical == true
          base_dmg = (base_dmg * 4 / 3).round
        else
          base_dmg = (base_dmg * 2 / 3).round
        end
      end
    when "•òd"
      base_dmg = (base_dmg * 2 / 3).round
    when "‹z¸EŒû","‹z¸E«Ší"
      #œVPŒ¸Š‚Í•ÊŒvZ®
      base_dmg = $msg.t_enemy.atk
      base_dmg += ($msg.t_enemy.level * 2) + rand($msg.t_enemy.level * 3)
      base_dmg += ($msg.t_enemy.str / 2).round if $msg.tag == "‹z¸E«Ší"
      base_dmg = ($game_actors[101].sp - 1) if base_dmg >= $game_actors[101].sp
      $msg.t_enemy.add_state(16) #‹z¸‚ÍƒXƒe[ƒg•Ï‰»‚ğ’Ê‚ç‚È‚¢‚Ì‚Å‚±‚±‚Ås“®•úŠü
    when "‹Š­"
      base_dmg = (base_dmg / 2).round
    end
    #ƒeƒLƒXƒg•â³Eƒ_ƒ[ƒW“K—p
    if $msg.tag == "‹z¸EŒû" or $msg.tag == "‹z¸E«Ší"
      text += "#{damage_target.name}‚Í¸‹C‚ğ #{base_dmg.to_s} ‹z‚¢æ‚ç‚ê‚½I"
      damage_target.sp -= base_dmg
    else
      if $msg.tag == "•òd"
        text += "#{$msg.t_enemy.name}‚É #{base_dmg.to_s} ‚Ì‰õŠ´‚ğ—^‚¦‚½I"
      elsif $msg.tag == "‹Š­"
        text += "#{$msg.t_enemy.name}‚Í #{base_dmg.to_s} ‚Ì‰õŠ´‚ğ“¾‚½I"
      else
        text += "#{$msg.t_target.name}‚Í #{base_dmg.to_s} ‚Ì‰õŠ´‚ğó‚¯‚½I"
      end
      t_hp = damage_target.hp - base_dmg
      if t_hp <= 0
        if $msg.tag == "•òd"
          $msg.talking_ecstasy_flag = "enemy"
        else
          p "ƒAƒNƒ^[" if $DEBUG
          $msg.talking_ecstasy_flag = "actor"
        end
        damage_target.add_state(11)
      end
      #ÀÛ‚Éƒ_ƒ[ƒW‚ğ“K—p‚·‚é
      damage_target.hp -= base_dmg
    end
    #ƒXƒe[ƒ^ƒXƒEƒBƒ“ƒhƒEXV
    @stateswindow_refresh = true
    if $game_temp.battle_log_text != ""
      $game_temp.battle_log_text += "\\" + text
    else
      $game_temp.battle_log_text += text
    end
    
    #damage_target.animation_id = 0
    
    
    
    # ‰æ‘œ•ÏX
    damage_target.graphic_change = true
  end
  #============================================================================
  # œƒg[ƒNã“_“Ë‚«ƒ`ƒFƒbƒN
  #============================================================================
  def talk_weakpoint
    @weakpoints = 0
    case $msg.at_type
    when "Œû"
      if $game_actors[101].have_ability?("ŒûU‚ß‚Éã‚¢")
        @weakpoints = 2
        @weakpoints = 20 if $msg.t_enemy.talk_weak_check.include?("Œû")
      else
        @weakpoints = 1
        @weakpoints = 10 if $msg.t_enemy.talk_weak_check.include?("Œû")
      end
    when "è"
      if $game_actors[101].have_ability?("èU‚ß‚Éã‚¢")
        @weakpoints = 2
        @weakpoints = 20 if $msg.t_enemy.talk_weak_check.include?("è")
      else
        @weakpoints = 1
        @weakpoints = 10 if $msg.t_enemy.talk_weak_check.include?("è")
      end
    when "‹¹"
      if $game_actors[101].have_ability?("‹¹U‚ß‚Éã‚¢")
        @weakpoints = 2
        @weakpoints = 20 if $msg.t_enemy.talk_weak_check.include?("‹¹")
      else
        @weakpoints = 1
        @weakpoints = 10 if $msg.t_enemy.talk_weak_check.include?("‹¹")
      end
    when "Š"
      if $game_actors[101].have_ability?("—‰AU‚ß‚Éã‚¢")
        @weakpoints = 2
        @weakpoints = 20 if $msg.t_enemy.talk_weak_check.include?("Š")
      else
        @weakpoints = 1
        @weakpoints = 10 if $msg.t_enemy.talk_weak_check.include?("Š")
      end
    when "‘«"
      if $game_actors[101].have_ability?("šn‹sU‚ß‚Éã‚¢")
        @weakpoints = 2
        @weakpoints = 20 if $msg.t_enemy.talk_weak_check.include?("‘«")
      else
        @weakpoints = 1
        @weakpoints = 10 if $msg.t_enemy.talk_weak_check.include?("‘«")
      end
    when "K”ö"
      if $game_actors[101].have_ability?("ˆÙŒ`U‚ß‚Éã‚¢")
        @weakpoints = 2
        @weakpoints = 20 if $msg.t_enemy.talk_weak_check.include?("K”ö")
      else
        @weakpoints = 1
        @weakpoints = 10 if $msg.t_enemy.talk_weak_check.include?("K”ö")
      end
    when "Š‘}“ü"
      if $game_actors[101].have_ability?("«Œğ‚Éã‚¢")
        @weakpoints = 2
        @weakpoints = 20 if $msg.t_enemy.talk_weak_check.include?("Š‘}“ü")
      else
        @weakpoints = 1
        @weakpoints = 10 if $msg.t_enemy.talk_weak_check.include?("Š‘}“ü")
      end
    when "Œû‘}“ü"
      if $game_actors[101].have_ability?("ŒûU‚ß‚Éã‚¢")
        @weakpoints = 2
        @weakpoints = 20 if $msg.t_enemy.talk_weak_check.include?("Œû‘}“ü")
      else
        @weakpoints = 1
        @weakpoints = 10 if $msg.t_enemy.talk_weak_check.include?("Œû‘}“ü")
      end
    when "K‘}“ü"
      if $game_actors[101].have_ability?("«Œğ‚Éã‚¢")
        @weakpoints = 2
        @weakpoints = 20 if $msg.t_enemy.talk_weak_check.include?("K‘}“ü")
      else
        @weakpoints = 1
        @weakpoints = 10 if $msg.t_enemy.talk_weak_check.include?("K‘}“ü")
      end
    when "ƒpƒCƒYƒŠ"
      if $game_actors[101].have_ability?("‹¹U‚ß‚Éã‚¢")
        @weakpoints = 2
        @weakpoints = 20 if $msg.t_enemy.talk_weak_check.include?("‹¹")
      else
        @weakpoints = 1
        @weakpoints = 10 if $msg.t_enemy.talk_weak_check.include?("‹¹")
      end
    end
    #‘Šè‚ª–²–‚‚Ìê‡AQÆ‚·‚é‘f¿‚ª•Ï‚í‚é
    case $msg.at_parts
    when "‘ÎÛFŒû"
      if $msg.t_enemy.have_ability?("Œû‚ª«Š´‘Ñ") or $msg.t_enemy.have_ability?("ˆúO")
        @weakpoints = 2
        @weakpoints = 20 if $msg.t_enemy.talk_weak_check.include?("‘ÎÛFŒû")
      else
        @weakpoints = 1
        @weakpoints = 10 if $msg.t_enemy.talk_weak_check.include?("‘ÎÛFŒû")
      end
    when "‘ÎÛF‹¹"
      if $msg.t_enemy.have_ability?("‹¹‚ª«Š´‘Ñ") or $msg.t_enemy.have_ability?("ˆú“û")
        @weakpoints = 2
        @weakpoints = 20 if $msg.t_enemy.talk_weak_check.include?("‘ÎÛF‹¹")
      else
        @weakpoints = 1
        @weakpoints = 10 if $msg.t_enemy.talk_weak_check.include?("‘ÎÛF‹¹")
      end
    when "‘ÎÛFK"
      if $msg.t_enemy.have_ability?("‚¨K‚ª«Š´‘Ñ") or $msg.t_enemy.have_ability?("ˆúK")
        @weakpoints = 2
        @weakpoints = 20 if $msg.t_enemy.talk_weak_check.include?("‘ÎÛFK")
      else
        @weakpoints = 1
        @weakpoints = 10 if $msg.t_enemy.talk_weak_check.include?("‘ÎÛFK")
      end
    when "‘ÎÛFƒAƒ\ƒR"
      if $msg.t_enemy.have_ability?("—‰A‚ª«Š´‘Ñ") or $msg.t_enemy.have_ability?("ˆúšâ")
        @weakpoints = 2
        @weakpoints = 20 if $msg.t_enemy.talk_weak_check.include?("‘ÎÛFƒAƒ\ƒR")
      else
        @weakpoints = 1
        @weakpoints = 10 if $msg.t_enemy.talk_weak_check.include?("‘ÎÛFƒAƒ\ƒR")
      end
    when "‘ÎÛF‰AŠj"
      if $msg.t_enemy.have_ability?("‰AŠj‚ª«Š´‘Ñ") or $msg.t_enemy.have_ability?("ˆúŠj")
        @weakpoints = 2
        @weakpoints = 20 if $msg.t_enemy.talk_weak_check.include?("‘ÎÛF‰AŠj")
      else
        @weakpoints = 1
        @weakpoints = 10 if $msg.t_enemy.talk_weak_check.include?("‘ÎÛF‰AŠj")
      end
    when "‘ÎÛFƒAƒiƒ‹"
      if $msg.t_enemy.have_ability?("‹eÀ‚ª«Š´‘Ñ") or $msg.t_enemy.have_ability?("ˆú‰Ô")
        @weakpoints = 2
        @weakpoints = 20 if $msg.t_enemy.talk_weak_check.include?("‘ÎÛFƒAƒiƒ‹")
      else
        @weakpoints = 1
        @weakpoints = 10 if $msg.t_enemy.talk_weak_check.include?("‘ÎÛFƒAƒiƒ‹")
      end
    end
  end
  #============================================================================
  # œƒXƒe[ƒg•ÏX(ŒÂ•Êƒg[ƒN‚ÌƒXƒe[ƒg•t—^“™‚ğŠÇ—)
  #============================================================================
  def talk_states_change
    text = ""
    case $msg.tag
    when "ˆ¤•E’Êí","ˆ¤•E«Œğ"
      if $game_actors[101].hpp < 20 and $game_actors[101].hp > 0
        unless $game_actors[101].states.include?(6)
          $game_actors[101].add_state(6)
          if $game_temp.battle_log_text != ""
            text = "\\" + $game_actors[101].bms_states_update
          else
            text = $game_actors[101].bms_states_update
          end
          $game_actors[101].graphic_change = true
          $msg.stateswindow_refresh = true
        end
      end
      $msg.t_enemy.add_state(16) #s“®•úŠü
    when "Œğ‡"
      case $msg.at_parts
      when "Š‘}“ü"
        # ƒAƒNƒZƒvƒg‚ğ’Ê‚·
        SR_Util.special_hold_make($data_skills[682], $msg.t_enemy, $game_actors[101])
=begin
        # ƒAƒNƒZƒvƒg‚ğ’Ê‚·
        $scene.hold_effect($data_skills[682], $msg.t_enemy, $game_actors[101])
        $msg.t_enemy.white_flash = true
        $msg.t_enemy.animation_id = 105
        $msg.t_enemy.animation_hit = true
        # ‰æ–Ê‚ÌcƒVƒFƒCƒN
        $game_screen.start_flash(Color.new(255,210,225,220), 8)
        $game_screen.start_shake2(7, 15, 15)

        #$msg.t_enemy.hold.vagina.set($game_actors[101], "ƒyƒjƒX", "Š‘}“ü", 3)
        #$game_actors[101].hold.penis.set($msg.t_enemy, "ƒAƒ\ƒR", "Š‘}“ü", 0)

        # ƒg[ƒN‘Šè‚ÉƒXƒ^ƒ“‚ğ‚©‚¯‚é
        $scene.battler_stan($msg.t_enemy)
=end
#      when "Œû‘}“ü"
#      when "K‘}“ü"
#      when "ƒpƒCƒYƒŠ"
#      when "ƒLƒbƒX"
      end
      @hold_pops_refresh = true
    when "ålŒö’Eˆß"
      $game_actors[101].undress
      if $game_temp.battle_log_text != ""
        text = "\\" + $game_actors[101].bms_states_update
      else
        text = $game_actors[101].bms_states_update
      end
      $game_actors[101].graphic_change = true
      $msg.stateswindow_refresh = true
      for enemy in $game_troop.enemies
        pc = [[($game_actors[101].str + 10 - enemy.int), 10].max, 40].min
        pc = [[($game_actors[101].dex + 10 - enemy.int), 10].max, 40].min if $msg.tag == "’‡ŠÔ’Eˆß"
        #—¦æ‚µ‚Ä‚â‚é‚Æ•t—^Šm—¦‚ªã‚ª‚é
        pc += 20 if $game_switches[89] == true
        if rand(100) < pc
          enemy.add_state(32) #ƒhƒLƒhƒL
          enemy.animation_id = 39
          if $game_temp.battle_log_text != ""
            text = "\\" + enemy.bms_states_update
          else
            text = enemy.bms_states_update
          end
        end
      end
    when "–²–‚’Eˆß"
      $msg.t_enemy.undress
      if $game_temp.battle_log_text != ""
        text = "\\" + $msg.t_enemy.bms_states_update
      else
        text = $msg.t_enemy.bms_states_update
      end
      $msg.t_enemy.graphic_change = true
      $msg.stateswindow_refresh = true
      #ålŒö‚Ì‚İƒhƒLƒhƒL‚Ì‰Â”\«A‚»‚µ‚Ä‚â‚â‚‚¢
      pc = [[($msg.t_enemy.str + 20 - $game_actors[101].int), 20].max, 50].min
      #i‚ñ‚ÅŒ©‚é‚Æ‚æ‚èŠm—¦‚‚¢
      pc += 30 if $game_switches[89] == true
      if rand(100) < pc
        $game_actors[101].add_state(32) #ƒhƒLƒhƒL
        $game_actors[101].animation_id = 39
        if $game_temp.battle_log_text != ""
          text = "\\" + $game_actors[101].bms_states_update
        else
          text = $game_actors[101].bms_states_update
        end
      end
      $msg.t_enemy.add_state(16) #s“®•úŠü
    when "•òd"
      if ($msg.t_enemy.hpp < $mood.crisis_point(self) + rand(5)) and $msg.t_enemy.hp > 0
        unless $msg.t_enemy.states.include?(6)
          $msg.t_enemy.add_state(6)
          if $game_temp.battle_log_text != ""
            text = "\\" + $msg.t_enemy.bms_states_update
          else
            text = $msg.t_enemy.bms_states_update
          end
          $msg.t_enemy.graphic_change = true
          $msg.stateswindow_refresh = true
        end
      end
      case $msg.talk_step
      when 2
        $game_actors[101].add_state(32) #ƒhƒLƒhƒL
        text += "\\" + $game_actors[101].bms_states_update
        $msg.t_enemy.add_state(16) #s“®•úŠü
      when 3..99
        plus = ($msg.talk_step * 5)
        perc = $game_actors[101].int
        perc /= 3 if $game_switches[89] == true #’ïR‚µ‚È‚¢‚Æ•t—^—¦‚‚­‚È‚é
        if $game_actors[101].state?(40)
          if rand($mood.point) + plus > [perc,60].min
            $game_actors[101].add_state(36) #–\‘–
            text += "\\" + $game_actors[101].bms_states_update
          end
        elsif $game_actors[101].state?(35)
          if rand($mood.point) + plus > [perc,45].min
            $game_actors[101].add_state(40) #U–Ÿ
            text += "\\" + $game_actors[101].bms_states_update
          end
        else
          if rand($mood.point) + plus > [perc,30].min
            $game_actors[101].add_state(35) #—~î
            text += "\\" + $game_actors[101].bms_states_update
          end
        end
      end
    when "‹Š­"
      if ($msg.t_enemy.hpp < $mood.crisis_point(self) + rand(5)) and $msg.t_enemy.hp > 0
        unless $msg.t_enemy.states.include?(6)
          $msg.t_enemy.add_state(6)
          if $game_temp.battle_log_text != ""
            text = "\\" + $msg.t_enemy.bms_states_update
          else
            text = $msg.t_enemy.bms_states_update
          end
          $msg.t_enemy.graphic_change = true
          $msg.stateswindow_refresh = true
        end
      end
      case $msg.talk_step
      when 2
        $game_actors[101].add_state(32) #ƒhƒLƒhƒL
        text += "\\" + $game_actors[101].bms_states_update
        $msg.t_enemy.add_state(16) #s“®•úŠü
      when 3..99
        plus = ($msg.talk_step * 5)
        perc = $game_actors[101].int
        perc /= 3 if $game_switches[89] == true #’ïR‚µ‚È‚¢‚Æ•t—^—¦‚‚­‚È‚é
        if $game_actors[101].state?(40)
          if rand($mood.point) + plus > [perc,60].min
            $game_actors[101].add_state(34) #œ’›
            text += "\\" + $game_actors[101].bms_states_update
          end
        elsif $game_actors[101].state?(35)
          if rand($mood.point) + plus > [perc,45].min
            $game_actors[101].add_state(40) #U–Ÿ
            text += "\\" + $game_actors[101].bms_states_update
          end
        else
          if rand($mood.point) + plus > [perc,30].min
            $game_actors[101].add_state(35) #—~î
            text += "\\" + $game_actors[101].bms_states_update
          end
        end
      end
    end
    $game_temp.battle_log_text += text
  end
  #============================================================================
  # œ‘Šè‚É«Œğ‚ÌˆÓv‚ª‚È‚¢‰ï˜b‚ğ‚·‚éê‡
  #============================================================================
  def bitter_talk?(enemy)
    result = false
    # ’ÊííŠ‚ÂAƒNƒ‰ƒXID‚ªƒvƒŠ[ƒXƒeƒX‚©ƒMƒ‹ƒS[ƒ“‚©ƒ‰[ƒ~ƒ‹‚Å‚ ‚é
    if not ($game_switches[85] or $game_switches[86] or $game_switches[99])
      if [118,254,257].include?(enemy.class_id)
        result = true
      end
    end
    return result
  end
  
end