#==============================================================================
# ¡ SR_Util@F@‚»‚Ì‘¼
#------------------------------------------------------------------------------
#==============================================================================
module SR_Util
  
  #--------------------------------------------------------------------------
  # œ ‚±‚Ì“G–²–‚‚ª–{‹C‚ğo‚µ‚Ä‚¢‚È‚¢
  #--------------------------------------------------------------------------
  def self.enemy_before_earnest?(enemy)
    result = false
    # ƒxƒXƒgƒGƒ“ƒhƒ”ƒFƒ‹ƒ~ƒB[ƒií
    if $game_temp.battle_troop_id == 603
      # ƒGƒlƒ~[ˆÊ’u‚ª‚O”ÔŠ‚ÂA‚Ü‚¾–{‹C‚ğo‚µ‚Ä‚¢‚È‚¢
      if enemy == $game_troop.enemies[0] and not $game_troop.enemies[0].earnest
        result = true
      end
    end
    return result
  end
  #--------------------------------------------------------------------------
  # œ “Áê‚È•‚ğ’E‚®
  #--------------------------------------------------------------------------
  def self.special_undress(enemy)
    enemy.undress
    if $game_temp.battle_log_text != ""
      text = "\\" + enemy.bms_states_update
    else
      text = enemy.bms_states_update
    end
    enemy.graphic_change = true
    end
  #--------------------------------------------------------------------------
  # œ “Áê‚Èƒz[ƒ‹ƒh”­¶‚ğs‚¤
  #--------------------------------------------------------------------------
  def self.special_hold_make(skill, active, target)
    $scene.special_hold_start
    $scene.hold_effect(skill, active, target)
    target.white_flash = true
    target.animation_id = 105
    target.animation_hit = true
    # ‰æ–Ê‚ÌcƒVƒFƒCƒN
    $game_screen.start_flash(Color.new(255,210,225,220), 8)
    $game_screen.start_shake2(7, 15, 15)
    # —¼Ò‚ÉƒXƒ^ƒ“‚ğ‚©‚¯‚é
    $scene.battler_stan(active)
    $scene.battler_stan(target)
    $scene.special_hold_end
  end
  #--------------------------------------------------------------------------
  # œ ƒz[ƒ‹ƒhî•ñ‚Æƒp[ƒc–¼‚©‚ç‘Î‰ƒp[ƒc‚ğ•Ô‚·
  #--------------------------------------------------------------------------
  def self.holding_parts_name(hold_type, parts_name)
    box = []
    if hold_type == "Š‘}“ü"
      box.push(["penis"])
      box.push(["vagina"])
    elsif hold_type == "Œû‘}“ü"
      box.push(["penis"])
      box.push(["mouth"])
    elsif hold_type == "K‘}“ü"
      box.push(["penis"])
      box.push(["anal"])
    elsif hold_type == "ƒpƒCƒYƒŠ"
      box.push(["tops"])
      box.push(["penis"])
    elsif hold_type == "‚Ï‚Ó‚Ï‚Ó"
      box.push(["tops"])
      box.push(["mouth"])
    elsif hold_type == "S‘©"
      box.push(["tops"])
      box.push(["tops"])
    elsif hold_type == "Šç–Ê‹Ræ"
      box.push(["vagina"])
      box.push(["mouth"])
    elsif hold_type == "K‹Ræ"
      box.push(["anal"])
      box.push(["mouth"])
    elsif hold_type == "ƒNƒ“ƒj"
      box.push(["mouth"])
      box.push(["vagina"])
    elsif hold_type == "ŠL‡‚í‚¹"
#      box.push(["vagina","anal"])
#      box.push(["vagina","anal"])
      box.push(["vagina"])
      box.push(["vagina"])
    elsif hold_type == "ƒfƒBƒ‹ƒhŠ‘}“ü"
      box.push(["dildo"])
      box.push(["vagina"])
    elsif hold_type == "ƒfƒBƒ‹ƒhŒû‘}“ü"
      box.push(["dildo"])
      box.push(["mouth"])
    elsif hold_type == "ƒfƒBƒ‹ƒhK‘}“ü"
      box.push(["dildo"])
      box.push(["anal"])
    elsif hold_type == "Gè‹zˆø"
      box.push(["tentacle"])
      box.push(["penis"])
    elsif hold_type == "GèƒNƒ“ƒj"
      box.push(["tentacle"])
      box.push(["vagina"])
    end
    # ‚P‚Â–Ú‚É‘Î‰ƒp[ƒc‚ª‚ ‚éê‡‚ÍA‚Q‚Â–Ú‚ğ•Ô‚·
    if box[0].include?(parts_name)
      return box[1]
    # ‚P‚Â–Ú‚É‘Î‰ƒp[ƒc‚ª‚È‚¢ê‡‚ÍA‚P‚Â–Ú‚ğ•Ô‚·
    else
      return box[0]
    end
  end
  #--------------------------------------------------------------------------
  # œ ‹t“]‚Å‚«‚éƒz[ƒ‹ƒhH
  #--------------------------------------------------------------------------
  def self.reversible_hold?(hold_type)
    return true if ["Š‘}“ü","ŠL‡‚í‚¹"].include?(hold_type)
    return false
  end
  #--------------------------------------------------------------------------
  # œ ‘SƒAƒCƒeƒ€“üèƒCƒxƒ“ƒg‚Ì’†g‚ğŠm”F‚µAo—Í
  #--------------------------------------------------------------------------
  def self.treasure_box_check
    # ƒcƒN[ƒ‹‚ÅŠJ‚¢‚Ä‚¢‚é‡‚Éƒ}ƒbƒvID‚ğ“ü‚ê‘Ö‚¦‚é
    maplist = load_data("Data/MapInfos.rxdata")
    num_box = [] 
    for i in 1..999
      if maplist[i] != nil
        num_box.push([i, maplist[i].order])
      end
    end
    num_box.sort!{|a,b| a[1] <=> b[1] }
    # ‚P‚Â‚¸‚Âƒ}ƒbƒv‚Ì•ó” ‚ğŠm”F‚·‚é
    all_text = ""
    count = 0
    for num in num_box
      i = num[0]
      map_name = (sprintf("Data/Map%03d.rxdata", i))
      next unless FileTest.exist?(map_name)
      map = load_data(map_name)
      events = {}
      text = ""
      for j in map.events.keys
        events[j] = Game_Event.new(i, map.events[j])
