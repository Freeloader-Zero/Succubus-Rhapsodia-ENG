#==============================================================================
# ★ Game_Battler TextMake
#------------------------------------------------------------------------------
# 　バトルメッセージ処理
#==============================================================================

class Game_Battler
  ##################
  #● ステート報告 #
  ##################
  def bms_states_report
    text = ""
    # ステートでreportが設定されているものを全て取得
    # ただしクライシスは除外
    for i in self.states
      if $data_states[i].id != 6 and self.exist? and not self.dead?
        ms = $data_states[i].message($data_states[i],"report",self,nil)
        text = (text + ms + "\w\q") if ms != ""
      end
    end
    # メッセージ表示
    if text != ""
      text += "CLEAR"
      text.sub!("\w\qCLEAR","")
      return text
    else
      return ""
    end
  end
  ######################
  #● ステート変化報告#
  ######################
  def bms_states_update(user_battler = nil)
    user = $game_temp.battle_active_battler
    user = nil if $game_temp.battle_active_battler == [] and user_battler == nil #ターン開始時のみ
    user = user_battler if user_battler != nil
    ms1 = ms2 = ""
    text1 = text2 = ""
    if (self.add_states_log == [] and self.remove_states_log == [])
      return ""
    end
    # ステート付加報告
    if self.add_states_log != []
      for i in self.add_states_log
        ms1 = i.message(i,"effect", self, user)
        # 戦闘不能なら報告終了
        if i.id == 1
          text1 = ms1
          self.add_states_log.clear
          return text1
        end
        #改行を挿入
        text1 = text1 + ms1 + "\w\q" if ms1 != ""
      end
      #格納終了したらログを消去する
      self.add_states_log.clear
    end
    # ステート解除報告
    if self.remove_states_log != [] and not self.dead?
      for i in self.remove_states_log
        ms2 = i.message(i,"recover", self, user)
        #改行を挿入
        text2 = text2 + ms2 + "\w\q" if ms2 != ""
      end
      #格納終了したらログを消去する
      self.remove_states_log.clear
    end
    # テキスト整形
    text = text1 + text2
    # メッセージ出力
    if text != ""
      #文章がある場合、最後の改行を消す
      text += "CLEAR"
      text.sub!("\w\qCLEAR","")
      return text
    else
      return ""
    end
  end
  #-------------------------#
  # ● スキル使用メッセージ #
  #-------------------------#
  def bms_useskill(skill)
    user = $game_temp.battle_active_battler
    text = skill.message(skill, "action", self, user)
    if text != "" and text != nil
      text = text + "\q"
      # 挑発による対象変更が発生している場合、誘引メッセージを出す
      if $game_temp.incite_flag
        text = "#{user.name} ｗas invited!\q\m" + text
      end
      $game_temp.battle_log_text = text
    end
  end
  #-----------------------------#
  # ● スキル使用結果メッセージ #
  #-----------------------------#
  def bms_skill_effect(skill)
    user = $game_temp.battle_active_battler
    plus = ""
    text = ""
    if self.damage.is_a?(Numeric)
      myname = self.name
      username = $game_temp.battle_active_battler.name
      damage = self.damage
      # ●クリティカル処理
      if self.critical and self.damage != "Miss"
#        plus += "センシュアルストローク！\w\q"
        plus += "Sensual Stroke！\w\q"
        self.animation_id = 103
        self.animation_hit = true
        self.damage_pop = true
        # ムードアップ
        $mood.rise(1 + rand(5))
      else
        plus = ""
      end
      # ●ダメージ処理(値がマイナスなら回復スキル)
      if damage > 0
        if user.is_a?(Game_Actor)
          text = "Dealt #{damage.to_s} pleasure to #{myname}!"
          text = "#{myname} ｗrithes in pleasure!" if self.weaken? and not self.dead?
          text = "#{myname}'s body spasｍs from intense pleasure!" if self.sp_down_flag == true
        else
          text = "#{myname} received #{damage.to_s} pleasure!"
          text = "#{myname} ｗrithes in pleasure!" if self.weaken?
          text = "#{myname}'s body spasｍs from intense pleasure!" if self.sp_down_flag == true
          text = "#{myname}'s vitality has been cut...!" if self.weaken? and self == $game_actors[101]
          text = "#{myname}'s body has been pushed to its liｍit!" if self.sp_down_flag == true and self == $game_actors[101]
        end
      elsif damage == 0# and damage < 1
        if user.is_a?(Game_Actor)
          text = "#{myname} didn't take any pleasure!"
        else
          text = "#{myname} didn't take any pleasure!"
        end
      else
        n = self.damage * 80 / 100
        text = "#{myname} recovered #{(damage.abs).to_s}ＥＰ!"
      end
    elsif self.damage == "Miss"
      text = skill.message(skill,"avoid", self, user)
    end
    text = plus + text if plus != ""
    
