#==============================================================================
# ■ Window_Status
#------------------------------------------------------------------------------
# 　ステータス画面で表示する、フル仕様のステータスウィンドウです。
#==============================================================================

class Window_PromiseLeft < Window_Base
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
    super(40, 36, 600, 370)
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
    y_2 = 136
    
    self.contents.draw_text(50, 0, 200, 24, @actor.name)
    self.contents.draw_text(50 + 24, 24, 200, 24, @actor.class_name)
    self.contents.draw_text(0, y_1 + 38, 100, 24, "Lv." + @actor.level.to_s)
    self.contents.draw_text(44, y_1 + 38, 72, 24, "【" + @actor.personality + "】", 1)
    draw_actor_state(@actor, 116, y_1 + 33, 150)
    self.contents.font.color =  normal_color
    self.contents.draw_text(20, y_1 + 64, 64, 24, "EP")
    self.contents.draw_text(20, y_1 + 92, 64, 24, "VP")

    self.contents.font.size = $default_size_mini
    draw_actor_hp(@actor, 20 + 24, y_1 + 56, 150)
    draw_actor_sp(@actor, 20 + 24, y_1 + 84, 150)

    self.contents.font.size = $default_size
    draw_actor_parameter(@actor, 0, y_2, 0)
    draw_actor_parameter(@actor, 106, y_2, 1)
    draw_actor_parameter(@actor, 0, y_2 + 24, 3)
    draw_actor_parameter(@actor, 106, y_2 + 24, 4)
    draw_actor_parameter(@actor, 0, y_2 + 48, 5)
    draw_actor_parameter(@actor, 106, y_2 + 48, 6)
    
    
    x_1 = 0
    y_2 += 10
    unless @actor == $game_actors[101]
      self.contents.font.color = system_color
      self.contents.draw_text(x_1, y_2 + 72, 84, 24, "好感度")
      self.contents.draw_text(x_1 + 98, y_2 + 72, 84, 24, "夢の魔力")
      self.contents.draw_text(x_1, y_2 + 96, 84, 24, "空腹率")
      self.contents.draw_text(x_1 + 98, y_2 + 96, 84, 24, "吸精量")
      self.contents.draw_text(264, 10, 84, 24, "契約の珠")
      self.contents.font.color = normal_color
      self.contents.draw_text(x_1 + 32, y_2 + 72, 48, 24, @actor.love.to_s, 2)
      self.contents.draw_text(x_1 + 144, y_2 + 72, 48, 24, @actor.d_power.to_s, 2)
      self.contents.draw_text(x_1 + 32, y_2 + 96, 48, 24, @actor.digest.to_s, 2)
      self.contents.draw_text(x_1 + 144, y_2 + 96, 48, 24, @actor.absorb.to_s, 2)
      self.contents.draw_text(446 - 100, 10, 84 + 100, 24, @actor.promise.to_s, 2)
    end
    
    
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
