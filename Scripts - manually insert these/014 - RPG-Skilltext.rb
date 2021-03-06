#==============================================================================
# ■ RPG::Skill
#------------------------------------------------------------------------------
# 　スキル個別メッセージ格納
#
#   ※スキルテキストは一行あたり２４文字、２行までにできるだけ抑える事
#==============================================================================
module RPG
  class Skill
    def message(skill, type, myself, user)
      text = ""
      #ランダム基点スキル、またはテキスト無しスキルの場合
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
      avoid = "But #{myname} quickly dodged out of the way!"
      $game_variables[17] = rand(100) #スキル用乱数
      # 対象が複数の場合のテキスト
      range = target.is_a?(Game_Actor) ? $game_party.battle_actors : $game_troop.enemies
      exist_count = 0
      for one in range
        exist_count += 1 if one.exist?
      end
      rangetext = exist_count > 1 ? "たち" : ""
      
      
  #================================================================================================================================#
      # ■特殊な行動の場合（属性で判断）
      # ●魔法
      if skill.element_set.include?(5)
        action = premess + " casts #{skill_name}"
        avoid = "It had no effect on #{myname}!"
      #------------------------------------------------------------------------#
      # ★インセンス
      elsif skill.element_set.include?(129)
        action = premess + " used #{skill_name}!"
        avoid = "It had no effect on #{myname}!"
      else
        action = premess + " caressed #{targetname}!"
        avoid = "It had no effect on #{myname}!"
      end
      #------------------------------------------------------------------------#
      # ブレイクフラグ(仕掛け手と受け手の名前文字数合計が１２を越える場合、改行を挟むフラグ)
      # テキスト内容によっては、挟まなくても良い場合があるので考えて入れること
      # brkは「相手と自分の名前」、brk3は「相手の名前と相手の胸サイズ」を診断する
      # brk2はスキル単位で個別指定しているため、一括では設定しない
      brk = brk2 = brk3 = brk4 = ""
      if targetname != nil
        brk = "、\n\" if SR_Util.names_over?(myname,targetname)
        brk3 = "\n" if targetname.size + target.bustsize.size > 39 #胸比較と名前をあわせて１３文字越えで折り返す
        brk4 = "\n" if targetname.size > 24 #対象の名前が８文字越えで折り返す
      end
      #------------------------------------------------------------------------#
      #ホールド援護その他用・性格別形容表現
      emotion = "微笑んで、" #汎用
      case myself.personality
      when "陽気","勝ち気","柔和", "高貴"
        emotion = "悪戯っぽく笑みを浮かべると、"
        emotion = "楽しげに口元をゆがめ、" if $game_variables[17] < 33
        emotion = "にやっと目を細めると、" if $game_variables[17] > 66
      when "意地悪","高慢","虚勢", "気丈" #
        emotion = "意地悪げに口元をゆがめ、"
        emotion = "思わせぶりな笑みを浮かべ、" if $game_variables[17] < 33
        emotion = "すぅっと目を細めると、" if $game_variables[17] > 66
      when "好色","上品","倒錯", "独善" #
        emotion = "淫蕩な笑みを浮かべると、"
        emotion = "思わせぶりな笑みを浮かべ、" if $game_variables[17] < 33
        emotion = "しな垂れかかって来るや否や、" if $game_variables[17] > 66
      when "天然","甘え性", "暢気" #
        emotion = "無邪気に微笑みながら、"
        emotion = "じっと#{targetname}の顔を見つめると、" if $game_variables[17] < 33
        emotion = "悪戯っぽく笑みを浮かべると、" if $game_variables[17] > 66
      when "内気","従順", "尊大" #
        emotion = "周りに急かされるように、"
        emotion = "意を決したかのように、" if $game_variables[17] < 33
        emotion = "ちらちらと様子を伺いつつ、" if $game_variables[17] > 66
      when "不思議","淡泊","陰気" #
        emotion = "じっと#{targetname}の顔を見つめ、"
        emotion = "興味を惹かれたような表情で、" if $game_variables[17] < 33
        emotion = "何かを納得したように頷くと、" if $game_variables[17] > 66
      when "潔癖" #ラーミル
        emotion = "周りに急かされるように、"
        emotion = "意を決したかのように、" if $game_variables[17] < 33
        emotion = "ちらちらと様子を伺いつつ、" if $game_variables[17] > 66
      when "露悪狂" #ヴェルミィーナ
        emotion = "悪戯っぽく笑みを浮かべると、"
        emotion = "楽しげに口元をゆがめ、" if $game_variables[17] < 33
        emotion = "にやっと目を細めると、" if $game_variables[17] > 66
      end
      #------------------------------------------------------------------------#
      #尻尾の形容
      case $data_SDB[target.class_id].name
      when "Lesser Succubus","Succubus", "Vermiena"
        tail = "flexible tail"
      when "Iｍp","Devil","Deｍon", "Yuganaught"
        tail = "spaded tail"
      when "Werecat","Werewolf","Taｍaｍo"
        tail = "fluffy tail"
      when "Fulbeua", "Neijorange", "Succubus Lord"
        tail = "glossy tail"
      when "Familiar", "Rejeo", "Sylphe"
        tail = "delicate tail"
      when "Gargoyle"
        tail = "squarish tail"
      else
        tail = "tail"
      end
      #------------------------------------------------------------------------#
      ##{pantsu}の形容
      case $data_SDB[target.class_id].name
      when "Huｍan" #ロウ君
        pantsu = "underwear"
      when "Iｍp","Devil","Deｍon", "Goblin", "Goblin Leader"
        pantsu = "panties"
      when "Nightｍare"
        pantsu = "tights"
      when "Werewolf", "Werecat", "Taｍaｍo"
        pantsu = "loin cloth"
      when "Sliｍe", "Gold Slime"
        pantsu = "protective mucus"
      when "Gargoyle"
        pantsu = "groin slate"
      else
        pantsu = "panties"
      end
      #------------------------------------------------------------------------#
      #攻めの形容
      # 追撃時でない場合
      if $game_switches[78] == false
        tec = ["erratically","amorously"]
        tec.push("skillfully") if myself.positive?
        tec.push("smoothly") if myself.positive?
        tec.push("coyly") if myself.negative?
        tec.push("blissfully") if myself.negative?
      # 追撃時の場合
      else
        tec = ["delightfully","amorously"]
        tec.push("relentlessly") if myself.positive?
        tec.push("provocatively") if myself.positive?
        tec.push("ecstatically") if myself.negative?
        tec.push("eagerly") if myself.negative?
      end
      tec = tec[rand(tec.size)]
  #================================================================================================================================#
      # ■スキル名で判断(ホールド名は敵味方共通のためこちらで)
      case skill.name
  #------------------------------------------------------------------------#
      when "服を脱がす"
        if target.is_a?(Game_Enemy) #エネミーを脱がせる
          action = premess + ",\n\ atteｍpts to take off #{targetname}'s clothes!"
          #スライム系は専用のテキストとなる
          action = premess + ",\n\ attempts to push\n\ away #{targetname}'s protective slime!" if target.tribe_slime?
        elsif target.is_a?(Game_Actor) #アクターが脱がされる
          action = premess + ",\n\ tries to take off #{targetname}'s clothes!"
          #スライム系は専用のテキストとなる
          action = premess + ",\n\ tries to push away #{targetname}'s protective slime!" if target.tribe_slime?
        end
        avoid = ""
  #------------------------------------------------------------------------#
      when "服を脱ぐ"
        if myself == $game_actors[101]
          action = "#{myname} took off his clothes!"
        else
          action = "#{myname} took off her clothes!"
        end
        if myself == $game_actors[101]
          action = "#{myname} threw off his clothes! " if myself.berserk == true
        else
          action = "#{myname} threw off her clothes! " if myself.berserk == true
        end
        #スライム系は専用のテキストとなる
        action = "#{myname} released her protective sliｍe coating!" if target.tribe_slime?
        action = "#{myname}'s sliｍe coating splits and explodes\n off of her, revealing her voluptuously naked body!" if target.tribe_slime? and myself.berserk == true
        avoid = ""
  #------------------------------------------------------------------------#
      when "インサート","シェルマッチ","アクセプト","ディルドインサート"
        if target.is_a?(Game_Enemy) #エネミーをホールドする
          case $mood.point
          when 50..100
            case $data_SDB[target.class_id].name
            when "Iｍp", "Familiar", "Goblin", "Goblin Leader", "Unique Tycoon"
              action = premess + ",\n\ pins down #{targetname}'s small body froｍ above!"
            when "Caster", "Little Witch", "Liliｍ", "Slave"
              action = premess + ",\n\ pins down #{targetname}'s delicate body from above!"
            else
              action = premess + ",\n\ pins down #{targetname}'s body from above!"
            end
          else
            case $data_SDB[target.class_id].name
            when "Iｍp", "Familiar", "Goblin", "Goblin Leader", "Unique Tycoon"
              action = premess + ",\n\ pushes down #{targetname}'s small body!"
            when "Caster", "Little Witch", "Liliｍ", "Slave"
              action = premess + ",\n\ pushes down #{targetname}'s delicate body!"
            else
              action = premess + ",\n\ pushes down #{targetname}'s body!"
            end
          end
        elsif target.is_a?(Game_Actor) #アクターがホールドされる
          case $mood.point
          when 50..100
            action = "#{targetname},\n\ has been pinned down by #{myname}!"
          else
            if target == $game_actors[101]
            action = "#{myname} forcibly sits down\n\ on top of #{targetname}!"
            else
            action = "#{targetname},\n\ has been pushed down by #{myname}!"
            end
          end
        end
        avoid = ""
  #------------------------------------------------------------------------#
      when "バックインサート","ディルドインバック"
        if target.is_a?(Game_Enemy) #エネミーをホールドする
          case $mood.point
          when 50..100
            case $data_SDB[target.class_id].name
            when "Iｍp", "Familiar", "Goblin", "Goblin Leader", "Unique Tycoon"
              action = premess + ",\n\ pins down #{targetname}'s small body from above!"
            when "Caster", "Little Witch", "Liliｍ", "Slave"
              action = premess + ",\n\ pins down #{targetname}'s delicate body from above!"
            else
              action = premess + ",\n\ pins down #{targetname}'s body from above!"
            end
          else
            case $data_SDB[target.class_id].name
            when "Iｍp", "Familiar", "Goblin", "Goblin Leader", "Unique Tycoon"
              action = premess + ",\n\ pushes down #{targetname}'s small body!"
            when "Caster", "Little Witch", "Liliｍ", "Slave"
              action = premess + ",\n\ pushes down #{targetname}'s delicate body!"
            else
              action = premess + ",\n\ pushes down #{targetname}'s body!"
            end
          end
        elsif target.is_a?(Game_Actor) #アクターがホールドされる
          case $mood.point
          when 50..100
            action = "#{targetname},\n\ has been pinned down by #{myname}!"
          else
            action = "#{targetname},\n\ has been pushed down by #{myname}!"
          end
        end
        avoid = ""
  #------------------------------------------------------------------------#
      when "オーラルインサート","ディルドインマウス"
        if skill.name == "ディルドインマウス"
          penis_word = "dildo"
        else
          penis_word = "penis"
        end
        if myself == $game_actors[101]
          if target.is_a?(Game_Enemy) #エネミーをホールドする
            action = premess + " suddenly thrusts his #{penis_word}\n\ inside #{targetname}'s mouth!"
          elsif target.is_a?(Game_Actor) #アクターがホールドされる
            action = premess + " suddenly thrusts his #{penis_word}\n\ into #{targetname}'s mouth!"
          end
        else
          if target.is_a?(Game_Enemy) #エネミーをホールドする
            action = premess + " suddenly thrusts her #{penis_word}\n\ inside #{targetname}'s mouth!"
          elsif target.is_a?(Game_Actor) #アクターがホールドされる
            action = premess + " suddenly thrusts her #{penis_word}\n\ into #{targetname}'s mouth!"
          end
        end
        avoid = ""
  #------------------------------------------------------------------------#
      when "エキサイトビュー"
        if target.is_a?(Game_Enemy) #エネミーをホールドする
          case $mood.point
          when 50..100
            case $data_SDB[target.class_id].name
            when "Iｍp", "Familiar", "Goblin", "Goblin Leader", "Unique Tycoon"
              action = premess + ",\n\ pins down #{targetname}'s small body from above!"
            when "Caster", "Little Witch", "Liliｍ", "Slave"
              action = premess + ",\n\ pins down #{targetname}'s delicate body froｍ above!"
            else
              action = premess + ",\n\ pins down #{targetname}'s body from above!"
            end
          else
            case $data_SDB[target.class_id].name
            when "Iｍp", "Familiar", "Goblin", "Goblin Leader", "Unique Tycoon"
              action = premess + ",\n\ pushes down #{targetname}'s small body!"
            when "Caster", "Little Witch", "Liliｍ", "Slave"
              action = premess + ",\n\ pushes down #{targetname}'s delicate body!"
            else
              action = premess + ",\n\ pushes down #{targetname}'s body!"
            end
          end
        elsif target.is_a?(Game_Actor) #アクターがホールドされる
          if myself.full_nude?
            case $mood.point
            when 50..100
              if target == $game_actors[101]
              action = "Giving #{targetname} a full view of her nethers,\n\ #{myname} opens up her crotch with her fingers\n\ and starts lowering herself over his face!"
              else
              action = "Giving #{targetname} a full view of her nethers,\n\ #{myname} opens up her crotch with her fingers\n\ and starts lowering herself over her face!"
              end
            else
              if target == $game_actors[101]
              action = "Showing #{targetname} a clear view of her nethers,\n\ #{myname} tries to ｍash herself down\n\  on his face!"
              else
              action = "Showing #{targetname} a clear view of her nethers,\n\ #{myname} tries to ｍash herself down\n\  on her face!"
              end
            end
          else
            case $data_SDB[myself.class_id].name
            when "Caster","Familiar","Little Witch","Witch"
              action = "Standing over #{targetname}'s face,\n\ #{myname} lifts up her skirt to give him a clear view!"
            when "Lesser Succubus","Succubus"
              action = "Ｈovering over #{targetname}'s face,\n\#{myname}'s revealing panties can be clearly seen!"
            when "Iｍp","Devil"
              if target == $game_actors[101]
              action = "Flying over #{targetname}'s face,\n\#{myname} gives him a view between her strong legs!"
              else
              action = "Flying over #{targetname}'s face,\n\#{myname} gives her a view between her strong legs!"
              end
            when "Sliｍe"
              if target == $game_actors[101]
              action = "Slithering over #{targetname},\n\ #{myname} covers him in sliｍe and begins\n aligning herself\n\  to his head!"
              else
              action = "Slithering over #{targetname},\n\ #{myname} covers her in sliｍe and begins\n aligning herself\n\  to her head!"
              end
            when "Nightｍare"
              action = "Ｈovering over #{targetname}'s face,\n\#{myname} offers an enticing view through her thin panties!"
            else
              if target == $game_actors[101]
              action = "#{myname} aligns herself over #{targetname}'s face,\n\ and begins to lower herself!"
              else
              action = "#{myname} aligns herself over #{targetname}'s face,\n\ and begins to lower herself!"
              end
            end
          end
        end
        avoid = ""
  #------------------------------------------------------------------------#
      when "インモラルビュー"
        if target.is_a?(Game_Enemy) #エネミーをホールドする
          case $mood.point
          when 50..100
            case $data_SDB[target.class_id].name
            when "Iｍp", "Familiar", "Goblin", "Goblin Leader", "Unique Tycoon"
              action = premess + ",\n\ pins down #{targetname}'s small body from above!"
            when "Caster", "Little Witch", "Liliｍ", "Slave"
              action = premess + ",\n\ pins down #{targetname}'s delicate body from above!"
            else
              action = premess + ",\n\ pins down #{targetname}'s body froｍ above!"
            end
          else
            case $data_SDB[target.class_id].name
            when "Iｍp", "Familiar", "Goblin", "Goblin Leader", "Unique Tycoon"
              action = premess + ",\n\ pushes down #{targetname}'s sｍall body!"
            when "Caster", "Little Witch", "Liliｍ", "Slave"
              action = premess + ",\n\ pushes down #{targetname}'s delicate body!"
            else
              action = premess + ",\n\ pushes down #{targetname}'s body!"
            end
          end
        elsif target.is_a?(Game_Actor) #アクターがホールドされる
          case $mood.point
          when 50..100
            action = "Looｍing over #{targetname}'s eyes,\n\#{myname}'s ass draws closer!"
          else
            action = "Looｍing over #{targetname}'s eyes,\n\#{myname}'s ass draws closer!"
          end
        end
        avoid = ""
  #------------------------------------------------------------------------#
      when "ドロウネクター"
        if target.is_a?(Game_Enemy) #エネミーをホールドする
          action = premess + ",\n\ buries face-first between #{targetname}'s legs,\\n deep into her crotch!"
        elsif target.is_a?(Game_Actor) #アクターがホールドされる
          if myself.positive?
            emotion = "eats out her pussy\n\ with a seductive sｍile"
          elsif myself.negative?
            emotion = "puckers her lips to plants a kiss"
          else
            emotion = "gingerly sticks out her tongue"
          end
          action = "Bringing her face closer to #{targetname}'s pussy,\n\ #{myname} #{emotion}!"
        end
        avoid = ""
  #------------------------------------------------------------------------#
      when "オーラルアクセプト"
        if target.is_a?(Game_Enemy) #エネミーをホールドする
          action = premess + ",\n\ buries face-first between #{targetname}'s legs,\\n deep into her crotch!"
        elsif target.is_a?(Game_Actor) #アクターがホールドされる
          if myself.positive?
            emotion = "puckers her lips to plant a kiss"
          elsif myself.negative?
            emotion = "opens her mouth wide with certainty"
          else
            emotion = "opens her mouth slowly"
          end
          action = "Bringing her face close to #{targetname}'s penis,\n\ #{myname} #{emotion}!"
        end
        avoid = ""
  #------------------------------------------------------------------------#
      when "フラッタナイズ"
        if target.is_a?(Game_Enemy) #エネミーをホールドする
          action = premess + ",\n\ pulls #{targetname} in close!"
          action = premess + ",\n\ turns #{targetname} around to ｍeet face-to-face!" if target.holding?
        elsif target.is_a?(Game_Actor) #アクターがホールドされる
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
      when "エンブレイス"
        if target.is_a?(Game_Enemy) #エネミーをホールドする
          action = premess + ",\n\ clings to #{targetname} froｍ the rear!"
          action = premess + ",\n\ bends over #{targetname}, eｍbracing her froｍ behind!" if target.holding?
        elsif target.is_a?(Game_Actor) #アクターがホールドされる
          action = "#{myname} clings to #{targetname} froｍ the rear!"
          action = "#{myname} bends over #{targetname},\n\ eｍbracing froｍ behind!" if target.holding?
        end
        avoid = ""
  #------------------------------------------------------------------------#
      when "ペリスコープ"
        if target.is_a?(Game_Enemy) #エネミーをホールドする
          action = premess + ",\n\ clings to #{targetname}'s waist!"
        elsif target.is_a?(Game_Actor) #アクターがホールドされる
          action = "#{myname} tries to bury #{targetname}'s penis\n\ in her #{myself.bustsize}!"
        end
        avoid = ""
  #------------------------------------------------------------------------#
      when "ヘブンリーフィール"
        if target.is_a?(Game_Enemy) #エネミーをホールドする
          action = premess + " extends out her arms,\n\ pressing down on #{targetname}!"
        elsif target.is_a?(Game_Actor) #アクターがホールドされる
          action = premess + "\ tries to\n envelop #{targetname} in her #{myself.bustsize}!"
        end
        avoid = ""
  #------------------------------------------------------------------------#
      when "デモンズアブソーブ"
        action = "#{myname} opens up a tentacle,\n\ and begins bringing it down over #{targetname}'s penis!"
        avoid = ""
  #------------------------------------------------------------------------#
      when "デモンズドロウ"
        action = "#{myname}'s tentacle wriggles suspiciously,\n\ then lunges at #{targetname}'s crotch!"
        avoid = ""
  #------------------------------------------------------------------------#
      when "ヘブンリーフィール"
        if target.is_a?(Game_Enemy) #エネミーをホールドする
          action = premess + " extends out her arms,\n\ pressing down on #{targetname}!"
        elsif target.is_a?(Game_Actor) #アクターがホールドされる
          action = premess + "\ tries to\n envelop #{targetname} in her #{myself.bustsize}!"
        end
        avoid = ""
  #------------------------------------------------------------------------#
      when "リリース"
        action = premess + " twists around,\\n in atteｍpt to separate froｍ #{targetname}'s hold!"
        action = premess + " struggles about,\\n atteｍpting to escape froｍ #{targetname}'s hold!" if myself.initiative_level == 0
        avoid = ""
  #------------------------------------------------------------------------#
      when "インタラプト"
        if myself == $game_actors[101]
          for i in $game_party.actors
            if i.exist? and i != $game_actors[101]
              partner = i
            end
          end
          action = premess + " approaches, and tries to\n separate #{targetname} from #{partner.name}!"
        elsif myself.positive?
          action = "Approaching with a suggestive attitude,\n\#{myname} tries to break #{targetname}'s hold!"
        elsif myself.negative?
          action = premess + "clings to #{$game_actors[101].name},\n\ trying to break #{targetname}'s hold of him!"
        else
          action = "Approaching with a suggestive attitude,\n\#{myname} tries to break #{targetname}'s hold!"
        end
        avoid = ""
      end
