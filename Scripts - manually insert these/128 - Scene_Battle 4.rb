#==============================================================================
# ¡ Scene_Battle (•ªŠ„’è‹` 4)
#------------------------------------------------------------------------------
# @ƒoƒgƒ‹‰æ–Ê‚Ìˆ—‚ğs‚¤ƒNƒ‰ƒX‚Å‚·B
#==============================================================================

class Scene_Battle
  
  #--------------------------------------------------------------------------
  # œ ƒz[ƒ‹ƒhƒ|ƒbƒv‚ÌoŒ»E”ñoŒ»
  #--------------------------------------------------------------------------
  def hold_pops_display_check(bool)

    # ‚»‚ê‚¼‚ê‚Ìƒoƒgƒ‰[‚É•\¦ƒtƒ‰ƒO‚ğ—§‚Ä‚éB
    for battler in $game_party.battle_actors + $game_troop.enemies
      battler.hold_pops_fade = 1 if bool
      battler.hold_pops_fade = 2 unless bool
    end
  end
  #--------------------------------------------------------------------------
  # œ ƒƒCƒ“ƒtƒF[ƒYŠJn
  #--------------------------------------------------------------------------
  def start_phase4
    # ƒtƒF[ƒY 4 ‚ÉˆÚs
    @phase = 4
    # ƒ^[ƒ“”ƒJƒEƒ“ƒg
    $game_temp.battle_turn += 1
    # ƒoƒgƒ‹ƒCƒxƒ“ƒg‚Ì‘Sƒy[ƒW‚ğŒŸõ
    for index in 0...$data_troops[@troop_id].pages.size
      # ƒCƒxƒ“ƒgƒy[ƒW‚ğæ“¾
      page = $data_troops[@troop_id].pages[index]
      # ‚±‚Ìƒy[ƒW‚ÌƒXƒpƒ“‚ª [ƒ^[ƒ“] ‚Ìê‡
      if page.span == 1
        # ÀsÏ‚İƒtƒ‰ƒO‚ğƒNƒŠƒA
        $game_temp.battle_event_flags[index] = false
      end
    end
    # ƒAƒNƒ^[‚ğ”ñ‘I‘ğó‘Ô‚Éİ’è
    @actor_index = -1
    @active_battler = nil
    
    # ƒz[ƒ‹ƒhƒ|ƒbƒv‚ğ”ñ•\¦‚É‚·‚éB
    hold_pops_display_check(false) if @hold_pops_display
    @hold_pops_display = false
      
    #ŒûãŠÇ—ŒnƒXƒCƒbƒ`‚ğØ‚Á‚Ä‚¨‚­
    for i in 23..24
      $game_switches[i] = false
    end
    for i in 77..83
      $game_switches[i] = false
    end
    $game_switches[89] = false #ƒŒƒWƒXƒgó‘øƒXƒCƒbƒ`
    
    # ƒƒbƒZ[ƒW•\¦ˆÊ’u•ÏX‚ğ–ß‚·
    $game_temp.in_battle_change = false
    
    # ƒp[ƒeƒBƒRƒ}ƒ“ƒhƒEƒBƒ“ƒhƒE‚ğ—LŒø‰»
#    @party_command_window.active = false
#    @party_command_window.visible = false
    # ƒAƒNƒ^[ƒRƒ}ƒ“ƒhƒEƒBƒ“ƒhƒE‚ğ–³Œø‰»
    command_all_delete
#    @actor_command_window.active = false
#    @actor_command_window.visible = false
    # ƒƒCƒ“ƒtƒF[ƒYƒtƒ‰ƒO‚ğƒZƒbƒg
    $game_temp.battle_main_phase = true
    
    #œƒoƒgƒ‹ƒg[ƒNŠÖ˜A‚ğƒŠƒZƒbƒg
    $game_temp.action_num = 0
    #ƒAƒNƒ^[‚Ì–\‘–ƒtƒ‰ƒO‚ğ‰ğœ(T‚¦ŠÜ‚Ş)
    for actor in $game_party.actors
      #œ–\‘–ƒtƒ‰ƒO‚ğ‰ğœ
      if actor.berserk == true and not actor.state?(36)
        actor.berserk = false
      elsif actor.berserk == false and actor.state?(36)
        actor.berserk = true
      end
    end
    # ƒGƒlƒ~[ƒAƒNƒVƒ‡ƒ“ì¬
    for enemy in $game_troop.enemies
      #œ–\‘–ƒtƒ‰ƒO‚ğ‰ğœ
      if enemy.berserk == true and not enemy.state?(36)
        enemy.berserk = false
      end
      enemy.another_action = false
      enemy_action_swicthes(enemy)
      enemy.make_action
    end
    # ƒGƒlƒ~[‚Ì‘½ds“®ƒtƒ‰ƒO‚ğ‰ğœ
    for enemy in $game_troop.enemies
#      enemy.another_action = false # ã‚ÉˆÚ“®
    end
    
    # ƒAƒNƒ^[‚Ìg—pƒ^[ƒ“‚ÉŠ|‚©‚éƒXƒLƒ‹ƒGƒtƒFƒNƒg
    for actor in $game_party.battle_actors
      if actor.exist? and actor.current_action.kind == 1
        # ‘®«Fƒ^[ƒ“’†ƒK[ƒhŒø‰Ê
        if $data_skills[actor.current_action.skill_id].element_set.include?(197)
          # ƒK[ƒhƒXƒe[ƒg‚ğ•t‚¯‚é
          actor.add_state(93)
          actor.add_states_log.clear
        end
      end
    end
    
    
    
    # šƒoƒgƒ‹ƒƒOƒEƒBƒ“ƒhƒE‚ğƒtƒF[ƒhƒCƒ“ŠJnÀ•W‚É
    @battle_log_window.bgframe_sprite.opacity = 0
    @battle_log_window.bgframe_sprite.y = -12
    
    # s“®‡˜ì¬
    make_action_orders
    
    # æè‚ğæ‚ç‚ê‚½ê‡
    if $game_temp.first_attack_flag == 2
      # ƒAƒNƒ^[‚ğ”z—ñ @action_battlers ‚©‚çíœ
      for actor in $game_party.actors
        @action_battlers.delete(actor)
      end
#      $game_temp.first_attack_flag = 0
    elsif $game_temp.first_attack_flag == 1
      # ƒGƒlƒ~[‚ğ”z—ñ @action_battlers ‚©‚çíœ
      for enemy in $game_troop.enemies
        @action_battlers.delete(enemy)
      end
#      $game_temp.first_attack_flag = 0
    end
    #########################################################
    @self_data = ""          #‚»‚Ì‚Ìs“®Ò‚Ìî•ñ
    @target_data = ""        #‚»‚Ì‚ÌUŒ‚‘ÎÛ‚Ìî•ñ
    @free_text = ""          #•¶š—ñì¬—p‚Ìƒƒ‚’ 
    
    @battle_log_window.visible = false
    #@battle_log_window.set_text($game_temp.battle_turn.to_s + "ƒ^[ƒ“–Ú ŠJn")
    #@wait_count = 60
    #p $game_temp.battle_turn.to_s + "ƒ^[ƒ“–Ú ŠJn"
    #########################################################
    @wait_count = 5
    # ƒXƒeƒbƒv 1 ‚ÉˆÚs
    @phase4_step = 0
  end
  #--------------------------------------------------------------------------
  # œ s“®‡˜ì¬
  #--------------------------------------------------------------------------
  def make_action_orders
    # ”z—ñ @action_battlers ‚ğ‰Šú‰»
    @action_battlers = []
    # ƒGƒlƒ~[‚ğ”z—ñ @action_battlers ‚É’Ç‰Á
    # ‘½ds“®—p‚É‚Q˜g’Ç‰Á‚·‚é(–\‘–’†AˆØ•|s“®’†‚Í‚P˜g‚Ì‚İ)
    for enemy in $game_troop.enemies
      @action_battlers.push(enemy)
      if enemy.berserk == false 
        @action_battlers.push(enemy)
      end
    end
    # ƒAƒNƒ^[‚ğ”z—ñ @action_battlers ‚É’Ç‰Á
    for actor in $game_party.actors
      @action_battlers.push(actor)
    end
    # ‘Sˆõ‚ÌƒAƒNƒVƒ‡ƒ“ƒXƒs[ƒh‚ğŒˆ’è
    for battler in @action_battlers
      battler.make_action_speed
    end
    # ƒAƒNƒVƒ‡ƒ“ƒXƒs[ƒh‚Ì‘å‚«‚¢‡‚É•À‚Ñ‘Ö‚¦
    @action_battlers.sort! {|a,b|
      b.current_action.speed - a.current_action.speed }
  end
  #--------------------------------------------------------------------------
  # œ ƒtƒŒ[ƒ€XV (ƒƒCƒ“ƒtƒF[ƒY)
  #--------------------------------------------------------------------------
  def update_phase4
    case @phase4_step
    when 0 # šƒ^[ƒ“ŠJnˆ—
      update_phase4_step0
    when 101 # šƒNƒ‰ƒCƒVƒX•ñ
      update_phase4_step101
    when 102 # šƒXƒe[ƒgŒp‘±•ñ
      update_phase4_step102
    when 104 # šƒCƒ“ƒZƒ“ƒXŒp‘±•ñ
      update_phase4_step104
    when 1
      update_phase4_step1
    when 103 # šƒ^[ƒ“I—¹ˆ—
      update_phase4_step103
    when 105 # š‰‡Œìs“®
      update_phase4_step105
    when 2
      update_phase4_step2
    when 3
      update_phase4_step3
    when 4
      update_phase4_step4
    when 401 #ƒNƒ‰ƒCƒVƒXˆ—
      update_phase4_step401
    when 402 #“r’†‰ï˜bˆ—
      update_phase4_step402
    when 5
      update_phase4_step5
    when 501 #šâ’¸ƒXƒeƒbƒv‘O”¼
      update_phase4_step501
    when 502 #šâ’¸ƒXƒeƒbƒvŒã”¼
      update_phase4_step502
    when 503 #šƒz[ƒ‹ƒh‰ğœ
      update_phase4_step503
    when 504 #šƒAƒNƒ^[“ü‚ê‘Ö‚¦ˆ—(í“¬•s”\)
      update_phase4_step504
    when 601 #š’ÇŒ‚”»’è
      update_phase4_step601
    when 602 # šâ’¸ˆ—
      update_phase4_step602
    when 6
      update_phase4_step6
    when 12 # šƒŒƒWƒXƒgƒQ[ƒ€ŠJn
      update_phase4_step12
    when 13 # šƒŒƒWƒXƒg¬”Û‚ÌŒ‹‰Êì¬ 
      update_phase4_step13
    end
  end
  #--------------------------------------------------------------------------
  # š ƒtƒŒ[ƒ€XV (ƒƒCƒ“ƒtƒF[ƒY ƒXƒeƒbƒv 0 : ƒ^[ƒ“ŠJnˆ—)
  #--------------------------------------------------------------------------
  def update_phase4_step0
    
    # ƒwƒ‹ƒvƒEƒBƒ“ƒhƒE‚ğ‰B‚·
    @help_window.visible = false
    # šƒoƒgƒ‹ƒƒOƒEƒBƒ“ƒhƒE‚ğo‚·
    @battle_log_window.visible = true
    @battle_log_window.bgframe_sprite.visible = true

    text = ""
    txc = 0
    # ƒNƒ‰ƒCƒVƒX•ñƒƒbƒZ[ƒW•\¦
    for actor in $game_party.battle_actors
      if actor.exist? and actor.state?(6)
        text += $data_states[6].message($data_states[6], "report", actor, nil) + "\\"
        txc += 1
      end
    end
    for enemy in $game_troop.enemies
      if enemy.exist? and enemy.state?(6)
        text += $data_states[6].message($data_states[6], "report", enemy, nil) + "\\"
        txc += 1
      end
    end
    if text != ""
      #¥ƒVƒXƒeƒ€ƒEƒFƒCƒg
      case $game_system.ms_skip_mode
      when 3 #è“®‘—‚èƒ‚[ƒh
        @wait_count = (txc + 1) * 4
      when 2 #ƒfƒoƒbƒOƒ‚[ƒh
        @wait_count = 8
      when 1 #‰õ‘¬ƒ‚[ƒh
        @wait_count = 12
      else
        @wait_count = $game_system.battle_speed_time(0) + $game_system.important_wait_time + (txc * (4 + 1))
      end
      if $game_system.system_read_mode != 0
        text += "CLEAR"
        text.sub!("\\CLEAR","")
      end
      $game_temp.battle_log_text += text if text != ""
    end
    
    
    # ƒXƒeƒbƒv 1 ‚ÉˆÚs
    @phase4_step = 101
  end  
  #--------------------------------------------------------------------------
  # š ƒtƒŒ[ƒ€XV (ƒƒCƒ“ƒtƒF[ƒY ƒXƒeƒbƒv 101 : ƒXƒe[ƒgŒp‘±ƒƒbƒZ[ƒW)
  #--------------------------------------------------------------------------
  def update_phase4_step101
    # ƒoƒgƒ‹ƒƒO‚ğƒNƒŠƒA
    @battle_log_window.contents.clear
    @battle_log_window.keep_flag = false
    $game_temp.battle_log_text = ""
    ms = text = text1 = text2 = ""
    txc = 0
    for actor in $game_party.battle_actors
      if actor.exist? and not actor.dead?
#        actor.remove_states_auto
        ms = actor.bms_states_report
        text1 = (text1 + ms + "\\") if ms != ""
        txc += 1 if ms != ""
      end
    end
    ms = ms2 = ""
    for enemy in $game_troop.enemies
      if enemy.exist?
#        enemy.remove_states_auto
        ms = enemy.bms_states_report
        text2 = (text2 + ms + "\\") if ms != ""
        txc += 1 if ms != ""
      end
    end
#    text2.sub!("\\\\n\\n\\n\\n","\\n") if text2.include?("\\n\\n\\n\\n\\n")
    text = text1 + text2
    if text != ""
=begin
      #¥ƒVƒXƒeƒ€ƒEƒFƒCƒg
      case $game_system.ms_skip_mode
      when 3 #è“®‘—‚èƒ‚[ƒh
        @wait_count = (txc + 1) * 4
      when 2 #ƒfƒoƒbƒOƒ‚[ƒh
        @wait_count = 8
      when 1 #‰õ‘¬ƒ‚[ƒh
        @wait_count = 12
      else
        # ƒXƒe[ƒgŠÖŒW‚ÍƒXƒe[ƒg‚Ì”‚¾‚¯ƒEƒFƒCƒg‚ğ‰ÁZ
        @wait_count = $game_system.battle_speed_time(0) + $game_system.important_wait_time + (txc * (4 + 1))
      end
=end
      if $game_system.system_read_mode != 0
        text += "CLEAR"
        text.sub!("\\CLEAR","")
      end
      $game_temp.battle_log_text += text
      #¥ƒVƒXƒeƒ€ƒEƒFƒCƒg
      @wait_count = system_wait_make($game_temp.battle_log_text)
    end
    # ‘Sƒoƒgƒ‰[‚ÌƒXƒe[ƒgƒƒO‚ğ‚·‚×‚ÄƒNƒŠƒA
    for battler in @battlers
      battler.add_states_log.clear
      battler.remove_states_log.clear
    end
    # ‰æ‘œ•ÏXƒtƒ‰ƒO‚ğ—§‚Ä‚Ä‰æ‘œ‚ğƒŠƒtƒŒƒbƒVƒ…
    for enemy in $game_troop.enemies
      if enemy.exist?
        enemy.graphic_change = true
      end
    end
    for actor in $game_party.party_actors
      if actor.exist?
        actor.graphic_change = true
      end
    end
    # ƒXƒeƒbƒv 102 ‚ÉˆÚs
    @phase4_step = 102
  end  
  #--------------------------------------------------------------------------
  # š ƒtƒŒ[ƒ€XV (ƒƒCƒ“ƒtƒF[ƒY ƒXƒeƒbƒv 102 : ƒXƒe[ƒg•Ï‰»ƒƒbƒZ[ƒW)
  #   i‚Ù‚Úˆú“Åê—pj
  #--------------------------------------------------------------------------
  def update_phase4_step102
    # ƒoƒgƒ‹ƒƒO‚ğƒNƒŠƒA
    @battle_log_window.contents.clear
    @battle_log_window.keep_flag = false
    $game_temp.battle_log_text = ""
    ms = text = text1 = text2 = ""
    txc = 0
    for actor in $game_party.battle_actors
      if actor.exist? and not actor.dead?
        special_mushroom_effect(actor) if actor.state?(30) #ˆú“Å•¹”­
        #actor.persona_break if actor.state?(106) #”j–Ê•¹”­
        
