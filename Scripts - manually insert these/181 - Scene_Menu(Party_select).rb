#==============================================================================
# ■ Scene_Menu
#------------------------------------------------------------------------------
# 　メニュー画面の処理を行うクラスです。
#==============================================================================

class Scene_Menu
  #--------------------------------------------------------------------------
  # ● フレーム更新 : パーティ選択
  #--------------------------------------------------------------------------
  def update_actor_select
    
    if @party_change_flag
      update_party_select_change
      return
    end
    
    if @menu_party_command_window[0].visible or @menu_party_command_window[1].visible
      update_party_select_command
      return
    end
    
    # C ボタンが押された場合
    if Input.trigger?(Input::C)
      # 決定 SE を演奏
      $game_system.se_play($data_system.decision_se)
      @select_blink_flag = false
      @select_blink_check = true
      @select.opacity = 255
      
      if $game_party.actors[@select_index] == $game_actors[101]
        @menu_party_command_window[0].visible = true
        @menu_party_command_window[0].active = true
        @menu_party_command_window[0].index = 0
      else
        @menu_party_command_window[1].visible = true
        @menu_party_command_window[1].active = true
        @menu_party_command_window[1].index = 0
      end
      return
    end
    
    
    # C ボタンが押された場合
    if Input.trigger?(Input::C)
      # 決定 SE を演奏
      $game_system.se_play($data_system.decision_se)
      @fade_flag = 4
      # セレクトをリセット
      @select.opacity = 0
      @select.visible = false
      @select_blink_check = false
      @command = 1
      @center_window = Window_Status.new($game_party.actors[@select_index])
      actor = $game_party.actors[@select_index]
      @actor_graphic.bitmap = RPG::Cache.battler(actor.battler_name, actor.battler_hue)
      @actor_graphic.x = 320
      @actor_graphic.y = 240
      @actor_graphic.y += 60 if actor.boss_graphic?
      @actor_graphic.ox = @actor_graphic.bitmap.width / 2
      @actor_graphic.oy = @actor_graphic.bitmap.height / 2
      @window[0].visible = true
      @window[0].y = 40
      @help_window.visible = true
      @help_window.window.visible = true
      text = "決定：装備変更・ルーン刻印　←→：表示メンバー変更　↑↓：ウィンドウ変更"
      @help_window.set_text(text, 1)
      n = 340
      @help_window.y = n
      @help_window.window.y = n
      @overF_text = "S t a t u s"
      @party_command = 0
      return
    end
    
    # B ボタンが押された場合
    if Input.trigger?(Input::B)
      # キャンセル SE を演奏
      $game_system.se_play($data_system.cancel_se)
      # 上部テキストを戻す
      @overF_text = $game_party.gold.to_s + "　" + $data_system.words.gold
      # メニューに戻る
      @command = 0
      @fade_flag = 5
      # セレクトをリセット
      @select.opacity = 0
      @select.visible = false
      @select_index = 0
      @select_blink_check = false
      return
    end
    
    # 右 ボタンが押された場合
    if Input.repeat?(Input::RIGHT)
      # カーソル SE を演奏
      $game_system.se_play($data_system.cursor_se)
      @select_index += 1
      if @select_index > $game_party.actors.size - 1
        @select_index = 0
      end  
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
      return
    end
    # 上 ボタンが押された場合
    if Input.repeat?(Input::UP)
      # カーソル SE を演奏
      $game_system.se_play($data_system.cursor_se)
      @select_index -= 2
      if @select_index < 0
        if $game_party.actors.size == 1 or $game_party.actors.size == 3
          if $game_party.actors.size == 3 and @select_index == -1
            @select_index += $game_party.actors.size
          else
            @select_index += $game_party.actors.size + 1
          end
        else
          @select_index += $game_party.actors.size
        end
        
      end  
      return
    end
    # 下 ボタンが押された場合
    if Input.repeat?(Input::DOWN)
      # カーソル SE を演奏
      $game_system.se_play($data_system.cursor_se)
      @select_index += 2
      if @select_index > $game_party.actors.size - 1
        if @select_index == 3 or @select_index == 5
          if $game_party.actors.size == 3
            @select_index = 2
          else
            @select_index = 1
          end
        else
          @select_index = 0
        end
      end  
      return
    end
    
  end

  #--------------------------------------------------------------------------
  # ● フレーム更新 (確認ウィンドウがアクティブの場合)
  #--------------------------------------------------------------------------
  def update_party_select_command
    
    
    # コマンド開始
    if $game_temp.script_message_index != 99
      # の刻印をしてもいいですか？
      case $game_temp.script_message_index
      when 0 # いいえ
        if $game_temp.script_message_cancel == false
          $game_system.se_play($data_system.decision_se) 
        end
      when 1 # はい
        # 決定 SE を演奏
        $game_system.se_play($data_system.decision_se)
        if $game_actors[101].sp <= $game_party.party_actors[@select_index].absorb
          $game_temp.message_text = $game_actors[101].name + "のVPが不足しています！"
        else
          @menu_party_command_window[1].visible = false
          @select.visible = false
          $game_temp.battle_active_battler = $game_party.party_actors[@select_index]
          # コモンイベント ID が有効の場合
          $game_temp.common_event_id = 41
          # マップ画面に切り替え
          @fade_flag = 2
        end
      end
      $game_temp.script_message_index = 99
      return
    end

    
    
    if @menu_party_command_window[0].active
      @menu_party_command_window[0].update
      
      # C ボタンが押された場合
      if Input.trigger?(Input::C)
        # 決定 SE を演奏
        $game_system.se_play($data_system.decision_se)
        
        case @menu_party_command_window[0].index
        
        when 0 # ステータス
          @fade_flag = 4
          # セレクトをリセット
          @select.opacity = 0
          @select.visible = false
          @select_blink_check = false
          @command = 1
          @center_window = Window_Status.new($game_party.actors[@select_index])
          actor = $game_party.actors[@select_index]
          @actor_graphic.bitmap = RPG::Cache.battler(actor.battler_name, actor.battler_hue)
          @actor_graphic.x = 320
          @actor_graphic.y = 240
          @actor_graphic.y += 60 if actor.boss_graphic?
          @actor_graphic.ox = @actor_graphic.bitmap.width / 2
          @actor_graphic.oy = @actor_graphic.bitmap.height / 2
          @window[0].visible = true
          @window[0].y = 40
          @help_window.visible = true
          @help_window.window.visible = true
          text = "決定：装備変更・ルーン刻印　←→：表示メンバー変更　↑↓：ウィンドウ変更"
          @help_window.set_text(text, 1)
          n = 340
          @help_window.y = n
          @help_window.window.y = n
          @overF_text = "S t a t u s"
          @party_command = 0
          @menu_party_command_window[0].visible = false
          @menu_party_command_window[0].active = false
          @select_blink_flag = true
          return
        when 1 # キャンセル
          @menu_party_command_window[0].visible = false
          @menu_party_command_window[0].active = false
          @select_blink_flag = true
          return
        end
      end
      
    else
      @menu_party_command_window[1].update
      
      # C ボタンが押された場合
      if Input.trigger?(Input::C)
        # 決定 SE を演奏
        $game_system.se_play($data_system.decision_se)
        
        case @menu_party_command_window[1].index
        
        when 0 # ステータス
          @fade_flag = 4
          # セレクトをリセット
          @select.opacity = 0
          @select.visible = false
          @select_blink_check = false
          @command = 1
          @center_window = Window_Status.new($game_party.actors[@select_index])
          actor = $game_party.actors[@select_index]
          @actor_graphic.bitmap = RPG::Cache.battler(actor.battler_name, actor.battler_hue)
          @actor_graphic.x = 320
          @actor_graphic.y = 240
          @actor_graphic.y += 60 if actor.boss_graphic?
          @actor_graphic.ox = @actor_graphic.bitmap.width / 2
          @actor_graphic.oy = @actor_graphic.bitmap.height / 2
          @window[0].visible = true
          @window[0].y = 40
          @help_window.visible = true
          @help_window.window.visible = true
          text = "決定：装備変更・ルーン刻印　←→：表示メンバー変更　↑↓：ウィンドウ変更"
          @help_window.set_text(text, 1)
          n = 340
          @help_window.y = n
          @help_window.window.y = n
          @overF_text = "S t a t u s"
          @party_command = 0
          @menu_party_command_window[1].visible = false
          @menu_party_command_window[1].active = false
          @select_blink_flag = true
          return
        when 1
          @menu_party_command_window[1].visible = false
          @menu_party_command_window[1].active = false
          @select_blink_flag = true
          @party_change_flag = true
          @now_select_index = @select_index
          @now_select.visible = true
          @overF_text = "C h a n g e"
          return
        when 2
          # メッセージ表示中フラグを立てる
          $game_temp.message_window_showing = true
          $game_temp.script_message = true
          if not $game_party.actors[@select_index].state?(15)
            text = "空腹でない夢魔に精を献上することはできません！"
            $game_temp.message_text = text
            return
          end
          if not $game_party.actors[@select_index].dead?
            #●割合吸収テスト
            eat = $game_party.actors[@select_index].absorb
