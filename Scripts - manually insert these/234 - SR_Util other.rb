#==============================================================================
# ■ SR_Util　：　その他
#------------------------------------------------------------------------------
#==============================================================================
module SR_Util
  
  #--------------------------------------------------------------------------
  # ● この敵夢魔が本気を出していない
  #--------------------------------------------------------------------------
  def self.enemy_before_earnest?(enemy)
    result = false
    # ベストエンドヴェルミィーナ戦
    if $game_temp.battle_troop_id == 603
      # エネミー位置が０番且つ、まだ本気を出していない
      if enemy == $game_troop.enemies[0] and not $game_troop.enemies[0].earnest
        result = true
      end
    end
    return result
  end
  #--------------------------------------------------------------------------
  # ● 特殊な服を脱ぐ
  #--------------------------------------------------------------------------
  def self.special_undress(enemy)
    enemy.undress
    if $game_temp.battle_log_text != ""
      text = "\w\q" + enemy.bms_states_update
    else
      text = enemy.bms_states_update
    end
    enemy.graphic_change = true
    end
  #--------------------------------------------------------------------------
  # ● 特殊なホールド発生を行う
  #--------------------------------------------------------------------------
  def self.special_hold_make(skill, active, target)
    $scene.special_hold_start
    $scene.hold_effect(skill, active, target)
    target.white_flash = true
    target.animation_id = 105
    target.animation_hit = true
    # 画面の縦シェイク
    $game_screen.start_flash(Color.new(255,210,225,220), 8)
    $game_screen.start_shake2(7, 15, 15)
    # 両者にスタンをかける
    $scene.battler_stan(active)
    $scene.battler_stan(target)
    $scene.special_hold_end
  end
  #--------------------------------------------------------------------------
  # ● ホールド情報とパーツ名から対応パーツを返す
  #--------------------------------------------------------------------------
  def self.holding_parts_name(hold_type, parts_name)
    box = []
    if hold_type == "♀挿入"
      box.push(["penis"])
      box.push(["vagina"])
    elsif hold_type == "口挿入"
      box.push(["penis"])
      box.push(["mouth"])
    elsif hold_type == "尻挿入"
      box.push(["penis"])
      box.push(["anal"])
    elsif hold_type == "パイズリ"
      box.push(["tops"])
      box.push(["penis"])
    elsif hold_type == "ぱふぱふ"
      box.push(["tops"])
      box.push(["mouth"])
    elsif hold_type == "拘束"
      box.push(["tops"])
      box.push(["tops"])
    elsif hold_type == "顔面騎乗"
      box.push(["vagina"])
      box.push(["mouth"])
    elsif hold_type == "尻騎乗"
      box.push(["anal"])
      box.push(["mouth"])
    elsif hold_type == "クンニ"
      box.push(["mouth"])
      box.push(["vagina"])
    elsif hold_type == "貝合わせ"
#      box.push(["vagina","anal"])
#      box.push(["vagina","anal"])
      box.push(["vagina"])
      box.push(["vagina"])
    elsif hold_type == "ディルド♀挿入"
      box.push(["dildo"])
      box.push(["vagina"])
    elsif hold_type == "ディルド口挿入"
      box.push(["dildo"])
      box.push(["mouth"])
    elsif hold_type == "ディルド尻挿入"
      box.push(["dildo"])
      box.push(["anal"])
    elsif hold_type == "触手吸引"
      box.push(["tentacle"])
      box.push(["penis"])
    elsif hold_type == "触手クンニ"
      box.push(["tentacle"])
      box.push(["vagina"])
    end
    # １つ目に対応パーツがある場合は、２つ目を返す
    if box[0].include?(parts_name)
      return box[1]
    # １つ目に対応パーツがない場合は、１つ目を返す
    else
      return box[0]
    end
  end
  #--------------------------------------------------------------------------
  # ● 逆転できるホールド？
  #--------------------------------------------------------------------------
  def self.reversible_hold?(hold_type)
    return true if ["♀挿入","貝合わせ"].include?(hold_type)
    return false
  end
  #--------------------------------------------------------------------------
  # ● 全アイテム入手イベントの中身を確認し、出力
  #--------------------------------------------------------------------------
  def self.treasure_box_check
    # ツクールで開いている順にマップIDを入れ替える
    maplist = load_data("Data/MapInfos.rxdata")
    num_box = [] 
    for i in 1..999
      if maplist[i] != nil
        num_box.push([i, maplist[i].order])
      end
    end
    num_box.sort!{|a,b| a[1] <=> b[1] }
    # １つずつマップの宝箱を確認する
    all_text = ""
    count = 0
    for num in num_box
      i = num[0]
      map_name = (sprintf("Data/Map%03d.rxdata", i))
      next unless FileTest.exist?(map_name)
      map = load_data(map_name)
      events = {}
      text = ""
      for j in map.events.keys
        events[j] = Game_Event.new(i, map.events[j])
