# ▼▲▼ No 9. メッセージ表示フルグレードアップX ▼▲▼
#
# update 2007/12/26
#
#==============================================================================
# □ カスタマイズポイント
#==============================================================================
class Window_Message < Window_Selectable
  #--------------------------------------------------------------------------
  # 文字サイズ設定
  #--------------------------------------------------------------------------
  DEFAULT_FONT_SIZE      =  $default_size      # 標準文字サイズ( 22が初期設定 )
  DEFAULT_LINE_SPACE     =  24      # 標準行間　　　( 32が初期設定 )
  #--------------------------------------------------------------------------
  # 基本メッセージウィンドウ
  #--------------------------------------------------------------------------
  DEFAULT_RECT           = Rect.new(48, 0, 520, 152)
#  BATTLE_RECT            = Rect.new(118, 292, 544, 150) #★
  BATTLE_RECT            = Rect.new(118, 292, 402, 150) #★
  DEFAULT_BACK_OPACITY   = 160      # ウィンドウの不透明度
  DEFAULT_STRETCH_ENABLE = true     # 五行以上の場合自動的にサイズを変更する
  #--------------------------------------------------------------------------
  # 通常モード(一文字ずつ描画)
  #--------------------------------------------------------------------------
  DEFAULT_TYPING_ENABLE = true  # (falseにすると同時に全文章を表示)
  DEFAULT_TYPING_SPEED  = 0     # 通常モード時の基本メッセージスピード(大きいほど遅い)
  #--------------------------------------------------------------------------
  # 個人スピード設定
  #--------------------------------------------------------------------------
  TALK_SPEEDS = {
  }
  #--------------------------------------------------------------------------
  # インフォメーションウィンドウ
  #--------------------------------------------------------------------------
  INFO_RECT              = Rect.new(-16, 64, 672, DEFAULT_LINE_SPACE + 16)
  #--------------------------------------------------------------------------
  # テロップモード (スキップ禁止、文字描画速度を遅くし、自動的に閉じます)
  #--------------------------------------------------------------------------
  TELOP_SWITCH_ID       = 9     # テロップモードをONにするスイッチ ID
  TELOP_TYPING_SPEED    = 0     # テロップモード時の基本メッセージスピード
  TELOP_HOLD_WAIT       = 20    # 自動閉じまでの待機時間[単位:F]
  #--------------------------------------------------------------------------
  # 高速スキップ／タイピングスキップ
  #--------------------------------------------------------------------------
  KEY_TYPE_SKIP         = Input::C # タイピングスキップ(残りを瞬間表示)
  KEY_HISPEED_SKIP      = Input::B # 高速スキップ
  HISKIP_ENABLE_SWITCH_ID = 10 # 高速スキップを有効にするスイッチのID.( 0 は常時可能)
  SKIP_BAN_SWITCH_ID      = 0 # 高速／タイピングを共にスキップ禁止するスイッチのID. ( 0 は常時可能)
  #--------------------------------------------------------------------------
  # キャラポップ
  #--------------------------------------------------------------------------
  CHARPOP_HEIGHT         =  56      # キャラポップの高さ
  #--------------------------------------------------------------------------
  # ネームウィンドウ
  #--------------------------------------------------------------------------
  NAME_WINDOW_SKIN        = "MessageName"     # 画像ファイル(Windowskins)
  NAME_WINDOW_OFFSET_X    =   0    # \name ウィンドウのオフセット位置 X
  NAME_WINDOW_OFFSET_Y    =   5     # \name ウィンドウのオフセット位置 Y
  NAME_WINDOW_TEXT_SIZE   =   $default_size_mini    # \name ウィンドウの文字サイズ
  NAME_WINDOW_TEXT_COLOR  = Color.new(224,252,255,255) # \name ウィンドウ文字色
  #--------------------------------------------------------------------------
  # 終了時フェードアウト (Fade Out Before Terminate)
  #--------------------------------------------------------------------------
  FOBT_DURATION           =  5     # \fade を指定した時のフェード持続時間 
  #--------------------------------------------------------------------------
  # 文字描画SE 除外文字
  #--------------------------------------------------------------------------
  NOT_SOUND_CHARACTERS = [" ", "　", "・","･", "、", "。", "─"]
end
module XRXS9
  #--------------------------------------------------------------------------
  # 自動ウェイト文字
  #--------------------------------------------------------------------------
  TYPEWAITS = ["・","･","、","。","　"]
  #--------------------------------------------------------------------------
  # メッセージ背景
  #--------------------------------------------------------------------------
  BACK_NAME = "MessageBack" # (Windowskins)
  BACK_OX   =  0
  BACK_OY   =  24
end
#==============================================================================
# メッセージ背景
#==============================================================================
class Game_System
  attr_accessor :messageback_name
  def messageback_name
    return @messageback_name.nil? ? XRXS9::BACK_NAME : @messageback_name
  end
end
#==============================================================================
# --- セリフ効果音 ---
#        ◇スクリプト：$game_system.speak_se = RPG::AudioFile.new("ファイル名")
#        と設定して使用します。
#==============================================================================
class Game_System
  attr_accessor :speak_se
  def speak_se_play
    self.se_play(self.speak_se) if self.speak_se != nil
  end
end
#==============================================================================
# --- キャラポップ限界位置指定 --- [単位：マップ座標]
#==============================================================================
class Game_System
  attr_accessor :limit_right
end
#==============================================================================
# --- マテリアル機構連携
#==============================================================================
class Game_Temp
  attr_accessor :current_material
end
#==============================================================================
# □ Sprite_Pause
#==============================================================================
class Sprite_Pause < Sprite
  def initialize
    super
    self.bitmap = RPG::Cache.windowskin($game_system.windowskin_name)
    self.x = 604
    self.y = 456
    self.z = 5500
    @count = 0
    @wait_count = 0
    update
  end
  def update
    super
    if @wait_count > 0
      @wait_count -= 1
    else
      @count = (@count + 1)%4
      x = 160 + @count % 2
      y =  64 + @count / 2
      self.src_rect.set(x, y, 16, 16)
      @wait_count = 4
    end
  end
