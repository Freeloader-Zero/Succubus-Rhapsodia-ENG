#==============================================================================
# ■ Game_Battler (分割定義 5)
#------------------------------------------------------------------------------
# 　各種処理
#   ・潤滑度処理
#   ・アイテム効果処理
#   ・スリップダメージ処理
#   ・属性計算処理
#   ・ステート「淫毒」処理
#==============================================================================

class Game_Battler
  #--------------------------------------------------------------------------
  # ● アイテムの効果適用
  #     item : アイテム
  #--------------------------------------------------------------------------
  def item_effect(item)
    # クリティカルフラグをクリア
    self.critical = false
    # アイテムの効果範囲が HP 1 以上の味方で、自分の HP が 0、
    # またはアイテムの効果範囲が HP 0 の味方で、自分の HP が 1 以上の場合
    # （後者は属性216がついていれば無視）
    if ((item.scope == 3 or item.scope == 4) and self.hp == 0) or
       ((item.scope == 5 or item.scope == 6) and self.hp >= 1 and not item.element_set.include?(216))
      # メソッド終了
      return false
    end
    # 有効フラグをクリア
    effective = false
    # コモンイベント ID が有効の場合は有効フラグをセット
    effective |= item.common_event_id > 0
    # 命中判定
    hit_result = (rand(100) < item.hit)
    # 不確実なスキルの場合は有効フラグをセット
    effective |= item.hit < 100
    # 命中の場合
    if hit_result == true
      # 回復量を計算
      recover_hp = maxhp * item.recover_hp_rate / 100 + item.recover_hp
      recover_sp = maxsp * item.recover_sp_rate / 100 + item.recover_sp
      if recover_hp < 0
        recover_hp += self.pdef * item.pdef_f / 20
        recover_hp += self.mdef * item.mdef_f / 20
        recover_hp = [recover_hp, 0].min
      end
      # 属性修正
      recover_hp *= elements_correct(item.element_set)
      recover_hp /= 100
      recover_sp *= elements_correct(item.element_set)
      recover_sp /= 100
      # 分散
      if item.variance > 0 and recover_hp.abs > 0
        amp = [recover_hp.abs * item.variance / 100, 1].max
        recover_hp += rand(amp+1) + rand(amp+1) - amp
      end
      if item.variance > 0 and recover_sp.abs > 0
        amp = [recover_sp.abs * item.variance / 100, 1].max
        recover_sp += rand(amp+1) + rand(amp+1) - amp
      end
#      # 回復量の符号が負の場合
#      if recover_hp < 0
#        # 防御修正
#        if self.guarding?
#          recover_hp /= 2
#        end
#      end
      # HP 回復量の符号を反転し、ダメージの値に設定
      self.damage = -recover_hp
      # HP および SP を回復
      last_hp = self.hp
      last_sp = self.sp
      self.hp += recover_hp
      self.sp += recover_sp
      # ●クライシス判定（VPが残っていない場合は飛ばす）
      if self.sp > 0 and self.hp > 0 and $game_temp.in_battle
        #ダメージの場合
        if (self.hp < last_hp) and not self.states.include?(6)
          if self.hpp <= $mood.crisis_point(self) + rand(5)
            self.add_state(6)
          end
        #回復の場合
        elsif $mood != nil and (self.hp > last_hp) and self.states.include?(6)
          if self.hpp >= $mood.crisis_point(self) + rand(5)
            self.remove_state(6)
            self.crisis_flag = false
          end
        end
      end
      #友好度の上昇（贈り物アイテムの場合）
      if self.is_a?(Game_Enemy) and item.parameter > 0 and item.element_set.include?(199)
        # 贈り物をまだ受け取ってくれる場合
        unless self.present_fully?
          last_friendly = self.friendly
          self.friendly += item.parameter
          self.present_count += 1
          eff_flag_friendly |= self.friendly != last_friendly
        end
      end
      # 失神状態を回復させるものは、満腹度が３０以下の場合に３０まで回復させる。
      if (item.scope == 5 or item.scope == 6) and recover_sp > 0
        last_fed = self.fed
        if self.fed < 30
          self.fed = 30
        end
        eff_flag_fed |= self.fed != last_fed
        # 戦闘メンバーをリフレッシュ
        $game_party.battle_actor_refresh
      end
      #満腹度の回復
      if self.is_a?(Game_Actor) and item.parameter > 0 and item.element_set.include?(119)
        last_fed = self.fed
        self.fed += item.parameter
        eff_flag_fed |= self.fed != last_fed
      end
      #レベルアップ
      if item.parameter > 0 and item.element_set.include?(201)
        last_level = self.level
        self.level += item.parameter
        eff_flag_level |= self.level != last_level
      end
      effective |= self.hp != last_hp
      effective |= self.sp != last_sp
      effective |= eff_flag_friendly
      effective |= eff_flag_fed
      effective |= eff_flag_level
      # ステート変化
      # アイテムでステート変化を発生させる場合は個別に設定
      @state_changed = false
