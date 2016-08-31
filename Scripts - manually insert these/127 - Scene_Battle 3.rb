#==============================================================================
# ■ Scene_Battle (分割定義 3)
#------------------------------------------------------------------------------
# 　バトル画面の処理を行うクラスです。
#==============================================================================

class Scene_Battle
  #--------------------------------------------------------------------------
  # ● アクターコマンドフェーズ開始
  #--------------------------------------------------------------------------
  def start_phase3
    # フェーズ 3 に移行
    @phase = 3
    # アクターを非選択状態に設定
    @actor_index = -1
    @active_battler = nil
    # 次のアクターのコマンド入力へ
    phase3_next_actor
    
    $game_temp.in_battle_change = true
    
    # アクターコマンドフェーズのtempフラグを立てる
    # （このフェーズ中のエラーメッセージをバックログに記録させないため）
    $game_temp.battle_actor_command_flag = true


  end
  #--------------------------------------------------------------------------
  # ● 次のアクターのコマンド入力へ
  #--------------------------------------------------------------------------
  def phase3_next_actor
    # ループ
    begin
      # アクターの明滅エフェクト OFF
      if @active_battler != nil
        @active_battler.blink = false
      end
      # 最後のアクターの場合
      if @actor_index == $game_party.actors.size-1
        # メインフェーズ開始
        $game_temp.arrow_actor = nil
        # アクターコマンドフェーズのtempフラグを切る
        $game_temp.battle_actor_command_flag = false
        start_phase4
        return
      end
      # アクターのインデックスを進める
      @actor_index += 1
      @active_battler = $game_party.actors[@actor_index]
      @active_battler.blink = true
      $game_temp.arrow_actor = @active_battler
    # アクターがコマンド入力を受け付けない状態ならもう一度
    end until @active_battler.inputable?
    # アクターコマンドウィンドウをセットアップ
    phase3_setup_command_window
  end
  #--------------------------------------------------------------------------
  # ● 前のアクターのコマンド入力へ
  #--------------------------------------------------------------------------
  def phase3_prior_actor
    # ループ
    begin
      # アクターの明滅エフェクト OFF
      if @active_battler != nil
        @active_battler.blink = false
      end
      # 最初のアクターの場合
      if @actor_index == 0
        # パーティコマンドフェーズ開始
        $game_temp.arrow_actor = nil
        start_phase3
        return
      end
      # アクターのインデックスを戻す
      @actor_index -= 1
      @active_battler = $game_party.actors[@actor_index]
      @active_battler.blink = true
      $game_temp.arrow_actor = @active_battler
    # アクターがコマンド入力を受け付けない状態ならもう一度
    end until @active_battler.inputable?
    # アクターコマンドウィンドウをセットアップ
    phase3_setup_command_window
  end
  #--------------------------------------------------------------------------
  # ● アクターコマンドウィンドウのセットアップ
  #--------------------------------------------------------------------------
  def phase3_setup_command_window
    # パーティコマンドウィンドウを無効化
#    @party_command_window.active = false
#    @party_command_window.visible = false
    # アクターコマンドウィンドウを有効化

#    @actor_command_window.active = true
#    @actor_command_window.visible = true
    # アクターコマンドウィンドウの位置を設定
    @actor_command_window.x = @actor_index * 160
    @actor_command_window.fade_flag = 1
    # インデックスを 0 に設定
    @actor_command_window.index = 0
    
    @actor_command_window.refresh
    command_all_active
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新 (アクターコマンドフェーズ)
  #--------------------------------------------------------------------------
  def update_phase3
#    @battle_log_window.contents.clear
#    @battle_log_window.keep_flag = false
#    $game_temp.battle_log_text = ""

=begin
    # ホールドポップを非表示にする。
    if Input.trigger?(Input::L)
      # フラグを反転させる。備考（^=trueで真偽反転）
      @hold_pops_display ^= true
      hold_pops_display_check(@hold_pops_display)
    end
=end

    # エネミーアローが有効の場合
    if @enemy_arrow != nil
      update_phase3_enemy_select
    # アクターアローが有効の場合
    elsif @actor_arrow != nil
      update_phase3_actor_select
    # スキルウィンドウが有効の場合
    elsif @skill_window != nil
      update_phase3_skill_select
    # アイテムウィンドウが有効の場合
    elsif @item_window != nil
      update_phase3_item_select
    # パーティウィンドウが有効の場合
    elsif @party_window != nil
      update_phase3_party_select
    # アクターコマンドウィンドウが有効の場合
    elsif @actor_command_window.active
      update_phase3_basic_command
    end
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新 (アクターコマンドフェーズ : 基本コマンド)
  #--------------------------------------------------------------------------
  def update_phase3_basic_command
    @window_flag = true
    $game_temp.error_message = ""
    # B ボタンが押された場合
    if Input.trigger?(Input::B)
      if @actor_index == 0
        return
      end
      # キャンセル SE を演奏
      $game_system.se_play($data_system.cancel_se)
      # 前のアクターのコマンド入力へ
      phase3_prior_actor
      @window_flag = false
      return
    end

    # ホールドポップを表示する。
    if Input.trigger?(Input::UP) or Input.trigger?(Input::DOWN)
      # フラグを反転させる。備考（^=trueで真偽反転）
      @hold_pops_display ^= true
      hold_pops_display_check(@hold_pops_display)
    end
    
    
    # A ボタンが押された場合
    if Input.trigger?(Input::A)
      $game_temp.check_result_list = SR_Util.make_condition_text(@active_battler)
      common_event = $data_common_events[51]
      $game_system.battle_interpreter.setup(common_event.list, 0)
      @window_flag = false
      return
    end

    # C ボタンが押された場合
    if Input.trigger?(Input::C)

      # アクターコマンドウィンドウのカーソル位置で分岐
      case @actor_command_window.index
      when 0  # スキル
        # 決定 SE を演奏
        $game_system.se_play($data_system.decision_se)
        # アクションを設定
        @active_battler.current_action.kind = 1
        # スキルの選択を開始
        start_skill_select
      when 1  # アイテム
        if @active_battler.holding?
          # ブザー SE を演奏
          $game_system.se_play($data_system.buzzer_se)
          $game_temp.message_text = "ホールド中はアイテムが使えない！"
          $game_temp.script_message = true
          @window_flag = false
          return
        end
        # 決定 SE を演奏
        $game_system.se_play($data_system.decision_se)
        # アクションを設定
        @active_battler.current_action.kind = 2
        # アイテムの選択を開始
        start_item_select
      when 2  # パーティ編成
        if $game_system.partyform_permit
          # 決定 SE を演奏
          $game_system.se_play($data_system.decision_se)
          # パーティ編成フェーズ開始
          start_party_select
        else
          # ブザー SE を演奏
          $game_system.se_play($data_system.buzzer_se)
        end
        @window_flag = false
        return
      when 3  # 逃走
        # 決定 SE を演奏
        if not $game_temp.battle_can_escape
          # ブザー SE を演奏
          $game_system.se_play($data_system.buzzer_se)
          $game_temp.message_text = "Can't escape from this battle!"
          $game_temp.script_message = true
          @window_flag = false
          return
        else
          # 心掴み中は逃走不可能
          if $incense.exist?("心掴み", 0)
            # ブザー SE を演奏
            $game_system.se_play($data_system.buzzer_se)
            $game_temp.message_text = "後ろ髪を引かれていて逃げられない！"
            $game_temp.script_message = true
            @window_flag = false
            return
          end
          # ホールドされている時は逃走不可能
          for actor in $game_party.actors
            if actor.holding?
              # ブザー SE を演奏
              $game_system.se_play($data_system.buzzer_se)
              $game_temp.message_text = "Can't escape because #{actor.name} is engaged in a hold!"
              $game_temp.script_message = true
              @window_flag = false
              return
            end
          end
        end
        $game_system.se_play($data_system.decision_se)
        @active_battler.current_action.kind = 0
        @active_battler.current_action.basic = 2
        phase3_next_actor