#        if map.events[j].pages[0].graphic.character_name == "174-Chest01"
          for list_one in map.events[j].pages[0].list
            contents = ""
            case list_one.code
            when 125 # ƒS[ƒ‹ƒh
              number = list_one.parameters[2]
              contents = "@#{number}Lps." if list_one.parameters[1] != 0
            when 126 # ƒAƒCƒeƒ€
              name = $data_items[list_one.parameters[0]].name
              number = list_one.parameters[3]
              contents = "@#{name} #{number}ŒÂ" if list_one.parameters[1] != 1
            when 128 # –h‹ï
              name = $data_armors[list_one.parameters[0]].name
              number = list_one.parameters[3]
              contents = "@#{name} #{number}ŒÂ" if list_one.parameters[1] != 1
            end
            text += contents + "\n" if contents != ""
          end
#        end
      end
      if text != ""
        all_text += "¡#{maplist[i].name}\n" + text + "\n"
      end
      count += 1
      Graphics.update if count % 50 == 0 
    end
    # treasure_box.txt‚Éo—Í‚·‚é
    file_name = "treasure_box.txt"    #•Û‘¶‚·‚éƒtƒ@ƒCƒ‹–¼
    File.open(file_name, 'w') {|file|
     file.write all_text
    }
    p "treasure_box.txt‚Éo—Í‚µ‚Ü‚µ‚½"
  end
  #--------------------------------------------------------------------------
  # œ –²Š±Â‚ª‰Â”\‚©‚Ç‚¤‚©
  #--------------------------------------------------------------------------
  def self.can_dream_interference?
    result = false
    result = true if $game_party.all_d_power >= 300
    return result
  end
  #--------------------------------------------------------------------------
  # œ ålŒö‚Ìã“_‚ğŒˆ‚ß’¼‚·
  #--------------------------------------------------------------------------
  def self.hero_weak_change(weak_id_box = [], type = 0)
    case type
    # type‚É‚æ‚Á‚ÄÁ‚·ã“_‚ğ•Ï‚¦‚é
    #----------------------------------------------------------------------
    when 0 # Šî–{ã“_
      # Šî–{ã“_‚ğ‘S‚ÄÁ‚·
      for i in [10,11,12,13]
        $game_actors[101].remove_ability(i)
      end
    when 1 # “Áêã“_
      # “Áêã“_‚ğ‘S‚ÄÁ‚·
      for i in [16,14]
        $game_actors[101].remove_ability(i)
      end
    end
    #----------------------------------------------------------------------
    # w’è‚³‚ê‚½ã“_‚ğ‘S‚ÄK“¾
    for i in weak_id_box
      $game_actors[101].gain_ability(i)
    end
  end
  #--------------------------------------------------------------------------
  # œ Šî–{ã“_‚ğŒˆ‚ß‚é
  #--------------------------------------------------------------------------
  def self.normal_weak_dicide(weak_box)
    result = []
    # ŒûU‚ß‚Éã‚¢
    result.push(10) if weak_box[0]
    # KU‚ß‚Éã‚¢
    result.push(11) if weak_box[1]
    # ‹¹U‚ß‚Éã‚¢
    result.push(12) if weak_box[2]
    # —‰AU‚ß‚Éã‚¢
    result.push(13) if weak_box[3]
    # •Ô‚·
    return result
  end
  #--------------------------------------------------------------------------
  # œ “Áêã“_‚ğŒˆ‚ß‚é
  #--------------------------------------------------------------------------
  def self.special_weak_dicide(weak_box)
    result = []
    # «Œğ‚Éã‚¢
    result.push(16) if weak_box[0]
    # šn‹sU‚ß‚Éã‚¢
    result.push(14) if weak_box[1]
    # •Ô‚·
    return result
  end
  #--------------------------------------------------------------------------
  # œ ƒg[ƒN—pƒƒOƒEƒFƒCƒg‚Ìì¬
  #--------------------------------------------------------------------------
  def self.talk_log_wait_make
    log = $game_temp.battle_log_text
    if log != ""
      # s”‚É‡‚í‚¹‚ÄƒEƒFƒCƒg‚ğ“ü‚ê‚é
      log = log.split(/[\n\]/)
      ct = (4 * (log.size + 1)) + $game_system.battle_speed_time(0) + $game_system.important_wait_time
#      ct = (4 * 3) + $game_system.battle_speed_time(0) + $game_system.important_wait_time
      $game_temp.set_wait_count = ct
    else
      $game_temp.set_wait_count = 0
    end
  end
  #--------------------------------------------------------------------------
  # œ ó‘ÔˆÙíˆµ‚¢ƒXƒe[ƒg
  #--------------------------------------------------------------------------
  def self.bad_states
    reslut = []
    # ‚Vó‘ÔˆÙí
    for i in 34..40
      reslut.push(i)
    end
    reslut.push(30)  # ˆú“Å