end
#==============================================================================
# 選択肢ウィンドウ
#==============================================================================
class Window_MessageSelect < Window_Selectable
  #--------------------------------------------------------------------------
  # オブジェクト初期化
  #--------------------------------------------------------------------------
  def initialize(window)
    @message_window = window
    super(0,0,160,160)
    self.visible = false
    self.back_opacity = Window_Message::DEFAULT_BACK_OPACITY
    self.contents = Bitmap.new(1,1)
    self.z = 9998
    @column_max = 1
    self.index = -1
  end
  #--------------------------------------------------------------------------
  # セット！
  #--------------------------------------------------------------------------
  def set(texts)
    if texts.empty?
      texts = [""]
    end
    max_width = 1
    for text in texts
      w = self.contents.text_size(text).width
      max_width = w if max_width < w
    end
    self.contents.dispose
    self.contents = Bitmap.new(max_width + 8, texts.size * 32)
    self.width  = self.contents.width  + 32
    self.height = self.contents.height + 32
    y = 0
    for text in texts
      self.contents.draw_text(4, y, max_width, 32, text)
      y += 32
    end
    self.reset
    self.index = 0
    @item_max = texts.size
  end
  #--------------------------------------------------------------------------
  # 座標のリセット
  #--------------------------------------------------------------------------
  def reset
    self.x = @message_window.x + @message_window.width - self.width
    upper = @message_window.y
    under = 480 - (@message_window.y + @message_window.height)
    if upper > under
      self.y = @message_window.y - self.height
    else
      self.y = @message_window.y + @message_window.height
    end
  end
end
#==============================================================================
# ■ Window_Message
#==============================================================================
class Window_Message < Window_Selectable
  #--------------------------------------------------------------------------
  # ● 公開インスタンス変数
  #--------------------------------------------------------------------------
  attr_reader   :bgframe_sprite  # 背景画像
  attr_reader   :select_window   # 選択肢ウィンドウ
  # 定数
  AUTO   = 0
  LEFT   = 1
  CENTER = 2
  RIGHT  = 3
  #--------------------------------------------------------------------------
  # ○ line_height : 行の高さ(@y増加値)を返します。
  #--------------------------------------------------------------------------
  def line_height
    return DEFAULT_LINE_SPACE
  end
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  alias xrxs9_initialize initialize
  def initialize
    # 背景
    @bgframe_sprite = Sprite.new
    @bgframe_sprite.x = 320
    @bgframe_sprite.y =   0
    @bgframe_sprite.z += 3000 
    @bgframe_sprite.oy = XRXS9::BACK_OY
    if $game_temp.in_battle 
      @bgframe_sprite.visible = false
    end
    # 名前タブ
    @name_skin = RPG::Cache.windowskin(NAME_WINDOW_SKIN)
    # 文章部分
    @text_sprite = Sprite.new
    @text_sprite.opacity = 0
    @text_sprite.bitmap = Bitmap.new(1,1)
    # 選択肢部分
    @select_window = Window_MessageSelect.new(self)
    # 初期化
    @stand_pictuers = []
    @held_windows = []
    @extra_windows = []
    @extra_sprites = []
    # ポーズサインの作成
    @pause = Sprite_Pause.new
    #@pause_flag = false
    # 初期化
    @line_index = 0
    @telop_hold_count = 0
    # 呼び戻す
    xrxs9_initialize
    #self.contents.dispose
    #self.contents = Bitmap.new(1,1)
    self.index = -1
    # ポーズサインの設定
    @pause.visible = false
    # Z座標の設定
    @pause.z = self.z + 1
  end
  #--------------------------------------------------------------------------
  # 土台の位置連動