#      effective |= states_plus(item.plus_state_set)
      effective |= states_minus(item.minus_state_set)
      # パラメータ上昇値が有効の場合
      if item.parameter_type > 0 and item.parameter_points != 0
        # パラメータで分岐
        case item.parameter_type
        when 1  # MaxHP
          @maxhp_plus += item.parameter_points
        when 2  # MaxSP
          @maxsp_plus += item.parameter_points
        when 3  # 腕力
          @str_plus += item.parameter_points
        when 4  # 器用さ
          @dex_plus += item.parameter_points
        when 5  # 素早さ
          @agi_plus += item.parameter_points
        when 6  # 魔力
          @int_plus += item.parameter_points
        end
        # 有効フラグをセット
        effective = true
      end
      # HP 回復率と回復量が 0 の場合
      if item.recover_hp_rate == 0 and item.recover_hp == 0
        # ダメージに空文字列を設定
        self.damage = ""
        # SP 回復率と回復量が 0、パラメータ上昇値が無効の場合
        if item.recover_sp_rate == 0 and item.recover_sp == 0 and
           (item.parameter_type == 0 or item.parameter_points == 0)
          # ステートに変化がない場合
          if not @state_changed and not eff_flag_friendly and not eff_flag_fed and not eff_flag_level
            # ダメージに "Miss" を設定
            self.damage = "Miss"
          end
        end
      end
    # ミスの場合
    else
      # ダメージに "Miss" を設定
      self.damage = "Miss"
    end
    # 戦闘中でない場合
    unless $game_temp.in_battle
      # ダメージに nil を設定
      self.damage = nil
    end
    # メソッド終了
    return effective
  end
  #--------------------------------------------------------------------------
  # ● スリップダメージの効果適用
  #--------------------------------------------------------------------------
  def slip_damage_effect
    # ダメージを設定
    self.damage = self.maxhp / 10
    # 分散
    if self.damage.abs > 0
      amp = [self.damage.abs * 15 / 100, 1].max
      self.damage += rand(amp+1) + rand(amp+1) - amp
    end
    # HP からダメージを減算
    self.hp -= self.damage
    # メソッド終了
    return true
  end
  #--------------------------------------------------------------------------
  # ● 属性修正の計算
  #     element_set : 属性
  #--------------------------------------------------------------------------
  def elements_correct(element_set)
    # 無属性の場合
    if element_set == []
      # 100 を返す
      return 100
    end
    # 与えられた属性の中で最も弱いものを返す
    # ※メソッド element_rate は、このクラスから継承される Game_Actor
    #   および Game_Enemy クラスで定義される
    weakest = -100
    for i in element_set
      weakest = [weakest, self.element_rate(i)].max
    end
    return weakest
  end
  #--------------------------------------------------------------------------
  # ● 淫毒付与式(ネイジュレンジ専用処理)
  #    target : 付与対象
  #--------------------------------------------------------------------------
  def special_mushroom(target)
    
    # すでに淫毒である場合、メソッド終了
    return if target.state?(30)
    
    # 淫毒を耐性計算有りで付与
    target.add_state(30,false,true)
    # 淫毒が付与できていない場合、メソッド終了
    return unless target.state?(30)
    
    # 併発できるものを耐性込みで検査
    bs = [37,39,40]
    # 虚脱
    registance = target.state_percent(nil, 37, nil)
    if target.states.include?(37) or rand(100) >= registance
      bs.delete(37) 
    end
    # 麻痺
    registance = target.state_percent(nil, 39, nil)
    if target.states.include?(39) or rand(100) >= registance
      bs.delete(39) 
    end
    # 散漫
    registance = target.state_percent(nil, 40, nil)
    if target.states.include?(40) or rand(100) >= registance
      bs.delete(40) 
    end
    
    # 併発できるものがない場合、メソッド終了
    return if bs == []
    
    # 併発できるものの中から１つ選んでそのステートを付与
    bs = bs[rand(bs.size)]
    target.add_state(bs)

  end
  #--------------------------------------------------------------------------
  # ● 破面の併発
  #--------------------------------------------------------------------------
  def persona_break
    
    # 併発できるものを耐性込みで検査
    bs = [35,36,38,40]
    # 欲情
    registance = self.state_percent(nil, 35, nil)
    if self.states.include?(35) or rand(100) >= registance
      bs.delete(35) 
    end
    # 暴走
    registance = self.state_percent(nil, 36, nil)
    if self.states.include?(36) or rand(100) >= registance
      bs.delete(36) 
    end
    # 畏怖
    registance = self.state_percent(nil, 38, nil)
    if self.states.include?(38) or rand(100) >= registance
      bs.delete(38) 
    end
    # 散漫
    registance = self.state_percent(nil, 40, nil)
    if self.states.include?(40) or rand(100) >= registance
      bs.delete(40) 
    end
    
    # 併発できるものがない場合、メソッド終了
    return if bs == []
    
    # 併発できるものの中から１つ選んでそのステートを付与
    bs = bs[rand(bs.size)]
    self.add_state(bs)
  end
  #--------------------------------------------------------------------------
  # ● キススイッチＯＮ？
  #--------------------------------------------------------------------------
  def kiss_switch_on?
    return self.state?(97)
  end

end