#        # アクションを設定
#        @active_battler.current_action.kind = 2
#        # アイテムの選択を開始
#        start_item_select
       end
       @window_flag = false
     return
    end
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新 (アクターコマンドフェーズ : スキル選択)
  #--------------------------------------------------------------------------
  def update_phase3_skill_select
    # スキルウィンドウを可視状態にする
    @skill_window.visible = true
    # スキルウィンドウを更新
    @skill_window.update
    # B ボタンが押された場合
    if Input.trigger?(Input::B)
      # キャンセル SE を演奏
      $game_system.se_play($data_system.cancel_se)
      # スキルの選択を終了
      end_skill_select
      return
    end
    # C ボタンが押された場合
    if Input.trigger?(Input::C)
      # スキルウィンドウで現在選択されているデータを取得
      @skill = @skill_window.skill
      # ●選択したスキルを一時的に記憶
      $game_temp.skill_selection = @skill
      # ●選択したスキルをアクター情報に記憶し、次回のカーソル合わせに使用
      # 関連数値がアクターにしかないので、念のためエラー落ち対策
      if @active_battler.is_a?(Game_Actor)
        # システムページで「カーソル位置記憶」がＯＮになっている場合
        if $game_system.system_arrow == true
          @active_battler.skill_collect = $game_temp.skill_selection
        else
          @active_battler.skill_collect = nil
        end
      end
      # 使用できない場合
      if @skill == nil or not @active_battler.skill_can_use?(@skill.id)
        # ブザー SE を演奏
        $game_system.se_play($data_system.buzzer_se)
        # ●エラーメッセージを表示
        $game_temp.message_text = $game_temp.error_message if $game_temp.error_message != ""
        $game_temp.error_message = ""
        return
      end
      # 決定 SE を演奏
      $game_system.se_play($data_system.decision_se)
      # アクションを設定
      @active_battler.current_action.skill_id = @skill.id
      # スキルウィンドウを不可視状態にする
      @skill_window.visible = false
      @skill_window.window.visible = false #★
      # 効果範囲が敵単体の場合
      if @skill.scope == 1
        # エネミーの選択を開始
        start_enemy_select
      # 効果範囲が味方単体の場合
      elsif @skill.scope == 3 or @skill.scope == 5
        # アクターの選択を開始
        start_actor_select
      # 効果範囲が単体ではない場合
      else
        # スキルの選択を終了
        end_skill_select
        # 次のアクターのコマンド入力へ
        phase3_next_actor
      end
      return
    end
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新 (アクターコマンドフェーズ : アイテム選択)
  #--------------------------------------------------------------------------
  def update_phase3_item_select
    # アイテムウィンドウを可視状態にする
    @item_window.visible = true
    # アイテムウィンドウを更新
    @item_window.update
    # B ボタンが押された場合
    if Input.trigger?(Input::B)
      # キャンセル SE を演奏
      $game_system.se_play($data_system.cancel_se)
      # アイテムの選択を終了
      end_item_select
      return
    end
    # C ボタンが押された場合
    if Input.trigger?(Input::C)
      # アイテムウィンドウで現在選択されているデータを取得
      @item = @item_window.item
      # ●選択したアイテムを一時的に記憶
      $game_temp.skill_selection = @item
      # 使用できない場合
      unless $game_party.item_can_use?(@item.id)
        # ブザー SE を演奏
        $game_system.se_play($data_system.buzzer_se)
        # ●エラーメッセージを表示
        $game_temp.message_text = $game_temp.error_message if $game_temp.error_message != ""
        $game_temp.error_message = ""
        return
      end
      # 決定 SE を演奏
      $game_system.se_play($data_system.decision_se)
      # アクションを設定
      @active_battler.current_action.item_id = @item.id
      # アイテムウィンドウを不可視状態にする
      @item_window.visible = false
      @item_window.window.visible = false #★
      # 効果範囲が敵単体の場合
      if @item.scope == 1
        # エネミーの選択を開始
        start_enemy_select
      # 効果範囲が味方単体の場合
      elsif @item.scope == 3 or @item.scope == 5
        # アクターの選択を開始
        start_actor_select
      # 効果範囲が単体ではない場合
      else
        # アイテムの選択を終了
        end_item_select
        # 次のアクターのコマンド入力へ
        phase3_next_actor
      end
      return
    end
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新 (アクターコマンドフェーズ : パーティ選択)
  #--------------------------------------------------------------------------
  def update_phase3_party_select
    
    # 確認ウィンドウが表示されている時はそちらのフレーム更新を行う
    if @party_check[0].visible == true or @party_check[1].visible == true
      update_phase3_party_select_check
      return
    end
    # パーティウィンドウを可視状態にする
    @party_window.visible = true
    # パーティウィンドウを更新
    @party_window.update
    # B ボタンが押された場合
    if Input.trigger?(Input::B)
      # キャンセル SE を演奏
      $game_system.se_play($data_system.cancel_se)
      # パーティの選択を終了
      end_party_select
      return
    end
    # C ボタンが押された場合
    if Input.trigger?(Input::C)
      # 決定 SE を演奏
      $game_system.se_play($data_system.decision_se)
      # 確認ウィンドウを表示
      # 行動中が主人公、選択中の夢魔がすでに戦闘に出ている場合
      if @active_battler == $game_actors[101] or
       $game_party.battle_actors.include?($game_party.party_actors[@party_window.index])
