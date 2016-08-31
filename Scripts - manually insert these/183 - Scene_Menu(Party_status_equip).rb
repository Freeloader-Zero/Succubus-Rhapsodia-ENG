#==============================================================================
# ■ Scene_Menu
#------------------------------------------------------------------------------
# 　メニュー画面の処理を行うクラスです。
#==============================================================================

class Scene_Menu
  #--------------------------------------------------------------------------
  # ● フレーム更新 : 現在装備欄
  #--------------------------------------------------------------------------
  def update_equip
    
    
    equip_refresh
    @equip_left_window.update
    @equip_item_window.update
    

    # 装備画面中の場合はそちらのフレーム更新を行う
    if @equip_time == 2
      update_equip_time
      return
    end
    
    # B ボタンが押された場合
    if Input.trigger?(Input::B)
      # キャンセル SE を演奏
      $game_system.se_play($data_system.cancel_se)
      # SE を演奏
      Audio.se_play("Audio/SE/005-System05", 80, 100)
      @center_window.active = false
      @equip_fade_flag = 2
      @window[1].visible = true
      @center_window.index = -2
      @center_window.help_window = nil
      text = "ENTER: Examine Equipment/Runes　←→：Cycle Party Member　↑↓：Change Window"
      @help_window.set_text(text, 1)
      @center_window.refresh
      @overF_text = "S t a t u s"
      return
    end
    
    # C ボタンが押された場合
    if Input.trigger?(Input::C)
      # 決定 SE を演奏
      $game_system.se_play($data_system.decision_se)
      @equip_time = 2
      @center_window.active = false
      @equip_item_window.index = 0
      @equip_item_window.active = true
      return
    end
    
    
    # 下 ボタンが押された場合
    if Input.repeat?(Input::DOWN)
      # カーソル SE を演奏
      $game_system.se_play($data_system.cursor_se)
      @center_window.index += 1
      if @center_window.index > $data_SDB[$game_party.actors[@select_index].class_id].maxrune
        @center_window.index = 0
      end
      @center_window.refresh
      return
    end
    # 下 ボタンが押された場合
    if Input.repeat?(Input::UP)
      # カーソル SE を演奏
      $game_system.se_play($data_system.cursor_se)
      @center_window.index -= 1
      if @center_window.index < 0
        @center_window.index = $data_SDB[$game_party.actors[@select_index].class_id].maxrune
      end
      @center_window.refresh
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
      actor = $game_party.actors[@select_index]
      @center_window.actor = actor
      @center_window.index = 0
      @center_window.refresh
      
      actor = $game_party.actors[@select_index]
      @equip_left_window.actor = actor
      @equip_item_window1.actor = actor
      @equip_item_window2.actor = actor
      @equip_left_window.refresh
      @equip_item_window1.refresh
      @equip_item_window2.refresh

      @actor_graphic.x = 320
      @actor_graphic.y = 240
      @actor_graphic.y += 60 if actor.boss_graphic?
      @actor_graphic.bitmap = RPG::Cache.battler(actor.battler_name, actor.battler_hue)
      @actor_graphic.ox = @actor_graphic.bitmap.width / 2
      @actor_graphic.oy = @actor_graphic.bitmap.height / 2
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
      
      actor = $game_party.actors[@select_index]
      @equip_left_window.actor = actor
      @equip_item_window1.actor = actor
      @equip_item_window2.actor = actor
      @equip_left_window.refresh
      @equip_item_window1.refresh
      @equip_item_window2.refresh

      @actor_graphic.x = 320
      @actor_graphic.y = 240
      @actor_graphic.y += 60 if actor.boss_graphic?
      @actor_graphic.bitmap = RPG::Cache.battler(actor.battler_name, actor.battler_hue)
      @actor_graphic.ox = @actor_graphic.bitmap.width / 2
      @actor_graphic.oy = @actor_graphic.bitmap.height / 2
    end
  end

  #--------------------------------------------------------------------------
  # ● 装備変更中：アイテム欄　
  #--------------------------------------------------------------------------
  def update_equip_time
    
    # コマンド開始
    if $game_temp.script_message_index != 99
      # ルーンの刻印をしてもいいですか？
      case $game_temp.script_message_index
      when 0 # いいえ
        if $game_temp.script_message_cancel == false
          $game_system.se_play($data_system.decision_se) 
        end
      when 1 # はい
        item = @equip_item_window.item
        # SE を演奏
        Audio.se_play("Audio/SE/046-Book01", 80, 100)
        # 装備を変更
        $game_party.actors[@select_index].equip(@center_window.index + 1, item == nil ? 0 : item.id, 1)
        # ライトウィンドウをアクティブ化
        @center_window.active = true
        @equip_item_window.active = false
        @equip_item_window.index = -1
        # ライトウィンドウ、アイテムウィンドウの内容を再作成
        @center_window.refresh
        @equip_item_window.refresh
        @equip_time = 1
      end
      $game_temp.script_message_index = 99
      return
    end

    
    # C ボタンが押された場合
    if Input.trigger?(Input::C)

      # アイテムウィンドウで現在選択されているデータを取得
      item = @equip_item_window.item
      
      if item == nil and $game_party.actors[@select_index].armor_id[@center_window.index + 1] == 0
        # ブザー SE を演奏
        $game_system.se_play($data_system.buzzer_se)
        return
      end

      if @center_window.index != 0
        if item != nil
          text = "ルーンは一度刻印していまうと再利用する事ができません。\n刻印しますか？"
          text += "\nやめる\n刻印する"
          $game_temp.choice_start = 2
        else
          text = "刻印しているルーンを破棄してしまいますか？"
          text += "\nやめる\n破棄する"
          $game_temp.choice_start = 1
        end
        # 決定 SE を演奏
        $game_system.se_play($data_system.decision_se) 
        $game_temp.message_text = text
        $game_temp.choice_max = 2
        $game_temp.choice_cancel_type = 1
        # メッセージ表示中フラグを立てる
        $game_temp.message_window_showing = true
        $game_temp.script_message = true
        return
      end
      
      # 装備 SE を演奏
      $game_system.se_play($data_system.equip_se)
      # 装備を変更
      $game_party.actors[@select_index].equip(@center_window.index + 1, item == nil ? 0 : item.id)
      # ライトウィンドウをアクティブ化
      @center_window.active = true
      @equip_item_window.active = false
      @equip_item_window.index = -1
      # ライトウィンドウ、アイテムウィンドウの内容を再作成
      @center_window.refresh
      @equip_item_window.refresh
      @equip_time = 1
      return
    end

    # B ボタンが押された場合
    if Input.trigger?(Input::B)
      # キャンセル SE を演奏
      $game_system.se_play($data_system.cancel_se)
      @equip_time = 1
      @center_window.active = true
      @equip_item_window.active = false
      @equip_item_window.index = -1

      return
    end
  end

  #--------------------------------------------------------------------------
  # ● 装備変更中：アイテム欄　
  #--------------------------------------------------------------------------
  def equip_refresh
    
    actor = $game_party.actors[@select_index]

    # アイテムウィンドウの可視状態設定
    @equip_item_window1.visible = (@center_window.index == 0)
    @equip_item_window2.visible = (@center_window.index != 0)

    # 現在装備中のアイテムを取得
    item1 = @center_window.item
    
    # 現在のアイテムウィンドウを @equip_item_window に設定
    if @center_window.index == 0
      @equip_item_window = @equip_item_window1
    else
      @equip_item_window = @equip_item_window2
    end
    # ライトウィンドウがアクティブの場合
    if @center_window.active
      # 装備変更後のパラメータを消去
      @equip_left_window.set_new_parameters(nil, nil, nil)
    end
    # アイテムウィンドウがアクティブの場合
    if @equip_item_window.active
      # 現在選択中のアイテムを取得
      item2 = @equip_item_window.item
      # 装備を変更
      last_hp = actor.hp
      last_sp = actor.sp
      actor.equip(@center_window.index + 1, item2 == nil ? 0 : item2.id)
      if $imported["EquipExtension"]
        for i in (actor.two_swords? ? actor.ts_number : 1)...actor.equip_type.size
          actor.update_auto_state(nil, $data_armors[actor.armor_id[i]])
        end
      else
        for i in 1..4
          actor.update_auto_state(nil, $data_armors[eval("actor.armor#{i}_id")])
        end
      end      # 装備変更後のパラメータを取得
      new_atk = actor.atk
      new_pdef = actor.pdef
      new_mdef = actor.mdef
      if $imported["EquipAlter"]
        new_st = [actor.str, actor.dex, actor.agi, actor.int]
      end

      # 装備を戻す
      actor.equip(@center_window.index + 1, item1 == nil ? 0 : item1.id)
      actor.hp = last_hp
      actor.sp = last_sp
      # レフトウィンドウに描画
      if $imported["EquipAlter"]
        @equip_left_window.set_new_parameters(new_atk, new_pdef, new_mdef, new_st)
      else
        @equip_left_window.set_new_parameters(new_atk, new_pdef, new_mdef)
      end
    end
  end
  #--------------------------------------------------------------------------
  # ● 装備画面用フェード
  #--------------------------------------------------------------------------
  def equip_fade
    
    n = 10
    case @equip_fade_flag
    when 1 #出現
      @window[0].x -= 400 / n
      @center_window.x -= 320 / n
      @window[1].x -= 400 / n
      @equip_left_window.x -= 400 / n
      @equip_item_window1.x -= 400 / n
      @equip_item_window2.x -= 400 / n
      # すべて完了したらフェードを終了する。
      if @window[0].x == -400
        @equip_fade_flag = 0
        @equip_time = 1
      end
      return
    when 2 #消去    
      @window[0].x += 400 / n
      @center_window.x += 320 / n
      @window[1].x += 400 / n
      @equip_left_window.x += 400 / n
      @equip_item_window1.x += 400 / n
      @equip_item_window2.x += 400 / n
      # すべて完了したらフェードを終了する。
      if @window[0].x == 0
        @equip_fade_flag = 0
        @window[1].visible = false
        @equip_time = 0
        @equip_left_window.dispose
        @equip_item_window1.dispose
        @equip_item_window2.dispose
      end
      return
    end
   
  end
  
end