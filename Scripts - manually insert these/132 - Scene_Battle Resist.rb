#==============================================================================
# ■ Scene_Battle (分割定義 8)
#------------------------------------------------------------------------------
# 　バトル画面の処理を行うクラスです。
#   この項目ではレジスト処理を行います。
#==============================================================================

class Scene_Battle
  
  def battle_resist
    # レジストフラグを建てる
    $game_temp.resistgame_flag = 1
    # レジストの成否をクリア
    $game_temp.resistgame_clear = false
    # ダメージナレート後に口上を出すフラグを入れる
    $game_switches[90] = true
    # ホールドスキルならスイッチ８１をオンにする
    $game_switches[81] = false
    $game_switches[81] = true if @skill.element_set.include?(6)
    # ●レジストは基本＋ムード＋能力＋その他の補正合計で難易度決定する
    md = lvp = pm = ste = ins = 0
    # ●対象の設定と同時にムード補正と、口上呼出キーを設定する
    # エネミーが対象の場合(行動側がアクター)
    active = @active_battler
    target = @target_battlers[0]
    # --------------------------------------------------------------
    # ★トークステップ、コールサイン設定
    # --------------------------------------------------------------
    #トークステップを１（レジスト開始）に設定
    #なお後述するがレジスト成功の場合は２、失敗の場合は３となる
    #トーク中の選択肢レジストの場合、既にトークステップがあるため設定しない
    #ホールド攻撃
    if @skill.element_set.include?(6)
      $msg.talk_step = 1
      #解除系スキルは別枠
      if @skill.name == "リリース" or @skill.name == "ストラグル"
        if active == $game_actors[101]
          $msg.tag = "主人公が夢魔をホールド"
          $msg.at_type = "自分ホールド解除"
          $msg.callsign = 8
          $msg.callsign = 18 if $game_switches[85] == true
        else
          $msg.tag = "パートナーが夢魔をホールド"
          $msg.at_type = "自分ホールド解除"
          $msg.callsign = 28
          $msg.callsign = 38 if $game_switches[85] == true
        end
      elsif @skill.name == "インタラプト"
        if active == $game_actors[101]
          $msg.tag = "主人公が夢魔をホールド"
          $msg.at_type = "仲間ホールド解除"
          $msg.callsign = 8
          $msg.callsign = 18 if $game_switches[85] == true
        else
          $msg.tag = "パートナーが夢魔をホールド"
          $msg.at_type = "仲間ホールド解除"
          $msg.callsign = 28
          $msg.callsign = 38 if $game_switches[85] == true
        end
      elsif target.is_a?(Game_Actor)
        if target == $game_actors[101]
          $msg.tag = "夢魔が主人公をホールド"
          $msg.callsign = 8
          $msg.callsign = 18 if $game_switches[85] == true
        else
          $msg.tag = "夢魔がパートナーをホールド"
          $msg.callsign = 28
          $msg.callsign = 38 if $game_switches[85] == true
        end
      elsif target.is_a?(Game_Enemy)
        if active == $game_actors[101]
          $msg.tag = "主人公が夢魔をホールド"
          $msg.callsign = 8
          $msg.callsign = 18 if $game_switches[85] == true
        else
          $msg.tag = "パートナーが夢魔をホールド"
          $msg.callsign = 28
          $msg.callsign = 38 if $game_switches[85] == true
        end
      end
      #ホールドタイプを指定(追撃イベントとは被らないので$msg.at_typeを使用)
      case @skill.name
      when "インサート"
        $msg.at_type = "♀挿入：♂側"
      when "アクセプト"
        $msg.at_type = "♀挿入：♀側"
      when "オーラルインサート"
        $msg.at_type = "口挿入：♂側"
      when "オーラルアクセプト"
        $msg.at_type = "口挿入：口側"
      when "バックインサート"
        $msg.at_type = "Ａ挿入：♂側"
      when "バックアクセプト"
        $msg.at_type = "Ａ挿入：Ａ側"
      when "エキサイトビュー"
        $msg.at_type = "顔面騎乗"
      when "インモラルビュー"
        $msg.at_type = "尻騎乗"
      when "エンブレイス"
        $msg.at_type = "背面拘束"
      when "エキシビジョン"
        $msg.at_type = "開脚"
      when "ペリスコープ"
        $msg.at_type = "パイズリ"
      when "ヘブンリーフィール"
        $msg.at_type = "ぱふぱふ"
      when "シェルマッチ"
        $msg.at_type = "貝合わせ"
      when "ドロウネクター"
        $msg.at_type = "クンニリングス"
      when "フラッタナイズ"
        $msg.at_type = "キッス"
      when "インサートテイル"
        $msg.at_type = "尻尾♀挿入"
      when "マウスインテイル"
        $msg.at_type = "尻尾口挿入"
      when "バックインテイル"
        $msg.at_type = "尻尾Ａ挿入"
      when "ディルドインサート"
        $msg.at_type = "ディルド♀挿入"
      when "ディルドインディルド"
        $msg.at_type = "ディルド口挿入"
      when "ディルドインバック"
        $msg.at_type = "ディルド尻挿入"
      when "インサートテンタクル"
        $msg.at_type = "触手♀挿入"
      when "マウスインテンタクル"
        $msg.at_type = "触手口挿入"
      when "バックインテンタクル"
        $msg.at_type = "触手Ａ挿入"
      when "テンタクルバンデージ"
        $msg.at_type = "触手拘束"
      when "デモンズアブソーブ"
        $msg.at_type = "触手吸引"
      when "デモンズドロウ"
        $msg.at_type = "触手クンニ"
      end
    #相手の服を脱がせる
    elsif @skill.element_set.include?(36)
      $msg.talk_step = 1
      if target.is_a?(Game_Actor)
        if target == $game_actors[101]
          $msg.tag = "夢魔が主人公を脱衣"
          $msg.callsign = 7
          $msg.callsign = 17 if $game_switches[85] == true
        else
          $msg.tag = "夢魔がパートナーを脱衣"
          $msg.callsign = 27
          $msg.callsign = 37 if $game_switches[85] == true
        end
      elsif target.is_a?(Game_Enemy)
        if active == $game_actors[101]
          $msg.tag = "主人公が夢魔を脱衣"
          $msg.callsign = 7
          $msg.callsign = 17 if $game_switches[85] == true
        else
          $msg.tag = "パートナーが夢魔を脱衣"
          $msg.callsign = 27
          $msg.callsign = 37 if $game_switches[85] == true
        end
      end
    #トーク中の選択肢代わりレジスト
    elsif @skill.id == 10
      
    else
      $msg.talk_step = 1
      $msg.tag = "汎用レジスト"
    end
    # --------------------------------------------------------------
    # ★レジストアイコン個数設定
    # --------------------------------------------------------------
    # ■レベル差補正(同レベルなら修正は無い)
    # 夢魔のほうが高ければ無条件で＋１される
    # アクターのほうが３レベル以上高ければ、２レベルごとに－１される
    # --------------------------------------------------------------
    #■ホールド解除スキルは別処理となる
    #================================================================================================
    if @skill.name == "リリース" or @skill.name == "ストラグル"
    #================================================================================================
      n = 8
      #自分の有利度ぶん難易度が減少する
      if active.penis_intv != nil
        n -= active.penis_intv if target.hold.penis.battler == active
      end
      if active.vagina_intv != nil
        n -= active.vagina_intv if target.hold.vagina.battler == active
      end
      if active.mouth_intv != nil
        n -= active.mouth_intv if target.hold.mouth.battler == active
      end
      if active.anal_intv != nil
        n -= active.anal_intv if target.hold.anal.battler == active
      end
      if active.tops_intv != nil
        n -= active.tops_intv if target.hold.tops.battler == active
      end
      if active.tail_intv != nil
        n -= active.tail_intv if target.hold.tail.battler == active
      end
      if active.tentacle_intv != nil
        n -= active.tentacle_intv if target.hold.tentacle.battler == active
      end
      if active.dildo_intv != nil
        n -= active.dildo_intv if target.hold.dildo.battler == active
      end