#        @active_battler == $game_actors[101] \
#       or @party_window.index == 0 \
#       or @party_window.index == 1
        @party_check[0].visible = true
        @party_check[0].active = true
        @party_check[0].index = 0
      else
        @party_check[1].visible = true
        @party_check[1].active = true
        @party_check[1].index = 0
      end
      return
    end
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新 (アクターコマンドフェーズ : パーティ選択の確認中
  #--------------------------------------------------------------------------
  def update_phase3_party_select_check
    
    if @party_check[0].visible == true
      @party_check[0].update
      # C ボタンが押された場合
      if Input.trigger?(Input::C)
        # 決定 SE を演奏
        $game_system.se_play($data_system.decision_se)
        case @party_check[0].index
        when 0 # ステータス
          Graphics.freeze
          scene = Scene_Partychange.new(2, @party_window.index)
          scene.main
          @party_check[0].visible = false
          @party_check[0].active = false
          @spriteset.refresh_actor_sprites
          @spriteset.update
          @status_window.refresh
          Graphics.transition(8)
        when 1 # キャンセル
          @party_check[0].visible = false
          @party_check[0].active = false
        end
        return
      end
    elsif @party_check[1].visible == true
      @party_check[1].update
      # C ボタンが押された場合
      if Input.trigger?(Input::C)
        # 決定 SE を演奏
        $game_system.se_play($data_system.decision_se)
        case @party_check[1].index
        when 0 # ステータス
          Graphics.freeze
          scene = Scene_Partychange.new(2, @party_window.index)
          scene.main
          @party_check[1].visible = false
          @party_check[1].active = false
          @spriteset.refresh_actor_sprites
          @spriteset.update
          @status_window.refresh
          Graphics.transition(8)
        when 1 # この夢魔と交代
          # 倒れている夢魔の場合はブザー
          if $game_party.party_actors[@party_window.index].dead?
            # ブザー SE を演奏
            $game_system.se_play($data_system.buzzer_se)
            $game_temp.message_text = "This succubus cannot be sｗitched out!"
            $game_temp.script_message = true
            @window_flag = false
            return
          end
          # 心掴み中は逃走不可能
          if $incense.exist?("心掴み", 0)
            # ブザー SE を演奏
            $game_system.se_play($data_system.buzzer_se)
            $game_temp.message_text = "後ろ髪を引かれていて交代することができない！"
            $game_temp.script_message = true
            @window_flag = false
            return
          end
          # ホールドされている時は逃走不可能
          if @active_battler.holding?
            # ブザー SE を演奏
            $game_system.se_play($data_system.buzzer_se)
            $game_temp.message_text = "Can't switch out when engaged in a hold!"
            $game_temp.script_message = true
            @window_flag = false
            return
          end
          @party_check[1].visible = false
          @party_check[1].active = false
          # 行動情報をセット
          @active_battler.current_action.kind = 0
          @active_battler.current_action.basic = 5
          for i in 0...$game_party.party_actors.size
            if $game_party.party_actors[i] == @active_battler
              n = [i, @party_window.index]
              @active_battler.change_index = n
              break
            end
          end
          # パーティの選択を終了
          end_party_select
          # 次のアクターのコマンド入力へ
          phase3_next_actor
        when 2 # キャンセル
          @party_check[1].visible = false
          @party_check[1].active = false
        end
        return
      end
      
    end
    
    # B ボタンが押された場合
    if Input.trigger?(Input::B)
      # キャンセル SE を演奏
      $game_system.se_play($data_system.cancel_se)
      # パーティの選択を終了
      @party_check[0].visible = false
      @party_check[0].active = false
      @party_check[1].visible = false
      @party_check[1].active = false
      return
    end

  end
  
  #--------------------------------------------------------------------------
  # ● フレーム更新 (アクターコマンドフェーズ : エネミー選択)
  #--------------------------------------------------------------------------
  def update_phase3_enemy_select
    # エネミーアローを更新
    @enemy_arrow.update
    
    # ★エネミーの表示状態の変更
    enemies_display(@enemy_arrow.enemy)
    
    # A ボタンが押された場合
    if Input.trigger?(Input::A)
      $game_temp.check_result_list = SR_Util.make_condition_text(@enemy_arrow.enemy)
      common_event = $data_common_events[51]
      $game_system.battle_interpreter.setup(common_event.list, 0)
      return
    end

    # F8 ボタンが押された場合
    if Input.trigger?(Input::F8) and $DEBUG
      SR_Util.make_succubus_message(@enemy_arrow.enemy)
    end
    
    # ホールドポップを表示する。
    if Input.trigger?(Input::UP) or Input.trigger?(Input::DOWN)
      # フラグを反転させる。備考（^=trueで真偽反転）
      @hold_pops_display ^= true
      hold_pops_display_check(@hold_pops_display)
    end

    
    # B ボタンが押された場合
    if Input.trigger?(Input::B)
      # キャンセル SE を演奏
      $game_system.se_play($data_system.cancel_se)
      # エネミーの選択を終了
      end_enemy_select
      # ★コマンドウィンドウはアクティブにしない。
      @actor_command_window.active = false
      # ★ウィンドウの後ろ帯を出す
      if @skill_window != nil
        @skill_window.window.visible = true #★
      elsif @item_window != nil
        @item_window.window.visible = true #★
      end
      return
    end
    
    # C ボタンが押された場合
    if Input.trigger?(Input::C)
      
      # command変数に格納（スキルの場合はスキル、アイテムの場合はアイテム）
      # スキルウィンドウ表示中の場合
      if @skill_window != nil
        command = @skill
      end
      # アイテムウィンドウ表示中の場合
      if @item_window != nil
        # アイテムの選択を終了
        command = @item
      end

      #----------------------------------------------------------------
      # ■ エラー集
      #----------------------------------------------------------------
      
      # ■相手：着衣中不可のスキルの場合
      if command.element_set.include?(178)
      #----------------------------------------------------------------
        #挿入系攻撃の場合、相手が特定半脱ぎ状態なら敢行可能
        #(ただし口挿入時を除く)
        if command.element_set.include?(134) and (command.element_set.include?(94) or command.element_set.include?(95) or command.element_set.include?(97))
          unless (@enemy_arrow.enemy.insertable_half_nude? or @enemy_arrow.enemy.full_nude?)
            $game_temp.error_message = "Can't use unless target is coｍpletely nude!"
            return
          end
#        elsif command.element_set.include?(37) or command.element_set.include?(38)
#          unless (@enemy_arrow.enemy.insertable_half_nude? or @enemy_arrow.enemy.full_nude?)
#            $game_temp.error_message = "相手が服を脱いでいないと使用できません！"
#            return
#          end
        # 相手が着衣状態である場合
        elsif not @enemy_arrow.enemy.full_nude?
          $game_system.se_play($data_system.cancel_se)
          $game_temp.message_text = "Can't use unless target is coｍpletely nude!"
          $game_temp.script_message = true
          return
        end
      end

      # ■相手：脱衣中不可のスキルの場合
      if command.element_set.include?(180)
      #----------------------------------------------------------------
        # 相手が裸状態である場合
        if @enemy_arrow.enemy.full_nude?
          $game_system.se_play($data_system.cancel_se)
          $game_temp.message_text = "相手が服を着ていないと使用できません！"
          $game_temp.script_message = true
          return
        end
      end

      # ■相手：♂占有時不可のスキルの場合
      if command.element_set.include?(141)
      #----------------------------------------------------------------
        # 相手のペニスが既に誰かに占有されている場合
        if @enemy_arrow.enemy.hold.penis.battler != nil
          $game_system.se_play($data_system.cancel_se)
          $game_temp.message_text = "相手のペニスが既に占有されているため使用できません！"
          $game_temp.script_message = true
          return
        end
      end
      # ■相手：口占有時不可のスキルの場合
      if command.element_set.include?(147)
      #----------------------------------------------------------------
        # 相手が挿入中の場合
        if @enemy_arrow.enemy.hold.mouth.battler != nil
          $game_system.se_play($data_system.cancel_se)
          $game_temp.message_text = "相手の口が既に占有されているため使用できません！"
          $game_temp.script_message = true
          return
        end
      end
      # ■相手：尻占有時不可のスキルの場合
      if command.element_set.include?(152)
      #----------------------------------------------------------------
        # 相手が挿入中の場合
        if @enemy_arrow.enemy.hold.anal.battler != nil
          $game_system.se_play($data_system.cancel_se)
          $game_temp.message_text = "相手のお尻が既に占有されているため使用できません！"
          $game_temp.script_message = true
          return
        end
      end
      # ■相手：アソコ占有時不可のスキルの場合
      if command.element_set.include?(156)
      #----------------------------------------------------------------
        # 相手が挿入中の場合
        if @enemy_arrow.enemy.hold.vagina.battler != nil
          $game_system.se_play($data_system.cancel_se)
          $game_temp.message_text = "相手のアソコが既に占有されているため使用できません！"
          $game_temp.script_message = true
          return
        end
      end
      # ■相手：上半身占有時不可のスキルの場合
      if command.element_set.include?(162)
      #----------------------------------------------------------------
        # 相手が挿入中の場合
        if @enemy_arrow.enemy.hold.tops.battler != nil
          $game_system.se_play($data_system.cancel_se)
          $game_temp.message_text = "相手の上半身が既に占有されているため使用できません！"
          $game_temp.script_message = true
          return
        end
      end
      # ■相手：尻尾占有時不可のスキルの場合
      if command.element_set.include?(166)
      #----------------------------------------------------------------
        # 相手が挿入中の場合
        if @enemy_arrow.enemy.hold.tail.battler != nil
          $game_system.se_play($data_system.cancel_se)
          $game_temp.message_text = "相手の尻尾が既に占有されているため使用できません！"
          $game_temp.script_message = true
          return
        end
      end
      
      # ■挿入中のみ可のスキルの場合
      if command.element_set.include?(142) or command.element_set.include?(167) or command.element_set.include?(172) or command.element_set.include?(183)
      #----------------------------------------------------------------
        # 相手が挿入状態で無い場合
        unless @enemy_arrow.enemy.vagina_insert? or @enemy_arrow.enemy.vagina_insert_special?
          $game_system.se_play($data_system.cancel_se)
          $game_temp.message_text = "相手と挿入中でないと使えません！"
          $game_temp.script_message = true
          return
        end
      end
      # ■口淫中のみ可のスキルの場合
      if command.element_set.include?(143) or command.element_set.include?(168) or command.element_set.include?(173) or command.element_set.include?(184)
      #----------------------------------------------------------------
        # 相手が口淫状態で無い場合
        unless @enemy_arrow.enemy.mouth_oralsex? or @enemy_arrow.enemy.mouth_oralsex_special?
          $game_system.se_play($data_system.cancel_se)
          $game_temp.message_text = "相手と口淫中でないと使えません！"
          $game_temp.script_message = true
          return
        end
      end
      # ■肛姦中のみ可のスキルの場合
      if command.element_set.include?(144) or command.element_set.include?(169) or command.element_set.include?(174) or command.element_set.include?(185)
      #----------------------------------------------------------------
        # 相手が肛姦状態で無い場合
        unless @enemy_arrow.enemy.anal_analsex?
          $game_system.se_play($data_system.cancel_se)
          $game_temp.message_text = "相手と肛姦中でないと使えません！"
          $game_temp.script_message = true
          return
        end
      end
      # ■被騎乗中のみ可のスキルの場合
      if command.element_set.include?(149)
      #----------------------------------------------------------------
        # 相手が騎乗状態で無い場合
        unless @enemy_arrow.enemy.vagina_riding?
          $game_system.se_play($data_system.cancel_se)
          $game_temp.message_text = "相手が騎乗中でないと使えません！"
          $game_temp.script_message = true
          return
        end
      end
      # ■騎乗中のみ可のスキルの場合
      if command.element_set.include?(158)
      #----------------------------------------------------------------
        # 相手に騎乗状態で無い場合
        unless @enemy_arrow.enemy.mouth_riding?
          $game_system.se_play($data_system.cancel_se)
          $game_temp.message_text = "相手に騎乗中でないと使えません！"
          $game_temp.script_message = true
          return
        end
      end
      # ■被尻騎乗中のみ可のスキルの場合
      if command.element_set.include?(145)
      #----------------------------------------------------------------
        # 相手に騎乗状態で無い場合
        unless @enemy_arrow.enemy.anal_hipriding?
          $game_system.se_play($data_system.cancel_se)
          $game_temp.message_text = "相手が騎乗中でないと使えません！"
          $game_temp.script_message = true
          return
        end
      end
      # ■尻騎乗中のみ可のスキルの場合
      if command.element_set.include?(154)
      #----------------------------------------------------------------
        # 相手が騎乗状態で無い場合
        unless @enemy_arrow.enemy.mouth_hipriding?
          $game_system.se_play($data_system.cancel_se)
          $game_temp.message_text = "相手に騎乗中でないと使えません！"
          $game_temp.script_message = true
          return
        end
      end
      # ■貝合わせ中のみ可のスキルの場合
      if command.element_set.include?(159)
      #----------------------------------------------------------------
        # 相手が貝合わせ状態で無い場合
        unless @enemy_arrow.enemy.shellmatch?
          $game_system.se_play($data_system.cancel_se)
          $game_temp.message_text = "相手と貝合わせ中でないと使えません！"
          $game_temp.script_message = true
          return
        end
      end
      # ■クンニ中のみ可のスキルの場合
      if command.element_set.include?(150)
      #----------------------------------------------------------------
        # 相手がクンニ状態で無い場合
        unless @enemy_arrow.enemy.vagina_draw?
          $game_system.se_play($data_system.cancel_se)
          $game_temp.message_text = "相手に口淫中でないと使えません！"
          $game_temp.script_message = true
          return
        end
      end
      # ■Dキッス中のみ可のスキルの場合
      if command.element_set.include?(170)
      #----------------------------------------------------------------
        # 相手がDキッス状態で無い場合
        unless @enemy_arrow.enemy.deepkiss?
          $game_system.se_play($data_system.cancel_se)
          $game_temp.message_text = "相手とキッス中でないと使えません！"
          $game_temp.script_message = true
          return
        end
      end
      # ■ぱふぱふ中のみ可のスキルの場合
      if command.element_set.include?(171)
      #----------------------------------------------------------------
        # 相手がぱふぱふ状態で無い場合
        unless @enemy_arrow.enemy.mouth_pahupahu?
          $game_system.se_play($data_system.cancel_se)
          $game_temp.message_text = "相手を抱擁中でないと使えません！"
          $game_temp.script_message = true
          return
        end
      end
      # ■拘束中のみ可のスキルの場合
      if command.element_set.include?(163)
      #----------------------------------------------------------------
        # 相手が拘束状態で無い場合
        unless (@enemy_arrow.enemy.tops_binder? or @enemy_arrow.enemy.tops_binding?)
          $game_system.se_play($data_system.cancel_se)
          $game_temp.message_text = "相手と密着中でないと使えません！"
          $game_temp.script_message = true
          return
        end
      end
      # ■ホールド解除スキル
      if command.is_a?(RPG::Skill) and (command.id == 28 or command.id == 29)
      #----------------------------------------------------------------
        # 相手が本気状態で挿入している場合
        if @enemy_arrow.enemy.earnest and @enemy_arrow.enemy.vagina_insert?
          $game_system.se_play($data_system.cancel_se)
          $game_temp.message_text = "彼女から逃げてはいけない！"
          $game_temp.script_message = true
          return
        end
      end

      #----------------------------------------------------------------

      # 決定 SE を演奏
      $game_system.se_play($data_system.decision_se)
      # アクションを設定
      @active_battler.current_action.target_index = @enemy_arrow.index
      # エネミーの選択を終了
      end_enemy_select
      # スキルウィンドウ表示中の場合
      if @skill_window != nil
        # スキルの選択を終了
        end_skill_select
      end
      # アイテムウィンドウ表示中の場合
      if @item_window != nil
        # アイテムの選択を終了
        end_item_select
      end
      # 次のアクターのコマンド入力へ
      phase3_next_actor
    end
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新 (アクターコマンドフェーズ : アクター選択)
  #--------------------------------------------------------------------------
  def update_phase3_actor_select
    # アクターアローを更新
    @actor_arrow.update

    # ホールドポップを表示する。
    if Input.trigger?(Input::UP) or Input.trigger?(Input::DOWN)
      # フラグを反転させる。備考（^=trueで真偽反転）
      @hold_pops_display ^= true
      hold_pops_display_check(@hold_pops_display)
    end


    # A ボタンが押された場合
    if Input.trigger?(Input::A)
       # ステート名の文字列を作成
       text = ""
       # １行に表示しているステート数を作成
       state_set = 0
       for i in @actor_arrow.actor.states
        if $data_states[i].rating >= 1
          if state_set == 0
            text = "　" + $data_states[i].name
            state_set += 1
          else
            new_text = text + "/" + $data_states[i].name
            state_set += 1
            text = new_text
            # １行にステートを５個描画したら改行
            if state_set == 7
              text += "\n　"
              state_set = 0
            end
          end
        end
      end
      # ステート名の文字列が空の場合は "ステート無し" にする
      if text == ""
        text = "　正常"
      end
      text_base = "【状態】\n"
      text = text_base + text
      # 決定 SE を演奏
      $game_system.se_play($data_system.decision_se)
      # 完成した文字列を表示
      $game_temp.message_text = text
      $game_temp.script_message = true
      return
    end
    # B ボタンが押された場合
    if Input.trigger?(Input::B)
      # キャンセル SE を演奏
      $game_system.se_play($data_system.cancel_se)
      # アクターの選択を終了
      end_actor_select
      # ★コマンドウィンドウはアクティブにしない。
      @actor_command_window.active = false
      # ★ウィンドウの後ろ帯を出す
      if @skill_window != nil
        @skill_window.window.visible = true #★
      elsif @item_window != nil
        @item_window.window.visible = true #★
      end
      return
    end
    # C ボタンが押された場合
    if Input.trigger?(Input::C)
      # 決定 SE を演奏
      $game_system.se_play($data_system.decision_se)
      # アクションを設定
      @active_battler.current_action.target_index = @actor_arrow.index
      # アクターの選択を終了
      end_actor_select
      # スキルウィンドウ表示中の場合
      if @skill_window != nil
        # スキルの選択を終了
        end_skill_select
      end
      # アイテムウィンドウ表示中の場合
      if @item_window != nil
        # アイテムの選択を終了
        end_item_select
      end
      # 次のアクターのコマンド入力へ
      phase3_next_actor
    end
  end
  #--------------------------------------------------------------------------
  # ● エネミー選択開始
  #--------------------------------------------------------------------------
  def start_enemy_select
    # エネミーアローを作成
    @enemy_arrow = Arrow_Enemy.new(@spriteset.viewport1)
    # ヘルプウィンドウを関連付け
    @enemy_arrow.help_window = @help_window
    # アクターコマンドウィンドウを無効化
    @actor_command_window.active = false
    @actor_command_window.visible = false
    
    if @active_battler.current_action.kind == 1
      skill_element_set = $data_skills[@active_battler.current_action.skill_id].element_set
    elsif @active_battler.current_action.kind == 2
      skill_element_set = $data_items[@active_battler.current_action.item_id].element_set
    end
    go_flag = false

    for i in 0...$game_troop.enemies.size
      
      enemy_one = $game_troop.enemies[i]
      
      # スキル以外は省略
      break if @active_battler.current_action.kind != 1
      # このエネミーがいない場合は次
      next unless enemy_one.exist?

      #♀挿入＝対象のアソコが♀挿入状態
      go_flag = true if skill_element_set.include?(142) and enemy_one.vagina_insert?
      #口挿入＝対象の口が口淫状態
      go_flag = true if skill_element_set.include?(143) and enemy_one.mouth_oralsex?
      #被口挿入＝対象のペニスが口淫状態(尻尾、触手、ディルド相手では反撃が発生しないため)
      go_flag = true if skill_element_set.include?(148) and enemy_one.penis_analsex?
      #被騎乗＝対象のアソコが騎乗状態
      go_flag = true if skill_element_set.include?(149) and enemy_one.vagina_riding?
      #被尻騎乗＝対象の尻が尻騎乗状態
      go_flag = true if skill_element_set.include?(145) and enemy_one.anal_hipriding?
      #被尻挿入＝対象のペニスが肛姦状態(尻尾、触手、ディルド相手では反撃が発生しないため)
      go_flag = true if skill_element_set.include?(153) and enemy_one.penis_analsex?
      #被♀挿入＝対象のペニスが挿入状態
      go_flag = true if skill_element_set.include?(157) and enemy_one.penis_insert?
      #騎乗＝対象の口が騎乗状態
      go_flag = true if skill_element_set.include?(158) and enemy_one.mouth_riding?
      #尻騎乗＝対象の口が尻騎乗状態
      go_flag = true if skill_element_set.include?(154) and enemy_one.mouth_hipriding?
      #貝合わせ＝対象のアソコが貝合わせ状態
      go_flag = true if skill_element_set.include?(159) and enemy_one.shellmatch?
      #クンニ＝対象のアソコがクンニ状態
      go_flag = true if skill_element_set.include?(150) and enemy_one.vagina_draw?
      #Dキッス＝対象の口がキッス状態
      go_flag = true if skill_element_set.include?(170) and enemy_one.deepkiss?
      #ぱふぱふ＝対象の口がぱふぱふ状態
      go_flag = true if skill_element_set.include?(171) and enemy_one.mouth_pahupahu?
      #パイズリ＝対象のペニスがパイズリ状態
      go_flag = true if skill_element_set.include?(160) and enemy_one.penis_paizuri?
      #拘束＝対象の上半身が拘束状態
      go_flag = true if skill_element_set.include?(163) and enemy_one.tops_binding?
      #尻尾♀挿入＝対象のアソコが♀挿入状態
      go_flag = true if skill_element_set.include?(167) and enemy_one.vagina_insert?
      #尻尾口挿入＝対象の口が口淫状態
      go_flag = true if skill_element_set.include?(168) and enemy_one.mouth_oralsex?
      #尻尾尻挿入＝対象の尻が肛姦状態
      go_flag = true if skill_element_set.include?(169) and enemy_one.anal_analsex?
      #触手♀挿入＝対象のアソコが♀挿入状態
      go_flag = true if skill_element_set.include?(172) and enemy_one.vagina_insert?
      #触手口挿入＝対象の口が口淫状態
      go_flag = true if skill_element_set.include?(173) and enemy_one.mouth_oralsex?
      #触手尻挿入＝対象の尻が肛姦状態
      go_flag = true if skill_element_set.include?(174) and enemy_one.anal_analsex?
      #触手拘束＝対象の上半身が拘束状態
      go_flag = true if skill_element_set.include?(175) and enemy_one.tentacle_binding?
      #Ｄ♀挿入＝対象のアソコが張子♀挿入状態
      go_flag = true if skill_element_set.include?(183) and enemy_one.dildo_vagina_insert?
      #Ｄ口挿入＝対象の口が張子口挿入状態
      go_flag = true if skill_element_set.include?(184) and enemy_one.dildo_mouth_oralsex?
      #Ｄ尻挿入＝対象の尻が張子尻挿入状態
      go_flag = true if skill_element_set.include?(185) and enemy_one.dildo_anal_analsex?
      #触手吸引＝対象のペニスが触手吸引状態
      go_flag = true if skill_element_set.include?(209) and enemy_one.tentacle_penis_absorbing?
      #触手クンニ＝対象のアソコが触手クンニ状態
      go_flag = true if skill_element_set.include?(210) and enemy_one.tentacle_vagina_draw?
      
      # この夢魔にしていい場合この夢魔にする
      if go_flag
        @enemy_arrow.index = i
        break
      end

    end
  end
  #--------------------------------------------------------------------------
  # ● エネミー選択終了
  #--------------------------------------------------------------------------
  def end_enemy_select
    # エネミーアローを解放
    @enemy_arrow.enemy.blink = false
    @enemy_arrow.dispose
    @enemy_arrow = nil
    # コマンドが [戦う] の場合
    if @actor_command_window.index == 0
      # アクターコマンドウィンドウを有効化
      @actor_command_window.active = true
      @actor_command_window.visible = true
      # ヘルプウィンドウを隠す
      @help_window.visible = false
    end
  end
  #--------------------------------------------------------------------------
  # ● アクター選択開始
  #--------------------------------------------------------------------------
  def start_actor_select
    # アクターアローを作成
    @actor_arrow = Arrow_Actor.new(@spriteset.viewport2)
    @actor_arrow.index = @actor_index
    # ヘルプウィンドウを関連付け
    @actor_arrow.help_window = @help_window
    # アクターコマンドウィンドウを無効化
    @actor_command_window.active = false
    @actor_command_window.visible = false
  end
  #--------------------------------------------------------------------------
  # ● アクター選択終了
  #--------------------------------------------------------------------------
  def end_actor_select
    # アクターアローを解放
    @actor_arrow.dispose
    @actor_arrow = nil
  end
  #--------------------------------------------------------------------------
  # ● スキル選択開始
  #--------------------------------------------------------------------------
  def start_skill_select
    # スキルウィンドウを作成
    @skill_window = Window_Skill_Battle.new(@active_battler)
    # ヘルプウィンドウを関連付け
    @skill_window.help_window = @help_window
    @help_window.window.visible = true # ★
    # アクターコマンドウィンドウを無効化
    @actor_command_window.active = false
    @actor_command_window.visible = false
    #●スキル位置記憶をしない場合はスキルを規定のスキルに合わせる
    unless $game_system.system_arrow == true
      if @active_battler.holding?
        for i in 0..@skill_window.item_max
          #インサート：♂
          if @active_battler.penis_insert?
            if @skill_window.data[i].name == "スウィング"
              @skill_window.index = i
              break
            end
          #インサート：♀
          elsif @active_battler.vagina_insert?
            if @skill_window.data[i].name == "グラインド"
              @skill_window.index = i
              break
            end
          #インサート：口
          elsif @active_battler.penis_oralsex?
            if @skill_window.data[i].name == "オーラルピストン"
              @skill_window.index = i
              break
            end
          #顔面騎乗・尻騎乗（攻）
          elsif @active_battler.vagina_riding?
            if @skill_window.data[i].name == "ライディング"
              @skill_window.index = i
              break
            end
          #顔面騎乗・尻騎乗（守）
          elsif @active_battler.mouth_riding? or @active_battler.mouth_hipriding?
            if @skill_window.data[i].name == "リック"
              @skill_window.index = i
              break
            end
          #貝合わせ
          elsif @active_battler.shellmatch?
            if @skill_window.data[i].name == "スクラッチ"
              @skill_window.index = i
              break
            end
          #クンニ
          elsif @active_battler.mouth_draw?
            if @skill_window.data[i].name == "サック"
              @skill_window.index = i
              break
            end
          #被クンニ
          elsif @active_battler.vagina_draw?
            if @skill_window.data[i].name == "プッシング"
              @skill_window.index = i
              break
            end
          #拘束
          elsif @active_battler.tops_binder?
            if @skill_window.data[i].name == "ミスチーフ"
              @skill_window.index = i
              break
            end
          #被拘束
          elsif @active_battler.tops_binding?
            if @skill_window.data[i].name == "リアカレス"
              @skill_window.index = i
              break
            end
          #ディルドインサート
          elsif @active_battler.dildo_insert?
            if @skill_window.data[i].name == "ディルドスウィング"
              @skill_window.index = i
              break
            end
          #ディルドインマウス
          elsif @active_battler.dildo_oralsex?
            if @skill_window.data[i].name == "オーラルディルド"
              @skill_window.index = i
              break
            end
          #デモンズサック
          elsif @active_battler.tentacle_draw?
            if @skill_window.data[i].name == "デモンズサック"
              @skill_window.index = i
              break
            end
          #被ペリスコープ
          elsif @active_battler.penis_paizuri?
            if @skill_window.data[i].name == "ラビングピストン"
              @skill_window.index = i
              break
            end
          #該当しない場合は解除スキルのリリースにカーソルを合わせる
          else
            if @skill_window.data[i].name == "リリース"
              @skill_window.index = i
              break
            end
          end
        end
        #ホールドで無い場合
      else
        for i in 0..@skill_window.item_max
        #キッスにカーソルを合わせる
          if @skill_window.data[i].name == "キッス"
            @skill_window.index = i
            break
          end
        end
      end
    #●スキル位置記憶をする場合
    else
      #スキル記憶が無い場合は、必ずキッスにセットする
      if @active_battler.skill_collect == nil or
        @active_battler.skill_collect == "" or
        (@active_battler.holding? and @active_battler.skill_collect.element_set.include?(131)) or
        (not @active_battler.holding? and @active_battler.skill_collect.element_set.include?(132))
        for i in 0..@skill_window.item_max
          if @active_battler.holding?
            #インサート：♂
            if @active_battler.penis_insert?
              if @skill_window.data[i].name == "スウィング"
                @skill_window.index = i
                break
              end
            #インサート：♀
            elsif @active_battler.vagina_insert?
              if @skill_window.data[i].name == "グラインド"
                @skill_window.index = i
                break
              end
            #インサート：口
            elsif @active_battler.penis_oralsex?
              if @skill_window.data[i].name == "オーラルピストン"
                @skill_window.index = i
                break
              end
            #顔面騎乗・尻騎乗（攻）
            elsif @active_battler.vagina_riding?
              if @skill_window.data[i].name == "ライディング"
                @skill_window.index = i
                break
              end
            #顔面騎乗・尻騎乗（守）
            elsif @active_battler.mouth_riding? or @active_battler.mouth_hipriding?
              if @skill_window.data[i].name == "リック"
                @skill_window.index = i
                break
              end
            #貝合わせ
            elsif @active_battler.shellmatch?
              if @skill_window.data[i].name == "スクラッチ"
                @skill_window.index = i
                break
              end
            #クンニ
            elsif @active_battler.mouth_draw?
              if @skill_window.data[i].name == "サック"
                @skill_window.index = i
                break
              end
            #被クンニ
            elsif @active_battler.vagina_draw?
              if @skill_window.data[i].name == "プッシング"
                @skill_window.index = i
                break
              end
            #拘束
            elsif @active_battler.tops_binder?
              if @skill_window.data[i].name == "ミスチーフ"
                @skill_window.index = i
                break
              end
            #被拘束
            elsif @active_battler.tops_binding?
              if @skill_window.data[i].name == "リアカレス"
                @skill_window.index = i
                break
              end
            #ディルドインサート
            elsif @active_battler.dildo_insert?
              if @skill_window.data[i].name == "ディルドスウィング"
                @skill_window.index = i
                break
              end
            #ディルドインマウス
            elsif @active_battler.dildo_oralsex?
              if @skill_window.data[i].name == "オーラルディルド"
                @skill_window.index = i
                break
              end
            #デモンズサック
            elsif @active_battler.tentacle_draw?
              if @skill_window.data[i].name == "デモンズサック"
                @skill_window.index = i
                break
              end
            #該当しない場合は解除スキルのリリースにカーソルを合わせる
            else
              if @skill_window.data[i].name == "リリース"
                @skill_window.index = i
                break
              end
            end
          #非ホールド状態ならキッスにカーソルを合わせる
          else
            if @skill_window.data[i].name == "キッス"
              @skill_window.index = i
              break
            end
          end
        end
      #スキル記憶がある場合、そのスキルにカーソルをセットする
      else
        for i in 0..@skill_window.item_max
          if @skill_window.data[i].name == @active_battler.skill_collect.name
            @skill_window.index = i
            break
          end
        end
      end
    end
  end
  #--------------------------------------------------------------------------
  # ● スキル選択終了
  #--------------------------------------------------------------------------
  def end_skill_select
    # スキルウィンドウを解放
    @skill_window.dispose
    @skill_window.window.dispose # ★
    @skill_window = nil
    # ヘルプウィンドウを隠す
    @help_window.visible = false
    @help_window.window.visible = false # ★
    # アクターコマンドウィンドウを有効化
    @actor_command_window.active = true
    @actor_command_window.visible = false #true
  end
  #--------------------------------------------------------------------------
  # ● アイテム選択開始
  #--------------------------------------------------------------------------
  def start_item_select
    # アイテムウィンドウを作成
    @item_window = Window_Item.new
    # ヘルプウィンドウを関連付け
    @item_window.help_window = @help_window
    @help_window.window.visible = true # ★
    # アクターコマンドウィンドウを無効化
    @actor_command_window.active = false
    @actor_command_window.visible = false
  end
  #--------------------------------------------------------------------------
  # ● アイテム選択終了
  #--------------------------------------------------------------------------
  def end_item_select
    # アイテムウィンドウを解放
    @item_window.dispose
    @item_window.window.dispose # ★
    @item_window = nil
    # ヘルプウィンドウを隠す
    @help_window.visible = false
    @help_window.window.visible = false # ★
    # アクターコマンドウィンドウを有効化
    @actor_command_window.active = true
    @actor_command_window.visible = true
  end
  #--------------------------------------------------------------------------
  # ● パーティ選択開始
  #--------------------------------------------------------------------------
  def start_party_select
    # アイテムウィンドウを作成
    @party_window = Window_Partychange.new
    for i in 0...$game_party.party_actors.size
      if @active_battler == $game_party.party_actors[i]
        @party_window.index = i
      end
    end
#    if @active_battler == $game_actors[101]
#      @party_window.index = 0
#    else
#      @party_window.index = 1
#    end
    # ヘルプウィンドウを関連付け
    @party_window.help_window = @help_window
    @help_window.window.visible = true # ★
    
    # 確認ウィンドウを作成
    @party_check = []
    commands0 = ["ステータス", "キャンセル"]
    @party_check[0] = Window_Command.new(160, commands0)
    commands1 = ["ステータス", "この夢魔と交代", "キャンセル"]
    @party_check[1] = Window_Command.new(160, commands1)
    for i in 0..1
      @party_check[i].back_opacity = 255
      @party_check[i].x = (640 - @party_check[i].width) / 2
      @party_check[i].y = (480 - @party_check[i].height) / 2
      @party_check[i].z = 2100
      @party_check[i].visible = false
      @party_check[i].active = false
    end
    # アクターコマンドウィンドウを無効化
    @actor_command_window.active = false
    @actor_command_window.visible = false
  end
  #--------------------------------------------------------------------------
  # ● パーティ選択終了
  #--------------------------------------------------------------------------
  def end_party_select
    # パーティウィンドウを解放
    @party_window.dispose
    @party_window = nil
    # ヘルプウィンドウを隠す
    @help_window.visible = false
    @help_window.window.visible = false # ★
    # 確認ウィンドウを解放
    for check in @party_check
      check.dispose
    end
    # アクターコマンドウィンドウを有効化
    @actor_command_window.active = true
    @actor_command_window.visible = true
  end
  #--------------------------------------------------------------------------
  # ● パーティ選択開始
  #--------------------------------------------------------------------------
  def start_party_select_status
  end
  #--------------------------------------------------------------------------
  # ● パーティ選択開始
  #--------------------------------------------------------------------------
  def end_party_select_status
  end
  #--------------------------------------------------------------------------
  # ★ アクターコマンドの全視覚化
  #--------------------------------------------------------------------------
  def command_all_active
    @actor_command_window.active = true
    @actor_command_window.window.visible = true
    @actor_command_window.skill.visible = true
    @actor_command_window.item.visible = true
    @actor_command_window.change.visible = true
    @actor_command_window.escape.visible = true
    @actor_command_window.help.visible = true
    @actor_command_window.window.opacity = 51
    @actor_command_window.window.y = -12
  end
  #--------------------------------------------------------------------------
  # ★ アクターコマンドの全視覚化解除
  #--------------------------------------------------------------------------
  def command_all_delete
    @actor_command_windowactive = false
    @actor_command_window.window.visible = false
    @actor_command_window.skill.visible = false
    @actor_command_window.item.visible = false
    @actor_command_window.change.visible = false
    @actor_command_window.escape.visible = false
    @actor_command_window.help.visible = false
  end
end
