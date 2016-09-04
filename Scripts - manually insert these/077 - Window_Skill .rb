#==============================================================================
# ■ Window_Skill
#------------------------------------------------------------------------------
# 　スキル画面、バトル画面で、使用できるスキルの一覧を表示するウィンドウです。
#==============================================================================

class Window_Skill < Window_Selectable
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
  def initialize(actor, from_box = false)
    # 戦闘中の場合はウィンドウを画面中央へ移動し、半透明にする
    unless $game_temp.in_battle
      super(40, 76, 560, 258)
      self.z = 2050
    else
      super(40, 68, 560, 256)
      self.z = 2060
      if from_box == false
        @window = Sprite.new
        @window.y = 0
        @window.z = 2050
        @window.bitmap = RPG::Cache.windowskin("battle_index")
        @window.opacity = 255
      end
    end
    self.opacity = 0
    @actor = actor
    @column_max = 2
    @from_box = from_box
    refresh
    self.index = 0    
  end
  #--------------------------------------------------------------------------
  # ● スキルの取得
  #--------------------------------------------------------------------------
  def skill
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
    skill_box = @actor.all_skills

    for i in 0...skill_box.size
      skill = $data_skills[skill_box[i]]
      if skill != nil
        @data.push(skill)
      end
    end
    # スキルソート
    skills_sort
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
    skill = @data[index]
    if @actor.skill_can_use?(skill.id)
      self.contents.font.color = normal_color
      self.contents.font.color = text_color(9) if not @actor.skill_learn?(skill.id, "ORIGINAL")
    else
      self.contents.font.color = disabled_color
      self.contents.font.color = normal_color if @from_box
      self.contents.font.color = text_color(11) if not @actor.skill_learn?(skill.id, "ORIGINAL")
    end    
    x = 4 + index % 2 * (248 + 32)
    y = index / 2 * 32
    rect = Rect.new(x, y, self.width / @column_max - 32, 32)
    self.contents.fill_rect(rect, Color.new(0, 0, 0, 0))
    bitmap = RPG::Cache.icon(skill.icon_name)
    if self.contents.font.color == normal_color or self.contents.font.color == text_color(9)
      opacity = 255
    else 
      opacity = 128
    end
    self.contents.blt(x, y + 4, bitmap, Rect.new(0, 0, 24, 24), opacity)
    self.contents.draw_text(x + 28, y, 204, 32, skill.name, 0)
    if skill.sp_cost != 0
      self.contents.draw_text(x + 178, y, 48, 32, "VP", 0) 
      self.contents.draw_text(x + 184, y, 48, 32, "-" + skill.sp_cost.to_s, 2) 
    end
  end
  #--------------------------------------------------------------------------
  # ● ヘルプテキスト更新
  #--------------------------------------------------------------------------
  def update_help
    @help_window.set_text(self.skill == nil ? "" : self.skill.description)
  end
  #--------------------------------------------------------------------------
  # ● スキルソート
  #--------------------------------------------------------------------------
  def skills_sort
    
    @sort_box = []
    #--------------------------------------------------------------------------
    # ■この順番に配置する
    #--------------------------------------------------------------------------
    # ▽脱衣系
    #--------------------------------------------------------------------------
    # 服を脱がす・服を脱ぐ
    for i in [2,4]
      skills_sort_push(i)
    end
    #--------------------------------------------------------------------------
    # ▽初期アタックスキル
    #--------------------------------------------------------------------------
    # キッス・バスト・ヒップ・クロッチ・カレス
    for i in 81..85
      skills_sort_push(i)
    end
    #--------------------------------------------------------------------------
    # ▽ホールド中専用スキル
    #--------------------------------------------------------------------------
    # リリース・インタラプト・ストラグル含めたホールド専用スキル
    for i in 28..79
      skills_sort_push(i)
    end
    for i in [641,642]
      skills_sort_push(i)
    end
    #--------------------------------------------------------------------------
    # ▽初期サポートスキル+スイートウィスパー
    #--------------------------------------------------------------------------
    # ブレス・ウェイト・トーク・スイートウィスパー
    for i in [121,123,9,418]
      skills_sort_push(i)
    end
    #--------------------------------------------------------------------------
    # ▽ホールドスキル
    #--------------------------------------------------------------------------
    # ホールドスキル
    for i in 5..18
      skills_sort_push(i)
    end
    #--------------------------------------------------------------------------
    # ▽優先アタックスキル
    #--------------------------------------------------------------------------
    # ディバウアー・プライスオブハレム・プライスオブシナー
    for i in [106,362,363]
      skills_sort_push(i)
    end
    #--------------------------------------------------------------------------
    # ▽残ったものを入れる
    #--------------------------------------------------------------------------
    for data_one in @data
      @sort_box.push(data_one) 
    end
    #--------------------------------------------------------------------------
    # nilをすべて消す
    @sort_box.compact!
    # 並び替えしたものを@dataに移す
    @data = @sort_box
    
    
  end
  #--------------------------------------------------------------------------
  # ● スキルソート、入れていくメソッド
  #--------------------------------------------------------------------------
  def skills_sort_push(skill_id)
    if @data.include?($data_skills[skill_id])
      @sort_box.push(@data.delete($data_skills[skill_id])) 
    end
  end
end