#        if map.events[j].pages[0].graphic.character_name == "174-Chest01"
          for list_one in map.events[j].pages[0].list
            contents = ""
            case list_one.code
            when 125 # ゴールド
              number = list_one.parameters[2]
              contents = "　#{number}Lps." if list_one.parameters[1] != 0
            when 126 # アイテム
              name = $data_items[list_one.parameters[0]].name
              number = list_one.parameters[3]
              contents = "　#{name} #{number}個" if list_one.parameters[1] != 1
            when 128 # 防具
              name = $data_armors[list_one.parameters[0]].name
              number = list_one.parameters[3]
              contents = "　#{name} #{number}個" if list_one.parameters[1] != 1
            end
            text += contents + "\n" if contents != ""
          end
#        end
      end
      if text != ""
        all_text += "■#{maplist[i].name}\n" + text + "\n"
      end
      count += 1
      Graphics.update if count % 50 == 0 
    end
    # treasure_box.txtに出力する
    file_name = "treasure_box.txt"    #保存するファイル名
    File.open(file_name, 'w') {|file|
     file.write all_text
    }
    p "treasure_box.txtに出力しました"
  end
  #--------------------------------------------------------------------------
  # ● 夢干渉が可能かどうか
  #--------------------------------------------------------------------------
  def self.can_dream_interference?
    result = false
    result = true if $game_party.all_d_power >= 300
    return result
  end
  #--------------------------------------------------------------------------
  # ● 主人公の弱点を決め直す
  #--------------------------------------------------------------------------
  def self.hero_weak_change(weak_id_box = [], type = 0)
    case type
    # typeによって消す弱点を変える
    #----------------------------------------------------------------------
    when 0 # 基本弱点
      # 基本弱点を全て消す
      for i in [10,11,12,13]
        $game_actors[101].remove_ability(i)
      end
    when 1 # 特殊弱点
      # 特殊弱点を全て消す
      for i in [16,14]
        $game_actors[101].remove_ability(i)
      end
    end
    #----------------------------------------------------------------------
    # 指定された弱点を全て習得
    for i in weak_id_box
      $game_actors[101].gain_ability(i)
    end
  end
  #--------------------------------------------------------------------------
  # ● 基本弱点を決める
  #--------------------------------------------------------------------------
  def self.normal_weak_dicide(weak_box)
    result = []
    # 口攻めに弱い
    result.push(10) if weak_box[0]
    # 尻攻めに弱い
    result.push(11) if weak_box[1]
    # 胸攻めに弱い
    result.push(12) if weak_box[2]
    # 女陰攻めに弱い
    result.push(13) if weak_box[3]
    # 返す
    return result
  end
  #--------------------------------------------------------------------------
  # ● 特殊弱点を決める
  #--------------------------------------------------------------------------
  def self.special_weak_dicide(weak_box)
    result = []
    # 性交に弱い
    result.push(16) if weak_box[0]
    # 嗜虐攻めに弱い
    result.push(14) if weak_box[1]
    # 返す
    return result
  end
  #--------------------------------------------------------------------------
  # ● トーク用ログウェイトの作成
  #--------------------------------------------------------------------------
  def self.talk_log_wait_make
    log = $game_temp.battle_log_text
    if log != ""
      # 行数に合わせてウェイトを入れる
      log = log.split(/[\n\q]/)
      ct = (4 * (log.size + 1)) + $game_system.battle_speed_time(0) + $game_system.important_wait_time
