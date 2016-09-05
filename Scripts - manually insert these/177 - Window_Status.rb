#==============================================================================
# ■ Window_Status
#------------------------------------------------------------------------------
# 　ステータス画面で表示する、フル仕様のステータスウィンドウです。
#==============================================================================

class Window_Status < Window_Base
  #--------------------------------------------------------------------------
  # ● 公開インスタンス変数
  #--------------------------------------------------------------------------
  attr_accessor   :actor
  attr_accessor   :index
  
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #     actor : アクター
  #--------------------------------------------------------------------------
  def initialize(actor)
    super(50, 40, 540, 360)
    self.contents = Bitmap.new(width - 32, height - 32)
    self.z = 2050
    self.back_opacity = 0
    self.active = false
    @actor = actor
    @index = -2
    refresh
  end
  #--------------------------------------------------------------------------
  # ● リフレッシュ
  #--------------------------------------------------------------------------
  def refresh
    self.contents.clear

    draw_actor_graphic(@actor, 20, 52)

    y_1 = 16
    y_2 = 188
    
    self.contents.draw_text(60, 0, 200, 24, @actor.name)
    self.contents.draw_text(60 + 24, 24, 200, 24, @actor.class_name)
    self.contents.draw_text(0, y_1 + 38, 100, 24, "Lv." + @actor.level.to_s)
    self.contents.draw_text(44, y_1 + 38, 72, 24, "【" + @actor.personality + "】", 1)
    draw_actor_state(@actor, 116, y_1 + 33, 150, 0, 1)
    self.contents.font.color =  normal_color
    self.contents.draw_text(20, y_1 + 92, 64, 24, "EP")
    self.contents.draw_text(20, y_1 + 120, 64, 24, "VP")
    unless @actor == $game_actors[101]
      draw_actor_fed(@actor, 20, y_1 + 148, 160)
    end

    self.contents.font.size = $default_size_mini
    draw_actor_hp(@actor, 20 + 24, y_1 + 84, 150, 1)
    draw_actor_sp(@actor, 20 + 24, y_1 + 112, 150, 1)
    self.contents.draw_text(0, y_1 + 64, 200, 24, "Until Next Level: " + @actor.next_rest_exp_s + " Exp")

    
    self.contents.font.size = $default_size
    draw_actor_parameter(@actor, 0, y_2, 0)
    draw_actor_parameter(@actor, 130, y_2, 1)
    draw_actor_parameter(@actor, 0, y_2 + 24, 3)
    draw_actor_parameter(@actor, 130, y_2 + 24, 4)
    draw_actor_parameter(@actor, 0, y_2 + 48, 5)
    draw_actor_parameter(@actor, 130, y_2 + 48, 6)
    

    x_1 = 274
    
    unless @actor == $game_actors[101]
      self.contents.font.color = system_color
      self.contents.draw_text(x_1 - 5, 168, 90, 24, "Appetite")
      self.contents.draw_text(x_1 + 78, 168, 96, 24, "Dream Power ")
      self.contents.draw_text(x_1 - 5, 192, 84, 24, "Favorability")
      self.contents.draw_text(x_1 - 5, 216, 105, 24, "Contract Beads")
      self.contents.draw_text(x_1 - 5, 240, 124, 24, "Energy Consumed")
      self.contents.font.color = normal_color
      self.contents.draw_text(x_1 + 24, 168, 48, 24, @actor.digest.to_s, 2)
      self.contents.draw_text(x_1 + 136, 168, 48, 24, @actor.d_power.to_s, 2)
      self.contents.draw_text(x_1 + 136, 192, 48, 24, @actor.love.to_s, 2)
      self.contents.draw_text(x_1 + 36, 216, 48 + 100, 24, @actor.promise.to_s, 2)
      self.contents.draw_text(x_1 + 136, 240, 48, 24, @actor.absorb.to_s, 2)
    end
    
    self.contents.font.color = system_color
    self.contents.draw_text(x_1 - 5, 0, 92, 32, "Accessories ")
    self.contents.font.color = normal_color
    
    equip = $data_armors[@actor.armor1_id]
    if equip != nil
      bitmap = RPG::Cache.icon($data_armors[@actor.armor1_id].icon_name)
      self.contents.blt(x_1 + 20, 20 + 4, bitmap, Rect.new(0, 0, 24, 24))
      self.contents.draw_text(x_1 + 50, 20, 150, 32, $data_armors[@actor.armor1_id].name)
    else
      self.contents.draw_text(x_1 + 25, 20, 150, 32, "---------------")
    end
  
    self.contents.font.color = system_color
    self.contents.draw_text(x_1 - 5, 44, 96, 32, "Runes Branded")
    self.contents.font.color = normal_color
    
    rune_y = 64
    for i in 1..$data_SDB[@actor.class_id].maxrune
      if @actor.armor_id[i + 1] != 0
        bitmap = RPG::Cache.icon($data_armors[@actor.armor_id[i + 1]].icon_name)
        self.contents.blt(x_1 + 20, rune_y + 4, bitmap, Rect.new(0, 0, 24, 24))
        self.contents.draw_text(x_1 + 50, rune_y, 150, 32, $data_armors[@actor.armor_id[i + 1]].name)
      else
        self.contents.draw_text(x_1 + 25, rune_y, 150, 32, "---------------")
      end
      rune_y += 24
    end
    
    
    rune_y = 64
    rune_y_a = 24
    case @index
    when -2 # 非選択
      y = -100
    when 0 # 装備品
      y = 20 + 4
    when 1 # 以下ルーン
      y = rune_y + (rune_y_a * 0) + 4
    when 2
      y = rune_y + (rune_y_a * 1) + 4
    when 3
      y = rune_y + (rune_y_a * 2) + 4
    when 4
      y = rune_y + (rune_y_a * 3) + 4
    when 5
      y = rune_y + (rune_y_a * 4) + 4
    end
    self.cursor_rect.set(292, y, 170, 24)

  end
  
  def dummy
    self.contents.font.color = system_color
    self.contents.draw_text(320, 112, 96, 32, $data_system.words.weapon)
    self.contents.draw_text(320, 176, 96, 32, $data_system.words.armor1)
    self.contents.draw_text(320, 240, 96, 32, $data_system.words.armor2)
    self.contents.draw_text(320, 304, 96, 32, $data_system.words.armor3)
    self.contents.draw_text(320, 368, 96, 32, $data_system.words.armor4)
    draw_item_name($data_weapons[@actor.weapon_id], 320 + 24, 144)
    draw_item_name($data_armors[@actor.armor1_id], 320 + 24, 208)
    draw_item_name($data_armors[@actor.armor2_id], 320 + 24, 272)
    draw_item_name($data_armors[@actor.armor3_id], 320 + 24, 336)
    draw_item_name($data_armors[@actor.armor4_id], 320 + 24, 400)
  end
  #--------------------------------------------------------------------------
  # ● ヘルプウィンドウの設定
  #     help_window : 新しいヘルプウィンドウ
  #--------------------------------------------------------------------------
  def help_window=(help_window)
    @help_window = help_window
    # ヘルプテキストを更新 (update_help は継承先で定義される)
    if self.active and @help_window != nil
      update_help
    end
  end
  #--------------------------------------------------------------------------
  # ● ヘルプテキスト更新
  #--------------------------------------------------------------------------
  def update_help
    equip = $data_armors[@actor.armor_id[@index + 1]]
    @help_window.set_text(equip == nil ? "" : equip.description)
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新
  #--------------------------------------------------------------------------
  def update
    super
    # ヘルプテキストを更新 (update_help は継承先で定義される)
    if self.active and @help_window != nil
      update_help
    end
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新
  #--------------------------------------------------------------------------
  def item
    return $data_armors[@actor.armor_id[@index + 1]]
  end
end
