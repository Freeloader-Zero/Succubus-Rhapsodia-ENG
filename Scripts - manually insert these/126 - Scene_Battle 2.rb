#==============================================================================
# ¡ Scene_Battle (•ªŠ„’è‹` 2)
#------------------------------------------------------------------------------
# @ƒoƒgƒ‹‰æ–Ê‚Ìˆ—‚ğs‚¤ƒNƒ‰ƒX‚Å‚·B
#==============================================================================

class Scene_Battle
  #--------------------------------------------------------------------------
  # š ƒXƒ^[ƒgƒtƒF[ƒYŠJn
  #--------------------------------------------------------------------------
  def start_phase0
    # ƒtƒF[ƒY 1 ‚ÉˆÚs
    @phase = 0
    
    #--------------------------------------------------------------------------
    # šƒgƒ‹[ƒvƒGƒlƒ~[‚Ì•\¦
    
    # ƒoƒgƒ‹ƒƒOƒEƒBƒ“ƒhƒE‚ğo‚·
    @battle_log_window.visible = true
    @battle_log_window.bgframe_sprite.visible = true
    # ƒgƒ‹[ƒv‚Ì‰Šúl”‚ğ”‚¦‚é
    n = $game_troop.enemies.size
    for i in 1...$game_troop.enemies.size
      if $game_troop.enemies[i].hidden == true
        n -= 1
      end
    end 
    # ‰Šúl”‚ª‚QlˆÈã‚Ìê‡Au`‚½‚¿v‚ğ‚Â‚¯‚éB
    unless n > 1 
      text = $game_troop.enemies[0].name + " has appeared!"
    else
      if n == 2
      text = "A pair of succubi have appeared!"
      else
      text = "A group of succubi have appeared!"
      end
    end
    $game_temp.battle_log_text += text + "\"
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
    
=begin    
    @appear_turns = []
    for enemy in $game_troop.enemies.reverse
      if enemy.exist?
        @appear_turns.push(enemy) 
      end
    end
