#==============================================================================
# ¡ Scene_Battle (•ªŠ„’è‹` 5)
#------------------------------------------------------------------------------
# @ƒoƒgƒ‹‰æ–Ê‚Ìˆ—‚ğs‚¤ƒNƒ‰ƒX‚Å‚·B
#==============================================================================

class Scene_Battle
  #--------------------------------------------------------------------------
  # œ Šî–{ƒAƒNƒVƒ‡ƒ“ Œ‹‰Êì¬
  #--------------------------------------------------------------------------
  def make_basic_action_result
    #¥ƒVƒXƒeƒ€ƒEƒFƒCƒg
    case $game_system.ms_skip_mode
    when 3 #è“®‘—‚èƒ‚[ƒh
      @wait_count = $game_system.battle_speed_time(0)
    when 2 #ƒfƒoƒbƒOƒ‚[ƒh
      @wait_count = 8
    when 1 #‰õ‘¬ƒ‚[ƒh
      @wait_count = 12
    else
      @wait_count = $game_system.battle_speed_time(0)
    end
    
    # UŒ‚‚Ìê‡
    if @active_battler.current_action.basic == 0
      # ƒAƒjƒ[ƒVƒ‡ƒ“ ID ‚ğİ’è
      @animation1_id = @active_battler.animation1_id
      @animation2_id = @active_battler.animation2_id
      # s“®‘¤ƒoƒgƒ‰[‚ªƒGƒlƒ~[‚Ìê‡
      if @active_battler.is_a?(Game_Enemy)
        if @active_battler.restriction == 3
          target = $game_troop.random_target_enemy
        elsif @active_battler.restriction == 2
          target = $game_party.random_target_actor
        else
          index = @active_battler.current_action.target_index
          target = $game_party.smooth_target_actor(index)
        end
      end
      # s“®‘¤ƒoƒgƒ‰[‚ªƒAƒNƒ^[‚Ìê‡
      if @active_battler.is_a?(Game_Actor)
        if @active_battler.restriction == 3
          target = $game_party.random_target_actor
        elsif @active_battler.restriction == 2
          target = $game_troop.random_target_enemy
        else
          index = @active_battler.current_action.target_index
          target = $game_troop.smooth_target_enemy(index)
        end
      end
      # ‘ÎÛ‘¤ƒoƒgƒ‰[‚Ì”z—ñ‚ğİ’è
      @target_battlers = [target]
      # ’ÊíUŒ‚‚ÌŒø‰Ê‚ğ“K—p
      for target in @target_battlers
        target.attack_effect(@active_battler)
      end
      return
    end
    # –hŒä‚Ìê‡
    if @active_battler.current_action.basic == 1
      # šƒwƒ‹ƒvƒEƒBƒ“ƒhƒE‘Ñ‚ğ•\¦
      @help_window.window.visible = true
      # ƒwƒ‹ƒvƒEƒBƒ“ƒhƒE‚É "–hŒä" ‚ğ•\¦
      @help_window.set_text($data_system.words.guard, 1)
      #  šƒoƒgƒ‹ƒƒO‚ğ•\¦
      $game_temp.battle_log_text += @active_battler.name + "‚Í–hŒä‚µ‚Ä‚¢‚écc\"
      @phase4_step = 6
      return
    end
    # “¦‚°‚é‚Ìê‡
    if @active_battler.is_a?(Game_Enemy) and
       @active_battler.current_action.basic == 2
      # šƒwƒ‹ƒvƒEƒBƒ“ƒhƒE‘Ñ‚ğ•\¦
      @help_window.window.visible = true
      # ƒwƒ‹ƒvƒEƒBƒ“ƒhƒE‚É "“¦‚°‚é" ‚ğ•\¦
      @help_window.set_text("“¦‚°‚é", 1)
      # šƒoƒgƒ‹ƒƒO‚ğ•\¦
      # “¦‚°‚éƒƒbƒZ[ƒW‚Í•Ê‚ÌêŠ‚É‘‚©‚È‚¢‚Æƒ_ƒ‚İ‚½‚¢B(’²¸’†)
      $game_temp.battle_log_text += @active_battler.name + "‚Í“¦‚°o‚µ‚½I\"
      # “¦‚°‚é
      @active_battler.escape
      @phase4_step = 6
      return
    end
    # ‰½‚à‚µ‚È‚¢‚Ìê‡
    if @active_battler.current_action.basic == 3
      # ƒAƒNƒVƒ‡ƒ“‹­§‘ÎÛ‚Ìƒoƒgƒ‰[‚ğƒNƒŠƒA
      $game_temp.forcing_battler = nil
      # ‰B‚ê‚Ä‚¢‚é–²–‚‚ÆƒXƒ^ƒ“ó‘Ô‚Ì–²–‚‚ÍƒƒO‚ğo‚³‚È‚¢B
      if @active_battler.hidden == false and @active_battler.another_action == false
        if @active_battler.is_a?(Game_Enemy) and not $game_temp.first_attack_flag == 1
          # šƒoƒgƒ‹ƒƒO‚ğ•\¦
          $game_temp.battle_log_text += @active_battler.name + " is observing...\"
        else
          @wait_count = 0
        end
        @phase4_step = 6
        return
      else
        # šƒXƒeƒbƒv 6 ‚ÉˆÚs
        @wait_count = 0
        @phase4_step = 6
        return
      end
    end
    # “¦‘–‚Ìê‡
    if @active_battler.current_action.basic == 2
      # “¦‘–‰Â”\‚Èê‡‚Í“¦‘–
      if @active_battler.can_escape?
        # ƒAƒNƒVƒ‡ƒ“‹­§‘ÎÛ‚Ìƒoƒgƒ‰[‚ğƒNƒŠƒA
        $game_temp.forcing_battler = nil
        @active_battler.white_flash = true
        # šƒoƒgƒ‹ƒƒO‚ğ•\¦
        $game_temp.battle_log_text += @active_battler.name + " ran a‚—ay!\\"
        # ƒEƒFƒCƒg‚ğÄİ’è
        #¥ƒVƒXƒeƒ€ƒEƒFƒCƒg
        case $game_system.ms_skip_mode
        when 3 #è“®‘—‚èƒ‚[ƒh
          @wait_count = 1
        when 2 #ƒfƒoƒbƒOƒ‚[ƒh
          @wait_count = 6
        when 1 #‰õ‘¬ƒ‚[ƒh
          @wait_count = 8
        else
          @wait_count = 12
        end
        # “¦‘– SE ‚ğ‰‰‘t
        $game_system.se_play($data_system.escape_se)
        escape_result
      # “¦‘–•s‰Â”\‚Èê‡‚ÍƒEƒFƒCƒg‚ğ‚O‚É‚µ‚ÄI—¹
      else
        @wait_count = 0
      end
      @phase4_step = 6
      return
    end
    # ƒp[ƒeƒBŒğ‘ã‚Ìê‡
    if @active_battler.current_action.basic == 5
      # Œğ‘ã‰Â”\‚Èê‡‚ÍŒğ‘ã
      if @active_battler.can_escape?
        # Œğ‘ã‘O‚ÌƒXƒe[ƒg‰ñ•œ
        # ¸_A—‡ŒnˆÈŠO‚ÌƒXƒe[ƒg‚ğ‘S‚Ä‰ğœ
        for n in @active_battler.states
          @active_battler.remove_state(n) unless [1,4,5].include?(n)
        end
        @active_battler.remove_states_log.clear
        #ƒz[ƒ‹ƒh‘S‰ğœ
        @active_battler.hold_reset
        # •¡»‚ğì‚é
        actor_1 = $game_party.party_actors[@active_battler.change_index[0]]#.dup
        actor_2 = $game_party.party_actors[@active_battler.change_index[1]]#.dup
        # w’è‚µ‚½ƒƒ“ƒo[‚ğŒğ‘ã‚·‚é
        $game_party.party_actors[@active_battler.change_index[0]] = actor_2
        $game_party.party_actors[@active_battler.change_index[1]] = actor_1
        $game_party.battle_actor_refresh
        @active_battler = $game_party.party_actors[@active_battler.change_index[0]]
        # ‰æ‘œ•ÏX
        @active_battler.graphic_change = true
        #œí“¬ŠJnˆ—ŠÖ˜A‚Åİ’è˜R‚ê‚ª‚ ‚ê‚ÎÄ“xİ’è
        actor_2.state_runk = [0, 0, 0, 0, 0, 0] if actor_2.state_runk == nil
        actor_2.ecstasy_count = [] if actor_2.ecstasy_count == nil
        actor_2.crisis_flag = false
        actor_2.skill_collect = nil
        actor_2.hold_reset
        actor_2.lub_male = 0 if actor_2.lub_male == nil or not actor_2.lub_male > 0
        actor_2.lub_female = 0 if actor_2.lub_female == nil or not actor_2.lub_female > 0
        actor_2.lub_anal = 0 if actor_2.lub_anal == nil or not actor_2.lub_anal > 0
        actor_2.used_mouth = 0 if actor_2.used_mouth == nil or not actor_2.used_mouth > 0
        actor_2.used_anal = 0 if actor_2.used_anal == nil or not actor_2.used_anal > 0
        actor_2.used_sadism = 0 if actor_2.used_sadism == nil or not actor_2.used_sadism > 0
        actor_2.ecstasy_turn = 0 if actor_2.ecstasy_turn == nil
        actor_2.ecstasy_emotion = nil
        actor_2.sp_down_flag = false if actor_2.sp_down_flag == nil or actor_2.sp_down_flag == true
        actor_2.resist_count = 0 if actor_2.resist_count == nil
        actor_2.add_states_log.clear
        actor_2.remove_states_log.clear
        #ƒxƒbƒhƒCƒ“A‹ó• PŒ‚‚ÍÅ‰‚©‚çã“_ƒ`ƒFƒbƒN‚ğtrue‚É‚·‚é
        if $game_switches[85] == true or $game_switches[86] == true
          actor_2.checking = 1
        else
          actor_2.checking = 0
        end
        # ƒoƒgƒ‹ƒƒO‚ğ•\¦
        $game_temp.battle_log_text += actor_1.name + " and " + actor_2.name + "\\n s‚—itched places!\\"
        # ƒXƒe[ƒ^ƒX‰æ–Ê‚ğƒŠƒtƒŒƒbƒVƒ…
        @status_window.refresh
        # ƒAƒNƒVƒ‡ƒ“‹­§‘ÎÛ‚Ìƒoƒgƒ‰[‚ğƒNƒŠƒA
        $game_temp.forcing_battler = nil
        # ƒAƒjƒ[ƒVƒ‡ƒ“‚ğ•\¦
        @active_battler.animation_id = 18
        @active_battler.animation_hit = true
        # oŒ»ƒGƒtƒFƒNƒg‚ÌƒtƒFƒCƒY‚Ö
        appear_effect_order([@active_battler])
      # Œğ‘ã•s‰Â”\‚Èê‡‚ÍƒEƒFƒCƒg‚ğ‚O‚É‚µ‚ÄI—¹
      else
        @wait_count = 0
      end
      @phase4_step = 6
      return
    end
  end
  #--------------------------------------------------------------------------
  # œ ƒtƒŒ[ƒ€XV (ƒp[ƒeƒBƒRƒ}ƒ“ƒhƒtƒF[ƒY : “¦‚°‚é)
  #--------------------------------------------------------------------------
  def escape_result
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
        agi_one = actor.agi
        # –ƒáƒ‚Í‘f‘‚³‚ğ1/10ˆµ‚¢‚É‚·‚éB
        agi_one /= 10 if actor.state?(39)
        actors_agi += agi_one
        actors_number += 1
      end
    end
    if actors_number > 0
      # •½‹Ï’l‚ğZo
      actors_agi /= actors_number
      # ‘S‘Ì“¦‘–•â³‚Í‚±‚±‚ÅŠ|‚¯‚é
      actors_agi += actors_agi / 2 if @active_battler.equip?("“¦‘–‚ÌƒAƒ“ƒNƒŒƒbƒg")
      actors_agi += actors_agi / 2 if @active_battler.have_ability?("“¦‘–‚Ì‹ÉˆÓ")
    end
    # “¦‘–¬Œ÷”»’è
    success = rand(100) < 50 * actors_agi / enemies_agi
    # “¦‘–¬Œ÷‚Ìê‡(æ§‚Í‚P‚O‚O““¦‚°‚ç‚ê‚é)
    if success or @actor_first_attack == true
      @escape_success = true
    # “¦‘–¸”s‚Ìê‡
    else
      # šƒoƒgƒ‹ƒƒO‚ğ•\¦
      $game_temp.battle_log_text += "‚µ‚©‚µ‰ñ‚è‚±‚Ü‚ê‚Ä‚µ‚Ü‚Á‚½I\"
      # ƒEƒFƒCƒg‚ğÄİ’è
      #¥ƒVƒXƒeƒ€ƒEƒFƒCƒg
      case $game_system.ms_skip_mode
      when 3 #è“®‘—‚èƒ‚[ƒh
        @wait_count = $game_system.battle_speed_time(0)
      when 2 #ƒfƒoƒbƒOƒ‚[ƒh
        @wait_count = 8
      when 1 #‰õ‘¬ƒ‚[ƒh
        @wait_count = 12
      else
        @wait_count = $game_system.battle_speed_time(0)
      end
      #‘ÎÛ–‘O‘I’èÏ‚İƒg[ƒNƒXƒeƒbƒv‚ğİ’è
      $msg.callsign = 40
      $msg.talk_step = 100
