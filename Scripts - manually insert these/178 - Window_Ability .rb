#==============================================================================
# ■ Window_Ability
#------------------------------------------------------------------------------
# 　スキル画面、バトル画面で、使用できるスキルの一覧を表示するウィンドウです。
#==============================================================================

class Window_Ability < Window_Selectable
  #--------------------------------------------------------------------------
  # ● 公開インスタンス変数
  #--------------------------------------------------------------------------
  attr_reader     :data                     # 後ろ帯
  attr_reader     :item_max
  attr_accessor   :window                   # 後ろ帯
  attr_accessor   :actor
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #     actor : アクター
  #--------------------------------------------------------------------------
  def initialize(actor, type = 0)
    # 戦闘中の場合はウィンドウを画面中央へ移動し、半透明にする
    super(90, 76, 460, 258)
    self.z = 2050
    self.opacity = 0
    self.active = false
    @column_max = 2
    @actor = actor
    refresh
    self.index = 0
  end
  #--------------------------------------------------------------------------
  # ● スキルの取得
  #--------------------------------------------------------------------------
  def ability_data
    return @data[self.index]
  end
  #--------------------------------------------------------------------------
  # ● リフレッシュ
  #--------------------------------------------------------------------------
  def refresh
    if self.contents != nil
      self.contents.dispose
      self.contents = nil
    end
    @data = []
    for i in 0...@actor.all_ability.size
      ability = $data_ability[@actor.all_ability[i]]
      if ability != nil
        unless ability.hidden # 非公開素質は除外
          @data.push(ability)
        end
      end
    end
    # 項目数が 0 でなければビットマップを作成し、全項目を描画
    @item_max = @data.size
    if @item_max > 0
      self.contents = Bitmap.new(width - 32, row_max * 32)
      for i in 0...@item_max
        draw_item(i)
      end
    end
  end
  #--------------------------------------------------------------------------
  # ● 項目の描画
  #     index : 項目番号
  #--------------------------------------------------------------------------
  def draw_item(index)
    ability = @data[index]
    self.contents.font.color = normal_color
    self.contents.font.color = text_color(9) if not @actor.have_ability?(ability.id, "ORIGINAL")
    # 戦闘中の場合はウィンドウを画面中央へ移動し、半透明にする
    x = 4 + index % 2 * (198 + 32)
    y = index / 2 * 32
    rect = Rect.new(x, y, self.width / @column_max - 32, 32)
    self.contents.fill_rect(rect, Color.new(0, 0, 0, 0))
    bitmap = RPG::Cache.icon(ability.icon_name)
    opacity = 255
    self.contents.blt(x, y + 4, bitmap, Rect.new(0, 0, 24, 24), opacity)
    self.contents.draw_text(x + 28, y, 204, 32, "【" + ability.UK_name + "】" , 0)
  end
  #--------------------------------------------------------------------------
  # ● ヘルプテキスト更新
  #--------------------------------------------------------------------------
  def update_help
    @help_window.set_text(self.ability_data == nil ? "" : self.ability_data.description)
  end
end