=end
    #--------------------------------------------------------------------------
    @phase0_step = 1
  end
  
  #--------------------------------------------------------------------------
  # š ƒXƒ^[ƒgƒtƒF[ƒY@ƒtƒŒ[ƒ€XV
  #--------------------------------------------------------------------------
  def update_phase0
    # Å‰‚Ì–²–‚•\¦’†‚Ì‚ÍXV‚ğ~‚ß‚é
    for enemy in $game_troop.enemies
      return if enemy.start_appear == true
    end
    
    case @phase0_step
    when 1
      update_phase0_step1
    when 2
      update_phase0_step2
    when 3
      update_phase0_step3
    end
  end
  #--------------------------------------------------------------------------
  # š ƒXƒ^[ƒgƒtƒF[ƒY@ƒtƒŒ[ƒ€XV@ƒXƒeƒbƒv‚PFæUŒãUƒƒO
  #--------------------------------------------------------------------------
  def update_phase0_step1
    # @phase0_step2_count ‚²‚Æ‚É‡”Ô‚Éí“¬‘Oˆ—‚ğs‚¤
    
    # šæU‚ğæ‚Á‚½
    if $game_temp.first_attack_flag == 1
      #ƒAƒNƒ^[‚Ìƒtƒ@[ƒXƒgƒAƒ^ƒbƒNƒtƒ‰ƒO‚ğ—§‚Ä‚é
      @actor_first_attack = true
      @enemy_first_attack = false
      @battle_log_window.contents.clear
      @battle_log_window.keep_flag = false
      $game_temp.battle_log_text = ""
      if $game_party.actors.size == 1
        $game_temp.battle_log_text += $game_actors[101].name + " has the initiative!\"
      else
        $game_temp.battle_log_text += $game_actors[101].name + " has the initiative!\"
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
    end
 
    # šæè‚ğæ‚ç‚ê‚½
    if $game_temp.first_attack_flag == 2
      #ƒGƒlƒ~[‚Ìƒtƒ@[ƒXƒgƒAƒ^ƒbƒNƒtƒ‰ƒO‚ğ—§‚Ä‚é
      @actor_first_attack = false
      @enemy_first_attack = true
      @battle_log_window.contents.clear
      @battle_log_window.keep_flag = false
      $game_temp.battle_log_text = ""
      if $game_party.actors.size == 1
        $game_temp.battle_log_text += $game_actors[101].name + " had the initiative taken by the ene‚y!\"
      else
        $game_temp.battle_log_text += $game_actors[101].name + " had the initiative taken by the ene‚y!\"
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
    end

    
    @phase0_step = 2
    @phase0_step2_count = 0
  end
  #--------------------------------------------------------------------------
  # š ƒXƒ^[ƒgƒtƒF[ƒY@ƒtƒŒ[ƒ€XV@ƒXƒeƒbƒv‚PFí“¬‘Oˆ—
  #--------------------------------------------------------------------------
  def update_phase0_step2

    @battle_log_window.contents.clear
    @battle_log_window.keep_flag = false
    $game_temp.battle_log_text = ""

    # ƒoƒgƒ‹ƒCƒxƒ“ƒg
    if @phase0_step2_count == 0
      @phase0_step2_count = 1
      # ƒoƒgƒ‹ƒCƒxƒ“ƒg‚ÌƒZƒbƒgƒAƒbƒv
      setup_battle_event
      return
    end
    # ƒoƒgƒ‹ƒCƒxƒ“ƒgÀs’†‚Ìê‡
    if $game_system.battle_interpreter.running?
      return
    end
    # oŒ»ƒGƒtƒFƒNƒg‚Ìw¦‚ğo‚·
    appear_effect_order(@battlers)
    # ƒtƒFƒCƒY‚ği‚ß‚é
    @phase0_step = 3
  end
  #--------------------------------------------------------------------------
  # š ƒXƒ^[ƒgƒtƒF[ƒY@ƒtƒŒ[ƒ€XV@ƒXƒeƒbƒv‚RFI—¹ˆ—@
  #--------------------------------------------------------------------------
  def update_phase0_step3
    #›í“¬ŠJnŒûã‚ª‚ ‚éê‡‚Í•\¦‚·‚é
    # ‘Sƒoƒgƒ‰[‚ÌƒŠƒZƒbƒg
    
    # í“¬‘OŒûã–³‚µƒXƒCƒbƒ`‚ª‚n‚e‚e‚È‚ç‚Îí“¬‘OŒûã‚ğŒÄ‚Ño‚¹‚é‚æ‚¤‚É‚·‚é
    if $game_switches[59]
      # ‚n‚m‚Ìê‡‚ÍƒXƒCƒbƒ`‚ğØ‚Á‚ÄI—¹‚·‚éB
      $game_switches[59] = false
    else
      #œ“Áêí“¬‚É‰ï˜bƒtƒ‰ƒO‚ğ—§‚Ä‚é
      #šÚ×•\¦’†‚Í•K‚¸‘S‚Ä•\¦
      if $game_switches[95] == true
        #‘ÎÛ–‘O‘I’èÏ‚İƒg[ƒNƒXƒeƒbƒv‚ğİ’è
        $msg.callsign = 40
        $msg.tag = "í“¬ŠJn"
        common_event = $data_common_events[69]
        $game_system.battle_interpreter.setup(common_event.list, 0)
      #šŠÈˆÕ•\¦’†‚ÍAƒxƒbƒhƒCƒ“‚Æƒ{ƒXíˆÈŠO‚ğ•\¦‚µ‚È‚¢
      elsif $game_switches[96] == true
        #ƒxƒbƒhƒCƒ“í“¬
        if ($game_switches[85] == true or
        #ƒ{ƒXí
          $game_switches[91] == true)
          #‘ÎÛ–‘O‘I’èÏ‚İƒg[ƒNƒXƒeƒbƒv‚ğİ’è
          $msg.callsign = 40
          $msg.tag = "í“¬ŠJn"
          common_event = $data_common_events[69]
          $game_system.battle_interpreter.setup(common_event.list, 0)
        end
      #š’Êí‚ÍƒxƒbƒhƒCƒ“Aƒ{ƒXíA‹ó• A‚n‚e‚dAƒŒƒAoŒ»‚É•\¦‚·‚é
      else 
        #ƒxƒbƒhƒCƒ“í“¬
        if ($game_switches[85] == true or
        #‹ó• í“¬
          $game_switches[86] == true or
        #ƒ{ƒXí
          $game_switches[91] == true or
        #OFEí
          $game_switches[92] == true or
        #ƒŒƒAoŒ»í“¬
          $game_switches[93] == true)
          #‘ÎÛ–‘O‘I’èÏ‚İƒg[ƒNƒXƒeƒbƒv‚ğİ’è
          $msg.callsign = 40
          $msg.tag = "í“¬ŠJn"
          common_event = $data_common_events[69]
          $game_system.battle_interpreter.setup(common_event.list, 0)
        end
      end
    end
    start_phase1
  end

  #--------------------------------------------------------------------------
  # œ ƒvƒŒƒoƒgƒ‹ƒtƒF[ƒYŠJn
  #--------------------------------------------------------------------------
  def start_phase1
    # ƒtƒF[ƒY 1 ‚ÉˆÚs
    @phase = 1
    # ƒp[ƒeƒB‘Sˆõ‚ÌƒAƒNƒVƒ‡ƒ“‚ğƒNƒŠƒA
    $game_party.clear_actions

    # šƒoƒgƒ‹ƒƒO‚ğƒNƒŠƒA
    @battle_log_window.contents.clear
    @battle_log_window.keep_flag = false   
    
    # šæè‚ğæ‚ç‚ê‚½
    if $game_temp.first_attack_flag == 2
      start_phase4
    end
    
  end
  #--------------------------------------------------------------------------
  # œ ƒtƒŒ[ƒ€XV (ƒvƒŒƒoƒgƒ‹ƒtƒF[ƒY)
  #--------------------------------------------------------------------------
  def update_phase1
    
    # Ÿ”s”»’è
    if judge
      # Ÿ—˜‚Ü‚½‚Í”s–k‚Ìê‡ : ƒƒ\ƒbƒhI—¹
      return
    end

    
    # ƒp[ƒeƒBƒRƒ}ƒ“ƒhƒtƒF[ƒYŠJn
    start_phase2
  end
  #--------------------------------------------------------------------------
  # œ ƒp[ƒeƒBƒRƒ}ƒ“ƒhƒtƒF[ƒYŠJn
  #--------------------------------------------------------------------------
  def start_phase2
    # ƒtƒF[ƒY 2 ‚ÉˆÚs
    @phase = 2
    # ƒAƒNƒ^[‚ğ”ñ‘I‘ğó‘Ô‚Éİ’è
    @actor_index = -1
    @active_battler = nil

    # šƒoƒgƒ‹ƒƒOƒEƒBƒ“ƒhƒE‚ğÁ‚·
    @battle_log_window.contents.clear
    @battle_log_window.keep_flag = false
    @battle_log_window.visible = false
    @battle_log_window.bgframe_sprite.visible = false
    $game_temp.battle_log_text = ""
    
    # šƒGƒlƒ~[‚Ì•\¦ó‘Ô‚Ì•ÏX
    # æ“ª‚Ì‘¶İ‚µ‚Ä‚¢‚é–²–‚‚ğ‘I‚ÔB
    select_enemy = nil
    for enemy in $game_troop.enemies
      if enemy.exist?
        select_enemy = enemy
        break
      end
    end
    enemies_display(select_enemy) if select_enemy != nil
      