=begin
      talk = []
      for enemy in $game_troop.enemies
        if enemy.talkable?
          talk.push(enemy)
        end
      end
      talk.push($game_actors[101]) if talk == []
      $msg.t_enemy = talk[rand(talk.size)]
      $msg.t_target = $game_actors[101]
=end
      $msg.tag = "“¦‘–¸”s"
      @common_event_id = 31
      #ˆ—‚ªI‚í‚Á‚½‚ç•K‚¸ƒXƒeƒbƒv‚ğ‚O‚É–ß‚·
      $msg.talk_step = 0
    end
  end
  #--------------------------------------------------------------------------
  # œ ƒXƒLƒ‹‚Ü‚½‚ÍƒAƒCƒeƒ€‚Ì‘ÎÛ‘¤ƒoƒgƒ‰[İ’è
  #     scope : ƒXƒLƒ‹‚Ü‚½‚ÍƒAƒCƒeƒ€‚ÌŒø‰Ê”ÍˆÍ
  #--------------------------------------------------------------------------
  def set_target_battlers(scope, skill_id = nil)
    
    # ’Ç‹L
    # ˆø”‚Éskill_id‚ğ’Ç‰Á‚µA‘ÎÛ‚ÌƒXƒ€[ƒY‚ÈŒˆ’è‚ÉƒXƒLƒ‹ID‚ğˆø‚«Œp‚®‚æ‚¤‚É‚µ‚Ü‚µ‚½B
    
    # s“®‘¤ƒoƒgƒ‰[‚ªƒGƒlƒ~[‚Ìê‡
    if @active_battler.is_a?(Game_Enemy)
      # Œø‰Ê”ÍˆÍ‚Å•ªŠò
      case scope
      when 1  # “G’P‘Ì
        index = @active_battler.current_action.target_index
#        p "s“®F#{@active_battler.name}/‘ÎÛindexF#{index}"if $DEBUG
        @target_battlers.push($game_party.smooth_target_actor(index, skill_id))
      when 2  # “G‘S‘Ì
        for actor in $game_party.actors
          if actor.exist?
            @target_battlers.push(actor)
          end
        end
      when 3  # –¡•û’P‘Ì
        index = @active_battler.current_action.target_index
        @target_battlers.push($game_troop.smooth_target_enemy(index,skill_id))
      when 4  # –¡•û‘S‘Ì
        for enemy in $game_troop.enemies
          if enemy.exist?
            @target_battlers.push(enemy)
          end
        end
      when 5  # –¡•û’P‘Ì (HP 0) 
        index = @active_battler.current_action.target_index
        enemy = $game_troop.enemies[index]
        if enemy != nil and enemy.hp0?
          @target_battlers.push(enemy)
        end
      when 6  # –¡•û‘S‘Ì (HP 0) 
        for enemy in $game_troop.enemies
          if enemy != nil and enemy.hp0?
            @target_battlers.push(enemy)
          end
        end
      when 7  # g—pÒ
        @target_battlers.push(@active_battler)
      end
    end
    # s“®‘¤ƒoƒgƒ‰[‚ªƒAƒNƒ^[‚Ìê‡
    if @active_battler.is_a?(Game_Actor)
      # Œø‰Ê”ÍˆÍ‚Å•ªŠò
      case scope
      when 1  # “G’P‘Ì
        index = @active_battler.current_action.target_index
        @target_battlers.push($game_troop.smooth_target_enemy(index,skill_id))
      when 2  # “G‘S‘Ì
        for enemy in $game_troop.enemies
          if enemy.exist?
            @target_battlers.push(enemy)
          end
        end
      when 3  # –¡•û’P‘Ì
        index = @active_battler.current_action.target_index
        @target_battlers.push($game_party.smooth_target_actor(index,skill_id))
      when 4  # –¡•û‘S‘Ì
        for actor in $game_party.actors
          if actor.exist?
            @target_battlers.push(actor)
          end
        end
      when 5  # –¡•û’P‘Ì (HP 0) 
        index = @active_battler.current_action.target_index
        actor = $game_party.actors[index]
        if actor != nil and actor.hp0?
          @target_battlers.push(actor)
        end
      when 6  # –¡•û‘S‘Ì (HP 0) 
        for actor in $game_party.actors
          if actor != nil and actor.hp0?
            @target_battlers.push(actor)
          end
        end
      when 7  # g—pÒ
        @target_battlers.push(@active_battler)
      end
    end
  end
  #--------------------------------------------------------------------------
  # œ ƒXƒLƒ‹ƒAƒNƒVƒ‡ƒ“ Œ‹‰Êì¬
  #--------------------------------------------------------------------------
  def make_skill_action_result
    # ƒXƒLƒ‹‚ğæ“¾
    @skill = $data_skills[@active_battler.current_action.skill_id]
    
    # nil‘Îô
    if @skill == nil
      @skill = $data_skills[299] # ƒGƒ‚[ƒVƒ‡ƒ“
    end
    
    # ‹­§ƒAƒNƒVƒ‡ƒ“’†ˆÈŠOŠ‚ÂƒXƒLƒ‹‚ªg—p•s‰Â‚Èê‡
    if not @active_battler.current_action.forcing and @active_battler.is_a?(Game_Actor)
      # ƒXƒLƒ‹‚ª‘Ã‹¦‚Å‚«‚éê‡A‘Ã‹¦‚µ‚Äƒ`ƒFƒbƒNB
      # ‘Ã‹¦‚µ‚Ä‚àg—p•s‰Â”\‚Èê‡‚Í‘¦I—¹
      end_flag = false
      while end_flag == false
        unless @active_battler.skill_can_use?(@skill.id)
          # ƒwƒ”ƒBƒsƒXƒgƒ“¨ƒsƒXƒgƒ“
          if @skill.id == 33
            new_id = 32
            @skill = $data_skills[new_id]
            @active_battler.current_action.skill_id = new_id
            next
          end
          $game_temp.forcing_battler = nil
          @active_battler.another_action = true
          @phase4_step = 1
          return
        end
        end_flag = true
      end
    end
    # ˆØ•|‚Ìê‡A‚R‚O“‚ÌŠm—¦‚Ås“®•s”\‚É‚È‚é
    # (‚½‚¾‚µŠù‚ÉƒƒCƒNƒAƒNƒVƒ‡ƒ“‚ÅˆØ•|s“®‚ªƒZƒbƒg‚³‚ê‚½ê‡‚Í”ò‚Î‚·)
    unless @skill.id == 297
      if @active_battler.states.include?(38) and rand(100) < 30
        @skill = $data_skills[297]
        @active_battler.current_action.forcing = true
        @active_battler.another_action = false
      end
    end
    # –\‘–‚Ìê‡A•K‚¸ƒ‰ƒ“ƒ_ƒ€ƒAƒNƒVƒ‡ƒ“‚Æ‚È‚é
    if @active_battler.state?(36) and not @active_battler.berserk == false
      @active_battler.berserk = true
    elsif @active_battler.berserk == true and not @active_battler.state?(36)
      @active_battler.berserk = false
    end
    if @active_battler.berserk == true and $game_switches[78] == false
      @skill = $data_skills[296] if @skill.id != 296
      @active_battler.another_action = false
#      @active_battler.current_action.forcing = true
    end

#    p "g—pƒXƒLƒ‹(ŠJn)F#{@skill.name}" if $DEBUG
#    p @active_battler.current_action.kind if $DEBUG
    # ‘ÎÛ‘¤ƒoƒgƒ‰[‚ğİ’è
    set_target_battlers(@skill.scope, @skill.id)
    # šƒ^[ƒQƒbƒgƒoƒgƒ‰[‚Ìî•ñ‚ğ‹L‰¯@¦ƒRƒ‚ƒ“ƒCƒxƒ“ƒg‚Åg‚¢‚Ü‚·B
    $game_temp.battle_target_battler = @target_battlers
#    p "s“®5-2F#{@active_battler.name}/‘ÎÛindexF#{@active_battler.current_action.target_index}"if $DEBUG
#    p "‘ÎÛ(ŠJn)F#{@target_battlers[0].name}" if $DEBUG

    # šƒ‰ƒ“ƒ_ƒ€ƒXƒLƒ‹‚ğg—p‚·‚éê‡Aê—pƒy[ƒW‚Ö”ò‚Î‚·
    if @skill.element_set.include?(9)
#      p $data_skills[@active_battler.current_action.skill_id].name
      random_skill_action
    end
    
    # ƒGƒ‰[ƒeƒLƒXƒg‚ğ‰Šú‰»
    @error_text = ""
   
    # š---------------------------------------------------------------

    # UŒ‚‘¤‚ªƒGƒlƒ~[‚Ìê‡
    if @active_battler.is_a?(Game_Enemy)
      ct = 0
      # ¡’Ç‹L•”•ª-----------------------------------  
      #
      # ”­“®•s‰Â‚ÈƒXƒLƒ‹‚Ìê‡A”­“®‰Â”\‚È‚à‚Ì‚ªo‚é‚Ü‚Å‘I‚Ñ’¼‚µ
      #
      # ------------------------------------------------------------

      loop do
        #----------------------------------------------------------------
        # ¡ ƒGƒ‰[W
        #----------------------------------------------------------------
        # ƒGƒ‰[—p•Ï”‚ğƒŠƒZƒbƒg
        n = 0
        a = 0
