#==============================================================================
# ¡ Scene_Battle (•ªŠ„’è‹` 6)
#------------------------------------------------------------------------------
# @ƒoƒgƒ‹‰æ–Ê‚Ìˆ—‚ğs‚¤ƒNƒ‰ƒX‚Å‚·B
#==============================================================================

class Scene_Battle
  #--------------------------------------------------------------------------
  # š “Áêƒz[ƒ‹ƒh•t—^‚Ì€”õ
  #--------------------------------------------------------------------------
  def special_hold_start
    $game_switches[81] = true
    @add_hold_flag = true
    hold_record
  end
  #--------------------------------------------------------------------------
  # š “Áêƒz[ƒ‹ƒh•t—^‚ÌI—¹
  #--------------------------------------------------------------------------
  def special_hold_end
    $game_switches[81] = false
    @add_hold_flag = false
    hold_pops_order
  end
  #--------------------------------------------------------------------------
  # š ƒz[ƒ‹ƒh‹““®ˆ—
  #--------------------------------------------------------------------------
  def hold_effect(skill, active, target)
    
    #‰æ–ÊƒVƒFƒCƒN
    # ƒsƒXƒgƒ“Œn
    if @hold_shake == true
      #ƒtƒ‰ƒbƒVƒ…{ƒAƒjƒ[ƒVƒ‡ƒ“
      if target.is_a?(Game_Enemy)
        if skill.name == "ƒŠƒŠ[ƒX" or skill.name == "ƒCƒ“ƒ^ƒ‰ƒvƒg"
          active.white_flash = true
          target.animation_id = 129
          target.animation_hit = true
        else
          active.white_flash = true
          target.animation_id = 105
          target.animation_hit = true
        end
      elsif target.is_a?(Game_Actor)
        target.white_flash = true
        active.animation_id = 105
        active.animation_hit = true
      end
      if skill.element_set.include?(37)
        # ‰æ–Ê‚ÌcƒVƒFƒCƒN
        $game_screen.start_flash(Color.new(255,210,225,220), 8)
        $game_screen.start_shake2(7, 15, 15)
      # ƒOƒ‰ƒCƒ“ƒhŒn
      elsif skill.element_set.include?(38)
        # ‰æ–Ê‚Ì‰¡ƒVƒFƒCƒN
        $game_screen.start_flash(Color.new(255,210,225,220), 8)
        $game_screen.start_shake(7, 15, 15)
      end
      #ƒz[ƒ‹ƒh¬Œ÷‚É‚ÍƒeƒLƒXƒg‚ğo‚µAƒ^[ƒQƒbƒg‚ğs“®Ï‚İ‚É‚·‚é
      unless (skill.name == "ƒŠƒŠ[ƒX" or skill.name == "ƒCƒ“ƒ^ƒ‰ƒvƒg")
        @action_battlers.delete(target)
      end
      make_hold_text(skill, active, target)
    elsif @hold_shake == false
      if skill.element_set.include?(37)
        # ‰æ–Ê‚ÌcƒVƒFƒCƒN
#        $game_screen.start_flash(Color.new(255,210,225,100), 8)
        $game_screen.start_shake2(2, 15, 10)
      # ƒOƒ‰ƒCƒ“ƒhŒn
      elsif skill.element_set.include?(38)
        # ‰æ–Ê‚Ì‰¡ƒVƒFƒCƒN
#        $game_screen.start_flash(Color.new(255,210,225,100), 8)
        $game_screen.start_shake(2, 15, 10)
      end
    end
    #-------------------------------------------------------------------------
    # ¥—ŒğAƒz[ƒ‹ƒh•t—^‚ÉƒCƒjƒVƒAƒ`ƒu‚ğ•Ï“®‚³‚¹‚é
    #-------------------------------------------------------------------------
    if $game_switches[81] and @add_hold_flag
      # ‚·‚Å‚É‘Šè‚ª‚P‚ÂˆÈãƒz[ƒ‹ƒh‚µ‚Ä‚¢‚éê‡A‘ÎÛü‚è‚Ìƒz[ƒ‹ƒh‚ğ‚·‚×‚Ä”½“]‚³‚¹‚é
      if target.hold.hold_output.size > 0 and target.hold.initiative? and
       not ["ƒŠƒŠ[ƒX","ƒCƒ“ƒ^ƒ‰ƒvƒg","ƒXƒgƒ‰ƒOƒ‹"].include?(skill.name)
        # ‰º‚Ì‹Lq‚ÍŠÈ—ª‰»‚µ‚½ƒƒ\ƒbƒh‚É‚µ‚Ü‚µ‚½
        hold_dancing_change(target)
