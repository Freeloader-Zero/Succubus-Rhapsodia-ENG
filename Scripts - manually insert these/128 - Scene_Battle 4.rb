#==============================================================================
# ■ Scene_Battle (分割定義 4)
#------------------------------------------------------------------------------
# 　バトル画面の処理を行うクラスです。
#==============================================================================

class Scene_Battle
  
  #--------------------------------------------------------------------------
  # ● ホールドポップの出現・非出現
  #--------------------------------------------------------------------------
  def hold_pops_display_check(bool)

    # それぞれのバトラーに表示フラグを立てる。
    for battler in $game_party.battle_actors + $game_troop.enemies
      battler.hold_pops_fade = 1 if bool
      battler.hold_pops_fade = 2 unless bool
    end
  end
  #--------------------------------------------------------------------------
  # ● メインフェーズ開始
  #--------------------------------------------------------------------------
  def start_phase4
    # フェーズ 4 に移行
    @phase = 4
    # ターン数カウント
    $game_temp.battle_turn += 1
    # バトルイベントの全ページを検索
    for index in 0...$data_troops[@troop_id].pages.size
      # イベントページを取得
      page = $data_troops[@troop_id].pages[index]
      # このページのスパンが [ターン] の場合
      if page.span == 1
        # 実行済みフラグをクリア
        $game_temp.battle_event_flags[index] = false
      end
    end
    # アクターを非選択状態に設定
    @actor_index = -1
    @active_battler = nil
    
    # ホールドポップを非表示にする。
    hold_pops_display_check(false) if @hold_pops_display
    @hold_pops_display = false
      
    #口上管理系スイッチを切っておく
    for i in 23..24
      $game_switches[i] = false
    end
    for i in 77..83
      $game_switches[i] = false
    end
    $game_switches[89] = false #レジスト受諾スイッチ
    
    # メッセージ表示位置変更を戻す
    $game_temp.in_battle_change = false
    
    # パーティコマンドウィンドウを有効化
#    @party_command_window.active = false
#    @party_command_window.visible = false
    # アクターコマンドウィンドウを無効化
    command_all_delete
#    @actor_command_window.active = false
#    @actor_command_window.visible = false
    # メインフェーズフラグをセット
    $game_temp.battle_main_phase = true
    
    #●バトルトーク関連をリセット
    $game_temp.action_num = 0
    #アクターの暴走フラグを解除(控え含む)
    for actor in $game_party.actors
      #●暴走フラグを解除
      if actor.berserk == true and not actor.state?(36)
        actor.berserk = false
      elsif actor.berserk == false and actor.state?(36)
        actor.berserk = true
      end
    end
    # エネミーアクション作成
    for enemy in $game_troop.enemies
      #●暴走フラグを解除
      if enemy.berserk == true and not enemy.state?(36)
        enemy.berserk = false
      end
      enemy.another_action = false
      enemy_action_swicthes(enemy)
      enemy.make_action
    end
    # エネミーの多重行動フラグを解除
    for enemy in $game_troop.enemies
#      enemy.another_action = false # 上に移動
    end
    
    # アクターの使用ターンに掛かるスキルエフェクト
    for actor in $game_party.battle_actors
      if actor.exist? and actor.current_action.kind == 1
        # 属性：ターン中ガード効果
        if $data_skills[actor.current_action.skill_id].element_set.include?(197)
          # ガードステートを付ける
          actor.add_state(93)
          actor.add_states_log.clear
        end
      end
    end
    
    
    
    # ★バトルログウィンドウをフェードイン開始座標に
    @battle_log_window.bgframe_sprite.opacity = 0
    @battle_log_window.bgframe_sprite.y = -12
    
    # 行動順序作成
    make_action_orders
    
    # 先手を取られた場合
    if $game_temp.first_attack_flag == 2
      # アクターを配列 @action_battlers から削除
      for actor in $game_party.actors
        @action_battlers.delete(actor)
      end
#      $game_temp.first_attack_flag = 0
    elsif $game_temp.first_attack_flag == 1
      # エネミーを配列 @action_battlers から削除
      for enemy in $game_troop.enemies
        @action_battlers.delete(enemy)
      end
#      $game_temp.first_attack_flag = 0
    end
    #########################################################
    @self_data = ""          #その時の行動者の情報
    @target_data = ""        #その時の攻撃対象の情報
    @free_text = ""          #文字列作成用のメモ帳
    
    @battle_log_window.visible = false
    #@battle_log_window.set_text($game_temp.battle_turn.to_s + "ターン目 開始")
    #@wait_count = 60
    #p $game_temp.battle_turn.to_s + "ターン目 開始"
    #########################################################
    @wait_count = 5
    # ステップ 1 に移行
    @phase4_step = 0
  end
  #--------------------------------------------------------------------------
  # ● 行動順序作成
  #--------------------------------------------------------------------------
  def make_action_orders
    # 配列 @action_battlers を初期化
    @action_battlers = []
    # エネミーを配列 @action_battlers に追加
    # 多重行動用に２枠追加する(暴走中、畏怖行動中は１枠のみ)
    for enemy in $game_troop.enemies
      @action_battlers.push(enemy)
      if enemy.berserk == false 
        @action_battlers.push(enemy)
      end
    end
    # アクターを配列 @action_battlers に追加
    for actor in $game_party.actors
      @action_battlers.push(actor)
    end
    # 全員のアクションスピードを決定
    for battler in @action_battlers
      battler.make_action_speed
    end
    # アクションスピードの大きい順に並び替え
    @action_battlers.sort! {|a,b|
      b.current_action.speed - a.current_action.speed }
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新 (メインフェーズ)
  #--------------------------------------------------------------------------
  def update_phase4
    case @phase4_step
    when 0 # ★ターン開始時処理
      update_phase4_step0
    when 101 # ★クライシス報告
      update_phase4_step101
    when 102 # ★ステート継続報告
      update_phase4_step102
    when 104 # ★インセンス継続報告
      update_phase4_step104
    when 1
      update_phase4_step1
    when 103 # ★ターン終了処理
      update_phase4_step103
    when 105 # ★援護行動
      update_phase4_step105
    when 2
      update_phase4_step2
    when 3
      update_phase4_step3
    when 4
      update_phase4_step4
    when 401 #クライシス処理
      update_phase4_step401
    when 402 #途中会話処理
      update_phase4_step402
    when 5
      update_phase4_step5
    when 501 #★絶頂ステップ前半
      update_phase4_step501
    when 502 #★絶頂ステップ後半
      update_phase4_step502
    when 503 #★ホールド解除
      update_phase4_step503
    when 504 #★アクター入れ替え処理(戦闘不能時)
      update_phase4_step504
    when 601 #★追撃判定
      update_phase4_step601
    when 602 # ★絶頂時処理
      update_phase4_step602
    when 6
      update_phase4_step6
    when 12 # ★レジストゲーム開始
      update_phase4_step12
    when 13 # ★レジスト成否の結果作成 
      update_phase4_step13
    end
  end
  #--------------------------------------------------------------------------
  # ★ フレーム更新 (メインフェーズ ステップ 0 : ターン開始時処理)
  #--------------------------------------------------------------------------
  def update_phase4_step0
    
    # ヘルプウィンドウを隠す
    @help_window.visible = false
    # ★バトルログウィンドウを出す
    @battle_log_window.visible = true
    @battle_log_window.bgframe_sprite.visible = true

    text = ""
    txc = 0
    # クライシス報告メッセージ表示
    for actor in $game_party.battle_actors
      if actor.exist? and actor.state?(6)
        text += $data_states[6].message($data_states[6], "report", actor, nil) + "\w\q"
        txc += 1
      end
    end
    for enemy in $game_troop.enemies
      if enemy.exist? and enemy.state?(6)
        text += $data_states[6].message($data_states[6], "report", enemy, nil) + "\w\q"
        txc += 1
      end
    end
    if text != ""
      #▼システムウェイト
      case $game_system.ms_skip_mode
      when 3 #手動送りモード
        @wait_count = (txc + 1) * 4
      when 2 #デバッグモード
        @wait_count = 8
      when 1 #快速モード
        @wait_count = 12
      else
        @wait_count = $game_system.battle_speed_time(0) + $game_system.important_wait_time + (txc * (4 + 1))
      end
      if $game_system.system_read_mode != 0
        text += "CLEAR"
        text.sub!("\w\qCLEAR","")
      end
      $game_temp.battle_log_text += text if text != ""
    end
    
    
    # ステップ 1 に移行
    @phase4_step = 101
  end  
  #--------------------------------------------------------------------------
  # ★ フレーム更新 (メインフェーズ ステップ 101 : ステート継続メッセージ)
  #--------------------------------------------------------------------------
  def update_phase4_step101
    # バトルログをクリア
    @battle_log_window.contents.clear
    @battle_log_window.keep_flag = false
    $game_temp.battle_log_text = ""
    ms = text = text1 = text2 = ""
    txc = 0
    for actor in $game_party.battle_actors
      if actor.exist? and not actor.dead?
#        actor.remove_states_auto
        ms = actor.bms_states_report
        text1 = (text1 + ms + "\w\q") if ms != ""
        txc += 1 if ms != ""
      end
    end
    ms = ms2 = ""
    for enemy in $game_troop.enemies
      if enemy.exist?
#        enemy.remove_states_auto
        ms = enemy.bms_states_report
        text2 = (text2 + ms + "\w\q") if ms != ""
        txc += 1 if ms != ""
      end
    end
#    text2.sub!("\w\q\w\n\w\n\w\n\w\n","\w\n") if text2.include?("\w\n\w\n\w\n\w\n\w\n")
    text = text1 + text2
    if text != ""
=begin
      #▼システムウェイト
      case $game_system.ms_skip_mode
      when 3 #手動送りモード
        @wait_count = (txc + 1) * 4
      when 2 #デバッグモード
        @wait_count = 8
      when 1 #快速モード
        @wait_count = 12
      else
        # ステート関係はステートの数だけウェイトを加算
        @wait_count = $game_system.battle_speed_time(0) + $game_system.important_wait_time + (txc * (4 + 1))
      end
=end
      if $game_system.system_read_mode != 0
        text += "CLEAR"
        text.sub!("\w\qCLEAR","")
      end
      $game_temp.battle_log_text += text
      #▼システムウェイト
      @wait_count = system_wait_make($game_temp.battle_log_text)
    end
    # 全バトラーのステートログをすべてクリア
    for battler in @battlers
      battler.add_states_log.clear
      battler.remove_states_log.clear
    end
    # 画像変更フラグを立てて画像をリフレッシュ
    for enemy in $game_troop.enemies
      if enemy.exist?
        enemy.graphic_change = true
      end
    end
    for actor in $game_party.party_actors
      if actor.exist?
        actor.graphic_change = true
      end
    end
    # ステップ 102 に移行
    @phase4_step = 102
  end  
  #--------------------------------------------------------------------------
  # ★ フレーム更新 (メインフェーズ ステップ 102 : ステート変化メッセージ)
  #   （ほぼ淫毒専用）
  #--------------------------------------------------------------------------
  def update_phase4_step102
    # バトルログをクリア
    @battle_log_window.contents.clear
    @battle_log_window.keep_flag = false
    $game_temp.battle_log_text = ""
    ms = text = text1 = text2 = ""
    txc = 0
    for actor in $game_party.battle_actors
      if actor.exist? and not actor.dead?
        special_mushroom_effect(actor) if actor.state?(30) #淫毒併発
        #actor.persona_break if actor.state?(106) #破面併発
        
