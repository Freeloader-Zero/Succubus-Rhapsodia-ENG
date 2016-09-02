#==============================================================================
# š Game_Battler TextMake
#------------------------------------------------------------------------------
# @ƒoƒgƒ‹ƒƒbƒZ[ƒWˆ—
#==============================================================================

class Game_Battler
  ##################
  #œ ƒXƒe[ƒg•ñ #
  ##################
  def bms_states_report
    text = ""
    # ƒXƒe[ƒg‚Åreport‚ªİ’è‚³‚ê‚Ä‚¢‚é‚à‚Ì‚ğ‘S‚Äæ“¾
    # ‚½‚¾‚µƒNƒ‰ƒCƒVƒX‚ÍœŠO
    for i in self.states
      if $data_states[i].id != 6 and self.exist? and not self.dead?
        ms = $data_states[i].message($data_states[i],"report",self,nil)
        text = (text + ms + "\\") if ms != ""
      end
    end
    # ƒƒbƒZ[ƒW•\¦
    if text != ""
      text += "CLEAR"
      text.sub!("\\CLEAR","")
      return text
    else
      return ""
    end
  end
  ######################
  #œ ƒXƒe[ƒg•Ï‰»•ñ#
  ######################
  def bms_states_update(user_battler = nil)
    user = $game_temp.battle_active_battler
    user = nil if $game_temp.battle_active_battler == [] and user_battler == nil #ƒ^[ƒ“ŠJn‚Ì‚İ
    user = user_battler if user_battler != nil
    ms1 = ms2 = ""
    text1 = text2 = ""
    if (self.add_states_log == [] and self.remove_states_log == [])
      return ""
    end
    # ƒXƒe[ƒg•t‰Á•ñ
    if self.add_states_log != []
      for i in self.add_states_log
        ms1 = i.message(i,"effect", self, user)
        # í“¬•s”\‚È‚ç•ñI—¹
        if i.id == 1
          text1 = ms1
          self.add_states_log.clear
          return text1
        end
        #‰üs‚ğ‘}“ü
        text1 = text1 + ms1 + "\\" if ms1 != ""
      end
      #Ši”[I—¹‚µ‚½‚çƒƒO‚ğÁ‹‚·‚é
      self.add_states_log.clear
    end
    # ƒXƒe[ƒg‰ğœ•ñ
    if self.remove_states_log != [] and not self.dead?
      for i in self.remove_states_log
        ms2 = i.message(i,"recover", self, user)
        #‰üs‚ğ‘}“ü
        text2 = text2 + ms2 + "\\" if ms2 != ""
      end
      #Ši”[I—¹‚µ‚½‚çƒƒO‚ğÁ‹‚·‚é
      self.remove_states_log.clear
    end
    # ƒeƒLƒXƒg®Œ`
    text = text1 + text2
    # ƒƒbƒZ[ƒWo—Í
    if text != ""
      #•¶Í‚ª‚ ‚éê‡AÅŒã‚Ì‰üs‚ğÁ‚·
      text += "CLEAR"
      text.sub!("\\CLEAR","")
      return text
    else
      return ""
    end
  end
  #-------------------------#
  # œ ƒXƒLƒ‹g—pƒƒbƒZ[ƒW #
  #-------------------------#
  def bms_useskill(skill)
    user = $game_temp.battle_active_battler
    text = skill.message(skill, "action", self, user)
    if text != "" and text != nil
      text = text + "\"
      # ’§”­‚É‚æ‚é‘ÎÛ•ÏX‚ª”­¶‚µ‚Ä‚¢‚éê‡A—UˆøƒƒbƒZ[ƒW‚ğo‚·
      if $game_temp.incite_flag
        text = "#{user.name} ‚—as invited!\\" + text
      end
      $game_temp.battle_log_text = text
    end
  end
  #-----------------------------#
  # œ ƒXƒLƒ‹g—pŒ‹‰ÊƒƒbƒZ[ƒW #
  #-----------------------------#
  def bms_skill_effect(skill)
    user = $game_temp.battle_active_battler
    plus = ""
    text = ""
    if self.damage.is_a?(Numeric)
      myname = self.name
      username = $game_temp.battle_active_battler.name
      damage = self.damage
      # œƒNƒŠƒeƒBƒJƒ‹ˆ—
      if self.critical and self.damage != "Miss"
