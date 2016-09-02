#==============================================================================
# ¡ RPG::Skill
#------------------------------------------------------------------------------
# @ƒXƒLƒ‹ŒÂ•ÊƒƒbƒZ[ƒWŠi”[
#
#   ¦ƒXƒLƒ‹ƒeƒLƒXƒg‚Íˆês‚ ‚½‚è‚Q‚S•¶šA‚Qs‚Ü‚Å‚É‚Å‚«‚é‚¾‚¯—}‚¦‚é–
#==============================================================================
module RPG
  class Skill
    def message(skill, type, myself, user)
      text = ""
      #ƒ‰ƒ“ƒ_ƒ€Šî“_ƒXƒLƒ‹A‚Ü‚½‚ÍƒeƒLƒXƒg–³‚µƒXƒLƒ‹‚Ìê‡
      if skill.element_set.include?(9) or skill.element_set.include?(43)
        return text 
      end
      action = ""
      myname = myself.name #rescue myname = "*TODO*"
      username = user.name #rescue username = "*TODO*"
      skill_name = skill.UK_name rescue skill_name = "skill name error"   
      target = $game_temp.battle_target_battler[0] if $game_temp.battle_target_battler[0] != nil
      targetname = $game_temp.battle_target_battler[0].name if $game_temp.battle_target_battler[0] != nil
      premess = "#{myname}"
      avoid = "But #{myname} quickly dodged out of the ‚—ay!"
      $game_variables[17] = rand(100) #ƒXƒLƒ‹—p—”
      # ‘ÎÛ‚ª•¡”‚Ìê‡‚ÌƒeƒLƒXƒg
      range = target.is_a?(Game_Actor) ? $game_party.battle_actors : $game_troop.enemies
      exist_count = 0
      for one in range
        exist_count += 1 if one.exist?
      end
      rangetext = exist_count > 1 ? "‚½‚¿" : ""
      
      
  #================================================================================================================================#
      # ¡“Áê‚Ès“®‚Ìê‡i‘®«‚Å”»’fj
      # œ–‚–@
      if skill.element_set.include?(5)
        action = premess + " casts #{skill_name}"
        avoid = "It had no effect on #{myname}!"
      #------------------------------------------------------------------------#
      # šƒCƒ“ƒZƒ“ƒX
      elsif skill.element_set.include?(129)
        action = premess + " used #{skill_name}!"
        avoid = "It had no effect on #{myname}!"
      else
        action = premess + " caressed #{targetname}!"
        avoid = "It had no effect on #{myname}!"
      end
      #------------------------------------------------------------------------#
      # ƒuƒŒƒCƒNƒtƒ‰ƒO(dŠ|‚¯è‚Æó‚¯è‚Ì–¼‘O•¶š”‡Œv‚ª‚P‚Q‚ğ‰z‚¦‚éê‡A‰üs‚ğ‹²‚Şƒtƒ‰ƒO)
      # ƒeƒLƒXƒg“à—e‚É‚æ‚Á‚Ä‚ÍA‹²‚Ü‚È‚­‚Ä‚à—Ç‚¢ê‡‚ª‚ ‚é‚Ì‚Ål‚¦‚Ä“ü‚ê‚é‚±‚Æ
      # brk‚Íu‘Šè‚Æ©•ª‚Ì–¼‘OvAbrk3‚Íu‘Šè‚Ì–¼‘O‚Æ‘Šè‚Ì‹¹ƒTƒCƒYv‚ğf’f‚·‚é
      # brk2‚ÍƒXƒLƒ‹’PˆÊ‚ÅŒÂ•Êw’è‚µ‚Ä‚¢‚é‚½‚ßAˆêŠ‡‚Å‚Íİ’è‚µ‚È‚¢
      brk = brk2 = brk3 = brk4 = ""
      if targetname != nil
        brk = "A\n\" if SR_Util.names_over?(myname,targetname)
        brk3 = "\n" if targetname.size + target.bustsize.size > 39 #‹¹”äŠr‚Æ–¼‘O‚ğ‚ ‚í‚¹‚Ä‚P‚R•¶š‰z‚¦‚ÅÜ‚è•Ô‚·
        brk4 = "\n" if targetname.size > 24 #‘ÎÛ‚Ì–¼‘O‚ª‚W•¶š‰z‚¦‚ÅÜ‚è•Ô‚·
      end
      #------------------------------------------------------------------------#
      #ƒz[ƒ‹ƒh‰‡Œì‚»‚Ì‘¼—pE«Ši•ÊŒ`—e•\Œ»
      emotion = "”÷Î‚ñ‚ÅA" #”Ä—p
      case myself.personality
      when "—z‹C","Ÿ‚¿‹C","_˜a", "‚‹M"
        emotion = "ˆ«‹Y‚Á‚Û‚­Î‚İ‚ğ•‚‚©‚×‚é‚ÆA"
        emotion = "Šy‚µ‚°‚ÉŒûŒ³‚ğ‚ä‚ª‚ßA" if $game_variables[17] < 33
        emotion = "‚É‚â‚Á‚Æ–Ú‚ğ×‚ß‚é‚ÆA" if $game_variables[17] > 66
      when "ˆÓ’nˆ«","‚–","‹•¨", "‹Cä" #
        emotion = "ˆÓ’nˆ«‚°‚ÉŒûŒ³‚ğ‚ä‚ª‚ßA"
        emotion = "v‚í‚¹‚Ô‚è‚ÈÎ‚İ‚ğ•‚‚©‚×A" if $game_variables[17] < 33
        emotion = "‚·‚£‚Á‚Æ–Ú‚ğ×‚ß‚é‚ÆA" if $game_variables[17] > 66
      when "DF","ã•i","“|ö", "“Æ‘P" #
        emotion = "ˆú“ ‚ÈÎ‚İ‚ğ•‚‚©‚×‚é‚ÆA"
        emotion = "v‚í‚¹‚Ô‚è‚ÈÎ‚İ‚ğ•‚‚©‚×A" if $game_variables[17] < 33
        emotion = "‚µ‚È‚‚ê‚©‚©‚Á‚Ä—ˆ‚é‚â”Û‚âA" if $game_variables[17] > 66
      when "“V‘R","ŠÃ‚¦«", "’¨‹C" #
        emotion = "–³×‹C‚É”÷Î‚İ‚È‚ª‚çA"
        emotion = "‚¶‚Á‚Æ#{targetname}‚ÌŠç‚ğŒ©‚Â‚ß‚é‚ÆA" if $game_variables[17] < 33
        emotion = "ˆ«‹Y‚Á‚Û‚­Î‚İ‚ğ•‚‚©‚×‚é‚ÆA" if $game_variables[17] > 66
      when "“à‹C","]‡", "‘¸‘å" #
        emotion = "ü‚è‚É‹}‚©‚³‚ê‚é‚æ‚¤‚ÉA"
        emotion = "ˆÓ‚ğŒˆ‚µ‚½‚©‚Ì‚æ‚¤‚ÉA" if $game_variables[17] < 33
        emotion = "‚¿‚ç‚¿‚ç‚Æ—lq‚ğf‚¢‚Â‚ÂA" if $game_variables[17] > 66
      when "•sv‹c","’W”‘","‰A‹C" #
        emotion = "‚¶‚Á‚Æ#{targetname}‚ÌŠç‚ğŒ©‚Â‚ßA"
        emotion = "‹»–¡‚ğä‚©‚ê‚½‚æ‚¤‚È•\î‚ÅA" if $game_variables[17] < 33
        emotion = "‰½‚©‚ğ”[“¾‚µ‚½‚æ‚¤‚Éèõ‚­‚ÆA" if $game_variables[17] > 66
      when "Œ‰•È" #ƒ‰[ƒ~ƒ‹
        emotion = "ü‚è‚É‹}‚©‚³‚ê‚é‚æ‚¤‚ÉA"
        emotion = "ˆÓ‚ğŒˆ‚µ‚½‚©‚Ì‚æ‚¤‚ÉA" if $game_variables[17] < 33
        emotion = "‚¿‚ç‚¿‚ç‚Æ—lq‚ğf‚¢‚Â‚ÂA" if $game_variables[17] > 66
      when "˜Iˆ«‹¶" #ƒ”ƒFƒ‹ƒ~ƒB[ƒi
        emotion = "ˆ«‹Y‚Á‚Û‚­Î‚İ‚ğ•‚‚©‚×‚é‚ÆA"
        emotion = "Šy‚µ‚°‚ÉŒûŒ³‚ğ‚ä‚ª‚ßA" if $game_variables[17] < 33
        emotion = "‚É‚â‚Á‚Æ–Ú‚ğ×‚ß‚é‚ÆA" if $game_variables[17] > 66
      end
      #------------------------------------------------------------------------#
      #K”ö‚ÌŒ`—e
      case $data_SDB[target.class_id].name
      when "Lesser Succubus ","Succubus", "Vermiena"
        tail = "flexible tail"
      when "I‚p","Devil ","De‚on", "Yuganaught"
        tail = "spaded tail"
      when "Werecat ","Werewolf","Ta‚a‚o"
        tail = "fluffy tail"
      when "Fulbeua ", "Neijorange", "Succubus Lord "
        tail = "glossy tail"
      when "Familiar", "Rejeo ", "Sylphe"
        tail = "delicate tail"
      when "Gargoyle"
        tail = "squarish tail"
      else
        tail = "tail"
      end
      #------------------------------------------------------------------------#
      ##{pantsu}‚ÌŒ`—e
      case $data_SDB[target.class_id].name
      when "Hu‚an" #ƒƒEŒN
        pantsu = "under‚—ear"
      when "I‚p","Devil ","De‚on", "Goblin", "Goblin Leader "
        pantsu = "panties"
      when "Night‚are"
        pantsu = "tights"
      when "Werewolf", "Werecat ", "Ta‚a‚o"
        pantsu = "loin cloth"
      when "Sli‚e", "Gold Sli‚e "
        pantsu = "loin mucus"
      when "Gargoyle"
        pantsu = "groin slate"
      else
        pantsu = "panties"
      end
      #------------------------------------------------------------------------#
      #U‚ß‚ÌŒ`—e
      # ’ÇŒ‚‚Å‚È‚¢ê‡
      if $game_switches[78] == false
        tec = ["erratically","amorously"]
        tec.push("skillfully") if myself.positive?
        tec.push("smoothly") if myself.positive?
        tec.push("coyly") if myself.negative?
        tec.push("blissfully") if myself.negative?
      # ’ÇŒ‚‚Ìê‡
      else
        tec = ["delightfully","amorously"]
        tec.push("relentlessly") if myself.positive?
        tec.push("provokingly") if myself.positive?
        tec.push("ecstatically") if myself.negative?
        tec.push("eagerly") if myself.negative?
      end
      tec = tec[rand(tec.size)]
  #================================================================================================================================#
      # ¡ƒXƒLƒ‹–¼‚Å”»’f(ƒz[ƒ‹ƒh–¼‚Í“G–¡•û‹¤’Ê‚Ì‚½‚ß‚±‚¿‚ç‚Å)
      case skill.name
  #------------------------------------------------------------------------#
      when "•‚ğ’E‚ª‚·"
        if target.is_a?(Game_Enemy) #ƒGƒlƒ~[‚ğ’E‚ª‚¹‚é
          action = premess + ",\n\ atte‚pts to take off #{targetname}'s clothes!"
          #ƒXƒ‰ƒCƒ€Œn‚Íê—p‚ÌƒeƒLƒXƒg‚Æ‚È‚é
          action = premess + ",\n\ attempts to push\n\ away #{targetname}'s protective slime!" if target.tribe_slime?
        elsif target.is_a?(Game_Actor) #ƒAƒNƒ^[‚ª’E‚ª‚³‚ê‚é
          action = premess + ",\n\ tries to take off #{targetname}'s clothes!"
          #ƒXƒ‰ƒCƒ€Œn‚Íê—p‚ÌƒeƒLƒXƒg‚Æ‚È‚é
          action = premess + ",\n\ tries to push away #{targetname}'s protective slime!" if target.tribe_slime?
        end
        avoid = ""
  #------------------------------------------------------------------------#
      when "•‚ğ’E‚®"
        if myself == $game_actors[101]
          action = "#{myname} took off his clothes!"
        else
          action = "#{myname} took off her clothes!"
        end
        if myself == $game_actors[101]
          action = "#{myname} thre‚— off his clothes! " if myself.berserk == true
        else
          action = "#{myname} thre‚— off her clothes! " if myself.berserk == true
        end
        #ƒXƒ‰ƒCƒ€Œn‚Íê—p‚ÌƒeƒLƒXƒg‚Æ‚È‚é
        action = "#{myname} released her protective sli‚e coating!" if target.tribe_slime?
        action = "#{myname}'s sli‚e coating splits and explodes\n off of her, revealing her voluptuously naked body!" if target.tribe_slime? and myself.berserk == true
        avoid = ""
  #------------------------------------------------------------------------#
      when "ƒCƒ“ƒT[ƒg","ƒVƒFƒ‹ƒ}ƒbƒ`","ƒAƒNƒZƒvƒg","ƒfƒBƒ‹ƒhƒCƒ“ƒT[ƒg"
        if target.is_a?(Game_Enemy) #ƒGƒlƒ~[‚ğƒz[ƒ‹ƒh‚·‚é
          case $mood.point
          when 50..100
            case $data_SDB[target.class_id].name
            when "I‚p", "Familiar", "Goblin", "Goblin Leader ", "Unique Tycoon "
              action = premess + ",\n\ pins do‚—n #{targetname}'s s‚all body fro‚ above!"
            when "Caster", "Little Witch", "Lili‚", "Slave "
              action = premess + ",\n\ pins do‚—n #{targetname}'s delicate body fro‚ above!"
            else
              action = premess + ",\n\ pins do‚—n #{targetname}'s body fro‚ above!"
            end
          else
            case $data_SDB[target.class_id].name
            when "I‚p", "Familiar", "Goblin", "Goblin Leader ", "Unique Tycoon "
              action = premess + ",\n\ pushes do‚—n #{targetname}'s s‚all body!"
            when "Caster", "Little Witch", "Lili‚", "Slave "
              action = premess + ",\n\ pushes do‚—n #{targetname}'s delicate body!"
            else
              action = premess + ",\n\ pushes do‚—n #{targetname}'s body!"
            end
          end
        elsif target.is_a?(Game_Actor) #ƒAƒNƒ^[‚ªƒz[ƒ‹ƒh‚³‚ê‚é
          case $mood.point
          when 50..100
            action = "#{targetname},\n\ has been pinned do‚—n by #{myname}!"
          else
            if target == $game_actors[101]
            action = "#{myname},\n\ forcibly sits do‚—n on top of #{targetname}!"
            else
            action = "#{targetname},\n\ has been pushed do‚—n by #{myname}!"
            end
          end
        end
        avoid = ""
  #------------------------------------------------------------------------#
      when "ƒoƒbƒNƒCƒ“ƒT[ƒg","ƒfƒBƒ‹ƒhƒCƒ“ƒoƒbƒN"
        if target.is_a?(Game_Enemy) #ƒGƒlƒ~[‚ğƒz[ƒ‹ƒh‚·‚é
          case $mood.point
          when 50..100
            case $data_SDB[target.class_id].name
            when "I‚p", "Familiar", "Goblin", "Goblin Leader ", "Unique Tycoon "
              action = premess + ",\n\ pins do‚—n #{targetname}'s s‚all body fro‚ above!"
            when "Caster", "Little Witch", "Lili‚", "Slave "
              action = premess + ",\n\ pins do‚—n #{targetname}'s delicate body fro‚ above!"
            else
              action = premess + ",\n\ pins do‚—n #{targetname}'s body fro‚ above!"
            end
          else
            case $data_SDB[target.class_id].name
            when "I‚p", "Familiar", "Goblin", "Goblin Leader ", "Unique Tycoon "
              action = premess + ",\n\ pushes do‚—n #{targetname}'s s‚all body!"
            when "Caster", "Little Witch", "Lili‚", "Slave "
              action = premess + ",\n\ pushes do‚—n #{targetname}'s delicate body!"
            else
              action = premess + ",\n\ pushes do‚—n #{targetname}'s body!"
            end
          end
        elsif target.is_a?(Game_Actor) #ƒAƒNƒ^[‚ªƒz[ƒ‹ƒh‚³‚ê‚é
          case $mood.point
          when 50..100
            action = "#{targetname},\n\ has been pinned do‚—n by #{myname}!"
          else
            action = "#{targetname},\n\ has been pushed do‚—n by #{myname}!"
          end
        end
        avoid = ""
  #------------------------------------------------------------------------#
      when "ƒI[ƒ‰ƒ‹ƒCƒ“ƒT[ƒg","ƒfƒBƒ‹ƒhƒCƒ“ƒ}ƒEƒX"
        if skill.name == "ƒfƒBƒ‹ƒhƒCƒ“ƒ}ƒEƒX"
          penis_word = "ƒfƒBƒ‹ƒh"
        else
          penis_word = "ƒyƒjƒX"
        end
        if target.is_a?(Game_Enemy) #ƒGƒlƒ~[‚ğƒz[ƒ‹ƒh‚·‚é
          action = premess + "A‚»‚»‚è–u‚Â#{penis_word}‚ğ\n\m#{targetname}‚ÌŒûŒ³‚É“Ë‚«‚Â‚¯‚½I"
        elsif target.is_a?(Game_Actor) #ƒAƒNƒ^[‚ªƒz[ƒ‹ƒh‚³‚ê‚é
          action = premess + "A‚»‚»‚è–u‚Â#{penis_word}‚ğ\n\m#{targetname}‚ÌŒûŒ³‚É“Ë‚«o‚µ‚½I"
        end
        avoid = ""
  #------------------------------------------------------------------------#
      when "ƒGƒLƒTƒCƒgƒrƒ…["
        if target.is_a?(Game_Enemy) #ƒGƒlƒ~[‚ğƒz[ƒ‹ƒh‚·‚é
          case $mood.point
          when 50..100
            case $data_SDB[target.class_id].name
            when "I‚p", "Familiar", "Goblin", "Goblin Leader ", "Unique Tycoon "
              action = premess + ",\n\ pins do‚—n #{targetname}'s s‚all body fro‚ above!"
            when "Caster", "Little Witch", "Lili‚", "Slave "
              action = premess + ",\n\ pins do‚—n #{targetname}'s delicate body fro‚ above!"
            else
              action = premess + ",\n\ pins do‚—n #{targetname}'s body fro‚ above!"
            end
          else
            case $data_SDB[target.class_id].name
            when "I‚p", "Familiar", "Goblin", "Goblin Leader ", "Unique Tycoon "
              action = premess + ",\n\ pushes do‚—n #{targetname}'s s‚all body!"
            when "Caster", "Little Witch", "Lili‚", "Slave "
              action = premess + ",\n\ pushes do‚—n #{targetname}'s delicate body!"
            else
              action = premess + ",\n\ pushes do‚—n #{targetname}'s body!"
            end
          end
        elsif target.is_a?(Game_Actor) #ƒAƒNƒ^[‚ªƒz[ƒ‹ƒh‚³‚ê‚é
          if myself.full_nude?
            case $mood.point
            when 50..100
              if target == $game_actors[101]
              action = "Giving #{targetname} a full vie‚— of her nethers,\n\ #{myname} opens up her crotch ‚—ith her fingers\n\ and starts lo‚—ering herself over his face!"
              else
              action = "Giving #{targetname} a full vie‚— of her nethers,\n\ #{myname} opens up her crotch ‚—ith her fingers\n\ and starts lo‚—ering herself over her face!"
              end
            else
              if target == $game_actors[101]
              action = "Sho‚—ing #{targetname} a clear vie‚— of her nethers,\n\ #{myname} tries to ‚ash herself do‚—n\n\  on his face!"
              else
              action = "Sho‚—ing #{targetname} a clear vie‚— of her nethers,\n\ #{myname} tries to ‚ash herself do‚—n\n\  on her face!"
              end
            end
          else
            case $data_SDB[myself.class_id].name
            when "Caster","Familiar","Little Witch","Witch "
              action = "Standing over #{targetname}'s face,\n\ #{myname} lifts up her skirt to give him a clear vie‚—!"
            when "Lesser Succubus ","Succubus"
              action = "‚govering over #{targetname}'s face,\n\#{myname}'s revealing panties can be clearly seen!"
            when "I‚p","Devil "
              if target == $game_actors[101]
              action = "Flying over #{targetname}'s face,\n\#{myname} gives him a vie‚— bet‚—een her strong legs!"
              else
              action = "Flying over #{targetname}'s face,\n\#{myname} gives her a vie‚— bet‚—een her strong legs!"
              end
            when "Sli‚e"
              if target == $game_actors[101]
              action = "Slithering over #{targetname},\n\ #{myname} covers him in sli‚e and begins\n aligning herself\n\  to his head!"
              else
              action = "Slithering over #{targetname},\n\ #{myname} covers her in sli‚e and begins\n aligning herself\n\  to her head!"
              end
            when "Night‚are"
              action = "‚govering over #{targetname}'s face,\n\#{myname} offers an enticing vie‚— through her thin panties!"
            else
              if target == $game_actors[101]
              action = "#{myname} aligns herself over #{targetname}'s face,\n\ and begins to lo‚—er herself!"
              else
              action = "#{myname} aligns herself over #{targetname}'s face,\n\ and begins to lo‚—er herself!"
              end
            end
          end
        end
        avoid = ""
  #------------------------------------------------------------------------#
      when "ƒCƒ“ƒ‚ƒ‰ƒ‹ƒrƒ…["
        if target.is_a?(Game_Enemy) #ƒGƒlƒ~[‚ğƒz[ƒ‹ƒh‚·‚é
          case $mood.point
          when 50..100
            case $data_SDB[target.class_id].name
            when "I‚p", "Familiar", "Goblin", "Goblin Leader ", "Unique Tycoon "
              action = premess + ",\n\ pins do‚—n #{targetname}'s s‚all body fro‚ above!"
            when "Caster", "Little Witch", "Lili‚", "Slave "
              action = premess + ",\n\ pins do‚—n #{targetname}'s delicate body fro‚ above!"
            else
              action = premess + ",\n\ pins do‚—n #{targetname}'s body fro‚ above!"
            end
          else
            case $data_SDB[target.class_id].name
            when "I‚p", "Familiar", "Goblin", "Goblin Leader ", "Unique Tycoon "
              action = premess + ",\n\ pushes do‚—n #{targetname}'s s‚all body!"
            when "Caster", "Little Witch", "Lili‚", "Slave "
              action = premess + ",\n\ pushes do‚—n #{targetname}'s delicate body!"
            else
              action = premess + ",\n\ pushes do‚—n #{targetname}'s body!"
            end
          end
        elsif target.is_a?(Game_Actor) #ƒAƒNƒ^[‚ªƒz[ƒ‹ƒh‚³‚ê‚é
          case $mood.point
          when 50..100
            action = "Loo‚ing over #{targetname}'s eyes,\n\#{myname}'s ass dra‚—s closer!"
          else
            action = "Loo‚ing over #{targetname}'s eyes,\n\#{myname}'s ass dra‚—s closer!"
          end
        end
        avoid = ""
  #------------------------------------------------------------------------#
      when "ƒhƒƒEƒlƒNƒ^["
        if target.is_a?(Game_Enemy) #ƒGƒlƒ~[‚ğƒz[ƒ‹ƒh‚·‚é
          action = premess + ",\n\ buries face-first bet‚—een #{targetname}'s legs,\\n deep into her crotch!"
        elsif target.is_a?(Game_Actor) #ƒAƒNƒ^[‚ªƒz[ƒ‹ƒh‚³‚ê‚é
          if myself.positive?
            emotion = "eats out her pussy ‚—ith a seductive s‚ile"
          elsif myself.negative?
            emotion = "puckers her lips to plants a kiss"
          else
            emotion = "gingerly sticks out her tongue"
          end
          action = "Bringing her face closer to #{targetname}'s pussy,\n\ #{myname} #{emotion}!"
        end
        avoid = ""
  #------------------------------------------------------------------------#
      when "ƒI[ƒ‰ƒ‹ƒAƒNƒZƒvƒg"
        if target.is_a?(Game_Enemy) #ƒGƒlƒ~[‚ğƒz[ƒ‹ƒh‚·‚é
          action = premess + ",\n\ buries face-first bet‚—een #{targetname}'s legs,\\n deep into her crotch!"
        elsif target.is_a?(Game_Actor) #ƒAƒNƒ^[‚ªƒz[ƒ‹ƒh‚³‚ê‚é
          if myself.positive?
            emotion = "puckers her lips to plant a kiss"
          elsif myself.negative?
            emotion = "opens her ‚outh ‚—ide ‚—ith certainty"
          else
            emotion = "opens her ‚outh slo‚—ly"
          end
          action = "Bringing her face close to #{targetname}'s penis,\n\ #{myname} #{emotion}!"
        end
        avoid = ""
  #------------------------------------------------------------------------#
      when "ƒtƒ‰ƒbƒ^ƒiƒCƒY"
        if target.is_a?(Game_Enemy) #ƒGƒlƒ~[‚ğƒz[ƒ‹ƒh‚·‚é
          action = premess + ",\n\ pulls #{targetname} in close!"
          action = premess + ",\n\ turns #{targetname} around to ‚eet face-to-face!" if target.holding?
        elsif target.is_a?(Game_Actor) #ƒAƒNƒ^[‚ªƒz[ƒ‹ƒh‚³‚ê‚é
          if myself.positive?
            action = premess + ",\n\ pulls #{targetname} in close!"
          elsif myself.negative?
            action = premess + " closes her eyes,\n\ bringing her face close to #{targetname}'s lips!"
          else
            action = premess + ",\n\ pulls #{targetname} in close!"
          end
        end
        avoid = ""
  #------------------------------------------------------------------------#
      when "ƒGƒ“ƒuƒŒƒCƒX"
        if target.is_a?(Game_Enemy) #ƒGƒlƒ~[‚ğƒz[ƒ‹ƒh‚·‚é
          action = premess + ",\n\ clings to #{targetname} fro‚ the rear!"
          action = premess + ",\n\ bends over #{targetname}, e‚bracing her fro‚ behind!" if target.holding?
        elsif target.is_a?(Game_Actor) #ƒAƒNƒ^[‚ªƒz[ƒ‹ƒh‚³‚ê‚é
          action = "#{myname} clings to #{targetname} fro‚ the rear!"
          action = "#{myname} bends over #{targetname}, e‚bracing fro‚ behind!" if target.holding?
        end
        avoid = ""
  #------------------------------------------------------------------------#
      when "ƒyƒŠƒXƒR[ƒv"
        if target.is_a?(Game_Enemy) #ƒGƒlƒ~[‚ğƒz[ƒ‹ƒh‚·‚é
          action = premess + ",\n\ clings to #{targetname}'s ‚—aist!"
        elsif target.is_a?(Game_Actor) #ƒAƒNƒ^[‚ªƒz[ƒ‹ƒh‚³‚ê‚é
          action = "#{myname} tries to bury #{targetname}'s penis in her #{myself.bustsize}!"
        end
        avoid = ""
  #------------------------------------------------------------------------#
      when "ƒwƒuƒ“ƒŠ[ƒtƒB[ƒ‹"
        if target.is_a?(Game_Enemy) #ƒGƒlƒ~[‚ğƒz[ƒ‹ƒh‚·‚é
          action = premess + " extends out her arms,\n\ pressing down on #{targetname}!"
        elsif target.is_a?(Game_Actor) #ƒAƒNƒ^[‚ªƒz[ƒ‹ƒh‚³‚ê‚é
          action = premess + "\ tries to\n envelop #{targetname} in her #{myself.bustsize}!"
        end
        avoid = ""
  #------------------------------------------------------------------------#
      when "ƒfƒ‚ƒ“ƒYƒAƒuƒ\[ƒu"
        action = "#{myname} opens up a tentacle,\n\ and begins bringing it down over #{targetname}'s penis!"
        avoid = ""
  #------------------------------------------------------------------------#
      when "ƒfƒ‚ƒ“ƒYƒhƒƒE"
        action = "#{myname}'s tentacle wriggles suspiciously,\n\ then lunges at #{targetname}'s crotch!"
        avoid = ""
  #------------------------------------------------------------------------#
      when "ƒwƒuƒ“ƒŠ[ƒtƒB[ƒ‹"
        if target.is_a?(Game_Enemy) #ƒGƒlƒ~[‚ğƒz[ƒ‹ƒh‚·‚é
          action = premess + " extends out her arms,\n\ pressing down on #{targetname}!"
        elsif target.is_a?(Game_Actor) #ƒAƒNƒ^[‚ªƒz[ƒ‹ƒh‚³‚ê‚é
          action = premess + "\ tries to\n envelop #{targetname} in her #{myself.bustsize}!"
        end
        avoid = ""
  #------------------------------------------------------------------------#
      when "ƒŠƒŠ[ƒX"
        action = premess + " t‚—ists around,\\n in atte‚pt to separate fro‚ #{targetname}'s hold!"
        action = premess + " struggles about,\\n atte‚pting to escape fro‚ #{targetname}'s hold!" if myself.initiative_level == 0
        avoid = ""
  #------------------------------------------------------------------------#
      when "ƒCƒ“ƒ^ƒ‰ƒvƒg"
        if myself == $game_actors[101]
          for i in $game_party.actors
            if i.exist? and i != $game_actors[101]
              partner = i
            end
          end
          action = premess + "#{partner.name}‚ğ•ø‚«Šñ‚¹A\n\–§’…‚µ‚Ä‚¢‚é#{targetname}‚Æ—£‚»‚¤‚Æ‚İ‚½I"
        elsif myself.positive?
          action = premess + "v‚í‚¹‚Ô‚è‚È‘Ô“x‚ÅA\n\#{targetname}‚Ì‹C‚ğˆí‚ç‚»‚¤‚Æ‚İ‚½I"
        elsif myself.negative?
          action = premess + "#{$game_actors[101].name}‚É•ø‚«‚Â‚«A\n\#{targetname}‚Æ‚ÌŠÔ‚ÉŠ„‚Á‚Ä“ü‚ë‚¤‚Æ‚İ‚½I"
        else
          action = premess + "v‚í‚¹‚Ô‚è‚È‘Ô“x‚ÅA\n\#{targetname}‚Ì‹C‚ğˆí‚ç‚»‚¤‚Æ‚İ‚½I"
        end
        avoid = ""
      end
