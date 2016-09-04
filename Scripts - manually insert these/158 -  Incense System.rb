#==============================================================================
# ■ Incense_System
#------------------------------------------------------------------------------
# 　インセンス
#==============================================================================

class Incense
  #--------------------------------------------------------------------------
  # ● 公開インスタンス変数
  #--------------------------------------------------------------------------
  attr_accessor :name                        # 名前
  attr_accessor :remaining_turn              # 残りターン
  attr_accessor :start_text                  # 開始テキスト
  attr_accessor :fragranting_text            # 継続中テキスト
  attr_accessor :end_text                    # 終了テキスト
  # ステータス補正
  attr_accessor :atk_rate
  attr_accessor :pdef_rate
  attr_accessor :str_rate                    
  attr_accessor :dex_rate                     
  attr_accessor :agi_rate
  attr_accessor :int_rate
  attr_accessor :plus_rate
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  def initialize(incense_name)
    
    @name = incense_name
    @remaining_turn = 5
    @start_text       = ""
    @fragranting_text = ""
    @end_text         = ""
    @plus_rate = [0,0,0,0,0,0]
    
    @atk_rate  = 100
    @pdef_rate = 100
    @str_rate  = 100
    @dex_rate  = 100
    @agi_rate  = 100
    @int_rate  = 100
    
    actors_word  = "味方"
    enemies_word = "味方" # 後で改変する
    field_word   = "周囲"
    brk_word   = "brk"
    
    case incense_name
    
    #--------------------------------------------------------------------------
    # 自陣効果
    #-------------------------------------------------------------------|------
    when "リラックスタイム" # 〆
      @start_text       = "#{actors_word}に安息の時が訪れた！"
      @fragranting_text = "#{actors_word}に安息の時が流れている……！"
      @end_text         = "#{actors_word}の安息の時が終わった！"
      # 毎ターン終了時に小回復
    #-------------------------------------------------------------------|------
    when "スイートアロマ" # 〆
#      @start_text       = "#{actors_word}に甘い香りが立ち込めた！"
      @start_text       = "#{actors_word}の魅力が上昇した！"
      @fragranting_text = "#{actors_word}は甘い香りに包まれている……！"
      @end_text         = "#{actors_word}から甘い香りが薄れた！"
      @plus_rate[0] = 50
      @atk_rate  = 150
      # 魅力強化
    #-------------------------------------------------------------------|------
    when "パッションビート" # 〆
#      @start_text       = "#{actors_word}のやる気が高まった！"
      @start_text       = "#{actors_word}の精力と素早さが上昇した！"
      @fragranting_text = "#{actors_word}のやる気は高まっている……！"
      @end_text         = "#{actors_word}のやる気が落ち着いた！"
      @plus_rate[2] = 130
      @plus_rate[4] = 130
      # 精力、素早さ強化
    #-------------------------------------------------------------------|------
    when "マイルドパフューム" # 〆
#      @start_text       = "#{actors_word}に柔かな香りが立ち込める！"
      @start_text       = "#{actors_word}は状態異常に強くなった！"
      @fragranting_text = "#{actors_word}は柔かな香りを纏っている……！"
      @end_text         = "#{actors_word}から柔かな香りが薄れた！"
      # バステ耐性値増加
    #-------------------------------------------------------------------|------
    when "レッドカーペット" # 〆
      @start_text       = "#{actors_word}は仲間の出番の準備を整えた！"
      @fragranting_text = "#{actors_word}は#{brk_word}仲間の出番の準備が整っている！"
      @end_text         = "#{actors_word}の#{brk_word}レッドカーペットが無くなった！"
      # 交代で出てきた夢魔の魅力・素早さ強化
    #-------------------------------------------------------------------|------
    when "安穏の時" # （没）
      @fragranting_text = "#{actors_word}は身体を休めている……！"
      # 回復量アップ
    #-------------------------------------------------------------------|------

#      @start_text       = "#{field_word}に官能的な香りが立ち込める！"
    #--------------------------------------------------------------------------
    # 敵陣効果
    #--------------------------------------------------------------------|------
    when "ストレンジスポア" # 〆
#      @start_text       = "#{enemies_word}に奇妙な胞子が漂い始めた！"
      @start_text       = "#{enemies_word}は状態異常に弱くなった！"
      @fragranting_text = "#{enemies_word}に奇妙な胞子が漂っている……！"
      @end_text         = "#{enemies_word}に漂う奇妙な胞子が無くなった！"
      # バステ耐性値減少
    #--------------------------------------------------------------------|------
    when "ウィークスポア" # 〆