=begin
       #‚Ü‚¸‘Šè‚ÌƒCƒjƒVƒAƒ`ƒu‚ğ‘S‚ÄŠO‚µA‘ÎÛ‚ğƒz[ƒ‹ƒh‚µ‚Ä‚¢‚éƒoƒgƒ‰[‘S‚Ä‚É
        #—L—˜‚Q‚ğ•t—^‚·‚é(©gŠÜ‚Ş)
        #ƒp[ƒc‚²‚Æ‚ÉŒÂ•Ê‘Î‰‚·‚é‚±‚ÆB
        #œƒyƒjƒX•”•ª
        if target.hold.penis.battler != nil
          target.hold.penis.initiative = 0
          hold_target = target.hold.penis.battler
          case target.hold.penis.type
          when "Š‘}“ü"
            hold_target.hold.vagina.initiative = 2
          when "Œû‘}“ü"
            hold_target.hold.mouth.set(nil, nil, nil, nil)
            target.hold.penis.set(nil, nil, nil, nil)
          when "K‘}“ü"
            hold_target.hold.anal.set(nil, nil, nil, nil)
            target.hold.penis.set(nil, nil, nil, nil)
          when "Gè‹zˆø"
            hold_target.hold.tentacle.set(nil, nil, nil, nil)
            target.hold.penis.set(nil, nil, nil, nil)
          end
        end
        #œŒû•”•ª
        if target.hold.mouth.battler != nil
          target.hold.mouth.initiative = 0
          hold_target = target.hold.mouth.battler
          case target.hold.mouth.type
          when "Œû‘}“ü"
            hold_target.hold.penis.set(nil, nil, nil, nil)
            target.hold.mouth.set(nil, nil, nil, nil)
          when "ƒfƒBƒ‹ƒhŒû‘}“ü"
            hold_target.hold.dildo.set(nil, nil, nil, nil)
            target.hold.mouth.set(nil, nil, nil, nil)
          when "ƒNƒ“ƒj"
            #S‘©ƒ^ƒCƒv‚ÍƒCƒjƒVƒAƒ`ƒu‚ªØ‚ê‚½’iŠK‚ÅŠO‚ê‚é
            hold_target.hold.vagina.set(nil, nil, nil, nil)
            target.hold.mouth.set(nil, nil, nil, nil)
          when "ƒLƒbƒX"
            #S‘©ƒ^ƒCƒv‚ÍƒCƒjƒVƒAƒ`ƒu‚ªØ‚ê‚½’iŠK‚ÅŠO‚ê‚é
            hold_target.hold.mouth.set(nil, nil, nil, nil)
            target.hold.mouth.set(nil, nil, nil, nil)
          end
        end
        #œƒAƒ\ƒR•”•ª
        if target.hold.vagina.battler != nil
          target.hold.vagina.initiative = 0
          hold_target = target.hold.vagina.battler
          case target.hold.vagina.type
          when "Š‘}“ü"
            hold_target.hold.penis.initiative = 2
          when "ŠL‡‚í‚¹"
            hold_target.hold.vagina.initiative = 2
          when "ƒNƒ“ƒj"
            #S‘©ƒ^ƒCƒv‚ÍƒCƒjƒVƒAƒ`ƒu‚ªØ‚ê‚½’iŠK‚ÅŠO‚ê‚é
            hold_target.hold.mouth.set(nil, nil, nil, nil)
            target.hold.vagina.set(nil, nil, nil, nil)
          when "ƒfƒBƒ‹ƒhŠ‘}“ü"
            hold_target.hold.dildo.set(nil, nil, nil, nil)
            target.hold.vagina.set(nil, nil, nil, nil)
          when "Šç–Ê‹Ræ"
            #S‘©ƒ^ƒCƒv‚ÍƒCƒjƒVƒAƒ`ƒu‚ªØ‚ê‚½’iŠK‚ÅŠO‚ê‚é
            hold_target.hold.mouth.set(nil, nil, nil, nil)
            target.hold.vagina.set(nil, nil, nil, nil)
          when "GèƒNƒ“ƒj"
            #S‘©ƒ^ƒCƒv‚ÍƒCƒjƒVƒAƒ`ƒu‚ªØ‚ê‚½’iŠK‚ÅŠO‚ê‚é
            hold_target.hold.tentacle.set(nil, nil, nil, nil)
            target.hold.vagina.set(nil, nil, nil, nil)
          end
        end
        #œƒAƒiƒ‹•”•ª
        if target.hold.anal.battler != nil
          target.hold.anal.initiative = 0
          hold_target = target.hold.anal.battler
          case target.hold.anal.type
          when "K‘}“ü"
            hold_target.hold.penis.initiative = 2
          when "ƒfƒBƒ‹ƒhK‘}“ü"
            hold_target.hold.dildo.set(nil, nil, nil, nil)
            target.hold.anal.set(nil, nil, nil, nil)
          when "K‹Ræ"
            hold_target.hold.mouth.set(nil, nil, nil, nil)
            target.hold.anal.set(nil, nil, nil, nil)
          end
        end
        #œã”¼g•”•ª
        if target.hold.tops.battler != nil
          target.hold.tops.initiative = 0
          #ã”¼g‚ÍƒCƒjƒVƒAƒ`ƒu‚ªØ‚ê‚½’iŠK‚ÅŠO‚ê‚é
          hold_target = target.hold.tops.battler
          case target.hold.tops.type
          when "ƒpƒCƒYƒŠ"
            #ƒpƒCƒYƒŠ‚ÍƒCƒjƒVƒAƒ`ƒu‚ªØ‚ê‚½’iŠK‚ÅŠO‚ê‚é
            hold_target.hold.penis.set(nil, nil, nil, nil)
            target.hold.tops.set(nil, nil, nil, nil)
          when "‚Ï‚Ó‚Ï‚Ó"
            #‚Ï‚Ó‚Ï‚Ó‚ÍƒCƒjƒVƒAƒ`ƒu‚ªØ‚ê‚½’iŠK‚ÅŠO‚ê‚é
            hold_target.hold.mouth.set(nil, nil, nil, nil)
            target.hold.tops.set(nil, nil, nil, nil)
          when "GèS‘©","’ÓS‘©"
            #S‘©ƒ^ƒCƒv‚ÍƒCƒjƒVƒAƒ`ƒu‚ªØ‚ê‚½’iŠK‚ÅŠO‚ê‚é
            hold_target.hold.tentacle.set(nil, nil, nil, nil)
            target.hold.tops.set(nil, nil, nil, nil)
          else
            hold_target.hold.tops.set(nil, nil, nil, nil)
            target.hold.tops.set(nil, nil, nil, nil)
          end
        end
        #œK”ö•”•ª
        if target.hold.tail.battler != nil
          target.hold.tail.initiative = 0
          #K”ö‚ÍƒCƒjƒVƒAƒ`ƒu‚ªØ‚ê‚½’iŠK‚ÅŠO‚ê‚é
          hold_target = target.hold.tail.battler
          case target.hold.tail.type
          when "Š‘}“ü"
            hold_target.hold.vagina.set(nil, nil, nil, nil)
          when "Œû‘}“ü"
            hold_target.hold.mouth.set(nil, nil, nil, nil)
          when "K‘}“ü"
            hold_target.hold.anal.set(nil, nil, nil, nil)
          end
          target.hold.tail.set(nil, nil, nil, nil)
        end
        #œƒfƒBƒ‹ƒh•”•ª
        if target.hold.dildo.battler != nil
          target.hold.dildo.initiative = 0
          #K”ö‚ÍƒCƒjƒVƒAƒ`ƒu‚ªØ‚ê‚½’iŠK‚ÅŠO‚ê‚é
          hold_target = target.hold.dildo.battler
          case target.hold.dildo.type
          when "ƒfƒBƒ‹ƒhŠ‘}“ü"
            hold_target.hold.vagina.set(nil, nil, nil, nil)
          when "ƒfƒBƒ‹ƒhŒû‘}“ü"
            hold_target.hold.mouth.set(nil, nil, nil, nil)
          when "ƒfƒBƒ‹ƒhK‘}“ü"
            hold_target.hold.anal.set(nil, nil, nil, nil)
          end
          target.hold.dildo.set(nil, nil, nil, nil)
        end
        #œGè•”•ª
        if target.hold.tentacle.battler != nil
          target.hold.tentacle.initiative = 0
          #K”ö‚ÍƒCƒjƒVƒAƒ`ƒu‚ªØ‚ê‚½’iŠK‚ÅŠO‚ê‚é
          hold_target = target.hold.tentacle.battler
          case target.hold.tentacle.type
          when "Gè‹zˆø"
            hold_target.hold.penis.set(nil, nil, nil, nil)
          when "GèŠ‘}“ü","GèƒNƒ“ƒj"
            hold_target.hold.vagina.set(nil, nil, nil, nil)
          when "GèŒû‘}“ü"
            hold_target.hold.mouth.set(nil, nil, nil, nil)
          when "GèK‘}“ü"
            hold_target.hold.anal.set(nil, nil, nil, nil)
          when "GèS‘©","’ÓS‘©","GèŠJ‹r"
            hold_target.hold.tops.set(nil, nil, nil, nil)
          end
          target.hold.tentacle.set(nil, nil, nil, nil)
        end
