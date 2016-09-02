#==============================================================================
# ■ Game_Battler (分割定義 1)
#------------------------------------------------------------------------------
# 　バトラーを扱うクラスです。このクラスは Game_Actor クラスと Game_Enemy クラ
# スのスーパークラスとして使用されます。
#==============================================================================

class Game_Battler
  #--------------------------------------------------------------------------
  # ● 公開インスタンス変数
  #--------------------------------------------------------------------------
  attr_accessor :battler_name             # バトラー ファイル名
  attr_reader   :battler_hue              # バトラー 色相
  attr_reader   :hp                       # HP
  attr_reader   :sp                       # SP
  attr_accessor   :states                   # ステート
  attr_accessor :level                    # レベル
  attr_accessor :hidden                   # 隠れフラグ
  attr_accessor :immortal                 # 不死身フラグ
  attr_accessor :damage_pop               # ダメージ表示フラグ
  attr_accessor :damage                   # ダメージ値
  attr_accessor :critical                 # クリティカルフラグ
  attr_accessor :animation_id             # アニメーション ID
  attr_accessor :animation_hit            # アニメーション ヒットフラグ
  attr_accessor :white_flash              # 白フラッシュフラグ
  attr_accessor :white_flash_long         # 長い白フラッシュフラグ
  attr_accessor :blink                    # 明滅フラグ
  attr_accessor :change                   # ★交代準備用
  attr_accessor :add_states_log           # 付加されたステートのログ
  attr_accessor :remove_states_log        # 解除されたステートのログ
  attr_accessor :lub_male                 # ♂潤滑度
  attr_accessor :lub_female               # ♀潤滑度
  attr_accessor :lub_anal                 # 尻穴潤滑度
  attr_accessor :personality              # 性格
  attr_accessor :ability                  # 素質
  attr_accessor :state_runk               # 素質
  attr_accessor :change_index             # 交代する場所
  attr_accessor :before_target            # 自分が直前に追撃を発生させた対象
  attr_accessor :crisis_flag              # クライシス会話発生フラグ
  attr_accessor :love                     # 好感度
  attr_accessor :resist_count             # レジストした回数チェック
  attr_accessor :ecstasy_count            # 絶頂させた相手の情報
  attr_accessor :ecstasy_turn             # 絶頂ターン
  attr_accessor :ecstasy_emotion          # 絶頂時の行動エモーション
  attr_accessor :sp_down_flag             # VP減少による失神フラグ
  attr_accessor :graphic_change           # 画像変更フラグ
  attr_accessor :checking                 # チェック完了フラグ
  #口上拡張用各種フラグ
  attr_accessor :bedin_count              # ベッドイン回数
  attr_accessor :rankup_flag              # ランクアップ経験フラグ
  attr_accessor :hold                     # ホールドフラグ
  attr_accessor :label                    # 固有ラベル設定用
  attr_accessor :defaultname_hero         # ロウ君の基本呼称
  attr_accessor :nickname_master          # ロウ君の特殊呼称
  attr_accessor :defaultname_self         # 自分の基本呼称
  attr_accessor :nickname_self            # 自分の特殊呼称
  attr_accessor :used_mouth               # 口腔快感受容
  attr_accessor :used_anal                # 肛門快感受容
  attr_accessor :used_sadism              # 被虐快感受容
  attr_accessor :another_action           # 多重アクション用フラグ
  attr_accessor :marking_battler          # マーキング相手
  attr_accessor :berserk                  # 暴走フラグ
  attr_accessor :pillowtalk               # 会話フラグ(契約発動誘発)
  attr_accessor :talk_weak_check          # 会話弱点突きフラグ
  attr_accessor :lub_flag_male            # ♂潤滑進行フラグ
  attr_accessor :lub_flag_female          # ♀潤滑進行フラグ
  attr_accessor :lub_flag_anal            # 尻穴潤滑進行フラグ
  attr_accessor :earnest                  # 本気フラグ
  attr_accessor :UK_name                  # $UKmode go!
  
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  def initialize
    @battler_name = ""
    @battler_hue = 0
    @hp = 0
    @sp = 0
    @states = []
    @last_states = []
    @states_turn = {}
    @maxhp_plus = 0
    @maxsp_plus = 0
    @str_plus = 0
    @dex_plus = 0
    @agi_plus = 0
    @int_plus = 0
    @hidden = false
    @immortal = false
    @damage_pop = false
    @damage = nil
    @critical = false
    @animation_id = 0
    @animation_hit = false
    @white_flash = false
    @blink = false
    @current_action = Game_BattleAction.new
    @change = -1
    @add_states_log = []
    @remove_states_log = []
    @lub_male = 0
    @lub_female = 0
    @lub_anal = 0
    @personality = "" 
    @ability = []
    @state_runk = []
    @change_index = []
    @before_target = ""
    @crisis_flag = false
    @love = 0
    @resist_count = 0
    @ecstasy_count = []
    @ecstasy_turn = 0
    @ecstasy_emotion = nil
    @sp_down_flag = false
    @graphic_change = false
    @checking = 0
    #口上拡張用各種フラグ
    @bedin_count = 0
    @rankup_flag = false
    @hold = Game_BattlerHold.new
    @label = []
    @nickname_master = nil
    @nickname_self = nil
    #それぞれ150を越えると確率で快感を受け始める。
    @used_mouth = 0
    @used_anal = 0
    @used_sadism = 0
    @another_action = false
    @berserk = false
    @pillowtalk = 0
    @talk_weak_check = []
    @lub_flag_male = 0
    @lub_flag_female = 0
    @lub_flag_anal = 0
    @earnest = false
  end
  #--------------------------------------------------------------------------
  # ● MaxHP の取得
  #--------------------------------------------------------------------------
  def maxhp
    n = [[base_maxhp + @maxhp_plus, 1].max, 999999].min
    for i in @states
      n *= $data_states[i].maxhp_rate / 100.0
    end
    n = [[Integer(n), 1].max, 999999].min
    return n
  end
  #--------------------------------------------------------------------------
  # ● MaxSP の取得
  #--------------------------------------------------------------------------
  def maxsp
    n = [[base_maxsp + @maxsp_plus, 0].max, 9999].min
    for i in @states
      n *= $data_states[i].maxsp_rate / 100.0
    end
    # 一匹狼の誡
    n += 2000 if self.is_a?(Game_Actor) and lonely_wolf?
    # 独占欲
    n += 300 if self.is_a?(Game_Actor) and monopolize?
    n += 1000 if self.is_a?(Game_Actor) and self.equip?("淫紋のルーン")
    n = [[Integer(n), 0].max, 9999].min
    return n
  end
  #--------------------------------------------------------------------------
  # ● 腕力の取得
  #--------------------------------------------------------------------------
  def str
    n = [[base_str + @str_plus, 1].max, 999].min
    for i in @states
      n *= $data_states[i].str_rate / 100.0
    end
    # 戦闘中補正
    if $game_temp.in_battle
      # インセンス補正
      n = n * $incense.inc_adjusted_value(self, 2) / 100
      # 【無我夢中】持ちはクライシス時に精力を１．５倍
      n = (n * 1.5).truncate if self.have_ability?("無我夢中") and self.crisis?
      # 【超暴走】持ちは暴走時に精力を１．５倍
      n = n * 2 if self.have_ability?("超暴走") and self.state?(36)
    end
    n = [[Integer(n), 1].max, 999].min
    return n
  end
  #--------------------------------------------------------------------------
  # ● 器用さの取得
  #--------------------------------------------------------------------------
  def dex
    n = [[base_dex + @dex_plus, 1].max, 999].min
    for i in @states
      n *= $data_states[i].dex_rate / 100.0
    end
    # 戦闘中補正
    if $game_temp.in_battle
      # インセンス補正
      n = n * $incense.inc_adjusted_value(self, 3) / 100
    end
    n = [[Integer(n), 1].max, 999].min
    return n
  end
  #--------------------------------------------------------------------------
  # ● 素早さの取得
  #--------------------------------------------------------------------------
  def agi
    n = [[base_agi + @agi_plus, 1].max, 999].min
    for i in @states
      n *= $data_states[i].agi_rate / 100.0
    end
    # 戦闘中補正
    if $game_temp.in_battle
      # インセンス補正
      n = n * $incense.inc_adjusted_value(self, 4) / 100
      # 【厚着】持ちは着衣時に素早さを０．５倍
      n = (n * 0.5).truncate if self.have_ability?("厚着") and not self.nude?
    end
    n = [[Integer(n), 1].max, 999].min
    return n
  end
  #--------------------------------------------------------------------------
  # ● 魔力の取得
  #--------------------------------------------------------------------------
  def int
    n = [[base_int + @int_plus, 1].max, 999].min
    for i in @states
      n *= $data_states[i].int_rate / 100.0
    end
    # 戦闘中補正
    if $game_temp.in_battle
      # インセンス補正
      n = n * $incense.inc_adjusted_value(self, 5) / 100
      # 【超暴走】持ちは暴走時に精神力を０．５倍
      n = n / 2 if self.have_ability?("超暴走") and self.state?(36)
    end
    n = [[Integer(n), 1].max, 999].min
    return n
  end
  #--------------------------------------------------------------------------
  # ● MaxHP の設定
  #     maxhp : 新しい MaxHP
  #--------------------------------------------------------------------------
  def maxhp=(maxhp)
    @maxhp_plus += maxhp - self.maxhp
    @maxhp_plus = [[@maxhp_plus, -9999].max, 9999].min
    @hp = [@hp, self.maxhp].min
  end
  #--------------------------------------------------------------------------
  # ● MaxSP の設定
  #     maxsp : 新しい MaxSP
  #--------------------------------------------------------------------------
  def maxsp=(maxsp)
    @maxsp_plus += maxsp - self.maxsp
    @maxsp_plus = [[@maxsp_plus, -9999].max, 9999].min
    @sp = [@sp, self.maxsp].min
  end
  #--------------------------------------------------------------------------
  # ★ HPパーセンテージの取得
  #--------------------------------------------------------------------------
  def hpp
    return (self.hp * 100 / self.maxhp).round
  end
  #--------------------------------------------------------------------------
  # ★ SPパーセンテージの取得
  #--------------------------------------------------------------------------
  def spp
    return (self.sp * 100 / self.maxsp).round
  end
  #--------------------------------------------------------------------------
  # ● 腕力の設定
  #     str : 新しい腕力
  #--------------------------------------------------------------------------
  def str=(str)
    @str_plus += str - self.str
    @str_plus = [[@str_plus, -999].max, 999].min
  end
  #--------------------------------------------------------------------------
  # ● 器用さの設定
  #     dex : 新しい器用さ
  #--------------------------------------------------------------------------
  def dex=(dex)
    @dex_plus += dex - self.dex
    @dex_plus = [[@dex_plus, -999].max, 999].min
  end
  #--------------------------------------------------------------------------
  # ● 素早さの設定
  #     agi : 新しい素早さ
  #--------------------------------------------------------------------------
  def agi=(agi)
    @agi_plus += agi - self.agi
    @agi_plus = [[@agi_plus, -999].max, 999].min
  end
  #--------------------------------------------------------------------------
  # ● 魔力の設定
  #     int : 新しい魔力
  #--------------------------------------------------------------------------
  def int=(int)
    @int_plus += int - self.int
    @int_plus = [[@int_plus, -999].max, 999].min
  end
  #--------------------------------------------------------------------------
  # ● 命中率の取得
  #--------------------------------------------------------------------------
  def hit
    n = 100
    for i in @states
      n *= $data_states[i].hit_rate / 100.0
    end
    return Integer(n)
  end
  #--------------------------------------------------------------------------
  # ● 攻撃力の取得
  #--------------------------------------------------------------------------
  def atk
    n = base_atk
    n += 10 if self.have_ability?("寵愛")
    n += 10 if self.have_ability?("大切な人")
    for i in @states
      n *= $data_states[i].atk_rate / 100.0
    end
    # 戦闘中補正
    if $game_temp.in_battle
      # インセンス補正
      n = n * $incense.inc_adjusted_value(self, 0) / 100
    end
    return Integer(n)
  end
  #--------------------------------------------------------------------------
  # ● 物理防御の取得
  #--------------------------------------------------------------------------
  def pdef
    n = base_pdef
    for i in @states
      n *= $data_states[i].pdef_rate / 100.0
    end
    # 戦闘中補正
    if $game_temp.in_battle
      # インセンス補正
      n = n * $incense.inc_adjusted_value(self, 1) / 100
      # 【超暴走】持ちは暴走時に忍耐力を０．５倍
      n = n / 2 if self.have_ability?("超暴走") and self.state?(36)
    end
    # 【厚着】持ちは着衣時に忍耐力を１．５倍
    n = (n * 1.5).truncate if self.have_ability?("厚着") and not self.nude?
    return Integer(n)
  end
  #--------------------------------------------------------------------------
  # ● 魔法防御の取得
  #--------------------------------------------------------------------------
  def mdef
    n = base_mdef
    for i in @states
      n *= $data_states[i].mdef_rate / 100.0
    end
    return Integer(n)
  end
  #--------------------------------------------------------------------------
  # ● 回避修正の取得
  #--------------------------------------------------------------------------
  def eva
    n = base_eva
    for i in @states
      n += $data_states[i].eva
    end
    return n
  end
  #--------------------------------------------------------------------------
  # ● HP の変更
  #     hp : 新しい HP
  #--------------------------------------------------------------------------
  def hp=(hp)
    @hp = [[hp, maxhp].min, 0].max
  end
  #--------------------------------------------------------------------------
  # ● SP の変更
  #     sp : 新しい SP
  #--------------------------------------------------------------------------
  def sp=(sp)
    @sp = [[sp, maxsp].min, 0].max
    if self.dead?
      add_state(1)
    else
      remove_state(1)
    end
  end
  #--------------------------------------------------------------------------
  # ● 潤滑度 の変更
  #--------------------------------------------------------------------------
  def lub_male=(lub_male)
    @lub_male = [[lub_male, 100].min, 0].max
  end
  def lub_female=(lub_female)
    @lub_female = [[lub_female, 100].min, 0].max
  end
  def lub_anal=(lub_anal)
    @lub_anal = [[lub_anal, 100].min, 0].max
  end
  #--------------------------------------------------------------------------
  # ● 全回復
  #--------------------------------------------------------------------------
  def recover_all
    @hp = maxhp
    @sp = maxsp
    for i in @states.clone
      remove_state(i)
    end
    if self.is_a?(Game_Actor)
      self.fed = 100
    end
  end
  
  #--------------------------------------------------------------------------
  # ● カレントアクションの取得
  #--------------------------------------------------------------------------
  def current_action
    return @current_action
  end
  #--------------------------------------------------------------------------
  # ● アクションスピードの決定
  #--------------------------------------------------------------------------
  def make_action_speed
    plus = 0