################################################################################
      # ¡ID‚Å”»’f
      case skill.id
  #------------------------------------------------------------------------#
      when 9     #ƒg[ƒN
        case $mood.point
        when 50..100
          action = premess + ",\n\ ‚—hispers quietly into #{targetname}'s ear!"
        else
          action = premess + ",\n\ starts speaking to #{targetname}!"
        end
        avoid = ""
  #------------------------------------------------------------------------#
      when 81    #ƒLƒbƒX
        held = ""
        if myself.holding?
          held = " changed posture,\n\ and"
        end
        case $mood.point
        when 50..100
          case myself.personality
          when "Ÿ‚¿‹C", "˜r”’", "‚–"
            action = premess + "#{held} aggressively presses a kiss against #{targetname}'s lips!"
          when "DF", "ŠÃ‚¦«"
            action = premess + "#{held} exchanged a passionate kiss ‚—ith #{targetname}!"
          when "’W”‘", "“à‹C", "—âÃ"
            action = premess + "#{held} gently presses her lips against #{targetname}'s!"
          else
            action = premess + "#{held} exchanged a strong kiss ‚—ith #{targetname}!"
          end
        else
          action = premess + "#{held} exchanged kisses ‚—ith #{targetname}!"
        end
  #------------------------------------------------------------------------#
      when 82    #ƒoƒXƒg
        brk2 = ""
        brk2 = "\n\" if targetname.size + target.bustsize.size > 36 and $mood.point >= 50 #‹¹•\Œ»‚Æ–²–‚–¼‚ğ‘«‚µ‚Ä‚P‚Q•¶š‰z‚¦
        if target.nude?
          if skill.element_set.include?(71) #è‚ğg—p
            if myself == $game_actors[101]
            action = premess + " uses his hands to caress #{targetname}'s\n\ #{target.bustsize}!"
            else
            action = premess + " uses her hands to caress\n\ #{targetname}'s #{target.bustsize}!"
            end
            action = premess + " reaches out a hand to caress\n\ #{targetname}'s #{target.bustsize}!" if myself.holding?
          elsif skill.element_set.include?(72) #Œû‚ğg—p
            if myself == $game_actors[101]
            action = premess + " caresses #{targetname}'s #{target.bustsize}\n\ ‚—ith his ‚outh!"
            else
            action = premess + " caresses #{targetname}'s\n\ #{target.bustsize} ‚—ith her ‚outh!"
            end
            if myself == $game_actors[101]
            action = premess + " shifts his body, suckling \n\#{targetname}'s #{target.bustsize} ‚—ith his ‚outh!" if myself.holding?
            else
            action = premess + " shifts her body, suckling \n\#{targetname}'s #{target.bustsize} ‚—ith her ‚outh!" if myself.holding?
            end
          end
        else
          if skill.element_set.include?(71) #è‚ğg—p
            if myself == $game_actors[101]
            action = premess + " uses his hands to caress #{targetname}'s\n\ #{target.bustsize} through her clothes!"
            else
              if target == $game_actors[101]
              action = premess + " uses her hands to caress\n\ #{targetname}'s #{target.bustsize} through his clothes!"
              else
              action = premess + " uses her hands to caress\n\ #{targetname}'s #{target.bustsize} through her clothes!"
              end
            end
            if target == $game_actors[101]
            action = premess + " reaches out a hand to caress #{targetname}'s\n\ #{target.bustsize}\n\ through his clothes!" if myself.holding?
            else
            action = premess + " reaches out a hand to caress\n\ #{targetname}'s #{target.bustsize}\n\ through her clothes!" if myself.holding?
            end
          elsif skill.element_set.include?(72) #Œû‚ğg—p
            if myself == $game_actors[101]
            action = premess + " uses his ‚outh to caress #{targetname}'s\n\ #{target.bustsize} through her clothes!"
            else
              if target == $game_actors[101]
              action = premess + " uses her ‚outh to caress\n\ #{targetname}'s #{target.bustsize} through his clothes!"
              else
              action = premess + " uses her ‚outh to caress\n\ #{targetname}'s #{target.bustsize} through her clothes!"
              end
            end
            if myself == $game_actors[101]
            action = "Shifting his body, he suckles \n\#{targetname}'s #{target.bustsize} through her\n\ clothes ‚—ith his ‚outh!" if myself.holding?
            else
              if target == $game_actors[101]
              action = "Shifting her body, she suckles \n\#{targetname}'s #{target.bustsize} through his\n\ clothes ‚—ith her ‚outh!" if myself.holding?
              else
              action = "Shifting her body, she suckles \n\#{targetname}'s #{target.bustsize} through her\n\ clothes ‚—ith her ‚outh!" if myself.holding?
              end
            end
          end
        end
        #ƒ€[ƒh‚É‚æ‚éU‚ß•û•Ï‰»f’f
        case $mood.point
        when 0..100#50..100
          action.gsub!("è‚Å","w‚Å") 
          action.gsub!("Œû‚Å","ã‚Å")
          #UŒ‚‘ÎÛØ‚è‘Ö‚¦
          if $game_variables[17] > 50
            action.gsub!("chest","nipples") 
            action.gsub!("youthful breasts","pretty nipples") 
            action.gsub!("shapely breasts","pointed nipples") 
            action.gsub!("round breasts","supple nipples") 
            action.gsub!("voluptuous breasts","supple nipples") 
            action.gsub!("incredible breasts","supple nipples") 
          end
          #«Šif’f
          case myself.personality
          when "Ÿ‚¿‹C", "˜r”’", "‚–"
            action.gsub!("ˆ¤•","rX‚µ‚­ˆ¤•") 
          when "DF", "_˜a"
            action.gsub!("ˆ¤•","‰‚ß‚©‚µ‚­ˆ¤•") 
          when "’W”‘", "“à‹C", "—âÃ", "ŠÃ‚¦«"
            action.gsub!("ˆ¤•","—D‚µ‚­ˆ¤•") 
          else
            action.gsub!("ˆ¤•","’š”J‚Éˆ¤•") 
          end
        end
        #ƒXƒ‰ƒCƒ€—pƒeƒLƒXƒg®Œ`
        if $data_SDB[target.class_id].name == "ƒXƒ‰ƒCƒ€"
          action.gsub!("•‰z‚µ‚É","”S‰t‚ğœ‚¯‚Â‚Â") 
        end
  #------------------------------------------------------------------------#
      when 83    #ƒqƒbƒv
        brk2 = ""
        brk2 = "\n\" if targetname.size > 24 and $mood.point >= 50 #‚W•¶š‰z‚¦‚Ì–²–‚–¼
        if target.nude?
          if skill.element_set.include?(71) #è‚ğg—p
            if myself == $game_actors[101]
            action = premess + " uses his hands to caress\n\ #{targetname}'s butt!"
            else
            action = premess + " uses her hands to caress\n\ #{targetname}'s butt!"
            end
            action = premess + " reaches out a hand to caress\n\ #{targetname}'s ass!" if myself.holding?
          elsif skill.element_set.include?(72) #Œû‚ğg—p
            if myself == $game_actors[101]
            action = premess + " uses his ‚outh to caress\n\ #{targetname}'s butt!"
            else
            action = premess + " uses her ‚outh to caress\n\ #{targetname}'s butt!"
            end
            if myself == $game_actors[101]
            action = premess + " shifts his body to caress #{targetname}'s\n\ ass ‚—ith his ‚outh!" if myself.holding?
            else
            action = premess + " shifts her body to caress\n\ #{targetname}'s ass ‚—ith her ‚outh!" if myself.holding?
            end
          end
        else
          if skill.element_set.include?(71) #è‚ğg—p
            if myself == $game_actors[101]
            action = premess + " uses his hands to caress #{targetname}'s\n\ ass through her #{pantsu}!"
            else
              if target == $game_actors[101]
              action = premess + " uses her hands to caress\n\ #{targetname}'s butt through his #{pantsu}!"
              else
              action = premess + " uses her hands to caress\n\ #{targetname}'s ass through her #{pantsu}!"
              end
            end
            if target == $game_actors[101]
            action = premess + " reaches out a hand to caress\n\ #{targetname}'s butt through his #{pantsu}!" if myself.holding?
            else
            action = premess + " reaches out a hand to caress\n\ #{targetname}'s ass through her #{pantsu}!" if myself.holding?
            end
          elsif skill.element_set.include?(72) #Œû‚ğg—p
            if myself == $game_actors[101]
            action = premess + " uses his ‚outh to caress #{targetname}'s\n\ ass through her #{pantsu}!"
            else
              if target == $game_actors[101]
              action = premess + " uses her ‚outh to caress\n\ #{targetname}'s butt through his #{pantsu}!"
              else
              action = premess + " uses her ‚outh to caress\n\ #{targetname}'s ass through her #{pantsu}!"
              end
            end
            if myself == $game_actors[101]
            action = premess + " shifts his body to caress #{targetname}'s\n\ ass through her #{pantsu}!" if myself.holding?
            else
              if target == $game_actors[101]
              action = premess + " shifts her body to caress\n\ #{targetname}'s butt through his #{pantsu}!" if myself.holding?
              else
              action = premess + " shifts her body to caress\n\ #{targetname}'s ass through her #{pantsu}!" if myself.holding?
              end
            end
          end
        end
        #ƒ€[ƒh‚É‚æ‚éU‚ß•û•Ï‰»f’f
        case $mood.point
        when 50..100
          action.gsub!("è‚Å","w‚Å") 
          action.gsub!("Œû‚Å","ã‚Å")
          #UŒ‚‘ÎÛØ‚è‘Ö‚¦
          if $game_variables[17] > 80
            action.gsub!("‚¨K","‹eÀ") 
          end
          #«Šif’f
          case myself.personality
          when "Ÿ‚¿‹C", "˜r”’", "‚–"
            action.gsub!("ˆ¤•","rX‚µ‚­ˆ¤•") 
          when "DF", "_˜a"
            action.gsub!("ˆ¤•","‰‚ß‚©‚µ‚­ˆ¤•") 
          when "’W”‘", "“à‹C", "—âÃ", "ŠÃ‚¦«"
            action.gsub!("ˆ¤•","—D‚µ‚­ˆ¤•") 
          else
            action.gsub!("ˆ¤•","’š”J‚Éˆ¤•") 
          end
        end
  #------------------------------------------------------------------------#
      when 84    #ƒNƒƒbƒ`
        brk2 = ""
        brk2 = "\n\" if targetname.size > 24 and $mood.point >= 50 #‚W•¶š‰z‚¦‚Ì–²–‚–¼
        if target.nude?
          if skill.element_set.include?(71) #è‚ğg—p
            if myself == $game_actors[101]
            action = premess + " uses his hands\n\ to caress #{targetname}'s crotch!"
            else
            action = premess + " uses her hands\n\ to caress #{targetname}'s crotch!"
            end
            action = premess + " reaches out a hand to\n\ caress #{targetname}'s crotch!" if myself.holding?
          elsif skill.element_set.include?(72) #Œû‚ğg—p
            if myself == $game_actors[101]
            action = premess + " uses his ‚outh\n\ to caress #{targetname}'s crotch!"
            else
            action = premess + " uses her ‚outh\n\ to caress #{targetname}'s crotch!"
            end
            if myself == $game_actors[101]
            action = premess + " shifts his body to caress\n\ #{targetname}'s crotch ‚—ith his ‚outh!" if myself.holding?
            else
            action = premess + " shifts her body to caress\n\ #{targetname}'s crotch ‚—ith her ‚outh!" if myself.holding?
            end
          end
        else
          if skill.element_set.include?(71) #è‚ğg—p
            if myself == $game_actors[101]
            action = premess + " uses his hands to caress #{targetname}'s\n\ pussy through her #{pantsu}!"
            else
              if target == $game_actors[101]
              action = premess + " uses her hands to caress\n\ #{targetname}'s penis through his #{pantsu}!"
              else
              action = premess + " uses her hands to caress\n\ #{targetname}'s pussy through her #{pantsu}!"
              end
            end
            if target == $game_actors[101]
            action = premess + " reaches out a hand to caress\n\ #{targetname}'s penis through his #{pantsu}!" if myself.holding?
            else
            action = premess + " reaches out a hand to caress\n\ #{targetname}'s pussy through her #{pantsu}!" if myself.holding?
            end
          elsif skill.element_set.include?(72) #Œû‚ğg—p
            if myself == $game_actors[101]
            action = premess + " uses his ‚outh to caress #{targetname}'s\n\ pussy through her #{pantsu}!"
            else
              if target == $game_actors[101]
              action = premess + " uses her ‚outh to caress\n\ #{targetname}'s penis through his #{pantsu}!"
              else
              action = premess + " uses her ‚outh to caress\n\ #{targetname}'s pussy through her #{pantsu}!"
              end
            end
            if myself == $game_actors[101]
            action = premess + " shifts his body to caress\n\ #{targetname}'s pussy through her #{pantsu}!" if myself.holding?
            else
              if target == $game_actors[101]
              action = premess + " shifts her body to caress\n\ #{targetname}'s penis through his #{pantsu}!" if myself.holding?
              else
              action = premess + " shifts her body to caress\n\ #{targetname}'s pussy through her #{pantsu}!" if myself.holding?
              end
            end
          end
        end
        #ƒ€[ƒh‚É‚æ‚éU‚ß•û•Ï‰»f’f
        case $mood.point
        when 50..100
          action.gsub!("è‚Å","w‚Å") 
          action.gsub!("Œû‚Å","ã‚Å")
          #UŒ‚‘ÎÛØ‚è‘Ö‚¦
          if $game_variables[17] > 50
            action.gsub!("ƒAƒ\ƒR","‰AŠj") 
          end
          #«Šif’f
          case myself.personality
          when "Ÿ‚¿‹C", "˜r”’", "‚–"
            action.gsub!("ˆ¤•","rX‚µ‚­ˆ¤•") 
          when "DF", "_˜a"
            action.gsub!("ˆ¤•","‰‚ß‚©‚µ‚­ˆ¤•") 
          when "’W”‘", "“à‹C", "—âÃ", "ŠÃ‚¦«"
            action.gsub!("ˆ¤•","—D‚µ‚­ˆ¤•") 
          else
            action.gsub!("ˆ¤•","’š”J‚Éˆ¤•") 
          end
        end
  #------------------------------------------------------------------------#
      when 52    #ƒVƒFƒ‹ƒ}ƒbƒ`AƒXƒNƒ‰ƒbƒ`(ƒz[ƒ‹ƒh)
        action = premess + "#{brk}#{targetname}‚Æ‹r‚ğ—‚ß‚ ‚¢A\n\ƒAƒ\ƒR‚ğC‚è‡‚í‚¹‚½I"
        if $mood.point > 50
          #«Šif’f
          case myself.personality
          when "Ÿ‚¿‹C", "‚–"
            action.gsub!("C‚è‡‚í‚¹","Œƒ‚µ‚­C‚è‡‚í‚¹") 
          when "DF", "_˜a"
            action.gsub!("C‚è‡‚í‚¹","‰‚ß‚©‚µ‚­C‚è‡‚í‚¹") 
          when "ã•i", "ˆÓ’nˆ«"
            action.gsub!("C‚è‡‚í‚¹","Å‚ç‚·‚æ‚¤‚ÉC‚è‡‚í‚¹") 
          when "’W”‘", "“à‹C", "ŠÃ‚¦«"
            action.gsub!("C‚è‡‚í‚¹","‚ä‚Á‚­‚è‚ÆC‚è‡‚í‚¹") 
          else
            action.gsub!("C‚è‡‚í‚¹","C‚è‡‚í‚¹") 
          end
        end
  #------------------------------------------------------------------------#
      when 32,35,37,41,47,34,38 #ƒXƒEƒBƒ“ƒOAƒOƒ‰ƒCƒ“ƒh
        if myself == $game_actors[101]
          action = premess + " thrusts his pelvis!"
        else
          action = premess + " shakes her waist!"
        end
        if $mood.point > 50
          #«Šif’f
          case myself.personality
          when "Ÿ‚¿‹C", "˜r”’"
            action.gsub!("˜‚ğ","rX‚µ‚­˜‚ğ") 
          when "DF", "_˜a"
            action.gsub!("˜‚ğ","‰‚ß‚©‚µ‚­˜‚ğ") 
          when "—âÃ", "ˆÓ’nˆ«"
            action.gsub!("˜‚ğ","ŠÉ‹}•t‚¯‚Ä˜‚ğ") 
          when "“à‹C", "ŠÃ‚¦«", "“V‘R"
            action.gsub!("˜‚ğ","ˆêŠŒœ–½‚É˜‚ğ") 
          else
            action.gsub!("˜‚ğ","Œƒ‚µ‚­˜‚ğ") 
          end
        end
      when 33 #ƒwƒ”ƒBƒXƒEƒBƒ“ƒO
        action = premess + "‘å‚«‚­˜‚ğU‚Á‚½I"
        if $mood.point > 50
          #«Šif’f
          case myself.personality
          when "Ÿ‚¿‹C", "˜r”’"
            action.gsub!("‘å‚«‚­˜‚ğ","’@‚«‚Â‚¯‚é‚æ‚¤‚É˜‚ğ") 
          when "DF", "_˜a"
            action.gsub!("‘å‚«‚­˜‚ğ","‚¤‚Ë‚é‚æ‚¤‚É˜‚ğ") 
          when "—âÃ", "ˆÓ’nˆ«"
            action.gsub!("‘å‚«‚­˜‚ğ","Å‰œ‚ğ“Ë‚­‚æ‚¤‚É˜‚ğ") 
          when "“à‹C", "ŠÃ‚¦«", "“V‘R"
            action.gsub!("‘å‚«‚­˜‚ğ","ˆêS•s—‚É˜‚ğ") 
          else
            action.gsub!("‘å‚«‚­˜‚ğ","Œƒ‚µ‚­˜‚ğ") 
          end
        end
  #------------------------------------------------------------------------#
      when 55   #ƒ‰ƒCƒfƒBƒ“ƒO
        if myself.nude?
          action = "Straddling #{targetname}'s face,\n\ #{myname} shakes her hips back and forth!"
          action = "Riding on top of #{targetname}'s face,\n\ #{myname} grinds her hips back and forth!" if $mood.point > 50
        else
          case $data_SDB[myself.class_id].name
          when "Caster","Familiar","Little Witch","Witch "
            action = "Fro‚ underneath her skirt,\n\ #{myname} presses her undergar‚ents against\n\ #{targetname}'s ‚outh!"
          when "Lesser Succubus ","Succubus"
            action = "#{myname} drops do‚—n, pressing\n\ her #{pantsu} against #{targetname}'s ‚outh!"
          when "I‚p","Devil "
            action = "#{myname} drops do‚—n, pressing\n\ her #{pantsu} against #{targetname}'s ‚outh!"
          when "Sli‚e"
            action = "Riding on top of #{targetname}'s face,\n\ #{myname} presses her pussy into\n\ #{targetname}'s ‚outh!"
          when "Night‚are"
            action = "#{myname} drops do‚—n, pressing\n\ her #{pantsu} against #{targetname}'s ‚outh!"
          else
            action = "#{myname} drops do‚—n, pressing\n\ her pussy against #{targetname}'s ‚outh!"
          end
        end
  #------------------------------------------------------------------------#
      when 91   #ƒc[ƒpƒt
        #ˆê•”«Ši‚ÅŠî–{ƒeƒLƒXƒg•ªŠò
        case myself.personality
        when "Ÿ‚¿‹C", "‚–", "ˆÓ’nˆ«"
          action = premess + " pushes #{targetname}'s face\n\ bet‚—een her #{myself.bustsize}!"
        else
          action = premess + " ‚—raps #{targetname}'s face\n\ bet‚—een her #{myself.bustsize}!"
        end
  #------------------------------------------------------------------------#
      when 71,61   #ƒŠƒbƒN
        if target.full_nude?
          case $mood.point
          when 50..100
            if myself == $game_actors[101]
            action = premess + " licks #{targetname}'s\n\ pussy ‚—ith his tongue!"
            else
            action = premess + " licks #{targetname}'s\n\ pussy ‚—ith her tongue!"
            end
          else
            if myself == $game_actors[101]
            action = premess + " caresses #{targetname}'s\n\ pussy ‚—ith his tongue!"
            else
            action = premess + " caresses #{targetname}'s\n\ pussy ‚—ith her tongue!"
            end
          end
          #UŒ‚‘ÎÛØ‚è‘Ö‚¦
          if $game_variables[17] > 50
            action.gsub!("ƒAƒ\ƒR","‰AŠj") 
          end
        else
          case $data_SDB[target.class_id].name
          when "Sli‚e"
            if myself == $game_actors[101]
            action = "Through her thick sli‚e, #{myname}\n\ pushes against #{targetname}'s pussy ‚—ith his tongue!"
            else
            action = "Through her thick sli‚e, #{myname}\n\ pushes against #{targetname}'s pussy ‚—ith her tongue!"
            end
          when "Night‚are"
            if myself == $game_actors[101]
            action = "Through her thin loin cloth, #{myname}\n\ pushes against #{targetname}'s pussy ‚—ith his tongue!"
            else
            action = "Through her thin loin cloth, #{myname}\n\ pushes against #{targetname}'s pussy ‚—ith her tongue!"
            end
          else
            if myself == $game_actors[101]
            action = "Through her #{pantsu}, #{myname}\n\ pushes against #{targetname}'s pussy ‚—ith his tongue!"
            else
            action = "Through her #{pantsu}, #{myname}\n\ pushes against #{targetname}'s pussy ‚—ith her tongue!"
            end
          end
        end
        avoid = ""
  #------------------------------------------------------------------------#
      when 72   #ƒŠƒbƒN(‘ÎK)
        case $mood.point
        when 50..100
          if myself == $game_actors[101]
          action = premess + " pushes against #{targetname}'s\n\ sphincter ‚—ith his tongue!"
          else
          action = premess + " pushes against #{targetname}'s\n\ sphincter ‚—ith her tongue!"
          end
        else
          if myself == $game_actors[101]
          action = premess + " caresses #{targetname}'s\n\ sphincter ‚—ith his tongue!"
          else
          action = premess + " caresses #{targetname}'s\n\ sphincter ‚—ith her tongue!"
          end
        end
        avoid = ""
  #------------------------------------------------------------------------#
      when 73   #ƒ~ƒXƒ`[ƒt
        case $mood.point
        when 50..100
          action = premess + " reaches out with her hand,\n\ and caresses #{targetname}'s crotch!"
          if myself == $game_actors[101]
          action = premess + " embraces #{targetname} closely,\n\ and forces her tongue in his mouth!" if $game_variables[17] > 50
          else
          action = premess + " embraces #{targetname} closely,\n\ and forces her tongue in her mouth!" if $game_variables[17] > 50
          end
        else
          action = premess + " reaches out,\n\ softly stroking #{targetname}'s thighs!"
          if myself == $game_actors[101]
          action = premess + " holds back #{targetname} with her arms\n\ as she fondles her #{target.bustsize}!" if $game_variables[17] > 50
        else
          action = premess + " holds down #{targetname}\n\ with her arms while she rubs his #{target.bustsize}!" if $game_variables[17] > 50
          end
        end
        avoid = ""
  #------------------------------------------------------------------------#
      when 74   #ƒŠƒAƒJƒŒƒX
        case $mood.point
        when 50..100
          action = premess + " caresses #{targetname}'s\n\ crotch from the rear!"
          action = premess + " turns around, \n\ and tries to kiss #{targetname}!" if $game_variables[17] > 50
        else
          action = premess + "Œã‚ëè‚ÅA\n\#{targetname}‚Ì‘¾ŒÒ‚ğ—D‚µ‚­•‚Å‰ñ‚µ‚½I"
          action = premess + "‘Ì‚ğ‚æ‚¶‚èA\n\#{targetname}‚Ì#{target.bustsize}‚ğhŒƒ‚µ‚½I" if $game_variables[17] > 50
        end
        avoid = ""
  #------------------------------------------------------------------------#
      when 641   #ƒfƒ‚ƒ“ƒYƒXƒ[ƒg
        action = "#{myname}‚Ì‘€‚éGè‚ªA\n\#{targetname}‚ÌƒyƒjƒX‚ğŠÔ’f‚È‚­‹z‚¢ã‚°‚Ä‚¢‚éI"
        action = "#{myname}‚Ì‘€‚éGè‚Ì‚Ğ‚¾‚ªA\n\#{targetname}‚ÌƒyƒjƒX‚ğâ‚¦ŠÔ‚È‚­hŒƒ‚µ‚Ä‚¢‚éI"  if $game_variables[17] > 50
        avoid = ""
  #------------------------------------------------------------------------#
      when 642   #ƒfƒ‚ƒ“ƒYƒTƒbƒN
        action = "#{myname}‚Ì‘€‚éGè‚ªA\n\#{targetname}‚ÌƒAƒ\ƒR‚ğŠÔ’f‚È‚­‹z‚¢‘±‚¯‚Ä‚¢‚éI"
        action = "#{myname}‚Ì‘€‚éGè‚Ì‚Ğ‚¾‚ªA\n\#{targetname}‚ÌƒAƒ\ƒR‚ğâ‚¦ŠÔ‚È‚­ˆ¤•‚µ‚Ä‚¢‚éI"  if $game_variables[17] > 50
        avoid = ""
  #------------------------------------------------------------------------#
      when 79   #ƒŒƒbƒNƒŒƒX
        if myself == $game_actors[101]
        action = premess + "  shifts his body around, \n\ trying to change posture!"
        else
        action = premess + "  shifts her body around, \n\ trying to change posture!"
        end
        avoid = ""
  #------------------------------------------------------------------------#
      when 101   #ƒeƒB[ƒY
        action = premess + ",\n\ teasingly caresses #{targetname}!"
        avoid = ""
  #------------------------------------------------------------------------#
      when 104   #ƒgƒŠƒbƒNƒŒƒCƒh
        action = premess + ",\n\ suddenly attacks #{targetname}!"
        avoid = ""
  #------------------------------------------------------------------------#
      when 106   #ƒfƒBƒoƒEƒA[
        action = premess + " voraciously gropes and \n\ rubs down #{targetname}'s body!"
        avoid = ""
  #------------------------------------------------------------------------#
      when 121   #ƒuƒŒƒX
        action = "#{myname} takes a deep breath!"
        avoid = ""
  #------------------------------------------------------------------------#
      when 122   #ƒJ[ƒ€ƒuƒŒƒX
        if myself == $game_actors[101]
        action = "#{myname} inhales deeply,\n\ calming his breathing!"
        else
        action = "#{myname} inhales deeply,\n\ calming her breathing!"
        end
        avoid = ""
  #------------------------------------------------------------------------#
      when 123   #ƒEƒFƒCƒg
        action = "#{myname} ‚—aits and observes..."
        avoid = ""
  #------------------------------------------------------------------------#
      when 124   #ƒCƒ“ƒgƒ‰ƒXƒg
        if myself == $game_actors[101]
        action = "#{myname} relaxes his body!"
        else
        action = "#{myname} relaxes her body!"
        end
        avoid = ""
  #------------------------------------------------------------------------#
      when 125   #ƒŠƒtƒŒƒbƒVƒ…
        if myself == $game_actors[101]
        action = "#{myname} calms his mind,\n\ clearing it of all abnormalities!"
        else
        action = "#{myname} calms her mind,\n\ clearing it of all abnormalities!"
        end
        avoid = ""
  #------------------------------------------------------------------------#
      when 126   #ƒ`ƒFƒbƒN
        action = premess + " inspects #{targetname}!"
        avoid = ""
  #------------------------------------------------------------------------#
      when 127   #ƒAƒiƒ‰ƒCƒY
        action = premess + " exhaustively analyzes #{targetname}!"
        avoid = ""
  #------------------------------------------------------------------------#
      when 140   #ƒeƒ“ƒvƒe[ƒVƒ‡ƒ“
        action = premess + "A\n\#{targetname}‚É‰‚ß‚©‚µ‚­‘Ì‹ë‚ğ–£‚¹‚Â‚¯‚½I"
        avoid = "‚µ‚©‚µ#{myname}‚É‚ÍŒø‚©‚È‚©‚Á‚½I"
  #------------------------------------------------------------------------#
      when 145   #ƒK[ƒh
        action = premess + " took a defensive stance!"
        avoid = ""
  #------------------------------------------------------------------------#
      when 146   #ƒCƒ“ƒfƒ…ƒA
        if myself == $game_actors[101]
        action = premess + " closed his eyes, focusing his ‚ind!"
        else
        action = premess + " closed her eyes, focusing her ‚ind!"
        end
        avoid = ""
  #------------------------------------------------------------------------#
      when 148   #ƒAƒs[ƒ‹
        case $data_classes[myself.class_id].name
        when "Lesser Succubus "
          action = premess + " poses suggestively!"
        when "Succubus" #
          action = premess + " ‚akes a suggestive pose!"
        when "I‚p" #
          action = premess + " pesters the ene‚y to\n\ play ‚—ith her!"
        when "Devil " #
          action = premess + " ‚akes a provocative pose!"
        when "Sli‚e" #
          action = premess + " poses suggestively!"
        when "Night‚are" #
          action = premess + " invites the ene‚y ‚—ith\n\ her sleepy eyes!"
        when "Caster" #
          action = premess + " pretends to be frightened!"
          action = premess + " invites the ene‚y ‚—ith\n\ her defenseless appearance!" if myself.nude?
        when "Little Witch" #
          action = premess + " did a provocative pose!"
        when "Witch " #
          action = premess + " ‚akes a provocative pose!"
        when "Familiar" #
          action = premess + " tucks up the he‚ of her dress!"
          action = premess + " invites the ene‚y ‚—ith\n\ her defenseless appearance!" if myself.nude?
        when "Unique Succubus " #
          action = premess + " ‚akes a suggestive pose!"
        else
          action = premess + " ‚akes a suggestive pose!"
        end
        n = 0