=end
      end

      
      # ‚»‚ÌŒãAƒz[ƒ‹ƒh•t—^ˆ—‚ğs‚¤
      add_hold(skill, active, target)
      # ƒOƒ‰ƒtƒBƒbƒNƒ`ƒFƒ“ƒWƒtƒ‰ƒO‚ğ—§‚Ä‚é
      active.graphic_change = true
      target.graphic_change = true
    end
  end
  #--------------------------------------------------------------------------
  # š ƒz[ƒ‹ƒhŠ®—¹ƒeƒLƒXƒgˆ—
  #--------------------------------------------------------------------------
  def make_hold_text(skill, active, target)
    if active.is_a?(Game_Actor)
      #ƒz[ƒ‹ƒh–¼‚©‚çƒeƒLƒXƒg‚ğ®Œ`
      
      brk = "\n" if SR_Util.names_over?(active.name,target.name)
      case skill.name
      when "ƒCƒ“ƒT[ƒg"
        text = "#{active.name} inserted into #{target.name}!"
      when "ƒAƒNƒZƒvƒg"
        text = "#{active.name} inserted #{target.name}'s penis into her pussy!"
      when "ƒI[ƒ‰ƒ‹ƒCƒ“ƒT[ƒg"
        text = "#{active.name} inserted into#{brk} #{target.name}'s ‚outh!"
      when "ƒI[ƒ‰ƒ‹ƒAƒNƒZƒvƒg"
        text = "#{active.name} sucked#{brk} #{target.name}'s penis into her ‚outh!"
      when "ƒoƒbƒNƒCƒ“ƒT[ƒg"
        text = "#{active.name} inserted into#{brk} up #{target.name}'s ass!"
      when "ƒoƒbƒNƒAƒNƒZƒvƒg"
        text = "#{active.name} inserted #{target.name}'s penis up her ass!"
      when "ƒGƒLƒTƒCƒgƒrƒ…["
        text = "#{active.name} is straddling #{brk}#{target.name}'s face!"
      when "ƒhƒƒEƒlƒNƒ^["
        if active.name == $game_actors[101]
        text = "#{active.name} drinks in #{brk}#{target.name}'s pussy ‚—ith his ‚outh!"
        else
        text = "#{active.name} drinks in #{brk}#{target.name}'s pussy\n ‚—ith her ‚outh!"
        end
      when "ƒGƒ“ƒuƒŒƒCƒX"
        text = "#{active.name} clings tightly to #{brk}#{target.name}!"
      when "ƒVƒFƒ‹ƒ}ƒbƒ`"
        text = "#{active.name} legs intertwined ‚—ith #{brk}#{target.name}'s!"
      when "ƒfƒBƒ‹ƒhƒCƒ“ƒT[ƒg"
        text = "#{active.name} inserted into #{brk}#{target.name}!"
      when "ƒfƒBƒ‹ƒhƒCƒ“ƒ}ƒEƒX"
        text = "#{active.name} inserted into #{brk}#{target.name}'s ‚outh!"
      when "ƒfƒBƒ‹ƒhƒCƒ“ƒoƒbƒN"
        text = "#{active.name} inserted up #{brk}#{target.name}'s ass!"
      when "ƒAƒCƒ”ƒBƒNƒ[ƒY","ƒfƒ‚ƒ“ƒYƒNƒ[ƒY"
        text = "#{active.name}‚Ì‘€‚éGè‚ÍA\n#{target.name}‚Ìg‘Ì‚ğ—‚ß‚Æ‚Á‚½I"
      when "ƒfƒ‚ƒ“ƒYƒAƒuƒ\[ƒu"
        text = "#{active.name}‚Ì‘€‚éGè‚ªA\n#{target.name}‚ÌƒyƒjƒX‚É‹z‚¢•t‚¢‚½I"
      when "ƒfƒ‚ƒ“ƒYƒhƒƒE"
        text = "#{active.name}‚Ì‘€‚éGè‚ªA\n#{target.name}‚ÌƒAƒ\ƒR‚É‹z‚¢•t‚¢‚½I"
      when "ƒŠƒŠ[ƒX"
        text = "#{active.name} broke free fro‚ #{target.name}!"
      when "ƒCƒ“ƒ^ƒ‰ƒvƒg"
        if active == $game_actors[101]
          for i in $game_party.actors
            if i != $game_actors[101]
              partner = i
            end
          end
        else
          partner = $game_actors[101]
        end
        text = "#{active.name} separated #{partner.name} fro‚ #{target.name}!"
      end
    elsif active.is_a?(Game_Enemy)
      #ƒz[ƒ‹ƒh–¼‚©‚çƒeƒLƒXƒg‚ğ®Œ`
      case skill.name
      when "ƒCƒ“ƒT[ƒg"
        if $game_switches[89] == true #ƒLƒƒƒ“ƒZƒ‹ƒL[‚Åó‚¯“ü‚ê‚½ê‡
          text = "#{target.name} spreads her legs\n to receive #{active.name}'s insertion!"
        else
          text = "#{target.name} ‚—as violated by #{active.name}!"
        end
      when "ƒAƒNƒZƒvƒg"
        if $game_switches[89] == true #ƒLƒƒƒ“ƒZƒ‹ƒL[‚Åó‚¯“ü‚ê‚½ê‡
          text = "#{target.name} lies on his back,\n ready to be inserted by #{active.name}!"
        else
          text = "#{target.name} ‚—as violated by #{active.name}!"
        end
      when "ƒI[ƒ‰ƒ‹ƒCƒ“ƒT[ƒg"
        if $game_switches[89] == true #ƒLƒƒƒ“ƒZƒ‹ƒL[‚Åó‚¯“ü‚ê‚½ê‡
          text = "#{target.name} opens her mouth\n to receive #{active.name}'s penis!"
        else
          text = "#{active.name}'s penis has been\n scre‚—ed into #{target.name}'s ‚outh!"
        end
      when "ƒI[ƒ‰ƒ‹ƒAƒNƒZƒvƒg"
        if $game_switches[89] == true #ƒLƒƒƒ“ƒZƒ‹ƒL[‚Åó‚¯“ü‚ê‚½ê‡
          text = "#{target.name} thrusts forward, offering\n his penis to #{active.name}'s lewd ‚outh!"
        else
          text = "#{target.name}'s penis ‚—as stuffed\n into #{active.name}'s ‚outh!"
        end
      when "ƒoƒbƒNƒCƒ“ƒT[ƒg"
        if $game_switches[89] == true #ƒLƒƒƒ“ƒZƒ‹ƒL[‚Åó‚¯“ü‚ê‚½ê‡
          text = "#{target.name} opens up her ass\n to receive #{active.name}'s penis!"
        else
          text = "#{target.name}'s sphincter has been pierced by\n #{active.name}'s penis!"
        end
      when "ƒoƒbƒNƒAƒNƒZƒvƒg"
        if $game_switches[89] == true #ƒLƒƒƒ“ƒZƒ‹ƒL[‚Åó‚¯“ü‚ê‚½ê‡
          text = "#{target.name} looks upward, ready to\n be inserted into #{active.name}'s ass!"
        else
          text = "#{target.name}'s penis has been s‚—allo‚—ed by\n #{active.name}'s ass!"
        end
      when "ƒGƒLƒTƒCƒgƒrƒ…["
        if $game_switches[89] == true #ƒLƒƒƒ“ƒZƒ‹ƒL[‚Åó‚¯“ü‚ê‚½ê‡
          text = "Lying down, #{target.name} willingly accepts\n to be sat on by #{active.name}!"
        else
          text = "#{target.name}'s face is being s‚othered by\n #{active.name}'s pussy!"
        end
      when "ƒCƒ“ƒ‚ƒ‰ƒ‹ƒrƒ…["
        if $game_switches[89] == true #ƒLƒƒƒ“ƒZƒ‹ƒL[‚Åó‚¯“ü‚ê‚½ê‡
          text = "Lying down, #{target.name} willingly accepts\n to be sat on by #{active.name}!"
        else
          text = "#{target.name}'s face is being s‚othered by\n #{active.name}'s ass!"
        end
      when "ƒGƒ“ƒuƒŒƒCƒX"
        if $game_switches[89] == true #ƒLƒƒƒ“ƒZƒ‹ƒL[‚Åó‚¯“ü‚ê‚½ê‡
          if active.name == $game_actors[101]
          text = "#{target.name} relaxes and entrusts his body\n to #{active.name}!"
          else
          text = "#{target.name} relaxes and entrusts her\n body to #{active.name}!"
          end
        else
          text = "#{active.name} clung tightly to #{target.name}!"
        end
      when "ƒGƒLƒVƒrƒWƒ‡ƒ“"
        if $game_switches[89] == true #ƒLƒƒƒ“ƒZƒ‹ƒL[‚Åó‚¯“ü‚ê‚½ê‡
          text = "#{target.name} spreads her legs,\n entrusting herself to #{active.name}!"
        else
          text = "#{active.name} clings on to #{target.name},\n opening up her crotch for all to see!"
        end
      when "ƒyƒŠƒXƒR[ƒv"
        if $game_switches[89] == true #ƒLƒƒƒ“ƒZƒ‹ƒL[‚Åó‚¯“ü‚ê‚½ê‡
          text = "#{target.name} thrusts out his pelvis\n and buries his penis in #{active.name}'s breasts!"
        else
          text = "#{target.name}'s penis has been\n s‚—allo‚—ed by #{active.name}'s cleavage!!"
        end
      when "ƒVƒFƒ‹ƒ}ƒbƒ`"
        if $game_switches[89] == true #ƒLƒƒƒ“ƒZƒ‹ƒL[‚Åó‚¯“ü‚ê‚½ê‡
          text = "#{target.name} opens her legs to accept #{active.name}!"
        else
          text = "#{target.name} legs have been entangled ‚—ith #{active.name}!"
        end
      when "ƒhƒƒEƒlƒNƒ^["
        if $game_switches[89] == true #ƒLƒƒƒ“ƒZƒ‹ƒL[‚Åó‚¯“ü‚ê‚½ê‡
          text = "#{target.name} opens up her slit ‚—ith her\n finger, happily accepting #{active.name}'s ‚outh!"
        else
          text = "#{target.name}'s pussy is being sucked on\n by #{active.name}'s ‚outh!"
        end
      when "ƒCƒ“ƒT[ƒgƒeƒCƒ‹"
        text = "#{active.name} sticks her tail inside #{target.name}'s pussy!"
      when "ƒ}ƒEƒXƒCƒ“ƒeƒCƒ‹"
        text = "#{active.name} sticks her tail inside #{target.name}'s ‚outh!"
      when "ƒoƒbƒNƒCƒ“ƒeƒCƒ‹"
        text = "#{active.name} sticks her tail up #{target.name}'s ass!"
      when "ƒfƒBƒ‹ƒhƒCƒ“ƒT[ƒg"
        if $game_switches[89] == true #ƒLƒƒƒ“ƒZƒ‹ƒL[‚Åó‚¯“ü‚ê‚½ê‡
          text = "#{target.name} spreads her legs to receive #{active.name}!"
        else
          text = "#{active.name} pierces #{target.name}'s pussy!"
        end
      when "ƒfƒBƒ‹ƒhƒCƒ“ƒ}ƒEƒX"
        if $game_switches[89] == true #ƒLƒƒƒ“ƒZƒ‹ƒL[‚Åó‚¯“ü‚ê‚½ê‡
          text = "#{target.name}‚Í©‚çŒû‚ğŠJ‚¯A\n#{active.name}‚ÌƒfƒBƒ‹ƒh‚ğ™ø‚¦‚ñ‚¾I"
        else
          text = "#{target.name}‚ÌŒû‚ÉA\n#{active.name}‚ÌƒfƒBƒ‹ƒh‚ª‚Ë‚¶‚Ü‚ê‚½I"
        end
      when "ƒfƒBƒ‹ƒhƒCƒ“ƒoƒbƒN"
        if $game_switches[89] == true #ƒLƒƒƒ“ƒZƒ‹ƒL[‚Åó‚¯“ü‚ê‚½ê‡
          text = "#{target.name}‚Í©‚ç‚¨K‚ğã‚°A\n#{active.name}‚ÌƒfƒBƒ‹ƒh‚Ì‘}“ü‚ğŒ}‚¦“ü‚ê‚½I"
        else
          text = "#{target.name}‚Ì‹eÀ‚ÉA\n#{active.name}‚ÌƒfƒBƒ‹ƒh‚ª“Ë‚«“ü‚ê‚ç‚ê‚½I"
        end
      when "ƒCƒ“ƒT[ƒgƒeƒ“ƒ^ƒNƒ‹"
        text = "#{target.name}‚ÌƒAƒ\ƒR‚ÉA\n#{active.name}‚Ì‘€‚éGè‚ªN“ü‚µ‚Ä‚«‚½I"
      when "ƒ}ƒEƒXƒCƒ“ƒeƒ“ƒ^ƒNƒ‹"
        text = "#{target.name}‚ÌŒû‚ÉA\n#{active.name}‚Ì‘€‚éGè‚ªN“ü‚µ‚Ä‚«‚½I"
      when "ƒoƒbƒNƒCƒ“ƒeƒ“ƒ^ƒNƒ‹"
        text = "#{target.name}‚Ì‹eÀ‚ÉA\n#{active.name}‚Ì‘€‚éGè‚ªN“ü‚µ‚Ä‚«‚½I"
      when "ƒAƒCƒ”ƒBƒNƒ[ƒY","ƒfƒ‚ƒ“ƒYƒNƒ[ƒY"
        if $game_switches[89] == true #ƒLƒƒƒ“ƒZƒ‹ƒL[‚Åó‚¯“ü‚ê‚½ê‡
          text = "#{target.name}‚ÍA\n#{active.name}‚Ì‘€‚éGè‚Ég‚ğ·‚µo‚µ‚½II"
        else
          text = "#{target.name}‚Ìg‘Ì‚ÍA\n#{active.name}‚Ì‘€‚éGè‚É—‚ßæ‚ç‚ê‚Ä‚µ‚Ü‚Á‚½II"
        end
      when "ƒfƒ‚ƒ“ƒYƒAƒuƒ\[ƒu"
        if $game_switches[89] == true #ƒLƒƒƒ“ƒZƒ‹ƒL[‚Åó‚¯“ü‚ê‚½ê‡
          text = "#{target.name}‚Í©‚ç‹ÂŒü‚¯‚É‚È‚èA\n#{active.name}‚Ì‘€‚éGè‚ÌŒû‚ğó‚¯“ü‚ê‚½II"
        else
          text = "#{target.name}‚ÌƒyƒjƒX‚ÍA\n#{active.name}‚Ì‘€‚éGè‚É™ø‚¦‚ç‚ê‚Ä‚µ‚Ü‚Á‚½II"
        end
      when "ƒfƒ‚ƒ“ƒYƒhƒƒE"
        if $game_switches[89] == true #ƒLƒƒƒ“ƒZƒ‹ƒL[‚Åó‚¯“ü‚ê‚½ê‡
          text = "#{target.name}‚Í©‚çw‚ÅƒAƒ\ƒR‚ğL‚°AA\n#{active.name}‚Ì‘€‚éGè‚ÌŒû‚ğó‚¯“ü‚ê‚½II"
        else
          text = "#{target.name}‚ÌƒAƒ\ƒR‚ÉA\n#{active.name}‚Ì‘€‚éGè‚ª’£‚è•t‚¢‚Ä‚«‚½II"
        end
      when "ƒCƒ“ƒTƒ‹ƒgƒcƒŠ["
        text = "#{active.name}‚Ì‘€‚éGè‚ª‰ö‚µ‚­å¿‚­‚ÆA\n#{target.name}‚ÍŒÒ‚ğ‘å‚«‚­L‚°‚½p¨‚É‚³‚ê‚Ä‚µ‚Ü‚Á‚½I"
      end
    end
    $game_temp.battle_log_text += text + "\\"
  end
  #--------------------------------------------------------------------------
  # š ƒz[ƒ‹ƒhI—¹ƒeƒLƒXƒgˆ—
  #--------------------------------------------------------------------------
  def make_unhold_text(target)
    #ƒeƒLƒXƒg‚Í‚P•¶š‚É‚Â‚«ƒTƒCƒY‚R
    #‚Ps•\¦ŒÀŠE‚Í‚Q‚U•¶š‚È‚Ì‚ÅA–¼‘O‚Ì‡Œv‚ª‚P‚Q•¶š(ƒTƒCƒY36)‚ğ‰z‚¦‚éê‡‚Í‰üs‚ğ“ü‚ê‚é
    text = []
    #œ‚Ü‚¸ƒ^[ƒQƒbƒg‚Ìâ’¸•`Ê‚ğ“ü‚ê‚é
    if target == $game_actors[101]
      text.push("#{target.name}‚ÍŒƒ‚µ‚­Á–Õ‚µ‚Ä‚¢‚éccI")
      text.push("#{target.name}‚Í‹É“x‚ÉÁ–Õ‚µ‚Ä‚¢‚éccI") if target.ecstasy_count.size > 1 #‚·‚Å‚É‚Q“xˆÈãâ’¸‚µ‚Ä‚¢‚éê‡
    else
      text.push("#{target.name}‚Í‰õŠ´‚Éšb‚¢‚Å‚¢‚éccI")
    end
    #œ‚»‚ÌŒãAƒz[ƒ‹ƒh‘ÎÛ‚Ì•`Ê‚ğ“ü‚ê‚é
    if target.hold.penis.battler != nil
      holder = target.hold.penis.battler
      case target.hold.penis.type
      when "Š‘}“ü"
        text.push("#{holder.name} releases his penis fro‚ her vagina!")
      when "Œû‘}“ü"
        text.push("#{holder.name}'s ‚outh releases his penis!")
      when "K‘}“ü"
        text.push("#{holder.name} released his penis fro‚ her ass!")
      when "ƒpƒCƒYƒŠ"
        text.push("#{holder.name} released his penis fro‚ her cleavage!")
      end
    end
    if target.hold.vagina.battler != nil
      holder = target.hold.vagina.battler
      case target.hold.vagina.type
      when "Š‘}“ü"
        item = target.hold.vagina.parts
        text.push("#{holder.name} pulled his penis out of her #{item}!")
      when "Šç–Ê‹Ræ","ƒNƒ“ƒj"
        text.push("#{holder.name} pulls a‚—ay fro‚ #{target.name}'s crotch!")
      when "ŠL‡‚í‚¹"
        text.push("#{holder.name} unt‚—ines her legs!")
      end
    end
    if target.hold.mouth.battler != nil
      holder = target.hold.mouth.battler
      case target.hold.mouth.type
      when "Œû‘}“ü"
        item = target.hold.mouth.parts
        text.push("#{holder.name} pulled his penis out of her #{item}!")
      when "Šç–Ê‹Ræ","K‹Ræ","‚Ï‚Ó‚Ï‚Ó"
        text.push("#{holder.name} releases #{target.name}!")
      when "ƒNƒ“ƒj","ƒLƒbƒX"
        text.push("#{holder.name} parts fro‚ #{target.name}'s lips!")
      end
    end
    if target.hold.anal.battler != nil
      holder = target.hold.anal.battler
      case target.hold.anal.type
      when "K‘}“ü"
        text.push("#{holder.name} pulled his penis out of her #{item}!")
      when "K‹Ræ"
        text.push("#{holder.name} releases #{target.name}!")
      end
    end
    if target.hold.tops.battler != nil
      holder = target.hold.tops.battler
      case target.hold.tops.type
      when "S‘©","ŠJ‹r","‚Ï‚Ó‚Ï‚Ó"
        text.push("#{holder.name} lets go of #{target.name}!")
      end
    end
    if target.hold.tail.battler != nil
      holder = target.hold.tail.battler
      case target.hold.tail.type
      when "Š‘}“ü","Œû‘}“ü","K‘}“ü"
        text.push("#{target.name} was released fro‚ her tail's grasp!")
      end
    end
    if target.hold.tentacle.battler != nil
      holder = target.hold.tentacle.battler
      case target.hold.tentacle.type
      when "Š‘}“ü","Œû‘}“ü","K‘}“ü"
        text.push("#{holder.name} releases her tentacle!")
      end
    end
    if target.hold.dildo.battler != nil
      holder = target.hold.dildo.battler
      brk = "A\n" if SR_Util.names_over?(holder.name,target.name)
      case target.hold.dildo.type
      when "Š‘}“ü","Œû‘}“ü","K‘}“ü"
        text.push("#{holder.name} releases her dildo!")
      end
    end
    a = ""
    a += text[0] if text[0] != nil
    a += "\n\" if text[1] != nil
    a += text[1] if text[1] != nil
    a += "\n\" if text[2] != nil
    a += text[2] if text[2] != nil
    a += "\n\" if text[3] != nil
    a += text[3] if text[3] != nil
    $game_temp.battle_log_text += a + "\\"
  end
  #--------------------------------------------------------------------------
  # œ —Œğ‚Ìƒz[ƒ‹ƒh•t—^‚É‚æ‚éƒCƒjƒVƒAƒ`ƒu•Ï“®
  # owner : Œ¸­‚·‚éƒoƒgƒ‰[
  #--------------------------------------------------------------------------
  def hold_dancing_change(owner)
    # ƒp[ƒc–¼‚ğæ“¾‚·‚é
    owner_parts = owner.hold.parts_names
    # Šeƒp[ƒc‚²‚Æ‚ÉŠm”F
    for o_parts_one in owner_parts
      # ƒp[ƒcî•ñ‚ğ•Ï”‚É“ü‚ê‚é
      checking_parts = eval("owner.hold.#{o_parts_one}")
      # ‚±‚Ìƒp[ƒc‚ªè—L’†‚Ìê‡
      if checking_parts.battler != nil
        initiative_zero_flag = false
        # ‚OˆÈ‰º‚Å–³‚¯‚ê‚ÎƒCƒjƒVƒAƒ`ƒu‚ğŒ¸­‚³‚¹‚é
        if checking_parts.initiative > 0
          checking_parts.initiative = 0
          # ‚±‚ê‚É‚æ‚èƒCƒjƒVƒAƒ`ƒu‚ª‚O‚É‚È‚Á‚½ê‡Aƒtƒ‰ƒO‚ğ—§‚Ä‚é
          initiative_zero_flag = true
        end
        #-----------------------------------------------------------------------------
        # ¤ƒCƒjƒVƒAƒ`ƒu‚ª‚O‚É‚³‚ê‚½‚Ì•Ï“®
        if checking_parts.initiative == 0
          # ƒz[ƒ‹ƒh‘Šè‚ğ•Ï”‚É“ü‚ê‚é
          hold_target = checking_parts.battler
          # ƒz[ƒ‹ƒh‘Šè‘¤‚Ì‘Î‰ƒp[ƒc”z—ñ‚ğŠm”F‚·‚é
          target_parts_names = SR_Util.holding_parts_name(checking_parts.type, o_parts_one)
          # ‘Î‰ƒp[ƒc‚²‚Æ‚Éƒ`ƒFƒbƒN
          for t_parts_one in target_parts_names
            # ‘Î‰ƒp[ƒcî•ñ‚ğ•Ï”‚É“ü‚ê‚é
            checking_target_parts = eval("hold_target.hold.#{t_parts_one}")
            # ‹t“]‰Â”\‚Èƒz[ƒ‹ƒh‚Í‘Î‰ƒp[ƒc‚ÌƒCƒjƒVƒAƒ`ƒu‚ğ‚Q‚É‚Ü‚Åˆø‚«ã‚°‚é
            if SR_Util.reversible_hold?(checking_target_parts.type)
              if checking_target_parts.initiative < 2
                checking_target_parts.initiative = 2
              end
            # ‹t“]•s‰Â‚È‚à‚Ì‚Íƒz[ƒ‹ƒh‚ğ‰ğœ‚³‚¹‚é
            else
              # ƒCƒjƒVƒAƒ`ƒu‚ª‚O‚É‚³‚ê‚½i—D¨‚©‚ç—ò¨‚É‚È‚Á‚½j‚Í‰ğœ
              if initiative_zero_flag
                checking_parts.clear
                checking_target_parts.clear
              # ƒCƒjƒVƒAƒ`ƒu‚ªŒ³X‚O‚ÌiŒ³‚©‚ç—ò¨j‚ÍƒCƒjƒVƒAƒ`ƒu‚ğ‚Q‚É‚Ü‚Åˆø‚«ã‚°‚é
              else
                if checking_target_parts.initiative < 2
                  checking_target_parts.initiative = 2
                end
              end
            end
          end
        end
        #-----------------------------------------------------------------------------
      end
    end
  end
  #--------------------------------------------------------------------------
  # œ ƒNƒŠƒeƒBƒJƒ‹“™‚É‚æ‚éƒz[ƒ‹ƒhƒCƒjƒVƒAƒ`ƒuŒ¸­
  # owner : Œ¸­‚·‚éƒoƒgƒ‰[
  #--------------------------------------------------------------------------
  def hold_initiative_down(owner)
    # ƒp[ƒc–¼‚ğæ“¾‚·‚é
    owner_parts = owner.hold.parts_names
    # Šeƒp[ƒc‚²‚Æ‚ÉŠm”F
    for o_parts_one in owner_parts
      # ƒp[ƒcî•ñ‚ğ•Ï”‚É“ü‚ê‚é
      checking_parts = eval("owner.hold.#{o_parts_one}")
      # ‚±‚Ìƒp[ƒc‚ªè—L’†‚Ìê‡
      if checking_parts.battler != nil
        initiative_zero_flag = false
        # ‚OˆÈ‰º‚Å–³‚¯‚ê‚ÎƒCƒjƒVƒAƒ`ƒu‚ğŒ¸­‚³‚¹‚é
        if checking_parts.initiative > 0
          checking_parts.initiative -= 1
          # ‚±‚ê‚É‚æ‚èƒCƒjƒVƒAƒ`ƒu‚ª‚O‚É‚È‚Á‚½ê‡Aƒtƒ‰ƒO‚ğ—§‚Ä‚é
          initiative_zero_flag = true if checking_parts.initiative == 0
        end
        #-----------------------------------------------------------------------------
        # ƒCƒjƒVƒAƒ`ƒu‚ª‚O‚Ì‘Šè‚É‘Î‚·‚éŒø‰Ê
        if checking_parts.initiative == 0
          # ƒz[ƒ‹ƒh‘Šè‚ğ•Ï”‚É“ü‚ê‚é
          hold_target = checking_parts.battler
          # ƒz[ƒ‹ƒh‘Šè‘¤‚Ì‘Î‰ƒp[ƒc”z—ñ‚ğŠm”F‚·‚é
          target_parts_names = SR_Util.holding_parts_name(checking_parts.type, o_parts_one)
          # ‘Î‰ƒp[ƒc‚²‚Æ‚Éƒ`ƒFƒbƒN
          for t_parts_one in target_parts_names
            # ‘Î‰ƒp[ƒcî•ñ‚ğ•Ï”‚É“ü‚ê‚é
            checking_target_parts = eval("hold_target.hold.#{t_parts_one}")
            # ¤‹t“]‰Â”\‚Èƒz[ƒ‹ƒh
            # ‘Î‰ƒp[ƒc‚ÌƒCƒjƒVƒAƒ`ƒu‚ğ‰ÁZ‚³‚¹‚é
            if SR_Util.reversible_hold?(checking_target_parts.type)
              # ƒCƒjƒVƒAƒ`ƒu‚ª‚O‚É‚³‚ê‚½i—D¨‚©‚ç—ò¨‚É‚È‚Á‚½j‚Í‚Q‚Ü‚Åˆø‚«ã‚°‚é
              if initiative_zero_flag
                if checking_target_parts.initiative < 2
                  checking_target_parts.initiative = 2
                end
              # ƒCƒjƒVƒAƒ`ƒu‚ªŒ³X‚O‚ÌiŒ³‚©‚ç—ò¨j‚ÍƒCƒjƒVƒAƒ`ƒu‚ğ‰ÁZ‚³‚¹‚é
              else
                if checking_target_parts.initiative < 3
                  checking_target_parts.initiative += 1
                end
              end
            # ¤‹t“]•s‰Â‚Èƒz[ƒ‹ƒh‚ğ‰ğœ‚³‚¹‚é
            else
              # ƒCƒjƒVƒAƒ`ƒu‚ª‚O‚É‚³‚ê‚½i—D¨‚©‚ç—ò¨‚É‚È‚Á‚½j‚Í‰ğœ
              if initiative_zero_flag
                checking_parts.clear
                checking_target_parts.clear
              # ƒCƒjƒVƒAƒ`ƒu‚ªŒ³X‚O‚ÌiŒ³‚©‚ç—ò¨j‚ÍƒCƒjƒVƒAƒ`ƒu‚ğ‰ÁZ‚³‚¹‚é
              else
                if checking_target_parts.initiative < 3
                  checking_target_parts.initiative += 1
                end
              end
            end
          end
        end
        #-----------------------------------------------------------------------------
      end
    end
    