#        actor.remove_states_auto
        ms = actor.bms_states_update
        text1 = (text1 + ms + "\w\q") if ms != ""
        txc += 1 if ms != ""
      end
    end
    ms = ms2 = ""
    for enemy in $game_troop.enemies
      if enemy.exist?
        special_mushroom_effect(enemy) if enemy.state?(30) #淫毒併発
        #enemy.persona_break if enemy.state?(106) #破面併発
#        enemy.remove_states_auto
        ms = enemy.bms_states_update
        text2 = (text2 + ms + "\w\q") if ms != ""
        txc += 1 if ms != ""
      end
    end
    text = text1 + text2
    if text != ""
      #▼システムウェイト
      case $game_system.ms_skip_mode
      when 3 #手動送りモード
        @wait_count = (txc + 1) * 4
      when 2 #デバッグモード
        @wait_count = 8
      when 1 #快速モード
        @wait_count = 12
      else
        # ステート関係はステートの数だけウェイトを加算
        @wait_count = $game_system.battle_speed_time(0) + $game_system.important_wait_time + (txc * (4 + 1))
      end
      if $game_system.system_read_mode != 0
        text += "CLEAR"
        text.sub!("\w\qCLEAR","")
      end
      $game_temp.battle_log_text += text
    end
    # 全バトラーのステートログをすべてクリア
    for battler in @battlers
      battler.add_states_log.clear
      battler.remove_states_log.clear
    end
    # 画像変更フラグを立てて画像をリフレッシュ
    for enemy in $game_troop.enemies
      if enemy.exist?
        enemy.graphic_change = true
      end
    end
    for actor in $game_party.party_actors
      if actor.exist?
        actor.graphic_change = true
      end
    end
    # ステップ 104 に移行
    @phase4_step = 104
  end
  #--------------------------------------------------------------------------
  # ★ フレーム更新 (メインフェーズ ステップ 103 : インセンス変化メッセージ)
  #--------------------------------------------------------------------------
  def update_phase4_step104
    # バトルログをクリア
    @battle_log_window.contents.clear
    @battle_log_window.keep_flag = false
    $game_temp.battle_log_text = ""
    #★インセンス効果報告を出力する
    $incense.keep_text_call
    #★インセンスエフェクトを発生させる
    incense_effect
    #▼システムウェイト
    if $game_temp.battle_log_text != ""
      @wait_count = system_wait_make($game_temp.battle_log_text)
    end
    # ステップ 1 に移行
    @phase4_step = 1
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新 (メインフェーズ ステップ 1 : アクション準備)
  #--------------------------------------------------------------------------
  def update_phase4_step1
#    p "update4-1"if $DEBUG
    #p "1a" if $debug_flag == 1
    #絶頂スイッチは切っておく
    
    # 勝敗判定
    if judge
      # 勝利または敗北の場合 : メソッド終了
      return
    end
    
    # 残りの夢魔情報を初期化
    @last_enemies = []
    common_enemies = []
    # トループをチェック
    for enemy in $game_troop.enemies
      if enemy.exist?
        @last_enemies.push(enemy)
        common_enemies.push(enemy) unless enemy.boss_graphic?
      end
    end
    if common_enemies.size == 1
      common_enemies[0].position_flag = 1 unless common_enemies[0].position_flag == -1
    end
    
    # ヘルプウィンドウを隠す
    @help_window.visible = false
    # ★バトルログウィンドウを出す
    @battle_log_window.visible = true
    @battle_log_window.bgframe_sprite.visible = true

    # アクションを強制されているバトラーが存在しない場合
    if $game_temp.forcing_battler == nil
      # バトルイベントをセットアップ
      setup_battle_event
      # バトルイベント実行中の場合
      if $game_system.battle_interpreter.running?
        return
      end
    end
    # アクションを強制されているバトラーが存在する場合
    if $game_temp.forcing_battler != nil
      # 先頭に追加または移動(強制行動を起こすと多重行動不可にする)
      @action_battlers.delete($game_temp.forcing_battler)
      @action_battlers.unshift($game_temp.forcing_battler)
      $game_temp.forcing_battler.another_action = false
    end
    # 未行動バトラーが存在しない場合 (全員行動した)
    if @action_battlers.size == 0
      # バトルログをクリア
      @battle_log_window.contents.clear
      @battle_log_window.keep_flag = false
      $game_temp.battle_log_text = ""
      txc = 0
      # ●ステート解除判定を行なう
      ms = text = text1 = text2 = ""
      for actor in $game_party.battle_actors
        if actor.exist? and not actor.dead?
          actor.remove_states_auto
          ms = actor.bms_states_update
          text1 = (text1 + ms + "\w\q") if ms != ""
          txc += 1
        end
      end
      ms = ms2 = ""
      for enemy in $game_troop.enemies
        if enemy.exist?
          enemy.remove_states_auto
          ms = enemy.bms_states_update
          text2 = (text2 + ms + "\w\q") if ms != ""
          txc += 1
        end
      end
      text = text1 + text2
      before_text_flag = false # この時点でテキストがあるか確認
      if text != ""
        #▼システムウェイト
        case $game_system.ms_skip_mode
        when 3 #手動送りモード
          @wait_count = (txc + 1) * 4
        when 2 #デバッグモード
          @wait_count = 8
        when 1 #快速モード
          @wait_count = 12
        else
          # ステート関係はステートの数だけウェイトを加算
          @wait_count = $game_system.battle_speed_time(0) + $game_system.important_wait_time + (txc * (4 + 1))
        end
        if $game_system.system_read_mode != 0
          text += "CLEAR"
          text.sub!("\w\qCLEAR","")
        end
        $game_temp.battle_log_text += text
        before_text_flag = true # テキスト有りのフラグを立てる
      end
      # 全バトラーのステートログをすべてクリア
      for battler in @battlers
        battler.add_states_log.clear
        battler.remove_states_log.clear
      end
      # 画像変更フラグを立てて画像をリフレッシュ
      for enemy in $game_troop.enemies
        if enemy.exist?
          enemy.graphic_change = true
        end
      end
      for actor in $game_party.party_actors
        if actor.exist?
          actor.graphic_change = true
        end
      end
      # 先攻後攻はここでリフレッシュを入れる
      $game_temp.first_attack_flag = 0
      # 画像変更フラグを立てて画像をリフレッシュ
      # 更に、ガード状態、リクエスト状態ならそれらも同時に解除する
      text = ""
      for enemy in $game_troop.enemies
        if enemy.exist?
          #ターンをまたぐとレジストカウントは１下がる
#          enemy.resist_count -= 1 if enemy.resist_count > 0
          if enemy.ecstasy_turn > 0
            enemy.ecstasy_turn -= 1
            if enemy.ecstasy_turn == 0 and enemy.weaken?
              enemy.remove_state(2) if enemy.states.include?(2) #衰弱
              enemy.remove_state(3) if enemy.states.include?(3) #絶頂
              text += enemy.bms_states_update + "\w\q"
              enemy.animation_id = 12
              enemy.animation_hit = true
              txc += 1
            end
          end
          enemy.graphic_change = true
          enemy.remove_state(93) if enemy.states.include?(93) #ガード
          enemy.remove_state(94) if enemy.states.include?(94) #大ガード
        end
      end
      for actor in $game_party.party_actors
        if actor.exist?
          #暴走チェック
          if actor.state?(36)
            actor.berserk = true
          else
            actor.berserk = false
          end
          #ターンをまたぐとレジストカウントは１下がる
#          actor.resist_count -= 1 if actor.resist_count > 0
          if actor.ecstasy_turn > 0
            actor.ecstasy_turn -= 1
            if actor.ecstasy_turn == 0 and actor.weaken?
              actor.remove_state(2) if actor.states.include?(2) #衰弱
              actor.remove_state(3) if actor.states.include?(3) #絶頂
              text += actor.bms_states_update + "\w\q"
              actor.animation_id = 12
              actor.animation_hit = true
              txc += 1
            end
          end
          actor.graphic_change = true
          actor.remove_state(93) if actor.states.include?(93) #ガード
          actor.remove_state(94) if actor.states.include?(94) #大ガード
          actor.remove_state(96) if actor.states.include?(96) #アピール
        end
      end
      #お任せ中の場合、カウント減。カウントが０になったら解除して抜ける
      if $game_actors[101].state?(95)
        if $freemode_count > 0
          $freemode_count -= 1
        else
          $game_actors[101].remove_state(95)
          $freemode_count = nil
        end
      end
      #テキスト整形
      if text != ""
        if $game_system.system_read_mode != 0
          text += "CLEAR"
          text.sub!("\w\qCLEAR","")
        end
        # 事前にテキストがあった場合は改行を挿す
        text = "\w\q" + text if before_text_flag 
        $game_temp.battle_log_text += text
        #▼システムウェイト
        case $game_system.ms_skip_mode
        when 3 #手動送りモード
          @wait_count = (txc + 1) * 4
        when 2 #デバッグモード
          @wait_count = 8
        when 1 #快速モード
          @wait_count = 12
        else
          @wait_count = $game_system.battle_speed_time(0) + $game_system.important_wait_time
        end
      end
      #★インセンス継続判定を行なう
      $incense.turn_end_reduction
      
      # 先制攻撃フラグをクリア      
      $game_temp.first_attack_flag = 0
      @actor_first_attack = true
      @enemy_first_attack = false
      # ステータスウィンドウをリフレッシュ
      @status_window.refresh
      ## ステップ 103 に移行
      #@phase4_step = 103
      # ステップ 105 に移行
      @phase4_step = 105
    else
      # アニメーション ID およびコモンイベント ID を初期化
      @animation1_id = 0
      @animation2_id = 0
      @common_event_id = 0
      # 未行動バトラー配列の先頭からシフト
      @active_battler = @action_battlers.shift
      # すでに戦闘から外されている場合（隠れエネミーも含む）
      if @active_battler.index == nil or @active_battler.hidden
        return
      end
      # ★アクティブバトラーの情報を記憶　※コモンイベントで使います。
      $game_temp.battle_active_battler = @active_battler

=begin
      # ★エネミーの表示状態の変更
      enemies_display(@active_battler) if @active_battler.is_a?(Game_Enemy)