#        plus += "ƒZƒ“ƒVƒ…ƒAƒ‹ƒXƒgƒ[ƒNI\\"
        plus += "Sensual StrokeI\\"
        self.animation_id = 103
        self.animation_hit = true
        self.damage_pop = true
        # ƒ€[ƒhƒAƒbƒv
        $mood.rise(1 + rand(5))
      else
        plus = ""
      end
      # œƒ_ƒ[ƒWˆ—(’l‚ªƒ}ƒCƒiƒX‚È‚ç‰ñ•œƒXƒLƒ‹)
      if damage > 0
        if user.is_a?(Game_Actor)
          text = "Dealt #{damage.to_s} pleasure to #{myname}!"
          text = "#{myname} ‚—rithes in pleasure!" if self.weaken? and not self.dead?
          text = "#{myname}'s body spas‚s from intense pleasure!" if self.sp_down_flag == true
        else
          text = "#{myname} received #{damage.to_s} pleasure!"
          text = "#{myname} ‚—rithes in pleasure!" if self.weaken?
          text = "#{myname}'s body spas‚s from intense pleasure!" if self.sp_down_flag == true
          text = "#{myname}'s vitality has been cut...!" if self.weaken? and self == $game_actors[101]
          text = "#{myname}'s body has been pushed to its li‚it!" if self.sp_down_flag == true and self == $game_actors[101]
        end
      elsif damage == 0# and damage < 1
        if user.is_a?(Game_Actor)
          text = "#{myname} didn't take any pleasure!"
        else
          text = "#{myname} didn't take any pleasure!"
        end
        #-------------------------------------------------------------------------
        # –{‹C‚É‚È‚é–²–‚‚ª‚Ü‚¾–{‹C‚ğo‚µ‚Ä‚¢‚È‚¢‚½‚ß‚É¸_‚µ‚È‚¢ê‡AƒeƒLƒXƒg‚ğ•ÏX
        #-------------------------------------------------------------------------
        if SR_Util.enemy_before_earnest?(self)
          text = "#{myname}'s body lurges in great pleasure!"
        end
      else
        n = self.damage * 80 / 100
        text = "#{myname} recovered #{(damage.abs).to_s}‚d‚o!"
      end
    elsif self.damage == "Miss"
      text = skill.message(skill,"avoid", self, user)
    end
    text = plus + text if plus != ""
    
# ƒ_ƒ[ƒW–³‚µƒXƒLƒ‹‚Åƒ€[ƒh‚ªã‚ª‚ç‚È‚¢‚Ì‚ÅScene_Battle‚ÉˆÚA
=begin
    # ƒ€[ƒhƒAƒbƒvˆ—
    #------------------------------------------------------
    # ƒ€[ƒhƒAƒbƒv¬
    if skill.element_set.include?(20)
      $mood.rise(1)
    # ƒ€[ƒhƒAƒbƒv’†
    elsif skill.element_set.include?(21)
      $mood.rise(4)
    # ƒ€[ƒhƒAƒbƒv‘å
    elsif skill.element_set.include?(22)
      $mood.rise(10)
    end
