#==============================================================================
# ■ Window_BattleLog
#------------------------------------------------------------------------------
# 　戦闘中のメッセージ表示用ウィンドウです。(Window_Messageを元手にしてます)
#
#   ※目安として、全角文字20字×4行。
#
#==============================================================================
class Window_BattleLog < Window_Base
  #--------------------------------------------------------------------------
  # ● 公開インスタンス変数
  #--------------------------------------------------------------------------
    attr_accessor   :bgframe_sprite         # バトルログのウィンドウ画像
    attr_accessor   :wait_count             # ウェイトカウント
    attr_accessor   :keep_flag              # キープフラグ
    attr_accessor   :clear_flag             # クリアフラグ
    attr_accessor   :last_x                 # 最終取得Ｘ座標
    attr_accessor   :last_y                 # 最終取得Ｙ座標
    attr_accessor   :stay_flag              # 維持フラグ
    attr_accessor   :pause                  # 維持フラグ
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  def initialize
    #super(100, 280, 540, 150)
    super(100, 280, 418, 150)
    @bgframe_sprite = Sprite.new
    @bgframe_sprite.x = 0
    @bgframe_sprite.y = -12
    @bgframe_sprite.z = 1
    @wait_count = 0
    @keep_flag = false
    @clear_flag = false
    @last_x = 0
    @last_y = 0
    self.contents = Bitmap.new(width - 32, height - 32)
    self.opacity = 0
    self.visible = false
    bitmap = RPG::Cache.windowskin($game_system.battlelog_back_name)
    @bgframe_sprite.bitmap = bitmap
    @bgframe_sprite.visible = false
    # ポーズサインの作成
    @pause = Sprite_Pause.new
    # ポーズサインの設定
    @pause.visible = false
    # Z座標の設定
    @pause.z = self.z + 1
    # ポーズサイン位置
    @pause.x = self.x + self.width / 2 + 8
    @pause.y = self.y + self.height - 24
    # 停止フラグ
    @stay_flag = false
  end
  #--------------------------------------------------------------------------
  # ● テキスト設定
  #     text  : ウィンドウに表示する文字列(文字入りの配列ごと渡してもOK)
  #     align : アラインメント (0..左揃え、1..中央揃え、2..右揃え)
  #--------------------------------------------------------------------------
  def refresh
    text = $game_temp.battle_log_text
    
    #p $game_temp.battle_log_text
    
    
    
    
=begin
      # ログ矯正
      if ["\067\067","\067\065\067","\067\066\067","\067\y\067"].include?($game_temp.battle_back_log)
        $game_temp.battle_back_log += "CLEAR"
        $game_temp.battle_back_log.gsub!("\067CLEAR","")
      elsif $game_temp.battle_back_log == "\n"
        $game_temp.battle_back_log = ""
      end
=end
    
    
=begin
    # マニュアルモードは末尾に\067をつける
    if $game_system.system_read_mode == 0
      text += "CHECK"
      if text.match("\065\067CHECK")
        text.gsub!("CHECK","")
      else
        text.gsub!("CHECK","\065\067")
      end
    end
=end

=begin    
    # ログ矯正
    if ["\n","\067"].include?(text)
      $game_temp.battle_log_text = ""
      return
    end
