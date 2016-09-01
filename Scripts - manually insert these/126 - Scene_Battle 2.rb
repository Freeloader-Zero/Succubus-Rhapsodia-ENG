#==============================================================================
# ■ Scene_Battle (分割定義 2)
#------------------------------------------------------------------------------
# 　バトル画面の処理を行うクラスです。
#==============================================================================

class Scene_Battle
  #--------------------------------------------------------------------------
  # ★ スタートフェーズ開始
  #--------------------------------------------------------------------------
  def start_phase0
    # フェーズ 1 に移行
    @phase = 0
    
    #--------------------------------------------------------------------------
    # ★トループエネミーの表示
    
    # バトルログウィンドウを出す
    @battle_log_window.visible = true
    @battle_log_window.bgframe_sprite.visible = true
    # トループの初期人数を数える
    n = $game_troop.enemies.size
    for i in 1...$game_troop.enemies.size
      if $game_troop.enemies[i].hidden == true
        n -= 1
      end
    end 
    # 初期人数が２人以上の場合、「～たち」をつける。
    unless n > 1 
      text = $game_troop.enemies[0].name + " has appeared!"
    else
      if n == 2
      text = "A pair of succubi have appeared!"
      else
      text = "A group of succubi have appeared!"
      end
    end
    $game_temp.battle_log_text += text + "\067"
    #▼システムウェイト
    case $game_system.ms_skip_mode
    when 3 #手動送りモード
      @wait_count = 1
    when 2 #デバッグモード
      @wait_count = 8
    when 1 #快速モード
      @wait_count = 12
    else
      @wait_count = $game_system.battle_speed_time(0) + $game_system.important_wait_time
    end
    
=begin    
    @appear_turns = []
    for enemy in $game_troop.enemies.reverse
      if enemy.exist?
        @appear_turns.push(enemy) 
      end
    end