# ダメージ無しスキルでムードが上がらないのでScene_Battleに移植
=begin
    # ムードアップ処理
    #------------------------------------------------------
    # ムードアップ小
    if skill.element_set.include?(20)
      $mood.rise(1)
    # ムードアップ中
    elsif skill.element_set.include?(21)
      $mood.rise(4)
    # ムードアップ大
    elsif skill.element_set.include?(22)
      $mood.rise(10)
    end
=end

    
    return text
  end
  #---------------------------------#
  # ● 演出スキル使用結果メッセージ #
  #---------------------------------#
  def bms_direction_skill_effect(skill)
    text = ""
    myname = self.name
    username = $game_temp.battle_active_battler.name
    #------------------------------------------------------------------------#        
    # ■特殊スキル
    case skill.id
    when 419   #アンラッキーロア
      text = "#{$game_actors[101].name}は不幸になってしまった！\w\q"
      # 不幸でない場合、不幸状態にする。
      if $game_variables[61] == 0
        $game_variables[61] = 50 
      end
    when 239   #シャイニングレイジ
      text = "闇を裁く閃光の鉄槌が、悪しき者どもを貫く！！\w\q"
    end
    #------------------------------------------------------------------------#        
    return text
  end
 
  #---------------------------#
  # ● アイテム使用メッセージ #
  #---------------------------#
  def bms_useitem(item)
    user = $game_temp.battle_active_battler
    text = item.message(item, "action", self, user)
    if text != nil
      text = text + "\q"
      $game_temp.battle_log_text = text
    end
  end
  #-------------------------------#
  # ● アイテム使用結果メッセージ #
  #-------------------------------#
  def bms_item_effect(item)
    user = $game_temp.battle_active_battler
    text = ""
    myname = self.name
    damage = self.damage
    # EPとVP両方回復の場合
    if (item.recover_hp_rate > 0 or item.recover_hp > 0) and
       (item.recover_sp_rate > 0 or item.recover_sp > 0)
      text = "#{myname} recovered #{(damage.abs).to_s}ＥＰ!\q" + 
             "#{myname} recovered #{(recover_sp).to_s}ＶＰ!！"
      text = "しかし今は効果が無かった！" if self.state?("衰弱")
    # EPのみ回復の場合
    elsif (item.recover_hp_rate > 0 or item.recover_hp > 0)
      text = "#{myname} recovered #{(damage.abs).to_s}ＥＰ!"
      text = "Ｈoｗever it seems to be ineffective!" if self.state?("衰弱")
    # VPのみ回復の場合
    elsif (item.recover_sp_rate > 0 or item.recover_sp > 0)
      text = "#{myname} recovered #{(recover_sp).to_s}ＶＰ!"
    # 贈り物アイテムアイテムの場合
    elsif item.element_set.include?(199)
      text = bms_present_response
    end
    # ミスの場合回避メッセージを表示
    if self.damage == "Miss"
      text = item.message(item,"avoid", self, user)
    end
    # メッセージ表示
    return text
  end
  #-------------------------------#
  # ● 贈り物を受け取った反応     #
  #-------------------------------#
  def bms_present_response
    text = ""
    myname = self.name
    user = $game_temp.battle_active_battler.name
    # 性格ごとに変更
    case self.personality
    #------------------------------------------------------------------------
    when "好色","高慢","独善"
      text = "#{myname} sｍiles suggestively...!"
    #------------------------------------------------------------------------
    when "陽気","天然","甘え性","暢気"
      text = "#{myname} is sｍiling happily...！"
    #------------------------------------------------------------------------
    when "好色","上品","柔和","従順","高貴"
      text = "#{myname} has a subｍissively pleased look on her face...!"
    #------------------------------------------------------------------------
    when "勝ち気","意地悪","気丈","尊大"
      text = "#{myname} looks aｗay to shadoｗ her eｍbarrassｍent...!"
    #------------------------------------------------------------------------
    when "淡泊","不思議","倒錯","陰気"
      text = "#{myname} seeｍs soｍeｗhat pleased...!"
    #------------------------------------------------------------------------
    when "内気","虚勢","潔癖"
      text = "#{myname}'s face is blushing red ｗith eｍbarrassｍent...!"
    #------------------------------------------------------------------------
    when "露悪狂"
      text = "#{myname} appears aｍused,\n\m sneering and laughing at #{user}...!"
    #------------------------------------------------------------------------
    else
      text = "#{myname} seeｍs to be pleased...!"
    end
    # 返す
    return text
  end
  
end