#      ct = (4 * 3) + $game_system.battle_speed_time(0) + $game_system.important_wait_time
      $game_temp.set_wait_count = ct
    else
      $game_temp.set_wait_count = 0
    end
  end
  #--------------------------------------------------------------------------
  # ● 状態異常扱いステート
  #--------------------------------------------------------------------------
  def self.bad_states
    reslut = []
    # ７状態異常
    for i in 34..40
      reslut.push(i)
    end
    reslut.push(30)  # 淫毒
#    reslut.push(13)   # ディレイ
#    reslut.push(105)  # 拘束
#    reslut.push(106)  # 破面
    return reslut 
  end
  #--------------------------------------------------------------------------
  # ● 公開ステート
  #--------------------------------------------------------------------------
  def self.checking_states
    #--------------------------------------------------------------------------
    # 公開されるステート。ダメージが無くこれらの付与を行うスキルは、
    # 重複時の使用不可チェックがされたり、失敗時のテキストが出たりする。
    #--------------------------------------------------------------------------
    reslut = []
    # ドキドキ２種、７状態異常、高揚沈着
    for i in 32..42
      reslut.push(i)
    end
    # 感度上昇
    for i in 45..50
      reslut.push(i)
    end
    # その他
    reslut.push(13)  # ディレイ
    reslut.push(30)  # 淫毒
    reslut.push(98)  # 魔法陣
    reslut.push(101) # 祝福
    reslut.push(102) # 焦燥
    reslut.push(103) # 専心
    reslut.push(105) # 拘束
    reslut.push(106) # 破面
    # 返す
    return reslut
  end
  #--------------------------------------------------------------------------
  # ● 盟約の儀式執行
  #--------------------------------------------------------------------------
  def self.compact_ritual_start
    # パーティが２人以下の場合、執行不可
    if $game_party.party_actors.size < 2
      return false
    end
    # 条件チェック
    return false unless $game_party.party_actors[1].love >= 150
    return false unless $game_party.party_actors[1].have_ability?("寵愛")
    return false unless $game_party.party_actors[1].promise >= 10000
    return false if $game_party.party_actors[1].have_ability?("大切な人")
    # 返す
    return true
  end
  #--------------------------------------------------------------------------
  # ● 古印破棄の儀式執行
  #--------------------------------------------------------------------------
  def self.ancient_rune_ritual_start
    # パーティが４人以下の場合、執行不可
    if $game_party.party_actors.size < 4
      return false
    end
    # 仲間の３人が精神力100以上、ＶＰ1000以上を満たしていない場合、執行不可
    for i in 1..3
      unless $game_party.party_actors[i].int >= 100 and
       $game_party.party_actors[i].sp >= 1000
        return false
      end
    end
    # 対価のＶＰ1000を支払い、執行開始。
    for i in 1..3
      $game_party.party_actors[i].sp -= 1000
    end
    return true
  end
  #--------------------------------------------------------------------------
  # ● ステータス計算式一括
  #--------------------------------------------------------------------------
  def self.status_calculate(int, level, type)
    reslut = 1
    case type
    when 0 # ＥＰ・ＶＰ
      reslut = int * 8 * level / $Status_UP_RATE + 300
    when 1 # 魅力・忍耐力
      reslut = int * 3 * level / $Status_UP_RATE + 50
    when 2 # 精力・器用さ・素早さ・精神力
      reslut = int * 3 * level / $Status_UP_RATE + 30
    end
    return reslut
  end
  #--------------------------------------------------------------------------
  # ● 確認
  #--------------------------------------------------------------------------
  def self.test_do
    number = 0
    case number
    when 3..1.0/0 
      p "ok" if $DEBUG
    else
      p "out" if $DEBUG
    end
  end
  #--------------------------------------------------------------------------
  # ★ 吸精
  #--------------------------------------------------------------------------
  def self.energy_drain(active_battler,target_battler)
    # 絶頂させたのがアクターの場合、満腹度を回復
     if active_battler.is_a?(Game_Actor)
      active_battler.fed += 20
    end
  end
  #--------------------------------------------------------------------------
  # ● 口上確認（没）
  #--------------------------------------------------------------------------
  def self.make_succubus_message(battler)
    # 喋るエネミーと対象を代入
    $msg.t_enemy = battler
    $msg.t_target = $game_party.party_actors[0]
    # アクティブエネミーを仮代入
    temp_active = $game_temp.battle_active_battler
    $game_temp.battle_active_battler = $msg.t_enemy
    
    $msg.at_type = "ホールド攻撃"
    $msg.at_parts = "♀挿入：アソコ側"
    
    # 出力
    p $msg.call(battler) if $DEBUG
    
    # 元に戻す
    $game_temp.battle_active_battler = temp_active
  end
  #--------------------------------------------------------------------------
  # ● 非シンボル戦前の変数リセット
  #--------------------------------------------------------------------------
  def self.nonsymbol_battle_reset
    
    # 先手後手をフラットに
    $game_temp.first_attack_flag = 0
    # 確定契約フラグを不可状態に
    $game_temp.absolute_contract = 2
    
  end
  #--------------------------------------------------------------------------
  # ● 習得スキル表の確認
  #--------------------------------------------------------------------------
  def self.debug_learnings_check
    for i in 1..300
      
      next if $data_classes[i].name == ""
      next if $data_classes[i].name.include?("■")
      next if $data_classes[i].name.include?("【data】")
      
      message = ""
      message += "#{$data_classes[i].name} #{$data_classes[i].color}\n"
      for learn in $data_classes[i].learnings
        case learn[1] 
        when 0
          next if [2,4,81,82,83,84,121,123].include?(learn[2])
          message += "Lv#{learn[0].to_s}.#{$data_skills[learn[2]].name}\n"
        when 1
          message += "Lv#{learn[0].to_s}.【#{$data_ability[learn[2]].name}】\n"
        end
      end
      print message
    end
  end
  #--------------------------------------------------------------------------
  # ● ボーナス表の確認
  #--------------------------------------------------------------------------
  def self.debug_bonus_check
    for i in 1..300
      
      next if $data_classes[i].name == ""
      next if $data_classes[i].name.include?("■")
      next if $data_classes[i].name.include?("【data】")
      
      message = ""
      message += "#{$data_classes[i].name} #{$data_classes[i].color}\n"
      for learn in $data_classes[i].bonus
        case learn[1] 
        when 0
          message += "Cost:#{learn[0].to_s}.#{$data_skills[learn[2]].name}\n"
        when 1
          next if [19,21,23,27,29].include?(learn[2])
          message += "Cost:#{learn[0].to_s}.【#{$data_ability[learn[2]].name}】\n"
        end
      end
      print message
    end
  end
  #--------------------------------------------------------------------------
  # ● 精の献上時のステータス変動
  #    ※書き方が良くはないが元々あったものをコピペしたもののため、動作は大丈夫。
  #--------------------------------------------------------------------------
  def self.spam_gift_change
    $game_actors[101].sp -= 
    $game_temp.battle_active_battler.absorb
    for actor in $game_party.party_actors
      if actor == $game_temp.battle_active_battler
        actor.fed = 100
        actor.promise += 100
        actor.promise += 20 if actor.equip?("ガラスの指輪")
        actor.promise += 30 if actor.equip?("信頼のルーン")
        actor.love += 3
        actor.love += 2 if actor.equip?("ガラスの指輪")
        #actor.love_dish_bonus(0)
        actor.hp = actor.maxhp if actor.equip?("美食のルーン")
        actor.sp = actor.maxsp if actor.equip?("美食のルーン")
        actor.remove_state(15)
      elsif actor != $game_actors[101]
        actor.love += 1
        actor.love += 1 if actor.equip?("ガラスの指輪")
        actor.promise += 10
        actor.promise += 5 if actor.equip?("ガラスの指輪")
        actor.promise += 5 if actor.equip?("信頼のルーン")
      end
    end
  end
  #--------------------------------------------------------------------------
  # ● ベッド戦後のステータス変動
  #    ※書き方が良くはないが元々あったものをコピペしたもののため、動作は大丈夫。
  #--------------------------------------------------------------------------
  def self.bed_battle_change
    favor_list = []
    for actor in $game_temp.vs_actors
      $game_actors[actor.id].vs_me = false
      $game_actors[actor.id].love += 3
      $game_actors[actor.id].love += 2 if actor.equip?("ガラスの指輪")
      $game_actors[actor.id].promise += 30
      $game_actors[actor.id].promise += 20 if actor.equip?("ガラスの指輪")
      $game_actors[actor.id].promise += 30 if actor.equip?("信頼のルーン")
      #$game_actors[actor.id].love_dish_bonus(1)
      $game_party.add_actor(actor.id)
      $game_party.battle_actor_refresh
      # 好感度が100以上且つ寵愛がついていない場合、寵愛リストに追加する
      if $game_actors[actor.id].love >= 100 and not $game_actors[actor.id].have_ability?("寵愛")
        favor_list.push($game_actors[actor.id])
      end
    end
    for actor in $game_party.party_actors
      if actor != $game_actors[101]
        $game_actors[actor.id].love += 3
        $game_actors[actor.id].love += 2 if actor.equip?("ガラスの指輪")
        $game_actors[actor.id].promise += 20
        $game_actors[actor.id].promise += 20 if actor.equip?("ガラスの指輪")
        $game_actors[actor.id].promise += 30 if actor.equip?("信頼のルーン")
        $game_actors[actor.id].bedin_count += 1
        #$game_actors[actor.id].love_dish_bonus(2)
      end
    end
    $game_temp.vs_actors = []
    
    # 寵愛チェック
    text = ""
    for favor_actor in favor_list
      text += "\n" if text != ""
      favor_actor.gain_ability(60)  # 【寵愛】
      favor_actor.gain_ability(302) # 【アクセプト】を持っていない夢魔もここで習得
      text += "#{$game_actors[101].name}は#{favor_actor.name}からの寵愛を得た！"
    end
    $game_variables[2] = ""
    $game_variables[2] = text if text != ""
    
  end
  #--------------------------------------------------------------------------
  # ● スキル消費ＶＰの計算 
  #--------------------------------------------------------------------------
  def self.sp_cost_result(battler, skill)
    
    result = skill.sp_cost
    # 魔法スキルの場合
    if skill.element_set.include?(5)
      # ステート「魔法陣」がついている場合、０に。
      result = 0 if battler.state?(98)
      # 魔導の首飾りを装備中の場合、1/2に。
      if battler.is_a?(Game_Actor)
        result /= 2 if battler.equip?("魔導の首飾り")
      end
    end
    if not (skill.name == "ウェイト" or 
     skill.name == "フリーアクション" or
     skill.name == "エモーション" or 
     skill.name == "小休止")
      # 虚脱状態の場合、VPの3％を加算
      if battler.state?(37)
        # ボス系は虚脱の効果を弱化させる
        if battler.is_a?(Game_Enemy) and (
        $data_enemies[battler.id].element_ranks[124] == 1 or # イベント敵の場合
        $data_enemies[battler.id].element_ranks[126] == 1 or # ボスの場合
        $data_enemies[battler.id].element_ranks[128] == 1)   # ラスボスの場合
          result += battler.maxsp * 0.005
        else
          result += battler.maxsp * 0.03
        end
        result = result.truncate
      end
      # デモンキスマークを装備中の場合、VPの0.5％を加算
      if battler.is_a?(Game_Actor)
        if battler.equip?("デモンキスマーク")
          result += battler.maxsp * 0.01
          result = result.truncate
        end
      end
    end
    return result
  end
  #--------------------------------------------------------------------------
  # ● アナウンス
  #--------------------------------------------------------------------------
  def self.announce(text, se = "通常")
    $game_temp.announce_text.push([text, se])
  end
  #--------------------------------------------------------------------------
  # ● マップ中の一時変数をリセット ★
  #--------------------------------------------------------------------------
  def self.map_temp_variables_reset
    # シンボル出現変数・索敵変数
    for i in 102..150
      $game_variables[i] = 0
    end
    # スプライトの消し忘れがある場合は消す
    $sprite.dispose if $sprite != nil
  end
  #--------------------------------------------------------------------------
  # ● ゲームオーバー時の変数をリセット ★
  #    ※風の翼を使用した場合もこれを通ります。
  #--------------------------------------------------------------------------
  def self.map_gameover_reset
    $game_variables[29] = 0 # 走っちゃダメ　地区判定
    $game_variables[38] = 0 # 暗闇度（実働）
    $game_switches[53]  = false # 時計音
    $game_switches[54]  = false # 鳥の囀り
    $game_switches[75]  = false # 風の翼使用禁止
    $game_switches[334] = false # 井戸の魔女に目を付けられた
    $game_switches[305] = false # ２階判定：ゴブリンタウン
    $game_switches[433] = false # ２階判定：獄界火山通路
  end
  #--------------------------------------------------------------------------
  # ● アイテム入手時のテキスト作成
  #--------------------------------------------------------------------------
  def self.item_get_message_make

    # 初期化
    message = []
    text  = ""
    count = 0
    
    # 何もなかったら終了
    if $game_temp.get_item == [] or $game_temp.get_item == nil
      return message
    end
    
    # 全アイテムを確認するまでループ
    while $game_temp.get_item.size > 0
    
      # ４行使用したら次のページ
      if count >= 4
        message.push(text)
        text  = ""
        count = 0
      end
      
      # 一番前のアイテム取得データを読み込む
      data = $game_temp.get_item.shift
      text += "\\T[#{data[1]}]#{data[2]}#{data[0]}　を手に入れた！"
      if $game_temp.get_item.size > 0
        count += 1
        text += "\n" if count < 4
      end
    end
    
    # メッセージを格納
    message.push(text)
    
    return message
  end
  #--------------------------------------------------------------------------
  # ● チェックリザルトのテキスト作成
  #--------------------------------------------------------------------------
  def self.make_condition_text(battler)
    
    # チェッキング確認
    checking = battler.checking
    checking = 10 if battler.is_a?(Game_Actor) # アクターの場合特殊処理
    
    #--------------------------------------------------------------------------
    # ■■メッセージウィンドウ１
    #--------------------------------------------------------------------------
    
    message = []
    
    # ○名前/種族文字列を作成
    names_text = "#{battler.name}/#{$data_classes[battler.class_id].name}"
    
    # ○性格文字列を作成
    personality = battler.personality
    personality = "？？？？" if checking < 1 # チェック完了１以上
    personality_text = "性格：#{personality}"
    
    # ○弱点文字列を作成
    # 弱点確認
    weak_list = [
    "口攻めに弱い",
    "手攻めに弱い",
    "胸攻めに弱い",
    "女陰攻めに弱い",
    "嗜虐攻めに弱い",
    "異形攻めに弱い",
    "性交に弱い",
    "肛虐に弱い",
    "口が性感帯", "淫唇",
    "胸が性感帯", "淫乳", 
    "お尻が性感帯", "淫尻",
    "菊座が性感帯", "淫花",
    "陰核が性感帯", "淫核",
    "女陰が性感帯", "淫壺",
    ]
    # 文字列をリセット
    weak_text = ""
    # リストを作成
    battler_weak_list = []
    for weak in weak_list
      # 弱点を持っていればリストに追加
      if battler.have_ability?(weak)
        battler_weak_list.push(weak)
      end
    end
    # 弱点用テキストを作成
    if battler_weak_list != []
      weak_text = SR_Util.weak_text_change(battler_weak_list)
    else
      weak_text = "無し"
    end
    weak_text = "？？？？？" if checking < 1 # チェック完了１以上
    weak_base = "弱点："
    # ステート完成
    weak_text = weak_base + weak_text
    
    # ○ステート文字列を作成
    state_text = ""
    # １行に表示しているステート数を作成
    state_set = 0
    for i in battler.states
      if $data_states[i].rating >= 1
        if state_set == 0
          state_text += $data_states[i].name
          state_set += 1
        else
          # １行にステートを８個描画したら改行
          if state_set == 20
            state_text += "\n"
            state_set = 0
          end
          new_text = state_text + "/" + $data_states[i].name
          state_set += 1
          state_text = new_text
        end
      end
    end
    # ステート名の文字列が空の場合は "ステート無し" にする
    if state_text == ""
      state_text = "正常"
    end
    state_base = "状態："
    # ステート完成
    state_text = state_base + state_text

    # メッセージウィンドウ１表示分を作成
    message.push("#{names_text}\n#{personality_text}\n#{weak_text}\n#{state_text}")

    #--------------------------------------------------------------------------
    # ■■メッセージウィンドウ２
    #--------------------------------------------------------------------------
    
    # チェック完了２以上から表示（アクターは表示しない）
    if checking >= 2 and checking < 10
    
      # ○耐久文字列を作成
      ep = "#{battler.hp}/#{battler.maxhp}"
      vp = "#{battler.sp}/#{battler.maxsp}"
      # ボス戦は現ＥＰ、ＶＰを隠す。
      ep = "？？/#{battler.maxhp}" if $game_switches[91]
      vp = "？？/#{battler.maxsp}" if $game_switches[91]
      toughness_text = "ＥＰ：#{ep}\nＶＰ：#{vp}"
    
      # メッセージウィンドウ２表示分を作成
      message.push("#{toughness_text}")
    end
    #--------------------------------------------------------------------------
    
      # ドロップアイテム
    
    #--------------------------------------------------------------------------
    
    #--------------------------------------------------------------------------
    # ■■メッセージウィンドウ特殊
    #--------------------------------------------------------------------------
    
    # チェック完了１以上から表示（アクターは表示しない）
    if checking >= 1 and checking < 10
      
      # 敵戦用ステート耐性の表示
      state_rank_text = ""
      state_rank_text1 = ""
      state_rank_text2 = ""
      for i in 1..battler.state_ranks.xsize
        if battler.state_ranks[i] == 6
          state_rank_text1 += "・" unless state_rank_text1 == ""
          state_rank_text1 += $data_states[i].name
        elsif battler.state_ranks[i] == 5
          state_rank_text2 += "・" unless state_rank_text2 == ""
          state_rank_text2 += $data_states[i].name
        end
      end
      state_rank_text += "\n無効：#{state_rank_text1}" if state_rank_text1 != ""
      state_rank_text += "\n抵抗：#{state_rank_text2}" if state_rank_text2 != ""
      
      # メッセージウィンドウ特殊の表示分を作成
      unless state_rank_text == ""
        state_rank_text = "【限定特殊耐性】" + "#{state_rank_text}"
        message.push("#{state_rank_text}")
      end
        
    end
    
    #--------------------------------------------------------------------------
    # ■■メッセージウィンドウ特殊
    #--------------------------------------------------------------------------
    
    # チェック完了１以上から表示（アクターは表示しない）
    if checking >= 1 and checking < 10
      
      special_text = ""
      # 味方戦以外且つ、特殊な素質を持つものを表示
      if not ($game_switches[85] or $game_switches[86])
        if battler.have_ability?("確固たる自尊心")
          special_text += "【確固たる自尊心】"
          special_text += "\n" + $data_ability.data[$data_ability.search(0,"確固たる自尊心")].description
        elsif battler.have_ability?("毒の体液")
          special_text += "【毒の体液】"
          special_text += "\n" + $data_ability.data[$data_ability.search(0,"毒の体液")].description
        elsif battler.have_ability?("妄執")
          special_text += "【妄執】"
          special_text += "\n" + $data_ability.data[$data_ability.search(0,"妄執")].description
        elsif battler.have_ability?("先読み")
          special_text += "【先読み】"
          special_text += "\n" + $data_ability.data[$data_ability.search(0,"先読み")].description
        end
      end
      
      # メッセージウィンドウ特殊の表示分を作成
      unless special_text == ""
        message.push("#{special_text}")
      end
    end
    
    # 最終出力
    return message
  end