#        a = 1 if $DEBUG
        # šƒ^[ƒQƒbƒg—Dæ‡ˆÊ
        #   –Ï·(ƒƒEƒ‰ƒbƒg‚µ‚©‘_‚í‚È‚¢)„ƒz[ƒ‹ƒh‘ÎÛ„ƒCƒ“ƒgƒ‰ƒXƒg„ƒAƒs[ƒ‹„ƒ}[ƒLƒ“ƒO
        # ¡ƒAƒs[ƒ‹ó‘Ô‚Ìƒp[ƒgƒi[‚ª‚¢‚éê‡A‚»‚¿‚ç‚ÉUŒ‚‚ªW’†‚·‚é
        #   ‚½‚¾‚µƒg[ƒN’†A‘}“ü’†‚Í‚»‚ÌŒÀ‚è‚Å‚Í‚È‚¢
        
        # Œ³‚Ì‚u‚oÁ”ï‚ª‚OŠ‚ÂA‹•’E“™‚ÅÁ”ï‚u‚o‚ªŒ»İ‚Ì‚u‚o‚æ‚è‰º‰ñ‚Á‚Ä‚¢‚éê‡A
        # ‘¦¬‹x~‚É‚·‚é
        if SR_Util.sp_cost_result(@active_battler, @skill) >= @active_battler.sp and
         @skill.sp_cost == 0
          # ¬‹x~‚ğg—p‚·‚é
          @active_battler.current_action.skill_id = 970
          @skill = $data_skills[@active_battler.current_action.skill_id]
          @active_battler.current_action.kind = 1
          if @skill.scope == 7 #©•ª‚És‚¤‚à‚Ì
            $game_temp.attack_combo_target = @active_battler
            @target_battlers = []
            @target_battlers.push($game_temp.attack_combo_target)
            # šƒ^[ƒQƒbƒgƒoƒgƒ‰[‚Ìî•ñ‚ğ‹L‰¯
            $game_temp.battle_target_battler = @target_battlers
          end
          if @active_battler.is_a?(Game_Enemy)
            @active_battler.current_action.decide_random_target_for_enemy
          end
          $game_temp.battle_target_battler = @target_battlers
          # œ‹L‰¯‚µ‚½ƒXƒLƒ‹‚ğ‰ğœ
          $game_temp.skill_selection = nil
          break
        end
        
        #‘Î–¡•ûí(‹ó• AƒxƒbƒhƒCƒ“)‚Íˆê•”–‚–@‚ğ§ŒÀ‚·‚é
        if ($game_switches[85] == true or $game_switches[86] == true)
          #Š®‘S‚Ég—p•s‰Â‚Ìê‡
          if @skill.element_set.include?(69)
            n = 1
            p "‘Î–¡•ûí‚Íg—p•s‰Â" if a == 1
          #§ŒÀ‚ª‚©‚©‚éê‡‚ÍA‚P^‚Q‚ÌŠm—¦‚ÅÄ’²®
          elsif @skill.element_set.include?(68)
            if rand(100) > 20
              n = 1
              p "‘Î–¡•ûí‚Ì§ŒÀ‚É‚æ‚èg—p•s‰Â" if a == 1
            end
          end
        end
        # ¡ƒz[ƒ‹ƒh’†‚Ì‘Šè‚Ì‚İ‚ğ‘ÎÛ‚Æ‚·‚éƒXƒLƒ‹‚Ì‘I’è
        if @skill.element_set.include?(189)
          unless @target_battlers[0].holding?
            n = 1
            p "ƒz[ƒ‹ƒh’†‚ÌƒLƒƒƒ‰ƒNƒ^[‚Å‚È‚¢‚Ì‚Å•s‰Â" if a == 1
          end
        # ¡”ñƒz[ƒ‹ƒhó‘Ô‚Ì‘Šè‚Ì‚İ‚ğ‘ÎÛ‚Æ‚·‚éƒXƒLƒ‹‚Ì‘I’è
        elsif @skill.element_set.include?(188)
          if @target_battlers[0].holding?
            n = 1
            p "ƒz[ƒ‹ƒh’†‚ÌƒLƒƒƒ‰ƒNƒ^[‚È‚Ì‚Å•s‰Â" if a == 1
          end
        end
        # ¡–‚–@ƒXƒLƒ‹‚Ìê‡A©g‚ªƒz[ƒ‹ƒh’†‚¾‚Æg—p•s‰Â
        if @skill.element_set.include?(5)
        #----------------------------------------------------------------
          if @active_battler.holding?
            n = 1
            p "©g‚ªƒz[ƒ‹ƒh’†‚È‚Ì‚Åg—p•s‰Â" if a == 1
          end
        end
        # ¡©•ª‚ğ‘ÎÛ‚Éæ‚ê‚È‚¢ƒXƒLƒ‹‚Å©•ª‚ğ‘I‘ğ‚µ‚½ê‡g—p•s‰Â
        if @skill.element_set.include?(19)
        #----------------------------------------------------------------
          if @active_battler == @target_battlers[0]
            n = 1
            p "©•ª‚ğ‘ÎÛ‚Éæ‚ê‚È‚¢ƒXƒLƒ‹‚È‚Ì‚Åg—p•s‰Â" if a == 1
          end
        end
        # ¡©•ªF’…ˆß’†•s‰Â‚ÌƒXƒLƒ‹‚Ìê‡
        if @skill.element_set.include?(177)
        #----------------------------------------------------------------
          #Œû‘}“ü(ƒz[ƒ‹ƒhƒ^ƒCƒvF‘}“ü‚Å‘ÎÛ‚ªŒû)‚ğœ‚­‘}“ü‚ÍA‘Šè‚ª‘}“ü‰Â”\‚Èó‹µ‚Å‚È‚¯‚ê‚Î’e‚­
          if @skill.element_set.include?(134)
            unless @skill.element_set.include?(91)
              unless (@active_battler.insertable_half_nude? or @active_battler.full_nude?)
                n = 1
                p "ƒGƒlƒ~[‘¤‚ª’…ˆß‚Ì‚½‚ß•s‰Â(‘}“üŒn)F#{@active_battler.name}F#{@skill.name}" if a == 1
              end
            end
          # ©•ª‚ª’…ˆßó‘Ô‚Å‚ ‚éê‡
          elsif not @active_battler.full_nude?
            n = 1
            p "ƒGƒlƒ~[‘¤‚ª’…ˆß‚Ì‚½‚ß•s‰ÂF#{@active_battler.name}F#{@skill.name}" if a == 1
          end
        end
        # ¡‘ŠèF’…ˆß’†•s‰Â‚ÌƒXƒLƒ‹‚Ìê‡
        if @skill.element_set.include?(178)
        #----------------------------------------------------------------
          #Œû‘}“ü(ƒz[ƒ‹ƒhƒ^ƒCƒvF‘}“ü‚Å‘ÎÛ‚ªŒû)‚ğœ‚­‘}“ü‚ÍA‘Šè‚ª‘}“ü‰Â”\‚Èó‹µ‚Å‚È‚¯‚ê‚Î’e‚­
          if @skill.element_set.include?(134)
            unless @skill.element_set.include?(91)
              unless (@target_battlers[0].insertable_half_nude? or @target_battlers[0].full_nude?)
                n = 1
                p "ƒAƒNƒ^[‘¤‚ª’…ˆß‚Ì‚½‚ß•s‰Â(‘}“üŒn)F#{@target_battlers[0].name}F#{@skill.name}" if a == 1
              end
            end
          # ‘Šè‚ª’…ˆßó‘Ô‚Å‚ ‚éê‡
          elsif not @target_battlers[0].full_nude?
            n = 1
            p "ƒAƒNƒ^[‘¤‚ª’…ˆß‚Ì‚½‚ß•s‰ÂF#{@target_battlers[0].name}F#{@skill.name}" if a == 1
          end
        end
        # ¡©•ªF’Eˆß’†•s‰Â‚ÌƒXƒLƒ‹‚Ìê‡
        if @skill.element_set.include?(179)
        #----------------------------------------------------------------
          # ©•ª‚ª—‡ó‘Ô‚Å‚ ‚éê‡
          if @active_battler.nude?
            n = 1
            p "ƒGƒlƒ~[‘¤‚ª—‡‚Ì‚½‚ß•s‰ÂF#{@active_battler.name}F#{@skill.name}" if a == 1
          end
        end
        # ¡‘ŠèF’Eˆß’†•s‰Â‚ÌƒXƒLƒ‹‚Ìê‡
        if @skill.element_set.include?(180)
        #----------------------------------------------------------------
          # ‘Šè‚ª—‡ó‘Ô‚Å‚ ‚éê‡
          if @target_battlers[0].full_nude?
            n = 1
            p "ƒAƒNƒ^[‘¤‚ª—‡‚Ì‚½‚ß•s‰ÂF#{@target_battlers[0].name}F#{@skill.name}" if a == 1
          end
        end

      
        # ¡ƒz[ƒ‹ƒh’†—D¨ê—pƒXƒLƒ‹‚Ìê‡
        if @skill.element_set.include?(137) and @active_battler.holding?
        #------------------------------------------------------------------------
          # ©•ª‚ª—ò¨‚Ìê‡
          unless @active_battler.initiative?
            n = 1
          end
        end
        # ¡ƒz[ƒ‹ƒh’†—ò¨ê—pƒXƒLƒ‹‚Ìê‡
        #------------------------------------------------------------------------
        if @skill.element_set.include?(138) and @active_battler.holding?
          # ©•ª‚ª—ò¨‚Ìê‡
          if @active_battler.initiative?
            n = 1
          end
        end
        #------------------------------------------------------------------------
        # ¡©•ªF‰è—L’†•s‰Â‚ÌƒXƒLƒ‹‚Ìê‡
        if @skill.element_set.include?(140)
          # ©•ª‚ÌƒyƒjƒX‚ª’N‚©ƒoƒgƒ‰[‚Åè—L‚³‚ê‚Ä‚¢‚ê‚Î•s‰Â
          if @active_battler.hold.penis.battler != nil
            n = 1
          end
        end
        #------------------------------------------------------------------------
        # ¡‘ŠèF‰è—L’†•s‰Â‚ÌƒXƒLƒ‹‚Ìê‡
        if @skill.element_set.include?(141)
          # ©•ª‚ÌƒyƒjƒX‚ª’N‚©ƒoƒgƒ‰[‚Åè—L‚³‚ê‚Ä‚¢‚ê‚Î•s‰Â
          if @target_battlers[0].hold.penis.battler != nil
            n = 1
          end
        end
        # ¡‰è—L’†‚Ì‚İ‰Â‚ÌƒXƒLƒ‹‚Ìê‡
        #------------------------------------------------------------------------
        if @skill.element_set.include?(142)
          # ©•ª‚Ì‰‚ªŠ‘}“üó‘Ô‚Å–³‚¢ê‡
          unless @active_battler.penis_insert?
            n = 1
          end
        end
        if @skill.element_set.include?(143)
        # ©•ª‚Ì‰‚ªŒûˆúó‘Ô‚Å–³‚¢ê‡
          unless @active_battler.penis_oralsex?
            n = 1
          end
        end
        if @skill.element_set.include?(144)
        # ©•ª‚Ì‰‚ªãèŠ­ó‘Ô‚Å–³‚¢ê‡
          unless @active_battler.penis_analsex?
            n = 1
          end
        end
        #------------------------------------------------------------------------
        # ¡©•ªFŒûè—L’†•s‰Â‚ÌƒXƒLƒ‹‚Ìê‡
        if @skill.element_set.include?(146)
          # Œû‚ªè—L’†‚Ìê‡
          if @active_battler.hold.mouth.battler != nil
            n = 1
          end
        end
        # ¡‘ŠèFŒûè—L’†•s‰Â‚ÌƒXƒLƒ‹‚Ìê‡
        if @skill.element_set.include?(147)
          # Œû‚ªè—L’†‚Ìê‡
          if @target_battlers[0].hold.mouth.battler != nil
            n = 1
          end
        end
        # ¡Œû‘}“ü’†‚Ì‚İ‰Â‚ÌƒXƒLƒ‹‚Ìê‡
        #------------------------------------------------------------------------
        if @skill.element_set.include?(148)
        # ©•ª‚ÌŒû‚ªŒû‘}“üó‘Ô‚Å–³‚¢ê‡
          unless @active_battler.mouth_oralsex?
            n = 1
          end
        end
        if @skill.element_set.include?(149)
        # ©•ª‚ÌŒû‚ªŠç–Ê‹Ræó‘Ô‚Å–³‚¢ê‡
          unless @active_battler.mouth_riding?
            n = 1
          end
        end
        if @skill.element_set.include?(145)
        # ©•ª‚ÌŒû‚ªK‹Ræó‘Ô‚Å–³‚¢ê‡
          unless @active_battler.mouth_hipriding?
            n = 1
          end
        end
        if @skill.element_set.include?(150)
        # ©•ª‚ÌŒû‚ªƒNƒ“ƒjó‘Ô‚Å–³‚¢ê‡
          unless @active_battler.mouth_draw?
            n = 1
          end
        end
        if @skill.element_set.include?(170)
        # ©•ª‚ÌŒû‚ªDƒLƒbƒXó‘Ô‚Å–³‚¢ê‡
          unless @active_battler.deepkiss?
            n = 1
          end
        end
        #------------------------------------------------------------------------
        # ¡©•ªFKè—L’†•s‰Â‚ÌƒXƒLƒ‹‚Ìê‡
        if @skill.element_set.include?(151)
          # ©•ª‚ªK‘}“ü’†‚Ìê‡
          if @active_battler.hold.anal.battler != nil
            n = 1
          end
        end
        # ¡‘ŠèFKè—L’†•s‰Â‚ÌƒXƒLƒ‹‚Ìê‡
        if @skill.element_set.include?(152)
          # ©•ª‚ªK‘}“ü’†‚Ìê‡
          if @target_battlers[0].hold.anal.battler != nil
            n = 1
          end
        end
        # ¡Kè—L’†‚Ì‚İ‰Â‚ÌƒXƒLƒ‹‚Ìê‡
        #------------------------------------------------------------------------
        if @skill.element_set.include?(153)
          # ©•ª‚ÌK‚ªK‘}“üó‘Ô‚Å–³‚¢ê‡
          unless @active_battler.anal_analsex?
            n = 1
          end
        end
        if @skill.element_set.include?(154)
          # ©•ª‚ÌK‚ªK‹Ræó‘Ô‚Å–³‚¢ê‡
          unless @active_battler.anal_hipriding?
            n = 1
          end
        end
        #------------------------------------------------------------------------
        # ¡©•ªFŠè—L’†•s‰Â‚ÌƒXƒLƒ‹‚Ìê‡
        if @skill.element_set.include?(155)
          # ©•ª‚ªŠè—L’†‚Ìê‡
          if @active_battler.hold.vagina.battler != nil
            n = 1
          end
        end
        # ¡‘ŠèFŠè—L’†•s‰Â‚ÌƒXƒLƒ‹‚Ìê‡
        if @skill.element_set.include?(156)
          # ‘Šè‚ªŠè—L’†‚Ìê‡
          if @target_battlers[0].hold.vagina.battler != nil
            n = 1
          end
        end
        # ¡Šè—L’†‚Ì‚İ‰Â‚ÌƒXƒLƒ‹‚Ìê‡
        #------------------------------------------------------------------------
        if @skill.element_set.include?(157)
        # ©•ª‚ÌŠ‚ªŠ‘}“üó‘Ô‚Å–³‚¢ê‡
          unless @active_battler.vagina_insert?
            n = 1
          end
        end
        if @skill.element_set.include?(158)
        # ©•ª‚ÌŠ‚ª‹Ræó‘Ô‚Å–³‚¢ê‡
          unless @active_battler.vagina_riding?
            n = 1
          end
        end
        if @skill.element_set.include?(159)
        # ©•ª‚ÌŠ‚ªŠL‡‚í‚¹ó‘Ô‚Å–³‚¢ê‡
          unless @active_battler.shellmatch?
            n = 1
          end
        end
        #------------------------------------------------------------------------
        # ¡©•ªFã”¼gè—L’†•s‰Â‚ÌƒXƒLƒ‹‚Ìê‡
        if @skill.element_set.include?(161)
          # ©•ª‚ªã”¼gè—L’†‚Ìê‡
          if @active_battler.hold.tops.battler != nil
            @error_text = "©•ª‚ªã”¼gè—L’†‚Åã”¼gg—p"
            n = 1
          end
        end
        if @skill.element_set.include?(162)
          # ©•ª‚ªã”¼gè—L’†‚Ìê‡
          if @target_battlers[0].hold.tops.battler != nil
            @error_text = "©•ª‚ªã”¼gè—L’†‚Åã”¼gg—p"
            n = 1
          end
        end
        # ¡ã”¼gè—L’†‚Ì‚İ‰Â‚ÌƒXƒLƒ‹‚Ìê‡
        #------------------------------------------------------------------------
        if @skill.element_set.include?(163)
        # ©•ª‚Ìã”¼g‚ªS‘©ó‘Ô(U‚ßè)‚Å–³‚¢ê‡
          unless @active_battler.tops_binder? or @active_battler.tops_binding?
            n = 1
            @error_text = "©•ª‚Ìã”¼g‚ªS‘©ó‘Ô(U‚ßè)‚Å–³‚¢"
          end
        end
        if @skill.element_set.include?(164)
        # ©•ª‚Ìã”¼g‚ªŠJ‹ró‘Ô(U‚ßè)‚Å–³‚¢ê‡
          unless @active_battler.tops_openbinder? or @active_battler.tops_openbinding?
            n = 1
          end
        end
        if @skill.element_set.include?(160)
        # ©•ª‚Ìã”¼g‚ªƒpƒCƒYƒŠó‘Ô(U‚ßè)‚Å–³‚¢ê‡
          unless @active_battler.tops_paizuri?
            n = 1
          end
        end
        if @skill.element_set.include?(171)
        # ©•ª‚Ìã”¼g‚ª‚Ï‚Ó‚Ï‚Óó‘Ô(U‚ßè)‚Å–³‚¢ê‡
          unless @active_battler.tops_pahupahu?
            n = 1
          end
        end
        #------------------------------------------------------------------------
        # ¡©•ªFK”öè—L’†•s‰Â‚ÌƒXƒLƒ‹‚Ìê‡
        if @skill.element_set.include?(165)
        # ©•ª‚ÌK”ö‚ğ‘}“ü’†‚Ìê‡
          if @active_battler.hold.tail.battler != nil
            n = 1
          end
        end
        if @skill.element_set.include?(166)
        # ©•ª‚ÌK”ö‚ğ‘}“ü’†‚Ìê‡
          if @target_battlers[0].hold.tail.battler != nil
            n = 1
          end
        end
        # ¡K”öè—L’†‚Ì‚İ‰Â‚ÌƒXƒLƒ‹‚Ìê‡
        #------------------------------------------------------------------------
        if @skill.element_set.include?(167)
        # ©•ª‚ÌK”ö‚ªŠ‘}“üó‘Ô‚Å–³‚¢ê‡
          unless @active_battler.tail_insert?
            n = 1
          end
        end
        if @skill.element_set.include?(168)
        # ©•ª‚ÌK”ö‚ªŒûˆúó‘Ô‚Å–³‚¢ê‡
          unless @active_battler.tail_oralsex?
            n = 1
          end
        end
        if @skill.element_set.include?(169)
        # ©•ª‚ÌK”ö‚ªãèŠ­ó‘Ô‚Å–³‚¢ê‡
          unless @active_battler.tail_analsex?
            n = 1
          end
        end
        #------------------------------------------------------------------------
        # ¡Gèè—L’†‚Ì‚İ‰Â‚ÌƒXƒLƒ‹‚Ìê‡
        #------------------------------------------------------------------------
        if @skill.element_set.include?(172)
        # ©•ª‚ÌGè‚ªŠ‘}“üó‘Ô‚Å–³‚¢ê‡
          unless @active_battler.tentacle_insert?
            n = 1
          end
        end
        if @skill.element_set.include?(173)
        # ©•ª‚ÌGè‚ªŒûˆúó‘Ô‚Å–³‚¢ê‡
          unless @active_battler.tentacle_oralsex?
            n = 1
          end
        end
        if @skill.element_set.include?(174)
        # ©•ª‚ÌGè‚ªãèŠ­ó‘Ô‚Å–³‚¢ê‡
          unless @active_battler.tentacle_analsex?
            n = 1
          end
        end
        if @skill.element_set.include?(175)
        # ©•ª‚ÌGè‚Å‘Šè‚ğS‘©‚µ‚Ä‚¢‚È‚¢ê‡
          unless @active_battler.tentacle_binder?
            n = 1
            @error_text = "©•ª‚ÌGè‚ÅS‘©‚³‚¹‚Ä‚¢‚È‚¢"
          end
        end
        if @skill.element_set.include?(176)
        # ©•ª‚ÌGè‚Å‘Šè‚ğŠJ‹r‚³‚¹‚Ä‚¢‚È‚¢ê‡
          unless @active_battler.tentacle_openbinder?
            n = 1
            @error_text = "©•ª‚ÌGè‚ÅŠJ‹r‚³‚¹‚Ä‚¢‚È‚¢"
          end
        end

        #------------------------------------------------------------------------
        # ¡©•ªFƒfƒBƒ‹ƒhè—L’†•s‰Â‚ÌƒXƒLƒ‹‚Ìê‡
        if @skill.element_set.include?(182)
          # ©•ª‚ÌƒfƒBƒ‹ƒh‚ğ‘}“ü’†‚Ìê‡
          n = 1 if @active_battler.hold.dildo.battler != nil
        end
        # ¡K”öè—L’†‚Ì‚İ‰Â‚ÌƒXƒLƒ‹‚Ìê‡
        #------------------------------------------------------------------------
        if @skill.element_set.include?(183)
        # ©•ª‚ÌƒfƒBƒ‹ƒh‚ªŠ‘}“üó‘Ô‚Å–³‚¢ê‡
          n = 1 unless @active_battler.dildo_insert?
        end
        if @skill.element_set.include?(184)
        # ©•ª‚ÌƒfƒBƒ‹ƒh‚ªŒûˆúó‘Ô‚Å–³‚¢ê‡
          n = 1 unless @active_battler.dildo_oralsex?
        end
        if @skill.element_set.include?(185)
        # ©•ª‚ÌƒfƒBƒ‹ƒh‚ªãèŠ­ó‘Ô‚Å–³‚¢ê‡
          n = 1 unless @active_battler.dildo_analsex?
        end

        # ¡‘Î’j—pƒXƒLƒ‹‚Ìê‡
        if @skill.element_set.include?(41)
        #----------------------------------------------------------------
          # ‘Šè‚ª’jiålŒöj‚Å‚È‚¢ê‡
          unless @target_battlers[0] == $game_actors[101]
            n = 1
            p "‘Î’jƒXƒLƒ‹‚ğ—‚Ég—p‚µ‚Ä‚¢‚é‚½‚ß•s‰ÂF#{@skill.name}" if a == 1
          end
        end
        # ¡‘Î——pƒXƒLƒ‹‚Ìê‡
        if @skill.element_set.include?(42)
        #----------------------------------------------------------------
          # ‘Šè‚ª’jiålŒöj‚Å‚ ‚éê‡
          if @target_battlers[0] == $game_actors[101]
            n = 1
            p "‘Î—ƒXƒLƒ‹‚ğ’j‚Ég—p‚µ‚Ä‚¢‚é‚½‚ß•s‰ÂF#{@skill.name}" if a == 1
          end
        end
        # ¡ƒXƒe[ƒ^ƒX•Ï‰»–‚–@‚Ìê‡
        # ƒXƒe[ƒg•Ï‰»”­¶‘®«Š‚ÂAƒ_ƒ[ƒW–³‚µ‘®«‚Ìê‡A‚·‚Å‚É‚Â‚¢‚Ä‚¢‚é‚à‚Ì‚É‚Íg—p‚µ‚È‚¢
        if @skill.element_set.include?(33) and @skill.element_set.include?(17) 
          if @skill.id == 215 #ƒgƒŠƒ€ƒ‹[ƒgF¸_ŒnƒoƒXƒe‰ğœ
            unless @target_battlers[0].badstate_mental?
              n = 1
              p "¸_ŒnƒoƒbƒhƒXƒe[ƒg‚Å‚Í‚È‚¢‚Ì‚Åg—p•s‰ÂF#{@skill.name}" if a == 1
            end
          elsif @skill.id == 216 #ƒgƒŠƒ€ƒXƒg[ƒNFôæfŒnƒoƒXƒe‰ğœ
            unless @target_battlers[0].badstate_curse?
              n = 1
              p "ôæfŒnƒoƒbƒhƒXƒe[ƒg‚Å‚Í‚È‚¢‚Ì‚Åg—p•s‰ÂF#{@skill.name}" if a == 1
            end
          elsif  @skill.id == 217 #ƒgƒŠƒ€ƒ”ƒ@ƒCƒ“F•¨—ŒnƒoƒXƒe‰ğœ
            unless @target_battlers[0].badstate_tool?
              n = 1
              p "•¨—ŒnƒoƒbƒhƒXƒe[ƒg‚Å‚Í‚È‚¢‚Ì‚Åg—p•s‰ÂF#{@skill.name}" if a == 1
            end
          else #ƒoƒXƒe•t—^
            for i in SR_Util.checking_states # ˆê”ÊƒoƒXƒe
              if @skill.plus_state_set.include?(i) and @target_battlers[0].states.include?(i)
                n = 1
                p "Šù‚ÉƒXƒe[ƒg•t—^‚³‚ê‚Ä‚¢‚é‚Ì‚Åg—p•s‰ÂF#{@skill.name}" if a == 1
                break
              end
            end
            for i in [30,98,104] # “ÁêƒoƒXƒe
              if @skill.plus_state_set.include?(i) and @target_battlers[0].states.include?(i)
                n = 1
                p "Šù‚ÉƒXƒe[ƒg•t—^‚³‚ê‚Ä‚¢‚é‚Ì‚Åg—p•s‰ÂF#{@skill.name}" if a == 1
                break
              end
            end
          end
        end
        # ¡ƒpƒ‰ƒ[ƒ^•Ï‰»–‚–@‚Ìê‡
        if @skill.element_set.include?(34)
        # ‚·‚Å‚ÉãŒÀ‚Ü‚Å‚©‚©‚Á‚Ä‚¢‚éê‡‚Íg—p‚µ‚È‚¢
        #----------------------------------------------------------------
          #œ‰ğœ
          if @skill.element_set.include?(67) #‘S‰ğœ
            eff_count = 0
            for i in 0..5
              # ‘ÎÛ‚ªƒGƒlƒ~[i©ŒRj‚È‚çã‰»’l‚Ì”‚ğ”‚¦‚é
              if @target_battlers[0].is_a?(Game_Enemy) and 
              @target_battlers[0].state_runk[i] < 0 
                eff_count += @target_battlers[0].state_runk[i].abs
              # ‘ÎÛ‚ªƒAƒNƒ^[[i“GŒRj‚È‚ç‹­‰»’l‚Ì”‚ğ”‚¦‚é
              elsif @target_battlers[0].is_a?(Game_Actor) and 
              @target_battlers[0].state_runk[i] < 0 
                eff_count += @target_battlers[0].state_runk[i].abs
              end
            end
            n = 1 if eff_count < 1 # ‹­‰»‚P‚ÂˆÈ‰º‚È‚çg‚í‚È‚¢