#--------------------------------------------------------------------------
  def x=(n)
    @text_sprite.x = n + 8
    @select_window.reset
    super
  end
  def y=(n)
    @text_sprite.y = n + 8
    @select_window.reset
    super
  end
  def z=(n)
    @text_sprite.z = n + 3
    super
  end
  def visible=(b)
    @text_sprite.visible = b
    @bgframe_sprite.visible = b
    super
  end
  #--------------------------------------------------------------------------
  # ★ 一時消去/出現
  #--------------------------------------------------------------------------
  def hide
    self.visible = false
    @text_sprite.visible = false
    $game_temp.message_window_showing = false
    if @pause.visible
      @pause.visible = false
      @pause_icon_stay = true
    end
  end
  def appear
    self.opacity = 0 if @pause
    self.visible = true
    @text_sprite.visible = true
    $game_temp.message_window_showing = true
    if @pause_icon_stay
      @pause.visible = true
      @pause_icon_stay = false
    end
  end
  #--------------------------------------------------------------------------
  # ● 解放
  #--------------------------------------------------------------------------
  alias xrxs9_dispose dispose
  def dispose
    # 呼び戻す
    xrxs9_dispose
    # ホールドされたウィンドウを開放
    @held_windows.each {|window| window.dispose}
    @held_windows.clear
    # ポーズサイン
    @pause.dispose
    # 選択肢ウィンドウ
    @select_window.dispose
    # 外字キャッシュ開放
    if @gaiji_cache != nil
      @gaiji_cache.dispose
      @gaiji_cache = nil
    end
    # 文章部分
    @text_sprite.dispose
    # 背景ピクチャを解放
    @bgframe_sprite.dispose
  end
  #--------------------------------------------------------------------------
  # ● メッセージ終了処理
  #--------------------------------------------------------------------------
  alias xrxs9_terminate_message terminate_message
  def terminate_message
    # 素通りフラグをクリア
    @passable = false
    $game_player.messaging_moving = false
    # 選択肢
    @select_window.visible = false
    $game_temp.message_text = nil
    # ウィンドウホールド
    if @window_hold
      # ウィンドウやスプライトの複製を作成
      @held_windows.push(Window_Copy.new(self))
      @held_windows.push(Sprite_Copy.new(@text_sprite))
      for window in @extra_windows
        next if window.disposed?
        @held_windows.push(Window_Copy.new(window))
      end
      for sprite in @extra_sprites
        next if sprite.disposed?
        @held_windows.push(Sprite_Copy.new(sprite))
      end
      # ネームウィンドウを解放
      if @name_frame != nil
        @name_frame.dispose
        @name_frame = nil
      end
      # 設定をクリア
      self.opacity = 0
      @text_sprite.opacity = 0
      @extra_windows.clear
      @extra_sprites.clear
    else
      # ホールドされたウィンドウを開放
      @held_windows.each {|object| object.dispose}
      @held_windows.clear
    end
    # 呼び戻す
    xrxs9_terminate_message
  end
  #--------------------------------------------------------------------------
  # ○ ポップキャラクターの設定と取得
  #--------------------------------------------------------------------------
  def pop_character=(character_id)
    @pop_character = character_id
  end
  def pop_character
    return @pop_character
  end
  #--------------------------------------------------------------------------
  # ○ クリア
  #--------------------------------------------------------------------------
  def clear
    @text_sprite.bitmap.clear
    @text_sprite.bitmap.font.color = normal_color
    @text_sprite.bitmap.font.size  = DEFAULT_FONT_SIZE
    self.opacity      = 255
    self.back_opacity = DEFAULT_BACK_OPACITY
    @text_sprite.opacity  = 255
    @mid_stop     = false       # \!    　　の中断中フラグ
    @current_name = nil         # \name 　　のネーム保持
    @window_hold  = false       # \hold 　　のウィンドウホールドのフラグ
    @stand_pictuer_hold = false # \picthold のスタンドピクチャの保持フラグ
    @passable     = false       # \pass 　　の素通り可能フラグ
    @inforesize   = false       # \info　　 のインフォリサイズ
    @material     = nil         # \material
    @face_bitmap  = nil         # \f
    # 固定設定をロード
    @auto_align   = LEFT         # 基本位置揃え
    if $game_temp.in_battle and not $game_temp.in_battle_change
      @default_rect = BATTLE_RECT #★
    else
      @default_rect = DEFAULT_RECT # 基本メッセージウィンドウ矩形
    end
    # あと残りのここらへんのものを全て 0 で初期化
    @x = @y = @indent = @line_index = 0
    @cursor_width = @write_wait = @lines_max = 0
    # 各行の描画幅＆位置揃え設定初期化
    @line_widths = []
    @line_aligns = []
    # self.pop_character が nil の場合、標準位置。-1の場合、文字センター。
    # 0以上の場合　キャラポップ。0は主人公、1以降はイベント。
    self.pop_character = nil
    # ネームウィンドウを解放
    if @name_frame != nil
      @name_frame.dispose
      @name_frame = nil
    end
  end
  #--------------------------------------------------------------------------
  # ● リフレッシュ [再定義]
  #--------------------------------------------------------------------------
  def refresh
    # ビットマップの取得と設定
    if $game_system.messageback_name != ""
      bitmap = RPG::Cache.windowskin($game_system.messageback_name)
      @bgframe_sprite.bitmap = bitmap
      @bgframe_sprite.ox = bitmap.width / 2 + XRXS9::BACK_OX
      self.opacity = 0
    end
    # 初期化
    self.clear
    # バックログに改行指定を追加
    $game_temp.battle_back_log += "\n" if $game_temp.in_battle
    # 表示待ちのメッセージがある場合
    if $game_temp.message_text != nil
      @now_text = $game_temp.message_text
      # 改行削除指定\_があるか？
      if (/\\_\n/.match(@now_text)) != nil
        $game_temp.choice_start -= 1
        @now_text.gsub!(/\\_\n/) { "" }
      end
      # インフォ判定
      @inforesize = (@now_text.gsub!(/\\info/) { "" } != nil)
      # ウィンドウ保持指定\holdがあるか？
      @window_hold = (@now_text.gsub!(/\\hold/) { "" } != nil)
      # \vの即時変換
      @now_text.gsub!(/\\[v]\[([0-9]+)\]/) { $game_variables[$1.to_i].to_s }
      # \Vを独自ルーチンに変更(追加部分)
      begin
        last_text = @now_text.clone
        @now_text.gsub!(/\\[V]\[([IiWwAaSs]?)([0-9]+)\]/) { convart_value($1, $2.to_i) }
      end until @now_text == last_text
      @now_text.gsub!(/\\[Nn]\[([0-9]+)\]/) do
        $game_actors[$1.to_i] != nil ? $game_actors[$1.to_i].name : ""
      end
      # \name 判定
      if @now_text.sub!(/\\[Nn]ame\[(.*?)\]/) { "" }
        @current_name = $1
      end
      # ウィンドウポップ判定
      if @now_text.gsub!(/\\[Pp]\[([0-9]+)\]/) { "" }
        self.pop_character = $1.to_i
      end
      # 顔グラフィック表示指定
      if (/\\[Ff]\[(.+?),([0-9]+)\]/.match(@now_text)) != nil
        @now_text.gsub!(/\\[Ff]\[(.+?),([0-9]+)\]/) { "" }
        begin
          face = RPG::Cache.picture($1)
          n    = $2.to_i
          rect = Rect.new(n % 4 * 96, n / 4 * 96, 96, 96)
          @face_bitmap = Bitmap.new(96,96)
          @face_bitmap.blt(0, 0, face, rect)
        rescue
          nil
        end
      end
      # 改行指定
      if (/\\n/.match(@now_text)) != nil
        $game_temp.choice_start += 1
        @now_text.gsub!(/\\n/) { "\n" }
      end
      # フェード判定
      if @now_text.gsub!(/\\fade/) { "" }
        @fade_count_before_terminate = FOBT_DURATION
      end
      # 素通り判定
      if @now_text.gsub!(/\\pass/) { "" }
        @passable = true
        $game_player.messaging_moving = true
      end
      # 末尾連続改行を削除
      nil while( @now_text.sub!(/\n\n\z/) { "\n" } )
      # 行数の取得
      @lines_max = @now_text.scan(/\n/).size
      # 現在搭載されている制御文字を配列化
      rxs = [/\\\w\[(\w+)\]/, /\\[.]/, /\\[|]/, /\\[>]/, /\\[<]/, /\\[!]/,
              /\\[~]/, /\\[i]/, /\\[Oo]\[([0-9]+)\]/, /\\[Hh]\[([0-9]+)\]/,
              /\\[b]\[([0-9]+)\]/, /\\[Rr]\[(.*?)\]/, /\\[B]/, /\\[I]/, /\\[Mm]/]
      # インフォウィンドウの強制センタリング
      @line_aligns[0] = CENTER if @inforesize
      # 選択肢用の文章をカット！＆再構築
      lines = @now_text.split(/\n/)
      text  = ""
      texts = []
      for i in 0...lines.size
        if i < $game_temp.choice_start
          text += lines[i] + "\n"
        else
          texts.push(lines[i])
        end
      end
      @now_text = text
      @select_window.set(texts)
      #
      # [行ごとの設定]
      #
      lines = @now_text.split(/\n/)
      for i in 0..@lines_max
        # 行の取得 (インデックスは逆順)
        line = lines[@lines_max - i]
        # 空白行の場合は次へ
        next if line == nil
        # 制御文字を削る
        line.gsub!(/\\[Ee]\[([0-9]+)\]/) { "\022[#{$1}]" }
        for rx in rxs
          line.gsub!(rx) { "" }
        end
        # 位置揃えを取得
        @line_aligns[@lines_max - i] =
          line.sub!(/\\center/) {""} ? CENTER :
          line.sub!(/\\right/)  {""} ? RIGHT :
          line.sub!(/\\left/)   {""} ? LEFT :
                                       AUTO
        # 行の横幅の取得と設定
        cx = @text_sprite.bitmap.text_size(line).width
        @line_widths[@lines_max - i] = cx
      end
      # 位置揃え制御文字の削除
      @now_text.gsub!(/\\center/) {""}
      @now_text.gsub!(/\\right/) {""}
      @now_text.gsub!(/\\left/) {""}
      # キャラポップ時のウィンドウリサイズ
      if self.pop_character != nil and self.pop_character >= 0
        max_x = @line_widths.max.to_i
        n = 0
        if @current_name != nil
          n = @name_skin.width + 2
        end
        self.width  = [max_x + @indent + DEFAULT_FONT_SIZE/2, n].max + 32
        self.height = [@lines_max * line_height, @indent].max + 16
      end
      #
      # 「変換」
      #
      # 便宜上、"\\\\" を "\000" に変換
      @now_text.gsub!(/\\\\/) { "\000" }
      # "\\C" を "\001" に、"\\G" を "\002" に、
      # "\\S" を "\003" に、"\\A" を "\004" に変換
      @now_text.gsub!(/\\[Cc]\[([0-9]+)\]/) { "\001[#{$1}]" }
      @now_text.gsub!(/\\[Gg]/) { "\002" }
      @now_text.gsub!(/\\[Ss]\[([0-9]+)\]/) { "\003[#{$1}]" }
      @now_text.gsub!(/\\[Aa]\[(.*?)\]/) { "\004[#{$1}]" }
      @now_text.gsub!(/\\[.]/) { "\005" }
      @now_text.gsub!(/\\[|]/) { "\006" }
      # 競合回避のため\016以降を使用する
      @now_text.gsub!(/\\[>]/) { "\016" }
      @now_text.gsub!(/\\[<]/) { "\017" }
      @now_text.gsub!(/\\[!]/) { "\020" }
      @now_text.gsub!(/\\[~]/) { "\021" }
      @now_text.gsub!(/\\[Ee]\[([0-9]+)\]/) { "\022[#{$1}]" }
      # インデント設定(追加部分)
      @now_text.gsub!(/\\[i]/) { "\023" }
      # テキスト透過率指定(追加部分)
      @now_text.gsub!(/\\[Oo]\[([0-9]+)\]/) { "\024[#{$1}]" }
      # テキストサイズ指定(追加部分)
      @now_text.gsub!(/\\[Hh]\[([0-9]+)\]/) { "\025[#{$1}]" }
      @now_text.gsub!(/\\[Ss]ize\[([0-9]+)\]/) { "\025[#{$1}]" }
      # 空白挿入(追加部分)
      @now_text.gsub!(/\\[b]\[([0-9]+)\]/) { "\026[#{$1}]" }
      # ルビ表示(追加部分)
      @now_text.gsub!(/\\[Rr]\[(.*?)\]/) { "\027[#{$1}]" }
      # Font.bold
      @now_text.gsub!(/\\[B]/) { "\031" }
      # Font.italic
      @now_text.gsub!(/\\[I]/) { "\032" }
      # ★外字表示
      @now_text.gsub!(/\\[H]/) { "\052" }
      # ●アイコン表示(アイテム)
      @now_text.gsub!(/\\[T]\[([0-9]+)\]/) { "\050[#{$1}]" }
      # ★メッセージ表示後レジスト開始
      @now_text.gsub!(/\\[Tt]/) { "\051" }
      # ★メッセージ表示後レジスト開始
      @now_text.gsub!(/\\[Mm]/) { "\053" }
      # マテリアル描画
      if @now_text.gsub!(/\\material/) { "" }
        @material = $game_temp.current_material
      end
      # ここで一旦ウィンドウ位置更新
      reset_window
      #
      # \nameがあるか？～「ネームウィンドウの作成」
      #
      if @current_name != nil
        # スキンの取得
        frame = @name_skin
        # 作成
        @name_frame = Sprite.new
        @name_frame.bitmap = Bitmap.new(frame.width, frame.height)
        @name_frame.bitmap.font.size = NAME_WINDOW_TEXT_SIZE
        @name_frame.bitmap.blt(0, 0, frame, frame.rect)
        x = self.x + NAME_WINDOW_OFFSET_X
        n = 0
        @name_frame.x = x
        @name_frame.y = self.y + NAME_WINDOW_OFFSET_Y - frame.height
        @name_frame.z = self.z + 2
        @name_frame.bitmap.draw_text(8, 0, frame.width, frame.height, @current_name, n)
        # エクストラスプライトに登録
        @extra_sprites.push(@name_frame)
      end
    end
    # ウィンドウを更新
    reset_window
    # コンテンツの再作成
    if @text_sprite.bitmap != nil
      @text_sprite.bitmap.dispose
      @text_sprite.bitmap = nil
    end
    @text_sprite.bitmap = Bitmap.new(self.width - 16, self.height - 16)
    @text_sprite.bitmap.font.color = normal_color

    #
    # 選択肢の場合
    #
    if $game_temp.choice_max > 0
      @item_max = $game_temp.choice_max
    #  self.active = true
      self.index = 0
    end
    #
    # 数値入力の場合
    #
    if $game_temp.num_input_variable_id > 0
      digits_max = $game_temp.num_input_digits_max
      number = $game_variables[$game_temp.num_input_variable_id]
      @input_number_window = Window_InputNumber.new(digits_max)
      @input_number_window.number = number
      @input_number_window.x = self.x + 8 + @indent
      @input_number_window.y = self.y + $game_temp.num_input_start * 32
    end
    # タイピングスピードを取得
    @write_speed = DEFAULT_TYPING_SPEED
    if @current_name != nil
      speed = TALK_SPEEDS[@current_name]
      @write_speed = speed if speed != nil
    end
    # テロップモードの場合
    if telop_ok? #$game_switches[TELOP_SWITCH_ID] and $game_temp.in_battle
      @write_speed = TELOP_TYPING_SPEED
      @fade_count_before_terminate = FOBT_DURATION
      @telop_hold_count = $game_system.battle_speed_time(2)
    end
    # フォントサイズを再設定
    @text_sprite.bitmap.font.size  = DEFAULT_FONT_SIZE
    # 顔グラフィック
    if @face_bitmap != nil
      #y = (self.height - 128) / 2
      @text_sprite.bitmap.blt(8, 0, @face_bitmap, @face_bitmap.rect)
      @indent += 120
      @face_bitmap.dispose
      @face_bitmap = nil
    end
    # 選択肢ならカーソルの更新
    if @line_index >= $game_temp.choice_start
      @select_window.visible = true
      self.active = true
    end
    # 行初期化
    line_reset
    # マテリアルの場合
    case @material
    when RPG::Item, RPG::Weapon, RPG::Armor
      text = @material.name
      rect = @text_sprite.bitmap.text_size(text)
      icon = RPG::Cache.icon(@material.icon_name)
      @text_sprite.bitmap.blt(@x + 8, (line_height - 24)/2, icon, icon.rect)
      @text_sprite.bitmap.draw_text(@x + 36, 0, rect.width, line_height, text)
      @x += rect.width + 32
    when Numeric
      text = @material.to_s
      w = @text_sprite.bitmap.text_size(text).width
      @text_sprite.bitmap.font.size  = DEFAULT_FONT_SIZE + 1
      @text_sprite.bitmap.draw_text(@x, 0, w, line_height, text)
      @text_sprite.bitmap.font.size  = DEFAULT_FONT_SIZE - 2
      @text_sprite.bitmap.draw_text(@x + w + 4, 0, 36, line_height, "スィル")
      @x += w + 40
    end
    # 瞬間表示の場合はこのままフレーム更新へ  
    update if $game_system.ms_skip_mode == 2
    update unless DEFAULT_TYPING_ENABLE
  end
  #--------------------------------------------------------------------------
  # ○ 行初期化
  #--------------------------------------------------------------------------
  def line_reset
    # 位置揃えの取得
    align = @line_aligns[@line_index]
    align = @auto_align if align == AUTO
    align = CENTER if @inforesize
    case align
    when LEFT
      @x  = @indent
      @x += 8 if $game_temp.choice_start <= @line_index
    when CENTER
      @x = self.width / 2 - 16 - @line_widths[@line_index].to_i / 2
    when RIGHT
      @x = self.width - 40 - @line_widths[@line_index].to_i
    end
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新 [再定義]
  #--------------------------------------------------------------------------
  def update
    # メッセージ素通り中にイベントが開始した場合
    if @passable and not $game_player.messaging_moving
      self.opacity = 0
      terminate_message
      return
    end
    # 選択肢
    if @line_index >= $game_temp.choice_start
      @select_window.update
    end
    # ポーズサイン
    @pause.update if @pause.visible
    # 呼び戻す
    super
    # フレーム更新↓
    update_main
  end
  #--------------------------------------------------------------------------
  # キャラポップが稼動中か？
  #--------------------------------------------------------------------------
  def chara_pop_working?
    return (!self.pop_character.nil? and self.pop_character >= 0)
  end
  #--------------------------------------------------------------------------
  # ○ フレーム更新
  #--------------------------------------------------------------------------
  def update_main
    # 動きに対応
    update_reset_window if chara_pop_working?
    # 高速スキップ処理
    if hispeed_skippable_now? and Input.press?(KEY_HISPEED_SKIP)
      @text_sprite.opacity = 255
      @fade_in = false
    end
    # フェードインの場合はここで処理
    if @fade_in
      @text_sprite.opacity += 51
      if @input_number_window != nil
        @input_number_window.contents_opacity += 51
      end
      if @text_sprite.opacity == 255
        @fade_in = false
      end
      return
    end
    # 変換
    @now_text = nil if @now_text == ""
    # 表示待ちのメッセージがある場合
    if @now_text != nil and not @mid_stop
      # 一文字ごとのウェイト
      if @write_wait > 0
        @write_wait -= 1
        return
      end
      @text_not_skip = DEFAULT_TYPING_ENABLE
      # スキップ不可状態以外は特定行動でスキップ
      unless $game_switches[23]
        @text_not_skip = false if $game_system.ms_skip_mode == 2
        if Input.trigger?(Input::C)
          @text_not_skip = false
        elsif Input.press?(Input::CTRL) and not $game_temp.in_battle
          @text_not_skip = false
        end
      end
      # 文字描画処理
      while true
        # c に @now_text から1文字だけ取得 
        c = @now_text.slice!(/./m)
        # 連続実行中に文字が取得できなくなったら終了
        if c == nil
          @text_not_skip = true
          break
        end
        # 1文字の描画
        type_text(c)
        # 終了判定
        break if @text_not_skip
      end
      @write_wait += @write_speed
      return
    end
    # 数値入力中の場合
    if @input_number_window != nil
      @input_number_window.update
      # 決定
      if Input.trigger?(Input::C)
        $game_system.se_play($data_system.decision_se)
        $game_variables[$game_temp.num_input_variable_id] = @input_number_window.number
        $game_map.need_refresh = true
        # 数値入力ウィンドウを解放
        @input_number_window.dispose
        @input_number_window = nil
        terminate_message
      end
      return
    end
    # テロップホールド処理
    if $game_switches[TELOP_SWITCH_ID] and @telop_hold_count >= 1
      if $game_temp.talk_resist_flag_log[/\\T/] != nil
        @telop_hold_count = 0
      else
        @telop_hold_count -= 1
      end
      return
    end
    #
    # メッセージ表示中の場合
    #
    if @contents_showing
      # 終了前フェーズでない場合
      unless @fade_phase_before_terminate
        # レジストゲーム中は固定
        if $game_temp.resistgame_flag >= 2
          #レジスト制御文字
          if $game_temp.talk_resist_flag_log[/\\T/] != nil or $game_temp.talk_resist_flag_log[/\\t/] != nil
            if $game_temp.resistgame_swicth == true
              $msg.resist_flag = true
            else
              $msg.resist_flag = false
            end
          end
          return
        end
        # 選択肢の表示中でなければポーズサインを表示
        if $game_temp.choice_max == 0
          #self.pause = true
          @pause.visible = true
        end
        # 決定 (テロップモードならボタンを押さなくても実行)
        # レジストゲームが終了しても実行
        if Input.trigger?(Input::C) or telop_ok?