=end
      # ★エネミーの場合
      enemy_skill = @active_battler.current_action.skill_id
      if @active_battler.is_a?(Game_Enemy) and enemy_skill != nil
        if @active_battler.another_action
          # 行動二回目ならアクション強制フラグを外す
          @active_battler.current_action.forcing = false
        end
        if not @active_battler.current_action.forcing
          # エネミー行動制御用スイッチを確認し、再度アクション選択
          enemy_action_swicthes(@active_battler)
          @active_battler.make_action
        end
      end
      
      # スリップダメージ
      if @active_battler.hp > 0 and @active_battler.slip_damage?
        @active_battler.slip_damage_effect
        @active_battler.damage_pop = true
      end
      
      #p "1b" if $debug_flag == 1
      # 全バトラーのステートログをすべてクリア
      for battler in @battlers
        battler.add_states_log.clear
        battler.remove_states_log.clear
      end
      # メッセージタグをクリア
      $msg.tag = ""
      
      # バックログに改行指定を追加
#      $game_temp.battle_back_log += "\q"

      # ステータスウィンドウをリフレッシュ
      @status_window.refresh
      # ステップ 2 に移行
      @phase4_step = 2
    end
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新 (メインフェーズ ステップ 11 : ターン終了)
  #--------------------------------------------------------------------------
  def update_phase4_step103
    # ★バトルログウィンドウを消す
    @battle_log_window.visible = false
    @battle_log_window.bgframe_sprite.visible = false

    @status_window.refresh
    # パーティコマンドフェーズ開始
    start_phase2
  end
  
  #--------------------------------------------------------------------------
  # ● フレーム更新 (メインフェーズ ステップ 2 : アクション開始)
  #--------------------------------------------------------------------------
  def update_phase4_step2
    
    # バトルログをクリア
    @battle_log_window.contents.clear
    @battle_log_window.keep_flag = false
    $game_temp.battle_log_text = ""
    # 各バトラーにホールド状況を記録
    hold_record
#    p "行動4-2：#{@active_battler.name}/対象index：#{@active_battler.current_action.target_index}"if $DEBUG
    
    #p "2a" if $debug_flag == 1
    # ★アクティブバトラーの情報を記憶　※コモンイベントで使います。
    $game_temp.battle_active_battler = @active_battler
    # 強制アクションでなければ
    unless @active_battler.current_action.forcing
      # 制約が [敵を通常攻撃する] か [味方を通常攻撃する] の場合
      if @active_battler.restriction == 2 or @active_battler.restriction == 3
        # アクションに攻撃を設定
        @active_battler.current_action.kind = 0
        @active_battler.current_action.basic = 0
        # ●記憶したスキルを解除
        $game_temp.skill_selection = nil
      end
      # 制約が [行動できない] の場合
      if @active_battler.restriction == 4
        #行動できない原因が暴走の場合、ランダム行動スキルを装填
        if @active_battler.berserk == true
          @active_battler.current_action.kind = 1
          @active_battler.current_action.forcing = true
          @active_battler.current_action.skill_id = 296
          if @active_battler.is_a?(Game_Enemy)
            @active_battler.current_action.decide_random_target_for_enemy
          elsif @active_battler.is_a?(Game_Actor)
            @active_battler.current_action.decide_random_target_for_actor
          end
          @active_battler.another_action = false
        #暴走以外の場合、バトラーをクリアする
        else
          # アクション強制対象のバトラーをクリア
          $game_temp.forcing_battler = nil
          # ステップ 1 に移行
          @phase4_step = 1
          # ●記憶したスキルを解除
          $game_temp.skill_selection = nil
          return
        end
      end
    end
    # 対象バトラーをクリア
    @target_battlers = []
    # アクションの種別で分岐
    case @active_battler.current_action.kind
    when 0  # 基本
      make_basic_action_result
    when 1  # スキル
      make_skill_action_result
    when 2  # アイテム
      make_item_action_result
    end
    #p "2b" if $debug_flag == 1
    
    # ステップ 3 に移行
    if @phase4_step == 2
      @phase4_step = 3
    end
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新 (メインフェーズ ステップ 3 : 行動側アニメーション)
  #--------------------------------------------------------------------------
  def update_phase4_step3
    #p "3a" if $debug_flag == 1
    # バトルログをクリア
    @battle_log_window.contents.clear
    @battle_log_window.keep_flag = false
    $game_temp.battle_log_text = ""
    # 行動側アニメーション (ID が 0 の場合は白フラッシュ)
    if @animation1_id == 0
      @active_battler.white_flash = true
    else
      @active_battler.animation_id = @animation1_id
      @active_battler.animation_hit = true
    end
    # ★バトルログを表示
    case @active_battler.current_action.kind
    when 1  #スキル
      @active_battler.bms_useskill(@skill)
    when 2  #アイテム
      @active_battler.bms_useitem(@item)
    end
    
    # ■コマンド統括 
    #------------------------------------------------------
    case @active_battler.current_action.kind
    when 1 #スキルの場合
      command = @skill
    when 2 #アイテムの場合
      command = @item
    end
    # ★エネミーの表示状態の変更（対象が全体の場合は変更無し）
    # （ターゲットもアクティブもエネミーの場合、ここで表示エネミーを予約し、
    # 　行動時メッセージの終了後に表示させる）
    if @target_battlers[0].is_a?(Game_Enemy) and @active_battler.is_a?(Game_Enemy) \
     and command.scope != 2 and command.scope != 4 
      @display_order_enemy = @target_battlers[0]
    end
    
    # ■レジストスキルの場合
    if @active_battler.current_action.kind == 1
      #ホールド(6)、誘惑(7)、物理(8)レジストのいずれかの属性がある場合は専用処理に移動
      if @skill.element_set.include?(6) or @skill.element_set.include?(7) or @skill.element_set.include?(8)
        # 対象に吹き出しアニメーションをつける
        unless @skill.id == 10
          @target_battlers[0].animation_id = 109
          @target_battlers[0].animation_hit = true
        end
        # レジストスキルの情報を記録
        $game_temp.resist_skill = @skill
        # ウェイトを入れて 12 に移行
        @phase4_step = 12
        return
      end
    end
    # レジストスキルでない場合、ステップ 4 に移行
    @phase4_step = 4
#●    @wait_count = 8 #ウェイト外してテンポアップ
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新 (メインフェーズ ステップ 4 : レジスト処理)
  #--------------------------------------------------------------------------
  def update_phase4_step12
    # --------------------------------------------------------------
    @battle_log_window.contents.clear
    @battle_log_window.keep_flag = false
    $game_temp.battle_log_text = ""
    # コモンイベントを挟んでレジスト前の会話を表示
    common_event = $data_common_events[31]
    $game_system.battle_interpreter.setup(common_event.list, 0)
    @wait_count = 10
    battle_resist
    # ステップ 4 に移行
    @phase4_step = 13
  end  
  #--------------------------------------------------------------------------
  # ● フレーム更新 (メインフェーズ ステップ 4 : レジスト結果作成)
  #--------------------------------------------------------------------------
  def update_phase4_step13
    @battle_log_window.contents.clear
    @battle_log_window.keep_flag = false
    $game_temp.battle_log_text = ""
#●    @wait_count = 30
    @add_hold_flag = false
    for target in @target_battlers
      # 対象がエネミーの場合
      if target.is_a?(Game_Enemy)
        # 成功時
        if $game_temp.resistgame_clear == true
          @resist_flag = true
          @hold_shake = true
          #レジストカウントを０にする
          target.resist_count = 0
          #成功時のトークステップ(２)に設定
          $msg.talk_step = 2
          # ■服を脱がす
          if @skill.element_set.include?(36)
            target.undress
            $game_temp.battle_log_text += target.bms_states_update
          # ■ホールド付与
          elsif @skill.element_set.include?(6)
#            add_hold(@skill, @active_battler, target)
            @add_hold_flag = true
            hold_effect(@skill, @active_battler, target)
          # その他
          else
            $game_temp.battle_log_text += "Resist Successful\w\q" 
          end
        # 失敗時
        else
          @resist_flag = false
          @hold_shake = false
          #失敗時のトークステップ(３)に設定
          $msg.talk_step = 3
          #受け入れた場合はSEを鳴らさず、レジストカウントを上げない
          if $game_switches[89]
            $game_temp.battle_log_text += @active_battler.name + " gave up!\w\q"
          else
          # 避けるSEを鳴らし、対象のレジストカウントを＋１する
            Audio.se_play("Audio/SE/063-Swing02", 80, 100)
            $game_temp.battle_log_text += target.name + " resisted it!\w\q"
            target.resist_count += 1
          end
          if @skill.element_set.include?(6)
            @hold_shake = false
            hold_effect(@skill, @active_battler, target)
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
            # ここは少しだけウェイトを増やす
            @wait_count = $game_system.battle_speed_time(0) + 2
          end
        end
      # 対象がアクターの場合
      else  
        # 成功時
        if $game_temp.resistgame_clear == true
          @resist_flag = true
          #成功時のトークステップ(２)に設定
          $msg.talk_step = 2
          # 避けるSEを鳴らし、対象のレジストカウントを＋１する
          Audio.se_play("Audio/SE/063-Swing02", 80, 100)
          $game_temp.battle_log_text += target.name + " resisted it!\w\q"
          target.resist_count += 1
          if @skill.element_set.include?(6)
            @hold_shake = false
            hold_effect(@skill, @active_battler, target)
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
            # ここは少しだけウェイトを増やす
            @wait_count = $game_system.battle_speed_time(0) + 2
          end
        # 失敗時
        else
          @resist_flag = false
          #レジストカウントを０にする
          target.resist_count = 0
          @hold_shake = true
          #失敗時のトークステップ(３)に設定
          $msg.talk_step = 3
          # ■服を脱がす
          if @skill.element_set.include?(36)
            # 脱衣アニメーションをつける
              target.animation_id = 104
              target.animation_hit = true
              target.undress
              $game_temp.battle_log_text += target.bms_states_update
          # ■ホールド付与
          elsif @skill.element_set.include?(6)
#            add_hold(@skill, @active_battler, target)
            @add_hold_flag = true
            hold_effect(@skill, @active_battler, target)
          # その他
          else
            $game_temp.battle_log_text += "Failed to resist.\w\q" 
          end
        end
      end
      # 画像変更
      @active_battler.graphic_change = true
      target.graphic_change = true
    end
    # ステータスのリフレッシュ
    @status_window.refresh
    # ステップ 4 に移行
    @phase4_step = 4
  end  
  #--------------------------------------------------------------------------
  # ● フレーム更新 (メインフェーズ ステップ 4 : 対象側アニメーション)
  #--------------------------------------------------------------------------
  def update_phase4_step4
    
    # 各種項目をクリア
    @ecstasy_check = false
    @ecstasy_check_self = false
    text1 = ""
    text2 = ""
    text3 = ""
    # ■コマンド統括 
    #------------------------------------------------------
    case @active_battler.current_action.kind
    when 1 #スキルの場合
      @command = @skill
    when 2 #アイテムの場合
      @command = @item
    end
=begin
    # ★エネミーの表示状態の変更（対象が全体の場合は変更無し）
    if @target_battlers[0].is_a?(Game_Enemy) \
     and @command.scope != 2 and @command.scope != 4 
      enemies_display(@target_battlers[0])
    end
