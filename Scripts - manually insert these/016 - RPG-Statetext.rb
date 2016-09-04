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
        recover = "#{myname}は気力を振り絞り立ち上がった！"
        report = "#{myname}は射精の余韻で力が入らない！"
      when 3 # 絶頂
        effect = "" #{myname}は絶頂に達した！"
        recover = "#{myname}の身体の興奮が治まった！"
        report = "#{myname}は絶頂の余韻で力が入らない！"
      when 6 # クライシス
        effect = "#{myname}はいきそうになってきた…！"
        recover = "#{myname}は落ち着きを取り戻した！"
        report = "#{myname}はいきそうになっている！"
      when 5 # 裸
        if user.is_a?(Game_Actor)
          if myself.is_a?(Game_Actor)
            effect = "#{myname}は裸になった！"
            effect = "#{myname}を裸にした！" if $msg.tag == "仲間脱衣"
          else
            effect = "#{myname}を裸にした！"
            effect = "#{myname}は裸になった！" if $msg.tag == "夢魔脱衣"
          end
        elsif user.is_a?(Game_Enemy)
          if myself.is_a?(Game_Actor)
            effect = "#{myname}は裸にされた！"
            effect = "#{myname}は言われるままに裸になった！" if $game_switches[89] == true
          else
            effect = "#{myname}は裸になった！"
          end
        end
      when 8 # 挿入
        if user.is_a?(Game_Actor)
          effect = "#{username}は#{myname}に挿入した！"
        elsif user.is_a?(Game_Enemy)
          effect = "#{myname}は#{username}に犯された！"
        end
      when 13 # ディレイ
        effect = "#{myname}は驚いて動きが鈍った！"
        recover = ""
      when 17 # 苦痛スタン
        if $game_temp.used_skill != nil
          if user.is_a?(Game_Actor)
            if $game_temp.used_skill.element_set.include?(10) #口淫系
              effect = "#{myname}は口内を攻められ受身になっている！"
            elsif $game_temp.used_skill.element_set.include?(11) #肛姦系
              effect = "#{myname}は菊座を攻められ受身になっている！"
            else #苦痛系
              effect = "#{myname}は痛みで受身になっている！"
            end
          else
            if $game_temp.used_skill.element_set.include?(10) #口淫系
              effect = "#{myname}は口内を攻められ気を散らされた！"
            elsif $game_temp.used_skill.element_set.include?(11) #肛姦系
              effect = "#{myname}は菊座を攻められ力が抜けてしまった！"
            else #苦痛系
              effect = "#{myname}は痛みで気を散らされた！"
            end
          end
        else
          if user.is_a?(Game_Actor)
            effect = "#{myname}は痛みで受身になっている！"
          else
            effect = "#{myname}は痛みで気を散らされた！"
          end
        end
        recover = ""
      when 14 # 秘所潤滑度↑
        #処理はGame_Battler3のスキルエフェクトで設定
        effect = recover = report =  ""
      when 19 # 両性具有化
        effect = "#{myname}の陰核が肥大化を始める……！\n\m#{myname}の股間にペニスが出現した！"
        recover = "#{myname}のペニスは消え去った！"
      when 20 # 潤滑♂(弱)
        effect = "#{myname}のペニスが滑りを帯びてきた！"
        recover = ""
      when 21 # 潤滑♂(強)
        effect = "#{myname}のペニスは十二分に滑りを帯びた！"
        recover = ""
      when 22 # 潤滑♀(少)
        effect = "#{myname}のアソコが濡れてきた！"
        effect = "#{myname}のアソコは粘液でぬめっている！" if myself.states.include?(27) or myself.states.include?(28)
#        effect = "#{myname}のアソコから、\n\m徐々に蜜が染み出てきた…！"
#        effect = "#{myname}のアソコが、\n\m付着した粘液のせいでぬるぬるしてきた…！" if myself.states.include?(27) or myself.states.include?(28)
        recover = ""
      when 23 # 潤滑♀(多)
        effect = "#{myname}のアソコが十分に濡れてきた！"
        effect = "#{myname}のアソコは粘液で十分にぬめっている！" if myself.states.include?(27) or myself.states.include?(28)
