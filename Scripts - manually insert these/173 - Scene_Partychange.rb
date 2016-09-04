#==============================================================================
# ■ Scene_PartyForm
#------------------------------------------------------------------------------
# 　パーティ編成を行うクラスです。
#==============================================================================

class Scene_Partychange
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #     call_scene  : 呼び出し元 (0..メニュー  1..マップ  2..戦闘)
  #     menu_index  : メニューコマンドINDEX
  #     can_discont : 中断可能
  #     min_members : 最低人数
  #--------------------------------------------------------------------------
  def initialize(call_scene = 0, now_index = 0)
    @call_scene = call_scene
    @now_index = now_index
  end
  #--------------------------------------------------------------------------
  # ● メイン処理
  #--------------------------------------------------------------------------
  def main
    
    
    @status_command = 0
    
    # 中央
    @back = Sprite.new
    @back.bitmap = RPG::Cache.windowskin("default_back")
    @back.bitmap = RPG::Cache.windowskin("default_back_2") if $PRODUCT_VERSION
    @back.visible = true
    @back.z = 5000
    # ウィンドウ
    @window = Sprite.new
    @window.bitmap = RPG::Cache.windowskin("menu_windowL")
    @window.y = 40
    @window.z = 5020
    @window.opacity = 200
    @window.visible = true
    # 中央ウィンドウ
    @center_window = Window_Status.new($game_party.party_actors[@now_index])
    @center_window.z = 5100
    @center_window1 = Window_SkillStatus.new($game_party.party_actors[@now_index])
    @center_window1.z= 5100
    @center_window1.visible = false
    # ヘルプウィンドウ
    @help_window = Window_Help.new
    @help_window.visible = true
    @help_window.z = 5020
    @help_window.window.z = 5015
    @help_window.window.visible = true
    @help_window.y = 340
    @help_window.window.y = 340
    
    # アクターグラフィック
    @actor_graphic = Sprite.new
    @actor_graphic.x = 320
    @actor_graphic.y = 240
    @actor_graphic.z = 5010
    
    refresh
    
    
    # トランジション実行
    Graphics.transition(8)
    # メインループ
    loop {
      # ゲーム画面を更新
      Graphics.update
      # 入力情報を更新
      Input.update
      # フレーム更新
      update
      # シーン終了判定
      break if scene_end?
    }
    # トランジション準備
    Graphics.freeze
    # ウィンドウを解放
    
    @actor_graphic.dispose
    @center_window.dispose
    @center_window1.dispose
    @back.dispose
    @window.dispose
    @help_window.dispose
  end
  #--------------------------------------------------------------------------
  # ● リフレッシュ
  #--------------------------------------------------------------------------
  def refresh
    actor = $game_party.party_actors[@now_index]
        
    @actor_graphic.bitmap = RPG::Cache.battler(actor.battler_name, actor.battler_hue)
    @actor_graphic.x = 320
    @actor_graphic.y = 240
    @actor_graphic.y += 60 if actor.boss_graphic?
    @actor_graphic.ox = @actor_graphic.bitmap.width / 2
    @actor_graphic.oy = @actor_graphic.bitmap.height / 2
    @center_window1.actor = @center_window.actor = actor
    @center_window.refresh
    @center_window1.refresh
    
    case @status_command
    when 0
      text = "←→：表示メンバー変更　↑↓：ウィンドウ変更"
    when 1
      text = "決定：スキル確認　←→：表示メンバー変更　↑↓：ウィンドウ変更"
    when 2
      text = "決定：素質確認　←→：表示メンバー変更　↑↓：ウィンドウ変更"
    end
    @help_window.set_text(text, 1)
    
  end
  #--------------------------------------------------------------------------
  # ● シーン終了判定
  #--------------------------------------------------------------------------
  def scene_end?
    if @call_scene == 2
      return @return_flag
    else
      return $scene != self
    end
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新
  #--------------------------------------------------------------------------
  def update
    
    if @center_window.active
      update_center_active
      return
    end
    
    case @status_command
    when 0
      update_status
    when 1
      update_skill
    when 2
      update_ability
    end
        
    # 右 ボタンが押された場合
    if Input.repeat?(Input::RIGHT)
      # カーソル SE を演奏
      @now_index += 1
      @now_index = 0 if @now_index >= $game_party.party_actors.size
      $game_system.se_play($data_system.cursor_se)
      refresh
      return
    end
    
    # 左 ボタンが押された場合
    if Input.repeat?(Input::LEFT)
      # カーソル SE を演奏
      @now_index -= 1
      @now_index = $game_party.party_actors.size - 1 if @now_index < 0
      $game_system.se_play($data_system.cursor_se)
      refresh
      return
    end
    
    
  end
  #--------------------------------------------------------------------------
  # ● 元の画面に戻す
  #--------------------------------------------------------------------------
  def return_scene
    case @call_scene
    when 0
      # メニュー画面に戻す
      if $imported["MenuAlter"]
        index = KGC::MA_COMMANDS.index(7)
        if index != nil
          $scene = Scene_Menu.new(index)
        else
          $scene = Scene_Menu.new
        end
      else
        $scene = Scene_Menu.new(@menu_index)
      end
    when 1
      # マップ画面に戻す
      $scene = Scene_Map.new
    when 2
      @return_flag  = true
    end
  end
end