#        actor.remove_states_auto
        ms = actor.bms_states_update
        text1 = (text1 + ms + "\\") if ms != ""
        txc += 1 if ms != ""
      end
    end
    ms = ms2 = ""
    for enemy in $game_troop.enemies
      if enemy.exist?
        special_mushroom_effect(enemy) if enemy.state?(30) #ˆú“Å•¹”­
        #enemy.persona_break if enemy.state?(106) #”j–Ê•¹”­
#        enemy.remove_states_auto
        ms = enemy.bms_states_update
        text2 = (text2 + ms + "\\") if ms != ""
        txc += 1 if ms != ""
      end
    end
    text = text1 + text2
    if text != ""
      #¥ƒVƒXƒeƒ€ƒEƒFƒCƒg
      case $game_system.ms_skip_mode
      when 3 #è“®‘—‚èƒ‚[ƒh
        @wait_count = (txc + 1) * 4
      when 2 #ƒfƒoƒbƒOƒ‚[ƒh
        @wait_count = 8
      when 1 #‰õ‘¬ƒ‚[ƒh
        @wait_count = 12
      else
        # ƒXƒe[ƒgŠÖŒW‚ÍƒXƒe[ƒg‚Ì”‚¾‚¯ƒEƒFƒCƒg‚ğ‰ÁZ
        @wait_count = $game_system.battle_speed_time(0) + $game_system.important_wait_time + (txc * (4 + 1))
      end
      if $game_system.system_read_mode != 0
        text += "CLEAR"
        text.sub!("\\CLEAR","")
      end
      $game_temp.battle_log_text += text
    end
    # ‘Sƒoƒgƒ‰[‚ÌƒXƒe[ƒgƒƒO‚ğ‚·‚×‚ÄƒNƒŠƒA
    for battler in @battlers
      battler.add_states_log.clear
      battler.remove_states_log.clear
    end
    # ‰æ‘œ•ÏXƒtƒ‰ƒO‚ğ—§‚Ä‚Ä‰æ‘œ‚ğƒŠƒtƒŒƒbƒVƒ…
    for enemy in $game_troop.enemies
      if enemy.exist?
        enemy.graphic_change = true
      end
    end
    for actor in $game_party.party_actors
      if actor.exist?
        actor.graphic_change = true
      end
    end
    # ƒXƒeƒbƒv 104 ‚ÉˆÚs
    @phase4_step = 104
  end
  #--------------------------------------------------------------------------
  # š ƒtƒŒ[ƒ€XV (ƒƒCƒ“ƒtƒF[ƒY ƒXƒeƒbƒv 103 : ƒCƒ“ƒZƒ“ƒX•Ï‰»ƒƒbƒZ[ƒW)
  #--------------------------------------------------------------------------
  def update_phase4_step104
    # ƒoƒgƒ‹ƒƒO‚ğƒNƒŠƒA
    @battle_log_window.contents.clear
    @battle_log_window.keep_flag = false
    $game_temp.battle_log_text = ""
    #šƒCƒ“ƒZƒ“ƒXŒø‰Ê•ñ‚ğo—Í‚·‚é
    $incense.keep_text_call
    #šƒCƒ“ƒZƒ“ƒXƒGƒtƒFƒNƒg‚ğ”­¶‚³‚¹‚é
    incense_effect
    #¥ƒVƒXƒeƒ€ƒEƒFƒCƒg
    if $game_temp.battle_log_text != ""
      @wait_count = system_wait_make($game_temp.battle_log_text)
    end
    # ƒXƒeƒbƒv 1 ‚ÉˆÚs
    @phase4_step = 1
  end
  #--------------------------------------------------------------------------
  # œ ƒtƒŒ[ƒ€XV (ƒƒCƒ“ƒtƒF[ƒY ƒXƒeƒbƒv 1 : ƒAƒNƒVƒ‡ƒ“€”õ)
  #--------------------------------------------------------------------------
  def update_phase4_step1
#    p "update4-1"if $DEBUG
    #p "1a" if $debug_flag == 1
    #â’¸ƒXƒCƒbƒ`‚ÍØ‚Á‚Ä‚¨‚­
    
    # Ÿ”s”»’è
    if judge
      # Ÿ—˜‚Ü‚½‚Í”s–k‚Ìê‡ : ƒƒ\ƒbƒhI—¹
      return
    end
    
    # c‚è‚Ì–²–‚î•ñ‚ğ‰Šú‰»
    @last_enemies = []
    common_enemies = []
    # ƒgƒ‹[ƒv‚ğƒ`ƒFƒbƒN
    for enemy in $game_troop.enemies
      if enemy.exist?
        @last_enemies.push(enemy)
        common_enemies.push(enemy) unless enemy.boss_graphic?
      end
    end
    if common_enemies.size == 1
      common_enemies[0].position_flag = 1 unless common_enemies[0].position_flag == -1
    end
    
    # ƒwƒ‹ƒvƒEƒBƒ“ƒhƒE‚ğ‰B‚·
    @help_window.visible = false
    # šƒoƒgƒ‹ƒƒOƒEƒBƒ“ƒhƒE‚ğo‚·
    @battle_log_window.visible = true
    @battle_log_window.bgframe_sprite.visible = true

    # ƒAƒNƒVƒ‡ƒ“‚ğ‹­§‚³‚ê‚Ä‚¢‚éƒoƒgƒ‰[‚ª‘¶İ‚µ‚È‚¢ê‡
    if $game_temp.forcing_battler == nil
      # ƒoƒgƒ‹ƒCƒxƒ“ƒg‚ğƒZƒbƒgƒAƒbƒv
      setup_battle_event
      # ƒoƒgƒ‹ƒCƒxƒ“ƒgÀs’†‚Ìê‡
      if $game_system.battle_interpreter.running?
        return
      end
    end
    # ƒAƒNƒVƒ‡ƒ“‚ğ‹­§‚³‚ê‚Ä‚¢‚éƒoƒgƒ‰[‚ª‘¶İ‚·‚éê‡
    if $game_temp.forcing_battler != nil
      # æ“ª‚É’Ç‰Á‚Ü‚½‚ÍˆÚ“®(‹­§s“®‚ğ‹N‚±‚·‚Æ‘½ds“®•s‰Â‚É‚·‚é)
      @action_battlers.delete($game_temp.forcing_battler)
      @action_battlers.unshift($game_temp.forcing_battler)
      $game_temp.forcing_battler.another_action = false
    end
    # –¢s“®ƒoƒgƒ‰[‚ª‘¶İ‚µ‚È‚¢ê‡ (‘Sˆõs“®‚µ‚½)
    if @action_battlers.size == 0
      # ƒoƒgƒ‹ƒƒO‚ğƒNƒŠƒA
      @battle_log_window.contents.clear
      @battle_log_window.keep_flag = false
      $game_temp.battle_log_text = ""
      txc = 0
      # œƒXƒe[ƒg‰ğœ”»’è‚ğs‚È‚¤
      ms = text = text1 = text2 = ""
      for actor in $game_party.battle_actors
        if actor.exist? and not actor.dead?
          actor.remove_states_auto
          ms = actor.bms_states_update
          text1 = (text1 + ms + "\\") if ms != ""
          txc += 1
        end
      end
      ms = ms2 = ""
      for enemy in $game_troop.enemies
        if enemy.exist?
          enemy.remove_states_auto
          ms = enemy.bms_states_update
          text2 = (text2 + ms + "\\") if ms != ""
          txc += 1
        end
      end
      text = text1 + text2
      before_text_flag = false # ‚±‚Ì“_‚ÅƒeƒLƒXƒg‚ª‚ ‚é‚©Šm”F
      if text != ""
        #¥ƒVƒXƒeƒ€ƒEƒFƒCƒg
        case $game_system.ms_skip_mode
        when 3 #è“®‘—‚èƒ‚[ƒh
          @wait_count = (txc + 1) * 4
        when 2 #ƒfƒoƒbƒOƒ‚[ƒh
          @wait_count = 8
        when 1 #‰õ‘¬ƒ‚[ƒh
          @wait_count = 12
        else
          # ƒXƒe[ƒgŠÖŒW‚ÍƒXƒe[ƒg‚Ì”‚¾‚¯ƒEƒFƒCƒg‚ğ‰ÁZ
          @wait_count = $game_system.battle_speed_time(0) + $game_system.important_wait_time + (txc * (4 + 1))
        end
        if $game_system.system_read_mode != 0
          text += "CLEAR"
          text.sub!("\\CLEAR","")
        end
        $game_temp.battle_log_text += text
        before_text_flag = true # ƒeƒLƒXƒg—L‚è‚Ìƒtƒ‰ƒO‚ğ—§‚Ä‚é
      end
      # ‘Sƒoƒgƒ‰[‚ÌƒXƒe[ƒgƒƒO‚ğ‚·‚×‚ÄƒNƒŠƒA
      for battler in @battlers
        battler.add_states_log.clear
        battler.remove_states_log.clear
      end
      # ‰æ‘œ•ÏXƒtƒ‰ƒO‚ğ—§‚Ä‚Ä‰æ‘œ‚ğƒŠƒtƒŒƒbƒVƒ…
      for enemy in $game_troop.enemies
        if enemy.exist?
          enemy.graphic_change = true
        end
      end
      for actor in $game_party.party_actors
        if actor.exist?
          actor.graphic_change = true
        end
      end
      # æUŒãU‚Í‚±‚±‚ÅƒŠƒtƒŒƒbƒVƒ…‚ğ“ü‚ê‚é
      $game_temp.first_attack_flag = 0
      # ‰æ‘œ•ÏXƒtƒ‰ƒO‚ğ—§‚Ä‚Ä‰æ‘œ‚ğƒŠƒtƒŒƒbƒVƒ…
      # X‚ÉAƒK[ƒhó‘ÔAƒŠƒNƒGƒXƒgó‘Ô‚È‚ç‚»‚ê‚ç‚à“¯‚É‰ğœ‚·‚é
      text = ""
      for enemy in $game_troop.enemies
        if enemy.exist?
          #ƒ^[ƒ“‚ğ‚Ü‚½‚®‚ÆƒŒƒWƒXƒgƒJƒEƒ“ƒg‚Í‚P‰º‚ª‚é
#          enemy.resist_count -= 1 if enemy.resist_count > 0
          if enemy.ecstasy_turn > 0
            enemy.ecstasy_turn -= 1
            if enemy.ecstasy_turn == 0 and enemy.weaken?
              enemy.remove_state(2) if enemy.states.include?(2) #Šã
              enemy.remove_state(3) if enemy.states.include?(3) #â’¸
              text += enemy.bms_states_update + "\\"
              enemy.animation_id = 12
              enemy.animation_hit = true
              txc += 1
            end
          end
          enemy.graphic_change = true
          enemy.remove_state(93) if enemy.states.include?(93) #ƒK[ƒh
          enemy.remove_state(94) if enemy.states.include?(94) #‘åƒK[ƒh
        end
      end
      for actor in $game_party.party_actors
        if actor.exist?
          #–\‘–ƒ`ƒFƒbƒN
          if actor.state?(36)
            actor.berserk = true
          else
            actor.berserk = false
          end
          #ƒ^[ƒ“‚ğ‚Ü‚½‚®‚ÆƒŒƒWƒXƒgƒJƒEƒ“ƒg‚Í‚P‰º‚ª‚é
#          actor.resist_count -= 1 if actor.resist_count > 0
          if actor.ecstasy_turn > 0
            actor.ecstasy_turn -= 1
            if actor.ecstasy_turn == 0 and actor.weaken?
              actor.remove_state(2) if actor.states.include?(2) #Šã
              actor.remove_state(3) if actor.states.include?(3) #â’¸
              text += actor.bms_states_update + "\\"
              actor.animation_id = 12
              actor.animation_hit = true
              txc += 1
            end
          end
          actor.graphic_change = true
          actor.remove_state(93) if actor.states.include?(93) #ƒK[ƒh
          actor.remove_state(94) if actor.states.include?(94) #‘åƒK[ƒh
          actor.remove_state(96) if actor.states.include?(96) #ƒAƒs[ƒ‹
        end
      end
      #‚¨”C‚¹’†‚Ìê‡AƒJƒEƒ“ƒgŒ¸BƒJƒEƒ“ƒg‚ª‚O‚É‚È‚Á‚½‚ç‰ğœ‚µ‚Ä”²‚¯‚é
      if $game_actors[101].state?(95)
        if $freemode_count > 0
          $freemode_count -= 1
        else
          $game_actors[101].remove_state(95)
          $freemode_count = nil
        end
      end
      #ƒeƒLƒXƒg®Œ`
      if text != ""
        if $game_system.system_read_mode != 0
          text += "CLEAR"
          text.sub!("\\CLEAR","")
        end
        # –‘O‚ÉƒeƒLƒXƒg‚ª‚ ‚Á‚½ê‡‚Í‰üs‚ğ‘}‚·
        text = "\\" + text if before_text_flag 
        $game_temp.battle_log_text += text
        #¥ƒVƒXƒeƒ€ƒEƒFƒCƒg
        case $game_system.ms_skip_mode
        when 3 #è“®‘—‚èƒ‚[ƒh
          @wait_count = (txc + 1) * 4
        when 2 #ƒfƒoƒbƒOƒ‚[ƒh
          @wait_count = 8
        when 1 #‰õ‘¬ƒ‚[ƒh
          @wait_count = 12
        else
          @wait_count = $game_system.battle_speed_time(0) + $game_system.important_wait_time
        end
      end
      #šƒCƒ“ƒZƒ“ƒXŒp‘±”»’è‚ğs‚È‚¤
      $incense.turn_end_reduction
      
      # æ§UŒ‚ƒtƒ‰ƒO‚ğƒNƒŠƒA      
      $game_temp.first_attack_flag = 0
      @actor_first_attack = true
      @enemy_first_attack = false
      # ƒXƒe[ƒ^ƒXƒEƒBƒ“ƒhƒE‚ğƒŠƒtƒŒƒbƒVƒ…
      @status_window.refresh
      ## ƒXƒeƒbƒv 103 ‚ÉˆÚs
      #@phase4_step = 103
      # ƒXƒeƒbƒv 105 ‚ÉˆÚs
      @phase4_step = 105
    else
      # ƒAƒjƒ[ƒVƒ‡ƒ“ ID ‚¨‚æ‚ÑƒRƒ‚ƒ“ƒCƒxƒ“ƒg ID ‚ğ‰Šú‰»
      @animation1_id = 0
      @animation2_id = 0
      @common_event_id = 0
      # –¢s“®ƒoƒgƒ‰[”z—ñ‚Ìæ“ª‚©‚çƒVƒtƒg
      @active_battler = @action_battlers.shift
      # ‚·‚Å‚Éí“¬‚©‚çŠO‚³‚ê‚Ä‚¢‚éê‡i‰B‚êƒGƒlƒ~[‚àŠÜ‚Şj
      if @active_battler.index == nil or @active_battler.hidden
        return
      end
      # šƒAƒNƒeƒBƒuƒoƒgƒ‰[‚Ìî•ñ‚ğ‹L‰¯@¦ƒRƒ‚ƒ“ƒCƒxƒ“ƒg‚Åg‚¢‚Ü‚·B
      $game_temp.battle_active_battler = @active_battler

=begin
      # šƒGƒlƒ~[‚Ì•\¦ó‘Ô‚Ì•ÏX
      enemies_display(@active_battler) if @active_battler.is_a?(Game_Enemy)
=end
      # šƒGƒlƒ~[‚Ìê‡
      enemy_skill = @active_battler.current_action.skill_id
      if @active_battler.is_a?(Game_Enemy) and enemy_skill != nil
        if @active_battler.another_action
          # s“®“ñ‰ñ–Ú‚È‚çƒAƒNƒVƒ‡ƒ“‹­§ƒtƒ‰ƒO‚ğŠO‚·
          @active_battler.current_action.forcing = false
        end
        if not @active_battler.current_action.forcing
          # ƒGƒlƒ~[s“®§Œä—pƒXƒCƒbƒ`‚ğŠm”F‚µAÄ“xƒAƒNƒVƒ‡ƒ“‘I‘ğ
          enemy_action_swicthes(@active_battler)
          @active_battler.make_action
        end
      end
      
      # ƒXƒŠƒbƒvƒ_ƒ[ƒW
      if @active_battler.hp > 0 and @active_battler.slip_damage?
        @active_battler.slip_damage_effect
        @active_battler.damage_pop = true
      end
      
      #p "1b" if $debug_flag == 1
      # ‘Sƒoƒgƒ‰[‚ÌƒXƒe[ƒgƒƒO‚ğ‚·‚×‚ÄƒNƒŠƒA
      for battler in @battlers
        battler.add_states_log.clear
        battler.remove_states_log.clear
      end
      # ƒƒbƒZ[ƒWƒ^ƒO‚ğƒNƒŠƒA
      $msg.tag = ""
      
      # ƒoƒbƒNƒƒO‚É‰üsw’è‚ğ’Ç‰Á