#      p "イニチアチブ補正：#{n}"if $DEBUG
      #ステート・性格によって難易度が変動
#      n += 1 if not active.talkable? #クライシス・暴走など会話できないほど余裕が無い場合
#      n += 2 if active.dancing? #乱交状態の場合
      # 補正
      n += resist_correction(active, target) if active.is_a?(Game_Enemy)
      n -= resist_correction(active, target) if active.is_a?(Game_Actor)
      #性格によって難易度が変動
      case target.personality 
      when "内気","甘え性","倒錯","意地悪"
        n += 1
      #一部の性格の夢魔は引き剥がしやすい
      when "淡泊","天然","従順","陽気"
        n -= 1
      end
      #麻痺状態の場合、最大値・最小値が変動する(双方麻痺の場合は通常通り)
      if not (active.state?(39) and target.state?(39))
        n = 5 if n < 5 if active.state?(39) #行動側(アクター)が麻痺
        n = 4 if n > 4 if target.state?(39) #受動側(エネミー)が麻痺
      end
      #連続レジスト抵抗による難易度変化を行う
      n -= target.resist_count
      #最終調整
      n = 7 if n > 7
      n = 2 if n < 2
#      p "イニチアチブ補正後：#{n}"if $DEBUG
      #難易度代入
      #-------------------------------------------------------------------------------
      $game_temp.resistgame_difficulty = n
      return
    #================================================================================================
    elsif @skill.name == "インタラプト"
    #================================================================================================
      if active == $game_actors[101]
        for i in $game_party.actors
          if i != $game_actors[101]
            hold_actor = i
          end
        end
      else
        hold_actor = $game_actors[101]
      end
      n = 8
      #対象の有利度ぶん難易度が減少する
      if target.penis_intv != nil
        n -= target.penis_intv if target.hold.penis.battler == hold_actor
      end
      if target.vagina_intv != nil
        n -= target.vagina_intv if target.hold.vagina.battler == hold_actor
      end
      if target.mouth_intv != nil
        n -= target.mouth_intv if target.hold.mouth.battler == hold_actor
      end
      if target.anal_intv != nil
        n -= target.anal_intv if target.hold.anal.battler == hold_actor
      end
      if target.tops_intv != nil
        n -= target.tops_intv if target.hold.tops.battler == hold_actor
      end
      if target.tail_intv != nil
        n -= target.tail_intv if target.hold.tail.battler == hold_actor
      end
      if target.tentacle_intv != nil
        n -= target.tentacle_intv if target.hold.tentacle.battler == hold_actor
      end
      if target.dildo_intv != nil
        n -= target.dildo_intv if target.hold.dildo.battler == hold_actor
      end