=begin
            n = 1
            for i in 0..5
              if @target_battlers[0].state_runk[i] != 0 
                n = 0
                break
              end
            end
=end
            p "‰ğœ‚µ‚½‚¢’ö”\—Í•Ï‰»‚ª–³‚¢‚Ì‚Åg—p•s‰ÂF#{@skill.name}" if a == 1 and n == 1
          elsif @skill.element_set.include?(65) #‹­‰»‰ğœ
            n = 1
            for i in 0..5
              if @target_battlers[0].state_runk[i] > 0
                n = 0
                break
              end
            end
            p "‹­‰»‚³‚ê‚½”\—Í‚ª–³‚¢‚Ì‚Åg—p•s‰ÂF#{@skill.name}" if a == 1 and n == 1
          elsif @skill.element_set.include?(66) #ã‘Ì‰»‰ğœ
            n = 1
            for i in 0..5
              if @target_battlers[0].state_runk[i] < 0
                n = 0
                break
              end
            end
            p "ã‘Ì‰»‚µ‚½”\—Í‚ª–³‚¢‚Ì‚Åg—p•s‰ÂF#{@skill.name}" if a == 1 and n == 1
          #œ‘S”\—Í
          elsif @skill.element_set.include?(63) #ƒXƒgƒŒƒŠƒuƒ‹ƒ€
            effectable = []
            state_count = 0
            # ‘ÎÛ‘Sˆõ‚ğŠm”F
            for target in @target_battlers
              # ‘SƒXƒe[ƒ^ƒX‚Ìã¸•â³‚ğŠm”F
              for i in 0..5
                # Å‘å’l‚É‚È‚Á‚Ä‚¢‚È‚¢‚à‚Ì‚ğ”‚¦‚é
                if target.state_runk[i] < 2
                  state_count += 1
                end
              end
              effectable.push(state_count)
            end
            # ‚Pl‚¸‚ÂA—LŒø‚©‚Ì”»’è‚ğs‚¤
            effectable_count = 0
            for i in 0...@target_battlers.size
              # ‚RˆÈã‚ª—LŒø‚Èƒ^[ƒQƒbƒg
              if effectable[i] >= 3
                effectable_count += 1
              end
            end
            # ‘ÎÛ‘Sˆõ‚ÉŒø‰Ê‚ª–³‚¯‚ê‚ÎƒGƒ‰[
            if effectable_count < @target_battlers.size
              n = 1
              # ‘ÎÛ‚ª‚RlˆÈãAŠ‚Â‘ÎÛ”|‚P‚É—LŒø‚È‚ç‹–‰Â
              if @target_battlers.size >= 3 and effectable_count + 1 >= @target_battlers.size
                n = 0
              end
            end
          elsif @skill.element_set.include?(64) #ƒXƒgƒŒƒŠƒC[ƒU
            effectable = []
            state_count = 0
            # ‘ÎÛ‘Sˆõ‚ğŠm”F
            for target in @target_battlers
              # ‘SƒXƒe[ƒ^ƒX‚Ìã¸•â³‚ğŠm”F
              for i in 0..5
                # Å¬’l‚É‚È‚Á‚Ä‚¢‚È‚¢‚à‚Ì‚ğ”‚¦‚é
                if target.state_runk[i] > -2
                  state_count += 1
                end
              end
              effectable.push(state_count)
            end
            # ‚Pl‚¸‚ÂA—LŒø‚©‚Ì”»’è‚ğs‚¤
            effectable_count = 0
            for i in 0...@target_battlers.size
              # ‚RˆÈã‚ª—LŒø‚Èƒ^[ƒQƒbƒg
              if effectable[i] >= 3
                effectable_count += 1
              end
            end
            # ‘ÎÛ‘Sˆõ‚ÉŒø‰Ê‚ª–³‚¯‚ê‚ÎƒGƒ‰[
            if effectable_count < @target_battlers.size
              n = 1
              # ‘ÎÛ‚ª‚RlˆÈãAŠ‚Â‘ÎÛ”|‚P‚É—LŒø‚È‚ç‹–‰Â
              if @target_battlers.size >= 3 and effectable_count + 1 >= @target_battlers.size
                n = 0
              end
            end
          #œ–£—Í
          elsif @skill.element_set.include?(51) #ƒ‰ƒiƒ“ƒuƒ‹ƒ€
            effectable_count = @target_battlers.size
            for target in @target_battlers
              if target.state_runk[0] == 2
                effectable_count -= 1
                n = 1
                p "‚±‚êˆÈã–£—Í‹­‰»‚Å‚«‚È‚¢‚Ì‚Åg—p•s‰ÂF#{@skill.name}" if a == 1
              end
            end
            # ‘ÎÛ‘Sˆõ‚ÉŒø‰Ê‚ª–³‚¯‚ê‚ÎƒGƒ‰[
            if effectable_count < @target_battlers.size
              n = 1
              # ‘ÎÛ‚ª‚RlˆÈãAŠ‚Â‘ÎÛ”|‚P‚É—LŒø‚È‚ç‹–‰Â
              if @target_battlers.size >= 3 and effectable_count + 1 >= @target_battlers.size
                n = 0
              end
            end
          elsif @skill.element_set.include?(52) #ƒ‰ƒiƒ“ƒC[ƒU
            effectable_count = @target_battlers.size
            for target in @target_battlers
              if target.state_runk[0] == -2
                effectable_count -= 1
                n = 1
                p "‚±‚êˆÈã–£—Íã‰»‚Å‚«‚È‚¢‚Ì‚Åg—p•s‰ÂF#{@skill.name}" if a == 1
              end
            end
            # ‘ÎÛ‘Sˆõ‚ÉŒø‰Ê‚ª–³‚¯‚ê‚ÎƒGƒ‰[
            if effectable_count < @target_battlers.size
              n = 1
              # ‘ÎÛ‚ª‚RlˆÈãAŠ‚Â‘ÎÛ”|‚P‚É—LŒø‚È‚ç‹–‰Â
              if @target_battlers.size >= 3 and effectable_count + 1 >= @target_battlers.size
                n = 0
              end
            end
          #œ”E‘Ï—Í
          elsif @skill.element_set.include?(53) #ƒlƒŠƒlƒuƒ‹ƒ€
            effectable_count = @target_battlers.size
            for target in @target_battlers
              if target.state_runk[1] == 2
                effectable_count -= 1
                n = 1
                p "‚±‚êˆÈã”E‘Ï—Íã‰»‚Å‚«‚È‚¢‚Ì‚Åg—p•s‰ÂF#{@skill.name}" if a == 1
              end
            end
            # ‘ÎÛ‘Sˆõ‚ÉŒø‰Ê‚ª–³‚¯‚ê‚ÎƒGƒ‰[
            if effectable_count < @target_battlers.size
              n = 1
              # ‘ÎÛ‚ª‚RlˆÈãAŠ‚Â‘ÎÛ”|‚P‚É—LŒø‚È‚ç‹–‰Â
              if @target_battlers.size >= 3 and effectable_count + 1 >= @target_battlers.size
                n = 0
              end
            end
          elsif @skill.element_set.include?(54) #ƒlƒŠƒlƒC[ƒU
            effectable_count = @target_battlers.size
            for target in @target_battlers
              if target.state_runk[1] == -2
                effectable_count -= 1
                n = 1
                p "‚±‚êˆÈã”E‘Ï—Íã‰»‚Å‚«‚È‚¢‚Ì‚Åg—p•s‰ÂF#{@skill.name}" if a == 1
              end
            end
            # ‘ÎÛ‘Sˆõ‚ÉŒø‰Ê‚ª–³‚¯‚ê‚ÎƒGƒ‰[
            if effectable_count < @target_battlers.size
              n = 1
              # ‘ÎÛ‚ª‚RlˆÈãAŠ‚Â‘ÎÛ”|‚P‚É—LŒø‚È‚ç‹–‰Â
              if @target_battlers.size >= 3 and effectable_count + 1 >= @target_battlers.size
                n = 0
              end
            end
          #œ¸—Í
          elsif @skill.element_set.include?(55) #ƒGƒ‹ƒ_ƒuƒ‹ƒ€
            effectable_count = @target_battlers.size
            for target in @target_battlers
              if target.state_runk[2] == 2
                effectable_count -= 1
                n = 1
                p "‚±‚êˆÈã¸—Í‹­‰»‚Å‚«‚È‚¢‚Ì‚Åg—p•s‰ÂF#{@skill.name}" if a == 1
              end
            end
            # ‘ÎÛ‘Sˆõ‚ÉŒø‰Ê‚ª–³‚¯‚ê‚ÎƒGƒ‰[
            if effectable_count < @target_battlers.size
              n = 1
              # ‘ÎÛ‚ª‚RlˆÈãAŠ‚Â‘ÎÛ”|‚P‚É—LŒø‚È‚ç‹–‰Â
              if @target_battlers.size >= 3 and effectable_count + 1 >= @target_battlers.size
                n = 0
              end
            end
          elsif @skill.element_set.include?(56) #ƒGƒ‹ƒ_ƒC[ƒU
            effectable_count = @target_battlers.size
            for target in @target_battlers
              if target.state_runk[2] == -2
                effectable_count -= 1
                n = 1
                p "‚±‚êˆÈã¸—Íã‰»‚Å‚«‚È‚¢‚Ì‚Åg—p•s‰ÂF#{@skill.name}" if a == 1
              end
            end
            # ‘ÎÛ‘Sˆõ‚ÉŒø‰Ê‚ª–³‚¯‚ê‚ÎƒGƒ‰[
            if effectable_count < @target_battlers.size
              n = 1
              # ‘ÎÛ‚ª‚RlˆÈãAŠ‚Â‘ÎÛ”|‚P‚É—LŒø‚È‚ç‹–‰Â
              if @target_battlers.size >= 3 and effectable_count + 1 >= @target_battlers.size
                n = 0
              end
            end
          #œŠí—p‚³
          elsif @skill.element_set.include?(57) #ƒTƒtƒ‰ƒuƒ‹ƒ€
            effectable_count = @target_battlers.size
            for target in @target_battlers
              if target.state_runk[3] == 2
                effectable_count -= 1
                n = 1
                p "‚±‚êˆÈãŠí—p‚³‹­‰»‚Å‚«‚È‚¢‚Ì‚Åg—p•s‰ÂF#{@skill.name}" if a == 1
              end
            end
            # ‘ÎÛ‘Sˆõ‚ÉŒø‰Ê‚ª–³‚¯‚ê‚ÎƒGƒ‰[
            if effectable_count < @target_battlers.size
              n = 1
              # ‘ÎÛ‚ª‚RlˆÈãAŠ‚Â‘ÎÛ”|‚P‚É—LŒø‚È‚ç‹–‰Â
              if @target_battlers.size >= 3 and effectable_count + 1 >= @target_battlers.size
                n = 0
              end
            end
          elsif @skill.element_set.include?(58) #ƒTƒtƒ‰ƒC[ƒU
            effectable_count = @target_battlers.size
            for target in @target_battlers
              if target.state_runk[3] == -2
                effectable_count -= 1
                n = 1
                p "‚±‚êˆÈãŠí—p‚³ã‰»‚Å‚«‚È‚¢‚Ì‚Åg—p•s‰ÂF#{@skill.name}" if a == 1
              end
            end
            # ‘ÎÛ‘Sˆõ‚ÉŒø‰Ê‚ª–³‚¯‚ê‚ÎƒGƒ‰[
            if effectable_count < @target_battlers.size
              n = 1
              # ‘ÎÛ‚ª‚RlˆÈãAŠ‚Â‘ÎÛ”|‚P‚É—LŒø‚È‚ç‹–‰Â
              if @target_battlers.size >= 3 and effectable_count + 1 >= @target_battlers.size
                n = 0
              end
            end
          #œ‘f‘‚³
          elsif @skill.element_set.include?(59) #ƒRƒŠƒIƒuƒ‹ƒ€
            effectable_count = @target_battlers.size
            for target in @target_battlers
              if target.state_runk[4] == 2
                effectable_count -= 1
                n = 1
                p "‚±‚êˆÈã‘f‘‚³‹­‰»‚Å‚«‚È‚¢‚Ì‚Åg—p•s‰ÂF#{@skill.name}" if a == 1
              end
            end
            # ‘ÎÛ‘Sˆõ‚ÉŒø‰Ê‚ª–³‚¯‚ê‚ÎƒGƒ‰[
            if effectable_count < @target_battlers.size
              n = 1
              # ‘ÎÛ‚ª‚RlˆÈãAŠ‚Â‘ÎÛ”|‚P‚É—LŒø‚È‚ç‹–‰Â
              if @target_battlers.size >= 3 and effectable_count + 1 >= @target_battlers.size
                n = 0
              end
            end
          elsif @skill.element_set.include?(60) #ƒRƒŠƒIƒC[ƒU
            effectable_count = @target_battlers.size
            for target in @target_battlers
              if target.state_runk[4] == -2
                effectable_count -= 1
                n = 1
                p "‚±‚êˆÈã‘f‘‚³ã‰»‚Å‚«‚È‚¢‚Ì‚Åg—p•s‰ÂF#{@skill.name}" if a == 1
              end
            end
            # ‘ÎÛ‘Sˆõ‚ÉŒø‰Ê‚ª–³‚¯‚ê‚ÎƒGƒ‰[
            if effectable_count < @target_battlers.size
              n = 1
              # ‘ÎÛ‚ª‚RlˆÈãAŠ‚Â‘ÎÛ”|‚P‚É—LŒø‚È‚ç‹–‰Â
              if @target_battlers.size >= 3 and effectable_count + 1 >= @target_battlers.size
                n = 0
              end
            end
          #œ¸_—Í
          elsif @skill.element_set.include?(61) #ƒAƒXƒ^ƒuƒ‹ƒ€
            effectable_count = @target_battlers.size
            for target in @target_battlers
              if target.state_runk[5] == 2
                effectable_count -= 1
                n = 1
                p "‚±‚êˆÈã¸_—Í‹­‰»‚Å‚«‚È‚¢‚Ì‚Åg—p•s‰ÂF#{@skill.name}" if a == 1
              end
            end
            # ‘ÎÛ‘Sˆõ‚ÉŒø‰Ê‚ª–³‚¯‚ê‚ÎƒGƒ‰[
            if effectable_count < @target_battlers.size
              n = 1
              # ‘ÎÛ‚ª‚RlˆÈãAŠ‚Â‘ÎÛ”|‚P‚É—LŒø‚È‚ç‹–‰Â
              if @target_battlers.size >= 3 and effectable_count + 1 >= @target_battlers.size
                n = 0
              end
            end
          elsif @skill.element_set.include?(62) #ƒAƒXƒ^ƒC[ƒU
            effectable_count = @target_battlers.size
            for target in @target_battlers
              if target.state_runk[5] == -2
                effectable_count -= 1
                n = 1
                p "‚±‚êˆÈã¸_—Íã‰»‚Å‚«‚È‚¢‚Ì‚Åg—p•s‰ÂF#{@skill.name}" if a == 1
              end
            end
            # ‘ÎÛ‘Sˆõ‚ÉŒø‰Ê‚ª–³‚¯‚ê‚ÎƒGƒ‰[
            if effectable_count < @target_battlers.size
              n = 1
              # ‘ÎÛ‚ª‚RlˆÈãAŠ‚Â‘ÎÛ”|‚P‚É—LŒø‚È‚ç‹–‰Â
              if @target_battlers.size >= 3 and effectable_count + 1 >= @target_battlers.size
                n = 0
              end
            end
          end
        end
        
        # ƒCƒ“ƒZƒ“ƒXƒXƒLƒ‹‚ÍA‚·‚Å‚É“¯‚¶ƒCƒ“ƒZƒ“ƒX‚ª‚ ‚éê‡‚Í•s‰Â
        if @skill.element_set.include?(129)
          n = 1 if $incense.exist?(@skill.name, @target_battlers[0])
        end
        # ©•ª‚Ìƒz[ƒ‹ƒh‘Šè‚É‚Ì‚İg—p‰Â‚Ìê‡A©•ª‚Ìƒz[ƒ‹ƒh‘ŠèˆÈŠO‚Í•s‰Â
        if @skill.element_set.include?(208)
          n = 1 if not @active_battler.target_hold?(@target_battlers[0])
        end
        # ©•ª‚Ìƒz[ƒ‹ƒh‘Šè‚ğ—Dæ‚µ‚Äg—p‚Ìê‡A©•ª‚ªƒz[ƒ‹ƒh‚µ‚Ä‚¢‚é‚È‚ç‚Î
        # ©•ª‚Ìƒz[ƒ‹ƒh‘ŠèˆÈŠO‚Í•s‰Â
        if @skill.element_set.include?(215)
          if @active_battler.holding? and not @active_battler.target_hold?(@target_battlers[0])
            n = 1 
          end
        end
        
        
        # ¡ƒXƒLƒ‹•Ê‚²‚Æ‚Ìg—p‰Â”Û
        #----------------------------------------------------------------
        case @skill.name
        
        # ƒ‰ƒ“ƒ_ƒ€ƒXƒLƒ‹‚È‚Ç‚ÅƒXƒLƒ‹Œˆ‚ß’¼‚µ‚ªo‚½ê‡‚Í‚à‚¤ˆê‰ñ‰ñ‚³‚¹‚é        
        when "ƒXƒLƒ‹Œˆ‚ß’¼‚µ"
          n = 1
        # ‚·‚Å‚Éƒ}[ƒLƒ“ƒO‚µ‚Ä‚¢‚éê‡A•i’è‚ß‚ğg‚í‚È‚¢
        when "•i’è‚ß"; n = 1 if @active_battler.marking?
        # ‰ñ•œ–‚–@
        #----------------------------------------------------------------
        # ‘ÎÛ‚Pl‚Ìê‡A‘ÎÛ‚ÌŒ»İ‚d‚o‚ÌŠ„‡‚Å‰Â”Û‚ğŠm”F
        when "ƒCƒŠƒXƒV[ƒh"; n = 1 if @target_battlers[0].hpp >= 90
        when "ƒCƒŠƒXƒyƒ^ƒ‹"; n = 1 if @target_battlers[0].hpp >= 80
        when "ƒCƒŠƒXƒtƒ‰ƒE"; n = 1 if @target_battlers[0].hpp >= 50
        when "ƒCƒŠƒXƒRƒƒi"; n = 1 if @target_battlers[0].hpp >= 50
        # ‘ÎÛ•¡”‚Ìê‡A‘ÎÛ‚Ì‚d‚oŠ„‡‚ª“K³‚Å‚ ‚éê‡‚ÌÒ‚ª‚QlˆÈã‚Ìê‡‚n‚j
        when "ƒCƒŠƒXƒV[ƒhEƒAƒ‹ƒ_","ƒCƒŠƒXƒyƒ^ƒ‹EƒAƒ‹ƒ_","ƒCƒŠƒXƒtƒ‰ƒEEƒAƒ‹ƒ_"
          target_count = 0
          for target in @target_battlers
            case @skill.name
            when "ƒCƒŠƒXƒV[ƒhEƒAƒ‹ƒ_"
              target_count += 1 if target.hpp < 90
            when "ƒCƒŠƒXƒyƒ^ƒ‹EƒAƒ‹ƒ_"
              target_count += 1 if target.hpp < 80
            when "ƒCƒŠƒXƒtƒ‰ƒEEƒAƒ‹ƒ_"
              target_count += 1 if target.hpp < 50
            end
          end
          if target_count < 2
            n = 1 
            @error_text = "”ÍˆÍ‰ñ•œ–‚–@F‘ÎÛ•s“K³"
          end
        # ’§”­ŒnƒXƒLƒ‹‚ÍA©w‚Å‚·‚Å‚É’N‚©‚ª’§”­‚µ‚Ä‚¢‚éê‡‚ÍƒGƒ‰[
        when "ƒAƒs[ƒ‹","ƒvƒƒ”ƒH[ƒN"
          for enemy in $game_troop.enemies
            if enemy.exist? and (enemy.state?(96) or enemy.state?(104))
              n = 1
              break
            end
          end
        # ƒMƒ‹ƒS[ƒ“—pB‚Ü‚¾‚â‚¯‚­‚»‚R˜AŒ‚‚ğg—p‚µ‚Ä‚¢‚È‚¢ê‡A‚à‚ª‚©‚È‚¢B
        when "‚à‚ª‚­"
          if $game_switches[393]
            n = 1
            @error_text = "‚à‚ª‚­F“Áêó‹µƒGƒ‰["
          end
        end
        #------------------------------------------------------------------------
        # ¡‘I‚Ñ’¼‚µ‚Å‘I‚Î‚ê‚È‚¢ƒXƒLƒ‹‚Ìê‡‚ÍƒGƒ‰[
        #------------------------------------------------------------------------
        if @skill.element_set.include?(211) and ct > 0
          n = 1
        end
        #------------------------------------------------------------------------
        # ¡‚Pl‚Ì‚É‚Íg‚í‚È‚¢ƒXƒLƒ‹‚Ìê‡A‚Pl‚¾‚ÆƒGƒ‰[
        #------------------------------------------------------------------------
        if @skill.element_set.include?(212)
          enemy_count = 0
          for enemy in $game_troop.enemies
            enemy_count += 1 if enemy.exist?
          end
          n = 1 if enemy_count < 2
        end
        #------------------------------------------------------------------------
        # ¡–{‹Có‘Ô‚Å‚Íg‚í‚È‚¢A–{‹C‚¾‚ÆƒGƒ‰[
        #------------------------------------------------------------------------
        if @skill.element_set.include?(218)
          if @active_battler.earnest
            n = 1 
          end
        end
        #------------------------------------------------------------------------
        # ¡‘ÎÛ‚ª•s“K³‚Ìê‡‚ÍƒGƒ‰[
        #------------------------------------------------------------------------
        if not @active_battler.proper_target?(@target_battlers[0],@skill.id)
          n = 1 
          @error_text = "‘ÎÛ•s“K³"
        end

        
        
        #----------------------------------------------------------------
        #ƒXƒLƒ‹s‰ñ”‚ª‚S‚O‰ñ‚ğ’´‚¦‚½ê‡A”Ä—pƒAƒNƒVƒ‡ƒ“‚É‚µ‚Äƒ‹[ƒv‚ğ”²‚¯‚é
        #¦ƒnƒ“ƒOƒAƒbƒv‘Îô
        if ct > 300
          p "sãŒÀ‚È‚Ì‚Å‰ñ”ğôÀs" if $DEBUG
          unless @active_battler.holding?
            # ƒXƒLƒ‹[ƒGƒ‚[ƒVƒ‡ƒ“]‚ğæ“¾
            @skill = $data_skills[299]
          else
            # ƒXƒLƒ‹[Œ©ŠwEÀ‹µ]‚ğæ“¾
            @skill = $data_skills[968]
          end
        # ƒGƒ‰[ƒJƒEƒ“ƒg‚Ìê‡‚ÍƒAƒNƒVƒ‡ƒ“Œˆ‚ß’¼‚µ
        elsif n == 1
          ct += 1