#      $game_temp.battle_back_log += "\"

      # ƒXƒe[ƒ^ƒXƒEƒBƒ“ƒhƒE‚ğƒŠƒtƒŒƒbƒVƒ…
      @status_window.refresh
      # ƒXƒeƒbƒv 2 ‚ÉˆÚs
      @phase4_step = 2
    end
  end
  #--------------------------------------------------------------------------
  # œ ƒtƒŒ[ƒ€XV (ƒƒCƒ“ƒtƒF[ƒY ƒXƒeƒbƒv 11 : ƒ^[ƒ“I—¹)
  #--------------------------------------------------------------------------
  def update_phase4_step103
    # šƒoƒgƒ‹ƒƒOƒEƒBƒ“ƒhƒE‚ğÁ‚·
    @battle_log_window.visible = false
    @battle_log_window.bgframe_sprite.visible = false

    @status_window.refresh
    # ƒp[ƒeƒBƒRƒ}ƒ“ƒhƒtƒF[ƒYŠJn
    start_phase2
  end
  
  #--------------------------------------------------------------------------
  # œ ƒtƒŒ[ƒ€XV (ƒƒCƒ“ƒtƒF[ƒY ƒXƒeƒbƒv 2 : ƒAƒNƒVƒ‡ƒ“ŠJn)
  #--------------------------------------------------------------------------
  def update_phase4_step2
    
    # ƒoƒgƒ‹ƒƒO‚ğƒNƒŠƒA
    @battle_log_window.contents.clear
    @battle_log_window.keep_flag = false
    $game_temp.battle_log_text = ""
    # Šeƒoƒgƒ‰[‚Éƒz[ƒ‹ƒhó‹µ‚ğ‹L˜^
    hold_record
#    p "s“®4-2F#{@active_battler.name}/‘ÎÛindexF#{@active_battler.current_action.target_index}"if $DEBUG
    
    #p "2a" if $debug_flag == 1
    # šƒAƒNƒeƒBƒuƒoƒgƒ‰[‚Ìî•ñ‚ğ‹L‰¯@¦ƒRƒ‚ƒ“ƒCƒxƒ“ƒg‚Åg‚¢‚Ü‚·B
    $game_temp.battle_active_battler = @active_battler
    # ‹­§ƒAƒNƒVƒ‡ƒ“‚Å‚È‚¯‚ê‚Î
    unless @active_battler.current_action.forcing
      # §–ñ‚ª [“G‚ğ’ÊíUŒ‚‚·‚é] ‚© [–¡•û‚ğ’ÊíUŒ‚‚·‚é] ‚Ìê‡
      if @active_battler.restriction == 2 or @active_battler.restriction == 3
        # ƒAƒNƒVƒ‡ƒ“‚ÉUŒ‚‚ğİ’è
        @active_battler.current_action.kind = 0
        @active_battler.current_action.basic = 0
        # œ‹L‰¯‚µ‚½ƒXƒLƒ‹‚ğ‰ğœ
        $game_temp.skill_selection = nil
      end
      # §–ñ‚ª [s“®‚Å‚«‚È‚¢] ‚Ìê‡
      if @active_battler.restriction == 4
        #s“®‚Å‚«‚È‚¢Œ´ˆö‚ª–\‘–‚Ìê‡Aƒ‰ƒ“ƒ_ƒ€s“®ƒXƒLƒ‹‚ğ‘•“U
        if @active_battler.berserk == true
          @active_battler.current_action.kind = 1
          @active_battler.current_action.forcing = true
          @active_battler.current_action.skill_id = 296
          if @active_battler.is_a?(Game_Enemy)
            @active_battler.current_action.decide_random_target_for_enemy
          elsif @active_battler.is_a?(Game_Actor)
            @active_battler.current_action.decide_random_target_for_actor
          end
          @active_battler.another_action = false
        #–\‘–ˆÈŠO‚Ìê‡Aƒoƒgƒ‰[‚ğƒNƒŠƒA‚·‚é
        else
          # ƒAƒNƒVƒ‡ƒ“‹­§‘ÎÛ‚Ìƒoƒgƒ‰[‚ğƒNƒŠƒA
          $game_temp.forcing_battler = nil
          # ƒXƒeƒbƒv 1 ‚ÉˆÚs
          @phase4_step = 1
          # œ‹L‰¯‚µ‚½ƒXƒLƒ‹‚ğ‰ğœ
          $game_temp.skill_selection = nil
          return
        end
      end
    end
    # ‘ÎÛƒoƒgƒ‰[‚ğƒNƒŠƒA
    @target_battlers = []
    # ƒAƒNƒVƒ‡ƒ“‚Ìí•Ê‚Å•ªŠò
    case @active_battler.current_action.kind
    when 0  # Šî–{
      make_basic_action_result
    when 1  # ƒXƒLƒ‹
      make_skill_action_result
    when 2  # ƒAƒCƒeƒ€
      make_item_action_result
    end
    #p "2b" if $debug_flag == 1
    
    # ƒXƒeƒbƒv 3 ‚ÉˆÚs
    if @phase4_step == 2
      @phase4_step = 3
    end
  end
  #--------------------------------------------------------------------------
  # œ ƒtƒŒ[ƒ€XV (ƒƒCƒ“ƒtƒF[ƒY ƒXƒeƒbƒv 3 : s“®‘¤ƒAƒjƒ[ƒVƒ‡ƒ“)
  #--------------------------------------------------------------------------
  def update_phase4_step3
    #p "3a" if $debug_flag == 1
    # ƒoƒgƒ‹ƒƒO‚ğƒNƒŠƒA
    @battle_log_window.contents.clear
    @battle_log_window.keep_flag = false
    $game_temp.battle_log_text = ""
    # s“®‘¤ƒAƒjƒ[ƒVƒ‡ƒ“ (ID ‚ª 0 ‚Ìê‡‚Í”’ƒtƒ‰ƒbƒVƒ…)
    if @animation1_id == 0
      @active_battler.white_flash = true
    else
      @active_battler.animation_id = @animation1_id
      @active_battler.animation_hit = true
    end
    # šƒoƒgƒ‹ƒƒO‚ğ•\¦
    case @active_battler.current_action.kind
    when 1  #ƒXƒLƒ‹
      @active_battler.bms_useskill(@skill)
    when 2  #ƒAƒCƒeƒ€
      @active_battler.bms_useitem(@item)
    end
    
    # ¡ƒRƒ}ƒ“ƒh“Š‡ 
    #------------------------------------------------------
    case @active_battler.current_action.kind
    when 1 #ƒXƒLƒ‹‚Ìê‡
      command = @skill
    when 2 #ƒAƒCƒeƒ€‚Ìê‡
      command = @item
    end
    # šƒGƒlƒ~[‚Ì•\¦ó‘Ô‚Ì•ÏXi‘ÎÛ‚ª‘S‘Ì‚Ìê‡‚Í•ÏX–³‚µj
    # iƒ^[ƒQƒbƒg‚àƒAƒNƒeƒBƒu‚àƒGƒlƒ~[‚Ìê‡A‚±‚±‚Å•\¦ƒGƒlƒ~[‚ğ—\–ñ‚µA
    # @s“®ƒƒbƒZ[ƒW‚ÌI—¹Œã‚É•\¦‚³‚¹‚éj
    if @target_battlers[0].is_a?(Game_Enemy) and @active_battler.is_a?(Game_Enemy) \
     and command.scope != 2 and command.scope != 4 
      @display_order_enemy = @target_battlers[0]
    end
    
    # ¡ƒŒƒWƒXƒgƒXƒLƒ‹‚Ìê‡
    if @active_battler.current_action.kind == 1
      #ƒz[ƒ‹ƒh(6)A—U˜f(7)A•¨—(8)ƒŒƒWƒXƒg‚Ì‚¢‚¸‚ê‚©‚Ì‘®«‚ª‚ ‚éê‡‚Íê—pˆ—‚ÉˆÚ“®
      if @skill.element_set.include?(6) or @skill.element_set.include?(7) or @skill.element_set.include?(8)
        # ‘ÎÛ‚É‚«o‚µƒAƒjƒ[ƒVƒ‡ƒ“‚ğ‚Â‚¯‚é
        unless @skill.id == 10
          @target_battlers[0].animation_id = 109
          @target_battlers[0].animation_hit = true
        end
        # ƒŒƒWƒXƒgƒXƒLƒ‹‚Ìî•ñ‚ğ‹L˜^
        $game_temp.resist_skill = @skill
        # ƒEƒFƒCƒg‚ğ“ü‚ê‚Ä 12 ‚ÉˆÚs
        @phase4_step = 12
        return
      end
    end
    # ƒŒƒWƒXƒgƒXƒLƒ‹‚Å‚È‚¢ê‡AƒXƒeƒbƒv 4 ‚ÉˆÚs
    @phase4_step = 4
#œ    @wait_count = 8 #ƒEƒFƒCƒgŠO‚µ‚Äƒeƒ“ƒ|ƒAƒbƒv
  end
  #--------------------------------------------------------------------------
  # œ ƒtƒŒ[ƒ€XV (ƒƒCƒ“ƒtƒF[ƒY ƒXƒeƒbƒv 4 : ƒŒƒWƒXƒgˆ—)
  #--------------------------------------------------------------------------
  def update_phase4_step12
    # --------------------------------------------------------------
    @battle_log_window.contents.clear
    @battle_log_window.keep_flag = false
    $game_temp.battle_log_text = ""
    # ƒRƒ‚ƒ“ƒCƒxƒ“ƒg‚ğ‹²‚ñ‚ÅƒŒƒWƒXƒg‘O‚Ì‰ï˜b‚ğ•\¦
    common_event = $data_common_events[31]
    $game_system.battle_interpreter.setup(common_event.list, 0)
    @wait_count = 10
    battle_resist
    # ƒXƒeƒbƒv 4 ‚ÉˆÚs
    @phase4_step = 13
  end  
  #--------------------------------------------------------------------------
  # œ ƒtƒŒ[ƒ€XV (ƒƒCƒ“ƒtƒF[ƒY ƒXƒeƒbƒv 4 : ƒŒƒWƒXƒgŒ‹‰Êì¬)
  #--------------------------------------------------------------------------
  def update_phase4_step13
    @battle_log_window.contents.clear
    @battle_log_window.keep_flag = false
    $game_temp.battle_log_text = ""
#œ    @wait_count = 30
    @add_hold_flag = false
    for target in @target_battlers
      # ‘ÎÛ‚ªƒGƒlƒ~[‚Ìê‡
      if target.is_a?(Game_Enemy)
        # ¬Œ÷
        if $game_temp.resistgame_clear == true
          @resist_flag = true
          @hold_shake = true
          #ƒŒƒWƒXƒgƒJƒEƒ“ƒg‚ğ‚O‚É‚·‚é
          target.resist_count = 0
          #¬Œ÷‚Ìƒg[ƒNƒXƒeƒbƒv(‚Q)‚Éİ’è
          $msg.talk_step = 2
          # ¡•‚ğ’E‚ª‚·
          if @skill.element_set.include?(36)
            target.undress
            $game_temp.battle_log_text += target.bms_states_update
          # ¡ƒz[ƒ‹ƒh•t—^
          elsif @skill.element_set.include?(6)
#            add_hold(@skill, @active_battler, target)
            @add_hold_flag = true
            hold_effect(@skill, @active_battler, target)
          # ‚»‚Ì‘¼
          else
            $game_temp.battle_log_text += "Resist Successful\\" 
          end
        # ¸”s
        else
          @resist_flag = false
          @hold_shake = false
          #¸”s‚Ìƒg[ƒNƒXƒeƒbƒv(‚R)‚Éİ’è
          $msg.talk_step = 3
          #ó‚¯“ü‚ê‚½ê‡‚ÍSE‚ğ–Â‚ç‚³‚¸AƒŒƒWƒXƒgƒJƒEƒ“ƒg‚ğã‚°‚È‚¢
          if $game_switches[89]
            $game_temp.battle_log_text += @active_battler.name + " gave up!\\"
          else
          # ”ğ‚¯‚éSE‚ğ–Â‚ç‚µA‘ÎÛ‚ÌƒŒƒWƒXƒgƒJƒEƒ“ƒg‚ğ{‚P‚·‚é
            Audio.se_play("Audio/SE/063-Swing02", 80, 100)
            $game_temp.battle_log_text += target.name + " resisted it!\\"
            target.resist_count += 1
          end
          if @skill.element_set.include?(6)
            @hold_shake = false
            hold_effect(@skill, @active_battler, target)
          end
          #¥ƒVƒXƒeƒ€ƒEƒFƒCƒg
          case $game_system.ms_skip_mode
          when 3 #è“®‘—‚èƒ‚[ƒh
            @wait_count = 1
          when 2 #ƒfƒoƒbƒOƒ‚[ƒh
            @wait_count = 8
          when 1 #‰õ‘¬ƒ‚[ƒh
            @wait_count = 12
          else
            # ‚±‚±‚Í­‚µ‚¾‚¯ƒEƒFƒCƒg‚ğ‘‚â‚·
            @wait_count = $game_system.battle_speed_time(0) + 2
          end
        end
      # ‘ÎÛ‚ªƒAƒNƒ^[‚Ìê‡
      else  
        # ¬Œ÷
        if $game_temp.resistgame_clear == true
          @resist_flag = true
          #¬Œ÷‚Ìƒg[ƒNƒXƒeƒbƒv(‚Q)‚Éİ’è
          $msg.talk_step = 2
          # ”ğ‚¯‚éSE‚ğ–Â‚ç‚µA‘ÎÛ‚ÌƒŒƒWƒXƒgƒJƒEƒ“ƒg‚ğ{‚P‚·‚é
          Audio.se_play("Audio/SE/063-Swing02", 80, 100)
          $game_temp.battle_log_text += target.name + " resisted it!\\"
          target.resist_count += 1
          if @skill.element_set.include?(6)
            @hold_shake = false
            hold_effect(@skill, @active_battler, target)
          end
          #¥ƒVƒXƒeƒ€ƒEƒFƒCƒg
          case $game_system.ms_skip_mode
          when 3 #è“®‘—‚èƒ‚[ƒh
            @wait_count = 1
          when 2 #ƒfƒoƒbƒOƒ‚[ƒh
            @wait_count = 8
          when 1 #‰õ‘¬ƒ‚[ƒh
            @wait_count = 12
          else
            # ‚±‚±‚Í­‚µ‚¾‚¯ƒEƒFƒCƒg‚ğ‘‚â‚·
            @wait_count = $game_system.battle_speed_time(0) + 2
          end
        # ¸”s
        else
          @resist_flag = false
          #ƒŒƒWƒXƒgƒJƒEƒ“ƒg‚ğ‚O‚É‚·‚é
          target.resist_count = 0
          @hold_shake = true
          #¸”s‚Ìƒg[ƒNƒXƒeƒbƒv(‚R)‚Éİ’è
          $msg.talk_step = 3
          # ¡•‚ğ’E‚ª‚·
          if @skill.element_set.include?(36)
            # ’EˆßƒAƒjƒ[ƒVƒ‡ƒ“‚ğ‚Â‚¯‚é
              target.animation_id = 104
              target.animation_hit = true
              target.undress
              $game_temp.battle_log_text += target.bms_states_update
          # ¡ƒz[ƒ‹ƒh•t—^
          elsif @skill.element_set.include?(6)