#    reslut.push(13)   # ƒfƒBƒŒƒC
#    reslut.push(105)  # S‘©
#    reslut.push(106)  # ”j–Ê
    return reslut 
  end
  #--------------------------------------------------------------------------
  # œ ŒöŠJƒXƒe[ƒg
  #--------------------------------------------------------------------------
  def self.checking_states
    #--------------------------------------------------------------------------
    # ŒöŠJ‚³‚ê‚éƒXƒe[ƒgBƒ_ƒ[ƒW‚ª–³‚­‚±‚ê‚ç‚Ì•t—^‚ğs‚¤ƒXƒLƒ‹‚ÍA
    # d•¡‚Ìg—p•s‰Âƒ`ƒFƒbƒN‚ª‚³‚ê‚½‚èA¸”s‚ÌƒeƒLƒXƒg‚ªo‚½‚è‚·‚éB
    #--------------------------------------------------------------------------
    reslut = []
    # ƒhƒLƒhƒL‚QíA‚Vó‘ÔˆÙíA‚—g’¾’…
    for i in 32..42
      reslut.push(i)
    end
    # Š´“xã¸
    for i in 45..50
      reslut.push(i)
    end
    # ‚»‚Ì‘¼
    reslut.push(13)  # ƒfƒBƒŒƒC
    reslut.push(30)  # ˆú“Å
    reslut.push(98)  # –‚–@w
    reslut.push(101) # j•Ÿ
    reslut.push(102) # Å‘‡
    reslut.push(103) # êS
    reslut.push(105) # S‘©
    reslut.push(106) # ”j–Ê
    # •Ô‚·
    return reslut
  end
  #--------------------------------------------------------------------------
  # œ –¿–ñ‚Ì‹V®·s
  #--------------------------------------------------------------------------
  def self.compact_ritual_start
    # ƒp[ƒeƒB‚ª‚QlˆÈ‰º‚Ìê‡A·s•s‰Â
    if $game_party.party_actors.size < 2
      return false
    end
    # ğŒƒ`ƒFƒbƒN
    return false unless $game_party.party_actors[1].love >= 150
    return false unless $game_party.party_actors[1].have_ability?("’ˆ¤")
    return false unless $game_party.party_actors[1].promise >= 10000
    return false if $game_party.party_actors[1].have_ability?("‘åØ‚Èl")
    # •Ô‚·
    return true
  end
  #--------------------------------------------------------------------------
  # œ ŒÃˆó”jŠü‚Ì‹V®·s
  #--------------------------------------------------------------------------
  def self.ancient_rune_ritual_start
    # ƒp[ƒeƒB‚ª‚SlˆÈ‰º‚Ìê‡A·s•s‰Â
    if $game_party.party_actors.size < 4
      return false
    end
    # ’‡ŠÔ‚Ì‚Rl‚ª¸_—Í100ˆÈãA‚u‚o1000ˆÈã‚ğ–‚½‚µ‚Ä‚¢‚È‚¢ê‡A·s•s‰Â
    for i in 1..3
      unless $game_party.party_actors[i].int >= 100 and
       $game_party.party_actors[i].sp >= 1000
        return false
      end
    end
    # ‘Î‰¿‚Ì‚u‚o1000‚ğx•¥‚¢A·sŠJnB
    for i in 1..3
      $game_party.party_actors[i].sp -= 1000
    end
    return true
  end
  #--------------------------------------------------------------------------
  # œ ƒXƒe[ƒ^ƒXŒvZ®ˆêŠ‡
  #--------------------------------------------------------------------------
  def self.status_calculate(int, level, type)
    reslut = 1
    case type
    when 0 # ‚d‚oE‚u‚o
      reslut = int * 8 * level / $Status_UP_RATE + 300
    when 1 # –£—ÍE”E‘Ï—Í
      reslut = int * 3 * level / $Status_UP_RATE + 50
    when 2 # ¸—ÍEŠí—p‚³E‘f‘‚³E¸_—Í
      reslut = int * 3 * level / $Status_UP_RATE + 30
    end
    return reslut
  end
  #--------------------------------------------------------------------------
  # œ Šm”F
  #--------------------------------------------------------------------------
  def self.test_do
    number = 0
    case number
    when 3..1.0/0 
      p "ok" if $DEBUG
    else
      p "out" if $DEBUG
    end
  end
  #--------------------------------------------------------------------------
  # š ‹z¸
  #--------------------------------------------------------------------------
  def self.energy_drain(active_battler,target_battler)
    # â’¸‚³‚¹‚½‚Ì‚ªƒAƒNƒ^[‚Ìê‡A–• “x‚ğ‰ñ•œ
     if active_battler.is_a?(Game_Actor)
      active_battler.fed += 20
    end
  end
  #--------------------------------------------------------------------------
  # œ ŒûãŠm”Fi–vj
  #--------------------------------------------------------------------------
  def self.make_succubus_message(battler)
    # ’‚éƒGƒlƒ~[‚Æ‘ÎÛ‚ğ‘ã“ü
    $msg.t_enemy = battler
    $msg.t_target = $game_party.party_actors[0]
    # ƒAƒNƒeƒBƒuƒGƒlƒ~[‚ğ‰¼‘ã“ü
    temp_active = $game_temp.battle_active_battler
    $game_temp.battle_active_battler = $msg.t_enemy
    
    $msg.at_type = "ƒz[ƒ‹ƒhUŒ‚"
    $msg.at_parts = "Š‘}“üFƒAƒ\ƒR‘¤"
    
    # o—Í
    p $msg.call(battler) if $DEBUG
    
    # Œ³‚É–ß‚·
    $game_temp.battle_active_battler = temp_active
  end
  #--------------------------------------------------------------------------
  # œ ”ñƒVƒ“ƒ{ƒ‹í‘O‚Ì•Ï”ƒŠƒZƒbƒg
  #--------------------------------------------------------------------------
  def self.nonsymbol_battle_reset
    
    # æèŒãè‚ğƒtƒ‰ƒbƒg‚É
    $game_temp.first_attack_flag = 0
    # Šm’èŒ_–ñƒtƒ‰ƒO‚ğ•s‰Âó‘Ô‚É
    $game_temp.absolute_contract = 2
    
  end
  #--------------------------------------------------------------------------
  # œ K“¾ƒXƒLƒ‹•\‚ÌŠm”F
  #--------------------------------------------------------------------------
  def self.debug_learnings_check
    for i in 1..300
      
      next if $data_classes[i].name == ""
      next if $data_classes[i].name.include?("¡")
      next if $data_classes[i].name.include?("ydataz")
      
      message = ""
      message += "#{$data_classes[i].name} #{$data_classes[i].color}\n"
      for learn in $data_classes[i].learnings
        case learn[1] 
        when 0
          next if [2,4,81,82,83,84,121,123].include?(learn[2])
          message += "Lv#{learn[0].to_s}.#{$data_skills[learn[2]].name}\n"
        when 1
          message += "Lv#{learn[0].to_s}.y#{$data_ability[learn[2]].name}z\n"
        end
      end
      print message
    end
  end
  #--------------------------------------------------------------------------
  # œ ƒ{[ƒiƒX•\‚ÌŠm”F
  #--------------------------------------------------------------------------
  def self.debug_bonus_check
    for i in 1..300
      
      next if $data_classes[i].name == ""
      next if $data_classes[i].name.include?("¡")
      next if $data_classes[i].name.include?("ydataz")
      
      message = ""
      message += "#{$data_classes[i].name} #{$data_classes[i].color}\n"
      for learn in $data_classes[i].bonus
        case learn[1] 
        when 0
          message += "Cost:#{learn[0].to_s}.#{$data_skills[learn[2]].name}\n"
        when 1
          next if [19,21,23,27,29].include?(learn[2])
          message += "Cost:#{learn[0].to_s}.y#{$data_ability[learn[2]].name}z\n"
        end
      end
      print message
    end
  end
  #--------------------------------------------------------------------------
  # œ ¸‚ÌŒ£ã‚ÌƒXƒe[ƒ^ƒX•Ï“®
  #    ¦‘‚«•û‚ª—Ç‚­‚Í‚È‚¢‚ªŒ³X‚ ‚Á‚½‚à‚Ì‚ğƒRƒsƒy‚µ‚½‚à‚Ì‚Ì‚½‚ßA“®ì‚Í‘åä•vB
  #--------------------------------------------------------------------------
  def self.spam_gift_change
    $game_actors[101].sp -= 
    $game_temp.battle_active_battler.absorb
    for actor in $game_party.party_actors
      if actor == $game_temp.battle_active_battler
        actor.fed = 100
        actor.promise += 100
        actor.promise += 20 if actor.equip?("ƒKƒ‰ƒX‚Ìw—Ö")
        actor.promise += 30 if actor.equip?("M—Š‚Ìƒ‹[ƒ“")
        actor.love += 3
        actor.love += 2 if actor.equip?("ƒKƒ‰ƒX‚Ìw—Ö")
        #actor.love_dish_bonus(0)
        actor.hp = actor.maxhp if actor.equip?("”üH‚Ìƒ‹[ƒ“")
        actor.sp = actor.maxsp if actor.equip?("”üH‚Ìƒ‹[ƒ“")
        actor.remove_state(15)
      elsif actor != $game_actors[101]
        actor.love += 1
        actor.love += 1 if actor.equip?("ƒKƒ‰ƒX‚Ìw—Ö")
        actor.promise += 10
        actor.promise += 5 if actor.equip?("ƒKƒ‰ƒX‚Ìw—Ö")
        actor.promise += 5 if actor.equip?("M—Š‚Ìƒ‹[ƒ“")
      end
    end
  end
  #--------------------------------------------------------------------------
  # œ ƒxƒbƒhíŒã‚ÌƒXƒe[ƒ^ƒX•Ï“®
  #    ¦‘‚«•û‚ª—Ç‚­‚Í‚È‚¢‚ªŒ³X‚ ‚Á‚½‚à‚Ì‚ğƒRƒsƒy‚µ‚½‚à‚Ì‚Ì‚½‚ßA“®ì‚Í‘åä•vB
  #--------------------------------------------------------------------------
  def self.bed_battle_change
    favor_list = []
    for actor in $game_temp.vs_actors
      $game_actors[actor.id].vs_me = false
      $game_actors[actor.id].love += 3
      $game_actors[actor.id].love += 2 if actor.equip?("ƒKƒ‰ƒX‚Ìw—Ö")
      $game_actors[actor.id].promise += 30
      $game_actors[actor.id].promise += 20 if actor.equip?("ƒKƒ‰ƒX‚Ìw—Ö")
      $game_actors[actor.id].promise += 30 if actor.equip?("M—Š‚Ìƒ‹[ƒ“")
      #$game_actors[actor.id].love_dish_bonus(1)
      $game_party.add_actor(actor.id)
      $game_party.battle_actor_refresh
      # DŠ´“x‚ª100ˆÈãŠ‚Â’ˆ¤‚ª‚Â‚¢‚Ä‚¢‚È‚¢ê‡A’ˆ¤ƒŠƒXƒg‚É’Ç‰Á‚·‚é
      if $game_actors[actor.id].love >= 100 and not $game_actors[actor.id].have_ability?("’ˆ¤")
        favor_list.push($game_actors[actor.id])
      end
    end
    for actor in $game_party.party_actors
      if actor != $game_actors[101]
        $game_actors[actor.id].love += 3
        $game_actors[actor.id].love += 2 if actor.equip?("ƒKƒ‰ƒX‚Ìw—Ö")
        $game_actors[actor.id].promise += 20
        $game_actors[actor.id].promise += 20 if actor.equip?("ƒKƒ‰ƒX‚Ìw—Ö")
        $game_actors[actor.id].promise += 30 if actor.equip?("M—Š‚Ìƒ‹[ƒ“")
        $game_actors[actor.id].bedin_count += 1
        #$game_actors[actor.id].love_dish_bonus(2)
      end
    end
    $game_temp.vs_actors = []
    
    # ’ˆ¤ƒ`ƒFƒbƒN
    text = ""
    for favor_actor in favor_list
      text += "\n" if text != ""
      favor_actor.gain_ability(60)  # y’ˆ¤z
      favor_actor.gain_ability(302) # yƒAƒNƒZƒvƒgz‚ğ‚Á‚Ä‚¢‚È‚¢–²–‚‚à‚±‚±‚ÅK“¾
      text += "#{$game_actors[101].name} earned some favor from #{favor_actor.name}!"
    end
    $game_variables[2] = ""
    $game_variables[2] = text if text != ""
    
  end
  #--------------------------------------------------------------------------
  # œ ƒXƒLƒ‹Á”ï‚u‚o‚ÌŒvZ 
  #--------------------------------------------------------------------------
  def self.sp_cost_result(battler, skill)
    
    result = skill.sp_cost
    # –‚–@ƒXƒLƒ‹‚Ìê‡
    if skill.element_set.include?(5)
      # ƒXƒe[ƒgu–‚–@wv‚ª‚Â‚¢‚Ä‚¢‚éê‡A‚O‚ÉB
      result = 0 if battler.state?(98)
      # –‚“±‚Ìñü‚è‚ğ‘•”õ’†‚Ìê‡A1/2‚ÉB
      if battler.is_a?(Game_Actor)
        result /= 2 if battler.equip?("–‚“±‚Ìñü‚è")
      end
    end
    if not (skill.name == "ƒEƒFƒCƒg" or 
     skill.name == "ƒtƒŠ[ƒAƒNƒVƒ‡ƒ“" or
     skill.name == "ƒGƒ‚[ƒVƒ‡ƒ“" or 
     skill.name == "¬‹x~")
      # ‹•’Eó‘Ô‚Ìê‡AVP‚Ì3“‚ğ‰ÁZ
      if battler.state?(37)
        # ƒ{ƒXŒn‚Í‹•’E‚ÌŒø‰Ê‚ğã‰»‚³‚¹‚é
        if battler.is_a?(Game_Enemy) and (
        $data_enemies[battler.id].element_ranks[124] == 1 or # ƒCƒxƒ“ƒg“G‚Ìê‡
        $data_enemies[battler.id].element_ranks[126] == 1 or # ƒ{ƒX‚Ìê‡
        $data_enemies[battler.id].element_ranks[128] == 1)   # ƒ‰ƒXƒ{ƒX‚Ìê‡
          result += battler.maxsp * 0.005
        else
          result += battler.maxsp * 0.03
        end
        result = result.truncate
      end
      # ƒfƒ‚ƒ“ƒLƒXƒ}[ƒN‚ğ‘•”õ’†‚Ìê‡AVP‚Ì0.5“‚ğ‰ÁZ
      if battler.is_a?(Game_Actor)
        if battler.equip?("ƒfƒ‚ƒ“ƒLƒXƒ}[ƒN")
          result += battler.maxsp * 0.01
          result = result.truncate
        end
      end
    end
    return result
  end
  #--------------------------------------------------------------------------
  # œ ƒAƒiƒEƒ“ƒX
  #--------------------------------------------------------------------------
  def self.announce(text, se = "’Êí")
    $game_temp.announce_text.push([text, se])
  end
  #--------------------------------------------------------------------------
  # œ ƒ}ƒbƒv’†‚Ìˆê•Ï”‚ğƒŠƒZƒbƒg š
  #--------------------------------------------------------------------------
  def self.map_temp_variables_reset
    # ƒVƒ“ƒ{ƒ‹oŒ»•Ï”Eõ“G•Ï”
    for i in 102..150
      $game_variables[i] = 0
    end
    # ƒXƒvƒ‰ƒCƒg‚ÌÁ‚µ–Y‚ê‚ª‚ ‚éê‡‚ÍÁ‚·
    $sprite.dispose if $sprite != nil
  end
  #--------------------------------------------------------------------------
  # œ ƒQ[ƒ€ƒI[ƒo[‚Ì•Ï”‚ğƒŠƒZƒbƒg š
  #    ¦•—‚Ì—ƒ‚ğg—p‚µ‚½ê‡‚à‚±‚ê‚ğ’Ê‚è‚Ü‚·B
  #--------------------------------------------------------------------------
  def self.map_gameover_reset
    $game_variables[29] = 0 # ‘–‚Á‚¿‚áƒ_ƒ@’n‹æ”»’è
    $game_variables[38] = 0 # ˆÃˆÅ“xiÀ“­j
    $game_switches[53]  = false # Œv‰¹
    $game_switches[54]  = false # ’¹‚Ìš“‚è
    $game_switches[75]  = false # •—‚Ì—ƒg—p‹Ö~
    $game_switches[334] = false # ˆäŒË‚Ì–‚—‚É–Ú‚ğ•t‚¯‚ç‚ê‚½
    $game_switches[305] = false # ‚QŠK”»’èFƒSƒuƒŠƒ“ƒ^ƒEƒ“
    $game_switches[433] = false # ‚QŠK”»’èF–ŠE‰ÎR’Ê˜H
  end
  #--------------------------------------------------------------------------
  # œ ƒAƒCƒeƒ€“üè‚ÌƒeƒLƒXƒgì¬
  #--------------------------------------------------------------------------
  def self.item_get_message_make

    # ‰Šú‰»
    message = []
    text  = ""
    count = 0
    
    # ‰½‚à‚È‚©‚Á‚½‚çI—¹
    if $game_temp.get_item == [] or $game_temp.get_item == nil
      return message
    end
    
    # ‘SƒAƒCƒeƒ€‚ğŠm”F‚·‚é‚Ü‚Åƒ‹[ƒv
    while $game_temp.get_item.size > 0
    
      # ‚Ssg—p‚µ‚½‚çŸ‚Ìƒy[ƒW
      if count >= 4
        message.push(text)
        text  = ""
        count = 0
      end
      
      # ˆê”Ô‘O‚ÌƒAƒCƒeƒ€æ“¾ƒf[ƒ^‚ğ“Ç‚İ‚Ş
      data = $game_temp.get_item.shift
      text += "\\T[#{data[1]}]#{data[2]}#{data[0]}@‚ğè‚É“ü‚ê‚½I"
      if $game_temp.get_item.size > 0
        count += 1
        text += "\n" if count < 4
      end
    end
    
    # ƒƒbƒZ[ƒW‚ğŠi”[
    message.push(text)
    
    return message
  end
  #--------------------------------------------------------------------------
  # œ ƒ`ƒFƒbƒNƒŠƒUƒ‹ƒg‚ÌƒeƒLƒXƒgì¬
  #--------------------------------------------------------------------------
  def self.make_condition_text(battler)
    
    # ƒ`ƒFƒbƒLƒ“ƒOŠm”F
    checking = battler.checking
    checking = 10 if battler.is_a?(Game_Actor) # ƒAƒNƒ^[‚Ìê‡“Áêˆ—
    
    #--------------------------------------------------------------------------
    # ¡¡ƒƒbƒZ[ƒWƒEƒBƒ“ƒhƒE‚P
    #--------------------------------------------------------------------------
    
    message = []
    
    # ›–¼‘O/í‘°•¶š—ñ‚ğì¬
    names_text = "#{battler.name}/#{$data_classes[battler.class_id].name}"
    
    # ›«Ši•¶š—ñ‚ğì¬
    personality = battler.personality
    personality = "HHHH" if checking < 1 # ƒ`ƒFƒbƒNŠ®—¹‚PˆÈã
    personality_text = "«ŠiF#{personality}"
    
    # ›ã“_•¶š—ñ‚ğì¬
    # ã“_Šm”F
    weak_list = [
    "ŒûU‚ß‚Éã‚¢",
    "èU‚ß‚Éã‚¢",
    "‹¹U‚ß‚Éã‚¢",
    "—‰AU‚ß‚Éã‚¢",
    "šn‹sU‚ß‚Éã‚¢",
    "ˆÙŒ`U‚ß‚Éã‚¢",
    "«Œğ‚Éã‚¢",
    "ãè‹s‚Éã‚¢",
    "Œû‚ª«Š´‘Ñ", "ˆúO",
    "‹¹‚ª«Š´‘Ñ", "ˆú“û", 
    "‚¨K‚ª«Š´‘Ñ", "ˆúK",
    "‹eÀ‚ª«Š´‘Ñ", "ˆú‰Ô",
    "‰AŠj‚ª«Š´‘Ñ", "ˆúŠj",
    "—‰A‚ª«Š´‘Ñ", "ˆúšâ",
    ]
    # •¶š—ñ‚ğƒŠƒZƒbƒg
    weak_text = ""
    # ƒŠƒXƒg‚ğì¬
    battler_weak_list = []
    for weak in weak_list
      # ã“_‚ğ‚Á‚Ä‚¢‚ê‚ÎƒŠƒXƒg‚É’Ç‰Á
      if battler.have_ability?(weak)
        battler_weak_list.push(weak)
      end
    end
    # ã“_—pƒeƒLƒXƒg‚ğì¬
    if battler_weak_list != []
      weak_text = SR_Util.weak_text_change(battler_weak_list)
    else
      weak_text = "–³‚µ"
    end
    weak_text = "HHHHH" if checking < 1 # ƒ`ƒFƒbƒNŠ®—¹‚PˆÈã
    weak_base = "ã“_F"
    # ƒXƒe[ƒgŠ®¬
    weak_text = weak_base + weak_text
    
    # ›ƒXƒe[ƒg•¶š—ñ‚ğì¬
    state_text = ""
    # ‚Ps‚É•\¦‚µ‚Ä‚¢‚éƒXƒe[ƒg”‚ğì¬
    state_set = 0
    for i in battler.states
      if $data_states[i].rating >= 1
        if state_set == 0
          state_text += $data_states[i].name
          state_set += 1
        else
          # ‚Ps‚ÉƒXƒe[ƒg‚ğ‚WŒÂ•`‰æ‚µ‚½‚ç‰üs
          if state_set == 20
            state_text += "\n"
            state_set = 0
          end
          new_text = state_text + "/" + $data_states[i].name
          state_set += 1
          state_text = new_text
        end
      end
    end
    # ƒXƒe[ƒg–¼‚Ì•¶š—ñ‚ª‹ó‚Ìê‡‚Í "ƒXƒe[ƒg–³‚µ" ‚É‚·‚é
    if state_text == ""
      state_text = "³í"
    end
    state_base = "ó‘ÔF"
    # ƒXƒe[ƒgŠ®¬
    state_text = state_base + state_text

    # ƒƒbƒZ[ƒWƒEƒBƒ“ƒhƒE‚P•\¦•ª‚ğì¬
    message.push("#{names_text}\n#{personality_text}\n#{weak_text}\n#{state_text}")

    #--------------------------------------------------------------------------
    # ¡¡ƒƒbƒZ[ƒWƒEƒBƒ“ƒhƒE‚Q
    #--------------------------------------------------------------------------
    
    # ƒ`ƒFƒbƒNŠ®—¹‚QˆÈã‚©‚ç•\¦iƒAƒNƒ^[‚Í•\¦‚µ‚È‚¢j
    if checking >= 2 and checking < 10
    
      # ›‘Ï‹v•¶š—ñ‚ğì¬
      ep = "#{battler.hp}/#{battler.maxhp}"
      vp = "#{battler.sp}/#{battler.maxsp}"
      # ƒ{ƒXí‚ÍŒ»‚d‚oA‚u‚o‚ğ‰B‚·B
      ep = "HH/#{battler.maxhp}" if $game_switches[91]
      vp = "HH/#{battler.maxsp}" if $game_switches[91]
      toughness_text = "‚d‚oF#{ep}\n‚u‚oF#{vp}"
    
      # ƒƒbƒZ[ƒWƒEƒBƒ“ƒhƒE‚Q•\¦•ª‚ğì¬
      message.push("#{toughness_text}")
    end
    #--------------------------------------------------------------------------
    
      # ƒhƒƒbƒvƒAƒCƒeƒ€
    
    #--------------------------------------------------------------------------
    
    #--------------------------------------------------------------------------
    # ¡¡ƒƒbƒZ[ƒWƒEƒBƒ“ƒhƒE“Áê
    #--------------------------------------------------------------------------
    
    # ƒ`ƒFƒbƒNŠ®—¹‚PˆÈã‚©‚ç•\¦iƒAƒNƒ^[‚Í•\¦‚µ‚È‚¢j
    if checking >= 1 and checking < 10
      
      # “Gí—pƒXƒe[ƒg‘Ï«‚Ì•\¦
      state_rank_text = ""
      state_rank_text1 = ""
      state_rank_text2 = ""
      for i in 1..battler.state_ranks.xsize
        if battler.state_ranks[i] == 6
          state_rank_text1 += "E" unless state_rank_text1 == ""
          state_rank_text1 += $data_states[i].name
        elsif battler.state_ranks[i] == 5
          state_rank_text2 += "E" unless state_rank_text2 == ""
          state_rank_text2 += $data_states[i].name
        end
      end
      state_rank_text += "\n–³ŒøF#{state_rank_text1}" if state_rank_text1 != ""
      state_rank_text += "\n’ïRF#{state_rank_text2}" if state_rank_text2 != ""
      
      # ƒƒbƒZ[ƒWƒEƒBƒ“ƒhƒE“Áê‚Ì•\¦•ª‚ğì¬
      unless state_rank_text == ""
        state_rank_text = "yŒÀ’è“Áê‘Ï«z" + "#{state_rank_text}"
        message.push("#{state_rank_text}")
      end
        
    end
    
    #--------------------------------------------------------------------------
    # ¡¡ƒƒbƒZ[ƒWƒEƒBƒ“ƒhƒE“Áê
    #--------------------------------------------------------------------------
    
    # ƒ`ƒFƒbƒNŠ®—¹‚PˆÈã‚©‚ç•\¦iƒAƒNƒ^[‚Í•\¦‚µ‚È‚¢j
    if checking >= 1 and checking < 10
      
      special_text = ""
      # –¡•ûíˆÈŠOŠ‚ÂA“Áê‚È‘f¿‚ğ‚Â‚à‚Ì‚ğ•\¦
      if not ($game_switches[85] or $game_switches[86])
        if battler.have_ability?("ŠmŒÅ‚½‚é©‘¸S")
          special_text += "yŠmŒÅ‚½‚é©‘¸Sz"
          special_text += "\n" + $data_ability.data[$data_ability.search(0,"ŠmŒÅ‚½‚é©‘¸S")].description
        elsif battler.have_ability?("“Å‚Ì‘Ì‰t")
          special_text += "y“Å‚Ì‘Ì‰tz"
          special_text += "\n" + $data_ability.data[$data_ability.search(0,"“Å‚Ì‘Ì‰t")].description
        elsif battler.have_ability?("–Ï·")
          special_text += "y–Ï·z"
          special_text += "\n" + $data_ability.data[$data_ability.search(0,"–Ï·")].description
        elsif battler.have_ability?("æ“Ç‚İ")
          special_text += "yæ“Ç‚İz"
          special_text += "\n" + $data_ability.data[$data_ability.search(0,"æ“Ç‚İ")].description
        end
      end
      
      # ƒƒbƒZ[ƒWƒEƒBƒ“ƒhƒE“Áê‚Ì•\¦•ª‚ğì¬
      unless special_text == ""
        message.push("#{special_text}")
      end
    end
    
    # ÅIo—Í
    return message
  end

