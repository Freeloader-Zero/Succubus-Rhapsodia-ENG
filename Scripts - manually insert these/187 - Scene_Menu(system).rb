#==============================================================================
# ■ Scene_Menu
#------------------------------------------------------------------------------
# 　メニュー画面の処理を行うクラスです。
#==============================================================================

class Scene_Menu
  #--------------------------------------------------------------------------
  # ● フレーム更新（システム）
  #--------------------------------------------------------------------------
  def update_system
    @center_window.update
    # コマンド開始
    if $game_temp.script_message_index != 99
      case $game_temp.script_message_index
      when 0 # やめる
        if $game_temp.script_message_cancel == false
          $game_system.se_play($data_system.decision_se) 
        end
        $game_temp.script_message_index = 99
      when 1 # タイトルへ戻る
        # 決定 SE を演奏
        $game_system.se_play($data_system.decision_se)
        @center_window.dispose
        @fade_flag = 6
        # BGM、BGS、ME をフェードアウト
        Audio.bgm_fade(800)
        Audio.bgs_fade(800)
        Audio.me_fade(800)
        # タイトル画面に切り替え
        $scene = Scene_Title.new
        
        
      when 2 # シャットダウン
        # 決定 SE を演奏
        $game_system.se_play($data_system.decision_se)
        @center_window.dispose
        @fade_flag = 6
        # BGM、BGS、ME をフェードアウト
        Audio.bgm_fade(800)
        Audio.bgs_fade(800)
        Audio.me_fade(800)
        # シャットダウン
        $scene = nil
      end
      return
    end


    
    
    
    # B ボタンが押された場合
    if Input.trigger?(Input::B)
=begin
      #メッセージ表示速度を再設定
      #変数45：システムウェイト(フェイズの合間のウェイト)
      #変数46：メッセージウェイト(\mや\wの基準値)
      #変数47：オートモード速度(テロップ時のみ有効)
      case $game_system.system_battle_speed
      when 0
        $game_variables[45] = 60
        $game_variables[46] = 5
        $game_variables[47] = 60
      when 1
        $game_variables[45] = 30
        $game_variables[46] = 3
        $game_variables[47] = 40
      when 2
        $game_variables[45] = 16
        $game_variables[46] = 1
        $game_variables[47] = 28
      end
=end
      # キャンセル SE を演奏
      $game_system.se_play($data_system.cancel_se)
      # 上部テキストを戻す
      @overF_text = $game_party.gold.to_s + "　" + $data_system.words.gold
      @help_window.visible = false
      @help_window.window.visible = false
      @item_window.visible = false
      @window[0].visible = false
      @center_window.dispose
      # メニューに戻る
      @command = 0
      @fade_flag = 5
    end

    # C ボタンが押された場合
    if Input.trigger?(Input::C)
      if @center_window.index == 13
        # 決定 SE を演奏
        $keybd = Win32API.new 'user32.dll', 'keybd_event', ['i', 'i', 'l', 'l'], 'v'
        $keybd.call 0xA4, 0, 0, 0
        $keybd.call 13, 0, 0, 0
        $keybd.call 13, 0, 2, 0
        $keybd.call 0xA4, 0, 2, 0
        return
      elsif @center_window.index == 14
        # 決定 SE を演奏
        $game_system.se_play($data_system.decision_se)
        
        text = "Quit game?"
        text += "\nCancel\nBack to Title\nShutdown"
        $game_temp.choice_start = 1
        # 決定 SE を演奏
        $game_system.se_play($data_system.decision_se) 
        $game_temp.message_text = text
        $game_temp.choice_max = 3
        $game_temp.choice_cancel_type = 1
        # メッセージ表示中フラグを立てる
        $game_temp.message_window_showing = true
        $game_temp.script_message = true
        return
      end
      # ブザー SE を演奏
      $game_system.se_play($data_system.buzzer_se)
      return
    end
    
    
    # 下 ボタンが押された場合
    if Input.repeat?(Input::DOWN)
      # カーソル SE を演奏
      $game_system.se_play($data_system.cursor_se)
      @center_window.index += 1
      @center_window.index = 0 if @center_window.index > @center_window.max - 1
      @center_window.refresh
      @center_window.index += 1 if @center_window.index == 0 or @center_window.index == 5 or @center_window.index == 12
      @center_window.refresh
      return
    end

    # 上 ボタンが押された場合
    if Input.repeat?(Input::UP)
      # カーソル SE を演奏
      $game_system.se_play($data_system.cursor_se)
      @center_window.index -= 1
      @center_window.index = @center_window.max - 1 if @center_window.index <= 0
      @center_window.refresh
      @center_window.index -= 1 if @center_window.index == 5 or @center_window.index == 12
      @center_window.refresh
      return
    end

    # 右 ボタンが押された場合
    if Input.repeat?(Input::RIGHT)
      # カーソル SE を演奏
      $game_system.se_play($data_system.cursor_se)
      case @center_window.index
      when 1 # ダッシュ変更の時
        if $game_system.system_dash == false
          $game_system.system_dash = true
        else
          $game_system.system_dash = false
        end
      when 2 # 精の献上イベント
        if $game_system.system_present == false
          $game_system.system_present = true
        else
          $game_system.system_present = false
        end
      when 3 # ポート設定
        if $game_switches[33] == false
          $game_switches[33] = true
        else
          $game_switches[33] = false
        end
      when 4 # 空腹度変更
        $game_system.system_fed += 1
        $game_system.system_fed = 0 if $game_system.system_fed > 2
      when 6 # バトル速度
        $game_system.system_battle_speed += 1
        $game_system.system_battle_speed = 0 if $game_system.system_battle_speed > 2
      when 7 # メッセージモード
        $game_system.system_read_mode += 1
        $game_system.system_read_mode = 0 if $game_system.system_read_mode > 2
      when 8 # レジスト時間
        $game_system.system_regist += 1
        $game_system.system_regist = 0 if $game_system.system_regist > 3
      when 9 # 精液グラフィック
        if $game_system.system_sperm == false
          $game_system.system_sperm = true
        else
          $game_system.system_sperm = false
        end
      when 10 # カーソル位置記憶
        if $game_system.system_arrow == false
          $game_system.system_arrow = true
        else
          $game_system.system_arrow = false
        end
      when 11 # エロティックメッセージ
        $game_system.system_message += 1
        $game_system.system_message = 0 if $game_system.system_message > 2
        #詳細
        $game_switches[95] = ($game_system.system_message == 2)
        #簡易
        $game_switches[96] = ($game_system.system_message == 0)