#    # ƒp[ƒeƒBƒRƒ}ƒ“ƒhƒEƒBƒ“ƒhƒE‚ğ—LŒø‰»
#    @party_command_window.active = true
#    @party_command_window.visible = true
#    # ƒAƒNƒ^[ƒRƒ}ƒ“ƒhƒEƒBƒ“ƒhƒE‚ğ–³Œø‰»
#     command_all_delete
#š    @actor_command_window.active = false
#š    @actor_command_window.visible = false
    # ƒƒCƒ“ƒtƒF[ƒYƒtƒ‰ƒO‚ğƒNƒŠƒA
    $game_temp.battle_main_phase = false
    # ƒp[ƒeƒB‘Sˆõ‚ÌƒAƒNƒVƒ‡ƒ“‚ğƒNƒŠƒA
    $game_party.clear_actions
    # ƒRƒ}ƒ“ƒh“ü—Í•s‰Â”\‚Èê‡
    unless $game_party.inputable?
      # ƒƒCƒ“ƒtƒF[ƒYŠJn
      start_phase4
    end
  end
  #--------------------------------------------------------------------------
  # œ ƒtƒŒ[ƒ€XV (ƒp[ƒeƒBƒRƒ}ƒ“ƒhƒtƒF[ƒY)
  #--------------------------------------------------------------------------
  def update_phase2
    
    start_phase3 #š
    
    
