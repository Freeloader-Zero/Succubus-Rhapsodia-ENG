#==============================================================================
# ■ Game_Battler (分割定義 2)
#------------------------------------------------------------------------------
# 　バトラーを扱うクラスです。このクラスは Game_Actor クラスと Game_Enemy クラ
# スのスーパークラスとして使用されます。
#==============================================================================

class Game_Battler
  #--------------------------------------------------------------------------
  # ● ボス用のグラフィック？
  #--------------------------------------------------------------------------
  def boss_graphic?
    return @battler_name.include?("boss_")
  end
  #--------------------------------------------------------------------------
  # ● クラス名の取得
  #--------------------------------------------------------------------------
  def class_name
    return $data_classes[self.class_id].name
  end
  #--------------------------------------------------------------------------
  # ● 年齢帯の取得
  #--------------------------------------------------------------------------
  def age
    return $data_SDB[self.class_id].years_type
  end
  #--------------------------------------------------------------------------
  # ● クラス色の取得
  #--------------------------------------------------------------------------
  def class_color
    return $data_classes[self.class_id].color
  end
  #--------------------------------------------------------------------------
  # ● 種族の取得(口上の変化が特定条件で発生する夢魔等の管理で使用)
  #--------------------------------------------------------------------------
  # ●種族
  def tribe
    return $data_SDB[self.class_id].name
  end
  #●人間属(明らかに夢魔・魔物でない方々)
  def tribe_human?
    case $data_SDB[self.class_id].name
    when "Little Witch","Witch ","Caster","Slave "
      return true
    when "Priestess ","Cursed Magus","Ramile","Huｍan"
      return true
    else
      return false
    end
  end
  #●スライム属(服が粘液)
  def tribe_slime?
    case $data_SDB[self.class_id].name
    when "Sliｍe","Gold Sliｍe ","Queen Sliｍe"
      return true
    else
      return false
    end
  end
  #●ガーゴイル属(服が鱗)
  def tribe_gargoyle?
    return true if $data_SDB[self.class_id].name == "Gargoyle"
    return false
  end
  #●ファミリア属(同種に対して口調が変わる)
  def tribe_familiar?
    return true if $data_SDB[self.class_id].name == "Familiar"
    return false
  end
  #●子鬼属(コマンダー指揮範囲となる。インプも例外的に含まれる)
  def tribe_gobrin?
    case $data_SDB[self.class_id].name
    when "Goblin","Goblin Leader ","Iｍp"
      return true
    else
      return false
    end
  end
  #--------------------------------------------------------------------------
  # ● 胸サイズ表現の取得
  #--------------------------------------------------------------------------
  def bustsize
    bust = "胸"
    case $data_SDB[self.class_id].bust_size
    when 0 #ロウ君
      bust = "chest"
    when 1 #Ａ
      bust = "youthful breasts"
    when 2 #Ｂ
      bust = "shapely breasts"
    when 3 #Ｃ
      bust = "round breasts"
    when 4 #Ｄ
      bust = "voluptuous breasts"
    when 5 #Ｅ以上
      bust = "incredible breasts"
    end
    return bust
  end
  #--------------------------------------------------------------------------
  # ★ 特殊判定
  #--------------------------------------------------------------------------
  # ●男であるかどうかの判定(原則ロウ君のみがこれに合致)
  def boy?
    return false if self.have_ability?("女")
    return false if self.have_ability?("両性具有")
    return true if self.have_ability?("男")
    return false
  end
  # 女であるかどうかの判定(夢魔は原則こちら)
  def girl?
    return false if self.have_ability?("男")
    return true if self.have_ability?("女")
    return false
  end
  # 両性具有状態(夢魔の特殊状態)
  def futanari?
    return false if self.have_ability?("男")
    return true if self.have_ability?("両性具有")
    return false
  end
  # ディルド装備か否かの判定
  def equip_dildo?
    return false if self.have_ability?("男") #主人公は自前のがあるためfalse
    return true if self.have_ability?("イクイップディルド")
    return false
  end
  # 粘液状態(ダメージ計算等に使用)
  def wet?
    return true if self.states.include?(27) #粘液潤滑少
    return true if self.states.include?(28) #粘液潤滑多
    return true if self.states.include?(29) #スライム
    return true if self.states.include?(31) #ローション
    return false
  end
  # 絶頂維持状態(追撃率変化に使用)
  def weaken?
    return true if self.states.include?(2) #衰弱
    return true if self.states.include?(3) #絶頂
    return false
  end
  # 会話可能か否か(トーク設定に使用)
  def talkable?
    return false if self.states.include?(2) #衰弱
    return false if self.states.include?(3) #絶頂
    return false if self.states.include?(34) #恍惚
    return false if self.states.include?(36) #暴走
    return false if self.dead?
    return false unless self.exist?
    return true
  end
  #興奮状態か否か(服ビリビリ用)
  def excited?
    return true if self.states.include?(6)  #クライシス
    return true if self.states.include?(35) #欲情
    return true if self.states.include?(36) #暴走
    return true if self.states.include?(41) #高揚
    return true if self.have_ability?("サディスト") and $mood.point > 30
    return false
  end
  #ホールド中か否か(自分がいずれかのホールド状態ならtrue)
  def holding?
    return true if self.hold.mouth.battler != nil
    return true if self.hold.tops.battler != nil
    return true if self.hold.penis.battler != nil
    return true if self.hold.vagina.battler != nil
    return true if self.hold.anal.battler != nil
    return true if self.hold.tail.battler != nil
    return true if self.hold.tentacle.battler != nil 
    return true if self.hold.dildo.battler != nil
    return false
  end
  #アクション対象とホールド状態か否か(対象が居ない場合はfalse)
  def holding_now?
    if $msg.t_enemy != nil and $msg.t_target != nil
      target = $msg.t_enemy if self.is_a?(Game_Actor)
      target = $msg.t_target if self.is_a?(Game_Enemy)
    elsif $game_temp.battle_target_battler[0] != nil
      target = $game_temp.battle_target_battler[0]
    else
      target = nil
    end
    return false if target == nil
    return false unless self.holding?
    return true if self.hold.mouth.battler == target
    return true if self.hold.tops.battler == target
    return true if self.hold.penis.battler == target
    return true if self.hold.vagina.battler == target
    return true if self.hold.anal.battler == target
    return true if self.hold.tail.battler == target
    return true if self.hold.tentacle.battler == target
    return true if self.hold.dildo.battler == target
    return false
  end
  #乱交中か否か(２箇所以上の複数個所がホールドされていればtrue)
  def dancing?
    dc = 0
    dc += 1 if self.hold.mouth.battler != nil
    dc += 1 if self.hold.tops.battler != nil
    dc += 1 if self.hold.penis.battler != nil
    dc += 1 if self.hold.vagina.battler != nil
    dc += 1 if self.hold.anal.battler != nil
    dc += 1 if self.hold.tail.battler != nil