#    @current_action.speed = agi + rand(10 + agi / 4)
    # ★行動順にランダム要素無くAGIで確定
    @current_action.speed = agi
    #ディレイを受けていると行動速度-999に
    if self.state?(13)
      @current_action.speed -= 999
    end
    #麻痺していると行動速度が1/10に
    if self.state?(39)
      @current_action.speed /= 10
    end
    # ●現在使用中のスキル属性で修正を加える
    if self.current_action.kind == 1
      #先制行動属性
      if $data_skills[self.current_action.skill_id].element_set.include?(29)
        plus += 9999
      end
      #最遅行動属性
      if $data_skills[self.current_action.skill_id].element_set.include?(214)
        plus -= 9999
      end
      #口淫属性スキルは若干発動が早い（没）
      if $data_skills[self.current_action.skill_id].element_set.include?(10)
#        plus += 20
      end
      @current_action.speed += plus
    end
  end
  #--------------------------------------------------------------------------
  # ★ 絶頂判定
  #--------------------------------------------------------------------------
  def ecstasy?
    return ((@hp == 0 and not @immortal) or @sp_down_flag)
  end
  #--------------------------------------------------------------------------
  # ● 戦闘不能判定
  #--------------------------------------------------------------------------
  def dead?
    return (@sp == 0 and not @immortal and not @sp_down_flag)
  end
  #--------------------------------------------------------------------------
  # ● 存在判定
  #--------------------------------------------------------------------------
  def exist?
    return (not @hidden and (@sp > 0 or @immortal or @sp_down_flag))
  end
  #--------------------------------------------------------------------------
  # ● HP 0 判定
  #--------------------------------------------------------------------------
  def hp0?
    return (not @hidden and @hp == 0)
  end
  #--------------------------------------------------------------------------
  # ● コマンド入力可能判定
  #--------------------------------------------------------------------------
  def inputable?
    return (not @hidden and restriction <= 1)
  end
  #--------------------------------------------------------------------------
  # ● 行動可能判定
  #--------------------------------------------------------------------------
  def movable?
    return (not @hidden and restriction < 4)
  end
  #--------------------------------------------------------------------------
  # ● 防御中判定
  #--------------------------------------------------------------------------
  def guarding?
    return (@current_action.kind == 0 and @current_action.basic == 1)
  end
  #--------------------------------------------------------------------------
  # ● 休止中判定
  #--------------------------------------------------------------------------
  def resting?
    return (@current_action.kind == 0 and @current_action.basic == 3)
  end
  #--------------------------------------------------------------------------
  # ★ クライシス処理(未稼動)
  #--------------------------------------------------------------------------
  def crisis
    return
  end
  #--------------------------------------------------------------------------
  # ★ クライシス判定
  #--------------------------------------------------------------------------
  def crisis?
    return self.states.include?(6)
  end
  #--------------------------------------------------------------------------
  # ★ 半裸判定
  #--------------------------------------------------------------------------
  def half_nude?
    return self.states.include?(4)
  end
  #--------------------------------------------------------------------------
  # ★ 半裸 + 挿入許可判定
  #--------------------------------------------------------------------------
  def insertable_half_nude?
    result = false
    if half_nude?
      condBitmapFile = @battler_name.clone()
      condBitmapFile += "_M"
      if RPG::Cache.battler_exist?(condBitmapFile)
        result = true
      end
    end
    return result
  end
  #--------------------------------------------------------------------------
  # ★ 半裸 + 挿入不可判定
  #--------------------------------------------------------------------------
  def uninsertable_half_nude?
    result = false
    if half_nude?
      condBitmapFile = @battler_name.clone()
      condBitmapFile += "_L"
      if RPG::Cache.battler_exist?(condBitmapFile)
        result = true
      end
    end
    return result
  end
  #--------------------------------------------------------------------------
  # ★ 全裸判定
  #--------------------------------------------------------------------------
  def full_nude?
    return self.states.include?(5)
  end
  #--------------------------------------------------------------------------
  # ★ 裸判定
  #--------------------------------------------------------------------------
  def nude?
    return (self.half_nude? or full_nude?)
  end
  #--------------------------------------------------------------------------
  # ★ 挿入可能裸判定
  #--------------------------------------------------------------------------
  def insertable_nude?
    return (self.insertable_half_nude? or full_nude?)
  end
  #--------------------------------------------------------------------------
  # ★ 挿入判定
  #--------------------------------------------------------------------------
  # ♀挿入判定（♂側）
  def penis_insert?
    # ペニスが相手の「アソコ」で「♀挿入」によりホールドされていればtrue
    return (self.hold.penis.parts == "アソコ" and self.hold.penis.type == "♀挿入")
  end
  # ♀挿入判定（尻尾側）
  def tail_insert?
    # 尻尾が相手の「アソコ」で「♀挿入」によりホールドされていればtrue
    return (self.hold.tail.parts == "アソコ" and self.hold.tail.type == "♀挿入")
  end
  # ♀挿入判定（触手側）
  def tentacle_insert?
    # 触手が相手の「アソコ」で「♀挿入」によりホールドされていればtrue
    return (self.hold.tentacle.parts == "アソコ" and self.hold.tentacle.type == "♀挿入")
  end
  # ♀挿入判定（ディルド側）
  def dildo_insert?
    # ディルドが相手の「アソコ」で「♀挿入」によりホールドされていればtrue
    return (self.hold.dildo.parts == "アソコ" and self.hold.dildo.type == "ディルド♀挿入")
  end
  # ♀挿入判定（♀側）
  # インサート画が存在する場合、これがtrueだということを条件にする。
  def vagina_insert?
    # アソコが相手の「ペニス」「尻尾」「触手」「ディルド」のいずれかで、
    #「♀挿入」によりホールドされていればtrue
    return (self.hold.vagina.parts == "ペニス" and self.hold.vagina.type == "♀挿入")
    #return (self.hold.vagina.parts == "尻尾" and self.hold.vagina.type == "♀挿入")
    #return (self.hold.vagina.parts == "触手" and self.hold.vagina.type == "♀挿入")
    #return (self.hold.vagina.parts == "ディルド" and self.hold.vagina.type == "♀挿入")
  end
  
  # ディルド♀挿入判定（♀側）
  def dildo_vagina_insert?
    return (self.hold.vagina.parts == "ディルド" and self.hold.vagina.type == "ディルド♀挿入")
  end
  
  # ♀挿入判定（♀側特殊）
  def vagina_insert_special?
    return true if (self.hold.vagina.parts == "尻尾" and self.hold.vagina.type == "♀挿入")
    return true if (self.hold.vagina.parts == "触手" and self.hold.vagina.type == "♀挿入")
    return true if (self.hold.vagina.parts == "ディルド" and self.hold.vagina.type == "ディルド♀挿入")
    return false
  end
  # 総合♀挿入判定
  def insert?
    return true if self.penis_insert?
    return true if self.vagina_insert?
    return true if self.vagina_insert_special?
    return true if self.tail_insert?
    return true if self.tentacle_insert?
    return true if self.dildo_insert?
    return false
  end
  #--------------------------------------------------------------------------
  # ★ 口淫判定
  #--------------------------------------------------------------------------
  # 口淫判定（♂側）
  def penis_oralsex?
    # ペニスが相手の「口」で「口挿入」によりホールドされていればtrue
    return (self.hold.penis.parts == "口" and self.hold.penis.type == "口挿入")
  end
  # 口淫判定（尻尾側）
  def tail_oralsex?
    # 尻尾が相手の「口」で「口挿入」によりホールドされていればtrue
    return (self.hold.tail.parts == "口" and self.hold.tail.type == "口挿入")
  end
  # 口淫判定（触手側）
  def tentacle_oralsex?
    # 触手が相手の「口」で「口挿入」によりホールドされていればtrue
    return (self.hold.tentacle.parts == "口" and self.hold.tentacle.type == "口挿入")
  end
  # ディルド口淫判定（ディルド側）
  def dildo_oralsex?
    # ディルドが相手の「口」で「口挿入」によりホールドされていればtrue
    return (self.hold.dildo.parts == "口" and self.hold.dildo.type == "ディルド口挿入")
  end
  # 口淫判定（口側）
  # インサート画が存在する場合、これがtrueだということを条件にする。
  def mouth_oralsex?
    # 口が相手の「ペニス」「尻尾」「触手」「ディルド」のいずれかで、
    #「口挿入」によりホールドされていればtrue
    return true if (self.hold.mouth.parts == "ペニス" and self.hold.mouth.type == "口挿入")
    return false
  end
  # ディルド口淫判定（口側）
  def dildo_mouth_oralsex?
    # ディルドが相手の「口」で「口挿入」によりホールドされていればtrue
    return (self.hold.mouth.parts == "ディルド" and self.hold.mouth.type == "ディルド口挿入")
  end
  # 口淫判定（口側特殊）
  # インサート画が存在する場合、これがtrueだということを条件にする。
  def mouth_oralsex_special?
    return true if (self.hold.mouth.parts == "尻尾" and self.hold.mouth.type == "口挿入")
    return true if (self.hold.mouth.parts == "触手" and self.hold.mouth.type == "口挿入")
    return true if (self.hold.mouth.parts == "ディルド" and self.hold.mouth.type == "ディルド口挿入")
    return false
  end
  # 総合口淫判定
  def oralsex?
    return true if self.penis_oralsex?
    return true if self.mouth_oralsex?
    return true if self.tail_oralsex?
    return true if self.tentacle_oralsex?
    return true if self.dildo_oralsex?
    return true if self.mouth_oralsex_special?
    return false
  end
  #--------------------------------------------------------------------------
  # ★ 肛姦判定
  #--------------------------------------------------------------------------
  # 肛姦判定（♂側）
  def penis_analsex?
    # ペニスが相手の「アナル」で「尻挿入」によりホールドされていればtrue
    return (self.hold.penis.parts == "アナル" and self.hold.penis.type == "尻挿入")
  end
  # 肛姦判定（尻尾側）
  def tail_analsex?
    # 尻尾が相手の「アナル」で「尻挿入」によりホールドされていればtrue
    return (self.hold.tail.parts == "アナル" and self.hold.tail.type == "尻挿入")
  end
  # 肛姦判定（触手側）
  def tentacle_analsex?
    # 触手が相手の「アナル」で「尻挿入」によりホールドされていればtrue
    return (self.hold.tentacle.parts == "アナル" and self.hold.tentacle.type == "尻挿入")
  end
  # ディルド肛姦判定（ディルド側）
  def dildo_analsex?
    # ディルドが相手の「アナル」で「尻挿入」によりホールドされていればtrue
    return (self.hold.dildo.parts == "アナル" and self.hold.dildo.type == "ディルド尻挿入")
  end
  # 肛姦判定（尻側）
  # インサート画が存在する場合、これがtrueだということを条件にする。
  def anal_analsex?
    # アナルが相手の「ペニス」「尻尾」「触手」「ディルド」のいずれかで、
    #「尻挿入」によりホールドされていればtrue
    return (self.hold.anal.parts == "ペニス" and self.hold.anal.type == "尻挿入")
  end
  # ディルド肛姦判定（尻側）
  def dildo_anal_analsex?
    # アナルが相手の「ディルド」で「尻挿入」によりホールドされていればtrue
    return (self.hold.anal.parts == "ディルド" and self.hold.anal.type == "ディルド尻挿入")
  end
  # 肛姦判定（尻側）
  # インサート画が存在する場合、これがtrueだということを条件にする。
  def anal_analsex?
    return true if (self.hold.anal.parts == "尻尾" and self.hold.anal.type == "尻挿入")
    return true if (self.hold.anal.parts == "触手" and self.hold.anal.type == "触手尻挿入")
    return true if (self.hold.anal.parts == "ディルド" and self.hold.anal.type == "ディルド尻挿入")
    return false
  end
  # 総合肛姦判定
  def analsex?
    return true if self.penis_analsex?
    return true if self.tail_analsex?
    return true if self.tentacle_analsex?
    return true if self.dildo_analsex?
    return true if self.anal_analsex?
    return false
  end
  #--------------------------------------------------------------------------
  # ★ 騎乗判定
  #--------------------------------------------------------------------------
  # 騎乗判定（攻め側）
  def vagina_riding?
    # アソコが相手の「口」で「顔面騎乗」によりホールドされていればtrue
    return (self.hold.vagina.parts == "口" and self.hold.vagina.type == "顔面騎乗")
  end
  # 騎乗判定（受け側）
  def mouth_riding?
    # 口が相手の「アソコ」で「顔面騎乗」によりホールドされていればtrue
    return (self.hold.mouth.parts == "アソコ" and self.hold.mouth.type == "顔面騎乗")
  end
  # 総合騎乗判定
  def riding?
    return true if self.vagina_riding?
    return true if self.mouth_riding?
    return false
  end
  #--------------------------------------------------------------------------
  # ★ 尻騎乗判定
  #--------------------------------------------------------------------------
  # 尻騎乗判定（攻め側）
  def anal_hipriding?
    # アナルが相手の「口」で「尻騎乗」によりホールドされていればtrue
    return (self.hold.anal.parts == "口" and self.hold.anal.type == "尻騎乗")
  end
  # 騎乗判定（受け側）
  def mouth_hipriding?
    # 口が相手の「アナル」で「尻騎乗」によりホールドされていればtrue
    return (self.hold.mouth.parts == "アナル" and self.hold.mouth.type == "尻騎乗")
  end
  # 総合騎乗判定
  def hipriding?
    return true if self.anal_hipriding?
    return true if self.mouth_hipriding?
    return false
  end
  #--------------------------------------------------------------------------
  # ★ クンニ判定
  #--------------------------------------------------------------------------
  # クンニ判定（攻め側）
  def mouth_draw?
    # 口が相手の「アソコ」で「クンニ」によりホールドされていればtrue
    return (self.hold.mouth.parts == "アソコ" and self.hold.mouth.type == "クンニ")
  end
  # クンニ判定（受け側）
  def vagina_draw?
    # アソコが相手の「口」で「クンニ」によりホールドされていればtrue
    return (self.hold.vagina.parts == "口" and self.hold.vagina.type == "クンニ")
  end
  # クンニ判定（攻め側）
  def tentacle_draw?
    # 口が相手の「アソコ」で「クンニ」によりホールドされていればtrue
    return (self.hold.tentacle.parts == "アソコ" and self.hold.tentacle.type == "触手クンニ")
  end
  # クンニ判定（受け側）
  def tentacle_vagina_draw?
    # アソコが相手の「口」で「クンニ」によりホールドされていればtrue
    return (self.hold.vagina.parts == "触手" and self.hold.vagina.type == "触手クンニ")
  end
  # 総合クンニ判定
  def draw?
    return true if self.mouth_draw?
    return true if self.vagina_draw?
    return true if self.tentacle_draw?
    return true if self.tentacle_vagina_draw?
    return false
  end
  #--------------------------------------------------------------------------
  # ★ ディープキッス判定
  #--------------------------------------------------------------------------
  # ディープキッス判定(受け攻めで同じ部位ホールド)
  def deepkiss?
    # 口が相手の「口」で「キッス」によりホールドされていればtrue
    return (self.hold.mouth.parts == "口" and self.hold.mouth.type == "キッス")
  end
  #--------------------------------------------------------------------------
  # ★ 貝合わせ判定
  #--------------------------------------------------------------------------
  # 貝合わせ判定(受け攻めで同じ部位ホールド)
  def shellmatch?
    # アソコが相手の「アソコ」で「貝合わせ」によりホールドされていればtrue
    return (self.hold.vagina.parts == "アソコ" and self.hold.vagina.type == "貝合わせ")
  end
  #--------------------------------------------------------------------------
  # ★ パイズリ判定
  #--------------------------------------------------------------------------
  # パイズリ判定（攻め側）
  def tops_paizuri?
    # 上半身が相手の「ペニス」で「パイズリ」によりホールドされ、イニシアチブが１以上ならばtrue
    return (self.hold.tops.parts == "ペニス" and self.hold.tops.type == "パイズリ" and self.hold.tops.initiative > 0)
  end
  # パイズリ判定（受け側）
  def penis_paizuri?
    # 上半身が相手の「上半身」で「パイズリ」によりホールドされ、イニシアチブが０ならばtrue
    return (self.hold.penis.parts == "上半身" and self.hold.penis.type == "パイズリ" and self.hold.penis.initiative == 0)
  end
  # 総合パイズリ判定
  def paizuri?
    return true if self.tops_paizuri?
    return true if self.penis_paizuri?
    return false
  end
  #--------------------------------------------------------------------------
  # ★ ぱふぱふ判定
  #--------------------------------------------------------------------------
  # ぱふぱふ判定（攻め側）
  def tops_pahupahu?
    # 上半身が相手の「口」で「ぱふぱふ」によりホールドされ、イニシアチブが１以上ならばtrue
    return (self.hold.tops.parts == "口" and self.hold.tops.type == "ぱふぱふ" and self.hold.tops.initiative > 0)
  end
  # ぱふぱふ判定（受け側）
  def mouth_pahupahu?
    # 上半身が相手の「上半身」で「パイズリ」によりホールドされ、イニシアチブが０ならばtrue
    return (self.hold.mouth.parts == "上半身" and self.hold.mouth.type == "ぱふぱふ" and self.hold.mouth.initiative == 0)
  end
  # 総合ぱふぱふ判定
  def pahupahu?
    return true if self.tops_pahupahu?
    return true if self.mouth_pahupahu?
    return false
  end
  #--------------------------------------------------------------------------
  # ★ 拘束判定
  #--------------------------------------------------------------------------
  # 拘束判定（攻め側）
  def tops_binder?
    # 上半身が相手の「上半身」で「拘束」によりホールドされ、イニシアチブが１以上ならばtrue
    return (self.hold.tops.parts == "上半身" and self.hold.tops.type == "拘束" and self.hold.tops.initiative > 0)
  end
  # 拘束判定（受け側）
  def tops_binding?
    # 上半身が相手の「上半身」で「拘束」によりホールドされ、イニシアチブが０ならばtrue
    return (self.hold.tops.parts == "上半身" and self.hold.tops.type == "拘束" and self.hold.tops.initiative == 0)
  end
  # 総合拘束判定
  def bind?
    return true if self.tops_binder?
    return true if self.tops_binding?
    return false
  end
  #--------------------------------------------------------------------------
  # ★ 触手拘束判定
  #--------------------------------------------------------------------------
  # 拘束判定（触手攻め側）
  def tentacle_binder?
    # 触手が相手の「上半身」で「拘束」によりホールドされていればtrue
    return true if (self.hold.tentacle.parts == "上半身" and self.hold.tentacle.type == "触手拘束")
    return true if (self.hold.tentacle.parts == "上半身" and self.hold.tentacle.type == "蔦拘束")
    return false
  end
  # 拘束判定（触手受け側）
  def tentacle_binding?
    # 触手が相手の「触手」で「拘束」によりホールドされていればtrue
    return true if (self.hold.tops.parts == "触手" and self.hold.tops.type == "触手拘束")
    return true if (self.hold.tops.parts == "触手" and self.hold.tops.type == "蔦拘束")
    return false
  end
  # 総合拘束判定
  def tentacle_bind?
    return true if self.tentacle_binder?
    return true if self.tentacle_binding?
    return false
  end
  #--------------------------------------------------------------------------
  # ★ 触手吸引判定
  #--------------------------------------------------------------------------
  # 吸引判定（触手側）
  def tentacle_absorbing?
    # 触手が相手の「触手」で「拘束」によりホールドされていればtrue
    return (self.hold.tentacle.parts == "ペニス" and self.hold.tentacle.type == "触手吸引")
  end
  # 吸引判定（♂側）
  def tentacle_penis_absorbing?
    # 触手が相手の「触手」で「拘束」によりホールドされていればtrue
    return (self.hold.penis.parts == "触手" and self.hold.penis.type == "触手吸引")
  end
  # 総合吸引判定
  def tentacle_absorb?
    return true if self.tentacle_absorbing?
    return true if self.tentacle_penis_absorbing?
    return false
  end
  #--------------------------------------------------------------------------
  # ★ 開帳判定
  #--------------------------------------------------------------------------
  # 開帳判定（攻め側）
  def tops_openbinder?
    # 上半身が相手の「上半身」で「開脚」によりホールドされ、イニシアチブが１以上ならばtrue
    return (self.hold.tops.parts == "上半身" and self.hold.tops.type == "開脚" and self.hold.tops.initiative > 0)
  end
  # 拘束判定（受け側）
  def tops_openbinding?
    # 上半身が相手の「上半身」で「開脚」によりホールドされ、イニシアチブが０ならばtrue
    return (self.hold.tops.parts == "上半身" and self.hold.tops.type == "開脚" and self.hold.tops.initiative == 0)
  end
  # 拘束判定（触手側）
  def tentacle_openbinder?
    # 触手が相手の「上半身」で「開脚」によりホールドされていればtrue
    return (self.hold.tentacle.parts == "上半身" and self.hold.tentacle.type == "開脚")
  end
  # 拘束判定（触手側）
  def tentacle_openbinding?
    # 触手が相手の「触手」で「開脚」によりホールドされていればtrue
    return (self.hold.tops.parts == "触手" and self.hold.tentacle.type == "開脚")
  end
  # 総合拘束判定
  def openbind?
    return true if self.tops_openbinder?
    return true if self.tops_openbinding?
    return true if self.tentacle_openbinder?
    return true if self.tentacle_openbinding?
    return false
  end
  #--------------------------------------------------------------------------
  # ★ 本気挿入が行われているかの確認
  #--------------------------------------------------------------------------
  def earnest_insert?
    return true if self.earnest and self.vagina_insert?
    return true if self.earnest and self.penis_insert?
    return true if self.hold.penis.battler != nil and self.hold.penis.battler.earnest
    return true if self.hold.vagina.battler != nil and self.hold.vagina.battler.earnest
    return false
  end
  #--------------------------------------------------------------------------
  # ★ 本気挿入の確認（グラフィック変更用）
  #--------------------------------------------------------------------------
  def earnest_vagina_insert?
    return true if self.earnest and self.vagina_insert?
    return false
  end
  #--------------------------------------------------------------------------
  # ★ 素質判定
  #    ability : 確認する素質（ＩＤ、文字列どちらでもＯＫ）
  #--------------------------------------------------------------------------
  def have_ability?(ability, type = "ALL")
    # 習得しているものだけ確認する
    n = ability
    # 引数が文字列の場合、IDに変換する。
    n = $data_ability.search(0, ability) if ability.is_a?(String)
    # 全確認がONでアクターの場合、全部から確認する（デフォルト）
    if type == "ALL" and self.is_a?(Game_Actor)
      return self.all_ability.include?(n)
    else
      return @ability.include?(n)
    end
  end
  #--------------------------------------------------------------------------
  # ★ 素質習得
  #    ability : 習得する素質（ＩＤ、文字列どちらでもＯＫ）
  #--------------------------------------------------------------------------
  def gain_ability(ability)
    n = ability
    # 引数が文字列の場合、IDに変換する。
    n = $data_ability.search(0, ability) if ability.is_a?(String)
    
    case n
    # 高揚を習得する時は沈着を消去
    when $data_ability.search(0, "高揚")
      remove_ability("沈着")
      
    # 沈着を習得する時は高揚を消去
    when $data_ability.search(0, "沈着")
      remove_ability("高揚")
    end
    
    unless have_ability?(n, "ORIGINAL")
      @ability.push(n)
      @ability.sort!
    end
  end
  #--------------------------------------------------------------------------
  # ★ 素質消去
  #    ability : 消去する素質（ＩＤ、文字列どちらでもＯＫ）
  #--------------------------------------------------------------------------
  def remove_ability(ability)
    n = ability
    # 引数が文字列の場合、IDに変換する。
    n = $data_ability.search(0, ability) if ability.is_a?(String)

    if have_ability?(n, "ORIGINAL")
      @ability.delete(n)
      @ability.sort!
    end
  end
  #--------------------------------------------------------------------------
  # ★ ホールド設定処理
  #--------------------------------------------------------------------------
  def hold
    @hold = Game_BattlerHold.new if @hold == nil
    return @hold
  end
  def hold=(hold)
    @hold = Game_BattlerHold.new if @hold == nil
    @hold = hold
  end
  def hold_reset
    self.hold.mouth.set(nil, nil, nil, nil)
    self.hold.penis.set(nil, nil, nil, nil)
    self.hold.tops.set(nil, nil, nil, nil)
    self.hold.vagina.set(nil, nil, nil, nil)
    self.hold.anal.set(nil, nil, nil, nil)
    self.hold.tail.set(nil, nil, nil, nil)
    self.hold.tentacle.set(nil, nil, nil, nil)
  end
  #--------------------------------------------------------------------------
  # ★ クライシス処理
  #--------------------------------------------------------------------------
  
  #--------------------------------------------------------------------------
  # ★ 着衣処理
  #--------------------------------------------------------------------------
  def dress
    user = $game_temp.battle_active_battler
    for i in 4..5
      user.remove_state(i) if user.states.include?(i)
    end
  end
  #--------------------------------------------------------------------------
  # ★ 脱衣処理
  #--------------------------------------------------------------------------
  def undress
    user = $game_temp.battle_active_battler
    #半脱ぎに条件分岐が存在する夢魔はフラグを１にする
    undress_flag = 0
    #夢魔によって、脱衣方法を個別に設定する
    case $data_SDB[self.class_id].name
    #ナイトメアの場合「アクターから脱衣」「アクターが興奮」で半脱ぎになる
    #自分から脱いだ場合や通常時は特に変化しない
    when "ナイトメア"
      unless user.is_a?(Game_Actor) and user.excited?
        #条件を満たさない場合はフラグを１にする
        undress_flag = 1
      end
    end
    # 半裸状態？
    if half_nude?
      # 全裸状態にする
      self.add_state(5)
    # 着衣状態？
    elsif undress_flag == 0
      bmp_name = []
      bmp_name[0] = @battler_name + "_L"
      bmp_name[1] = @battler_name + "_M"
      if RPG::Cache.battler_exist?(bmp_name[0]) or
         RPG::Cache.battler_exist?(bmp_name[1])
        # 半裸状態にする
        self.add_state(4)
      else
        # 全裸状態にする
        self.add_state(5)
      end
    else
      # 全裸状態にする
      self.add_state(5)
    end