################################################################################
      # ■IDで判断
      case skill.id
  #------------------------------------------------------------------------#
      when 9     #トーク
        case $mood.point
        when 50..100
          action = premess + ",\n\ whispers quietly into #{targetname}'s ear!"
        else
          action = premess + ",\n\ starts speaking to #{targetname}!"
        end
        avoid = ""
  #------------------------------------------------------------------------#
      when 81    #キッス
        held = ""
        if myself.holding?
          held = " changed posture, and"
        end
        case $mood.point
        when 50..100
          case myself.personality
          when "勝ち気", "腕白", "高慢"
            action = premess + "#{held} aggressively presses a\n\ kiss against #{targetname}'s lips!"
          when "好色", "甘え性"
            action = premess + "#{held} exchanged a passionate\n\ kiss with #{targetname}!"
          when "淡泊", "内気", "冷静"
            if myself == $game_actors[101]
            action = premess + "#{held} gently presses his\n\ lips against #{targetname}'s!"
            else
            action = premess + "#{held} gently presses her\n\ lips against #{targetname}'s!"
            end
          else
            action = premess + "#{held} exchanged a strong kiss\n\ with #{targetname}!"
          end
        else
          action = premess + "#{held} exchanged kisses with #{targetname}!"
        end
  #------------------------------------------------------------------------#
      when 82    #バスト
        brk2 = ""
        brk2 = "\n\" if targetname.size + target.bustsize.size > 36 and $mood.point >= 50 #胸表現と夢魔名を足して１２文字越え
        if target.nude?
          if skill.element_set.include?(71) #手を使用
            if myself == $game_actors[101]
            action = premess + " uses his hands to caress\n\ #{targetname}'s #{target.bustsize}!"
            else
            action = premess + " uses her hands to caress\n\ #{targetname}'s #{target.bustsize}!"
            end
            action = premess + " reaches out a hand to caress\n\ #{targetname}'s #{target.bustsize}!" if myself.holding?
          elsif skill.element_set.include?(72) #口を使用
            if myself == $game_actors[101]
            action = premess + " caresses #{targetname}'s\n\ #{target.bustsize} with his mouth!"
            else
            action = premess + " caresses #{targetname}'s\n\ #{target.bustsize} with her mouth!"
            end
            if myself == $game_actors[101]
            action = premess + " shifts his body, suckling \n\#{targetname}'s #{target.bustsize} with his mouth!" if myself.holding?
            else
            action = premess + " shifts her body, suckling \n\#{targetname}'s #{target.bustsize} with her mouth!" if myself.holding?
            end
          end
        else
          if skill.element_set.include?(71) #手を使用
            if myself == $game_actors[101]
            action = premess + " uses his hands to caress\n\ #{targetname}'s #{target.bustsize} through her clothes!"
            else
              if target == $game_actors[101]
              action = premess + " uses her hands to caress\n\ #{targetname}'s #{target.bustsize} through his clothes!"
              else
              action = premess + " uses her hands to caress\n\ #{targetname}'s #{target.bustsize} through her clothes!"
              end
            end
            if target == $game_actors[101]
            action = premess + " reaches out a hand to caress #{targetname}'s\n\ #{target.bustsize} through his clothes!" if myself.holding?
            else
            action = premess + " reaches out a hand to caress\n\ #{targetname}'s #{target.bustsize}\n\ through her clothes!" if myself.holding?
            end
          elsif skill.element_set.include?(72) #口を使用
            if myself == $game_actors[101]
            action = premess + " uses his mouth to caress #{targetname}'s\n\ #{target.bustsize} through her clothes!"
            else
              if target == $game_actors[101]
              action = premess + " uses her mouth to caress\n\ #{targetname}'s #{target.bustsize} through his clothes!"
              else
              action = premess + " uses her mouth to caress\n\ #{targetname}'s #{target.bustsize} through her clothes!"
              end
            end
            if myself == $game_actors[101]
            action = "Shifting his body, he suckles \n\#{targetname}'s #{target.bustsize} through her\n\ clothes with his mouth!" if myself.holding?
            else
              if target == $game_actors[101]
              action = "Shifting her body, she suckles \n\#{targetname}'s #{target.bustsize} through his\n\ clothes with her mouth!" if myself.holding?
              else
              action = "Shifting her body, she suckles \n\#{targetname}'s #{target.bustsize} through her\n\ clothes with her mouth!" if myself.holding?
              end
            end
          end
        end
        #ムードによる攻め方変化診断
        case $mood.point
        when 0..100#50..100
          action.gsub!("with her hand","with her fingers")
          action.gsub!("with her hand","with her finger")
          action.gsub!("uses his hands","uses his fingers")
          action.gsub!("uses her hands","uses her fingers")
          action.gsub!("with his mouth","with his tongue")
          action.gsub!("with her mouth","with her tongue")
          action.gsub!("uses his mouth","uses his tongue")
          action.gsub!("uses her mouth","uses her tongue")
          #攻撃対象切り替え
          if $game_variables[17] > 50
            action.gsub!("chest","nipples") 
            action.gsub!("youthful breasts","little nipples") 
            action.gsub!("shapely breasts","pointed nipples") 
            action.gsub!("round breasts","supple nipples") 
            action.gsub!("voluptuous breasts","supple nipples") 
            action.gsub!("incredible breasts","supple nipples") 
          end
          #性格診断
          case myself.personality
          when "勝ち気", "腕白", "高慢"
            action.gsub!("caress","roughly caress") 
          when "好色", "柔和"
            action.gsub!("caress","sensuously caress") 
          when "淡泊", "内気", "冷静", "甘え性"
            action.gsub!("caress","tenderly caress") 
          else
            action.gsub!("caress","carefully caress") 
          end
        end
        #スライム用テキスト整形
        if $data_SDB[target.class_id].name == "Sliｍe"
          action.gsub!("clothes","protective slime") 
        end
  #------------------------------------------------------------------------#
      when 83    #ヒップ
        brk2 = ""
        brk2 = "\n\" if targetname.size > 24 and $mood.point >= 50 #８文字越えの夢魔名
        if target.nude?
          if skill.element_set.include?(71) #手を使用
            if myself == $game_actors[101]
            action = premess + " uses his hands to caress\n\ #{targetname}'s butt!"
            else
            action = premess + " uses her hands to caress\n\ #{targetname}'s butt!"
            end
            action = premess + " reaches out a hand to caress\n\ #{targetname}'s ass!" if myself.holding?
          elsif skill.element_set.include?(72) #口を使用
            if myself == $game_actors[101]
            action = premess + " uses his mouth to caress\n\ #{targetname}'s butt!"
            else
            action = premess + " uses her mouth to caress\n\ #{targetname}'s butt!"
            end
            if myself == $game_actors[101]
            action = premess + " shifts his body to caress #{targetname}'s\n\ ass with his mouth!" if myself.holding?
            else
            action = premess + " shifts her body to caress\n\ #{targetname}'s ass with her mouth!" if myself.holding?
            end
          end
        else
          if skill.element_set.include?(71) #手を使用
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
          elsif skill.element_set.include?(72) #口を使用
            if myself == $game_actors[101]
            action = premess + " uses his mouth to caress #{targetname}'s\n\ ass through her #{pantsu}!"
            else
              if target == $game_actors[101]
              action = premess + " uses her mouth to caress\n\ #{targetname}'s butt through his #{pantsu}!"
              else
              action = premess + " uses her mouth to caress\n\ #{targetname}'s ass through her #{pantsu}!"
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
        #ムードによる攻め方変化診断
        case $mood.point
        when 50..100
          action.gsub!("with her hand","with her fingers")
          action.gsub!("with her hand","with her finger")
          action.gsub!("uses his hands","uses his fingers")
          action.gsub!("uses her hands","uses her fingers")
          action.gsub!("with his mouth","with his tongue")
          action.gsub!("with her mouth","with her tongue")
          action.gsub!("uses his mouth","uses his tongue")
          action.gsub!("uses her mouth","uses her tongue")
          #攻撃対象切り替え
          if $game_variables[17] > 80
            action.gsub!("お尻","菊座") 
          end
          #性格診断
          case myself.personality
          when "勝ち気", "腕白", "高慢"
            action.gsub!("caress","roughly caress") 
          when "好色", "柔和"
            action.gsub!("caress","sensuously caress") 
          when "淡泊", "内気", "冷静", "甘え性"
            action.gsub!("caress","tenderly caress") 
          else
            action.gsub!("caress","carefully caress") 
          end
        end
  #------------------------------------------------------------------------#
      when 84    #クロッチ
        brk2 = ""
        brk2 = "\n\" if targetname.size > 24 and $mood.point >= 50 #８文字越えの夢魔名
        if target.nude?
          if skill.element_set.include?(71) #手を使用
            if myself == $game_actors[101]
            action = premess + " uses his hands\n\ to caress #{targetname}'s crotch!"
            else
            action = premess + " uses her hands\n\ to caress #{targetname}'s crotch!"
            end
            action = premess + " reaches out a hand to\n\ caress #{targetname}'s crotch!" if myself.holding?
          elsif skill.element_set.include?(72) #口を使用
            if myself == $game_actors[101]
            action = premess + " uses his mouth\n\ to caress #{targetname}'s crotch!"
            else
            action = premess + " uses her mouth\n\ to caress #{targetname}'s crotch!"
            end
            if myself == $game_actors[101]
            action = premess + " shifts his body to caress\n\ #{targetname}'s crotch with his mouth!" if myself.holding?
            else
            action = premess + " shifts her body to caress\n\ #{targetname}'s crotch with her mouth!" if myself.holding?
            end
          end
        else
          if skill.element_set.include?(71) #手を使用
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
          elsif skill.element_set.include?(72) #口を使用
            if myself == $game_actors[101]
            action = premess + " uses his mouth to caress #{targetname}'s\n\ pussy through her #{pantsu}!"
            else
              if target == $game_actors[101]
              action = premess + " uses her mouth to caress\n\ #{targetname}'s penis through his #{pantsu}!"
              else
              action = premess + " uses her mouth to caress\n\ #{targetname}'s pussy through her #{pantsu}!"
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
        #ムードによる攻め方変化診断
        case $mood.point
        when 50..100
          action.gsub!("with her hand","with her fingers")
          action.gsub!("with her hand","with her finger")
          action.gsub!("uses his hands","uses his fingers")
          action.gsub!("uses her hands","uses her fingers")
          action.gsub!("with his mouth","with his tongue")
          action.gsub!("with her mouth","with her tongue")
          action.gsub!("uses his mouth","uses his tongue")
          action.gsub!("uses her mouth","uses her tongue")
          #攻撃対象切り替え
          if $game_variables[17] > 50
            action.gsub!("アソコ","陰核") 
          end
          #性格診断
          case myself.personality
          when "勝ち気", "腕白", "高慢"
            action.gsub!("caress","roughly caress") 
          when "好色", "柔和"
            action.gsub!("caress","sensuously caress") 
          when "淡泊", "内気", "冷静", "甘え性"
            action.gsub!("caress","tenderly caress") 
          else
            action.gsub!("caress","carefully caress") 
          end
        end
  #------------------------------------------------------------------------#
      when 52    #シェルマッチ、スクラッチ(ホールド時)
        action = premess + "intertwines with #{brk}#{targetname},\n\ rubbing their intimates together!"
        if $mood.point > 50
          #性格診断
          case myself.personality
          when "勝ち気", "高慢"
            action.gsub!("rubbing","fiercely rubbing") 
          when "好色", "柔和"
            action.gsub!("rubbing","sensuously rubbing") 
          when "上品", "意地悪"
            action.gsub!("rubbing","teasingly rubbing") 
          when "淡泊", "内気", "甘え性"
            action.gsub!("rubbing","tenderly rubbing") 
          else
            action.gsub!("rubbing","rubbing") 
          end
        end
  #------------------------------------------------------------------------#
      when 32,35,37,41,47,34,38 #スウィング、グラインド
        if myself == $game_actors[101]
          action = premess + " thrusts his pelvis!"
        else
          action = premess + " shakes her waist!"
        end
        if $mood.point > 50
          #性格診断
          case myself.personality
          when "勝ち気", "腕白"
            action.gsub!("thrusts","fiercely thrusts") 
            action.gsub!("shakes","violently shakes") 
          when "好色", "柔和"
            action.gsub!("thrusts","passionately thrusts") 
            action.gsub!("shakes","sensuously shakes") 
          when "冷静", "意地悪"
            action.gsub!("thrusts","undulatingly thrusts") 
            action.gsub!("shakes","undulatingly shakes") 
          when "内気", "甘え性", "天然"
            action.gsub!("thrusts","frantically thrusts") 
            action.gsub!("shakes","frantically shakes") 
          else
            action.gsub!("thrusts","intensely thrusts") 
            action.gsub!("shakes","intensely shakes") 
          end
        end
      when 33 #ヘヴィスウィング
        if myself == $game_actors[101]
          action = premess + " powerfully thrusts his pelvis!"
        else
          action = premess + " powerfully shakes her waist!"
        end
        if $mood.point > 50
          #性格診断
          case myself.personality
          when "勝ち気", "腕白"
            action.gsub!("powerfully thrusts","furiously thrusts") 
            action.gsub!("powerfully shakes","furiously shakes") 
          when "好色", "柔和"
            action.gsub!("powerfully thrusts","undulatingly thrusts") 
            action.gsub!("powerfully shakes","undulatingly shakes") 
          when "冷静", "意地悪"
            action.gsub!("powerfully thrusts","thrusts deeply") 
            action.gsub!("powerfully shakes","deeply fucks with") 
          when "内気", "甘え性", "天然"
            action.gsub!("powerfully thrusts","persistently thrusts") 
            action.gsub!("powerfully shakes","persistently shakes") 
          else
            action.gsub!("powerfully thrusts","intensely thrusts") 
            action.gsub!("powerfully shakes","intensely shakes") 
          end
        end
  #------------------------------------------------------------------------#
      when 55   #ライディング
        if myself.nude?
          action = "Straddling #{targetname}'s face,\n\ #{myname} shakes her hips back and forth!"
          action = "Riding on top of #{targetname}'s face,\n\ #{myname} grinds her hips back and forth!" if $mood.point > 50
        else
          case $data_SDB[myself.class_id].name
          when "Caster","Familiar","Little Witch","Witch"
            action = "Froｍ underneath her skirt,\n\ #{myname} presses her undergarｍents against\n\ #{targetname}'s mouth!"
          when "Lesser Succubus","Succubus"
            action = "#{myname} drops down, pressing\n\ her #{pantsu} against #{targetname}'s mouth!"
          when "Iｍp","Devil"
            action = "#{myname} drops down, pressing\n\ her #{pantsu} against #{targetname}'s mouth!"
          when "Sliｍe"
            action = "Riding on top of #{targetname}'s face,\n\ #{myname} presses her pussy into\n\ #{targetname}'s mouth!"
          when "Nightｍare"
            action = "#{myname} drops down, pressing\n\ her #{pantsu} against #{targetname}'s mouth!"
          else
            action = "#{myname} drops down, pressing\n\ her pussy against #{targetname}'s mouth!"
          end
        end
  #------------------------------------------------------------------------#
      when 91   #ツーパフ
        #一部性格で基本テキスト分岐
        case myself.personality
        when "勝ち気", "高慢", "意地悪"
          action = premess + " pushes #{targetname}'s face\n\ between her #{myself.bustsize}!"
        else
          action = premess + " wraps #{targetname}'s face\n\ between her #{myself.bustsize}!"
        end
  #------------------------------------------------------------------------#
      when 71,61   #リック
        if target.full_nude?
          case $mood.point
          when 50..100
            if myself == $game_actors[101]
            action = premess + " licks #{targetname}'s\n\ pussy with his tongue!"
            else
            action = premess + " licks #{targetname}'s\n\ pussy with her tongue!"
            end
          else
            if myself == $game_actors[101]
            action = premess + " caresses #{targetname}'s\n\ pussy with his tongue!"
            else
            action = premess + " caresses #{targetname}'s\n\ pussy with her tongue!"
            end
          end
          #攻撃対象切り替え
          if $game_variables[17] > 50
            action.gsub!("pussy","clit") 
          end
        else
          case $data_SDB[target.class_id].name
          when "Sliｍe"
            if myself == $game_actors[101]
            action = "Through her thick sliｍe, #{myname}\n\ pushes against #{targetname}'s pussy with his tongue!"
            else
            action = "Through her thick sliｍe, #{myname}\n\ pushes against #{targetname}'s pussy with her tongue!"
            end
          when "Nightｍare"
            if myself == $game_actors[101]
            action = "Through her #{pantsu}, #{myname}\n\ pushes against #{targetname}'s pussy with his tongue!"
            else
            action = "Through her #{pantsu}, #{myname}\n\ pushes against #{targetname}'s pussy with her tongue!"
            end
          else
            if myself == $game_actors[101]
            action = "Through her #{pantsu}, #{myname}\n\ pushes against #{targetname}'s pussy with his tongue!"
            else
            action = "Through her #{pantsu}, #{myname}\n\ pushes against #{targetname}'s pussy with her tongue!"
            end
          end
        end
        avoid = ""
  #------------------------------------------------------------------------#
      when 72   #リック(対尻)
        case $mood.point
        when 50..100
          if myself == $game_actors[101]
          action = premess + " pushes against #{targetname}'s\n\ sphincter with his tongue!"
          else
          action = premess + " pushes against #{targetname}'s\n\ sphincter with her tongue!"
          end
        else
          if myself == $game_actors[101]
          action = premess + " caresses #{targetname}'s\n\ sphincter with his tongue!"
          else
          action = premess + " caresses #{targetname}'s\n\ sphincter with her tongue!"
          end
        end
        avoid = ""
  #------------------------------------------------------------------------#
      when 73   #ミスチーフ
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
      when 74   #リアカレス
        case $mood.point
        when 50..100
          action = premess + " caresses #{targetname}'s\n\ crotch from the rear!"
          action = premess + " turns around, \n\ and tries to kiss #{targetname}!" if $game_variables[17] > 50
        else
          action = premess + " reaches back to gentley \n\ stroke #{targetname}'s thighs!"
          action = premess + " twists around, and \n\ starts rubbing #{targetname}'s #{target.bustsize}!" if $game_variables[17] > 50
        end
        avoid = ""
  #------------------------------------------------------------------------#
      when 641   #デモンズスロート
        action = "#{myname}'s tentacle \n\ relentlessly swallows #{targetname}'s penis!"
        action = "#{myname}'s tentacle \n\ incessantly stimulates #{targetname}'s penis!"  if $game_variables[17] > 50
        avoid = ""
  #------------------------------------------------------------------------#
      when 642   #デモンズサック
        action = "#{myname}の操る触手が、\n\#{targetname}のアソコを間断なく吸い続けている！"
        action = "#{myname}の操る触手のひだが、\n\#{targetname}のアソコを絶え間なく愛撫している！"  if $game_variables[17] > 50
        avoid = ""
  #------------------------------------------------------------------------#
      when 79   #レックレス
        if myself == $game_actors[101]
        action = premess + "  shifts his body around, \n\ trying to change posture!"
        else
        action = premess + "  shifts her body around, \n\ trying to change posture!"
        end
        avoid = ""
  #------------------------------------------------------------------------#
      when 101   #ティーズ
        action = premess + ",\n\ teasingly caresses #{targetname}!"
        avoid = ""
  #------------------------------------------------------------------------#
      when 104   #トリックレイド
        action = premess + ",\n\ suddenly attacks #{targetname}!"
        avoid = ""
  #------------------------------------------------------------------------#
      when 106   #ディバウアー
        action = premess + " voraciously gropes and \n\ rubs down #{targetname}'s body!"
        avoid = ""
  #------------------------------------------------------------------------#
      when 121   #ブレス
        action = "#{myname} takes a deep breath!"
        avoid = ""
  #------------------------------------------------------------------------#
      when 122   #カームブレス
        if myself == $game_actors[101]
        action = "#{myname} inhales deeply,\n\ calming his breathing!"
        else
        action = "#{myname} inhales deeply,\n\ calming her breathing!"
        end
        avoid = ""
  #------------------------------------------------------------------------#
      when 123   #ウェイト
        action = "#{myname} waits and observes..."
        avoid = ""
  #------------------------------------------------------------------------#
      when 124   #イントラスト
        if myself == $game_actors[101]
        action = "#{myname} relaxes his body!"
        else
        action = "#{myname} relaxes her body!"
        end
        avoid = ""
  #------------------------------------------------------------------------#
      when 125   #リフレッシュ
        if myself == $game_actors[101]
        action = "#{myname} calms his mind,\n\ clearing it of all abnormalities!"
        else
        action = "#{myname} calms her mind,\n\ clearing it of all abnormalities!"
        end
        avoid = ""
  #------------------------------------------------------------------------#
      when 126   #チェック
        action = premess + " inspects #{targetname}!"
        avoid = ""
  #------------------------------------------------------------------------#
      when 127   #アナライズ
        action = premess + " exhaustively analyzes #{targetname}!"
        avoid = ""
  #------------------------------------------------------------------------#
      when 140   #テンプテーション
        action = premess + " sensuously traces her body,\n\ brushing up against #{targetname}!"
        avoid = "But it didn't affect #{myname}!"
  #------------------------------------------------------------------------#
      when 145   #ガード
        action = premess + " took a defensive stance!"
        avoid = ""
  #------------------------------------------------------------------------#
      when 146   #インデュア
        if myself == $game_actors[101]
        action = premess + " closed his eyes, focusing his mind!"
        else
        action = premess + " closed her eyes, focusing her mind!"
        end
        avoid = ""
  #------------------------------------------------------------------------#
      when 148   #アピール
        case $data_classes[myself.class_id].name
        when "Lesser Succubus"
          action = premess + " poses suggestively!"
        when "Succubus" #
          action = premess + " makes a suggestive pose!"
        when "Iｍp" #
          action = premess + " pesters the enemy to\n\ play with her!"
        when "Devil" #
          action = premess + " makes a provocative pose!"
        when "Sliｍe" #
          action = premess + " poses suggestively!"
        when "Nightｍare" #
          action = premess + " invites the enemy with\n\ her sleepy eyes!"
        when "Caster" #
          action = premess + " pretends to be frightened!"
          action = premess + " invites the enemy with\n\ her defenseless appearance!" if myself.nude?
        when "Little Witch" #
          action = premess + " did a provocative pose!"
        when "Witch" #
          action = premess + " makes a provocative pose!"
        when "Familiar" #
          action = premess + " tucks up the hem of her dress!"
          action = premess + " invites the enemy with\n\ her defenseless appearance!" if myself.nude?
        when "Unique Succubus" #
          action = premess + " makes a suggestive pose!"
        else
          action = premess + " makes a suggestive pose!"
        end
        n = 0
