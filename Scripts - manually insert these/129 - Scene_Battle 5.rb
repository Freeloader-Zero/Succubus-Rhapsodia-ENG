#==============================================================================
# ■ Scene_Battle (分割定義 5)
#------------------------------------------------------------------------------
# 　バトル画面の処理を行うクラスです。
#==============================================================================

class Scene_Battle
  #--------------------------------------------------------------------------
  # ● 基本アクション 結果作成
  #--------------------------------------------------------------------------
  def make_basic_action_result
    #▼システムウェイト
    case $game_system.ms_skip_mode
    when 3 #手動送りモード
      @wait_count = $game_system.battle_speed_time(0)
    when 2 #デバッグモード
      @wait_count = 8
    when 1 #快速モード
      @wait_count = 12
    else
      @wait_count = $game_system.battle_speed_time(0)
    end
    
    # 攻撃の場合
    if @active_battler.current_action.basic == 0
      # アニメーション ID を設定
      @animation1_id = @active_battler.animation1_id
      @animation2_id = @active_battler.animation2_id
      # 行動側バトラーがエネミーの場合
      if @active_battler.is_a?(Game_Enemy)
        if @active_battler.restriction == 3
          target = $game_troop.random_target_enemy
        elsif @active_battler.restriction == 2
          target = $game_party.random_target_actor
        else
          index = @active_battler.current_action.target_index
          target = $game_party.smooth_target_actor(index)
        end
      end
      # 行動側バトラーがアクターの場合
      if @active_battler.is_a?(Game_Actor)
        if @active_battler.restriction == 3
          target = $game_party.random_target_actor
        elsif @active_battler.restriction == 2
          target = $game_troop.random_target_enemy
        else
          index = @active_battler.current_action.target_index
          target = $game_troop.smooth_target_enemy(index)
        end
      end
      # 対象側バトラーの配列を設定
      @target_battlers = [target]
      # 通常攻撃の効果を適用
      for target in @target_battlers
        target.attack_effect(@active_battler)
      end
      return
    end
    # 防御の場合
    if @active_battler.current_action.basic == 1
      # ★ヘルプウィンドウ帯を表示
      @help_window.window.visible = true
      # ヘルプウィンドウに "防御" を表示
      @help_window.set_text($data_system.words.guard, 1)
      #  ★バトルログを表示
      $game_temp.battle_log_text += @active_battler.name + "は防御している……\067"
      @phase4_step = 6
      return
    end
    # 逃げるの場合
    if @active_battler.is_a?(Game_Enemy) and
       @active_battler.current_action.basic == 2
      # ★ヘルプウィンドウ帯を表示
      @help_window.window.visible = true
      # ヘルプウィンドウに "逃げる" を表示
      @help_window.set_text("逃げる", 1)
      # ★バトルログを表示
      # 逃げるメッセージは別の場所に書かないとダメみたい。(調査中)
      $game_temp.battle_log_text += @active_battler.name + "は逃げ出した！\067"
      # 逃げる
      @active_battler.escape
      @phase4_step = 6
      return
    end
    # 何もしないの場合
    if @active_battler.current_action.basic == 3
      # アクション強制対象のバトラーをクリア
      $game_temp.forcing_battler = nil
      # 隠れている夢魔とスタン状態の夢魔はログを出さない。
      if @active_battler.hidden == false and @active_battler.another_action == false
        if @active_battler.is_a?(Game_Enemy) and not $game_temp.first_attack_flag == 1
          # ★バトルログを表示
          $game_temp.battle_log_text += @active_battler.name + " is observing...\067"
        else
          @wait_count = 0
        end
        @phase4_step = 6
        return
      else
        # ★ステップ 6 に移行
        @wait_count = 0
        @phase4_step = 6
        return
      end
    end
    # 逃走の場合
    if @active_battler.current_action.basic == 2
      # 逃走可能な場合は逃走
      if @active_battler.can_escape?
        # アクション強制対象のバトラーをクリア
        $game_temp.forcing_battler = nil
        @active_battler.white_flash = true
        # ★バトルログを表示
        $game_temp.battle_log_text += @active_battler.name + " ran aｗay!\065\067"
        # ウェイトを再設定
        #▼システムウェイト
        case $game_system.ms_skip_mode
        when 3 #手動送りモード
          @wait_count = 1
        when 2 #デバッグモード
          @wait_count = 6
        when 1 #快速モード
          @wait_count = 8
        else
          @wait_count = 12
        end
        # 逃走 SE を演奏
        $game_system.se_play($data_system.escape_se)
        escape_result
      # 逃走不可能な場合はウェイトを０にして終了
      else
        @wait_count = 0
      end
      @phase4_step = 6
      return
    end
    # パーティ交代の場合
    if @active_battler.current_action.basic == 5
      # 交代可能な場合は交代
      if @active_battler.can_escape?
        # 交代前のステート回復
        # 失神、裸系以外のステートを全て解除
        for n in @active_battler.states
          @active_battler.remove_state(n) unless [1,4,5].include?(n)
        end
        @active_battler.remove_states_log.clear
        #ホールド全解除
        @active_battler.hold_reset
        # 複製を作る
        actor_1 = $game_party.party_actors[@active_battler.change_index[0]]#.dup
        actor_2 = $game_party.party_actors[@active_battler.change_index[1]]#.dup
        # 指定したメンバーを交代する
        $game_party.party_actors[@active_battler.change_index[0]] = actor_2
        $game_party.party_actors[@active_battler.change_index[1]] = actor_1
        $game_party.battle_actor_refresh
        @active_battler = $game_party.party_actors[@active_battler.change_index[0]]
        # 画像変更
        @active_battler.graphic_change = true
        #●戦闘開始処理関連で設定漏れがあれば再度設定
        actor_2.state_runk = [0, 0, 0, 0, 0, 0] if actor_2.state_runk == nil
        actor_2.ecstasy_count = [] if actor_2.ecstasy_count == nil
        actor_2.crisis_flag = false
        actor_2.skill_collect = nil
        actor_2.hold_reset
        actor_2.lub_male = 0 if actor_2.lub_male == nil or not actor_2.lub_male > 0
        actor_2.lub_female = 0 if actor_2.lub_female == nil or not actor_2.lub_female > 0
        actor_2.lub_anal = 0 if actor_2.lub_anal == nil or not actor_2.lub_anal > 0
        actor_2.used_mouth = 0 if actor_2.used_mouth == nil or not actor_2.used_mouth > 0
        actor_2.used_anal = 0 if actor_2.used_anal == nil or not actor_2.used_anal > 0
        actor_2.used_sadism = 0 if actor_2.used_sadism == nil or not actor_2.used_sadism > 0
        actor_2.ecstasy_turn = 0 if actor_2.ecstasy_turn == nil
        actor_2.ecstasy_emotion = nil
        actor_2.sp_down_flag = false if actor_2.sp_down_flag == nil or actor_2.sp_down_flag == true
        actor_2.resist_count = 0 if actor_2.resist_count == nil
        actor_2.add_states_log.clear
        actor_2.remove_states_log.clear
        #ベッドイン時、空腹襲撃時は最初から弱点チェックをtrueにする
        if $game_switches[85] == true or $game_switches[86] == true
          actor_2.checking = 1
        else
          actor_2.checking = 0
        end
        # バトルログを表示
        $game_temp.battle_log_text += actor_1.name + " and " + actor_2.name + "\065\n sｗitched places!\065\067"
        # ステータス画面をリフレッシュ
        @status_window.refresh
        # アクション強制対象のバトラーをクリア
        $game_temp.forcing_battler = nil
        # アニメーションを表示
        @active_battler.animation_id = 18
        @active_battler.animation_hit = true
        # 出現時エフェクトのフェイズへ
        appear_effect_order([@active_battler])
      # 交代不可能な場合はウェイトを０にして終了
      else
        @wait_count = 0
      end
      @phase4_step = 6
      return
    end
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新 (パーティコマンドフェーズ : 逃げる)
  #--------------------------------------------------------------------------
  def escape_result
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
        agi_one = actor.agi
        # 麻痺は素早さを1/10扱いにする。
        agi_one /= 10 if actor.state?(39)
        actors_agi += agi_one
        actors_number += 1
      end
    end
    if actors_number > 0
      # 平均値を算出
      actors_agi /= actors_number
      # 全体逃走補正はここで掛ける
      actors_agi += actors_agi / 2 if @active_battler.equip?("逃走のアンクレット")
      actors_agi += actors_agi / 2 if @active_battler.have_ability?("逃走の極意")
    end
    # 逃走成功判定
    success = rand(100) < 50 * actors_agi / enemies_agi
    # 逃走成功の場合(先制時は１００％逃げられる)
    if success or @actor_first_attack == true
      @escape_success = true
    # 逃走失敗の場合
    else
      # ★バトルログを表示
      $game_temp.battle_log_text += "しかし回りこまれてしまった！\067"
      # ウェイトを再設定
      #▼システムウェイト
      case $game_system.ms_skip_mode
      when 3 #手動送りモード
        @wait_count = $game_system.battle_speed_time(0)
      when 2 #デバッグモード
        @wait_count = 8
      when 1 #快速モード
        @wait_count = 12
      else
        @wait_count = $game_system.battle_speed_time(0)
      end
      #対象事前選定済みトークステップを設定
      $msg.callsign = 40
      $msg.talk_step = 100
