#==============================================================================
# ■ Scene_Battle (分割定義 6)
#------------------------------------------------------------------------------
# 　バトル画面の処理を行うクラスです。
#==============================================================================

class Scene_Battle
  #--------------------------------------------------------------------------
  # ● フレーム更新 (援護行動)
  #--------------------------------------------------------------------------
  def update_phase4_step105
    # 初期化
    support_exist = false
    text = ""
    # バトルログをクリア
    @battle_log_window.contents.clear
    @battle_log_window.keep_flag = false
    $game_temp.battle_log_text = ""
    # 使用対象を確認
    actor_crisis_box = []
    actor_bad_state_box = []
    actor_status_down_box = []
    for actor_one in $game_party.battle_actors
      # ＥＰ約半分未満のアクター（主人公のみ）
      actor_crisis_box.push(actor_one) if actor_one.hpp < 60 and actor_one == $game_actors[101]
      # 状態以上が２以上のアクター
      actor_bad_state_box.push(actor_one) if actor_one.bad_state_number >= 2
      n = 0
      # 弱化が３以上のアクター
      for i in 0..5
        n += actor_one.state_runk[i] * -1 if actor_one.state_runk[i] < 0
      end
      actor_status_down_box.push(actor_one) if n >= 2
    end
    #--------------------------------------------------------------------------
    # ラーミルキャストの援護
    #--------------------------------------------------------------------------
    if $game_switches[401]
      # ラーミルキャストの名前を変数に入れる
      supporter = $game_actors[122].name
      # ２の倍数のターンに魔法を詠唱させる。
      if $game_temp.battle_turn % 2 == 0
        # 上のものほど優先
        #--------------------------------------------------------------------------
        # 自軍の誰かがＥＰ約半分未満の時は、300程度の回復を行う
        #--------------------------------------------------------------------------
        if actor_crisis_box.size > 0
          # 主人公を優先
          if actor_crisis_box.include?($game_actors[101])
            target = $game_actors[101]
          else 
            target = actor_crisis_box[0]
          end
          # 回復
          heal = 350 + rand(10) - rand(10)
          target.hp += heal
          target.animation_id = 70
          target.animation_hit = true
          text += "#{supporter}はイリスペタルを詠唱した！" + "\w\q"
          text += "#{target.name}のＥＰが #{heal.to_s} 回復した！" + "\w\q"
          if target.hpp >= $mood.crisis_point(target) + rand(5)
            target.remove_state(6)
            target.crisis_flag = false
            text += target.bms_states_update
            target.remove_states_log.clear
            target.graphic_change = true
          end
        #--------------------------------------------------------------------------
        # バステが２つ以上掛かっている場合はそれの解除
        #--------------------------------------------------------------------------
        elsif actor_bad_state_box.size > 0
          # 主人公を優先
          if actor_bad_state_box.include?($game_actors[101])
            target = $game_actors[101]
          else 
            target = actor_bad_state_box[0]
          end
          target.animation_id = 73
          target.animation_hit = true
          text += "#{supporter}はトリムオールを詠唱した！" + "\w\q"
          for i in 34..40
            target.remove_state(i)
          end
          text += target.bms_states_update
          target.remove_states_log.clear
        #--------------------------------------------------------------------------
        # 弱化合計が３以上の場合はそれの解除
        #--------------------------------------------------------------------------
        elsif actor_status_down_box.size > 0
          # 主人公を優先
          if actor_status_down_box.include?($game_actors[101])
            target = $game_actors[101]
          else 
            target = actor_status_down_box[0]
          end
          target.animation_id = 74
          target.animation_hit = true
          text += "#{supporter}はイーザカールを詠唱した！"
          # イーザカールの項目を通す
          text += special_status_check(target,[221])
          target.add_states_log.clear
          target.remove_states_log.clear
        #--------------------------------------------------------------------------
        # ピンチが無い場合は自軍全体を100程度小回復
        #--------------------------------------------------------------------------
        else
          text += "#{supporter}はイリスシード・アルダを詠唱した！" + "\w\q"
          for actor_one in $game_party.battle_actors
            heal = 150 + rand(10) - rand(10)
            actor_one.hp += heal
            actor_one.animation_id = 69
            actor_one.animation_hit = true
            text += "#{actor_one.name}のＥＰが #{heal.to_s} 回復した！" + "\w\q"
            if actor_one.hpp >= $mood.crisis_point(actor_one) + rand(5)
              actor_one.remove_state(6)
              actor_one.crisis_flag = false
              text += actor_one.bms_states_update
              actor_one.remove_states_log.clear
              actor_one.graphic_change = true
            end
          end
        end
        # テキストに追加
        $game_temp.battle_log_text = text
        support_exist = true
      # ３の倍数以外のターンは詠唱
      else
        Audio.se_play("Audio/SE/087-Action02", 80, 100)
        $game_temp.battle_log_text = "#{supporter}は詠唱している！"
        support_exist = true
      end
    end
    # 援護が発生した場合、ウェイトを付ける
    if support_exist
      # ステータスのリフレッシュ
      @status_window.refresh
      #▼システムウェイト
      if $game_temp.battle_log_text != ""
        @wait_count = system_wait_make($game_temp.battle_log_text)
      end
    end
    # ステップ 103 に移行
    @phase4_step = 103
  end
  #--------------------------------------------------------------------------
  # ★ ステータス上昇テキストを作成
  #--------------------------------------------------------------------------
  def special_status_check(battler_one, skill_id_box = [])
    text = ""
    for i in skill_id_box
      battler_one.capacity_alteration_effect($data_skills[i]) 
      m = "#{battler_one.bms_states_update}"
      if m != "しかし#{battler_one.name}には効果が無かった！"
        text += "\w\q" + m
      end
    end
    return text
  end
  #--------------------------------------------------------------------------
  # ★ インセンス効果
  #--------------------------------------------------------------------------
  def incense_effect
    # バトラーずつに効果があるもの
    text = ""
    for battler_one in $game_party.battle_actors + $game_troop.enemies
      # リラックスタイムは小回復
      if $incense.exist?("リラックスタイム", battler_one)
        battler_one.hp += battler_one.maxhp / 16
        if battler_one.hpp >= $mood.crisis_point(battler_one) + rand(5)
          battler_one.remove_state(6)
          battler_one.crisis_flag = false
          text += battler_one.bms_states_update
          battler_one.graphic_change = true
          battler_one.remove_states_log.clear
        end
        battler_one.animation_id = 51
        battler_one.animation_hit = true
      end
    end
    $game_temp.battle_log_text += text if text != ""
    $mood.rise(4) if $incense.exist?("ラブフレグランス", 2)
    # ステータスのリフレッシュ
    @status_window.refresh
  end  
  #--------------------------------------------------------------------------
  # ★ インセンス効果
  #--------------------------------------------------------------------------
  def incense_start_effect
    text = ""
    case @command.name
    when "リラックスタイム"
      for target_one in @target_battlers
        heal_one = target_one.maxhp / 16
        target_one.hp += heal_one
        text += "#{target_one.name}のＥＰが #{heal_one.to_s} 回復した！" + "\w\q"
        if target_one.hpp >= $mood.crisis_point(target_one) + rand(5)
          target_one.remove_state(6)
          target_one.crisis_flag = false
          text += target_one.bms_states_update
          target_one.remove_states_log.clear
          target_one.graphic_change = true
        end
      end
    when "ラブフレグランス"
      $mood.rise(4)
    end
    text = "\w\q" + text if text != ""
    return text
  end  
  #--------------------------------------------------------------------------
  # ● スタンメソッド
  #--------------------------------------------------------------------------
  def battler_stan(battler)
    @action_battlers.delete(battler)
  end
  #--------------------------------------------------------------------------
  # ● 出現時エフェクトの指示
  #--------------------------------------------------------------------------
  def appear_effect_order(battlers=[])
    @effect_order_battlers = []
    for battler_one in battlers.dup
      @effect_order_battlers.push(battler_one) if battler_one.exist?
    end
    @appear_effect_step_count = 0
    @go_appear_effect_step = true
  end  
  #--------------------------------------------------------------------------
  # ● 絶頂時エフェクトの指示
  #--------------------------------------------------------------------------
  def dead_effect_order(battlers=[])
    @effect_order_battlers = []
    for battler_one in battlers.dup
      @effect_order_battlers.push(battler_one) if battler_one.exist?
    end
    @dead_effect_step_count = 0
    @go_dead_effect_step = true
  end  
  #--------------------------------------------------------------------------
  # ● フレーム更新 (特殊：出現時エフェクト)
  #--------------------------------------------------------------------------
  def appear_effect_step
    # 文章のリフレッシュ
    @battle_log_window.contents.clear
    @battle_log_window.keep_flag = false
    $game_temp.battle_log_text = ""
    # ループ解除フラグを初期化
    end_flag = false
    #----------------------------------------------------------------------
    # 素質確認のループを開始
    while end_flag == false
      # 何も通らなかった用に終了フラグを立てる。
      end_flag = true
      #----------------------------------------------------------------------
      # 0：素質【高揚】と【沈着】
      # 戦闘参加時に高揚or沈着状態になる。
      #----------------------------------------------------------------------
      if @appear_effect_step_count == 0
        for battler in @effect_order_battlers
          text = ""
          # 【高揚】を持ち、【沈着】が無い場合は【高揚】処理
          if battler.have_ability?("高揚") \
           and not battler.have_ability?("沈着")
            text += "\w\q" if $game_temp.battle_log_text != ""
            text += "#{battler.name}は興奮している！"
            $game_temp.battle_log_text += text
            battler.animation_id = 123
            battler.animation_hit = true
            # このバトラーを高揚状態にする
            battler.add_state(41)
            battler.add_states_log.clear
          end
          text = ""
          # 【沈着】を持ち、【高揚】が無い場合は【沈着】処理
          if battler.have_ability?("沈着") \
           and not battler.have_ability?("高揚")
            text += "\w\q" if $game_temp.battle_log_text != ""
            text += "#{battler.name}は落ち着いている！"
            $game_temp.battle_log_text += text
            battler.animation_id = 124
            battler.animation_hit = true
            # このバトラーを沈着状態にする
            battler.add_state(42)
            battler.add_states_log.clear
          end
        end
        # エフェクトを確認したのでループを終了させない
        end_flag = false
      end
      #----------------------------------------------------------------------
      # 1：素質【粘体】
      # 初期状態で潤滑度が高い。
      #----------------------------------------------------------------------
      if @appear_effect_step_count == 1
        for battler in @effect_order_battlers
          if battler.have_ability?("粘体")
            # 男または両性具有の場合、♂の潤滑を引き上げる
            if battler.boy? or battler.futanari?
              if battler.lub_male < 60
                battler.lub_male = 60
                battler.add_state(21)
              end
            end
            # 女（または両性具有）の場合、♀の潤滑を引き上げる
            if battler.girl? or battler.futanari?
              if battler.lub_female < 60
                battler.lub_female = 60
                battler.add_state(23)
              end
            end
            # 性別に関わらず、菊座の潤滑を引き上げる
            if battler.lub_anal < 60
              battler.lub_anal = 60
              battler.add_state(23)
            end
            # テキスト表示しないのでステートログをクリア
            battler.add_states_log = []
          end
        end
        # エフェクトを確認したのでループを終了させない
        end_flag = false
      end
      #----------------------------------------------------------------------
      # 2：素質【サンチェック】（味方）
      # 出現時に敵全員を畏怖状態にする。
      #----------------------------------------------------------------------
      if @appear_effect_step_count == 2
        for battler in @effect_order_battlers
          text = ""
          if battler.have_ability?("サンチェック") and battler.is_a?(Game_Actor)
            # ＶＰが消費できるか
            go_flag = false
            go_flag = true if battler.sp > 100
            # フラグが立っていれば処理を行う
            if go_flag
              # コストを消費
              battler.sp -= 100
              battler.animation_id = 190
              battler.animation_hit = true
              text += "\w\q" if $game_temp.battle_log_text != ""
              text += "#{battler.name}は相手を恐怖に駆り立てた！"
              if battler.is_a?(Game_Actor)
                for enemy in $game_troop.enemies
                  if enemy.exist?
                    enemy.add_state(38, false, true)
                    if enemy.add_states_log.include?($data_states[38])
                      enemy.animation_id = 80
                      enemy.animation_hit = true
                      text += "\w\q" + enemy.bms_states_update(battler)
                    end
                  end
                end
              end
              $game_temp.battle_log_text += text
            end
          end
        end
        # エフェクトを確認したのでループを終了させない
        end_flag = false
      end
      #----------------------------------------------------------------------
      # 3：素質【サンチェック】（敵）
      # 出現時に敵全員を畏怖状態にする。
      #----------------------------------------------------------------------
      if @appear_effect_step_count == 3
        for battler in @effect_order_battlers
          text = ""
          if battler.have_ability?("サンチェック") and battler.is_a?(Game_Enemy)
            # ＶＰが消費できるか
            go_flag = false
            go_flag = true if battler.sp > 100
            # フラグが立っていれば処理を行う
            if go_flag
              # コストを消費
              battler.sp -= 100
              battler.animation_id = 190
              battler.animation_hit = true
              text += "\w\q" if $game_temp.battle_log_text != ""
              text += "#{battler.name}は相手を恐怖に駆り立てた！"
              if battler.is_a?(Game_Enemy)
                for actor in $game_party.battle_actors
                  if actor.exist?
                    actor.add_state(38, false, true)
                    if actor.add_states_log.include?($data_states[38])
                      actor.animation_id = 80
                      actor.animation_hit = true
                      text += "\w\q" + actor.bms_states_update(battler)
                    end
                  end
                end
              end
              $game_temp.battle_log_text += text
            end
          end
        end
        # エフェクトを確認したのでループを終了させない
        end_flag = false
      end
      #----------------------------------------------------------------------
      # 4：素質【慧眼】
      # 出現時に相手全員をチェック状態にする。
      #----------------------------------------------------------------------
      if @appear_effect_step_count == 4
        for battler in @effect_order_battlers
          text = ""
          if battler.have_ability?("慧眼")
            if battler.is_a?(Game_Actor)
              for enemy in $game_troop.enemies
                if enemy.exist? and enemy.checking < 1
                  enemy.checking = 1
                end
              end
            elsif battler.is_a?(Game_Enemy)
              for actor in $game_party.battle_actors
                if actor.exist? and actor.checking < 1
                  actor.checking = 1
                end
              end
            end
          end
        end
        # エフェクトを確認したのでループを終了させない
        end_flag = false
      end
      #----------------------------------------------------------------------
      # 5：インセンス「レッドカーペット」
      # 出現時に魅力と素早さを強化する。
      #----------------------------------------------------------------------
      if @appear_effect_step_count == 5
        for battler in @effect_order_battlers
          text = ""
          if $incense.exist?("レッドカーペット", battler)
            text += "\w\q" if $game_temp.battle_log_text != ""
            text += "#{battler.name}は劇的な入場を果たした！"
            battler.animation_id = 55
            battler.animation_hit = true
            # このバトラーの魅力と精力を１段階上げる
            # ラナンブルム、コリオブルムの強化項目を通す
            text += special_status_check(battler,[171,187])
            $game_temp.battle_log_text += text
            battler.add_states_log.clear
            n = 0 if battler.is_a?(Game_Actor)
            n = 1 if battler.is_a?(Game_Enemy)
            $incense.delete_incense("レッドカーペット", n)
            Audio.se_play("Audio/SE/059-Applause01", 80, 100)
          end
        end
        # エフェクトを確認したのでループを終了させない
        end_flag = false
      end
      #----------------------------------------------------------------------
      # カウントを進める
      @appear_effect_step_count += 1
      # テキストがあるならウェイトをかけて返す
      return if effect_text_check
    end
    #------------------------------------------------------------------------
    # フラグを切り、通常のステップへ戻す
    @go_appear_effect_step = false
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新 (特殊：絶頂時エフェクト)
  #--------------------------------------------------------------------------
  def dead_effect_step
    # 文章のリフレッシュ
    @battle_log_window.contents.clear
    @battle_log_window.keep_flag = false
    $game_temp.battle_log_text = ""
    # ループ解除フラグを初期化
    end_flag = false
    
    #----------------------------------------------------------------------
    # 素質確認のループを開始
    while end_flag == false
      # 何も通らなかった用に終了フラグを立てる。
      end_flag = true
      #----------------------------------------------------------------------
      # 0 : 素質【焦欲】
      # 自分以外の味方が絶頂した時、自分の魅力と精力を１段階上げる
      #----------------------------------------------------------------------
      if @dead_effect_step_count == 0
        # 全員を確認
        for battler in @effect_order_battlers
          text = ""
          effect_text = ""
          if battler.have_ability?("焦欲")
            go_flag = false
            # 絶頂したバトラーの中に、自分以外の味方がいる場合フラグを立てる
            for ecstasy_battler in @ecstasy_battlers_clone
              if ecstasy_battler != battler and
               ((battler.is_a?(Game_Actor) and ecstasy_battler.is_a?(Game_Actor)) or
               (battler.is_a?(Game_Enemy) and ecstasy_battler.is_a?(Game_Enemy)))
                go_flag = true
              end
            end
            # フラグが立っていれば処理を行う
            if go_flag
              text += "\w\q" if $game_temp.battle_log_text != ""
              text += "#{battler.name}は味方の絶頂を見て昂った！"
              # このバトラーの魅力と精力を１段階上げる
              # ラナンブルム、エルダブルムの強化項目を通す
              effect_text += special_status_check(battler,[171,179])
              # 効果があるなら表示させる
              if effect_text != ""
                battler.animation_id = 123
                battler.animation_hit = true
                $game_temp.battle_log_text += text + effect_text
              end
              battler.add_states_log.clear
            end
          end
        end
        # エフェクトを確認したのでループを終了させない
        end_flag = false
      end
      #----------------------------------------------------------------------
      # 1 : 素質【対抗心】
      # 味方の絶頂時に味方の数が敵の数より少ない場合、精力と素早さを上げる。
      #----------------------------------------------------------------------
      if @dead_effect_step_count == 1
        # 全員を確認
        for battler in @effect_order_battlers
          text = ""
          effect_text = ""
          if battler.have_ability?("対抗心")
            # フラグを初期化
            go_flag = false
            # 絶頂したバトラーの中に、味方がいる場合フラグを立てる
            for ecstasy_battler in @ecstasy_battlers_clone
              if (battler.is_a?(Game_Actor) and ecstasy_battler.is_a?(Game_Actor)) or
               (battler.is_a?(Game_Enemy) and ecstasy_battler.is_a?(Game_Enemy))
                go_flag = true
              end
            end
            # フラグが立っていない場合次のバトラーに
            next if go_flag == false
            # フラグを再初期化（使い回し）
            go_flag = false
            # 生存している味方の数と敵の数を調べる
            actors_number = 0
            enemies_number = 0
            for actor in $game_party.party_actors
              actors_number += 1 if actor.exist?
            end
            for enemy in $game_troop.enemies
              enemies_number += 1 if enemy.exist?
            end
            # 味方数 < 敵数になっている場合、フラグを立てる
            if (battler.is_a?(Game_Actor) and enemies_number > actors_number) or
             (battler.is_a?(Game_Enemy) and actors_number > enemies_number)
              go_flag = true
            end
            # フラグが立っていれば処理を行う
            if go_flag
              text += "\w\q" if $game_temp.battle_log_text != ""
              text += "#{battler.name}は不利な状況に対抗心を燃やした！"
              # このバトラーの精力と素早さを１段階上げる
              # エルダブルム、コリオブルムの強化項目を通す
              effect_text += special_status_check(battler,[179,187])
              # 効果があるなら表示させる
              if effect_text != ""
                battler.animation_id = 123
                battler.animation_hit = true
                $game_temp.battle_log_text += text + effect_text
              end
              battler.add_states_log.clear
            end
          end
        end
        # エフェクトを確認したのでループを終了させない
        end_flag = false
      end
      #----------------------------------------------------------------------
      # 2 : 素質【エクスタシーボム】
      # 自分が絶頂した時、自分以外の味方全員を暴走状態にする。
      #----------------------------------------------------------------------
      if @dead_effect_step_count == 2
        # 全員を確認
        for battler in @effect_order_battlers
          text = ""
          if battler.have_ability?("エクスタシーボム")
            # フラグを初期化
            go_flag = false
            # 絶頂したバトラーの中に、自分がいる場合フラグを立てる
            for ecstasy_battler in @ecstasy_battlers_clone
              if ecstasy_battler == battler
                go_flag = true
                break
              end
            end
            # 自軍が自分しかいない場合はフラグを下ろす
            army = $game_party.battle_actors if battler.is_a?(Game_Actor)
            army = $game_troop.enemies if battler.is_a?(Game_Enemy)
            army_count = 0
            for army_one in army
              army_count += 1 if army_one.exist?
            end
            go_flag = false if army_count <= 1
            # フラグが立っていれば処理を行う
            if go_flag
              text += "\w\q" if $game_temp.battle_log_text != ""
              text += "#{battler.name}の絶頂が他の味方を刺激する！"
              # 効果対象を入れる配列を作成
              effect_battlers = []
              # 自分以外の味方全員を配列に入れる。
              if battler.is_a?(Game_Actor)
                for actor in $game_party.battle_actors
                  effect_battlers.push(actor) if actor.exist? and actor != battler
                end
              elsif battler.is_a?(Game_Enemy)
                for enemy in $game_troop.enemies
                  effect_battlers.push(enemy) if enemy.exist? and enemy != battler
                end
              end
              # 効果対象全員に処理を行う
              for effected_one in effect_battlers
                # 暴走を耐性計算ありで付与
                effected_one.add_state(36, false, true)
                # これにより暴走状態になった時、アニメーションとテキストを表示
                if effected_one.add_states_log.include?($data_states[36])
                  effected_one.animation_id = 123
                  effected_one.animation_hit = true
                  text += "\w\q" + effected_one.bms_states_update
                else
                  text += "\w\q" + "#{effected_one.name}には効果がなかった！"
                end
              end
              $game_temp.battle_log_text += text
              battler.add_states_log.clear
            end
          end
        end
        # エフェクトを確認したのでループを終了させない
        end_flag = false
      end
      #--------------------------------------------------------------------
      # カウントを１進める
      @dead_effect_step_count += 1
      # テキストがあるならウェイトをかけて返す
      return if effect_text_check
    end
    #------------------------------------------------------------------------
    # フラグを切り、通常のステップへ戻す
    @go_dead_effect_step = false
  end

  #--------------------------------------------------------------------------
  # ● フレーム更新 出現時、絶頂時エフェクトのテキストチェック
  #--------------------------------------------------------------------------
  def effect_text_check
    return_flag = false
    # テキストがある場合、ウェイトを作りメソッドを終了させる。
    if $game_temp.battle_log_text != ""
      @status_window.refresh
      $game_temp.battle_log_text += "\w\q" if $game_system.system_read_mode == 0
      #▼システムウェイト
      @wait_count = system_wait_make($game_temp.battle_log_text)
      return_flag = true
    end
    return return_flag
  end
end