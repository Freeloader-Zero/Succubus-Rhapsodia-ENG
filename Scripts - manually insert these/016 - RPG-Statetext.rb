#==============================================================================
# ■ RPG::Sprite
#------------------------------------------------------------------------------
# 　ステート個別メッセージ格納
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
      when 1 # 戦闘不能
        effect = recover = report =  ""
      when 2 # 衰弱
        effect = "" #{myname}は絶頂に達した！"
        recover = "#{myname} ｍustered the ｗillpoｗer to stand back up!"
        report = "#{myname} can't ｍuster any strength\m\n due to the lingering affects of cliｍax!"
      when 3 # 絶頂
        effect = "" #{myname}は絶頂に達した！"
        recover = "#{myname}'s orgasｍ has settled!"
        report = "#{myname} can't ｍuster any strength\m\n due to the lingering affects of cliｍax!"
      when 6 # クライシス
        effect = "#{myname} nearly caｍe!"
        recover = "#{myname} regained coｍposure!"
        report = "#{myname} nearly caｍe!"
      when 5 # 裸
        if user.is_a?(Game_Actor)
          if myself.is_a?(Game_Actor)
            effect = "#{myname} becaｍe naked!"
            effect = "#{myname} ｗas stripped naked!" if $msg.tag == "仲間脱衣"
          else
            effect = "#{myname} has been stripped naked!"
            effect = "#{myname} becaｍe naked!" if $msg.tag == "夢魔脱衣"
          end
        elsif user.is_a?(Game_Enemy)
          if myself.is_a?(Game_Actor)
            effect = "#{myname} ｗas stripped naked!"
            effect = "#{myname} becaｍe naked as told!" if $game_switches[89] == true
          else
            effect = "#{myname} becaｍe naked!"
          end
        end
      when 8 # 挿入
        if user.is_a?(Game_Actor)
          effect = "#{username} inserted #{myname}!"
        elsif user.is_a?(Game_Enemy)
          effect = "#{myname} violated #{username}!"
        end
      when 13 # ディレイ
        effect = "#{myname} yelps in surprise!\n\m #{myname}'s ｍoveｍents have dulled!"
        recover = ""
      when 17 # 苦痛スタン
        if $game_temp.used_skill != nil
          if user.is_a?(Game_Actor)
            if $game_temp.used_skill.element_set.include?(10) #口淫系
              if myself == $game_actors[101]
              effect = "#{myname} flinched froｍ the\n\m attack to his ｍouth!"
              else
              effect = "#{myname} flinched froｍ the\n\m attack to her ｍouth!"
              end
            elsif $game_temp.used_skill.element_set.include?(11) #肛姦系
              if myself == $game_actors[101]
              effect = "#{myname} ｗas stunned by the\n\m attack to his ass!"
              else
              effect = "#{myname} ｗas stunned by the\n\m attack to her ass!"
              end
            else #苦痛系
              effect = "#{myname} flinched painfully!"
            end
          else
            if $game_temp.used_skill.element_set.include?(10) #口淫系
              effect = "#{myname} sｗoons froｍ being\n\m attacked in the ｍouth!"
            elsif $game_temp.used_skill.element_set.include?(11) #肛姦系
              effect = "#{myname} cries out froｍ\n\m being attacked in the back!"
            else #苦痛系
              effect = "#{myname} keels froｍ the pain!"
            end
          end
        else
          if user.is_a?(Game_Actor)
            effect = "#{myname} flinched painfully!"
          else
            effect = "#{myname} keels froｍ the pain!"
          end
        end
        recover = ""
      when 14 # 秘所潤滑度↑
        #処理はGame_Battler4のスキルエフェクトで設定
        effect = recover = report =  ""
      when 19 # 両性具有化
        effect = "#{myname}'s clit begins to enlarge...!\n\m A penis appeared betｗeen #{myname}'s crotch!"
        recover = "#{myname}'s penis sloｗly disappeared!"
      when 20 # 潤滑♂(弱)
        effect = "#{myname}'s penis is ｗell-lubricated!"
        recover = ""
      when 21 # 潤滑♂(強)
        effect = "#{myname}'s penis is extreｍely lubricated!"
        recover = ""
      when 22 # 潤滑♀(少)
        effect = "#{myname}'s pussy has gotten ｗet!"
        effect = "#{myname}'s pussy is sliｍy ｗith goo!" if myself.states.include?(27) or myself.states.include?(28)
#        effect = "#{myname}のアソコから、\n\m徐々に蜜が染み出てきた…！"
#        effect = "#{myname}のアソコが、\n\m付着した粘液のせいでぬるぬるしてきた…！" if myself.states.include?(27) or myself.states.include?(28)
        recover = ""
      when 23 # 潤滑♀(多)
        effect = "#{myname}'s pussy is sufficiently ｗet!"
        effect = "#{myname}'s pussy is sliｍy ｗith goo!" if myself.states.include?(27) or myself.states.include?(28)
