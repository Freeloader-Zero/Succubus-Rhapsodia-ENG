#==============================================================================
# ■ Scene_Menu
#------------------------------------------------------------------------------
# 　メニュー画面の処理を行うクラスです。
#==============================================================================

class Scene_Menu
  #--------------------------------------------------------------------------
  # ● フレーム更新（アイテム）
  #--------------------------------------------------------------------------
  def update_item
    # ウィンドウを更新
    @help_window.update
    @item_window.update
    @target_window.update
    # アイテムウィンドウがアクティブの場合: update_item を呼ぶ
    if @item_window.active
      update_item_active
      return
    end
    # ターゲットウィンドウがアクティブの場合: update_target を呼ぶ
    if @target_window.active
      update_target_active
      return
    end
        
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新 (アイテムウィンドウがアクティブの場合)
  #--------------------------------------------------------------------------
  def update_item_active

    # B ボタンが押された場合
    if Input.trigger?(Input::B)
      # キャンセル SE を演奏
      $game_system.se_play($data_system.cancel_se)
      # 上部テキストを戻す
      @overF_text = $game_party.gold.to_s + "　" + $data_system.words.gold
      @help_window.visible = false
      @help_window.window.visible = false
      @item_window.visible = false
      @window[0].visible = false
      @target_window.visible = false
      # メニューに戻る
      @command = 0
      @fade_flag = 5
      return
    end

    # C ボタンが押された場合
    if Input.trigger?(Input::C)
      # アイテムウィンドウで現在選択されているデータを取得
      @item = @item_window.item
      # 使用アイテムではない場合
      unless @item.is_a?(RPG::Item)
        # ブザー SE を演奏
        $game_system.se_play($data_system.buzzer_se)
        return
      end
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
      # 効果範囲が味方の場合
      if @item.scope >= 3
        # ターゲットウィンドウをアクティブ化
        @item_window.visible = false
        @item_window.active = false
        @target_window.y = 40
        @target_window.visible = true
        @target_window.active = true
        @target_window.icon = @item.icon_name
        @target_window.name = @item.name
        @target_window.refresh

        # 効果範囲 (単体/全体) に応じてカーソル位置を設定
        if @item.scope == 4 || @item.scope == 6
          @target_window.index = -1
        else
          @target_window.index = 0
        end
      # 効果範囲が味方以外の場合
      else
        # コモンイベント ID が有効の場合
        if @item.common_event_id > 0
          # コモンイベント呼び出し予約
          $game_temp.common_event_id = @item.common_event_id
          # アイテムの使用時 SE を演奏
          $game_system.se_play(@item.menu_se)
          # 消耗品の場合
          if @item.consumable
            # 使用したアイテムを 1 減らす
            $game_party.lose_item(@item.id, 1)
            # アイテムウィンドウの項目を再描画
            @item_window.draw_item(@item_window.index)
          end
          @item_window.visible = false
          # マップ画面に切り替え
          @fade_flag = 6
          return
        end
      end
      return
    end
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新 (ターゲットウィンドウがアクティブの場合)
  #--------------------------------------------------------------------------
  def update_target_active
    # B ボタンが押された場合
    if Input.trigger?(Input::B)
      # キャンセル SE を演奏
      $game_system.se_play($data_system.cancel_se)
      # アイテム切れなどで使用できなくなった場合
      unless $game_party.item_can_use?(@item.id)
        # アイテムウィンドウの内容を再作成
        @item_window.refresh
      end
      # ターゲットウィンドウを消去
      @item_window.active = true
      @item_window.visible = true
      @target_window.visible = false
      @target_window.active = false
      return
    end
    # C ボタンが押された場合
    if Input.trigger?(Input::C)
      # アイテムを使い切った場合
      if $game_party.item_number(@item.id) == 0
        # ブザー SE を演奏
        $game_system.se_play($data_system.buzzer_se)
        return
      end
      # 夢魔用食物の場合
      if $data_items[@item.id].element_set.include?(127)
        # ターゲット取得
        target = $game_party.actors[@target_window.index]
        # 対象が主人公の場合は使用不可
        if target == $game_actors[101]
          $game_temp.error_message = "#{$game_actors[101].name} cannot use this item."
          # ブザー SE を演奏
          $game_system.se_play($data_system.buzzer_se)
          # ●エラーメッセージを表示
          $game_temp.message_text = $game_temp.error_message if $game_temp.error_message != ""
          $game_temp.error_message = ""
          return
        elsif target.fed == 100
          $game_temp.error_message = "#{target.name} cannot use this item on a full stomach."
          # ブザー SE を演奏
          $game_system.se_play($data_system.buzzer_se)
          # ●エラーメッセージを表示
          $game_temp.message_text = $game_temp.error_message if $game_temp.error_message != ""
          $game_temp.error_message = ""
          return
        end
      end
      # レベルアップアイテムの場合
      if $data_items[@item.id].element_set.include?(201)
        # ターゲット取得
        target = $game_party.actors[@target_window.index]
        # レベルが最大だと使用不可
        if target.level >= $MAX_LEVEL
          $game_temp.error_message = "#{target.name} cannot level any further."
          # ブザー SE を演奏
          $game_system.se_play($data_system.buzzer_se)
          # ●エラーメッセージを表示
          $game_temp.message_text = $game_temp.error_message if $game_temp.error_message != ""
          $game_temp.error_message = ""
          return
        end
      end
      # ターゲットが全体の場合
      if @target_window.index == -1
        # パーティ全体にアイテムの使用効果を適用
        used = false
        for i in $game_party.actors
          used |= i.item_effect(@item)
        end
      end
      # ターゲットが単体の場合
      if @target_window.index >= 0
        # ターゲットのアクターにアイテムの使用効果を適用
        target = $game_party.party_actors[@target_window.index]
        used = target.item_effect(@item)
      end
      # アイテムを使った場合
      if used
        # アイテムの使用時 SE を演奏
        $game_system.se_play(@item.menu_se)
        # 消耗品の場合
        if @item.consumable
          # 使用したアイテムを 1 減らす
          $game_party.lose_item(@item.id, 1)
          # アイテムウィンドウの項目を再描画
          @item_window.draw_item(@item_window.index)
        end
        # ターゲットウィンドウの内容を再作成
        @target_window.refresh
        center_refresh
        # 全滅の場合
        if $game_party.all_dead?
          # ゲームオーバー画面に切り替え
          $scene = Scene_Gameover.new
          return
        end
        # コモンイベント ID が有効の場合
        if @item.common_event_id > 0
          # コモンイベント呼び出し予約
          $game_temp.common_event_id = @item.common_event_id
          @item_window.visible = false
          # マップ画面に切り替え
          @fade_flag = 6
          return
        end
      end
      # アイテムを使わなかった場合
      unless used
        # ブザー SE を演奏
        $game_system.se_play($data_system.buzzer_se)
      end
      return
    end
  end
end