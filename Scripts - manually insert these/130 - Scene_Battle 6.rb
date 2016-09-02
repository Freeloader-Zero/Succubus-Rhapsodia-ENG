#==============================================================================
# ¡ Scene_Battle (•ªŠ„’è‹` 6)
#------------------------------------------------------------------------------
# @ƒoƒgƒ‹‰æ–Ê‚Ìˆ—‚ğs‚¤ƒNƒ‰ƒX‚Å‚·B
#==============================================================================

class Scene_Battle
  #--------------------------------------------------------------------------
  # œ ƒtƒŒ[ƒ€XV (‰‡Œìs“®)
  #--------------------------------------------------------------------------
  def update_phase4_step105
    # ‰Šú‰»
    support_exist = false
    text = ""
    # ƒoƒgƒ‹ƒƒO‚ğƒNƒŠƒA
    @battle_log_window.contents.clear
    @battle_log_window.keep_flag = false
    $game_temp.battle_log_text = ""
    # g—p‘ÎÛ‚ğŠm”F
    actor_crisis_box = []
    actor_bad_state_box = []
    actor_status_down_box = []
    for actor_one in $game_party.battle_actors
      # ‚d‚o–ñ”¼•ª–¢–‚ÌƒAƒNƒ^[iålŒö‚Ì‚İj
      actor_crisis_box.push(actor_one) if actor_one.hpp < 60 and actor_one == $game_actors[101]
      # ó‘ÔˆÈã‚ª‚QˆÈã‚ÌƒAƒNƒ^[
      actor_bad_state_box.push(actor_one) if actor_one.bad_state_number >= 2
      n = 0
      # ã‰»‚ª‚RˆÈã‚ÌƒAƒNƒ^[
      for i in 0..5
        n += actor_one.state_runk[i] * -1 if actor_one.state_runk[i] < 0
      end
      actor_status_down_box.push(actor_one) if n >= 2
    end
    #--------------------------------------------------------------------------
    # ƒ‰[ƒ~ƒ‹ƒLƒƒƒXƒg‚Ì‰‡Œì
    #--------------------------------------------------------------------------
    if $game_switches[401]
      # ƒ‰[ƒ~ƒ‹ƒLƒƒƒXƒg‚Ì–¼‘O‚ğ•Ï”‚É“ü‚ê‚é
      supporter = $game_actors[122].name
      # ‚Q‚Ì”{”‚Ìƒ^[ƒ“‚É–‚–@‚ğ‰r¥‚³‚¹‚éB
      if $game_temp.battle_turn % 2 == 0
        # ã‚Ì‚à‚Ì‚Ù‚Ç—Dæ
        #--------------------------------------------------------------------------
        # ©ŒR‚Ì’N‚©‚ª‚d‚o–ñ”¼•ª–¢–‚Ì‚ÍA300’ö“x‚Ì‰ñ•œ‚ğs‚¤
        #--------------------------------------------------------------------------
        if actor_crisis_box.size > 0
          # ålŒö‚ğ—Dæ
          if actor_crisis_box.include?($game_actors[101])
            target = $game_actors[101]
          else 
            target = actor_crisis_box[0]
          end
          # ‰ñ•œ
          heal = 350 + rand(10) - rand(10)
          target.hp += heal
          target.animation_id = 70
          target.animation_hit = true
          text += "#{supporter}‚ÍƒCƒŠƒXƒyƒ^ƒ‹‚ğ‰r¥‚µ‚½I" + "\\"
          text += "#{target.name}‚Ì‚d‚o‚ª #{heal.to_s} ‰ñ•œ‚µ‚½I" + "\\"
          if target.hpp >= $mood.crisis_point(target) + rand(5)
            target.remove_state(6)
            target.crisis_flag = false
            text += target.bms_states_update
            target.remove_states_log.clear
            target.graphic_change = true
          end
        #--------------------------------------------------------------------------
        # ƒoƒXƒe‚ª‚Q‚ÂˆÈãŠ|‚©‚Á‚Ä‚¢‚éê‡‚Í‚»‚ê‚Ì‰ğœ
        #--------------------------------------------------------------------------
        elsif actor_bad_state_box.size > 0
          # ålŒö‚ğ—Dæ
          if actor_bad_state_box.include?($game_actors[101])
            target = $game_actors[101]
          else 
            target = actor_bad_state_box[0]
          end
          target.animation_id = 73
          target.animation_hit = true
          text += "#{supporter}‚ÍƒgƒŠƒ€ƒI[ƒ‹‚ğ‰r¥‚µ‚½I" + "\\"
          for i in 34..40
            target.remove_state(i)
          end
          text += target.bms_states_update
          target.remove_states_log.clear
        #--------------------------------------------------------------------------
        # ã‰»‡Œv‚ª‚RˆÈã‚Ìê‡‚Í‚»‚ê‚Ì‰ğœ
        #--------------------------------------------------------------------------
        elsif actor_status_down_box.size > 0
          # ålŒö‚ğ—Dæ
          if actor_status_down_box.include?($game_actors[101])
            target = $game_actors[101]
          else 
            target = actor_status_down_box[0]
          end
          target.animation_id = 74
          target.animation_hit = true
          text += "#{supporter}‚ÍƒC[ƒUƒJ[ƒ‹‚ğ‰r¥‚µ‚½I"
          # ƒC[ƒUƒJ[ƒ‹‚Ì€–Ú‚ğ’Ê‚·
          text += special_status_check(target,[221])
          target.add_states_log.clear
          target.remove_states_log.clear
        #--------------------------------------------------------------------------
        # ƒsƒ“ƒ`‚ª–³‚¢ê‡‚Í©ŒR‘S‘Ì‚ğ100’ö“x¬‰ñ•œ
        #--------------------------------------------------------------------------
        else
          text += "#{supporter}‚ÍƒCƒŠƒXƒV[ƒhEƒAƒ‹ƒ_‚ğ‰r¥‚µ‚½I" + "\\"
          for actor_one in $game_party.battle_actors
            heal = 150 + rand(10) - rand(10)
            actor_one.hp += heal
            actor_one.animation_id = 69
            actor_one.animation_hit = true
            text += "#{actor_one.name}‚Ì‚d‚o‚ª #{heal.to_s} ‰ñ•œ‚µ‚½I" + "\\"
            if actor_one.hpp >= $mood.crisis_point(actor_one) + rand(5)
              actor_one.remove_state(6)
              actor_one.crisis_flag = false
              text += actor_one.bms_states_update
              actor_one.remove_states_log.clear
              actor_one.graphic_change = true
            end
          end
        end
        # ƒeƒLƒXƒg‚É’Ç‰Á
        $game_temp.battle_log_text = text
        support_exist = true
      # ‚R‚Ì”{”ˆÈŠO‚Ìƒ^[ƒ“‚Í‰r¥
      else
        Audio.se_play("Audio/SE/087-Action02", 80, 100)
        $game_temp.battle_log_text = "#{supporter}‚Í‰r¥‚µ‚Ä‚¢‚éI"
        support_exist = true
      end
    end
    # ‰‡Œì‚ª”­¶‚µ‚½ê‡AƒEƒFƒCƒg‚ğ•t‚¯‚é
    if support_exist
      # ƒXƒe[ƒ^ƒX‚ÌƒŠƒtƒŒƒbƒVƒ…
      @status_window.refresh
      #¥ƒVƒXƒeƒ€ƒEƒFƒCƒg
      if $game_temp.battle_log_text != ""
        @wait_count = system_wait_make($game_temp.battle_log_text)
      end
    end
    # ƒXƒeƒbƒv 103 ‚ÉˆÚs
    @phase4_step = 103
  end
  #--------------------------------------------------------------------------
  # š ƒXƒe[ƒ^ƒXã¸ƒeƒLƒXƒg‚ğì¬
  #--------------------------------------------------------------------------
  def special_status_check(battler_one, skill_id_box = [])
    text = ""
    for i in skill_id_box
      battler_one.capacity_alteration_effect($data_skills[i]) 
      m = "#{battler_one.bms_states_update}"
      if m != "‚µ‚©‚µ#{battler_one.name}‚É‚ÍŒø‰Ê‚ª–³‚©‚Á‚½I"
        text += "\\" + m
      end
    end
    return text
  end
  #--------------------------------------------------------------------------
  # š ƒCƒ“ƒZƒ“ƒXŒø‰Ê
  #--------------------------------------------------------------------------
  def incense_effect
    # ƒoƒgƒ‰[‚¸‚Â‚ÉŒø‰Ê‚ª‚ ‚é‚à‚Ì
    text = ""
    for battler_one in $game_party.battle_actors + $game_troop.enemies
      # ƒŠƒ‰ƒbƒNƒXƒ^ƒCƒ€‚Í¬‰ñ•œ
      if $incense.exist?("ƒŠƒ‰ƒbƒNƒXƒ^ƒCƒ€", battler_one)
        battler_one.hp += battler_one.maxhp / 16
        if battler_one.hpp >= $mood.crisis_point(battler_one) + rand(5)
          battler_one.remove_state(6)
          battler_one.crisis_flag = false
          text += battler_one.bms_states_update
          battler_one.graphic_change = true
          battler_one.remove_states_log.clear
        end
        battler_one.animation_id = 51
        battler_one.animation_hit = true
      end
    end
    $game_temp.battle_log_text += text if text != ""
    $mood.rise(4) if $incense.exist?("ƒ‰ƒuƒtƒŒƒOƒ‰ƒ“ƒX", 2)
    # ƒXƒe[ƒ^ƒX‚ÌƒŠƒtƒŒƒbƒVƒ…
    @status_window.refresh
  end  
  #--------------------------------------------------------------------------
  # š ƒCƒ“ƒZƒ“ƒXŒø‰Ê
  #--------------------------------------------------------------------------
  def incense_start_effect
    text = ""
    case @command.name
    when "ƒŠƒ‰ƒbƒNƒXƒ^ƒCƒ€"
      for target_one in @target_battlers
        heal_one = target_one.maxhp / 16
        target_one.hp += heal_one
        text += "#{target_one.name}‚Ì‚d‚o‚ª #{heal_one.to_s} ‰ñ•œ‚µ‚½I" + "\\"
        if target_one.hpp >= $mood.crisis_point(target_one) + rand(5)
          target_one.remove_state(6)
          target_one.crisis_flag = false
          text += target_one.bms_states_update
          target_one.remove_states_log.clear
          target_one.graphic_change = true
        end
      end
    when "ƒ‰ƒuƒtƒŒƒOƒ‰ƒ“ƒX"
      $mood.rise(4)
    end
    text = "\\" + text if text != ""
    return text
  end  
  #--------------------------------------------------------------------------
  # œ ƒXƒ^ƒ“ƒƒ\ƒbƒh
  #--------------------------------------------------------------------------
  def battler_stan(battler)
    @action_battlers.delete(battler)
  end
  #--------------------------------------------------------------------------
  # œ oŒ»ƒGƒtƒFƒNƒg‚Ìw¦
  #--------------------------------------------------------------------------
  def appear_effect_order(battlers=[])
    @effect_order_battlers = []
    for battler_one in battlers.dup
      @effect_order_battlers.push(battler_one) if battler_one.exist?
    end
    @appear_effect_step_count = 0
    @go_appear_effect_step = true
  end  
  #--------------------------------------------------------------------------
  # œ â’¸ƒGƒtƒFƒNƒg‚Ìw¦
  #--------------------------------------------------------------------------
  def dead_effect_order(battlers=[])
    @effect_order_battlers = []
    for battler_one in battlers.dup
      @effect_order_battlers.push(battler_one) if battler_one.exist?
    end
    @dead_effect_step_count = 0
    @go_dead_effect_step = true
  end  
  #--------------------------------------------------------------------------
  # œ ƒtƒŒ[ƒ€XV (“ÁêFoŒ»ƒGƒtƒFƒNƒg)
  #--------------------------------------------------------------------------
  def appear_effect_step
    # •¶Í‚ÌƒŠƒtƒŒƒbƒVƒ…
    @battle_log_window.contents.clear
    @battle_log_window.keep_flag = false
    $game_temp.battle_log_text = ""
    # ƒ‹[ƒv‰ğœƒtƒ‰ƒO‚ğ‰Šú‰»
    end_flag = false
    #----------------------------------------------------------------------
    # ‘f¿Šm”F‚Ìƒ‹[ƒv‚ğŠJn
    while end_flag == false
      # ‰½‚à’Ê‚ç‚È‚©‚Á‚½—p‚ÉI—¹ƒtƒ‰ƒO‚ğ—§‚Ä‚éB
      end_flag = true
      #----------------------------------------------------------------------
      # 0F‘f¿y‚—gz‚Æy’¾’…z
      # í“¬Q‰Á‚É‚—gor’¾’…ó‘Ô‚É‚È‚éB
      #----------------------------------------------------------------------
      if @appear_effect_step_count == 0
        for battler in @effect_order_battlers
          text = ""
          # y‚—gz‚ğ‚¿Ay’¾’…z‚ª–³‚¢ê‡‚Íy‚—gzˆ—
          if battler.have_ability?("‚—g") \
           and not battler.have_ability?("’¾’…")
            text += "\\" if $game_temp.battle_log_text != ""
            text += "#{battler.name}‚Í‹»•±‚µ‚Ä‚¢‚éI"
            $game_temp.battle_log_text += text
            battler.animation_id = 123
            battler.animation_hit = true
            # ‚±‚Ìƒoƒgƒ‰[‚ğ‚—gó‘Ô‚É‚·‚é
            battler.add_state(41)
            battler.add_states_log.clear
          end
          text = ""
          # y’¾’…z‚ğ‚¿Ay‚—gz‚ª–³‚¢ê‡‚Íy’¾’…zˆ—
          if battler.have_ability?("’¾’…") \
           and not battler.have_ability?("‚—g")
            text += "\\" if $game_temp.battle_log_text != ""
            text += "#{battler.name}‚Í—‚¿’…‚¢‚Ä‚¢‚éI"
            $game_temp.battle_log_text += text
            battler.animation_id = 124
            battler.animation_hit = true
            # ‚±‚Ìƒoƒgƒ‰[‚ğ’¾’…ó‘Ô‚É‚·‚é
            battler.add_state(42)
            battler.add_states_log.clear
          end
        end
        # ƒGƒtƒFƒNƒg‚ğŠm”F‚µ‚½‚Ì‚Åƒ‹[ƒv‚ğI—¹‚³‚¹‚È‚¢
        end_flag = false
      end
      #----------------------------------------------------------------------
      # 1F‘f¿y”S‘Ìz
      # ‰Šúó‘Ô‚ÅŠŠ“x‚ª‚‚¢B
      #----------------------------------------------------------------------
      if @appear_effect_step_count == 1
        for battler in @effect_order_battlers
          if battler.have_ability?("”S‘Ì")
            # ’j‚Ü‚½‚Í—¼«‹ï—L‚Ìê‡A‰‚ÌŠŠ‚ğˆø‚«ã‚°‚é
            if battler.boy? or battler.futanari?
              if battler.lub_male < 60
                battler.lub_male = 60
                battler.add_state(21)
              end
            end
            # —i‚Ü‚½‚Í—¼«‹ï—Lj‚Ìê‡AŠ‚ÌŠŠ‚ğˆø‚«ã‚°‚é
            if battler.girl? or battler.futanari?
              if battler.lub_female < 60
                battler.lub_female = 60
                battler.add_state(23)
              end
            end
            # «•Ê‚ÉŠÖ‚í‚ç‚¸A‹eÀ‚ÌŠŠ‚ğˆø‚«ã‚°‚é
            if battler.lub_anal < 60
              battler.lub_anal = 60
              battler.add_state(23)
            end
            # ƒeƒLƒXƒg•\¦‚µ‚È‚¢‚Ì‚ÅƒXƒe[ƒgƒƒO‚ğƒNƒŠƒA
            battler.add_states_log = []
          end
        end
        # ƒGƒtƒFƒNƒg‚ğŠm”F‚µ‚½‚Ì‚Åƒ‹[ƒv‚ğI—¹‚³‚¹‚È‚¢
        end_flag = false
      end
      #----------------------------------------------------------------------
      # 2F‘f¿yƒTƒ“ƒ`ƒFƒbƒNzi–¡•ûj
      # oŒ»‚É“G‘Sˆõ‚ğˆØ•|ó‘Ô‚É‚·‚éB
      #----------------------------------------------------------------------
      if @appear_effect_step_count == 2
        for battler in @effect_order_battlers
          text = ""
          if battler.have_ability?("ƒTƒ“ƒ`ƒFƒbƒN") and battler.is_a?(Game_Actor)
            # ‚u‚o‚ªÁ”ï‚Å‚«‚é‚©
            go_flag = false
            go_flag = true if battler.sp > 100
            # ƒtƒ‰ƒO‚ª—§‚Á‚Ä‚¢‚ê‚Îˆ—‚ğs‚¤
            if go_flag
              # ƒRƒXƒg‚ğÁ”ï
              battler.sp -= 100
              battler.animation_id = 190
              battler.animation_hit = true
              text += "\\" if $game_temp.battle_log_text != ""
              text += "#{battler.name}‚Í‘Šè‚ğ‹°•|‚É‹ì‚è—§‚Ä‚½I"
              if battler.is_a?(Game_Actor)
                for enemy in $game_troop.enemies
                  if enemy.exist?
                    enemy.add_state(38, false, true)
                    if enemy.add_states_log.include?($data_states[38])
                      enemy.animation_id = 80
                      enemy.animation_hit = true
                      text += "\\" + enemy.bms_states_update(battler)
                    end
                  end
                end
              end
              $game_temp.battle_log_text += text
            end
          end
        end
        # ƒGƒtƒFƒNƒg‚ğŠm”F‚µ‚½‚Ì‚Åƒ‹[ƒv‚ğI—¹‚³‚¹‚È‚¢
        end_flag = false
      end
      #----------------------------------------------------------------------
      # 3F‘f¿yƒTƒ“ƒ`ƒFƒbƒNzi“Gj
      # oŒ»‚É“G‘Sˆõ‚ğˆØ•|ó‘Ô‚É‚·‚éB
      #----------------------------------------------------------------------
      if @appear_effect_step_count == 3
        for battler in @effect_order_battlers
          text = ""
          if battler.have_ability?("ƒTƒ“ƒ`ƒFƒbƒN") and battler.is_a?(Game_Enemy)
            # ‚u‚o‚ªÁ”ï‚Å‚«‚é‚©
            go_flag = false
            go_flag = true if battler.sp > 100
            # ƒtƒ‰ƒO‚ª—§‚Á‚Ä‚¢‚ê‚Îˆ—‚ğs‚¤
            if go_flag
              # ƒRƒXƒg‚ğÁ”ï
              battler.sp -= 100
              battler.animation_id = 190
              battler.animation_hit = true
              text += "\\" if $game_temp.battle_log_text != ""
              text += "#{battler.name}‚Í‘Šè‚ğ‹°•|‚É‹ì‚è—§‚Ä‚½I"
              if battler.is_a?(Game_Enemy)
                for actor in $game_party.battle_actors
                  if actor.exist?
                    actor.add_state(38, false, true)
                    if actor.add_states_log.include?($data_states[38])
                      actor.animation_id = 80
                      actor.animation_hit = true
                      text += "\\" + actor.bms_states_update(battler)
                    end
                  end
                end
              end
              $game_temp.battle_log_text += text
            end
          end
        end
        # ƒGƒtƒFƒNƒg‚ğŠm”F‚µ‚½‚Ì‚Åƒ‹[ƒv‚ğI—¹‚³‚¹‚È‚¢
        end_flag = false
      end
      #----------------------------------------------------------------------
      # 4F‘f¿yŒdŠáz
      # oŒ»‚É‘Šè‘Sˆõ‚ğƒ`ƒFƒbƒNó‘Ô‚É‚·‚éB
      #----------------------------------------------------------------------
      if @appear_effect_step_count == 4
        for battler in @effect_order_battlers
          text = ""
          if battler.have_ability?("ŒdŠá")
            if battler.is_a?(Game_Actor)
              for enemy in $game_troop.enemies
                if enemy.exist? and enemy.checking < 1
                  enemy.checking = 1
                end
              end
            elsif battler.is_a?(Game_Enemy)
              for actor in $game_party.battle_actors
                if actor.exist? and actor.checking < 1
                  actor.checking = 1
                end
              end
            end
          end
        end
        # ƒGƒtƒFƒNƒg‚ğŠm”F‚µ‚½‚Ì‚Åƒ‹[ƒv‚ğI—¹‚³‚¹‚È‚¢
        end_flag = false
      end
      #----------------------------------------------------------------------
      # 5FƒCƒ“ƒZƒ“ƒXuƒŒƒbƒhƒJ[ƒyƒbƒgv
      # oŒ»‚É–£—Í‚Æ‘f‘‚³‚ğ‹­‰»‚·‚éB
      #----------------------------------------------------------------------
      if @appear_effect_step_count == 5
        for battler in @effect_order_battlers
          text = ""
          if $incense.exist?("ƒŒƒbƒhƒJ[ƒyƒbƒg", battler)
            text += "\\" if $game_temp.battle_log_text != ""
            text += "#{battler.name}‚ÍŒ€“I‚È“üê‚ğ‰Ê‚½‚µ‚½I"
            battler.animation_id = 55
            battler.animation_hit = true
            # ‚±‚Ìƒoƒgƒ‰[‚Ì–£—Í‚Æ¸—Í‚ğ‚P’iŠKã‚°‚é
            # ƒ‰ƒiƒ“ƒuƒ‹ƒ€AƒRƒŠƒIƒuƒ‹ƒ€‚Ì‹­‰»€–Ú‚ğ’Ê‚·
            text += special_status_check(battler,[171,187])
            $game_temp.battle_log_text += text
            battler.add_states_log.clear
            n = 0 if battler.is_a?(Game_Actor)
            n = 1 if battler.is_a?(Game_Enemy)
            $incense.delete_incense("ƒŒƒbƒhƒJ[ƒyƒbƒg", n)
            Audio.se_play("Audio/SE/059-Applause01", 80, 100)
          end
        end
        # ƒGƒtƒFƒNƒg‚ğŠm”F‚µ‚½‚Ì‚Åƒ‹[ƒv‚ğI—¹‚³‚¹‚È‚¢
        end_flag = false
      end
      #----------------------------------------------------------------------
      # ƒJƒEƒ“ƒg‚ği‚ß‚é
      @appear_effect_step_count += 1
      # ƒeƒLƒXƒg‚ª‚ ‚é‚È‚çƒEƒFƒCƒg‚ğ‚©‚¯‚Ä•Ô‚·
      return if effect_text_check
    end
    #------------------------------------------------------------------------
    # ƒtƒ‰ƒO‚ğØ‚èA’Êí‚ÌƒXƒeƒbƒv‚Ö–ß‚·
    @go_appear_effect_step = false
  end
  #--------------------------------------------------------------------------
  # œ ƒtƒŒ[ƒ€XV (“ÁêFâ’¸ƒGƒtƒFƒNƒg)
  #--------------------------------------------------------------------------
  def dead_effect_step
    # •¶Í‚ÌƒŠƒtƒŒƒbƒVƒ…
    @battle_log_window.contents.clear
    @battle_log_window.keep_flag = false
    $game_temp.battle_log_text = ""
    # ƒ‹[ƒv‰ğœƒtƒ‰ƒO‚ğ‰Šú‰»
    end_flag = false
    
    #----------------------------------------------------------------------
    # ‘f¿Šm”F‚Ìƒ‹[ƒv‚ğŠJn
    while end_flag == false
      # ‰½‚à’Ê‚ç‚È‚©‚Á‚½—p‚ÉI—¹ƒtƒ‰ƒO‚ğ—§‚Ä‚éB
      end_flag = true
      #----------------------------------------------------------------------
      # 0 : ‘f¿yÅ—~z
      # ©•ªˆÈŠO‚Ì–¡•û‚ªâ’¸‚µ‚½A©•ª‚Ì–£—Í‚Æ¸—Í‚ğ‚P’iŠKã‚°‚é
      #----------------------------------------------------------------------
      if @dead_effect_step_count == 0
        # ‘Sˆõ‚ğŠm”F
        for battler in @effect_order_battlers
          text = ""
          effect_text = ""
          if battler.have_ability?("Å—~")
            go_flag = false
            # â’¸‚µ‚½ƒoƒgƒ‰[‚Ì’†‚ÉA©•ªˆÈŠO‚Ì–¡•û‚ª‚¢‚éê‡ƒtƒ‰ƒO‚ğ—§‚Ä‚é
            for ecstasy_battler in @ecstasy_battlers_clone
              if ecstasy_battler != battler and
               ((battler.is_a?(Game_Actor) and ecstasy_battler.is_a?(Game_Actor)) or
               (battler.is_a?(Game_Enemy) and ecstasy_battler.is_a?(Game_Enemy)))
                go_flag = true
              end
            end
            # ƒtƒ‰ƒO‚ª—§‚Á‚Ä‚¢‚ê‚Îˆ—‚ğs‚¤
            if go_flag
              text += "\\" if $game_temp.battle_log_text != ""
              text += "#{battler.name}‚Í–¡•û‚Ìâ’¸‚ğŒ©‚ÄV‚Á‚½I"
              # ‚±‚Ìƒoƒgƒ‰[‚Ì–£—Í‚Æ¸—Í‚ğ‚P’iŠKã‚°‚é
              # ƒ‰ƒiƒ“ƒuƒ‹ƒ€AƒGƒ‹ƒ_ƒuƒ‹ƒ€‚Ì‹­‰»€–Ú‚ğ’Ê‚·
              effect_text += special_status_check(battler,[171,179])
              # Œø‰Ê‚ª‚ ‚é‚È‚ç•\¦‚³‚¹‚é
              if effect_text != ""
                battler.animation_id = 123
                battler.animation_hit = true
                $game_temp.battle_log_text += text + effect_text
              end
              battler.add_states_log.clear
            end
          end
        end
        # ƒGƒtƒFƒNƒg‚ğŠm”F‚µ‚½‚Ì‚Åƒ‹[ƒv‚ğI—¹‚³‚¹‚È‚¢
        end_flag = false
      end
      #----------------------------------------------------------------------
      # 1 : ‘f¿y‘ÎRSz
      # –¡•û‚Ìâ’¸‚É–¡•û‚Ì”‚ª“G‚Ì”‚æ‚è­‚È‚¢ê‡A¸—Í‚Æ‘f‘‚³‚ğã‚°‚éB
      #----------------------------------------------------------------------
      if @dead_effect_step_count == 1
        # ‘Sˆõ‚ğŠm”F
        for battler in @effect_order_battlers
          text = ""
          effect_text = ""
          if battler.have_ability?("‘ÎRS")
            # ƒtƒ‰ƒO‚ğ‰Šú‰»
            go_flag = false
            # â’¸‚µ‚½ƒoƒgƒ‰[‚Ì’†‚ÉA–¡•û‚ª‚¢‚éê‡ƒtƒ‰ƒO‚ğ—§‚Ä‚é
            for ecstasy_battler in @ecstasy_battlers_clone
              if (battler.is_a?(Game_Actor) and ecstasy_battler.is_a?(Game_Actor)) or
               (battler.is_a?(Game_Enemy) and ecstasy_battler.is_a?(Game_Enemy))
                go_flag = true
              end
            end
            # ƒtƒ‰ƒO‚ª—§‚Á‚Ä‚¢‚È‚¢ê‡Ÿ‚Ìƒoƒgƒ‰[‚É
            next if go_flag == false
            # ƒtƒ‰ƒO‚ğÄ‰Šú‰»ig‚¢‰ñ‚µj
            go_flag = false
            # ¶‘¶‚µ‚Ä‚¢‚é–¡•û‚Ì”‚Æ“G‚Ì”‚ğ’²‚×‚é
            actors_number = 0
            enemies_number = 0
            for actor in $game_party.party_actors
              actors_number += 1 if actor.exist?
            end
            for enemy in $game_troop.enemies
              enemies_number += 1 if enemy.exist?
            end
            # –¡•û” < “G”‚É‚È‚Á‚Ä‚¢‚éê‡Aƒtƒ‰ƒO‚ğ—§‚Ä‚é
            if (battler.is_a?(Game_Actor) and enemies_number > actors_number) or
             (battler.is_a?(Game_Enemy) and actors_number > enemies_number)
              go_flag = true
            end
            # ƒtƒ‰ƒO‚ª—§‚Á‚Ä‚¢‚ê‚Îˆ—‚ğs‚¤
            if go_flag
              text += "\\" if $game_temp.battle_log_text != ""
              text += "#{battler.name}‚Í•s—˜‚Èó‹µ‚É‘ÎRS‚ğ”R‚â‚µ‚½I"
              # ‚±‚Ìƒoƒgƒ‰[‚Ì¸—Í‚Æ‘f‘‚³‚ğ‚P’iŠKã‚°‚é
              # ƒGƒ‹ƒ_ƒuƒ‹ƒ€AƒRƒŠƒIƒuƒ‹ƒ€‚Ì‹­‰»€–Ú‚ğ’Ê‚·
              effect_text += special_status_check(battler,[179,187])
              # Œø‰Ê‚ª‚ ‚é‚È‚ç•\¦‚³‚¹‚é
              if effect_text != ""
                battler.animation_id = 123
                battler.animation_hit = true
                $game_temp.battle_log_text += text + effect_text
              end
              battler.add_states_log.clear
            end
          end
        end
        # ƒGƒtƒFƒNƒg‚ğŠm”F‚µ‚½‚Ì‚Åƒ‹[ƒv‚ğI—¹‚³‚¹‚È‚¢
        end_flag = false
      end
      #----------------------------------------------------------------------
      # 2 : ‘f¿yƒGƒNƒXƒ^ƒV[ƒ{ƒ€z
      # ©•ª‚ªâ’¸‚µ‚½A©•ªˆÈŠO‚Ì–¡•û‘Sˆõ‚ğ–\‘–ó‘Ô‚É‚·‚éB
      #----------------------------------------------------------------------
      if @dead_effect_step_count == 2
        # ‘Sˆõ‚ğŠm”F
        for battler in @effect_order_battlers
          text = ""
          if battler.have_ability?("ƒGƒNƒXƒ^ƒV[ƒ{ƒ€")
            # ƒtƒ‰ƒO‚ğ‰Šú‰»
            go_flag = false
            # â’¸‚µ‚½ƒoƒgƒ‰[‚Ì’†‚ÉA©•ª‚ª‚¢‚éê‡ƒtƒ‰ƒO‚ğ—§‚Ä‚é
            for ecstasy_battler in @ecstasy_battlers_clone
              if ecstasy_battler == battler
                go_flag = true
                break
              end
            end
            # ©ŒR‚ª©•ª‚µ‚©‚¢‚È‚¢ê‡‚Íƒtƒ‰ƒO‚ğ‰º‚ë‚·
            army = $game_party.battle_actors if battler.is_a?(Game_Actor)
            army = $game_troop.enemies if battler.is_a?(Game_Enemy)
            army_count = 0
            for army_one in army
              army_count += 1 if army_one.exist?
            end
            go_flag = false if army_count <= 1
            # ƒtƒ‰ƒO‚ª—§‚Á‚Ä‚¢‚ê‚Îˆ—‚ğs‚¤
            if go_flag
              text += "\\" if $game_temp.battle_log_text != ""
              text += "#{battler.name}‚Ìâ’¸‚ª‘¼‚Ì–¡•û‚ğhŒƒ‚·‚éI"
              # Œø‰Ê‘ÎÛ‚ğ“ü‚ê‚é”z—ñ‚ğì¬
              effect_battlers = []
              # ©•ªˆÈŠO‚Ì–¡•û‘Sˆõ‚ğ”z—ñ‚É“ü‚ê‚éB
              if battler.is_a?(Game_Actor)
                for actor in $game_party.battle_actors
                  effect_battlers.push(actor) if actor.exist? and actor != battler
                end
              elsif battler.is_a?(Game_Enemy)
                for enemy in $game_troop.enemies
                  effect_battlers.push(enemy) if enemy.exist? and enemy != battler
                end
              end
              # Œø‰Ê‘ÎÛ‘Sˆõ‚Éˆ—‚ğs‚¤
              for effected_one in effect_battlers
                # –\‘–‚ğ‘Ï«ŒvZ‚ ‚è‚Å•t—^
                effected_one.add_state(36, false, true)
                # ‚±‚ê‚É‚æ‚è–\‘–ó‘Ô‚É‚È‚Á‚½AƒAƒjƒ[ƒVƒ‡ƒ“‚ÆƒeƒLƒXƒg‚ğ•\¦
                if effected_one.add_states_log.include?($data_states[36])
                  effected_one.animation_id = 123
                  effected_one.animation_hit = true
                  text += "\\" + effected_one.bms_states_update
                else
                  text += "\\" + "#{effected_one.name}‚É‚ÍŒø‰Ê‚ª‚È‚©‚Á‚½I"
                end
              end
              $game_temp.battle_log_text += text
              battler.add_states_log.clear
            end
          end
        end
        # ƒGƒtƒFƒNƒg‚ğŠm”F‚µ‚½‚Ì‚Åƒ‹[ƒv‚ğI—¹‚³‚¹‚È‚¢
        end_flag = false
      end
      #--------------------------------------------------------------------
      # ƒJƒEƒ“ƒg‚ğ‚Pi‚ß‚é
      @dead_effect_step_count += 1
      # ƒeƒLƒXƒg‚ª‚ ‚é‚È‚çƒEƒFƒCƒg‚ğ‚©‚¯‚Ä•Ô‚·
      return if effect_text_check
    end
    #------------------------------------------------------------------------
    # ƒtƒ‰ƒO‚ğØ‚èA’Êí‚ÌƒXƒeƒbƒv‚Ö–ß‚·
    @go_dead_effect_step = false
  end

  #--------------------------------------------------------------------------
  # œ ƒtƒŒ[ƒ€XV oŒ»Aâ’¸ƒGƒtƒFƒNƒg‚ÌƒeƒLƒXƒgƒ`ƒFƒbƒN
  #--------------------------------------------------------------------------
  def effect_text_check
    return_flag = false
    # ƒeƒLƒXƒg‚ª‚ ‚éê‡AƒEƒFƒCƒg‚ğì‚èƒƒ\ƒbƒh‚ğI—¹‚³‚¹‚éB
    if $game_temp.battle_log_text != ""
      @status_window.refresh
      $game_temp.battle_log_text += "\\" if $game_system.system_read_mode == 0
      #¥ƒVƒXƒeƒ€ƒEƒFƒCƒg
      @wait_count = system_wait_make($game_temp.battle_log_text)
      return_flag = true
    end
    return return_flag
  end
end