=end
    #--------------------------------------------------------------------------
    @phase0_step = 1
  end
  
  #--------------------------------------------------------------------------
  # ★ スタートフェーズ　フレーム更新
  #--------------------------------------------------------------------------
  def update_phase0
    # 最初の夢魔表示中の時は更新を止める
    for enemy in $game_troop.enemies
      return if enemy.start_appear == true
    end
    
    case @phase0_step
    when 1
      update_phase0_step1
    when 2
      update_phase0_step2
    when 3
      update_phase0_step3
    end
  end
  #--------------------------------------------------------------------------
  # ★ スタートフェーズ　フレーム更新　ステップ１：先攻後攻ログ
  #--------------------------------------------------------------------------
  def update_phase0_step1
    # @phase0_step2_count ごとに順番に戦闘前処理を行う
    
    # ★先攻を取った
    if $game_temp.first_attack_flag == 1
      #アクターのファーストアタックフラグを立てる
      @actor_first_attack = true
      @enemy_first_attack = false
      @battle_log_window.contents.clear
      @battle_log_window.keep_flag = false
      $game_temp.battle_log_text = ""
      if $game_party.actors.size == 1
        $game_temp.battle_log_text += $game_actors[101].name + " has the initiative!\067"
      else
        $game_temp.battle_log_text += $game_actors[101].name + " has the initiative!\067"
      end
      #▼システムウェイト
      case $game_system.ms_skip_mode
      when 3 #手動送りモード
        @wait_count = 1
      when 2 #デバッグモード
        @wait_count = 8
      when 1 #快速モード
        @wait_count = 12
      else
        @wait_count = $game_system.battle_speed_time(0) + $game_system.important_wait_time
      end
    end
 
    # ★先手を取られた
    if $game_temp.first_attack_flag == 2
      #エネミーのファーストアタックフラグを立てる
      @actor_first_attack = false
      @enemy_first_attack = true
      @battle_log_window.contents.clear
      @battle_log_window.keep_flag = false
      $game_temp.battle_log_text = ""
      if $game_party.actors.size == 1
        $game_temp.battle_log_text += $game_actors[101].name + " had the initiative taken by the eneｍy!\067"
      else
        $game_temp.battle_log_text += $game_actors[101].name + " had the initiative taken by the eneｍy!\067"
      end
      #▼システムウェイト
      case $game_system.ms_skip_mode
      when 3 #手動送りモード
        @wait_count = 1
      when 2 #デバッグモード
        @wait_count = 8
      when 1 #快速モード
        @wait_count = 12
      else
        @wait_count = $game_system.battle_speed_time(0) + $game_system.important_wait_time
      end
    end

    
    @phase0_step = 2
    @phase0_step2_count = 0
  end
  #--------------------------------------------------------------------------
  # ★ スタートフェーズ　フレーム更新　ステップ１：戦闘前処理
  #--------------------------------------------------------------------------
  def update_phase0_step2

    @battle_log_window.contents.clear
    @battle_log_window.keep_flag = false
    $game_temp.battle_log_text = ""

    # バトルイベント
    if @phase0_step2_count == 0
      @phase0_step2_count = 1
      # バトルイベントのセットアップ
      setup_battle_event
      return
    end
    # バトルイベント実行中の場合
    if $game_system.battle_interpreter.running?
      return
    end
    # 出現時エフェクトの指示を出す
    appear_effect_order(@battlers)
    # フェイズを進める
    @phase0_step = 3
  end
  #--------------------------------------------------------------------------
  # ★ スタートフェーズ　フレーム更新　ステップ３：終了処理　
  #--------------------------------------------------------------------------
  def update_phase0_step3
    #○戦闘開始口上がある場合は表示する
    # 全バトラーのリセット
    
    # 戦闘前口上無しスイッチがＯＦＦならば戦闘前口上を呼び出せるようにする
    if $game_switches[59]
      # ＯＮの場合はスイッチを切って終了する。
      $game_switches[59] = false
    else
      #●特殊戦闘時に会話フラグを立てる
      #★詳細表示中は必ず全て表示
      if $game_switches[95] == true
        #対象事前選定済みトークステップを設定
        $msg.callsign = 40
        $msg.tag = "戦闘開始"
        common_event = $data_common_events[69]
        $game_system.battle_interpreter.setup(common_event.list, 0)
      #★簡易表示中は、ベッドインとボス戦以外を表示しない
      elsif $game_switches[96] == true
        #ベッドイン戦闘時
        if ($game_switches[85] == true or
        #ボス戦時
          $game_switches[91] == true)
          #対象事前選定済みトークステップを設定
          $msg.callsign = 40
          $msg.tag = "戦闘開始"
          common_event = $data_common_events[69]
          $game_system.battle_interpreter.setup(common_event.list, 0)
        end
      #★通常時はベッドイン、ボス戦、空腹時、ＯＦＥ、レア出現時に表示する
      else 
        #ベッドイン戦闘時
        if ($game_switches[85] == true or
        #空腹戦闘時
          $game_switches[86] == true or
        #ボス戦時
          $game_switches[91] == true or
        #OFE戦時
          $game_switches[92] == true or
        #レア出現戦闘時
          $game_switches[93] == true)
          #対象事前選定済みトークステップを設定
          $msg.callsign = 40
          $msg.tag = "戦闘開始"
          common_event = $data_common_events[69]
          $game_system.battle_interpreter.setup(common_event.list, 0)
        end
      end
    end
    start_phase1
  end

  #--------------------------------------------------------------------------
  # ● プレバトルフェーズ開始
  #--------------------------------------------------------------------------
  def start_phase1
    # フェーズ 1 に移行
    @phase = 1
    # パーティ全員のアクションをクリア
    $game_party.clear_actions

    # ★バトルログをクリア
    @battle_log_window.contents.clear
    @battle_log_window.keep_flag = false   
    
    # ★先手を取られた
    if $game_temp.first_attack_flag == 2
      start_phase4
    end
    
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新 (プレバトルフェーズ)
  #--------------------------------------------------------------------------
  def update_phase1
    
    # 勝敗判定
    if judge
      # 勝利または敗北の場合 : メソッド終了
      return
    end

    
    # パーティコマンドフェーズ開始
    start_phase2
  end
  #--------------------------------------------------------------------------
  # ● パーティコマンドフェーズ開始
  #--------------------------------------------------------------------------
  def start_phase2
    # フェーズ 2 に移行
    @phase = 2
    # アクターを非選択状態に設定
    @actor_index = -1
    @active_battler = nil

    # ★バトルログウィンドウを消す
    @battle_log_window.contents.clear
    @battle_log_window.keep_flag = false
    @battle_log_window.visible = false
    @battle_log_window.bgframe_sprite.visible = false
    $game_temp.battle_log_text = ""
    
    # ★エネミーの表示状態の変更
    # 先頭の存在している夢魔を選ぶ。
    select_enemy = nil
    for enemy in $game_troop.enemies
      if enemy.exist?
        select_enemy = enemy
        break
      end
    end
    enemies_display(select_enemy) if select_enemy != nil
      