=begin
      talk = []
      for enemy in $game_troop.enemies
        if enemy.talkable?
          talk.push(enemy)
        end
      end
      talk.push($game_actors[101]) if talk == []
      $msg.t_enemy = talk[rand(talk.size)]
      $msg.t_target = $game_actors[101]
=end
      $msg.tag = "逃走失敗"
      @common_event_id = 31
      #処理が終わったら必ずステップを０に戻す
      $msg.talk_step = 0
    end
  end
  #--------------------------------------------------------------------------
  # ● スキルまたはアイテムの対象側バトラー設定
  #     scope : スキルまたはアイテムの効果範囲
  #--------------------------------------------------------------------------
  def set_target_battlers(scope, skill_id = nil)
    
    # 追記
    # 引数にskill_idを追加し、対象のスムーズな決定にスキルIDを引き継ぐようにしました。
    
    # 行動側バトラーがエネミーの場合
    if @active_battler.is_a?(Game_Enemy)
      # 効果範囲で分岐
      case scope
      when 1  # 敵単体
        index = @active_battler.current_action.target_index
#        p "行動：#{@active_battler.name}/対象index：#{index}"if $DEBUG
        @target_battlers.push($game_party.smooth_target_actor(index, skill_id))
      when 2  # 敵全体
        for actor in $game_party.actors
          if actor.exist?
            @target_battlers.push(actor)
          end
        end
      when 3  # 味方単体
        index = @active_battler.current_action.target_index
        @target_battlers.push($game_troop.smooth_target_enemy(index,skill_id))
      when 4  # 味方全体
        for enemy in $game_troop.enemies
          if enemy.exist?
            @target_battlers.push(enemy)
          end
        end
      when 5  # 味方単体 (HP 0) 
        index = @active_battler.current_action.target_index
        enemy = $game_troop.enemies[index]
        if enemy != nil and enemy.hp0?
          @target_battlers.push(enemy)
        end
      when 6  # 味方全体 (HP 0) 
        for enemy in $game_troop.enemies
          if enemy != nil and enemy.hp0?
            @target_battlers.push(enemy)
          end
        end
      when 7  # 使用者
        @target_battlers.push(@active_battler)
      end
    end
    # 行動側バトラーがアクターの場合
    if @active_battler.is_a?(Game_Actor)
      # 効果範囲で分岐
      case scope
      when 1  # 敵単体
        index = @active_battler.current_action.target_index
        @target_battlers.push($game_troop.smooth_target_enemy(index,skill_id))
      when 2  # 敵全体
        for enemy in $game_troop.enemies
          if enemy.exist?
            @target_battlers.push(enemy)
          end
        end
      when 3  # 味方単体
        index = @active_battler.current_action.target_index
        @target_battlers.push($game_party.smooth_target_actor(index,skill_id))
      when 4  # 味方全体
        for actor in $game_party.actors
          if actor.exist?
            @target_battlers.push(actor)
          end
        end
      when 5  # 味方単体 (HP 0) 
        index = @active_battler.current_action.target_index
        actor = $game_party.actors[index]
        if actor != nil and actor.hp0?
          @target_battlers.push(actor)
        end
      when 6  # 味方全体 (HP 0) 
        for actor in $game_party.actors
          if actor != nil and actor.hp0?
            @target_battlers.push(actor)
          end
        end
      when 7  # 使用者
        @target_battlers.push(@active_battler)
      end
    end
  end
  #--------------------------------------------------------------------------
  # ● スキルアクション 結果作成
  #--------------------------------------------------------------------------
  def make_skill_action_result
    # スキルを取得
    @skill = $data_skills[@active_battler.current_action.skill_id]
    
    # nil対策
    if @skill == nil
      @skill = $data_skills[299] # エモーション
    end
    
    # 強制アクション中以外且つスキルが使用不可な場合
    if not @active_battler.current_action.forcing and @active_battler.is_a?(Game_Actor)
      # スキルが妥協できる場合、妥協してチェック。
      # 妥協しても使用不可能な場合は即終了
      end_flag = false
      while end_flag == false
        unless @active_battler.skill_can_use?(@skill.id)
          # ヘヴィピストン→ピストン
          if @skill.id == 33
            new_id = 32
            @skill = $data_skills[new_id]
            @active_battler.current_action.skill_id = new_id
            next
          end
          $game_temp.forcing_battler = nil
          @active_battler.another_action = true
          @phase4_step = 1
          return
        end
        end_flag = true
      end
    end
    # 畏怖の場合、３０％の確率で行動不能になる
    # (ただし既にメイクアクションで畏怖行動がセットされた場合は飛ばす)
    unless @skill.id == 297
      if @active_battler.states.include?(38) and rand(100) < 30
        @skill = $data_skills[297]
        @active_battler.current_action.forcing = true
        @active_battler.another_action = false
      end
    end
    # 暴走の場合、必ずランダムアクションとなる
    if @active_battler.state?(36) and not @active_battler.berserk == false
      @active_battler.berserk = true
    elsif @active_battler.berserk == true and not @active_battler.state?(36)
      @active_battler.berserk = false
    end
    if @active_battler.berserk == true and $game_switches[78] == false
      @skill = $data_skills[296] if @skill.id != 296
      @active_battler.another_action = false
#      @active_battler.current_action.forcing = true
    end

#    p "使用スキル(開始)：#{@skill.name}" if $DEBUG
#    p @active_battler.current_action.kind if $DEBUG
    # 対象側バトラーを設定
    set_target_battlers(@skill.scope, @skill.id)
    # ★ターゲットバトラーの情報を記憶　※コモンイベントで使います。
    $game_temp.battle_target_battler = @target_battlers
#    p "行動5-2：#{@active_battler.name}/対象index：#{@active_battler.current_action.target_index}"if $DEBUG
#    p "対象(開始)：#{@target_battlers[0].name}" if $DEBUG

    # ★ランダムスキルを使用する場合、専用ページへ飛ばす
    if @skill.element_set.include?(9)
#      p $data_skills[@active_battler.current_action.skill_id].name
      random_skill_action
    end
    
    # エラーテキストを初期化
    @error_text = ""
   
    # ★---------------------------------------------------------------

    # 攻撃側がエネミーの場合
    if @active_battler.is_a?(Game_Enemy)
      ct = 0
      # ■追記部分-----------------------------------  
      #
      # 発動不可なスキルの場合、発動可能なものが出るまで選び直し
      #
      # ------------------------------------------------------------

      loop do
        #----------------------------------------------------------------
        # ■ エラー集
        #----------------------------------------------------------------
        # エラー用変数をリセット
        n = 0
        a = 0