#            eat_p = (100 - $game_party.actors[@select_index].fed)
#            eat = (eat * eat_p / 100).round
            text = $game_party.actors[@select_index].name + "に精を献上しますか？\n"
            text += "（" + $game_actors[101].name + "のVPを"+ eat.to_s + "消費します）"
            text += "\nやめる\n献上する"
            $game_temp.choice_start = 2
            # 決定 SE を演奏
            $game_system.se_play($data_system.decision_se) 
            $game_temp.message_text = text
            $game_temp.choice_max = 2
            $game_temp.choice_cancel_type = 1
          else
            text = "失神している夢魔に精を献上することはできません！"
            $game_temp.message_text = text
          end
          return

          
          
        when 3 # キャンセル
          @menu_party_command_window[1].visible = false
          @menu_party_command_window[1].active = false
          @select_blink_flag = true
          return
        end
      end
    end
    
    # B ボタンが押された場合
    if Input.trigger?(Input::B)
      # キャンセル SE を演奏
      $game_system.se_play($data_system.cancel_se)
      @menu_party_command_window[0].visible = false
      @menu_party_command_window[0].active = false
      @menu_party_command_window[1].visible = false
      @menu_party_command_window[1].active = false
      @select_blink_flag = true
      return
    end
  end
  
  
  
  #--------------------------------------------------------------------------
  # ● フレーム更新 (並び替え中の場合)
  #--------------------------------------------------------------------------
  def update_party_select_change
    
    # C ボタンが押された場合
    if Input.trigger?(Input::C)
      if $game_party.actors[@select_index] == $game_actors[101] \
       or @now_select_index == @select_index
        # ブザー SE を演奏
        $game_system.se_play($data_system.buzzer_se)
        return
      end
      # 決定 SE を演奏
      $game_system.se_play($data_system.decision_se)
      # SE を演奏
      Audio.se_play("Audio/SE/005-System05", 80, 100)
      @select_blink_check = true
      @select.opacity = 255
      @party_change_flag = false