=end

    
    return text
  end
  #---------------------------------#
  # œ ‰‰oƒXƒLƒ‹g—pŒ‹‰ÊƒƒbƒZ[ƒW #
  #---------------------------------#
  def bms_direction_skill_effect(skill)
    text = ""
    myname = self.name
    username = $game_temp.battle_active_battler.name
    #------------------------------------------------------------------------#        
    # ¡“ÁêƒXƒLƒ‹
    case skill.id
    when 419   #ƒAƒ“ƒ‰ƒbƒL[ƒƒA
      text = "#{$game_actors[101].name}‚Í•sK‚É‚È‚Á‚Ä‚µ‚Ü‚Á‚½I\\"
      # •sK‚Å‚È‚¢ê‡A•sKó‘Ô‚É‚·‚éB
      if $game_variables[61] == 0
        $game_variables[61] = 50 
      end
    when 239   #ƒVƒƒƒCƒjƒ“ƒOƒŒƒCƒW
      text = "ˆÅ‚ğÙ‚­‘MŒõ‚Ì“S’Æ‚ªAˆ«‚µ‚«Ò‚Ç‚à‚ğŠÑ‚­II\\"
    end
    #------------------------------------------------------------------------#        
    return text
  end
 
  #---------------------------#
  # œ ƒAƒCƒeƒ€g—pƒƒbƒZ[ƒW #
  #---------------------------#
  def bms_useitem(item)
    user = $game_temp.battle_active_battler
    text = item.message(item, "action", self, user)
    if text != nil
      text = text + "\"
      $game_temp.battle_log_text = text
    end
  end
  #-------------------------------#
  # œ ƒAƒCƒeƒ€g—pŒ‹‰ÊƒƒbƒZ[ƒW #
  #-------------------------------#
  def bms_item_effect(item)
    user = $game_temp.battle_active_battler
    text = ""
    myname = self.name
    damage = self.damage
    # EP‚ÆVP—¼•û‰ñ•œ‚Ìê‡
    if (item.recover_hp_rate > 0 or item.recover_hp > 0) and
       (item.recover_sp_rate > 0 or item.recover_sp > 0)
      text = "#{myname} recovered #{(damage.abs).to_s}‚d‚o!\" + 
             "#{myname} recovered #{(recover_sp).to_s}‚u‚o!I"
      text = "‚µ‚©‚µ¡‚ÍŒø‰Ê‚ª–³‚©‚Á‚½I" if self.state?("Šã")
    # EP‚Ì‚İ‰ñ•œ‚Ìê‡
    elsif (item.recover_hp_rate > 0 or item.recover_hp > 0)
      text = "#{myname} recovered #{(damage.abs).to_s}‚d‚o!"
      text = "‚go‚—ever it seems to be ineffective!" if self.state?("Šã")
    # VP‚Ì‚İ‰ñ•œ‚Ìê‡
    elsif (item.recover_sp_rate > 0 or item.recover_sp > 0)
      text = "#{myname} recovered #{(recover_sp).to_s}‚u‚o!"
    # ‘¡‚è•¨ƒAƒCƒeƒ€ƒAƒCƒeƒ€‚Ìê‡
    elsif item.element_set.include?(199)
      text = bms_present_response
    end
    # ƒ~ƒX‚Ìê‡‰ñ”ğƒƒbƒZ[ƒW‚ğ•\¦
    if self.damage == "Miss"
      text = item.message(item,"avoid", self, user)
    end
    # ƒƒbƒZ[ƒW•\¦
    return text
  end
  #-------------------------------#
  # œ ‘¡‚è•¨‚ğó‚¯æ‚Á‚½”½‰     #
  #-------------------------------#
  def bms_present_response
    text = ""
    myname = self.name
    user = $game_temp.battle_active_battler.name
    # «Ši‚²‚Æ‚É•ÏX
    case self.personality
    #------------------------------------------------------------------------
    when "DF","‚–","“Æ‘P"
      text = "#{myname} s‚iles suggestively...!"
    #------------------------------------------------------------------------
    when "—z‹C","“V‘R","ŠÃ‚¦«","’¨‹C"
      text = "#{myname} is s‚iling happily...I"
    #------------------------------------------------------------------------
    when "DF","ã•i","_˜a","]‡","‚‹M"
      text = "#{myname} has a sub‚issively pleased look on her face...!"
    #------------------------------------------------------------------------
    when "Ÿ‚¿‹C","ˆÓ’nˆ«","‹Cä","‘¸‘å"
      text = "#{myname} looks a‚—ay to shado‚— her e‚barrass‚ent...!"
    #------------------------------------------------------------------------
    when "’W”‘","•sv‹c","“|ö","‰A‹C"
      text = "#{myname} see‚s so‚e‚—hat pleased...!"
    #------------------------------------------------------------------------
    when "“à‹C","‹•¨","Œ‰•È"
      text = "#{myname}'s face is blushing red ‚—ith e‚barrass‚ent...!"
    #------------------------------------------------------------------------
    when "˜Iˆ«‹¶"
      text = "#{myname} appears a‚used,\n\ sneering and laughing at #{user}...!"
    #------------------------------------------------------------------------
    else
      text = "#{myname} see‚s to be pleased...!"
    end
    # •Ô‚·
    return text
  end
  
end