#        effect = "#{myname}のアソコから、\n\mとろりと蜜が滴り落ちて来た…！"
#        effect = "#{myname}のアソコは、\n\m粘液と本人の蜜とで十二分に濡れてきた…！" if myself.states.include?(27) or myself.states.include?(28)
        recover = ""
      when 24 # 潤滑♀(溢)
        effect = "#{myname}'s pussy is overfloｗing ｗith\n\m vaginal secretions!"
        effect = "#{myname}'s pussy is sliｍy ｗith goo!" if myself.states.include?(27) or myself.states.include?(28)
#        effect = "#{myname}のアソコから、\n\m蜜が止めどなく溢れ出して来る…！"
#        effect = "#{myname}のアソコは、\n\m粘液と本人の蜜とで既にぐしょぐしょだ…！" if myself.states.include?(27) or myself.states.include?(28)
        recover = ""
      #アナル系ステートは体験版では未搭載なので、誤作動防止のためテキスト封印
      when 25 # 潤滑Ａ(弱)
        effect = "" #"#{myname}の菊門が滑りを帯びてきた…！"
        recover = ""
      when 26 # 潤滑Ａ(強)
        effect = "" #"#{myname}の菊門は十二分に滑りを帯びた！"
        recover = ""
      when 27 # 粘液潤滑(少)
        effect = recover = ""
      when 28 # 粘液潤滑(多)
        effect = recover = ""
      when 29 # スライム
        effect = recover = ""
      when 30 # 淫毒
        effect = "#{myname} ｗas poisoned ｗith aphrodisiacs!"
        report = "#{myname} is poisoned ｗith aphrodisiacs!"
        recover = "The poison fang fell out of #{myname}...\w\n" +
                  "Soon after, #{myname}'s body\n\m started to feel hot and flushed!"
        if type == "recover"
          myself.add_state(35)
          myself.add_states_log.clear
        end
      when 32 # スタン：ドキドキ
        effect = "#{myname}'s chest is thruｍping!"
        effect = "#{myname}'s chest is pounding...!" if $msg.tag == "奉仕" or $msg.tag == "視姦"
        recover = ""
      when 33 # スタン：びっくり
        effect = "#{myname} is lost in surprise!"
        recover = ""
      when 34 # 恍惚
        effect = "#{myname} got lost in ecstasy!"
        recover = "#{myname} regained sanity!"
        if myself == $game_actors[101]
          report = "#{myname} ｗears an expression\n\m of supreｍe bliss on his face!"
        else
          report = "#{myname} ｗears an expression\n\m of supreｍe bliss on her face!"
        end
        # 視覚に働きかけるスキルの場合、メッセージを変化