# ƒz[ƒ‹ƒhƒ|ƒbƒv‚Ìw¦‚Í‚à‚ª‚­“™A
#•¡”‘Šè‚ğ’Ê‚éê‡‚ª‚ ‚é‚Ì‚Å‚±‚Ìƒƒ\ƒbƒh‚ğ’Ê‚Á‚½‚ ‚Æ‚Åw’è
=begin 
    # ƒz[ƒ‹ƒhƒ|ƒbƒv‚Ìw¦
    hold_pops_order
=end

  end
  #--------------------------------------------------------------------------
  # œ Šeƒoƒgƒ‰[‚Éƒz[ƒ‹ƒhó‹µ‚ğ‹L˜^
  #--------------------------------------------------------------------------
  def hold_record
    for battler in $game_party.party_actors + $game_troop.enemies
      battler.hold_list = battler.hold.hold_output
    end
  end
  #--------------------------------------------------------------------------
  # œ ‘Œ¸‚µ‚½ƒz[ƒ‹ƒhƒ|ƒbƒv‚ğw¦
  #--------------------------------------------------------------------------
  def hold_pops_order
    # ‘Sˆõ‚Ìƒz[ƒ‹ƒhó‹µ‚ğŠm”F‚·‚é
    for battler in $game_party.battle_actors + $game_troop.enemies
      # ‘O‰ñ‚ÆŒ»İ‚Ìƒz[ƒ‹ƒhó‹µ‚ğo‚·B
      last_hold = battler.hold_list
      now_hold = battler.hold.hold_output
      # ‘O‚Ìƒz[ƒ‹ƒhó‹µ‚Æˆá‚¤ê‡Aƒf[ƒ^‚ğô‚¢o‚·B
      if last_hold != now_hold
        # ’Ç‰Á‚³‚ê‚½ƒz[ƒ‹ƒh‚Æíœ‚³‚ê‚½ƒz[ƒ‹ƒh‚Ì” ‚ğ‰Šú‰»
        add_hold = []
        delete_hold = []
        #----------------------------------------------------------------------
        # ’Ç‰Á‘¤‚ğŠm”F
        #----------------------------------------------------------------------
        for now in now_hold
          # “¯ƒz[ƒ‹ƒh‚Ì‘¶İƒtƒ‰ƒO‚ğ‰Šú‰»
          exist_flag = false
          for last in last_hold
            # “¯ƒz[ƒ‹ƒh‚ªŒ©‚Â‚©‚Á‚½‚çƒtƒ‰ƒO‚ğ—§‚Ä‚ÄI—¹
            if now[0] == last[0] and now[2] == last[2]
              exist_flag = true
              break
            end
          end
          # “¯‚¶ƒz[ƒ‹ƒh‚ª‚È‚©‚Á‚½ê‡A‚»‚ê‚Í’Ç‰Á‚³‚ê‚½‚à‚Ì‚Å‚ ‚éB
          if exist_flag == false
            add_hold.push(now)
          end
        end
        # ƒ^ƒCƒv‚ªd•¡‚µ‚Ä‚¢‚é‚à‚Ì‚ğ1‚Â‚É‚Ü‚Æ‚ß‚é
        result_box = []
        for hold in add_hold
          overlap_flag = false
          for result in result_box
            if hold[0] == result[0] and hold[2] == result[2]
              overlap_flag = true
              break
            end
          end
          if overlap_flag == false
            result_box.push(hold)
          end
        end
        add_hold = result_box
        #----------------------------------------------------------------------
        # íœ‘¤‚ğŠm”F
        #----------------------------------------------------------------------
        for last in last_hold
          # “¯ƒz[ƒ‹ƒh‚Ì‘¶İƒtƒ‰ƒO‚ğ‰Šú‰»
          exist_flag = false
          for now in now_hold
            # “¯ƒz[ƒ‹ƒh‚ªŒ©‚Â‚©‚Á‚½‚çƒtƒ‰ƒO‚ğ—§‚Ä‚ÄI—¹
            if now[0] == last[0] and now[2] == last[2]
              exist_flag = true
              break
            end
          end
          # “¯‚¶ƒz[ƒ‹ƒh‚ª‚È‚©‚Á‚½ê‡A‚»‚ê‚Ííœ‚³‚ê‚½‚à‚Ì‚Å‚ ‚éB
          if exist_flag == false
            delete_hold.push(last) 
          end
        end
        # ƒ^ƒCƒv‚ªd•¡‚µ‚Ä‚¢‚é‚à‚Ì‚ğ1‚Â‚É‚Ü‚Æ‚ß‚é
        result_box = []
        for hold in delete_hold
          overlap_flag = false
          for result in result_box
            if hold[0] == result[0] and hold[2] == result[2]
              overlap_flag = true
              break
            end
          end
          if overlap_flag == false
            result_box.push(hold)
          end
        end
        delete_hold = result_box
        #----------------------------------------------------------------------
        # ‘O‰ñ‚ÆŒ»İ‚ÌƒCƒjƒVƒAƒ`ƒu‚ğŠm”F
        #----------------------------------------------------------------------
        last_initiative = 0
        for last in last_hold
          last_initiative = last[3] 
          break
        end
        now_initiative = 0
        for now in now_hold
          now_initiative = now[3] 
          break
        end
        #----------------------------------------------------------------------
        # ƒz[ƒ‹ƒhƒ|ƒbƒv‚Ö‚Ìw¦‚ğì¬
        #----------------------------------------------------------------------
        order = []
        for hold in add_hold
          order.push([1, hold[2], battler, hold[0]])
        end
        for hold in delete_hold
          order.push([2, hold[2], battler, hold[0]])
        end
        order.push([3, now_initiative])
        battler.hold_pop_order = order
      end
    end
  end