=begin
          skippable_now? or $game_temp.resistgame_flag < 0 or
          ($game_switches[TELOP_SWITCH_ID] and not $game_temp.choice_max > 0 and not $game_temp.battle_actor_command_flag) or
          ($game_system.ms_skip_mode == 2 and not $game_temp.choice_max > 0 and not $game_temp.battle_actor_command_flag) or
          ($msg.talk_step == 4 and $game_switches[77] == true)
=end
          if $game_temp.choice_max > 0
            # ★スクリプトからのメッセージ表示では無い場合はデフォルト
            if $game_temp.script_message == false
              $game_system.se_play($data_system.decision_se)
              $game_temp.choice_proc.call(self.index)
            else
              # ★スクリプトからのメッセージの場合は、そのindexを返す
              $game_temp.script_message_index = self.index
              $game_temp.script_message_cancel = false
            end
          end
          if @mid_stop
            @mid_stop = false
            @pause.visible = false
            return
          elsif @fade_count_before_terminate.to_i > 0
            # 終了前フェーズへ
            @fade_phase_before_terminate = true
          else
            terminate_message
          end
          @pause.visible = false
        end
        # キャンセル
        if Input.trigger?(Input::B)
          if $game_temp.choice_max > 0 and $game_temp.choice_cancel_type > 0
             # ★スクリプトからのメッセージ表示では無い場合はデフォルト
            if $game_temp.script_message == false
              $game_system.se_play($data_system.cancel_se)
              $game_temp.choice_proc.call($game_temp.choice_cancel_type - 1)
            else
              # ★スクリプトからのメッセージの場合は、キャンセル時のindexを返す
              $game_system.se_play($data_system.cancel_se)
              $game_temp.script_message_index = $game_temp.choice_cancel_type - 1
              $game_temp.script_message_cancel = true
            end
            terminate_message
            @pause.visible = false
            return
          end
        end
      end
      # 終了前：カウント + フェードアウト
      if @fade_phase_before_terminate
        # 例外補正
        @fade_count_before_terminate  = 0 if @fade_count_before_terminate == nil
        # カウント
        @fade_count_before_terminate -= 1
        # 不透明度を計算・設定
        opacity = @fade_count_before_terminate * (256 / FOBT_DURATION)
        @text_sprite.opacity = opacity
        # 終了判定
        if @fade_count_before_terminate <= 0
          @fade_count_before_terminate = 0
          @fade_phase_before_terminate = false
          terminate_message
        end
      end
      return
    end
    #
    # 以下、メッセージ表示中でない場合
    #
    # フェードアウト中以外で表示待ちのメッセージか選択肢がある場合
    if @fade_out == false and $game_temp.message_text != nil
      @contents_showing = true
      $game_temp.message_window_showing = true
      refresh
      Graphics.frame_reset
      self.visible = true
      # ★戦闘中でない場合
      unless $game_temp.in_battle and not $game_temp.in_battle_change
        @bgframe_sprite.visible = true
      end
      @text_sprite.opacity = 0
      if @input_number_window != nil
        @input_number_window.contents_opacity = 0
      end
      @fade_in = true
      if $game_temp.script_message == true #★
        $game_temp.script_message_count += 1
      end
      return
    end
    if self.visible
      @fade_out = true
      self.opacity -= 48
      @text_sprite.opacity = self.opacity
      @name_frame.opacity = self.opacity if @name_frame != nil
      if self.opacity == 0
        message_end
      end
      return
    end
  end
  #--------------------------------------------------------------------------
  # テロップモード状態適用可能か？
  #--------------------------------------------------------------------------
  def telop_ok?
    return false if $game_switches[73]
    result = false
    result = true if skippable_now?
    if $game_temp.in_battle
      result = true if $game_temp.resistgame_flag < 0
      if $game_switches[TELOP_SWITCH_ID] or $game_system.ms_skip_mode == 2
        result = true if not $game_temp.choice_max > 0 and not $game_temp.battle_actor_command_flag
      end
      result = true if $msg.talk_step == 4 and $game_switches[77] == true
    end
    return result
  end
  #--------------------------------------------------------------------------
  # メッセージ処理の終了
  #--------------------------------------------------------------------------
  def message_end
    self.visible = false
    @fade_out = false
    $game_temp.message_window_showing = false
    $game_temp.script_message = false #★
    $game_temp.script_message_count = 0 #★