#        a = 1 if $DEBUG
        # ★ターゲット優先順位
        #   妄執(ロウラットしか狙わない)＞ホールド対象＞イントラスト＞アピール＞マーキング
        # ■アピール状態のパートナーがいる場合、そちらに攻撃が集中する
        #   ただしトーク中、挿入中はその限りではない
        
        # 元のＶＰ消費が０且つ、虚脱等で消費ＶＰが現在のＶＰより下回っている場合、
        # 即小休止にする
        if SR_Util.sp_cost_result(@active_battler, @skill) >= @active_battler.sp and
         @skill.sp_cost == 0
          # 小休止を使用する
          @active_battler.current_action.skill_id = 970
          @skill = $data_skills[@active_battler.current_action.skill_id]
          @active_battler.current_action.kind = 1
          if @skill.scope == 7 #自分に行うもの
            $game_temp.attack_combo_target = @active_battler
            @target_battlers = []
            @target_battlers.push($game_temp.attack_combo_target)
            # ★ターゲットバトラーの情報を記憶
            $game_temp.battle_target_battler = @target_battlers
          end
          if @active_battler.is_a?(Game_Enemy)
            @active_battler.current_action.decide_random_target_for_enemy
          end
          $game_temp.battle_target_battler = @target_battlers
          # ●記憶したスキルを解除
          $game_temp.skill_selection = nil
          break
        end
        
        #対味方戦(空腹時、ベッドイン時)は一部魔法を制限する
        if ($game_switches[85] == true or $game_switches[86] == true)
          #完全に使用不可の場合
          if @skill.element_set.include?(69)
            n = 1
            p "対味方戦時は使用不可" if a == 1
          #制限がかかる場合は、１／２の確率で再調整
          elsif @skill.element_set.include?(68)
            if rand(100) > 20
              n = 1
              p "対味方戦時の制限により使用不可" if a == 1
            end
          end
        end
        # ■ホールド中の相手のみを対象とするスキルの選定
        if @skill.element_set.include?(189)
          unless @target_battlers[0].holding?
            n = 1
            p "ホールド中のキャラクターでないので不可" if a == 1
          end
        # ■非ホールド状態の相手のみを対象とするスキルの選定
        elsif @skill.element_set.include?(188)
          if @target_battlers[0].holding?
            n = 1
            p "ホールド中のキャラクターなので不可" if a == 1
          end
        end
        # ■魔法スキルの場合、自身がホールド中だと使用不可
        if @skill.element_set.include?(5)
        #----------------------------------------------------------------
          if @active_battler.holding?
            n = 1
            p "自身がホールド中なので使用不可" if a == 1
          end
        end
        # ■自分を対象に取れないスキルで自分を選択した場合使用不可
        if @skill.element_set.include?(19)
        #----------------------------------------------------------------
          if @active_battler == @target_battlers[0]
            n = 1
            p "自分を対象に取れないスキルなので使用不可" if a == 1
          end
        end
        # ■自分：着衣中不可のスキルの場合
        if @skill.element_set.include?(177)
        #----------------------------------------------------------------
          #口挿入(ホールドタイプ：挿入で対象が口)を除く挿入は、相手が挿入可能な状況でなければ弾く
          if @skill.element_set.include?(134)
            unless @skill.element_set.include?(91)
              unless (@active_battler.insertable_half_nude? or @active_battler.full_nude?)
                n = 1
                p "エネミー側が着衣のため不可(挿入系)：#{@active_battler.name}：#{@skill.name}" if a == 1
              end
            end
          # 自分が着衣状態である場合
          elsif not @active_battler.full_nude?
            n = 1
            p "エネミー側が着衣のため不可：#{@active_battler.name}：#{@skill.name}" if a == 1
          end
        end
        # ■相手：着衣中不可のスキルの場合
        if @skill.element_set.include?(178)
        #----------------------------------------------------------------
          #口挿入(ホールドタイプ：挿入で対象が口)を除く挿入は、相手が挿入可能な状況でなければ弾く
          if @skill.element_set.include?(134)
            unless @skill.element_set.include?(91)
              unless (@target_battlers[0].insertable_half_nude? or @target_battlers[0].full_nude?)
                n = 1
                p "アクター側が着衣のため不可(挿入系)：#{@target_battlers[0].name}：#{@skill.name}" if a == 1
              end
            end
          # 相手が着衣状態である場合
          elsif not @target_battlers[0].full_nude?
            n = 1
            p "アクター側が着衣のため不可：#{@target_battlers[0].name}：#{@skill.name}" if a == 1
          end
        end
        # ■自分：脱衣中不可のスキルの場合
        if @skill.element_set.include?(179)
        #----------------------------------------------------------------
          # 自分が裸状態である場合
          if @active_battler.nude?
            n = 1
            p "エネミー側が裸のため不可：#{@active_battler.name}：#{@skill.name}" if a == 1
          end
        end
        # ■相手：脱衣中不可のスキルの場合
        if @skill.element_set.include?(180)
        #----------------------------------------------------------------
          # 相手が裸状態である場合
          if @target_battlers[0].full_nude?
            n = 1
            p "アクター側が裸のため不可：#{@target_battlers[0].name}：#{@skill.name}" if a == 1
          end
        end

      
        # ■ホールド中優勢時専用スキルの場合
        if @skill.element_set.include?(137) and @active_battler.holding?
        #------------------------------------------------------------------------
          # 自分が劣勢の場合
          unless @active_battler.initiative?
            n = 1
          end
        end
        # ■ホールド中劣勢時専用スキルの場合
        #------------------------------------------------------------------------
        if @skill.element_set.include?(138) and @active_battler.holding?
          # 自分が劣勢の場合
          if @active_battler.initiative?
            n = 1
          end
        end
        #------------------------------------------------------------------------
        # ■自分：♂占有中不可のスキルの場合
        if @skill.element_set.include?(140)
          # 自分のペニスが誰かバトラーで占有されていれば不可
          if @active_battler.hold.penis.battler != nil
            n = 1
          end
        end
        #------------------------------------------------------------------------
        # ■相手：♂占有中不可のスキルの場合
        if @skill.element_set.include?(141)
          # 自分のペニスが誰かバトラーで占有されていれば不可
          if @target_battlers[0].hold.penis.battler != nil
            n = 1
          end
        end
        # ■♂占有中のみ可のスキルの場合
        #------------------------------------------------------------------------
        if @skill.element_set.include?(142)
          # 自分の♂が♀挿入状態で無い場合
          unless @active_battler.penis_insert?
            n = 1
          end
        end
        if @skill.element_set.include?(143)
        # 自分の♂が口淫状態で無い場合
          unless @active_battler.penis_oralsex?
            n = 1
          end
        end
        if @skill.element_set.include?(144)
        # 自分の♂が肛姦状態で無い場合
          unless @active_battler.penis_analsex?
            n = 1
          end
        end
        #------------------------------------------------------------------------
        # ■自分：口占有中不可のスキルの場合
        if @skill.element_set.include?(146)
          # 口が占有中の場合
          if @active_battler.hold.mouth.battler != nil
            n = 1
          end
        end
        # ■相手：口占有中不可のスキルの場合
        if @skill.element_set.include?(147)
          # 口が占有中の場合
          if @target_battlers[0].hold.mouth.battler != nil
            n = 1
          end
        end
        # ■口挿入中のみ可のスキルの場合
        #------------------------------------------------------------------------
        if @skill.element_set.include?(148)
        # 自分の口が口挿入状態で無い場合
          unless @active_battler.mouth_oralsex?
            n = 1
          end
        end
        if @skill.element_set.include?(149)
        # 自分の口が顔面騎乗状態で無い場合
          unless @active_battler.mouth_riding?
            n = 1
          end
        end
        if @skill.element_set.include?(145)
        # 自分の口が尻騎乗状態で無い場合
          unless @active_battler.mouth_hipriding?
            n = 1
          end
        end
        if @skill.element_set.include?(150)
        # 自分の口がクンニ状態で無い場合
          unless @active_battler.mouth_draw?
            n = 1
          end
        end
        if @skill.element_set.include?(170)
        # 自分の口がDキッス状態で無い場合
          unless @active_battler.deepkiss?
            n = 1
          end
        end
        #------------------------------------------------------------------------
        # ■自分：尻占有中不可のスキルの場合
        if @skill.element_set.include?(151)
          # 自分が尻挿入中の場合
          if @active_battler.hold.anal.battler != nil
            n = 1
          end
        end
        # ■相手：尻占有中不可のスキルの場合
        if @skill.element_set.include?(152)
          # 自分が尻挿入中の場合
          if @target_battlers[0].hold.anal.battler != nil
            n = 1
          end
        end
        # ■尻占有中のみ可のスキルの場合
        #------------------------------------------------------------------------
        if @skill.element_set.include?(153)
          # 自分の尻が尻挿入状態で無い場合
          unless @active_battler.anal_analsex?
            n = 1
          end
        end
        if @skill.element_set.include?(154)
          # 自分の尻が尻騎乗状態で無い場合
          unless @active_battler.anal_hipriding?
            n = 1
          end
        end
        #------------------------------------------------------------------------
        # ■自分：♀占有中不可のスキルの場合
        if @skill.element_set.include?(155)
          # 自分が♀占有中の場合
          if @active_battler.hold.vagina.battler != nil
            n = 1
          end
        end
        # ■相手：♀占有中不可のスキルの場合
        if @skill.element_set.include?(156)
          # 相手が♀占有中の場合
          if @target_battlers[0].hold.vagina.battler != nil
            n = 1
          end
        end
        # ■♀占有中のみ可のスキルの場合
        #------------------------------------------------------------------------
        if @skill.element_set.include?(157)
        # 自分の♀が♀挿入状態で無い場合
          unless @active_battler.vagina_insert?
            n = 1
          end
        end
        if @skill.element_set.include?(158)
        # 自分の♀が騎乗状態で無い場合
          unless @active_battler.vagina_riding?
            n = 1
          end
        end
        if @skill.element_set.include?(159)
        # 自分の♀が貝合わせ状態で無い場合
          unless @active_battler.shellmatch?
            n = 1
          end
        end
        #------------------------------------------------------------------------
        # ■自分：上半身占有中不可のスキルの場合
        if @skill.element_set.include?(161)
          # 自分が上半身占有中の場合
          if @active_battler.hold.tops.battler != nil
            @error_text = "自分が上半身占有中で上半身使用"
            n = 1
          end
        end
        if @skill.element_set.include?(162)
          # 自分が上半身占有中の場合
          if @target_battlers[0].hold.tops.battler != nil
            @error_text = "自分が上半身占有中で上半身使用"
            n = 1
          end
        end
        # ■上半身占有中のみ可のスキルの場合
        #------------------------------------------------------------------------
        if @skill.element_set.include?(163)
        # 自分の上半身が拘束状態(攻め手)で無い場合
          unless @active_battler.tops_binder? or @active_battler.tops_binding?
            n = 1
            @error_text = "自分の上半身が拘束状態(攻め手)で無い"
          end
        end
        if @skill.element_set.include?(164)
        # 自分の上半身が開脚状態(攻め手)で無い場合
          unless @active_battler.tops_openbinder? or @active_battler.tops_openbinding?
            n = 1
          end
        end
        if @skill.element_set.include?(160)
        # 自分の上半身がパイズリ状態(攻め手)で無い場合
          unless @active_battler.tops_paizuri?
            n = 1
          end
        end
        if @skill.element_set.include?(171)
        # 自分の上半身がぱふぱふ状態(攻め手)で無い場合
          unless @active_battler.tops_pahupahu?
            n = 1
          end
        end
        #------------------------------------------------------------------------
        # ■自分：尻尾占有中不可のスキルの場合
        if @skill.element_set.include?(165)
        # 自分の尻尾を挿入中の場合
          if @active_battler.hold.tail.battler != nil
            n = 1
          end
        end
        if @skill.element_set.include?(166)
        # 自分の尻尾を挿入中の場合
          if @target_battlers[0].hold.tail.battler != nil
            n = 1
          end
        end
        # ■尻尾占有中のみ可のスキルの場合
        #------------------------------------------------------------------------
        if @skill.element_set.include?(167)
        # 自分の尻尾が♀挿入状態で無い場合
          unless @active_battler.tail_insert?
            n = 1
          end
        end
        if @skill.element_set.include?(168)
        # 自分の尻尾が口淫状態で無い場合
          unless @active_battler.tail_oralsex?
            n = 1
          end
        end
        if @skill.element_set.include?(169)
        # 自分の尻尾が肛姦状態で無い場合
          unless @active_battler.tail_analsex?
            n = 1
          end
        end
        #------------------------------------------------------------------------
        # ■触手占有中のみ可のスキルの場合
        #------------------------------------------------------------------------
        if @skill.element_set.include?(172)
        # 自分の触手が♀挿入状態で無い場合
          unless @active_battler.tentacle_insert?
            n = 1
          end
        end
        if @skill.element_set.include?(173)
        # 自分の触手が口淫状態で無い場合
          unless @active_battler.tentacle_oralsex?
            n = 1
          end
        end
        if @skill.element_set.include?(174)
        # 自分の触手が肛姦状態で無い場合
          unless @active_battler.tentacle_analsex?
            n = 1
          end
        end
        if @skill.element_set.include?(175)
        # 自分の触手で相手を拘束していない場合
          unless @active_battler.tentacle_binder?
            n = 1
            @error_text = "自分の触手で拘束させていない"
          end
        end
        if @skill.element_set.include?(176)
        # 自分の触手で相手を開脚させていない場合
          unless @active_battler.tentacle_openbinder?
            n = 1
            @error_text = "自分の触手で開脚させていない"
          end
        end

        #------------------------------------------------------------------------
        # ■自分：ディルド占有中不可のスキルの場合
        if @skill.element_set.include?(182)
          # 自分のディルドを挿入中の場合
          n = 1 if @active_battler.hold.dildo.battler != nil
        end
        # ■尻尾占有中のみ可のスキルの場合
        #------------------------------------------------------------------------
        if @skill.element_set.include?(183)
        # 自分のディルドが♀挿入状態で無い場合
          n = 1 unless @active_battler.dildo_insert?
        end
        if @skill.element_set.include?(184)
        # 自分のディルドが口淫状態で無い場合
          n = 1 unless @active_battler.dildo_oralsex?
        end
        if @skill.element_set.include?(185)
        # 自分のディルドが肛姦状態で無い場合
          n = 1 unless @active_battler.dildo_analsex?
        end

        # ■対男用スキルの場合
        if @skill.element_set.include?(41)
        #----------------------------------------------------------------
          # 相手が男（主人公）でない場合
          unless @target_battlers[0] == $game_actors[101]
            n = 1
            p "対男スキルを女に使用しているため不可：#{@skill.name}" if a == 1
          end
        end
        # ■対女用スキルの場合
        if @skill.element_set.include?(42)
        #----------------------------------------------------------------
          # 相手が男（主人公）である場合
          if @target_battlers[0] == $game_actors[101]
            n = 1
            p "対女スキルを男に使用しているため不可：#{@skill.name}" if a == 1
          end
        end
        # ■ステータス変化魔法の場合
        # ステート変化発生属性且つ、ダメージ無し属性の場合、すでについているものには使用しない
        if @skill.element_set.include?(33) and @skill.element_set.include?(17) 
          if @skill.id == 215 #トリムルート：精神系バステ解除
            unless @target_battlers[0].badstate_mental?
              n = 1
              p "精神系バッドステートではないので使用不可：#{@skill.name}" if a == 1
            end
          elsif @skill.id == 216 #トリムストーク：呪詛系バステ解除
            unless @target_battlers[0].badstate_curse?
              n = 1
              p "呪詛系バッドステートではないので使用不可：#{@skill.name}" if a == 1
            end
          elsif  @skill.id == 217 #トリムヴァイン：物理系バステ解除
            unless @target_battlers[0].badstate_tool?
              n = 1
              p "物理系バッドステートではないので使用不可：#{@skill.name}" if a == 1
            end
          else #バステ付与
            for i in SR_Util.checking_states # 一般バステ
              if @skill.plus_state_set.include?(i) and @target_battlers[0].states.include?(i)
                n = 1
                p "既にステート付与されているので使用不可：#{@skill.name}" if a == 1
                break
              end
            end
            for i in [30,98,104] # 特殊バステ
              if @skill.plus_state_set.include?(i) and @target_battlers[0].states.include?(i)
                n = 1
                p "既にステート付与されているので使用不可：#{@skill.name}" if a == 1
                break
              end
            end
          end
        end
        # ■パラメータ変化魔法の場合
        if @skill.element_set.include?(34)
        # すでに上限までかかっている場合は使用しない
        #----------------------------------------------------------------
          #●解除
          if @skill.element_set.include?(67) #全解除
            eff_count = 0
            for i in 0..5
              # 対象がエネミー（自軍）なら弱化値の数を数える
              if @target_battlers[0].is_a?(Game_Enemy) and 
              @target_battlers[0].state_runk[i] < 0 
                eff_count += @target_battlers[0].state_runk[i].abs
              # 対象がアクターー（敵軍）なら強化値の数を数える
              elsif @target_battlers[0].is_a?(Game_Actor) and 
              @target_battlers[0].state_runk[i] < 0 
                eff_count += @target_battlers[0].state_runk[i].abs
              end
            end
            n = 1 if eff_count < 1 # 強化１つ以下なら使わない
