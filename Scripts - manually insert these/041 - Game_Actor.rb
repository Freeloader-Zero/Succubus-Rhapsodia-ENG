#==============================================================================
# ■ Game_Actor
#------------------------------------------------------------------------------
# 　アクターを扱うクラスです。このクラスは Game_Actors クラス ($game_actors)
# の内部で使用され、Game_Party クラス ($game_party) からも参照されます。
#==============================================================================

class Game_Actor < Game_Battler
  #--------------------------------------------------------------------------
  # ● 公開インスタンス変数
  #--------------------------------------------------------------------------
  attr_reader   :name                   # 名前
  attr_reader   :character_name         # キャラクター ファイル名
  attr_reader   :character_hue          # キャラクター 色相
  attr_reader   :class_id               # クラス ID
  attr_accessor :weapon_id              # 武器 ID
  attr_accessor :armor1_id              # 盾 ID
  attr_accessor :armor2_id              # 頭防具 ID
  attr_accessor :armor3_id              # 体防具 ID
  attr_accessor :armor4_id              # 装飾品 ID
  attr_reader   :level                  # レベル
  attr_accessor :exp                    # EXP
  # ★追加箇所---------------------------------------------------------------
  attr_accessor :skills                 # スキル
  attr_accessor :base_atk2              # 攻撃力（調整用）
  attr_accessor :base_pdef2             # 物理防御（調整用）
  attr_accessor :base_mdef2             # 魔法防御（調整用）
  attr_accessor :promise                # 契約ポイント
  attr_accessor :maxfed                 # 最大満腹度
  attr_accessor :fed                    # 満腹度
  attr_accessor :digest                 # 空腹率
  attr_accessor :absorb                 # 吸精率
  attr_accessor :d_power                # 夢の魔力
  attr_accessor :exp_tank               # 経験値タンク
  attr_accessor :race                   # 種族
  attr_accessor :hp_autoheal            # EP自動回復
  attr_accessor :sp_autoheal            # VP自動回復
  attr_accessor :vs_me                  # この夢魔と戦闘中
  attr_accessor :exp_list               # 経験値テーブル
  attr_accessor :level_up_log           # レベルアップログ
  attr_accessor :skill_collect          # スキル使用履歴
  attr_accessor :exp_plus_flag          # 経験値を多めに貰ったか？
  
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #     actor_id : アクター ID
  #--------------------------------------------------------------------------
  def initialize(actor_id)
    super()
    setup(actor_id)
  end
  #--------------------------------------------------------------------------
  # ● セットアップ
  #     actor_id : アクター ID
  #--------------------------------------------------------------------------
  def setup(actor_id)
    actor = $data_actors[actor_id]
    @actor_id = actor_id
    @name = actor.name
    @character_name = actor.character_name
    @character_hue = actor.character_hue
    @battler_name = actor.battler_name
    @battler_hue = actor.battler_hue
    @class_id = actor.class_id
    @weapon_id = actor.weapon_id
    @armor1_id = actor.armor1_id
    @armor2_id = actor.armor2_id
    @armor3_id = actor.armor3_id
    @armor4_id = actor.armor4_id
    @level = actor.initial_level
    @exp_list = Array.new(101)
    make_exp_list
    @exp = @exp_list[@level]
    @skills = []
    @hp = maxhp
    @sp = maxsp
    @states = []
    @states_turn = {}
    @maxhp_plus = 0
    @maxsp_plus = 0
    @str_plus = 0
    @dex_plus = 0
    @agi_plus = 0
    @int_plus = 0
    # ★ 更新箇所
    @base_atk2 = 0
    @base_pdef2 = 0
    @base_mdef2 = 0
    @promise = 0
    @maxfed = 100
    @fed = 100
    @digest = 0
    @absorb = 0
    @d_power = 0
    @exp_tank = 0
    @hp_autoheal = 1
    @sp_autoheal = 1
    @vs_me = false
    @skill_collect = nil
    # スキル習得
    @skills = []
    if actor_id == 101
      for i in 1..@level
        for j in $data_classes[@class_id].learnings
          if j[0] == i
            if j[1] == 0
              learn_skill(j[2])
            else
              gain_ability(j[2])
            end
          end
        end
      end
    end
    @level_up_log = ""
    # オートステートを更新
    update_auto_state(nil, $data_armors[@armor1_id])
    update_auto_state(nil, $data_armors[@armor2_id])
    update_auto_state(nil, $data_armors[@armor3_id])
    update_auto_state(nil, $data_armors[@armor4_id])
  end
  #--------------------------------------------------------------------------
  # ● アクター ID 取得
  #--------------------------------------------------------------------------
  def id
    return @actor_id
  end
  #--------------------------------------------------------------------------
  # ● インデックス取得
  #--------------------------------------------------------------------------
  def index
    return $game_party.actors.index(self)
  end
  #--------------------------------------------------------------------------
  # ● EXP 計算
  #--------------------------------------------------------------------------
  def make_exp_list
    actor = $data_actors[@actor_id]
    @exp_list[1] = 0
    pow_i = 2.4 + actor.exp_inflation / 100.0
    for i in 2..100
      if i > actor.final_level
        @exp_list[i] = 0
      else
        n = actor.exp_basis * ((i + 3) ** pow_i) / (5 ** pow_i)
        @exp_list[i] = @exp_list[i-1] + Integer(n)
      end
    end
  end
  #--------------------------------------------------------------------------
  # ● 属性補正値の取得
  #     element_id : 属性 ID
  #--------------------------------------------------------------------------
  def element_rate(element_id)
    # 属性有効度に対応する数値を取得
    table = [0,200,150,100,50,0,-100]
    result = table[$data_classes[@class_id].element_ranks[element_id]]
    # 防具でこの属性が防御されている場合は半減
    for i in [@armor1_id, @armor2_id, @armor3_id, @armor4_id]
      armor = $data_armors[i]
      if armor != nil and armor.guard_element_set.include?(element_id)
        result /= 2
      end
    end
    # ステートでこの属性が防御されている場合は半減
    for i in @states
      if $data_states[i].guard_element_set.include?(element_id)
        result /= 2
      end
    end
    # メソッド終了
    return result
  end
  #--------------------------------------------------------------------------
  # ● ステート有効度の取得
  #--------------------------------------------------------------------------
  def state_ranks
    return $data_classes[@class_id].state_ranks
  end
  #--------------------------------------------------------------------------
  # ● ステート防御判定
  #     state_id : ステート ID
  #--------------------------------------------------------------------------
  def state_guard?(state_id)
    for i in [@armor1_id, @armor2_id, @armor3_id, @armor4_id]
      armor = $data_armors[i]
      if armor != nil
        if armor.guard_state_set.include?(state_id)
          return true
        end
      end
    end
    return false
  end
  #--------------------------------------------------------------------------
  # ● 通常攻撃の属性取得
  #--------------------------------------------------------------------------
  def element_set
    weapon = $data_weapons[@weapon_id]
    return weapon != nil ? weapon.element_set : []
  end
  #--------------------------------------------------------------------------
  # ● 通常攻撃のステート変化 (+) 取得
  #--------------------------------------------------------------------------
  def plus_state_set
    weapon = $data_weapons[@weapon_id]
    return weapon != nil ? weapon.plus_state_set : []
  end
  #--------------------------------------------------------------------------
  # ● 通常攻撃のステート変化 (-) 取得
  #--------------------------------------------------------------------------
  def minus_state_set
    weapon = $data_weapons[@weapon_id]
    return weapon != nil ? weapon.minus_state_set : []
  end
  #--------------------------------------------------------------------------
  # ● MaxHP の取得
  #--------------------------------------------------------------------------
  def maxhp
    n = [[base_maxhp + @maxhp_plus, 1].max, 9999].min
    for i in @states
      n *= $data_states[i].maxhp_rate / 100.0
    end
    n = [[Integer(n), 1].max, 9999].min
    n += 300 if self.is_a?(Game_Actor) and self.equip?("暴食のルーン")
    return n
  end
  #--------------------------------------------------------------------------
  # ● 基本 MaxHP の取得
  #--------------------------------------------------------------------------
  def base_maxhp
    return $data_actors[@actor_id].parameters[0, @level]
  end
  #--------------------------------------------------------------------------
  # ● 基本 MaxSP の取得
  #--------------------------------------------------------------------------
  def base_maxsp
    return $data_actors[@actor_id].parameters[1, @level]
  end
  #--------------------------------------------------------------------------
  # ● 基本腕力の取得
  #--------------------------------------------------------------------------
  def base_str
    n = $data_actors[@actor_id].parameters[2, @level]
    weapon = $data_weapons[@weapon_id]
    armor1 = $data_armors[@armor1_id]
    armor2 = $data_armors[@armor2_id]
    armor3 = $data_armors[@armor3_id]
    armor4 = $data_armors[@armor4_id]
    n += weapon != nil ? weapon.str_plus : 0
    n += armor1 != nil ? armor1.str_plus : 0
    n += armor2 != nil ? armor2.str_plus : 0
    n += armor3 != nil ? armor3.str_plus : 0
    n += armor4 != nil ? armor4.str_plus : 0
    return [[n, 1].max, 999].min
  end
  #--------------------------------------------------------------------------
  # ● 基本器用さの取得
  #--------------------------------------------------------------------------
  def base_dex
    n = $data_actors[@actor_id].parameters[3, @level]
    weapon = $data_weapons[@weapon_id]
    armor1 = $data_armors[@armor1_id]
    armor2 = $data_armors[@armor2_id]
    armor3 = $data_armors[@armor3_id]
    armor4 = $data_armors[@armor4_id]
    n += weapon != nil ? weapon.dex_plus : 0
    n += armor1 != nil ? armor1.dex_plus : 0
    n += armor2 != nil ? armor2.dex_plus : 0
    n += armor3 != nil ? armor3.dex_plus : 0
    n += armor4 != nil ? armor4.dex_plus : 0
    return [[n, 1].max, 999].min
  end
  #--------------------------------------------------------------------------
  # ● 基本素早さの取得
  #--------------------------------------------------------------------------
  def base_agi
    n = $data_actors[@actor_id].parameters[4, @level]
    weapon = $data_weapons[@weapon_id]
    armor1 = $data_armors[@armor1_id]
    armor2 = $data_armors[@armor2_id]
    armor3 = $data_armors[@armor3_id]
    armor4 = $data_armors[@armor4_id]
    n += weapon != nil ? weapon.agi_plus : 0
    n += armor1 != nil ? armor1.agi_plus : 0
    n += armor2 != nil ? armor2.agi_plus : 0
    n += armor3 != nil ? armor3.agi_plus : 0
    n += armor4 != nil ? armor4.agi_plus : 0
    return [[n, 1].max, 999].min
  end
  #--------------------------------------------------------------------------
  # ● 基本魔力の取得
  #--------------------------------------------------------------------------
  def base_int
    n = $data_actors[@actor_id].parameters[5, @level]
    weapon = $data_weapons[@weapon_id]
    armor1 = $data_armors[@armor1_id]
    armor2 = $data_armors[@armor2_id]
    armor3 = $data_armors[@armor3_id]
    armor4 = $data_armors[@armor4_id]
    n += weapon != nil ? weapon.int_plus : 0
    n += armor1 != nil ? armor1.int_plus : 0
    n += armor2 != nil ? armor2.int_plus : 0
    n += armor3 != nil ? armor3.int_plus : 0
    n += armor4 != nil ? armor4.int_plus : 0
    return [[n, 1].max, 999].min
  end
  #--------------------------------------------------------------------------
  # ● 基本攻撃力の取得
  #--------------------------------------------------------------------------
  def base_atk
    weapon = $data_weapons[@weapon_id]
    return weapon != nil ? weapon.atk : 0
  end
  #--------------------------------------------------------------------------
  # ● 基本物理防御の取得
  #--------------------------------------------------------------------------
  def base_pdef
    weapon = $data_weapons[@weapon_id]
    armor1 = $data_armors[@armor1_id]
    armor2 = $data_armors[@armor2_id]
    armor3 = $data_armors[@armor3_id]
    armor4 = $data_armors[@armor4_id]
    pdef1 = weapon != nil ? weapon.pdef : 0
    pdef2 = armor1 != nil ? armor1.pdef : 0
    pdef3 = armor2 != nil ? armor2.pdef : 0
    pdef4 = armor3 != nil ? armor3.pdef : 0
    pdef5 = armor4 != nil ? armor4.pdef : 0
    return pdef1 + pdef2 + pdef3 + pdef4 + pdef5
  end
  #--------------------------------------------------------------------------
  # ★ 調整用基本物理防御の取得
  #--------------------------------------------------------------------------
  def base_pdef2
    weapon = $data_weapons[@weapon_id]
    armor1 = $data_armors[@armor1_id]
    armor2 = $data_armors[@armor2_id]
    armor3 = $data_armors[@armor3_id]
    armor4 = $data_armors[@armor4_id]
    pdef1 = weapon != nil ? weapon.pdef : 0
    pdef2 = armor1 != nil ? armor1.pdef : 0
    pdef3 = armor2 != nil ? armor2.pdef : 0
    pdef4 = armor3 != nil ? armor3.pdef : 0
    pdef5 = armor4 != nil ? armor4.pdef : 0
    return pdef1 + pdef2 + pdef3 + pdef4 + pdef5 + int
  end
  #--------------------------------------------------------------------------
  # ● 基本魔法防御の取得
  #--------------------------------------------------------------------------
  def base_mdef
    weapon = $data_weapons[@weapon_id]
    armor1 = $data_armors[@armor1_id]
    armor2 = $data_armors[@armor2_id]
    armor3 = $data_armors[@armor3_id]
    armor4 = $data_armors[@armor4_id]
    mdef1 = weapon != nil ? weapon.mdef : 0
    mdef2 = armor1 != nil ? armor1.mdef : 0
    mdef3 = armor2 != nil ? armor2.mdef : 0
    mdef4 = armor3 != nil ? armor3.mdef : 0
    mdef5 = armor4 != nil ? armor4.mdef : 0
    return mdef1 + mdef2 + mdef3 + mdef4 + mdef5
  end
  #--------------------------------------------------------------------------
  # ● 基本回避修正の取得
  #--------------------------------------------------------------------------
  def base_eva
    armor1 = $data_armors[@armor1_id]
    armor2 = $data_armors[@armor2_id]
    armor3 = $data_armors[@armor3_id]
    armor4 = $data_armors[@armor4_id]
    eva1 = armor1 != nil ? armor1.eva : 0
    eva2 = armor2 != nil ? armor2.eva : 0
    eva3 = armor3 != nil ? armor3.eva : 0
    eva4 = armor4 != nil ? armor4.eva : 0
    return eva1 + eva2 + eva3 + eva4
  end
  #--------------------------------------------------------------------------
  # ● 通常攻撃 攻撃側アニメーション ID の取得
  #--------------------------------------------------------------------------
  def animation1_id
    weapon = $data_weapons[@weapon_id]
    return weapon != nil ? weapon.animation1_id : 0
  end
  #--------------------------------------------------------------------------
  # ● 通常攻撃 対象側アニメーション ID の取得
  #--------------------------------------------------------------------------
  def animation2_id
    weapon = $data_weapons[@weapon_id]
    return weapon != nil ? weapon.animation2_id : 0
  end

  #--------------------------------------------------------------------------
  # ● EXP の文字列取得
  #--------------------------------------------------------------------------
  def exp_s
    return @exp_list[@level+1] > 0 ? @exp.to_s : "----"
  end
  #--------------------------------------------------------------------------
  # ● 次のレベルの EXP の文字列取得
  #--------------------------------------------------------------------------
  def next_exp_s
    return @exp_list[@level+1] > 0 ? @exp_list[@level+1].to_s : "----"
  end
  #--------------------------------------------------------------------------
  # ● 次のレベルまでの EXP の文字列取得
  #--------------------------------------------------------------------------
  def next_rest_exp_s
    return @exp_list[@level+1] > 0 ?
      (@exp_list[@level+1] - @exp).to_s : "----"
  end
  #--------------------------------------------------------------------------
  # ● オートステートの更新
  #     old_armor : 外した防具
  #     new_armor : 装備した防具
  #--------------------------------------------------------------------------
  def update_auto_state(old_armor, new_armor)
    # 外した防具のオートステートを強制解除
    if old_armor != nil and old_armor.auto_state_id != 0
      remove_state(old_armor.auto_state_id, true)
    end
    # 装備した防具のオートステートを強制付加
    if new_armor != nil and new_armor.auto_state_id != 0
      add_state(new_armor.auto_state_id, true)
    end
  end
  #--------------------------------------------------------------------------
  # ● 装備固定判定
  #     equip_type : 装備タイプ
  #--------------------------------------------------------------------------
  def equip_fix?(equip_type)
    case equip_type
    when 0  # 武器
      return $data_actors[@actor_id].weapon_fix
    when 1  # 盾
      return $data_actors[@actor_id].armor1_fix
    when 2  # 頭
      return $data_actors[@actor_id].armor2_fix
    when 3  # 身体
      return $data_actors[@actor_id].armor3_fix
    when 4  # 装飾品
      return $data_actors[@actor_id].armor4_fix
    end
    return false
  end
  #--------------------------------------------------------------------------
  # ● 装備の変更
  #     equip_type : 装備タイプ
  #     id    : 武器 or 防具 ID  (0 なら装備解除)
  #--------------------------------------------------------------------------
  def equip(equip_type, id)
    case equip_type
    when 0  # 武器
      if id == 0 or $game_party.weapon_number(id) > 0
        $game_party.gain_weapon(@weapon_id, 1)
        @weapon_id = id
        $game_party.lose_weapon(id, 1)
      end
    when 1  # 盾
      if id == 0 or $game_party.armor_number(id) > 0
        update_auto_state($data_armors[@armor1_id], $data_armors[id])
        $game_party.gain_armor(@armor1_id, 1)
        @armor1_id = id
        $game_party.lose_armor(id, 1)
      end
    when 2  # 頭
      if id == 0 or $game_party.armor_number(id) > 0
        update_auto_state($data_armors[@armor2_id], $data_armors[id])
        $game_party.gain_armor(@armor2_id, 1)
        @armor2_id = id
        $game_party.lose_armor(id, 1)
      end
    when 3  # 身体
      if id == 0 or $game_party.armor_number(id) > 0
        update_auto_state($data_armors[@armor3_id], $data_armors[id])
        $game_party.gain_armor(@armor3_id, 1)
        @armor3_id = id
        $game_party.lose_armor(id, 1)
      end
    when 4  # 装飾品
      if id == 0 or $game_party.armor_number(id) > 0
        update_auto_state($data_armors[@armor4_id], $data_armors[id])
        $game_party.gain_armor(@armor4_id, 1)
        @armor4_id = id
        $game_party.lose_armor(id, 1)
      end
    end
  end
  #--------------------------------------------------------------------------
  # ● 装備可能判定
  #     item : アイテム
  #--------------------------------------------------------------------------
  def equippable?(item)
    # 武器の場合
    if item.is_a?(RPG::Weapon)
      # 現在のクラスの装備可能な武器に含まれている場合
      if $data_classes[@class_id].weapon_set.include?(item.id)
        return true
      end
    end
    # 防具の場合
    if item.is_a?(RPG::Armor)
      # 現在のクラスの装備可能な防具に含まれている場合
      if $data_classes[@class_id].armor_set.include?(item.id)
        return true
      end
    end
    return false
  end
  #--------------------------------------------------------------------------
  # ● EXP の変更
  #     exp : 新しい EXP
  #--------------------------------------------------------------------------
  def exp=(exp)
    @exp = [[exp, 9999999].min, 0].max
    text = ""
    @level_up_log = ""
    myname = self.name
    up_flag = false
    # レベルアップ
    while @exp >= @exp_list[@level+1] and @exp_list[@level+1] > 0
      @level += 1
      text += "\065\067" #if up_flag
      text += "#{myname} reached Lv.#{@level.to_s}!"
      # スキル習得
      for j in $data_classes[@class_id].learnings
        if j[0] == @level
          if j[1] == 0
            learn_skill(j[2])
            text += "\065\067#{myname} learned #{$data_skills[j[2]].UK_name}!"
          else
            gain_ability(j[2])
            # 非表示素質は表示しない
            if $data_ability[j[2]].hidden == false
              text += "\065\067#{myname} got the 【#{$data_ability[j[2]].UK_name}】 trait!"
            end
          end
        end
      end