#    $game_temp.script_message_cancel = false #★
    @bgframe_sprite.visible = false 
    # ネームウィンドウを解放
    if @name_frame != nil
      @name_frame.dispose
      @name_frame = nil
    end
  end
  #--------------------------------------------------------------------------
  # 一文字の描画
  #--------------------------------------------------------------------------
  def type_text(text)
    c = text
    
    
    # 事前変換処理
    case c
    when "\000"
      # \\ : 本来の文字に戻す
      c = "\\"
    end
    #
    # [１文字処理]
    #
    case c
    when "\001" # \C[n] : 文字色を変更
      @now_text.sub!(/\[([0-9]+)\]/, "")
      color = $1.to_i
      if color >= 0 and color <= 12
        @text_sprite.bitmap.font.color = text_color(color)
        if @opacity != nil
          color = @text_sprite.bitmap.font.color
          @text_sprite.bitmap.font.color = Color.new(color.red, color.green, color.blue, color.alpha * @opacity / 255)
        end
      end
    when "\002" # \g
      # ゴールドウィンドウを作成
      if @gold_window == nil
        @gold_window = Window_Gold.new
        @gold_window.x = 560 - @gold_window.width + 64
        if $game_temp.in_battle
          @gold_window.y = 192
        else
          @gold_window.y = self.y >= 128 ? 32 : 384
        end
        @gold_window.back_opacity = self.back_opacity
      end
    when "\003" # \S[n] の場合
      # 文字色を変更
      @now_text.sub!(/\[([0-9]+)\]/, "")
      speed = $1.to_i
      if speed >= 0 and speed <= 19
        @write_speed = speed
      end
    when "\005" # \.
      @write_wait += 5
    when "\006" # \|
      @write_wait += 20
    when "\016" # \>
      @text_not_skip = false
    when "\017" # \<
      @text_not_skip = true
    when "\020" # \!
      @mid_stop = true
    when "\021" # \~
      terminate_message
    when "\024" # \0
      @now_text.sub!(/\[([0-9]+)\]/, "")
      @opacity = $1.to_i
      color = @text_sprite.bitmap.font.color
      @text_sprite.bitmap.font.color = Color.new(color.red, color.green, color.blue, color.alpha * @opacity / 255)
    when "\025" # \H
      @now_text.sub!(/\[([0-9]+)\]/, "")
      @text_sprite.bitmap.font.size = [[$1.to_i, 6].max, 32].min
    when "\027" # \Rルビ
      process_ruby
    when "\030" # アイコン描画
      # アイコンファイル名を取得
      @now_text.sub!(/\[(.*?)\]/, "")
      # アイコンを描画
      @text_sprite.bitmap.blt(@x , @y * line_height + 8, RPG::Cache.icon($1), Rect.new(0, 0, 24, 24))
      @x += 24
    when "\022" # 外字
      # []部分の除去
      @now_text.sub!(/\[([0-9]+)\]/, "")
      # 外字を表示
      @x += draw_gaiji(4 + @x, @y * line_height + (line_height - @text_sprite.bitmap.font.size), $1.to_i)
    when "\031" # \B太字 - Font.bold (排他的論理和での反転)
      @text_sprite.bitmap.font.bold ^= true
    when "\032" # \I斜体 - Font.italic
      @text_sprite.bitmap.font.italic ^= true
      
    # ★
    when "\052"
      # 外字を表示
      heart = RPG::Cache.picture("heart")
      @text_sprite.bitmap.blt(@x + 6 , @y * line_height + 5, heart, Rect.new(0, 0, 16, 16))
      @x += 16
      #@write_wait += 8
      $game_system.speak_se_play
      
      # デバッグ用、横文字数確認
      if $game_temp.in_battle and not $game_temp.battle_actor_command_flag
        if 4 + @x > @text_sprite.bitmap.width and $DEBUG
          Audio.se_play("Audio/SE/069-Animal04", 80, 100)
          print "エラー：この行は横文字数を超過しています。\n文字数：#{(@x/14)-1}/26　横幅：#{4 + @x}/#{@text_sprite.bitmap.width}"
        end
      end

      # 戦闘中ならバックログに外字指定を追加
      $game_temp.battle_back_log += "\H" if $game_temp.in_battle
    when "\050"
      # アイテムアイコンを表示
      @now_text.sub!(/\[([0-9]+)\]/, "")
      ico = $1.to_i
      #装飾品
      if ico > 10000
        ico -= 10000
        bitmap = RPG::Cache.icon($data_armors[ico].icon_name)
        @text_sprite.bitmap.blt(@x, @y * line_height , bitmap, Rect.new(0, 0, 24, 24))
        @x += 24
      #アイテム
      elsif ico > 0
        bitmap = RPG::Cache.icon($data_items[ico].icon_name)
        @text_sprite.bitmap.blt(@x, @y * line_height , bitmap, Rect.new(0, 0, 24, 24))
        @x += 24
      #ラピス
      elsif ico == 0
        bitmap = RPG::Cache.icon("gem_03")
        @text_sprite.bitmap.blt(@x, @y * line_height, bitmap, Rect.new(0, 0, 24, 24))
        @x += 20
      end
      return if bitmap == nil
