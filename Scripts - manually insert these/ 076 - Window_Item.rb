#==============================================================================
# ■ Window_Item
#------------------------------------------------------------------------------
# 　アイテム画面、バトル画面で、所持アイテムの一覧を表示するウィンドウです。
#==============================================================================

class Window_Item < Window_Selectable
  #--------------------------------------------------------------------------
  # ● 公開インスタンス変数
  #--------------------------------------------------------------------------
  attr_accessor   :window                   # 後ろ帯
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  def initialize
    # 戦闘中の場合はウィンドウを画面中央へ移動し、半透明にする
    unless $game_temp.in_battle
      super(40, 45, 560, 290)
    else
      super(40, 68, 560, 256)
      @window = Sprite.new
      @window.y = 0
      @window.z = 2050
      @window.bitmap = RPG::Cache.windowskin("battle_index")
      @window.opacity = 255
    end
    self.z = 2050
    self.opacity = 0
    @column_max = 2
    refresh
    self.index = 0
  end
  #--------------------------------------------------------------------------
  # ● 表示状態の背景画像との連動
  #--------------------------------------------------------------------------
  def visible=(bool)
    super
    @window.visible = bool if @window != nil
  end
  #--------------------------------------------------------------------------
  # ● アイテムの取得
  #--------------------------------------------------------------------------
  def item
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
    # アイテムを追加
    for i in 1...$data_items.size
      if $game_party.item_number(i) > 0
        if $game_temp.in_battle
          if $data_items[i].occasion == 0 \
           or $data_items[i].occasion == 1
            @data.push($data_items[i])
          end
        else
          @data.push($data_items[i])
        end
      end
    end
    # 戦闘中以外なら武器と防具も追加
    unless $game_temp.in_battle
      for i in 1...$data_weapons.size
        if $game_party.weapon_number(i) > 0
          @data.push($data_weapons[i])
        end
      end
      for i in 1...$data_armors.size
        if $game_party.armor_number(i) > 0
          @data.push($data_armors[i])
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
    item = @data[index]
    case item
    when RPG::Item
      number = $game_party.item_number(item.id)
    when RPG::Weapon
      number = $game_party.weapon_number(item.id)
    when RPG::Armor
      number = $game_party.armor_number(item.id)
    end
    if item.is_a?(RPG::Item) and
       $game_party.item_can_use?(item.id)
      self.contents.font.color = normal_color
    else
      self.contents.font.color = disabled_color
    end
    x = 4 + index % 2 * (248 + 32)
    y = index / 2 * 32
    rect = Rect.new(x, y, self.width / @column_max - 32, 32)
    self.contents.fill_rect(rect, Color.new(0, 0, 0, 0))
    bitmap = RPG::Cache.icon(item.icon_name)
    opacity = self.contents.font.color == normal_color ? 255 : 128
    self.contents.blt(x, y + 4, bitmap, Rect.new(0, 0, 24, 24), opacity)
    self.contents.draw_text(x + 28, y, 204, 32, item.UK_name, 0)
    self.contents.draw_text(x + 192, y, 16, 32, ":", 1)
    self.contents.draw_text(x + 210, y, 24, 32, number.to_s, 2)
  end
  #--------------------------------------------------------------------------
  # ● ヘルプテキスト更新
  #--------------------------------------------------------------------------
  def update_help
    @help_window.set_text(self.item == nil ? "" : self.item.UK_description)
  end
end