=begin
            n = 1
            for i in 0..5
              if @target_battlers[0].state_runk[i] != 0 
                n = 0
                break
              end
            end
=end
            p "解除したい程能力変化が無いので使用不可：#{@skill.name}" if a == 1 and n == 1
          elsif @skill.element_set.include?(65) #強化解除
            n = 1
            for i in 0..5
              if @target_battlers[0].state_runk[i] > 0
                n = 0
                break
              end
            end
            p "強化された能力が無いので使用不可：#{@skill.name}" if a == 1 and n == 1
          elsif @skill.element_set.include?(66) #弱体化解除
            n = 1
            for i in 0..5
              if @target_battlers[0].state_runk[i] < 0
                n = 0
                break
              end
            end
            p "弱体化した能力が無いので使用不可：#{@skill.name}" if a == 1 and n == 1
          #●全能力
          elsif @skill.element_set.include?(63) #ストレリブルム
            effectable = []
            state_count = 0
            # 対象全員を確認
            for target in @target_battlers
              # 全ステータスの上昇補正を確認
              for i in 0..5
                # 最大値になっていないものを数える
                if target.state_runk[i] < 2
                  state_count += 1
                end
              end
              effectable.push(state_count)
            end
            # １人ずつ、有効かの判定を行う
            effectable_count = 0
            for i in 0...@target_battlers.size
              # ３以上が有効なターゲット
              if effectable[i] >= 3
                effectable_count += 1
              end
            end
            # 対象全員に効果が無ければエラー
            if effectable_count < @target_battlers.size
              n = 1
              # 対象が３人以上、且つ対象数－１に有効なら許可
              if @target_battlers.size >= 3 and effectable_count + 1 >= @target_battlers.size
                n = 0
              end
            end
          elsif @skill.element_set.include?(64) #ストレリイーザ
            effectable = []
            state_count = 0
            # 対象全員を確認
            for target in @target_battlers
              # 全ステータスの上昇補正を確認
              for i in 0..5
                # 最小値になっていないものを数える
                if target.state_runk[i] > -2
                  state_count += 1
                end
              end
              effectable.push(state_count)
            end
            # １人ずつ、有効かの判定を行う
            effectable_count = 0
            for i in 0...@target_battlers.size
              # ３以上が有効なターゲット
              if effectable[i] >= 3
                effectable_count += 1
              end
            end
            # 対象全員に効果が無ければエラー
            if effectable_count < @target_battlers.size
              n = 1
              # 対象が３人以上、且つ対象数－１に有効なら許可
              if @target_battlers.size >= 3 and effectable_count + 1 >= @target_battlers.size
                n = 0
              end
            end
          #●魅力
          elsif @skill.element_set.include?(51) #ラナンブルム
            effectable_count = @target_battlers.size
            for target in @target_battlers
              if target.state_runk[0] == 2
                effectable_count -= 1
                n = 1
                p "これ以上魅力強化できないので使用不可：#{@skill.name}" if a == 1
              end
            end
            # 対象全員に効果が無ければエラー
            if effectable_count < @target_battlers.size
              n = 1
              # 対象が３人以上、且つ対象数－１に有効なら許可
              if @target_battlers.size >= 3 and effectable_count + 1 >= @target_battlers.size
                n = 0
              end
            end
          elsif @skill.element_set.include?(52) #ラナンイーザ
            effectable_count = @target_battlers.size
            for target in @target_battlers
              if target.state_runk[0] == -2
                effectable_count -= 1
                n = 1
                p "これ以上魅力弱化できないので使用不可：#{@skill.name}" if a == 1
              end
            end
            # 対象全員に効果が無ければエラー
            if effectable_count < @target_battlers.size
              n = 1
              # 対象が３人以上、且つ対象数－１に有効なら許可
              if @target_battlers.size >= 3 and effectable_count + 1 >= @target_battlers.size
                n = 0
              end
            end
          #●忍耐力
          elsif @skill.element_set.include?(53) #ネリネブルム
            effectable_count = @target_battlers.size
            for target in @target_battlers
              if target.state_runk[1] == 2
                effectable_count -= 1
                n = 1
                p "これ以上忍耐力弱化できないので使用不可：#{@skill.name}" if a == 1
              end
            end
            # 対象全員に効果が無ければエラー
            if effectable_count < @target_battlers.size
              n = 1
              # 対象が３人以上、且つ対象数－１に有効なら許可
              if @target_battlers.size >= 3 and effectable_count + 1 >= @target_battlers.size
                n = 0
              end
            end
          elsif @skill.element_set.include?(54) #ネリネイーザ
            effectable_count = @target_battlers.size
            for target in @target_battlers
              if target.state_runk[1] == -2
                effectable_count -= 1
                n = 1
                p "これ以上忍耐力弱化できないので使用不可：#{@skill.name}" if a == 1
              end
            end
            # 対象全員に効果が無ければエラー
            if effectable_count < @target_battlers.size
              n = 1
              # 対象が３人以上、且つ対象数－１に有効なら許可
              if @target_battlers.size >= 3 and effectable_count + 1 >= @target_battlers.size
                n = 0
              end
            end
          #●精力
          elsif @skill.element_set.include?(55) #エルダブルム
            effectable_count = @target_battlers.size
            for target in @target_battlers
              if target.state_runk[2] == 2
                effectable_count -= 1
                n = 1
                p "これ以上精力強化できないので使用不可：#{@skill.name}" if a == 1
              end
            end
            # 対象全員に効果が無ければエラー
            if effectable_count < @target_battlers.size
              n = 1
              # 対象が３人以上、且つ対象数－１に有効なら許可
              if @target_battlers.size >= 3 and effectable_count + 1 >= @target_battlers.size
                n = 0
              end
            end
          elsif @skill.element_set.include?(56) #エルダイーザ
            effectable_count = @target_battlers.size
            for target in @target_battlers
              if target.state_runk[2] == -2
                effectable_count -= 1
                n = 1
                p "これ以上精力弱化できないので使用不可：#{@skill.name}" if a == 1
              end
            end
            # 対象全員に効果が無ければエラー
            if effectable_count < @target_battlers.size
              n = 1
              # 対象が３人以上、且つ対象数－１に有効なら許可
              if @target_battlers.size >= 3 and effectable_count + 1 >= @target_battlers.size
                n = 0
              end
            end
          #●器用さ
          elsif @skill.element_set.include?(57) #サフラブルム
            effectable_count = @target_battlers.size
            for target in @target_battlers
              if target.state_runk[3] == 2
                effectable_count -= 1
                n = 1
                p "これ以上器用さ強化できないので使用不可：#{@skill.name}" if a == 1
              end
            end
            # 対象全員に効果が無ければエラー
            if effectable_count < @target_battlers.size
              n = 1
              # 対象が３人以上、且つ対象数－１に有効なら許可
              if @target_battlers.size >= 3 and effectable_count + 1 >= @target_battlers.size
                n = 0
              end
            end
          elsif @skill.element_set.include?(58) #サフライーザ
            effectable_count = @target_battlers.size
            for target in @target_battlers
              if target.state_runk[3] == -2
                effectable_count -= 1
                n = 1
                p "これ以上器用さ弱化できないので使用不可：#{@skill.name}" if a == 1
              end
            end
            # 対象全員に効果が無ければエラー
            if effectable_count < @target_battlers.size
              n = 1
              # 対象が３人以上、且つ対象数－１に有効なら許可
              if @target_battlers.size >= 3 and effectable_count + 1 >= @target_battlers.size
                n = 0
              end
            end
          #●素早さ
          elsif @skill.element_set.include?(59) #コリオブルム
            effectable_count = @target_battlers.size
            for target in @target_battlers
              if target.state_runk[4] == 2
                effectable_count -= 1
                n = 1
                p "これ以上素早さ強化できないので使用不可：#{@skill.name}" if a == 1
              end
            end
            # 対象全員に効果が無ければエラー
            if effectable_count < @target_battlers.size
              n = 1
              # 対象が３人以上、且つ対象数－１に有効なら許可
              if @target_battlers.size >= 3 and effectable_count + 1 >= @target_battlers.size
                n = 0
              end
            end
          elsif @skill.element_set.include?(60) #コリオイーザ
            effectable_count = @target_battlers.size
            for target in @target_battlers
              if target.state_runk[4] == -2
                effectable_count -= 1
                n = 1
                p "これ以上素早さ弱化できないので使用不可：#{@skill.name}" if a == 1
              end
            end
            # 対象全員に効果が無ければエラー
            if effectable_count < @target_battlers.size
              n = 1
              # 対象が３人以上、且つ対象数－１に有効なら許可
              if @target_battlers.size >= 3 and effectable_count + 1 >= @target_battlers.size
                n = 0
              end
            end
          #●精神力
          elsif @skill.element_set.include?(61) #アスタブルム
            effectable_count = @target_battlers.size
            for target in @target_battlers
              if target.state_runk[5] == 2
                effectable_count -= 1
                n = 1
                p "これ以上精神力強化できないので使用不可：#{@skill.name}" if a == 1
              end
            end
            # 対象全員に効果が無ければエラー
            if effectable_count < @target_battlers.size
              n = 1
              # 対象が３人以上、且つ対象数－１に有効なら許可
              if @target_battlers.size >= 3 and effectable_count + 1 >= @target_battlers.size
                n = 0
              end
            end
          elsif @skill.element_set.include?(62) #アスタイーザ
            effectable_count = @target_battlers.size
            for target in @target_battlers
              if target.state_runk[5] == -2
                effectable_count -= 1
                n = 1
                p "これ以上精神力弱化できないので使用不可：#{@skill.name}" if a == 1
              end
            end
            # 対象全員に効果が無ければエラー
            if effectable_count < @target_battlers.size
              n = 1
              # 対象が３人以上、且つ対象数－１に有効なら許可
              if @target_battlers.size >= 3 and effectable_count + 1 >= @target_battlers.size
                n = 0
              end
            end
          end
        end
        
        # インセンススキルは、すでに同じインセンスがある場合は不可
        if @skill.element_set.include?(129)
          n = 1 if $incense.exist?(@skill.name, @target_battlers[0])
        end
        # 自分のホールド相手にのみ使用可の場合、自分のホールド相手以外は不可
        if @skill.element_set.include?(208)
          n = 1 if not @active_battler.target_hold?(@target_battlers[0])
        end
        # 自分のホールド相手を優先して使用の場合、自分がホールドしているならば
        # 自分のホールド相手以外は不可
        if @skill.element_set.include?(215)
          if @active_battler.holding? and not @active_battler.target_hold?(@target_battlers[0])
            n = 1 
          end
        end
        
        
        # ■スキル別ごとの使用可否
        #----------------------------------------------------------------
        case @skill.name
        
        # ランダムスキルなどでスキル決め直しが出た場合はもう一回回させる        
        when "スキル決め直し"
          n = 1
        # すでにマーキングしている場合、品定めを使わない
        when "品定め"; n = 1 if @active_battler.marking?
        # 回復魔法
        #----------------------------------------------------------------
        # 対象１人の場合、対象の現在ＥＰの割合で可否を確認
        when "イリスシード"; n = 1 if @target_battlers[0].hpp >= 90
        when "イリスペタル"; n = 1 if @target_battlers[0].hpp >= 80
        when "イリスフラウ"; n = 1 if @target_battlers[0].hpp >= 50
        when "イリスコロナ"; n = 1 if @target_battlers[0].hpp >= 50
        # 対象複数の場合、対象のＥＰ割合が適正である場合の者が２人以上の場合ＯＫ
        when "イリスシード・アルダ","イリスペタル・アルダ","イリスフラウ・アルダ"
          target_count = 0
          for target in @target_battlers
            case @skill.name
            when "イリスシード・アルダ"
              target_count += 1 if target.hpp < 90
            when "イリスペタル・アルダ"
              target_count += 1 if target.hpp < 80
            when "イリスフラウ・アルダ"
              target_count += 1 if target.hpp < 50
            end
          end
          if target_count < 2
            n = 1 
            @error_text = "範囲回復魔法：対象不適正"
          end
        # 挑発系スキルは、自陣ですでに誰かが挑発している場合はエラー
        when "アピール","プロヴォーク"
          for enemy in $game_troop.enemies
            if enemy.exist? and (enemy.state?(96) or enemy.state?(104))
              n = 1
              break
            end
          end
        # ギルゴーン用。まだやけくそ３連撃を使用していない場合、もがかない。
        when "もがく"
          if $game_switches[393]
            n = 1
            @error_text = "もがく：特殊状況エラー"
          end
        end
        #------------------------------------------------------------------------
        # ■選び直しで選ばれないスキルの場合はエラー
        #------------------------------------------------------------------------
        if @skill.element_set.include?(211) and ct > 0
          n = 1
        end
        #------------------------------------------------------------------------
        # ■１人の時には使わないスキルの場合、１人だとエラー
        #------------------------------------------------------------------------
        if @skill.element_set.include?(212)
          enemy_count = 0
          for enemy in $game_troop.enemies
            enemy_count += 1 if enemy.exist?
          end
          n = 1 if enemy_count < 2
        end
        #------------------------------------------------------------------------
        # ■本気状態では使わない時、本気だとエラー
        #------------------------------------------------------------------------
        if @skill.element_set.include?(218)
          if @active_battler.earnest
            n = 1 
          end
        end
        #------------------------------------------------------------------------
        # ■対象が不適正の場合はエラー
        #------------------------------------------------------------------------
        if not @active_battler.proper_target?(@target_battlers[0],@skill.id)
          n = 1 
          @error_text = "対象不適正"
        end

        
        
        #----------------------------------------------------------------
        #スキル試行回数が４０回を超えた場合、汎用アクションにしてループを抜ける
        #※ハングアップ対策
        if ct > 300
          p "試行上限なので回避策実行" if $DEBUG
          unless @active_battler.holding?
            # スキル[エモーション]を取得
            @skill = $data_skills[299]
          else
            # スキル[見学・実況]を取得
            @skill = $data_skills[968]
          end
        # エラーカウントの場合はアクション決め直し
        elsif n == 1
          ct += 1
