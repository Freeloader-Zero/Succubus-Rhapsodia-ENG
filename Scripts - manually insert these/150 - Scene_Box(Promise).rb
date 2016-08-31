#==============================================================================
# ■ Scene_Menu
#------------------------------------------------------------------------------
# 　メニュー画面の処理を行うクラスです。
#==============================================================================

class Scene_Box
  
  #--------------------------------------------------------------------------
  # ● 名称変更
  #--------------------------------------------------------------------------
  def update_petname
    # ウィンドウを更新
    @petname_window.update
    # C ボタンが押された場合
    if Input.trigger?(Input::C)
      @bonus = @petname_window.petname
      # 確認の場合は何もしない
      if @bonus[1] == @petname_window.check_text
        # ブザー SE を演奏
        $game_system.se_play($data_system.buzzer_se)
        return
      end
      # 習得できない場合
      unless @petname_window.can_get_petname?
        # ブザー SE を演奏
        $game_system.se_play($data_system.buzzer_se)
        $game_temp.message_text = $game_temp.error_message
        return
      end
      @petname_window.input_petname = nil
      if @bonus[1] == @petname_window.input_text
        # 名前を一時記憶
        temp_name = @now_actor.nickname_master
        # 名前入力画面に以降
        Graphics.freeze
        $game_actors[120].name = @now_actor.defaultname_hero
        $game_temp.name_actor_id = 120
        $game_temp.name_max_char = 12
        $scene1 = Scene_Name.new(1)
        $scene1.main
        Graphics.transition(8)
        # 前と同じ愛称だった場合、返す
        if $game_actors[120].name == @now_actor.nickname_master
          return
        end
        @petname_window.input_petname = $game_actors[120].name
      end
      text = "#{@now_actor.name}からの呼び方を、「#{@bonus[1]}」に"
      text += "\n変えてもらいますか？（契約の珠を#{@bonus[0]}消費します）"
      if @bonus[1] == @petname_window.default_text
        text = "#{@now_actor.name}からの呼び方を、「#{@now_actor.defaultname_hero}」に"
        text += "\n戻してもらいますか？（契約の珠を#{@bonus[0]}消費します）"
      end
      if @bonus[1] == @petname_window.input_text
        text = "#{@now_actor.name}からの呼び方を、「#{@petname_window.input_petname}」に"
        text += "\n変えてもらいますか？（契約の珠を#{@bonus[0]}消費します）"
      end
      text += "\nいいえ\nはい"
      $game_temp.choice_start = 2
      # 決定 SE を演奏
      $game_system.se_play($data_system.decision_se) 
      $game_temp.message_text = text
      $game_temp.choice_max = 2
      $game_temp.choice_cancel_type = 1
      # メッセージ表示中フラグを立てる
      $game_temp.message_window_showing = true
      $game_temp.script_message = true
      @select_type = "ボーナス・呼び方変更"
    end
    # B ボタンが押された場合
    if Input.trigger?(Input::B)
      # キャンセル SE を演奏
      $game_system.se_play($data_system.cancel_se)
      @petname_window.dispose
      @center_window.active = true
      @center_window.visible = true
      @petname_flag = false
    end
  end
  #--------------------------------------------------------------------------
  # ● ボーナス習得
  #--------------------------------------------------------------------------
  def update_promise
    
    if @petname_flag
      update_petname
      return
    end
    
    
    @center_window.update
    
    # C ボタンが押された場合
    if Input.trigger?(Input::C)
      @bonus = @center_window.bonus
      
      # 習得できない場合
      unless @center_window.can_get_bonus?
        # ブザー SE を演奏
        $game_system.se_play($data_system.buzzer_se)
        $game_temp.message_text = $game_temp.error_message
        return
      end
      
      case @bonus[1]
      when 0 # スキルの場合
        text = "#{@now_actor.name} can learn 「#{$data_skills[@bonus[2]].name}」."
        text += "\nLearn Skill? (Will consume #{@bonus[0]} Contract Beads!)"
        text += "\nNo\nYes"
        $game_temp.choice_start = 2
        # 決定 SE を演奏
        $game_system.se_play($data_system.decision_se) 
        $game_temp.message_text = text
        $game_temp.choice_max = 2
        $game_temp.choice_cancel_type = 1
        # メッセージ表示中フラグを立てる
        $game_temp.message_window_showing = true
        $game_temp.script_message = true
        @select_type = "ボーナス・スキル"

        
      when 1 # 素質の場合
        text = "#{@now_actor.name} can acquire 【#{$data_ability[@bonus[2]].name}】."
        text += "\nAcquire trait? (Will consume #{@bonus[0]} Contract Beads!)"
        text += "\nNo\nYes"
        $game_temp.choice_start = 2
        # 決定 SE を演奏
        $game_system.se_play($data_system.decision_se) 
        $game_temp.message_text = text
        $game_temp.choice_max = 2
        $game_temp.choice_cancel_type = 1
        # メッセージ表示中フラグを立てる
        $game_temp.message_window_showing = true
        $game_temp.script_message = true
        @select_type = "ボーナス・素質"
        
      when 2 # ルーンの場合
        
        
      when 3 # その他の場合
        # 決定 SE を演奏
        $game_system.se_play($data_system.decision_se)
        case @bonus[2]
        when 0 # 名前を変える
          # 名前を一時記憶
          temp_name = @now_actor.name.dup
          # 名前入力画面に以降
          Graphics.freeze
          $game_temp.name_actor_id = @now_actor.id
          $game_temp.name_max_char = 9
          $scene1 = Scene_Name.new(1)
          $scene1.main
          # 前と違う名前だった場合、契約の珠を消費
          if @now_actor.name != temp_name
            @now_actor.promise -= @bonus[0]
          end
          @promise_left_window.refresh
          Graphics.transition(8)
        when 1 # レベルを上げる
          text = "Level up #{@now_actor.name}?"
          text += "\n(Will consume #{@bonus[0]} Contract Beads)"
          text += "\nYes\nNo"
          $game_temp.choice_start = 2
          # 決定 SE を演奏
          $game_system.se_play($data_system.decision_se) 
          $game_temp.message_text = text
          $game_temp.choice_max = 2
          $game_temp.choice_cancel_type = 1
          # メッセージ表示中フラグを立てる
          $game_temp.message_window_showing = true
          $game_temp.script_message = true
          @select_type = "ボーナス・レベルアップ"
        when 2 # 呼び名を変える
          # 決定 SE を演奏
          $game_system.se_play($data_system.decision_se) 
          @center_window.active = false
          @center_window.visible = false
          @petname_window = Window_Petname_Change.new(@now_actor)
          @petname_window.help_window = @help_window
          @petname_flag = true
          return
        when 3 # 金を採取する
          text = "Can extract 3000Lps. from #{@now_actor.name}. Extract?"
          text += "\n（Will consume #{@bonus[0]} Contract Beads)"
          text += "\nYes\nNo"
          $game_temp.choice_start = 2
          # 決定 SE を演奏
          $game_system.se_play($data_system.decision_se) 
          $game_temp.message_text = text
          $game_temp.choice_max = 2
          $game_temp.choice_cancel_type = 1
          # メッセージ表示中フラグを立てる
          $game_temp.message_window_showing = true
          $game_temp.script_message = true
          @select_type = "ボーナス・金を作る"
        end
      end
      @center_window.refresh
      @promise_left_window.refresh
      return
        
    end
    
    # B ボタンが押された場合
    if Input.trigger?(Input::B)
      # キャンセル SE を演奏
      $game_system.se_play($data_system.cancel_se)
      # アクティブを終了
      @fade_flag = 4
      @window[2].visible = false
      @help_window.visible = false
      @help_window.window.visible = false

      @center_window.dispose
      @promise_left_window.dispose

      @promise_flag = false
      if @left_window.mode == 0
        @overF_text = "H o m e"
      else
        @overF_text = "P a r t y"
      end
      refresh
    end
  end
end