#    self.white_flash_long = true
#    Audio.se_play("Audio/SE/one28", 80, 100)
    # 脱衣アニメーションをつける
    @animation_id = 104
    @animation_hit = true
    
  end

  #--------------------------------------------------------------------------
  # ★ 挿入処理
  #--------------------------------------------------------------------------
  

  #--------------------------------------------------------------------------
  # ★ 挿入解除処理
  #--------------------------------------------------------------------------

  #--------------------------------------------------------------------------
  # ★ 好感度上昇処理
  #--------------------------------------------------------------------------
  def like(plus=0)
    #対象がエネミーでない(好感度が存在しない)場合は戻す
    return if self.is_a?(Game_Actor)
    #好感度上昇前と上昇後を比べる
    point1 = self.friendly
    point2 = self.friendly + plus
    if point2 > point1
      friendly_animation_order(point2)
      self.friendly = self.friendly + plus
    end
  end
  #--------------------------------------------------------------------------
  # ★ 好感度アニメ指示
  #--------------------------------------------------------------------------
  def friendly_animation_order(point = self.friendly)
    case point
    #好感度が７０越えの場合
    when 71..255
      @animation_id = 42
      @animation_hit = true
    #好感度が３０～７０の間の場合
    when 30..70
      @animation_id = 41
      @animation_hit = true
    #好感度が２９以下の場合(マイナスも含む)
    else
      @animation_id = 40
      @animation_hit = true
    end
  end
  #--------------------------------------------------------------------------
  # ★ 精液処理
  #   point   0:ぶっかけ 1:中出し
  #--------------------------------------------------------------------------
  def sperm(point)
    case point
    when 0 # ぶっかけ
      self.add_state(9)
     when 1 # 中出し
      # ぶっかけされている場合はぶっかけ記号もつける
      self.add_state(10)
    end
    
  end    

  #--------------------------------------------------------------------------
  # ★ クライシス顔条件判定
  #--------------------------------------------------------------------------
  def crisis_graphic?
    if self.state?(6) or self.state?(11) or self.state?(2) or self.state?(3)
      return true
    elsif self.sp_down_flag
      return true
    end
    return false
  end
  #--------------------------------------------------------------------------
  # ★ 絶頂回数
  #--------------------------------------------------------------------------
  def ecstasy_count
    @ecstasy_count = [] if @ecstasy_count == nil
    return @ecstasy_count
  end
  #--------------------------------------------------------------------------
  # ● マーキング状態？
  #--------------------------------------------------------------------------
  def marking?
    return (self.marking_battler != nil and self.state?(99))
  end
  #--------------------------------------------------------------------------
  # ● 行動済み状態？
  #--------------------------------------------------------------------------
  def actioned?
    if $game_temp.in_battle
      return !$scene.action_battlers.include?(self)
    else
      return false
    end
  end
  #--------------------------------------------------------------------------
  # ● 状態異常の数
  #--------------------------------------------------------------------------
  def bad_state_number
    count = 0
    for i in SR_Util.bad_states
      count += 1 if self.state?(i)
    end
    return count
  end
  #--------------------------------------------------------------------------
  # ● バッドチェインできるか？
  #--------------------------------------------------------------------------
  def bad_chain?
    # ２個以上でバッドチェイン達成
    return bad_state_number >= 2
  end
  #--------------------------------------------------------------------------
  # ● 足が使えるか？
  #--------------------------------------------------------------------------
  def can_use_leg?
    result = true
    result = false if $data_SDB[self.class_id].legless == true
    return result
  end
  #--------------------------------------------------------------------------
  # ● この相手の胸に手が届くか？
  #--------------------------------------------------------------------------
  def can_reach_bust?(target)
    #--------------------------------------------------------------------------
    # 体勢的に不可
    #--------------------------------------------------------------------------
    # 口挿入・口淫系は両者不可
    return false if self.hold.mouth.parts == "ペニス" and self.hold.mouth.battler == target
    return false if self.hold.penis.parts == "口" and self.hold.penis.battler == target
    return false if self.hold.mouth.parts == "ディルド" and self.hold.mouth.battler == target
    return false if self.hold.dildo.parts == "口" and self.hold.dildo.battler == target
    return false if self.hold.mouth.parts == "アソコ" and self.hold.mouth.battler == target
    return false if self.hold.vagina.parts == "口" and self.hold.vagina.battler == target
    #--------------------------------------------------------------------------
    return true
  end
  #--------------------------------------------------------------------------
  # ● この相手の秘部に手が届くか？
  #--------------------------------------------------------------------------
  def can_reach_secret?(target)
    #--------------------------------------------------------------------------
    # 相手の秘部がホールド状態になっている場合は不可
    #--------------------------------------------------------------------------
    return false if target.hold.penis.battler != nil
    return false if target.hold.dildo.battler != nil
    return false if target.hold.vagina.battler != nil