#    # C ƒ{ƒ^ƒ“‚ª‰Ÿ‚³‚ê‚½ê‡
#    if Input.trigger?(Input::C)
#      # ƒp[ƒeƒBƒRƒ}ƒ“ƒhƒEƒBƒ“ƒhƒE‚ÌƒJ[ƒ\ƒ‹ˆÊ’u‚Å•ªŠò
#      case @party_command_window.index
#      when 0  # í‚¤
#        # Œˆ’è SE ‚ğ‰‰‘t
#        $game_system.se_play($data_system.decision_se)
#        # ƒAƒNƒ^[ƒRƒ}ƒ“ƒhƒtƒF[ƒYŠJn
#        start_phase3
#      when 1  # “¦‚°‚é
#        # “¦‘–‰Â”\‚Å‚Í‚È‚¢ê‡
#        if $game_temp.battle_can_escape == false
#          # ƒuƒU[ SE ‚ğ‰‰‘t
#         $game_system.se_play($data_system.buzzer_se)
#        return
#      end
#        # Œˆ’è SE ‚ğ‰‰‘t
#      $game_system.se_play($data_system.decision_se)
#        # “¦‘–ˆ—
#     update_phase2_escape
#     end
#     return
#   end
  end
  #--------------------------------------------------------------------------
  # œ ƒtƒŒ[ƒ€XV (ƒp[ƒeƒBƒRƒ}ƒ“ƒhƒtƒF[ƒY : “¦‚°‚é)
  #--------------------------------------------------------------------------
  def update_phase2_escape
    # ƒGƒlƒ~[‚Ì‘f‘‚³•½‹Ï’l‚ğŒvZ
    enemies_agi = 0
    enemies_number = 0
    for enemy in $game_troop.enemies
      if enemy.exist?
        enemies_agi += enemy.agi
        enemies_number += 1
      end
    end
    if enemies_number > 0
      enemies_agi /= enemies_number
    end
    # ƒAƒNƒ^[‚Ì‘f‘‚³•½‹Ï’l‚ğŒvZ
    actors_agi = 0
    actors_number = 0
    for actor in $game_party.actors
      if actor.exist?
        actors_agi += actor.agi
        actors_number += 1
      end
    end
    if actors_number > 0
      actors_agi /= actors_number
    end
    # “¦‘–¬Œ÷”»’è
    success = rand(100) < 50 * actors_agi / enemies_agi
    # “¦‘–¬Œ÷‚Ìê‡
    if success
      # “¦‘– SE ‚ğ‰‰‘t
      $game_system.se_play($data_system.escape_se)
      # ƒoƒgƒ‹ŠJn‘O‚Ì BGM ‚É–ß‚·
      $game_system.bgm_play($game_temp.map_bgm)
      # ƒoƒgƒ‹I—¹
      battle_end(1)
    # “¦‘–¸”s‚Ìê‡
    else
      # ƒp[ƒeƒB‘Sˆõ‚ÌƒAƒNƒVƒ‡ƒ“‚ğƒNƒŠƒA
      $game_party.clear_actions
      # ƒƒCƒ“ƒtƒF[ƒYŠJn
      start_phase4
    end
  end
  #--------------------------------------------------------------------------
  # œ ƒAƒtƒ^[ƒoƒgƒ‹ƒtƒF[ƒYŠJn
  #--------------------------------------------------------------------------
  def start_phase5
    # ƒtƒF[ƒY 5 ‚ÉˆÚs
    @phase = 5
    # ƒtƒ@ƒ“ƒtƒ@[ƒŒƒIƒt‚ª–³‚¢ê‡Aƒoƒgƒ‹I—¹ ME ‚ğ‰‰‘t
    unless @fanfare_off
      $game_system.me_play($game_system.battle_end_me) 
    end
    # Œ_–ñ–²–‚‚ª‚¢‚é‚©‚Ìƒ`ƒFƒbƒN
    contract_check
    if $game_temp.contract_enemy == nil
      # ƒoƒgƒ‹ŠJn‘O‚Ì BGM ‚É–ß‚·
      $game_system.bgm_play($game_temp.map_bgm)
    else
      # Œ_–ñ–²–‚‚ª‚¢‚éê‡‚Í BGM ‚ğÁ‚·
      $game_system.bgm_play(nil)
    end
    # šƒoƒgƒ‹ƒƒOƒEƒBƒ“ƒhƒE‚ğo‚·
    @battle_log_window.visible = true
    @battle_log_window.bgframe_sprite.visible = true
    n = $game_troop.enemies_dead_count
    # l”‚ª‚QlˆÈã‚Ìê‡Au`‚½‚¿v‚ğ‚Â‚¯‚éB
    if n > 1
      if $game_switches[85] == true
        $game_temp.battle_log_text = "The ene‚y succubi have been satisfied!"
      else
        $game_temp.battle_log_text = "The ene‚y succubi have been repelled! "
      end
    else
      if $game_switches[85] == true
        $game_temp.battle_log_text = "The ene‚y succubus has been satisfied!"
      else
        $game_temp.battle_log_text = "The ene‚y succubus has been repelled! "
      end
    end
    # œƒAƒNƒ^[‚ÆƒGƒlƒ~[‚ÌƒŒƒxƒ‹·•ª‚ğZo‚·‚é(••ˆó’†)