#            add_hold(@skill, @active_battler, target)
            @add_hold_flag = true
            hold_effect(@skill, @active_battler, target)
          # ‚»‚Ì‘¼
          else
            $game_temp.battle_log_text += "Failed to resist.\\" 
          end
        end
      end
      # ‰æ‘œ•ÏX
      @active_battler.graphic_change = true
      target.graphic_change = true
    end
    # ƒXƒe[ƒ^ƒX‚ÌƒŠƒtƒŒƒbƒVƒ…
    @status_window.refresh
    # ƒXƒeƒbƒv 4 ‚ÉˆÚs
    @phase4_step = 4
  end  
  #--------------------------------------------------------------------------
  # œ ƒtƒŒ[ƒ€XV (ƒƒCƒ“ƒtƒF[ƒY ƒXƒeƒbƒv 4 : ‘ÎÛ‘¤ƒAƒjƒ[ƒVƒ‡ƒ“)
  #--------------------------------------------------------------------------
  def update_phase4_step4
    
    # Šeí€–Ú‚ğƒNƒŠƒA
    @ecstasy_check = false
    @ecstasy_check_self = false
    text1 = ""
    text2 = ""
    text3 = ""
    # ¡ƒRƒ}ƒ“ƒh“Š‡ 
    #------------------------------------------------------
    case @active_battler.current_action.kind
    when 1 #ƒXƒLƒ‹‚Ìê‡
      @command = @skill
      @command = $data_skills[@active_battler.current_action.skill_id] unless @command.is_a?(RPG::Skill)
    when 2 #ƒAƒCƒeƒ€‚Ìê‡
      @command = @item
      @command = $data_items[@active_battler.current_action.item_id] unless @command.is_a?(RPG::Item)
    end
    
    # @command‚ÉƒXƒLƒ‹‚Ü‚½‚ÍƒAƒCƒeƒ€î•ñ‚ª“ü‚Á‚Ä‚¢‚È‚¢ê‡
    unless @command.is_a?(RPG::Skill) or @command.is_a?(RPG::Item)
      if $DEBUG
        debug_text = ""
        debug_text += "@command‚ÉƒXƒLƒ‹‚Ü‚½‚ÍƒAƒCƒeƒ€ˆÈŠO‚Ìî•ñ‚ª“ü‚Á‚Ä‚¢‚Ü‚·B\n"
        debug_text += "‚±‚Ì‚Ü‚Ü“®ì‚µ‚Ü‚·‚ªAƒGƒ‰[‚É‚È‚éŠm—¦‚ª‚‚¢‚Å‚·B\n"
        debug_text += "@commandF#{@command}"
        Audio.se_play("Audio/SE/069-Animal04", 80, 100)
        print debug_text
      end
    end

=begin
    # šƒGƒlƒ~[‚Ì•\¦ó‘Ô‚Ì•ÏXi‘ÎÛ‚ª‘S‘Ì‚Ìê‡‚Í•ÏX–³‚µj
    if @target_battlers[0].is_a?(Game_Enemy) \
     and @command.scope != 2 and @command.scope != 4 
      enemies_display(@target_battlers[0])
    end
=end
    # œˆ—ŠJn
    for target in @target_battlers
      #------------------------------------------------------
      # ‘ÎÛ‘¤ƒAƒjƒ[ƒVƒ‡ƒ“
      target.animation_id = @animation2_id
      target.animation_hit = (target.damage != "Miss")
      # ƒ€[ƒhƒAƒbƒvˆ—
      #------------------------------------------------------
      # ƒ€[ƒhƒAƒbƒv¬
      if @command.element_set.include?(20)
        $mood.rise(1)
      # ƒ€[ƒhƒAƒbƒv’†
      elsif @command.element_set.include?(21)
        $mood.rise(4)
      # ƒ€[ƒhƒAƒbƒv‘å
      elsif @command.element_set.include?(22)
        $mood.rise(10)
      end
      # ƒVƒFƒCƒNˆ—(ƒz[ƒ‹ƒhˆ—‚ÅƒVƒFƒCƒN‚³‚¹‚½ê‡‚Í”ò‚Î‚·)
      #------------------------------------------------------
      # ƒsƒXƒgƒ“Œn
      if @hold_shake == nil
        if @command.element_set.include?(37)
          # ‰æ–Ê‚ÌcƒVƒFƒCƒN
          $game_screen.start_flash(Color.new(255,210,225,220), 8)
          $game_screen.start_shake2(7, 15, 15)
        # ƒOƒ‰ƒCƒ“ƒhŒn
        elsif @command.element_set.include?(38)
          # ‰æ–Ê‚Ì‰¡ƒVƒFƒCƒN
          $game_screen.start_flash(Color.new(255,210,225,220), 8)
          $game_screen.start_shake(7, 15, 15)
        end
      else
        #ƒz[ƒ‹ƒh‚ÅƒVƒFƒCƒNˆ—‚ğs‚Á‚½ê‡A‚±‚±‚Ånil‚É–ß‚·
        @hold_shake = nil
      end
      #======================================================================================
      # ƒ_ƒ[ƒW‚ª‚ ‚éê‡      
      #======================================================================================
      if target.damage != nil
        skill_result = state_result = ""
        target.damage_pop = true
        #======================================================================================
        # ¡UŒ‚‚ğ–½’†‚³‚¹‚Ä‚¢‚é
        #======================================================================================
        if target.damage != "Miss"
          #************************************************************************
          # ¥uƒ_ƒ[ƒW–³‚µƒXƒLƒ‹v‚Å‚Í‚È‚¢ê‡
          #************************************************************************
          if not @command.element_set.include?(17)
            #œƒXƒLƒ‹ƒeƒLƒXƒgŒÄ‚Ño‚µ
            if @active_battler.current_action.kind == 1
              skill_result = target.bms_skill_effect(@skill)
            #œƒAƒCƒeƒ€ƒeƒLƒXƒgŒÄ‚Ño‚µ
            elsif @active_battler.current_action.kind == 2
              skill_result = target.bms_item_effect(@item)
            end
            state_result = target.bms_states_update
            state_result2 = @active_battler.bms_states_update
            #œƒeƒLƒXƒg®Œ`
            #¤ƒXƒLƒ‹ƒeƒLƒXƒg‚ª‚ ‚é‚È‚ç‘}“ü
            text1 += skill_result if skill_result != ""
            #¤‘ÎÛ‚ÌƒXƒe[ƒgƒeƒLƒXƒg‚ª‚ ‚é‚È‚ç‘}“ü
            text1 += "\\" + state_result if state_result != ""
            #¤©g‚ÌƒXƒe[ƒgƒeƒLƒXƒg‚ª‚ ‚é‚È‚ç‘}“ü
            text1 += "\\" + state_result2 if state_result2 != ""
            #¤ƒeƒLƒXƒg‚ª‘¶İ‚·‚é‚È‚çAÅŒã‚É‰üs‚ğ‘}“ü
            text1 += "\\" if text1 != ""
            #------------------------------------------------------
            # œ‘¡‚è•¨ƒAƒCƒeƒ€‚Ìê‡A—FD“x‚É‰‚¶‚ÄƒAƒjƒ[ƒVƒ‡ƒ“‚ğw¦
            #------------------------------------------------------
            if target.is_a?(Game_Enemy) and @command.element_set.include?(199)
              target.friendly_animation_order
            end
            #------------------------------------------------------
            # œƒŠƒoƒEƒ“ƒh‚ª”­¶‚·‚éƒXƒLƒ‹‚Å‚ ‚éê‡‚ÍZo
            #------------------------------------------------------
            if @command.element_set.include?(31) or @command.element_set.include?(32)
              @active_rebound_flag = false
              rebound = (target.damage * (5 + ($mood.point / 10).floor) / 100).floor
              rebound = (rebound / 2).round if @command.element_set.include?(31) #ƒŠƒoƒEƒ“ƒh­
              # ”½“®ƒ_ƒ[ƒW‚Å‚g‚o‚ª‚OˆÈ‰º‚É‚È‚éê‡‚Í‚P‚ğc‚·(¡‚Ì‚Æ‚±‚ë)
              rebound = 0 if @active_battler.hp == 1
              rebound = @active_battler.hp - 1 if @active_battler.hp <= rebound
              # ÀÛ‚ÉEP‚ğŒ¸Z
              @active_battler.hp -= rebound
              # ƒoƒgƒ‹ƒƒO‚ğ•\¦(ƒŠƒoƒEƒ“ƒh‚ª”­¶‚µ‚È‚¢ê‡‚Í•\¦‚µ‚È‚¢j
              text3 += "\" + @active_battler.name + " took " + rebound.to_s + " rebound pleasure!\" if rebound > 0
              if @active_battler.hp > 0 and not @active_battler.state?(6)
                if @active_battler.hpp <= $mood.crisis_point(@active_battler) + rand(5)
                  @active_rebound_flag = true
                  @active_battler.add_state(6)
                  text3 += @active_battler.bms_states_update + "\\"
                end
              end
              # ‰æ‘œ•ÏX
              @active_battler.graphic_change = true
            end
            #------------------------------------------------------
            # œ‹z¸‚ª”­¶‚·‚éƒXƒLƒ‹‚Å‚ ‚éê‡‚ÍZo
            #------------------------------------------------------
            if @command.element_set.include?(198)
              # ‹zû’l‚ğZo‚µA‹zûˆ—
              vp_drain = (target.damage * (10 + ($mood.point / 5).floor) / 100).floor
              if vp_drain > 0
                target.sp -= vp_drain
                @active_battler.sp += vp_drain
                text3 += "\" + @active_battler.name + " had " + vp_drain.to_s + " energy absorbed!\\"
                if target.sp <= 0
                  target.sp_down_flag = true
                end
                # ‹z¸‚µ‚½‚È‚çƒAƒjƒ‚ğ•t‚¯‚é
                @active_battler.animation_id = 168
                @active_battler.animation_hit = (target.damage != "Miss")
              end
            end
            #------------------------------------------------------
            # œƒŒƒxƒ‹ƒhƒŒƒCƒ“‚ª”­¶‚·‚éƒXƒLƒ‹‚Å‚ ‚éê‡‚ÍZo
            #------------------------------------------------------
            if @command.element_set.include?(202)
              if target.level > 1
                target.level -= 1
                text3 += "\" + "#{target.name} became Lv.#{target.level.to_s}!"
                # g—pÒ‚ÉƒXƒgƒŒƒŠƒuƒ‹ƒ€‚Ì‹­‰»€–Ú‚ğ’Ê‚·
                level_drain_text = ""
#                @active_battler.capacity_alteration_effect($data_skills[195])
#                level_drain_text = @active_battler.bms_states_update
                level_drain_text += special_status_check(@active_battler,[195])
#               
                # ƒeƒLƒXƒg‚ª‚ ‚é‚È‚ç‚»‚±‚ğ’Ê‚·
#                if level_drain_text != "" and level_drain_text != "‚µ‚©‚µ#{@active_battler.name}‚É‚ÍŒø‰Ê‚ª–³‚©‚Á‚½I"
                  text3 += level_drain_text + "\\"
#                end
                # ‹zû‚µ‚½‚È‚çƒAƒjƒ‚ğ•t‚¯‚é
                @active_battler.animation_id = 168
                @active_battler.animation_hit = (target.damage != "Miss")
              end
            end
            #------------------------------------------------------
            # œÅ‚ç‚µƒXƒCƒbƒ`‚ª“ü‚Á‚Ä‚¢‚éê‡AÅŒã‚ÉƒiƒŒ[ƒg‚ğ’Ç‰Á
            #------------------------------------------------------
            if $game_switches[82] == true
              brk = ""
              brk = "A\n\" if SR_Util.names_over?(@active_battler.name,$game_temp.battle_target_battler[0].name)
              #ƒeƒB[ƒY‚Ìê‡AƒXƒCƒbƒ`‚ğ‘¦‰ğœ‚·‚é
              if @active_battler.is_a?(Game_Actor) and @command.id == 101
                text3 += "\" + @active_battler.name + "‚Í#{brk}#{$game_temp.battle_target_battler[0].name}‚ğÅ‚ç‚µ‚Ä‚¢‚éI\\"
              #–²–‚‚©‚ç‚ÌÅ‚ç‚µUŒ‚‚ğH‚ç‚Á‚½ê‡AƒXƒCƒbƒ`‚ğ‘¦‰ğœ‚·‚é
              elsif @active_battler.is_a?(Game_Enemy)
                text3 += "\" + @active_battler.name + "‚Í#{brk}#{$game_temp.battle_target_battler[0].name}‚ğÅ‚ç‚µ‚Ä‚¢‚éI\\"
              end
              $game_switches[82] = false
            end
            #------------------------------------------------------
            # œg—pÒ‚ª–¡•û‚Åy“´@—Íz‚¿‚Ìê‡
            #------------------------------------------------------
            if @active_battler.is_a?(Game_Actor) and @active_battler.have_ability?("“´@—Í")
              brk = ""
              brk = "A\n\" if SR_Util.names_over?(@active_battler.name, $game_temp.battle_target_battler[0].name, 16)
              # ‘ÎÛ‚ª“G‚ÅAƒ`ƒFƒbƒNƒtƒ‰ƒO‚ª‚P–¢–‚ÌA‚P‚É‚µ‚ÄƒiƒŒ[ƒg‚ğo‚·
              if target.is_a?(Game_Enemy) and target.checking < 1
                target.checking = 1
                text3 += "\" + @active_battler.name + " examined #{brk}#{$game_temp.battle_target_battler[0].name}!\\"
              end
            end
            #------------------------------------------------------
            # œƒxƒXƒgƒGƒ“ƒhí‚Ìƒ”ƒFƒ‹ƒ~ƒB[ƒi‚ª–{‹C‚ğo‚·ê‡
            #------------------------------------------------------
            if @troop_id == 603
              # ‘ÎÛ‚ªƒ”ƒFƒ‹ƒ~ƒB[ƒiŠ‚ÂAƒ”ƒFƒ‹ƒ~ƒB[ƒi‚ª‚Ü‚¾–{‹Có‘Ô‚Å–³‚¢Š‚Â
              # ‚u‚o‚ª1000ˆÈ‰ºŠ‚ÂAâ’¸ˆÛ’†‚Å‚È‚¢ê‡
              if target == $game_troop.enemies[0] and not $game_troop.enemies[0].earnest and
               $game_troop.enemies[0].sp <= 1200 and not $game_troop.enemies[0].weaken?
                # ƒCƒxƒ“ƒg‚ğ€”õiƒXƒeƒbƒv‚U‚ÅƒCƒxƒ“ƒgƒZƒbƒgƒAƒbƒvj
                @common_event_id = 119
              end
            end
          #************************************************************************
          # ¥uƒXƒe[ƒg•t—^ƒXƒLƒ‹v‚Ìê‡
          #************************************************************************
          elsif @command.element_set.include?(33)
            #‘ÎÛ‚ÌƒXƒe[ƒg‚©‚çƒXƒe[ƒgƒŠƒUƒ‹ƒg‚ğŒÄ‚Ño‚·
            state_result = target.bms_states_update
            if state_result != "" #•t—^ƒXƒe[ƒg‚ª‚ ‚éê‡
              text1 += state_result + "\\"
            elsif state_result == "" #•t—^ƒXƒe[ƒg‚ª–³‚¢ê‡
              text1 += ""
            else
              text1 += state_result + "\\"
            end
            # ‹­‰»E’á‰º–‚–@ŠÖ˜Aˆ—
            for i in 80..87
              target.remove_state(i) if target.states.include?(i)
            end
          #************************************************************************
          # ¥u‰‰oƒXƒLƒ‹v‚Ìê‡
          #************************************************************************
          elsif @command.element_set.include?(200)
            text1 = target.bms_direction_skill_effect(@skill)
          end
        #======================================================================================
        # ¡UŒ‚‚ğŠO‚µ‚Ä‚¢‚é
        #======================================================================================
        elsif target.damage == "Miss"
          #************************************************************************
          # ¥uƒXƒe[ƒg•t—^ƒXƒLƒ‹v‚Ìê‡
          #************************************************************************
          if @command.element_set.include?(33)
            # œƒoƒbƒhƒXƒe[ƒg•t—^–‚–@‚Ìê‡(Šù‚É•t—^‚³‚ê‚Ä‚¢‚éê‡–³Œø‰»‚³‚ê‚é)
            bs = 0
            for i in SR_Util.checking_states
              if $data_skills[@skill.id].plus_state_set.include?(i) and target.states.include?(i)
                text1 += "‚go‚—ever " + target.name + " cannot be effected ‚ore than this!\\"
                bs = 1
                break
              end
            end
            if bs == 0
              skill_result = target.bms_skill_effect(@skill)
              text1 += skill_result + "\\"
            end
          #************************************************************************
          # ¥u‘¡‚è•¨ƒAƒCƒeƒ€v‚Ìê‡A‘¡‚è•¨ƒAƒCƒeƒ€‚Ì¸”s‚ğ•\¦
          #************************************************************************
          elsif target.is_a?(Game_Enemy) and @command.element_set.include?(199) and
            skill_result = target.bms_item_effect(@item)
            text1 += skill_result + "\\"
          #************************************************************************
          # ¥uƒ_ƒ[ƒW–³‚µƒXƒLƒ‹v‚Å‚Í‚È‚¢ê‡
          #************************************************************************
          elsif not @command.element_set.include?(17)
