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
    self.contents.draw_text(x + 168, y + (y_a * 0), 200, 24, "マップ設定")
    #
    self.contents.font.color = normal_color  
    self.contents.font.size = $default_size
    self.contents.draw_text(x, y + (y_a * 1), 200, 24, "デフォルト移動方法")
    self.contents.draw_text(x, y + (y_a * 2), 200, 24, "精の献上イベント")
    self.contents.draw_text(x, y + (y_a * 3), 200, 24, "ポート機能設定")
    self.contents.draw_text(x, y + (y_a * 4), 200, 24, "パートナー空腹度")
    #
    self.contents.font.color = crisis_color
    self.contents.font.size = 22
    self.contents.draw_text(x + 168, y + (y_a * 5), 200, 24, "バトル設定")
    #
    self.contents.font.color = normal_color  
    self.contents.font.size = $default_size
    self.contents.draw_text(x, y + (y_a * 6), 200, 24, "バトルスピード")
    self.contents.draw_text(x, y + (y_a * 7), 200, 24, "メッセージモード")
    self.contents.draw_text(x, y + (y_a * 8), 200, 24, "レジスト猶予時間")
    self.contents.draw_text(x, y + (y_a * 9), 200, 24, "精液グラフィック表示")
    self.contents.draw_text(x, y + (y_a * 10), 200, 24, "カーソル位置記憶")
    self.contents.draw_text(x, y + (y_a * 11), 200, 24, "エロティックメッセージ")
    #
    self.contents.font.color = crisis_color
    self.contents.font.size = 22
    self.contents.draw_text(x + 184, y + (y_a * 12), 200, 24, "その他")
    #
    self.contents.font.color = normal_color  
    self.contents.font.size = $default_size
    self.contents.draw_text(x, y + (y_a * 13), 200, 24, "画面表示サイズ切り替え")    
    self.contents.draw_text(x, y + (y_a * 14), 200, 24, "ゲーム中断")    

    self.cursor_rect.set(x - 4, y - 4 + (y_a * @index) - self.oy, 130, 32)
   
    
    x = 270
    #●デフォルト移動
    x_a = 48
    color_change(1, false)
    self.contents.draw_text(x, y + (y_a * 1), 200, 24, "歩行")
    color_change(1, true)
    self.contents.draw_text(x + x_a, y + (y_a * 1), 200, 24, "ダッシュ")
    #●精の献上
    x_a = 48
    color_change(2, true)
    self.contents.draw_text(x, y + (y_a * 2), 200, 24, "見る")
    color_change(2, false)
    self.contents.draw_text(x + x_a, y + (y_a * 2), 200, 24, "見ない")
    #●ポート設定
    x_a = 84
    color_change(3, false)
    self.contents.draw_text(x, y + (y_a * 3), 200, 24, "記録優先")
    color_change(3, true)
    self.contents.draw_text(x + x_a, y + (y_a * 3), 200, 24, "転移優先")
    #●空腹度
    x_a = 48
    color_change(4, 0)
    self.contents.draw_text(x + (x_a * 0), y + (y_a * 4), 200, 24, "標準")
    color_change(4, 1)
    self.contents.draw_text(x + (x_a * 1), y + (y_a * 4), 200, 24, "少食")
    color_change(4, 2)
    self.contents.draw_text(x + (x_a * 2), y + (y_a * 4), 200, 24, "節制")
    #●バトルスピード
    x_a = 48
    color_change(6, 0)
    self.contents.draw_text(x + (x_a * 0), y + (y_a * 6), 200, 24, "遅い")
    color_change(6, 1)
    self.contents.draw_text(x + (x_a * 1), y + (y_a * 6), 200, 24, "標準")
    color_change(6, 2)
    self.contents.draw_text(x + (x_a * 2), y + (y_a * 6), 200, 24, "速い")
    #●メッセージモード
    x_a = 84
    color_change(7, 0)
    self.contents.draw_text(x + (x_a * 0), y + (y_a * 7), 200, 24, "マニュアル")
    color_change(7, 1)
    self.contents.draw_text(x + (x_a * 1), y + (y_a * 7), 200, 24, "セミオート")
    color_change(7, 2)
    self.contents.draw_text(x + (x_a * 2), y + (y_a * 7), 200, 24, "フルオート")
    #●レジスト猶予期間
    x_a = 48
    color_change(8, 0)
    self.contents.draw_text(x + (x_a * 0), y + (y_a * 8), 200, 24, "短い")
    color_change(8, 1)
    self.contents.draw_text(x + (x_a * 1), y + (y_a * 8), 200, 24, "標準")
    color_change(8, 2)
    self.contents.draw_text(x + (x_a * 2), y + (y_a * 8), 200, 24, "長い")
    color_change(8, 3)
    self.contents.draw_text(x + (x_a * 3), y + (y_a * 8), 200, 24, "接待")
    #●精液グラフィック表示
    x_a = 48
    color_change(9, true)
    self.contents.draw_text(x, y + (y_a * 9), 200, 24, "表示")
    color_change(9, false)
    self.contents.draw_text(x + x_a, y + (y_a * 9), 200, 24, "非表示")
    #●カーソル位置記憶
    x_a = 48
    color_change(10, true)
    self.contents.draw_text(x, y + (y_a * 10), 200, 24, "する")
    color_change(10, false)
    self.contents.draw_text(x + x_a, y + (y_a * 10), 200, 24, "しない")
    #●エロティックメッセージ
    x_a = 48
    color_change(11, 0)
    self.contents.draw_text(x, y + (y_a * 11), 200, 24, "簡易")
    color_change(11, 1)
    self.contents.draw_text(x + x_a, y + (y_a * 11), 200, 24, "標準")
    color_change(11, 2)
    self.contents.draw_text(x + (x_a * 2), y + (y_a * 11), 200, 24, "詳細")
    
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
      text = "決定キーを押していない時の移動方法の設定をします。"
    when 2 # 精の献上イベント
      text = "精の献上イベントを見るか否かを設定します。"
    when 3 # ポート設定
      text = "ポート機能「セーブ」と「テレポート」のどちらを上に表示するか設定します。"
    when 4 # 空腹度
      text = "パートナー夢魔の空腹度の減り方を設定をします。"
    when 6 # バトルスピード
      text = "戦闘全体の速度を設定します。"
    when 7 # メッセージスピード
      text = "戦闘中のメッセージの表示時間を設定します。"
    when 8 # レジスト猶予
      text = "レジスト猶予時間の設定をします。"
    when 9 # 精液グラフィック
      text = "主人公が裸で絶頂した場合、相手夢魔に精液がかかるかを設定します。"
    when 10 # カーソル位置記憶
      text = "戦闘中、直前に使用したスキルの位置を記憶するかしないかを設定します。"
    when 11 # エロティックメッセージ
      text = "戦闘で夢魔の会話をどの程度表示するか設定します。"
    when 13 # フルスクリーン化
      text = "ゲーム画面のフルスクリーン／ウィンドウの切り替えを行います。"
    when 14 # ゲームをやめる
      text = "ゲームを中断します。次に始める時は最後にセーブした所からとなります。"
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