#    # パーティコマンドウィンドウを有効化
#    @party_command_window.active = true
#    @party_command_window.visible = true
#    # アクターコマンドウィンドウを無効化
#     command_all_delete
#★    @actor_command_window.active = false
#★    @actor_command_window.visible = false
    # メインフェーズフラグをクリア
    $game_temp.battle_main_phase = false
    # パーティ全員のアクションをクリア
    $game_party.clear_actions
    # コマンド入力不可能な場合
    unless $game_party.inputable?
      # メインフェーズ開始
      start_phase4
    end
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新 (パーティコマンドフェーズ)
  #--------------------------------------------------------------------------
  def update_phase2
    
    start_phase3 #★
    
    
#    # C ボタンが押された場合
#    if Input.trigger?(Input::C)
#      # パーティコマンドウィンドウのカーソル位置で分岐
#      case @party_command_window.index
#      when 0  # 戦う
#        # 決定 SE を演奏
#        $game_system.se_play($data_system.decision_se)
#        # アクターコマンドフェーズ開始
#        start_phase3
#      when 1  # 逃げる
#        # 逃走可能ではない場合
#        if $game_temp.battle_can_escape == false
#          # ブザー SE を演奏
#         $game_system.se_play($data_system.buzzer_se)
#        return
#      end
#        # 決定 SE を演奏
#      $game_system.se_play($data_system.decision_se)
#        # 逃走処理
#     update_phase2_escape
#     end
#     return
#   end
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新 (パーティコマンドフェーズ : 逃げる)
  #--------------------------------------------------------------------------
  def update_phase2_escape
    # エネミーの素早さ平均値を計算
    enemies_agi = 0
    enemies_number = 0
    for enemy in $game_troop.enemies
      if enemy.exist?
        enemies_agi += enemy.agi
        enemies_number += 1
      end
    end
    if enemies_number > 0
      enemies_agi /= enemies_number
    end
    # アクターの素早さ平均値を計算
    actors_agi = 0
    actors_number = 0
    for actor in $game_party.actors
      if actor.exist?
        actors_agi += actor.agi
        actors_number += 1
      end
    end
    if actors_number > 0
      actors_agi /= actors_number
    end
    # 逃走成功判定
    success = rand(100) < 50 * actors_agi / enemies_agi
    # 逃走成功の場合
    if success
      # 逃走 SE を演奏
      $game_system.se_play($data_system.escape_se)
      # バトル開始前の BGM に戻す
      $game_system.bgm_play($game_temp.map_bgm)
      # バトル終了
      battle_end(1)
    # 逃走失敗の場合
    else
      # パーティ全員のアクションをクリア
      $game_party.clear_actions
      # メインフェーズ開始
      start_phase4
    end
  end
  #--------------------------------------------------------------------------
  # ● アフターバトルフェーズ開始
  #--------------------------------------------------------------------------
  def start_phase5
    # フェーズ 5 に移行
    @phase = 5
    # ファンファーレオフが無い場合、バトル終了 ME を演奏
    unless @fanfare_off
      $game_system.me_play($game_system.battle_end_me) 
    end
    # 契約夢魔がいるかのチェック
    contract_check
    if $game_temp.contract_enemy == nil
      # バトル開始前の BGM に戻す
      $game_system.bgm_play($game_temp.map_bgm)
    else
      # 契約夢魔がいる場合は BGM を消す
      $game_system.bgm_play(nil)
    end
    # ★バトルログウィンドウを出す
    @battle_log_window.visible = true
    @battle_log_window.bgframe_sprite.visible = true
    n = $game_troop.enemies_dead_count
    # 人数が２人以上の場合、「～たち」をつける。
    if n > 1
      if $game_switches[85] == true
        $game_temp.battle_log_text = "The eneｍy succubi have been satisfied!"
      else
        $game_temp.battle_log_text = "The eneｍy succubi have been repelled! "
      end
    else
      if $game_switches[85] == true
        $game_temp.battle_log_text = "The eneｍy succubus has been satisfied!"
      else
        $game_temp.battle_log_text = "The eneｍy succubus has been repelled! "
      end
    end
    # ●アクターとエネミーのレベル差分を算出する(封印中)