#    level_f = a_level = e_level = ect = 0
#    for actor in $game_party.party_actors
#      a_level += actor.level
#    end
#    a_level = (a_level / $game_party.party_actors.size).ceil
    # EXPAƒS[ƒ‹ƒhAƒgƒŒƒWƒƒ[‚ğ‰Šú‰»
    exp = 0
    gold = 0
    treasures = []
    # ƒ‹[ƒv
    for enemy in $game_troop.enemies
      # ƒGƒlƒ~[‚ª‰B‚êó‘Ô‚Å‚È‚¢ê‡
      unless enemy.hidden
        #šƒxƒbƒhƒCƒ“‚ÍAI—¹‚Æ“¯‚ÉƒxƒbƒhƒCƒ“‰ñ”‚ğ‰ÁZ‚·‚é
        if $game_switches[85] == true
          enemy.bedin_count = 0 if enemy.bedin_count == nil
          enemy.bedin_count += 1
        end
        exp += enemy.exp + ((enemy.exp / 3) * $game_party.after_battle_bonus(0))
        gold += enemy.gold + ((enemy.gold / 3) * $game_party.after_battle_bonus(1))
        # ƒgƒŒƒWƒƒ[oŒ»”»’è
        if rand(100) < enemy.treasure_prob + (3 * $game_party.after_battle_bonus(2))
          if enemy.item_id > 0
            treasures.push($data_items[enemy.item_id])
          end
          if enemy.weapon_id > 0
            treasures.push($data_weapons[enemy.weapon_id])
          end
          if enemy.armor_id > 0
            treasures.push($data_armors[enemy.armor_id])
          end
        end
        # šƒgƒŒƒWƒƒ[oŒ»”»’è 
        if enemy.treasure != []
          for treasure in enemy.treasure
            if rand(100) < treasure[2] + $game_party.after_battle_bonus(2)
              case treasure[0]
              when 0
                treasures.push($data_items[treasure[1]])
              when 1
                treasures.push($data_weapons[treasure[1]])
              when 2
                treasures.push($data_armors[treasure[1]])
              end
            end
          end
        end        
        
      end
    end
    # ƒgƒŒƒWƒƒ[‚Ì”‚ğ 6 ŒÂ‚Ü‚Å‚ÉŒÀ’è
    treasures = treasures[0..5]
#    p "‰ŠúŒoŒ±’lF#{exp}"
    # ‘Î•¡”í‚ÅŒoŒ±’lƒAƒbƒv
    annihilation_rate = $game_troop.enemies_dead_count - 1 
    annihilation_rate = (annihilation_rate * 0.2) + 1.0
    exp = (exp * annihilation_rate).truncate
#    p "Ÿr–Å•â³—L‚èF#{exp}"
    # ƒŒƒAƒgƒ‹[ƒv‚Ìê‡AŒoŒ±’l‚ğã‚°‚éB
    exp = (exp * 1.5).truncate if $game_switches[93]
    # •sKó‘Ô‚Ìê‡AŒoŒ±’l‚ğã‚°‚éB
    exp = (exp * 1.5).truncate if $game_party.unlucky?