=begin
  #--------------------------------------------------------------------------
  # š ƒz[ƒ‹ƒh—L—˜•s—˜Ø‚è‘Ö‚¦
  #--------------------------------------------------------------------------
  def hold_initiative(skill, active, target)
    #œ•ûô
    #‚OFƒz[ƒ‹ƒh‚É¬Œ÷‚µ‚½ê‡
    #‚PFdŠ|‚¯‚½‘¤A‘Šè‚ª—¼•û–¢ƒz[ƒ‹ƒh‚Ìê‡  „  dŠ|‚¯‚½‘¤‚ÉdŠ|‚¯‚½ƒz[ƒ‹ƒh‚Ì—L—˜‚ªš‚Q‚Å•t‚­
    #‚QF‘Šè‚ª‚·‚Å‚Éƒz[ƒ‹ƒh’†‚Ìê‡  „  dŠ|‚¯‚½‘¤‚ÉdŠ|‚¯‚½ƒz[ƒ‹ƒh‚Ì—L—˜‚ªš‚Q‚ÅA
    #    ‚»‚Ìã‚Å‘Šè‚Ì—L—˜‚ª‘S‚ÄÁ‚¦‚ÄA‘Šè‚ÉdŠ|‚¯‚Ä‚¢‚éƒz[ƒ‹ƒhƒLƒƒƒ‰‘Sˆõ‚É‚àš‚P‚ª•t‚­
    #¥99ƒIƒt(ƒ_ƒ[ƒW‚âƒAƒ^ƒbƒN‚Å•Ï“®‚·‚éê‡)
    #‚PF‘Šè‚ª—L—˜‚Ìê‡A‚Ü‚¸‘S‚Ä‚Ì—L—˜‚ğ‚P’iŠK’á‰º‚³‚¹‚é
    #‚QF‘Šè‚Ì—L—˜‚Ì‚¤‚¿Aš‚ª‚O‚É‚È‚Á‚½‚ç‚»‚Ìƒz[ƒ‹ƒh‚µ‚Ä‚¢‚é‘Šè‚Éš‚P‚ğ•t—^‚·‚é
    #‚RF©•ª‚ª—L—˜‚Ìê‡Aš‚ª‚QˆÈ‰º‚¾‚Á‚½‚È‚çš‚ğ‚P’iŠKƒAƒbƒv‚³‚¹‚é
    #-------------------------------------------------------------------------
    # ¥ƒz[ƒ‹ƒhƒXƒLƒ‹‚Å‚Í‚È‚¢Aˆê”ÊƒXƒLƒ‹‚É‚æ‚éŒø‰Ê
    #-------------------------------------------------------------------------
    # ¤ƒpƒ^[ƒ“‚RF‘Šè‚ªƒz[ƒ‹ƒh’†‚ÅA‘Šè‚ÉƒZƒ“ƒVƒƒƒ‹ƒGƒtƒFƒNƒg‚ğ”­¶‚³‚¹‚½
    #-------------------------------------------------------------------------
    hd_text = ""
    if (target.critical or skill.element_set.include?(207)) and target.holding?
      #–Ê“|‚Å‚àƒp[ƒc‚²‚Æ‚ÉŒÂ•Ê‘Î‰B
      #‘Šè‚ÌƒCƒjƒVƒAƒ`ƒu‚ğ|‚P‚·‚éB‚P‚Ì‚É|‚P‚µ‚½ê‡AƒCƒjƒVƒAƒ`ƒu‚ª”½“]‚·‚é
      #Šù‚ÉUŒ‚‘ÎÛ‚ÌƒCƒjƒVƒAƒ`ƒu‚ª‚O‚Ìê‡Aƒz[ƒ‹ƒh‘ÎÛ‚É{‚PiÅ‘å‚Rj‚·‚é
      #œƒyƒjƒX•”•ª
      if target.hold.penis.battler != nil
        if target.hold.penis.initiative > 0
          target.hold.penis.initiative -= 1
        end
        if target.hold.penis.initiative == 0
          hold_target = target.hold.penis.battler
          case target.hold.penis.type
          when "Š‘}“ü"
            hold_target.hold.vagina.initiative += 1 unless hold_target.hold.vagina.initiative > 2
          when "Œû‘}“ü"
            hold_target.hold.mouth.initiative += 1 unless hold_target.hold.mouth.initiative > 2
          when "K‘}“ü"
            hold_target.hold.anal.initiative += 1 unless hold_target.hold.anal.initiative > 2
          when "ƒpƒCƒYƒŠ"
            hold_target.hold.tops.initiative += 1 unless hold_target.hold.tops.initiative > 2
          when "Gè‹zˆø"
            hold_target.hold.tentacle.initiative += 1 unless hold_target.hold.tentacle.initiative > 2
          end
        end
      end
      #œŒû•”•ª
      if target.hold.mouth.battler != nil
        if target.hold.mouth.initiative > 0
          target.hold.mouth.initiative -= 1
        end
        if target.hold.mouth.initiative == 0
          hold_target = target.hold.mouth.battler
          case target.hold.mouth.type
          when "Œû‘}“ü"
            case target.hold.mouth.parts
            when "ƒyƒjƒX"
              hold_target.hold.penis.set(nil, nil, nil, nil)
              target.hold.mouth.set(nil, nil, nil, nil)
            when "K”ö"
              hold_target.hold.tail.set(nil, nil, nil, nil)
              target.hold.mouth.set(nil, nil, nil, nil)
            when "ƒfƒBƒ‹ƒh"
              hold_target.hold.dildo.set(nil, nil, nil, nil)
              target.hold.mouth.set(nil, nil, nil, nil)
            when "Gè"
              hold_target.hold.tentacle.set(nil, nil, nil, nil)
              target.hold.mouth.set(nil, nil, nil, nil)
            end
          when "Šç–Ê‹Ræ"
            hold_target.hold.vagina.initiative += 1 unless hold_target.hold.vagina.initiative > 2
          when "K‹Ræ"
            hold_target.hold.anal.initiative += 1 unless hold_target.hold.anal.initiative > 2
          when "ƒLƒbƒX"
            hold_target.hold.mouth.initiative += 1 unless hold_target.hold.mouth.initiative > 2
          when "ƒNƒ“ƒj"
            #S‘©ƒ^ƒCƒv‚ÍƒCƒjƒVƒAƒ`ƒu‚ªØ‚ê‚½’iŠK‚ÅŠO‚ê‚é
            hold_target.hold.vagina.set(nil, nil, nil, nil)
            target.hold.mouth.set(nil, nil, nil, nil)
          end
        end
      end
      #œƒAƒ\ƒR•”•ª
      if target.hold.vagina.battler != nil
        if target.hold.vagina.initiative > 0
          target.hold.vagina.initiative -= 1
        end
        if target.hold.vagina.initiative == 0
          hold_target = target.hold.vagina.battler
          case target.hold.vagina.type
          when "Š‘}“ü"
            case target.hold.vagina.parts
            when "ƒyƒjƒX"
              hold_target.hold.penis.initiative += 1 unless hold_target.hold.penis.initiative > 2
            when "K”ö"
              hold_target.hold.tail.set(nil, nil, nil, nil)
              target.hold.vagina.set(nil, nil, nil, nil)
            when "ƒfƒBƒ‹ƒh"
              hold_target.hold.dildo.set(nil, nil, nil, nil)
              target.hold.vagina.set(nil, nil, nil, nil)
            when "Gè"
              hold_target.hold.tentacle.set(nil, nil, nil, nil)
              target.hold.vagina.set(nil, nil, nil, nil)
            end
          when "ŠL‡‚í‚¹"
            hold_target.hold.vagina.initiative += 1 unless hold_target.hold.vagina.initiative > 2
          when "Šç–Ê‹Ræ"
            #S‘©ƒ^ƒCƒv‚ÍƒCƒjƒVƒAƒ`ƒu‚ªØ‚ê‚½’iŠK‚ÅŠO‚ê‚é
            hold_target.hold.mouth.set(nil, nil, nil, nil)
            target.hold.vagina.set(nil, nil, nil, nil)
          end
        end
      end
      #œƒAƒiƒ‹•”•ª
      if target.hold.anal.battler != nil
        if target.hold.anal.initiative > 0
          target.hold.anal.initiative -= 1
        end
        if target.hold.anal.initiative == 0
          hold_target = target.hold.anal.battler
          case target.hold.anal.type
          when "K‘}“ü"
            case target.hold.anal.parts
            when "ƒyƒjƒX"
              hold_target.hold.penis.initiative += 1 unless hold_target.hold.penis.initiative > 2
            when "K”ö"
              hold_target.hold.tail.set(nil, nil, nil, nil)
              target.hold.anal.set(nil, nil, nil, nil)
            when "ƒfƒBƒ‹ƒh"
              hold_target.hold.dildo.set(nil, nil, nil, nil)
              target.hold.anal.set(nil, nil, nil, nil)
            when "Gè"
              hold_target.hold.tentacle.set(nil, nil, nil, nil)
              target.hold.anal.set(nil, nil, nil, nil)
            end
          when "K‹Ræ"
            #S‘©ƒ^ƒCƒv‚ÍƒCƒjƒVƒAƒ`ƒu‚ªØ‚ê‚½’iŠK‚ÅŠO‚ê‚é
            hold_target.hold.mouth.set(nil, nil, nil, nil)
            target.hold.anal.set(nil, nil, nil, nil)
          end
        end
      end
      #œã”¼g•”•ª
      if target.hold.tops.battler != nil
        hold_target = target.hold.tops.battler
        if target.hold.tops.initiative > 0
          target.hold.tops.initiative -= 1
          if target.hold.tops.initiative == 0
            #ã”¼g‚ÍƒCƒjƒVƒAƒ`ƒu‚ªØ‚ê‚½’iŠK‚ÅŠO‚ê‚é
            hold_target = target.hold.tops.battler
            hold_target.hold.tops.set(nil, nil, nil, nil)
            case target.hold.tops.parts
            when "ã”¼g" #ƒGƒ“ƒuƒŒƒCƒX
              target.hold.tops.set(nil, nil, nil, nil)
            when "Œû" #ƒwƒuƒ“ƒŠ[ƒtƒB[ƒ‹
              target.hold.mouth.set(nil, nil, nil, nil)
            when "ƒyƒjƒX" #ƒyƒŠƒXƒR[ƒv
              target.hold.penis.set(nil, nil, nil, nil)
            when "Gè" #ƒyƒŠƒXƒR[ƒv
              target.hold.tentacle.set(nil, nil, nil, nil)
            end
          end
        #Šù‚ÉƒCƒjƒVƒAƒ`ƒu‚ª‚O(‘ÎÛ‚ª”íS‘©ó‘Ô)‚È‚ç‘Šè‚É{‚P‚·‚é
        else
          case target.hold.tops.parts
          when "Œû"
            hold_target.hold.mouth.initiative += 1 unless hold_target.hold.mouth.initiative > 2
          when "ƒyƒjƒX"
            hold_target.hold.penis.initiative += 1 unless hold_target.hold.penis.initiative > 2
          when "ã”¼g"
            hold_target.hold.tops.initiative += 1 unless hold_target.hold.tops.initiative > 2
          end
        end
      end
      #œK”ö•”•ª
      if target.hold.tail.battler != nil
        if target.hold.tail.initiative > 0
          target.hold.tail.initiative -= 1
          if target.hold.tail.initiative == 0
            #K”ö‘}“ü‚ÍƒCƒjƒVƒAƒ`ƒu‚ªØ‚ê‚½’iŠK‚ÅŠO‚ê‚é
            hold_target = target.hold.tail.battler
            case target.hold.tail.parts
            when "ƒAƒ\ƒR"
              hold_target.hold.vagina.set(nil, nil, nil, nil)
            when "Œû"
              hold_target.hold.mouth.set(nil, nil, nil, nil)
            when "ƒAƒiƒ‹"
              hold_target.hold.anal.set(nil, nil, nil, nil)
            end
            target.hold.tail.set(nil, nil, nil, nil)
          end
        end
      end
      #œƒfƒBƒ‹ƒh•”•ª
      if target.hold.dildo.battler != nil
        if target.hold.dildo.initiative > 0
          target.hold.dildo.initiative -= 1
          if target.hold.dildo.initiative == 0
            #ƒfƒBƒ‹ƒh‘}“ü‚ÍƒCƒjƒVƒAƒ`ƒu‚ªØ‚ê‚½’iŠK‚ÅŠO‚ê‚é
            hold_target = target.hold.dildo.battler
            case target.hold.dildo.parts
            when "ƒAƒ\ƒR"
              hold_target.hold.vagina.set(nil, nil, nil, nil)
            when "Œû"
              hold_target.hold.mouth.set(nil, nil, nil, nil)
            when "ƒAƒiƒ‹"
              hold_target.hold.anal.set(nil, nil, nil, nil)
            end
            target.hold.dildo.set(nil, nil, nil, nil)
          end
        end
      end
      #œGè•”•ª
      if target.hold.tentacle.battler != nil
        if target.hold.tentacle.initiative > 0
          target.hold.tentacle.initiative -= 1
          if target.hold.tentacle.initiative == 0
            #Gè‘}“üES‘©‚ÍƒCƒjƒVƒAƒ`ƒu‚ªØ‚ê‚½’iŠK‚ÅŠO‚ê‚é
            hold_target = target.hold.tentacle.battler
            case target.hold.tentacle.parts
            when "ƒyƒjƒX"
              hold_target.hold.penis.set(nil, nil, nil, nil)
            when "ƒAƒ\ƒR"
              hold_target.hold.vagina.set(nil, nil, nil, nil)
            when "Œû"
              hold_target.hold.mouth.set(nil, nil, nil, nil)
            when "ƒAƒiƒ‹"
              hold_target.hold.anal.set(nil, nil, nil, nil)
            when "ã”¼g"
              hold_target.hold.tops.set(nil, nil, nil, nil)
            end
            target.hold.tentacle.set(nil, nil, nil, nil)
          end
        end
      end
    end
    # ƒz[ƒ‹ƒhƒ|ƒbƒv‚Ìw¦
    hold_pops_order
    # ‘ÌˆÊƒeƒLƒXƒg
    $game_temp.battle_log_text += "\\" + hd_text if hd_text != ""
  end
=end

end