#          p "使用スキル(エラー認識中)：#{@skill.name}" if $DEBUG
          if a == 1
            unless @skill.name == "スキル決め直し"
              text = "エラー認識中"
              text += "\nアクティブ：#{@active_battler.name}"
              text += "\nターゲット：#{@target_battlers[0].name}"
              text += "\nスキル：#{@skill.name}"
              text += "\nエラー内容：#{@error_text}"
              print text
              @error_text = ""
            end
          end
          # アクションを再決定
          enemy_action_swicthes(@active_battler)
          @active_battler.make_action
          # 基本アクションだった場合は、基本アクションの結果作成に飛ばす             
          if @active_battler.current_action.kind == 0
            make_basic_action_result
            return
          end
          # スキルを取得
          @skill = $data_skills[@active_battler.current_action.skill_id]
#          p "使用スキル(再設定)：#{@skill.name}" if $DEBUG
          
          # デバッグ用
          if @skill.id == 15
#            p @active_battler.current_action
#           a = 1
          end  
          
          # 対象側バトラーをクリア
          @target_battlers = []
          # 対象側バトラーを設定
          set_target_battlers(@skill.scope, @skill.id)
          # ★ターゲットバトラーの情報を再度記憶
          $game_temp.battle_target_battler = @target_battlers
