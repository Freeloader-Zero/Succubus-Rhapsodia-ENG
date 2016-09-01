#==============================================================================
# ■ Window_BattleBackLog
#==============================================================================
class Window_BattleBackLog < Window_Base
  #--------------------------------------------------------------------------
  # ● 公開インスタンス変数
  #--------------------------------------------------------------------------
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  def initialize
#    super(-64, -64, 720, 640)
    super(-64, -64, 720, 640)
    self.contents = Bitmap.new(width - 32, height - 32)
    self.back_opacity = 150
    self.z = 1100
    @log_text = ""
    @index = 0
    
    # ▽初期設定
    #--------------------------------------------------------------------------
    @start_x = 164 # 開始Ｘ座標
    @start_y = 64  # 開始Ｙ座標
    @max_line = 18 # 最大表示行数
    @scroll_speed = 24
  end
  #--------------------------------------------------------------------------
  # ● ログテキストのリフレッシュ
  #--------------------------------------------------------------------------
  def log_text_refresh
    # ログテキスト変数に新しい文章を追加
    @log_text += $game_temp.battle_back_log
    $game_temp.battle_back_log = ""
    # 改行の重複を直す
    @log_text.gsub!("\n\n","\n")
    
    # ▽ログテキストの行数が規定値を超えた場合、前の行を削る処理
    #--------------------------------------------------------------------------
    # まず行で区分けを行う
    @log_text.gsub!("\n","\n/")
    text_lines = @log_text.split(/\//)
    # 空白や改行のみになっている行は削除する
    for i in 0...text_lines.size
      if text_lines[i] == "" or text_lines[i] == "\n"
        text_lines[i] = nil
      end
    end
    text_lines.compact!
    # 超過した行がある場合、その分前から削除する
    over_lines = text_lines.size - @max_line
    if over_lines > 0
      for i in 0...over_lines
        text_lines.shift
      end
    end
    # テキストを入れなおす
    new_text = ""
    for text_one in text_lines
      new_text += text_one
    end
    @log_text = new_text
  end
  #--------------------------------------------------------------------------
  # ● テキスト設定
  #--------------------------------------------------------------------------
  def refresh
    # 初期化
    self.contents.clear
    x = @start_x
    line_deep = 0
    # ログテキストの複製を格納
    text = @log_text.clone
    # c に 1 文字を取得 (文字が取得できなくなるまでループ)
    while ((c = text.slice!(/./m)) != nil)
      # 外字の場合
      if c == "\H"
        heart = RPG::Cache.picture("heart")
        self.contents.blt(x + 6 , 24 * line_deep + @start_y + 9, heart, Rect.new(0, 0, 16, 16))
        x += 16
        next
      end
      # 改行文字の場合
      if c == "\n"
        x = @start_x
        line_deep += 1
        next
      end
      # 文字を描画
      self.contents.draw_text(4 + x, 24 * line_deep + @start_y, 40, 32, c)
      # x に描画した文字の幅を加算
      x += self.contents.text_size(c).width #+ 2
      if c == "\065"
        x = @start_x
        line_deep += 1
        next
      end
      # 文字を描画
      self.contents.draw_text(4 + x, 24 * line_deep + @start_y, 40, 32, c)
      # x に描画した文字の幅を加算
      x += self.contents.text_size(c).width #+ 2
    end
    # 一番下の行が表示されるように表示
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新
  #--------------------------------------------------------------------------
  def update
    # メッセージがあればログテキストをリフレッシュ
    if $game_temp.battle_back_log != ""
      log_text_refresh
    end
    # 表示中でない場合、操作を受け付けない
    return unless self.visible
=begin    
    # 方向ボタンの上が押された場合
    if Input.repeat?(Input::UP)
      self.oy += @scroll_speed
      return
    end
    # 方向ボタンの下が押された場合
    if Input.repeat?(Input::DOWN)
      self.oy -= @scroll_speed
      return
    end
=end
  end
  #--------------------------------------------------------------------------
  # ● 表示時にリフレッシュをかける
  #--------------------------------------------------------------------------
  def visible=(visible)
    refresh if visible == true
    super
  end
end