#    p "ƒŒƒAƒgƒ‹[ƒv•â³—L‚èF#{exp}"
    # EXP Šl“¾
    
    for i in 0...$game_party.party_actors.size
      actor = $game_party.party_actors[i]
      actor.exp_plus_flag = false
      if actor.cant_get_exp? == false
        last_level = actor.level
        temp_exp = exp
        if actor.equip?("‹­‚«Ò‚Ìw—Ö")
          temp_exp = (temp_exp * 1.5).truncate 
          actor.exp_plus_flag = true
        end
        # ƒWƒƒƒCƒAƒ“ƒgƒLƒŠƒ“ƒO•â³
        if $game_troop.enemies_max_level > actor.level + 4
          giant_killing_rate = $game_troop.enemies_max_level - actor.level - 4
          giant_killing_rate = (giant_killing_rate * 0.2) + 1.0
          temp_exp = (temp_exp * giant_killing_rate).truncate
          actor.exp_plus_flag = true
        end
#        p "ÅIæ“¾ŒoŒ±’lF#{temp_exp}"
        actor.exp += temp_exp
        # ƒŒƒxƒ‹ƒAƒbƒvƒtƒ‰ƒO‚ğ—§‚Ä‚é
        if actor.level > last_level
          @status_window.level_up(i)
        end
      end
    end
    # ƒS[ƒ‹ƒhŠl“¾
    $game_party.gain_gold(gold)
    # ƒgƒŒƒWƒƒ[Šl“¾
    for item in treasures
      case item
      when RPG::Item
        $game_party.gain_item(item.id, 1)
      when RPG::Weapon
        $game_party.gain_weapon(item.id, 1)
      when RPG::Armor
        $game_party.gain_armor(item.id, 1)
      end
    end
    
    # ƒq[ƒŠƒ“ƒOˆ—@
    $game_party.healing
    
    # ƒoƒgƒ‹ƒŠƒUƒ‹ƒgƒEƒBƒ“ƒhƒE‚ğì¬
    @result_window = Window_BattleResult.new(exp, gold, treasures)
    # ƒEƒFƒCƒgƒJƒEƒ“ƒg‚ğİ’è
    if Input.press?(Input::CTRL) and ($DEBUG or $game_switches[46])
      @phase5_wait_count = 50
    else
      @phase5_wait_count = 80
    end
  end

  #--------------------------------------------------------------------------
  # œ ƒtƒŒ[ƒ€XV (ƒAƒtƒ^[ƒoƒgƒ‹ƒtƒF[ƒY)
  #--------------------------------------------------------------------------
  def update_phase5
    # ƒEƒFƒCƒgƒJƒEƒ“ƒg‚ª 0 ‚æ‚è‘å‚«‚¢ê‡
    if @phase5_wait_count > 0
      # ƒEƒFƒCƒgƒJƒEƒ“ƒg‚ğŒ¸‚ç‚·
      @phase5_wait_count -= 1
      # ƒEƒFƒCƒgƒJƒEƒ“ƒg‚ª 0 ‚É‚È‚Á‚½ê‡
      if @phase5_wait_count == 0
        # ƒŠƒUƒ‹ƒgƒEƒBƒ“ƒhƒE‚ğ•\¦
        @result_window.visible = true
        # ƒƒCƒ“ƒtƒF[ƒYƒtƒ‰ƒO‚ğƒNƒŠƒA
        $game_temp.battle_main_phase = false
        # ƒŒƒxƒ‹ƒAƒbƒvƒiƒŒ[ƒg
        text = ""
        up_flag = false
        for a in $game_party.party_actors
          # ‘½‚ß‚É–á‚Á‚½ƒiƒŒ[ƒg
          if a.exp_plus_flag == true
            text += "\\#{a.name} received ‚ore experience than usual!"
            a.exp_plus_flag = false
          end
          text += a.level_up_log
          a.level_up_log = ""
          up_flag = true if text != ""
        end