=begin シックスナイン体勢なら可能なのでコメントアウト
    #--------------------------------------------------------------------------
    # 体勢的に不可
    #--------------------------------------------------------------------------
    # 自分の秘部が相手の口でホールドされている
    return false if self.hold.penis.parts == "口" and self.hold.penis.battler == target
    return false if self.hold.dildo.parts == "口" and self.hold.dildo.battler == target
    return false if self.hold.vagina.parts == "口" and self.hold.vagina.battler == target
    #--------------------------------------------------------------------------
=end
    return true
  end
  #--------------------------------------------------------------------------
  # ● この相手の尻に手が届くか？
  #--------------------------------------------------------------------------
  def can_reach_hip?(target)
    #--------------------------------------------------------------------------
    # 相手の尻がホールド状態になっている場合は不可
    #--------------------------------------------------------------------------
    return false if target.hold.anal.battler != nil
=begin シックスナイン体勢なら可能なのでコメントアウト
    #--------------------------------------------------------------------------
    # 体勢的に不可
    #--------------------------------------------------------------------------
    # 自分の秘部が相手の口でホールドされている
    return false if self.hold.penis.parts == "口" and self.hold.penis.battler == target
    return false if self.hold.dildo.parts == "口" and self.hold.dildo.battler == target
    return false if self.hold.vagina.parts == "口" and self.hold.vagina.battler == target
    #--------------------------------------------------------------------------