#          p "g—pƒXƒLƒ‹(ƒGƒ‰[”F¯’†)F#{@skill.name}" if $DEBUG
          if a == 1
            unless @skill.name == "ƒXƒLƒ‹Œˆ‚ß’¼‚µ"
              text = "ƒGƒ‰[”F¯’†"
              text += "\nƒAƒNƒeƒBƒuF#{@active_battler.name}"
              text += "\nƒ^[ƒQƒbƒgF#{@target_battlers[0].name}"
              text += "\nƒXƒLƒ‹F#{@skill.name}"
              text += "\nƒGƒ‰[“à—eF#{@error_text}"
              print text
              @error_text = ""
            end
          end
          # ƒAƒNƒVƒ‡ƒ“‚ğÄŒˆ’è
          enemy_action_swicthes(@active_battler)
          @active_battler.make_action
          # Šî–{ƒAƒNƒVƒ‡ƒ“‚¾‚Á‚½ê‡‚ÍAŠî–{ƒAƒNƒVƒ‡ƒ“‚ÌŒ‹‰Êì¬‚É”ò‚Î‚·             
          if @active_battler.current_action.kind == 0
            make_basic_action_result
            return
          end
          # ƒXƒLƒ‹‚ğæ“¾
          @skill = $data_skills[@active_battler.current_action.skill_id]
