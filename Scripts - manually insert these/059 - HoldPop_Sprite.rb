
class HoldPop_Sprite < RPG::Sprite
  #--------------------------------------------------------------------------
  # ● 公開インスタンス変数
  #--------------------------------------------------------------------------
  attr_accessor :type                  # ホールド種別
  attr_accessor :battler               # 自身
  attr_accessor :target                # 対象バトラー
  attr_accessor :initiative            # イニシアチブ
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  def initialize(type, battler, target)
    super()
    # 引数をインスタンス変数に
    @type   = type
    @battler = battler
    @target = target
    @initiative = 0
    # その他初期化
    @delete_flag = false
    @last_x = -100
    @last_y = -100
    self.opacity = 0
    refresh
  end
  #--------------------------------------------------------------------------
  # ● リフレッシュ
  #--------------------------------------------------------------------------
  def refresh
    # フレーム作成
    graphic = RPG::Cache.windowskin("hold_pop2")
    if @battler.is_a?(Game_Actor)
      graphic = RPG::Cache.windowskin("hold_pop1") if @battler == $game_actors[101]
    end
    if @target.is_a?(Game_Actor)
      graphic = RPG::Cache.windowskin("hold_pop1") if @target == $game_actors[101]
    end
    self.bitmap = Bitmap.new(graphic.width,graphic.height)
    self.bitmap.blt(0, 0, graphic, Rect.new(0, 0, graphic.width, graphic.height), 200)
    
    # ホールド名の描写
    case @type
    when "♀挿入"
      hold_name = "インサート"
    when "貝合わせ"
      hold_name = "シェルマッチ"
    when "口挿入"
      hold_name = "オーラルインサート"
    when "クンニ"
      hold_name = "ドロウネクター"
    when "顔面騎乗"
      hold_name = "エキサイトビュー"
    when "尻騎乗"
      hold_name = "インモラルビュー"
    when "拘束"
      hold_name = "エンブレイス"
    when "開脚"
      hold_name = "エキシビジョン"
    when "パイズリ"
      hold_name = "ペリスコープ"
    when "ディルド♀挿入"
      hold_name = "ディルドインサート"
    when "ディルド口挿入"
      hold_name = "ディルドインマウス"
    when "ディルド尻挿入"
      hold_name = "ディルドインバック"
    when "蔦拘束"
      hold_name = "アイヴィクローズ"
    when "触手拘束"
      hold_name = "デモンズクローズ"
    when "触手吸引"
      hold_name = "デモンズアブソーブ"
    when "触手クンニ"
      hold_name = "デモンズドロウ"
    else
      hold_name = @type
    end
    # 逆転不可のホールドは文字を黄色くする
    unless SR_Util.reversible_hold?(@type)
      self.bitmap.font.color = Color.new(255, 255, 128, 255)
    end
    self.bitmap.font.size = $default_size_s_mini
    self.bitmap.draw_text(0, 0, self.bitmap.width , self.bitmap.height, hold_name, 1)

    # 位置調整
    self.x = @last_x = -100
    self.y = @last_y = -100
    self.ox = self.bitmap.width / 2
    self.oy = self.bitmap.height / 2
    self.z = 1500
  end
  
  #--------------------------------------------------------------------------
  # ● イニシアチブの変更
  #-------------------------------------------------------------------------- 
  def initiative_change(number)
    @initiative += number
    refresh
  end
  #--------------------------------------------------------------------------
  # ● ホールド消去
  #-------------------------------------------------------------------------- 
  def hold_delete
    @delete_flag = true
  end
  #--------------------------------------------------------------------------
  # ● ホールド消した？
  #-------------------------------------------------------------------------- 
  def delete?
    return @delete_flag
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新
  #-------------------------------------------------------------------------- 
  def update
    super
  end
  
end