#      up_flag = true 
    end
    
    # レベルダウン
    while @exp < @exp_list[@level]
      @level -= 1
    end
    if text != ""
      @level_up_log = text
    end
    # 現在の HP と SP が最大値を超えていたら修正
    @hp = [@hp, self.maxhp].min
    @sp = [@sp, self.maxsp].min
  end
  #--------------------------------------------------------------------------
  # ● レベルの変更
  #     level : 新しいレベル
  #--------------------------------------------------------------------------
  def level=(level)
    # 上下限チェック
    level = [[level, $MAX_LEVEL].min, 1].max
    # EXP を変更
    self.exp = @exp_list[level]
  end
  #--------------------------------------------------------------------------
  # ● スキルを覚える
  #     skill_id : スキル ID
  #--------------------------------------------------------------------------
  def learn_skill(skill_id)
    if skill_id > 0 and not skill_learn?(skill_id, "ORIGINAL")
      @skills.push(skill_id)
      @skills.sort!
    end
  end
  #--------------------------------------------------------------------------
  # ● スキルを忘れる
  #     skill_id : スキル ID
  #--------------------------------------------------------------------------
  def forget_skill(skill_id)
    @skills.delete(skill_id)
  end
  #--------------------------------------------------------------------------
  # ● スキルの習得済み判定
  #     skill_id : スキル ID
  #--------------------------------------------------------------------------
  def skill_learn?(skill_id, type = "ALL")
    # 戦闘中かつＡＬＬなら戦闘中用スキルを返す
    return battle_skills.include?(skill_id) if type == "ALL" and $game_temp.in_battle
    # ＡＬＬなら習得している全スキルを返す
    return all_skills.include?(skill_id) if type == "ALL"
    # それ以外なら自力習得のみのスキルを返す
    return @skills.include?(skill_id)
  end
  #--------------------------------------------------------------------------
  # ● スキルの使用可能判定
  #     skill_id : スキル ID
  #--------------------------------------------------------------------------
  def skill_can_use?(skill_id)
    if not skill_learn?(skill_id)
      return false unless self.berserk == true
    end
    return super
  end
  #--------------------------------------------------------------------------
  # ● 名前の変更
  #     name : 新しい名前
  #--------------------------------------------------------------------------
  def name=(name)
    @name = name
  end
  #--------------------------------------------------------------------------
  # ★ 好感度の変更
  #     love : 新しい好感度
  #--------------------------------------------------------------------------
  def love=(love)
    if self.have_ability?("寵愛")
      @love = [[love, 150].min, 0].max
    else
      @love = [[love, $MAX_LOVE].min, 0].max
    end
  end
  #--------------------------------------------------------------------------
  # ★ 契約の珠の変更
  #     promise : 新しい契約の珠
  #--------------------------------------------------------------------------
  def promise=(promise)
    @promise = [[promise, 999999].min, 0].max
  end
  #--------------------------------------------------------------------------
  # ● クラス ID の変更
  #     class_id : 新しいクラス ID
  #--------------------------------------------------------------------------
  def class_id=(class_id)
    if $data_classes[class_id] != nil
      @class_id = class_id
      # 装備できなくなったアイテムを外す
      unless equippable?($data_weapons[@weapon_id])
        equip(0, 0)
      end
      unless equippable?($data_armors[@armor1_id])
        equip(1, 0)
      end
      unless equippable?($data_armors[@armor2_id])
        equip(2, 0)
      end
      unless equippable?($data_armors[@armor3_id])
        equip(3, 0)
      end
      unless equippable?($data_armors[@armor4_id])
        equip(4, 0)
      end
    end
  end
  #--------------------------------------------------------------------------
  # ● グラフィックの変更
  #     character_name : 新しいキャラクター ファイル名
  #     character_hue  : 新しいキャラクター 色相
  #     battler_name   : 新しいバトラー ファイル名
  #     battler_hue    : 新しいバトラー 色相
  #--------------------------------------------------------------------------
  def set_graphic(character_name, character_hue, battler_name, battler_hue)
    @character_name = character_name
    @character_hue = character_hue
    @battler_name = battler_name
    @battler_hue = battler_hue
  end
  #--------------------------------------------------------------------------
  # ● バトル画面 X 座標の取得
  #--------------------------------------------------------------------------
  def screen_x
    # パーティ内の並び順から X 座標を計算して返す
    if self.index != nil
      return self.index * 160 + 80
    else
      return 0
    end
  end
  #--------------------------------------------------------------------------
  # ● バトル画面 Y 座標の取得
  #--------------------------------------------------------------------------
  def screen_y
    return 464
  end
  #--------------------------------------------------------------------------
  # ● バトル画面 Z 座標の取得
  #--------------------------------------------------------------------------
  def screen_z
    # パーティ内の並び順から Z 座標を計算して返す
    if self.index != nil
      return 4 - self.index
    else
      return 0
    end
  end
  #--------------------------------------------------------------------------
  # ● 満腹度 の変更
  #--------------------------------------------------------------------------
  def fed
    return [[@fed, 0].max, 100].min
  end
  #---------------------------------------------------------------------------- 
  # ● 満腹度の減少
  #----------------------------------------------------------------------------
  def fed_down
    if self != $game_actors[101]
      @fed -= self.digest
      if @fed <= 20 and not self.state?(15)
        $game_temp.hungry = true
        self.add_state(15)
        text = "#{@name}\n seems to be hungry again..."
        SR_Util.announce(text)
      end
      if @fed <= 0
        $game_temp.vs_actors.push(self)
        @vs_me = true
      end
    end
  end
  #--------------------------------------------------------------------------
  # ● ランクアップ
  #--------------------------------------------------------------------------
  def rank_up
    # クラスの名前そのままならフラグを立てる。
    name_flag = @name == $data_classes[@class_id].name ? true :false
    # ランクアップ処理
    @class_id = $data_SDB[self.class_id].next_rank_id
    self.set_graphic($data_SDB[self.class_id].graphics,0,$data_SDB[self.class_id].graphics,0)
    @name = $data_classes[@class_id].name if name_flag == true
    # ランクアップを消去
    @skills.delete(249)
    
    # スキル習得
    for j in $data_classes[@class_id].learnings
      if j[0] <= @level
        if j[1] == 0
          learn_skill(j[2])
        else
          gain_ability(j[2])
        end
      end
    end
    # インプ、ゴブリン以外が【小悪魔の連携】を素で持っている場合、
    # 【小悪魔の統率】に変更する。（一応逆も設定）
    unless petit_devil_link?($data_SDB[self.class_id])
      if self.have_ability?("小悪魔の連携", "ORIGINAL")
        self.remove_ability(81)
        self.gain_ability(82)
      end
    else
      if self.have_ability?("小悪魔の統率", "ORIGINAL")
        self.remove_ability(82)
        self.gain_ability(81)
      end
    end
    # デフォ呼称を設定
    @defaultname_self = nil
    @defaultname_hero = nil
    $msg.defaultname_select(self)    
  end
  #--------------------------------------------------------------------------
  # ● 満腹度 の増減
  #--------------------------------------------------------------------------
  def fed=(fed)
    @fed = fed
    @fed = [[@fed, 100].min, 0].max
    if @fed > 20 and self.state?(15)
      self.remove_state(15)
      # 戦闘中に回復した場合はログを出す
      if $game_temp.in_battle
        self.remove_states_log.delete($data_states[15])
        text = "\065\n#{self.name}'s hunger has been satiated!"
        $game_temp.battle_log_text += text
      end
    end 
  end
  #----------------------------------------------------------------
  # ● 習得リセット
  #----------------------------------------------------------------
  def learn_reset(type = 0)
    skills_box    = []
    abilities_box = []
    if type == 0
      # 契約の珠で習得できるものは保持
      for bonus in $data_classes[self.class_id].bonus
        case bonus[1]
        when 0 # スキル
          if self.skill_learn?(bonus[2],"ORIGINAL")
            skills_box.push(bonus[2])
          end
        when 1 # 素質
          if self.have_ability?(bonus[2],"ORIGINAL")
            abilities_box.push(bonus[2])
          end
        end
      end
    end
    # 保持したい素質を保持
    keep_ability = []
    for i in 1..61 # 弱点等の先天素質は保持
      keep_ability.push(i)
    end
    for i in 301..400 # ホールドスキル習得素質も保持
      keep_ability.push(i)
    end
    for keep in keep_ability
      if self.have_ability?(keep,"ORIGINAL")
        abilities_box.push(keep)
      end
    end
    abilities_box.uinq! # 重複を消す
    # リフレッシュさせる
    self.skills = skills_box.sort
    self.ability = abilities_box.sort
    # ホールドスキル習得素質が抜けている場合、これを再装填
    for skill_id in self.skills
      case skill_id
      when 5  # シェルマッチ
        self.gain_ability(303)
      when 6  # インサート 
        self.gain_ability(301) 
      when 16 # ドロウネクター
        self.gain_ability(306)
      when 17 # エンブレイス
        self.gain_ability(305)
      when 18 # エキサイトビュー
        self.gain_ability(304)
      end
    end
    #レベル帯に応じてスキルを再取得
    for i in 1..self.level
      for j in $data_classes[self.class_id].learnings
        if j[0] == i
          if j[1] == 0
            learn_skill(j[2])
          else
            gain_ability(j[2])
          end
        end
      end
    end
  end
end