#      if $game_variables[24] > 0
#        bitmap = RPG::Cache.icon($data_armors[$game_variables[24]].icon_name)
#        $game_variables[24] = 0
#      elsif $data_items[$game_variables[23]] != nil
#        bitmap = RPG::Cache.icon($data_items[$game_variables[23]].icon_name)
#      end
    when "\051" #\\T
      $game_temp.talk_resist_flag_log += "\\T" if $game_temp.in_battle
      if $game_temp.resistgame_swicth == true
        $msg.resist_flag = true
      else
        $msg.resist_flag = false
      end
    when "\053"
      @write_wait += $game_system.battle_speed_time(1)
    when "\n" # [改行処理]
      @y += 1
      @line_index += 1
      line_reset
      # 選択肢ならカーソルの更新
      if @line_index >= $game_temp.choice_start
        @select_window.visible = true
        self.active = true
      end
      # 戦闘中ならバックログに改行指定を追加
      $game_temp.battle_back_log += "\n" if $game_temp.in_battle
    else
      # 文字を描画
      rect = @text_sprite.bitmap.text_size(c)
      @text_sprite.bitmap.draw_text(4 + @x, line_height * @y, rect.width + 4, line_height, c)
      @x += rect.width
      # 戦闘中且つアクターコマンド中以外ならバックログに文字を追加
      if $game_temp.in_battle and not $game_temp.battle_actor_command_flag
        $game_temp.battle_back_log += c 
      end
      
      # デバッグ用、横文字数確認
      if $game_temp.in_battle and not $game_temp.battle_actor_command_flag
        if 4 + @x > @text_sprite.bitmap.width and $DEBUG
          Audio.se_play("Audio/SE/069-Animal04", 80, 100)
          print "エラー：この行は横文字数を超過しています。\n文字数：#{(@x/14)-1}/26　横幅：#{4 + @x}/#{@text_sprite.bitmap.width}"
        end
      end

      # 文字描写のSEを演奏
      unless NOT_SOUND_CHARACTERS.include?(c)
        $game_system.speak_se_play
      end
      # タイプウェイト
      if XRXS9::TYPEWAITS.include?(c)
        if $game_temp.in_battle
          @write_wait += $game_system.battle_speed_time(1) #標準は３
        else
          @write_wait += 1
        end
      end
    end
 
  end
  #--------------------------------------------------------------------------
  # ● ウィンドウの位置と不透明度の設定 [再定義]
  #--------------------------------------------------------------------------
  def reset_window
    if @inforesize
      self.x = INFO_RECT.x
      self.y = INFO_RECT.y
      self.width  = INFO_RECT.width
      self.height = INFO_RECT.height
    elsif self.pop_character != nil and self.pop_character >= 0
      update_reset_window
    else
      self.x = @default_rect.x
      self.y = @default_rect.y
      self.width  = @default_rect.width
      self.height = @default_rect.height
      #
      position = $game_system.message_position
      position = 3 if $game_temp.in_battle
      position = 4 if $game_temp.in_battle_change
      position = 5 if $game_temp.in_menu or $game_temp.in_box
      case position
      when 0 # 上 
        self.y = [16, -NAME_WINDOW_OFFSET_Y + 4].max
      when 1 # 中
        self.y = 192
      when 2 # 下
        self.y = 348
      when 3 # 戦闘中
