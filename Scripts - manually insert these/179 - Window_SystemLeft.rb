#==============================================================================
# ■ Window_Status
#------------------------------------------------------------------------------
# 　ステータス画面で表示する、フル仕様のステータスウィンドウです。
#==============================================================================

class Window_SystemLeft < Window_Base
  #--------------------------------------------------------------------------
  # ● 公開インスタンス変数
  #--------------------------------------------------------------------------
  attr_accessor   :index
  attr_accessor   :max
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #     actor : アクター
  #--------------------------------------------------------------------------
  def initialize
    super(50, 46, 540, 288)
    # 数値設定---------------------------------------------------------------
    @max = 15 # 項目数。増設する場合はここを増やす。
    #------------------------------------------------------------------------
    self.contents = Bitmap.new(width - 32, @max * 32)
    self.z = 2050
    self.back_opacity = 0
    self.active = true
    @index = 1
    refresh
  end
  #--------------------------------------------------------------------------
  # ● リフレッシュ
  #--------------------------------------------------------------------------
  def refresh
    self.contents.clear
    self.contents.font.color = normal_color  

    row_refresh
    
    x = 50
    y = 0
    y_a = 32
    
    self.contents.font.color = crisis_color
    self.contents.font.size = 22
    self.contents.draw_text(x + 168, y + (y_a * 0), 200, 24, "Map Settings")
    #
    self.contents.font.color = normal_color  
    self.contents.font.size = $default_size
    self.contents.draw_text(x, y + (y_a * 1), 200, 24, "Default Movement")
    self.contents.draw_text(x, y + (y_a * 2), 200, 24, "Partner Feeding")
    self.contents.draw_text(x, y + (y_a * 3), 200, 24, "Crystal Priority")
    self.contents.draw_text(x, y + (y_a * 4), 200, 24, "Partner Appetite")
    #
    self.contents.font.color = crisis_color
    self.contents.font.size = 22
    self.contents.draw_text(x + 168, y + (y_a * 5), 200, 24, "Battle Settings")
    #
    self.contents.font.color = normal_color  
    self.contents.font.size = $default_size
    self.contents.draw_text(x, y + (y_a * 6), 200, 24, "Battle Speed")
    self.contents.draw_text(x, y + (y_a * 7), 200, 24, "Message Mode")
    self.contents.draw_text(x, y + (y_a * 8), 200, 24, "Resist Minigame Delay")
    self.contents.draw_text(x, y + (y_a * 9), 200, 24, "Bukkake")
    self.contents.draw_text(x, y + (y_a * 10), 200, 24, "Cursor Memory")
    self.contents.draw_text(x, y + (y_a * 11), 200, 24, "Erotic Messages")
    #
    self.contents.font.color = crisis_color
    self.contents.font.size = 22
    self.contents.draw_text(x + 184, y + (y_a * 12), 200, 24, "Other")
    #
    self.contents.font.color = normal_color  
    self.contents.font.size = $default_size
    self.contents.draw_text(x, y + (y_a * 13), 200, 24, "Screen Size")    
    self.contents.draw_text(x, y + (y_a * 14), 200, 24, "Stop Game")    

    self.cursor_rect.set(x - 4, y - 4 + (y_a * @index) - self.oy, 130, 32)
   
    
    x = 270
    #●デフォルト移動
    x_a = 48
    color_change(1, false)
    self.contents.draw_text(x, y + (y_a * 1), 200, 24, "Walk")
    color_change(1, true)
    self.contents.draw_text(x + x_a + 2, y + (y_a * 1), 200, 24, "Dash")
    #●精の献上
    x_a = 48
    color_change(2, true)
    self.contents.draw_text(x, y + (y_a * 2), 200, 24, "Show")
    color_change(2, false)
    self.contents.draw_text(x + x_a + 8, y + (y_a * 2), 200, 24, "Hide")
    #●ポート設定
    x_a = 84
    color_change(3, false)
    self.contents.draw_text(x, y + (y_a * 3), 200, 24, "Save")
    color_change(3, true)
    self.contents.draw_text(x + x_a - 20, y + (y_a * 3), 200, 24, "Teleport")
    #●空腹度
    x_a = 48
    color_change(4, 0)
    self.contents.draw_text(x + (x_a * 0), y + (y_a * 4), 200, 24, "Normal")
    color_change(4, 1)
    self.contents.draw_text(x + (x_a * 1) + 24, y + (y_a * 4), 200, 24, "Small")
    color_change(4, 2)
    self.contents.draw_text(x + (x_a * 2) + 30, y + (y_a * 4), 200, 24, "Constrained")
    #●バトルスピード
    x_a = 48
    color_change(6, 0)
    self.contents.draw_text(x + (x_a * 0), y + (y_a * 6), 200, 24, "Slow")
    color_change(6, 1)
    self.contents.draw_text(x + (x_a * 1) + 20, y + (y_a * 6), 200, 24, "Normal")
    color_change(6, 2)
    self.contents.draw_text(x + (x_a * 2) + 48, y + (y_a * 6), 200, 24, "Fast")
    #●メッセージモード
    x_a = 84
    color_change(7, 0)
    self.contents.draw_text(x + (x_a * 0), y + (y_a * 7), 200, 24, "Manual")
    color_change(7, 1)
    self.contents.draw_text(x + (x_a * 1) - 6, y + (y_a * 7), 200, 24, "Semiauto")
    color_change(7, 2)
    self.contents.draw_text(x + (x_a * 2), y + (y_a * 7), 200, 24, "Auto")
    #●レジスト猶予期間
    x_a = 48
    color_change(8, 0)
    self.contents.draw_text(x + (x_a * 0), y + (y_a * 8), 200, 24, "Short")
    color_change(8, 1)
    self.contents.draw_text(x + (x_a * 1) + 6, y + (y_a * 8), 200, 24, "Normal")
    color_change(8, 2)
    self.contents.draw_text(x + (x_a * 2) + 22, y + (y_a * 8), 200, 24, "Long")
    color_change(8, 3)
    self.contents.draw_text(x + (x_a * 3) + 24, y + (y_a * 8), 200, 24, "Relaxed")
    #●精液グラフィック表示
    x_a = 48
    color_change(9, true)
    self.contents.draw_text(x, y + (y_a * 9), 200, 24, "Show")
    color_change(9, false)
    self.contents.draw_text(x + x_a + 8, y + (y_a * 9), 200, 24, "Hide")
    #●カーソル位置記憶
    x_a = 48
    color_change(10, true)
    self.contents.draw_text(x, y + (y_a * 10), 200, 24, "Yes")
    color_change(10, false)
    self.contents.draw_text(x + x_a, y + (y_a * 10), 200, 24, "No")
    #●エロティックメッセージ
    x_a = 48
    color_change(11, 0)
    self.contents.draw_text(x, y + (y_a * 11), 200, 24, "Simple")
    color_change(11, 1)
    self.contents.draw_text(x + x_a + 24, y + (y_a * 11), 200, 24, "Normal")
    color_change(11, 2)
    self.contents.draw_text(x + (x_a * 2) + 48, y + (y_a * 11), 200, 24, "Detailed")
    