=end
    # ●処理開始
    for target in @target_battlers
      #------------------------------------------------------
      # 対象側アニメーション
      target.animation_id = @animation2_id
      target.animation_hit = (target.damage != "Miss")
      # ムードアップ処理
      #------------------------------------------------------
      # ムードアップ小
      if @command.element_set.include?(20)
        $mood.rise(1)
      # ムードアップ中
      elsif @command.element_set.include?(21)
        $mood.rise(4)
      # ムードアップ大
      elsif @command.element_set.include?(22)
        $mood.rise(10)
      end
      # シェイク処理(ホールド処理でシェイクさせた場合は飛ばす)
      #------------------------------------------------------
      # ピストン系
      if @hold_shake == nil
        if @command.element_set.include?(37)
          # 画面の縦シェイク
          $game_screen.start_flash(Color.new(255,210,225,220), 8)
          $game_screen.start_shake2(7, 15, 15)
        # グラインド系
        elsif @command.element_set.include?(38)
          # 画面の横シェイク
          $game_screen.start_flash(Color.new(255,210,225,220), 8)
          $game_screen.start_shake(7, 15, 15)
        end
      else
        #ホールドでシェイク処理を行った場合、ここでnilに戻す
        @hold_shake = nil
      end
      #======================================================================================
      # ダメージがある場合      
      #======================================================================================
      if target.damage != nil
        skill_result = state_result = ""
        target.damage_pop = true
        #======================================================================================
        # ■攻撃を命中させている
        #======================================================================================
        if target.damage != "Miss"
          #************************************************************************
          # ▼「ダメージ無しスキル」ではない場合
          #************************************************************************
          if not @command.element_set.include?(17)
            #●スキルテキスト呼び出し
            if @active_battler.current_action.kind == 1
              skill_result = target.bms_skill_effect(@skill)
            #●アイテムテキスト呼び出し
            elsif @active_battler.current_action.kind == 2
              skill_result = target.bms_item_effect(@item)
            end
            state_result = target.bms_states_update
            state_result2 = @active_battler.bms_states_update
            #●テキスト整形
            #▽スキルテキストがあるなら挿入
            text1 += skill_result if skill_result != ""
            #▽対象のステートテキストがあるなら挿入
            text1 += "\w\q" + state_result if state_result != ""
            #▽自身のステートテキストがあるなら挿入
            text1 += "\w\q" + state_result2 if state_result2 != ""
            #▽テキストが存在するなら、最後に改行を挿入
            text1 += "\w\q" if text1 != ""
            #------------------------------------------------------
            # ●贈り物アイテムの場合、友好度に応じてアニメーションを指示
            #------------------------------------------------------
            if target.is_a?(Game_Enemy) and @command.element_set.include?(199)
              target.friendly_animation_order
            end
            #------------------------------------------------------
            # ●リバウンドが発生するスキルである場合は算出
            #------------------------------------------------------
            if @command.element_set.include?(31) or @command.element_set.include?(32)
              @active_rebound_flag = false
              rebound = (target.damage * (5 + ($mood.point / 10).floor) / 100).floor
              rebound = (rebound / 2).round if @command.element_set.include?(31) #リバウンド少
              # 反動ダメージでＨＰが０以下になる場合は１を残す(今のところ)
              rebound = 0 if @active_battler.hp == 1
              rebound = @active_battler.hp - 1 if @active_battler.hp <= rebound
              # 実際にEPを減算
              @active_battler.hp -= rebound
              # バトルログを表示(リバウンドが発生しない場合は表示しない）
              text3 += "\w" + @active_battler.name + " took " + rebound.to_s + " rebound pleasure!\q" if rebound > 0
              if @active_battler.hp > 0 and not @active_battler.state?(6)
                if @active_battler.hpp <= $mood.crisis_point(@active_battler) + rand(5)
                  @active_rebound_flag = true
                  @active_battler.add_state(6)
                  text3 += @active_battler.bms_states_update + "\w\q"
                end
              end
              # 画像変更
              @active_battler.graphic_change = true
            end
            #------------------------------------------------------
            # ●吸精が発生するスキルである場合は算出
            #------------------------------------------------------
            if @command.element_set.include?(198)
              # 吸収値を算出し、吸収処理
              vp_drain = (target.damage * (10 + ($mood.point / 5).floor) / 100).floor
              if vp_drain > 0
                target.sp -= vp_drain
                @active_battler.sp += vp_drain
                text3 += "\w" + @active_battler.name + " had " + vp_drain.to_s + " energy absorbed!\w\q"
                if target.sp <= 0
                  target.sp_down_flag = true
                end
                # 吸精したならアニメを付ける
                @active_battler.animation_id = 168
                @active_battler.animation_hit = (target.damage != "Miss")
              end
            end
            #------------------------------------------------------
            # ●レベルドレインが発生するスキルである場合は算出
            #------------------------------------------------------
            if @command.element_set.include?(202)
              if target.level > 1
                target.level -= 1
                text3 += "\w" + "#{target.name} became Lv.#{target.level.to_s}!"
                # 使用者にストレリブルムの強化項目を通す
                level_drain_text = ""
#                @active_battler.capacity_alteration_effect($data_skills[195])
#                level_drain_text = @active_battler.bms_states_update
                level_drain_text += special_status_check(@active_battler,[195])
#               
                # テキストがあるならそこを通す
#                if level_drain_text != "" and level_drain_text != "しかし#{@active_battler.name}には効果が無かった！"
                  text3 += level_drain_text + "\w\q"
#                end
                # 吸収したならアニメを付ける
                @active_battler.animation_id = 168
                @active_battler.animation_hit = (target.damage != "Miss")
              end
            end
            #------------------------------------------------------
            # ●焦らしスイッチが入っている場合、最後にナレートを追加
            #------------------------------------------------------
            if $game_switches[82] == true
              brk = ""
              brk = "、\n\m" if SR_Util.names_over?(@active_battler.name,$game_temp.battle_target_battler[0].name)
              #ティーズの場合、スイッチを即時解除する
              if @active_battler.is_a?(Game_Actor) and @command.id == 101
                text3 += "\w" + @active_battler.name + "は#{brk}#{$game_temp.battle_target_battler[0].name}を焦らしている！\w\q"
              #夢魔からの焦らし攻撃を食らった場合、スイッチを即時解除する
              elsif @active_battler.is_a?(Game_Enemy)
                text3 += "\w" + @active_battler.name + "は#{brk}#{$game_temp.battle_target_battler[0].name}を焦らしている！\w\q"
              end
              $game_switches[82] = false
            end
            #------------------------------------------------------
            # ●使用者が味方で【洞察力】持ちの場合
            #------------------------------------------------------
            if @active_battler.is_a?(Game_Actor) and @active_battler.have_ability?("洞察力")
              brk = ""
              brk = "、\n\m" if SR_Util.names_over?(@active_battler.name, $game_temp.battle_target_battler[0].name, 16)
              # 対象が敵で、チェックフラグが１未満の時、１にしてナレートを出す
              if target.is_a?(Game_Enemy) and target.checking < 1
                target.checking = 1
                text3 += "\w" + @active_battler.name + " examined #{brk}#{$game_temp.battle_target_battler[0].name}!\w\q"
              end
            end
            #------------------------------------------------------
            # ●ベストエンド戦のヴェルミィーナが本気を出す場合
            #------------------------------------------------------
            if @troop_id == 603
              # 対象がヴェルミィーナ且つ、ヴェルミィーナがまだ本気状態で無い且つ
              # ＶＰが1000以下且つ、絶頂維持中でない場合
              if target == $game_troop.enemies[0] and not $game_troop.enemies[0].earnest and
               $game_troop.enemies[0].sp <= 1200 and not $game_troop.enemies[0].weaken?
                # イベントを準備（ステップ６でイベントセットアップ）
                @common_event_id = 119
              end
            end
          #************************************************************************
          # ▼「ステート付与スキル」の場合
          #************************************************************************
          elsif @command.element_set.include?(33)
            #対象のステートからステートリザルトを呼び出す
            state_result = target.bms_states_update
            if state_result != "" #付与ステートがある場合
              text1 += state_result + "\w\q"
            elsif state_result == "" #付与ステートが無い場合
              text1 += ""
            else
              text1 += state_result + "\w\q"
            end
            # 強化・低下魔法関連処理
            for i in 80..87
              target.remove_state(i) if target.states.include?(i)
            end
          #************************************************************************
          # ▼「演出スキル」の場合
          #************************************************************************
          elsif @command.element_set.include?(200)
            text1 = target.bms_direction_skill_effect(@skill)
          end
        #======================================================================================
        # ■攻撃を外している
        #======================================================================================
        elsif target.damage == "Miss"
          #************************************************************************
          # ▼「ステート付与スキル」の場合
          #************************************************************************
          if @command.element_set.include?(33)
            # ●バッドステート付与魔法の場合(既に付与されている場合無効化される)
            bs = 0
            for i in SR_Util.checking_states
              if $data_skills[@skill.id].plus_state_set.include?(i) and target.states.include?(i)
                text1 += "Ｈoｗever " + target.name + " cannot be effected ｍore than this!\w\q"
                bs = 1
                break
              end
            end
            if bs == 0
              skill_result = target.bms_skill_effect(@skill)
              text1 += skill_result + "\w\q"
            end
          #************************************************************************
          # ▼「贈り物アイテム」の場合、贈り物アイテムの失敗を表示
          #************************************************************************
          elsif target.is_a?(Game_Enemy) and @command.element_set.include?(199) and
            skill_result = target.bms_item_effect(@item)
            text1 += skill_result + "\w\q"
          #************************************************************************
          # ▼「ダメージ無しスキル」ではない場合
          #************************************************************************
          elsif not @command.element_set.include?(17)