#          p "対象(再設定)：#{@target_battlers[0].name}" if $DEBUG

          # ★ランダムスキルを使用する場合、専用ページへ飛ばす
          if $data_skills[@active_battler.current_action.skill_id].element_set.include?(9)
#            p $data_skills[@active_battler.current_action.skill_id].name
            random_skill_action
          end
          next
        end
        
        # 大丈夫ならループ終了
        break
      end    
#    p "使用スキル(決定)：#{@skill.name}" if $DEBUG
        
    # 攻撃側がアクターの場合    
    else
      # エラー用変数をリセット
      n = 0
=begin
      #----------------------------------------------------------------
      # ■ スキルが使用不可且つスキルの妥協が可能な場合、妥協する
      #----------------------------------------------------------------
      unless @active_battler.skill_can_use?(@skill.id)
        # ヘヴィピストン→ピストン
        if @skill.id == 33
          new_id = 32
          @skill = $data_skills[new_id]
          @active_battler.current_action.skill_id = new_id
          p 1
        end
      end
=end
      
      
      #----------------------------------------------------------------
      # ■ エラー集
      #----------------------------------------------------------------

      # エラー用変数をリセット
      n = 0
      @error_text = ""
      
      # ■自分：着衣中不可のスキルの場合
      if @skill.element_set.include?(177)
      #----------------------------------------------------------------
        #挿入タイプ・ピストン・グラインド属性がある場合、半脱ぎで許可される場合も
        if @skill.element_set.include?(134)
          unless @skill.element_set.include?(91)
            unless (@active_battler.insertable_half_nude? or @active_battler.full_nude?)
              n = 1
            end
          end
        else
          unless @active_battler.full_nude?
            n = 1
          end
        end
      end

      # ■相手：着衣中不可のスキルの場合
      if @skill.element_set.include?(178)
      #----------------------------------------------------------------
        #挿入タイプ・ピストン・グラインド属性がある場合、半脱ぎで許可される場合も
        if @skill.element_set.include?(134)
          unless @skill.element_set.include?(91)
            unless (@target_battlers[0].insertable_half_nude? or @target_battlers[0].full_nude?)
              n = 1
            end
          end
        else
          unless @target_battlers[0].full_nude?
            n = 1
          end
        end
      end

      # ■自分：脱衣中不可のスキルの場合
      if @skill.element_set.include?(179)
      #----------------------------------------------------------------
        # 自分が裸状態である場合
        n = 1 if @active_battler.full_nude?
      end

      # ■相手：脱衣中不可のスキルの場合
      if @skill.element_set.include?(180)
      #----------------------------------------------------------------
        # 相手が裸状態である場合
        n = 1 if @target_battlers[0].full_nude?
      end

      # ■ホールド中優勢時専用スキルの場合
      if @skill.element_set.include?(137) and @active_battler.holding?
      #------------------------------------------------------------------------
        # 自分が劣勢の場合
        n = 1 unless @active_battler.initiative?
      end
      # ■ホールド中劣勢時専用スキルの場合
      #------------------------------------------------------------------------
      if @skill.element_set.include?(138) and @active_battler.holding?
        # 自分が劣勢の場合
        n = 1 if @active_battler.initiative?
      end
      # ■ホールド解除スキルの場合
      #------------------------------------------------------------------------
      if @skill.name == "リリース" or @skill.name == "インタラプト"
        # 相手がすでにホールドで無い場合
        n = 1 unless @target_battlers[0].holding?
      end
      if @skill.name == "ストラグル"
        # 自分がすでにホールドで無い場合
        n = 1 unless @active_battler.holding?
      end

      # ■自分を対象に取れないスキルで自分を選択した場合使用不可
      if @skill.element_set.include?(19)
      #----------------------------------------------------------------
        if @active_battler == @target_battlers[0]
          n = 1
        end
      end
      #------------------------------------------------------------------------
      # ■自分：♂占有中不可のスキルの場合
      if @skill.element_set.include?(140)
        # 自分のペニスがバトラーに占有されている場合
        n = 1 if @active_battler.hold.penis.battler != nil
      end
      # ■相手：♂占有中不可のスキルの場合
      if @skill.element_set.include?(141)
        # 相手のペニスがバトラーに占有されている場合
        n = 1 if @target_battlers[0].hold.penis.battler != nil
      end
      # ■♂占有中のみ可のスキルの場合
      #------------------------------------------------------------------------
      if @skill.element_set.include?(142)
        # 自分の♂が♀挿入状態で無い場合
        n = 1 unless @active_battler.penis_insert?
      end
      if @skill.element_set.include?(143)
      # 自分の♂が口淫状態で無い場合
        n = 1 unless @active_battler.penis_oralsex?
      end
      if @skill.element_set.include?(144)
      # 自分の♂が肛姦状態で無い場合
        n = 1 unless @active_battler.penis_analsex?
      end

      #------------------------------------------------------------------------
      # ■自分：口占有中不可のスキルの場合
      if @skill.element_set.include?(146)
        # 口が占有中の場合
        n = 1 if @active_battler.hold.mouth.battler != nil
      end
      # ■相手：口占有中不可のスキルの場合
      if @skill.element_set.include?(147)
        # 口が占有中の場合
        n = 1 if @target_battlers[0].hold.mouth.battler != nil
      end
      # ■口挿入中のみ可のスキルの場合
      #------------------------------------------------------------------------
      if @skill.element_set.include?(148)
      # 自分の口が口挿入状態で無い場合
        n = 1 unless @active_battler.mouth_oralsex?
      end
      if @skill.element_set.include?(149)
      # 自分の口が顔面騎乗状態で無い場合
        n = 1 unless @active_battler.mouth_riding?
      end
      if @skill.element_set.include?(145)
      # 自分の口が尻騎乗状態で無い場合
        n = 1 unless @active_battler.mouth_hipriding?
      end
      if @skill.element_set.include?(150)
      # 自分の口がクンニ状態で無い場合
        n = 1 unless @active_battler.mouth_draw?
      end
      if @skill.element_set.include?(170)
      # 自分の口がキッス状態で無い場合
        n = 1 unless @active_battler.deepkiss?
      end

      #------------------------------------------------------------------------
      # ■自分：尻占有中不可のスキルの場合
      if @skill.element_set.include?(151)
        # 自分が尻占有中の場合
        n = 1 if @active_battler.hold.anal.battler != nil
      end
      # ■相手：尻占有中不可のスキルの場合
      if @skill.element_set.include?(152)
        # 相手が尻占有中の場合
        n = 1 if @target_battlers[0].hold.anal.battler != nil
      end
      # ■尻占有中のみ可のスキルの場合
      #------------------------------------------------------------------------
      if @skill.element_set.include?(153)
        # 自分の尻が尻挿入状態で無い場合
        n = 1 unless @active_battler.anal_analsex?
      end
      if @skill.element_set.include?(154)
        # 自分の尻が尻騎乗状態で無い場合
        n = 1 unless @active_battler.anal_hipriding?
      end

      #------------------------------------------------------------------------
      # ■自分：♀占有中不可のスキルの場合
      if @skill.element_set.include?(155)
        # 自分が挿入中の場合
        n = 1 if @active_battler.hold.vagina.battler != nil
      end
      # ■相手：♀占有中不可のスキルの場合
      if @skill.element_set.include?(156)
        # 相手が♀占有中の場合
        n = 1 if @target_battlers[0].hold.vagina.battler != nil
      end
      # ■♀占有中のみ可のスキルの場合
      #------------------------------------------------------------------------
      if @skill.element_set.include?(157)
      # 自分の♀が♀挿入状態で無い場合
        n = 1 unless @active_battler.vagina_insert?
      end
      if @skill.element_set.include?(158)
      # 自分の♀が騎乗状態で無い場合
        n = 1 unless @active_battler.vagina_riding?
      end
      if @skill.element_set.include?(159)
      # 自分の♀が貝合わせ状態で無い場合
        n = 1 unless @active_battler.shellmatch?
      end

      #------------------------------------------------------------------------
      # ■自分：上半身占有中不可のスキルの場合
      if @skill.element_set.include?(161)
        # 自分が上半身占有中の場合
        n = 1 if @active_battler.hold.tops.battler != nil
      end
      # ■相手：上半身占有中不可のスキルの場合
      if @skill.element_set.include?(162)
        # 相手が上半身占有中の場合
        n = 1 if @target_battlers[0].hold.tops.battler != nil
      end
      # ■上半身占有中のみ可のスキルの場合
      #------------------------------------------------------------------------
      if @skill.element_set.include?(163)
      # 自分の上半身が拘束状態で無い場合
        n = 1 unless (@active_battler.tops_binder? or @active_battler.tops_binding?)
      end
      if @skill.element_set.include?(164)
      # 自分の上半身が開脚状態で無い場合
        n = 1 unless @active_battler.tops_openbinding?
      end
      if @skill.element_set.include?(160)
      # 自分の上半身がパイズリ状態で無い場合
        n = 1 unless @active_battler.tops_paizuri?
      end
      if @skill.element_set.include?(171)
      # 自分の上半身がぱふぱふ状態で無い場合
        n = 1 unless @active_battler.tops_pahupahu?
      end

      #------------------------------------------------------------------------
      # ■自分：尻尾占有中不可のスキルの場合
      if @skill.element_set.include?(165)
        # 自分の尻尾を挿入中の場合
        n = 1 if @active_battler.hold.tail.battler != nil
      end
      # ■相手：尻尾占有中不可のスキルの場合
      if @skill.element_set.include?(165)
        # 相手の尻尾が占有中の場合
        n = 1 if @target_battlers[0].hold.tail.battler != nil
      end
      # ■尻尾占有中のみ可のスキルの場合
      #------------------------------------------------------------------------
      if @skill.element_set.include?(167)
      # 自分の尻尾が♀挿入状態で無い場合
        n = 1 unless @active_battler.tail_insert?
      end
      if @skill.element_set.include?(168)
      # 自分の尻尾が口淫状態で無い場合
        n = 1 unless @active_battler.tail_oralsex?
      end
      if @skill.element_set.include?(169)
      # 自分の尻尾が肛姦状態で無い場合
        n = 1 unless @active_battler.tail_analsex?
      end
      
      
      #------------------------------------------------------------------------
      # ■触手占有中のみ可のスキルの場合
      if @skill.element_set.include?(172)
      # 自分の触手が♀挿入状態で無い場合
        n = 1 unless @active_battler.tentacle_insert?
      end
      if @skill.element_set.include?(173)
      # 自分の触手が口淫状態で無い場合
        n = 1 unless @active_battler.tentacle_oralsex?
      end
      if @skill.element_set.include?(174)
      # 自分の触手が肛姦状態で無い場合
        n = 1 unless @active_battler.tentacle_analsex?
      end
      if @skill.element_set.include?(175)
      # 自分の触手で相手を拘束していない場合
        n = 1 unless @active_battler.tentacle_binding?
      end
      if @skill.element_set.include?(176)
      # 自分の触手で相手を拘束していない場合
        n = 1 unless @active_battler.tentacle_openbinding?
      end

      #------------------------------------------------------------------------
      # ■自分：ディルド占有中不可のスキルの場合
      if @skill.element_set.include?(182)
        # 自分のディルドを挿入中の場合
        n = 1 if @active_battler.hold.dildo.battler != nil
      end
      # ■相手：ディルド占有中不可のスキルの場合
      if @skill.element_set.include?(190)
        # 自分のディルドを挿入中の場合
        n = 1 if @target_battlers[0].hold.dildo.battler != nil
      end
      # ■尻尾占有中のみ可のスキルの場合
      #------------------------------------------------------------------------
      if @skill.element_set.include?(183)
      # 自分のディルドが♀挿入状態で無い場合
        n = 1 unless @active_battler.dildo_insert?
      end
      if @skill.element_set.include?(184)
      # 自分のディルドが口淫状態で無い場合
        n = 1 unless @active_battler.dildo_oralsex?
      end
      if @skill.element_set.include?(185)
      # 自分のディルドが肛姦状態で無い場合
        n = 1 unless @active_battler.dildo_analsex?
      end
      # ■対男用スキルの場合(アクターからの場合、相手が両性なら使用可)
      if @skill.element_set.include?(41)
      #----------------------------------------------------------------
        # 相手が両性具有でない場合
        n = 1 unless @target_battlers[0].futanari?
      end
      
      # ■対女用スキルの場合
      if @skill.element_set.include?(42)
      #----------------------------------------------------------------
        # 相手が男（主人公）である場合
        n = 1 if @target_battlers[0].boy?
      end

      # ■スキル矯正
      # ----------------------------------------------------------------

      # エラーカウントの場合はアクションを無効化
      if n == 1
        $game_temp.forcing_battler = nil
        @wait_count = 0
        @phase4_step = 6
        return
      end
    end

    # ---------------------------------------------------------------

    # ★ターゲットバトラーの情報を記憶　※コモンイベントで使います。
    $game_temp.battle_target_battler = @target_battlers
