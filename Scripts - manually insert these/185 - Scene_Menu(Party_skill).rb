#==============================================================================
# ■ Scene_Menu
#------------------------------------------------------------------------------
# 　メニュー画面の処理を行うクラスです。
#==============================================================================

class Scene_Menu
  #--------------------------------------------------------------------------
  # ● フレーム更新
  #--------------------------------------------------------------------------
  def update_party_skill
    
    # ウィンドウを更新
    @target_window.update
    
    # ターゲットウィンドウがアクティブの場合: update_target を呼ぶ
    if @center_window.active
      update_skill_active
      return
    end
    # ターゲットウィンドウがアクティブの場合: update_target を呼ぶ
    if @target_window.active
      update_skill_target_active
      return
    end
    
    # B ボタンが押された場合
    if Input.trigger?(Input::B)
      # キャンセル SE を演奏
      $game_system.se_play($data_system.cancel_se)
      # パーティセレクトに戻る
      @command = 0
      @fade_flag = 5
      @select.visible = false
      
      @window[0].y = 100
      @window[0].visible = false
      
      @center_window.dispose
      @center_window1.dispose
      
      @actor_graphic.bitmap = nil
      n = 30
      @help_window.visible = false
      @help_window.y = n
      @help_window.window.visible = false
      @help_window.window.y = n
      @overF_text = $game_party.gold.to_s + "　" + $data_system.words.gold
      center_refresh      

      return
    end
    
    # C ボタンが押された場合
    if Input.trigger?(Input::C)
      # 決定 SE を演奏
      $game_system.se_play($data_system.decision_se)
      @center_window.index = 0
      @center_window.help_window = @help_window
      @center_window.refresh
      @center_window.active = true
      return
    end


    
    # 右 ボタンが押された場合
    if Input.repeat?(Input::RIGHT)
      # カーソル SE を演奏
      @select_index += 1
      if @select_index > $game_party.actors.size - 1
        @select_index = 0
      end  
      $game_system.se_play($data_system.cursor_se)
      actor = $game_party.actors[@select_index]
      @center_window.actor = actor
      @center_window.refresh
      @center_window1.actor = actor
      @center_window1.refresh
      @actor_graphic.x = 320
      @actor_graphic.y = 240
      @actor_graphic.y += 60 if actor.boss_graphic?
      @actor_graphic.bitmap = RPG::Cache.battler(actor.battler_name, actor.battler_hue)
      @actor_graphic.ox = @actor_graphic.bitmap.width / 2
      @actor_graphic.oy = @actor_graphic.bitmap.height / 2
      return
    end
    
    # 左 ボタンが押された場合
    if Input.repeat?(Input::LEFT)
      # カーソル SE を演奏
      $game_system.se_play($data_system.cursor_se)
      @select_index -= 1
      if @select_index < 0
        @select_index = $game_party.actors.size - 1
      end  
      $game_system.se_play($data_system.cursor_se)
      actor = $game_party.actors[@select_index]
      @center_window.actor = actor
      @center_window.refresh
      @center_window1.actor = actor
      @center_window1.refresh
      @actor_graphic.x = 320
      @actor_graphic.y = 240
      @actor_graphic.y += 60 if actor.boss_graphic?
      @actor_graphic.bitmap = RPG::Cache.battler(actor.battler_name, actor.battler_hue)
      @actor_graphic.ox = @actor_graphic.bitmap.width / 2
      @actor_graphic.oy = @actor_graphic.bitmap.height / 2
      return
    end
    
    # 上 ボタンが押された場合
    if Input.repeat?(Input::UP)
      # カーソル SE を演奏
      $game_system.se_play($data_system.cursor_se)

      actor = $game_party.actors[@select_index]
      
      @center_window.dispose
      @center_window = Window_Status.new(actor)
      @center_window.index = -2
      @center_window.refresh
      @overF_text = "S t a t u s"
      text = "決定：装備変更・ルーン刻印　←→：表示メンバー変更　↑↓：ウィンドウ変更"
      @help_window.set_text(text, 1)
      @center_window1.dispose
      @party_command = 0
      return
    end

    # 下 ボタンが押された場合
    if Input.repeat?(Input::DOWN)
      # カーソル SE を演奏
      $game_system.se_play($data_system.cursor_se)
      actor = $game_party.actors[@select_index]
      @center_window.dispose
      @center_window = Window_Ability.new(actor)
      @center_window.index = 0
      @center_window.refresh
      @center_window.index = -1
      @center_window.refresh
      @overF_text = "A b i l i t y"
      text = "決定：素質確認　←→：表示メンバー変更　↑↓：ウィンドウ変更"
      @help_window.set_text(text, 1)
      @party_command = 1
      return
    end
  end
  
  #--------------------------------------------------------------------------
  # ● フレーム更新 (ターゲットウィンドウがアクティブの場合)
  #--------------------------------------------------------------------------
  def update_skill_active
    
    
    # B ボタンが押された場合
    if Input.trigger?(Input::B)
      # キャンセル SE を演奏
      $game_system.se_play($data_system.cancel_se)
      @center_window.help_window = nil
      @center_window.active = false
      @center_window.index = -1
      @center_window.refresh
      text = "決定：スキル確認　←→：表示メンバー変更　↑↓：ウィンドウ変更"
      @help_window.set_text(text, 1)
      return
    end

    
    # C ボタンが押された場合
    if Input.trigger?(Input::C)
      # スキルウィンドウで現在選択されているデータを取得
      @skill = @center_window.skill
      @actor = $game_party.party_actors[@select_index]
      # 使用できない場合
      if @skill == nil or not @actor.skill_can_use?(@skill.id)
        # ブザー SE を演奏
        $game_system.se_play($data_system.buzzer_se)
        return
      end
      # 決定 SE を演奏
      $game_system.se_play($data_system.decision_se)
      # 効果範囲が味方の場合
      if @skill.scope >= 3
        # ターゲットウィンドウをアクティブ化
        @center_window.visible = false
        @center_window.active = false
        @target_window.y = 60
        @target_window.visible = true
        @target_window.active = true
        @target_window.icon = @skill.icon_name
        @target_window.name = @skill.name
        # 効果範囲 (単体/全体) に応じてカーソル位置を設定
        if @skill.scope == 4 || @skill.scope == 6
          @target_window.index = -1
        elsif @skill.scope == 7
          @target_window.index = @select_index - 10
        else
          @target_window.index = 0
        end
        @target_window.refresh
      # 効果範囲が味方以外の場合
      else
        # コモンイベント ID が有効の場合
        if @skill.common_event_id > 0
          # コモンイベント呼び出し予約
          $game_temp.common_event_id = @skill.common_event_id
          # スキルの使用時 SE を演奏
          $game_system.se_play(@skill.menu_se)
          # SP 消費
          @actor.sp -= @skill.sp_cost
          # 使用者を記録
          $game_temp.skilluse_actor = $game_party.party_actors[@select_index]
          # 各ウィンドウの内容を再作成
          @center_window.refresh
          @target_window.refresh
          @center_window.visible = false
          # マップ画面に切り替え
          @fade_flag = 9
          return
        end
      end
      return
    end
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新 (ターゲットウィンドウがアクティブの場合)
  #--------------------------------------------------------------------------
  def update_skill_target_active
    # B ボタンが押された場合
    if Input.trigger?(Input::B)
      # キャンセル SE を演奏
      $game_system.se_play($data_system.cancel_se)
      # ターゲットウィンドウを消去
      @center_window.visible = true
      @center_window.active = true
      @target_window.visible = false
      @target_window.active = false
      return
    end
    # C ボタンが押された場合
    if Input.trigger?(Input::C)
      # SP 切れなどで使用できなくなった場合
      unless @actor.skill_can_use?(@skill.id)
        # ブザー SE を演奏
        $game_system.se_play($data_system.buzzer_se)
        return
      end
      # ターゲットが全体の場合
      if @target_window.index == -1
        # パーティ全体にスキルの使用効果を適用
        used = false
        for i in $game_party.party_actors
          used |= i.skill_effect(@actor, @skill)
        end
      end
      # ターゲットが使用者の場合
      if @target_window.index <= -2
        # ターゲットのアクターにスキルの使用効果を適用
        target = $game_party.party_actors[@target_window.index + 10]
        used = target.skill_effect(@actor, @skill)
      end
      # ターゲットが単体の場合
      if @target_window.index >= 0
        # ターゲットのアクターにスキルの使用効果を適用
        target = $game_party.party_actors[@target_window.index]
        used = target.skill_effect(@actor, @skill)
      end
      # スキルを使った場合
      if used
        # スキルの使用時 SE を演奏
        $game_system.se_play(@skill.menu_se)
        # SP 消費
        @actor.sp -= @skill.sp_cost
        # 各ウィンドウの内容を再作成
        @center_window.refresh
        @center_window1.refresh
        @target_window.refresh
        center_refresh
        # 全滅の場合
        if $game_party.all_dead?
          # ゲームオーバー画面に切り替え
          $scene = Scene_Gameover.new
          return
        end
        # コモンイベント ID が有効の場合
        if @skill.common_event_id > 0
          # コモンイベント呼び出し予約
          $game_temp.common_event_id = @skill.common_event_id
          # 使用者を記録
          $game_temp.skilluse_actor = $game_party.party_actors[@select_index]
          @center_window.visible = false
          # マップ画面に切り替え
          @fade_flag = 9
          return
        end
      end
      # スキルを使わなかった場合
      unless used
        # ブザー SE を演奏
        $game_system.se_play($data_system.buzzer_se)
      end
      return
    end
  end
end