#          else
#            # ミスした場合は避けるSEを鳴らす
#            Audio.se_play("Audio/SE/063-Swing02", 80, 100)
            $game_temp.battle_log_text += "\w" + target.name + " was not effected!\q"
          end
        end
        #======================================================================================
        # ■特殊
        #======================================================================================
        #************************************************************************
        # ▼『服を脱ぐ』系処理
        #************************************************************************
        if @command.element_set.include?(35)
          # ダメージナレート後に口上を出すフラグを入れる
          $game_switches[90] = true
          #●エネミー側の挙動
          if target.is_a?(Game_Enemy)
            $msg.tag = "夢魔が仲間夢魔を脱衣"
            $msg.tag = "夢魔が自ら脱衣" if @active_battler == target
            #夢魔側の脱衣口上管理は主人公部分で一括で行う
            $msg.callsign = 7
            $msg.callsign = 17 if $game_switches[85] == true
            target.undress
            #対象のステート状況をテキストに格納
            text1 += target.bms_states_update + "\w\q"
          #●アクター側の挙動
          else
            #主人公
            if target == $game_actors[101]
              if @active_battler != target
                $msg.tag = "パートナーが主人公を脱衣"
                $msg.callsign = 27
                $msg.callsign = 37 if $game_switches[85] == true
              else
                $msg.tag = "主人公が自ら脱衣"
                $msg.callsign = 7
                $msg.callsign = 17 if $game_switches[85] == true
              end
            #パートナー
            else
              if @active_battler != target
                $msg.tag = "主人公がパートナーを脱衣"
                $msg.callsign = 7
                $msg.callsign = 17 if $game_switches[85] == true
              else
                $msg.tag = "パートナーが自ら脱衣"
                $msg.callsign = 27
                $msg.callsign = 37 if $game_switches[85] == true
              end
            end
            target.animation_id = 104
            target.animation_hit = true
            target.undress
            text1 += target.bms_states_update + "\w\q"
          end
        end
        #************************************************************************
        # ▼スライムの着脱衣系処理
        #************************************************************************
        #●粘液再生
        if @command.name == "レストレーション"
          target.animation_id = 89
          target.animation_hit = true
          target.dress
        #●粘液投射
        elsif @command.name == "スライミーリキッド"
          target.animation_id = 90
          target.animation_hit = true
          @active_battler.undress
          text1 += @active_battler.bms_states_update + "\w\q"
          @active_battler.graphic_change = true
        end
        #************************************************************************
        # ▼イニシアチブ変更系
        #************************************************************************
        if @command.element_set.include?(207)
          text1 += "#{@active_battler.name}は主導権を取り戻した！\w\q"
        end
        #************************************************************************
        # ▼インセンス全て削除
        #************************************************************************
        if @command.element_set.include?(213)
          delete_flag = $incense.delete_incense_all
          if delete_flag
            text1 += "場に掛かっている効果がすべて無くなった！\w\q"
          else
            text1 += "しかし効果は無かった！\w\q"
          end
        end
        #************************************************************************
        # ▼エネミー復活系
        #************************************************************************
        if @command.element_set.include?(217)
          target.recover_all
          target.state_runk = [0, 0, 0, 0, 0, 0]
          target.ecstasy_count = []
          target.crisis_flag = false
          target.hold_reset
          target.ecstasy_turn = 0
          target.ecstasy_emotion = nil
          target.sp_down_flag = false
          target.resist_count = 0
          target.pillowtalk = 0
          target.talk_weak_check = []
          target.add_states_log.clear
          target.remove_states_log.clear
          target.checking = 0
          target.lub_male = 0
          target.lub_female = 0
          target.lub_anal = 0
          target.used_mouth = 0
          target.used_anal = 0
          target.used_sadism = 0
          battler_stan(target)
          enemies_display(target)
          text1 += "#{target.name}が現れた！\w\q"
        end
        
     #elsif target.damage == nil ダメージが無い場合の処理は現状では特に無いため封印
      end
      #======================================================================================
      # 画像変更
      target.graphic_change = true
      # ●ホールド状況確認
      if @active_battler != target
        #hold_initiative(@skill, @active_battler, target) # メソッド変更しました
        if target.holding?
          # クリティカルが出ている場合、敵ホールドのイニシアチブを減少
          if target.critical
            hold_initiative_down(target)
          end
          # もがくの場合、自分をホールドしている相手全員のイニシアチブを減少
          if @command.element_set.include?(207)
            for hold_target in @active_battler.hold_target_battlers
              hold_initiative_down(hold_target)
            end
          end
        end
        # ホールドポップの指示
        hold_pops_order
        #ホールド直後の処理の場合、ここで平常運転に戻す
        $game_switches[81] = false
      end
    #for target in @target_battlersここまで
    end
    #************************************************************************
    # ▼アンラッキーロア
    #************************************************************************
    if @command.name == "アンラッキーロア"
      # 不幸でない場合、不幸状態にする。
      unless $game_party.unlucky?
        text1 += "#{$game_actors[101].name}は不幸になってしまった！\w\q"
        $game_variables[61] = 50 
      else
        text1 += "しかし効果は無かった！\w\q"
      end
    end
    #************************************************************************
    # ▼インセンス処理
    #************************************************************************
    if @command.element_set.include?(129)
      add_check = $incense.use_incense(@active_battler, @command)
      if add_check
        # 発生時処理
        text1 = incense_start_effect
      else
        text1 = "しかし効果は無かった！\w\q"
      end
    end
    #本能の呼び覚ましで自己暴走した場合、そのターンの追加アクションをキャンセルする
    @action_battlers.delete(@active_battler) if @command.name == "本能の呼び覚まし"
    #======================================================================================
    #●トーク処理(トーク中の愛撫等でのダメージその他処理を行うため)
    #======================================================================================
    # コマンド名がトーク、かつコモンイベント ID が有効の場合
    if @common_event_id > 0 and @command.name == "トーク"
      @battle_log_window.contents.clear
      @battle_log_window.keep_flag = false
      $game_temp.battle_log_text = ""
      # イベントをセットアップ
      common_event = $data_common_events[@common_event_id]
      $game_system.battle_interpreter.setup(common_event.list, 0)
    end
    #************************************************************************
    # ★テキスト整形
    #************************************************************************
    if text1 != "" or text2 != "" or text3 != ""
      a = text1 + text2 + text3
      if $game_system.system_read_mode != 0
        a += "CLEAR"
        a.sub!("\w\qCLEAR","")
        a.sub!("CLEAR","") if a[/(CLEAR)/] != nil
      end
      $game_temp.battle_log_text += a
    else
      # マニュアル操作の場合、効果がない場合でもポーズを付ける
#      if $game_system.system_read_mode == 0
#        $game_temp.battle_log_text += "　\w\q"
#      end
    end
    
    #======================================================================================
    #●クライシス・絶頂フラグ
    #======================================================================================
    #対象がクライシスになり、クライシス会話が発生していないなら処理開始
    @crisis_battlers = []
    @ecstasy_battlers = []
    @ecstasy_battlers_count = []
    @ecstasy_battlers_clone = []
    @target_ecstasy_flag = false
    @active_ecstasy_flag = false
    @crisis_mes_stop_flag = false
    #▼絶頂キャラクターを格納する
    #------------------------------------------------------
    for target in @target_battlers
      if target.hp <= 0 or target.sp <= 0
        target.add_state(11)
        @ecstasy_battlers.push(target)
        @target_ecstasy_flag = true
        target.graphic_change = true
        @crisis_mes_stop_flag = true
      end
    end
    if @active_battler.hp <= 0 or @active_battler.sp <= 0
      @active_battler.add_state(11)
      @ecstasy_battlers.push(@active_battler)
      @active_ecstasy_flag = true
      @active_battler.graphic_change = true
      @crisis_mes_stop_flag = true
    end
    @ecstasy_battlers_count = @ecstasy_battlers
    @ecstasy_battlers_clone = @ecstasy_battlers_count.dup
    #▼クライシスキャラクターを格納する
    #------------------------------------------------------
    #トーク中、ダメージ無しスキル、回復スキル使用の場合は格納しない
    unless $game_switches[79] == true and @command.element_set.include?(16) and @command.element_set.include?(17)
      for target in @target_battlers
        unless @ecstasy_battlers.include?(target)
          unless @crisis_mes_stop_flag == true
            if target.crisis? and target.crisis_flag == false
              @crisis_battlers.push(target)
            end
          end
        end
      end
      #ターゲット確認の後、アクティブキャラクターも判定を行う
      unless @ecstasy_battlers.include?(@active_battler)
        unless @crisis_mes_stop_flag == true
          if @active_battler.crisis? and @active_battler.crisis_flag == false
            for target in @target_battlers
              # アクティブもターゲットもエネミーの場合はアクティブを入れない
              unless @active_battler.is_a?(Game_Enemy) and target.is_a?(Game_Enemy)
                @crisis_battlers.push(@active_battler)
              end
            end
          end
        end
      end
    end
    #************************************************************************
    # ★全バトラーのステートログをクリア
    #************************************************************************
    for battler in @battlers
      battler.add_states_log.clear
      battler.remove_states_log.clear
    end
    #************************************************************************
    # ★各種機能処理
    #************************************************************************
    #ステータスウィンドウ更新
    @status_window.refresh
    #▼システムウェイト
    case $game_system.ms_skip_mode
    when 3 #手動送りモード
      @wait_count = 4
    when 2 #デバッグモード
      @wait_count = 6
    when 1 #快速モード
      @wait_count = 10
    else
      @wait_count = $game_system.battle_speed_time(0)
    end
    if @crisis_battlers.size > 0
      # ステップ 401 に移行
      @phase4_step = 401
    elsif $game_switches[90] == true
      # ステップ 402 に移行
      @phase4_step = 402
    else
      # ステップ 5 に移行
      @phase4_step = 5
    end

  end
  #--------------------------------------------------------------------------
  # ● フレーム更新 (メインフェーズ ステップ 401 : クライシス処理)
  #--------------------------------------------------------------------------
  def update_phase4_step401
    #======================================================================================
    #●クライシスフラグ
    #======================================================================================
    cs_battler = @crisis_battlers[0]
    #▼コールサインを設定
    if @active_battler == $game_actors[101] or cs_battler == $game_actors[101]
      $msg.callsign = 6
      $msg.callsign = 16 if $game_switches[85] == true
    else
      $msg.callsign = 26
      $msg.callsign = 36 if $game_switches[85] == true
    end
    #▼アクション側がエネミー
    if cs_battler.is_a?(Game_Actor)
      if @active_battler.crisis? and @active_battler.is_a?(Game_Enemy)
        $msg.tag = "アクター両者"
      elsif cs_battler == @active_battler
        if @active_rebound_flag == true
          $msg.tag = "アクターリバウンド自爆"
          @active_rebound_flag = false
        else
          $msg.tag = "アクター自慰"
        end
      else
        $msg.tag = "アクター単独"
      end
    elsif cs_battler.is_a?(Game_Enemy)
      if @active_battler != cs_battler
        if @active_battler.is_a?(Game_Enemy) and cs_battler.is_a?(Game_Enemy)
          $msg.tag = "エネミー仲間攻め"
        elsif @active_battler.crisis? and @active_battler.is_a?(Game_Actor)
          $msg.tag = "エネミー両者"
        else
          $msg.tag = "エネミー単独"
        end
      else
        if @active_rebound_flag == true
          $msg.tag = "エネミーリバウンド自爆"
          @active_rebound_flag = false
        else
          $msg.tag = "エネミー自慰"
        end
      end
    end
    cs_battler.crisis_flag = true
    #口上モードが簡易表示の場合、この項目はスルーする
    unless $game_system.system_message == 0
      #アクティブ、ターゲットを更新
      $game_temp.battle_active_battler = @active_battler
      $game_temp.battle_target_battler[0] = cs_battler
      @battle_log_window.contents.clear
      @battle_log_window.keep_flag = false
      $game_temp.battle_log_text = ""
      # コモンイベント「☆口上コール」を実行
      common_event = $data_common_events[31]
      $game_system.battle_interpreter.setup(common_event.list, 0)
      @wait_count = 1
    end
    @crisis_battlers.delete(cs_battler)
    if @crisis_battlers.size > 0
      # ステップ 401 に移行
      @phase4_step = 401
    elsif $game_switches[90] == true
      # ステップ 402 に移行
      @phase4_step = 402
    else
      # ステップ 5 に移行
      @phase4_step = 5
    end
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新 (メインフェーズ ステップ 402 : 中途口上処理)
  #--------------------------------------------------------------------------
  def update_phase4_step402
    
    #口上モードが簡易表示の場合、この項目はスルーする
    if $game_system.system_message == 0
      #必ずスイッチを解除しておく
      $game_switches[90] = false
      #アクティブ、ターゲットを更新
      $game_temp.battle_active_battler = @active_battler
      $game_temp.battle_target_battler[0] = @target_battlers[0]
      #ムードチェック
      system_simplemode_moodcheck(@active_battler)
    #スキル等で夢魔口上を呼び出す場合、ここで設定
    elsif $game_switches[90] == true
      #アクティブ、ターゲットを更新
      $game_temp.battle_active_battler = @active_battler
      $game_temp.battle_target_battler[0] = @target_battlers[0]
      @battle_log_window.contents.clear
      @battle_log_window.keep_flag = false
      $game_temp.battle_log_text = ""
      # コモンイベント「☆口上コール」を実行
      common_event = $data_common_events[31]
      $game_system.battle_interpreter.setup(common_event.list, 0)
      @wait_count = 10
      #必ずスイッチを解除しておく
      $game_switches[90] = false
    end
    # ダメージ無しスキルでない場合
    unless @command.element_set.include?(17)
      # ラグを作る。
      #▼システムウェイト
      case $game_system.ms_skip_mode
      when 3 #手動送りモード
        @wait_count = 1
      when 2 #デバッグモード
        @wait_count = 2
      when 1 #快速モード
        @wait_count = 4
      else
        @wait_count = $game_system.battle_speed_time(0) #元は12
      end
    end
    # ステップ 5 に移行
    @phase4_step = 5
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新 (メインフェーズ ステップ 5 : ダメージ後処理)
  #--------------------------------------------------------------------------
  def update_phase4_step5
    #トーク愛撫から絶頂を起こす場合の処理
    if $msg.talking_ecstasy_flag == "actor"
      @ecstasy_battlers.push($game_actors[101])
      @active_ecstasy_flag = true
      @ecstasy_battlers_count = @ecstasy_battlers
      $game_actors[101].add_state(11)
    elsif $msg.talking_ecstasy_flag == "enemy"
      @ecstasy_battlers.push($msg.t_enemy)
      @target_ecstasy_flag = true
      @ecstasy_battlers_count = @ecstasy_battlers
      $msg.t_enemy.add_state(11)
    end
    #絶頂しているバトラーがいる場合
    if @ecstasy_battlers_count.size > 0