=end
    return true
  end
  #--------------------------------------------------------------------------
  # ● もがいて良いか？
  #--------------------------------------------------------------------------
  def can_struggle?
    result = false
    if (
    self.bind? or
    self.pahupahu? or
    self.paizuri? or
    self.draw? or
    self.hipriding? or
    self.riding? or
    self.oralsex? or
    self.vagina_insert_special? or 
    self.tentacle_bind? or
    self.tentacle_absorb?
    ) and not self.initiative?
      result = true
    end
    return result
  end
  #--------------------------------------------------------------------------
  # ● 対象の精液が自分にかかるか？
  #--------------------------------------------------------------------------
  def sperm_me?(target = $game_actors[101])
    result = true
    # 対象が裸になっていない場合、偽を返す
    unless target.nude?
      result = false
    end
    # 対象のペニスが自分以外の誰かにホールドされている場合、偽を返す
    if target.hold.penis.battler != nil and target.hold.penis.battler != self
      result = false
    end
    return result
  end
  #--------------------------------------------------------------------------
  # ● 顔が塞がれているか？
  #--------------------------------------------------------------------------
  def face_blind?
    result = false
    result = true if self.mouth_riding? # 自分が顔面騎乗を受けている
    result = true if self.mouth_hipriding? # 自分が尻顔面騎乗を受けている
    result = true if self.mouth_pahupahu? # 自分がぱふぱふを受けている
    return result
  end
  #----------------------------------------------------------------
  # ● 適正ターゲットの確認
  #----------------------------------------------------------------
  def proper_target?(target, skill_id = nil)
    #アイテム使用の場合はターゲット確認をスルーする
    if self.current_action.kind == 2
      return true
    end
    #----------------------------------------------------------------
    # スキルが設定されている場合
    if skill_id != nil 
      # 使用スキルの確認
      skill = $data_skills[skill_id]
      #----------------------------------------------------------------
      # 以下のスキルは適正ターゲットを無視する
      #----------------------------------------------------------------
      # 敵１人を対象とするスキルのうち
      if skill.scope == 1
        # サポートスキル