#      @start_text       = "#{enemies_word}に暗い胞子が漂い始めた！"
      @start_text       = "#{enemies_word}に薄暗く胞子が漂い始めた！"
      @fragranting_text = "#{enemies_word}に薄暗く胞子が漂っている……！"
      @end_text         = "#{enemies_word}に薄暗く漂う胞子が無くなった！"
      # 状態異常時、被ＳＳ率アップ。
    #--------------------------------------------------------------------|------
    when "戦慄き" # （没）
      @fragranting_text = "#{enemies_word}は緊張感に包まれている……！"
      # 畏怖時、精神力が1/2になる
    #--------------------------------------------------------------------|------
    when "威迫" # 〆
#      @start_text       = "#{enemies_word}は威迫されてしまった！"
      @start_text       = "#{enemies_word}はレジストに弱くなった！"
      @fragranting_text = "#{enemies_word}は威迫されている……！"
      @end_text         = "#{enemies_word}の威迫の効果が無くなった！"
      # レジスト難易度増加
    #--------------------------------------------------------------------|------
    when "心掴み" # 〆
      @start_text       = "#{enemies_word}は逃げられなくなった！"
      @fragranting_text = "#{enemies_word}は後ろ髪を引かれている！"
      @end_text         = "#{enemies_word}の心掴みの効果が無くなった！"
      # 逃げられない。
    #--------------------------------------------------------------------|----
    when "全ては現" # 〆
      @start_text       = "#{enemies_word}の感覚が急激に鮮明になる！"
      @fragranting_text = "#{enemies_word}の感覚が鮮明になっている……！"
      @end_text         = "#{enemies_word}の鮮明さが弱まった！"
      # 被ＳＳ率アップ
    #--------------------------------------------------------------------|------
      
    # 全体効果
    #-------------------------------------------------------------------------
    when "ラブフレグランス" # 〆
      @start_text       = "#{field_word}に官能的な香りが立ち込める！"
      @fragranting_text = "#{field_word}は官能的な香りに包まれている……！"
      @end_text         = "#{field_word}から官能的な香りが薄れた！"
      # 毎ターン開始時にムードアップ
    #-------------------------------------------------------------------------
    when "スライムフィールド" # 〆
      @start_text       = "#{field_word}に粘液が広がった！"
      @fragranting_text = "#{field_word}は粘液が広がっている……！"
      @end_text         = "#{field_word}に広がっていた粘液が無くなった！"
      # 攻撃で上昇する潤滑度量が上がる
    #--------------------------------------------------------------------------
    
    # それ以外は名前をリセットし、後でこれまるごと消してもらう
    else 
      @name = ""
    end
  end
end

class Incense_System
  #--------------------------------------------------------------------------
  # ● 公開インスタンス変数
  #--------------------------------------------------------------------------
  attr_accessor :data
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  def initialize
    @data = [[],[],[]]
  end
  #--------------------------------------------------------------------------
  # ● ステータス補正数値
  #--------------------------------------------------------------------------
  def inc_adjusted_value(battler, type)
    n = 0
    value = 100
    n = 0 if battler.is_a?(Game_Actor)
    n = 1 if battler.is_a?(Game_Enemy)
    n = battler if battler.is_a?(Integer)
    for i in [n, 2].uinq!
      for inc_one in @data[n]
        value += inc_one.plus_rate[type]
      end
    end
    return value
  end
  #--------------------------------------------------------------------------
  # ● このインセンスがあるか？
  #--------------------------------------------------------------------------
  def actors_inc
    return @data[0][0]
  end
  def enemies_inc
    return @data[1][0]
  end
  def all_inc
    return @data[2][0]
  end
  #--------------------------------------------------------------------------
  # ● このインセンスがあるか
  #--------------------------------------------------------------------------
  def exist?(name, battler)
    result = false
    n = 0
    n = 0 if battler.is_a?(Game_Actor)
    n = 1 if battler.is_a?(Game_Enemy)
    n = battler if battler.is_a?(Integer)
    for i in [n, 2].uinq!
      for incense in @data[i]
        result = true if incense.name == name
      end
    end
    return result 
  end
  #--------------------------------------------------------------------------
  # ● 使用者と発生源からインセンスを追加する
  #--------------------------------------------------------------------------
  def use_incense(user, val)
    result = false
    # valがスキルもしくはアイテムでない場合終了
    unless val.is_a?(RPG::Skill) or val.is_a?(RPG::Item)
      return false
    end
    # 効果範囲から適切な箇所に追加
    case val.scope
    when 2 # 敵全体　→敵軍
      result = add_incense(val.name, 1) if user.is_a?(Game_Actor)
      result = add_incense(val.name, 0) if user.is_a?(Game_Enemy)
    when 4 # 味方全体　→自軍
      result = add_incense(val.name, 0) if user.is_a?(Game_Actor)
      result = add_incense(val.name, 1) if user.is_a?(Game_Enemy)
    when 7 # 使用者　→全体
      result = add_incense(val.name, 2)
    end
    return result
  end
  #--------------------------------------------------------------------------
  # ● インセンスを追加
  #--------------------------------------------------------------------------
  def add_incense(name, box_number)
    # すでにある場合は終了
    return false if exist?(name, box_number)
    # インセンスの追加
    @data[box_number].push(Incense.new(name))
    # 設定されていないインセンスの場合、削除する
    if @data[box_number][@data[box_number].size - 1].name == ""
      @data[box_number].delete(@data[box_number][@data[box_number].size - 1])
      return false
    end
    add_text(name, box_number)
    return true
  end
  #--------------------------------------------------------------------------
  # ● インセンスを削除
  #--------------------------------------------------------------------------
  def delete_incense(name, box_number)
    for incense in @data[box_number]
      if incense.name == name
        remove_text(name, box_number)
        @data[box_number].delete(incense)