#        if skill != nil and skill != ""
#          if skill.element_set.include?(21)
#            effect = "#{myname}の視線は#{username}に釘付けになった！\w\n" + 
#                     "#{myname}は心を奪われた！"
#          end
#        end
      when 35 # 欲情
        if user.is_a?(Game_Actor)
          effect = "#{myname} has been ｍade horny!"
          effect = "#{myname} has becoｍe horny!" if $msg.tag == "奉仕"
        elsif user.is_a?(Game_Enemy)
          effect = "#{myname} has becoｍe horny!"
        end
        recover = "#{myname} is no longer horny!"
        report = "#{myname} is horny!"
      when 36 # 暴走
        if user.is_a?(Game_Actor)
          effect = "#{myname} has gone berserk!"
          effect = "#{myname} has goes berserk!" if $msg.tag == "奉仕"
        elsif user.is_a?(Game_Enemy)
          effect = "#{myname} ｗent berserk!"
        end
        recover = "#{myname} has calｍed doｗn!"
        if myself == $game_actors[101]
          report = "#{myname} can't control hiｍself!"
        else
          report = "#{myname} can't control herself!"
        end
      when 37 # 虚脱
        if user.is_a?(Game_Actor)
          effect = "#{myname}'s body started feeling ｗeak!"
          effect = "#{myname}'s strength feels like\n\m it's being drained aｗay...!" if $msg.tag == "奉仕"
          effect = "#{myname}'s strength feels like\n\m it's being drained aｗay...!" if myself.is_a?(Game_Actor)
          effect = "#{myname}'s strength is crushed\n\m by the pressure!" if $game_temp.used_skill.name == "懺悔なさい"
        elsif user.is_a?(Game_Enemy)
          effect = "#{myname}'s body becaｍe ｗeak!"
          effect = "#{myname}'s body is ｗeak froｍ aphrodisiacs!" if myself.state?(30)
          effect = "#{myname}'s strength is crushed\n\m by the pressure!" if $game_temp.used_skill.name == "懺悔なさい"
        end
        recover = "#{myname}'s strength has returned!"
        report = "#{myname} can't gather any strength!"
      when 38 # 畏怖
        if user.is_a?(Game_Actor)
          effect = "#{myname} feels overpoｗered by the eneｍy!"
          effect = "#{myname} is feeling overｗhelmed!" if $msg.tag == "奉仕"
        elsif user.is_a?(Game_Enemy)
          effect = "#{myname} is feeling overｗhelｍed!"
        end
        recover = "#{myname} no longer feels overｗhelｍed!"
        report = "#{myname} is aｗed by the eneｍy!"
      when 39 # 麻痺
        if user.is_a?(Game_Actor)
          effect = "#{myname} has been paralyzed!"
          effect = "#{myname}'s body has sloｗly becoｍe nuｍb!" if myself.is_a?(Game_Actor)
        elsif user.is_a?(Game_Enemy)
          effect = "#{myname}'s body has been paralyzed!"
          effect = "#{myname}'s\m\n body has been paralyzed by the poison!" if myself.state?(30)
        end
        recover = "#{myname}'s body\m\n has recovered froｍ paralysis!"
        report = "#{myname}'s body is nuｍb...!"
      when 40 # 散漫
        if user.is_a?(Game_Actor)
          effect = "#{myname} seeｍs lost in pleasure!"
          effect = "#{myname} feels a little light-headed...!" if myself.is_a?(Game_Actor)
          effect = "#{myname} feels light-headed...!" if $msg.tag == "奉仕"
        elsif user.is_a?(Game_Enemy)
          effect = "#{myname} seeｍs to be lost in pleasure!"
          effect = "#{myname} looks a little light-headed!" if $msg.tag == "奉仕"
          effect = "#{myname} can't concentrate\n\m because of the aphrodisiac's effects!" if myself.state?(30)
        end
        recover = "#{myname} is no longer lost in pleasure!"
        report = "#{myname} can't focus!"
      when 41 # 高揚
        effect = "#{myname} becaｍe excited!"
        recover = "#{myname}'s exciteｍent has ｗorn off!"
        report = ""
      when 42 # 沈着
        effect = "#{myname} has becoｍe coｍposed!"
        recover = "#{myname} returned to norｍal!"
        report = ""
      when 45 # 全身感度アップ
        effect = "#{myname} becaｍe sensitive!"
        effect = "#{myname}'s body becaｍe sensitive\n\m froｍ the aphrodisiac!" if myself.state?(30)
        recover = ""
      when 46 # 口感度アップ
        effect = "#{myname}'s lips becaｍe sensitive!"
        recover = ""
      when 47 # 胸感度アップ
        effect = "#{myname}'s chest becaｍe sensitive!"
        recover = ""
      when 48 # 尻感度アップ
        effect = "#{myname}'s ass becaｍe sensitive!"
        recover = ""
      when 49 # ♂感度アップ
        effect = "#{myname}'s penis becaｍe sensitive!"
        recover = ""
      when 50 # ♀感度アップ
        effect = "#{myname}'s pussy becaｍe sensitive!"
        recover = ""

      when 80 # ステート増加
        effect = "#{myname}'s stats has increased!" if myself.is_a?(Game_Actor)
        effect = "#{myname}'s stats has increased!" if myself.is_a?(Game_Enemy)
        case $msg.tag
        when "魅力", "魅力＋"
          effect.gsub!("能力","魅力") 
        when "忍耐力", "忍耐力＋"
          effect.gsub!("能力","忍耐力") 
        when "精力", "精力＋"
          effect.gsub!("能力","精力") 
        when "器用さ", "器用さ＋"
          effect.gsub!("能力","器用さ") 
        when "素早さ", "素早さ＋"
          effect.gsub!("能力","素早さ") 
        when "精神力", "精神力＋"
          effect.gsub!("能力","精神力") 
        end
        if $msg.tag[/＋/] != nil
          effect.gsub!("強化","更に強化") 
        end
        myself.remove_state(80)
        recover = ""
      when 81 # ステート減少
        effect = "#{myname}'s stats have decreased!" if myself.is_a?(Game_Enemy)
        effect = "#{myname}'s stats have decreased!" if myself.is_a?(Game_Actor)
        case $msg.tag
        when "魅力", "魅力－"
          effect.gsub!("能力","魅力") 
        when "忍耐力", "忍耐力－"
          effect.gsub!("能力","忍耐力") 
        when "精力", "精力－"
          effect.gsub!("能力","精力") 
        when "器用さ", "精力－"
          effect.gsub!("能力","器用さ") 
        when "素早さ", "素早さ－"
          effect.gsub!("能力","素早さ") 
        when "精神力", "精神力－"
          effect.gsub!("能力","精神力") 
        end
        if $msg.tag[/－/] != nil
          effect.gsub!("弱体化","更に弱体化") 
        end
        myself.remove_state(81)
        recover = ""
      when 82 # ステート全増加
        effect = "#{myname}の全能力を強化した！" if myself.is_a?(Game_Actor)
        effect = "#{myname}の全能力が強化された！" if myself.is_a?(Game_Enemy)
        myself.remove_state(82)
        recover = ""
      when 83 # ステート全減少
        effect = "#{myname}の全能力を弱体化させた！" if myself.is_a?(Game_Enemy)
        effect = "#{myname}は全能力を弱体化させられた！" if myself.is_a?(Game_Actor)
        myself.remove_state(83)
        recover = ""
      when 84 # ステート維持
        effect = "しかし#{myname}には効果が無かった！"
        myself.remove_state(84)
        recover = ""
      when 85 # 強化解除
        effect = "One of #{myname}'s buffs has ｗorn off!" if myself.is_a?(Game_Enemy)
        effect = "One of #{myname}'s buffs has ｗorn off!" if myself.is_a?(Game_Actor)
        myself.remove_state(85)
        recover = ""
      when 86 # 低下解除
        effect = "#{myname} has been cured of a status ailment!" if myself.is_a?(Game_Actor)
        effect = "#{myname} has been cured of a status ailment!" if myself.is_a?(Game_Enemy)
        myself.remove_state(86)
        recover = ""
      when 87 # 全解除
        effect = "#{myname}'s strength has been restored!" if myself.is_a?(Game_Enemy)
        effect = "#{myname}'s strength has been restored!" if myself.is_a?(Game_Actor)
        myself.remove_state(87)
        recover = ""
      when 93,94 # 防御中、大防御中
        effect = "#{myname} focuses on resisting pleasure!"
        recover = ""
      when 95 # お任せ中
        effect = "#{myname} surrenders to the eneｍy!"
        report = "#{myname} has surrendered to the eneｍy!"
        recover = ""
      when 96 # 誘引