#          else
#            # ƒ~ƒX‚µ‚½ê‡‚Í”ğ‚¯‚éSE‚ğ–Â‚ç‚·
#            Audio.se_play("Audio/SE/063-Swing02", 80, 100)
            $game_temp.battle_log_text += "\" + target.name + " was not effected!\"
          end
        end
        #======================================================================================
        # ¡“Áê
        #======================================================================================
        #************************************************************************
        # ¥w•‚ğ’E‚®xŒnˆ—
        #************************************************************************
        if @command.element_set.include?(35)
          # ƒ_ƒ[ƒWƒiƒŒ[ƒgŒã‚ÉŒûã‚ğo‚·ƒtƒ‰ƒO‚ğ“ü‚ê‚é
          $game_switches[90] = true
          #œƒGƒlƒ~[‘¤‚Ì‹““®
          if target.is_a?(Game_Enemy)
            $msg.tag = "–²–‚‚ª’‡ŠÔ–²–‚‚ğ’Eˆß"
            $msg.tag = "–²–‚‚ª©‚ç’Eˆß" if @active_battler == target
            #–²–‚‘¤‚Ì’EˆßŒûãŠÇ—‚ÍålŒö•”•ª‚ÅˆêŠ‡‚Ås‚¤
            $msg.callsign = 7
            $msg.callsign = 17 if $game_switches[85] == true
            target.undress
            #‘ÎÛ‚ÌƒXƒe[ƒgó‹µ‚ğƒeƒLƒXƒg‚ÉŠi”[
            text1 += target.bms_states_update + "\\"
          #œƒAƒNƒ^[‘¤‚Ì‹““®
          else
            #ålŒö
            if target == $game_actors[101]
              if @active_battler != target
                $msg.tag = "ƒp[ƒgƒi[‚ªålŒö‚ğ’Eˆß"
                $msg.callsign = 27
                $msg.callsign = 37 if $game_switches[85] == true
              else
                $msg.tag = "ålŒö‚ª©‚ç’Eˆß"
                $msg.callsign = 7
                $msg.callsign = 17 if $game_switches[85] == true
              end
            #ƒp[ƒgƒi[
            else
              if @active_battler != target
                $msg.tag = "ålŒö‚ªƒp[ƒgƒi[‚ğ’Eˆß"
                $msg.callsign = 7
                $msg.callsign = 17 if $game_switches[85] == true
              else
                $msg.tag = "ƒp[ƒgƒi[‚ª©‚ç’Eˆß"
                $msg.callsign = 27
                $msg.callsign = 37 if $game_switches[85] == true
              end
            end
            target.animation_id = 104
            target.animation_hit = true
            target.undress
            text1 += target.bms_states_update + "\\"
          end
        end
        #************************************************************************
        # ¥ƒXƒ‰ƒCƒ€‚Ì’…’EˆßŒnˆ—
        #************************************************************************
        #œ”S‰tÄ¶
        if @command.name == "ƒŒƒXƒgƒŒ[ƒVƒ‡ƒ“"
          target.animation_id = 89
          target.animation_hit = true
          target.dress
        #œ”S‰t“ŠË
        elsif @command.name == "ƒXƒ‰ƒCƒ~[ƒŠƒLƒbƒh"
          target.animation_id = 90
          target.animation_hit = true
          @active_battler.undress
          text1 += @active_battler.bms_states_update + "\\"
          @active_battler.graphic_change = true
        end
        #************************************************************************
        # ¥ƒCƒjƒVƒAƒ`ƒu•ÏXŒn
        #************************************************************************
        if @command.element_set.include?(207)
          text1 += "#{@active_battler.name}‚Íå“±Œ ‚ğæ‚è–ß‚µ‚½I\\"
        end
        #************************************************************************
        # ¥ƒCƒ“ƒZƒ“ƒX‘S‚Äíœ
        #************************************************************************
        if @command.element_set.include?(213)
          delete_flag = $incense.delete_incense_all
          if delete_flag
            text1 += "ê‚ÉŠ|‚©‚Á‚Ä‚¢‚éŒø‰Ê‚ª‚·‚×‚Ä–³‚­‚È‚Á‚½I\\"
          else
            text1 += "‚µ‚©‚µŒø‰Ê‚Í–³‚©‚Á‚½I\\"
          end
        end
        #************************************************************************
        # ¥ƒGƒlƒ~[•œŠˆŒn
        #************************************************************************
        if @command.element_set.include?(217)
          target.recover_all
          target.state_runk = [0, 0, 0, 0, 0, 0]
          target.ecstasy_count = []
          target.crisis_flag = false
          target.hold_reset
          target.ecstasy_turn = 0
          target.ecstasy_emotion = nil
          target.sp_down_flag = false
          target.resist_count = 0
          target.pillowtalk = 0
          target.talk_weak_check = []
          target.add_states_log.clear
          target.remove_states_log.clear
          target.checking = 0
          target.lub_male = 0
          target.lub_female = 0
          target.lub_anal = 0
          target.used_mouth = 0
          target.used_anal = 0
          target.used_sadism = 0
          battler_stan(target)
          enemies_display(target)
          text1 += "#{target.name}‚ªŒ»‚ê‚½I\\"
        end
        
     #elsif target.damage == nil ƒ_ƒ[ƒW‚ª–³‚¢ê‡‚Ìˆ—‚ÍŒ»ó‚Å‚Í“Á‚É–³‚¢‚½‚ß••ˆó
      end
      #======================================================================================
      # ‰æ‘œ•ÏX
      target.graphic_change = true
      # œƒz[ƒ‹ƒhó‹µŠm”F
      if @active_battler != target
        #hold_initiative(@skill, @active_battler, target) # ƒƒ\ƒbƒh•ÏX‚µ‚Ü‚µ‚½
        if target.holding?
          # ƒNƒŠƒeƒBƒJƒ‹‚ªo‚Ä‚¢‚éê‡A“Gƒz[ƒ‹ƒh‚ÌƒCƒjƒVƒAƒ`ƒu‚ğŒ¸­
          if target.critical
            hold_initiative_down(target)
          end
          # ‚à‚ª‚­‚Ìê‡A©•ª‚ğƒz[ƒ‹ƒh‚µ‚Ä‚¢‚é‘Šè‘Sˆõ‚ÌƒCƒjƒVƒAƒ`ƒu‚ğŒ¸­
          if @command.element_set.include?(207)
            for hold_target in @active_battler.hold_target_battlers
              hold_initiative_down(hold_target)
            end
          end
        end
        # ƒz[ƒ‹ƒhƒ|ƒbƒv‚Ìw¦
        hold_pops_order
        #ƒz[ƒ‹ƒh’¼Œã‚Ìˆ—‚Ìê‡A‚±‚±‚Å•½í‰^“]‚É–ß‚·
        $game_switches[81] = false
      end
    #for target in @target_battlers‚±‚±‚Ü‚Å
    end
    #************************************************************************
    # ¥ƒAƒ“ƒ‰ƒbƒL[ƒƒA
    #************************************************************************
    if @command.name == "ƒAƒ“ƒ‰ƒbƒL[ƒƒA"
      # •sK‚Å‚È‚¢ê‡A•sKó‘Ô‚É‚·‚éB
      unless $game_party.unlucky?
        text1 += "#{$game_actors[101].name}‚Í•sK‚É‚È‚Á‚Ä‚µ‚Ü‚Á‚½I\\"
        $game_variables[61] = 50 
      else
        text1 += "‚µ‚©‚µŒø‰Ê‚Í–³‚©‚Á‚½I\\"
      end
    end
    #************************************************************************
    # ¥ƒCƒ“ƒZƒ“ƒXˆ—
    #************************************************************************
    if @command.element_set.include?(129)
      add_check = $incense.use_incense(@active_battler, @command)
      if add_check
        # ”­¶ˆ—
        text1 = incense_start_effect
      else
        text1 = "‚µ‚©‚µŒø‰Ê‚Í–³‚©‚Á‚½I\\"
      end
    end
    #–{”\‚ÌŒÄ‚ÑŠo‚Ü‚µ‚Å©ŒÈ–\‘–‚µ‚½ê‡A‚»‚Ìƒ^[ƒ“‚Ì’Ç‰ÁƒAƒNƒVƒ‡ƒ“‚ğƒLƒƒƒ“ƒZƒ‹‚·‚é
    @action_battlers.delete(@active_battler) if @command.name == "–{”\‚ÌŒÄ‚ÑŠo‚Ü‚µ"
    #======================================================================================
    #œƒg[ƒNˆ—(ƒg[ƒN’†‚Ìˆ¤•“™‚Å‚Ìƒ_ƒ[ƒW‚»‚Ì‘¼ˆ—‚ğs‚¤‚½‚ß)
    #======================================================================================
    # ƒRƒ}ƒ“ƒh–¼‚ªƒg[ƒNA‚©‚ÂƒRƒ‚ƒ“ƒCƒxƒ“ƒg ID ‚ª—LŒø‚Ìê‡
    if @common_event_id > 0 and @command.name == "ƒg[ƒN"
      @battle_log_window.contents.clear
      @battle_log_window.keep_flag = false
      $game_temp.battle_log_text = ""
      # ƒCƒxƒ“ƒg‚ğƒZƒbƒgƒAƒbƒv
      common_event = $data_common_events[@common_event_id]
      $game_system.battle_interpreter.setup(common_event.list, 0)
    end
    #************************************************************************
    # šƒeƒLƒXƒg®Œ`
    #************************************************************************
    if text1 != "" or text2 != "" or text3 != ""
      a = text1 + text2 + text3
      if $game_system.system_read_mode != 0
        a += "CLEAR"
        a.sub!("\\CLEAR","")
        a.sub!("CLEAR","") if a[/(CLEAR)/] != nil
      end
      $game_temp.battle_log_text += a
    else
      # ƒ}ƒjƒ…ƒAƒ‹‘€ì‚Ìê‡AŒø‰Ê‚ª‚È‚¢ê‡‚Å‚àƒ|[ƒY‚ğ•t‚¯‚é
#      if $game_system.system_read_mode == 0
#        $game_temp.battle_log_text += "@\\"
#      end
    end
    
    #======================================================================================
    #œƒNƒ‰ƒCƒVƒXEâ’¸ƒtƒ‰ƒO
    #======================================================================================
    #‘ÎÛ‚ªƒNƒ‰ƒCƒVƒX‚É‚È‚èAƒNƒ‰ƒCƒVƒX‰ï˜b‚ª”­¶‚µ‚Ä‚¢‚È‚¢‚È‚çˆ—ŠJn
    @crisis_battlers = []
    @ecstasy_battlers = []
    @ecstasy_battlers_count = []
    @ecstasy_battlers_clone = []
    @target_ecstasy_flag = false
    @active_ecstasy_flag = false
    @crisis_mes_stop_flag = false
    #¥â’¸ƒLƒƒƒ‰ƒNƒ^[‚ğŠi”[‚·‚é
    #------------------------------------------------------
    for target in @target_battlers
      if target.hp <= 0 or target.sp <= 0
        target.add_state(11)
        @ecstasy_battlers.push(target)
        @target_ecstasy_flag = true
        target.graphic_change = true
        @crisis_mes_stop_flag = true
      end
    end
    if @active_battler.hp <= 0 or @active_battler.sp <= 0
      @active_battler.add_state(11)
      @ecstasy_battlers.push(@active_battler)
      @active_ecstasy_flag = true
      @active_battler.graphic_change = true
      @crisis_mes_stop_flag = true
    end
    @ecstasy_battlers_count = @ecstasy_battlers
    @ecstasy_battlers_clone = @ecstasy_battlers_count.dup
    #¥ƒNƒ‰ƒCƒVƒXƒLƒƒƒ‰ƒNƒ^[‚ğŠi”[‚·‚é
    #------------------------------------------------------
    #ƒg[ƒN’†Aƒ_ƒ[ƒW–³‚µƒXƒLƒ‹A‰ñ•œƒXƒLƒ‹g—p‚Ìê‡‚ÍŠi”[‚µ‚È‚¢
    if not $game_switches[79] == true and
      not @command.element_set.include?(16) and
      not @command.element_set.include?(17)
      for target in @target_battlers
        unless @ecstasy_battlers.include?(target)
          unless @crisis_mes_stop_flag == true
            if target.crisis? and target.crisis_flag == false
              @crisis_battlers.push(target)
            end
          end
        end
      end
      #ƒ^[ƒQƒbƒgŠm”F‚ÌŒãAƒAƒNƒeƒBƒuƒLƒƒƒ‰ƒNƒ^[‚à”»’è‚ğs‚¤
      unless @ecstasy_battlers.include?(@active_battler)
        unless @crisis_mes_stop_flag == true
          if @active_battler.crisis? and @active_battler.crisis_flag == false
            for target in @target_battlers
              # ƒAƒNƒeƒBƒu‚àƒ^[ƒQƒbƒg‚àƒGƒlƒ~[‚Ìê‡‚ÍƒAƒNƒeƒBƒu‚ğ“ü‚ê‚È‚¢
              unless @active_battler.is_a?(Game_Enemy) and target.is_a?(Game_Enemy)
                @crisis_battlers.push(@active_battler)
              end
            end
          end
        end
      end
    end
    #************************************************************************
    # š‘Sƒoƒgƒ‰[‚ÌƒXƒe[ƒgƒƒO‚ğƒNƒŠƒA
    #************************************************************************
    for battler in @battlers
      battler.add_states_log.clear
      battler.remove_states_log.clear
    end
    #************************************************************************
    # šŠeí‹@”\ˆ—
    #************************************************************************
    #ƒXƒe[ƒ^ƒXƒEƒBƒ“ƒhƒEXV
    @status_window.refresh
    #¥ƒVƒXƒeƒ€ƒEƒFƒCƒg
    case $game_system.ms_skip_mode
    when 3 #è“®‘—‚èƒ‚[ƒh
      @wait_count = 4
    when 2 #ƒfƒoƒbƒOƒ‚[ƒh
      @wait_count = 6
    when 1 #‰õ‘¬ƒ‚[ƒh
      @wait_count = 10
    else
      @wait_count = $game_system.battle_speed_time(0)
    end
    if @crisis_battlers.size > 0
      # ƒXƒeƒbƒv 401 ‚ÉˆÚs
      @phase4_step = 401
    elsif $game_switches[90] == true
      # ƒXƒeƒbƒv 402 ‚ÉˆÚs
      @phase4_step = 402
    else
      # ƒXƒeƒbƒv 5 ‚ÉˆÚs
      @phase4_step = 5
    end

  end
  #--------------------------------------------------------------------------
  # œ ƒtƒŒ[ƒ€XV (ƒƒCƒ“ƒtƒF[ƒY ƒXƒeƒbƒv 401 : ƒNƒ‰ƒCƒVƒXˆ—)
  #--------------------------------------------------------------------------
  def update_phase4_step401
    #======================================================================================
    #œƒNƒ‰ƒCƒVƒXƒtƒ‰ƒO
    #======================================================================================
    cs_battler = @crisis_battlers[0]
    #¥ƒR[ƒ‹ƒTƒCƒ“‚ğİ’è
    if @active_battler == $game_actors[101] or cs_battler == $game_actors[101]
      $msg.callsign = 6
      $msg.callsign = 16 if $game_switches[85] == true
    else
      $msg.callsign = 26
      $msg.callsign = 36 if $game_switches[85] == true
    end
    #¥ƒAƒNƒVƒ‡ƒ“‘¤‚ªƒGƒlƒ~[
    if cs_battler.is_a?(Game_Actor)
      if @active_battler.crisis? and @active_battler.is_a?(Game_Enemy)
        $msg.tag = "ƒAƒNƒ^[—¼Ò"
      elsif cs_battler == @active_battler
        if @active_rebound_flag == true
          $msg.tag = "ƒAƒNƒ^[ƒŠƒoƒEƒ“ƒh©”š"
          @active_rebound_flag = false
        else
          $msg.tag = "ƒAƒNƒ^[©ˆÔ"
        end
      else
        $msg.tag = "ƒAƒNƒ^[’P“Æ"
      end
    elsif cs_battler.is_a?(Game_Enemy)
      if @active_battler != cs_battler
        if @active_battler.is_a?(Game_Enemy) and cs_battler.is_a?(Game_Enemy)
          $msg.tag = "ƒGƒlƒ~[’‡ŠÔU‚ß"
        elsif @active_battler.crisis? and @active_battler.is_a?(Game_Actor)
          $msg.tag = "ƒGƒlƒ~[—¼Ò"
        else
          $msg.tag = "ƒGƒlƒ~[’P“Æ"
        end
      else
        if @active_rebound_flag == true
          $msg.tag = "ƒGƒlƒ~[ƒŠƒoƒEƒ“ƒh©”š"
          @active_rebound_flag = false
        else
          $msg.tag = "ƒGƒlƒ~[©ˆÔ"
        end
      end
    end
    cs_battler.crisis_flag = true
    #Œûãƒ‚[ƒh‚ªŠÈˆÕ•\¦‚Ìê‡A‚±‚Ì€–Ú‚ÍƒXƒ‹[‚·‚é
    unless $game_system.system_message == 0
      #ƒAƒNƒeƒBƒuAƒ^[ƒQƒbƒg‚ğXV
      $game_temp.battle_active_battler = @active_battler
      $game_temp.battle_target_battler[0] = cs_battler
      @battle_log_window.contents.clear
      @battle_log_window.keep_flag = false
      $game_temp.battle_log_text = ""
      # ƒRƒ‚ƒ“ƒCƒxƒ“ƒgu™ŒûãƒR[ƒ‹v‚ğÀs
      common_event = $data_common_events[31]
      $game_system.battle_interpreter.setup(common_event.list, 0)
      @wait_count = 1
    end
    @crisis_battlers.delete(cs_battler)
    if @crisis_battlers.size > 0
      # ƒXƒeƒbƒv 401 ‚ÉˆÚs
      @phase4_step = 401
    elsif $game_switches[90] == true
      # ƒXƒeƒbƒv 402 ‚ÉˆÚs
      @phase4_step = 402
    else
      # ƒXƒeƒbƒv 5 ‚ÉˆÚs
      @phase4_step = 5
    end
  end
  #--------------------------------------------------------------------------
  # œ ƒtƒŒ[ƒ€XV (ƒƒCƒ“ƒtƒF[ƒY ƒXƒeƒbƒv 402 : ’†“rŒûãˆ—)
  #--------------------------------------------------------------------------
  def update_phase4_step402
    
    #Œûãƒ‚[ƒh‚ªŠÈˆÕ•\¦‚Ìê‡A‚±‚Ì€–Ú‚ÍƒXƒ‹[‚·‚é
    if $game_system.system_message == 0
      #•K‚¸ƒXƒCƒbƒ`‚ğ‰ğœ‚µ‚Ä‚¨‚­
      $game_switches[90] = false
      #ƒAƒNƒeƒBƒuAƒ^[ƒQƒbƒg‚ğXV
      $game_temp.battle_active_battler = @active_battler
      $game_temp.battle_target_battler[0] = @target_battlers[0]
      #ƒ€[ƒhƒ`ƒFƒbƒN
      system_simplemode_moodcheck(@active_battler)
    #ƒXƒLƒ‹“™‚Å–²–‚Œûã‚ğŒÄ‚Ño‚·ê‡A‚±‚±‚Åİ’è
    elsif $game_switches[90] == true
      #ƒAƒNƒeƒBƒuAƒ^[ƒQƒbƒg‚ğXV
      $game_temp.battle_active_battler = @active_battler
      $game_temp.battle_target_battler[0] = @target_battlers[0]
      @battle_log_window.contents.clear
      @battle_log_window.keep_flag = false
      $game_temp.battle_log_text = ""
      # ƒRƒ‚ƒ“ƒCƒxƒ“ƒgu™ŒûãƒR[ƒ‹v‚ğÀs
      common_event = $data_common_events[31]
      $game_system.battle_interpreter.setup(common_event.list, 0)
      @wait_count = 10
      #•K‚¸ƒXƒCƒbƒ`‚ğ‰ğœ‚µ‚Ä‚¨‚­
      $game_switches[90] = false
    end
    # ƒ_ƒ[ƒW–³‚µƒXƒLƒ‹‚Å‚È‚¢ê‡
    unless @command.element_set.include?(17)
      # ƒ‰ƒO‚ğì‚éB
      #¥ƒVƒXƒeƒ€ƒEƒFƒCƒg
      case $game_system.ms_skip_mode
      when 3 #è“®‘—‚èƒ‚[ƒh
        @wait_count = 1
      when 2 #ƒfƒoƒbƒOƒ‚[ƒh
        @wait_count = 2
      when 1 #‰õ‘¬ƒ‚[ƒh
        @wait_count = 4
      else
        @wait_count = $game_system.battle_speed_time(0) #Œ³‚Í12
      end
    end
    # ƒXƒeƒbƒv 5 ‚ÉˆÚs
    @phase4_step = 5
  end
  #--------------------------------------------------------------------------
  # œ ƒtƒŒ[ƒ€XV (ƒƒCƒ“ƒtƒF[ƒY ƒXƒeƒbƒv 5 : ƒ_ƒ[ƒWŒãˆ—)
  #--------------------------------------------------------------------------
  def update_phase4_step5
    #ƒg[ƒNˆ¤•‚©‚çâ’¸‚ğ‹N‚±‚·ê‡‚Ìˆ—
    if $msg.talking_ecstasy_flag == "actor"
      @ecstasy_battlers.push($game_actors[101])
      @active_ecstasy_flag = true
      @ecstasy_battlers_count = @ecstasy_battlers
      $game_actors[101].add_state(11)
    elsif $msg.talking_ecstasy_flag == "enemy"
      @ecstasy_battlers.push($msg.t_enemy)
      @target_ecstasy_flag = true
      @ecstasy_battlers_count = @ecstasy_battlers
      $msg.t_enemy.add_state(11)
    end
    #â’¸‚µ‚Ä‚¢‚éƒoƒgƒ‰[‚ª‚¢‚éê‡
    if @ecstasy_battlers_count.size > 0
