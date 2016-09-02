#==============================================================================
# ■ Talk_Sys(分割定義 2)
#------------------------------------------------------------------------------
#   夢魔の口上を検索、表示するためのクラスです。
#   このクラスのインスタンスは $msg で参照されます。
#   ここでは会話を行うキャラクターの選定、スキル『トーク』の制御を行います。
#==============================================================================
class Talk_Sys
  #============================================================================
  # ●コマンド選択肢※要求パターンを引き当てた時に行うルーレット
  #============================================================================
  def talk_choice
    $msg.tag = $msg.at_type = $msg.at_parts = ""
    @talk_command_type = ""
    #ホールド中会話フラグをクリア
    holding_talk = false
    #エンブレイス相手の暫定処理
    # if #$msg.t_enemy.bind? or $msg.t_enemy.riding? 
    # インサート以外のホールドを受けている相手は不成立になる
    if $msg.t_enemy.can_struggle? or $msg.t_enemy.shellmatch? 
      $msg.tag = "不成立"
      $msg.at_type = "夢魔恍惚中"
      return
    end
    #ベッドイン以外で、会話フラグが一定数以上の場合打ち切られる(ただしホールド中は除く)
    if $game_switches[85] == false and $msg.t_enemy.pillowtalk > 4
      #主人公が会話対象とホールド中の場合は継続
      if $game_actors[101].holding_now?
        holding_talk = true
      #ホールド中でなければ会話不可
      else
        $msg.tag = "不成立"
        $msg.at_type = "試行過多"
        return
      end
    #主人公がクライシスの場合
    elsif $game_actors[101].crisis?
      #主人公が会話対象とホールド中の場合は継続
      if $game_actors[101].holding_now?
        holding_talk = true
      #ホールド中でなければ会話不可
      else
#        unless $msg.t_enemy.friendly > 70
          $msg.tag = "不成立"
          $msg.at_type = "主人公クライシス"
          return
#        else
          #▼交合は両者脱衣状態、かつ両者非ホールドでないと発生しない