#        return true if skill.element_set.include?(4)
        # 魔法スキル
#        return true if skill.element_set.include?(5)
      else
        # 敵１人だけを対象としない場合は以下すべて無視
        return true
      end
    end
    #----------------------------------------------------------------
    # 適正ターゲット用の初期化
    proper_battlers = []
    target_group = $game_party.battle_actors + $game_troop.enemies
    # ホールド中且つホールド中スキルの場合、
    # ホールド相手を適正ターゲットに入れる
    if self.holding? and skill.element_set.include?(132)
      proper_battlers.push(self.hold.mouth.battler)
      proper_battlers.push(self.hold.anal.battler)
      proper_battlers.push(self.hold.penis.battler)
      proper_battlers.push(self.hold.vagina.battler)
      proper_battlers.push(self.hold.tops.battler)
      proper_battlers.push(self.hold.tail.battler)
      proper_battlers.push(self.hold.dildo.battler)
      proper_battlers.push(self.hold.tentacle.battler)
      proper_battlers.compact!
    # それ以外の場合、全員を適正ターゲットに入れる
    else
      for target_one in target_group
        proper_battlers.push(target_one) if target_one.exist?
      end
    end
=begin
    # 上半身拘束（エンブレイス等）を受けている、してる場合は
    # その相手のみを適正ターゲットにする
    # ※触手拘束の場合、触手側はこの制限を受けない
    if self.hold.tops.type == "拘束"
      proper_battlers = [self.hold.tops.battler]
    end