#==============================================================================
  
  #--------------------------------------------------------------------------
  # ● チェックリザルト用、弱点テキスト製作
  #--------------------------------------------------------------------------
  def self.weak_text_change(battler_weak_list)
    
    #--------------------------------------------------------------------------
    # ■■　○○に弱い系
    #--------------------------------------------------------------------------
    
    text_first = ""

    # ○○攻めに弱い
    #--------------------------------------------------------------------------
    text_1 = ""
    count = 0
    for weak in battler_weak_list
      text_1a = ""
      case weak
      when "口攻めに弱い"
        text_1a += "口"
      when "手攻めに弱い"
        text_1a += "手"
      when "胸攻めに弱い"
        text_1a += "胸"
      when "女陰攻めに弱い"
        text_1a += "女陰"
      when "嗜虐攻めに弱い"
        text_1a += "嗜虐"
      when "異形攻めに弱い"
        text_1a += "異形"
      end
      # 弱点が入っていればテキストに追加
      if text_1a != ""
        text_1 += "・" if count > 0 
        text_1 += text_1a
        count += 1 
      end
    end
    text_1 += "攻め" if text_1 != ""

    # ○○に弱い
    #--------------------------------------------------------------------------
    text_2 = ""
    count = 0
    for weak in battler_weak_list
      text_2a = ""
      case weak
      when "性交に弱い"
        text_2a += "性交"
      when "肛虐に弱い"
        text_2a += "肛虐"
      end
      # 弱点が入っていればテキストに追加
      if text_2a != ""
        text_2 += "・" if count > 0 
        text_2 += text_2a
        count += 1 
      end
    end

    #--------------------------------------------------------------------------
    
    text_first = text_1 + "に弱い" if text_1 != ""
    text_first = text_2 + "に弱い" if text_2 != ""
    text_first = text_1 + "、" + text_2 + "に弱い" if text_1 != "" and text_2 != ""

    #--------------------------------------------------------------------------
    # ■■　○○が弱い系
    #--------------------------------------------------------------------------
    
    text_second = ""

    # ○○が性感帯
    #--------------------------------------------------------------------------
    text_3 = ""
    count = 0
    for weak in battler_weak_list
      text_3a = ""
      case weak
      when "口が性感帯"
        text_3a += "口"
      when "胸が性感帯"
        text_3a += "胸"
      when "お尻が性感帯"
        text_3a += "お尻"
      when "菊座が性感帯"
        text_3a += "菊座"
      when "陰核が性感帯"
        text_3a += "陰核"
      when "女陰が性感帯"
        text_3a += "女陰"
      end
      # 弱点が入っていればテキストに追加
      if text_3a != ""
        text_3 += "・" if count > 0 
        text_3 += text_3a
        count += 1 
      end
    end
    text_second = text_3 + "が弱い" if text_3 != ""

    #--------------------------------------------------------------------------
    text_third = ""

    # 淫○
    #--------------------------------------------------------------------------
    text_4 = ""
    count = 0
    for weak in battler_weak_list
      text_4a = ""
      case weak
      when "淫唇"
        text_4a += "口"
      when "淫乳" 
        text_4a += "胸"
      when "淫尻"
        text_4a += "お尻"
      when "淫花"
        text_4a += "菊座"
      when "淫核"
        text_4a += "陰核"
      when "淫壺"
        text_4a += "女陰"
      end
      # 弱点が入っていればテキストに追加
      if text_4a != ""
        text_4 += "・" if count > 0 
        text_4 += text_4a
        count += 1 
      end
    end
    text_third = text_4 + "が非常に弱い" if text_4 != ""
        
    #--------------------------------------------------------------------------
    # ■■　テキスト確定
    #--------------------------------------------------------------------------
    
    text = ""
    count = 0
    # ○○攻めに弱い
    if text_first != ""
      text += "　" if count > 0
      text += text_first
      count += 1
    end
    # ○○が性感帯
    if text_second != ""
      text += "　" if count > 0
      text += text_second 
      count += 1
    end
    # 淫○
    if text_third != ""
      text += "　" if count > 0
      text += text_third
      count += 1
    end
    return text
    
  end
  
end