#          p "g—pƒXƒLƒ‹(Äİ’è)F#{@skill.name}" if $DEBUG
          
          # ƒfƒoƒbƒO—p
          if @skill.id == 15
#            p @active_battler.current_action
#           a = 1
          end  
          
          # ‘ÎÛ‘¤ƒoƒgƒ‰[‚ğƒNƒŠƒA
          @target_battlers = []
          # ‘ÎÛ‘¤ƒoƒgƒ‰[‚ğİ’è
          set_target_battlers(@skill.scope, @skill.id)
          # šƒ^[ƒQƒbƒgƒoƒgƒ‰[‚Ìî•ñ‚ğÄ“x‹L‰¯
          $game_temp.battle_target_battler = @target_battlers
#          p "‘ÎÛ(Äİ’è)F#{@target_battlers[0].name}" if $DEBUG

          # šƒ‰ƒ“ƒ_ƒ€ƒXƒLƒ‹‚ğg—p‚·‚éê‡Aê—pƒy[ƒW‚Ö”ò‚Î‚·
          if $data_skills[@active_battler.current_action.skill_id].element_set.include?(9)
#            p $data_skills[@active_battler.current_action.skill_id].name
            random_skill_action
          end
          next
        end
        
        # ‘åä•v‚È‚çƒ‹[ƒvI—¹
        break
      end    
#    p "g—pƒXƒLƒ‹(Œˆ’è)F#{@skill.name}" if $DEBUG
        
    # UŒ‚‘¤‚ªƒAƒNƒ^[‚Ìê‡    
    else
      # ƒGƒ‰[—p•Ï”‚ğƒŠƒZƒbƒg
      n = 0
=begin
      #----------------------------------------------------------------
      # ¡ ƒXƒLƒ‹‚ªg—p•s‰ÂŠ‚ÂƒXƒLƒ‹‚Ì‘Ã‹¦‚ª‰Â”\‚Èê‡A‘Ã‹¦‚·‚é
      #----------------------------------------------------------------
      unless @active_battler.skill_can_use?(@skill.id)
        # ƒwƒ”ƒBƒsƒXƒgƒ“¨ƒsƒXƒgƒ“
        if @skill.id == 33
          new_id = 32
          @skill = $data_skills[new_id]
          @active_battler.current_action.skill_id = new_id
          p 1
        end
      end