=end
    # キープ中なら最後に取得した座標を読み込み
    if @keep_flag == true
      x = @last_x
      y = @last_y
      @keep_flag = false
    else
      # キープしてない時は座標をクリア
      x = y = 0
      # バックログに改行指定を追加
      $game_temp.battle_back_log += "\n"
    end

    # 制御文字処理
    begin
      last_text = text.clone
      text.gsub!(/\\[Vv]\[([0-9]+)\]/) { $game_variables[$1.to_i] }
    end until text == last_text
    text.gsub!(/\\[Nn]\[([0-9]+)\]/) do
      $game_actors[$1.to_i] != nil ? $game_actors[$1.to_i].name : ""
    end
    # 便宜上、"\\\\" を "\000" に変換
    text.gsub!(/\\\\/) { "\000" }
    # "\\C" を "\001" に、"\\G" を "\002" に変換
    text.gsub!(/\\[Cc]\[([0-9]+)\]/) { "\001[#{$1}]" }
    text.gsub!(/\\[Gg]/) { "\002" }
    # c に 1 文字を取得 (文字が取得できなくなるまでループ)
    while ((c = text.slice!(/./m)) != nil)
      # \\ の場合
      if c == "\000"
        # 本来の文字に戻す
        c = "\\"
      end
      # \C[n] の場合
      if c == "\001"
        # 文字色を変更
        text.sub!(/\[([0-9]+)\]/, "")
        color = $1.to_i
        if color >= 0 and color <= 7
          self.contents.font.color = text_color(color)
        end
        # 次の文字へ
        next
      end
      if c == "\H"
        heart = RPG::Cache.picture("heart")
        self.contents.blt(x + 6 , 24 * y + 10, heart, Rect.new(0, 0, 16, 16))
        x += 16
        # 次の文字へ
        next
      end
      # ウェイト文字(長時間)の場合
      if c == "\065"
        # ウェイトを入れる
        case $game_system.ms_skip_mode
        when 3 #手動送りモード
          @wait_count = 1
        when 2 #デバッグモード
          @wait_count = 3
        when 1 #快速モード
          @wait_count = 4
        else
          @wait_count = ($game_system.battle_speed_time(1) * 3)
        end
        $game_temp.battle_log_wait_flag = true
        # 今の座標を維持して返す
        @keep_flag = true
        @last_x = x
        @last_y = y
        return
      end
      # ウェイト文字(短時間)の場合
      if c == "\066"
        # ウェイトを入れる
        case $game_system.ms_skip_mode
        when 3 #手動送りモード
          @wait_count = 1
        when 2 #デバッグモード
          @wait_count = 1
        when 1 #快速モード
          @wait_count = 2
        else
          @wait_count = $game_system.battle_speed_time(1)
        end
        $game_temp.battle_log_wait_flag = true
        # 今の座標を維持して返す
        @keep_flag = true
        @last_x = x
        @last_y = y
        return
      end
      # ウェイト文字(システム)の場合
      #if c == "\y"
      #  # ウェイトを入れる
      #  case $game_system.ms_skip_mode
      #  when 3 #手動送りモード
      #    @wait_count = 1
      #  when 2 #デバッグモード
      #    @wait_count = 8
      #  when 1 #快速モード
      #    @wait_count = 12
      #  else
      #    @wait_count = $game_system.battle_speed_time(0)
      #  end
      #  $game_temp.battle_log_wait_flag = true
      #  # 今の座標を維持して返す
      #  @keep_flag = true
      #  @last_x = x
      #  @last_y = y
      #  return
      #end
      # 改行文字の場合
      if c == "\n"
        # y に 1 を加算
        y += 1
        x = 0
        @keep_flag = true
        @last_x = x
        @last_y = y
        # バックログに改行指定を追加
        $game_temp.battle_back_log += "\n"
        # ログがいっぱいならクリアフラグを入れて返す
        if y > 3 #and text != ""
#          if Input.trigger?(Input::C)
            @clear_flag = true
            $game_temp.battle_log_wait_flag = true
            @keep_flag = false
            #★手動送りの場合のみステイフラグを入れる
            if $game_system.system_read_mode == 0
              @stay_flag = true
            end
            case $game_system.ms_skip_mode
            when 3 #手動送りモード
              @wait_count = 4
            when 2 #デバッグモード
              @wait_count = 8
            when 1 #快速モード
              @wait_count = 12
            else
              @wait_count = $game_system.battle_speed_time(0) + $game_system.important_wait_time
            end
#          end
          return
        end
        # 次の文字へ
        next
      end
      # 手動改行文字の場合
      if c == "\067"
        # y に 1 を加算
        y += 1
        x = 0
        @keep_flag = true
        @last_x = x
        @last_y = y
        #★手動送りの場合のみステイフラグを入れる
        if $game_system.system_read_mode == 0
          @stay_flag = true
          @wait_count = 1
        end
        # バックログに改行指定を追加
        $game_temp.battle_back_log += "\n"
        # ログがいっぱいならクリアフラグを入れて返す
        if y > 3 #and text != ""