=end
    #----------------------------------------------------------------
    # 適正ターゲット内の挑発中の相手の存在を確認する
    incite_battlers = []
    for proper_one in proper_battlers
      if proper_one.incite_success? 
        # 自分から見て敵のバトラーが挑発中の場合は挑発中配列に入れる
        if (self.is_a?(Game_Actor) and proper_one.is_a?(Game_Enemy)) or 
         (self.is_a?(Game_Enemy) and proper_one.is_a?(Game_Actor))
          incite_battlers.push(proper_one)
        end
      end
    end
    #--------------------------------------------------------------------
    # 適正ターゲット内に現在選んでいる対象がいる場合、マーキング系の確認
    #--------------------------------------------------------------------
    # 結果を真に初期化
    result = true
    if proper_battlers.include?(target)
      #----------------------------------------------------------------
      # ※上位ほど優先度が上がる
      #----------------------------------------------------------------
      # このバトラーがエネミー且つ【妄執】持ちの場合、主人公以外だとエラー
      if self.have_ability?("妄執") and self.is_a?(Game_Enemy) and
       target != $game_actors[101] and proper_battlers.include?($game_actors[101])
        result = false
      #----------------------------------------------------------------
      # 主人公が無防備状態の場合、主人公以外だとエラー
      elsif $game_actors[101].state?(95) and
       target != $game_actors[101] and proper_battlers.include?($game_actors[101])
        result = false
      #----------------------------------------------------------------
      # 適正ターゲット内に挑発中の相手がおり、
      # その相手を狙っていない場合エラー
      elsif not incite_battlers.include?(target) and
       incite_battlers.size > 0
        result = false
        # 挑発相手を狙っていない場合、誘引成功フラグを立てる
        # （※対象のスムーズな決定と連動）
        $game_temp.incite_flag = true
      #----------------------------------------------------------------
      # 適正ターゲット内にマーキングしている相手がおり、
      # その相手を狙っていない場合エラー
      elsif proper_battlers.include?(self.marking_battler) and
       self.marking? and self.marking_battler != target
        result = false