#        effect = "#{myname}のアソコから、\n\mとろりと蜜が滴り落ちて来た…！"
#        effect = "#{myname}のアソコは、\n\m粘液と本人の蜜とで十二分に濡れてきた…！" if myself.states.include?(27) or myself.states.include?(28)
        recover = ""
      when 24 # 潤滑♀(溢)
        effect = "#{myname}のアソコから愛液が溢れ出ている！"
        effect = "#{myname}のアソコは粘液で十分にぬめっている！" if myself.states.include?(27) or myself.states.include?(28)
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
        effect = "#{myname}は淫毒に冒されてしまった！"
        report = "#{myname}は淫毒に冒されている！"
        recover = "#{myname}を蝕む淫毒が抜けていく……\w\n" +
                  "直後、#{myname}の身体が異様に火照り始めた！"
        if type == "recover"
          myself.add_state(35)
          myself.add_states_log.clear
        end
      when 32 # スタン：ドキドキ
        effect = "#{myname}は思わずドキっとした！"
        effect = "#{myname}はドキドキしてきた……！" if $msg.tag == "奉仕" or $msg.tag == "視姦"
        recover = ""
      when 33 # スタン：びっくり
        effect = "#{myname}は驚いて気が散ってしまった！"
        recover = ""
      when 34 # 恍惚
        effect = "#{myname}は心を奪われた！"
        recover = "#{myname}は正気を取り戻した！"
        report = "#{myname}は至福の表情を浮かべている…！"
        # 視覚に働きかけるスキルの場合、メッセージを変化