#    x_a = 96
#    color_change(5, false)
#    self.contents.draw_text(x, y + (y_a * 5), 200, 24, "ウィンドウ")
#    color_change(5, true)
#    self.contents.draw_text(x + x_a, y + (y_a * 5), 200, 24, "フルスクリーン")
    
 
  end
  #--------------------------------------------------------------------------
  # ● カラー変更用
  #--------------------------------------------------------------------------
  def color_change(type, variables)
    
    case type
    when 1 # ダッシュ変更
      if $game_system.system_dash == variables
        self.contents.font.color = normal_color  
      else
        self.contents.font.color = disabled_color
      end
    when 2 # 精の献上イベント
      if $game_system.system_present == variables
        self.contents.font.color = normal_color  
      else
        self.contents.font.color = disabled_color
      end
    when 3 # ポート設定
      if $game_switches[33] == variables
        self.contents.font.color = normal_color  
      else
        self.contents.font.color = disabled_color
      end
    when 4 # 空腹度調節
      if $game_system.system_fed == variables
        self.contents.font.color = normal_color  
      else
        self.contents.font.color = disabled_color
      end
    when 6 # バトルスピード
      if $game_system.system_battle_speed == variables
        self.contents.font.color = normal_color  
      else
        self.contents.font.color = disabled_color
      end
    when 7 # メッセージモード
      if $game_system.system_read_mode == variables
        self.contents.font.color = normal_color  
      else
        self.contents.font.color = disabled_color
      end
    when 8 # レジスト時間
      if $game_system.system_regist == variables
        self.contents.font.color = normal_color  
      else
        self.contents.font.color = disabled_color
      end
    when 9 # 精液グラフィック
      if $game_system.system_sperm == variables
        self.contents.font.color = normal_color  
      else
        self.contents.font.color = disabled_color
      end
    when 10 # カーソル位置記憶
      if $game_system.system_arrow == variables
        self.contents.font.color = normal_color  
      else
        self.contents.font.color = disabled_color
      end
    when 11 # エロティックメッセージ
      if $game_system.system_message == variables
        self.contents.font.color = normal_color  
      else
        self.contents.font.color = disabled_color
      end
    end
    
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
    case @index
    when 0,5,12 #項目名
      text = ""
    when 1 # デフォルト移動
      text = "Movement type when no key is pressed."
    when 2 # 精の献上イベント
      text = "Show or hide partner feeding animation. (Used from party menu)"
    when 3 # ポート設定
      text = "Set whether ｢Save｣ or ｢Teleport｣ is listed first."
    when 4 # 空腹度
      text = "Set how fast partner Satiety decreases."
    when 6 # バトルスピード
      text = "Set the overall battle speed."
    when 7 # メッセージスピード
      text = "Set the battle messages display delay."
    when 8 # レジスト猶予
      text = "Set how much time you get for the Resist minigame."
    when 9 # 精液グラフィック
      text = "Whether cum graphics show when applicable."
    when 10 # カーソル位置記憶
      text = "Allows cursor to jump to the last used skill in battle."
    when 11 # エロティックメッセージ
      text = "Set how talkative the succubi are in battle."
    when 13 # フルスクリーン化
      text = "Full screen or window."
    when 14 # ゲームをやめる
      text = "Quit the game, or return to the title menu.。"
    end
    @help_window.set_text(text == nil ? "" : text)
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
  # ● 行位置調整
  #--------------------------------------------------------------------------
  def row_refresh
    # 現在の行を取得
    row = @index
    if row < self.oy / 32
      self.oy = row * 32
    end
    if row > (self.oy / 32) + 7
      self.oy = (row - 7) * 32
    end
  end

  
  
end