#      #同時絶頂フラグが経っている場合は511、そうでない場合は501へ
#      if @ecstasy_battlers.size > 1 and @target_ecstasy_flag == true and @active_ecstasy_flag == true
        @phase4_step = 501
#      else
#        @phase4_step = 511
#      end
    #絶頂バトラーが居ない場合
    else
      #追撃フラグが経っている場合はステップ601へ
      if @combo_break == false
        @phase4_step = 601
      #それ以外の場合はステップ6へ
      else
        @phase4_step = 6
      end
    end
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新 (メインフェーズ ステップ 501 : 絶頂処理(単独)：前半)
  #--------------------------------------------------------------------------
  def update_phase4_step501
    # ●絶頂中スイッチを入れる
    $game_switches[77] = true
    # ●バトルログをクリア
    @battle_log_window.contents.clear
    @battle_log_window.keep_flag = false
    $game_temp.battle_log_text = ""
    #======================================================================================
    #●絶頂フラグ
    #======================================================================================
    # 自爆フラグを下げておく
    @self_ecstasy_flag = false
    #--------------------------------------------------------------------------------------
    # ●絶頂しているキャラクターがアクターの場合
    #--------------------------------------------------------------------------------------
    if @ecstasy_battlers_count[0].is_a?(Game_Actor)
      #自爆でない場合は攻撃エネミーが確定している
      if @ecstasy_battlers_count[0] != @active_battler
        $msg.t_enemy = $game_temp.battle_active_battler = @active_battler
        $msg.t_target = $game_temp.battle_target_battler[0] = @ecstasy_battlers_count[0]
      #トーク中の場合は会話対象エネミーが確定している
      elsif $msg.talking_ecstasy_flag == "actor"
        $msg.t_enemy = $game_temp.battle_active_battler = @target_battlers[0]
        $msg.t_target = $game_temp.battle_target_battler[0] = @ecstasy_battlers_count[0]
      #自爆の場合、ホールド中ならその相手を、違うならランダムで会話する相手を選択
      else
        @self_ecstasy_flag = true
        talk_battler = []
        if @ecstasy_battlers_count[0].holding?
          for enemy in $game_troop.enemies
            if enemy.exist?
              if (enemy.hold.penis.battler == @ecstasy_battlers_count[0] or
               enemy.hold.vagina.battler == @ecstasy_battlers_count[0] or
               enemy.hold.mouth.battler == @ecstasy_battlers_count[0] or
               enemy.hold.anal.battler == @ecstasy_battlers_count[0] or
               enemy.hold.tops.battler == @ecstasy_battlers_count[0] or
               enemy.hold.tail.battler == @ecstasy_battlers_count[0] or
               enemy.hold.tentacle.battler == @ecstasy_battlers_count[0] or
               enemy.hold.dildo.battler == @ecstasy_battlers_count[0])
                talk_battler.push(enemy)
              end
            end
          end
        else
          for enemy in $game_troop.enemies
            if enemy.exist?
              talk_battler.push(enemy)
            end
          end
        end
        #会話エネミーを選択
        $msg.t_enemy = $game_temp.battle_active_battler = talk_battler[rand(talk_battler.size)]
        $msg.t_target = $game_temp.battle_target_battler[0] = @ecstasy_battlers_count[0]
      end
    #--------------------------------------------------------------------------------------
    # ●絶頂しているキャラクターがエネミーの場合
    #--------------------------------------------------------------------------------------
    elsif @ecstasy_battlers_count[0].is_a?(Game_Enemy)
      #トーク中の場合は攻撃エネミーが確定している
      if $msg.talking_ecstasy_flag == "enemy"
        $msg.t_enemy = $game_temp.battle_target_battler[0] = @ecstasy_battlers_count[0]
        $msg.t_target = $game_temp.battle_active_battler = @active_battler
      #自爆でない場合は攻撃エネミーが確定している
      elsif @ecstasy_battlers_count[0] != @active_battler
        $msg.t_enemy = $game_temp.battle_target_battler[0] = @ecstasy_battlers_count[0]
        $msg.t_target = $game_temp.battle_active_battler = @active_battler
      #自爆の場合、ホールド中ならその相手を、違うなら主人公を選択
      else
        @self_ecstasy_flag = true
        talk_battler = []
        if @ecstasy_battlers_count[0].holding?
           for actor in $game_party.actors
            if actor.exist?
              if (actor.hold.penis.battler == @ecstasy_battlers_count[0] or
               actor.hold.vagina.battler == @ecstasy_battlers_count[0] or
               actor.hold.mouth.battler == @ecstasy_battlers_count[0] or
               actor.hold.anal.battler == @ecstasy_battlers_count[0] or
               actor.hold.tops.battler == @ecstasy_battlers_count[0] or
               actor.hold.tail.battler == @ecstasy_battlers_count[0] or
               actor.hold.tentacle.battler == @ecstasy_battlers_count[0] or
               actor.hold.dildo.battler == @ecstasy_battlers_count[0])
                talk_battler.push(actor)
              end
            end
          end
        else
          for actor in $game_party.actors
            if actor.exist?
              talk_battler.push(actor)
            end
          end
        end
        #会話エネミーを選択
        $msg.t_enemy = $game_temp.battle_active_battler = talk_battler[rand(talk_battler.size)]
        $msg.t_target = $game_temp.battle_target_battler[0] = @ecstasy_battlers_count[0]
      end
    end
    #--------------------------------------------------------------------------------------
    # ●数値処理
    #--------------------------------------------------------------------------------------
    # 絶頂したキャラのSP減少量を算出(20150823ダメージ量改定)
    $ecstasy_loss_sp = 0
    #自爆時
    if @self_ecstasy_flag == true
      loss = 100 + ($mood.point * 15 / 10)
      loss += (@ecstasy_battlers_count[0].str / 2) if @ecstasy_battlers_count[0].holding?
      loss = [[loss, (@ecstasy_battlers_count[0].maxsp / 3)].max, 999].min
      loss = loss + rand(@ecstasy_battlers_count[0].level * 5)
      loss = loss.round
    #トーク中
    elsif $msg.talking_ecstasy_flag != nil
      case $msg.tag
      when "奉仕","視姦"
        ec_battler = $msg.t_enemy
      else
        ec_battler = $game_actors[101]
      end
      loss = 200 + ec_battler.dex + ($mood.point * 15 / 10)
      loss += ec_battler.str if @ecstasy_battlers_count[0].holding?
      loss = [[loss, (@ecstasy_battlers_count[0].maxsp / 3)].max, 999].min
      loss = loss + ($msg.talk_step * 5)
      loss = loss.round
      $game_switches[79] = false
    else
      loss = 200 + @active_battler.dex + ($mood.point * 15 / 10)
      loss += @active_battler.str if @ecstasy_battlers_count[0].holding?
      loss = [[loss, (@ecstasy_battlers_count[0].maxsp / 3)].max, 999].min
      loss = loss - ($game_temp.difference_damage / 3).floor
      #主人公インサート中、かつ絶頂対象との場合、大幅にダメージ増加
      if @ecstasy_battlers_count[0].vagina_insert?
        if @ecstasy_battlers_count[0].hold.vagina.battler == $game_actors[101]
          loss += [($game_actors[101].str * 3),200].max
        end
      end
      loss = loss.round
    end
    #ベッドイン中は減少量半減
    if $game_switches[85] == true
      loss = (loss / 2).ceil
    #通常戦闘中は、相手がボスでなければ原則一撃で昇天するダメージを与える