#==============================================================================
  
  #--------------------------------------------------------------------------
  # œ ƒ`ƒFƒbƒNƒŠƒUƒ‹ƒg—pAã“_ƒeƒLƒXƒg»ì
  #--------------------------------------------------------------------------
  def self.weak_text_change(battler_weak_list)
    
    #--------------------------------------------------------------------------
    # ¡¡@››‚Éã‚¢Œn
    #--------------------------------------------------------------------------
    
    text_first = ""

    # ››U‚ß‚Éã‚¢
    #--------------------------------------------------------------------------
    text_1 = ""
    count = 0
    for weak in battler_weak_list
      text_1a = ""
      case weak
      when "ŒûU‚ß‚Éã‚¢"
        text_1a += "Œû"
      when "èU‚ß‚Éã‚¢"
        text_1a += "è"
      when "‹¹U‚ß‚Éã‚¢"
        text_1a += "‹¹"
      when "—‰AU‚ß‚Éã‚¢"
        text_1a += "—‰A"
      when "šn‹sU‚ß‚Éã‚¢"
        text_1a += "šn‹s"
      when "ˆÙŒ`U‚ß‚Éã‚¢"
        text_1a += "ˆÙŒ`"
      end
      # ã“_‚ª“ü‚Á‚Ä‚¢‚ê‚ÎƒeƒLƒXƒg‚É’Ç‰Á
      if text_1a != ""
        text_1 += "E" if count > 0 
        text_1 += text_1a
        count += 1 
      end
    end
    text_1 += "U‚ß" if text_1 != ""

    # ››‚Éã‚¢
    #--------------------------------------------------------------------------
    text_2 = ""
    count = 0
    for weak in battler_weak_list
      text_2a = ""
      case weak
      when "«Œğ‚Éã‚¢"
        text_2a += "«Œğ"
      when "ãè‹s‚Éã‚¢"
        text_2a += "ãè‹s"
      end
      # ã“_‚ª“ü‚Á‚Ä‚¢‚ê‚ÎƒeƒLƒXƒg‚É’Ç‰Á
      if text_2a != ""
        text_2 += "E" if count > 0 
        text_2 += text_2a
        count += 1 
      end
    end

    #--------------------------------------------------------------------------
    
    text_first = text_1 + "‚Éã‚¢" if text_1 != ""
    text_first = text_2 + "‚Éã‚¢" if text_2 != ""
    text_first = text_1 + "A" + text_2 + "‚Éã‚¢" if text_1 != "" and text_2 != ""

    #--------------------------------------------------------------------------
    # ¡¡@››‚ªã‚¢Œn
    #--------------------------------------------------------------------------
    
    text_second = ""

    # ››‚ª«Š´‘Ñ
    #--------------------------------------------------------------------------
    text_3 = ""
    count = 0
    for weak in battler_weak_list
      text_3a = ""
      case weak
      when "Œû‚ª«Š´‘Ñ"
        text_3a += "Œû"
      when "‹¹‚ª«Š´‘Ñ"
        text_3a += "‹¹"
      when "‚¨K‚ª«Š´‘Ñ"
        text_3a += "‚¨K"
      when "‹eÀ‚ª«Š´‘Ñ"
        text_3a += "‹eÀ"
      when "‰AŠj‚ª«Š´‘Ñ"
        text_3a += "‰AŠj"
      when "—‰A‚ª«Š´‘Ñ"
        text_3a += "—‰A"
      end
      # ã“_‚ª“ü‚Á‚Ä‚¢‚ê‚ÎƒeƒLƒXƒg‚É’Ç‰Á
      if text_3a != ""
        text_3 += "E" if count > 0 
        text_3 += text_3a
        count += 1 
      end
    end
    text_second = text_3 + "‚ªã‚¢" if text_3 != ""

    #--------------------------------------------------------------------------
    text_third = ""

    # ˆú›
    #--------------------------------------------------------------------------
    text_4 = ""
    count = 0
    for weak in battler_weak_list
      text_4a = ""
      case weak
      when "ˆúO"
        text_4a += "Œû"
      when "ˆú“û" 
        text_4a += "‹¹"
      when "ˆúK"
        text_4a += "‚¨K"
      when "ˆú‰Ô"
        text_4a += "‹eÀ"
      when "ˆúŠj"
        text_4a += "‰AŠj"
      when "ˆúšâ"
        text_4a += "—‰A"
      end
      # ã“_‚ª“ü‚Á‚Ä‚¢‚ê‚ÎƒeƒLƒXƒg‚É’Ç‰Á
      if text_4a != ""
        text_4 += "E" if count > 0 
        text_4 += text_4a
        count += 1 
      end
    end
    text_third = text_4 + "‚ª”ñí‚Éã‚¢" if text_4 != ""
        
    #--------------------------------------------------------------------------
    # ¡¡@ƒeƒLƒXƒgŠm’è
    #--------------------------------------------------------------------------
    
    text = ""
    count = 0
    # ››U‚ß‚Éã‚¢
    if text_first != ""
      text += "@" if count > 0
      text += text_first
      count += 1
    end
    # ››‚ª«Š´‘Ñ
    if text_second != ""
      text += "@" if count > 0
      text += text_second 
      count += 1
    end
    # ˆú›
    if text_third != ""
      text += "@" if count > 0
      text += text_third
      count += 1
    end
    return text
    
  end
  
end