#        $game_temp.battle_log_text += "\\n" + text + "\\" if text != ""
        $game_temp.battle_log_text += text + "\\" if text != ""
        
        # ‚»‚Ì‘¼í“¬Œãˆ—‚Ìƒ`ƒFƒbƒN
        for actor in $game_party.party_actors
          if actor.equip?("ƒƒCƒ‹ƒhƒJ[ƒh")
            actor.armor1_id = 0
            text = "\\#{actor.name}'s e‚‘uipped \\nWild Card has disappeared....."
            $game_temp.battle_log_text += text
          end
          if actor.equip?("èì‚èƒ~ƒTƒ“ƒK")
            # ‚T“ˆÈ‰º‚Åƒ~ƒTƒ“ƒK‚ªØ‚ê‚éB
            if rand(100) < 5
              actor.armor1_id = 0
              actor.promise += 500
              text = "\\#{actor.name}'s e‚‘uipped \nHo‚e‚ade Misanga broke!"
              $game_temp.battle_log_text += text
            end
          end
        end
        
        # ¥ƒVƒXƒeƒ€ƒEƒFƒCƒg
        if $game_system.system_read_mode == 0
          @wait_count = system_wait_make($game_temp.battle_log_text)
        end
        # ƒXƒe[ƒ^ƒXƒEƒBƒ“ƒhƒE‚ğƒŠƒtƒŒƒbƒVƒ…
        @status_window.refresh
      end
      return
    end
    
    
    # C ƒ{ƒ^ƒ“‚ª‰Ÿ‚³‚ê‚½ê‡
    if Input.trigger?(Input::C) or (Input.press?(Input::CTRL) and ($DEBUG or $game_switches[46]))
      if $game_temp.contract_enemy != nil
        start_phase6
      else
        # ƒoƒgƒ‹I—¹
        battle_end(0)
      end
    end
  end
  #--------------------------------------------------------------------------
  # œ Œ_–ñƒtƒF[ƒYŠJn
  #--------------------------------------------------------------------------
  def start_phase6
    # ƒtƒF[ƒY 6 ‚ÉˆÚs
    @phase = 6

    # ƒŠƒUƒ‹ƒgƒEƒBƒ“ƒhƒE‚ğÁ‚·
    @result_window.visible = false
    # šƒoƒgƒ‹ƒƒOƒEƒBƒ“ƒhƒE‚ğƒNƒŠƒA
    @battle_log_window.contents.clear
    @battle_log_window.keep_flag = false
    $game_temp.battle_log_text = ""
    
    enemy = $game_temp.contract_enemy
    @contract = Sprite.new
    bitmap =RPG::Cache.battler(enemy.battler_name, enemy.battler_hue)
    @contract.bitmap = bitmap

    @contract.ox = @contract.bitmap.width / 2
    @contract.oy = @contract.bitmap.height / 2

    @contract.x = 640 / 2
    @contract.y = 480 / 2
    @contract.visible = true
    @contract.opacity = 0
    Audio.se_play("Audio/SE/136-Light02", 80, 100)
    
    @event_switch = false

   
  end
  #--------------------------------------------------------------------------
  # œ ƒtƒŒ[ƒ€XV (ƒAƒtƒ^[ƒoƒgƒ‹ƒtƒF[ƒY)
  #--------------------------------------------------------------------------
  def update_phase6 
    
    if @contract.opacity < 255
      @contract.opacity += 10
      return
    end
    
    if @event_switch == false
      # ƒRƒ‚ƒ“ƒCƒxƒ“ƒguŒ_–ñƒtƒF[ƒYv‚ğÀs
      common_event = $data_common_events[28]
      $game_system.battle_interpreter.setup(common_event.list, 0)
      @event_switch = true
    end
    
    # ƒoƒgƒ‹ƒCƒxƒ“ƒgÀs’†‚Ìê‡
    if $game_system.battle_interpreter.running?
      return
    end
    
    # C ƒ{ƒ^ƒ“‚ª‰Ÿ‚³‚ê‚½ê‡
#    if Input.trigger?(Input::C)
      # ƒoƒgƒ‹ŠJn‘O‚Ì BGM ‚É–ß‚·
      $game_system.bgm_play($game_temp.map_bgm)
      # ƒoƒgƒ‹I—¹
      battle_end(0)