#    elsif @ecstasy_battlers_count[0].is_a?(Game_Enemy)
#      unless @ecstasy_battlers_count[0].element_rate(191) >= 2
#        loss = loss * 3
#      end
    end

    #--------------------------------------------------------------
    # 本気になる夢魔がまだ本気を出していない場合、ＶＰを１だけ残す
    #--------------------------------------------------------------
    if SR_Util.enemy_before_earnest?(@ecstasy_battlers_count[0])
      # 減少ＶＰがその夢魔の現在ＶＰ以上の場合
      if loss >= @ecstasy_battlers_count[0].sp
        # ＶＰを１だけ残す
        loss = @ecstasy_battlers_count[0].sp - 1
      end
    end
    
    # ここで減少するＶＰを確定するが、実際に減るのはこの次のステップで
    $ecstasy_loss_sp = loss
    unless $msg.talking_ecstasy_flag != nil
      attack_element_check
    else
      $msg.talking_ecstasy_flag = nil
    end
    #--------------------------------------------------------------------------------------
    # ●絶頂しているキャラクターがエネミーの場合
    #--------------------------------------------------------------------------------------
    # 絶頂しているのがエネミーの場合
    if @ecstasy_battlers_count[0].is_a?(Game_Enemy)
      # コモンイベント「絶頂（エネミー）」を実行
      common_event = $data_common_events[34]
      $game_system.battle_interpreter.setup(common_event.list, 0)
      @battle_log_window.contents.clear
      @battle_log_window.keep_flag = false
      $game_temp.battle_log_text = ""
    # 絶頂しているのがアクターの場合
    elsif @ecstasy_battlers_count[0].is_a?(Game_Actor)# == $game_actors[101]
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
      # コモンイベント「絶頂（アクター）」を実行
      common_event = $data_common_events[32]
      $game_system.battle_interpreter.setup(common_event.list, 0)
      @battle_log_window.contents.clear
      @battle_log_window.keep_flag = false
      $game_temp.battle_log_text = ""
    end
    @status_window.refresh
    # ステップ 502 に移行
    @phase4_step = 502
  end
  #--------------------------------------------------------------------------
  # ★ フレーム更新 (メインフェーズ ステップ 502 : 絶頂処理(単独)：後半)
  #--------------------------------------------------------------------------
  def update_phase4_step502
    # ●バトルログをクリア
    @battle_log_window.contents.clear
    @battle_log_window.keep_flag = false
    $game_temp.battle_log_text = ""
    # バトルイベント実行中の場合
    if $game_system.battle_interpreter.running?
      return
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
    #--------------------------------------------------------------------------------------
    # ●絶頂しているキャラクターがエネミーの場合の事後処理
    #--------------------------------------------------------------------------------------
    # 自爆以外でSPダウンフラグを与える場合の処理
    if @ecstasy_battlers_count[0].is_a?(Game_Enemy) and @ecstasy_battlers_count[0].sp_down_flag == true
      $game_temp.battle_log_text = "#{@ecstasy_battlers_count[0].name} has reached cliｍax!"
      # 絶頂させたキャラが【吸精】持ちの場合、吸精メソッドを通す
      if @active_battler.have_ability?("吸精")
        SR_Util.energy_drain(@active_battler,@ecstasy_battlers_count[0]) 
      end
      @ecstasy_battlers_count[0].animation_id = 13
      @ecstasy_battlers_count[0].animation_id = 127
      @ecstasy_battlers_count[0].animation_hit = true
      @ecstasy_battlers_count[0].add_state(1)
      @ecstasy_battlers_count[0].sp_down_flag = false
      @ecstasy_battlers_count[0].sp -= 1
    # 通常絶頂後処理
    else
      # 絶頂したキャラのＳＰを、前段階で算出していた値だけ減少。
      @ecstasy_battlers_count[0].sp = (@ecstasy_battlers_count[0].sp - $ecstasy_loss_sp)
      $ecstasy_loss_sp = 0 #リセット
      #----------------------------------------------------------------------
      # ●ＶＰが１以上残った場合
      #----------------------------------------------------------------------
      if @ecstasy_battlers_count[0].sp > 0
        #▼絶頂ステートを付与(ロウ君のみ衰弱ステート)
        @ecstasy_battlers_count[0].add_state(2) if @ecstasy_battlers_count[0] == $game_actors[101]
        @ecstasy_battlers_count[0].add_state(3) unless @ecstasy_battlers_count[0] == $game_actors[101]
        #▼絶頂処理を行う(絶頂カウントは口上処理の後で行う)
        #@ecstasy_battlers_count[0].ecstasy_turn = 1 + @ecstasy_battlers_count[0].ecstasy_count.size
        @ecstasy_battlers_count[0].ecstasy_turn = 2# + @ecstasy_battlers_count[0].ecstasy_count.size
        #@ecstasy_battlers_count[0].ecstasy_turn = 3 if @ecstasy_battlers_count[0].ecstasy_turn > 3
        @ecstasy_battlers_count[0].remove_state(6)
        @ecstasy_battlers_count[0].remove_state(11)
        #▼バッドステート解除
        for i in SR_Util.checking_states
          if @ecstasy_battlers_count[0].states.include?(i)
            @ecstasy_battlers_count[0].remove_state(i)
          end
        end
        #▼SPダウンフラグが入っていない場合、ここで絶頂アニメーションを表示
        unless @ecstasy_battlers_count[0].sp_down_flag
          @ecstasy_battlers_count[0].animation_id = 11
          @ecstasy_battlers_count[0].animation_hit = true
        end
        #▼実EPを最大値まで回復
        #  味方は全快、敵はＥＰ最大値の半分まで回復
        if @ecstasy_battlers_count[0].is_a?(Game_Actor)
          @ecstasy_battlers_count[0].hp = @ecstasy_battlers_count[0].maxhp
        elsif @ecstasy_battlers_count[0].is_a?(Game_Enemy)
          @ecstasy_battlers_count[0].hp = (@ecstasy_battlers_count[0].maxhp / 2).round
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
          @wait_count = $game_system.battle_speed_time(0)
        end
        #▼念のためバトルログをクリア
        @battle_log_window.contents.clear
        @battle_log_window.keep_flag = false
        $game_temp.battle_log_text = ""
        #----------------------------------------------------------------------
        # ●アクターとエネミーの処理
        if @ecstasy_battlers_count[0].is_a?(Game_Actor)
        # コモンイベント「絶頂後（アクター）」を実行
          common_event = $data_common_events[33]
          $game_system.battle_interpreter.setup(common_event.list, 0)
        elsif @ecstasy_battlers_count[0].is_a?(Game_Enemy)
          # 確定で出す場合、または予測減衰VPより対象のVPが多ければ絶頂口上を出す
          if ($game_switches[95] == true or
             $game_switches[91] == true or #ボス戦では必ず出す
             $game_switches[85] == true) #ベッドイン中は必ず出す
            # コモンイベント「絶頂後（エネミー）」を実行
            common_event = $data_common_events[35]
            $game_system.battle_interpreter.setup(common_event.list, 0)
            #▼システムウェイト
            case $game_system.ms_skip_mode
            when 3 #手動送りモード
              @wait_count = 1
            when 2 #デバッグモード
              @wait_count = 8
            when 1 #快速モード
              @wait_count = 12
            else
              @wait_count = $game_system.battle_speed_time(0)
            end
          end
        end
        #▼絶頂カウントを加算する
        @ecstasy_battlers_count[0].ecstasy_count.push(@active_battler)
        #▼ステートログをすべてクリア
        @ecstasy_battlers_count[0].add_states_log.clear
        @ecstasy_battlers_count[0].remove_states_log.clear
      #----------------------------------------------------------------------
      # ●ＶＰが０以下の場合
      #----------------------------------------------------------------------
      else
        # バトルログをクリア
        @battle_log_window.contents.clear
        @battle_log_window.keep_flag = false
        $game_temp.battle_log_text = ""
        if @ecstasy_battlers_count[0].is_a?(Game_Enemy)
          # 敵の場合
          # バトルログをクリア
          $game_temp.battle_log_text = "#{@ecstasy_battlers_count[0].name}を絶頂させた！"
          if @active_battler.have_ability?("吸精")
            SR_Util.energy_drain(@active_battler,@ecstasy_battlers_count[0]) 
          end
          @ecstasy_battlers_count[0].animation_id = 127
          @ecstasy_battlers_count[0].animation_hit = true
        else
          # コモンイベント「絶頂後（アクター）」を実行
          common_event = $data_common_events[33]
          $game_system.battle_interpreter.setup(common_event.list, 0)
          # 必ずコモン後にバトルログをクリア
          @battle_log_window.contents.clear
          @battle_log_window.keep_flag = false
          $game_temp.battle_log_text = ""
        end
      end
    end
    #----------------------------------------------------------------------
    # ホールド継続フラグの設定
    $game_switches[83] = false # 初期化
    if @ecstasy_battlers_count[0].holding?
      $game_switches[83] = true
      # 絶頂したバトラーが失神しているか、絶頂側が本気状態の挿入中でなく
      # アクティブ側のホールドイニシアチブが３未満だった時はホールドを継続しない
      if @ecstasy_battlers_count[0].dead? or
       (not @ecstasy_battlers_count[0].earnest_insert? and @active_battler.hold.initiative_level < 3)
        $game_switches[83] = false
      end
    end
    #----------------------------------------------------------------------
    #▼ステータスウィンドウ更新
    @status_window.refresh
    #----------------------------------------------------------------------
    # ●主人公が倒れるか否か
    #----------------------------------------------------------------------
    # ▼主人公が完全に倒れてしまった場合は速やかに終了
    if $game_actors[101].dead?
      @phase4_step = 6
    else
    # ▼主人公が健在ならホールド解除処理に移行
      @phase4_step = 503
    end
  end
  #--------------------------------------------------------------------------
  # ★ フレーム更新 (メインフェーズ ステップ 503 : 各種ホールド解除 )
  #--------------------------------------------------------------------------
  def update_phase4_step503
    # 各バトラーにホールド状況を記録
    hold_record
    # ホールド継続フラグが経っていない場合は解除
    unless $game_switches[83]
      # バトルログをクリア
      @battle_log_window.contents.clear
      @battle_log_window.keep_flag = false
      $game_temp.battle_log_text = ""
      make_unhold_text(@ecstasy_battlers_count[0])
      remove_hold("絶頂",@ecstasy_battlers_count[0])
    end
    # ホールド継続フラグをリセット
    $game_switches[83] = false
    
=begin
    #何かのホールドが相手にかかっているなら解除判定発生
    if @ecstasy_battlers_count[0].holding?
      if @ecstasy_battlers_count[0].dead? or @active_battler.hold.initiative_level < 3
        # バトルログをクリア
        @battle_log_window.contents.clear
        @battle_log_window.keep_flag = false
        $game_temp.battle_log_text = ""
        make_unhold_text(@ecstasy_battlers_count[0])
        remove_hold("絶頂",@ecstasy_battlers_count[0])
      end
    end
=end
    # ホールドポップの指示
    hold_pops_order
    # 敵夢魔がまだ倒れていない場合
    if not @ecstasy_battlers_count[0].dead?
      #▼システムウェイト
      case $game_system.ms_skip_mode
      when 3 #手動送りモード
        @wait_count = 1
      when 2 #デバッグモード
        @wait_count = 8
      when 1 #快速モード
        @wait_count = 12
      else
        @wait_count = $game_system.battle_speed_time(0) #元は20
      end
    else
      # バトルログをクリア
      @battle_log_window.contents.clear
      @battle_log_window.keep_flag = false
      $game_temp.battle_log_text = ""
    end
    @status_window.refresh
    # エネミーならすぐ絶頂時処理へ
    if @ecstasy_battlers_count[0].is_a?(Game_Enemy)
      #絶頂処理の済んだエネミーを消去
      @ecstasy_battlers_count.delete(@ecstasy_battlers_count[0])
      @phase4_step = 602
    # アクターなら入れ替え処理を入れてから
    else
      @phase4_step = 504
    end
  end
  #--------------------------------------------------------------------------
  # ★ フレーム更新 (メインフェーズ ステップ 5 : 戦闘不能時処理 )
  #--------------------------------------------------------------------------
  def update_phase4_step504
    # ステップ602（絶頂後挙動）のフラグ
    @phase4_step = 602
    target = @ecstasy_battlers_count[0]
    #絶頂処理を終えたアクターを消去
    @ecstasy_battlers_count.delete(@ecstasy_battlers_count[0])
    #------------------------------------------------------------------------
    if target.dead?
      for i in $game_party.party_actors
        if not i.dead? and not $game_party.battle_actors.include?(i)