#    dc += 1 if self.hold.tentacle.battler != nil
    dc += 1 if self.hold.dildo.battler != nil
    dc -= 1 if self.hold.vagina.type == "貝合わせ" #♀とAの二箇所占有のため
    return true if dc >= 2
    return false
  end
  #優位状態か否か(ホールド状態でない場合はfalse)
  def initiative?
    return self.hold.initiative?
    # 以下、前記述。
    # ※ホールドされてない箇所があるだけでtrueを返すようになっている。
=begin
    if self.holding?
      return true unless self.hold.penis.initiative == 0
      return true unless self.hold.mouth.initiative == 0
      return true unless self.hold.anal.initiative == 0
      return true unless self.hold.vagina.initiative == 0
      return true unless self.hold.tops.initiative == 0
      return true unless self.hold.tail.initiative == 0
      return true unless self.hold.dildo.initiative == 0
      return true unless self.hold.tentacle.initiative == 0
    end
    return false
=end
  end
  #アクション対象に対して優位状態か否か(ホールド状態でない場合はfalse)
  def initiative_now?
    if self.holding_now?
      return true unless self.hold.penis.initiative == 0
      return true unless self.hold.mouth.initiative == 0
      return true unless self.hold.anal.initiative == 0
      return true unless self.hold.vagina.initiative == 0
      return true unless self.hold.tops.initiative == 0
      return true unless self.hold.tail.initiative == 0
      return true unless self.hold.dildo.initiative == 0
      return true unless self.hold.tentacle.initiative == 0
    end
    return false
  end
  #ホールドイニシアチブの値の最大値を算出
  def initiative_level
    unless self.holding?
      return 0
    else
      intv = intv2 = 0
      intv = self.hold.penis.initiative if self.hold.penis.initiative != nil
      intv2 = self.hold.mouth.initiative if self.hold.mouth.initiative != nil
      intv = intv2 if intv2 > intv
      intv2 = self.hold.vagina.initiative if self.hold.vagina.initiative != nil
      intv = intv2 if intv2 > intv
      intv2 = self.hold.anal.initiative if self.hold.anal.initiative != nil
      intv = intv2 if intv2 > intv
      intv2 = self.hold.tops.initiative if self.hold.tops.initiative != nil
      intv = intv2 if intv2 > intv
      intv2 = self.hold.tail.initiative if self.hold.tail.initiative != nil
      intv = intv2 if intv2 > intv
      intv2 = self.hold.dildo.initiative if self.hold.dildo.initiative != nil
      intv = intv2 if intv2 > intv
      intv2 = self.hold.tentacle.initiative if self.hold.tentacle.initiative != nil
      intv = intv2 if intv2 > intv
      return intv
    end
  end
  #ホールド個別ごとのイニシアチブを算出
  #ペニス
  def penis_intv
    return self.hold.penis.initiative
  end
  #アソコ
  def vagina_intv
    return self.hold.vagina.initiative
  end
  #口
  def mouth_intv
    return self.hold.mouth.initiative
  end
  #お尻
  def anal_intv
    return self.hold.anal.initiative
  end
  #上半身
  def tops_intv
    return self.hold.tops.initiative
  end
  #尻尾
  def tail_intv
    return self.hold.tail.initiative
  end
  #触手
  def tentacle_intv
    return self.hold.tentacle.initiative
  end
  #ディルド
  def dildo_intv
    return self.hold.dildo.initiative
  end
  #状態判断メソッド追加
  #対象と♀インサート状態か否か
  def inserting_now?
    if $msg.t_enemy != nil and $msg.t_target != nil
      target = $msg.t_enemy if self.is_a?(Game_Actor)
      target = $msg.t_target if self.is_a?(Game_Enemy)
    elsif $game_temp.battle_target_battler[0] != nil
      target = $game_temp.battle_target_battler[0]
    else
      target = nil
    end
    return false if target == nil
    return false unless (self.insert? and target.insert?)
    #自分の♀に挿入中
    if self.vagina_insert?
      return true if self.hold.vagina.battler == target
    else
      return true if self.hold.penis.battler == target
      return true if self.hold.tail.battler == target
      return true if self.hold.tentacle.battler == target
      return true if self.hold.dildo.battler == target
    end
    return false
  end
  #対象と口インサート状態か否か
  def oralsex_now?
    if $msg.t_enemy != nil and $msg.t_target != nil
      target = $msg.t_enemy if self.is_a?(Game_Actor)
      target = $msg.t_target if self.is_a?(Game_Enemy)
    elsif $game_temp.battle_target_battler[0] != nil
      target = $game_temp.battle_target_battler[0]
    else
      target = nil
    end
    return false if target == nil
    return false unless (self.oralsex? and target.oralsex?)
    #自分の口に挿入中
    if self.mouth_oralsex?
      return true if self.hold.mouth.battler == target
    else
      return true if self.hold.penis.battler == target
      return true if self.hold.tail.battler == target
      return true if self.hold.tentacle.battler == target
      return true if self.hold.dildo.battler == target
    end
    return false
  end
  #対象とアナルインサート状態か否か
  def analsex_now?
    if $msg.t_enemy != nil and $msg.t_target != nil
      target = $msg.t_enemy if self.is_a?(Game_Actor)
      target = $msg.t_target if self.is_a?(Game_Enemy)
    elsif $game_temp.battle_target_battler[0] != nil
      target = $game_temp.battle_target_battler[0]
    else
      target = nil
    end
    return false if target == nil
    return false unless (self.analsex? and target.analsex?)
    if self.anal_analsex?
      return true if self.hold.anal.battler == target
    else
      return true if self.hold.penis.battler == target
      return true if self.hold.tail.battler == target
      return true if self.hold.tentacle.battler == target
      return true if self.hold.dildo.battler == target
    end
    return false
  end
  #対象とシェルマッチ状態か否か
  def shellmatch_now?
    if $msg.t_enemy != nil and $msg.t_target != nil
      target = $msg.t_enemy if self.is_a?(Game_Actor)
      target = $msg.t_target if self.is_a?(Game_Enemy)
    elsif $game_temp.battle_target_battler[0] != nil
      target = $game_temp.battle_target_battler[0]
    else
      target = nil
    end
    return false if target == nil
    return false unless (self.shellmatch? and target.shellmatch?)
    return true if self.hold.vagina.battler == target
    return false
  end
  #対象と顔面騎乗状態か否か
  def riding_now?
    if $msg.t_enemy != nil and $msg.t_target != nil
      target = $msg.t_enemy if self.is_a?(Game_Actor)
      target = $msg.t_target if self.is_a?(Game_Enemy)
    elsif $game_temp.battle_target_battler[0] != nil
      target = $game_temp.battle_target_battler[0]
    else
      target = nil
    end
    return false if target == nil
    return false unless (self.riding? and target.riding?)
    if self.vagina_riding?
      return true if self.hold.vagina.battler == target
    else
      return true if self.hold.mouth.battler == target
    end
    return false
  end
  #対象と密着状態か否か
  def binding_now?
    if $msg.t_enemy != nil and $msg.t_target != nil
      target = $msg.t_enemy if self.is_a?(Game_Actor)
      target = $msg.t_target if self.is_a?(Game_Enemy)
    elsif $game_temp.battle_target_battler[0] != nil
      target = $game_temp.battle_target_battler[0]
    else
      target = nil
    end
    return false if target == nil
    return false unless (self.bind? and target.bind?)
    #身体で密着中の場合
    if self.tops_binder? or self.tops_binding?
      return true if self.hold.tops.battler == target
    elsif self.tentacle_binder?
      return true if self.hold.tentacle.battler == target
    else
      return true if self.hold.tops.battler == target
    end
    return false
  end
  #対象とパイズリ状態か否か
  def paizuri_now?
    if $msg.t_enemy != nil and $msg.t_target != nil
      target = $msg.t_enemy if self.is_a?(Game_Actor)
      target = $msg.t_target if self.is_a?(Game_Enemy)
    elsif $game_temp.battle_target_battler[0] != nil
      target = $game_temp.battle_target_battler[0]
    else
      target = nil
    end
    return false if target == nil
    return false unless (self.paizuri? and target.paizuri?)
    if self.tops_paizuri?
      return true if self.hold.tops.battler == target
    else
      return true if self.hold.penis.battler == target
    end
    return false
  end
  #対象とクンニ状態か否か
  def drawing_now?
    if $msg.t_enemy != nil and $msg.t_target != nil
      target = $msg.t_enemy if self.is_a?(Game_Actor)
      target = $msg.t_target if self.is_a?(Game_Enemy)
    elsif $game_temp.battle_target_battler[0] != nil
      target = $game_temp.battle_target_battler[0]
    else
      target = nil
    end
    return false if target == nil
    return false unless (self.draw? and target.draw?)
    if self.mouth_draw?
      return true if self.hold.mouth.battler == target
    elsif self.vagina_draw?
      return true if self.hold.vagina.battler == target
    elsif self.tentacle_draw?
      return true if self.hold.tentacle.battler == target
    elsif self.tentacle_vagina_draw?
      return true if self.hold.vagina.battler == target
    end
    return false
  end
  #対象と触手吸引状態か否か(♂)
  def usetentacle_now?
    if $msg.t_enemy != nil and $msg.t_target != nil
      target = $msg.t_enemy if self.is_a?(Game_Actor)
      target = $msg.t_target if self.is_a?(Game_Enemy)
    elsif $game_temp.battle_target_battler[0] != nil
      target = $game_temp.battle_target_battler[0]
    else
      target = nil
    end
    return false if target == nil
    return false unless (self.tentacle_absorb? and target.tentacle_absorb?)
    if self.tentacle_absorbing?
      return true if self.hold.tentacle.battler == target
    elsif self.tentacle_penis_absorbing?
      return true if self.hold.penis.battler == target
    end
    return false
  end
  #精神系バステ状態(恍惚、欲情、暴走)
  def badstate_mental?
    return true if self.states.include?(33) #ドキドキ
    return true if self.states.include?(34) #恍惚
    return true if self.states.include?(35) #欲情
    return true if self.states.include?(36) #暴走
    return false
  end
  #呪詛系バステ状態(虚脱、畏怖、麻痺、散漫)
  def badstate_curse?
    return true if self.states.include?(37) #虚脱
    return true if self.states.include?(38) #畏怖
    return true if self.states.include?(39) #麻痺
    return true if self.states.include?(40) #散漫
    return false
  end
  #物理系バステ状態(張型、触手、拘束等)
  def badstate_tool?
    #現在は該当ステートがないのでfalse
    return false
  end
  #パラメータアップ状態(ブルム系魔法効果)
  def param_up?
    correct = [55,56,59,60,63,64,67,68,71,72,75,76]
    for i in correct
      return true if self.states.include?(i)
    end
    return false
  end
  #パラメータダウン状態(イーザ系魔法効果)
  def param_down?
    correct = [57,58,61,62,65,66,69,70,73,74,77,78]
    for i in correct
      return true if self.states.include?(i)
    end
    return false
  end
  #ピストン系ホールドで絶頂(絶頂コモンの画面揺れ処理に使用)
  def shake_tate?
    return true if self.insert? and not self.vagina_insert?
    return true if self.oralsex?
    return true if self.mouth_draw?
    return true if self.mouth_riding?
    return true if self.mouth_hipriding?
    return true if self.tops_paizuri?
    return false
  end
  #グラインド系ホールドで絶頂(絶頂コモンの画面揺れ処理に使用)
  def shake_yoko?
    return true if self.vagina_insert?
    return true if self.vagina_riding?
    return true if self.shellmatch?
    return true if self.anal_analsex?
    return true if self.anal_hipriding?
    return false
  end
  #性格診断(主に口上分岐に使用)
  def positive?
    case self.personality
    when "勝ち気","意地悪","高慢","好色","甘え性","独善"
      return true
    else
      return false
    end
  end
  def negative?
    case self.personality
    when "内気","従順","淡泊","虚勢","上品"
      return true
    else
      return false
    end
  end
  def neutral?
    case self.personality
    when "柔和","陽気","天然","不思議","倒錯"
      return true
    else
      return false
    end
  end
  #--------------------------------------------------------------------------
  # ★ 種族名の取得
  #--------------------------------------------------------------------------
  def race_name
    return $data_classes[self.class_id].name
  end
  #--------------------------------------------------------------------------
  # ★ 種族名の取得
  #--------------------------------------------------------------------------
  def race_color
    return $data_classes[self.class_id].color
  end
  #--------------------------------------------------------------------------
  # ● ステートの検査
  #     state_id : ステート ID
  #--------------------------------------------------------------------------
  def state?(state_id)
    # 該当するステートが付加されていれば true を返す
    return @states.include?(state_id)
  end
  #--------------------------------------------------------------------------
  # ● ステートの変動検査
  #     state_id : ステート ID
  #--------------------------------------------------------------------------
  def chenge_state?(state_id)
    # 該当するステートが付加されていれば true を返す
    return @states.include?(state_id) == @last_states.include?(state_id)
  end
  #--------------------------------------------------------------------------
  # ● ステートがフルかどうかの判定
  #     state_id : ステート ID
  #--------------------------------------------------------------------------
  def state_full?(state_id)
    # 該当するステートが付加されていなけば false を返す
    unless self.state?(state_id)
      return false
    end
    # 持続ターン数が -1 (オートステート) なら true を返す
    if @states_turn[state_id] == -1
      return true
    end
    # 持続ターン数が自然解除の最低ターン数と同じなら true を返す
    return @states_turn[state_id] == $data_states[state_id].hold_turn
  end
  #--------------------------------------------------------------------------
  # ● ステートの付加
  #     state_id : ステート ID
  #     force    : 強制付加フラグ (オートステートの処理で使用)
  #--------------------------------------------------------------------------
  def add_state(state_id, force = false, ragistance = false)
    # 無効なステートの場合
    if $data_states[state_id] == nil
      # メソッド終了
      return
    end
    # 強制付加ではない場合
    unless force
      # 既存のステートのループ
      for i in @states
        # 新しいステートが既存のステートのステート変化 (-) に含まれており、
        # そのステートが新しいステートのステート変化 (-) には含まれない場合
        # (ex : 戦闘不能のときに毒を付加しようとした場合)
        if $data_states[i].minus_state_set.include?(state_id) and
           not $data_states[state_id].minus_state_set.include?(i)
          # メソッド終了
          return
        end
      end
    end
    # このステートが付加されていない場合
    unless state?(state_id)

      # 耐性値を計算する場合
      if ragistance == true
        per = self.state_percent(nil, state_id, nil)
        add_flag = false
        # 乱数チェック
        if rand(100) < per
          add_flag = true
        end
        # add_flagが偽の場合はメソッドを終了
        return if add_flag == false
      end
      
      # ステート ID を @states 配列に追加
      @states.push(state_id)
      # 戦闘中の場合、付与ステート情報を記録
      if $game_temp.in_battle
        @add_states_log.push($data_states[state_id])
      end
      # オプション [HP 0 の状態とみなす] が有効の場合
      if $data_states[state_id].zero_hp
        # HP を 0 に変更
        @hp = 0
        @sp = 0
      end
      # 全ステートのループ
      for i in 1...$data_states.size
        # ステート変化 (+) 処理
        if $data_states[state_id].plus_state_set.include?(i)
          add_state(i)
        end
        # ステート変化 (-) 処理
        if $data_states[state_id].minus_state_set.include?(i)
          remove_state(i)
        end
      end
      
      # 破面は併発を通る
      persona_break if state_id == 106
      
      # レーティングの大きい順 (同値の場合は制約の強い順) に並び替え
      @states.sort! do |a, b|
        state_a = $data_states[a]
        state_b = $data_states[b]
        if state_a.rating > state_b.rating
          -1
        elsif state_a.rating < state_b.rating
          +1
        elsif state_a.restriction > state_b.restriction
          -1
        elsif state_a.restriction < state_b.restriction
          +1
        else
          a <=> b
        end
      end
    end
    # 強制付加の場合
    if force
      # 自然解除の最低ターン数を -1 (無効) に設定
      @states_turn[state_id] = -1
    end
    # 強制付加ではない場合
    unless  @states_turn[state_id] == -1
      # 自然解除の最低ターン数を設定
      @states_turn[state_id] = $data_states[state_id].hold_turn
    end
    # 行動不能の場合
    unless movable?
      # アクションをクリア(ただしお任せステート付与時はスルーする)
      @current_action.clear unless state_id == 95
    end
    # HP および SP の最大値チェック
    @hp = [@hp, self.maxhp].min
    @sp = [@sp, self.maxsp].min
  end
  #--------------------------------------------------------------------------
  # ● ステートの解除
  #     state_id : ステート ID
  #     force    : 強制解除フラグ (オートステートの処理で使用)
  #--------------------------------------------------------------------------
  def remove_state(state_id, force = false)
    # このステートが付加されている場合
    if state?(state_id)
      # 強制付加されたステートで、かつ解除が強制ではない場合
      if @states_turn[state_id] == -1 and not force
        # メソッド終了
        return
      end
      # 現在の HP が 0 かつ オプション [HP 0 の状態とみなす] が有効の場合
      if @hp == 0 and $data_states[state_id].zero_hp
        # ほかに [HP 0 の状態とみなす] ステートがあるかどうか判定
        zero_hp = false
        for i in @states
          if i != state_id and $data_states[i].zero_hp
            zero_hp = true
          end
        end
        # 戦闘不能を解除してよければ、HP を 1 に変更
        if zero_hp == false
          @sp = 1
        end
        if self.is_a?(Game_Actor)
          self.fed = 20 if self.fed == 0
        end
      end
      # ステート ID を @states 配列および @states_turn ハッシュから削除
      @states.delete(state_id)
      @states_turn.delete(state_id)
      # 戦闘中の場合、解除ステート情報を記録
      if $game_temp.in_battle
        @remove_states_log.push($data_states[state_id])
      end
    end
    # HP および SP の最大値チェック
    @hp = [@hp, self.maxhp].min
    @sp = [@sp, self.maxsp].min
  end
  #--------------------------------------------------------------------------
  # ● ステートのアニメーション ID 取得
  #--------------------------------------------------------------------------
  def state_animation_id
    # ステートがひとつも付加されていない場合
    if @states.size == 0
      return 0
    end
    # レーティング最大のステートのアニメーション ID を返す
    return $data_states[@states[0]].animation_id
  end
  #--------------------------------------------------------------------------
  # ● 制約の取得
  #--------------------------------------------------------------------------
  def restriction
    restriction_max = 0
    # 現在付加されているステートから最大の restriction を取得
    for i in @states
      if $data_states[i].restriction >= restriction_max
        restriction_max = $data_states[i].restriction
      end
    end
    return restriction_max
  end
  #--------------------------------------------------------------------------
  # ● ステート [EXP を獲得できない] 判定
  #--------------------------------------------------------------------------
  def cant_get_exp?
    for i in @states
      if $data_states[i].cant_get_exp
        return true
      end
    end
    return false
  end
  #--------------------------------------------------------------------------
  # ● ステート [攻撃を回避できない] 判定
  #--------------------------------------------------------------------------
  def cant_evade?
    for i in @states
      if $data_states[i].cant_evade
        return true
      end
    end
    return false
  end
  #--------------------------------------------------------------------------
  # ● ステート [スリップダメージ] 判定
  #--------------------------------------------------------------------------
  def slip_damage?
    for i in @states
      if $data_states[i].slip_damage
        return true
      end
    end
    return false
  end
  #--------------------------------------------------------------------------
  # ● バトル用ステートの解除 (バトル終了時に呼び出し)
  #--------------------------------------------------------------------------
  def remove_states_battle
    for i in @states.clone
      if $data_states[i].battle_only
        remove_state(i)
      end
    end
  end
  #--------------------------------------------------------------------------
  # ● ステート自然解除 (ターンごとに呼び出し)
  #--------------------------------------------------------------------------
  def remove_states_auto
    for i in @states_turn.keys.clone
      if @states_turn[i] > 0
        @states_turn[i] -= 1
      elsif rand(100) < $data_states[i].auto_release_prob
        remove_state(i)
      end
    end
  end
  #--------------------------------------------------------------------------
  # ● ステート衝撃解除 (物理ダメージごとに呼び出し)
  #--------------------------------------------------------------------------
  def remove_states_shock
    for i in @states.clone
      if rand(100) < $data_states[i].shock_release_prob
        remove_state(i)
      end
    end
  end
  #--------------------------------------------------------------------------
  # ● ステート衝撃解除 (物理ダメージごとに呼び出し)
  #--------------------------------------------------------------------------
  def remove_states_shock
    for i in @states.clone
      if rand(100) < $data_states[i].shock_release_prob
        remove_state(i)
      end
    end
  end
  #--------------------------------------------------------------------------
  # ● ステート有効度の取得
  #--------------------------------------------------------------------------
  def state_percent(user = nil, state_id = 1, skill = nil)
    state_name = $data_states[state_id].name
    # 確定フラグを初期化 (1:確定付与 2:確定無効)
    absolute_flag = 0
    # ■基本成功率を取得
    if self.is_a?(Game_Enemy)
      # エネミーの場合、有効度を参照
      # ※ A:100%(必中) / B:80% / C:60% / D:40% / E:20% / F:0%(無効)
      plus = [100,100,20,0,-20,-50,-100][self.state_ranks[state_id]]
      # 【スキルの魔法防御有効度=スキルのステート付与が失敗する確率の高さ】
      if skill != nil
        effect_percent = skill.mdef_f + plus
      else
        effect_percent = 50 + plus
      end
      # 有効度がＡ、または魔法防御有効度100の場合必中と見なす
      if self.state_ranks[state_id] == 1 or (skill != nil and skill.mdef_f == 100)
        absolute_flag = 1
      end
      # 有効度がＦ、または魔法防御有効度0の場合無効と見なす
      if self.state_ranks[state_id] == 6 or (skill != nil and skill.mdef_f == 0)
        absolute_flag = 2
      end
    elsif self.is_a?(Game_Actor)
      # アクターの場合、スキルの【魔法防御有効度を参照】(重要)
      # ※アクター自身の魔法防御は参照されない
      # 【スキルの魔法防御有効度=スキルのステート付与が失敗する確率の高さ】
      if skill != nil
        effect_percent = skill.mdef_f
      else
        effect_percent = 50
      end
      # 有効度100の場合必中と見なす
      absolute_flag = 1 if effect_percent == 100
      # 有効度0の場合無効と見なす
      absolute_flag = 2 if effect_percent == 0
    end

    n = m = 0
    if skill != nil
      # ■ステータスによる補正
      if skill.element_set.include?(44) #魅力を考慮する場合
        n = (user.atk / 10).floor
      elsif skill.element_set.include?(45) #器用さを考慮する場合
        n = (user.dex / 10).floor
      elsif skill.element_set.include?(46) #精神力を考慮する場合
        n = (user.int / 10).floor
      end
      m = (self.int / 10).floor #防御側は一括で精神を使用
    end
    effect_percent = effect_percent + n - m
    
    # 素質・装備品などの耐性値を計算
    registance = self.state_registance(state_id)
    registance_perpercent = registance[0]
    registance_flag       = registance[1]
    
    effect_percent *= registance_perpercent
    effect_percent = effect_percent.truncate
    absolute_flag = registance_flag if absolute_flag == 0
    
    if skill != nil
      # ■素質やステートによる補正
      # 魔法系を無効化する【プロテクション】
      if self.have_ability?("プロテクション")
        if skill.element_set.include?(5)
          absolute_flag = 2
        end
      end
      # 胞子系を無効化する【免疫力】
      if self.have_ability?("免疫力")
        if skill.element_set.include?(206)
          absolute_flag = 2
        end
      end
    end
    
    # 防御中は付与率半減、大防御中は直接付与以外を無効化する
    if self.states.include?(94) #大防御
      # 有利ステートの存在もあるため、確定フラグではなく-999で返す
      absolute_flag = -999 
    elsif self.states.include?(93) #防御
      effect_percent /= 2
    end
    return 100 if absolute_flag == 1
    return 0   if absolute_flag == 2
    return effect_percent
  end

  #--------------------------------------------------------------------------
  # ● ステート発生率
  #--------------------------------------------------------------------------
  def state_registance(state_id)
    result = 100
    absolute_flag = 0 # 0:通常, 1:確定で付く, 2:確定で付かない
    
    # 発生確率のため、耐性を付ける場合は100％から減算する
    
    # 耐性ルーンの耐性値
    rune_registance = 40
    # 耐性素質の耐性値
    ability_registance = 75
    # 彩花巻きの全耐性値
    flower_roll_registance = 50
    # 一匹狼の誡の全耐性値
    lonely_wolf_registance = 50
    # 独占欲の全耐性値
    monopolize_registance = 50
    
    # 淫毒・恍惚・欲情・暴走・虚脱・畏怖・麻痺・散漫
    if SR_Util.bad_states.include?(state_id)
      
      # ●総合
      if self.is_a?(Game_Actor)
        result -= flower_roll_registance if self.flower_roll_display?
        result -= lonely_wolf_registance if self.lonely_wolf?
        result -= monopolize_registance if self.monopolize?
        result -= rune_registance if self.equip?("無敵のルーン")
        result -= 10 if self.equip?("大きなリボン")
        result -= rivise_rate_dish("状態異常耐性", true)
      end
      result -= 50 if self.state?(101) # 祝福
      result -= 50 if $game_temp.in_battle and $incense.exist?("マイルドパフューム", self)
      result += 50 if $game_temp.in_battle and $incense.exist?("ストレンジスポア", self) and not self.have_ability?("免疫力")
      absolute_flag = 2 if self.have_ability?("確固たる自尊心")
      
      case state_id
      # 淫毒
      when 30
        result -= 50 if self.have_ability?("免疫力")
      # 恍惚
      when 34
        if self.is_a?(Game_Actor)
          result -= 25 if self.equip?("鎮静の紫水晶")
          result -= 50 if self.equip?("蜻蛉のブローチ")
          result -= 50 if self.equip?("蝶のブローチ")
          result -= rune_registance if self.equip?("意識のルーン")
          absolute_flag = 2 if self.equip?("統べる冠") and not $game_switches[79] == true
          absolute_flag = 2 if self.equip?("女狐のエンブレム") and not $game_switches[79] == true
        end
      # 欲情
      when 35
        if self.is_a?(Game_Actor)
          result -= 25 if self.equip?("鎮静の紫水晶")
          result -= 50 if self.equip?("涙の結晶")
          result -= 75 if self.equip?("淑女のカメオ")
          result -= rune_registance if self.equip?("抑制のルーン")
        end
      # 暴走
      when 36
        result -= ability_registance if self.have_ability?("平静")
        if self.is_a?(Game_Actor)
          result -= 25 if self.equip?("鎮静の紫水晶")
          result -= 50 if self.equip?("涙の結晶")
          result += 100 if self.equip?("野蛮な者の首輪")
          result -= 50 if self.equip?("勇気のサークレット")
          result += 100 if self.equip?("凶暴性")
          result -= rune_registance if self.equip?("理性のルーン")
          absolute_flag = 2 if self.equip?("自制のロザリオ") and not $game_switches[79] == true
        end
      # 虚脱
      when 37
        result -= ability_registance if self.have_ability?("活気")
        if self.is_a?(Game_Actor)
          result -= 75 if self.equip?("ハートのピアス")
          result -= 75 if self.equip?("薬草の冠")
          result -= 50 if self.equip?("信念のドッグタグ")
          result -= rune_registance if self.equip?("活気のルーン")
          absolute_flag = 2 if self.equip?("活力の炎") and not $game_switches[79] == true
        end
      # 畏怖
      when 38
        result -= ability_registance if self.have_ability?("胆力")
        if self.is_a?(Game_Actor)
          result -= 25 if self.equip?("鎮静の紫水晶")
          result -= 75 if self.equip?("銀剣のアミュレット")
          result -= 75 if self.equip?("金剣のアミュレット")
          result -= 50 if self.equip?("信念のドッグタグ")
          result -= 50 if self.equip?("勇気のサークレット")
          result -= rune_registance if self.equip?("胆力のルーン")
        end
        absolute_flag = 2 if self.have_ability?("確固たる自尊心")
      # 麻痺
      when 39
        result -= ability_registance if self.have_ability?("柔軟")
        if self.is_a?(Game_Actor)
          result -= 75 if self.equip?("薬草の冠")
          result -= 75 if self.equip?("蝙蝠羽のバッジ")
          result -= rune_registance if self.equip?("柔軟のルーン")
          absolute_flag = 2 if self.equip?("女豹のエンブレム") and not $game_switches[79] == true
        end
      # 散漫
      when 40
        result -= ability_registance if self.have_ability?("一心")
        if self.is_a?(Game_Actor)
          result -= 25 if self.equip?("鎮静の紫水晶")
          result -= 75 if self.equip?("星のピアス")
          result -= 75 if self.equip?("薬草の冠")
          result -= rune_registance if self.equip?("一心のルーン")
        end
      end
    end
    # 耐性値の下限上限を決める
    result = [[result,1000].min,0].max
    # 耐性値はパーセントで返すため100.0で割る。
    result /= 100.0
    # 返す
    return [result, absolute_flag]
  end
  #--------------------------------------------------------------------------
  # ● ステート変化 (+) の適用
  #     plus_state_set  : ステート変化 (+)
  #--------------------------------------------------------------------------
  def states_plus(user, plus_state_set, skill)
    # 有効フラグをクリア
    effective = false
    # ループ (付加するステート)
    for i in plus_state_set
      # このステートが防御されていない場合
      unless self.state_guard?(i)
        # このステートがフルでなければ有効フラグをセット
        effective |= self.state_full?(i) == false
        # ステートが [抵抗しない] の場合
        if $data_states[i].nonresistance
          # ステート変化フラグをセット
          @state_changed = true
          # ステートを付加
          add_state(i)
        # このステートがフルではない場合
        elsif self.state_full?(i) == false
          # 乱数との比較が行われ、かつ確立が0%でなかった場合フラグを立てる
          @hit_able = true if self.state_percent(user, i, skill) > 0
          percent_set = self.state_percent(user, i, skill)
          # ステート有効度を確率に変換し、乱数と比較
          if rand(100) < percent_set
            # ステート変化フラグをセット
            @state_changed = true
            # ステートを付加
            add_state(i)
          end
        end
      end
    end
    # メソッド終了
    return effective
  end
  #--------------------------------------------------------------------------
  # ● ステート変化 (-) の適用
  #     minus_state_set : ステート変化 (-)
  #--------------------------------------------------------------------------
  def states_minus(minus_state_set)
    # 有効フラグをクリア
    effective = false
    # ループ (解除するステート)
    for i in minus_state_set
      # このステートが付加されていれば有効フラグをセット
      effective |= self.state?(i)
      # ステート変化フラグをセット
      @state_changed = true
      # ステートを解除
      remove_state(i)
    end
    # メソッド終了
    return effective
  end
  #--------------------------------------------------------------------------
  # ● 弱点を突いているか否かの判定
  #    skill_id : スキル ID
  #--------------------------------------------------------------------------
  def weakpoint?(skill)
    return true if self.have_ability?("性交に弱い") and self.insert? and skill.element_set.include?(74) and skill.element_set.include?(97)
    return true if self.have_ability?("性交に弱い") and self.insert? and skill.element_set.include?(75) and skill.element_set.include?(95)
    return true if self.have_ability?("性交に弱い") and self.insert? and skill.element_set.include?(78) and skill.element_set.include?(97)
    return true if self.have_ability?("性交に弱い") and self.insert? and skill.element_set.include?(79) and skill.element_set.include?(97)
    return true if self.have_ability?("性交に弱い") and self.insert? and skill.element_set.include?(81) and skill.element_set.include?(97)
    return true if self.have_ability?("手攻めに弱い") and skill.element_set.include?(71)
    return true if self.have_ability?("口攻めに弱い") and skill.element_set.include?(72)
    return true if self.have_ability?("胸攻めに弱い") and skill.element_set.include?(73)
    return true if self.have_ability?("女陰攻めに弱い") and skill.element_set.include?(75)
    return true if self.have_ability?("嗜虐攻めに弱い") and not self.analsex? and (skill.element_set.include?(76) or skill.element_set.include?(77) or skill.element_set.include?(85))
    return true if self.have_ability?("異形攻めに弱い") and (skill.element_set.include?(78) or skill.element_set.include?(79))
    return true if self.have_ability?("肛虐に弱い") and self.analsex? and skill.element_set.include?(74) and skill.element_set.include?(94)
    return true if self.have_ability?("肛虐に弱い") and self.analsex? and skill.element_set.include?(78) and skill.element_set.include?(94)
    return true if self.have_ability?("肛虐に弱い") and self.analsex? and skill.element_set.include?(79) and skill.element_set.include?(94)
    return true if self.have_ability?("肛虐に弱い") and self.analsex? and skill.element_set.include?(81) and skill.element_set.include?(94)
    return true if (self.have_ability?("口が性感帯") or self.have_ability?("淫唇")) and skill.element_set.include?(91)
    return true if (self.have_ability?("胸が性感帯") or self.have_ability?("淫乳")) and skill.element_set.include?(92)
    return true if (self.have_ability?("お尻が性感帯") or self.have_ability?("淫尻")) and skill.element_set.include?(93)
    return true if (self.have_ability?("菊座が性感帯") or self.have_ability?("淫花")) and skill.element_set.include?(94)
    return true if (self.have_ability?("女陰が性感帯") or self.have_ability?("淫壺")) and skill.element_set.include?(97)
    return true if (self.have_ability?("陰核が性感帯") or self.have_ability?("淫核")) and skill.element_set.include?(98)
    return false
  end
end