#    end
  end

  #--------------------------------------------------------------------------
  # œ Œ_–ñƒ`ƒFƒbƒN
  #--------------------------------------------------------------------------
  def contract_check
    # Œ_–ñ–²–‚‚Ì‰Šú‰»
    $game_temp.contract_enemy == nil
    # –¡•ûí‚È‚çI—¹
    if $game_switches[85] or $game_switches[86] or $game_temp.absolute_contract == 2
      return
    end
    # ƒp[ƒeƒB‚àƒ{ƒbƒNƒX‚à–„‚Ü‚Á‚Ä‚¢‚éê‡‚àI—¹
    if $game_party.box_max == $game_party.home_actors
      return
    end
    # ÅŒã‚Éc‚Á‚½–²–‚‚Ì—FD“x‚ª100‚É“’B‚µ‚Ä‚¢‚éê‡
    if @last_enemies[0].friendly >= 100
      # ‘¡‚è•¨ƒJƒEƒ“ƒg‚ª‚ ‚éê‡‚Í–³ğŒ
      if @last_enemies[0].present_count > 0
        $game_temp.absolute_contract = 1
      # ƒg[ƒN‰ñ”‚ªŒÀŠE”‚É’B‚µ‚Ä‚¢‚½ê‡‚à–³ğŒ
      elsif @last_enemies[0].pillowtalk >= 3
        $game_temp.absolute_contract = 1
      end
    # —FD“x100–¢–‚¾‚ª50‚ğ‰z‚¦‚Ä‚¢‚éê‡
    elsif @last_enemies[0].friendly >= 50
      # ‘¡‚è•¨ƒJƒEƒ“ƒg‚ª‚P‰ñˆÈã‚ ‚éê‡‚Í•ÊƒJƒEƒ“ƒg
      if @last_enemies[0].present_count > 0
        perc = (@last_enemies[0].present_count * 30)
        #ƒŒƒxƒ‹·•ª‚ğ“K—p(ålŒö‚Ì‚Ù‚¤‚ªƒŒƒxƒ‹‚ª‚‚¯‚ê‚Î’Ç‰Á•â³‚Æ‚È‚é)
        perc -= (@last_enemies[0].level - $game_actors[101].level) * 2
        if rand(100) < perc
          $game_temp.absolute_contract = 1
        end
      end
    # —FD“x50‚É“’B‚µ‚Ä‚¢‚È‚¢ê‡
    else
      # ‘¡‚è•¨ƒJƒEƒ“ƒg‚ª‚P‰ñˆÈã‚ ‚éê‡‚Í•ÊƒJƒEƒ“ƒg
      if @last_enemies[0].present_count > 0
        perc = (@last_enemies[0].present_count * 10)
        #ƒŒƒxƒ‹·•ª‚ğ“K—p(ålŒö‚Ì‚Ù‚¤‚ªƒŒƒxƒ‹‚ª‚‚¯‚ê‚Î’Ç‰Á•â³‚Æ‚È‚é)
        perc -= (@last_enemies[0].level - $game_actors[101].level) * 2
        if rand(100) < perc
          $game_temp.absolute_contract = 1
        end
      end
    end
    # ‚±‚±‚©‚ç’Êíˆ—
    # ÅŒã‚Éc‚Á‚½–²–‚‚Ì—FD“x{ƒ€[ƒh‚ª—”ˆÈ“à‚È‚ç‚ÎŒ_–ñ‰Â”\‚É
    per = @last_enemies[0].friendly * $mood.point / 50
    # ƒƒEƒ‰ƒbƒg‚ÌƒŒƒxƒ‹‚ğ’´‚¦‚Ä‚¢‚éê‡A·‚É”ä—á‚µ‚ÄŠm—¦‚ğŒ¸­‚³‚¹‚é
    if $game_actors[101].level < @last_enemies[0].level
      lv_rate = (@last_enemies[0].level - $game_actors[101].level) * 3
    else
      lv_rate = 0
    end
    per -= lv_rate
    #Œ_–ñ—\’è‚Ì–²–‚‚Æ‰ï˜b‚à‘¡‚è•¨‚à‚µ‚È‚©‚Á‚½ê‡AŠm—¦‚ªŒƒŒ¸‚·‚é
    if @last_enemies[0].pillowtalk == 0 and @last_enemies[0].present_count == 0
      per /= 10
    end
    # ƒp[ƒZƒ“ƒgÅ‘å’l‚Í100
    per = [per,100].min
    # ƒŒƒxƒ‹‚Ì”¼•ª‚Í¸”s—¦‚ªŒ»‚ê‚éB
    per -= @last_enemies[0].level / 2
    # í“¬‚Éo‚Ä‚¢‚éƒƒ“ƒo[‚Ì•â³‚Å‚²‚Ü‚©‚¹‚é
    for actor in $game_party.battle_actors
      per += 10 if actor.equip?("—FD‚Ìƒƒ_ƒ‹")
      per += 10 if actor.have_ability?("ƒJƒŠƒXƒ}")
    end
    
    c = rand(100)
    if per >= c
      $game_temp.contract_enemy = @last_enemies[0]
    end
    # Šm’èŒ_–ñƒtƒ‰ƒO‚ª—§‚Á‚Ä‚é‚È‚çŠm’è‚Å“ü‚ê‚é
    if $game_temp.absolute_contract == 1
      $game_temp.contract_enemy = @last_enemies[0]
    end
  end
end