=end
      
      
      #----------------------------------------------------------------
      # ¡ ƒGƒ‰[W
      #----------------------------------------------------------------

      # ƒGƒ‰[—p•Ï”‚ğƒŠƒZƒbƒg
      n = 0
      @error_text = ""
      
      # ¡©•ªF’…ˆß’†•s‰Â‚ÌƒXƒLƒ‹‚Ìê‡
      if @skill.element_set.include?(177)
      #----------------------------------------------------------------
        #‘}“üƒ^ƒCƒvEƒsƒXƒgƒ“EƒOƒ‰ƒCƒ“ƒh‘®«‚ª‚ ‚éê‡A”¼’E‚¬‚Å‹–‰Â‚³‚ê‚éê‡‚à
        if @skill.element_set.include?(134)
          unless @skill.element_set.include?(91)
            unless (@active_battler.insertable_half_nude? or @active_battler.full_nude?)
              n = 1
            end
          end
        else
          unless @active_battler.full_nude?
            n = 1
          end
        end
      end

      # ¡‘ŠèF’…ˆß’†•s‰Â‚ÌƒXƒLƒ‹‚Ìê‡
      if @skill.element_set.include?(178)
      #----------------------------------------------------------------
        #‘}“üƒ^ƒCƒvEƒsƒXƒgƒ“EƒOƒ‰ƒCƒ“ƒh‘®«‚ª‚ ‚éê‡A”¼’E‚¬‚Å‹–‰Â‚³‚ê‚éê‡‚à
        if @skill.element_set.include?(134)
          unless @skill.element_set.include?(91)
            unless (@target_battlers[0].insertable_half_nude? or @target_battlers[0].full_nude?)
              n = 1
            end
          end
        else
          unless @target_battlers[0].full_nude?
            n = 1
          end
        end
      end

      # ¡©•ªF’Eˆß’†•s‰Â‚ÌƒXƒLƒ‹‚Ìê‡
      if @skill.element_set.include?(179)
      #----------------------------------------------------------------
        # ©•ª‚ª—‡ó‘Ô‚Å‚ ‚éê‡
        n = 1 if @active_battler.full_nude?
      end

      # ¡‘ŠèF’Eˆß’†•s‰Â‚ÌƒXƒLƒ‹‚Ìê‡
      if @skill.element_set.include?(180)
      #----------------------------------------------------------------
        # ‘Šè‚ª—‡ó‘Ô‚Å‚ ‚éê‡
        n = 1 if @target_battlers[0].full_nude?
      end

      # ¡ƒz[ƒ‹ƒh’†—D¨ê—pƒXƒLƒ‹‚Ìê‡
      if @skill.element_set.include?(137) and @active_battler.holding?
      #------------------------------------------------------------------------
        # ©•ª‚ª—ò¨‚Ìê‡
        n = 1 unless @active_battler.initiative?
      end
      # ¡ƒz[ƒ‹ƒh’†—ò¨ê—pƒXƒLƒ‹‚Ìê‡
      #------------------------------------------------------------------------
      if @skill.element_set.include?(138) and @active_battler.holding?
        # ©•ª‚ª—ò¨‚Ìê‡
        n = 1 if @active_battler.initiative?
      end
      # ¡ƒz[ƒ‹ƒh‰ğœƒXƒLƒ‹‚Ìê‡
      #------------------------------------------------------------------------
      if @skill.name == "ƒŠƒŠ[ƒX" or @skill.name == "ƒCƒ“ƒ^ƒ‰ƒvƒg"
        # ‘Šè‚ª‚·‚Å‚Éƒz[ƒ‹ƒh‚Å–³‚¢ê‡
        n = 1 unless @target_battlers[0].holding?
      end
      if @skill.name == "ƒXƒgƒ‰ƒOƒ‹"
        # ©•ª‚ª‚·‚Å‚Éƒz[ƒ‹ƒh‚Å–³‚¢ê‡
        n = 1 unless @active_battler.holding?
      end

      # ¡©•ª‚ğ‘ÎÛ‚Éæ‚ê‚È‚¢ƒXƒLƒ‹‚Å©•ª‚ğ‘I‘ğ‚µ‚½ê‡g—p•s‰Â
      if @skill.element_set.include?(19)
      #----------------------------------------------------------------
        if @active_battler == @target_battlers[0]
          n = 1
        end
      end
      #------------------------------------------------------------------------
      # ¡©•ªF‰è—L’†•s‰Â‚ÌƒXƒLƒ‹‚Ìê‡
      if @skill.element_set.include?(140)
        # ©•ª‚ÌƒyƒjƒX‚ªƒoƒgƒ‰[‚Éè—L‚³‚ê‚Ä‚¢‚éê‡
        n = 1 if @active_battler.hold.penis.battler != nil
      end
      # ¡‘ŠèF‰è—L’†•s‰Â‚ÌƒXƒLƒ‹‚Ìê‡
      if @skill.element_set.include?(141)
        # ‘Šè‚ÌƒyƒjƒX‚ªƒoƒgƒ‰[‚Éè—L‚³‚ê‚Ä‚¢‚éê‡
        n = 1 if @target_battlers[0].hold.penis.battler != nil
      end
      # ¡‰è—L’†‚Ì‚İ‰Â‚ÌƒXƒLƒ‹‚Ìê‡
      #------------------------------------------------------------------------
      if @skill.element_set.include?(142)
        # ©•ª‚Ì‰‚ªŠ‘}“üó‘Ô‚Å–³‚¢ê‡
        n = 1 unless @active_battler.penis_insert?
      end
      if @skill.element_set.include?(143)
      # ©•ª‚Ì‰‚ªŒûˆúó‘Ô‚Å–³‚¢ê‡
        n = 1 unless @active_battler.penis_oralsex?
      end
      if @skill.element_set.include?(144)
      # ©•ª‚Ì‰‚ªãèŠ­ó‘Ô‚Å–³‚¢ê‡
        n = 1 unless @active_battler.penis_analsex?
      end

      #------------------------------------------------------------------------
      # ¡©•ªFŒûè—L’†•s‰Â‚ÌƒXƒLƒ‹‚Ìê‡
      if @skill.element_set.include?(146)
        # Œû‚ªè—L’†‚Ìê‡
        n = 1 if @active_battler.hold.mouth.battler != nil
      end
      # ¡‘ŠèFŒûè—L’†•s‰Â‚ÌƒXƒLƒ‹‚Ìê‡
      if @skill.element_set.include?(147)
        # Œû‚ªè—L’†‚Ìê‡
        n = 1 if @target_battlers[0].hold.mouth.battler != nil
      end
      # ¡Œû‘}“ü’†‚Ì‚İ‰Â‚ÌƒXƒLƒ‹‚Ìê‡
      #------------------------------------------------------------------------
      if @skill.element_set.include?(148)
      # ©•ª‚ÌŒû‚ªŒû‘}“üó‘Ô‚Å–³‚¢ê‡
        n = 1 unless @active_battler.mouth_oralsex?
      end
      if @skill.element_set.include?(149)
      # ©•ª‚ÌŒû‚ªŠç–Ê‹Ræó‘Ô‚Å–³‚¢ê‡
        n = 1 unless @active_battler.mouth_riding?
      end
      if @skill.element_set.include?(145)
      # ©•ª‚ÌŒû‚ªK‹Ræó‘Ô‚Å–³‚¢ê‡
        n = 1 unless @active_battler.mouth_hipriding?
      end
      if @skill.element_set.include?(150)
      # ©•ª‚ÌŒû‚ªƒNƒ“ƒjó‘Ô‚Å–³‚¢ê‡
        n = 1 unless @active_battler.mouth_draw?
      end
      if @skill.element_set.include?(170)
      # ©•ª‚ÌŒû‚ªƒLƒbƒXó‘Ô‚Å–³‚¢ê‡
        n = 1 unless @active_battler.deepkiss?
      end

      #------------------------------------------------------------------------
      # ¡©•ªFKè—L’†•s‰Â‚ÌƒXƒLƒ‹‚Ìê‡
      if @skill.element_set.include?(151)
        # ©•ª‚ªKè—L’†‚Ìê‡
        n = 1 if @active_battler.hold.anal.battler != nil
      end
      # ¡‘ŠèFKè—L’†•s‰Â‚ÌƒXƒLƒ‹‚Ìê‡
      if @skill.element_set.include?(152)
        # ‘Šè‚ªKè—L’†‚Ìê‡
        n = 1 if @target_battlers[0].hold.anal.battler != nil
      end
      # ¡Kè—L’†‚Ì‚İ‰Â‚ÌƒXƒLƒ‹‚Ìê‡
      #------------------------------------------------------------------------
      if @skill.element_set.include?(153)
        # ©•ª‚ÌK‚ªK‘}“üó‘Ô‚Å–³‚¢ê‡
        n = 1 unless @active_battler.anal_analsex?
      end
      if @skill.element_set.include?(154)
        # ©•ª‚ÌK‚ªK‹Ræó‘Ô‚Å–³‚¢ê‡
        n = 1 unless @active_battler.anal_hipriding?
      end

      #------------------------------------------------------------------------
      # ¡©•ªFŠè—L’†•s‰Â‚ÌƒXƒLƒ‹‚Ìê‡
      if @skill.element_set.include?(155)
        # ©•ª‚ª‘}“ü’†‚Ìê‡
        n = 1 if @active_battler.hold.vagina.battler != nil
      end
      # ¡‘ŠèFŠè—L’†•s‰Â‚ÌƒXƒLƒ‹‚Ìê‡
      if @skill.element_set.include?(156)
        # ‘Šè‚ªŠè—L’†‚Ìê‡
        n = 1 if @target_battlers[0].hold.vagina.battler != nil
      end
      # ¡Šè—L’†‚Ì‚İ‰Â‚ÌƒXƒLƒ‹‚Ìê‡
      #------------------------------------------------------------------------
      if @skill.element_set.include?(157)
      # ©•ª‚ÌŠ‚ªŠ‘}“üó‘Ô‚Å–³‚¢ê‡
        n = 1 unless @active_battler.vagina_insert?
      end
      if @skill.element_set.include?(158)
      # ©•ª‚ÌŠ‚ª‹Ræó‘Ô‚Å–³‚¢ê‡
        n = 1 unless @active_battler.vagina_riding?
      end
      if @skill.element_set.include?(159)
      # ©•ª‚ÌŠ‚ªŠL‡‚í‚¹ó‘Ô‚Å–³‚¢ê‡
        n = 1 unless @active_battler.shellmatch?
      end

      #------------------------------------------------------------------------
      # ¡©•ªFã”¼gè—L’†•s‰Â‚ÌƒXƒLƒ‹‚Ìê‡
      if @skill.element_set.include?(161)
        # ©•ª‚ªã”¼gè—L’†‚Ìê‡
        n = 1 if @active_battler.hold.tops.battler != nil
      end
      # ¡‘ŠèFã”¼gè—L’†•s‰Â‚ÌƒXƒLƒ‹‚Ìê‡
      if @skill.element_set.include?(162)
        # ‘Šè‚ªã”¼gè—L’†‚Ìê‡
        n = 1 if @target_battlers[0].hold.tops.battler != nil
      end
      # ¡ã”¼gè—L’†‚Ì‚İ‰Â‚ÌƒXƒLƒ‹‚Ìê‡
      #------------------------------------------------------------------------
      if @skill.element_set.include?(163)
      # ©•ª‚Ìã”¼g‚ªS‘©ó‘Ô‚Å–³‚¢ê‡
        n = 1 unless (@active_battler.tops_binder? or @active_battler.tops_binding?)
      end
      if @skill.element_set.include?(164)
      # ©•ª‚Ìã”¼g‚ªŠJ‹ró‘Ô‚Å–³‚¢ê‡
        n = 1 unless @active_battler.tops_openbinding?
      end
      if @skill.element_set.include?(160)
      # ©•ª‚Ìã”¼g‚ªƒpƒCƒYƒŠó‘Ô‚Å–³‚¢ê‡
        n = 1 unless @active_battler.tops_paizuri?
      end
      if @skill.element_set.include?(171)
      # ©•ª‚Ìã”¼g‚ª‚Ï‚Ó‚Ï‚Óó‘Ô‚Å–³‚¢ê‡
        n = 1 unless @active_battler.tops_pahupahu?
      end

      #------------------------------------------------------------------------
      # ¡©•ªFK”öè—L’†•s‰Â‚ÌƒXƒLƒ‹‚Ìê‡
      if @skill.element_set.include?(165)
        # ©•ª‚ÌK”ö‚ğ‘}“ü’†‚Ìê‡
        n = 1 if @active_battler.hold.tail.battler != nil
      end
      # ¡‘ŠèFK”öè—L’†•s‰Â‚ÌƒXƒLƒ‹‚Ìê‡
      if @skill.element_set.include?(165)
        # ‘Šè‚ÌK”ö‚ªè—L’†‚Ìê‡
        n = 1 if @target_battlers[0].hold.tail.battler != nil
      end
      # ¡K”öè—L’†‚Ì‚İ‰Â‚ÌƒXƒLƒ‹‚Ìê‡
      #------------------------------------------------------------------------
      if @skill.element_set.include?(167)
      # ©•ª‚ÌK”ö‚ªŠ‘}“üó‘Ô‚Å–³‚¢ê‡
        n = 1 unless @active_battler.tail_insert?
      end
      if @skill.element_set.include?(168)
      # ©•ª‚ÌK”ö‚ªŒûˆúó‘Ô‚Å–³‚¢ê‡
        n = 1 unless @active_battler.tail_oralsex?
      end
      if @skill.element_set.include?(169)
      # ©•ª‚ÌK”ö‚ªãèŠ­ó‘Ô‚Å–³‚¢ê‡
        n = 1 unless @active_battler.tail_analsex?
      end
      
      
      #------------------------------------------------------------------------
      # ¡Gèè—L’†‚Ì‚İ‰Â‚ÌƒXƒLƒ‹‚Ìê‡
      if @skill.element_set.include?(172)
      # ©•ª‚ÌGè‚ªŠ‘}“üó‘Ô‚Å–³‚¢ê‡
        n = 1 unless @active_battler.tentacle_insert?
      end
      if @skill.element_set.include?(173)
      # ©•ª‚ÌGè‚ªŒûˆúó‘Ô‚Å–³‚¢ê‡
        n = 1 unless @active_battler.tentacle_oralsex?
      end
      if @skill.element_set.include?(174)
      # ©•ª‚ÌGè‚ªãèŠ­ó‘Ô‚Å–³‚¢ê‡
        n = 1 unless @active_battler.tentacle_analsex?
      end
      if @skill.element_set.include?(175)
      # ©•ª‚ÌGè‚Å‘Šè‚ğS‘©‚µ‚Ä‚¢‚È‚¢ê‡
        n = 1 unless @active_battler.tentacle_binding?
      end
      if @skill.element_set.include?(176)
      # ©•ª‚ÌGè‚Å‘Šè‚ğS‘©‚µ‚Ä‚¢‚È‚¢ê‡
        n = 1 unless @active_battler.tentacle_openbinding?
      end

      #------------------------------------------------------------------------
      # ¡©•ªFƒfƒBƒ‹ƒhè—L’†•s‰Â‚ÌƒXƒLƒ‹‚Ìê‡
      if @skill.element_set.include?(182)
        # ©•ª‚ÌƒfƒBƒ‹ƒh‚ğ‘}“ü’†‚Ìê‡
        n = 1 if @active_battler.hold.dildo.battler != nil
      end
      # ¡‘ŠèFƒfƒBƒ‹ƒhè—L’†•s‰Â‚ÌƒXƒLƒ‹‚Ìê‡
      if @skill.element_set.include?(190)
        # ©•ª‚ÌƒfƒBƒ‹ƒh‚ğ‘}“ü’†‚Ìê‡
        n = 1 if @target_battlers[0].hold.dildo.battler != nil
      end
      # ¡K”öè—L’†‚Ì‚İ‰Â‚ÌƒXƒLƒ‹‚Ìê‡
      #------------------------------------------------------------------------
      if @skill.element_set.include?(183)
      # ©•ª‚ÌƒfƒBƒ‹ƒh‚ªŠ‘}“üó‘Ô‚Å–³‚¢ê‡
        n = 1 unless @active_battler.dildo_insert?
      end
      if @skill.element_set.include?(184)
      # ©•ª‚ÌƒfƒBƒ‹ƒh‚ªŒûˆúó‘Ô‚Å–³‚¢ê‡
        n = 1 unless @active_battler.dildo_oralsex?
      end
      if @skill.element_set.include?(185)
      # ©•ª‚ÌƒfƒBƒ‹ƒh‚ªãèŠ­ó‘Ô‚Å–³‚¢ê‡
        n = 1 unless @active_battler.dildo_analsex?
      end
      # ¡‘Î’j—pƒXƒLƒ‹‚Ìê‡(ƒAƒNƒ^[‚©‚ç‚Ìê‡A‘Šè‚ª—¼«‚È‚çg—p‰Â)
      if @skill.element_set.include?(41)
      #----------------------------------------------------------------
        # ‘Šè‚ª—¼«‹ï—L‚Å‚È‚¢ê‡
        n = 1 unless @target_battlers[0].futanari?
      end
      
      # ¡‘Î——pƒXƒLƒ‹‚Ìê‡
      if @skill.element_set.include?(42)
      #----------------------------------------------------------------
        # ‘Šè‚ª’jiålŒöj‚Å‚ ‚éê‡
        n = 1 if @target_battlers[0].boy?
      end

      # ¡ƒXƒLƒ‹‹¸³
      # ----------------------------------------------------------------

      # ƒGƒ‰[ƒJƒEƒ“ƒg‚Ìê‡‚ÍƒAƒNƒVƒ‡ƒ“‚ğ–³Œø‰»
      if n == 1
        $game_temp.forcing_battler = nil
        @wait_count = 0
        @phase4_step = 6
        return
      end
    end

    # ---------------------------------------------------------------

    # šƒ^[ƒQƒbƒgƒoƒgƒ‰[‚Ìî•ñ‚ğ‹L‰¯@¦ƒRƒ‚ƒ“ƒCƒxƒ“ƒg‚Åg‚¢‚Ü‚·B
    $game_temp.battle_target_battler = @target_battlers
