#==============================================================================
# ■ Scene_Battle (その他)
#==============================================================================

class Scene_Battle  

  #--------------------------------------------------------------------------
  # ● エネミーの表示状態の変更
  #--------------------------------------------------------------------------
  def enemies_display(active_enemy)
    return unless active_enemy.exist?
    
    # 全エネミーを確認し、アクティブエネミーのみを表示する。
    for enemy in $game_troop.enemies
      if enemy == active_enemy
        enemy.display = true
      else
        enemy.display = false
      end
    end
    # アクティブエネミーがボス画像ではない場合、ボス以外のエネミーをすべて表示。
    unless active_enemy.boss_graphic?
      for enemy in $game_troop.enemies
        unless enemy.boss_graphic?
          enemy.display = true
        end
      end
    end
  end
  #--------------------------------------------------------------------------
  # ★ エネミー行動制限用
  #--------------------------------------------------------------------------
  def enemy_action_swicthes(enemy = @active_battler)
    # エネミー自身の状態
    $game_switches[101] = !enemy.full_nude?
    $game_switches[103] = enemy.full_nude?
    $game_switches[104] = !enemy.crisis?
    $game_switches[105] = enemy.crisis?
    $game_switches[106] = enemy.holding?
    # 自身のＨＰ割合が x 以上
    $game_switches[109] = (enemy.hpp >= 100)
    $game_switches[110] = (enemy.hpp >= 80)
    $game_switches[111] = (enemy.hpp >= 50)
    $game_switches[112] = (enemy.hpp >= 20)
    # 自身の潤滑度が x 以上
    $game_switches[114] = (enemy.lub_female >= 90)
    $game_switches[115] = (enemy.lub_female >= 60)
    $game_switches[116] = (enemy.lub_female >= 30)
    # 自身のステート状態
    $game_switches[121] = enemy.state?(98) # 魔法陣
    # エネミーが先手を取った
    $game_switches[144] = ($game_temp.first_attack_flag == 2)
    # エネミーがもがける
    $game_switches[143] = enemy.can_struggle?
    # エネミーが本気挿入状態
    $game_switches[142] = enemy.earnest and enemy.vagina_insert?
    
    # エネミートループの状態
    ex = tk = nd = 0
    hd = []
    tp = []
    enemys_state_runk_total = 0
    for enemy_one in $game_troop.enemies
      if enemy_one.exist?
        ex += 1
        if enemy_one.talkable?
          tk += 1
        end
        unless enemy_one.full_nude?
          nd += 1
        end
        if enemy_one.holding? and enemy_one != enemy
          hd.push(enemy_one)
        end
        if $data_SDB[enemy_one.class_id].name == $data_SDB[enemy.class_id].name
          tp.push(enemy_one)
        end
        for i in enemy_one.state_runk
          enemys_state_runk_total += i
        end
      end
    end
    $game_switches[126] = (nd > 0)
    $game_switches[127] = (nd == 0)

    $game_switches[131] = (hd.size > 0)
    $game_switches[132] = (ex = 1)
    $game_switches[133] = (ex > 1)
    $game_switches[134] = (tk > 1)
    $game_switches[135] = (tp.size > 1)
    $game_switches[136] = enemy.dancing?
    
    actors_state_runk_total = 0
    # アクターの状態
    for actor_one in $game_party.battle_actors
      if actor_one.exist?
        for i in actor_one.state_runk
          actors_state_runk_total += i
        end
      end
    end
    
    
    
    #--------------------------------------------------------------------------
    # ヘイト達成
    hate_result = false
    # イベント、ＯＦＥ、ボス属性がついているもののみ
    if ($data_enemies[enemy.id].element_ranks[124] == 1 or
     $data_enemies[enemy.id].element_ranks[125] == 1 or 
     $data_enemies[enemy.id].element_ranks[126] == 1 or 
     $data_enemies[enemy.id].element_ranks[128] == 1)
      # 条件：ヘイトカウントを６まで溜めた
      hate_result = true if $game_temp.battle_hate_count >= 6
      # 条件：アクター全員の強化値がエネミー全員の強化値より４以上高い
      hate_result = true if actors_state_runk_total >= 4 + enemys_state_runk_total
    end
    # 条件：不幸状態
    hate_result = true if $game_party.unlucky?
    # 確定させる
    $game_switches[145] = hate_result
    #--------------------------------------------------------------------------
    # 手加減達成
    allowance_result = false
    # ラスボス以外のみ
    unless $data_enemies[enemy.id].element_ranks[128] == 1
      # 条件：ヘイトカウントがマイナス
      allowance_result = true if $game_temp.battle_hate_count < 0
      # 条件：エネミー全員の強化値がアクター全員の強化値より４以上高い
      allowance_result = true if enemys_state_runk_total >= 4 + actors_state_runk_total
      # 条件：主人公のＶＰが１／４以下且つ、エネミーのＶＰが１／２以上
      allowance_result = true if $game_actors[101].spp <= 25 and enemy.spp >= 50
    end
    # 確定させる
    $game_switches[146] = allowance_result
  end
  #--------------------------------------------------------------------------
  # ● ステートなどのウェイトチェック
  #--------------------------------------------------------------------------
  def system_wait_make(text)
    result = 0
    if text != ""
      # 行数に合わせてウェイトを入れる
      text_size = text.split(/[\n\]/).size
    else 
      text_size = 0
    end
    case $game_system.ms_skip_mode
    when 3 #手動送りモード
      result = (4 * text_size)
    when 2 #デバッグモード
      result = 8
    when 1 #快速モード
      result = 12
    else
      # ステート関係はステートの数だけウェイトを加算
      result = $game_system.battle_speed_time(0) + $game_system.important_wait_time + (4 * text_size)
    end
    return result
  end
  #--------------------------------------------------------------------------
  # ● 簡易モードのムード管理
  #    battler ： 行動中バトラー
  #    skill   ： 行動中バトラーの使ったスキル
  #--------------------------------------------------------------------------
  def system_simplemode_moodcheck(battler)
    #簡易モードで無い場合は通常処理に戻す
    return unless $game_system.system_message == 0
    up = false
    down = false
    #レジスト成功
    if @resist_flag == true
      if battler.is_a?(Game_Actor)
        case $msg.tag
        when "主人公が夢魔を脱衣","パートナーが夢魔を脱衣"
          up = true
        when "主人公が夢魔をホールド","パートナーが夢魔をホールド"
          if $msg.at_type == "自分ホールド解除" or $msg.at_type == "仲間ホールド解除"
            down = true
          else
            up = true
          end
        end
      else
        case $msg.tag
        when "夢魔が主人公を脱衣","夢魔がパートナーを脱衣"
          down = true
        when "夢魔が主人公をホールド","夢魔がパートナーをホールド"
          down = true
       end
      end
    #レジスト失敗
    elsif @resist_flag == false
      if battler.is_a?(Game_Actor)
        case $msg.tag
        when "主人公が夢魔を脱衣","パートナーが夢魔を脱衣"
          down = true
        when "主人公が夢魔をホールド","パートナーが夢魔をホールド"
          if $msg.at_type == "自分ホールド解除" or $msg.at_type == "仲間ホールド解除"
            up = true
          else
            down = true
          end
        end
      else
        case $msg.tag
        when "夢魔が主人公を脱衣","夢魔がパートナーを脱衣"
          up = true
        when "夢魔が主人公をホールド","夢魔がパートナーをホールド"
          up = true
        end
      end
    #その他
    else
      case $msg.tag
      #自分から脱衣
      when "夢魔が自ら脱衣","夢魔が仲間夢魔を脱衣"
        up = true
      when "主人公が自ら脱衣","パートナーが自ら脱衣"
        up = true
      when "主人公がパートナーを脱衣","パートナーが主人公を脱衣"
        up = true
      end
    end
    #ムードの増減を行う
    if up == true
      pt = 6 + rand(3) - rand(3)
      $mood.rise(pt)
      if $msg.t_enemy != nil
        $msg.t_enemy.like(2)
      end
    elsif down == true
      pt = -4 + rand(2) - rand(3)
      $mood.rise(pt)
    end
    #レジストフラグを無効化する
    @resist_flag = nil
  end
end