=begin
        s_range = myself.is_a?(Game_Enemy) ? $game_troop.enemies : $game_party.party_actors
        for i in s_range
          if i.exist?
            n += 1
          end
        end
        s_range_text = n > 1 ? "‚½‚¿" : ""
        action += "\n\–²–‚#{s_range_text}‚Ì‹»–¡‚ª#{myname}‚ÉˆÚ‚Á‚½I" if myself.is_a?(Game_Actor)
        action += "\n\#{$game_actors[101].name}#{s_range_text}‚Í–Ú‚ğˆø‚«‚Â‚¯‚ç‚ê‚Ä‚µ‚Ü‚Á‚½I" if myself.is_a?(Game_Enemy)
=end
        avoid = ""
      when 149   #ƒvƒƒ”ƒH[ƒN
          action = premess + " provokes the ene‚y into attacking her!"
        
        
  #------------------------------------------------------------------------#        
      when 260   #•i’è‚ß
        action = premess + " checks out #{targetname}!"
  #------------------------------------------------------------------------#        
      when 261   #è‚Ù‚Ç‚«
        action = premess + "\n\#{targetname}‚Ìè‚ğæ‚èè‚Ù‚Ç‚«‚ğ‚µ‚½I"
  #------------------------------------------------------------------------#        
      when 262   #ŠÃ‚â‚©‚µ
        action = premess + "\n\#{targetname}‚Ì“ª‚ğ‚»‚Á‚Æ•‚ÅŠÃ‚â‚©‚µ‚½I"
  #------------------------------------------------------------------------#        
      when 263   #ƒXƒpƒ“ƒN
        action = premess + " gives #{targetname} a strong spank!"
  #------------------------------------------------------------------------#        
      when 275   #‚â‚¯‚­‚»‚R˜AŒ‚
        action = premess + "k‚¦‚È‚ª‚çŒã‚¸‚³‚è‚ğ‚µ‚Ä‚¢‚éI"
  #------------------------------------------------------------------------#        
      when 276   #ƒq[ƒ[ƒLƒŠƒ“ƒO
        action = premess + "EˆÓ‚ğ‚ß‚½˜r‚ğU‚è‚©‚Ô‚Á‚½I\n\h–½‚ğ’fâ‚·‚éˆêŒ‚‚ª#{targetname}‚É•ú‚½‚ê‚éII"
  #------------------------------------------------------------------------#        
      when 277   #ƒƒeƒIƒGƒNƒŠƒvƒX
        action = premess + "‰ó–Å‚Ì–‚–@‚ğ‰r¥‚µ‚½I\n\“V‚ÍŠ„‚ê¯‚ÍÓ‚¯A‰ó–Å‚ÌÜ”M‚ª¢ŠE‚ğˆù‚İ‚ŞI"
  #------------------------------------------------------------------------#        
      when 278   #ƒ[ƒ‹ƒhƒuƒŒƒCƒJ[
        action = premess + "’´‘å‚È–‚—Í‚ğ•úo‚µ‚½I\n\‘Sl—Ş‚ÌŠó–]‚ğA—E‹C‚ğA–¢—ˆ‚ğI\n\ÕŒ`‚à–³‚­‘’‚è‹‚éII"
  #------------------------------------------------------------------------#        
      when 297   #ƒtƒBƒA[(ˆØ•|s“®•úŠü)
        action = premess + "g‘Ì‚ªv‚¤‚æ‚¤‚É“®‚©‚È‚¢I"
  #------------------------------------------------------------------------#        
      when 298   #ƒtƒŠ[ƒAƒNƒVƒ‡ƒ“
        case $data_classes[myself.class_id].name
        when "Lesser Succubus "
          action = premess + " curiously flies around #{targetname}...."
          action = premess + "A\n\‰Hª‚ğ“®‚©‚µ‚Ä—V‚ñ‚Å‚¢‚écc" if $game_variables[17] >= 50
        when "Succubus" #
          action = premess + " s‚iles alluringly...."
          action = premess + " is groo‚ing her tail...." if $game_variables[17] >= 50
        when "Succubus Lord " #
          action = premess + " ‚—ears a captivating s‚ile...."
          action = premess + " is groo‚ing her tail...." if $game_variables[17] >= 50
        when "I‚p" #
          action = premess + "A\n\#{targetname}‚ÌüˆÍ‚ğ”ò‚Ñ‰ñ‚Á‚Ä‚¢‚écc"
          action = premess + "A\n\‰Hª‚ğ“®‚©‚µ‚Ä—V‚ñ‚Å‚¢‚écc" if $game_variables[17] >= 50
        when "Devil " #
          action = premess + " ‚—atches #{targetname} appraisingly, observing hi‚..."
          action = premess + " s‚iles ‚ysteriously at #{targetname}...." if $game_variables[17] >= 50
        when "De‚on" #
          action = premess + " ‚—atches #{targetname} appraisingly, observing hi‚..."
          action = premess + " s‚iles ‚ysteriously at #{targetname}...." if $game_variables[17] >= 50
        when "Sli‚e" #
          action = premess + "g‘Ì‚ğ‚Õ‚é‚Õ‚éU‚é‚í‚¹‚Ä‚¢‚écc"
          action = premess + "A\n\©•ª‚Ìg‘Ì‚ğFX‚ÈŒ`‚É•Ï‚¦‚Ä—V‚ñ‚Å‚¢‚écc" if $game_variables[17] >= 50
        when "Gold Sli‚e " #
          action = premess + "g‘Ì‚ğ‚Õ‚é‚Õ‚éU‚é‚í‚¹‚Ä‚¢‚écc"
          action = premess + "A\n\©•ª‚Ìg‘Ì‚ğFX‚ÈŒ`‚É•Ï‚¦‚Ä—V‚ñ‚Å‚¢‚écc" if $game_variables[17] >= 50
        when "Night‚are" #
          action = premess + " floats about, staring listlessly...."
          action = premess + " stares at #{targetname}'s\\n face ‚—ith sleepy eyes...." if $game_variables[17] >= 50
        when "Caster" #
          action = premess + " is tidying up her clothes..." if not myself.nude?
          action = premess + ", as through having just noticed, quickly starts fixing her clothes..." if not myself.nude? and $mood.point > 25
          action = premess + " see‚s so‚e‚—hat restless...." if myself.nude?
        when "Slave " #
          action = premess + "•‚Ì—‚ê‚ğ’¼‚µ‚Ä‚¢‚écc" if not myself.nude?
          action = premess + "v‚¢o‚µ‚½‚©‚Ì‚æ‚¤‚ÉA\n\Q‚Ä‚Ä•‚Ì—‚ê‚ğ’¼‚µn‚ß‚½cc" if not myself.nude? and $mood.point > 25
          action = premess + "‰½‚¾‚©‚»‚í‚»‚í‚µ‚Ä‚¢‚écc" if myself.nude?
        when "Little Witch" #
          action = premess + "’l“¥‚İ‚ğ‚·‚é‚æ‚¤‚ÉA\n\#{targetname}‚ğŠÏ@‚µ‚Ä‚¢‚écc"
          action = premess + "–Xq‚Ìè“ü‚ê‚ğn‚ß‚½cc" if $game_variables[17] >= 50
        when "Witch " #
          action = premess + "’l“¥‚İ‚ğ‚·‚é‚æ‚¤‚ÉA\n\#{targetname}‚ğŠÏ@‚µ‚Ä‚¢‚écc"
          action = premess + "–Xq‚Ìè“ü‚ê‚ğn‚ß‚½cc" if $game_variables[17] >= 50
        when "Familiar" #
          action = premess + "#{targetname}‚Ì—lq‚ğ‰M‚¢A\n\‰½‚â‚çl‚¦‚ñ‚Å‚¢‚écc"
          action = premess + "‚»‚Á‚Æ’…ˆß‚Ì—‚ê‚ğ’¼‚µ‚½cc" if not myself.nude?
          action = premess + "Ã‚©‚É‚½‚½‚¸‚ñ‚Å‚¢‚écc" if $game_variables[17] >= 50
        when "Werewolf" #
          action = premess + "šX‚èº‚ğã‚°‚Ä‚¢‚écc"
          action = premess + "K”ö‚ğU‚Á‚Ä‚¢‚écc" if $game_variables[17] >= 50
        when "Werecat " #
          action = premess + "–Ñ‘U‚¢‚ğ‚µ‚Ä‚¢‚écc"
          action = premess + "‚²‚ë‚²‚ë‚ÆA‚ğ–Â‚ç‚µ‚Ä‚¢‚écc" if $game_variables[17] >= 50
        when "Goblin" #
          action = premess + "—lq‚ğ‰M‚Á‚Ä‚¢‚écc"
          action = premess + "^‚Á’¼‚®‚ÉA\n\#{targetname}‚ÌŠç‚ğŒ©‚Â‚ß‚Ä‚¢‚écc" if $game_variables[17] >= 50
        when "Goblin Leader " #
          action = premess + "—lq‚ğ‰M‚Á‚Ä‚¢‚écc"
          action = premess + "^‚Á’¼‚®‚ÉA\n\#{targetname}‚ÌŠç‚ğŒ©‚Â‚ß‚Ä‚¢‚écc" if $game_variables[17] >= 50
        when "Priestess " #
          action = premess + "—lq‚ğ‰M‚Á‚Ä‚¢‚écc"
          action = premess + "•‚Ì—‚ê‚ğ’¼‚µ‚Ä‚¢‚écc" if not myself.nude?
          action = premess + "—â’W‚È–Ú‚Â‚«‚ÅA\n\#{targetname}‚ğŒ©‚Â‚ß‚Ä‚¢‚écc" if $game_variables[17] >= 50
        when "Cursed Magus" #
          action = premess + "’l“¥‚İ‚ğ‚·‚é‚æ‚¤‚ÉA\n\#{targetname}‚ğŠÏ@‚µ‚Ä‚¢‚écc"
          action = premess + "#{targetname}‚ÉA\n\—d‚µ‚°‚ÈÎ‚İ‚ğŒü‚¯‚Ä‚¢‚écc" if $game_variables[17] >= 50
        when "Alraune " #
          action = premess + "ƒjƒRƒŠ‚Æ”÷Î‚ğ•‚‚©‚×‚½cc"
          action = premess + "•s“G‚ÈÎ‚İ‚ğ•‚‚©‚×‚Ä‚¢‚écc" if $game_variables[17] >= 50
        when "Matango " #
          action = premess + "•‚Ì—‚ê‚ğ’¼‚µ‚Ä‚¢‚écc" if not myself.nude?
          action = premess + "v‚¢o‚µ‚½‚©‚Ì‚æ‚¤‚ÉA\n\Q‚Ä‚Ä•‚Ì—‚ê‚ğ’¼‚µn‚ß‚½cc" if not myself.nude? and $mood.point > 25
          action = premess + "‰½‚¾‚©‚»‚í‚»‚í‚µ‚Ä‚¢‚écc" if myself.nude?
        when "Dark Angel" #
          action = premess + "‘÷‚Á‚½–Ú‚Â‚«‚Å”÷Î‚ñ‚Å‚¢‚écc"
          action = premess + "•s“G‚ÈÎ‚İ‚ğ•‚‚©‚×‚Ä‚¢‚écc" if $game_variables[17] >= 50
        when "Gargoyle" #
          action = premess + "Œx‰ú‚·‚é‚æ‚¤‚ÉA\n\#{targetname}‚ğŠÏ@‚µ‚Ä‚¢‚écc"
          action = premess + "—â’W‚È–Ú‚Â‚«‚ÅA\n\#{targetname}‚ğŒ©‚Â‚ß‚Ä‚¢‚écc" if $game_variables[17] >= 50
        when "Mi‚ic" #
          action = premess + "åÁ˜f“I‚ÈÎ‚İ‚ğ•‚‚©‚×‚Ä‚¢‚écc"
          action = premess + "•ó” ‚Ì’†‚ğŠm”F‚µ‚Ä‚¢‚écc" if $game_variables[17] >= 50
        when "Ta‚a‚o" #
          action = premess + "’l“¥‚İ‚ğ‚·‚é‚æ‚¤‚ÉA\n\#{targetname}‚ğŠÏ@‚µ‚Ä‚¢‚écc"
          action = premess + "‚ä‚ç‚ä‚ç‚ÆK”ö‚ğ—h‚ç‚µ‚Ä‚¢‚écc" if $game_variables[17] >= 50
        when "Lili‚"
          action = premess + "A\n\#{targetname}‚ÌüˆÍ‚ğ”ò‚Ñ‰ñ‚Á‚Ä‚¢‚écc"
          action = premess + "åÁ˜f“I‚ÈÎ‚İ‚ğ•‚‚©‚×‚Ä‚¢‚écc"if $game_variables[17] >= 50
        else
          action = premess + "—lq‚ğ‰M‚Á‚Ä‚¢‚écc"
          # ƒ†ƒj[ƒNƒGƒlƒ~[
          case $data_classes[myself.class_id].color
          when "Neijorange"
            action = premess + "ƒjƒRƒŠ‚Æ”÷Î‚ğ•‚‚©‚×‚½cc"
            action = premess + "‚ä‚ç‚ä‚ç‚Æ—h‚ê‚Ä‚¢‚écc" if $game_variables[17] >= 50
          when "Rejeo "
            action = premess + "—lq‚ğ‰M‚Á‚Ä‚¢‚écc"
            action = premess + "’l“¥‚İ‚ğ‚·‚é‚æ‚¤‚ÉA\n\#{targetname}‚ğŠÏ@‚µ‚Ä‚¢‚écc" if $game_variables[17] >= 50
          when "Fulbeua "
            action = premess + "’§”­“I‚È–Ú‚Â‚«‚ÅA\n\#{targetname}‚ğŒ©‚Ä‚¢‚écc"
            action = premess + "•s“G‚ÈÎ‚İ‚ğ•‚‚©‚×‚Ä‚¢‚écc" if $game_variables[17] >= 50
          when "Gilgoon "
            action = premess + "Œx‰ú‚·‚é‚æ‚¤‚ÉA\n\#{targetname}‚ğŠÏ@‚µ‚Ä‚¢‚écc"
            action = premess + "•‚Ì—‚ê‚ğ’¼‚µ‚Ä‚¢‚écc" if not myself.nude?
            action = premess + "v‚¢o‚µ‚½‚©‚Ì‚æ‚¤‚ÉA\n\Q‚Ä‚Ä•‚Ì—‚ê‚ğ’¼‚µn‚ß‚½cc" if not myself.nude? and $mood.point > 25
            action = premess + "‰½‚¾‚©‚»‚í‚»‚í‚µ‚Ä‚¢‚écc" if myself.nude?
            # Œ‹ŠEó‘Ô
            if $game_switches[395]
              action = premess + "‚Î‚¢‚ğ‚µ‚Ä‚¢‚écc"
            # Œ‹ŠE”j‰óó‘Ô
            elsif $game_switches[394]
              action = premess + "k‚¦‚Ä‚¢‚écc"
            end
          when "Yuganaught"
            action = premess + "Gè‚Éº‚ğŠ|‚¯‚Ä‚¢‚écc"
            action = premess + "#{targetname}‚ÉA\n\—d‚µ‚°‚ÈÎ‚İ‚ğŒü‚¯‚Ä‚¢‚écc" if $game_variables[17] >= 50
          when "Sylphe"
            action = premess + "ƒjƒRƒŠ‚Æ”÷Î‚ğ•‚‚©‚×‚½cc"
            action = premess + "åÁ˜f“I‚ÈÎ‚İ‚ğ•‚‚©‚×‚Ä‚¢‚écc" if $game_variables[17] >= 50
          when "Ramile"
            action = premess + "‘÷‚Á‚½–Ú‚Â‚«‚Å”÷Î‚ñ‚Å‚¢‚écc"
            action = premess + "“f‘§‚ğ˜R‚ç‚µ‚Ä‚¢‚écc" if $game_variables[17] >= 50
          when "Vermiena"
            action = premess + "’§”­“I‚È–Ú‚Â‚«‚ÅA\n\#{targetname}‚ğŒ©‚Ä‚¢‚écc"
            action = premess + "•s“G‚ÈÎ‚İ‚ğ•‚‚©‚×‚Ä‚¢‚écc" if $game_variables[17] >= 50
          end
        end
        if myself.holding?