#          if $game_actors[101].insertable_half_nude? or $game_actors[101].full_nude?
#            if not $game_actors[101].holding? and not $msg.t_enemy.holding? #ホールド中は選択肢から除外
#              $msg.tag = "交合" if ($msg.t_enemy.friendly > 70 or $game_switches[85] == true)
#              b = []
#              b.push("♀挿入") if $msg.t_enemy.insertable_half_nude? or $msg.t_enemy.full_nude?
#              if b == []
#                $msg.tag = "不成立"
#                $msg.at_type = "主人公クライシス"
#                return
#              end
#              $msg.at_parts = b[rand(b.size)]
#              @talk_command_type = "成否タイプ"
#              return
#            end
#          end
#        end
      end
    #会話対象がクライシスの場合
    elsif $msg.t_enemy.crisis?
      #主人公が会話対象とホールド中の場合は継続
      if $game_actors[101].holding_now?
        holding_talk = true
      #ホールド中でなければ会話不可
      else
        $msg.tag = "不成立"
        $msg.at_type = "夢魔クライシス"
        return
      end
    #会話対象が絶頂中の場合
    elsif $msg.t_enemy.weaken?
      $msg.tag = "不成立"
      $msg.at_type = "夢魔絶頂中"
      return
    #会話対象が恍惚状態(34)の場合
    elsif $msg.t_enemy.states.include?(34)
      $msg.tag = "不成立"
      $msg.at_type = "夢魔恍惚中"
      return
    #会話対象が暴走状態(36)の場合（本気状態の際もこれになる）
    elsif $msg.t_enemy.states.include?(36) or $msg.t_enemy.earnest == true
      $msg.tag = "不成立"
      $msg.at_type = "夢魔暴走中"
      return
    #上記いずれでもない状態で主人公がホールド、かつ会話対象とホールド中の場合
    elsif $game_actors[101].holding_now?
      holding_talk = true
    end
    #●ここからトーク成立時の制御部分
    #["愛撫","主人公脱衣","仲間脱衣","夢魔脱衣","奉仕","視姦","吸精","交合","契約"]
    #前口上呼び出し
    #ムードが２０以下の場合はコモンイベントでトーク終了処理を行う
    if $msg.talk_step == 0
      $msg.tag = "前口上"
    #ステップ１以上なら通常処理
    else
      #ホールド会話フラグが立っている場合は専用タグにする
      if holding_talk == true and not bitter_talk?($msg.t_enemy)
        $msg.tag = "愛撫・性交"
        $msg.at_type = "ホールド攻撃"
        #ぱふぱふ、顔面騎乗、キッスはトークそのものが封じられるため除外
        #攻撃手段を設定(複数ホールドが発生する場合は相手との物のみを選択)
        #▼インサートorアクセプト(♀挿入状態)
        if $game_actors[101].inserting_now?
          $msg.at_parts = "♀挿入：アソコ側"
        #▼オーラルインサートorオーラルアクセプト(口挿入状態)
        elsif $game_actors[101].oralsex_now?
          $msg.tag = "愛撫・通常"
          $msg.at_parts = "口挿入：口側"
        #▼バックインサートorバックアクセプト(尻挿入状態)
        elsif $game_actors[101].analsex_now?
          $msg.tag = "愛撫・通常"
          $msg.at_parts = "尻挿入：尻側"
        #▼エンブレイス(密着状態)
        elsif $msg.t_enemy.binding_now?
          $msg.tag = "愛撫・通常"
          $msg.at_parts = "背面拘束"
        #▼ペリスコープ(パイズリ状態)
        elsif $msg.t_enemy.paizuri_now?
          $msg.tag = "愛撫・通常"
          $msg.at_parts = "パイズリ"
        else
          $msg.tag = "愛撫・通常"
        end
        @talk_command_type = "継続タイプ"
        return
      end
      return if $mood.point < 20 #ムード２０以下ならここまで
      a = []
      #▼主人公がホールド状態だと発生しないもの多数
      unless $game_actors[101].holding?
        #▼主人公脱衣は既に主人公が脱いでいると発生しない
        a.push("主人公脱衣") unless $game_actors[101].full_nude?
        # ●高ムード●
        if $mood.point >= 40
          #▼奉仕は相手が脱衣時のみ、かつ非ホールドでないと発生しない
          a.push("奉仕") if not $msg.t_enemy.holding? and $msg.t_enemy.full_nude?
          #▼吸精Pは主人公のVPが一定以上、かつ主人公が全裸、非Pホールドでないと発生しない
          if $game_actors[101].spp > 10 and $game_switches[85] == false
            a.push("吸精・性器") if $game_actors[101].hold.penis.battler == nil and $game_actors[101].full_nude?
          end
          #▼交合は両者脱衣状態、かつ両者非ホールドでないと発生しない
          if $game_actors[101].insertable_half_nude? or $game_actors[101].full_nude?
            if not $game_actors[101].holding? and not $msg.t_enemy.holding? #ホールド中は選択肢から除外
              a.push("交合") if $msg.t_enemy.friendly > 70
            end
          end
        end
      end
      #▼相手がホールド状態だと発生しないもの
      unless $msg.t_enemy.holding?
        #▼夢魔脱衣は既に夢魔が脱いでいる、もしくは夢魔がホールド中だと発生しない
        a.push("夢魔脱衣") unless $msg.t_enemy.full_nude?
        #▼愛撫は主人公が非Pホールド、かつ相手が非ホールドでないと発生しない
        if $game_actors[101].hold.penis.battler == nil
          a.push("愛撫・通常") if $game_actors[101].nude?
        end
        #ムード高限定
        if $mood.point >= 40
          #▼視姦は相手が全裸でないと発生しない
          a.push("視姦") if $msg.t_enemy.full_nude?
          if $game_actors[101].spp > 10 and $game_switches[85] == false
            #▼吸精口は口が塞がれていると発生しない
            a.push("吸精・口") if $game_actors[101].hold.mouth.battler == nil
          end
        end
      end
#      a.push("契約") if $mood.point >= 100
      #●ルーレット(選択肢が無い場合のみ「好意」が選ばれる)
      a.push("好意") if a == []
      
      #●好意以外の選択肢を取らない夢魔の場合
      if bitter_talk?($msg.t_enemy)
        a = ["好意"] # 好意のみを基準にする
        # 50％で不成立に変更
        if rand(100) < 50
          $msg.tag = "不成立"
          $msg.at_type = "試行過多" 
          # ↑タイプ分けする場合はここを変更して口上rb側に加筆
          return
        end
      end
      
      $msg.tag = a[rand(a.size)]
      #ホールド要求の場合、どのホールドを行うか選定
      if $msg.tag == "交合"
        b = []
        b.push("♀挿入") if $msg.t_enemy.insertable_half_nude? or $msg.t_enemy.full_nude?
#        b.push("口挿入")
#        b.push("キッス")
#        b.push("尻挿入") if $msg.t_enemy.insertable_half_nude? or $msg.t_enemy.full_nude?
#        b.push("パイズリ") if $msg.t_enemy.full_nude?
        if b == []
          $msg.tag = "好意"
          return
        end
        $msg.at_parts = b[rand(b.size)]
      end
      case $msg.tag
      when "愛撫・通常","愛撫・性交","視姦","奉仕"
        @talk_command_type = "継続タイプ"
      when "主人公脱衣","仲間脱衣","夢魔脱衣","吸精・口","吸精・性器","交合"
        @talk_command_type = "成否タイプ"
      end
    end
  end
  #============================================================================
  # ●レディ(個別トークの事前準備を出力する処理)
  #============================================================================
  def talk_ready
    case $msg.tag
    when "愛撫・通常","愛撫・性交","視姦","奉仕"
      #攻撃検証リセット
      @befor_talk_action = []
      talk_attack_pattern
      make_text_pretalk
    else
      make_text_pretalk
    end
  end
  #============================================================================
  # ●リザルト(個別トークの結果を出力する処理)
  #============================================================================
  def talk_result
