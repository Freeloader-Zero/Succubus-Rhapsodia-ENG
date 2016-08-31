#==============================================================================
# ■ Scene_Menu
#------------------------------------------------------------------------------
# 　メニュー画面の処理を行うクラスです。
#==============================================================================

class Scene_Menu
  #--------------------------------------------------------------------------
  # ● フレーム更新 : メンバーステータス画面
  #--------------------------------------------------------------------------
  def update_party_ability
    
    # 素質ウィンドウがアクティブの場合: update_target を呼ぶ
    if @center_window.active
      update_ability_active
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
      @center_window.index = 0
      @center_window.refresh
      @center_window.index = -1
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
      @center_window.index = 0
      @center_window.refresh
      @center_window.index = -1
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
    
     
    # 下 ボタンが押された場合
    if Input.repeat?(Input::DOWN)
      # カーソル SE を演奏
      $game_system.se_play($data_system.cursor_se)

      actor = $game_party.actors[@select_index]
      
      @center_window.dispose
      @center_window = Window_Status.new(actor)
      @center_window.index = -2
      @center_window.refresh
      @center_window1.dispose
      @overF_text = "S t a t u s"
      text = "ENTER: Examine Equipment/Runes　←→：Cycle Party Member　↑↓：Change Window"
      @help_window.set_text(text, 1)
      @party_command = 0
      return
    end

    # 上 ボタンが押された場合
    if Input.repeat?(Input::UP)
      # カーソル SE を演奏
      $game_system.se_play($data_system.cursor_se)
      actor = $game_party.actors[@select_index]
      @center_window.dispose
      @center_window = Window_Skill.new(actor)
      @center_window.index = 0
      @center_window.refresh
      @center_window.index = -1
      @center_window.active = false
      @center_window.refresh
      @overF_text = "S k i l l s"
      text = "ENTER: Examine Skills　←→：Cycle Party Member　↑↓：Change Window"
      @help_window.set_text(text, 1)
      @party_command = 2
      return
    end
    
    
  end
  
  
  #--------------------------------------------------------------------------
  # ● フレーム更新 : メンバーステータス画面
  #--------------------------------------------------------------------------
  def update_ability_active

    # C ボタンが押された場合
    if Input.trigger?(Input::C)
      # ブザー SE を演奏
      $game_system.se_play($data_system.buzzer_se)
      return
    end
    
    # B ボタンが押された場合
    if Input.trigger?(Input::B)
      # キャンセル SE を演奏
      $game_system.se_play($data_system.cancel_se)
      @center_window.help_window = nil
      @center_window.active = false
      @center_window.index = -1
      @center_window.refresh
      text = "ENTER: Examine Traits　←→：Cycle Party Member　↑↓：Change Window"
      @help_window.set_text(text, 1)
      return
    end
    
  end
  
end