#      p "イニチアチブ補正：#{n}"if $DEBUG
      #ステート・性格によって難易度が変動
#      n -= 1 if not target.talkable? #クライシス・暴走など会話できないほど余裕が無い場合
#      n -= 1 if target.dancing? #乱交状態の場合
      # 補正
      n += resist_correction(active, target) if active.is_a?(Game_Enemy)
      n -= resist_correction(active, target) if active.is_a?(Game_Actor)
      
      #性格によって難易度が変動
      case target.personality 
      when "内気","甘え性","倒錯","意地悪"
        n += 1
      #一部の性格の夢魔は引き剥がしやすい
      when "淡泊","天然","従順","陽気"
        n -= 1
      end
      #麻痺状態の場合、最大値・最小値が変動する(双方麻痺の場合は通常通り)
      if not (active.state?(39) and target.state?(39))
        n = 5 if n < 5 if active.state?(39) #行動側(アクター)が麻痺
        n = 4 if n > 4 if target.state?(39) #受動側(エネミー)が麻痺
      end
      # 連続レジスト抵抗による難易度変化を行う
      n -= target.resist_count
      #最終調整
      n = 7 if n > 7
      n = 2 if n < 2
#      p "イニチアチブ補正後：#{n}"if $DEBUG
      #難易度代入
      #-------------------------------------------------------------------------------
      $game_temp.resistgame_difficulty = n
      return
    end
    #================================================================================================
    # ■トーク選択肢レジストは別処理となる
    if @skill.id == 10
      n = 0