=begin
        s_range = myself.is_a?(Game_Enemy) ? $game_troop.enemies : $game_party.party_actors
        for i in s_range
          if i.exist?
            n += 1
          end
        end
        s_range_text = n > 1 ? "たち" : ""
        action += "\n\夢魔#{s_range_text}の興味が#{myname}に移った！" if myself.is_a?(Game_Actor)
        action += "\n\#{$game_actors[101].name}#{s_range_text}は目を引きつけられてしまった！" if myself.is_a?(Game_Enemy)
=end
        avoid = ""
      when 149   #プロヴォーク
          action = premess + " provokes the enemy into attacking her!"
        
        
  #------------------------------------------------------------------------#        
      when 260   #品定め
        action = premess + " checks out #{targetname}!"
  #------------------------------------------------------------------------#        
      when 261   #手ほどき
        action = premess + "\n\ takes #{targetname} by the hand!"
  #------------------------------------------------------------------------#        
      when 262   #甘やかし
        action = premess + " quietly strokes\n\ #{targetname}'s head in a pampering fashion!"
  #------------------------------------------------------------------------#        
      when 263   #スパンク
        action = premess + " gives #{targetname} a strong spank!"
  #------------------------------------------------------------------------#        
      when 275   #やけくそ３連撃
        action = premess + " backs away, trembling!"
  #------------------------------------------------------------------------#        
      when 276   #ヒーローキリング
        action = premess + " extends out a hand of murderous intent!\n\ A ruinous blow comes shooting #{targetname}'s way!!"
  #------------------------------------------------------------------------#        
      when 277   #メテオエクリプス
        action = premess + "壊滅の魔法を詠唱した！\n\天は割れ星は砕け、壊滅の灼熱が世界を飲み込む！"
  #------------------------------------------------------------------------#        
      when 278   #ワールドブレイカー
        action = premess + "超大な魔力を放出した！\n\全人類の希望を、勇気を、未来を！\n\跡形も無く葬り去る！！"
  #------------------------------------------------------------------------#        
      when 297   #フィアー(畏怖時行動放棄)
        action = premess + "身体が思うように動かない！"
  #------------------------------------------------------------------------#        
      when 298   #フリーアクション
        case $data_classes[myself.class_id].name
        when "Lesser Succubus"
          action = premess + "\ curiously flies about #{targetname}...."
          action = premess + "\ flaps her wings excitedly...." if $game_variables[17] >= 50
        when "Succubus" #
          action = premess + "\ smiles alluringly...."
          action = premess + "\ is grooming her tail...." if $game_variables[17] >= 50
        when "Succubus Lord" #
          action = premess + "\ wears a captivating smile...."
          action = premess + "\ is grooming her tail...." if $game_variables[17] >= 50
        when "Iｍp" #
          action = premess + "\ curiously flies about #{targetname}...."
          action = premess + "\ flaps her wings excitedly...." if $game_variables[17] >= 50
        when "Devil" #
          action = premess + " watches appraisingly,\n\ observing #{targetname}....."
          action = premess + "\ smiles mysteriously at #{targetname}...." if $game_variables[17] >= 50
        when "Deｍon" #
          action = premess + "watches appraisingly,\n\ observing #{targetname}....."
          action = premess + "\ smiles mysteriously at #{targetname}...." if $game_variables[17] >= 50
        when "Sliｍe" #
          action = premess + "\ is jiggling her body to and fro...."
          action = premess + " plays with her body,\n\ squeezing it into different shapes...." if $game_variables[17] >= 50
        when "Gold Slime" #
          action = premess + "\ is jiggling her body to and fro...."
          action = premess + " plays with her body,\n\ squeezing it into different shapes...." if $game_variables[17] >= 50
        when "Nightｍare" #
          action = premess + "\ floats about, staring listlessly...."
          action = premess + " stares at #{targetname}'s\\n face with sleepy eyes...." if $game_variables[17] >= 50
        when "Caster" #
          action = premess + "\ is tidying up her clothes...." if not myself.nude?
          action = premess + ", as through having just realized,\n\ quickly starts fixing her clothes...." if not myself.nude? and $mood.point > 25
          action = premess + "\ seems somewhat restless...." if myself.nude?
        when "Slave" #
          action = premess + "\ is tidying up her clothes...." if not myself.nude?
          action = premess + ", as through having just realized,\n\ quickly starts fixing her clothes...." if not myself.nude? and $mood.point > 25
          action = premess + "\ seems somewhat restless...." if myself.nude?
        when "Little Witch" #
          action = premess + " looks at #{targetname} appraisingly....."
          action = premess + "\ is adjusting her hat...." if $game_variables[17] >= 50
        when "Witch" #
          action = premess + " looks at #{targetname} appraisingly....."
          action = premess + "\ is adjusting her hat...." if $game_variables[17] >= 50
        when "Familiar" #
          action = premess + " peeps at #{targetname}.\n\ She seems to be pondering something...."
          action = premess + "\ is quietly straighting up her dress...." if not myself.nude?
          action = premess + "\ pauses quietly...." if $game_variables[17] >= 50
        when "Werewolf" #
          action = premess + " utters a soft growl...."
          action = premess + " is wagging her tail...." if $game_variables[17] >= 50
        when "Werecat" #
          action = premess + " is cleaning herself...."
          action = premess + " is purring softly......" if $game_variables[17] >= 50
        when "Goblin" #
          action = premess + " is observing the situation...."
          action = premess + " is staring straight\n\ at #{targetname}'s face...." if $game_variables[17] >= 50
        when "Goblin Leader" #
          action = premess + " is analyzing the situation...."
          action = premess + " is staring straight\n\ at #{targetname}'s face...." if $game_variables[17] >= 50
        when "Priestess" #
          action = premess + " is observing the situation.... "
          action = premess + "\ is tidying up her clothes...." if not myself.nude?
          action = premess + " watches #{targetname}\n\ with an icy stare...." if $game_variables[17] >= 50
        when "Cursed Magus" #
          action = premess + " looks at #{targetname} appraisingly....."
          action = premess + " looks over to #{targetname},\n\ watching with a myserious smile...." if $game_variables[17] >= 50
        when "Alraune" #
          action = premess + " smiles pleasantly....."
          action = premess + " is looking at #{targetname}\n\ with a fearless smile on her face...." if $game_variables[17] >= 50
        when "Matango" #
          action = premess + "\ is tidying up her clothes...." if not myself.nude?
          action = premess + ", as through having just realized,\n\ quickly starts fixing her clothes...." if not myself.nude? and $mood.point > 25
          action = premess + "\ seems somewhat restless...." if myself.nude?
        when "Dark Angel" #
          action = premess + " is smiling darkly...."
          action = premess + " is looking at #{targetname}\n\ with a fearless smile on her face...." if $game_variables[17] >= 50
        when "Gargoyle" #
          action = premess + " cautiously watches #{targetname},\n\ observing..... "
          action = premess + " watches #{targetname}\n\ with an icy stare...." if $game_variables[17] >= 50
        when "Miｍic" #
          action = premess + " watches with a captivating smile...."
          action = premess + " is rummaging through her treasure chest...." if $game_variables[17] >= 50
        when "Taｍaｍo" #
          action = premess + " looks at #{targetname} appraisingly....."
          action = premess + " is wagging her tail to and fro...." if $game_variables[17] >= 50
        when "Liliｍ"
          action = premess + " is flying around #{targetname}...."
          action = premess + " watches with a captivating smile...."if $game_variables[17] >= 50
        else
          action = premess + " is observing the situation...."
          # ユニークエネミー
          case $data_classes[myself.class_id].color
          when "Neijorange"
            action = premess + " is smiling pleasantly...."
            action = premess + " is slowly swaying her\n\ body from side to side...." if $game_variables[17] >= 50
          when "Rejeo"
            action = premess + " is observing the situation...."
            action = premess + " observes #{targetname} appraisingly....." if $game_variables[17] >= 50
          when "Fulbeua"
            action = premess + " is looking at #{targetname}\n\ with a provocative look in her eyes...."
            action = premess + " is looking at #{targetname}\n\ with a daunting smile on her face...." if $game_variables[17] >= 50
          when "Gilgoon"
            action = premess + " watches cautiously,\n\ observing #{targetname}....."
            action = premess + "\ is tidying up her clothes...." if not myself.nude?
            action = premess + ", as through having just realized,\n\ quickly starts fixing her clothes...." if not myself.nude? and $mood.point > 25
            action = premess + "\ seems somewhat restless...." if myself.nude?
            # 結界状態
            if $game_switches[395]
              action = premess + " roars with laughter...."
            # 結界破壊状態
            elsif $game_switches[394]
              action = premess + "is trembling....."
            end
          when "Yuganaught"
            action = premess + " is talking\n\ to one of her tentacles...."
            action = premess + " looks over to #{targetname},\n\ watching with a myserious smile...." if $game_variables[17] >= 50
          when "Sylphe"
            action = premess + " smiles pleasantly....."
            action = premess + " watches with a captivating smile...." if $game_variables[17] >= 50
          when "Ramile"
            action = premess + " is smiling darkly...."
            action = premess + " lets out a sigh...." if $game_variables[17] >= 50
          when "Vermiena"
            action = premess + " is looking at #{targetname} provocatively...."
            action = premess + " is watching #{targetname}\n\ with a daunting smile on her face...." if $game_variables[17] >= 50
          end
        end
        if myself.holding?