#    level_f = a_level = e_level = ect = 0
#    for actor in $game_party.party_actors
#      a_level += actor.level
#    end
#    a_level = (a_level / $game_party.party_actors.size).ceil
    # EXP、ゴールド、トレジャーを初期化
    exp = 0
    gold = 0
    treasures = []
    # ループ
    for enemy in $game_troop.enemies
      # エネミーが隠れ状態でない場合
      unless enemy.hidden
        #★ベッドイン時は、終了と同時にベッドイン回数を加算する
        if $game_switches[85] == true
          enemy.bedin_count = 0 if enemy.bedin_count == nil
          enemy.bedin_count += 1
        end
        exp += enemy.exp + ((enemy.exp / 3) * $game_party.after_battle_bonus(0))
        gold += enemy.gold + ((enemy.gold / 3) * $game_party.after_battle_bonus(1))
        # トレジャー出現判定
        if rand(100) < enemy.treasure_prob + (3 * $game_party.after_battle_bonus(2))
          if enemy.item_id > 0
            treasures.push($data_items[enemy.item_id])
          end
          if enemy.weapon_id > 0
            treasures.push($data_weapons[enemy.weapon_id])
          end
          if enemy.armor_id > 0
            treasures.push($data_armors[enemy.armor_id])
          end
        end
        # ★トレジャー出現判定 
        if enemy.treasure != []
          for treasure in enemy.treasure
            if rand(100) < treasure[2] + $game_party.after_battle_bonus(2)
              case treasure[0]
              when 0
                treasures.push($data_items[treasure[1]])
              when 1
                treasures.push($data_weapons[treasure[1]])
              when 2
                treasures.push($data_armors[treasure[1]])
              end
            end
          end
        end        
        
      end
    end
    # トレジャーの数を 6 個までに限定
    treasures = treasures[0..5]
#    p "初期経験値：#{exp}"
    # 対複数戦で経験値アップ
    annihilation_rate = $game_troop.enemies_dead_count - 1 
    annihilation_rate = (annihilation_rate * 0.2) + 1.0
    exp = (exp * annihilation_rate).truncate
#    p "殲滅補正有り：#{exp}"
    # レアトループの場合、経験値を上げる。
    exp = (exp * 1.5).truncate if $game_switches[93]
    # 不幸状態の場合、経験値を上げる。
    exp = (exp * 1.5).truncate if $game_party.unlucky?
#    p "レアトループ補正有り：#{exp}"
    # EXP 獲得
    
    for i in 0...$game_party.party_actors.size
      actor = $game_party.party_actors[i]
      actor.exp_plus_flag = false
      if actor.cant_get_exp? == false
        last_level = actor.level
        temp_exp = exp
        if actor.equip?("強き者の指輪")
          temp_exp = (temp_exp * 1.5).truncate 
          actor.exp_plus_flag = true
        end
        # ジャイアントキリング補正
        if $game_troop.enemies_max_level > actor.level + 4
          giant_killing_rate = $game_troop.enemies_max_level - actor.level - 4
          giant_killing_rate = (giant_killing_rate * 0.2) + 1.0
          temp_exp = (temp_exp * giant_killing_rate).truncate
          actor.exp_plus_flag = true
        end