#      #“¯â’¸ƒtƒ‰ƒO‚ªŒo‚Á‚Ä‚¢‚éê‡‚Í511A‚»‚¤‚Å‚È‚¢ê‡‚Í501‚Ö
#      if @ecstasy_battlers.size > 1 and @target_ecstasy_flag == true and @active_ecstasy_flag == true
        @phase4_step = 501
#      else
#        @phase4_step = 511
#      end
    #â’¸ƒoƒgƒ‰[‚ª‹‚È‚¢ê‡
    else
      #’ÇŒ‚ƒtƒ‰ƒO‚ªŒo‚Á‚Ä‚¢‚éê‡‚ÍƒXƒeƒbƒv601‚Ö
      if @combo_break == false
        @phase4_step = 601
      #‚»‚êˆÈŠO‚Ìê‡‚ÍƒXƒeƒbƒv6‚Ö
      else
        @phase4_step = 6
      end
    end
  end
  #--------------------------------------------------------------------------
  # œ ƒtƒŒ[ƒ€XV (ƒƒCƒ“ƒtƒF[ƒY ƒXƒeƒbƒv 501 : â’¸ˆ—(’P“Æ)F‘O”¼)
  #--------------------------------------------------------------------------
  def update_phase4_step501
    # œâ’¸’†ƒXƒCƒbƒ`‚ğ“ü‚ê‚é
    $game_switches[77] = true
    # œƒoƒgƒ‹ƒƒO‚ğƒNƒŠƒA
    @battle_log_window.contents.clear
    @battle_log_window.keep_flag = false
    $game_temp.battle_log_text = ""
    #======================================================================================
    #œâ’¸ƒtƒ‰ƒO
    #======================================================================================
    # ©”šƒtƒ‰ƒO‚ğ‰º‚°‚Ä‚¨‚­
    @self_ecstasy_flag = false
    #--------------------------------------------------------------------------------------
    # œâ’¸‚µ‚Ä‚¢‚éƒLƒƒƒ‰ƒNƒ^[‚ªƒAƒNƒ^[‚Ìê‡
    #--------------------------------------------------------------------------------------
    if @ecstasy_battlers_count[0].is_a?(Game_Actor)
      #©”š‚Å‚È‚¢ê‡‚ÍUŒ‚ƒGƒlƒ~[‚ªŠm’è‚µ‚Ä‚¢‚é
      if @ecstasy_battlers_count[0] != @active_battler
        $msg.t_enemy = $game_temp.battle_active_battler = @active_battler
        $msg.t_target = $game_temp.battle_target_battler[0] = @ecstasy_battlers_count[0]
      #ƒg[ƒN’†‚Ìê‡‚Í‰ï˜b‘ÎÛƒGƒlƒ~[‚ªŠm’è‚µ‚Ä‚¢‚é
      elsif $msg.talking_ecstasy_flag == "actor"
        $msg.t_enemy = $game_temp.battle_active_battler = @target_battlers[0]
        $msg.t_target = $game_temp.battle_target_battler[0] = @ecstasy_battlers_count[0]
      #©”š‚Ìê‡Aƒz[ƒ‹ƒh’†‚È‚ç‚»‚Ì‘Šè‚ğAˆá‚¤‚È‚çƒ‰ƒ“ƒ_ƒ€‚Å‰ï˜b‚·‚é‘Šè‚ğ‘I‘ğ
      else
        @self_ecstasy_flag = true
        talk_battler = []
        if @ecstasy_battlers_count[0].holding?
          for enemy in $game_troop.enemies
            if enemy.exist?
              if (enemy.hold.penis.battler == @ecstasy_battlers_count[0] or
               enemy.hold.vagina.battler == @ecstasy_battlers_count[0] or
               enemy.hold.mouth.battler == @ecstasy_battlers_count[0] or
               enemy.hold.anal.battler == @ecstasy_battlers_count[0] or
               enemy.hold.tops.battler == @ecstasy_battlers_count[0] or
               enemy.hold.tail.battler == @ecstasy_battlers_count[0] or
               enemy.hold.tentacle.battler == @ecstasy_battlers_count[0] or
               enemy.hold.dildo.battler == @ecstasy_battlers_count[0])
                talk_battler.push(enemy)
              end
            end
          end
        else
          for enemy in $game_troop.enemies
            if enemy.exist?
              talk_battler.push(enemy)
            end
          end
        end
        #‰ï˜bƒGƒlƒ~[‚ğ‘I‘ğ
        $msg.t_enemy = $game_temp.battle_active_battler = talk_battler[rand(talk_battler.size)]
        $msg.t_target = $game_temp.battle_target_battler[0] = @ecstasy_battlers_count[0]
      end
    #--------------------------------------------------------------------------------------
    # œâ’¸‚µ‚Ä‚¢‚éƒLƒƒƒ‰ƒNƒ^[‚ªƒGƒlƒ~[‚Ìê‡
    #--------------------------------------------------------------------------------------
    elsif @ecstasy_battlers_count[0].is_a?(Game_Enemy)
      #ƒg[ƒN’†‚Ìê‡‚ÍUŒ‚ƒGƒlƒ~[‚ªŠm’è‚µ‚Ä‚¢‚é
      if $msg.talking_ecstasy_flag == "enemy"
        $msg.t_enemy = $game_temp.battle_target_battler[0] = @ecstasy_battlers_count[0]
        $msg.t_target = $game_temp.battle_active_battler = @active_battler
      #©”š‚Å‚È‚¢ê‡‚ÍUŒ‚ƒGƒlƒ~[‚ªŠm’è‚µ‚Ä‚¢‚é
      elsif @ecstasy_battlers_count[0] != @active_battler
        $msg.t_enemy = $game_temp.battle_target_battler[0] = @ecstasy_battlers_count[0]
        $msg.t_target = $game_temp.battle_active_battler = @active_battler
      #©”š‚Ìê‡Aƒz[ƒ‹ƒh’†‚È‚ç‚»‚Ì‘Šè‚ğAˆá‚¤‚È‚çålŒö‚ğ‘I‘ğ
      else
        @self_ecstasy_flag = true
        talk_battler = []
        if @ecstasy_battlers_count[0].holding?
           for actor in $game_party.actors
            if actor.exist?
              if (actor.hold.penis.battler == @ecstasy_battlers_count[0] or
               actor.hold.vagina.battler == @ecstasy_battlers_count[0] or
               actor.hold.mouth.battler == @ecstasy_battlers_count[0] or
               actor.hold.anal.battler == @ecstasy_battlers_count[0] or
               actor.hold.tops.battler == @ecstasy_battlers_count[0] or
               actor.hold.tail.battler == @ecstasy_battlers_count[0] or
               actor.hold.tentacle.battler == @ecstasy_battlers_count[0] or
               actor.hold.dildo.battler == @ecstasy_battlers_count[0])
                talk_battler.push(actor)
              end
            end
          end
        else
          for actor in $game_party.actors
            if actor.exist?
              talk_battler.push(actor)
            end
          end
        end
        #‰ï˜bƒGƒlƒ~[‚ğ‘I‘ğ
        $msg.t_enemy = $game_temp.battle_active_battler = talk_battler[rand(talk_battler.size)]
        $msg.t_target = $game_temp.battle_target_battler[0] = @ecstasy_battlers_count[0]
      end
    end
    #--------------------------------------------------------------------------------------
    # œ”’lˆ—
    #--------------------------------------------------------------------------------------
    # â’¸‚µ‚½ƒLƒƒƒ‰‚ÌSPŒ¸­—Ê‚ğZo(20150823ƒ_ƒ[ƒW—Ê‰ü’è)
    $ecstasy_loss_sp = 0
    #©”š
    if @self_ecstasy_flag == true
      loss = 100 + ($mood.point * 15 / 10)
      loss += (@ecstasy_battlers_count[0].str / 2) if @ecstasy_battlers_count[0].holding?
      loss = [[loss, (@ecstasy_battlers_count[0].maxsp / 3)].max, 999].min
      loss = loss + rand(@ecstasy_battlers_count[0].level * 5)
      loss = loss.round
    #ƒg[ƒN’†
    elsif $msg.talking_ecstasy_flag != nil
      case $msg.tag
      when "•òd","‹Š­"
        ec_battler = $msg.t_enemy
      else
        ec_battler = $game_actors[101]
      end
      loss = 200 + ec_battler.dex + ($mood.point * 15 / 10)
      loss += ec_battler.str if @ecstasy_battlers_count[0].holding?
      loss = [[loss, (@ecstasy_battlers_count[0].maxsp / 3)].max, 999].min
      loss = loss + ($msg.talk_step * 5)
      loss = loss.round
      $game_switches[79] = false
    else
      loss = 200 + @active_battler.dex + ($mood.point * 15 / 10)
      loss += @active_battler.str if @ecstasy_battlers_count[0].holding?
      loss = [[loss, (@ecstasy_battlers_count[0].maxsp / 3)].max, 999].min
      loss = loss - ($game_temp.difference_damage / 3).floor
      #ålŒöƒCƒ“ƒT[ƒg’†A‚©‚Ââ’¸‘ÎÛ‚Æ‚Ìê‡A‘å•‚Éƒ_ƒ[ƒW‘‰Á
      if @ecstasy_battlers_count[0].vagina_insert?
        if @ecstasy_battlers_count[0].hold.vagina.battler == $game_actors[101]
          loss += [($game_actors[101].str * 3),200].max
        end
      end
      loss = loss.round
    end
    #ƒxƒbƒhƒCƒ“’†‚ÍŒ¸­—Ê”¼Œ¸
    if $game_switches[85] == true
      loss = (loss / 2).ceil
    #’Êíí“¬’†‚ÍA‘Šè‚ªƒ{ƒX‚Å‚È‚¯‚ê‚ÎŒ´‘¥ˆêŒ‚‚Å¸“V‚·‚éƒ_ƒ[ƒW‚ğ—^‚¦‚é