#          action = premess + "‚­‚·‚­‚·Î‚Á‚Ä‚¢‚écc"
          action = premess + "g–ã‚¦‚µ‚Ä‚¢‚écc" if myself.crisis?
        end
        avoid = ""
  #------------------------------------------------------------------------#        
      when 299   #ƒGƒ‚[ƒVƒ‡ƒ“
        case myself.personality
        when "DF"
          if target.holding?
            action = premess + "©•ª‚à¬‚´‚è‚½‚»‚¤‚ÉA\n\#{targetname}’B‚Ìsˆ×‚ğŒ©‚Â‚ß‚Ä‚¢‚écc"
          else
            action = premess + "‚­‚·‚­‚·Î‚Á‚Ä‚¢‚écc"
            action = premess + "—d‚µ‚¢Î‚İ‚ğ•‚‚©‚×A\n\#{targetname}‚Ì—‡‚ğŒ©‚Â‚ß‚Ä‚¢‚écc" if $game_variables[17] >= 50 and target.nude?
          end
        when "ã•i" #
          if target.holding?
            action = premess + "sˆ×‚ª‹C‚É‚È‚é‚Ì‚©A\n\#{targetname}’B‚ğ‰¡–Ú‚ÅŠÏ@‚µ‚Ä‚¢‚écc"
          else
            action = premess + "_‚ç‚©‚¢”÷Î‚ğ•‚‚©‚×‚Ä‚¢‚écc"
            action = premess + "‚ñ‚¾“µ‚ÅA\n\#{targetname}‚ğŒ©‚Â‚ß‚Ä‚¢‚écc" if $game_variables[17] >= 50 and myself.crisis?
          end
        when "‚–" #
          if target.holding?
            action = premess + "•¡G‚È•\î‚ÅA\n\#{targetname}’B‚Ìsˆ×‚ğŒ©‚Â‚ß‚Ä‚¢‚écc"
          else
            action = premess + "Œ©‰º‚·‚æ‚¤‚È‹ü‚ÅA\n\#{targetname}‚ğáÉ‚ñ‚Å‚¢‚écI"
            action = premess + "‚¿‚ç‚¿‚ç‚Æ‰¡–Ú‚ÅA\n\#{targetname}‚Ì—lq‚ğ‚¤‚©‚ª‚Á‚Ä‚¢‚écc" if $mood.point > 24
            action = premess + "‹ü‚É‹C‚Ã‚­‚ÆA\n\#{targetname}‚©‚ç‚Õ‚¢‚Æ–Ú‚ğˆí‚ç‚µ‚½cc" if $mood.point > 49
          end
        when "’W”‘" #
          if target.holding?
            action = premess + "w‚ğ‚­‚í‚¦‚ÄA\n\#{targetname}’B‚Ìsˆ×‚ğŒ©‚Â‚ß‚Ä‚¢‚écc"
          else
            action = premess + "‚­‚é‚­‚é‚Æ”¯‚ğw‚É—‚ß‚Ä‚¢‚écc"
            action = premess + "–Ú‚ğ•Â‚¶‚ÄA\n\‰½‚©•¨v‚¢‚É’^‚Á‚Ä‚¢‚écc" if $game_variables[17] >= 50
          end
        when "_˜a" #
          if target.holding?
            action = premess + "”÷Î‚ğ•‚‚©‚×‚ÄA\n\#{targetname}’B‚Ìsˆ×‚ğŒ©‚Â‚ß‚Ä‚¢‚écc"
          else
            action = premess + "_‚ç‚©‚¢”÷Î‚ğ•‚‚©‚×‚Ä‚¢‚écc"
          end
        when "Ÿ‚¿‹C" #
          if target.holding?
            action = premess + "æ‚ğ‰z‚³‚ê‚½‚Æ‚Î‚©‚è‚ÉA\n\#{targetname}’B‚ğŒ©‚Ä‰÷‚µ‚ª‚Á‚Ä‚¢‚écc"
          else
            action = premess + "’§‚Ş‚æ‚¤‚È–Ú‚ÅA\n\#{targetname}‚Ì—lq‚ğf‚Á‚Ä‚¢‚écc"
          end
        when "“à‹C" #
          if target.holding?
            action = premess + "Šç‚ğ—¼è‚Å•¢‚Á‚ÄA\n\#{targetname}’B‚Ìsˆ×‚ğŒ©‚È‚¢‚æ‚¤‚É‚µ‚Ä‚¢‚écc"
            action = premess + "Šç‚ğ—¼è‚Å•¢‚¢‚Â‚Â‚àA\n\Œ„ŠÔ‚©‚ç#{targetname}’B‚Ìsˆ×‚ğŒ©‚Ä‚¢‚écc" if $mood.point > 24
            action = premess + "H‚¢“ü‚é‚æ‚¤‚ÉA\n\#{targetname}’B‚Ìsˆ×‚ğŒ©‚Ä‚¢‚écc" if $mood.point > 49
          else
            action = premess + "‚¤‚Â‚Ş‚¢‚ÄA\n\‰½‚©‚ğŒ¾‚¢‚½‚»‚¤‚É‚µ‚Ä‚¢‚écc"
            action = premess + "’p‚¸‚©‚µ‚»‚¤‚ÉA\n\#{targetname}‚©‚ç–Ú‚ğˆí‚ç‚µ‚Ä‚¢‚écc"
            action = premess + "‚à‚¶‚à‚¶‚µ‚È‚ª‚çA\n\#{targetname}‚ğŒ©‚Â‚ß‚Ä‚¢‚écc" if $mood.point > 24
          end
        when "—z‹C" #
          if target.holding?
            action = premess + "©•ª‚à¬‚´‚è‚½‚»‚¤‚ÉA\n\#{targetname}’B‚Ìsˆ×‚ğŒ©‚Â‚ß‚Ä‚¢‚écc"
          else
            action = premess + "––Ê‚ÌÎŠç‚ÅA\n\#{targetname}‚ÌŠç‚ğ”`‚«‚ñ‚Å‚¢‚écc"
          end
        when "ˆÓ’nˆ«" #
          if target.holding?
            action = premess + "sˆ×‚ª‹C‚É‚È‚é‚Ì‚©A\n\#{targetname}’B‚ğ‰¡–Ú‚ÅŠÏ@‚µ‚Ä‚¢‚écc"
          else
            action = premess + "—â‚â‚â‚©‚È–Ú‚ÅA\n\#{targetname}‚Ì—lq‚ğ‰M‚Á‚Ä‚¢‚écc"
            action = premess + "‰½‚©‚ğv‚¢‚Â‚¢‚½‚æ‚¤‚ÉA\n\ƒjƒ„ƒŠ‚ÆÎ‚İ‚ğ•‚‚©‚×‚½cc" if $game_variables[17] >= 50
          end
        when "“V‘R" #
          action = premess + "‚Ú[‚Á‚Æ—]ŠŒ©‚ğ‚µ‚Ä‚¢‚écc"
        when "]‡" #
          if target.holding?
            action = premess + "w‚ğ‚­‚í‚¦‚ÄA\n\#{targetname}’B‚Ìsˆ×‚ğ‚¶‚Á‚ÆŒ©‚Â‚ß‚Ä‚¢‚écc"
          else
            action = premess + "A\n\#{targetname}‚©‚ç‚Ì“®Œü‚ğŒ©ç‚Á‚Ä‚¢‚écc"
          end
        when "‹•¨" #
          if target.holding?
            action = premess + "sˆ×‚ª‹C‚É‚È‚é‚Ì‚©A\n\#{targetname}’B‚ğ‰¡–Ú‚ÅŠÏ@‚µ‚Ä‚¢‚écc"
            action = premess + "H‚¢“ü‚é‚æ‚¤‚ÉA\n\#{targetname}’B‚Ìsˆ×‚ğŒ©‚Ä‚¢‚écc" if $mood.point > 24
          else
            action = premess + "©M–X‚ÌŠç‚ÅA\n\•s“G‚ÈÎ‚İ‚ğ•‚‚©‚×‚Ä‚¢‚écc"
            action = premess + "S‚È‚µ‚©‚»‚í‚»‚í‚µ‚Ä‚¢‚écc" if $mood.point > 24
            action = premess + "‰½ŒÌ‚©‚ ‚½‚Ó‚½‚µ‚Ä‚¢‚écc" if $mood.point > 49
          end
        when "“|ö" #
          if target.holding?
            action = premess + "—d‚µ‚¢Î‚İ‚ğ•‚‚©‚×‚ÄA\n\#{targetname}’B‚Ìsˆ×‚ğŒ©‚Â‚ß‚Ä‚¢‚écc"
          else
            action = premess + "‚­‚·‚­‚·Î‚Á‚Ä‚¢‚écc"
          end
        when "ŠÃ‚¦«" #
          if target.holding?
            action = premess + "‹»–¡’ÃX‚Ì–Ú‚ÅA\n\#{targetname}’B‚Ìsˆ×‚ğŒ©‚Â‚ß‚Ä‚¢‚écc"
          else
            action = premess + "‹»–¡’ÃX‚Ì–Ú‚ÅA\n\#{targetname}‚ğŒ©‚Â‚ß‚Ä‚¢‚écc"
          end
        when "•sv‹c" #
          if target.holding?
            action = premess + "‰½‚ğl‚¦‚Ä‚¢‚é‚©”»‚ç‚È‚¢•\î‚ÅA\n\#{targetname}’B‚Ìsˆ×‚ğŒ©‰º‚ë‚µ‚Ä‚¢‚écc"
          else
            action = premess + "‰½‚ğv‚Á‚½‚Ì‚©A\n\“‚“Ë‚É‚»‚Ìê‚Å‚ä‚ç‚ä‚ç‚Æ—x‚èn‚ß‚½cc"
          end
        when "“Æ‘P" #ƒtƒ‹ƒrƒ…ƒAê—p
          if target.holding?
            action = premess + "#{targetname}‚Ì‹ü‚É‹C•t‚«A\n\ˆêl”[“¾‚µ‚½‚æ‚¤‚É”÷Î‚ñ‚¾cc"
          else
            action = premess + "#{targetname}‚Ì‹ü‚É‹C•t‚«A\n\ˆêl”[“¾‚µ‚½‚æ‚¤‚É”÷Î‚ñ‚¾cc"
          end
        else
          action = premess + "‚­‚·‚­‚·Î‚Á‚Ä‚¢‚écc"
        end
        if myself.holding?
          action = premess + "‚­‚·‚­‚·Î‚Á‚Ä‚¢‚écc"
          action = premess + "g–ã‚¦‚µ‚Ä‚¢‚écc" if myself.crisis?
        end
        avoid = ""
  #------------------------------------------------------------------------#
  # œƒLƒbƒXŒn
  #------------------------------------------------------------------------#
      when 301   #ƒLƒbƒXã
        case myself.personality
        when "’W”‘", "“à‹C"
          action = premess + "A\n\#{targetname}‚ÌO‚É‚»‚Á‚ÆO‚ğd‚Ë‚Ä‚«‚½I"
        else
          action = premess + "A\n\#{targetname}‚É‚»‚Á‚ÆƒLƒX‚ğ‚µ‚Ä‚«‚½I"
        end
      when 302   #ƒLƒbƒX’†
        case myself.personality
        when "’W”‘", "“à‹C"
          action = premess + "–Ú‚ğ•Â‚¶‚ÄA\n\#{targetname}‚É‚»‚Á‚ÆƒLƒX‚ğ‚µ‚Ä‚«‚½I"
        else
          action = premess + "A\n\#{targetname}‚ÉƒLƒX‚ğ‚µ‚Ä‚«‚½I"
        end
      when 303   #ƒLƒbƒX‹­
        case myself.personality
        when "’W”‘", "“à‹C", "‚–"
          action = premess + "–Ú‚ğ•Â‚¶‚ÄA\n\#{targetname}‚Æ‰½“x‚àƒLƒX‚ğŒJ‚è•Ô‚µ‚Ä‚«‚½I"
        else
          action = premess + "ã‚ğ—‚ß‚é‚æ‚¤‚ÉA\n\#{targetname}‚Éî”M“I‚ÈƒLƒX‚ğ‚µ‚Ä‚«‚½I"
        end
      when 304   #ƒLƒbƒX•KE
        case myself.personality
        when "’W”‘", "“à‹C", "‚–"
          action = premess + "‚¤‚é‚ñ‚¾“µ‚ÅA\n\æÃ‚é‚æ‚¤‚É#{targetname}‚ÉƒLƒX‚ğ‚µ‚Ä‚«‚½I"
        else
          action = premess + "ã‚ğ—‚ß‚é‚æ‚¤‚ÉA\n\#{targetname}‚Éî”M“I‚ÈƒLƒX‚ğ‚µ‚Ä‚«‚½I"
        end
      when 305   #ƒLƒbƒX’ÇŒ‚
        case myself.personality
        when "’W”‘", "“à‹C", "‚–"
          action = premess + "ã–ÚŒ­‚¢‚ÉA\n\‰½“x‚à#{targetname}‚ÉƒLƒX‚ğd‚Ë‚Ä‚«‚½I"
        else
          action = premess + "‚È‚¨‚àŒƒ‚µ‚­A\n\#{targetname}‚Éî”M“I‚ÈƒLƒX‚ğd‚Ë‚Ä‚«‚½I"
        end
      when 308   #ƒ‰ƒuƒŠƒBƒLƒbƒX
        action = premess + "‰Âˆ¤‚ç‚µ‚­”÷Î‚ñ‚ÅA\n\#{targetname}‚É‚»‚Á‚ÆƒLƒX‚ğ‚µ‚Ä‚«‚½I"
      when 309   #ƒƒ}ƒ“ƒXƒLƒbƒX
        action = premess + "”÷Î‚İ‚ğ•‚‚©‚×A\n\#{targetname}‚Æî”M“I‚ÈƒLƒX‚ğŒğ‚í‚µ‚½I"
      when 310   #ƒtƒ@ƒVƒlƒCƒgƒLƒbƒX
        action = premess + "—d‰‚ÈÎ‚İ‚ğ•‚‚©‚×A\n\#{targetname}‚ğ•ø‚«Šñ‚¹‚Ä‚»‚ÌO‚ğ’D‚Á‚½I"
  #------------------------------------------------------------------------#
  # œè‹ZŒn
  #------------------------------------------------------------------------#
      when 319   #èU‚ßƒyƒjƒXÅ
        if target.nude?
          action = premess + " gently touches #{targetname}'s\n\ penis ‚—ith her hand!"
          action = premess + " gently brushes #{targetname}'s\n\ penis ‚—ith her finger!" if $game_variables[17] > 50
          action += "\n\ precu‚ dribbles out fro‚ the pleasure!" if target.lub_male >= 60
        else
          if target == $game_actors[101]
          action = "#{myname} gently strokes #{targetname}'s\n\ penis through his #{pantsu}!"
          else
          action = "#{myname} gently strokes #{targetname}'s\n\ penis through her #{pantsu}!"
          end
        end
      when 320   #èU‚ßƒyƒjƒX
        if target.nude?
          action = premess + " strokes #{targetname}'s\n\ penis ‚—ith her hand!"
          action = premess + " strokes #{targetname}'s\n\ penis ‚—ith her finger!" if $game_variables[17] > 50
          action += "\n\ precu‚ is spilling out fro‚ the intense pleasure!" if target.lub_male >= 60
        else
          if target == $game_actors[101]
          action = "#{myname} strokes #{targetname}'s\n\ penis through his #{pantsu}!"
          else
          action = "#{myname} strokes #{targetname}'s\n\ penis through her #{pantsu}!"
          end
        end
      when 321   #èU‚ßƒyƒjƒX‹­
        if target.nude?
          #ƒeƒLƒXƒg’²®
          action = premess + "#{tec},\n\ pu‚ps #{targetname}'s penis ‚—ith her hand!"
          action = premess + "#{tec},\n runs her fingers over #{targetname}'s penis!" if $game_variables[17] > 50
          action += "\n\ precu‚ is spilling out fro‚ the intense pleasure!" if target.lub_male >= 60
          action.gsub!("—lq‚Å","è‚Â‚«‚Å") #•\Œ»‚Ì•ÏX
        else
          if target == $game_actors[101]
          action = "#{myname} quickly slips her\n\ hand into #{targetname}'s #{pantsu},\n\ running her hands over his penis!"
          else
          action = "#{myname} quickly slips her\n\ hand into #{targetname}'s #{pantsu},\n\ running her hands over her penis!"
          end
        end
      when 322   #èU‚ßƒyƒjƒX•KE
        if target.nude?
          action = premess + "#{tec} happily plays\n\ around ‚—ith #{targetname}'s penisI"
          action += "\n\ precu‚ is spilling out fro‚ the intense pleasure!" if target.lub_male >= 60
          action.gsub!("—lq‚Å","è‚Â‚«‚Å") #•\Œ»‚Ì•ÏX
        else
          if target == $game_actors[101]
          action = "#{myname} quickly slips her\n\ hand into #{targetname}'s #{pantsu},\n\ running her hands over his penis!"
          else
          action = "#{myname} quickly slips her\n\ hand into #{targetname}'s #{pantsu},\n\ running her hands over her penis!"
          end
        end
      when 323   #èU‚ßáÎŠÛÅ
        if target.nude?
          action = premess + " gently rubs her\n\ hand over #{targetname}'s testicles!"
          action = premess + " gently runs her\n\ fingers over #{targetname}'s testicles!" if $game_variables[17] > 50
        else
          if target == $game_actors[101]
          action = "#{myname} quickly slips her\n\ hand into #{targetname}'s #{pantsu},\n\ rubbing her hands over his scrotu‚!"
          else
          action = "#{myname} quickly slips her\n\ hand into #{targetname}'s #{pantsu},\n\ rubbing her hands over her scrotu‚!"
          end
        end
      when 324   #èU‚ßáÎŠÛ•KE
        if target.nude?
          action = premess + " ‚assages #{targetname}'s\n\\ testicles ‚—ith her hand!"
          action = premess + " feels up #{targetname}'s\n\\ testicles ‚—ith her fingers!" if $game_variables[17] > 50
        else
          if target == $game_actors[101]
          action = "#{myname} quickly slips her\n\ hand into #{targetname}'s #{pantsu},\n\ feeling up his scrotu‚!"
          else
          action = "#{myname} quickly slips her\n\ hand into #{targetname}'s #{pantsu},\n\ feeling up her scrotu‚!"
          end
        end
      when 325   #èU‚ßƒyƒjƒX’ÇŒ‚
        if target.nude?
          action = premess + "#{tec} continues to\n\ caress #{targetname}'s penis so‚e ‚ore!"
          action += "\n\ precu‚ keeps spilling out fro‚ the intense pleasure!" if target.lub_male >= 60
        else
          action = "#{myname} slips her hand in again\n\ to grope #{targetname}'s penis so‚e ‚ore!"
        end
      when 326   #èU‚ßáÎŠÛ’ÇŒ‚
        if target.nude?
          action = premess + "#{tec} continues to\n\ fondle #{targetname}'s balls so‚e ‚ore!"
        else
          action = "#{myname} slips her hand in again\n\ to fondle #{targetname}'s balls so‚e ‚ore!"
        end
  #------------------------------------------------------------------------#
      when 328   #èU‚ß‹¹Å
        if target.nude?
          action = premess + "è‚ÅA\n\#{targetname}‚Ì#{target.bustsize}‚É#{brk3}—D‚µ‚­G‚ê‚Ä‚«‚½I"
          action = premess + "è‚ÅA\n\#{targetname}‚Ì“ûñ‚É—D‚µ‚­G‚ê‚Ä‚«‚½I" if target.boy?
        else
          action = premess + "•‚Ìã‚©‚çA\n\#{targetname}‚Ì#{target.bustsize}‚É#{brk3}è‚Å—D‚µ‚­G‚ê‚Ä‚«‚½I"
        end
        #‹¹ƒTƒCƒYf’f(‚bƒJƒbƒvŠî€)
        case $data_SDB[target.class_id].bust_size
        when 4,5 #‚c,‚d
          action.gsub!("‚³‚·‚Á‚Ä","†‚ñ‚Å") 
        end
      when 329   #èU‚ß‹¹
        if target.nude?
          action = premess + "—¼è‚ÅA\n\#{targetname}‚Ì#{target.bustsize}‚ğ#{brk3}†‚İ‚µ‚¾‚¢‚Ä‚«‚½I"
          action = premess + "wæ‚ÅA\n\#{targetname}‚Ì“ûñ‚ğhŒƒ‚µ‚Ä‚«‚½I" if target.boy?
        else
          action = premess + "•‚Ìã‚©‚çA\n\#{targetname}‚Ì#{target.bustsize}‚ğ#{brk3}è‚Å•‚Å‰ñ‚µ‚Ä‚«‚½I"
        end
        #‹¹ƒTƒCƒYf’f(‚bƒJƒbƒvŠî€)
        case $data_SDB[target.class_id].bust_size
        when 1,2 #‚`,‚a
          action.gsub!("†‚İ‚µ‚¾‚¢‚Ä","†‚ñ‚Å") 
        end
      when 330   #èU‚ß‹¹‹­
        if target.nude?
          action = premess + "wæ‚ÅA\n\#{targetname}‚Ì“ûñ‚ğ‚Â‚Ü‚İhŒƒ‚µ‚Ä‚«‚½I"
          action = premess + "wæ‚ÅA\n\#{targetname}‚Ì“ûñ‚ğI‚İ‚ÉhŒƒ‚µ‚Ä‚«‚½I" if target.boy?
        else
          action = premess + "•‚Éè‚ğŠŠ‚è‚Ü‚¹A\n\#{targetname}‚Ì#{target.bustsize}‚ğ#{brk3}†‚İ‚µ‚¾‚¢‚Ä‚«‚½I"
        end
        #‹¹ƒTƒCƒYf’f(‚bƒJƒbƒvŠî€)
        case $data_SDB[target.class_id].bust_size
        when 1,2 #‚`,‚a
          action.gsub!("†‚İ‚µ‚¾‚¢‚Ä","†‚ñ‚Å") 
        end
      when 331   #èU‚ß‹¹•KE
        if target.nude?
          action = premess + "#{tec}A\n\#{targetname}‚Ì#{target.bustsize}‚ğ#{brk3}v‚¤‚Ü‚Ü˜M‚ÔI"
          action = premess + "#{tec}A\n\#{targetname}‚Ì“ûñ‚ğI‚İ‚ÉhŒƒ‚µ‚Ä‚«‚½I" if target.boy?
          action.gsub!("—lq‚Å","è‚Â‚«‚Å") #•\Œ»‚Ì•ÏX
        else
          action = premess + "•‚Éè‚ğŠŠ‚è‚Ü‚¹A\n\#{targetname}‚Ì#{target.bustsize}‚ğ#{brk3}v‚¤‚Ü‚Ü˜M‚ÔI"
        end
      when 332   #èU‚ß‹¹’ÇŒ‚
        if target.nude?
          action = premess + "#{tec}A\n\#{targetname}‚Ì#{target.bustsize}‚ğ#{brk3}X‚É†‚İ‚µ‚¾‚¢‚½I"
          action = premess + "#{tec}A\n\#{targetname}‚Ì“ûñ‚ğI‚İ‚ÉhŒƒ‚µ‚Ä‚«‚½I" if target.boy?
        else
          action = premess + "•‚ÉŠŠ‚è‚Ü‚¹‚½è‚ÅA\n\#{targetname}‚Ì#{target.bustsize}‚ğX‚É˜M‚ÔI"
        end
        #‹¹ƒTƒCƒYf’f(‚bƒJƒbƒvŠî€)
        case $data_SDB[target.class_id].bust_size
        when 1,2 #‚`,‚a
          action.gsub!("†‚İ‚µ‚¾‚¢‚½","†‚ñ‚Å‚«‚½") 
        end
  #------------------------------------------------------------------------#
      when 334   #èU‚ßƒAƒ\ƒRÅ
        if target.nude?
          action = premess + " gently rubs #{targetname}'s crotch!"
        else
          action = premess + " gently rubs #{targetname}'s crotch\\n through her #{pantsu}!"
        end
      when 335   #èU‚ßƒAƒ\ƒR
        if target.nude?
          action = premess + " strokes #{targetname}'s crotch!"
          action = premess + "wæ‚ÅA\n\#{targetname}‚ÌƒAƒ\ƒR‚Ì“ü‚èŒû‚ğ#{brk4}ˆ¤•‚µ‚Ä‚«‚½I" if $game_variables[17] > 50
        else
          action = premess + " #{pantsu}‚Ìã‚©‚çA\n\#{targetname}‚ÌƒAƒ\ƒR‚ğ•‚Å‚Ä‚«‚½I"
        end
      when 336   #èU‚ßƒAƒ\ƒR‹­
        if target.nude?
          action = premess + "w‚ğA\n\#{targetname}‚ÌƒAƒ\ƒR‚Ì‰œ‚Ü‚Å“ü‚ê‚Ä‚«‚½I"
        else
          action = premess + " #{pantsu}‚Éè‚ğŠŠ‚è‚Ü‚¹A\n\#{targetname}‚ÌƒAƒ\ƒR‚ğw‚Åˆ¤•‚µ‚Ä‚«‚½I"
        end
      when 337   #èU‚ßƒAƒ\ƒR•KE
        if target.nude?
          action = premess + "#{tec}A\n\#{targetname}‚ÌƒAƒ\ƒR‚ğv‚¤‚Ü‚Ü˜M‚ÔI"
          action.gsub!("—lq‚Å","è‚Â‚«‚Å") if $game_variables[17] > 50 #ˆê“x•ÏX‚·‚é‚Æ•ÏX‘ÎÛ•¶š‚ª‚È‚­‚È‚é‚Ì‚ÅğŒ‚Íæ‚É
          action.gsub!("—lq‚Å","wg‚¢‚Å") 
        else
          action = premess + "#{pantsu}‚Éè‚ğŠŠ‚è‚Ü‚¹A\n\#{targetname}‚ÌƒAƒ\ƒR‚ğv‚¤‚Ü‚Ü˜M‚ÔI"
        end
      when 338   #èU‚ß‰AŠjÅ
        if target.nude?
          action = premess + "wæ‚ÅA\n\#{targetname}‚Ì‰AŠj‚ğ—D‚µ‚­•‚Å‚Ä‚«‚½I"
        else
          action = premess + " #{pantsu}‚Ìã‚©‚çA\n\#{targetname}‚Ì‰AŠj‚ğ—D‚µ‚­•‚Å‚Ä‚«‚½I"
        end
      when 339   #èU‚ß‰AŠj
        if target.nude?
          action = premess + "wæ‚ÅA\n\#{targetname}‚Ì‰AŠj‚ğŒƒ‚µ‚­hŒƒ‚µ‚Ä‚«‚½I"
        else
          action = premess + " #{pantsu}‚Éè‚ğŠŠ‚è‚Ü‚¹A\n\#{targetname}‚Ì‰AŠj‚ğhŒƒ‚µ‚Ä‚«‚½I"
        end
      when 340   #èU‚ß‰AŠj•KE
        if target.nude?
          action = premess + " #{tec}A\n\#{targetname}‚Ì‰AŠj‚ğw‚Åv‚¤‚Ü‚Ü˜M‚ÔI"
        else
          action = premess + " #{pantsu}‚Éè‚ğŠŠ‚è‚Ü‚¹A\n\#{targetname}‚Ì‰AŠj‚ğwæ‚Å‚Â‚Ü‚İ‚ ‚°‚½I"
        end
      when 341   #èU‚ßƒAƒ\ƒR’ÇŒ‚
        if target.nude?
          action = premess + " #{tec}A\n\#{targetname}‚ÌƒAƒ\ƒR‚ğX‚ÉU‚ß—§‚Ä‚éI"
        else
          action = premess + " #{pantsu}‚ÉŠŠ‚è‚Ü‚¹‚½è‚ÅA\n\#{targetname}‚ÌƒAƒ\ƒR‚ğX‚É˜M‚ÔI"
        end
      when 342   #èU‚ß‰AŠj’ÇŒ‚
        if target.nude?
          action = premess + " #{tec}A\n\#{targetname}‚Ì‰AŠj‚ğwæ‚Å˜M‚ÔI"
        else
          action = premess + " #{pantsu}‚ÉŠŠ‚è‚Ü‚¹‚½wæ‚ÅA\n\#{targetname}‚Ì‰AŠj‚ğX‚É˜M‚ÔI"
        end
  #------------------------------------------------------------------------#
      when 344   #èU‚ßKÅ
        if target.nude?
          action = premess + "è‚ÅA\n\#{targetname}‚Ì‚¨K‚ğ‚·‚é‚è‚Æ•‚Å‚Ä‚«‚½I"
        else
          action = premess + " #{pantsu}‰z‚µ‚ÉA\n\#{targetname}‚Ì‚¨K‚ğ‚·‚é‚è‚Æ•‚Å‚Ä‚«‚½I"
        end
      when 345   #èU‚ßK
        if target.nude?
          action = premess + "è‚ÅA\n\#{targetname}‚Ì‚¨K‚ğ†‚İ‚µ‚¾‚¢‚Ä‚«‚½I"
        else
          action = premess + " #{pantsu}‰z‚µ‚ÉA\n\#{targetname}‚Ì‚¨K‚ğ†‚İ‚µ‚¾‚¢‚Ä‚«‚½I"
        end
      when 346   #èU‚ßK‹­
        if target.nude?
          action = premess + "—¼è‚ÅA\n\#{targetname}‚Ì‚¨K‚ğ‹­‚­†‚İ‚µ‚¾‚¢‚Ä‚«‚½I"
        else
          action = premess + " #{pantsu}‚Éè‚ğŠŠ‚è‚Ü‚¹A\n\#{targetname}‚Ì‚¨K‚ğ†‚İ‚µ‚¾‚¢‚Ä‚«‚½I"
        end
      when 347   #èU‚ßK•KE
        if target.nude?
          action = premess + " #{tec}A\n\#{targetname}‚Ì‚¨K‚ğv‚¤‚Ü‚Ü˜M‚ÔI"
          action.gsub!("—lq‚Å","è‚Â‚«‚Å") #•\Œ»‚Ì•ÏX
        else
          action = premess + " #{pantsu}‚Éè‚ğŠŠ‚è‚Ü‚¹A\n\#{targetname}‚Ì‚¨K‚ğv‚¤‚Ü‚Ü˜M‚ÔI"
        end
      when 348   #èU‚ß‘O—§‘BÅ
        if target.nude?
          action = premess + " wæ‚ÅA\n\#{targetname}‚Ì‹eÀ‚ğhŒƒ‚µ‚Ä‚«‚½I"
        else
          action = premess + " #{pantsu}‚Éè‚ğŠŠ‚è‚Ü‚¹A\n\#{targetname}‚Ì‹eÀ‚ğhŒƒ‚µ‚Ä‚«‚½I"
        end
      when 349   #èU‚ß‘O—§‘B
        if target.nude?
          action = premess + "wæ‚ÅA\n\#{targetname}‚Ì‹e–å‚ğhŒƒ‚µ‚Ä‚«‚½I"
        else
          action = premess + " #{pantsu}‚Éè‚ğŠŠ‚è‚Ü‚¹A\n\#{targetname}‚Ì‹e–å‚ğw‚ÅhŒƒ‚µ‚Ä‚«‚½I"
        end
      when 350   #èU‚ß‘O—§‘B•KE
        if target.nude?
          action = premess + "#{tec}A\n\#{targetname}‚Ì‹e–å‚ğw‚Åˆ¤•‚µ‚Ä‚«‚½I"
        else
          action = premess + "#{pantsu}‚Éè‚ğŠŠ‚è‚Ü‚¹A\n\w‚Å#{targetname}‚Ì‹e–å‚ğˆ¤•‚µ‚Ä‚«‚½I"
        end
      when 351   #èU‚ßƒAƒiƒ‹Å
        if target.nude?
          action = premess + "wæ‚ÅA\n\#{targetname}‚Ì‹eÀ‚ğhŒƒ‚µ‚Ä‚«‚½I"
        else
          action = premess + "#{pantsu}‚Éè‚ğŠŠ‚è‚Ü‚¹A\n\#{targetname}‚Ì‹eÀ‚ğhŒƒ‚µ‚Ä‚«‚½I"
        end
      when 352   #èU‚ßƒAƒiƒ‹
        if target.nude?
          action = premess + "wæ‚ÅA\n\#{targetname}‚Ì‹e–å‚ğhŒƒ‚µ‚Ä‚«‚½I"
        else
          action = premess + "#{pantsu}‚Éè‚ğŠŠ‚è‚Ü‚¹A\n\#{targetname}‚Ì‹e–å‚ğw‚ÅhŒƒ‚µ‚Ä‚«‚½I"
        end
      when 353   #èU‚ßƒAƒiƒ‹•KE
        if target.nude?
          action = premess + "#{tec}A\n\#{targetname}‚Ì‹e–å‚ğw‚Åˆ¤•‚µ‚Ä‚«‚½II"
        else
          action = premess + "#{pantsu}‚Éè‚ğŠŠ‚è‚Ü‚¹A\n\w‚Å#{targetname}‚Ì‹e–å‚ğˆ¤•‚µ‚Ä‚«‚½I"
        end
      when 354   #èU‚ßK’ÇŒ‚
        if target.nude?
          action = premess + "#{tec}A\n\—¼è‚Å#{targetname}‚Ì‚¨K‚ğ˜M‚ÔI"
        else
          action = premess + "#{pantsu}‚ÉŠŠ‚è‚Ü‚¹‚½è‚ÅA\n\#{targetname}‚Ì‚¨K‚ğX‚É˜M‚ÔI"
        end
      when 355   #èU‚ß‘O—§‘B’ÇŒ‚
        if target.nude?
          action = premess + "#{tec}A\n\w‚Å#{targetname}‚Ì‹e–å‚ğX‚Éˆ¤•‚µ‚Ä‚«‚½I"
        else
          action = premess + "#{pantsu}‚ÉŠŠ‚è‚Ü‚¹‚½w‚ÅA\n\#{targetname}‚Ì‹e–å‚ğX‚Éˆ¤•‚µ‚Ä‚«‚½I"
        end
      when 356   #èU‚ßƒAƒiƒ‹’ÇŒ‚
        if target.nude?
          action = premess + "#{tec}A\n\w‚Å#{targetname}‚Ì‹e–å‚ğX‚Éˆ¤•‚µ‚Ä‚«‚½I"
        else
          action = premess + "#{pantsu}‚ÉŠŠ‚è‚Ü‚¹‚½w‚ÅA\n\#{targetname}‚Ì‹e–å‚ğX‚Éˆ¤•‚µ‚Ä‚«‚½I"
        end
     #------------------------------------------------------------------------#
      when 359   #ƒZƒbƒgƒT[ƒNƒ‹
        action = premess + "‘«Œ³‚É–‚–@w‚ğ•`‚¢‚½I"
      when 360   #ƒR[ƒ‹ƒhƒ^ƒbƒ`
        points = ["ñ‹Ø","”w’†","‘¾‚à‚à"]
        if myself.nude?
          points.push("ƒyƒjƒX","‘Ü") if myself.boy?
          points.push("ƒAƒ\ƒR","‰AŠj","‹¹","“ûñ","‚¨K") unless myself.boy?
        end
        points = points[rand(points.size)]
        action = premess + "‚Ğ‚ñ‚â‚è‚µ‚½è‚ÅA\n\#{targetname}‚Ì#{points}‚ğˆ¤•‚µ‚½I"
        action = premess + "‚Ğ‚ñ‚â‚è‚µ‚½wæ‚ÅA\n\#{targetname}‚Ì#{points}‚ğˆ¤•‚µ‚½I"
        avoid = ""
     #------------------------------------------------------------------------#
      when 361   #ƒTƒfƒBƒXƒgƒJƒŒƒX
        action = premess + "ˆÓ’nˆ«‚Èè‚Â‚«‚ÅA\n\#{targetname}‚ğˆ¤•‚µ‚½I"
     #------------------------------------------------------------------------#
      when 362   #ƒvƒ‰ƒCƒXƒIƒuƒnƒŒƒ€
        action = premess + "A\n\#{targetname + rangetext}‚ğ‚ ‚Ü‚Ë‚­ˆ¤•‚µ‚½I"
     #------------------------------------------------------------------------#
      when 363   #ƒvƒ‰ƒCƒXƒIƒuƒVƒi[
        action = premess + "A\n\#{targetname + rangetext}‚ğ‚ ‚Ü‚Ë‚­ˆ¤•‚µ‚½I"
     #------------------------------------------------------------------------#
      when 364   #ƒyƒ‹ƒ\ƒiƒuƒŒƒCƒN
        action = premess + "#{targetname}‚ÌŠá‘O‚ÅA\n\’ˆ‚ğˆ¬‚è’×‚µ‚½I"
     #------------------------------------------------------------------------#
      when 365   #ƒLƒƒƒXƒgƒR[ƒ‹
        action = "–²¢ŠE‚Í#{$game_actors[101].name}‚Ì‹L‰¯‚©‚ç\n‰ß‹‚Ì–Ï·‚ğ¶‚İo‚µ‚½I"
  #------------------------------------------------------------------------#
  # œŒû‹ZŒn
  #------------------------------------------------------------------------#
      when 375   #ŒûU‚ßƒyƒjƒXÅ
        if target.nude?
          action = "#{myname} gently kisses up and do‚—n #{targetname}'s penis!"
          action = "#{myname} quietly licks #{targetname}'s penis ‚—ith\n\ the tip of her tongue!" if $game_variables[17] > 50
          action += "\n\ A pleasant, sli‚y sensation runs do‚—n his penis!" if target.lub_male >= 60
        else
          action = "Through the #{pantsu}, #{myname}\n\ tenderly kisses bet‚—een #{targetname}'s crotch!"
        end
      when 376   #ŒûU‚ßƒyƒjƒX
        if target.nude?
          action = premess + "ã‚ÅA\n\#{targetname}‚ÌƒyƒjƒX‚ğär‚ß‚Ä‚«‚½I"
          action = "#{myname} licks #{targetname}'s penis ‚—ith the tip of her tongue!" if $game_variables[17] > 50
          action += "\n\ A pleasant, sli‚y sensation runs do‚—n his penis!" if target.lub_male >= 60
        else
          action = "Through the #{pantsu},\n\ #{myname} kisses bet‚—een #{targetname}'s crotch!"
        end
      when 377   #ŒûU‚ßƒyƒjƒX‹­
        if target.nude?
          action = premess + "#{tec}A\n\#{targetname}‚ÌƒyƒjƒX‚Ìæ’[‚ğ#{brk4}är‚ß‰ñ‚µ‚Ä‚«‚½I"
          action += "\n\‚Ê‚ß‚è‚ğ‘Ñ‚Ñ‚½ƒyƒjƒX‚É‹­‚¢‰õŠ´‚ª‘–‚éI" if target.lub_male >= 60
          action.gsub!("—lq‚Å","ãg‚¢‚Å") #•\Œ»‚Ì•ÏX
        else
          action = premess + "#{pantsu}‰z‚µ‚ÉA\n\#{targetname}‚ÌƒyƒjƒX‚ğär‚ßã‚°‚Ä‚«‚½I"
        end
      when 378   #ŒûU‚ßƒyƒjƒX•KE
        if target.nude?
          action = premess + "#{tec}A\n\#{targetname}‚ÌƒyƒjƒX‚ğ#{brk4}ªŒ³‚©‚çär‚ßã‚°‚Ä‚«‚½I"
          action += "\n\‚Ê‚ß‚è‚ğ‘Ñ‚Ñ‚½ƒyƒjƒX‚É‹­‚¢‰õŠ´‚ª‘–‚éI" if target.lub_male >= 60
          action.gsub!("—lq‚Å","ãg‚¢‚Å") #•\Œ»‚Ì•ÏX
        else
          action = premess + "#{pantsu}‰z‚µ‚ÉA\n\#{targetname}‚ÌƒyƒjƒX‚ğär‚ß‰ñ‚µ‚Ä‚«‚½I"
        end
      when 379   #ŒûU‚ßáÎŠÛÅ
        if target.nude?
          action = premess + "O‚ÅA\n\#{targetname}‚Ì‘Ü‚ğ—D‚µ‚­‹z‚¢ã‚°‚Ä‚«‚½I"
        else
          action = premess + "#{pantsu}‰z‚µ‚ÉA\n\#{targetname}‚Ì‘Ü‚ÉƒLƒX‚µ‚Ä‚«‚½I"
        end
      when 380   #ŒûU‚ßáÎŠÛ•KE
        if target.nude?
          action = premess + "#{tec}A\n\#{targetname}‚Ì‘Ü‚ğär‚ß‰ñ‚µ‚Ä‚«‚½I"
          action.gsub!("—lq‚Å","ãg‚¢‚Å") #•\Œ»‚Ì•ÏX
        else
          action = premess + "#{pantsu}‰z‚µ‚ÉA\n\#{targetname}‚Ì‘Ü‚ğär‚ß‰ñ‚µ‚Ä‚«‚½I"
        end
      when 381   #ŒûU‚ßƒyƒjƒX’ÇŒ‚
        if target.nude?
          action = premess + "#{tec}A\n\#{targetname}‚ÌƒyƒjƒX‚ğX‚Éär‚ßã‚°‚Ä‚«‚½I"
          action += "\n\‚Ê‚ß‚è‚ğ‘Ñ‚Ñ‚½ƒyƒjƒX‚É‹­‚¢‰õŠ´‚ª‘–‚éI" if target.lub_male >= 60
        else
          action = premess + "‚È‚¨‚à#{pantsu}‰z‚µ‚ÉA\n\#{targetname}‚ÌƒyƒjƒX‚ğär‚ß‰ñ‚µ‚Ä‚«‚½I"
        end
      when 382   #ŒûU‚ßáÎŠÛ’ÇŒ‚
        if target.nude?
          action = premess + "#{tec}A\n\#{targetname}‚Ì‘Ü‚ğX‚Éär‚ßã‚°‚Ä‚«‚½I"
        else
          action = premess + "‚È‚¨‚à#{pantsu}‰z‚µ‚ÉA\n\#{targetname}‚Ì‘Ü‚ğär‚ß‰ñ‚µ‚Ä‚«‚½I"
        end
  #------------------------------------------------------------------------#
      when 384   #ŒûU‚ß‹¹Å
        if target.nude?
          action = premess + "O‚ÅA\n\#{targetname}‚Ì#{target.bustsize}‚É#{brk3}‚»‚Á‚ÆƒLƒX‚µ‚Ä‚«‚½I"
        else
          action = premess + "•‚Ìã‚©‚çA\n\#{targetname}‚Ì#{target.bustsize}‚É#{brk3}‚»‚Á‚ÆƒLƒX‚µ‚Ä‚«‚½I"
        end
      when 385   #ŒûU‚ß‹¹
        if target.nude?
          action = premess + "ã‚ÅA\n\#{targetname}‚Ì#{target.bustsize}‚ğ#{brk3}‚È‚¼‚Á‚Ä‚«‚½I"
          action = premess + "ãæ‚ÅA\n\#{targetname}‚Ì#{target.bustsize}‚ğ#{brk3}är‚ß‚Ä‚«‚½I" if $game_variables[17] > 50
        else
          action = premess + "•‚Ìã‚©‚çA\n\#{targetname}‚Ì#{target.bustsize}‚ÉƒLƒX‚µ‚Ä‚«‚½I"
        end
      when 386   #ŒûU‚ß‹¹‹­
        if target.nude?
          action = premess + "ãæ‚ÅA\n\#{targetname}‚Ì#{target.bustsize}‚ğ#{brk3}är‚ß‰ñ‚µ‚Ä‚«‚½I"
          action = premess + "#{tec}A\n\#{targetname}‚Ì“ûñ‚ğär‚ß‰ñ‚µ‚Ä‚«‚½I" if $game_variables[17] > 50
          action.gsub!("—lq‚Å","ãg‚¢‚Å") #•\Œ»‚Ì•ÏX
        else
          action = premess + "•‚ÌŒ„ŠÔ‚©‚çA\n\#{targetname}‚Ì#{target.bustsize}‚ğär‚ß‰ñ‚µ‚Ä‚«‚½I"
        end
      when 387   #ŒûU‚ß‹¹•KE
        if target.nude?
          action = premess + "#{tec}A\n\#{targetname}‚Ì#{target.bustsize}‚ğ#{brk3}‹­‚­‹z‚¢ã‚°‚Ä‚«‚½I"
          action = premess + "#{tec}A\n\#{targetname}‚Ì“ûñ‚ğ‹­‚­‹z‚¢ã‚°‚Ä‚«‚½I" if $game_variables[17] > 50
          action.gsub!("—lq‚Å","ãg‚¢‚Å") #•\Œ»‚Ì•ÏX
        else
          action = premess + "•‚ÌŒ„ŠÔ‚©‚çA\n\#{targetname}‚Ì#{target.bustsize}‚ğ‹­‚­‹z‚Á‚Ä‚«‚½I"
        end
      when 388   #ŒûU‚ß‹¹’ÇŒ‚
        if target.nude?
          action = premess + "#{tec}A\n\#{targetname}‚Ì#{target.bustsize}‚ğ#{brk3}X‚Éär‚ß‰ñ‚µ‚½I"
          action = premess + "#{tec}A\n\#{targetname}‚Ì“ûñ‚ğX‚É‹z‚¢ã‚°‚½I" if $game_variables[17] > 50
        else
          action = premess + "•‚ÌŒ„ŠÔ‚©‚çA\n\#{targetname}‚Ì#{target.bustsize}‚ğX‚É‹­‚­‹z‚Á‚Ä‚«‚½I"
        end
  #------------------------------------------------------------------------#
      when 390   #ŒûU‚ßƒAƒ\ƒRÅ
        if target.nude?
          action = premess + "O‚ÅA\n\#{targetname}‚ÌƒAƒ\ƒR‚É‚»‚Á‚ÆƒLƒX‚µ‚Ä‚«‚½I"
        else
          action = premess + "#{pantsu}‚Ìã‚©‚çA\n\#{targetname}‚ÌƒAƒ\ƒR‚É‚»‚Á‚ÆƒLƒX‚µ‚Ä‚«‚½I"
        end
      when 391   #ŒûU‚ßƒAƒ\ƒR
        if target.nude?
          action = premess + "ã‚ÅA\n\#{targetname}‚ÌƒAƒ\ƒR‚ğär‚ß‚Ä‚«‚½I"
          action = premess + "O‚ÅA\n\#{targetname}‚ÌƒAƒ\ƒR‚ÉƒLƒX‚ğ‚µ‚Ä‚«‚½I" if $game_variables[17] > 50
        else
          action = premess + "#{pantsu}‚Ìã‚©‚çA\n\#{targetname}‚ÌƒAƒ\ƒR‚ğär‚ß‚Ä‚«‚½I"
        end
      when 392   #ŒûU‚ßƒAƒ\ƒR‹­
        if target.nude?
          action = premess + "ãæ‚ğ‚·‚Ú‚ßA\n\#{targetname}‚ÌƒAƒ\ƒR‚É‘}‚ê‚Ä‚«‚½I"
          action = premess + "#{tec}A\n\#{targetname}‚ÌƒAƒ\ƒR‚ğ‹­‚­‹z‚¢ã‚°‚½I" if $game_variables[17] > 50
        else
          action = premess + "#{pantsu}‚ğ‚¸‚ç‚µA\n\#{targetname}‚ÌƒAƒ\ƒR‚ğär‚ß‰ñ‚µ‚Ä‚«‚½I"
        end
      when 393   #ŒûU‚ßƒAƒ\ƒR•KE
        if target.nude?
          action = premess + "#{tec}A\n\#{targetname}‚ÌƒAƒ\ƒR‚ğv‚¤‚Ü‚Ü˜M‚ÔI"
          action.gsub!("—lq‚Å","ãg‚¢‚Å") #•\Œ»‚Ì•ÏX
        else
          action = premess + "#{pantsu}‚²‚ÆA\n\#{targetname}‚ÌƒAƒ\ƒR‚Éã‚ğ“Ë‚«“ü‚ê‚Ä‚«‚½I"
        end
      when 394   #ŒûU‚ß‰AŠjÅ
        if target.nude?
          action = premess + "ãæ‚ÅA\n\#{targetname}‚Ì‰AŠj‚ğ—D‚µ‚­ˆ¤•‚µ‚Ä‚«‚½I"
        else
          action = premess + "#{pantsu}‚Ìã‚©‚çA\n\#{targetname}‚Ì‰AŠj‚ğãæ‚Åˆ¤•‚µ‚Ä‚«‚½I"
        end
      when 395   #ŒûU‚ß‰AŠj
        if target.nude?
          action = premess + "ãæ‚ÅA\n\#{targetname}‚Ì‰AŠj‚ğär‚ßã‚°‚Ä‚«‚½I"
        else
          action = premess + "#{pantsu}‚ğ‚¸‚ç‚µA\n\#{targetname}‚Ì‰AŠj‚ğär‚ßã‚°‚Ä‚«‚½I"
        end
      when 396   #ŒûU‚ß‰AŠj•KE
        if target.nude?
          action = premess + "#{tec}A\n\#{targetname}‚Ì‰AŠj‚ğv‚¤‚Ü‚Ü˜M‚ÔI"
        else
          action = premess + "#{pantsu}‚²‚ÆA\n\#{targetname}‚Ì‰AŠj‚ğO‚Å‹z‚¢ã‚°‚½I"
        end
      when 397   #ŒûU‚ßƒAƒ\ƒR’ÇŒ‚
        if target.nude?
          action = premess + "#{tec}A\n\#{targetname}‚ÌƒAƒ\ƒR‚ğ·X‚Éär‚ßã‚°‚éI"
        else
          action = premess + "#{tec}A\n\#{targetname}‚ÌƒAƒ\ƒR‚ğ#{pantsu}‰z‚µ‚É˜M‚ÔI"
        end
      when 398   #ŒûU‚ß‰AŠj’ÇŒ‚
        if target.nude?
          action = premess + "#{tec}A\n\ãæ‚Å#{targetname}‚Ì‰AŠj‚ğ·X‚É˜M‚ÔI"
        else
          action = premess + "#{tec}A\n\#{pantsu}‚²‚Æ#{targetname}‚Ì‰AŠj‚ğO‚Å‹z‚¢ã‚°‚éI"
        end
  #------------------------------------------------------------------------#
      when 400   #ŒûU‚ßKÅ
        if target.nude?
          action = premess + "O‚ÅA\n\#{targetname}‚Ì‚¨K‚É‚»‚Á‚ÆƒLƒX‚ğ‚µ‚Ä‚«‚½I"
        else
          action = premess + "#{pantsu}‰z‚µ‚ÉA\n\#{targetname}‚Ì‚¨K‚É‚»‚Á‚ÆƒLƒX‚ğ‚µ‚Ä‚«‚½I"
        end
      when 401   #ŒûU‚ßK
        if target.nude?
          action = premess + "ã‚ÅA\n\#{targetname}‚Ì‚¨K‚ğär‚ßã‚°‚Ä‚«‚½I"
        else
          action = premess + "#{pantsu}‰z‚µ‚ÉA\n\#{targetname}‚Ì‚¨K‚ğär‚ßã‚°‚Ä‚«‚½I"
        end
      when 402   #ŒûU‚ßK‹­
        if target.nude?
          action = premess + "O‚ÅA\n\#{targetname}‚Ì‚¨K‚ÉŠÃŠš‚İ‚µ‚Ä‚«‚½I"
        else
          action = premess + "#{pantsu}‚²‚ÆA\n\O‚Å#{targetname}‚Ì‚¨K‚ÉŠÃŠš‚İ‚µ‚Ä‚«‚½I"
        end
      when 403   #ŒûU‚ßK•KE
        if target.nude?
          action = premess + "#{tec}A\n\#{targetname}‚Ì‚¨K‚ğär‚ß‰ñ‚µ‚Ä‚«‚½I"
        else
          action = premess + "#{pantsu}‚ğŒû‚Å‚¸‚ç‚µA\n\#{targetname}‚Ì‚¨K‚ğär‚ß‰ñ‚µ‚Ä‚«‚½I"
        end
      when 404   #ŒûU‚ß‘O—§‘BÅ
        if target.nude?
          action = premess + "ãæ‚ÅA\n\#{targetname}‚Ì‘O—§‘B‚ğhŒƒ‚µ‚Ä‚«‚½I"
        else
          action = premess + "#{pantsu}‚Ìã‚©‚çA\n\#{targetname}‚Ì‹eÀ‚ğhŒƒ‚µ‚Ä‚«‚½I"
        end
      when 405   #ŒûU‚ß‘O—§‘B
        if target.nude?
          action = premess + "ãæ‚ÅA\n\#{targetname}‚Ì‹eÀü•Ó‚ğär‚ß‰ñ‚µ‚Ä‚«‚½I"
        else
          action = premess + "#{pantsu}‚Ìã‚©‚çA\n\#{targetname}‚Ì‹e–å‚ğã‚ÅhŒƒ‚µ‚Ä‚«‚½I"
        end
      when 406   #ŒûU‚ß‘O—§‘B•KE
        if target.nude?
          action = premess + "#{tec}A\n\#{targetname}‚Ì‹e–å‚Ì‰œ‚Ü‚Åã‚ğ“ü‚ê‚Ä‚«‚½I"
          action.gsub!("—lq‚Å","ãg‚¢‚Å") #•\Œ»‚Ì•ÏX
        else
          action = premess + "#{pantsu}‚²‚ÆA\n\#{targetname}‚Ì‹e–å‚Ì‰œ‚Ü‚Åã‚ğ“ü‚ê‚Ä‚«‚½I"
        end
      when 407   #ŒûU‚ßƒAƒiƒ‹Å
        if target.nude?
          action = premess + "ãæ‚ÅA\n\#{targetname}‚Ì‹eÀ‚ğhŒƒ‚µ‚Ä‚«‚½I"
        else
          action = premess + "#{pantsu}‚Ìã‚©‚çA\n\#{targetname}‚Ì‹eÀ‚ğhŒƒ‚µ‚Ä‚«‚½I"
        end
      when 408   #ŒûU‚ßƒAƒiƒ‹
        if target.nude?
          action = premess + "ãæ‚ÅA\n\#{targetname}‚Ì‹e–åü•Ó‚ğär‚ß‰ñ‚µ‚Ä‚«‚½I"
        else
          action = premess + "#{pantsu}‚Ìã‚©‚çA\n\#{targetname}‚Ì‹e–å‚ğã‚ÅhŒƒ‚µ‚Ä‚«‚½I"
        end
      when 409   #ŒûU‚ßƒAƒiƒ‹•KE
        if target.nude?
          action = premess + "#{tec}A\n\#{targetname}‚Ì‹e–å‚Ì‰œ‚Ü‚Åã‚ğ“ü‚ê‚Ä‚«‚½I"
          action.gsub!("—lq‚Å","ãg‚¢‚Å") #•\Œ»‚Ì•ÏX
        else
          action = premess + "#{pantsu}‚²‚ÆA\n\#{targetname}‚Ì‹e–å‚Ì‰œ‚Ü‚Åã‚ğ“ü‚ê‚Ä‚«‚½I"
        end
      when 410   #ŒûU‚ßK’ÇŒ‚
        if target.nude?
          action = premess + "#{tec}A\n\ã‚Å#{targetname}‚Ì‚¨K‚ğ·X‚Éär‚ß‰ñ‚·I"
        else
          action = premess + "#{tec}A\n\#{targetname}‚Ì‚¨K‚ğX‚Éär‚ß‰ñ‚µ‚Ä‚«‚½I"
        end
      when 411   #ŒûU‚ß‘O—§‘B’ÇŒ‚
        if target.nude?
          action = premess + "#{tec}A\n\#{targetname}‚Ì‹e–å‚ğã‚Åˆ¤•‚µ‚Ä‚«‚½I"
        else
          action = premess + "#{pantsu}‚Ìã‚©‚çA\n\#{targetname}‚Ì‹e–å‚ÉX‚Éã‚ğ“ü‚ê‚Ä‚«‚½I"
        end
      when 409   #ŒûU‚ßƒAƒiƒ‹’ÇŒ‚
        if target.nude?
          action = premess + "#{tec}A\n\X‚É#{targetname}‚Ì‹e–å‚ğã‚Åˆ¤•‚µ‚Ä‚«‚½I"
        else
          action = premess + "#{pantsu}‚ğ‚¸‚ç‚µA\n\#{targetname}‚Ì‹e–å‚ğãæ‚Åär‚ßã‚°‚Ä‚«‚½I"
        end
    #------------------------------------------------------------------------#
      when 415   #ƒnƒEƒŠƒ“ƒO
        action = premess + " lets out a loud ho‚—l!"
    #------------------------------------------------------------------------#
      when 416   #–‚«‚ÌŒû•t‚¯
        action = premess + "#{targetname}‚ÌO‚ğ’D‚Á‚½I"
    #------------------------------------------------------------------------#
      when 417   #j•Ÿ‚ÌŒû•t‚¯
        action = premess + "#{targetname}‚ÌO‚ğ’D‚Á‚½I"
    #------------------------------------------------------------------------#
      when 418   #ƒXƒC[ƒgƒEƒBƒXƒp[
        action = premess + "#{targetname}‚ÉŠÃ‚­š‘‚¢‚½I"
    #------------------------------------------------------------------------#
      when 419   #ƒAƒ“ƒ‰ƒbƒL[ƒƒA
        action = premess + "•s‹g‚É–Â‚¢‚½I"
    #------------------------------------------------------------------------#
      when 421   #œğ‰÷‚È‚³‚¢
        action = premess + "“§‚«’Ê‚Á‚½º‚ÅA\n\#{targetname}‚ğˆêŠ…‚µ‚½I"
  #------------------------------------------------------------------------#
  # œ‹¹‹ZŒn
  #------------------------------------------------------------------------#
      #ƒpƒCƒYƒŠ‚Í—¼Ò—‡‚Ì‚İ‚Ì‚½‚ßA’…ˆßƒeƒLƒXƒg‚Í–³‚¢
      when 431   #ƒpƒCƒYƒŠÅ
        action = premess + "#{myself.bustsize}‚Ì’JŠÔ‚ÅA\n\#{targetname}‚ÌƒyƒjƒX‚ğ‹²‚ñ‚Å‚«‚½I"
        action += "\n\‚Ê‚ß‚è‚ğ‘Ñ‚Ñ‚½ƒyƒjƒX‚É‰õŠ´‚ª‚±‚İã‚°‚éI" if target.lub_male >= 60
      when 432   #ƒpƒCƒYƒŠ
        action = premess + "#{myself.bustsize}‚Ì’JŠÔ‚ÅA\n\#{targetname}‚ÌƒyƒjƒX‚ğ‹²‚İ‚µ‚²‚¢‚Ä‚«‚½I"
        action += "\n\‚Ê‚ß‚è‚ğ‘Ñ‚Ñ‚½ƒyƒjƒX‚É‰õŠ´‚ª‘–‚éI" if target.lub_male >= 60
      when 433   #ƒpƒCƒYƒŠ‹­
        action = premess + "#{myself.bustsize}‚Ì’JŠÔ‚ÅA\n\#{targetname}‚ÌƒyƒjƒX‚ğ‚±‚Ë‰ñ‚µ‚Ä‚«‚½I"
        action += "\n\‚Ê‚ß‚è‚ğ‘Ñ‚Ñ‚½ƒyƒjƒX‚É‹­‚¢‰õŠ´‚ª‘–‚éI" if target.lub_male >= 60
      when 434   #ƒpƒCƒYƒŠ•KE
        action = premess + "#{tec}A\n\#{myself.bustsize}‚Ì’JŠÔ‚ÉƒyƒjƒX‚ğ‹²‚İA\n\#{targetname}‚Ì”½‰‚ğŠy‚µ‚İ‚È‚ª‚ç˜M‚ÔI"
        action += "\n\‚Ê‚ß‚è‚ğ‘Ñ‚Ñ‚½ƒyƒjƒX‚É‹­‚¢‰õŠ´‚ª‘–‚éI" if target.lub_male >= 60
      when 435   #C‚è•t‚¯‰
        action = premess + "#{myself.bustsize}‚ğA\n\#{targetname}‚ÌƒyƒjƒX‚ÉC‚è•t‚¯‚Ä‚«‚½I"
        #‹¹ƒTƒCƒYf’f(ƒJƒbƒvw’èA‚bˆÈã‚É‚Í•K—v‚È‚¢)
        case $data_SDB[myself.class_id].bust_size
        when 2 #‚a
          action.gsub!("‚ğA","‚ÅA") 
          action.gsub!("‚ÉC‚è•t‚¯‚Ä‚«‚½","‚ğ‹²‚à‚¤‚ÆŠæ’£‚Á‚Ä‚¢‚é") 
        end
      when 436   #ƒpƒCƒYƒŠ’ÇŒ‚
        action = premess + "#{tec}A\n\#{myself.bustsize}‚É‹²‚Ü‚ê‚½ƒyƒjƒX‚ğ˜M‚ÔI"
        action += "\n\‚Ê‚ß‚è‚ğ‘Ñ‚Ñ‚½ƒyƒjƒX‚É‹­‚¢‰õŠ´‚ª‘–‚éI" if target.lub_male >= 60
      when 437   #C‚è•t‚¯‰’ÇŒ‚
        #‹¹ƒTƒCƒYf’f(ƒJƒbƒvw’èA‚bˆÈã‚É‚Í•K—v‚È‚¢)
        case $data_SDB[myself.class_id].bust_size
        when 2 #‚a
          action = premess + "#{tec}A\n\#{myself.bustsize}‚ÅX‚ÉƒyƒjƒX‚ğC‚èã‚°‚Ä‚«‚½I"
        else
          action = premess + "#{tec}A\n\#{myself.bustsize}‚ğX‚ÉƒyƒjƒX‚ÉC‚è•t‚¯‚Ä‚«‚½I"
        end
  #------------------------------------------------------------------------#
      when 439   #‚Ï‚Ó‚Ï‚ÓÅ
        #Å‚ç‚µ‚Ì‚İ’…ˆß‚Ï‚Ó‚Ï‚Ó‚ª‘¶İ‚·‚é
        if target.nude?
          action = premess + "#{myself.bustsize}‚Ì’JŠÔ‚ğA\n\#{targetname}‚ÌŠç‚É‰Ÿ‚µ•t‚¯‚Ä‚«‚½I"
        else
          action = premess + "“ñ‚Â‚Ì–c‚ç‚İ‚ğ\n\#{targetname}‚ÌŠç‚É‰Ÿ‚µ“–‚Ä‚Ä‚«‚½I"
        end
        #‹¹ƒTƒCƒYf’f(‚bƒJƒbƒvŠî€)
        case $data_SDB[myself.class_id].bust_size
        when 3 #‚b
          action.gsub!("“ñ‚Â","Œ`‚Ì—Ç‚¢“ñ‚Â") 
        when 4 #‚c
          action.gsub!("“ñ‚Â","–L–‚È“ñ‚Â") 
        when 5 #‚dˆÈã
          action.gsub!("“ñ‚Â","ˆ³“|“I‚È“ñ‚Â") 
        end
      when 440   #‚Ï‚Ó‚Ï‚Ó
        action = premess + "#{myself.bustsize}‚Ì’JŠÔ‚ÅA\n\#{targetname}‚ÌŠç‚ğ•ï‚İ‚ñ‚Å‚«‚½I"
      when 441   #‚Ï‚Ó‚Ï‚Ó‹­
        action = premess + "#{myself.bustsize}‚Ì’JŠÔ‚ÉA\n\#{targetname}‚ÌŠç‚ğ‹²‚ñ‚Å•ø‚«’÷‚ß‚Ä‚«‚½I"
      when 442   #‚Ï‚Ó‚Ï‚Ó•KE
        action = premess + "#{myself.bustsize}‚Ì’JŠÔ‚ÉA\n\#{targetname}‚ÌŠç‚ğ‹²‚ñ‚Å#{brk4}‹­‚­•ø‚«’÷‚ß‚Ä‚«‚½I"
      when 443   #•ø‚«‚Â‚«
        action = premess + "#{myself.bustsize}‚ÅA\n\#{targetname}‚ÌŠç‚É•ø‚«‚Â‚¢‚Ä‚«‚½I"
      when 444   #‚Ï‚Ó‚Ï‚Ó’ÇŒ‚
        action = premess + "#{tec}A\n\#{myself.bustsize}‚Ì’JŠÔ‚ğX‚É‰Ÿ‚µ•t‚¯‚Ä‚«‚½I"
      when 445   #•ø‚«‚Â‚«’ÇŒ‚
        #‹¹ƒTƒCƒYf’f(ƒJƒbƒvw’èA‚bˆÈã‚É‚Í•K—v‚È‚¢)
        case $data_SDB[myself.class_id].bust_size
        when 2 #‚a
          action = premess + "#{tec}A\n\#{myself.bustsize}‚ÅX‚É•ø‚«‚µ‚ß‚Ä‚«‚½I"
        else
          action = premess + "#{tec}A\n\#{myself.bustsize}‚ğX‚É‰Ÿ‚µ“–‚Ä‚Ä‚«‚½I"
        end
  #------------------------------------------------------------------------#
      when 447   #‹¹‡‚í‚¹Å
        action = premess + "#{myself.bustsize}‚ğA\n\#{targetname}‚Ì#{target.bustsize}‚É#{brk3}‰Ÿ‚µ“–‚Ä‚Ä‚«‚½I"
      when 448   #‹¹‡‚í‚¹
        action = premess + "#{myself.bustsize}‚ğA\n\#{targetname}‚Ì#{target.bustsize}‚É#{brk3}C‚è•t‚¯‚Ä‚«‚½I"
      when 449   #‹¹‡‚í‚¹‹­
        action = premess + "Œİ‚¢‚Ì‹¹‚ğC‚è‚ ‚í‚¹A\n\©‚ç‚Ì“ûñ‚Å#{targetname}‚Ì“ûñ‚ğ˜M‚Á‚Ä‚«‚½I"
      when 450   #‹¹‡‚í‚¹•KE
        action = premess + "‹­‚­•ø‚«‡‚Á‚ÄA\n\#{targetname}‚É#{myself.bustsize}‚ğC‚è‚Â‚¯‚Ä‚«‚½I\n\Œİ‚¢‚Ì‹¹‚ªˆú‚ç‚É˜c‚İ—x‚éI"
      when 451   #‹¹C‚è•t‚¯Å
        action = premess + "#{myself.bustsize}‚ğA\n\#{targetname}‚Ì#{target.bustsize}‚É#{brk3}‰Ÿ‚µ“–‚Ä‚Ä‚«‚½I"
      when 452   #‹¹C‚è•t‚¯•KE
        action = premess + "#{myself.bustsize}‚ğA\n\#{targetname}‚Ì#{target.bustsize}‚É#{brk3}C‚è•t‚¯‚Ä‚«‚½I"
      when 453   #‹¹‡‚í‚¹’ÇŒ‚
        brk2 = ""
        brk2 = "\n" if myself.bustsize.size + target.bustsize.size > 36 #—¼Ò‚Ì‹¹•\Œ»‚ğ‘«‚µ‚Ä‚P‚Q•¶š‰z‚¦‚ÅÜ‚è•Ô‚·
        action = premess + "#{tec}A\n\#{myself.bustsize}‚Æ#{target.bustsize}‚ğ#{brk2}Œİ‚¢‚ÉC‚è•t‚¯‡‚¤I"
      when 454   #‹¹C‚è•t‚¯’ÇŒ‚
        brk2 = ""
        brk2 = "\n" if myself.bustsize.size + target.bustsize.size > 36 #—¼Ò‚Ì‹¹•\Œ»‚ğ‘«‚µ‚Ä‚P‚Q•¶š‰z‚¦‚ÅÜ‚è•Ô‚·
        action = premess + "#{tec}A\n\#{myself.bustsize}‚Æ#{target.bustsize}‚ğ#{brk2}Œİ‚¢‚ÉC‚è•t‚¯‡‚¤I"
  #------------------------------------------------------------------------#
  # œƒAƒ\ƒR‹ZŒn(‘O’ñ‚ª—‡‚È‚½‚ßAğŒ‚ª’…ˆß‚ÌƒeƒLƒXƒg‚Í–³‚¢)
  #------------------------------------------------------------------------#
      when 473   #‘fŒÒÅ
        action = premess + "ƒAƒ\ƒR‚ğ‰Ÿ‚µ•t‚¯A\n\#{targetname}‚ÌƒyƒjƒX‚ğ‚ä‚Á‚­‚èC‚Á‚Ä‚«‚½I"
        action += "\n\‚Ê‚ß‚è‚ğ‘Ñ‚Ñ‚½ƒyƒjƒX‚É‰õŠ´‚ª‚±‚İã‚°‚éI" if target.lub_male >= 60
      when 474   #‘fŒÒ
        action = premess + "ƒAƒ\ƒR‚ğ‰Ÿ‚µ•t‚¯A\n\#{targetname}‚ÌƒyƒjƒX‚ğ‚µ‚²‚¢‚Ä‚«‚½I"
        action += "\n\‚Ê‚ß‚è‚ğ‘Ñ‚Ñ‚½ƒyƒjƒX‚É‰õŠ´‚ª‘–‚éI" if target.lub_male >= 60
      when 475   #‘fŒÒ‹­
        action = premess + "ƒAƒ\ƒR‚ğ‰Ÿ‚µ•t‚¯A\n\#{targetname}‚ÌƒyƒjƒX‚ğ‚µ‚²‚«ã‚°‚Ä‚«‚½I"
        action += "\n\‚Ê‚ß‚è‚ğ‘Ñ‚Ñ‚½ƒyƒjƒX‚É‹­‚¢‰õŠ´‚ª‘–‚éI" if target.lub_male >= 60
      when 476   #‘fŒÒ•KE
        action = premess + "#{tec}A\n\#{targetname}‚É”næ‚è‚É‚È‚è#{brk4}ƒyƒjƒX‚ğ˜M‚ñ‚Å‚¢‚éI"
        action += "\n\‚Ê‚ß‚è‚ğ‘Ñ‚Ñ‚½ƒyƒjƒX‚É‹­‚¢‰õŠ´‚ª‘–‚éI" if target.lub_male >= 60
      when 477   #‘fŒÒ’ÇŒ‚
        action = premess + "#{tec}A\n\#{targetname}‚É”næ‚è‚Ì‚Ü‚Ü#{brk4}ƒyƒjƒX‚ğ˜M‚ñ‚Å‚¢‚éI"
        action += "\n\‚Ê‚ß‚è‚ğ‘Ñ‚Ñ‚½ƒyƒjƒX‚É‹­‚¢‰õŠ´‚ª‘–‚éI" if target.lub_male >= 60
  #------------------------------------------------------------------------#
  # œ‘«‹ZŒn
  #------------------------------------------------------------------------#
      when 486   #‘«ƒRƒLÅ
        if target.nude?
          action = premess + "‘«‚Ì— ‚ÅA\n\#{targetname}‚ÌƒyƒjƒX‚ğ—D‚µ‚­‚³‚·‚Á‚Ä‚«‚½I"
          action += "\n\‚Ê‚ß‚è‚ğ‘Ñ‚Ñ‚½ƒyƒjƒX‚É‰õŠ´‚ª‚±‚İã‚°‚éI" if target.lub_male >= 60
        else
          action = premess + "•‚Ìã‚©‚çA\n\#{targetname}‚ÌƒyƒjƒX‚ğ‘«‚Ì— ‚Å#{brk4}hŒƒ‚µ‚Ä‚«‚½I"
        end
      when 487   #‘«ƒRƒL
        if target.nude?
          action = premess + "‘«‚Ìw‚ÅA\n\#{targetname}‚ÌƒyƒjƒX‚ğˆ¤•‚µ‚Ä‚«‚½I"
          action += "\n\‚Ê‚ß‚è‚ğ‘Ñ‚Ñ‚½ƒyƒjƒX‚É‰õŠ´‚ª‘–‚éI" if target.lub_male >= 60
        else
          action = premess + "•‚Ìã‚©‚çA\n\#{targetname}‚ÌƒyƒjƒX‚ğ‘«‚Ìw‚Å#{brk4}ˆ¤•‚µ‚Ä‚«‚½I"
        end
      when 488   #‘«ƒRƒL•KE
        if target.nude?
          action = premess + "#{tec}A\n\#{targetname}‚ÌƒyƒjƒX‚ğ‘«‚Åv‚¤‚Ü‚Ü˜M‚ÔI"
          action += "\n\‚Ê‚ß‚è‚ğ‘Ñ‚Ñ‚½ƒyƒjƒX‚É‹­‚¢‰õŠ´‚ª‘–‚éI" if target.lub_male >= 60
        else
          action = premess + "•‚Ì’†‚É‘«æ‚ğ‚Ë‚¶“ü‚êA\n\#{targetname}‚ÌƒyƒjƒX‚ğX‚É‘«w‚Å˜M‚Á‚Ä‚«‚½I"
        end
      when 489   #‘«ƒRƒL’ÇŒ‚
        if target.nude?
          action = premess + "#{tec}A\n\#{targetname}‚ÌƒyƒjƒX‚ğX‚É‘«‚ÅU‚ß—§‚Ä‚éI"
          action += "\n\‚Ê‚ß‚è‚ğ‘Ñ‚Ñ‚½ƒyƒjƒX‚É‹­‚¢‰õŠ´‚ª‘–‚éI" if target.lub_male >= 60
        else
          action = premess + "•‚Ì’†‚É‘«æ‚ğ‚Ë‚¶‚İA\n\#{targetname}‚ÌƒyƒjƒX‚ğ‘«w‚Å˜M‚Á‚Ä‚«‚½I"
        end
  #------------------------------------------------------------------------#
      when 491   #‘«U‚ß‹¹Å
        if target.nude?
          action = premess + "‘«‚Ìw‚ÅA\n\#{targetname}‚Ì#{target.bustsize}‚ğ#{brk3}¬‚İ‚ÉhŒƒ‚µ‚Ä‚«‚½I"
        else
          action = premess + "•‚Ìã‚©‚çA\n\#{targetname}‚Ì#{target.bustsize}‚ğ#{brk3}‘«— ‚ÅhŒƒ‚µ‚Ä‚«‚½I"
        end
      when 492   #‘«U‚ß‹¹
        if target.nude?
          action = premess + "‘«‚Ìw‚ÅA\n\#{targetname}‚Ì#{target.bustsize}‚ğ#{brk3}†‚İ‚µ‚¾‚¢‚Ä‚«‚½I"
          action = premess + "‘«‚Ìw‚ÅA\n\#{targetname}‚Ì“ûñ‚ğ‹­‚­”P‚èã‚°‚Ä‚«‚½I" if $game_variables[17] > 50
        else
          action = premess + "•‚Ìã‚©‚çA\n\#{targetname}‚Ì#{target.bustsize}‚ğ#{brk3}‘«‚Ìw‚ÅhŒƒ‚µ‚Ä‚«‚½I"
        end
      when 493   #‘«U‚ß‹¹•KE
        if target.nude?
          action = premess + "#{tec}A\n\#{targetname}‚Ì#{target.bustsize}‚ğ#{brk3}‘«‚Åv‚¤‚Ü‚Ü˜M‚ÔI"
        else
          action = premess + "•‚ÌŒ„ŠÔ‚©‚ç‘«æ‚ğ‚Ë‚¶“ü‚êA\n\#{targetname}‚Ì#{target.bustsize}‚ğ#{brk3}v‚¤‚Ü‚Ü˜M‚ÔI"
        end
      when 494   #‘«U‚ß‹¹’ÇŒ‚
        if target.nude?
          action = premess + "#{tec}A\n\#{targetname}‚Ì#{target.bustsize}‚ğ#{brk3}‘«‚ÅX‚ÉU‚ß—§‚Ä‚éI"
        else
          action = premess + "•‚ÌŒ„ŠÔ‚©‚ç‘«æ‚ğ‚Ë‚¶‚İA\n\#{targetname}‚Ì#{target.bustsize}‚ğ#{brk3}‘«‚ÅX‚ÉhŒƒ‚µ‚Ä‚«‚½I"
        end
  #------------------------------------------------------------------------#
      when 496   #‘«U‚ßƒAƒ\ƒRÅ
        if target.nude?
          action = premess + "‘«— ‚ÅA\n\#{targetname}‚ÌƒAƒ\ƒR‚ğ¬‚İ‚ÉhŒƒ‚µ‚Ä‚«‚½I"
        else
          action = premess + "#{pantsu}‚Ìã‚©‚çA\n\#{targetname}‚ÌƒAƒ\ƒR‚ğ‘«— ‚ÅhŒƒ‚µ‚Ä‚«‚½I"
        end
      when 497   #‘«U‚ßƒAƒ\ƒR
        if target.nude?
          action = premess + "‘«‚Ìw‚ÅA\n\#{targetname}‚ÌƒAƒ\ƒR‚ğ‚®‚è‚®‚èhŒƒ‚µ‚Ä‚«‚½I"
        else
          action = premess + "#{pantsu}‚Ìã‚©‚çA\n\#{targetname}‚ÌƒAƒ\ƒR‚ğ‘«‚Ìw‚ÅhŒƒ‚µ‚Ä‚«‚½I"
        end
      when 498   #‘«U‚ßƒAƒ\ƒR•KE
        if target.nude?
          action = premess + "#{tec}A\n\#{targetname}‚ÌƒAƒ\ƒR‚ğ‘«w‚Åv‚¤‚Ü‚Ü˜M‚ÔI"
        else
          action = premess + "#{pantsu}‚É‘«æ‚ğ‚Ë‚¶“ü‚êA\n\#{targetname}‚ÌƒAƒ\ƒR‚ğv‚¤‚Ü‚Ü˜M‚ÔI"
        end
      when 499   #‘«U‚ßƒAƒ\ƒR•KE
        if target.nude?
          action = premess + "#{tec}A\n\#{targetname}‚ÌƒAƒ\ƒR‚ğ#{brk4}‘«w‚Å‚È‚¨‚àU‚ß—§‚Ä‚éI"
        else
          action = premess + "#{pantsu}‚É‚Ë‚¶‚ñ‚¾‘«æ‚ÅA\n\#{targetname}‚ÌƒAƒ\ƒR‚ğX‚ÉU‚ß—§‚Ä‚éI"
        end
  #------------------------------------------------------------------------#
  # œˆ¤•‹Z
  #------------------------------------------------------------------------#
      when 508   #ˆ¤•EŠçü‚è
        case $game_variables[17]
        when 0..24
          action = premess + "ãæ‚ÅA\n\#{targetname}‚Ìñ‹Ø‚ğ‚Â‚¤‚Á‚Æ‚È‚¼‚Á‚Ä‚«‚½I"
        when 25..50
          action = premess + "O‚ÅA\n\#{targetname}‚Ì¨‚½‚Ô‚ğŠÃŠš‚İ‚µ‚Ä‚«‚½I"
        when 51..75
          action = premess + "A\n\#{targetname}‚ÌŠz‚É‚»‚Á‚ÆƒLƒX‚ğ‚µ‚½I"
        else
          action = premess + "A\n\#{targetname}‚Ì–j‚É‚»‚Á‚ÆƒLƒX‚ğ‚µ‚½I"
        end
      when 509   #ˆ¤•Eã”¼g
        case $game_variables[17]
        when 0..24
          action = premess + "è‚ÅA\n\#{targetname}‚Ì”w’†‚ğ—D‚µ‚­•‚Å‚Ä‚«‚½I"
        when 25..50
          action = premess + "ãæ‚ÅA\n\#{targetname}‚Ì‚Ö‚»‚Ìü‚è‚ğär‚ß‚Ä‚«‚½I"
        when 51..75
          action = premess + "ã–Úg‚¢‚ÅA\n\#{targetname}‚Ìw‚ğ’š”J‚É‚µ‚á‚Ô‚Á‚Ä‚«‚½I"
        else
          action = premess + "ãæ‚ÅA\n\#{targetname}‚Ì˜e‚ğ‚Â‚£‚Á‚Æ‚È‚¼‚Á‚Ä‚«‚½I"
        end
      when 510   #ˆ¤•E‰º”¼g(å‚É‹r)
        case $game_variables[17]
        when 0..24
          action = premess + "wæ‚ÅA\n\#{targetname}‚Ì˜‚ğ‚Â‚£‚Á‚Æ‚È‚¼‚Á‚Ä‚«‚½I"
        when 25..50
          action = premess + "è‚ÅA\n\#{targetname}‚Ì‘¾‚à‚à‚ğ•‚Å‚Ä‚«‚½I"
        when 51..75
          action = premess + "©•ª‚Ì‹r‚ğA\n\#{targetname}‚Ì‘«‚É—‚Ü‚¹‚Ä‚«‚½I"
        else
          action = premess + "ã‚ÅA\n\#{targetname}‚Ì‘«‚Ìw‚ğ’š”J‚Éär‚ß‚Ä‚«‚½I"
        end
      when 511   #ˆ¤•E”¯•‚Å
        action = premess + "wæ‚ÅA\n\#{targetname}‚Ì”¯‚ğ‚Ó‚í‚è‚Æ‚©‚«ã‚°‚Ä‚«‚½I"
        action = premess + "è‚Ì‚Ğ‚ç‚ÅA\n\#{targetname}‚Ì”¯‚ğ‚³‚í‚³‚í‚Æ•‚Å‚Ä‚«‚½I" if $game_variables[17] > 50
      when 512   #ˆ¤•E•ø‚«‚µ‚ß
        action = premess + "A\n\#{targetname}‚ğ—D‚µ‚­•ø‚«‚µ‚ß‚Ä‚«‚½I"
  #------------------------------------------------------------------------#
      when 515   #K”öU‚ß‰EÅ
        action = premess + "#{targetname}‚Ì#{pantsu}‚Ì’†‚ÉA\n\#{tail}‚ğö‚è‚Ü‚¹ƒyƒjƒX‚ğˆ¤•‚µ‚Ä‚«‚½I"
        action = premess + "#{targetname}‚ÌƒyƒjƒX‚ÉA\n\#{tail}‚ğ—‚ß‚ÄC‚èã‚°‚Ä‚«‚½I" if target.nude?
  #------------------------------------------------------------------------#
      when 523   #K”öU‚ß‹¹EÅ
        action = premess + "#{tail}‚ğg‚¢A\n\•‚ÌŠÔ‚©‚ç#{targetname}‚Ì#{brk3}#{target.bustsize}‚ğˆ¤•‚µ‚½I"
        action = premess + "#{tail}‚ğg‚¢A\n\#{targetname}‚Ì#{target.bustsize}‚ğˆ¤•‚µ‚½I" if target.nude?
  #------------------------------------------------------------------------#
      when 528   #K”öU‚ßŠEÅ
        action = premess + "#{targetname}‚Ì#{pantsu}‚Ì’†‚ÉA\n\#{tail}‚ğö‚è‚Ü‚¹‚ÄƒAƒ\ƒR‚ğˆ¤•‚µ‚Ä‚«‚½I"
        action = premess + "#{targetname}‚ÌƒAƒ\ƒR‚ÉA\n\#{tail}‚ğC‚è•t‚¯‚Äˆ¤•‚µ‚Ä‚«‚½I" if target.nude?
  #------------------------------------------------------------------------#
      when 536   #K”öU‚ßKEÅ
        action = premess + "#{targetname}‚Ì#{pantsu}‚ÌŒ„ŠÔ‚©‚çA\n\#{tail}‚ğŠŠ‚è‚Ü‚¹‚Äˆ¤•‚µ‚Ä‚«‚½I"
        action = premess + "#{targetname}‚Ì‚¨K‚ÉA\n\#{tail}‚ğŠŠ‚ç‚¹‚Äˆ¤•‚µ‚Ä‚«‚½I" if target.nude?
  #------------------------------------------------------------------------#
  # œ“Áêg‘ÌŒn
  #------------------------------------------------------------------------#
      when 586   #ƒŒƒXƒgƒŒ[ƒVƒ‡ƒ“
        action = "#{myname}‚Ìg‘Ì‚Ì”S‰t‚ª‘‚¦‚Ä‚¢‚­ccI\n\#{myname}‚Ìg‘Ì‚ªÄ‚Ñ”S‰t‚Å•¢‚í‚ê‚½I"
      when 587   #ƒXƒ‰ƒCƒ~[ƒŠƒLƒbƒh
        action = premess + "g‘Ì‚Ì”S‰t‚ğè‚Éæ‚èA\n\#{targetname}‚Ì•‚ÌŒ„ŠÔ‚©‚ç—¬‚µ“ü‚ê‚Ä‚«‚½I"
        action = premess + "g‘Ì‚Ì”S‰t‚ğè‚Éæ‚èA\n\#{targetname}‚Ìg‘Ì‚É“h‚è‚Â‚¯‚Ä‚«‚½I" if target.nude?
      when 588   #Œƒ—ã
        action = premess + "#{targetname}‚ğŒƒ—ã‚µ‚½I"
      when 589   #ƒoƒbƒhƒXƒ|ƒA
        action = premess + "A\n\#{targetname}‚É–Eq‚ğ‚«‚©‚¯‚½I"
      when 590   #ƒXƒ|ƒAƒNƒ‰ƒEƒh
        action = premess + "•Ó‚èˆê–Ê‚É–Eq‚ğU‚è‚Ü‚¢‚½I"
      when 591   #ƒAƒCƒ”ƒBƒNƒ[ƒY
        action = premess + "‚µ‚È‚é’Ó‚ğA\n\#{targetname}‚Ìg‘Ì‚ÉŠª‚«•t‚¯‚½I"
      when 592   #ƒfƒ‚ƒ“ƒYƒNƒ[ƒY
        action = "#{myname}‚Ì‘€‚éGè‚ªA\n\å¿‚­‚æ‚¤‚É#{targetname}‚Ìg‘Ì‚ÉŠª‚«•t‚¢‚½I"
      when 599   #Å‘‡
        action = premess + "©•ª‚ğ‹}‚«—§‚Ä‚½I"
      when 600   #êS
        action = premess + "–Ú‚ğáÒ‚èW’†‚µ‚½I"
      when 601   #–{”\‚ÌŒÄ‚ÑŠo‚Ü‚µ
        action = premess + "“à‚É–°‚é–{”\‚ğŒÄ‚ÑŠo‚Ü‚µ‚½I"
      when 602   #©M‰ßè
        action = premess + "©‚ç‚Ì”ü–e‚ÉŒ‚¢‚µ‚ê‚½I"# + "\n\‚»‚Ì—h‚é‚¬‚È‚¢©M‚Í—Í‚Æ‚È‚éI"
    #------------------------------------------------------------------------#
      when 611   #ƒŠƒ‰ƒbƒNƒXƒ^ƒCƒ€
        action = premess + " calls for relaxation!"
      when 612   #ƒXƒC[ƒgƒAƒƒ}
        action = premess + " is releasing a s‚—eet fragrance!"
      when 613   #ƒpƒbƒVƒ‡ƒ“ƒr[ƒg
        action = premess + "ŒÛ•‘‚µA‚â‚é‹C‚ğ‚‚ß‚½I"
      when 614   #ƒ}ƒCƒ‹ƒhƒpƒtƒ…[ƒ€
        action = premess + " lets off a gentle fragrance!"
      when 615   #ƒŒƒbƒhƒJ[ƒyƒbƒg
        action = premess + " used Red Carpet!"
      when 618   #ƒXƒgƒŒƒ“ƒWƒXƒ|ƒA
        action = premess + "Šï–­‚È–Eq‚ğU‚è‚Ü‚¢‚½I"
      when 619   #ƒEƒB[ƒNƒXƒ|ƒA
        action = premess + "–Eq‚ğU‚è‚Ü‚¢‚½I"
      when 620   #ˆĞ”—
        action = premess + "ˆĞ”—‚µ‚½I"
      when 621   #S’Í‚İ
        action = premess + "‚¶‚Á‚ÆŒ©‚Â‚ß‚½I"
      when 622   #‘S‚Ä‚ÍŒ»
        action = premess + "‘S‚Ä‚ÍŒ»‚¾‚Æv‚¢’m‚ç‚¹‚½I"
      when 625   #ƒ‰ƒuƒtƒŒƒOƒ‰ƒ“ƒX
        action = premess + "ƒsƒ“ƒNF‚Ì‚è‚ğU‚è‚Ü‚¢‚½I"
      when 626   #ƒXƒ‰ƒCƒ€ƒtƒB[ƒ‹ƒh
        action = premess + "g‘Ì‚Ì”S‰t‚ğüˆÍ‚ÉL‚°‚½I"
    #------------------------------------------------------------------------#
      when 631   #Œƒ—ã‚ğó‚¯‚é
        action = premess + "Œƒ—ã‚ğó‚¯‚½I"
  #------------------------------------------------------------------------#
  # œƒOƒ‰ƒCƒ“ƒhŒn
  #------------------------------------------------------------------------#
      when 751   #ƒOƒ‰ƒCƒ“ƒhã
        waist = ["‚ä‚Á‚­‚è‚Æ","T‚¦‚ß‚É"]
        waist.push("‚ä‚Á‚½‚è‚Æ") if myself.positive?
        waist.push("Å‚ç‚·‚æ‚¤‚É") if myself.positive?
        waist.push("‚¨‚¸‚¨‚¸‚Æ") if myself.negative?
        waist.push("’p‚ç‚¢‚Â‚Â‚à") if myself.negative?
        waist = waist[rand(waist.size)]
        action = premess + "#{waist}˜‚ğ“®‚©‚µ‚Ä‚«‚½I"
      when 752   #ƒOƒ‰ƒCƒ“ƒh’†
        waist = ["‘OŒã‚É","¶‰E‚É"]
        waist.push("‰ñ‚·‚æ‚¤‚É") if myself.positive?
        waist.push("’p‚ç‚¢‚Â‚Â") if myself.negative?
        waist = waist[rand(waist.size)]
        action = premess + "#{waist}˜‚ğU‚Á‚Ä‚«‚½I"
      when 753   #ƒOƒ‰ƒCƒ“ƒh‹­
        waist = ["‘å’_‚É","‘å‚«‚­","Œƒ‚µ‚­"]
        waist.push("ŠÉ‹}‚ğ‚Â‚¯‚Ä") if myself.positive?
        waist.push("‚¤‚Ë‚é‚æ‚¤‚É") if myself.positive?
        waist.push("‰‚©‚µ‚­") if myself.positive?
        waist.push("ˆêŠŒœ–½‚É") if myself.negative?
        waist.push("ˆêS•s—‚É") if myself.negative?
        waist.push("“ ‚¯‚½•\î‚Å") if myself.negative?
        waist = waist[rand(waist.size)]
        action = premess + "#{waist}˜‚ğU‚èn‚ß‚½I"
      when 754   #ƒOƒ‰ƒCƒ“ƒh•KE
        waist = ["‘å’_‚É","‘å‚«‚­","Œƒ‚µ‚­"]
        waist.push("ŠÉ‹}‚ğ‚Â‚¯‚Ä") if myself.positive?
        waist.push("‚¤‚Ë‚é‚æ‚¤‚É") if myself.positive?
        waist.push("‰‚©‚µ‚­") if myself.positive?
        waist.push("ˆêŠŒœ–½‚É") if myself.negative?
        waist.push("ˆêS•s—‚É") if myself.negative?
        waist.push("“ ‚¯‚½•\î‚Å") if myself.negative?
        waist = waist[rand(waist.size)]
        action = premess + "#{waist}˜‚ğU‚Á‚Ä‚«‚½I"
      when 755   #’÷‚ß‚é
        action = premess + "ƒAƒ\ƒR‚ğ‚«‚ã‚Á‚Æ’÷‚ß‚Ä‚«‚½I"
        action = "#{myname}‚ÌƒAƒ\ƒR‚ª‚«‚ã‚Á‚Æ’÷‚Ü‚Á‚½I" if myself.negative?
      when 756   #’÷‚ß‚é•KE
        action = premess + "ƒAƒ\ƒR‚ğ‚¬‚ã‚Á‚Æ‹­‚­’÷‚ß‚Ä‚«‚½I"
        action = "#{myname}‚ÌƒAƒ\ƒR‚ª‚¬‚ã‚Á‚Æ‹­‚­’÷‚Ü‚Á‚½I" if myself.negative?
      when 757   #ƒOƒ‰ƒCƒ“ƒh’ÇŒ‚
        waist = ["‘å’_‚É","‘å‚«‚­","Œƒ‚µ‚­"]
        waist.push("ŠÉ‹}‚ğ‚Â‚¯‚Ä") if myself.positive?
        waist.push("‚¤‚Ë‚é‚æ‚¤‚É") if myself.positive?
        waist.push("‰‚©‚µ‚­") if myself.positive?
        waist.push("ˆêŠŒœ–½‚É") if myself.negative?
        waist.push("ˆêS•s—‚É") if myself.negative?
        waist = waist[rand(waist.size)]
        action = premess + "#{tec}A\n\X‚É#{waist}˜‚ğ‘OŒã‚³‚¹‚Ä‚«‚½I"
      when 758   #’÷‚ß‚é’ÇŒ‚
        action = "#{myname}‚ÌƒAƒ\ƒR‚ª•Ê‚Ì¶‚«•¨‚Ì‚æ‚¤‚ÉA\n#{targetname}‚ÌƒyƒjƒX‚ğŠ¯”\“I‚É’÷‚ß•t‚¯‚éI"
  #------------------------------------------------------------------------#
      when 760   #ŠL‡‚í‚¹Å
        action = premess + "#{brk}#{targetname}‚Æ‹r‚ğ—‚ß‚ ‚¢A\n\ƒAƒ\ƒR“¯m‚ğ‰Ÿ‚µ“–‚Ä‚½I"
      when 761   #ŠL‡‚í‚¹
        action = premess + "#{brk}#{targetname}‚Æ‹r‚ğ—‚ß‚ ‚¢A\n\ƒAƒ\ƒR“¯m‚ğC‚è‡‚í‚¹‚½I"
      when 762   #ŠL‡‚í‚¹‹­
        waist = ["‘å’_‚É","‹­‚­","Œƒ‚µ‚­"]
        waist.push("ŠÉ‹}‚ğ‚Â‚¯‚Ä") if myself.positive?
        waist.push("‚¤‚Ë‚é‚æ‚¤‚É") if myself.positive?
        waist.push("‰‚©‚µ‚­") if myself.positive?
        waist.push("ˆêŠŒœ–½‚É") if myself.negative?
        waist.push("ˆêS•s—‚É") if myself.negative?
        waist = waist[rand(waist.size)]
        action = premess + "#{brk}#{targetname}‚Æ‹r‚ğ—‚ß‚ ‚¢A\n\ƒAƒ\ƒR“¯m‚ğ#{waist}C‚è‡‚í‚¹‚½I"
      when 763   #ŠL‡‚í‚¹•KE
        waist = ["‘å’_‚É","‹­‚­","Œƒ‚µ‚­"]
        waist.push("ŠÉ‹}‚ğ‚Â‚¯‚Ä") if myself.positive?
        waist.push("‚¤‚Ë‚é‚æ‚¤‚É") if myself.positive?
        waist.push("‰‚©‚µ‚­") if myself.positive?
        waist.push("ˆêŠŒœ–½‚É") if myself.negative?
        waist.push("ˆêS•s—‚É") if myself.negative?
        waist = waist[rand(waist.size)]
        action = premess + "#{brk}#{targetname}‚Æ‹r‚ğ—‚ß‚ ‚¢A\n\ƒAƒ\ƒR“¯m‚ğ#{waist}C‚è‡‚í‚¹‚½I"
      when 764   #ŠL‡‚í‚¹’ÇŒ‚
        waist = ["‘å’_‚É","‹­‚­","Œƒ‚µ‚­"]
        waist.push("ŠÉ‹}‚ğ‚Â‚¯‚Ä") if myself.positive?
        waist.push("‚¤‚Ë‚é‚æ‚¤‚É") if myself.positive?
        waist.push("‰‚©‚µ‚­") if myself.positive?
        waist.push("ˆêŠŒœ–½‚É") if myself.negative?
        waist.push("ˆêS•s—‚É") if myself.negative?
        waist = waist[rand(waist.size)]
        action = premess + "#{brk}#{targetname}‚Ì‹r‚ğ•ø‚¦A\n\X‚ÉƒAƒ\ƒR“¯m‚ğ#{waist}C‚è‡‚í‚¹‚½I"
  #------------------------------------------------------------------------#
      when 766   #ƒ‰ƒCƒfƒBƒ“ƒOÅ
        if myself.nude?
          action = premess + "#{brk}#{targetname}‚É‚Ü‚½‚ª‚Á‚½‚Ü‚ÜA\n\ƒAƒ\ƒR‚ğŒû‚É‰Ÿ‚µ•t‚¯‚Ä‚«‚½I"
        else
          case $data_SDB[myself.class_id].name
          when "Caster","Familiar","Little Witch","Witch "
            action = premess + "ƒXƒJ[ƒg‚Ì’[‚ğ‚¿A\n\#{targetname}‚ÌŒû‚É#{pantsu}‚ğ‰Ÿ‚µ•t‚¯‚½I"
          when "Lesser Succubus ","Succubus"
            action = premess + "drops do‚—n her hipsA\n\#{targetname}‚ÌŒû‚É#{pantsu}‚ğ‰Ÿ‚µ•t‚¯‚½I"
          when "I‚p","Devil "
            action = premess + "drops do‚—n her hipsA\n\#{targetname}‚ÌŒû‚É#{pantsu}‚ğ‰Ÿ‚µ•t‚¯‚½I"
          when "Sli‚e"
            action = premess + "#{brk}#{targetname}‚É‚Ü‚½‚ª‚Á‚½‚Ü‚ÜA\n\ŒÒ‚ÌŒE‚İ‚ğ‰Ÿ‚µ•t‚¯‚Ä‚«‚½I"
          when "Night‚are"
            action = premess + "drops do‚—n her hipsA\n\#{targetname}‚ÌŒû‚É#{pantsu}‰z‚µ‚ÌƒAƒ\ƒR‚ğ‰Ÿ‚µ•t‚¯‚½I"
          else
            action = premess + "drops do‚—n her hipsA\n\#{targetname}‚ÌŒû‚É#{pantsu}‚ğ‰Ÿ‚µ•t‚¯‚½I"
          end
        end
      when 767   #ƒ‰ƒCƒfƒBƒ“ƒO
        if myself.nude?
          action = premess + "#{brk}#{targetname}‚É‚Ü‚½‚ª‚Á‚½‚Ü‚ÜA\n\‚ä‚Á‚­‚è‚Æ˜‚ğ‘OŒã‚ÉU‚Á‚Ä‚«‚½I"
        else
          case $data_SDB[myself.class_id].name
          when "Caster","Familiar","Little Witch","Witch "
            action = premess + "ƒXƒJ[ƒg‚Ì’[‚ğ‚¿A\n\#{targetname}‚ÌŒû‚É#{pantsu}‚ğ‰Ÿ‚µ•t‚¯‚½I"
          when "Lesser Succubus ","Succubus"
            action = premess + "˜‚ğ—‚Æ‚µA\n\#{targetname}‚ÌŒû‚É#{pantsu}‚ğ‰Ÿ‚µ•t‚¯‚½I"
          when "I‚p","Devil "
            action = premess + "˜‚ğ—‚Æ‚µA\n\#{targetname}‚ÌŒû‚É#{pantsu}‚ğ‰Ÿ‚µ•t‚¯‚½I"
          when "Sli‚e"
            action = premess + "#{brk}#{targetname}‚É‚Ü‚½‚ª‚Á‚½‚Ü‚ÜA\n\ŒÒ‚ÌŒE‚İ‚ğ‹­‚­‰Ÿ‚µ•t‚¯‚Ä‚«‚½I"
          when "Night‚are"
            action = premess + "˜‚ğ—‚Æ‚µA\n\#{targetname}‚ÌŒû‚É#{pantsu}‰z‚µ‚ÌƒAƒ\ƒR‚ğ‰Ÿ‚µ•t‚¯‚½I"
          else
            action = premess + "˜‚ğ—‚Æ‚µA\n\#{targetname}‚ÌŒû‚É#{pantsu}‚ğ‰Ÿ‚µ•t‚¯‚½I"
          end
        end
      when 768   #ƒ‰ƒCƒfƒBƒ“ƒO•KE
        waist = ["‘å’_‚É","‰ñ‚·‚æ‚¤‚É","Œƒ‚µ‚­"]
        waist.push("ŠÉ‹}‚ğ‚Â‚¯‚Ä") if myself.positive?
        waist.push("‚¤‚Ë‚é‚æ‚¤‚É") if myself.positive?
        waist.push("‰‚©‚µ‚­") if myself.positive?
        waist.push("ˆêŠŒœ–½‚É") if myself.negative?
        waist.push("ˆêS•s—‚É") if myself.negative?
        waist = waist[rand(waist.size)]
        action = premess + "#{brk}#{targetname}‚ÉŒ©‚¹•t‚¯‚é‚æ‚¤‚ÉA\n\Šç‚Ìã‚Å#{waist}˜‚ğU‚Á‚Ä‚«‚½I"
      when 769   #ƒ‰ƒCƒfƒBƒ“ƒO’ÇŒ‚
        waist = ["‘å’_‚É","Œƒ‚µ‚­"]
        waist.push("ŠÉ‹}‚ğ‚Â‚¯‚Ä") if myself.positive?
        waist.push("‚¤‚Ë‚é‚æ‚¤‚É") if myself.positive?
        waist.push("—x‚é‚æ‚¤‚É") if myself.positive?
        waist.push("ˆêŠŒœ–½‚É") if myself.negative?
        waist.push("ˆêS•s—‚É") if myself.negative?
        waist = waist[rand(waist.size)]
        action = premess + "#{brk}#{targetname}‚É”næ‚è‚Ì‚Ü‚ÜA\n\X‚É#{waist}˜‚ğ‘OŒã‚ÉU‚Á‚Ä‚«‚½I"
  #------------------------------------------------------------------------#
      when 772   #ƒGƒiƒW[ƒhƒŒƒCƒ“
        action = premess + "i‚èæ‚é‚æ‚¤‚É˜‚ğU‚Á‚Ä‚«‚½I"
      when 773   #ƒŒƒxƒ‹ƒhƒŒƒCƒ“
        action = premess + "i‚èæ‚é‚æ‚¤‚É˜‚ğU‚Á‚Ä‚«‚½I"
  #------------------------------------------------------------------------#
      when 788   #ƒtƒFƒ‰ƒ`ƒIÅ
        action = premess + "#{targetname}‚ÌƒyƒjƒX‚ğA\n\Œû‚Å™ø‚¦‚½‚Ü‚Ü‚ä‚Á‚­‚è‚Æã‚ğ”‡‚í‚¹‚Ä‚«‚½I"
      when 789   #ƒtƒFƒ‰ƒ`ƒI
        action = premess + "#{targetname}‚ÌƒyƒjƒX‚ğA\n\Œû‚Å™ø‚¦‚½‚Ü‚Ü‚ä‚Á‚­‚è‚Æ‚µ‚á‚Ô‚Á‚Ä‚«‚½I"
      when 790   #ƒtƒFƒ‰ƒ`ƒI‹­
        action = premess + "#{targetname}‚ÌƒyƒjƒX‚ğA\n\Œû‚Å™ø‚¦‚½‚Ü‚Üã‚Åär‚ß‰ñ‚µ‚Ä‚«‚½I"
      when 791   #ƒtƒFƒ‰ƒ`ƒI•KE
        action = premess + "#{targetname}‚ÌƒyƒjƒX‚ğA\n\Œû‚Å™ø‚¦‚½‚Ü‚Ü‰‚©‚µ‚­är‚ß‰ñ‚µ‚Ä‚«‚½I"
      when 792   #ƒXƒ[ƒg
        action = premess + "#{targetname}‚ÌƒyƒjƒX‚ğA\n\‚ä‚Á‚­‚è‚Æ‹z‚¢ã‚°‚Ä‚«‚½I"
      when 793   #ƒXƒ[ƒg•KE
        action = premess + "#{targetname}‚ÌƒyƒjƒX‚ğA\n\ˆù‚İ‚Ş‚æ‚¤‚É‹z‚¢ã‚°‚Ä‚«‚½I"
      when 794   #ƒtƒFƒ‰ƒ`ƒI’ÇŒ‚
        action = premess + "#{targetname}‚ÌƒyƒjƒX‚ğA\n\Œû‚É™ø‚¦‚½‚Ü‚Üã‚ÅX‚Éär‚ß‰ñ‚µ‚Ä‚«‚½I"
      when 795   #ƒXƒ[ƒg’ÇŒ‚
        action = premess + "#{targetname}‚ÌƒyƒjƒX‚ğA\n\ŠÉ‹}‚ğ•t‚¯‚ÄX‚É‹z‚¢ã‚°‚Ä‚«‚½I"
  #------------------------------------------------------------------------#
      when 797   #ƒNƒ“ƒjÅ
        action = premess + "#{targetname}‚ÌƒAƒ\ƒR‚ğA\n\Œû‘S‘Ì‚Å‚ä‚Á‚­‚è‚Æ‹z‚¢ã‚°‚Ä‚«‚½I"
      when 798   #ƒNƒ“ƒj
        action = premess + "#{targetname}‚ÌƒAƒ\ƒR‚ÉA\n\ãæ‚ğ“ü‚ê‚Ä‘OŒã‚É”²‚«·‚µ‚µ‚Ä‚«‚½I"
      when 799   #ƒNƒ“ƒj‹­
        action = premess + "#{targetname}‚ÌƒAƒ\ƒR‚ğA\n\Œû‘S‘Ì‚Å‰AŠj‚²‚Æ‹­‚­‹z‚¢ã‚°‚Ä‚«‚½I"
      when 800   #ƒNƒ“ƒj•KE
        action = premess + "#{targetname}‚ÌƒAƒ\ƒR‚ÉA\n\ãæ‚ğë‚ç‚¹‰œ‚Ü‚Å¨‚¢—Ç‚­“Ë‚«“ü‚ê‚Ä‚«‚½I"
      when 801   #ƒNƒ“ƒj’ÇŒ‚
        action = premess + "#{targetname}‚ÌƒAƒ\ƒR‚ğA\n\Œû‚Å‹z‚¢•t‚¢‚½‚Ü‚ÜX‚Éã‚Åˆ¤•‚µ‚Ä‚«‚½I"
  #------------------------------------------------------------------------#
      when 803   #ƒfƒB[ƒvƒLƒbƒXÅ
        action = premess + "#{targetname}‚ÆA\n\‚ä‚Á‚­‚è‚ÆŒİ‚¢‚Ìã‚ğ—‚ß‚ ‚Á‚½I"
      when 804   #ƒfƒB[ƒvƒLƒbƒX
        action = premess + "#{targetname}‚ÆA\n\Œİ‚¢‚Ìã‚ğ—‚ß‚ ‚Á‚½I"
      when 805   #ƒfƒB[ƒvƒLƒbƒX‹­
        action = premess + "#{targetname}‚ÆA\n\Œİ‚¢‚ÉŒƒ‚µ‚­O‚ğæÃ‚è‚ ‚Á‚½I"
      when 806   #ƒfƒB[ƒvƒLƒbƒX•KE
        action = premess + "#{targetname}‚ÌŒû“à‚ÉA\n\ã‚ğär‚ß“ü‚ê‘Á‰t‚ğ—¬‚µ‚ñ‚Å‚«‚½I"
      when 807   #ƒfƒB[ƒvƒLƒbƒX’ÇŒ‚
        action = premess + "‚È‚¨‚àŒƒ‚µ‚­A\n\#{targetname}‚ÌŒû“à‚ğã‚ÅæøçW‚·‚éI"
  #------------------------------------------------------------------------#
      when 828   #”w–ÊS‘©EƒXƒ^ƒ“‘_‚¢
        action = premess + "#{targetname}‚Æ–§’…‚µA\n\ñ‹Ø‚É‚Ó‚£‚Á‚Æ‘§‚ğ‚«‚©‚¯‚Ä‚«‚½I"
        action = premess + "#{targetname}‚Æ–§’…‚µA\n\¨‚½‚Ô‚ğO‚ÅŠÃŠš‚İ‚µ‚Ä‚«‚½I"
      when 829   #”w–ÊS‘©E•KE‘_‚¢
        if target.boy?
          action = premess + "#{targetname}‚Æ–§’…‚µA\n\ñ‹Ø‚ğã‚Å‚Â‚£‚Á‚Æär‚ß‚ ‚°‚Ä‚«‚½I"
          action = premess + "#{targetname}‚Æ–§’…‚µA\n\è‚ğL‚Î‚µ‚ÄƒyƒjƒX‚ğw‚Åˆ¤•‚µ‚Ä‚«‚½I" unless target.hold.penis.battler != nil
        else
          action = premess + "#{targetname}‚Æ–§’…‚µA\n\#{target.bustsize}‚ğ†‚İ‚µ‚¾‚¢‚Ä‚«‚½I"
          action = premess + "#{targetname}‚Æ–§’…‚µA\n\ƒAƒ\ƒR‚Éè‚ğL‚Î‚µw‚Åˆ¤•‚µ‚Ä‚«‚½I" unless target.hold.vagina.battler != nil
        end
      when 830   #”w–ÊS‘©’ÇŒ‚
        if target.boy?
          action = premess + "#{tec}A\n\–§’…‚µ‚½‚Ü‚Ü#{targetname}‚É#{brk4}ƒLƒX‚Ì‰J‚ğ~‚ç‚¹‚½I"
          action = premess + "#{tec}A\n\–§’…‚µ‚½‚Ü‚Ü#{targetname}‚ÌƒyƒjƒX‚ğ#{brk4}w‚Å˜M‚ÔI" unless target.hold.penis.battler != nil
        else
          action = premess + "#{tec}A\n\–§’…‚µ‚½‚Ü‚Ü#{targetname}‚Ì#{target.bustsize}‚ğ#{brk4}ˆ¤•‚µ‚½I"
          action = premess + "#{tec}A\n\–§’…‚µ‚½‚Ü‚Ü#{targetname}‚ÌƒAƒ\ƒR‚ğ#{brk4}w‚Å˜M‚ñ‚¾I" unless target.hold.vagina.battler != nil
        end
  #------------------------------------------------------------------------#
      #ƒpƒCƒYƒŠŒn
      when 836   #ƒXƒgƒ[ƒNÅ
        action = premess + "#{myself.bustsize}‚Ì’JŠÔ‚ÅA\n\#{targetname}‚ÌƒyƒjƒX‚ğ‚¬‚ã‚Á‚Æˆ³”—‚µ‚Ä‚«‚½I"
        action += "\n\‚Ê‚ß‚è‚ğ‘Ñ‚Ñ‚½ƒyƒjƒX‚É‰õŠ´‚ª‘–‚éI" if target.lub_male >= 60
      when 837   #ƒXƒgƒ[ƒN
        action = premess + "#{myself.bustsize}‚Ì’JŠÔ‚ÅA\n\#{targetname}‚ÌƒyƒjƒX‚ğ‹²‚ñ‚Å‚µ‚²‚¢‚Ä‚«‚½I"
        action += "\n\‚Ê‚ß‚è‚ğ‘Ñ‚Ñ‚½ƒyƒjƒX‚É‰õŠ´‚ª‘–‚éI" if target.lub_male >= 60
      when 838   #ƒXƒgƒ[ƒN‹­
        action = premess + "#{myself.bustsize}‚Ì’JŠÔ‚ÉƒyƒjƒX‚ğ‹²‚İA\n\#{targetname}‚ğã–ÚŒ­‚¢‚ÉŒ©‚È‚ª‚çã‚ğ”‡‚í‚¹‚Ä‚«‚½I"
        target.lub_male += 4
        action += "\n\‚Ê‚ß‚è‚ğ‘Ñ‚Ñ‚½ƒyƒjƒX‚É‹­‚¢‰õŠ´‚ª‘–‚éI" if target.lub_male >= 60
      when 839   #ƒXƒgƒ[ƒN•KE
        action = premess + "#{myself.bustsize}‚Ì’JŠÔ‚ÉƒyƒjƒX‚ğ‹²‚İA\n\#{targetname}‚Ì”½‰‚ğŠy‚µ‚Ş‚©‚Ì‚æ‚¤‚É˜M‚ñ‚Å‚«‚½I"
        action += "\n\‚Ê‚ß‚è‚ğ‘Ñ‚Ñ‚½ƒyƒjƒX‚É‹­‚¢‰õŠ´‚ª‘–‚éI" if target.lub_male >= 60
      when 840   #ƒXƒgƒ[ƒN’ÇŒ‚
        action = premess + "X‚É#{myself.bustsize}‚ğ‰Ÿ‚µ•t‚¯A\n\#{targetname}‚ÌƒyƒjƒX‚Éã‚ğ”‡‚í‚¹‚È‚ª‚çC‚èã‚°‚½I"
        target.lub_male += 4
        action += "\n\‚Ê‚ß‚è‚ğ‘Ñ‚Ñ‚½ƒyƒjƒX‚É‹­‚¢‰õŠ´‚ª‘–‚éI" if target.lub_male >= 60
  #------------------------------------------------------------------------#
      #‚Ï‚Ó‚Ï‚ÓŒn
      when 842   #ƒvƒŒƒXÅ
        action = premess + "#{myself.bustsize}‚Ì’JŠÔ‚ÅA\n\#{targetname}‚ÌŠç‚ğ—D‚µ‚­•ï‚İ‚ñ‚Å‚«‚½I"
      when 843   #ƒvƒŒƒX
        action = premess + "#{myself.bustsize}‚Ì’JŠÔ‚ÅA\n\#{targetname}‚ÌŠç‚ğ•ø‚«‚µ‚ß‚Ä‚«‚½I"
      when 844   #ƒvƒŒƒX‹­
        action = premess + "#{myself.bustsize}‚Ì’JŠÔ‚ğA\n\#{targetname}‚ÌŠç‚ğ‚¬‚ã‚Á‚Æ‰Ÿ‚µ•t‚¯‚Ä‚«‚½I"
      when 845   #ƒvƒŒƒX•KE
        action = premess + "#{myself.bustsize}‚Ì’JŠÔ‚ÅA\n\#{targetname}‚ÌŠç‚ğ‹²‚İ‚±‚Ë‰ñ‚µ‚Ä‚«‚½I"
      when 846   #ƒvƒŒƒX’ÇŒ‚
        action = premess + "X‚É#{myself.bustsize}‚ÅA\n\#{targetname}‚ÌŠç‚ğ•ï‚İ‚İ‚±‚Ë‰ñ‚·I"
  #------------------------------------------------------------------------#
      #ƒfƒBƒ‹ƒhŒn
      when 891   #ƒfƒBƒ‹ƒhŠ‘}“üEÅ
        waist = ["‚ä‚Á‚­‚è‚Æ","T‚¦‚ß‚É"]
        waist.push("‚ä‚Á‚½‚è‚Æ") if myself.positive?
        waist.push("Å‚ç‚·‚æ‚¤‚É") if myself.positive?
        waist.push("‚¨‚¸‚¨‚¸‚Æ") if myself.negative?
        waist.push("’p‚ç‚¢‚Â‚Â‚à") if myself.negative?
        waist = waist[rand(waist.size)]
        action = premess + "#{waist}˜‚ğ“®‚©‚µ‚Ä‚«‚½I"
      when 892   #ƒfƒBƒ‹ƒhŠ‘}“ü
        waist = ["‘OŒã‚É"]
        waist.push("‰Ÿ‚µ‚±‚Ş‚æ‚¤‚É") if myself.positive?
        waist.push("’p‚ç‚¢‚Â‚Â") if myself.negative?
        waist = waist[rand(waist.size)]
        action = premess + "#{waist}˜‚ğU‚Á‚Ä‚«‚½I"
      when 893   #ƒfƒBƒ‹ƒhŠ‘}“üE•KE
        waist = ["‘å’_‚É","‘å‚«‚­","Œƒ‚µ‚­"]
        waist.push("ŠÉ‹}‚ğ‚Â‚¯‚Ä") if myself.positive?
        waist.push("P‚é‚æ‚¤‚É") if myself.positive?
        waist.push("g‘Ì‚ğ’Í‚ñ‚Å") if myself.positive?
        waist.push("ˆêŠŒœ–½‚É") if myself.negative?
        waist.push("ˆêS•s—‚É") if myself.negative?
        waist.push("“ ‚¯‚½•\î‚Å") if myself.negative?
        waist = waist[rand(waist.size)]
        action = premess + "#{waist}˜‚ğU‚èn‚ß‚½I"
      when 894   #ƒfƒBƒ‹ƒhŠ‘}“üE’ÇŒ‚
        waist = ["‘å’_‚É","‘å‚«‚­","Œƒ‚µ‚­"]
        waist.push("ŠÉ‹}‚ğ‚Â‚¯‚Ä") if myself.positive?
        waist.push("P‚é‚æ‚¤‚É") if myself.positive?
        waist.push("g‘Ì‚ğ’Í‚ñ‚Å") if myself.positive?
        waist.push("ˆêŠŒœ–½‚É") if myself.negative?
        waist.push("ˆêS•s—‚É") if myself.negative?
        waist = waist[rand(waist.size)]
        action = premess + "#{tec}A\n\X‚É#{waist}˜‚ğ‘OŒã‚³‚¹‚Ä‚«‚½I"
  #------------------------------------------------------------------------#
      when 896   #ƒfƒBƒ‹ƒhŒû‘}“üEÅ
        waist = ["‚ä‚Á‚­‚è‚Æ","T‚¦‚ß‚É"]
        waist.push("‚ä‚Á‚½‚è‚Æ") if myself.positive?
        waist.push("Å‚ç‚·‚æ‚¤‚É") if myself.positive?
        waist.push("‚¨‚¸‚¨‚¸‚Æ") if myself.negative?
        waist.push("’p‚ç‚¢‚Â‚Â‚à") if myself.negative?
        waist = waist[rand(waist.size)]
        action = premess + "#{waist}˜‚ğ“®‚©‚µ‚Ä‚«‚½I"
      when 897   #ƒfƒBƒ‹ƒhŒû‘}“ü
        waist = ["‘OŒã‚É"]
        waist.push("‰Ÿ‚µ‚±‚Ş‚æ‚¤‚É") if myself.positive?
        waist.push("’p‚ç‚¢‚Â‚Â") if myself.negative?
        waist = waist[rand(waist.size)]
        action = premess + "#{waist}˜‚ğU‚Á‚Ä‚«‚½I"
      when 898   #ƒfƒBƒ‹ƒhŒû‘}“üE•KE
        waist = ["‘å’_‚É","‘å‚«‚­","Œƒ‚µ‚­"]
        waist.push("ŠÉ‹}‚ğ‚Â‚¯‚Ä") if myself.positive?
        waist.push("P‚é‚æ‚¤‚É") if myself.positive?
        waist.push("g‘Ì‚ğ’Í‚ñ‚Å") if myself.positive?
        waist.push("ˆêŠŒœ–½‚É") if myself.negative?
        waist.push("ˆêS•s—‚É") if myself.negative?
        waist.push("“ ‚¯‚½•\î‚Å") if myself.negative?
        waist = waist[rand(waist.size)]
        action = premess + "#{waist}˜‚ğU‚èn‚ß‚½I"
      when 899   #ƒfƒBƒ‹ƒhŒû‘}“üE’ÇŒ‚
        waist = ["‘å’_‚É","‘å‚«‚­","Œƒ‚µ‚­"]
        waist.push("ŠÉ‹}‚ğ‚Â‚¯‚Ä") if myself.positive?
        waist.push("P‚é‚æ‚¤‚É") if myself.positive?
        waist.push("g‘Ì‚ğ’Í‚ñ‚Å") if myself.positive?
        waist.push("ˆêŠŒœ–½‚É") if myself.negative?
        waist.push("ˆêS•s—‚É") if myself.negative?
        waist = waist[rand(waist.size)]
        action = premess + "#{tec}A\n\X‚É#{waist}˜‚ğ‘OŒã‚³‚¹‚Ä‚«‚½I"
  #------------------------------------------------------------------------#
      when 901   #ƒfƒBƒ‹ƒhK‘}“üEÅ
        waist = ["‚ä‚Á‚­‚è‚Æ","T‚¦‚ß‚É"]
        waist.push("‚ä‚Á‚½‚è‚Æ") if myself.positive?
        waist.push("Å‚ç‚·‚æ‚¤‚É") if myself.positive?
        waist.push("‚¨‚¸‚¨‚¸‚Æ") if myself.negative?
        waist.push("’p‚ç‚¢‚Â‚Â‚à") if myself.negative?
        waist = waist[rand(waist.size)]
        action = premess + "#{waist}˜‚ğ“®‚©‚µ‚Ä‚«‚½I"
      when 902   #ƒfƒBƒ‹ƒhK‘}“ü
        waist = ["‘OŒã‚É"]
        waist.push("‰Ÿ‚µ‚±‚Ş‚æ‚¤‚É") if myself.positive?
        waist.push("’p‚ç‚¢‚Â‚Â") if myself.negative?
        waist = waist[rand(waist.size)]
        action = premess + "#{waist}˜‚ğU‚Á‚Ä‚«‚½I"
      when 903   #ƒfƒBƒ‹ƒhK‘}“üE•KE
        waist = ["‘å’_‚É","‘å‚«‚­","Œƒ‚µ‚­"]
        waist.push("ŠÉ‹}‚ğ‚Â‚¯‚Ä") if myself.positive?
        waist.push("P‚é‚æ‚¤‚É") if myself.positive?
        waist.push("g‘Ì‚ğ’Í‚ñ‚Å") if myself.positive?
        waist.push("ˆêŠŒœ–½‚É") if myself.negative?
        waist.push("ˆêS•s—‚É") if myself.negative?
        waist.push("“ ‚¯‚½•\î‚Å") if myself.negative?
        waist = waist[rand(waist.size)]
        action = premess + "#{waist}˜‚ğU‚èn‚ß‚½I"
      when 904   #ƒfƒBƒ‹ƒhK‘}“üE’ÇŒ‚
        waist = ["‘å’_‚É","‘å‚«‚­","Œƒ‚µ‚­"]
        waist.push("ŠÉ‹}‚ğ‚Â‚¯‚Ä") if myself.positive?
        waist.push("P‚é‚æ‚¤‚É") if myself.positive?
        waist.push("g‘Ì‚ğ’Í‚ñ‚Å") if myself.positive?
        waist.push("ˆêŠŒœ–½‚É") if myself.negative?
        waist.push("ˆêS•s—‚É") if myself.negative?
        waist = waist[rand(waist.size)]
        action = premess + "#{tec}A\n\X‚É#{waist}˜‚ğ‘OŒã‚³‚¹‚Ä‚«‚½I"
  #------------------------------------------------------------------------#
      #GèŒn
      when 733   #GèƒtƒFƒ‰ƒ`ƒIEÅ
        action = "#{myname}‚Ì‘€‚éGè‚ªA#{targetname}‚Ì\n\ƒyƒjƒX‚ğ™ø‚¦‚½‚Ü‚Ü‚à‚¼‚à‚¼‚Æå¿‚«ˆ¤•‚µ‚½I"
      when 734   #GèƒtƒFƒ‰ƒ`ƒI
        action = "#{myname}‚Ì‘€‚éGè‚ªA#{targetname}‚Ì\n\ƒyƒjƒX‚ğ™ø‚¦‚½‚Ü‚Ü‚ä‚Á‚­‚è‚Æ‚µ‚á‚Ô‚Á‚Ä‚«‚½I"
      when 735   #GèƒtƒFƒ‰ƒ`ƒIE•KE
        action = "#{myname}‚Ì‘€‚éGè‚ªA#{targetname}‚Ì\n\ƒyƒjƒX‚ğ™ø‚¦‚½‚Ü‚ÜŒƒ‚µ‚­‚µ‚á‚Ô‚Á‚Ä‚«‚½I"
      when 736   #GèƒtƒFƒ‰ƒ`ƒIE’ÇŒ‚
        action = "#{myname}‚Ì‘€‚éGè‚ªA#{targetname}‚Ì\n\ƒyƒjƒX‚ğ™ø‚¦‚½‚Ü‚ÜX‚É‚µ‚á‚Ô‚Á‚Ä‚«‚½I"
  #------------------------------------------------------------------------#
      when 738   #GèƒNƒ“ƒjEÅ
        action = "#{myname}‚Ì‘€‚éGè‚ªA#{targetname}‚Ì\n\ƒAƒ\ƒR‚É’£‚è•t‚¢‚½‚Ü‚Ü‚à‚¼‚à‚¼‚Æå¿‚«ˆ¤•‚µ‚½I"
      when 739   #GèƒNƒ“ƒj
        action = "#{myname}‚Ì‘€‚éGè‚ªA#{targetname}‚Ì\n\ƒAƒ\ƒR‚É’£‚è•t‚¢‚½‚Ü‚Ü‚ä‚Á‚­‚è‚Æ‹z‚¢ã‚°‚Ä‚«‚½I"
      when 740   #GèƒNƒ“ƒjE•KE
        action = "#{myname}‚Ì‘€‚éGè‚ªA#{targetname}‚Ì\n\ƒAƒ\ƒR‚É’£‚è•t‚¢‚½‚Ü‚Ü‰AŠj‚²‚Æ‹­‚­‹z‚¢ã‚°‚Ä‚«‚½I"
      when 741   #GèƒNƒ“ƒjE’ÇŒ‚
        action = "#{myname}‚Ì‘€‚éGè‚ªA#{targetname}‚Ì\n\ƒAƒ\ƒR‚É’£‚è•t‚¢‚½‚Ü‚ÜX‚É‹z‚¢ã‚°‚Ä‚«‚½I"
  #------------------------------------------------------------------------#
      when 942   #ã“Ë‚«ã‚°Š
        action = premess + "ãæ‚ÅA\n\#{targetname}‚ÌƒAƒ\ƒR‚ğ‰º‚©‚ç“Ë‚«ã‚°‚½I"
        action = premess + "ã‚ÅA\n\#{targetname}‚ÌƒAƒ\ƒR‚ğär‚ß‰ñ‚µ‚½I" if $game_variables[17] > 50
      when 943   #ã“Ë‚«ã‚°K
        action = premess + "ãæ‚ÅA\n\#{targetname}‚Ì‹e–å‚ğ‰º‚©‚ç“Ë‚«ã‚°‚½I"
        action = premess + "ã‚ÅA\n\#{targetname}‚Ì‹eÀ‚ğär‚ß‰ñ‚µ‚½I" if $game_variables[17] > 50
      when 944   #‹¹†‚İ
        action = premess + "©—R‚É“®‚©‚¹‚éè‚ÅA\n\#{targetname}‚Ì#{target.bustsize}‚ğ˜h’Í‚İ‚É‚µ‚½I"
        action = premess + "©—R‚É“®‚©‚¹‚éè‚ÅA\n\#{targetname}‚Ì#{target.bustsize}‚ğ‰º‚©‚ç˜h’Í‚İ‚É‚µ‚½I" if myself.mouth_riding?
        action = premess + "©—R‚É“®‚©‚¹‚éw‚ÅA\n\#{targetname}‚Ì“ûñ‚ğ“E‚İã‚°‚½I" if $game_variables[17] > 50
      when 945   #K†‚İ
        action = premess + "©—R‚É“®‚©‚¹‚éè‚ÅA\n\#{targetname}‚Ì‚¨K‚ğ˜h’Í‚İ‚É‚µ‚½I"
        action = premess + "©—R‚É“®‚©‚¹‚éw‚ÅA\n\#{targetname}‚Ì‹e–å‚ğhŒƒ‚µ‚½I" if $game_variables[17] > 80
      when 946   #”w–Êˆ¤•
        action = premess + "\n\#{targetname}‚Ì‘¾‚à‚à‚ğ•‚Å‰ñ‚µ‚½I"
        action = premess + "\n\#{targetname}‚ÌƒAƒ\ƒR‚ğw‚Åˆ¤•‚µ‚½I" if $game_variables[17] > 50
      when 947   #ƒLƒX”½Œ‚
        action = premess + "Šç‚ğ‹ß‚Ã‚¯A\n\#{targetname}‚ÉƒLƒX‚ğ‚µ‚½I"
        action = premess + "Šç‚ğ‹ß‚Ã‚¯A\n\#{targetname}‚Æ‰‚ß‚©‚µ‚­ã‚ğ—‚Ü‚¹‚½I" if $game_variables[17] > 50
      when 948   #Š‰Ÿ‚µ•t‚¯
        action = premess + "˜‚ğ“®‚©‚µA\n\#{targetname}‚ÌŠç‚ÉƒAƒ\ƒR‚ğC‚è‚Â‚¯‚½I"
        action = premess + "˜‚ğ“®‚©‚µA\n\#{targetname}‚ÌŠç‚ÉƒAƒ\ƒR‚ğ‰Ÿ‚µ•t‚¯‚½I" if $game_variables[17] > 50
      when 949   #ƒAƒ\ƒRU‚ß”½Œ‚
        if target.nude?
          action = premess + "è‚ÅA\n\#{targetname}‚ÌƒAƒ\ƒR‚ğ•‚Å‚Ä‚«‚½I"
          action = premess + "wæ‚ÅA\n\#{targetname}‚ÌƒAƒ\ƒR‚Ì“ü‚èŒû‚ğ#{brk4}ˆ¤•‚µ‚Ä‚«‚½I" if $game_variables[17] > 50
        else
          action = premess + "#{pantsu}‚Ìã‚©‚çA\n\#{targetname}‚ÌƒAƒ\ƒR‚ğ•‚Å‚Ä‚«‚½I"
        end
      when 950   #‰AŠjU‚ß”½Œ‚
        if target.nude?
          action = premess + "wæ‚ÅA\n\#{targetname}‚Ì‰AŠj‚ğŒƒ‚µ‚­hŒƒ‚µ‚Ä‚«‚½I"
        else
          action = premess + "#{pantsu}‚Éè‚ğŠŠ‚è‚Ü‚¹A\n\#{targetname}‚Ì‰AŠj‚ğhŒƒ‚µ‚Ä‚«‚½I"
        end
      when 951   #ƒyƒjƒXU‚ß”½Œ‚
        if target.nude?
          action = premess + "è‚ÅA\n\#{targetname}‚ÌƒyƒjƒX‚ğ•‚Å‚Ä‚«‚½I"
          action = premess + "wæ‚ÅA\n\#{targetname}‚ÌƒyƒjƒX‚ğ•‚Å‚Ä‚«‚½I" if $game_variables[17] > 50
          action += "\n\‚Ê‚ß‚è‚ğ‘Ñ‚Ñ‚½ƒyƒjƒX‚É‰õŠ´‚ª‘–‚éI" if target.lub_male >= 60
        else
          action = premess + "#{pantsu}‚Ìã‚©‚çA\n\#{targetname}‚ÌƒyƒjƒX‚ğ•‚Å‚Ä‚«‚½I"
        end
      when 952   #áÎŠÛU‚ß”½Œ‚
        if target.nude?
          action = premess + "è‚ÅA\n\#{targetname}‚Ì‘Ü‚ğ—D‚µ‚­‚³‚·‚Á‚Ä‚«‚½I"
          action = premess + "wæ‚ÅA\n\#{targetname}‚Ì‘Ü‚ğ—D‚µ‚­•‚Å‚Ä‚«‚½I" if $game_variables[17] > 50
        else
          action = premess + "#{pantsu}‚Éè‚ğŠŠ‚è‚Ü‚¹A\n\#{targetname}‚Ì‘Ü‚ğè‚Å‚³‚·‚Á‚Ä‚«‚½I"
        end
      when 953   #Š¨‰C‚è•t‚¯”½Œ‚
        action = premess + "ƒAƒ\ƒR‚ğ‰Ÿ‚µ•t‚¯A\n\#{targetname}‚ÌƒyƒjƒX‚ÉC‚è‚Â‚¯‚Ä‚«‚½I"
        action += "\n\‚Ê‚ß‚è‚ğ‘Ñ‚Ñ‚½ƒyƒjƒX‚É‰õŠ´‚ª‘–‚éI" if target.lub_male >= 60
      when 954   #Š¨ŠC‚è•t‚¯”½Œ‚
        action = premess + "ƒAƒ\ƒR‚ğ‰Ÿ‚µ•t‚¯A\n\#{targetname}‚ÆƒAƒ\ƒR‚ÉC‚è‚Â‚¯‚Ä‚«‚½I"