#          action = premess + "くすくす笑っている……"
          action = premess + "'s body writhes about...." if myself.crisis?
        end
        avoid = ""
  #------------------------------------------------------------------------#        
      when 299   #エモーション
        case myself.personality
        when "好色"
          if target.holding?
            action = premess + " watches #{targetname},\n\ seemingly with intentions of joining...."
          else
            action = premess + " giggles....."
            action = premess + " watches #{targetname}'s\n\ naked body with devilish smile...." if $game_variables[17] >= 50 and target.nude?
          end
        when "上品" #
          if target.holding?
            action = premess + "行為が気になるのか、\n\#{targetname}達を横目で観察している……"
          else
            action = premess + "柔らかい微笑を浮かべている……"
            action = premess + "潤んだ瞳で、\n\#{targetname}を見つめている……" if $game_variables[17] >= 50 and myself.crisis?
          end
        when "高慢" #
          if target.holding?
            action = premess + "複雑な表情で、\n\#{targetname}達の行為を見つめている……"
          else
            action = premess + "見下すような視線で、\n\#{targetname}を睨んでいる…！"
            action = premess + "ちらちらと横目で、\n\#{targetname}の様子をうかがっている……" if $mood.point > 24
            action = premess + "視線に気づくと、\n\#{targetname}からぷいと目を逸らした……" if $mood.point > 49
          end
        when "淡泊" #
          if target.holding?
            action = premess + "指をくわえて、\n\#{targetname}達の行為を見つめている……"
          else
            action = premess + "くるくると髪を指に絡めている……"
            action = premess + "目を閉じて、\n\何か物思いに耽っている……" if $game_variables[17] >= 50
          end
        when "柔和" #
          if target.holding?
            action = premess + "微笑を浮かべて、\n\#{targetname}達の行為を見つめている……"
          else
            action = premess + "柔らかい微笑を浮かべている……"
          end
        when "勝ち気" #
          if target.holding?
            action = premess + "先を越されたとばかりに、\n\#{targetname}達を見て悔しがっている……"
          else
            action = premess + "挑むような目で、\n\#{targetname}の様子を伺っている……"
          end
        when "内気" #
          if target.holding?
            action = premess + "顔を両手で覆って、\n\#{targetname}達の行為を見ないようにしている……"
            action = premess + "顔を両手で覆いつつも、\n\隙間から#{targetname}達の行為を見ている……" if $mood.point > 24
            action = premess + "食い入るように、\n\#{targetname}達の行為を見ている……" if $mood.point > 49
          else
            action = premess + "うつむいて、\n\何かを言いたそうにしている……"
            action = premess + "恥ずかしそうに、\n\#{targetname}から目を逸らしている……"
            action = premess + "もじもじしながら、\n\#{targetname}を見つめている……" if $mood.point > 24
          end
        when "陽気" #
          if target.holding?
            action = premess + "自分も混ざりたそうに、\n\#{targetname}達の行為を見つめている……"
          else
            action = premess + "満面の笑顔で、\n\#{targetname}の顔を覗き込んでいる……"
          end
        when "意地悪" #
          if target.holding?
            action = premess + "行為が気になるのか、\n\#{targetname}達を横目で観察している……"
          else
            action = premess + "冷ややかな目で、\n\#{targetname}の様子を窺っている……"
            action = premess + "何かを思いついたように、\n\ニヤリと笑みを浮かべた……" if $game_variables[17] >= 50
          end
        when "天然" #
          action = premess + "ぼーっと余所見をしている……"
        when "従順" #
          if target.holding?
            action = premess + "指をくわえて、\n\#{targetname}達の行為をじっと見つめている……"
          else
            action = premess + "、\n\#{targetname}からの動向を見守っている……"
          end
        when "虚勢" #
          if target.holding?
            action = premess + "行為が気になるのか、\n\#{targetname}達を横目で観察している……"
            action = premess + "食い入るように、\n\#{targetname}達の行為を見ている……" if $mood.point > 24
          else
            action = premess + "自信満々の顔で、\n\不敵な笑みを浮かべている……"
            action = premess + "心なしかそわそわしている……" if $mood.point > 24
            action = premess + "何故かあたふたしている……" if $mood.point > 49
          end
        when "倒錯" #
          if target.holding?
            action = premess + "妖しい笑みを浮かべて、\n\#{targetname}達の行為を見つめている……"
          else
            action = premess + "くすくす笑っている……"
          end
        when "甘え性" #
          if target.holding?
            action = premess + "興味津々の目で、\n\#{targetname}達の行為を見つめている……"
          else
            action = premess + "興味津々の目で、\n\#{targetname}を見つめている……"
          end
        when "不思議" #
          if target.holding?
            action = premess + "何を考えているか判らない表情で、\n\#{targetname}達の行為を見下ろしている……"
          else
            action = premess + "何を思ったのか、\n\唐突にその場でゆらゆらと踊り始めた……"
          end
        when "独善" #フルビュア専用
          if target.holding?
            action = premess + "#{targetname}の視線に気付き、\n\一人納得したように微笑んだ……"
          else
            action = premess + "#{targetname}の視線に気付き、\n\一人納得したように微笑んだ……"
          end
        else
          action = premess + "くすくす笑っている……"
        end
        if myself.holding?
          action = premess + "くすくす笑っている……"
          action = premess + "身悶えしている……" if myself.crisis?
        end
        avoid = ""
  #------------------------------------------------------------------------#
  # ●キッス系
  #------------------------------------------------------------------------#
      when 301   #キッス弱
        case myself.personality
        when "淡泊", "内気"
          action = premess + "、\n\#{targetname}の唇にそっと唇を重ねてきた！"
        else
          action = premess + "、\n\#{targetname}にそっとキスをしてきた！"
        end
      when 302   #キッス中
        case myself.personality
        when "淡泊", "内気"
          action = premess + "目を閉じて、\n\#{targetname}にそっとキスをしてきた！"
        else
          action = premess + "、\n\#{targetname}にキスをしてきた！"
        end
      when 303   #キッス強
        case myself.personality
        when "淡泊", "内気", "高慢"
          action = premess + "目を閉じて、\n\#{targetname}と何度もキスを繰り返してきた！"
        else
          action = premess + "舌を絡めるように、\n\#{targetname}に情熱的なキスをしてきた！"
        end
      when 304   #キッス必殺
        case myself.personality
        when "淡泊", "内気", "高慢"
          action = premess + "うるんだ瞳で、\n\貪るように#{targetname}にキスをしてきた！"
        else
          action = premess + "舌を絡めるように、\n\#{targetname}に情熱的なキスをしてきた！"
        end
      when 305   #キッス追撃
        case myself.personality
        when "淡泊", "内気", "高慢"
          action = premess + "上目遣いに、\n\何度も#{targetname}にキスを重ねてきた！"
        else
          action = premess + "なおも激しく、\n\#{targetname}に情熱的なキスを重ねてきた！"
        end
      when 308   #ラブリィキッス
        action = premess + "可愛らしく微笑んで、\n\#{targetname}にそっとキスをしてきた！"
      when 309   #ロマンスキッス
        action = premess + "微笑みを浮かべ、\n\#{targetname}と情熱的なキスを交わした！"
      when 310   #ファシネイトキッス
        action = premess + "妖艶な笑みを浮かべ、\n\#{targetname}を抱き寄せてその唇を奪った！"
  #------------------------------------------------------------------------#
  # ●手技系
  #------------------------------------------------------------------------#
      when 319   #手攻めペニス焦
        if target.nude?
          action = premess + " gently touches #{targetname}'s\n\ penis with her hand!"
          action = premess + " gently brushes #{targetname}'s\n\ penis with her finger!" if $game_variables[17] > 50
          action += "\n\ precum dribbles out from the pleasure!" if target.lub_male >= 60
        else
          if target == $game_actors[101]
          action = "#{myname} gently strokes #{targetname}'s\n\ penis through his #{pantsu}!"
          else
          action = "#{myname} gently strokes #{targetname}'s\n\ penis through her #{pantsu}!"
          end
        end
      when 320   #手攻めペニス
        if target.nude?
          action = premess + " strokes #{targetname}'s\n\ penis with her hand!"
          action = premess + " strokes #{targetname}'s\n\ penis with her finger!" if $game_variables[17] > 50
          action += "\n\ precuｍ is spilling out froｍ the intense pleasure!" if target.lub_male >= 60
        else
          if target == $game_actors[101]
          action = "#{myname} strokes #{targetname}'s\n\ penis through his #{pantsu}!"
          else
          action = "#{myname} strokes #{targetname}'s\n\ penis through her #{pantsu}!"
          end
        end
      when 321   #手攻めペニス強
        if target.nude?
          #テキスト調整
          action = premess + "#{tec} pumps\n\ #{targetname}'s penis with her hand!"
          action = premess + "#{tec} runs \n\ her fingers over #{targetname}'s penis!" if $game_variables[17] > 50
          action += "\n\ precum is spilling out froｍ the intense pleasure!" if target.lub_male >= 60
          action.gsub!("様子で","手つきで") #表現の変更, unnecessary; can skip this
        else
          if target == $game_actors[101]
          action = "#{myname} quickly slips her\n\ hand into #{targetname}'s #{pantsu},\n\ running her hands over his penis!"
          else
          action = "#{myname} quickly slips her\n\ hand into #{targetname}'s #{pantsu},\n\ running her hands over her penis!"
          end
        end
      when 322   #手攻めペニス必殺
        if target.nude?
          action = premess + "#{tec} happily plays\n\ around with #{targetname}'s penis！"
          action += "\n\ precuｍ is spilling out froｍ the intense pleasure!" if target.lub_male >= 60
          action.gsub!("様子で","手つきで") #表現の変更, unnecessary; can skip this
        else
          if target == $game_actors[101]
          action = "#{myname} quickly slips her\n\ hand into #{targetname}'s #{pantsu},\n\ running her hands over his penis!"
          else
          action = "#{myname} quickly slips her\n\ hand into #{targetname}'s #{pantsu},\n\ running her hands over her penis!"
          end
        end
      when 323   #手攻め睾丸焦
        if target.nude?
          action = premess + " gently rubs her\n\ hand over #{targetname}'s testicles!"
          action = premess + " gently runs her\n\ fingers over #{targetname}'s testicles!" if $game_variables[17] > 50
        else
          if target == $game_actors[101]
          action = "#{myname} quickly slips her\n\ hand into #{targetname}'s #{pantsu},\n\ rubbing her hands over his scrotuｍ!"
          else
          action = "#{myname} quickly slips her\n\ hand into #{targetname}'s #{pantsu},\n\ rubbing her hands over her scrotuｍ!"
          end
        end
      when 324   #手攻め睾丸必殺
        if target.nude?
          action = premess + " massages #{targetname}'s\n\\ testicles with her hand!"
          action = premess + " feels up #{targetname}'s\n\\ testicles with her fingers!" if $game_variables[17] > 50
        else
          if target == $game_actors[101]
          action = "#{myname} quickly slips her\n\ hand into #{targetname}'s #{pantsu},\n\ feeling up his scrotuｍ!"
          else
          action = "#{myname} quickly slips her\n\ hand into #{targetname}'s #{pantsu},\n\ feeling up her scrotuｍ!"
          end
        end
      when 325   #手攻めペニス追撃
        if target.nude?
          action = premess + "#{tec} continues to\n\ caress #{targetname}'s penis soｍe ｍore!"
          action += "\n\ precuｍ keeps spilling out froｍ the intense pleasure!" if target.lub_male >= 60
        else
          action = "#{myname} slips her hand in again\n\ to grope #{targetname}'s penis soｍe ｍore!"
        end
      when 326   #手攻め睾丸追撃
        if target.nude?
          action = premess + "#{tec} continues to\n\ fondle #{targetname}'s balls soｍe ｍore!"
        else
          action = "#{myname} slips her hand in again\n\ to fondle #{targetname}'s balls soｍe ｍore!"
        end
  #------------------------------------------------------------------------#
      when 328   #手攻め胸焦
        if target.nude?
          action = premess + "手で、\n\#{targetname}の#{target.bustsize}に#{brk3}優しく触れてきた！"
          action = premess + "手で、\n\#{targetname}の乳首に優しく触れてきた！" if target.boy?
        else
          action = premess + "服の上から、\n\#{targetname}の#{target.bustsize}に#{brk3}手で優しく触れてきた！"
        end
        #胸サイズ診断(Ｃカップ基準)
        case $data_SDB[target.class_id].bust_size
        when 4,5 #Ｄ,Ｅ
          action.gsub!("さすって","揉んで") 
        end
      when 329   #手攻め胸
        if target.nude?
          action = premess + "両手で、\n\#{targetname}の#{target.bustsize}を#{brk3}揉みしだいてきた！"
          action = premess + "指先で、\n\#{targetname}の乳首を刺激してきた！" if target.boy?
        else
          action = premess + "服の上から、\n\#{targetname}の#{target.bustsize}を#{brk3}手で撫で回してきた！"
        end
        #胸サイズ診断(Ｃカップ基準)
        case $data_SDB[target.class_id].bust_size
        when 1,2 #Ａ,Ｂ
          action.gsub!("揉みしだいて","揉んで") 
        end
      when 330   #手攻め胸強
        if target.nude?
          action = premess + "指先で、\n\#{targetname}の乳首をつまみ刺激してきた！"
          action = premess + "指先で、\n\#{targetname}の乳首を巧みに刺激してきた！" if target.boy?
        else
          action = premess + "服に手を滑り込ませ、\n\#{targetname}の#{target.bustsize}を#{brk3}揉みしだいてきた！"
        end
        #胸サイズ診断(Ｃカップ基準)
        case $data_SDB[target.class_id].bust_size
        when 1,2 #Ａ,Ｂ
          action.gsub!("揉みしだいて","揉んで") 
        end
      when 331   #手攻め胸必殺
        if target.nude?
          action = premess + "#{tec}、\n\#{targetname}の#{target.bustsize}を#{brk3}思うまま弄ぶ！"
          action = premess + "#{tec}、\n\#{targetname}の乳首を巧みに刺激してきた！" if target.boy?
          action.gsub!("様子で","手つきで") #表現の変更
        else
          action = premess + "服に手を滑り込ませ、\n\#{targetname}の#{target.bustsize}を#{brk3}思うまま弄ぶ！"
        end
      when 332   #手攻め胸追撃
        if target.nude?
          action = premess + "#{tec}、\n\#{targetname}の#{target.bustsize}を#{brk3}更に揉みしだいた！"
          action = premess + "#{tec}、\n\#{targetname}の乳首を巧みに刺激してきた！" if target.boy?
        else
          action = premess + "服に滑り込ませた手で、\n\#{targetname}の#{target.bustsize}を更に弄ぶ！"
        end
        #胸サイズ診断(Ｃカップ基準)
        case $data_SDB[target.class_id].bust_size
        when 1,2 #Ａ,Ｂ
          action.gsub!("揉みしだいた","揉んできた") 
        end
  #------------------------------------------------------------------------#
      when 334   #手攻めアソコ焦
        if target.nude?
          action = premess + " gently rubs #{targetname}'s crotch!"
        else
          action = premess + " gently rubs #{targetname}'s crotch\\n through her #{pantsu}!"
        end
      when 335   #手攻めアソコ
        if target.nude?
          action = premess + " strokes #{targetname}'s crotch!"
          action = premess + "指先で、\n\#{targetname}のアソコの入り口を#{brk4}愛撫してきた！" if $game_variables[17] > 50
        else
          action = premess + " #{pantsu}の上から、\n\#{targetname}のアソコを撫でてきた！"
        end
      when 336   #手攻めアソコ強
        if target.nude?
          action = premess + "指を、\n\#{targetname}のアソコの奥まで入れてきた！"
        else
          action = premess + " #{pantsu}に手を滑り込ませ、\n\#{targetname}のアソコを指で愛撫してきた！"
        end
      when 337   #手攻めアソコ必殺
        if target.nude?
          action = premess + "#{tec}、\n\#{targetname}のアソコを思うまま弄ぶ！"
          action.gsub!("様子で","手つきで") if $game_variables[17] > 50 #一度変更すると変更対象文字がなくなるので条件は先に
          action.gsub!("様子で","指使いで") 
        else
          action = premess + "#{pantsu}に手を滑り込ませ、\n\#{targetname}のアソコを思うまま弄ぶ！"
        end
      when 338   #手攻め陰核焦
        if target.nude?
          action = premess + "指先で、\n\#{targetname}の陰核を優しく撫でてきた！"
        else
          action = premess + " #{pantsu}の上から、\n\#{targetname}の陰核を優しく撫でてきた！"
        end
      when 339   #手攻め陰核
        if target.nude?
          action = premess + "指先で、\n\#{targetname}の陰核を激しく刺激してきた！"
        else
          action = premess + " #{pantsu}に手を滑り込ませ、\n\#{targetname}の陰核を刺激してきた！"
        end
      when 340   #手攻め陰核必殺
        if target.nude?
          action = premess + " #{tec}、\n\#{targetname}の陰核を指で思うまま弄ぶ！"
        else
          action = premess + " #{pantsu}に手を滑り込ませ、\n\#{targetname}の陰核を指先でつまみあげた！"
        end
      when 341   #手攻めアソコ追撃
        if target.nude?
          action = premess + " #{tec}、\n\#{targetname}のアソコを更に攻め立てる！"
        else
          action = premess + " #{pantsu}に滑り込ませた手で、\n\#{targetname}のアソコを更に弄ぶ！"
        end
      when 342   #手攻め陰核追撃
        if target.nude?
          action = premess + " #{tec}、\n\#{targetname}の陰核を指先で弄ぶ！"
        else
          action = premess + " #{pantsu}に滑り込ませた指先で、\n\#{targetname}の陰核を更に弄ぶ！"
        end
  #------------------------------------------------------------------------#
      when 344   #手攻め尻焦
        if target.nude?
          action = premess + "手で、\n\#{targetname}のお尻をするりと撫でてきた！"
        else
          action = premess + " #{pantsu}越しに、\n\#{targetname}のお尻をするりと撫でてきた！"
        end
      when 345   #手攻め尻
        if target.nude?
          action = premess + "手で、\n\#{targetname}のお尻を揉みしだいてきた！"
        else
          action = premess + " #{pantsu}越しに、\n\#{targetname}のお尻を揉みしだいてきた！"
        end
      when 346   #手攻め尻強
        if target.nude?
          action = premess + "両手で、\n\#{targetname}のお尻を強く揉みしだいてきた！"
        else
          action = premess + " #{pantsu}に手を滑り込ませ、\n\#{targetname}のお尻を揉みしだいてきた！"
        end
      when 347   #手攻め尻必殺
        if target.nude?
          action = premess + " #{tec}、\n\#{targetname}のお尻を思うまま弄ぶ！"
          action.gsub!("様子で","手つきで") #表現の変更
        else
          action = premess + " #{pantsu}に手を滑り込ませ、\n\#{targetname}のお尻を思うまま弄ぶ！"
        end
      when 348   #手攻め前立腺焦
        if target.nude?
          action = premess + " 指先で、\n\#{targetname}の菊座を刺激してきた！"
        else
          action = premess + " #{pantsu}に手を滑り込ませ、\n\#{targetname}の菊座を刺激してきた！"
        end
      when 349   #手攻め前立腺
        if target.nude?
          action = premess + "指先で、\n\#{targetname}の菊門を刺激してきた！"
        else
          action = premess + " #{pantsu}に手を滑り込ませ、\n\#{targetname}の菊門を指で刺激してきた！"
        end
      when 350   #手攻め前立腺必殺
        if target.nude?
          action = premess + "#{tec}、\n\#{targetname}の菊門を指で愛撫してきた！"
        else
          action = premess + "#{pantsu}に手を滑り込ませ、\n\指で#{targetname}の菊門を愛撫してきた！"
        end
      when 351   #手攻めアナル焦
        if target.nude?
          action = premess + "指先で、\n\#{targetname}の菊座を刺激してきた！"
        else
          action = premess + "#{pantsu}に手を滑り込ませ、\n\#{targetname}の菊座を刺激してきた！"
        end
      when 352   #手攻めアナル
        if target.nude?
          action = premess + "指先で、\n\#{targetname}の菊門を刺激してきた！"
        else
          action = premess + "#{pantsu}に手を滑り込ませ、\n\#{targetname}の菊門を指で刺激してきた！"
        end
      when 353   #手攻めアナル必殺
        if target.nude?
          action = premess + "#{tec}、\n\#{targetname}の菊門を指で愛撫してきた！！"
        else
          action = premess + "#{pantsu}に手を滑り込ませ、\n\指で#{targetname}の菊門を愛撫してきた！"
        end
      when 354   #手攻め尻追撃
        if target.nude?
          action = premess + "#{tec}、\n\両手で#{targetname}のお尻を弄ぶ！"
        else
          action = premess + "#{pantsu}に滑り込ませた手で、\n\#{targetname}のお尻を更に弄ぶ！"
        end
      when 355   #手攻め前立腺追撃
        if target.nude?
          action = premess + "#{tec}、\n\指で#{targetname}の菊門を更に愛撫してきた！"
        else
          action = premess + "#{pantsu}に滑り込ませた指で、\n\#{targetname}の菊門を更に愛撫してきた！"
        end
      when 356   #手攻めアナル追撃
        if target.nude?
          action = premess + "#{tec}、\n\指で#{targetname}の菊門を更に愛撫してきた！"
        else
          action = premess + "#{pantsu}に滑り込ませた指で、\n\#{targetname}の菊門を更に愛撫してきた！"
        end
     #------------------------------------------------------------------------#
      when 359   #セットサークル
        action = premess + "足元に魔法陣を描いた！"
      when 360   #コールドタッチ
        points = ["首筋","背中","太もも"]
        if myself.nude?
          points.push("ペニス","袋") if myself.boy?
          points.push("アソコ","陰核","胸","乳首","お尻") unless myself.boy?
        end
        points = points[rand(points.size)]
        action = premess + "ひんやりした手で、\n\#{targetname}の#{points}を愛撫した！"
        action = premess + "ひんやりした指先で、\n\#{targetname}の#{points}を愛撫した！"
        avoid = ""
     #------------------------------------------------------------------------#
      when 361   #サディストカレス
        action = premess + "意地悪な手つきで、\n\#{targetname}を愛撫した！"
     #------------------------------------------------------------------------#
      when 362   #プライスオブハレム
        action = premess + "、\n\#{targetname + rangetext}をあまねく愛撫した！"
     #------------------------------------------------------------------------#
      when 363   #プライスオブシナー
        action = premess + "、\n\#{targetname + rangetext}をあまねく愛撫した！"
     #------------------------------------------------------------------------#
      when 364   #ペルソナブレイク
        action = premess + "#{targetname}の眼前で、\n\宙を握り潰した！"
     #------------------------------------------------------------------------#
      when 365   #キャストコール
        action = "夢世界は#{$game_actors[101].name}の記憶から\n過去の妄執を生み出した！"
  #------------------------------------------------------------------------#
  # ●口技系
  #------------------------------------------------------------------------#
      when 375   #口攻めペニス焦
        if target.nude?
          action = "#{myname} tenderly kisses up and\n\ down #{targetname}'s penis!"
          action = "#{myname} quietly licks #{targetname}'s penis with\n\ the tip of her tongue!" if $game_variables[17] > 50
          action += "\n\ A pleasantly wet sensation trickles down his penis!" if target.lub_male >= 60
        else
          if target == $game_actors[101]
          action = "Through his #{pantsu}, #{myname}\n\ tenderly kisses #{targetname}'s crotch!"
          else
          action = "Through her #{pantsu}, #{myname}\n\ tenderly kisses #{targetname}'s crotch!"
          end
        end
      when 376   #口攻めペニス
        if target.nude?
          action = premess + "is licking #{targetname}'s\n\ penis with her tongue!"
          action = "#{myname} licks #{targetname}'s penis\n\ with the tip of her tongue!" if $game_variables[17] > 50
          action += "\n\ A pleasantly wet sensation trickles down his penis!" if target.lub_male >= 60
        else
          if target == $game_actors[101]
          action = "Through his #{pantsu}, #{myname}\n\ pushes her face up against #{targetname}'s crotch!"
          else
          action = "Through her #{pantsu}, #{myname}\n\ pushes her face up against #{targetname}'s crotch!"
          end
        end
      when 377   #口攻めペニス強
        if target.nude?
          action = premess + "#{tec} licks\n\ the tip of #{targetname}'s penis clean!"
          action += "\n\ A pleasantly wet sensation dribbles down his penis!" if target.lub_male >= 60
          action.gsub!("様子で","舌使いで") #表現の変更
        else
          if target == $game_actors[101]
          action = "#{myname} licks up the length\n\ of #{targetname}'s penis through his #{pantsu}!"
          else
          action = "#{myname} licks up the length\n\ of #{targetname}'s penis through her #{pantsu}!"
          end
        end
      when 378   #口攻めペニス必殺
        if target.nude?
          action = "Starting at the base, #{myname}\n\ #{tec} licks up the length of #{targetname}'s penis!"
          action += "\n\ A pleasantly wet sensation trickles down his penis!" if target.lub_male >= 60
          action.gsub!("様子で","舌使いで") #表現の変更
        else
          if target == $game_actors[101]
          action = "Through his #{pantsu}, #{myname}'s\n\ mouth tries to gobble up #{targetname}'s penis!"
          else
          action = "Through her #{pantsu}, #{myname}'s\n\ mouth tries to gobble up #{targetname}'s penis!"
          end
        end
      when 379   #口攻め睾丸焦
        if target.nude?
          action = premess + " uses her mouth,\n\ tenderly suckling #{targetname}'s scrotum!"
        else
          if target == $game_actors[101]
          action = premess + " tenderly nuzzles #{targetname}'s\n\ scrotum through his #{pantsu}!"
          else
          action = premess + " tenderly nuzzles #{targetname}'s\n\ scrotum through her #{pantsu}!"
          end
        end
      when 380   #口攻め睾丸必殺
        if target.nude?
          action = premess + "#{tec}、\n\#{targetname}の袋を舐め回してきた！"
          action.gsub!("様子で","舌使いで") #表現の変更
        else
          action = premess + "#{pantsu}越しに、\n\#{targetname}の袋を舐め回してきた！"
        end
      when 381   #口攻めペニス追撃
        if target.nude?
          action = premess + "#{tec} licks\n\ #{targetname}'s penis some more!"
          action += "\n\ A pleasantly wet sensation dribbles down his penis!" if target.lub_male >= 60
        else
          action = premess + "なおも#{pantsu}越しに、\n\#{targetname}のペニスを舐め回してきた！"
        end
      when 382   #口攻め睾丸追撃
        if target.nude?
          action = premess + "#{tec}、\n\#{targetname}の袋を更に舐め上げてきた！"
        else
          action = premess + "なおも#{pantsu}越しに、\n\#{targetname}の袋を舐め回してきた！"
        end
  #------------------------------------------------------------------------#
      when 384   #口攻め胸焦
        if target.nude?
          action = premess + "唇で、\n\#{targetname}の#{target.bustsize}に#{brk3}そっとキスしてきた！"
        else
          action = premess + "服の上から、\n\#{targetname}の#{target.bustsize}に#{brk3}そっとキスしてきた！"
        end
      when 385   #口攻め胸
        if target.nude?
          action = premess + "舌で、\n\#{targetname}の#{target.bustsize}を#{brk3}なぞってきた！"
          action = premess + "舌先で、\n\#{targetname}の#{target.bustsize}を#{brk3}舐めてきた！" if $game_variables[17] > 50
        else
          action = premess + "服の上から、\n\#{targetname}の#{target.bustsize}にキスしてきた！"
        end
      when 386   #口攻め胸強
        if target.nude?
          action = premess + "舌先で、\n\#{targetname}の#{target.bustsize}を#{brk3}舐め回してきた！"
          action = premess + "#{tec}、\n\#{targetname}の乳首を舐め回してきた！" if $game_variables[17] > 50
          action.gsub!("様子で","舌使いで") #表現の変更
        else
          action = premess + "服の隙間から、\n\#{targetname}の#{target.bustsize}を舐め回してきた！"
        end
      when 387   #口攻め胸必殺
        if target.nude?
          action = premess + "#{tec}、\n\#{targetname}の#{target.bustsize}を#{brk3}強く吸い上げてきた！"
          action = premess + "#{tec}、\n\#{targetname}の乳首を強く吸い上げてきた！" if $game_variables[17] > 50
          action.gsub!("様子で","舌使いで") #表現の変更
        else
          action = premess + "服の隙間から、\n\#{targetname}の#{target.bustsize}を強く吸ってきた！"
        end
      when 388   #口攻め胸追撃
        if target.nude?
          action = premess + "#{tec}、\n\#{targetname}の#{target.bustsize}を#{brk3}更に舐め回した！"
          action = premess + "#{tec}、\n\#{targetname}の乳首を更に吸い上げた！" if $game_variables[17] > 50
        else
          action = premess + "服の隙間から、\n\#{targetname}の#{target.bustsize}を更に強く吸ってきた！"
        end
  #------------------------------------------------------------------------#
      when 390   #口攻めアソコ焦
        if target.nude?
          action = premess + "唇で、\n\#{targetname}のアソコにそっとキスしてきた！"
        else
          action = premess + "#{pantsu}の上から、\n\#{targetname}のアソコにそっとキスしてきた！"
        end
      when 391   #口攻めアソコ
        if target.nude?
          action = premess + "舌で、\n\#{targetname}のアソコを舐めてきた！"
          action = premess + "唇で、\n\#{targetname}のアソコにキスをしてきた！" if $game_variables[17] > 50
        else
          action = premess + "#{pantsu}の上から、\n\#{targetname}のアソコを舐めてきた！"
        end
      when 392   #口攻めアソコ強
        if target.nude?
          action = premess + "舌先をすぼめ、\n\#{targetname}のアソコに挿れてきた！"
          action = premess + "#{tec}、\n\#{targetname}のアソコを強く吸い上げた！" if $game_variables[17] > 50
        else
          action = premess + "#{pantsu}をずらし、\n\#{targetname}のアソコを舐め回してきた！"
        end
      when 393   #口攻めアソコ必殺
        if target.nude?
          action = premess + "#{tec}、\n\#{targetname}のアソコを思うまま弄ぶ！"
          action.gsub!("様子で","舌使いで") #表現の変更
        else
          action = premess + "#{pantsu}ごと、\n\#{targetname}のアソコに舌を突き入れてきた！"
        end
      when 394   #口攻め陰核焦
        if target.nude?
          action = premess + "舌先で、\n\#{targetname}の陰核を優しく愛撫してきた！"
        else
          action = premess + "#{pantsu}の上から、\n\#{targetname}の陰核を舌先で愛撫してきた！"
        end
      when 395   #口攻め陰核
        if target.nude?
          action = premess + "舌先で、\n\#{targetname}の陰核を舐め上げてきた！"
        else
          action = premess + "#{pantsu}をずらし、\n\#{targetname}の陰核を舐め上げてきた！"
        end
      when 396   #口攻め陰核必殺
        if target.nude?
          action = premess + "#{tec}、\n\#{targetname}の陰核を思うまま弄ぶ！"
        else
          action = premess + "#{pantsu}ごと、\n\#{targetname}の陰核を唇で吸い上げた！"
        end
      when 397   #口攻めアソコ追撃
        if target.nude?
          action = premess + "#{tec}、\n\#{targetname}のアソコを執拗に舐め上げる！"
        else
          action = premess + "#{tec}、\n\#{targetname}のアソコを#{pantsu}越しに弄ぶ！"
        end
      when 398   #口攻め陰核追撃
        if target.nude?
          action = premess + "#{tec}、\n\舌先で#{targetname}の陰核を執拗に弄ぶ！"
        else
          action = premess + "#{tec}、\n\#{pantsu}ごと#{targetname}の陰核を唇で吸い上げる！"
        end
  #------------------------------------------------------------------------#
      when 400   #口攻め尻焦
        if target.nude?
          action = premess + "唇で、\n\#{targetname}のお尻にそっとキスをしてきた！"
        else
          action = premess + "#{pantsu}越しに、\n\#{targetname}のお尻にそっとキスをしてきた！"
        end
      when 401   #口攻め尻
        if target.nude?
          action = premess + "舌で、\n\#{targetname}のお尻を舐め上げてきた！"
        else
          action = premess + "#{pantsu}越しに、\n\#{targetname}のお尻を舐め上げてきた！"
        end
      when 402   #口攻め尻強
        if target.nude?
          action = premess + "唇で、\n\#{targetname}のお尻に甘噛みしてきた！"
        else
          action = premess + "#{pantsu}ごと、\n\唇で#{targetname}のお尻に甘噛みしてきた！"
        end
      when 403   #口攻め尻必殺
        if target.nude?
          action = premess + "#{tec}、\n\#{targetname}のお尻を舐め回してきた！"
        else
          action = premess + "#{pantsu}を口でずらし、\n\#{targetname}のお尻を舐め回してきた！"
        end
      when 404   #口攻め前立腺焦
        if target.nude?
          action = premess + "舌先で、\n\#{targetname}の前立腺を刺激してきた！"
        else
          action = premess + "#{pantsu}の上から、\n\#{targetname}の菊座を刺激してきた！"
        end
      when 405   #口攻め前立腺
        if target.nude?
          action = premess + "舌先で、\n\#{targetname}の菊座周辺を舐め回してきた！"
        else
          action = premess + "#{pantsu}の上から、\n\#{targetname}の菊門を舌で刺激してきた！"
        end
      when 406   #口攻め前立腺必殺
        if target.nude?
          action = premess + "#{tec}、\n\#{targetname}の菊門の奥まで舌を入れてきた！"
          action.gsub!("様子で","舌使いで") #表現の変更
        else
          action = premess + "#{pantsu}ごと、\n\#{targetname}の菊門の奥まで舌を入れてきた！"
        end
      when 407   #口攻めアナル焦
        if target.nude?
          action = premess + "舌先で、\n\#{targetname}の菊座を刺激してきた！"
        else
          action = premess + "#{pantsu}の上から、\n\#{targetname}の菊座を刺激してきた！"
        end
      when 408   #口攻めアナル
        if target.nude?
          action = premess + "舌先で、\n\#{targetname}の菊門周辺を舐め回してきた！"
        else
          action = premess + "#{pantsu}の上から、\n\#{targetname}の菊門を舌で刺激してきた！"
        end
      when 409   #口攻めアナル必殺
        if target.nude?
          action = premess + "#{tec}、\n\#{targetname}の菊門の奥まで舌を入れてきた！"
          action.gsub!("様子で","舌使いで") #表現の変更
        else
          action = premess + "#{pantsu}ごと、\n\#{targetname}の菊門の奥まで舌を入れてきた！"
        end
      when 410   #口攻め尻追撃
        if target.nude?
          action = premess + "#{tec}、\n\舌で#{targetname}のお尻を執拗に舐め回す！"
        else
          action = premess + "#{tec}、\n\#{targetname}のお尻を更に舐め回してきた！"
        end
      when 411   #口攻め前立腺追撃
        if target.nude?
          action = premess + "#{tec}、\n\#{targetname}の菊門を舌で愛撫してきた！"
        else
          action = premess + "#{pantsu}の上から、\n\#{targetname}の菊門に更に舌を入れてきた！"
        end
      when 409   #口攻めアナル追撃
        if target.nude?
          action = premess + "#{tec}、\n\更に#{targetname}の菊門を舌で愛撫してきた！"
        else
          action = premess + "#{pantsu}をずらし、\n\#{targetname}の菊門を舌先で舐め上げてきた！"
        end
    #------------------------------------------------------------------------#
      when 415   #ハウリング
        action = premess + " lets out a loud howl!"
    #------------------------------------------------------------------------#
      when 416   #魔性の口付け
        action = premess + "#{targetname}の唇を奪った！"
    #------------------------------------------------------------------------#
      when 417   #祝福の口付け
        action = premess + "#{targetname}の唇を奪った！"
    #------------------------------------------------------------------------#
      when 418   #スイートウィスパー
        action = premess + "#{targetname}に甘く囁いた！"
    #------------------------------------------------------------------------#
      when 419   #アンラッキーロア
        action = premess + "不吉に鳴いた！"
    #------------------------------------------------------------------------#
      when 421   #懺悔なさい
        action = premess + "透き通った声で、\n\#{targetname}を一喝した！"
  #------------------------------------------------------------------------#
  # ●胸技系
  #------------------------------------------------------------------------#
      #パイズリは両者裸時のみのため、着衣テキストは無い
      when 431   #パイズリ焦
        action = premess + "#{myself.bustsize}の谷間で、\n\#{targetname}のペニスを挟んできた！"
        action += "\n\ぬめりを帯びたペニスに快感がこみ上げる！" if target.lub_male >= 60
      when 432   #パイズリ
        action = premess + "#{myself.bustsize}の谷間で、\n\#{targetname}のペニスを挟みしごいてきた！"
        action += "\n\ぬめりを帯びたペニスに快感が走る！" if target.lub_male >= 60
      when 433   #パイズリ強
        action = premess + "#{myself.bustsize}の谷間で、\n\#{targetname}のペニスをこね回してきた！"
        action += "\n\ぬめりを帯びたペニスに強い快感が走る！" if target.lub_male >= 60
      when 434   #パイズリ必殺
        action = premess + "#{tec}、\n\#{myself.bustsize}の谷間にペニスを挟み、\n\#{targetname}の反応を楽しみながら弄ぶ！"
        action += "\n\ぬめりを帯びたペニスに強い快感が走る！" if target.lub_male >= 60
      when 435   #擦り付け♂
        action = premess + "#{myself.bustsize}を、\n\#{targetname}のペニスに擦り付けてきた！"
        #胸サイズ診断(カップ指定、Ｃ以上には必要ない)
        case $data_SDB[myself.class_id].bust_size
        when 2 #Ｂ
          action.gsub!("を、","で、") 
          action.gsub!("に擦り付けてきた","を挟もうと頑張っている") 
        end
      when 436   #パイズリ追撃
        action = premess + "#{tec}、\n\#{myself.bustsize}に挟まれたペニスを弄ぶ！"
        action += "\n\ぬめりを帯びたペニスに強い快感が走る！" if target.lub_male >= 60
      when 437   #擦り付け♂追撃
        #胸サイズ診断(カップ指定、Ｃ以上には必要ない)
        case $data_SDB[myself.class_id].bust_size
        when 2 #Ｂ
          action = premess + "#{tec}、\n\#{myself.bustsize}で更にペニスを擦り上げてきた！"
        else
          action = premess + "#{tec}、\n\#{myself.bustsize}を更にペニスに擦り付けてきた！"
        end
  #------------------------------------------------------------------------#
      when 439   #ぱふぱふ焦
        #焦らしのみ着衣ぱふぱふが存在する
        if target.nude?
          action = premess + "#{myself.bustsize}の谷間を、\n\#{targetname}の顔に押し付けてきた！"
        else
          action = premess + "二つの膨らみを\n\#{targetname}の顔に押し当ててきた！"
        end
        #胸サイズ診断(Ｃカップ基準)
        case $data_SDB[myself.class_id].bust_size
        when 3 #Ｃ
          action.gsub!("二つ","形の良い二つ") 
        when 4 #Ｄ
          action.gsub!("二つ","豊満な二つ") 
        when 5 #Ｅ以上
          action.gsub!("二つ","圧倒的な二つ") 
        end
      when 440   #ぱふぱふ
        action = premess + "#{myself.bustsize}の谷間で、\n\#{targetname}の顔を包み込んできた！"
      when 441   #ぱふぱふ強
        action = premess + "#{myself.bustsize}の谷間に、\n\#{targetname}の顔を挟んで抱き締めてきた！"
      when 442   #ぱふぱふ必殺
        action = premess + "#{myself.bustsize}の谷間に、\n\#{targetname}の顔を挟んで#{brk4}強く抱き締めてきた！"
      when 443   #抱きつき
        action = premess + "#{myself.bustsize}で、\n\#{targetname}の顔に抱きついてきた！"
      when 444   #ぱふぱふ追撃
        action = premess + "#{tec}、\n\#{myself.bustsize}の谷間を更に押し付けてきた！"
      when 445   #抱きつき追撃
        #胸サイズ診断(カップ指定、Ｃ以上には必要ない)
        case $data_SDB[myself.class_id].bust_size
        when 2 #Ｂ
          action = premess + "#{tec}、\n\#{myself.bustsize}で更に抱きしめてきた！"
        else
          action = premess + "#{tec}、\n\#{myself.bustsize}を更に押し当ててきた！"
        end
  #------------------------------------------------------------------------#
      when 447   #胸合わせ焦
        action = premess + "#{myself.bustsize}を、\n\#{targetname}の#{target.bustsize}に#{brk3}押し当ててきた！"
      when 448   #胸合わせ
        action = premess + "#{myself.bustsize}を、\n\#{targetname}の#{target.bustsize}に#{brk3}擦り付けてきた！"
      when 449   #胸合わせ強
        action = premess + "互いの胸を擦りあわせ、\n\自らの乳首で#{targetname}の乳首を弄ってきた！"
      when 450   #胸合わせ必殺
        action = premess + "強く抱き合って、\n\#{targetname}に#{myself.bustsize}を擦りつけてきた！\n\互いの胸が淫らに歪み踊る！"
      when 451   #胸擦り付け焦
        action = premess + "#{myself.bustsize}を、\n\#{targetname}の#{target.bustsize}に#{brk3}押し当ててきた！"
      when 452   #胸擦り付け必殺
        action = premess + "#{myself.bustsize}を、\n\#{targetname}の#{target.bustsize}に#{brk3}擦り付けてきた！"
      when 453   #胸合わせ追撃
        brk2 = ""
        brk2 = "\n" if myself.bustsize.size + target.bustsize.size > 36 #両者の胸表現を足して１２文字越えで折り返す
        action = premess + "#{tec}、\n\#{myself.bustsize}と#{target.bustsize}を#{brk2}互いに擦り付け合う！"
      when 454   #胸擦り付け追撃
        brk2 = ""
        brk2 = "\n" if myself.bustsize.size + target.bustsize.size > 36 #両者の胸表現を足して１２文字越えで折り返す
        action = premess + "#{tec}、\n\#{myself.bustsize}と#{target.bustsize}を#{brk2}互いに擦り付け合う！"
  #------------------------------------------------------------------------#
  # ●アソコ技系(前提が裸なため、条件が着衣のテキストは無い)
  #------------------------------------------------------------------------#
      when 473   #素股焦
        action = premess + "アソコを押し付け、\n\#{targetname}のペニスをゆっくり擦ってきた！"
        action += "\n\ぬめりを帯びたペニスに快感がこみ上げる！" if target.lub_male >= 60
      when 474   #素股
        action = premess + "アソコを押し付け、\n\#{targetname}のペニスをしごいてきた！"
        action += "\n\ぬめりを帯びたペニスに快感が走る！" if target.lub_male >= 60
      when 475   #素股強
        action = premess + "アソコを押し付け、\n\#{targetname}のペニスをしごき上げてきた！"
        action += "\n\ぬめりを帯びたペニスに強い快感が走る！" if target.lub_male >= 60
      when 476   #素股必殺
        action = premess + "#{tec}、\n\#{targetname}に馬乗りになり#{brk4}ペニスを弄んでいる！"
        action += "\n\ぬめりを帯びたペニスに強い快感が走る！" if target.lub_male >= 60
      when 477   #素股追撃
        action = premess + "#{tec}、\n\#{targetname}に馬乗りのまま#{brk4}ペニスを弄んでいる！"
        action += "\n\ぬめりを帯びたペニスに強い快感が走る！" if target.lub_male >= 60
  #------------------------------------------------------------------------#
  # ●足技系
  #------------------------------------------------------------------------#
      when 486   #足コキ焦
        if target.nude?
          action = premess + "足の裏で、\n\#{targetname}のペニスを優しくさすってきた！"
          action += "\n\ぬめりを帯びたペニスに快感がこみ上げる！" if target.lub_male >= 60
        else
          action = premess + "服の上から、\n\#{targetname}のペニスを足の裏で#{brk4}刺激してきた！"
        end
      when 487   #足コキ
        if target.nude?
          action = premess + "足の指で、\n\#{targetname}のペニスを愛撫してきた！"
          action += "\n\ぬめりを帯びたペニスに快感が走る！" if target.lub_male >= 60
        else
          action = premess + "服の上から、\n\#{targetname}のペニスを足の指で#{brk4}愛撫してきた！"
        end
      when 488   #足コキ必殺
        if target.nude?
          action = premess + "#{tec}、\n\#{targetname}のペニスを足で思うまま弄ぶ！"
          action += "\n\ぬめりを帯びたペニスに強い快感が走る！" if target.lub_male >= 60
        else
          action = premess + "服の中に足先をねじ入れ、\n\#{targetname}のペニスを更に足指で弄ってきた！"
        end
      when 489   #足コキ追撃
        if target.nude?
          action = premess + "#{tec}、\n\#{targetname}のペニスを更に足で攻め立てる！"
          action += "\n\ぬめりを帯びたペニスに強い快感が走る！" if target.lub_male >= 60
        else
          action = premess + "服の中に足先をねじ込み、\n\#{targetname}のペニスを足指で弄ってきた！"
        end
  #------------------------------------------------------------------------#
      when 491   #足攻め胸焦
        if target.nude?
          action = premess + "足の指で、\n\#{targetname}の#{target.bustsize}を#{brk3}小刻みに刺激してきた！"
        else
          action = premess + "服の上から、\n\#{targetname}の#{target.bustsize}を#{brk3}足裏で刺激してきた！"
        end
      when 492   #足攻め胸
        if target.nude?
          action = premess + "足の指で、\n\#{targetname}の#{target.bustsize}を#{brk3}揉みしだいてきた！"
          action = premess + "足の指で、\n\#{targetname}の乳首を強く捻り上げてきた！" if $game_variables[17] > 50
        else
          action = premess + "服の上から、\n\#{targetname}の#{target.bustsize}を#{brk3}足の指で刺激してきた！"
        end
      when 493   #足攻め胸必殺
        if target.nude?
          action = premess + "#{tec}、\n\#{targetname}の#{target.bustsize}を#{brk3}足で思うまま弄ぶ！"
        else
          action = premess + "服の隙間から足先をねじ入れ、\n\#{targetname}の#{target.bustsize}を#{brk3}思うまま弄ぶ！"
        end
      when 494   #足攻め胸追撃
        if target.nude?
          action = premess + "#{tec}、\n\#{targetname}の#{target.bustsize}を#{brk3}足で更に攻め立てる！"
        else
          action = premess + "服の隙間から足先をねじ込み、\n\#{targetname}の#{target.bustsize}を#{brk3}足で更に刺激してきた！"
        end
  #------------------------------------------------------------------------#
      when 496   #足攻めアソコ焦
        if target.nude?
          action = premess + "足裏で、\n\#{targetname}のアソコを小刻みに刺激してきた！"
        else
          action = premess + "#{pantsu}の上から、\n\#{targetname}のアソコを足裏で刺激してきた！"
        end
      when 497   #足攻めアソコ
        if target.nude?
          action = premess + "足の指で、\n\#{targetname}のアソコをぐりぐり刺激してきた！"
        else
          action = premess + "#{pantsu}の上から、\n\#{targetname}のアソコを足の指で刺激してきた！"
        end
      when 498   #足攻めアソコ必殺
        if target.nude?
          action = premess + "#{tec}、\n\#{targetname}のアソコを足指で思うまま弄ぶ！"
        else
          action = premess + "#{pantsu}に足先をねじ入れ、\n\#{targetname}のアソコを思うまま弄ぶ！"
        end
      when 499   #足攻めアソコ必殺
        if target.nude?
          action = premess + "#{tec}、\n\#{targetname}のアソコを#{brk4}足指でなおも攻め立てる！"
        else
          action = premess + "#{pantsu}にねじ込んだ足先で、\n\#{targetname}のアソコを更に攻め立てる！"
        end
  #------------------------------------------------------------------------#
  # ●愛撫技
  #------------------------------------------------------------------------#
      when 508   #愛撫・顔周り
        case $game_variables[17]
        when 0..24
          action = premess + "舌先で、\n\#{targetname}の首筋をつうっとなぞってきた！"
        when 25..50
          action = premess + "唇で、\n\#{targetname}の耳たぶを甘噛みしてきた！"
        when 51..75
          action = premess + "、\n\#{targetname}の額にそっとキスをした！"
        else
          action = premess + "、\n\#{targetname}の頬にそっとキスをした！"
        end
      when 509   #愛撫・上半身
        case $game_variables[17]
        when 0..24
          action = premess + "手で、\n\#{targetname}の背中を優しく撫でてきた！"
        when 25..50
          action = premess + "舌先で、\n\#{targetname}のへその周りを舐めてきた！"
        when 51..75
          action = premess + "上目使いで、\n\#{targetname}の指を丁寧にしゃぶってきた！"
        else
          action = premess + "舌先で、\n\#{targetname}の脇をつぅっとなぞってきた！"
        end
      when 510   #愛撫・下半身(主に脚)
        case $game_variables[17]
        when 0..24
          action = premess + "指先で、\n\#{targetname}の腰をつぅっとなぞってきた！"
        when 25..50
          action = premess + "手で、\n\#{targetname}の太ももを撫でてきた！"
        when 51..75
          action = premess + "自分の脚を、\n\#{targetname}の足に絡ませてきた！"
        else
          action = premess + "舌で、\n\#{targetname}の足の指を丁寧に舐めてきた！"
        end
      when 511   #愛撫・髪撫で
        action = premess + "指先で、\n\#{targetname}の髪をふわりとかき上げてきた！"
        action = premess + "手のひらで、\n\#{targetname}の髪をさわさわと撫でてきた！" if $game_variables[17] > 50
      when 512   #愛撫・抱きしめ
        action = premess + "、\n\#{targetname}を優しく抱きしめてきた！"
  #------------------------------------------------------------------------#
      when 515   #尻尾攻め♂・焦
        action = premess + "#{targetname}の#{pantsu}の中に、\n\#{tail}を潜り込ませペニスを愛撫してきた！"
        action = premess + "#{targetname}のペニスに、\n\#{tail}を絡めて擦り上げてきた！" if target.nude?
  #------------------------------------------------------------------------#
      when 523   #尻尾攻め胸・焦
        action = premess + "#{tail}を使い、\n\服の間から#{targetname}の#{brk3}#{target.bustsize}を愛撫した！"
        action = premess + "#{tail}を使い、\n\#{targetname}の#{target.bustsize}を愛撫した！" if target.nude?
  #------------------------------------------------------------------------#
      when 528   #尻尾攻め♀・焦
        action = premess + "#{targetname}の#{pantsu}の中に、\n\#{tail}を潜り込ませてアソコを愛撫してきた！"
        action = premess + "#{targetname}のアソコに、\n\#{tail}を擦り付けて愛撫してきた！" if target.nude?
  #------------------------------------------------------------------------#
      when 536   #尻尾攻め尻・焦
        action = premess + "#{targetname}の#{pantsu}の隙間から、\n\#{tail}を滑り込ませて愛撫してきた！"
        action = premess + "#{targetname}のお尻に、\n\#{tail}を滑らせて愛撫してきた！" if target.nude?
  #------------------------------------------------------------------------#
  # ●特殊身体系
  #------------------------------------------------------------------------#
      when 586   #レストレーション
        action = "#{myname}の身体の粘液が増えていく……！\n\#{myname}の身体が再び粘液で覆われた！"
      when 587   #スライミーリキッド
        action = premess + "身体の粘液を手に取り、\n\#{targetname}の服の隙間から流し入れてきた！"
        action = premess + "身体の粘液を手に取り、\n\#{targetname}の身体に塗りつけてきた！" if target.nude?
      when 588   #激励
        action = premess + "#{targetname}を激励した！"
      when 589   #バッドスポア
        action = premess + "、\n\#{targetname}に胞子を吹きかけた！"
      when 590   #スポアクラウド
        action = premess + "辺り一面に胞子を振りまいた！"
      when 591   #アイヴィクローズ
        action = premess + "しなる蔦を、\n\#{targetname}の身体に巻き付けた！"
      when 592   #デモンズクローズ
        action = "#{myname}の操る触手が、\n\蠢くように#{targetname}の身体に巻き付いた！"
      when 599   #焦燥
        action = premess + "自分を急き立てた！"
      when 600   #専心
        action = premess + "目を瞑り集中した！"
      when 601   #本能の呼び覚まし
        action = premess + "内に眠る本能を呼び覚ました！"
      when 602   #自信過剰
        action = premess + "自らの美貌に酔いしれた！"# + "\n\その揺るぎない自信は力となる！"
    #------------------------------------------------------------------------#
      when 611   #リラックスタイム
        action = premess + " calls for relaxation!"
      when 612   #スイートアロマ
        action = premess + " is releasing a sweet fragrance!"
      when 613   #パッションビート
        action = premess + "鼓舞し、やる気を高めた！"
      when 614   #マイルドパフューム
        action = premess + " lets off a gentle fragrance!"
      when 615   #レッドカーペット
        action = premess + " used Red Carpet!"
      when 618   #ストレンジスポア
        action = premess + "奇妙な胞子を振りまいた！"
      when 619   #ウィークスポア
        action = premess + "胞子を振りまいた！"
      when 620   #威迫
        action = premess + "威迫した！"
      when 621   #心掴み
        action = premess + "じっと見つめた！"
      when 622   #全ては現
        action = premess + "全ては現だと思い知らせた！"
      when 625   #ラブフレグランス
        action = premess + "ピンク色の香りを振りまいた！"
      when 626   #スライムフィールド
        action = premess + "身体の粘液を周囲に広げた！"
    #------------------------------------------------------------------------#
      when 631   #激励を受ける
        action = premess + "激励を受けた！"
  #------------------------------------------------------------------------#
  # ●グラインド系
  #------------------------------------------------------------------------#
      when 751   #グラインド弱
        waist = ["ゆっくりと","控えめに"]
        waist.push("ゆったりと") if myself.positive?
        waist.push("焦らすように") if myself.positive?
        waist.push("おずおずと") if myself.negative?
        waist.push("恥らいつつも") if myself.negative?
        waist = waist[rand(waist.size)]
        action = premess + "#{waist}腰を動かしてきた！"
      when 752   #グラインド中
        waist = ["前後に","左右に"]
        waist.push("回すように") if myself.positive?
        waist.push("恥らいつつ") if myself.negative?
        waist = waist[rand(waist.size)]
        action = premess + "#{waist}腰を振ってきた！"
      when 753   #グラインド強
        waist = ["大胆に","大きく","激しく"]
        waist.push("緩急をつけて") if myself.positive?
        waist.push("うねるように") if myself.positive?
        waist.push("艶かしく") if myself.positive?
        waist.push("一所懸命に") if myself.negative?
        waist.push("一心不乱に") if myself.negative?
        waist.push("蕩けた表情で") if myself.negative?
        waist = waist[rand(waist.size)]
        action = premess + "#{waist}腰を振り始めた！"
      when 754   #グラインド必殺
        waist = ["大胆に","大きく","激しく"]
        waist.push("緩急をつけて") if myself.positive?
        waist.push("うねるように") if myself.positive?
        waist.push("艶かしく") if myself.positive?
        waist.push("一所懸命に") if myself.negative?
        waist.push("一心不乱に") if myself.negative?
        waist.push("蕩けた表情で") if myself.negative?
        waist = waist[rand(waist.size)]
        action = premess + "#{waist}腰を振ってきた！"
      when 755   #締める
        action = premess + "アソコをきゅっと締めてきた！"
        action = "#{myname}のアソコがきゅっと締まった！" if myself.negative?
      when 756   #締める必殺
        action = premess + "アソコをぎゅっと強く締めてきた！"
        action = "#{myname}のアソコがぎゅっと強く締まった！" if myself.negative?
      when 757   #グラインド追撃
        waist = ["大胆に","大きく","激しく"]
        waist.push("緩急をつけて") if myself.positive?
        waist.push("うねるように") if myself.positive?
        waist.push("艶かしく") if myself.positive?
        waist.push("一所懸命に") if myself.negative?
        waist.push("一心不乱に") if myself.negative?
        waist = waist[rand(waist.size)]
        action = premess + "#{tec}、\n\更に#{waist}腰を前後させてきた！"
      when 758   #締める追撃
        action = "#{myname}のアソコが別の生き物のように、\n#{targetname}のペニスを官能的に締め付ける！"
  #------------------------------------------------------------------------#
      when 760   #貝合わせ焦
        action = premess + "#{brk}#{targetname}と脚を絡めあい、\n\アソコ同士を押し当てた！"
      when 761   #貝合わせ
        action = premess + "#{brk}#{targetname}と脚を絡めあい、\n\アソコ同士を擦り合わせた！"
      when 762   #貝合わせ強
        waist = ["大胆に","強く","激しく"]
        waist.push("緩急をつけて") if myself.positive?
        waist.push("うねるように") if myself.positive?
        waist.push("艶かしく") if myself.positive?
        waist.push("一所懸命に") if myself.negative?
        waist.push("一心不乱に") if myself.negative?
        waist = waist[rand(waist.size)]
        action = premess + "#{brk}#{targetname}と脚を絡めあい、\n\アソコ同士を#{waist}擦り合わせた！"
      when 763   #貝合わせ必殺
        waist = ["大胆に","強く","激しく"]
        waist.push("緩急をつけて") if myself.positive?
        waist.push("うねるように") if myself.positive?
        waist.push("艶かしく") if myself.positive?
        waist.push("一所懸命に") if myself.negative?
        waist.push("一心不乱に") if myself.negative?
        waist = waist[rand(waist.size)]
        action = premess + "#{brk}#{targetname}と脚を絡めあい、\n\アソコ同士を#{waist}擦り合わせた！"
      when 764   #貝合わせ追撃
        waist = ["大胆に","強く","激しく"]
        waist.push("緩急をつけて") if myself.positive?
        waist.push("うねるように") if myself.positive?
        waist.push("艶かしく") if myself.positive?
        waist.push("一所懸命に") if myself.negative?
        waist.push("一心不乱に") if myself.negative?
        waist = waist[rand(waist.size)]
        action = premess + "#{brk}#{targetname}の脚を抱え、\n\更にアソコ同士を#{waist}擦り合わせた！"
  #------------------------------------------------------------------------#
      when 766   #ライディング焦
        if myself.nude?
          action = premess + "#{brk}#{targetname}にまたがったまま、\n\アソコを口に押し付けてきた！"
        else
          case $data_SDB[myself.class_id].name
          when "Caster","Familiar","Little Witch","Witch"
            action = premess + "スカートの端を持ち、\n\#{targetname}の口に#{pantsu}を押し付けた！"
          when "Lesser Succubus","Succubus"
            action = premess + "drops down her hips、\n\#{targetname}の口に#{pantsu}を押し付けた！"
          when "Iｍp","Devil"
            action = premess + "drops down her hips、\n\#{targetname}の口に#{pantsu}を押し付けた！"
          when "Sliｍe"
            action = premess + "#{brk}#{targetname}にまたがったまま、\n\股の窪みを押し付けてきた！"
          when "Nightｍare"
            action = premess + "drops down her hips、\n\#{targetname}の口に#{pantsu}越しのアソコを押し付けた！"
          else
            action = premess + "drops down her hips、\n\#{targetname}の口に#{pantsu}を押し付けた！"
          end
        end
      when 767   #ライディング
        if myself.nude?
          action = premess + "#{brk}#{targetname}にまたがったまま、\n\ゆっくりと腰を前後に振ってきた！"
        else
          case $data_SDB[myself.class_id].name
          when "Caster","Familiar","Little Witch","Witch"
            action = premess + "スカートの端を持ち、\n\#{targetname}の口に#{pantsu}を押し付けた！"
          when "Lesser Succubus","Succubus"
            action = premess + "腰を落とし、\n\#{targetname}の口に#{pantsu}を押し付けた！"
          when "Iｍp","Devil"
            action = premess + "腰を落とし、\n\#{targetname}の口に#{pantsu}を押し付けた！"
          when "Sliｍe"
            action = premess + "#{brk}#{targetname}にまたがったまま、\n\股の窪みを強く押し付けてきた！"
          when "Nightｍare"
            action = premess + "腰を落とし、\n\#{targetname}の口に#{pantsu}越しのアソコを押し付けた！"
          else
            action = premess + "腰を落とし、\n\#{targetname}の口に#{pantsu}を押し付けた！"
          end
        end
      when 768   #ライディング必殺
        waist = ["大胆に","回すように","激しく"]
        waist.push("緩急をつけて") if myself.positive?
        waist.push("うねるように") if myself.positive?
        waist.push("艶かしく") if myself.positive?
        waist.push("一所懸命に") if myself.negative?
        waist.push("一心不乱に") if myself.negative?
        waist = waist[rand(waist.size)]
        action = premess + "#{brk}#{targetname}に見せ付けるように、\n\顔の上で#{waist}腰を振ってきた！"
      when 769   #ライディング追撃
        waist = ["大胆に","激しく"]
        waist.push("緩急をつけて") if myself.positive?
        waist.push("うねるように") if myself.positive?
        waist.push("踊るように") if myself.positive?
        waist.push("一所懸命に") if myself.negative?
        waist.push("一心不乱に") if myself.negative?
        waist = waist[rand(waist.size)]
        action = premess + "#{brk}#{targetname}に馬乗りのまま、\n\更に#{waist}腰を前後に振ってきた！"
  #------------------------------------------------------------------------#
      when 772   #エナジードレイン
        action = premess + "絞り取るように腰を振ってきた！"
      when 773   #レベルドレイン
        action = premess + "絞り取るように腰を振ってきた！"
  #------------------------------------------------------------------------#
      when 788   #フェラチオ焦
        action = premess + "#{targetname}のペニスを、\n\口で咥えたままゆっくりと舌を這わせてきた！"
      when 789   #フェラチオ
        action = premess + "#{targetname}のペニスを、\n\口で咥えたままゆっくりとしゃぶってきた！"
      when 790   #フェラチオ強
        action = premess + "#{targetname}のペニスを、\n\口で咥えたまま舌で舐め回してきた！"
      when 791   #フェラチオ必殺
        action = premess + "#{targetname}のペニスを、\n\口で咥えたまま艶かしく舐め回してきた！"
      when 792   #スロート
        action = premess + "#{targetname}のペニスを、\n\ゆっくりと吸い上げてきた！"
      when 793   #スロート必殺
        action = premess + "#{targetname}のペニスを、\n\飲み込むように吸い上げてきた！"
      when 794   #フェラチオ追撃
        action = premess + "#{targetname}のペニスを、\n\口に咥えたまま舌で更に舐め回してきた！"
      when 795   #スロート追撃
        action = premess + "#{targetname}のペニスを、\n\緩急を付けて更に吸い上げてきた！"
  #------------------------------------------------------------------------#
      when 797   #クンニ焦
        action = premess + "#{targetname}のアソコを、\n\口全体でゆっくりと吸い上げてきた！"
      when 798   #クンニ
        action = premess + "#{targetname}のアソコに、\n\舌先を入れて前後に抜き差ししてきた！"
      when 799   #クンニ強
        action = premess + "#{targetname}のアソコを、\n\口全体で陰核ごと強く吸い上げてきた！"
      when 800   #クンニ必殺
        action = premess + "#{targetname}のアソコに、\n\舌先を尖らせ奥まで勢い良く突き入れてきた！"
      when 801   #クンニ追撃
        action = premess + "#{targetname}のアソコを、\n\口で吸い付いたまま更に舌で愛撫してきた！"
  #------------------------------------------------------------------------#
      when 803   #ディープキッス焦
        action = premess + "#{targetname}と、\n\ゆっくりと互いの舌を絡めあった！"
      when 804   #ディープキッス
        action = premess + "#{targetname}と、\n\互いの舌を絡めあった！"
      when 805   #ディープキッス強
        action = premess + "#{targetname}と、\n\互いに激しく唇を貪りあった！"
      when 806   #ディープキッス必殺
        action = premess + "#{targetname}の口内に、\n\舌を舐め入れ唾液を流し込んできた！"
      when 807   #ディープキッス追撃
        action = premess + "なおも激しく、\n\#{targetname}の口内を舌で蹂躙する！"
  #------------------------------------------------------------------------#
      when 828   #背面拘束・スタン狙い
        action = premess + "#{targetname}と密着し、\n\首筋にふぅっと息を吹きかけてきた！"
        action = premess + "#{targetname}と密着し、\n\耳たぶを唇で甘噛みしてきた！"
      when 829   #背面拘束・必殺狙い
        if target.boy?
          action = premess + "#{targetname}と密着し、\n\首筋を舌でつぅっと舐めあげてきた！"
          action = premess + "#{targetname}と密着し、\n\手を伸ばしてペニスを指で愛撫してきた！" unless target.hold.penis.battler != nil
        else
          action = premess + "#{targetname}と密着し、\n\#{target.bustsize}を揉みしだいてきた！"
          action = premess + "#{targetname}と密着し、\n\アソコに手を伸ばし指で愛撫してきた！" unless target.hold.vagina.battler != nil
        end
      when 830   #背面拘束追撃
        if target.boy?
          action = premess + "#{tec}、\n\密着したまま#{targetname}に#{brk4}キスの雨を降らせた！"
          action = premess + "#{tec}、\n\密着したまま#{targetname}のペニスを#{brk4}指で弄ぶ！" unless target.hold.penis.battler != nil
        else
          action = premess + "#{tec}、\n\密着したまま#{targetname}の#{target.bustsize}を#{brk4}愛撫した！"
          action = premess + "#{tec}、\n\密着したまま#{targetname}のアソコを#{brk4}指で弄んだ！" unless target.hold.vagina.battler != nil
        end
  #------------------------------------------------------------------------#
      #パイズリ系
      when 836   #ストローク焦
        action = premess + "#{myself.bustsize}の谷間で、\n\#{targetname}のペニスをぎゅっと圧迫してきた！"
        action += "\n\ぬめりを帯びたペニスに快感が走る！" if target.lub_male >= 60
      when 837   #ストローク
        action = premess + "#{myself.bustsize}の谷間で、\n\#{targetname}のペニスを挟んでしごいてきた！"
        action += "\n\ぬめりを帯びたペニスに快感が走る！" if target.lub_male >= 60
      when 838   #ストローク強
        action = premess + "#{myself.bustsize}の谷間にペニスを挟み、\n\#{targetname}を上目遣いに見ながら舌を這わせてきた！"
        target.lub_male += 4
        action += "\n\ぬめりを帯びたペニスに強い快感が走る！" if target.lub_male >= 60
      when 839   #ストローク必殺
        action = premess + "#{myself.bustsize}の谷間にペニスを挟み、\n\#{targetname}の反応を楽しむかのように弄んできた！"
        action += "\n\ぬめりを帯びたペニスに強い快感が走る！" if target.lub_male >= 60
      when 840   #ストローク追撃
        action = premess + "更に#{myself.bustsize}を押し付け、\n\#{targetname}のペニスに舌を這わせながら擦り上げた！"
        target.lub_male += 4
        action += "\n\ぬめりを帯びたペニスに強い快感が走る！" if target.lub_male >= 60
  #------------------------------------------------------------------------#
      #ぱふぱふ系
      when 842   #プレス焦
        action = premess + "#{myself.bustsize}の谷間で、\n\#{targetname}の顔を優しく包み込んできた！"
      when 843   #プレス
        action = premess + "#{myself.bustsize}の谷間で、\n\#{targetname}の顔を抱きしめてきた！"
      when 844   #プレス強
        action = premess + "#{myself.bustsize}の谷間を、\n\#{targetname}の顔をぎゅっと押し付けてきた！"
      when 845   #プレス必殺
        action = premess + "#{myself.bustsize}の谷間で、\n\#{targetname}の顔を挟みこね回してきた！"
      when 846   #プレス追撃
        action = premess + "更に#{myself.bustsize}で、\n\#{targetname}の顔を包み込みこね回す！"
  #------------------------------------------------------------------------#
      #ディルド系
      when 891   #ディルド♀挿入・焦
        waist = ["ゆっくりと","控えめに"]
        waist.push("ゆったりと") if myself.positive?
        waist.push("焦らすように") if myself.positive?
        waist.push("おずおずと") if myself.negative?
        waist.push("恥らいつつも") if myself.negative?
        waist = waist[rand(waist.size)]
        action = premess + "#{waist}腰を動かしてきた！"
      when 892   #ディルド♀挿入
        waist = ["前後に"]
        waist.push("押しこむように") if myself.positive?
        waist.push("恥らいつつ") if myself.negative?
        waist = waist[rand(waist.size)]
        action = premess + "#{waist}腰を振ってきた！"
      when 893   #ディルド♀挿入・必殺
        waist = ["大胆に","大きく","激しく"]
        waist.push("緩急をつけて") if myself.positive?
        waist.push("抉るように") if myself.positive?
        waist.push("身体を掴んで") if myself.positive?
        waist.push("一所懸命に") if myself.negative?
        waist.push("一心不乱に") if myself.negative?
        waist.push("蕩けた表情で") if myself.negative?
        waist = waist[rand(waist.size)]
        action = premess + "#{waist}腰を振り始めた！"
      when 894   #ディルド♀挿入・追撃
        waist = ["大胆に","大きく","激しく"]
        waist.push("緩急をつけて") if myself.positive?
        waist.push("抉るように") if myself.positive?
        waist.push("身体を掴んで") if myself.positive?
        waist.push("一所懸命に") if myself.negative?
        waist.push("一心不乱に") if myself.negative?
        waist = waist[rand(waist.size)]
        action = premess + "#{tec}、\n\更に#{waist}腰を前後させてきた！"
  #------------------------------------------------------------------------#
      when 896   #ディルド口挿入・焦
        waist = ["ゆっくりと","控えめに"]
        waist.push("ゆったりと") if myself.positive?
        waist.push("焦らすように") if myself.positive?
        waist.push("おずおずと") if myself.negative?
        waist.push("恥らいつつも") if myself.negative?
        waist = waist[rand(waist.size)]
        action = premess + "#{waist}腰を動かしてきた！"
      when 897   #ディルド口挿入
        waist = ["前後に"]
        waist.push("押しこむように") if myself.positive?
        waist.push("恥らいつつ") if myself.negative?
        waist = waist[rand(waist.size)]
        action = premess + "#{waist}腰を振ってきた！"
      when 898   #ディルド口挿入・必殺
        waist = ["大胆に","大きく","激しく"]
        waist.push("緩急をつけて") if myself.positive?
        waist.push("抉るように") if myself.positive?
        waist.push("身体を掴んで") if myself.positive?
        waist.push("一所懸命に") if myself.negative?
        waist.push("一心不乱に") if myself.negative?
        waist.push("蕩けた表情で") if myself.negative?
        waist = waist[rand(waist.size)]
        action = premess + "#{waist}腰を振り始めた！"
      when 899   #ディルド口挿入・追撃
        waist = ["大胆に","大きく","激しく"]
        waist.push("緩急をつけて") if myself.positive?
        waist.push("抉るように") if myself.positive?
        waist.push("身体を掴んで") if myself.positive?
        waist.push("一所懸命に") if myself.negative?
        waist.push("一心不乱に") if myself.negative?
        waist = waist[rand(waist.size)]
        action = premess + "#{tec}、\n\更に#{waist}腰を前後させてきた！"
  #------------------------------------------------------------------------#
      when 901   #ディルド尻挿入・焦
        waist = ["ゆっくりと","控えめに"]
        waist.push("ゆったりと") if myself.positive?
        waist.push("焦らすように") if myself.positive?
        waist.push("おずおずと") if myself.negative?
        waist.push("恥らいつつも") if myself.negative?
        waist = waist[rand(waist.size)]
        action = premess + "#{waist}腰を動かしてきた！"
      when 902   #ディルド尻挿入
        waist = ["前後に"]
        waist.push("押しこむように") if myself.positive?
        waist.push("恥らいつつ") if myself.negative?
        waist = waist[rand(waist.size)]
        action = premess + "#{waist}腰を振ってきた！"
      when 903   #ディルド尻挿入・必殺
        waist = ["大胆に","大きく","激しく"]
        waist.push("緩急をつけて") if myself.positive?
        waist.push("抉るように") if myself.positive?
        waist.push("身体を掴んで") if myself.positive?
        waist.push("一所懸命に") if myself.negative?
        waist.push("一心不乱に") if myself.negative?
        waist.push("蕩けた表情で") if myself.negative?
        waist = waist[rand(waist.size)]
        action = premess + "#{waist}腰を振り始めた！"
      when 904   #ディルド尻挿入・追撃
        waist = ["大胆に","大きく","激しく"]
        waist.push("緩急をつけて") if myself.positive?
        waist.push("抉るように") if myself.positive?
        waist.push("身体を掴んで") if myself.positive?
        waist.push("一所懸命に") if myself.negative?
        waist.push("一心不乱に") if myself.negative?
        waist = waist[rand(waist.size)]
        action = premess + "#{tec}、\n\更に#{waist}腰を前後させてきた！"
  #------------------------------------------------------------------------#
      #触手系
      when 733   #触手フェラチオ・焦
        action = "#{myname}の操る触手が、#{targetname}の\n\ペニスを咥えたままもぞもぞと蠢き愛撫した！"
      when 734   #触手フェラチオ
        action = "#{myname}の操る触手が、#{targetname}の\n\ペニスを咥えたままゆっくりとしゃぶってきた！"
      when 735   #触手フェラチオ・必殺
        action = "#{myname}の操る触手が、#{targetname}の\n\ペニスを咥えたまま激しくしゃぶってきた！"
      when 736   #触手フェラチオ・追撃
        action = "#{myname}の操る触手が、#{targetname}の\n\ペニスを咥えたまま更にしゃぶってきた！"
  #------------------------------------------------------------------------#
      when 738   #触手クンニ・焦
        action = "#{myname}の操る触手が、#{targetname}の\n\アソコに張り付いたままもぞもぞと蠢き愛撫した！"
      when 739   #触手クンニ
        action = "#{myname}の操る触手が、#{targetname}の\n\アソコに張り付いたままゆっくりと吸い上げてきた！"
      when 740   #触手クンニ・必殺
        action = "#{myname}の操る触手が、#{targetname}の\n\アソコに張り付いたまま陰核ごと強く吸い上げてきた！"
      when 741   #触手クンニ・追撃
        action = "#{myname}の操る触手が、#{targetname}の\n\アソコに張り付いたまま更に吸い上げてきた！"
  #------------------------------------------------------------------------#
      when 942   #舌突き上げ♀
        action = premess + "舌先で、\n\#{targetname}のアソコを下から突き上げた！"
        action = premess + "舌で、\n\#{targetname}のアソコを舐め回した！" if $game_variables[17] > 50
      when 943   #舌突き上げ尻
        action = premess + "舌先で、\n\#{targetname}の菊門を下から突き上げた！"
        action = premess + "舌で、\n\#{targetname}の菊座を舐め回した！" if $game_variables[17] > 50
      when 944   #胸揉み
        action = premess + "自由に動かせる手で、\n\#{targetname}の#{target.bustsize}を鷲掴みにした！"
        action = premess + "自由に動かせる手で、\n\#{targetname}の#{target.bustsize}を下から鷲掴みにした！" if myself.mouth_riding?
        action = premess + "自由に動かせる指で、\n\#{targetname}の乳首を摘み上げた！" if $game_variables[17] > 50
      when 945   #尻揉み
        action = premess + "自由に動かせる手で、\n\#{targetname}のお尻を鷲掴みにした！"
        action = premess + "自由に動かせる指で、\n\#{targetname}の菊門を刺激した！" if $game_variables[17] > 80
      when 946   #背面愛撫
        action = premess + "\n\#{targetname}の太ももを撫で回した！"
        action = premess + "\n\#{targetname}のアソコを指で愛撫した！" if $game_variables[17] > 50
      when 947   #キス反撃
        action = premess + "顔を近づけ、\n\#{targetname}にキスをした！"
        action = premess + "顔を近づけ、\n\#{targetname}と艶めかしく舌を絡ませた！" if $game_variables[17] > 50
      when 948   #♀押し付け
        action = premess + "腰を動かし、\n\#{targetname}の顔にアソコを擦りつけた！"
        action = premess + "腰を動かし、\n\#{targetname}の顔にアソコを押し付けた！" if $game_variables[17] > 50
      when 949   #アソコ攻め反撃
        if target.nude?
          action = premess + "手で、\n\#{targetname}のアソコを撫でてきた！"
          action = premess + "指先で、\n\#{targetname}のアソコの入り口を#{brk4}愛撫してきた！" if $game_variables[17] > 50
        else
          action = premess + "#{pantsu}の上から、\n\#{targetname}のアソコを撫でてきた！"
        end
      when 950   #陰核攻め反撃
        if target.nude?
          action = premess + "指先で、\n\#{targetname}の陰核を激しく刺激してきた！"
        else
          action = premess + "#{pantsu}に手を滑り込ませ、\n\#{targetname}の陰核を刺激してきた！"
        end
      when 951   #ペニス攻め反撃
        if target.nude?
          action = premess + "手で、\n\#{targetname}のペニスを撫でてきた！"
          action = premess + "指先で、\n\#{targetname}のペニスを撫でてきた！" if $game_variables[17] > 50
          action += "\n\ぬめりを帯びたペニスに快感が走る！" if target.lub_male >= 60
        else
          action = premess + "#{pantsu}の上から、\n\#{targetname}のペニスを撫でてきた！"
        end
      when 952   #睾丸攻め反撃
        if target.nude?
          action = premess + "手で、\n\#{targetname}の袋を優しくさすってきた！"
          action = premess + "指先で、\n\#{targetname}の袋を優しく撫でてきた！" if $game_variables[17] > 50
        else
          action = premess + "#{pantsu}に手を滑り込ませ、\n\#{targetname}の袋を手でさすってきた！"
        end
      when 953   #♀→♂擦り付け反撃
        action = premess + "アソコを押し付け、\n\#{targetname}のペニスに擦りつけてきた！"
        action += "\n\ぬめりを帯びたペニスに快感が走る！" if target.lub_male >= 60
      when 954   #♀→♀擦り付け反撃
        action = premess + "アソコを押し付け、\n\#{targetname}とアソコに擦りつけてきた！"
