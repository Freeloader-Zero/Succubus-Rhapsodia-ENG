#==============================================================================
# ■ Window_Status
#------------------------------------------------------------------------------
# 　ステータス画面で表示する、フル仕様のステータスウィンドウです。
#==============================================================================

class Window_MenuStatus < Window_Base
  #--------------------------------------------------------------------------
  # ● 公開インスタンス変数
  #--------------------------------------------------------------------------
  attr_accessor   :blink
  attr_accessor   :actor
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #     actor : アクター
  #--------------------------------------------------------------------------
  def initialize(x, y, actor, type)
    super(x - 16, y, 342, 212)
    self.contents = Bitmap.new(width - 32, height - 32)
    self.z = 2050
    self.back_opacity = 0
    self.contents_opacity = 0
    @actor = actor
    @type = type
    @blink = false
    refresh
  end
  #--------------------------------------------------------------------------
  # ● リフレッシュ
  #--------------------------------------------------------------------------
  def refresh
    self.contents.clear
    self.contents.font.size = $default_size
    # 土台
    if @type == 1
      bitmap = RPG::Cache.windowskin("menu_status1")
    else
      bitmap = RPG::Cache.windowskin("menu_status2")
    end
    src_rect = Rect.new(0, 0, 310, 180)
    self.contents.blt(0, 0, bitmap, src_rect)
    # 顔フレーム
    bitmap = RPG::Cache.windowskin("face_frame")
    self.contents.blt(4, 8, bitmap, src_rect)
    # 顔グラフィック
    @face_name =  RPG::Face.seek(@actor.character_name)
    @face_name.sub!(/_\d+$/) { "" }
    bitmap = RPG::Cache.face(@face_name)
    self.contents.blt(4, 8, bitmap, src_rect)

    #名前
    self.contents.draw_text(120, 12, 200, 24, @actor.name)
    self.contents.draw_text(120 + 24, 12 + 24, 200, 24, @actor.class_name)
    self.contents.draw_text(120, 12 + 54, 64, 24, "EP")
    self.contents.draw_text(120, 12 + 80, 64, 24, "VP")
    unless @actor == $game_actors[101]
      draw_actor_fed(@actor, 120 + 4, 12 + 104, 160)
    end
    draw_actor_state(@actor, 120 + 4, 12 + 128, 150, 2)
    self.contents.font.color =  normal_color
    self.contents.draw_text(14, 118, 100, 24, "Lv." + @actor.level.to_s, 1)
    
    self.contents.font.size = $default_size_mini
    draw_actor_hp(@actor, 120 + 24, 12 + 46, 150)
    draw_actor_sp(@actor, 120 + 24, 12 + 72, 150)
    self.contents.draw_text(14, 135, 100, 24, "Until Next Level: ")
    self.contents.draw_text(14, 150, 100, 24, " " + @actor.next_rest_exp_s + " Exp", 2)
  end
  
end