#        text =
#          case box_number
#          when 0;"味方の#{incense.name}の効果が無くなった"
#          when 1;"敵の#{incense.name}の効果が無くなった"
#          when 2;"場の#{incense.name}の効果が無くなった"
#          end
      end
    end
  end
  #--------------------------------------------------------------------------
  # ● インセンスを全てリセット（何かひとつでもあったならばtrueを返す）
  #--------------------------------------------------------------------------
  def delete_incense_all
    result = false
    result = true if @data != [[],[],[]]
    @data = [[],[],[]]
    return result
  end
  #--------------------------------------------------------------------------
  # ● ターン終了時の減少
  #--------------------------------------------------------------------------
  def turn_end_reduction
    index = 0
    for data_one in @data
      for incense in data_one
        incense.remaining_turn -= 1
        delete_incense(incense.name, index) if incense.remaining_turn <= 0
      end
      index += 1
    end
  end
  #--------------------------------------------------------------------------
  # ● インセンス付与テキスト
  #--------------------------------------------------------------------------
  def add_text(name, box_number)
    txt = ""
    if $incense.data[box_number] != []
      for incense_one in $incense.data[box_number]
        if incense_one.name == name
          txt += text_alter(incense_one.start_text + "\w\q", box_number)
        end
      end
    end
    if txt != ""
      if $game_system.system_read_mode != 0
        txt += "CLEAR"
        txt.sub!("\w\qCLEAR","")
      end
      $game_temp.battle_log_text += txt
    else
      return ""
    end
  end
  #--------------------------------------------------------------------------
  # ● インセンス解除テキスト
  #--------------------------------------------------------------------------
  def remove_text(name, box_number)
    txt = ""
    if $incense.data[box_number] != []
      for incense_one in $incense.data[box_number]
        if incense_one.name == name
          txt += text_alter(incense_one.end_text + "\w\q", box_number)
        end
      end
    end
    if txt != ""
      if $game_system.system_read_mode != 0
        txt += "CLEAR"
        txt.sub!("\w\qCLEAR","")
      end
      # 事前にテキストがあった場合は改行を挿す
      txt = "\w\q" + txt if $game_temp.battle_log_text != "" 
      $game_temp.battle_log_text += txt
    else
      return ""
    end
  end
  #--------------------------------------------------------------------------
  # ● インセンス継続テキスト
  #--------------------------------------------------------------------------
  def keep_text_call
    txt = ""
    for i in 0..2
      if $incense.data[i] != []
        for incense_one in $incense.data[i]
          txt += text_alter(incense_one.fragranting_text + "\w\q", i)
        end
      end
    end
    if txt != ""
      if $game_system.system_read_mode != 0
        txt += "CLEAR"
        txt.sub!("\w\qCLEAR","")
      end
      $game_temp.battle_log_text += txt
    else
      return ""
    end
  end
  #--------------------------------------------------------------------------
  # ● テキスト中の改変
  #--------------------------------------------------------------------------
  def text_alter(text, box_number)
    count = 0
    delegate = nil
    text.gsub!("味方", "相手") if box_number == 1
    
    for actor in $game_party.battle_actors
      if actor.exist?
        delegate = actor if delegate == nil
        count += 1
      end
    end
    if delegate != nil
      s1 = delegate.name
      s1 += "たち" if count > 1
      change_flag = text.gsub!("味方", s1)
      text.gsub!("brk", "\w\n") if change_flag != nil and s1.size > 10 * 3
    end
    count = 0
    delegate = nil  
    for enemy in $game_troop.enemies
      if enemy.exist?
        delegate = enemy if delegate == nil
        count += 1
      end
    end
    if delegate != nil
      s2 = delegate.name
      s2 += "たち" if count > 1
      change_flag = text.gsub!("相手", s2)
      text.gsub!("brk", "\w\n") if change_flag != nil and  s2.size > 10 * 3
    end
    text.gsub!("brk", "")
    return text
  end
end