#        p "最終取得経験値：#{temp_exp}"
        actor.exp += temp_exp
        # レベルアップフラグを立てる
        if actor.level > last_level
          @status_window.level_up(i)
        end
      end
    end
    # ゴールド獲得
    $game_party.gain_gold(gold)
    # トレジャー獲得
    for item in treasures
      case item
      when RPG::Item
        $game_party.gain_item(item.id, 1)
      when RPG::Weapon
        $game_party.gain_weapon(item.id, 1)
      when RPG::Armor
        $game_party.gain_armor(item.id, 1)
      end
    end
    
    # ヒーリング処理　
    $game_party.healing
    
    # バトルリザルトウィンドウを作成
    @result_window = Window_BattleResult.new(exp, gold, treasures)
    # ウェイトカウントを設定
    if Input.press?(Input::CTRL) and ($DEBUG or $game_switches[46])
      @phase5_wait_count = 50
    else
      @phase5_wait_count = 80
    end
  end

  #--------------------------------------------------------------------------
  # ● フレーム更新 (アフターバトルフェーズ)
  #--------------------------------------------------------------------------
  def update_phase5
    # ウェイトカウントが 0 より大きい場合
    if @phase5_wait_count > 0
      # ウェイトカウントを減らす
      @phase5_wait_count -= 1
      # ウェイトカウントが 0 になった場合
      if @phase5_wait_count == 0
        # リザルトウィンドウを表示
        @result_window.visible = true
        # メインフェーズフラグをクリア
        $game_temp.battle_main_phase = false
        # レベルアップナレート
        text = ""
        up_flag = false
        for a in $game_party.party_actors
          # 多めに貰ったナレート
          if a.exp_plus_flag == true
            text += "\065\067#{a.name} received ｍore experience than usual!"
            a.exp_plus_flag = false
          end
          text += a.level_up_log
          a.level_up_log = ""
          up_flag = true if text != ""
        end
#        $game_temp.battle_log_text += "\065\n" + text + "\065\065" if text != ""
        $game_temp.battle_log_text += text + "\065\065" if text != ""
        
        # その他戦闘後処理のチェック
        for actor in $game_party.party_actors
          if actor.equip?("ワイルドカード")
            actor.armor1_id = 0
            text = "\065\067#{actor.name}'s eｑuipped \065\nWild Card has disappeared....."
            $game_temp.battle_log_text += text
          end
          if actor.equip?("手作りミサンガ")
            # ５％以下でミサンガが切れる。
            if rand(100) < 5
              actor.armor1_id = 0
              actor.promise += 500
              text = "\065\067#{actor.name}'s eｑuipped \nHoｍeｍade Misanga broke!"
              $game_temp.battle_log_text += text
            end
          end
        end
        
        # ▼システムウェイト
        if $game_system.system_read_mode == 0
          @wait_count = system_wait_make($game_temp.battle_log_text)
        end
        # ステータスウィンドウをリフレッシュ
        @status_window.refresh
      end
      return
    end
    
    
    # C ボタンが押された場合
    if Input.trigger?(Input::C) or (Input.press?(Input::CTRL) and ($DEBUG or $game_switches[46]))
      if $game_temp.contract_enemy != nil
        start_phase6
      else
        # バトル終了
        battle_end(0)
      end
    end
  end
  #--------------------------------------------------------------------------
  # ● 契約フェーズ開始
  #--------------------------------------------------------------------------
  def start_phase6
    # フェーズ 6 に移行
    @phase = 6

    # リザルトウィンドウを消す
    @result_window.visible = false
    # ★バトルログウィンドウをクリア
    @battle_log_window.contents.clear
    @battle_log_window.keep_flag = false
    $game_temp.battle_log_text = ""
    
    enemy = $game_temp.contract_enemy
    @contract = Sprite.new
    bitmap =RPG::Cache.battler(enemy.battler_name, enemy.battler_hue)
    @contract.bitmap = bitmap

    @contract.ox = @contract.bitmap.width / 2
    @contract.oy = @contract.bitmap.height / 2

    @contract.x = 640 / 2
    @contract.y = 480 / 2
    @contract.visible = true
    @contract.opacity = 0
    Audio.se_play("Audio/SE/136-Light02", 80, 100)
    
    @event_switch = false

   
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新 (アフターバトルフェーズ)
  #--------------------------------------------------------------------------
  def update_phase6 
    
    if @contract.opacity < 255
      @contract.opacity += 10
      return
    end
    
    if @event_switch == false
      # コモンイベント「契約フェーズ」を実行
      common_event = $data_common_events[28]
      $game_system.battle_interpreter.setup(common_event.list, 0)
      @event_switch = true
    end
    
    # バトルイベント実行中の場合
    if $game_system.battle_interpreter.running?
      return
    end
    
    # C ボタンが押された場合
