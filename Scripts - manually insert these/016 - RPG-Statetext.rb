#==============================================================================
# ¡ RPG::Sprite
#------------------------------------------------------------------------------
# @ƒXƒe[ƒgŒÂ•ÊƒƒbƒZ[ƒWŠi”[
#==============================================================================
module RPG
  class State
    def name
      return @name.split(/\//)[0]
    end
    def message(state, type, myself, user)
      
      myname = myself.name if myself != nil
      username = user.name if user != nil
      master = $game_actors[101].name
      state_name = state.name.split(/\//)[0]
      effect = recover = report =  ""
      
      case state.id
      when 1 # í“¬•s”\
        effect = recover = report =  ""
      when 2 # Šã
        effect = "" #{myname}‚Íâ’¸‚É’B‚µ‚½I"
        recover = "#{myname} ‚ustered the willpower to stand back up!"
        report = "#{myname} can't ‚uster any strength\\n due to the lingering affects of cli‚ax!"
      when 3 # â’¸
        effect = "" #{myname}‚Íâ’¸‚É’B‚µ‚½I"
        recover = "#{myname}'s orgas‚ has settled!"
        report = "#{myname} can't ‚uster any strength\\n due to the lingering affects of cli‚ax!"
      when 6 # ƒNƒ‰ƒCƒVƒX
        effect = "#{myname} nearly ca‚e!"
        recover = "#{myname} regained co‚posure!"
        report = "#{myname} nearly ca‚e!"
      when 5 # —‡
        if user.is_a?(Game_Actor)
          if myself.is_a?(Game_Actor)
            effect = "#{myname} beca‚e naked!"
            effect = "#{myname} was stripped naked!" if $msg.tag == "’‡ŠÔ’Eˆß"
          else
            effect = "#{myname} has been stripped naked!"
            effect = "#{myname} beca‚e naked!" if $msg.tag == "–²–‚’Eˆß"
          end
        elsif user.is_a?(Game_Enemy)
          if myself.is_a?(Game_Actor)
            effect = "#{myname} was stripped naked!"
            effect = "#{myname} willingly strips naked!" if $game_switches[89] == true
          else
            effect = "#{myname} beca‚e naked!"
          end
        end
      when 8 # ‘}“ü
        if user.is_a?(Game_Actor)
          effect = "#{username} inserted #{myname}!"
        elsif user.is_a?(Game_Enemy)
          effect = "#{myname} violated #{username}!"
        end
      when 13 # ƒfƒBƒŒƒC
        effect = "#{myname} yelps in surprise!\n\ #{myname}'s ‚ove‚ents have dulled!"
        recover = ""
      when 17 # ‹ê’ÉƒXƒ^ƒ“
        if $game_temp.used_skill != nil
          if user.is_a?(Game_Actor)
            if $game_temp.used_skill.element_set.include?(10) #ŒûˆúŒn
              if myself == $game_actors[101]
              effect = "#{myname} flinched fro‚ the\n\ attack to his ‚outh!"
              else
              effect = "#{myname} flinched fro‚ the\n\ attack to her ‚outh!"
              end
            elsif $game_temp.used_skill.element_set.include?(11) #ãèŠ­Œn
              if myself == $game_actors[101]
              effect = "#{myname} was stunned by the\n\ attack to his ass!"
              else
              effect = "#{myname} was stunned by the\n\ attack to her ass!"
              end
            else #‹ê’ÉŒn
              effect = "#{myname} flinched painfully!"
            end
          else
            if $game_temp.used_skill.element_set.include?(10) #ŒûˆúŒn
              effect = "#{myname} swoons fro‚ being\n\ attacked in the ‚outh!"
            elsif $game_temp.used_skill.element_set.include?(11) #ãèŠ­Œn
              effect = "#{myname} cries out fro‚\n\ being attacked in the back!"
            else #‹ê’ÉŒn
              effect = "#{myname} keels fro‚ the pain!"
            end
          end
        else
          if user.is_a?(Game_Actor)
            effect = "#{myname} flinched painfully!"
          else
            effect = "#{myname} keels fro‚ the pain!"
          end
        end
        recover = ""
      when 14 # ”éŠŠŠ“xª
        #ˆ—‚ÍGame_Battler4‚ÌƒXƒLƒ‹ƒGƒtƒFƒNƒg‚Åİ’è
        effect = recover = report =  ""
      when 19 # —¼«‹ï—L‰»
        effect = "#{myname}'s clit begins to enlarge...!\n\ A penis appeared between #{myname}'s crotch!"
        recover = "#{myname}'s penis slowly disappeared!"
      when 20 # ŠŠ‰(ã)
        effect = "#{myname}'s penis is well-lubricated!"
        recover = ""
      when 21 # ŠŠ‰(‹­)
        effect = "#{myname}'s penis is extre‚ely lubricated!"
        recover = ""
      when 22 # ŠŠŠ(­)
        effect = "#{myname}'s pussy has gotten wet!"
        effect = "#{myname}'s pussy is sli‚y with goo!" if myself.states.include?(27) or myself.states.include?(28)
#        effect = "#{myname}‚ÌƒAƒ\ƒR‚©‚çA\n\™X‚É–¨‚ªõ‚İo‚Ä‚«‚½cI"
#        effect = "#{myname}‚ÌƒAƒ\ƒR‚ªA\n\•t’…‚µ‚½”S‰t‚Ì‚¹‚¢‚Å‚Ê‚é‚Ê‚é‚µ‚Ä‚«‚½cI" if myself.states.include?(27) or myself.states.include?(28)
        recover = ""
      when 23 # ŠŠŠ(‘½)
        effect = "#{myname}'s pussy is sufficiently wet!"
        effect = "#{myname}'s pussy is sli‚y with goo!" if myself.states.include?(27) or myself.states.include?(28)
#        effect = "#{myname}‚ÌƒAƒ\ƒR‚©‚çA\n\‚Æ‚ë‚è‚Æ–¨‚ª“H‚è—‚¿‚Ä—ˆ‚½cI"
#        effect = "#{myname}‚ÌƒAƒ\ƒR‚ÍA\n\”S‰t‚Æ–{l‚Ì–¨‚Æ‚Å\“ñ•ª‚É”G‚ê‚Ä‚«‚½cI" if myself.states.include?(27) or myself.states.include?(28)
        recover = ""
      when 24 # ŠŠŠ(ˆì)
        effect = "#{myname}'s pussy is overflowing with\n\ vaginal secretions!"
        effect = "#{myname}'s pussy is sli‚y with goo!" if myself.states.include?(27) or myself.states.include?(28)
#        effect = "#{myname}‚ÌƒAƒ\ƒR‚©‚çA\n\–¨‚ª~‚ß‚Ç‚È‚­ˆì‚êo‚µ‚Ä—ˆ‚écI"
#        effect = "#{myname}‚ÌƒAƒ\ƒR‚ÍA\n\”S‰t‚Æ–{l‚Ì–¨‚Æ‚ÅŠù‚É‚®‚µ‚å‚®‚µ‚å‚¾cI" if myself.states.include?(27) or myself.states.include?(28)
        recover = ""
      #ƒAƒiƒ‹ŒnƒXƒe[ƒg‚Í‘ÌŒ±”Å‚Å‚Í–¢“‹Ú‚È‚Ì‚ÅAŒëì“®–h~‚Ì‚½‚ßƒeƒLƒXƒg••ˆó
      when 25 # ŠŠ‚`(ã)
        effect = "" #"#{myname}‚Ì‹e–å‚ªŠŠ‚è‚ğ‘Ñ‚Ñ‚Ä‚«‚½cI"
        recover = ""
      when 26 # ŠŠ‚`(‹­)
        effect = "" #"#{myname}‚Ì‹e–å‚Í\“ñ•ª‚ÉŠŠ‚è‚ğ‘Ñ‚Ñ‚½I"
        recover = ""
      when 27 # ”S‰tŠŠ(­)
        effect = recover = ""
      when 28 # ”S‰tŠŠ(‘½)
        effect = recover = ""
      when 29 # ƒXƒ‰ƒCƒ€
        effect = recover = ""
      when 30 # ˆú“Å
        effect = "#{myname} was poisoned with aphrodisiacs!"
        report = "#{myname} is poisoned with aphrodisiacs!"
        recover = "The poison fang fell out of #{myname}...\\n" +
                  "Soon after, #{myname}'s body\n\ started to feel hot and flushed!"
        if type == "recover"
          myself.add_state(35)
          myself.add_states_log.clear
        end
      when 32 # ƒXƒ^ƒ“FƒhƒLƒhƒL
        effect = "#{myname}'s chest is thru‚ping!"
        effect = "#{myname}'s chest is pounding...!" if $msg.tag == "•òd" or $msg.tag == "‹Š­"
        recover = ""
      when 33 # ƒXƒ^ƒ“F‚Ñ‚Á‚­‚è
        effect = "#{myname} is lost in surprise!"
        recover = ""
      when 34 # œ’›
        effect = "#{myname} got lost in ecstasy!"
        recover = "#{myname} regained sanity!"
        if myself == $game_actors[101]
          report = "#{myname} wears an expression\n\ of supre‚e bliss on his face!"
        else
          report = "#{myname} wears an expression\n\ of supre‚e bliss on her face!"
        end
        # ‹Šo‚É“­‚«‚©‚¯‚éƒXƒLƒ‹‚Ìê‡AƒƒbƒZ[ƒW‚ğ•Ï‰»
#        if skill != nil and skill != ""
#          if skill.element_set.include?(21)
#            effect = "#{myname}‚Ì‹ü‚Í#{username}‚É“B•t‚¯‚É‚È‚Á‚½I\\n" + 
#                     "#{myname}‚ÍS‚ğ’D‚í‚ê‚½I"
#          end
#        end
      when 35 # —~î
        if user.is_a?(Game_Actor)
          effect = "#{myname} has been ‚ade horny!"
          effect = "#{myname} has beco‚e horny!" if $msg.tag == "•òd"
        elsif user.is_a?(Game_Enemy)
          effect = "#{myname} has beco‚e horny!"
        end
        recover = "#{myname} is no longer horny!"
        report = "#{myname} is horny!"
      when 36 # –\‘–
        if user.is_a?(Game_Actor)
          effect = "#{myname} has gone berserk!"
          effect = "#{myname} has goes berserk!" if $msg.tag == "•òd"
        elsif user.is_a?(Game_Enemy)
          effect = "#{myname} went berserk!"
        end
        recover = "#{myname} has cal‚ed down!"
        if myself == $game_actors[101]
          report = "#{myname} can't control hi‚self!"
        else
          report = "#{myname} can't control herself!"
        end
      when 37 # ‹•’E
        if user.is_a?(Game_Actor)
          effect = "#{myname}'s body started feeling weak!"
          effect = "#{myname}'s strength feels like\n\ it's being drained away...!" if $msg.tag == "•òd"
          effect = "#{myname}'s strength feels like\n\ it's being drained away...!" if myself.is_a?(Game_Actor)
          effect = "#{myname}'s strength is crushed\n\ by the pressure!" if $game_temp.used_skill.name == "œğ‰÷‚È‚³‚¢"
        elsif user.is_a?(Game_Enemy)
          effect = "#{myname}'s body beca‚e weak!"
          effect = "#{myname}'s body is weak fro‚ aphrodisiacs!" if myself.state?(30)
          effect = "#{myname}'s strength is crushed\n\ by the pressure!" if $game_temp.used_skill.name == "œğ‰÷‚È‚³‚¢"
        end
        recover = "#{myname}'s strength has returned!"
        report = "#{myname} can't gather any strength!"
      when 38 # ˆØ•|
        if user.is_a?(Game_Actor)
          effect = "#{myname} feels overpowered by the ene‚y!"
          effect = "#{myname} is feeling overwhelmed!" if $msg.tag == "•òd"
        elsif user.is_a?(Game_Enemy)
          effect = "#{myname} is feeling overwhel‚ed!"
        end
        recover = "#{myname} no longer feels overwhel‚ed!"
        report = "#{myname} is awed by the ene‚y!"
      when 39 # –ƒáƒ
        if user.is_a?(Game_Actor)
          effect = "#{myname} has been paralyzed!"
          effect = "#{myname}'s body has slowly beco‚e nu‚b!" if myself.is_a?(Game_Actor)
        elsif user.is_a?(Game_Enemy)
          effect = "#{myname}'s body has been paralyzed!"
          effect = "#{myname}'s\\n body has been paralyzed by the poison!" if myself.state?(30)
        end
        recover = "#{myname}'s body\\n has recovered fro‚ paralysis!"
        report = "#{myname}'s body is nu‚b...!"
      when 40 # U–Ÿ
        if user.is_a?(Game_Actor)
          effect = "#{myname} see‚s lost in pleasure!"
          effect = "#{myname} feels a little light-headed...!" if myself.is_a?(Game_Actor)
          effect = "#{myname} feels light-headed...!" if $msg.tag == "•òd"
        elsif user.is_a?(Game_Enemy)
          effect = "#{myname} see‚s to be lost in pleasure!"
          effect = "#{myname} looks a little light-headed!" if $msg.tag == "•òd"
          effect = "#{myname} can't concentrate\n\ because of the aphrodisiac's effects!" if myself.state?(30)
        end
        recover = "#{myname} is no longer lost in pleasure!"
        report = "#{myname} can't focus!"
      when 41 # ‚—g
        effect = "#{myname} beca‚e excited!"
        recover = "#{myname}'s excite‚ent has worn off!"
        report = ""
      when 42 # ’¾’…
        effect = "#{myname} has beco‚e co‚posed!"
        recover = "#{myname} returned to nor‚al!"
        report = ""
      when 45 # ‘SgŠ´“xƒAƒbƒv
        effect = "#{myname} beca‚e sensitive!"
        effect = "#{myname}'s body beca‚e sensitive\n\ fro‚ the aphrodisiac!" if myself.state?(30)
        recover = ""
      when 46 # ŒûŠ´“xƒAƒbƒv
        effect = "#{myname}'s lips beca‚e sensitive!"
        recover = ""
      when 47 # ‹¹Š´“xƒAƒbƒv
        effect = "#{myname}'s chest beca‚e sensitive!"
        recover = ""
      when 48 # KŠ´“xƒAƒbƒv
        effect = "#{myname}'s ass beca‚e sensitive!"
        recover = ""
      when 49 # ‰Š´“xƒAƒbƒv
        effect = "#{myname}'s penis beca‚e sensitive!"
        recover = ""
      when 50 # ŠŠ´“xƒAƒbƒv
        effect = "#{myname}'s pussy beca‚e sensitive!"
        recover = ""

      when 80 # ƒXƒe[ƒg‘‰Á
        effect = "#{myname}'s stat has increased!" if myself.is_a?(Game_Actor)
        effect = "#{myname}'s stat has increased!" if myself.is_a?(Game_Enemy)
        case $msg.tag
        when "–£—Í", "–£—Í{"
          effect.gsub!("stat","charm") 
        when "”E‘Ï—Í", "”E‘Ï—Í{"
          effect.gsub!("stat","endurance") 
        when "¸—Í", "¸—Í{"
          effect.gsub!("stat","vitality") 
        when "Ší—p‚³", "Ší—p‚³{"
          effect.gsub!("stat","dexterity") 
        when "‘f‘‚³", "‘f‘‚³{"
          effect.gsub!("stat","agility") 
        when "¸_—Í", "¸_—Í{"
          effect.gsub!("stat","spirit") 
        end
        if $msg.tag[/{/] != nil
          effect.gsub!("increased","increased futher") 
        end
        myself.remove_state(80)
        recover = ""
      when 81 # ƒXƒe[ƒgŒ¸­
        effect = "#{myname}'s stat has decreased!" if myself.is_a?(Game_Enemy)
        effect = "#{myname}'s stat has decreased!" if myself.is_a?(Game_Actor)
        case $msg.tag
        when "–£—Í", "–£—Í|"
          effect.gsub!("stat","charm") 
        when "”E‘Ï—Í", "”E‘Ï—Í|"
          effect.gsub!("stat","endurance") 
        when "¸—Í", "¸—Í|"
          effect.gsub!("stat","vitality") 
        when "Ší—p‚³", "¸—Í|"
          effect.gsub!("stat","dexterity") 
        when "‘f‘‚³", "‘f‘‚³|"
          effect.gsub!("stat","agility") 
        when "¸_—Í", "¸_—Í|"
          effect.gsub!("stat","spirit") 
        end
        if $msg.tag[/|/] != nil
          effect.gsub!("decreased","decreased further") 
        end
        myself.remove_state(81)
        recover = ""
      when 82 # ƒXƒe[ƒg‘S‘‰Á
        effect = "All of #{myname}'s stats\n\ have increased!" if myself.is_a?(Game_Actor)
        effect = "All of #{myname}'s stats\n\ have been increased!" if myself.is_a?(Game_Enemy)
        myself.remove_state(82)
        recover = ""
      when 83 # ƒXƒe[ƒg‘SŒ¸­
        effect = "All of #{myname}'s stats\n\ have decreased!" if myself.is_a?(Game_Enemy)
        effect = "All of #{myname}'s stats\n\ have been decreased!" if myself.is_a?(Game_Actor)
        myself.remove_state(83)
        recover = ""
      when 84 # ƒXƒe[ƒgˆÛ
        effect = "But it had no effect on #{myname}!"
        myself.remove_state(84)
        recover = ""
      when 85 # ‹­‰»‰ğœ
        effect = "One of #{myname}'s buffs has worn off!" if myself.is_a?(Game_Enemy)
        effect = "One of #{myname}'s buffs has worn off!" if myself.is_a?(Game_Actor)
        myself.remove_state(85)
        recover = ""
      when 86 # ’á‰º‰ğœ
        effect = "#{myname} has been cured of a status ailment!" if myself.is_a?(Game_Actor)
        effect = "#{myname} has been cured of a status ailment!" if myself.is_a?(Game_Enemy)
        myself.remove_state(86)
        recover = ""
      when 87 # ‘S‰ğœ
        effect = "#{myname}'s strength has been restored!" if myself.is_a?(Game_Enemy)
        effect = "#{myname}'s strength has been restored!" if myself.is_a?(Game_Actor)
        myself.remove_state(87)
        recover = ""
      when 93,94 # –hŒä’†A‘å–hŒä’†
        effect = "#{myname} focuses on resisting pleasure!"
        recover = ""
      when 95 # ‚¨”C‚¹’†
        effect = "#{myname} surrenders to the ene‚y!"
        report = "#{myname} has surrendered to the ene‚y!"
        recover = ""
      when 96 # —Uˆø
=begin
@@    s_range = myself.is_a?(Game_Enemy) ? $game_troop.enemies : $game_party.battle_actors
        for i in s_range
          if i.exist?
            n += 1
          end
        end
        s_range_text = n > 1 ? "‚½‚¿" : ""
        effect += "–²–‚#{s_range_text}‚Ì‹»–¡‚ª#{myname}‚ÉˆÚ‚Á‚½I" if myself.is_a?(Game_Actor)
        effect += "#{master}#{s_range_text}‚Í#{myname}‚É\n–Ú‚ğˆø‚«‚Â‚¯‚ç‚ê‚Ä‚µ‚Ü‚Á‚½I" if myself.is_a?(Game_Enemy)
=end
      when 97 # ƒLƒXƒXƒCƒbƒ`‹N“®
        effect = "#{myname}‚ÍƒLƒX‚ğ‚³‚ê‚ÄƒXƒCƒbƒ`‚ª“ü‚Á‚½I"
        recover = ""
      when 98 # –‚–@w
        effect = "#{myname}‚Ì¥‚¦‚é–‚–@‚ÌÁ”ï‚ª–³‚­‚È‚Á‚½I"
        recover = "#{myname}‚Ì‘«Œ³‚Ì–‚–@w‚ªÁ–Å‚µ‚½I"
      when 99 # ƒ}[ƒLƒ“ƒO
        effect = "#{myself.marking_battler.name}‚Í#{myname}‚É\n"+
                 "–Ú‚ğ•t‚¯‚ç‚ê‚Ä‚µ‚Ü‚Á‚½I"
        recover = "#{myname}‚Ì#{myself.marking_battler.name}‚Ö‚Ì\\n"+
                  "‹»–¡‚ª—‚¿’…‚¢‚½I"
      when 101 # j•Ÿ
        effect = "#{myname}‚Íó‘ÔˆÙí‚É‹­‚­‚È‚Á‚½I"
        recover = "#{myname}‚Ìj•Ÿ‚ª–³‚­‚È‚Á‚½I"
      when 102 # Å‘‡
        effect = "#{myname}‚Ì‹Ù’£‚ª‚‚Ü‚Á‚Ä‚«‚½I"
        recover = "#{myname}‚Ì‹Ù’£‚ª‰ğ‚¯‚½I"
        report = ""
      when 103 # êS
        effect = "#{myname}‚Ì¸_‚ªŒ¤‚¬Ÿ‚Ü‚³‚ê‚½I"
        recover = "#{myname}‚ÌW’†‚ªØ‚ê‚½I"
        report = ""
      when 104 # ’§”­
        recover = "#{myname} is no longer being provocative!"
        report = "#{myname} is ‚aking provacative gestures!!"
=begin
        # «‚È‚º‚©‚±‚±‚Å—‚¿‚é
@@    s_range = $game_troop.enemies if myself.is_a?(Game_Enemy)
        s_range = $game_party.battle_actors if myself.is_a?(Game_Actor)
        for i in s_range
          if i.exist?
            n += 1
          end
        end
        s_range_text = n > 1 ? "‚½‚¿" : ""
        effect += "#{myname}‚Í–²–‚#{s_range_text}‚©‚ç–Ú‚ğ‚Â‚¯‚ç‚ê‚½I" if myself.is_a?(Game_Actor)
        effect += "#{master}#{s_range_text}‚Í#{myname}‚É\n‹C‚ğˆø‚«‚Â‚¯‚ç‚ê‚Ä‚µ‚Ü‚Á‚½I" if myself.is_a?(Game_Enemy)
=end
      when 105 # S‘©
        if user.is_a?(Game_Actor)
          effect = "#{myname} has been restrained!"
        elsif user.is_a?(Game_Enemy)
          effect = "#{myname} was restrained!"
        end
        recover = "#{myname} has been freed!"
        report = "#{myname}'s body is restrained!"
      when 106 # ”j–Ê
        effect = "#{myname}‚Ì–{«‚ª–\‚©‚ê‚Ä‚µ‚Ü‚Á‚½I"
        report = "#{myname}‚Í–{«‚ğæ‚è‘U‚¤‚±‚Æ‚ª‚Å‚«‚È‚¢I"
        recover = "#{myname}‚Í—«‚ğæ‚è–ß‚µ‚½I"
      end
      # ƒƒbƒZ[ƒWo—Í
      case type
      when "effect"
        text = effect
      when "recover"
        text = recover
      when "report"
        text = report
      end
      return text
    end
  end
end