#      @select_index = @now_select_index
      @now_select.visible = false
      
      # 指定メンバーの複製を作る
      @select_actor1 = $game_party.actors[@select_index]
      @select_actor2 = $game_party.actors[@now_select_index]
      
      @fade_flag = 7
      return
    end
    
    # B ボタンが押された場合
    if Input.trigger?(Input::B)
      # キャンセル SE を演奏
      $game_system.se_play($data_system.cancel_se)
      @select_blink_flag = true
      @select_blink_check = true
      @select.opacity = 255
      @party_change_flag = false
#      @select_index = @now_select_index
      @now_select.visible = false
      @overF_text = "P a r t y"
      return
    end
    
        
    # 右 ボタンが押された場合
    if Input.repeat?(Input::RIGHT)
      # カーソル SE を演奏
      $game_system.se_play($data_system.cursor_se)
      @select_index += 1
      if @select_index > $game_party.actors.size - 1
        @select_index = 0
      end  
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
      return
    end
    # 上 ボタンが押された場合
    if Input.repeat?(Input::UP)
      # カーソル SE を演奏
      $game_system.se_play($data_system.cursor_se)
      @select_index -= 2
      if @select_index < 0
        if $game_party.actors.size == 1 or $game_party.actors.size == 3
          if $game_party.actors.size == 3 and @select_index == -1
            @select_index += $game_party.actors.size
          else
            @select_index += $game_party.actors.size + 1
          end
        else
          @select_index += $game_party.actors.size
        end
        
      end  
      return
    end
    # 下 ボタンが押された場合
    if Input.repeat?(Input::DOWN)
      # カーソル SE を演奏
      $game_system.se_play($data_system.cursor_se)
      @select_index += 2
      if @select_index > $game_party.actors.size - 1
        if @select_index == 3 or @select_index == 5
          if $game_party.actors.size == 3
            @select_index = 2
          else
            @select_index = 1
          end
        else
          @select_index = 0
        end
      end  
      return
    end
    

    
  end
end