#    p "タグ：#{@tag}／分類：#{@talk_command_type}"
    case $msg.tag
    when "愛撫・通常","愛撫・性交","視姦","奉仕"
      unless $msg.talk_step >= 77
        talk_critical
        make_text_aftertalk
        talk_damage
        talk_states_change
        #読み込んだテキスト長からウェイトを算出
        SR_Util.talk_log_wait_make
        #アタックパターン再度読み込み
        talk_attack_pattern
        #直前行動との整合性を検証
        if @befor_talk_action[0] == @befor_talk_action[1]
          @chain_attack = true
        else
          @chain_attack = false
        end
        #先頭を消去
        a = @befor_talk_action[1]
        @befor_talk_action = []
        @befor_talk_action.push(a)
      end
    when "吸精・口","吸精・性器"
      unless $msg.talk_step >= 77
        make_text_aftertalk
        talk_damage
        talk_states_change
      end
    when "主人公脱衣","仲間脱衣","夢魔脱衣","交合"
      make_text_aftertalk
      unless $msg.talk_step >= 77
        talk_states_change
      end
    when "好意","不成立"
      make_text_aftertalk
    end
  end
  #============================================================================
  # ●アタックパターン(愛撫選択時に行うルーレット処理)
  #============================================================================
  def talk_attack_pattern
    if $msg.tag == "愛撫・通常"
      #ルーレット作成
      pattern = ["手","手","手","口","口","口","足"]
      pattern.push("胸","胸","♀","♀") if $msg.t_enemy.full_nude?
      pattern.push("尻尾") if $data_SDB[$msg.t_enemy.class_id].tail == true
      #仲間戦やチェックスキルを使われた場合は予め弱点を突かれやすくなる
      if $msg.t_enemy.checking == 1
        pattern.push("手","手","手","手","手") if $game_actors[101].have_ability?("手攻めに弱い")
        pattern.push("口","口","口","口","口") if $game_actors[101].have_ability?("口攻めに弱い")
        pattern.push("足","足","足","足","足") if $game_actors[101].have_ability?("嗜虐攻めに弱い")
        pattern.push("胸","胸","胸","胸","胸") if $game_actors[101].have_ability?("胸攻めに弱い")
        pattern.push("♀","♀","♀","♀","♀") if $game_actors[101].have_ability?("女陰攻めに弱い")
        pattern.push("尻尾","尻尾","尻尾","尻尾","尻尾") if $game_actors[101].have_ability?("異形攻めに弱い")
      end
      #これ以降は弱点を知られた場合に追加する項目
      if $msg.t_enemy.talk_weak_check.include?("手")
        pattern.push("手","手","手","手","手") 
        pattern.push("手","手","手","手","手","手","手","手","手","手") if $game_actors[101].have_ability?("手攻めに弱い")
      end
      if $msg.t_enemy.talk_weak_check.include?("口")
        pattern.push("口","口","口","口","口") 
        pattern.push("口","口","口","口","口","口","口","口","口","口") if $game_actors[101].have_ability?("口攻めに弱い")
      end
      if $msg.t_enemy.talk_weak_check.include?("足")
        pattern.push("足","足","足","足","足","足","足") 
        pattern.push("足","足","足","足","足","足","足","足","足","足") if $game_actors[101].have_ability?("嗜虐攻めに弱い")
      end
      if $msg.t_enemy.talk_weak_check.include?("胸")
        pattern.push("胸","胸","胸","胸","胸","胸") 
        pattern.push("胸","胸","胸","胸","胸","胸","胸","胸","胸","胸") if $game_actors[101].have_ability?("胸攻めに弱い")
      end
      if $msg.t_enemy.talk_weak_check.include?("♀")
        pattern.push("♀","♀","♀","♀","♀","♀") 
        pattern.push("♀","♀","♀","♀","♀","♀","♀","♀","♀","♀") if $game_actors[101].have_ability?("女陰攻めに弱い")
      end
      if $msg.t_enemy.talk_weak_check.include?("尻尾")
        pattern.push("尻尾","尻尾","尻尾","尻尾","尻尾") 
        pattern.push("尻尾","尻尾","尻尾","尻尾","尻尾","尻尾","尻尾","尻尾","尻尾","尻尾") if $game_actors[101].have_ability?("異形攻めに弱い")
      end
      $msg.at_type = pattern[rand(pattern.size)]
      @befor_talk_action.push($msg.at_type)
    elsif $msg.tag == "奉仕" or $msg.tag == "視姦"
      #ルーレット作成
      pattern = ["口","胸","尻","アソコ"]
      pattern.push("陰核","アナル") if $msg.t_enemy.full_nude?
      #仲間戦やチェックスキルを使った場合は弱点を突きやすくなる
      if $msg.t_enemy.checking == 1
        pattern.push("口","口","口","口","口") if $msg.t_enemy.have_ability?("口が性感帯") or $msg.t_enemy.have_ability?("淫唇")
        pattern.push("胸","胸","胸","胸","胸") if $msg.t_enemy.have_ability?("胸が性感帯") or $msg.t_enemy.have_ability?("淫乳")
        pattern.push("尻","尻","尻","尻","尻") if $msg.t_enemy.have_ability?("お尻が性感帯") or $msg.t_enemy.have_ability?("淫尻")
        pattern.push("アソコ","アソコ","アソコ","アソコ","アソコ") if $msg.t_enemy.have_ability?("女陰が性感帯") or $msg.t_enemy.have_ability?("淫壺")
        pattern.push("陰核","陰核","陰核","陰核","陰核") if $msg.t_enemy.have_ability?("陰核が性感帯") or $msg.t_enemy.have_ability?("淫核")
        pattern.push("アナル","アナル","アナル","アナル","アナル") if $msg.t_enemy.have_ability?("菊座が性感帯") or $msg.t_enemy.have_ability?("淫花")
      end
      if $msg.t_enemy.talk_weak_check.include?("対象：口")
        pattern.push("口","口","口","口","口") 
        pattern.push("口","口","口","口","口","口","口","口","口","口") if $msg.t_enemy.have_ability?("口が性感帯") or $msg.t_enemy.have_ability?("淫唇")
      end
      if $msg.t_enemy.talk_weak_check.include?("対象：胸")
        pattern.push("胸","胸","胸","胸","胸") 
        pattern.push("胸","胸","胸","胸","胸","胸","胸","胸","胸","胸") if $msg.t_enemy.have_ability?("胸が性感帯") or $msg.t_enemy.have_ability?("淫乳")
      end
      if $msg.t_enemy.talk_weak_check.include?("対象：尻")
        pattern.push("尻","尻","尻","尻","尻") 
        pattern.push("尻","尻","尻","尻","尻","尻","尻","尻","尻","尻") if $msg.t_enemy.have_ability?("お尻が性感帯") or $msg.t_enemy.have_ability?("淫尻")
      end
      if $msg.t_enemy.talk_weak_check.include?("対象：アソコ")
        pattern.push("アソコ","アソコ","アソコ","アソコ","アソコ") 
        pattern.push("アソコ","アソコ","アソコ","アソコ","アソコ","アソコ","アソコ","アソコ","アソコ","アソコ") if $msg.t_enemy.have_ability?("女陰が性感帯") or $msg.t_enemy.have_ability?("淫壺")
      end
      if $msg.t_enemy.talk_weak_check.include?("対象：陰核")
        pattern.push("陰核","陰核","陰核","陰核","陰核") 
        pattern.push("陰核","陰核","陰核","陰核","陰核","陰核","陰核","陰核","陰核","陰核") if $msg.t_enemy.have_ability?("陰核が性感帯") or $msg.t_enemy.have_ability?("淫核")
      end
      if $msg.t_enemy.talk_weak_check.include?("対象：アナル")
        pattern.push("アナル","アナル","アナル","アナル","アナル") 
        pattern.push("アナル","アナル","アナル","アナル","アナル","アナル","アナル","アナル","アナル","アナル") if $msg.t_enemy.have_ability?("菊座が性感帯") or $msg.t_enemy.have_ability?("淫花")
      end
      $msg.at_parts = "対象：" + pattern[rand(pattern.size)]
      @befor_talk_action.push($msg.at_parts)
    #通常愛撫と奉仕で無い場合は戻す
    else
      return
    end
  end
  #============================================================================
  # ●クリティカル(トーク時にダメージを算出する際のクリティカルの処理)
  #   必ず$msg.t_targetは主人公になっている(はず)
  #============================================================================
  def talk_critical
    case $msg.tag
    when "奉仕","視姦"
      damage_target = $msg.t_enemy
    else
      damage_target = $game_actors[101]
    end
    damage_target.critical = false
    #対象の弱点を予めサーチ
    talk_weakpoint
    #性癖込みの弱点を看破された場合
    case @weakpoints
    #性癖(性感帯)を突いた場合(すでに看破済み)
    when 20
      perc = 60
    #性癖(性感帯)を突いた場合(発見された)
    when 10
      perc = [($msg.talk_step * 3),30].min + 20
    #性癖(性感帯)を攻められた場合
    when 2
      perc = [($msg.talk_step * 3),30].min + 10
    #通常
    else
      perc = [$msg.talk_step,10].min + 10
    end
    #●確率計算
    if perc > rand(100)
      damage_target.critical = true
    else
      damage_target.critical = false
    end
  end
  #============================================================================
  # ●ダメージ(トーク時に愛撫等で実ダメージを算出する際の処理)
  #   必ず$msg.t_targetは主人公になっている(はず)
  #============================================================================
  def talk_damage
    text = ""
    #ダメージを与える対象をタグごとに変更
    if $msg.tag == "奉仕"
      damage_target = $msg.t_enemy
      #ダメージを算出
      base_dmg = [($game_actors[101].dex / 2).ceil, 40].min
      base_dmg += [[(($game_actors[101].level * 2) - damage_target.level),0].max,30].min
      base_dmg += rand(($mood.point / 5).round)
      base_dmg += rand($msg.talk_step * 3) if $msg.talk_step > 0
    elsif $msg.tag == "視姦"
      damage_target = $msg.t_enemy
      #ダメージを算出
      base_dmg = [($msg.t_enemy.dex / 2).ceil, 40].min
      base_dmg += rand(($mood.point / 5).round)
      base_dmg += rand($msg.talk_step * 3) if $msg.talk_step > 0
    else
      damage_target = $game_actors[101]
      #ダメージを算出
      base_dmg = [($msg.t_enemy.dex / 2).ceil, 80].min
      base_dmg += [(($msg.t_enemy.level * 2) - damage_target.level),0].max
      base_dmg += rand(($mood.point / 4).round)
      base_dmg += rand($msg.talk_step * 5) if $msg.talk_step > 0
    end
    #あまりに低すぎたら修正する
    base_dmg = 20 + rand(10) - rand(5) if base_dmg <= 20
    #●SS発生及びアニメーションの設定
    #視姦にはSSは発生しない
    case $msg.tag
    when "愛撫・通常","愛撫・性交","奉仕"
      #クリティカル処理
      if damage_target.critical == true
        text += "Sensual Stroke！\065\067"
        damage_target.animation_id = 103
        damage_target.animation_hit = true
        base_dmg = (base_dmg * 5 / 4).round
        #●愛撫、性交の場合は突いた弱点を確保しておく
        if $msg.tag == "愛撫・通常"
          unless $msg.t_enemy.talk_weak_check.include?($msg.at_type)
            $msg.t_enemy.talk_weak_check.push($msg.at_type)
          end
        elsif $msg.tag == "愛撫・性交"
          unless $msg.t_enemy.talk_weak_check.include?($msg.at_type)
            $msg.t_enemy.talk_weak_check.push($msg.at_type)
          end
          @hold_initiative_refresh.push($msg.t_enemy,$game_actors[101])
        #●奉仕の場合は突かれた弱点を確保しておく
        elsif $msg.tag == "奉仕"
          unless $msg.t_enemy.talk_weak_check.include?($msg.at_parts)
            $msg.t_enemy.talk_weak_check.push($msg.at_parts)
          end
        end
      #クリティカルで無い場合は攻撃ごとにアニメーションを表示
      else
        if $msg.at_type == "尻尾"
          damage_target.animation_id = 46
        elsif $msg.tag == "愛撫・性交"
          damage_target.animation_id = 107
        else
          damage_target.animation_id = 45
        end
        damage_target.animation_hit = true
      end
    when "吸精・口","吸精・性器"
      damage_target.animation_id = 85
    when "視姦"
      damage_target.animation_id = 52
    end
    #ダメージ値修正(愛撫を１とした場合)
    case $msg.tag
    when "愛撫・性交"
      unless $msg.at_parts == "背面拘束"
        base_dmg = (base_dmg * 3 / 2).round
        if damage_target.shake_tate?
          # 画面の縦シェイク
          $game_screen.start_flash(Color.new(255,210,225,220), 8)
          $game_screen.start_shake2(7, 15, 15)
        # グラインド系
        elsif damage_target.shake_yoko?
          # 画面の横シェイク
          $game_screen.start_flash(Color.new(255,210,225,220), 8)
          $game_screen.start_shake(7, 15, 15)
        end
      else
        if damage_target.critical == true
          base_dmg = (base_dmg * 4 / 3).round
        else
          base_dmg = (base_dmg * 2 / 3).round
        end
      end
    when "奉仕"
      base_dmg = (base_dmg * 2 / 3).round
    when "吸精・口","吸精・性器"
      #●VP減衰は別計算式
      base_dmg = $msg.t_enemy.atk
      base_dmg += ($msg.t_enemy.level * 2) + rand($msg.t_enemy.level * 3)
      base_dmg += ($msg.t_enemy.str / 2).round if $msg.tag == "吸精・性器"
      base_dmg = ($game_actors[101].sp - 1) if base_dmg >= $game_actors[101].sp
      $msg.t_enemy.add_state(16) #吸精はステート変化を通らないのでここで行動放棄
    when "視姦"
      base_dmg = (base_dmg / 2).round
    end
    #テキスト補正・ダメージ適用
    if $msg.tag == "吸精・口" or $msg.tag == "吸精・性器"
      text += "#{damage_target.name}は精気を #{base_dmg.to_s} 吸い取られた！"
      damage_target.sp -= base_dmg
    else
      if $msg.tag == "奉仕"
        text += "#{$msg.t_enemy.name}に #{base_dmg.to_s} の快感を与えた！"
      elsif $msg.tag == "視姦"
        text += "#{$msg.t_enemy.name}は #{base_dmg.to_s} の快感を得た！"
      else
        text += "#{$msg.t_target.name}は #{base_dmg.to_s} の快感を受けた！"
      end
      t_hp = damage_target.hp - base_dmg
      if t_hp <= 0
        if $msg.tag == "奉仕"
          $msg.talking_ecstasy_flag = "enemy"
        else
          p "アクター" if $DEBUG
          $msg.talking_ecstasy_flag = "actor"
        end
        damage_target.add_state(11)
      end
      #実際にダメージを適用する
      damage_target.hp -= base_dmg
    end
    #ステータスウィンドウ更新
    @stateswindow_refresh = true
    if $game_temp.battle_log_text != ""
      $game_temp.battle_log_text += "\065\067" + text
    else
      $game_temp.battle_log_text += text
    end
    
    #damage_target.animation_id = 0
    
    
    
    # 画像変更
    damage_target.graphic_change = true
  end
  #============================================================================
  # ●トーク弱点突きチェック
  #============================================================================
  def talk_weakpoint
    @weakpoints = 0
    case $msg.at_type
    when "口"
      if $game_actors[101].have_ability?("口攻めに弱い")
        @weakpoints = 2
        @weakpoints = 20 if $msg.t_enemy.talk_weak_check.include?("口")
      else
        @weakpoints = 1
        @weakpoints = 10 if $msg.t_enemy.talk_weak_check.include?("口")
      end
    when "手"
      if $game_actors[101].have_ability?("手攻めに弱い")
        @weakpoints = 2
        @weakpoints = 20 if $msg.t_enemy.talk_weak_check.include?("手")
      else
        @weakpoints = 1
        @weakpoints = 10 if $msg.t_enemy.talk_weak_check.include?("手")
      end
    when "胸"
      if $game_actors[101].have_ability?("胸攻めに弱い")
        @weakpoints = 2
        @weakpoints = 20 if $msg.t_enemy.talk_weak_check.include?("胸")
      else
        @weakpoints = 1
        @weakpoints = 10 if $msg.t_enemy.talk_weak_check.include?("胸")
      end
    when "♀"
      if $game_actors[101].have_ability?("女陰攻めに弱い")
        @weakpoints = 2
        @weakpoints = 20 if $msg.t_enemy.talk_weak_check.include?("♀")
      else
        @weakpoints = 1
        @weakpoints = 10 if $msg.t_enemy.talk_weak_check.include?("♀")
      end
    when "足"
      if $game_actors[101].have_ability?("嗜虐攻めに弱い")
        @weakpoints = 2
        @weakpoints = 20 if $msg.t_enemy.talk_weak_check.include?("足")
      else
        @weakpoints = 1
        @weakpoints = 10 if $msg.t_enemy.talk_weak_check.include?("足")
      end
    when "尻尾"
      if $game_actors[101].have_ability?("異形攻めに弱い")
        @weakpoints = 2
        @weakpoints = 20 if $msg.t_enemy.talk_weak_check.include?("尻尾")
      else
        @weakpoints = 1
        @weakpoints = 10 if $msg.t_enemy.talk_weak_check.include?("尻尾")
      end
    when "♀挿入"
      if $game_actors[101].have_ability?("性交に弱い")
        @weakpoints = 2
        @weakpoints = 20 if $msg.t_enemy.talk_weak_check.include?("♀挿入")
      else
        @weakpoints = 1
        @weakpoints = 10 if $msg.t_enemy.talk_weak_check.include?("♀挿入")
      end
    when "口挿入"
      if $game_actors[101].have_ability?("口攻めに弱い")
        @weakpoints = 2
        @weakpoints = 20 if $msg.t_enemy.talk_weak_check.include?("口挿入")
      else
        @weakpoints = 1
        @weakpoints = 10 if $msg.t_enemy.talk_weak_check.include?("口挿入")
      end
    when "尻挿入"
      if $game_actors[101].have_ability?("性交に弱い")
        @weakpoints = 2
        @weakpoints = 20 if $msg.t_enemy.talk_weak_check.include?("尻挿入")
      else
        @weakpoints = 1
        @weakpoints = 10 if $msg.t_enemy.talk_weak_check.include?("尻挿入")
      end
    when "パイズリ"
      if $game_actors[101].have_ability?("胸攻めに弱い")
        @weakpoints = 2
        @weakpoints = 20 if $msg.t_enemy.talk_weak_check.include?("胸")
      else
        @weakpoints = 1
        @weakpoints = 10 if $msg.t_enemy.talk_weak_check.include?("胸")
      end
    end
    #相手が夢魔の場合、参照する素質が変わる
    case $msg.at_parts
    when "対象：口"
      if $msg.t_enemy.have_ability?("口が性感帯") or $msg.t_enemy.have_ability?("淫唇")
        @weakpoints = 2
        @weakpoints = 20 if $msg.t_enemy.talk_weak_check.include?("対象：口")
      else
        @weakpoints = 1
        @weakpoints = 10 if $msg.t_enemy.talk_weak_check.include?("対象：口")
      end
    when "対象：胸"
      if $msg.t_enemy.have_ability?("胸が性感帯") or $msg.t_enemy.have_ability?("淫乳")
        @weakpoints = 2
        @weakpoints = 20 if $msg.t_enemy.talk_weak_check.include?("対象：胸")
      else
        @weakpoints = 1
        @weakpoints = 10 if $msg.t_enemy.talk_weak_check.include?("対象：胸")
      end
    when "対象：尻"
      if $msg.t_enemy.have_ability?("お尻が性感帯") or $msg.t_enemy.have_ability?("淫尻")
        @weakpoints = 2
        @weakpoints = 20 if $msg.t_enemy.talk_weak_check.include?("対象：尻")
      else
        @weakpoints = 1
        @weakpoints = 10 if $msg.t_enemy.talk_weak_check.include?("対象：尻")
      end
    when "対象：アソコ"
      if $msg.t_enemy.have_ability?("女陰が性感帯") or $msg.t_enemy.have_ability?("淫壺")
        @weakpoints = 2
        @weakpoints = 20 if $msg.t_enemy.talk_weak_check.include?("対象：アソコ")
      else
        @weakpoints = 1
        @weakpoints = 10 if $msg.t_enemy.talk_weak_check.include?("対象：アソコ")
      end
    when "対象：陰核"
      if $msg.t_enemy.have_ability?("陰核が性感帯") or $msg.t_enemy.have_ability?("淫核")
        @weakpoints = 2
        @weakpoints = 20 if $msg.t_enemy.talk_weak_check.include?("対象：陰核")
      else
        @weakpoints = 1
        @weakpoints = 10 if $msg.t_enemy.talk_weak_check.include?("対象：陰核")
      end
    when "対象：アナル"
      if $msg.t_enemy.have_ability?("菊座が性感帯") or $msg.t_enemy.have_ability?("淫花")
        @weakpoints = 2
        @weakpoints = 20 if $msg.t_enemy.talk_weak_check.include?("対象：アナル")
      else
        @weakpoints = 1
        @weakpoints = 10 if $msg.t_enemy.talk_weak_check.include?("対象：アナル")
      end
    end
  end
  #============================================================================
  # ●ステート変更(個別トーク時のステート付与等を管理)
  #============================================================================
  def talk_states_change
    text = ""
    case $msg.tag
    when "愛撫・通常","愛撫・性交"
      if $game_actors[101].hpp < 20 and $game_actors[101].hp > 0
        unless $game_actors[101].states.include?(6)
          $game_actors[101].add_state(6)
          if $game_temp.battle_log_text != ""
            text = "\065\067" + $game_actors[101].bms_states_update
          else
            text = $game_actors[101].bms_states_update
          end
          $game_actors[101].graphic_change = true
          $msg.stateswindow_refresh = true
        end
      end
      $msg.t_enemy.add_state(16) #行動放棄
    when "交合"
      case $msg.at_parts
      when "♀挿入"
        # アクセプトを通す
        SR_Util.special_hold_make($data_skills[682], $msg.t_enemy, $game_actors[101])