#      when 12 # 画面切り替え
#        if $game_system.system_fullscreen == false
#          $game_system.system_fullscreen = true
#          $data_config.setLine(2, "full")
#          $data_config.save()
#          @f_screen2 = 1
#          $full_method = true
#        else
#          $game_system.system_fullscreen = false
#          $data_config.setLine(2, "window")
#          $data_config.save()
#          @f_screen2 = 0
#          $full_method = false
#        end
      end
      @center_window.refresh
      return
    end
    
    # 左 ボタンが押された場合
    if Input.repeat?(Input::LEFT)
      # カーソル SE を演奏
      $game_system.se_play($data_system.cursor_se)
      case @center_window.index
      when 1 # ダッシュ変更の時
        if $game_system.system_dash == false
          $game_system.system_dash = true
        else
          $game_system.system_dash = false
        end
      when 2 # 精の献上イベント
        if $game_system.system_present == false
          $game_system.system_present = true
        else
          $game_system.system_present = false
        end
      when 3 # ポート設定
        if $game_switches[33] == false
          $game_switches[33] = true
        else
          $game_switches[33] = false
        end
      when 4 # 空腹度変更
        $game_system.system_fed -= 1
        $game_system.system_fed = 2 if $game_system.system_fed < 0
      when 6 # バトル速度
        $game_system.system_battle_speed -= 1
        $game_system.system_battle_speed = 2 if $game_system.system_battle_speed < 0
      when 7 # メッセージスピード
        $game_system.system_read_mode -= 1
        $game_system.system_read_mode = 2 if $game_system.system_read_mode < 0
      when 8 # レジスト時間
        $game_system.system_regist -= 1
        $game_system.system_regist = 3 if $game_system.system_regist < 0
      when 9 # 精液グラフィック
        if $game_system.system_sperm == false
          $game_system.system_sperm = true
        else
          $game_system.system_sperm = false
        end
      when 10 # カーソル位置記憶
        if $game_system.system_arrow == false
          $game_system.system_arrow = true
        else
          $game_system.system_arrow = false
        end
      when 11 # エロティックメッセージ
        $game_system.system_message -= 1
        $game_system.system_message = 2 if $game_system.system_message < 0
        #詳細
        $game_switches[95] = ($game_system.system_message == 2)
        #簡易
        $game_switches[96] = ($game_system.system_message == 0)
#      when 12 # 画面切り替え
#        if $game_system.system_fullscreen == false
#          $game_system.system_fullscreen = true
#          $data_config.setLine(2, "full")
#          $data_config.save()
#          @f_screen2 = 1
#          $full_method = true
#          p @f_screen2
#        else
#          $game_system.system_fullscreen = false
#          $data_config.setLine(2, "window")
#          $data_config.save()
#          @f_screen2 = 0
#          $full_method = false
#        end
      end
      @center_window.refresh
      return
    end
    
  end
  #--------------------------------------------------------------------------
  # ● 設定変更
  #--------------------------------------------------------------------------
  def system_change
    
    
  end
end