#      case $msg.tag
      $game_temp.resistgame_difficulty = 1
      # タイマーをセット
      $game_temp.resistgame_timer = 50
      return
    end
    #-------------------------------------------------------------------------------
    #■難易度算出
    #p "攻/#{attack_pow}：防/#{defense_pow}" if $DEBUG
    #-------------------------------------------------------------------------------
    #●基準値を呼び出す
    n = 0
    if active.is_a?(Game_Enemy)
      n += $mood.resist_rate(active)
      #●能動側の補正から受動側の補正を引いた値を難易度に加算
      n += resist_correction(active, target)
    elsif active.is_a?(Game_Actor)
      n += $mood.resist_rate(target)
      #●能動側の補正から受動側の補正を引いた値を難易度から減算
      n -= resist_correction(active, target)
    end
    #麻痺状態の場合、最大値・最小値が変動する(双方麻痺の場合は通常通り)
    if active.is_a?(Game_Enemy) and not (active.state?(39) and target.state?(39))
      n = 6 if n > 6 if active.state?(39) #行動側(エネミー)が麻痺は最大値を下げる
      n = 7 if n < 7 if target.state?(39) #受動側(アクター)が麻痺は最小値を上げる
    elsif active.is_a?(Game_Actor) and not (active.state?(39) and target.state?(39))
      n = 7 if n < 7 if active.state?(39) #行動側(アクター)が麻痺は最小値を上げる
      n = 6 if n > 6 if target.state?(39) #受動側(エネミー)が麻痺は最大値を下げる
    end
    # 強引のルーン、抵抗のルーンによる最大値変動
    n = 6 if n > 6 if active.is_a?(Game_Actor) and active.equip?("強引のルーン")
    n = 6 if n > 6 if target.is_a?(Game_Actor) and target.equip?("抵抗のルーン")
    #抵抗回数で難易度を増減
    n += (target.resist_count * 2) if active.is_a?(Game_Enemy)#抵抗回数を加算(回数が多いと成功しにくくなる)
    n -= (target.resist_count * 2) if active.is_a?(Game_Actor)#抵抗回数を減算(回数が多いと成功しやすくなる)
    #-------------------------------------------------------------------------------
    #■最大値・最小値補正(最大１０、最小３とする)
    #-------------------------------------------------------------------------------
    n = 10 if n > 10
    n = 3 if n < 3
    #-------------------------------------------------------------------------------
    #■難易度代入
    #-------------------------------------------------------------------------------
    $game_temp.resistgame_difficulty = n
    return
  end
  
  #--------------------------------------------------------------------------
  # ★ レジスト補正
  #--------------------------------------------------------------------------
  def resist_correction(active, target)
    n = 0
    attack_pow = 0
    defense_pow = 0
    #-------------------------------------------------------------------------------
    #■行動側の補正
    #-------------------------------------------------------------------------------
    #レベル補正
    attack_pow += 1 if active.level > target.level
    attack_pow += ((active.level - (target.level + 2)) / 2).ceil if active.level > (target.level + 2)
    #パラメータ補正
    attack_pow += 1 if (active.str > target.str) and @skill.element_set.include?(6) #ホールドレジスト
    attack_pow += 1 if (active.atk > target.atk) and @skill.element_set.include?(7) #誘惑レジスト
    attack_pow += 1 if (active.dex > target.agi) and @skill.element_set.include?(8) #物理レジスト
    #ステート補正(自分が有利なものはプラス、不利なものはマイナス)
    attack_pow += 1 if active.state?(41) #高揚(能動時は有利)
    attack_pow += 5 if active.state?(36) #暴走(能動時は有利)
    attack_pow -= 1 if active.state?(42) #沈着(能動時は不利)
    attack_pow -= 1 if active.state?(6) #クライシス(不利)
    attack_pow -= 5 if active.state?(34) #恍惚(不利)
    attack_pow -= 2 if active.state?(40) #散漫(不利)
    attack_pow -= 15 if active.weaken? #衰弱状態(不利)
    attack_pow -= 3 if active.state?(93) #防御中(能動時は不利)
    attack_pow -= 5 if active.state?(94) #大防御中(能動時は不利)
    attack_pow -= 2 if active.dancing? #２箇所以上ホールド(不利)
    attack_pow -= 1 if active.state?(13) #ディレイを受けている(不利)
    attack_pow -= 2 if $incense.exist?("威迫", active) #インセンス「威迫」（不利）
    # 味方のみ補正（装備品など）
    if active.is_a?(Game_Actor)
      attack_pow += 1  if active.equip?("凶暴性") #(有利)
      attack_pow += 3  if active.equip?("野蛮な者の首輪") #(有利)
      attack_pow -= 2  if active.equip?("淑女のカメオ") #(不利)
      attack_pow -= 10  if active.equip?("隷属の首輪") #(不利)
    end
    #ホールド補正(ペニス・アソコ・アナルを使うタイプの場合、潤滑度を参照する)
    if @skill.element_set.include?(6)
      attack_pow += [(active.lub_male / 15).floor,3].min if @skill.element_set.include?(95) #ペニスを使用するホールド
      attack_pow += [(active.lub_female / 15).floor,3].min if @skill.element_set.include?(97) #アソコを使用するホールド
      attack_pow += [(active.lub_anal / 15).floor,3].min if @skill.element_set.include?(94) #アナルを使用するホールド
      attack_pow += (($mood.point) / 30).floor #ムードが上がると有利
    end
    #-------------------------------------------------------------------------------
    #■受動側の補正
    #-------------------------------------------------------------------------------
    #レベル補正
    defense_pow += 1 if active.level < target.level
    defense_pow += ((target.level - (active.level + 2)) / 2).ceil if (active.level + 2) < target.level
    #パラメータ補正
    defense_pow += 1 if (active.str < target.str) and @skill.element_set.include?(6) #ホールドレジスト
    defense_pow += 1 if (active.atk < target.atk) and @skill.element_set.include?(7) #誘惑レジスト
    defense_pow += 1 if (active.dex < target.agi) and @skill.element_set.include?(8) #物理レジスト
    #ステート補正(自分が有利なものはプラス、不利なものはマイナス)
    defense_pow -= 1 if target.state?(41) #高揚(受動時は不利)
    defense_pow -= 5 if target.state?(36) #暴走(受動時は不利)
    defense_pow += 1 if target.state?(42) #沈着(受動時は有利)
    defense_pow -= 1 if target.state?(6) #クライシス(不利)
    defense_pow -= 15 if target.state?(34) #恍惚(不利)
    defense_pow -= 2 if target.state?(40) #散漫(不利)
    defense_pow -= 15 if target.state?(105) #拘束(不利)
    defense_pow -= 15 if target.weaken? #衰弱状態(不利)
    defense_pow += 3 if target.state?(93) #防御中(受動時のみ有利)
    defense_pow += 5 if target.state?(94) #大防御中(受動時のみ有利)
    defense_pow -= 2 if target.dancing? #２箇所以上ホールド(不利)
    defense_pow -= 1 if target.state?(13) #ディレイを受けている(不利)
    defense_pow -= 2 if $incense.exist?("威迫", target) #インセンス「威迫」（不利）
    # 味方のみ補正（装備品など）
    if active.is_a?(Game_Actor)
      defense_pow -= 2  if active.equip?("淑女のカメオ") #(不利)
      defense_pow -= 10  if active.equip?("隷属の首輪") #(不利)
    end
    #ホールド補正(ペニス・アソコ・アナルを使うタイプの場合、潤滑度を参照する)
    if @skill.element_set.include?(6)
      #拘束タイプ・挿入タイプでそれぞれベースの難易度を加算する
      defense_pow += 5 if @skill.element_set.include?(134) #挿入タイプは難易度が高い
      defense_pow += 4 if @skill.element_set.include?(135) #拘束タイプは難易度が低い
      defense_pow -= [(target.lub_male / 15).floor,3].min if @skill.element_set.include?(74) #ペニスを対象にするホールド
      defense_pow -= [(target.lub_female / 15).floor,3].min if @skill.element_set.include?(75) #アソコを対象にするホールド
      defense_pow -= [(target.lub_anal / 15).floor,3].min if @skill.element_set.include?(76) #アナルを対象にするホールド
      defense_pow -= (($mood.point) / 30).floor #ムードが上がると不利
    end
    # 減算して補正値を確定して返す
    n = attack_pow - defense_pow
    return n
  end
  
end