=begin       
        text = ""
        for pro in proper_battlers
          text += "\n" if text != ""
          text += pro.name
        end
        text = "proper_battlers\n" + text
        print text
=end
      end
    #----------------------------------------------------------------
    # 適正ターゲット内に現在選んでいる対象がいない場合、エラー
    #----------------------------------------------------------------
    else
      result = false
    end
    # 結果を返す
    return result
  end
  
  #----------------------------------------------------------------
  # ● 挑発成功？
  #----------------------------------------------------------------
  def incite_success?
    return ((self.state?(96) or self.state?(104)) and self.bad_state_number <= 0)
  end
  #----------------------------------------------------------------
  # ● デフォルトの呼び方（一人称）
  #----------------------------------------------------------------
  def defaultname_self
    text = ""
    if @defaultname_self != nil
      text = @defaultname_self
    else
      text = $data_SDB[self.class_id].default_name_self
    end
    text.gsub!("夢魔名","#{self.name}")
    text.gsub!("夢魔短縮名","#{$msg.short_name(self)}")
    return text
  end
  #----------------------------------------------------------------
  # ● デフォルトの呼び方（二人称）
  #----------------------------------------------------------------
  def defaultname_hero
    text = ""
    if @defaultname_hero != nil
      text = @defaultname_hero
    else
      text = $data_SDB[self.class_id].default_name_hero
    end
    text.gsub!("主人公名","#{$game_actors[101].name}")
    text.gsub!("主人公短縮名","#{$msg.short_name($game_actors[101])}")
    return text
  end
  #----------------------------------------------------------------
  # ● 呼び方（一人称）
  #----------------------------------------------------------------
  def nickname_self
    text = self.defaultname_self
    text = @nickname_self if @nickname_self != nil
    text.gsub!("夢魔名","#{self.name}")
    text.gsub!("夢魔短縮名","#{$msg.short_name(self)}")
    return text
  end
  #----------------------------------------------------------------
  # ● 呼び方（ニ人称）
  #----------------------------------------------------------------
  def nickname_master
    text = self.defaultname_hero
    text = @nickname_master if @nickname_master != nil
    text.gsub!("主人公名","#{$game_actors[101].name}")
    text.gsub!("主人公短縮名","#{$msg.short_name($game_actors[101])}")
    return text
  end
  #----------------------------------------------------------------
  # ● defining UK names - temporary definition w/ rescue
  #----------------------------------------------------------------
  def UK_name
    text = self.defaultname_self
    if self.is_a?(Game_Enemy)
      text = $data_enemies[@enemy_id].UK_name rescue text = error
      else text = "not an enemy"
    end
    return text
  end
end