#        self.y = 348
      when 4 # 戦闘中交代ウィンドウ表示中
        self.y = 192
      when 5 # メニュー中
        self.y = 300
      end
      # 自動リサイズ
      n = [@lines_max, $game_temp.choice_start - 1].min
      if DEFAULT_STRETCH_ENABLE and n >= 5
        # 拡張する差分を計算
        d = @lines_max * line_height + 32 - self.height
        if d > 0
          self.height += d
          case position
          when 1  # 中
            self.y -= d/2
          when 2  # 下
            self.y -= d
          end
        end
      end
      # 背景の位置
      @bgframe_sprite.y = self.y
      #
      @select_window.reset
    end
    if $game_system.messageback_name != ""
      self.opacity = 0
    elsif $game_system.message_frame == 0
      self.back_opacity = DEFAULT_BACK_OPACITY
      @bgframe_sprite.visible = true
      #@name_frame.opacity = DEFAULT_BACK_OPACITY unless @name_frame.nil?
    else
      self.opacity = 0
      @bgframe_sprite.visible = false
      #@name_frame.opacity = 0 unless @name_frame.nil?
    end
    # ビットマップ
    self.contents.dispose
    self.contents = Bitmap.new(self.width - 32, self.height - 32)
    # ポーズサイン位置
    @pause.x = self.x + self.width / 2
    @pause.y = self.y + self.height - 36
  end
  #--------------------------------------------------------------------------
  # ○ ウィンドウの位置と不透明度の設定 (キャラポップ)
  #--------------------------------------------------------------------------
  def update_reset_window
    #
    # 「キャラポップ」
    #
    if self.pop_character == 0 or $game_map.events[self.pop_character] != nil
      character = get_character(self.pop_character)
      # [X座標]
      n = self.width / 2
      n = [n, @name_skin.width + 16].max if @current_name != nil
      x = character.screen_x - n
      # [Y座標]
      case $game_system.message_position
      when 0
        y  = character.screen_y - CHARPOP_HEIGHT - self.height
      else
        y = character.screen_y + 16
      end
      # [範囲による補正]
      if $game_system.limit_right != nil
        x_max = character.screen_x + 32 * ($game_system.limit_right - character.x) - 16
      else
        x_max = 640
      end
      x_max = x_max - 4 - self.width 
      y_max = 476 - self.height
      x_min = 4
      y_min = 4 + (@name_skin.height - NAME_WINDOW_OFFSET_Y)
      self.x = [[x, x_max].min, x_min].max
      self.y = [[y, y_max].min, y_min].max
      # [ネームフレーム連動]
      if  @name_frame != nil
        @name_frame.x = self.x + NAME_WINDOW_OFFSET_X
        @name_frame.y = self.y + NAME_WINDOW_OFFSET_Y - @name_frame.bitmap.height
      end
    end
    # ポーズサイン位置
    @pause.x = self.x + self.width  - 16
    @pause.y = self.y + self.height - 16
  end
  #--------------------------------------------------------------------------
  # ○ カーソルの矩形更新 [オーバーライド]
  #--------------------------------------------------------------------------
  def update_cursor_rect
    if @index >= 0
      n = $game_temp.choice_start + @index
      self.cursor_rect.set(0 + @indent, n * line_height - 8, @cursor_width, line_height)
    else
      self.cursor_rect.empty
    end
  end
  #--------------------------------------------------------------------------
  # ○ キャラクターの取得
  #     parameter : パラメータ
  #--------------------------------------------------------------------------
  def get_character(parameter)
    # パラメータで分岐
    case parameter
    when 0  # プレイヤー
      return $game_player
    else  # 特定のイベント
      events = $game_map.events
      return events == nil ? nil : events[parameter]
    end
  end
  #--------------------------------------------------------------------------
  # 現在、タイピングスキップが可能か？
  #--------------------------------------------------------------------------
  def skippable_now?
    return false if $game_switches[TELOP_SWITCH_ID]
    return ((SKIP_BAN_SWITCH_ID == 0 ? true : !$game_switches[SKIP_BAN_SWITCH_ID]) and 
       (HISKIP_ENABLE_SWITCH_ID == 0 ? true : $game_switches[HISKIP_ENABLE_SWITCH_ID]))
  end
  #--------------------------------------------------------------------------
  # 現在、高速連続メッセージスキップを使用可能か？
  #--------------------------------------------------------------------------
  def hispeed_skippable_now?
    return false if $game_switches[TELOP_SWITCH_ID]
    return (HISKIP_ENABLE_SWITCH_ID == 0 ? true : $game_switches[HISKIP_ENABLE_SWITCH_ID])
  end
  #--------------------------------------------------------------------------
  # ○ 可視状態
  #--------------------------------------------------------------------------
  def visible=(b)
    @name_frame.visible = b unless @name_frame.nil?
    @input_number_window.visible  = b unless @input_number_window.nil?
    super
  end
  #--------------------------------------------------------------------------
  # メソッド テンプレート
  #--------------------------------------------------------------------------
  def process_ruby
  end
  def draw_gaiji(x, y, num)
  end
  def convart_value(option, index)
  end
  #--------------------------------------------------------------------------
  # インデックスの同期
  #--------------------------------------------------------------------------
  def index=(n)
    @select_window.index = n
    super
  end
  #--------------------------------------------------------------------------
  # インデックスの同期
  #--------------------------------------------------------------------------
  def pause_terminate
    @pause.visible = false
  end