#        if skill != nil and skill != ""
#          if skill.element_set.include?(21)
#            effect = "#{myname}の視線は#{username}に釘付けになった！\w\n" + 
#                     "#{myname}は心を奪われた！"
#          end
#        end
      when 35 # 欲情
        if user.is_a?(Game_Actor)
          effect = "#{myname}を欲情させた！"
          effect = "#{myname}は欲情してしまった！" if $msg.tag == "奉仕"
        elsif user.is_a?(Game_Enemy)
          effect = "#{myname}は欲情してしまった！"
        end
        recover = "#{myname}は我を取り戻した！"
        report = "#{myname}は欲情している！"
      when 36 # 暴走
        if user.is_a?(Game_Actor)
          effect = "#{myname}の我を忘れさせた！"
          effect = "#{myname}は我を忘れてしまった！" if $msg.tag == "奉仕"
        elsif user.is_a?(Game_Enemy)
          effect = "#{myname}は我を忘れてしまった！"
        end
        recover = "#{myname}は我に返った！"
        report = "#{myname}は性欲を押さえきれない！"
      when 37 # 虚脱
        if user.is_a?(Game_Actor)
          effect = "#{myname}の身体の力を失わせた！"
          effect = "#{myname}の身体から力が抜けていく……！" if $msg.tag == "奉仕"
          effect = "#{myname}の身体から力が抜けていく……！" if myself.is_a?(Game_Actor)
          effect = "#{myname}は気圧されて力が入らなくなった！" if $game_temp.used_skill.name == "懺悔なさい"
        elsif user.is_a?(Game_Enemy)
          effect = "#{myname}の身体から力が抜けてしまった！"
          effect = "淫毒で#{myname}の身体から力が抜けていく！" if myself.state?(30)
          effect = "#{myname}は気圧されて力が入らなくなった！" if $game_temp.used_skill.name == "懺悔なさい"
        end
        recover = "#{myname}に力が戻ってきた！"
        report = "#{myname}は身体に力が入らない！"
      when 38 # 畏怖
        if user.is_a?(Game_Actor)
          effect = "#{myname}に威圧感を与えた！"
          effect = "#{myname}は消極的になってしまった！" if $msg.tag == "奉仕"
        elsif user.is_a?(Game_Enemy)
          effect = "#{myname}は消極的になってしまった！"
        end
        recover = "#{myname}は気を持ち直した！"
        report = "#{myname}は消極的になっている！"
      when 39 # 麻痺
        if user.is_a?(Game_Actor)
          effect = "#{myname}を麻痺させた！"
          effect = "#{myname}の身体がだんだん痺れてきた……！" if myself.is_a?(Game_Actor)
        elsif user.is_a?(Game_Enemy)
          effect = "#{myname}は身体が麻痺してしまった！"
          effect = "淫毒で#{myname}の身体が痺れてきた！" if myself.state?(30)
        end
        recover = "#{myname}の身体の麻痺が解けた！"
        report = "#{myname}は身体が痺れている……！"
      when 40 # 散漫
        if user.is_a?(Game_Actor)
          effect = "#{myname}の意識を乱した！"
          effect = "#{myname}の意識が朦朧としてきた……！" if myself.is_a?(Game_Actor)
          effect = "#{myname}の意識が朦朧としてきた……！" if $msg.tag == "奉仕"
        elsif user.is_a?(Game_Enemy)
          effect = "#{myname}は気を散らされてしまった！"
          effect = "#{myname}の意識が朦朧としてきた……！" if $msg.tag == "奉仕"
          effect = "淫毒で#{myname}は意識を集中できなくなった！" if myself.state?(30)
        end
        recover = "#{myname}は雑念を追い払った！"
        report = "#{myname}は意識が集中できない！"
      when 41 # 高揚
        effect = "#{myname}は気分が高揚してきた！"
        recover = "#{myname}の興奮が収まった！"
        report = ""
      when 42 # 沈着
        effect = "#{myname}は気分が落ち着いてきた！"
        recover = "#{myname}の気分が元に戻った！"
        report = ""
      when 45 # 全身感度アップ
        effect = "#{myname}は快感に敏感になった！"
        effect = "#{myname}の身体が淫毒で敏感になった！" if myself.state?(30)
        recover = ""
      when 46 # 口感度アップ
        effect = "#{myname}は口への快感に敏感になった！"
        recover = ""
      when 47 # 胸感度アップ
        effect = "#{myname}は胸への快感に敏感になった！"
        recover = ""
      when 48 # 尻感度アップ
        effect = "#{myname}はお尻への快感に敏感になった！"
        recover = ""
      when 49 # ♂感度アップ
        effect = "#{myname}はペニスへの快感に敏感になった！"
        recover = ""
      when 50 # ♀感度アップ
        effect = "#{myname}はアソコへの快感に敏感になった！"
        recover = ""

      when 80 # ステート増加
        effect = "#{myname}の能力を強化した！" if myself.is_a?(Game_Actor)
        effect = "#{myname}の能力が強化された！" if myself.is_a?(Game_Enemy)
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
        effect = "#{myname}の能力を弱体化させた！" if myself.is_a?(Game_Enemy)
        effect = "#{myname}は能力を弱体化させられた！" if myself.is_a?(Game_Actor)
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
        effect = "#{myname}の能力強化を解除した！" if myself.is_a?(Game_Enemy)
        effect = "#{myname}の能力強化が解除された！" if myself.is_a?(Game_Actor)
        myself.remove_state(85)
        recover = ""
      when 86 # 低下解除
        effect = "#{myname}の能力弱体化を解除した！" if myself.is_a?(Game_Actor)
        effect = "#{myname}の能力弱体化が解除された！" if myself.is_a?(Game_Enemy)
        myself.remove_state(86)
        recover = ""
      when 87 # 全解除
        effect = "#{myname}の全能力が元に戻った！" if myself.is_a?(Game_Enemy)
        effect = "#{myname}の全能力を元に戻された！" if myself.is_a?(Game_Actor)
        myself.remove_state(87)
        recover = ""
      when 93,94 # 防御中、大防御中
        effect = "#{myname}は快感から身を守っている！"
        recover = ""
      when 95 # お任せ中
        effect = "#{myname}は夢魔の好きに任せることにした！"
        report = "#{myname}は夢魔の成すがままになっている！"
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
        recover = "#{myname}の挑発が落ち着いた！"
        report = "#{myname}は挑発している！"
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
          effect = "#{myname}は拘束されてしまった！"
        elsif user.is_a?(Game_Enemy)
          effect = "#{myname}を拘束した！"
        end
        recover = "#{myname}は拘束から解かれた！"
        report = "#{myname}の身体は拘束されている！"
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