#        if not i.dead? and i != $game_party.party_actors[0] and
#         i != $game_party.party_actors[1]
          # 失神、裸系以外のステートを全て解除
          for n in target.states
            target.remove_state(n) unless [1,4,5].include?(n)
          end
          target.remove_states_log.clear
          #ホールド全解除
          target.hold_reset
          # 複製を作る
          a_actor = target#.dup
          b_actor = i#.dup
          # 指定したメンバーを交代する。
=begin
          if target == $game_party.party_actors[0]
            $game_party.battle_actors[0] = b_actor
            $game_party.party_actors[0] = b_actor
            appear_battler = $game_party.battle_actors[0]
          end
          if target == $game_party.party_actors[1]
            $game_party.battle_actors[1] = b_actor
            $game_party.party_actors[1] = b_actor
            appear_battler = $game_party.battle_actors[1]
          end
          if i == $game_party.party_actors[3]
            $game_party.party_actors[3] = a_actor
          elsif i == $game_party.party_actors[2]
            $game_party.party_actors[2] = a_actor
          end
=end
          for num in 0...$game_party.party_actors.size
            if target == $game_party.party_actors[num]
              $game_party.battle_actors.delete(target)
              $game_party.battle_actors.push(b_actor)
              $game_party.party_actors[num] = b_actor
              appear_battler = b_actor
              break
            end
          end
          for num in 0...$game_party.party_actors.size
            if i == $game_party.party_actors[num]
              $game_party.party_actors[num] = a_actor
              break
            end
          end
          
          i = a_actor
          #●戦闘開始処理関連で設定漏れがあれば再度設定
          b_actor.state_runk = [0, 0, 0, 0, 0, 0] if b_actor.state_runk == nil
          b_actor.ecstasy_count = [] if b_actor.ecstasy_count == nil
          b_actor.crisis_flag = false
          b_actor.skill_collect = nil
          b_actor.hold_reset
          b_actor.lub_male = 0 if b_actor.lub_male == nil or not b_actor.lub_male > 0
          b_actor.lub_female = 0 if b_actor.lub_female == nil or not b_actor.lub_female > 0
          b_actor.lub_anal = 0 if b_actor.lub_anal == nil or not b_actor.lub_anal > 0
          b_actor.used_mouth = 0 if b_actor.used_mouth == nil or not b_actor.used_mouth > 0
          b_actor.used_anal = 0 if b_actor.used_anal == nil or not b_actor.used_anal > 0
          b_actor.used_sadism = 0 if b_actor.used_sadism == nil or not b_actor.used_sadism > 0
          b_actor.ecstasy_turn = 0 if b_actor.ecstasy_turn == nil
          b_actor.sp_down_flag = false if b_actor.sp_down_flag == nil or b_actor.sp_down_flag == true
          b_actor.ecstasy_emotion = nil
          b_actor.add_states_log.clear
          b_actor.remove_states_log.clear
          b_actor.resist_count = 0 if b_actor.resist_count == nil
          #ベッドイン時、空腹襲撃時は最初から弱点チェックをtrueにする
          if $game_switches[85] == true or $game_switches[86] == true
            b_actor.checking = 1
          else
            b_actor.checking = 0
          end
          $game_party.battle_actor_refresh
          # バトルログを表示
          $game_temp.battle_log_text += b_actor.name + " has entered battle!\w\q"
          # ステータス画面をリフレッシュ
          @status_window.refresh
          #●バトルトーク関連をリセット
          $game_temp.action_num = 0
          $game_temp.attack_combo_target = ""
          # アクション強制対象のバトラーをクリア
          $game_temp.forcing_battler = nil
          # 画像変更
          $game_party.battle_actors[1].graphic_change = true
          # アニメーションを表示
          $game_party.battle_actors[1].animation_id = 18
          $game_party.battle_actors[1].animation_hit = true
          #▼システムウェイト
          case $game_system.ms_skip_mode
          when 3 #手動送りモード
            @wait_count = 1
          when 2 #デバッグモード
            @wait_count = 8
          when 1 #快速モード
            @wait_count = 12
          else
            @wait_count = $game_system.battle_speed_time(0)
          end
=begin
          # 出現時エフェクトのフェイズへ
          @phase4_step = 16
          @phase4_step16_count = 0
=end
          # 出現時エフェクトの処理を行う
          appear_effect_order([appear_battler])
          return
        end
      end
    end
    #------------------------------------------------------------------------
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新 (メインフェーズ ステップ 601 : 追撃判定)
  #--------------------------------------------------------------------------
  def update_phase4_step601
    #★絶頂していない場合、追撃判定をここで行う
    if $game_temp.battle_target_battler[0].hp > 0
      if @active_battler.is_a?(Game_Enemy)
        plural_attack_check(@skill,@target_battlers[0])
      elsif @active_battler.current_action.kind == 1
        #アクター行動中でスキル使用時のみ追撃判定を行う
        plural_attack_check(@skill,@target_battlers[0])
      else
        $game_switches[78] = false
        $weak_number = $weak_result = 0
      end
    else
      $game_switches[78] = false
      $weak_number = $weak_result = 0
    end
    @phase4_step = 6
  end

  #--------------------------------------------------------------------------
  # ● フレーム更新 (メインフェーズ ステップ 602 : 絶頂後の挙動)
  #--------------------------------------------------------------------------
  def update_phase4_step602
    #●絶頂処理が必要なキャラクターがまだ存在する場合
    if @ecstasy_battlers_count.size > 0
      # ステップ5（絶頂処理分岐）に飛ばす
      @phase4_step = 5
    else
      # 全員の絶頂時エフェクトの指示を出す
      dead_effect_order(@battlers)
      # ステップ6（リフレッシュ）に飛ばす
      @phase4_step = 6
    end
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新 (メインフェーズ ステップ 6 : リフレッシュ)
  #--------------------------------------------------------------------------
  def update_phase4_step6
#    p "update4-6"if $DEBUG
    case @active_battler.current_action.kind
    when 1 #スキルの場合
      @command = @skill
    when 2 #スキルの場合
      @command = @item
    else
      @command = nil
    end
    # 誘引フラグを初期化する
    $game_temp.incite_flag = false

    # コモンイベント ID が有効の場合
    if @common_event_id > 0
      if @command == nil
        unless (@skill != nil and @skill.name == "トーク")
          # イベントをセットアップ
          common_event = $data_common_events[@common_event_id]
          $game_system.battle_interpreter.setup(common_event.list, 0)
        end
      elsif not @command.name == "トーク"
        # イベントをセットアップ
        common_event = $data_common_events[@common_event_id]
        $game_system.battle_interpreter.setup(common_event.list, 0)
      end
    end
    
    # ヘルプウィンドウを隠す
    @help_window.visible = false
    # ★ヘルプウィンドウ帯を隠す
    @help_window.window.visible = false
    
    # ★バトルログのクリア
    @battle_log_window.contents.clear
    @battle_log_window.keep_flag = false
    $game_temp.battle_log_text = ""
    # ★逃走が成功している場合逃走
    if @escape_success == true
      # バトル開始前の BGM に戻す
      $game_system.bgm_play($game_temp.map_bgm)
      @escape_success = false
      battle_end(1)
    end
    #絶頂中、会話中は追撃を打ち切る
    if ($game_switches[77] == true or $game_switches[79] == true or @combo_break == true)
      $game_switches[78] = false
    end
    # ●追撃発生中
    if $game_switches[78] == true
      #追撃発生で、相手のEPが０以上なら追撃項目へ移動
      if $game_temp.battle_target_battler[0].hp > 0
        $weak_result += 1 #行った回数を＋１
        # バトルログを表示
        if @active_battler.is_a?(Game_Actor)
          # 口上イベントをセットアップ
          common_event = $data_common_events[31]
          $game_system.battle_interpreter.setup(common_event.list, 0)
        else
#          p "追撃中/対象：#{$game_temp.battle_target_battler[0].name}"
          # 口上イベントをセットアップ
          common_event = $data_common_events[31]
          $game_system.battle_interpreter.setup(common_event.list, 0)
          # ランダムスキルを再装填するため専用ページへ飛ばす
          random_skill_action
        end
        #トークステップを１進める
        $msg.talk_step += 1
        # ステップ 2 に移行し再攻撃
        @phase4_step = 2
      #相手が絶頂していたら終了
      else
        # メッセージタグをクリア
#        $msg.tag = ""
        # アクション強制対象のバトラーをクリア
        $game_temp.forcing_battler = nil
        #口上管理系スイッチを切っておく
        for i in 77..82
          $game_switches[i] = false
        end
        #絶頂行動パターンを初期化する
        for actor in $game_party.party_actors
          actor.ecstasy_emotion = nil if actor.exist?
        end
        for enemy in $game_troop.enemies
          enemy.ecstasy_emotion = nil if enemy.exist?
        end
        # ★追撃発生時は多重行動用フラグを下げる
        @active_battler.another_action = false
        #トークステップ、追撃攻撃手段をリセットする
        $msg.talk_step = 0
        $msg.at_parts = $msg.at_type = ""
        $msg.t_enemy = $msg.t_target = nil
        $msg.coop_enemy = []
        @combo_break = false
        $msg.moody_flag = false
        $game_switches[89] = false #レジスト受諾スイッチ
        # ステップ 1 に移行
        @phase4_step = 1
      end
    else
      # メッセージタグをクリア
#      $msg.tag = ""
      # アクション強制対象のバトラーをクリア
      $game_temp.forcing_battler = nil
      #口上管理系スイッチを切っておく
      for i in 77..82
        $game_switches[i] = false
      end
      #絶頂行動パターンを初期化する
      for actor in $game_party.party_actors
        actor.ecstasy_emotion = nil if actor.exist?
      end
      for enemy in $game_troop.enemies
        enemy.ecstasy_emotion = nil if enemy.exist?
      end
      # ★多重行動用フラグを立てる
      @active_battler.another_action = true
      #トークステップ、追撃攻撃手段をリセットする
      $msg.talk_step = 0
      $msg.at_parts = $msg.at_type = ""
      $msg.t_enemy = $msg.t_target = nil
      $msg.coop_enemy = []
      @combo_break = false
      $msg.moody_flag = false
      $game_switches[89] = false #レジスト受諾スイッチ
      # ステップ 1 に移行
      @phase4_step = 1
    end
  end
end