#          if Input.trigger?(Input::C)
            @clear_flag = true
            $game_temp.battle_log_wait_flag = true
            @keep_flag = false
            case $game_system.ms_skip_mode
            when 3 #手動送りモード
              @wait_count = 4
            when 2 #デバッグモード
              @wait_count = 8
            when 1 #快速モード
              @wait_count = 12
            else
              @wait_count = $game_system.battle_speed_time(0) + $game_system.important_wait_time
            end
#          end
          return
#        elsif y > 3 and text == ""
#          @stay_flag = false
        end
        # 次の文字へ
        if $game_system.system_read_mode == 0
          return
        else
          next
        end
      end
      # 文字を描画
#      self.contents.font.name = ["メイリオ"]
      self.contents.draw_text(4 + x, 24 * y, 40, 32, c)
      # x に描画した文字の幅を加算
      x += self.contents.text_size(c).width #+ 2
      # デバッグ用、横文字数確認
      if 4 + x > self.contents.width and $DEBUG
        Audio.se_play("Audio/SE/069-Animal04", 80, 100)
        print "エラー：この行は横文字数を超過しています。\n文字数：#{(x/14)-1}/26　横幅：#{4 + x}/#{self.contents.width}"
      end
      # バックログに文字を追加
      $game_temp.battle_back_log += c
    end
   self.visible = true
   @bgframe_sprite.visible = true

   
   
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新
  #--------------------------------------------------------------------------
  def update
    # 出現処理
    if @bgframe_sprite.opacity < 255
      @bgframe_sprite.opacity += 51
    end
    if @bgframe_sprite.y > -20
      @bgframe_sprite.y -= 1
      return
    end
    
    # ステイフラグが立っている場合且つ、マニュアルモード時のみ停止状態にする
    if @stay_flag
      @wait_count = 2
      $game_temp.battle_log_wait_flag = true
      @pause.visible = true
    end

    # ポーズサイン
    @pause.update if @pause.visible

    if Input.trigger?(Input::C)
      @wait_count = 1
      if @stay_flag
        $game_temp.battle_log_wait_flag = false
        @stay_flag = false
        @pause.visible = false
      end
    end

    if @stay_flag and $game_system.system_read_mode != 0
      $game_temp.battle_log_wait_flag = false
      @stay_flag = false
      @pause.visible = false
      @wait_count = 1 if @wait_count == 0
    end
    
    if @wait_count > 0
      @wait_count -= 1
      if @wait_count == 0 and @clear_flag == true
        self.contents.clear
        @keep_flag = false
        @clear_flag = false
      end
      return
    end
    
    # ログ矯正
    if $game_temp.battle_log_text != ""
      log_correction 
    end
    
    # メッセージがあればリフレッシュ
    if $game_temp.battle_log_text != ""
      if $game_temp.battle_log_text == "\n"
        $game_temp.battle_log_text = ""
        return
      end
      refresh
    end
  end
  #--------------------------------------------------------------------------
  # ● ログ矯正
  #--------------------------------------------------------------------------
  def log_correction

    # ウェイトの順序を直す
    $game_temp.battle_log_text.gsub!("\n\065","\065\n")
    $game_temp.battle_log_text.gsub!("\067\065","\065\067")
    
    # 改行が重複している場合、１つにする
    $game_temp.battle_log_text.gsub!(/(\\065\\n)+/,"\065\n")
    $game_temp.battle_log_text.gsub!(/(\\065\\067)+/,"\065\067")
    
    # \065\n・\065\067だけの場合、テキストを消す
    if ["\065\n","\065\067"].include?($game_temp.battle_log_text)
      $game_temp.battle_log_text = ""
    end

  end
  #--------------------------------------------------------------------------
  # ● 解放
  #--------------------------------------------------------------------------
  def dispose
    super
    @bgframe_sprite.dispose
    # ポーズサイン
    @pause.dispose
  end
end
#==============================================================================
# メッセージ背景
#==============================================================================
class Game_System
  attr_accessor :battlelog_back_name
  def battlelog_back_name
    return @battlelog_back_name.nil? ? "battle_message" : @battlelog_back_name
  end
end