#    elsif @ecstasy_battlers_count[0].is_a?(Game_Enemy)
#      unless @ecstasy_battlers_count[0].element_rate(191) >= 2
#        loss = loss * 3
#      end
    end

    #--------------------------------------------------------------
    # –{‹C‚É‚È‚é–²–‚‚ª‚Ü‚¾–{‹C‚ğo‚µ‚Ä‚¢‚È‚¢ê‡A‚u‚o‚ğ‚P‚¾‚¯c‚·
    #--------------------------------------------------------------
    if SR_Util.enemy_before_earnest?(@ecstasy_battlers_count[0])
      # Œ¸­‚u‚o‚ª‚»‚Ì–²–‚‚ÌŒ»İ‚u‚oˆÈã‚Ìê‡
      if loss >= @ecstasy_battlers_count[0].sp
        # ‚u‚o‚ğ‚P‚¾‚¯c‚·
        loss = @ecstasy_battlers_count[0].sp - 1
      end
    end
    
    # ‚±‚±‚ÅŒ¸­‚·‚é‚u‚o‚ğŠm’è‚·‚é‚ªAÀÛ‚ÉŒ¸‚é‚Ì‚Í‚±‚ÌŸ‚ÌƒXƒeƒbƒv‚Å
    $ecstasy_loss_sp = loss
    unless $msg.talking_ecstasy_flag != nil
      attack_element_check
    else
      $msg.talking_ecstasy_flag = nil
    end
    #--------------------------------------------------------------------------------------
    # œâ’¸‚µ‚Ä‚¢‚éƒLƒƒƒ‰ƒNƒ^[‚ªƒGƒlƒ~[‚Ìê‡
    #--------------------------------------------------------------------------------------
    # â’¸‚µ‚Ä‚¢‚é‚Ì‚ªƒGƒlƒ~[‚Ìê‡
    if @ecstasy_battlers_count[0].is_a?(Game_Enemy)
      # ƒRƒ‚ƒ“ƒCƒxƒ“ƒguâ’¸iƒGƒlƒ~[jv‚ğÀs
      common_event = $data_common_events[34]
      $game_system.battle_interpreter.setup(common_event.list, 0)
      @battle_log_window.contents.clear
      @battle_log_window.keep_flag = false
      $game_temp.battle_log_text = ""
    # â’¸‚µ‚Ä‚¢‚é‚Ì‚ªƒAƒNƒ^[‚Ìê‡
    elsif @ecstasy_battlers_count[0].is_a?(Game_Actor)# == $game_actors[101]
      #¥ƒVƒXƒeƒ€ƒEƒFƒCƒg
      case $game_system.ms_skip_mode
      when 3 #è“®‘—‚èƒ‚[ƒh
        @wait_count = 1
      when 2 #ƒfƒoƒbƒOƒ‚[ƒh
        @wait_count = 8
      when 1 #‰õ‘¬ƒ‚[ƒh
        @wait_count = 12
      else
        @wait_count = $game_system.battle_speed_time(0) + $game_system.important_wait_time
      end
      # ƒRƒ‚ƒ“ƒCƒxƒ“ƒguâ’¸iƒAƒNƒ^[jv‚ğÀs
      common_event = $data_common_events[32]
      $game_system.battle_interpreter.setup(common_event.list, 0)
      @battle_log_window.contents.clear
      @battle_log_window.keep_flag = false
      $game_temp.battle_log_text = ""
    end
    @status_window.refresh
    # ƒXƒeƒbƒv 502 ‚ÉˆÚs
    @phase4_step = 502
  end
  #--------------------------------------------------------------------------
  # š ƒtƒŒ[ƒ€XV (ƒƒCƒ“ƒtƒF[ƒY ƒXƒeƒbƒv 502 : â’¸ˆ—(’P“Æ)FŒã”¼)
  #--------------------------------------------------------------------------
  def update_phase4_step502
    # œƒoƒgƒ‹ƒƒO‚ğƒNƒŠƒA
    @battle_log_window.contents.clear
    @battle_log_window.keep_flag = false
    $game_temp.battle_log_text = ""
    # ƒoƒgƒ‹ƒCƒxƒ“ƒgÀs’†‚Ìê‡
    if $game_system.battle_interpreter.running?
      return
    end
    #¥ƒVƒXƒeƒ€ƒEƒFƒCƒg
    case $game_system.ms_skip_mode
    when 3 #è“®‘—‚èƒ‚[ƒh
      @wait_count = 1
    when 2 #ƒfƒoƒbƒOƒ‚[ƒh
      @wait_count = 8
    when 1 #‰õ‘¬ƒ‚[ƒh
      @wait_count = 12
    else
      @wait_count = $game_system.battle_speed_time(0) + $game_system.important_wait_time
    end
    #--------------------------------------------------------------------------------------
    # œâ’¸‚µ‚Ä‚¢‚éƒLƒƒƒ‰ƒNƒ^[‚ªƒGƒlƒ~[‚Ìê‡‚Ì–Œãˆ—
    #--------------------------------------------------------------------------------------
    # ©”šˆÈŠO‚ÅSPƒ_ƒEƒ“ƒtƒ‰ƒO‚ğ—^‚¦‚éê‡‚Ìˆ—
    if @ecstasy_battlers_count[0].is_a?(Game_Enemy) and @ecstasy_battlers_count[0].sp_down_flag == true
      $game_temp.battle_log_text = "#{@ecstasy_battlers_count[0].name} has reached cli‚ax!"
      # â’¸‚³‚¹‚½ƒLƒƒƒ‰‚ªy‹z¸z‚¿‚Ìê‡A‹z¸ƒƒ\ƒbƒh‚ğ’Ê‚·
      if @active_battler.have_ability?("‹z¸")
        SR_Util.energy_drain(@active_battler,@ecstasy_battlers_count[0]) 
      end
      @ecstasy_battlers_count[0].animation_id = 13
      @ecstasy_battlers_count[0].animation_id = 127
      @ecstasy_battlers_count[0].animation_hit = true
      @ecstasy_battlers_count[0].add_state(1)
      @ecstasy_battlers_count[0].sp_down_flag = false
      @ecstasy_battlers_count[0].sp -= 1
    # ’Êíâ’¸Œãˆ—
    else
      # â’¸‚µ‚½ƒLƒƒƒ‰‚Ì‚r‚o‚ğA‘O’iŠK‚ÅZo‚µ‚Ä‚¢‚½’l‚¾‚¯Œ¸­B
      @ecstasy_battlers_count[0].sp = (@ecstasy_battlers_count[0].sp - $ecstasy_loss_sp)
      $ecstasy_loss_sp = 0 #ƒŠƒZƒbƒg
      #----------------------------------------------------------------------
      # œ‚u‚o‚ª‚PˆÈãc‚Á‚½ê‡
      #----------------------------------------------------------------------
      if @ecstasy_battlers_count[0].sp > 0
        #¥â’¸ƒXƒe[ƒg‚ğ•t—^(ƒƒEŒN‚Ì‚İŠãƒXƒe[ƒg)
        @ecstasy_battlers_count[0].add_state(2) if @ecstasy_battlers_count[0] == $game_actors[101]
        @ecstasy_battlers_count[0].add_state(3) unless @ecstasy_battlers_count[0] == $game_actors[101]
        #¥â’¸ˆ—‚ğs‚¤(â’¸ƒJƒEƒ“ƒg‚ÍŒûãˆ—‚ÌŒã‚Ås‚¤)
        #@ecstasy_battlers_count[0].ecstasy_turn = 1 + @ecstasy_battlers_count[0].ecstasy_count.size
        @ecstasy_battlers_count[0].ecstasy_turn = 2# + @ecstasy_battlers_count[0].ecstasy_count.size
        #@ecstasy_battlers_count[0].ecstasy_turn = 3 if @ecstasy_battlers_count[0].ecstasy_turn > 3
        @ecstasy_battlers_count[0].remove_state(6)
        @ecstasy_battlers_count[0].remove_state(11)
        #¥ƒoƒbƒhƒXƒe[ƒg‰ğœ
        for i in SR_Util.checking_states
          if @ecstasy_battlers_count[0].states.include?(i)
            @ecstasy_battlers_count[0].remove_state(i)
          end
        end
        #¥SPƒ_ƒEƒ“ƒtƒ‰ƒO‚ª“ü‚Á‚Ä‚¢‚È‚¢ê‡A‚±‚±‚Åâ’¸ƒAƒjƒ[ƒVƒ‡ƒ“‚ğ•\¦
        unless @ecstasy_battlers_count[0].sp_down_flag
          @ecstasy_battlers_count[0].animation_id = 11
          @ecstasy_battlers_count[0].animation_hit = true
        end
        #¥ÀEP‚ğÅ‘å’l‚Ü‚Å‰ñ•œ
        #  –¡•û‚Í‘S‰õA“G‚Í‚d‚oÅ‘å’l‚Ì”¼•ª‚Ü‚Å‰ñ•œ
        if @ecstasy_battlers_count[0].is_a?(Game_Actor)
          @ecstasy_battlers_count[0].hp = @ecstasy_battlers_count[0].maxhp
        elsif @ecstasy_battlers_count[0].is_a?(Game_Enemy)
          @ecstasy_battlers_count[0].hp = (@ecstasy_battlers_count[0].maxhp / 2).round
        end
        #¥ƒVƒXƒeƒ€ƒEƒFƒCƒg
        case $game_system.ms_skip_mode
        when 3 #è“®‘—‚èƒ‚[ƒh
          @wait_count = 1
        when 2 #ƒfƒoƒbƒOƒ‚[ƒh
          @wait_count = 8
        when 1 #‰õ‘¬ƒ‚[ƒh
          @wait_count = 12
        else
          @wait_count = $game_system.battle_speed_time(0)
        end
        #¥”O‚Ì‚½‚ßƒoƒgƒ‹ƒƒO‚ğƒNƒŠƒA
        @battle_log_window.contents.clear
        @battle_log_window.keep_flag = false
        $game_temp.battle_log_text = ""
        #----------------------------------------------------------------------
        # œƒAƒNƒ^[‚ÆƒGƒlƒ~[‚Ìˆ—
        if @ecstasy_battlers_count[0].is_a?(Game_Actor)
        # ƒRƒ‚ƒ“ƒCƒxƒ“ƒguâ’¸ŒãiƒAƒNƒ^[jv‚ğÀs
          common_event = $data_common_events[33]
          $game_system.battle_interpreter.setup(common_event.list, 0)
        elsif @ecstasy_battlers_count[0].is_a?(Game_Enemy)
          # Šm’è‚Åo‚·ê‡A‚Ü‚½‚Í—\‘ªŒ¸ŠVP‚æ‚è‘ÎÛ‚ÌVP‚ª‘½‚¯‚ê‚Îâ’¸Œûã‚ğo‚·
          if ($game_switches[95] == true or
             $game_switches[91] == true or #ƒ{ƒXí‚Å‚Í•K‚¸o‚·
             $game_switches[85] == true) #ƒxƒbƒhƒCƒ“’†‚Í•K‚¸o‚·
            # ƒRƒ‚ƒ“ƒCƒxƒ“ƒguâ’¸ŒãiƒGƒlƒ~[jv‚ğÀs
            common_event = $data_common_events[35]
            $game_system.battle_interpreter.setup(common_event.list, 0)
            #¥ƒVƒXƒeƒ€ƒEƒFƒCƒg
            case $game_system.ms_skip_mode
            when 3 #è“®‘—‚èƒ‚[ƒh
              @wait_count = 1
            when 2 #ƒfƒoƒbƒOƒ‚[ƒh
              @wait_count = 8
            when 1 #‰õ‘¬ƒ‚[ƒh
              @wait_count = 12
            else
              @wait_count = $game_system.battle_speed_time(0)
            end
          end
        end
        #¥â’¸ƒJƒEƒ“ƒg‚ğ‰ÁZ‚·‚é
        @ecstasy_battlers_count[0].ecstasy_count.push(@active_battler)
        #¥ƒXƒe[ƒgƒƒO‚ğ‚·‚×‚ÄƒNƒŠƒA
        @ecstasy_battlers_count[0].add_states_log.clear
        @ecstasy_battlers_count[0].remove_states_log.clear
      #----------------------------------------------------------------------
      # œ‚u‚o‚ª‚OˆÈ‰º‚Ìê‡
      #----------------------------------------------------------------------
      else
        # ƒoƒgƒ‹ƒƒO‚ğƒNƒŠƒA
        @battle_log_window.contents.clear
        @battle_log_window.keep_flag = false
        $game_temp.battle_log_text = ""
        if @ecstasy_battlers_count[0].is_a?(Game_Enemy)
          # “G‚Ìê‡
          # ƒoƒgƒ‹ƒƒO‚ğƒNƒŠƒA
          $game_temp.battle_log_text = "#{@ecstasy_battlers_count[0].name}‚ğâ’¸‚³‚¹‚½I"
          if @active_battler.have_ability?("‹z¸")
            SR_Util.energy_drain(@active_battler,@ecstasy_battlers_count[0]) 
          end
          @ecstasy_battlers_count[0].animation_id = 127
          @ecstasy_battlers_count[0].animation_hit = true
        else
          # ƒRƒ‚ƒ“ƒCƒxƒ“ƒguâ’¸ŒãiƒAƒNƒ^[jv‚ğÀs
          common_event = $data_common_events[33]
          $game_system.battle_interpreter.setup(common_event.list, 0)
          # •K‚¸ƒRƒ‚ƒ“Œã‚Éƒoƒgƒ‹ƒƒO‚ğƒNƒŠƒA
          @battle_log_window.contents.clear
          @battle_log_window.keep_flag = false
          $game_temp.battle_log_text = ""
        end
      end
    end
    #----------------------------------------------------------------------
    # ƒz[ƒ‹ƒhŒp‘±ƒtƒ‰ƒO‚Ìİ’è
    $game_switches[83] = false # ‰Šú‰»
    if @ecstasy_battlers_count[0].holding?
      $game_switches[83] = true
      # â’¸‚µ‚½ƒoƒgƒ‰[‚ª¸_‚µ‚Ä‚¢‚é‚©Aâ’¸‘¤‚ª–{‹Có‘Ô‚Ì‘}“ü’†‚Å‚È‚­
      # ƒAƒNƒeƒBƒu‘¤‚Ìƒz[ƒ‹ƒhƒCƒjƒVƒAƒ`ƒu‚ª‚R–¢–‚¾‚Á‚½‚Íƒz[ƒ‹ƒh‚ğŒp‘±‚µ‚È‚¢
      if @ecstasy_battlers_count[0].dead? or
       (not @ecstasy_battlers_count[0].earnest_insert? and @active_battler.hold.initiative_level < 3)
        $game_switches[83] = false
      end
    end
    #----------------------------------------------------------------------
    #¥ƒXƒe[ƒ^ƒXƒEƒBƒ“ƒhƒEXV
    @status_window.refresh
    #----------------------------------------------------------------------
    # œålŒö‚ª“|‚ê‚é‚©”Û‚©
    #----------------------------------------------------------------------
    # ¥ålŒö‚ªŠ®‘S‚É“|‚ê‚Ä‚µ‚Ü‚Á‚½ê‡‚Í‘¬‚â‚©‚ÉI—¹
    if $game_actors[101].dead?
      @phase4_step = 6
    else
    # ¥ålŒö‚ªŒ’İ‚È‚çƒz[ƒ‹ƒh‰ğœˆ—‚ÉˆÚs
      @phase4_step = 503
    end
  end
  #--------------------------------------------------------------------------
  # š ƒtƒŒ[ƒ€XV (ƒƒCƒ“ƒtƒF[ƒY ƒXƒeƒbƒv 503 : Šeíƒz[ƒ‹ƒh‰ğœ )
  #--------------------------------------------------------------------------
  def update_phase4_step503
    # Šeƒoƒgƒ‰[‚Éƒz[ƒ‹ƒhó‹µ‚ğ‹L˜^
    hold_record
    # ƒz[ƒ‹ƒhŒp‘±ƒtƒ‰ƒO‚ªŒo‚Á‚Ä‚¢‚È‚¢ê‡‚Í‰ğœ
    unless $game_switches[83]
      # ƒoƒgƒ‹ƒƒO‚ğƒNƒŠƒA
      @battle_log_window.contents.clear
      @battle_log_window.keep_flag = false
      $game_temp.battle_log_text = ""
      make_unhold_text(@ecstasy_battlers_count[0])
      remove_hold("â’¸",@ecstasy_battlers_count[0])
    end
    # ƒz[ƒ‹ƒhŒp‘±ƒtƒ‰ƒO‚ğƒŠƒZƒbƒg
    $game_switches[83] = false
    
=begin
    #‰½‚©‚Ìƒz[ƒ‹ƒh‚ª‘Šè‚É‚©‚©‚Á‚Ä‚¢‚é‚È‚ç‰ğœ”»’è”­¶
    if @ecstasy_battlers_count[0].holding?
      if @ecstasy_battlers_count[0].dead? or @active_battler.hold.initiative_level < 3
        # ƒoƒgƒ‹ƒƒO‚ğƒNƒŠƒA
        @battle_log_window.contents.clear
        @battle_log_window.keep_flag = false
        $game_temp.battle_log_text = ""
        make_unhold_text(@ecstasy_battlers_count[0])
        remove_hold("â’¸",@ecstasy_battlers_count[0])
      end
    end
