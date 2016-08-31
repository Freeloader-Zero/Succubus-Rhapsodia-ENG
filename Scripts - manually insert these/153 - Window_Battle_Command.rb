#==============================================================================
# ★ Window_BoxLeft
#------------------------------------------------------------------------------
# 　ボックス画面で、預けられている夢魔の名前を表示するウィンドウ。
#==============================================================================

class Window_Battle_Command < Window_Base
  #--------------------------------------------------------------------------
  # ● 公開インスタンス変数
  #--------------------------------------------------------------------------
  attr_accessor   :index                    # カーソル位置
  attr_accessor   :window                   # 後ろ帯
  attr_accessor   :skill                    # スキル
  attr_accessor   :item                     # アイテム
  attr_accessor   :change                   # パーティ交代
  attr_accessor   :escape                   # 逃走
  attr_accessor   :help                     # コマンド解説
  attr_accessor   :fade_flag                # フェード用
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  def initialize
    super(0, 300, 640, 100)
    self.opacity = 0
    self.active = false
    self.visible = false
    @index = 0
    @fade_flag = 0
    
    # 後ろ帯
    @window = Sprite.new
    @window.y = -12
    @window.z = 4
    @window.bitmap = RPG::Cache.windowskin("command_window")
    @window.opacity = 51
    # スキル
    @skill = Sprite.new
    @skill.y = -20
    @skill.z = 4
    @skill.bitmap = RPG::Cache.windowskin("command_skill")
    @skill.opacity = 100
    # アイテム
    @item = Sprite.new
    @item.y = -20
    @item.z = 4
    @item.bitmap = RPG::Cache.windowskin("command_item")
    @item.opacity = 100
    # パーティ交代
    @change = Sprite.new
    @change.y = -20
    @change.z = 4
    @change.bitmap = RPG::Cache.windowskin("command_change")
    @change.opacity = 100
    # 逃走
    @escape = Sprite.new
    @escape.y = -20
    @escape.z = 4
    @escape.bitmap = RPG::Cache.windowskin("command_escape")
    @escape.opacity = 100
    # コマンド解説
    @help = Sprite.new
    @help.x = 220
    @help.y = 390
    @help.z = 100
    @help.bitmap = Bitmap.new(300, 200)
    @help.bitmap.font.size = $default_size_mini
  end
  #--------------------------------------------------------------------------
  # ● リフレッシュ
  #--------------------------------------------------------------------------
  def refresh
    if @help.bitmap != nil
      @help.bitmap.clear
    end
    x = 0
    y = 0
    case self.index
    when 0 # スキル
      @skill.opacity = 255
      @item.opacity = 100
      @change.opacity = 100
      @escape.opacity = 100
      @help.bitmap.draw_text(x, y, 200, 30, "Use a technique", 1) 
    when 1 # アイテム
      @skill.opacity = 100
      @item.opacity = 255
      @change.opacity = 100
      @escape.opacity = 100
      @help.bitmap.draw_text(x, y, 200, 30, "Use an item", 1) 
    when 2 # パーティ交代
      @skill.opacity = 100
      @item.opacity = 100
      @change.opacity = 255
      @escape.opacity = 100
      @help.bitmap.draw_text(x, y, 200, 30, "Switch partner", 1) 
    when 3 # 逃走
      @skill.opacity = 100
      @item.opacity = 100
      @change.opacity = 100
      @escape.opacity = 255
      @help.bitmap.draw_text(x, y, 200, 30, "Run away", 1) 
    end
  end
  #--------------------------------------------------------------------------
  # ● ポーズ用一時出現/隠し
  #--------------------------------------------------------------------------
  def hide
    for i in [@window,@skill,@item,@change,@escape,help]
      i.visible = false
    end
  end
  def appear
    for i in [@window,@skill,@item,@change,@escape,help]
      i.visible = true
    end
  end
  #--------------------------------------------------------------------------
  # ● フェード
  #--------------------------------------------------------------------------
  def fade
    
    case @fade_flag
    when 1 # フェードイン
      # 出現処理
      if @window.opacity < 255
        @window.opacity += 51
      end
      if @window.y > -20
        @window.y -= 1
      end
      @fade_flag = 0 if window.y == -20
    when 2 # フェードアウト
    end
    
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新
  #--------------------------------------------------------------------------
  def update
    
    if @fade_flag > 0
      fade
      return 
    end
    if self.active == true
      # メッセージ表示中の場合はボックス操作をロック
      if $game_temp.message_window_showing
        return
      end
      # 右ボタンが押された場合
      if Input.repeat?(Input::RIGHT)
        # SE を演奏
        Audio.se_play("Audio/SE/005-System05", 80, 100)
        if @index == 3
          @index = 0
        else
          @index += 1
        end
        refresh
      end
      # 左ボタンが押された場合
      if Input.repeat?(Input::LEFT)
        # SE を演奏
        Audio.se_play("Audio/SE/005-System05", 80, 100)
        if @index == 0
          @index = 3
        else
          @index -= 1
        end
        refresh
      end
    end
  end
end