=begin
　　    s_range = myself.is_a?(Game_Enemy) ? $game_troop.enemies : $game_party.battle_actors
        for i in s_range
          if i.exist?
            n += 1
          end
        end
        s_range_text = n > 1 ? "たち" : ""
        effect += "夢魔#{s_range_text}の興味が#{myname}に移った！" if myself.is_a?(Game_Actor)
        effect += "#{master}#{s_range_text}は#{myname}に\n目を引きつけられてしまった！" if myself.is_a?(Game_Enemy)
=end
      when 97 # キススイッチ起動
        effect = "#{myname}はキスをされてスイッチが入った！"
        recover = ""
      when 98 # 魔法陣
        effect = "#{myname}の唱える魔法の消費が無くなった！"
        recover = "#{myname}の足元の魔法陣が消滅した！"
      when 99 # マーキング
        effect = "#{myself.marking_battler.name}は#{myname}に\n"+
                 "目を付けられてしまった！"
        recover = "#{myname}の#{myself.marking_battler.name}への\m\n"+
                  "興味が落ち着いた！"
      when 101 # 祝福
        effect = "#{myname}は状態異常に強くなった！"
        recover = "#{myname}の祝福が無くなった！"
      when 102 # 焦燥
        effect = "#{myname}の緊張が高まってきた！"
        recover = "#{myname}の緊張が解けた！"
        report = ""
      when 103 # 専心
        effect = "#{myname}の精神が研ぎ澄まされた！"
        recover = "#{myname}の集中が切れた！"
        report = ""
      when 104 # 挑発
        recover = "#{myname} is no longer being provocative!"
        report = "#{myname} is ｍaking provacative gestures!!"
=begin
        # ↓なぜかここで落ちる
　　    s_range = $game_troop.enemies if myself.is_a?(Game_Enemy)
        s_range = $game_party.battle_actors if myself.is_a?(Game_Actor)
        for i in s_range
          if i.exist?
            n += 1
          end
        end
        s_range_text = n > 1 ? "たち" : ""
        effect += "#{myname}は夢魔#{s_range_text}から目をつけられた！" if myself.is_a?(Game_Actor)
        effect += "#{master}#{s_range_text}は#{myname}に\n気を引きつけられてしまった！" if myself.is_a?(Game_Enemy)
=end
      when 105 # 拘束
        if user.is_a?(Game_Actor)
          effect = "#{myname} has been restrained!"
        elsif user.is_a?(Game_Enemy)
          effect = "#{myname} ｗas restrained!"
        end
        recover = "#{myname} has been freed!"
        report = "#{myname}'s body is restrained!"
      when 106 # 破面
        effect = "#{myname}の本性が暴かれてしまった！"
        report = "#{myname}は本性を取り繕うことができない！"
        recover = "#{myname}は理性を取り戻した！"
      end
      # メッセージ出力
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