=end
    # ƒz[ƒ‹ƒhƒ|ƒbƒv‚Ìw¦
    hold_pops_order
    # “G–²–‚‚ª‚Ü‚¾“|‚ê‚Ä‚¢‚È‚¢ê‡
    if not @ecstasy_battlers_count[0].dead?
      #¥ƒVƒXƒeƒ€ƒEƒFƒCƒg
      case $game_system.ms_skip_mode
      when 3 #è“®‘—‚èƒ‚[ƒh
        @wait_count = 1
      when 2 #ƒfƒoƒbƒOƒ‚[ƒh
        @wait_count = 8
      when 1 #‰õ‘¬ƒ‚[ƒh
        @wait_count = 12
      else
        @wait_count = $game_system.battle_speed_time(0) #Œ³‚Í20
      end
    else
      # ƒoƒgƒ‹ƒƒO‚ğƒNƒŠƒA
      @battle_log_window.contents.clear
      @battle_log_window.keep_flag = false
      $game_temp.battle_log_text = ""
    end
    @status_window.refresh
    # ƒGƒlƒ~[‚È‚ç‚·‚®â’¸ˆ—‚Ö
    if @ecstasy_battlers_count[0].is_a?(Game_Enemy)
      #â’¸ˆ—‚ÌÏ‚ñ‚¾ƒGƒlƒ~[‚ğÁ‹
      @ecstasy_battlers_count.delete(@ecstasy_battlers_count[0])
      @phase4_step = 602
    # ƒAƒNƒ^[‚È‚ç“ü‚ê‘Ö‚¦ˆ—‚ğ“ü‚ê‚Ä‚©‚ç
    else
      @phase4_step = 504
    end
  end
  #--------------------------------------------------------------------------
  # š ƒtƒŒ[ƒ€XV (ƒƒCƒ“ƒtƒF[ƒY ƒXƒeƒbƒv 5 : í“¬•s”\ˆ— )
  #--------------------------------------------------------------------------
  def update_phase4_step504
    # ƒXƒeƒbƒv602iâ’¸Œã‹““®j‚Ìƒtƒ‰ƒO
    @phase4_step = 602
    target = @ecstasy_battlers_count[0]
    #â’¸ˆ—‚ğI‚¦‚½ƒAƒNƒ^[‚ğÁ‹
    @ecstasy_battlers_count.delete(@ecstasy_battlers_count[0])
    #------------------------------------------------------------------------
    if target.dead?
      for i in $game_party.party_actors
        if not i.dead? and not $game_party.battle_actors.include?(i)
#        if not i.dead? and i != $game_party.party_actors[0] and
#         i != $game_party.party_actors[1]
          # ¸_A—‡ŒnˆÈŠO‚ÌƒXƒe[ƒg‚ğ‘S‚Ä‰ğœ
          for n in target.states
            target.remove_state(n) unless [1,4,5].include?(n)
          end
          target.remove_states_log.clear
          #ƒz[ƒ‹ƒh‘S‰ğœ
          target.hold_reset
          # •¡»‚ğì‚é
          a_actor = target#.dup
          b_actor = i#.dup
          # w’è‚µ‚½ƒƒ“ƒo[‚ğŒğ‘ã‚·‚éB
=begin
          if target == $game_party.party_actors[0]
            $game_party.battle_actors[0] = b_actor
            $game_party.party_actors[0] = b_actor
            appear_battler = $game_party.battle_actors[0]
          end
          if target == $game_party.party_actors[1]
            $game_party.battle_actors[1] = b_actor
            $game_party.party_actors[1] = b_actor
            appear_battler = $game_party.battle_actors[1]
          end
          if i == $game_party.party_actors[3]
            $game_party.party_actors[3] = a_actor
          elsif i == $game_party.party_actors[2]
            $game_party.party_actors[2] = a_actor
          end
=end
          for num in 0...$game_party.party_actors.size
            if target == $game_party.party_actors[num]
              $game_party.battle_actors.delete(target)
              $game_party.battle_actors.push(b_actor)
              $game_party.party_actors[num] = b_actor
              appear_battler = b_actor
              break
            end
          end
          for num in 0...$game_party.party_actors.size
            if i == $game_party.party_actors[num]
              $game_party.party_actors[num] = a_actor
              break
            end
          end
          
          i = a_actor
          #œí“¬ŠJnˆ—ŠÖ˜A‚Åİ’è˜R‚ê‚ª‚ ‚ê‚ÎÄ“xİ’è
          b_actor.state_runk = [0, 0, 0, 0, 0, 0] if b_actor.state_runk == nil
          b_actor.ecstasy_count = [] if b_actor.ecstasy_count == nil
          b_actor.crisis_flag = false
          b_actor.skill_collect = nil
          b_actor.hold_reset
          b_actor.lub_male = 0 if b_actor.lub_male == nil or not b_actor.lub_male > 0
          b_actor.lub_female = 0 if b_actor.lub_female == nil or not b_actor.lub_female > 0
          b_actor.lub_anal = 0 if b_actor.lub_anal == nil or not b_actor.lub_anal > 0
          b_actor.used_mouth = 0 if b_actor.used_mouth == nil or not b_actor.used_mouth > 0
          b_actor.used_anal = 0 if b_actor.used_anal == nil or not b_actor.used_anal > 0
          b_actor.used_sadism = 0 if b_actor.used_sadism == nil or not b_actor.used_sadism > 0
          b_actor.ecstasy_turn = 0 if b_actor.ecstasy_turn == nil
          b_actor.sp_down_flag = false if b_actor.sp_down_flag == nil or b_actor.sp_down_flag == true
          b_actor.ecstasy_emotion = nil
          b_actor.add_states_log.clear
          b_actor.remove_states_log.clear
          b_actor.resist_count = 0 if b_actor.resist_count == nil
          #ƒxƒbƒhƒCƒ“A‹ó• PŒ‚‚ÍÅ‰‚©‚çã“_ƒ`ƒFƒbƒN‚ğtrue‚É‚·‚é
          if $game_switches[85] == true or $game_switches[86] == true
            b_actor.checking = 1
          else
            b_actor.checking = 0
          end
          $game_party.battle_actor_refresh
          # ƒoƒgƒ‹ƒƒO‚ğ•\¦
          $game_temp.battle_log_text += b_actor.name + " has entered battle!\\"
          # ƒXƒe[ƒ^ƒX‰æ–Ê‚ğƒŠƒtƒŒƒbƒVƒ…
          @status_window.refresh
          #œƒoƒgƒ‹ƒg[ƒNŠÖ˜A‚ğƒŠƒZƒbƒg
          $game_temp.action_num = 0
          $game_temp.attack_combo_target = ""
          # ƒAƒNƒVƒ‡ƒ“‹­§‘ÎÛ‚Ìƒoƒgƒ‰[‚ğƒNƒŠƒA
          $game_temp.forcing_battler = nil
          # ‰æ‘œ•ÏX
          $game_party.battle_actors[1].graphic_change = true
          # ƒAƒjƒ[ƒVƒ‡ƒ“‚ğ•\¦
          $game_party.battle_actors[1].animation_id = 18
          $game_party.battle_actors[1].animation_hit = true
          #¥ƒVƒXƒeƒ€ƒEƒFƒCƒg
          case $game_system.ms_skip_mode
          when 3 #è“®‘—‚èƒ‚[ƒh
            @wait_count = 1
          when 2 #ƒfƒoƒbƒOƒ‚[ƒh
            @wait_count = 8
          when 1 #‰õ‘¬ƒ‚[ƒh
            @wait_count = 12
          else
            @wait_count = $game_system.battle_speed_time(0)
          end
=begin
          # oŒ»ƒGƒtƒFƒNƒg‚ÌƒtƒFƒCƒY‚Ö
          @phase4_step = 16
          @phase4_step16_count = 0
=end
          # oŒ»ƒGƒtƒFƒNƒg‚Ìˆ—‚ğs‚¤
          appear_effect_order([appear_battler])
          return
        end
      end
    end
    #------------------------------------------------------------------------
  end
  #--------------------------------------------------------------------------
  # œ ƒtƒŒ[ƒ€XV (ƒƒCƒ“ƒtƒF[ƒY ƒXƒeƒbƒv 601 : ’ÇŒ‚”»’è)
  #--------------------------------------------------------------------------
  def update_phase4_step601
    #šâ’¸‚µ‚Ä‚¢‚È‚¢ê‡A’ÇŒ‚”»’è‚ğ‚±‚±‚Ås‚¤
    if $game_temp.battle_target_battler[0].hp > 0
      if @active_battler.is_a?(Game_Enemy)
        plural_attack_check(@skill,@target_battlers[0])
      elsif @active_battler.current_action.kind == 1
        #ƒAƒNƒ^[s“®’†‚ÅƒXƒLƒ‹g—p‚Ì‚İ’ÇŒ‚”»’è‚ğs‚¤
        plural_attack_check(@skill,@target_battlers[0])
      else
        $game_switches[78] = false
        $weak_number = $weak_result = 0
      end
    else
      $game_switches[78] = false
      $weak_number = $weak_result = 0
    end
    @phase4_step = 6
  end

  #--------------------------------------------------------------------------
  # œ ƒtƒŒ[ƒ€XV (ƒƒCƒ“ƒtƒF[ƒY ƒXƒeƒbƒv 602 : â’¸Œã‚Ì‹““®)
  #--------------------------------------------------------------------------
  def update_phase4_step602
    #œâ’¸ˆ—‚ª•K—v‚ÈƒLƒƒƒ‰ƒNƒ^[‚ª‚Ü‚¾‘¶İ‚·‚éê‡
    if @ecstasy_battlers_count.size > 0
      # ƒXƒeƒbƒv5iâ’¸ˆ—•ªŠòj‚É”ò‚Î‚·
      @phase4_step = 5
    else
      # ‘Sˆõ‚Ìâ’¸ƒGƒtƒFƒNƒg‚Ìw¦‚ğo‚·
      dead_effect_order(@battlers)
      # ƒXƒeƒbƒv6iƒŠƒtƒŒƒbƒVƒ…j‚É”ò‚Î‚·
      @phase4_step = 6
    end
  end
  #--------------------------------------------------------------------------
  # œ ƒtƒŒ[ƒ€XV (ƒƒCƒ“ƒtƒF[ƒY ƒXƒeƒbƒv 6 : ƒŠƒtƒŒƒbƒVƒ…)
  #--------------------------------------------------------------------------
  def update_phase4_step6

#    p "update4-6"if $DEBUG
    case @active_battler.current_action.kind
    when 1 #ƒXƒLƒ‹‚Ìê‡
      @command = @skill
    when 2 #ƒXƒLƒ‹‚Ìê‡
      @command = @item
    else
      @command = nil
    end
    # —Uˆøƒtƒ‰ƒO‚ğ‰Šú‰»‚·‚é
    $game_temp.incite_flag = false

    # ƒRƒ‚ƒ“ƒCƒxƒ“ƒg ID ‚ª—LŒø‚Ìê‡
    if @common_event_id > 0
      if @command == nil
        unless (@skill != nil and @skill.name == "ƒg[ƒN")
          # ƒCƒxƒ“ƒg‚ğƒZƒbƒgƒAƒbƒv
          common_event = $data_common_events[@common_event_id]
          $game_system.battle_interpreter.setup(common_event.list, 0)
        end
      elsif not @command.name == "ƒg[ƒN"
        # ƒCƒxƒ“ƒg‚ğƒZƒbƒgƒAƒbƒv
        common_event = $data_common_events[@common_event_id]
        $game_system.battle_interpreter.setup(common_event.list, 0)
      end
    end
    
    # ƒwƒ‹ƒvƒEƒBƒ“ƒhƒE‚ğ‰B‚·
    @help_window.visible = false
    # šƒwƒ‹ƒvƒEƒBƒ“ƒhƒE‘Ñ‚ğ‰B‚·
    @help_window.window.visible = false
    
    # šƒoƒgƒ‹ƒƒO‚ÌƒNƒŠƒA
    @battle_log_window.contents.clear
    @battle_log_window.keep_flag = false
    $game_temp.battle_log_text = ""
    # š“¦‘–‚ª¬Œ÷‚µ‚Ä‚¢‚éê‡“¦‘–
    if @escape_success == true
      # ƒoƒgƒ‹ŠJn‘O‚Ì BGM ‚É–ß‚·
      $game_system.bgm_play($game_temp.map_bgm)
      @escape_success = false
      battle_end(1)
    end
    #â’¸’†A‰ï˜b’†‚Í’ÇŒ‚‚ğ‘Å‚¿Ø‚é
    if ($game_switches[77] == true or $game_switches[79] == true or @combo_break == true)
      $game_switches[78] = false
    end
    # œ’ÇŒ‚”­¶’†
    if $game_switches[78] == true
      #’ÇŒ‚”­¶‚ÅA‘Šè‚ÌEP‚ª‚OˆÈã‚È‚ç’ÇŒ‚€–Ú‚ÖˆÚ“®
      if $game_temp.battle_target_battler[0].hp > 0
        $weak_result += 1 #s‚Á‚½‰ñ”‚ğ{‚P
        # ƒoƒgƒ‹ƒƒO‚ğ•\¦
        if @active_battler.is_a?(Game_Actor)
          
          # ’ÇŒ‚‚Ì‘®«ƒ`ƒFƒbƒN(@0830)
          attack_element_check
          
          # ŒûãƒCƒxƒ“ƒg‚ğƒZƒbƒgƒAƒbƒv
          common_event = $data_common_events[31]
          $game_system.battle_interpreter.setup(common_event.list, 0)
        else
#          p "’ÇŒ‚’†/‘ÎÛF#{$game_temp.battle_target_battler[0].name}"
          # ŒûãƒCƒxƒ“ƒg‚ğƒZƒbƒgƒAƒbƒv
          common_event = $data_common_events[31]
          $game_system.battle_interpreter.setup(common_event.list, 0)
          # ƒ‰ƒ“ƒ_ƒ€ƒXƒLƒ‹‚ğÄ‘•“U‚·‚é‚½‚ßê—pƒy[ƒW‚Ö”ò‚Î‚·
          random_skill_action
        end
        #ƒg[ƒNƒXƒeƒbƒv‚ğ‚Pi‚ß‚é
        $msg.talk_step += 1
        # ƒXƒeƒbƒv 2 ‚ÉˆÚs‚µÄUŒ‚
        @phase4_step = 2
      #‘Šè‚ªâ’¸‚µ‚Ä‚¢‚½‚çI—¹
      else
        # ƒƒbƒZ[ƒWƒ^ƒO‚ğƒNƒŠƒA
#        $msg.tag = ""
        # ƒAƒNƒVƒ‡ƒ“‹­§‘ÎÛ‚Ìƒoƒgƒ‰[‚ğƒNƒŠƒA
        $game_temp.forcing_battler = nil
        #ŒûãŠÇ—ŒnƒXƒCƒbƒ`‚ğØ‚Á‚Ä‚¨‚­
        for i in 77..82
          $game_switches[i] = false
        end
        #â’¸s“®ƒpƒ^[ƒ“‚ğ‰Šú‰»‚·‚é
        for actor in $game_party.party_actors
          actor.ecstasy_emotion = nil if actor.exist?
        end
        for enemy in $game_troop.enemies
          enemy.ecstasy_emotion = nil if enemy.exist?
        end
        # š’ÇŒ‚”­¶‚Í‘½ds“®—pƒtƒ‰ƒO‚ğ‰º‚°‚é
        @active_battler.another_action = false
        #ƒg[ƒNƒXƒeƒbƒvA’ÇŒ‚UŒ‚è’i‚ğƒŠƒZƒbƒg‚·‚é
        $msg.talk_step = 0
        $msg.at_parts = $msg.at_type = ""
        $msg.t_enemy = $msg.t_target = nil
        $msg.coop_enemy = []
        @combo_break = false
        $msg.moody_flag = false
        $game_switches[89] = false #ƒŒƒWƒXƒgó‘øƒXƒCƒbƒ`
        # ƒXƒeƒbƒv 1 ‚ÉˆÚs
        @phase4_step = 1
      end
    else
      # ƒƒbƒZ[ƒWƒ^ƒO‚ğƒNƒŠƒA
#      $msg.tag = ""
      # ƒAƒNƒVƒ‡ƒ“‹­§‘ÎÛ‚Ìƒoƒgƒ‰[‚ğƒNƒŠƒA
      $game_temp.forcing_battler = nil
      #ŒûãŠÇ—ŒnƒXƒCƒbƒ`‚ğØ‚Á‚Ä‚¨‚­
      for i in 77..82
        $game_switches[i] = false
      end
      #â’¸s“®ƒpƒ^[ƒ“‚ğ‰Šú‰»‚·‚é
      for actor in $game_party.party_actors
        actor.ecstasy_emotion = nil if actor.exist?
      end
      for enemy in $game_troop.enemies
        enemy.ecstasy_emotion = nil if enemy.exist?
      end
      # š‘½ds“®—pƒtƒ‰ƒO‚ğ—§‚Ä‚é
      @active_battler.another_action = true
      #ƒg[ƒNƒXƒeƒbƒvA’ÇŒ‚UŒ‚è’i‚ğƒŠƒZƒbƒg‚·‚é
      $msg.talk_step = 0
      $msg.at_parts = $msg.at_type = ""
      $msg.t_enemy = $msg.t_target = nil
      $msg.coop_enemy = []
      @combo_break = false
      $msg.moody_flag = false
      $game_switches[89] = false #ƒŒƒWƒXƒgó‘øƒXƒCƒbƒ`
      # ƒXƒeƒbƒv 1 ‚ÉˆÚs
      @phase4_step = 1
    end
  end
end