=begin
      when 947   #尻尾で奇襲
        action = premess + "尻尾を使い、\n\死角から#{targetname}のアソコを刺激してきた！"
        action = premess + "尻尾を使い、\n\死角から#{targetname}の胸を愛撫してきた！" if $game_variables[17] > 50
      when 948   #触手で奇襲
        action = premess + "触手を使い、\n\死角から#{targetname}のアソコを刺激してきた！"
        action = premess + "触手を使い、\n\死角から#{targetname}の胸を愛撫してきた！" if $game_variables[17] > 50
=end  
  #------------------------------------------------------------------------#
      when 956   #キッスで援護
        action = premess + "#{emotion}\n\#{targetname}の唇を塞ぎ、#{brk4}舌を絡めてきた！"
      when 957   #胸攻めで援護
        action = premess + "#{emotion}\n\#{targetname}の#{target.bustsize}を#{brk4}揉みしだいた！"
      when 958   #尻攻めで援護
        action = premess + "#{emotion}\n\#{targetname}のお尻を#{brk4}揉みしだいた！"
      when 959   #アナル攻めで援護
        action = premess + "#{emotion}\n\#{targetname}の菊座を舌先で突いてきた！"
      when 960   #アソコ攻めで援護
        action = premess + "#{emotion}\n\#{targetname}のアソコを舌で愛撫してきた！"
      when 961   #陰核攻めで援護
        action = premess + "#{emotion}\n\#{targetname}の陰核を舌で舐め上げてきた！"
      when 962   #ペニス攻めで援護
        #逆アナルで犯され状態
        if target.anal_analsex?
          action = premess + "#{emotion}\n\後ろを犯される#{targetname}のペニスを\n舌先で舐め上げてきた！"
          action = premess + "#{emotion}\n\後ろを犯される#{targetname}のペニスを\n手でしごいてきた！" if $game_variables[17] > 50
        #騎乗状態
        else
          action = premess + "#{emotion}\n\身動き取れない#{targetname}のペニスを\n舌先で舐め上げてきた！"
          action = premess + "#{emotion}\n\身動き取れない#{targetname}のペニスを\n手でしごいてきた！"if $game_variables[17] > 50
        end
      when 963   #睾丸攻めで援護
        #逆アナルで犯され状態
        if target.anal_analsex?
          action = premess + "#{emotion}\n\後ろを犯される#{targetname}の睾丸を\n舌先で舐め上げてきた！"
          action = premess + "#{emotion}\n\後ろを犯される#{targetname}の睾丸を\n指で愛撫してきた！" if $game_variables[17] > 50
        #騎乗状態
        else
          action = premess + "#{emotion}\n\身動き取れない#{targetname}の睾丸を\n舌先で舐め上げてきた！"
          action = premess + "#{emotion}\n\身動き取れない#{targetname}の睾丸を\n指で愛撫してきた！"if $game_variables[17] > 50
        end
      when 964   #援護攻撃追撃
        action = premess + "#{tec}、\n\更に#{targetname}を愛撫してきた！"
  #------------------------------------------------------------------------#
      when 967   #味方を攻める
        action = premess + "#{emotion}\n\#{targetname}を優しく愛撫した！"
      when 968   #実況・見学する
        action = premess + "、\n\#{targetname}の様子を興味津々な様子で見つめている……"
        #ホールド援護その他用・性格別形容表現
        case myself.personality
        when "意地悪","高慢","虚勢","勝ち気" #
          #見ている対象がホールド状態の場合
          if target.holding?
            action = premess + "、\n\#{targetname}の様子をにやにやと眺めている……"
          #見ている対象が自分と同様外野の場合
          else
            action = premess + "#{targetname}と視線が合うと、\n\挑発するような不敵な笑みを浮かべた……！"
          end
        when "好色","倒錯" #
          #見ている対象がホールド状態の場合
          if target.holding?
            action = premess + "、\n\#{targetname}の様子をにやにやと眺めている……"
          #見ている対象が自分と同様外野の場合
          else
            action = premess + "#{targetname}と視線が合うと、\n\淫蕩な笑みを浮かべて手招きしてきた……！"
          end
        when "陽気","甘え性","柔和","上品" #
          #見ている対象がホールド状態の場合
          if target.holding?
            action = premess + "、\n\#{targetname}の様子を興味津々な様子で見つめている……"
          #見ている対象が自分と同様外野の場合
          else
            action = premess + "#{targetname}と視線が合うと、\n\何かを期待するかのような笑みを浮かべた……"
          end
        when "内気" #
          #見ている対象がホールド状態の場合
          if target.holding?
            action = premess + "、\n\#{targetname}の様子を熱っぽい瞳で見つめている……"
          #見ている対象が自分と同様外野の場合
          else
            action = premess + "#{targetname}と視線が合うと、\n\恥じ入るように顔を逸らしてしまった……"
          end
        when "従順","淡泊" #
          #見ている対象がホールド状態の場合
          if target.holding?
            action = premess + "、\n\#{targetname}の様子を熱心に観察している……"
          #見ている対象が自分と同様外野の場合
          else
            action = premess + "#{targetname}と視線が合うと、\n\何かを期待するかのような眼差しを向けてきた……"
          end
        when "不思議","天然" #
          #見ている対象がホールド状態の場合
          if target.holding?
            action = premess + "、\n\#{targetname}をきょとんとした表情で見ている……"
          #見ている対象が自分と同様外野の場合
          else
            action = premess + "#{targetname}と視線が合うと、\n\にっこりと微笑んだ……"
          end
        when "独善" #フルビュア専用
          #見ている対象がホールド状態の場合
          if target.holding?
            action = premess + "、\n\#{targetname}の様子を面白そうに観察している……"
          #見ている対象が自分と同様外野の場合
          else
            action = premess + "#{targetname}と視線が合うと、\n\淫蕩な笑みを浮かべて手招きしてきた……！"
          end
        end
        if myself.holding?
          action = premess + "身悶えしている！"
        end
      when 969   #自慰
        #見ている対象がホールド状態の場合
        if target.holding?
          if myself.holding_now? and not (myself.tops_binding? or myself.tentacle_binding?)
            if myself.vagina_insert?
              action = premess + "#{targetname}と繋がりつつ、\n\自らの#{myself.bustsize}を指で慰めている……！"
            elsif myself.mouth_oralsex?
              action = premess + "#{targetname}のペニスを頬張りつつ、\n\自らのアソコに指を這わせて慰めている……！"
            elsif myself.vagina_riding?
              action = premess + "#{targetname}の顔に跨りつつ、\n\自らの#{myself.bustsize}を指で慰めている……！"
            elsif myself.shellmatch?
              action = premess + "#{targetname}と下半身を絡めあいつつ、\n\自らの#{myself.bustsize}を指で慰めている……！"
            else
              action = premess + "#{targetname}の痴態を眺めつつ、\n\自らの身体を慰めている……！"
            end
          elsif myself.tops_binding? or myself.tentacle_binding?
            action = premess + "#{targetname}の痴態を眺めつつ、\n\拘束された自らの状態に身悶えしている……！"
          else
            action = premess + "#{targetname}の痴態を眺めつつ、\n\自らの身体を慰めている……！"
          end
        #見ている対象が自分と同様外野の場合
        else
          action = premess + "自らの身体を慰めている……！"
        end
  #------------------------------------------------------------------------#        
      when 970   #小休止(ホールド中のＶＰ切れ対応)
        sp_plus = [(myself.maxsp / 8).ceil, 50].min
        #ターゲット指定(エンブレイス中のターゲットを優先)
        if myself.hold.tops.battler != nil and myself.hold.tops.parts != "触手"
          hold_action = "#{myself.hold.tops.battler.name}に身体を預け"
        else
          #性器＞尻＞口の順に優先度が決まる
          if myself.hold.penis.battler != nil
            hold_action = "#{myself.hold.penis.battler.name}に身体を預け"
          elsif myself.hold.vagina.battler != nil
            hold_action = "#{myself.hold.vagina.battler.name}に身体を委ね"
          elsif myself.hold.anal.battler != nil
            hold_action = "#{myself.hold.anal.battler.name}に身体を委ね"
          elsif myself.hold.dildo.battler != nil
            hold_action = "#{myself.hold.dildo.battler.name}に身体を委ね"
          elsif myself.hold.mouth.battler != nil
            hold_action = "#{myself.hold.mouth.battler.name}に身体を委ね"
          else
            hold_action = "身体の力を抜き"
          end
        end
        #口がふさがっている場合
        if myself.hold.mouth.battler != nil
          action = premess + "#{hold_action}、\n\何とか呼吸を落ち着けようとしている……！"
        else
          action = premess + "#{hold_action}、\n\呼吸を落ち着けようとしている……！"
        end
        myself.sp += sp_plus
      when 971   #もがく
        action = premess + " twists about, \n\ trying to change posture!"
      when 981   #暴走愛撫
        if target.nude?
          action = premess + "情動に身を任せ、\n#{targetname}の身体を思うままに貪った！"
          action = premess + "情動に身を任せ、\n#{targetname}の胸を思うままに貪った！" if $msg.at_parts == "対象：胸"
          action = premess + "情動に身を任せ、\n#{targetname}の顔を荒々しく引き寄せ、\n唇を有無を言わせず貪った！" if $msg.at_parts == "対象：口"
          action = premess + "情動に身を任せ、\n#{targetname}のお尻を荒々しく揉みしだいた！" if $msg.at_parts == "対象：尻"
          action = premess + "情動に身を任せ、\n#{targetname}のアソコを思うままに貪った！" if $msg.at_parts == "対象：アソコ"
          action = premess + "情動に身を任せ、\n#{targetname}のペニスを有無を言わせず貪った！" if $msg.at_parts == "対象：ペニス"
        else
          action = premess + "情動に身を任せ、\n#{targetname}の身体を思うままに貪った！"
          action = premess + "情動に身を任せ、\n#{targetname}の服を勢いよくはだけさせると、\nその胸を思うままに貪った！" if $msg.at_parts == "対象：胸"
          action = premess + "情動に身を任せ、\n#{targetname}の顔を荒々しく引き寄せ、\nその唇を有無を言わせず貪った！" if $msg.at_parts == "対象：口"
          action = premess + "情動に身を任せ、\n服など意に介さないとばかりに、\n#{targetname}のお尻を荒々しく揉みしだいた！" if $msg.at_parts == "対象：尻"
          action = premess + "情動に身を任せ、\n服など意に介さないとばかりに、\n#{targetname}のアソコを思うままに貪った！" if $msg.at_parts == "対象：アソコ"
          action = premess + "情動に身を任せ、\n服など意に介さないとばかりに、\n#{targetname}のペニスを有無を言わせず貪った！" if $msg.at_parts == "対象：ペニス"
        end
        action = premess + "#{targetname}のアソコを、\n音を立てて強く吸い上げた！"if myself.mouth_riding?
        action = premess + "#{targetname}の菊座を、\n荒々しく舌で舐め回した！"if myself.mouth_hipriding?
      when 982   #暴走愛撫・追撃
        action = premess + "なおも激しく、\n獣のように#{targetname}の身体を貪っている！"
      when 983   #暴走ピストン
        #インサート、ディルド系、オーラル系、クンニ系
        action = premess + "#{targetname}を組み伏せ、\n獣のように荒々しく腰を打ち付けた！" if myself.penis_insert?
        action = premess + "#{targetname}を組み伏せ、\n意地悪げな笑みを浮かべて腰を打ち付けた！" if myself.dildo_insert?
        action = premess + "#{targetname}の頭を掴み、\n何度も喉の奥まで張型をねじ入れた！" if myself.dildo_oralsex?
        action = premess + "#{targetname}の腰を掴み、\n嗜虐的な笑みを浮かべ何度も腰を打ちつけた！" if myself.dildo_analsex?
        action = premess + "#{targetname}の頭を掴み、\n喉の奥までペニスを荒々しくねじ込んだ！" if myself.penis_oralsex?
        action = premess + "#{targetname}を組み伏せ、\n卑猥な音を立てて激しくペニスを吸い上げた！" if myself.mouth_oralsex?
        action = "興奮した#{myname}が操る触手が、\n#{targetname}のアソコに吸い付き、\n　卑猥な音を立てて激しく吸い上げてきた！" if myself.tentacle_draw?
        action = "興奮した#{myname}が操る触手が、\n#{targetname}のペニスに吸い付き、\n　卑猥な音を立てて激しく吸い上げてきた！" if myself.tentacle_absorbing?
      when 984   #暴走ピストン・追撃
        action = premess + "なおも激しく、\n#{targetname}を犯している！"
        action = "#{myname}の触手は、\nなおも激しく#{targetname}を犯している！" if myself.tentacle_draw? or myself.tentacle_absorbing?
      when 985   #暴走グラインド
        #アクセプト、シェルマッチ、ペリスコープ、エキサイトビュー
        action = premess + "#{targetname}を組み伏せ、\n獣のように荒々しく腰をくねらせた！"
        action = premess + "#{targetname}を組み伏せ、\n#{myself.bustsize}でペニスを弄んでいる！" if myself.tops_paizuri?
      when 986   #暴走グラインド・追撃
        action = premess + "なおも激しく、\n#{targetname}を犯している！"
      when 987   #暴走愛撫(VP切れ)
        action = premess + "息を切らせつつも、\n衝動に任せて#{targetname}を愛撫した！\nしかし、思うように身体が動かせない！"
      when 988   #暴走愛撫(空振り)
        action = premess + "#{targetname}を愛撫した！\nしかし、興奮のあまり手元が定まらない！\\n#{targetname}は快感を受けていない！"
        action = premess + "#{targetname}を愛撫した！\nしかし、興奮のあまり身体がうまく動かない！\\n#{targetname}は快感を受けていない！" if myself.hold.tops.battler != nil
  #------------------------------------------------------------------------#
      end
      #●相手の濡れ度で補正テキスト修正(スキル威力があるもの限定)
      if skill.element_set.include?(97) and skill.power != 0 and target.girl?
        case target.lub_female
        when 81..255
          action += "\n\刺激を受けるたびに、アソコから愛蜜の水飛沫が上がる…！" if target.nude?
          action += "\n\#{targetname}の#{pantsu}から愛蜜が滴り落ちる…！" unless target.nude?
        when 61..80
          action += "\n\アソコの淫らな水音がより大きくなってきた…！" if target.nude?
          action += "\n\#{targetname}の#{pantsu}は愛蜜で濡れている…！" unless target.nude?
        when 41..60
          action += "\n\#{targetname}の内股を愛蜜がつぅっと流れる…！" if target.nude?
          action += "\n\#{targetname}の#{pantsu}の染みが濃くなってきた…！" unless target.nude?
        when 25..40
          action += "\n\アソコから淫らな水音が漏れ聞こえてくる…！" if target.nude?
          action += "\n\#{targetname}の#{pantsu}に染みが浮き出てきた…！" unless target.nude?
        end
      end
      # メッセージ出力
      case type
      when "action"
        #スライム系は服＝粘液に置き換える(暫定)
        if $data_SDB[target.class_id].name == "Sliｍe"
          action.gsub!("服","粘液") 
        end
        text = action
      when "avoid"
        text = avoid
      end
      
      
      
      return text
    end
  end
end