#    if Input.trigger?(Input::C)
      # バトル開始前の BGM に戻す
      $game_system.bgm_play($game_temp.map_bgm)
      # バトル終了
      battle_end(0)
#    end
  end

  #--------------------------------------------------------------------------
  # ● 契約チェック
  #--------------------------------------------------------------------------
  def contract_check
    # 契約夢魔の初期化
    $game_temp.contract_enemy == nil
    # 味方戦なら終了
    if $game_switches[85] or $game_switches[86] or $game_temp.absolute_contract == 2
      return
    end
    # パーティもボックスも埋まっている場合も終了
    if $game_party.box_max == $game_party.home_actors
      return
    end
    # 最後に残った夢魔の友好度が100に到達している場合
    if @last_enemies[0].friendly >= 100
      # 贈り物カウントがある場合は無条件
      if @last_enemies[0].present_count > 0
        $game_temp.absolute_contract = 1
      # トーク回数が限界数に達していた場合も無条件
      elsif @last_enemies[0].pillowtalk >= 3
        $game_temp.absolute_contract = 1
      end
    # 友好度100未満だが50を越えている場合
    elsif @last_enemies[0].friendly >= 50
      # 贈り物カウントが１回以上ある場合は別カウント
      if @last_enemies[0].present_count > 0
        perc = (@last_enemies[0].present_count * 30)
        #レベル差分を適用(主人公のほうがレベルが高ければ追加補正となる)
        perc -= (@last_enemies[0].level - $game_actors[101].level) * 2
        if rand(100) < perc
          $game_temp.absolute_contract = 1
        end
      end
    # 友好度50に到達していない場合
    else
      # 贈り物カウントが１回以上ある場合は別カウント
      if @last_enemies[0].present_count > 0
        perc = (@last_enemies[0].present_count * 10)
        #レベル差分を適用(主人公のほうがレベルが高ければ追加補正となる)
        perc -= (@last_enemies[0].level - $game_actors[101].level) * 2
        if rand(100) < perc
          $game_temp.absolute_contract = 1
        end
      end
    end
    # ここから通常処理
    # 最後に残った夢魔の友好度＋ムードが乱数以内ならば契約可能に
    per = @last_enemies[0].friendly * $mood.point / 50
    # ロウラットのレベルを超えている場合、差に比例して確率を減少させる
    if $game_actors[101].level < @last_enemies[0].level
      lv_rate = (@last_enemies[0].level - $game_actors[101].level) * 3
    else
      lv_rate = 0
    end
    per -= lv_rate
    #契約予定の夢魔と会話も贈り物もしなかった場合、確率が激減する
    if @last_enemies[0].pillowtalk == 0 and @last_enemies[0].present_count == 0
      per /= 10
    end
    # パーセント最大値は100
    per = [per,100].min
    # レベルの半分は失敗率が現れる。
    per -= @last_enemies[0].level / 2
    # 戦闘に出ているメンバーの補正でごまかせる
    for actor in $game_party.battle_actors
      per += 10 if actor.equip?("友好のメダル")
      per += 10 if actor.have_ability?("カリスマ")
    end
    
    c = rand(100)
    if per >= c
      $game_temp.contract_enemy = @last_enemies[0]
    end
    # 確定契約フラグが立ってるなら確定で入れる
    if $game_temp.absolute_contract == 1
      $game_temp.contract_enemy = @last_enemies[0]
    end
  end
end