#    p "‘ÎÛ(Œˆ’è)F#{@target_battlers[0].name}" if $DEBUG
#    p "g—pƒXƒLƒ‹(Œˆ’è)F#{@skill.name}" if $DEBUG

    # ‹­§ƒAƒNƒVƒ‡ƒ“‚Å‚È‚¯‚ê‚Î
    unless @active_battler.current_action.forcing
      # SP Ø‚ê‚È‚Ç‚Åg—p‚Å‚«‚È‚­‚È‚Á‚½ê‡
      unless @active_battler.skill_can_use?(@skill.id)
#        p "ƒAƒNƒVƒ‡ƒ“ğŒ•s”õ‚É‚æ‚è—š—ğƒNƒŠƒAF#{@skill.name}" if $DEBUG
        # ƒAƒNƒVƒ‡ƒ“‹­§‘ÎÛ‚Ìƒoƒgƒ‰[‚ğƒNƒŠƒA
        $game_temp.forcing_battler = nil
        # ƒXƒeƒbƒv 6 ‚ÉˆÚs
        @phase4_step = 6
        return
      end
    end
    
    # ’ÇŒ‚’†‚Å‚È‚¯‚ê‚Î@SP Á”ï‚ğs‚¤
    unless $game_switches[78]
      @active_battler.sp -= SR_Util.sp_cost_result(@active_battler, @skill)
      # ƒGƒlƒ~[‚ª‚u‚o‚ğÁ”ï‚·‚é•â•ƒXƒLƒ‹‚ğg—p‚µ‚½ê‡A
      # •â•ƒXƒLƒ‹ƒJƒEƒ“ƒg‚ğ‘‚â‚·
      if @active_battler.is_a?(Game_Enemy) and
       SR_Util.sp_cost_result(@active_battler, @skill) > 0 and
       (@skill.element_set.include?(4) or @skill.element_set.include?(5))
        @active_battler.support_skill_count += 1
      end
    end
    
    # ƒXƒe[ƒ^ƒXƒEƒBƒ“ƒhƒE‚ğƒŠƒtƒŒƒbƒVƒ…
    @status_window.refresh
    
    #g—p‚µ‚Ä‚¢‚éƒXƒLƒ‹‚ªè{Œû‚Ì•¡‡UŒ‚‚Ìê‡A‘®«‚ğ‚±‚±‚ÅK“¾
    if @skill.element_set.include?(84)
      @skill.element_set.delete(71) if @skill.element_set.include?(71)#è
      @skill.element_set.delete(72) if @skill.element_set.include?(72)#Œû
      #Œû‚ª••ˆóó‘Ô‚Ìê‡‚Íè‚Ì‚İ
      if @active_battler.hold.mouth.battler != nil
        @skill.element_set.push(71)
      #Œû‚Í‘åä•v‚¾‚ªã”¼g••ˆóó‘Ô‚Ìê‡‚ÍŒû‚Ì‚İ
      elsif @active_battler.hold.tops.battler != nil
        @skill.element_set.push(72)
      #‚Ç‚¿‚ç‚Å‚à–³‚¢ê‡‚Íƒ‰ƒ“ƒ_ƒ€
      else
        if rand(100) >= 50
          @skill.element_set.push(71)
        else
          @skill.element_set.push(72)
        end
      end
    end
    # šƒ‰ƒ“ƒ_ƒ€ƒXƒLƒ‹‚ğg—p‚·‚éê‡Aê—pƒy[ƒW‚Ö”ò‚Î‚·
#    if $data_skills[@active_battler.current_action.skill_id].element_set.include?(9)
#      p $data_skills[@active_battler.current_action.skill_id].name
#      random_skill_action
#    end
    # ¡ƒXƒLƒ‹–¼‚ğ•\¦‚·‚éê‡
    if @skill.element_set.include?(14)
      # šƒwƒ‹ƒvƒEƒBƒ“ƒhƒE‘Ñ‚ğ•\¦
      @help_window.window.visible = true
      #ƒxƒbƒhƒCƒ“’†‚Íƒg[ƒN–¼Ì‚ğƒsƒ[ƒg[ƒN‚É•ÏX
      if $game_switches[85] == true and @skill.name == "ƒg[ƒN"
        # ƒwƒ‹ƒvƒEƒBƒ“ƒhƒE‚ÉƒXƒLƒ‹–¼‚ğ•\¦
        @help_window.set_text("ƒsƒ[ƒg[ƒN", 1)
      else
        # ƒwƒ‹ƒvƒEƒBƒ“ƒhƒE‚ÉƒXƒLƒ‹–¼‚ğ•\¦
        @help_window.set_text(@skill.name, 1)
      end
    end
    # ƒAƒjƒ[ƒVƒ‡ƒ“ ID ‚ğİ’è
    @animation1_id = @skill.animation1_id
    @animation2_id = @skill.animation2_id
    # ƒRƒ‚ƒ“ƒCƒxƒ“ƒg ID ‚ğİ’è
    @common_event_id = @skill.common_event_id
    
    # šƒGƒlƒ~[‚Ì•\¦ó‘Ô‚Ì•ÏXi‘ÎÛ‚ª‘S‘Ì‚Ìê‡‚Í•ÏX–³‚µj
    # iƒAƒNƒeƒBƒu‚ªƒAƒNƒ^[‚Ìê‡‚Í‚±‚±‚Åƒ^[ƒQƒbƒg‚ª‰f‚éj
    if @target_battlers[0].is_a?(Game_Enemy) and @active_battler.is_a?(Game_Actor) \
     and @skill.scope != 2 and @skill.scope != 4 
      enemies_display(@target_battlers[0])
    # iƒAƒNƒeƒBƒu‚ªƒGƒlƒ~[‚Ìê‡‚Í‚±‚±‚ÅƒAƒNƒeƒBƒu‚ª‰f‚éj
    elsif @active_battler.is_a?(Game_Enemy)
      enemies_display(@active_battler)
    end

    
    
    # ƒXƒLƒ‹‚ÌŒø‰Ê‚ğ“K—p
    for target in @target_battlers
      #ƒ^[ƒQƒbƒgŒˆ’èŒãAUŒ‚‘¤‚ªƒAƒNƒ^[‚Ìê‡‚Íƒ^[ƒQƒbƒg‚És‚í‚ê‚½ƒXƒLƒ‹”»’è
      if target.is_a?(Game_Enemy) and @active_battler.is_a?(Game_Actor)
        #‘ÎÛ‚És‚Á‚½ƒXƒLƒ‹ID‚ª–‚–@‚Å‚È‚­A‚©‚Â’¼‘O‚És‚í‚ê‚½‚à‚Ì‚Æ“¯ˆê‚È‚çƒJƒEƒ“ƒg
        if @skill.id == target.before_suffered_skill_id and not @skill.element_set.include?(5)
          $repeat_skill_num += 1 unless $game_switches[78] == true #’ÇŒ‚’†‚ÍƒJƒEƒ“ƒg‚µ‚È‚¢
        else
          # •Ê‚ÈUŒ‚ƒXƒLƒ‹‚È‚çƒŠƒZƒbƒg
          $repeat_skill_num = 0
          target.before_suffered_skill_id = @skill.id
        end
      end
      #g‚Á‚½ƒXƒLƒ‹‚ğŠm’è‚µ$game_temp‚É‹L˜^
      $game_temp.used_skill = @skill
      #ƒXƒLƒ‹ƒGƒtƒFƒNƒg
      target.skill_effect(@active_battler, @skill)
    end
  end
  #--------------------------------------------------------------------------
  # œ ƒAƒCƒeƒ€ƒAƒNƒVƒ‡ƒ“ Œ‹‰Êì¬
  #--------------------------------------------------------------------------
  def make_item_action_result
    # ƒAƒCƒeƒ€‚ğæ“¾
    @item = $data_items[@active_battler.current_action.item_id]
    # šƒ^[ƒQƒbƒgƒoƒgƒ‰[‚Ìî•ñ‚ğ‹L‰¯@¦ƒRƒ‚ƒ“ƒCƒxƒ“ƒg‚Åg‚¢‚Ü‚·B
    $game_temp.battle_target_battler = @target_battlers
    # ƒAƒCƒeƒ€Ø‚ê‚È‚Ç‚Åg—p‚Å‚«‚È‚­‚È‚Á‚½ê‡
    unless $game_party.item_can_use?(@item.id)
      # ƒXƒeƒbƒv 1 ‚ÉˆÚs
      @phase4_step = 1
      return
    end
    # Á–Õ•i‚Ìê‡
    if @item.consumable
      # g—p‚µ‚½ƒAƒCƒeƒ€‚ğ 1 Œ¸‚ç‚·
      $game_party.lose_item(@item.id, 1)
    end
    # šƒwƒ‹ƒvƒEƒBƒ“ƒhƒE‘Ñ‚ğ•\¦
    @help_window.window.visible = true
    # ƒwƒ‹ƒvƒEƒBƒ“ƒhƒE‚ÉƒAƒCƒeƒ€–¼‚ğ•\¦
    @help_window.set_text(@item.name, 1)
    # ƒAƒjƒ[ƒVƒ‡ƒ“ ID ‚ğİ’è
    @animation1_id = @item.animation1_id
    @animation2_id = @item.animation2_id
    # ƒRƒ‚ƒ“ƒCƒxƒ“ƒg ID ‚ğİ’è
    @common_event_id = @item.common_event_id
    # ‘ÎÛ‚ğŒˆ’è
    index = @active_battler.current_action.target_index
    target = $game_party.smooth_target_actor(index)
    # ‘ÎÛ‘¤ƒoƒgƒ‰[‚ğİ’è
    set_target_battlers(@item.scope)
    
    # šƒGƒlƒ~[‚Ì•\¦ó‘Ô‚Ì•ÏXi‘ÎÛ‚ª‘S‘Ì‚Ìê‡‚Í•ÏX–³‚µj
    if @target_battlers[0].is_a?(Game_Enemy) \
     and @item.scope != 2 and @item.scope != 4 
      enemies_display(@target_battlers[0])
    end

    
    # ƒAƒCƒeƒ€‚ÌŒø‰Ê‚ğ“K—p
    for target in @target_battlers
      target.item_effect(@item)
    end
  end
  #--------------------------------------------------------------------------
  # œ ˆú“Åˆ—
  #--------------------------------------------------------------------------
  def special_mushroom_effect(battler)
    
    # •¹”­‚Å‚«‚é‚à‚Ì‚ğ‘Ï«‚İ‚ÅŒŸ¸
    bs = [0,0,0,45,45,45,45,37,39,40]
    # ‹•’E
    registance = battler.state_percent(nil, 37, nil)
    if battler.states.include?(37) or rand(100) >= registance
      bs.delete(37) 
    end
    # –ƒáƒ
    registance = battler.state_percent(nil, 39, nil)
    if battler.states.include?(39) or rand(100) >= registance
      bs.delete(39) 
    end
    # U–Ÿ
    registance = battler.state_percent(nil, 40, nil)
    if battler.states.include?(37) or rand(100) >= registance
      bs.delete(40) 
    end
    # •¹”­‚Å‚«‚é‚à‚Ì‚ª‚È‚¢ê‡Aƒƒ\ƒbƒhI—¹
    return if bs == []
    
    # •¹”­‚Å‚«‚é‚à‚Ì‚Ì’†‚©‚ç‚P‚Â‘I‚ñ‚Å‚»‚ÌƒXƒe[ƒg‚ğ•t—^
    bs = bs[rand(bs.size)]
    # 0‚Ìê‡‚Í•¹”­–³‚µ
    return if bs == 0
    # •¹”­
    battler.add_state(bs)
    
  end
end