=begin
        # アクセプトを通す
        $scene.hold_effect($data_skills[682], $msg.t_enemy, $game_actors[101])
        $msg.t_enemy.white_flash = true
        $msg.t_enemy.animation_id = 105
        $msg.t_enemy.animation_hit = true
        # 画面の縦シェイク
        $game_screen.start_flash(Color.new(255,210,225,220), 8)
        $game_screen.start_shake2(7, 15, 15)

        #$msg.t_enemy.hold.vagina.set($game_actors[101], "ペニス", "♀挿入", 3)
        #$game_actors[101].hold.penis.set($msg.t_enemy, "アソコ", "♀挿入", 0)

        # トーク相手にスタンをかける
        $scene.battler_stan($msg.t_enemy)
=end
#      when "口挿入"
#      when "尻挿入"
#      when "パイズリ"
#      when "キッス"
      end
      @hold_pops_refresh = true
    when "主人公脱衣"
      $game_actors[101].undress
      if $game_temp.battle_log_text != ""
        text = "\065\067" + $game_actors[101].bms_states_update
      else
        text = $game_actors[101].bms_states_update
      end
      $game_actors[101].graphic_change = true
      $msg.stateswindow_refresh = true
      for enemy in $game_troop.enemies
        pc = [[($game_actors[101].str + 10 - enemy.int), 10].max, 40].min
        pc = [[($game_actors[101].dex + 10 - enemy.int), 10].max, 40].min if $msg.tag == "仲間脱衣"
        #率先してやると付与確率が上がる
        pc += 20 if $game_switches[89] == true
        if rand(100) < pc
          enemy.add_state(32) #ドキドキ
          enemy.animation_id = 39
          if $game_temp.battle_log_text != ""
            text = "\065\067" + enemy.bms_states_update
          else
            text = enemy.bms_states_update
          end
        end
      end
    when "夢魔脱衣"
      $msg.t_enemy.undress
      if $game_temp.battle_log_text != ""
        text = "\065\067" + $msg.t_enemy.bms_states_update
      else
        text = $msg.t_enemy.bms_states_update
      end
      $msg.t_enemy.graphic_change = true
      $msg.stateswindow_refresh = true
      #主人公のみドキドキの可能性、そしてやや高い
      pc = [[($msg.t_enemy.str + 20 - $game_actors[101].int), 20].max, 50].min
      #進んで見るとより確率高い
      pc += 30 if $game_switches[89] == true
      if rand(100) < pc
        $game_actors[101].add_state(32) #ドキドキ
        $game_actors[101].animation_id = 39
        if $game_temp.battle_log_text != ""
          text = "\065\067" + $game_actors[101].bms_states_update
        else
          text = $game_actors[101].bms_states_update
        end
      end
      $msg.t_enemy.add_state(16) #行動放棄
    when "奉仕"
      if ($msg.t_enemy.hpp < $mood.crisis_point(self) + rand(5)) and $msg.t_enemy.hp > 0
        unless $msg.t_enemy.states.include?(6)
          $msg.t_enemy.add_state(6)
          if $game_temp.battle_log_text != ""
            text = "\065\067" + $msg.t_enemy.bms_states_update
          else
            text = $msg.t_enemy.bms_states_update
          end
          $msg.t_enemy.graphic_change = true
          $msg.stateswindow_refresh = true
        end
      end
      case $msg.talk_step
      when 2
        $game_actors[101].add_state(32) #ドキドキ
        text += "\065\067" + $game_actors[101].bms_states_update
        $msg.t_enemy.add_state(16) #行動放棄
      when 3..99
        plus = ($msg.talk_step * 5)
        perc = $game_actors[101].int
        perc /= 3 if $game_switches[89] == true #抵抗しないと付与率高くなる
        if $game_actors[101].state?(40)
          if rand($mood.point) + plus > [perc,60].min
            $game_actors[101].add_state(36) #暴走
            text += "\065\067" + $game_actors[101].bms_states_update
          end
        elsif $game_actors[101].state?(35)
          if rand($mood.point) + plus > [perc,45].min
            $game_actors[101].add_state(40) #散漫
            text += "\065\067" + $game_actors[101].bms_states_update
          end
        else
          if rand($mood.point) + plus > [perc,30].min
            $game_actors[101].add_state(35) #欲情
            text += "\065\067" + $game_actors[101].bms_states_update
          end
        end
      end
    when "視姦"
      if ($msg.t_enemy.hpp < $mood.crisis_point(self) + rand(5)) and $msg.t_enemy.hp > 0
        unless $msg.t_enemy.states.include?(6)
          $msg.t_enemy.add_state(6)
          if $game_temp.battle_log_text != ""
            text = "\065\067" + $msg.t_enemy.bms_states_update
          else
            text = $msg.t_enemy.bms_states_update
          end
          $msg.t_enemy.graphic_change = true
          $msg.stateswindow_refresh = true
        end
      end
      case $msg.talk_step
      when 2
        $game_actors[101].add_state(32) #ドキドキ
        text += "\065\067" + $game_actors[101].bms_states_update
        $msg.t_enemy.add_state(16) #行動放棄
      when 3..99
        plus = ($msg.talk_step * 5)
        perc = $game_actors[101].int
        perc /= 3 if $game_switches[89] == true #抵抗しないと付与率高くなる
        if $game_actors[101].state?(40)
          if rand($mood.point) + plus > [perc,60].min
            $game_actors[101].add_state(34) #恍惚
            text += "\065\067" + $game_actors[101].bms_states_update
          end
        elsif $game_actors[101].state?(35)
          if rand($mood.point) + plus > [perc,45].min
            $game_actors[101].add_state(40) #散漫
            text += "\065\067" + $game_actors[101].bms_states_update
          end
        else
          if rand($mood.point) + plus > [perc,30].min
            $game_actors[101].add_state(35) #欲情
            text += "\065\067" + $game_actors[101].bms_states_update
          end
        end
      end
    end
    $game_temp.battle_log_text += text
  end
  #============================================================================
  # ●相手に性交の意思がない会話をする場合
  #============================================================================
  def bitter_talk?(enemy)
    result = false
    # 通常戦且つ、クラスIDがプリーステスかギルゴーンかラーミルである
    if not ($game_switches[85] or $game_switches[86] or $game_switches[99])
      if [118,254,257].include?(enemy.class_id)
        result = true
      end
    end
    return result
  end
  
end