=begin
      when 947   #K”ö‚ÅŠïP
        action = premess + "K”ö‚ğg‚¢A\n\€Šp‚©‚ç#{targetname}‚ÌƒAƒ\ƒR‚ğhŒƒ‚µ‚Ä‚«‚½I"
        action = premess + "K”ö‚ğg‚¢A\n\€Šp‚©‚ç#{targetname}‚Ì‹¹‚ğˆ¤•‚µ‚Ä‚«‚½I" if $game_variables[17] > 50
      when 948   #Gè‚ÅŠïP
        action = premess + "Gè‚ğg‚¢A\n\€Šp‚©‚ç#{targetname}‚ÌƒAƒ\ƒR‚ğhŒƒ‚µ‚Ä‚«‚½I"
        action = premess + "Gè‚ğg‚¢A\n\€Šp‚©‚ç#{targetname}‚Ì‹¹‚ğˆ¤•‚µ‚Ä‚«‚½I" if $game_variables[17] > 50
=end  
  #------------------------------------------------------------------------#
      when 956   #ƒLƒbƒX‚Å‰‡Œì
        action = premess + "#{emotion}\n\#{targetname}‚ÌO‚ğÇ‚¬A#{brk4}ã‚ğ—‚ß‚Ä‚«‚½I"
      when 957   #‹¹U‚ß‚Å‰‡Œì
        action = premess + "#{emotion}\n\#{targetname}‚Ì#{target.bustsize}‚ğ#{brk4}†‚İ‚µ‚¾‚¢‚½I"
      when 958   #KU‚ß‚Å‰‡Œì
        action = premess + "#{emotion}\n\#{targetname}‚Ì‚¨K‚ğ#{brk4}†‚İ‚µ‚¾‚¢‚½I"
      when 959   #ƒAƒiƒ‹U‚ß‚Å‰‡Œì
        action = premess + "#{emotion}\n\#{targetname}‚Ì‹eÀ‚ğãæ‚Å“Ë‚¢‚Ä‚«‚½I"
      when 960   #ƒAƒ\ƒRU‚ß‚Å‰‡Œì
        action = premess + "#{emotion}\n\#{targetname}‚ÌƒAƒ\ƒR‚ğã‚Åˆ¤•‚µ‚Ä‚«‚½I"
      when 961   #‰AŠjU‚ß‚Å‰‡Œì
        action = premess + "#{emotion}\n\#{targetname}‚Ì‰AŠj‚ğã‚Åär‚ßã‚°‚Ä‚«‚½I"
      when 962   #ƒyƒjƒXU‚ß‚Å‰‡Œì
        #‹tƒAƒiƒ‹‚Å”Æ‚³‚êó‘Ô
        if target.anal_analsex?
          action = premess + "#{emotion}\n\Œã‚ë‚ğ”Æ‚³‚ê‚é#{targetname}‚ÌƒyƒjƒX‚ğ\nãæ‚Åär‚ßã‚°‚Ä‚«‚½I"
          action = premess + "#{emotion}\n\Œã‚ë‚ğ”Æ‚³‚ê‚é#{targetname}‚ÌƒyƒjƒX‚ğ\nè‚Å‚µ‚²‚¢‚Ä‚«‚½I" if $game_variables[17] > 50
        #‹Ræó‘Ô
        else
          action = premess + "#{emotion}\n\g“®‚«æ‚ê‚È‚¢#{targetname}‚ÌƒyƒjƒX‚ğ\nãæ‚Åär‚ßã‚°‚Ä‚«‚½I"
          action = premess + "#{emotion}\n\g“®‚«æ‚ê‚È‚¢#{targetname}‚ÌƒyƒjƒX‚ğ\nè‚Å‚µ‚²‚¢‚Ä‚«‚½I"if $game_variables[17] > 50
        end
      when 963   #áÎŠÛU‚ß‚Å‰‡Œì
        #‹tƒAƒiƒ‹‚Å”Æ‚³‚êó‘Ô
        if target.anal_analsex?
          action = premess + "#{emotion}\n\Œã‚ë‚ğ”Æ‚³‚ê‚é#{targetname}‚ÌáÎŠÛ‚ğ\nãæ‚Åär‚ßã‚°‚Ä‚«‚½I"
          action = premess + "#{emotion}\n\Œã‚ë‚ğ”Æ‚³‚ê‚é#{targetname}‚ÌáÎŠÛ‚ğ\nw‚Åˆ¤•‚µ‚Ä‚«‚½I" if $game_variables[17] > 50
        #‹Ræó‘Ô
        else
          action = premess + "#{emotion}\n\g“®‚«æ‚ê‚È‚¢#{targetname}‚ÌáÎŠÛ‚ğ\nãæ‚Åär‚ßã‚°‚Ä‚«‚½I"
          action = premess + "#{emotion}\n\g“®‚«æ‚ê‚È‚¢#{targetname}‚ÌáÎŠÛ‚ğ\nw‚Åˆ¤•‚µ‚Ä‚«‚½I"if $game_variables[17] > 50
        end
      when 964   #‰‡ŒìUŒ‚’ÇŒ‚
        action = premess + "#{tec}A\n\X‚É#{targetname}‚ğˆ¤•‚µ‚Ä‚«‚½I"
  #------------------------------------------------------------------------#
      when 967   #–¡•û‚ğU‚ß‚é
        action = premess + "#{emotion}\n\#{targetname}‚ğ—D‚µ‚­ˆ¤•‚µ‚½I"
      when 968   #À‹µEŒ©Šw‚·‚é
        action = premess + "A\n\#{targetname}‚Ì—lq‚ğ‹»–¡’ÃX‚È—lq‚ÅŒ©‚Â‚ß‚Ä‚¢‚écc"
        #ƒz[ƒ‹ƒh‰‡Œì‚»‚Ì‘¼—pE«Ši•ÊŒ`—e•\Œ»
        case myself.personality
        when "ˆÓ’nˆ«","‚–","‹•¨","Ÿ‚¿‹C" #
          #Œ©‚Ä‚¢‚é‘ÎÛ‚ªƒz[ƒ‹ƒhó‘Ô‚Ìê‡
          if target.holding?
            action = premess + "A\n\#{targetname}‚Ì—lq‚ğ‚É‚â‚É‚â‚Æ’­‚ß‚Ä‚¢‚écc"
          #Œ©‚Ä‚¢‚é‘ÎÛ‚ª©•ª‚Æ“¯—lŠO–ì‚Ìê‡
          else
            action = premess + "#{targetname}‚Æ‹ü‚ª‡‚¤‚ÆA\n\’§”­‚·‚é‚æ‚¤‚È•s“G‚ÈÎ‚İ‚ğ•‚‚©‚×‚½ccI"
          end
        when "DF","“|ö" #
          #Œ©‚Ä‚¢‚é‘ÎÛ‚ªƒz[ƒ‹ƒhó‘Ô‚Ìê‡
          if target.holding?
            action = premess + "A\n\#{targetname}‚Ì—lq‚ğ‚É‚â‚É‚â‚Æ’­‚ß‚Ä‚¢‚écc"
          #Œ©‚Ä‚¢‚é‘ÎÛ‚ª©•ª‚Æ“¯—lŠO–ì‚Ìê‡
          else
            action = premess + "#{targetname}‚Æ‹ü‚ª‡‚¤‚ÆA\n\ˆú“ ‚ÈÎ‚İ‚ğ•‚‚©‚×‚Äèµ‚«‚µ‚Ä‚«‚½ccI"
          end
        when "—z‹C","ŠÃ‚¦«","_˜a","ã•i" #
          #Œ©‚Ä‚¢‚é‘ÎÛ‚ªƒz[ƒ‹ƒhó‘Ô‚Ìê‡
          if target.holding?
            action = premess + "A\n\#{targetname}‚Ì—lq‚ğ‹»–¡’ÃX‚È—lq‚ÅŒ©‚Â‚ß‚Ä‚¢‚écc"
          #Œ©‚Ä‚¢‚é‘ÎÛ‚ª©•ª‚Æ“¯—lŠO–ì‚Ìê‡
          else
            action = premess + "#{targetname}‚Æ‹ü‚ª‡‚¤‚ÆA\n\‰½‚©‚ğŠú‘Ò‚·‚é‚©‚Ì‚æ‚¤‚ÈÎ‚İ‚ğ•‚‚©‚×‚½cc"
          end
        when "“à‹C" #
          #Œ©‚Ä‚¢‚é‘ÎÛ‚ªƒz[ƒ‹ƒhó‘Ô‚Ìê‡
          if target.holding?
            action = premess + "A\n\#{targetname}‚Ì—lq‚ğ”M‚Á‚Û‚¢“µ‚ÅŒ©‚Â‚ß‚Ä‚¢‚écc"
          #Œ©‚Ä‚¢‚é‘ÎÛ‚ª©•ª‚Æ“¯—lŠO–ì‚Ìê‡
          else
            action = premess + "#{targetname}‚Æ‹ü‚ª‡‚¤‚ÆA\n\’p‚¶“ü‚é‚æ‚¤‚ÉŠç‚ğˆí‚ç‚µ‚Ä‚µ‚Ü‚Á‚½cc"
          end
        when "]‡","’W”‘" #
          #Œ©‚Ä‚¢‚é‘ÎÛ‚ªƒz[ƒ‹ƒhó‘Ô‚Ìê‡
          if target.holding?
            action = premess + "A\n\#{targetname}‚Ì—lq‚ğ”MS‚ÉŠÏ@‚µ‚Ä‚¢‚écc"
          #Œ©‚Ä‚¢‚é‘ÎÛ‚ª©•ª‚Æ“¯—lŠO–ì‚Ìê‡
          else
            action = premess + "#{targetname}‚Æ‹ü‚ª‡‚¤‚ÆA\n\‰½‚©‚ğŠú‘Ò‚·‚é‚©‚Ì‚æ‚¤‚ÈŠá·‚µ‚ğŒü‚¯‚Ä‚«‚½cc"
          end
        when "•sv‹c","“V‘R" #
          #Œ©‚Ä‚¢‚é‘ÎÛ‚ªƒz[ƒ‹ƒhó‘Ô‚Ìê‡
          if target.holding?
            action = premess + "A\n\#{targetname}‚ğ‚«‚å‚Æ‚ñ‚Æ‚µ‚½•\î‚ÅŒ©‚Ä‚¢‚écc"
          #Œ©‚Ä‚¢‚é‘ÎÛ‚ª©•ª‚Æ“¯—lŠO–ì‚Ìê‡
          else
            action = premess + "#{targetname}‚Æ‹ü‚ª‡‚¤‚ÆA\n\‚É‚Á‚±‚è‚Æ”÷Î‚ñ‚¾cc"
          end
        when "“Æ‘P" #ƒtƒ‹ƒrƒ…ƒAê—p
          #Œ©‚Ä‚¢‚é‘ÎÛ‚ªƒz[ƒ‹ƒhó‘Ô‚Ìê‡
          if target.holding?
            action = premess + "A\n\#{targetname}‚Ì—lq‚ğ–Ê”’‚»‚¤‚ÉŠÏ@‚µ‚Ä‚¢‚écc"
          #Œ©‚Ä‚¢‚é‘ÎÛ‚ª©•ª‚Æ“¯—lŠO–ì‚Ìê‡
          else
            action = premess + "#{targetname}‚Æ‹ü‚ª‡‚¤‚ÆA\n\ˆú“ ‚ÈÎ‚İ‚ğ•‚‚©‚×‚Äèµ‚«‚µ‚Ä‚«‚½ccI"
          end
        end
        if myself.holding?
          action = premess + "g–ã‚¦‚µ‚Ä‚¢‚éI"
        end
      when 969   #©ˆÔ
        #Œ©‚Ä‚¢‚é‘ÎÛ‚ªƒz[ƒ‹ƒhó‘Ô‚Ìê‡
        if target.holding?
          if myself.holding_now? and not (myself.tops_binding? or myself.tentacle_binding?)
            if myself.vagina_insert?
              action = premess + "#{targetname}‚ÆŒq‚ª‚è‚Â‚ÂA\n\©‚ç‚Ì#{myself.bustsize}‚ğw‚ÅˆÔ‚ß‚Ä‚¢‚éccI"
            elsif myself.mouth_oralsex?
              action = premess + "#{targetname}‚ÌƒyƒjƒX‚ğ–j’£‚è‚Â‚ÂA\n\©‚ç‚ÌƒAƒ\ƒR‚Éw‚ğ”‡‚í‚¹‚ÄˆÔ‚ß‚Ä‚¢‚éccI"
            elsif myself.vagina_riding?
              action = premess + "#{targetname}‚ÌŠç‚ÉŒ×‚è‚Â‚ÂA\n\©‚ç‚Ì#{myself.bustsize}‚ğw‚ÅˆÔ‚ß‚Ä‚¢‚éccI"
            elsif myself.shellmatch?
              action = premess + "#{targetname}‚Æ‰º”¼g‚ğ—‚ß‚ ‚¢‚Â‚ÂA\n\©‚ç‚Ì#{myself.bustsize}‚ğw‚ÅˆÔ‚ß‚Ä‚¢‚éccI"
            else
              action = premess + "#{targetname}‚Ì’s‘Ô‚ğ’­‚ß‚Â‚ÂA\n\©‚ç‚Ìg‘Ì‚ğˆÔ‚ß‚Ä‚¢‚éccI"
            end
          elsif myself.tops_binding? or myself.tentacle_binding?
            action = premess + "#{targetname}‚Ì’s‘Ô‚ğ’­‚ß‚Â‚ÂA\n\S‘©‚³‚ê‚½©‚ç‚Ìó‘Ô‚Ég–ã‚¦‚µ‚Ä‚¢‚éccI"
          else
            action = premess + "#{targetname}‚Ì’s‘Ô‚ğ’­‚ß‚Â‚ÂA\n\©‚ç‚Ìg‘Ì‚ğˆÔ‚ß‚Ä‚¢‚éccI"
          end
        #Œ©‚Ä‚¢‚é‘ÎÛ‚ª©•ª‚Æ“¯—lŠO–ì‚Ìê‡
        else
          action = premess + "©‚ç‚Ìg‘Ì‚ğˆÔ‚ß‚Ä‚¢‚éccI"
        end
  #------------------------------------------------------------------------#        
      when 970   #¬‹x~(ƒz[ƒ‹ƒh’†‚Ì‚u‚oØ‚ê‘Î‰)
        sp_plus = [(myself.maxsp / 8).ceil, 50].min
        #ƒ^[ƒQƒbƒgw’è(ƒGƒ“ƒuƒŒƒCƒX’†‚Ìƒ^[ƒQƒbƒg‚ğ—Dæ)
        if myself.hold.tops.battler != nil and myself.hold.tops.parts != "Gè"
          hold_action = "#{myself.hold.tops.battler.name}‚Ég‘Ì‚ğ—a‚¯"
        else
          #«Ší„K„Œû‚Ì‡‚É—Dæ“x‚ªŒˆ‚Ü‚é
          if myself.hold.penis.battler != nil
            hold_action = "#{myself.hold.penis.battler.name}‚Ég‘Ì‚ğ—a‚¯"
          elsif myself.hold.vagina.battler != nil
            hold_action = "#{myself.hold.vagina.battler.name}‚Ég‘Ì‚ğˆÏ‚Ë"
          elsif myself.hold.anal.battler != nil
            hold_action = "#{myself.hold.anal.battler.name}‚Ég‘Ì‚ğˆÏ‚Ë"
          elsif myself.hold.dildo.battler != nil
            hold_action = "#{myself.hold.dildo.battler.name}‚Ég‘Ì‚ğˆÏ‚Ë"
          elsif myself.hold.mouth.battler != nil
            hold_action = "#{myself.hold.mouth.battler.name}‚Ég‘Ì‚ğˆÏ‚Ë"
          else
            hold_action = "g‘Ì‚Ì—Í‚ğ”²‚«"
          end
        end
        #Œû‚ª‚Ó‚³‚ª‚Á‚Ä‚¢‚éê‡
        if myself.hold.mouth.battler != nil
          action = premess + "#{hold_action}A\n\‰½‚Æ‚©ŒÄ‹z‚ğ—‚¿’…‚¯‚æ‚¤‚Æ‚µ‚Ä‚¢‚éccI"
        else
          action = premess + "#{hold_action}A\n\ŒÄ‹z‚ğ—‚¿’…‚¯‚æ‚¤‚Æ‚µ‚Ä‚¢‚éccI"
        end
        myself.sp += sp_plus
      when 971   #‚à‚ª‚­
        action = premess + " t‚—ists about, \n\ trying to change posture!"
      when 981   #–\‘–ˆ¤•
        if target.nude?
          action = premess + "î“®‚Ég‚ğ”C‚¹A\n#{targetname}‚Ìg‘Ì‚ğv‚¤‚Ü‚Ü‚ÉæÃ‚Á‚½I"
          action = premess + "î“®‚Ég‚ğ”C‚¹A\n#{targetname}‚Ì‹¹‚ğv‚¤‚Ü‚Ü‚ÉæÃ‚Á‚½I" if $msg.at_parts == "‘ÎÛF‹¹"
          action = premess + "î“®‚Ég‚ğ”C‚¹A\n#{targetname}‚ÌŠç‚ğrX‚µ‚­ˆø‚«Šñ‚¹A\nO‚ğ—L–³‚ğŒ¾‚í‚¹‚¸æÃ‚Á‚½I" if $msg.at_parts == "‘ÎÛFŒû"
          action = premess + "î“®‚Ég‚ğ”C‚¹A\n#{targetname}‚Ì‚¨K‚ğrX‚µ‚­†‚İ‚µ‚¾‚¢‚½I" if $msg.at_parts == "‘ÎÛFK"
          action = premess + "î“®‚Ég‚ğ”C‚¹A\n#{targetname}‚ÌƒAƒ\ƒR‚ğv‚¤‚Ü‚Ü‚ÉæÃ‚Á‚½I" if $msg.at_parts == "‘ÎÛFƒAƒ\ƒR"
          action = premess + "î“®‚Ég‚ğ”C‚¹A\n#{targetname}‚ÌƒyƒjƒX‚ğ—L–³‚ğŒ¾‚í‚¹‚¸æÃ‚Á‚½I" if $msg.at_parts == "‘ÎÛFƒyƒjƒX"
        else
          action = premess + "î“®‚Ég‚ğ”C‚¹A\n#{targetname}‚Ìg‘Ì‚ğv‚¤‚Ü‚Ü‚ÉæÃ‚Á‚½I"
          action = premess + "î“®‚Ég‚ğ”C‚¹A\n#{targetname}‚Ì•‚ğ¨‚¢‚æ‚­‚Í‚¾‚¯‚³‚¹‚é‚ÆA\n‚»‚Ì‹¹‚ğv‚¤‚Ü‚Ü‚ÉæÃ‚Á‚½I" if $msg.at_parts == "‘ÎÛF‹¹"
          action = premess + "î“®‚Ég‚ğ”C‚¹A\n#{targetname}‚ÌŠç‚ğrX‚µ‚­ˆø‚«Šñ‚¹A\n‚»‚ÌO‚ğ—L–³‚ğŒ¾‚í‚¹‚¸æÃ‚Á‚½I" if $msg.at_parts == "‘ÎÛFŒû"
          action = premess + "î“®‚Ég‚ğ”C‚¹A\n•‚È‚ÇˆÓ‚É‰î‚³‚È‚¢‚Æ‚Î‚©‚è‚ÉA\n#{targetname}‚Ì‚¨K‚ğrX‚µ‚­†‚İ‚µ‚¾‚¢‚½I" if $msg.at_parts == "‘ÎÛFK"
          action = premess + "î“®‚Ég‚ğ”C‚¹A\n•‚È‚ÇˆÓ‚É‰î‚³‚È‚¢‚Æ‚Î‚©‚è‚ÉA\n#{targetname}‚ÌƒAƒ\ƒR‚ğv‚¤‚Ü‚Ü‚ÉæÃ‚Á‚½I" if $msg.at_parts == "‘ÎÛFƒAƒ\ƒR"
          action = premess + "î“®‚Ég‚ğ”C‚¹A\n•‚È‚ÇˆÓ‚É‰î‚³‚È‚¢‚Æ‚Î‚©‚è‚ÉA\n#{targetname}‚ÌƒyƒjƒX‚ğ—L–³‚ğŒ¾‚í‚¹‚¸æÃ‚Á‚½I" if $msg.at_parts == "‘ÎÛFƒyƒjƒX"
        end
        action = premess + "#{targetname}‚ÌƒAƒ\ƒR‚ğA\n‰¹‚ğ—§‚Ä‚Ä‹­‚­‹z‚¢ã‚°‚½I"if myself.mouth_riding?
        action = premess + "#{targetname}‚Ì‹eÀ‚ğA\nrX‚µ‚­ã‚Åär‚ß‰ñ‚µ‚½I"if myself.mouth_hipriding?
      when 982   #–\‘–ˆ¤•E’ÇŒ‚
        action = premess + "‚È‚¨‚àŒƒ‚µ‚­A\nb‚Ì‚æ‚¤‚É#{targetname}‚Ìg‘Ì‚ğæÃ‚Á‚Ä‚¢‚éI"
      when 983   #–\‘–ƒsƒXƒgƒ“
        #ƒCƒ“ƒT[ƒgAƒfƒBƒ‹ƒhŒnAƒI[ƒ‰ƒ‹ŒnAƒNƒ“ƒjŒn
        action = premess + "#{targetname}‚ğ‘g‚İ•š‚¹A\nb‚Ì‚æ‚¤‚ÉrX‚µ‚­˜‚ğ‘Å‚¿•t‚¯‚½I" if myself.penis_insert?
        action = premess + "#{targetname}‚ğ‘g‚İ•š‚¹A\nˆÓ’nˆ«‚°‚ÈÎ‚İ‚ğ•‚‚©‚×‚Ä˜‚ğ‘Å‚¿•t‚¯‚½I" if myself.dildo_insert?
        action = premess + "#{targetname}‚Ì“ª‚ğ’Í‚İA\n‰½“x‚àA‚Ì‰œ‚Ü‚Å’£Œ^‚ğ‚Ë‚¶“ü‚ê‚½I" if myself.dildo_oralsex?
        action = premess + "#{targetname}‚Ì˜‚ğ’Í‚İA\nšn‹s“I‚ÈÎ‚İ‚ğ•‚‚©‚×‰½“x‚à˜‚ğ‘Å‚¿‚Â‚¯‚½I" if myself.dildo_analsex?
        action = premess + "#{targetname}‚Ì“ª‚ğ’Í‚İA\nA‚Ì‰œ‚Ü‚ÅƒyƒjƒX‚ğrX‚µ‚­‚Ë‚¶‚ñ‚¾I" if myself.penis_oralsex?
        action = premess + "#{targetname}‚ğ‘g‚İ•š‚¹A\n”ÚàÎ‚È‰¹‚ğ—§‚Ä‚ÄŒƒ‚µ‚­ƒyƒjƒX‚ğ‹z‚¢ã‚°‚½I" if myself.mouth_oralsex?
        action = "‹»•±‚µ‚½#{myname}‚ª‘€‚éGè‚ªA\n#{targetname}‚ÌƒAƒ\ƒR‚É‹z‚¢•t‚«A\n@”ÚàÎ‚È‰¹‚ğ—§‚Ä‚ÄŒƒ‚µ‚­‹z‚¢ã‚°‚Ä‚«‚½I" if myself.tentacle_draw?
        action = "‹»•±‚µ‚½#{myname}‚ª‘€‚éGè‚ªA\n#{targetname}‚ÌƒyƒjƒX‚É‹z‚¢•t‚«A\n@”ÚàÎ‚È‰¹‚ğ—§‚Ä‚ÄŒƒ‚µ‚­‹z‚¢ã‚°‚Ä‚«‚½I" if myself.tentacle_absorbing?
      when 984   #–\‘–ƒsƒXƒgƒ“E’ÇŒ‚
        action = premess + "‚È‚¨‚àŒƒ‚µ‚­A\n#{targetname}‚ğ”Æ‚µ‚Ä‚¢‚éI"
        action = "#{myname}‚ÌGè‚ÍA\n‚È‚¨‚àŒƒ‚µ‚­#{targetname}‚ğ”Æ‚µ‚Ä‚¢‚éI" if myself.tentacle_draw? or myself.tentacle_absorbing?
      when 985   #–\‘–ƒOƒ‰ƒCƒ“ƒh
        #ƒAƒNƒZƒvƒgAƒVƒFƒ‹ƒ}ƒbƒ`AƒyƒŠƒXƒR[ƒvAƒGƒLƒTƒCƒgƒrƒ…[
        action = premess + "#{targetname}‚ğ‘g‚İ•š‚¹A\nb‚Ì‚æ‚¤‚ÉrX‚µ‚­˜‚ğ‚­‚Ë‚ç‚¹‚½I"
        action = premess + "#{targetname}‚ğ‘g‚İ•š‚¹A\n#{myself.bustsize}‚ÅƒyƒjƒX‚ğ˜M‚ñ‚Å‚¢‚éI" if myself.tops_paizuri?
      when 986   #–\‘–ƒOƒ‰ƒCƒ“ƒhE’ÇŒ‚
        action = premess + "‚È‚¨‚àŒƒ‚µ‚­A\n#{targetname}‚ğ”Æ‚µ‚Ä‚¢‚éI"
      when 987   #–\‘–ˆ¤•(VPØ‚ê)
        action = premess + "‘§‚ğØ‚ç‚¹‚Â‚Â‚àA\nÕ“®‚É”C‚¹‚Ä#{targetname}‚ğˆ¤•‚µ‚½I\n‚µ‚©‚µAv‚¤‚æ‚¤‚Ég‘Ì‚ª“®‚©‚¹‚È‚¢I"
      when 988   #–\‘–ˆ¤•(‹óU‚è)
        action = premess + "#{targetname}‚ğˆ¤•‚µ‚½I\n‚µ‚©‚µA‹»•±‚Ì‚ ‚Ü‚èèŒ³‚ª’è‚Ü‚ç‚È‚¢I\\n#{targetname}‚Í‰õŠ´‚ğó‚¯‚Ä‚¢‚È‚¢I"
        action = premess + "#{targetname}‚ğˆ¤•‚µ‚½I\n‚µ‚©‚µA‹»•±‚Ì‚ ‚Ü‚èg‘Ì‚ª‚¤‚Ü‚­“®‚©‚È‚¢I\\n#{targetname}‚Í‰õŠ´‚ğó‚¯‚Ä‚¢‚È‚¢I" if myself.hold.tops.battler != nil
  #------------------------------------------------------------------------#
      end
      #œ‘Šè‚Ì”G‚ê“x‚Å•â³ƒeƒLƒXƒgC³(ƒXƒLƒ‹ˆĞ—Í‚ª‚ ‚é‚à‚ÌŒÀ’è)
      if skill.element_set.include?(97) and skill.power != 0 and target.girl?
        case target.lub_female
        when 81..255
          action += "\n\hŒƒ‚ğó‚¯‚é‚½‚Ñ‚ÉAƒAƒ\ƒR‚©‚çˆ¤–¨‚Ì…”ò–—‚ªã‚ª‚écI" if target.nude?
          action += "\n\#{targetname}‚Ì#{pantsu}‚©‚çˆ¤–¨‚ª“H‚è—‚¿‚écI" unless target.nude?
        when 61..80
          action += "\n\ƒAƒ\ƒR‚Ìˆú‚ç‚È…‰¹‚ª‚æ‚è‘å‚«‚­‚È‚Á‚Ä‚«‚½cI" if target.nude?
          action += "\n\#{targetname}‚Ì#{pantsu}‚Íˆ¤–¨‚Å”G‚ê‚Ä‚¢‚écI" unless target.nude?
        when 41..60
          action += "\n\#{targetname}‚Ì“àŒÒ‚ğˆ¤–¨‚ª‚Â‚£‚Á‚Æ—¬‚ê‚écI" if target.nude?
          action += "\n\#{targetname}‚Ì#{pantsu}‚Ìõ‚İ‚ª”Z‚­‚È‚Á‚Ä‚«‚½cI" unless target.nude?
        when 25..40
          action += "\n\ƒAƒ\ƒR‚©‚çˆú‚ç‚È…‰¹‚ª˜R‚ê•·‚±‚¦‚Ä‚­‚écI" if target.nude?
          action += "\n\#{targetname}‚Ì#{pantsu}‚Éõ‚İ‚ª•‚‚«o‚Ä‚«‚½cI" unless target.nude?
        end
      end
      # ƒƒbƒZ[ƒWo—Í
      case type
      when "action"
        #ƒXƒ‰ƒCƒ€Œn‚Í•”S‰t‚É’u‚«Š·‚¦‚é(b’è)
        if $data_SDB[target.class_id].name == "Sli‚e"
          action.gsub!("•","”S‰t") 
        end
        text = action
      when "avoid"
        text = avoid
      end
      
      
      
      return text
    end
  end
end