end
#==============================================================================
# □ Window_Copy
#------------------------------------------------------------------------------
#   指定のウィンドウのコピーを作成します。
#==============================================================================
class Window_Copy < Window_Base
  #--------------------------------------------------------------------------
  # ○ オブジェクト初期化
  #--------------------------------------------------------------------------
  def initialize(window)
    super(window.x, window.y, window.width, window.height)
    self.contents = window.contents.dup unless window.contents.nil?
    self.opacity = window.opacity
    self.back_opacity = window.back_opacity
    self.z = window.z - 3
  end
end
#==============================================================================
# □ Sprite_Copy
#------------------------------------------------------------------------------
#   指定のスプライトのコピーを作成します。
#==============================================================================
class Sprite_Copy < Sprite
  #--------------------------------------------------------------------------
  # ○ オブジェクト初期化
  #--------------------------------------------------------------------------
  def initialize(sprite)
    super()
    self.bitmap = sprite.bitmap.dup unless sprite.bitmap.nil?
    self.opacity = sprite.opacity
    self.x = sprite.x
    self.y = sprite.y
    self.z = sprite.z - 3
    self.ox = sprite.ox
    self.oy = sprite.oy
  end
end
#==============================================================================
# ■ Interpreter
#==============================================================================
class Interpreter
  #--------------------------------------------------------------------------
  # ● 文章の表示
  #--------------------------------------------------------------------------
  def command_101
    # ほかの文章が message_text に設定済みの場合
    if $game_temp.message_text != nil
      # 終了
      return false
    end
    # メッセージ終了待機中フラグおよびコールバックを設定
    @message_waiting = true
    $game_temp.message_proc = Proc.new { @message_waiting = false }
    # message_text に 1 行目を設定
    $game_temp.message_text = @list[@index].parameters[0] + "\n"
    line_count = 1
    # ループ
    loop do
      # 次のイベントコマンドが文章 2 行目以降の場合
      if @list[@index+1].code == 401
        # message_text に 2 行目以降を追加
        $game_temp.message_text += @list[@index+1].parameters[0] + "\n"
        line_count += 1
      # イベントコマンドが文章 2 行目以降ではない場合
      else
        # 次のイベントコマンドが文章の表示の場合
        if @list[@index+1].code == 101
          if (/\\next\Z/.match($game_temp.message_text)) != nil
            $game_temp.message_text.gsub!(/\\next/) { "" }
            $game_temp.message_text += @list[@index+1].parameters[0] + "\n"
            # インデックスを進める
            @index += 1
            next
          end
        # 次のイベントコマンドが選択肢の表示の場合
        elsif @list[@index+1].code == 102
          #x# 選択肢が画面に収まる場合
          # if @list[@index+1].parameters[0].size <= 4 - line_count
          #end
          # インデックスを進める
          @index += 1
          # 選択肢のセットアップ
          $game_temp.choice_start = line_count
          setup_choices(@list[@index].parameters)
        # 次のイベントコマンドが数値入力の処理の場合
        elsif @list[@index+1].code == 103
          # 数値入力ウィンドウが画面に収まる場合
          if line_count < 4
            # インデックスを進める
            @index += 1
            # 数値入力のセットアップ
            $game_temp.num_input_start = line_count
            $game_temp.num_input_variable_id = @list[@index].parameters[0]
            $game_temp.num_input_digits_max = @list[@index].parameters[1]
          end
        end
        # 継続
        return true
      end
      # インデックスを進める
      @index += 1
    end
  end
end
#==============================================================================
# --- メッセージ中移動許可 ---
#==============================================================================
class Game_Player < Game_Character
  attr_accessor :messaging_moving
end