#    p "対象(決定)：#{@target_battlers[0].name}" if $DEBUG
#    p "使用スキル(決定)：#{@skill.name}" if $DEBUG

    # 強制アクションでなければ
    unless @active_battler.current_action.forcing
      # SP 切れなどで使用できなくなった場合
      unless @active_battler.skill_can_use?(@skill.id)
#        p "アクション条件不備により履歴クリア：#{@skill.name}" if $DEBUG
        # アクション強制対象のバトラーをクリア
        $game_temp.forcing_battler = nil
        # ステップ 6 に移行
        @phase4_step = 6
        return
      end
    end
    
    # 追撃中でなければ　SP 消費を行う
    unless $game_switches[78]
      @active_battler.sp -= SR_Util.sp_cost_result(@active_battler, @skill)
      # エネミーがＶＰを消費する補助スキルを使用した場合、
      # 補助スキルカウントを増やす
      if @active_battler.is_a?(Game_Enemy) and
       SR_Util.sp_cost_result(@active_battler, @skill) > 0 and
       (@skill.element_set.include?(4) or @skill.element_set.include?(5))
        @active_battler.support_skill_count += 1
      end
    end
    
    # ステータスウィンドウをリフレッシュ
    @status_window.refresh
    
    #使用しているスキルが手＋口の複合攻撃の場合、属性をここで習得
    if @skill.element_set.include?(84)
      @skill.element_set.delete(71) if @skill.element_set.include?(71)#手
      @skill.element_set.delete(72) if @skill.element_set.include?(72)#口
      #口が封印状態の場合は手のみ
      if @active_battler.hold.mouth.battler != nil
        @skill.element_set.push(71)
      #口は大丈夫だが上半身封印状態の場合は口のみ
      elsif @active_battler.hold.tops.battler != nil
        @skill.element_set.push(72)
      #どちらでも無い場合はランダム
      else
        if rand(100) >= 50
          @skill.element_set.push(71)
        else
          @skill.element_set.push(72)
        end
      end
    end
    # ★ランダムスキルを使用する場合、専用ページへ飛ばす
#    if $data_skills[@active_battler.current_action.skill_id].element_set.include?(9)
#      p $data_skills[@active_battler.current_action.skill_id].name
#      random_skill_action
#    end
    # ■スキル名を表示する場合
    if @skill.element_set.include?(14)
      # ★ヘルプウィンドウ帯を表示
      @help_window.window.visible = true
      #ベッドイン中はトーク名称をピロートークに変更
      if $game_switches[85] == true and @skill.name == "トーク"
        # ヘルプウィンドウにスキル名を表示
        @help_window.set_text("ピロートーク", 1)
      else
        # ヘルプウィンドウにスキル名を表示
        @help_window.set_text(@skill.name, 1)
      end
    end
    # アニメーション ID を設定
    @animation1_id = @skill.animation1_id
    @animation2_id = @skill.animation2_id
    # コモンイベント ID を設定
    @common_event_id = @skill.common_event_id
    
    # ★エネミーの表示状態の変更（対象が全体の場合は変更無し）
    # （アクティブがアクターの場合はここでターゲットが映る）
    if @target_battlers[0].is_a?(Game_Enemy) and @active_battler.is_a?(Game_Actor) \
     and @skill.scope != 2 and @skill.scope != 4 
      enemies_display(@target_battlers[0])
    # （アクティブがエネミーの場合はここでアクティブが映る）
    elsif @active_battler.is_a?(Game_Enemy)
      enemies_display(@active_battler)
    end

    
    
    # スキルの効果を適用
    for target in @target_battlers
      #ターゲット決定後、攻撃側がアクターの場合はターゲットに行われたスキル判定
      if target.is_a?(Game_Enemy) and @active_battler.is_a?(Game_Actor)
        #対象に行ったスキルIDが魔法でなく、かつ直前に行われたものと同一ならカウント
        if @skill.id == target.before_suffered_skill_id and not @skill.element_set.include?(5)
          $repeat_skill_num += 1 unless $game_switches[78] == true #追撃中はカウントしない
        else
          # 別な攻撃スキルならリセット
          $repeat_skill_num = 0
          target.before_suffered_skill_id = @skill.id
        end
      end
      #使ったスキルを確定し$game_tempに記録
      $game_temp.used_skill = @skill
      #スキルエフェクト
      target.skill_effect(@active_battler, @skill)
    end
  end
  #--------------------------------------------------------------------------
  # ● アイテムアクション 結果作成
  #--------------------------------------------------------------------------
  def make_item_action_result
    # アイテムを取得
    @item = $data_items[@active_battler.current_action.item_id]
    # ★ターゲットバトラーの情報を記憶　※コモンイベントで使います。
    $game_temp.battle_target_battler = @target_battlers
    # アイテム切れなどで使用できなくなった場合
    unless $game_party.item_can_use?(@item.id)
      # ステップ 1 に移行
      @phase4_step = 1
      return
    end
    # 消耗品の場合
    if @item.consumable
      # 使用したアイテムを 1 減らす
      $game_party.lose_item(@item.id, 1)
    end
    # ★ヘルプウィンドウ帯を表示
    @help_window.window.visible = true
    # ヘルプウィンドウにアイテム名を表示
    @help_window.set_text(@item.name, 1)
    # アニメーション ID を設定
    @animation1_id = @item.animation1_id
    @animation2_id = @item.animation2_id
    # コモンイベント ID を設定
    @common_event_id = @item.common_event_id
    # 対象を決定
    index = @active_battler.current_action.target_index
    target = $game_party.smooth_target_actor(index)
    # 対象側バトラーを設定
    set_target_battlers(@item.scope)
    
    # ★エネミーの表示状態の変更（対象が全体の場合は変更無し）
    if @target_battlers[0].is_a?(Game_Enemy) \
     and @item.scope != 2 and @item.scope != 4 
      enemies_display(@target_battlers[0])
    end

    
    # アイテムの効果を適用
    for target in @target_battlers
      target.item_effect(@item)
    end
  end
  #--------------------------------------------------------------------------
  # ● 淫毒処理
  #--------------------------------------------------------------------------
  def special_mushroom_effect(battler)
    
    # 併発できるものを耐性込みで検査
    bs = [0,0,0,45,45,45,45,37,39,40]
    # 虚脱
    registance = battler.state_percent(nil, 37, nil)
    if battler.states.include?(37) or rand(100) >= registance
      bs.delete(37) 
    end
    # 麻痺
    registance = battler.state_percent(nil, 39, nil)
    if battler.states.include?(39) or rand(100) >= registance
      bs.delete(39) 
    end
    # 散漫
    registance = battler.state_percent(nil, 40, nil)
    if battler.states.include?(37) or rand(100) >= registance
      bs.delete(40) 
    end
    # 併発できるものがない場合、メソッド終了
    return if bs == []
    
    # 併発できるものの中から１つ選んでそのステートを付与
    bs = bs[rand(bs.size)]
    # 0の場合は併発無し
    return if bs == 0
    # 併発
    battler.add_state(bs)
    
  end
end