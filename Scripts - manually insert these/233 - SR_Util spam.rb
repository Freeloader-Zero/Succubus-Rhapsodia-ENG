#==============================================================================
# ■ SR_Util　：　精液付与処理
#------------------------------------------------------------------------------
# 　精液外部処理（委託）。
#==============================================================================
module SR_Util
  #---------------------------------------------------------------------------- 
  # ● 精の献上時のスプライト作成（基本）
  #----------------------------------------------------------------------------
  def self.gift_graphic_flag(actor)
    $game_switches[177] = false # 脱衣
    $game_switches[178] = false # 挿入
    $game_switches[179] = false # フルコース（未実装）
    spots = rand(100)
    if actor.have_ability?("寵愛")
      if spots < 30
        $game_switches[178] = true 
      elsif spots < 60 
        $game_switches[177] = true 
      end
    elsif actor.love >= 50
      if spots < 50
        $game_switches[177] = true
      end
    end
  end
  #---------------------------------------------------------------------------- 
  # ● 精の献上時のスプライト作成（基本）
  #----------------------------------------------------------------------------
  def self.gift_graphic_make1(actor)
    $sprite = Sprite.new
    name = actor.battler_name
    name = actor.battler_name + "_N" if $game_switches[177]
    if $game_switches[178]
      if RPG::Cache.battler_exist?(actor.battler_name + "_I")
        name = actor.battler_name + "_I" 
      else
        name = actor.battler_name + "_N"
      end
    end
    $game_temp.gift_graphic = name
    graphic = RPG::Cache.battler($game_temp.gift_graphic,actor.battler_hue)
    $sprite.bitmap = Bitmap.new(graphic.width, graphic.height)
    $sprite.bitmap.blt(0, 0, graphic, Rect.new(0, 0, graphic.width, graphic.height), 255)
    $sprite.x = 320
    $sprite.y = 240
    $sprite.y += 60 if actor.boss_graphic?
    $sprite.ox = $sprite.bitmap.width / 2
    $sprite.oy = $sprite.bitmap.height / 2
    $sprite.opacity = 0
  end
  #---------------------------------------------------------------------------- 
  # ● 精の献上時のスプライト作成その２（ぶっかけ）
  #----------------------------------------------------------------------------
  def self.gift_graphic_make2(actor)
    graphic = RPG::Cache.battler($game_temp.gift_graphic + "_C",actor.battler_hue)
    $sprite.bitmap = Bitmap.new(graphic.width, graphic.height)
    $sprite.bitmap.blt(0, 0, graphic, Rect.new(0, 0, graphic.width, graphic.height), 255)
    # 精液OKならぶっかける
    if $game_system.system_sperm == true
      spam_graphic = RPG::Cache.battler($game_temp.gift_graphic + "__S",actor.battler_hue)
      if $game_switches[178]      
        spam_graphic = RPG::Cache.battler($game_temp.gift_graphic + "__Z",actor.battler_hue)
      end
      $sprite.bitmap.blt(0, 0, spam_graphic, Rect.new(0, 0, spam_graphic.width, spam_graphic.height), 255)
    end
    $sprite.x = 320
    $sprite.y = 240
    $sprite.y += 60 if actor.boss_graphic?
    $sprite.ox = $sprite.bitmap.width / 2
    $sprite.oy = $sprite.bitmap.height / 2
  end

  #---------------------------------------------------------------------------- 
  # ● ２つの名前の文字数が一定以上か？
  #----------------------------------------------------------------------------
  def self.names_over?(a_name, b_name, permition_number = 12)
    return ((a_name.size + b_name.size) / 3 > permition_number)
  end
  
  
  
  #---------------------------------------------------------------------------- 
  # ● 精液処理
  #----------------------------------------------------------------------------
  def self.spam_plus
    
    if $msg.t_target.is_a?(Game_Actor)
      target = $msg.t_target
    # 絶頂したのが主人公の場合、攻撃バトラーに精液をかける。
      if target == $game_actors[101] and $game_actors[101].nude?
        target.white_flash = true
        $game_system.se_play($data_system.actor_collapse_se)
        @wait_count = 30
        # 挿入中である場合、中出し
        if target.insert?
          n = 1
          # 挿入中であるエネミーを探し、そちらに中出しをする。
          for enemy in $game_troop.enemies
            if enemy.vagina_insert?
              enemy.add_state(10)
              enemy.lub_female += 60
              $game_temp.sperm_battler = enemy
#              $game_temp.battle_log_text += "\w\n" + enemy.bms_states_update
              # コモンイベントによる精液箇所の判断（０はぶっかけ）
              $game_variables[4] = 1
              $game_temp.sperm_battler.sperm(n) if $game_system.system_sperm
              # 白フラッシュだけは精液ON/OFF関わらずセット
              $game_temp.sperm_battler.white_flash = true
              #ステートテキストを挿入
              brk = ""
              brk = "、\n\m" if SR_Util.names_over?(enemy.name,$msg.t_target.name)
              if enemy == $msg.t_enemy
                if enemy.positive?
                  emotion = "アソコで絞り取った！"
                elsif enemy.negative?
                  emotion = "アソコに受け入れた！"
                else
                  emotion = "アソコで絞り取った！"
                end
                text = "#{enemy.name}は#{brk}#{$msg.t_target.name}の精を#{emotion}"
              else
                text = "#{$msg.t_target.name}は堪えきれず、\m\n#{enemy.name}の中に精を吐き出してしまった！"
              end
              $game_temp.battle_log_text += text + "\n\m"
#              $game_temp.battle_log_text += "\w\n" + enemy.bms_states_update + "\n"
              # 画像変更
              $game_temp.sperm_battler.graphic_change = true
              # この夢魔を表示にする
              $scene.enemies_display($game_temp.sperm_battler)
            end
          end
        else #if target.nude?
        # 挿入中でない場合、ぶっかけ
        #ただし、フェラ中、パイズリ中の対象が居る場合はそちらに発射する
          n = 0
          if $msg.t_target.penis_oralsex? or $msg.t_target.penis_paizuri?
            # 口淫中であるエネミーを探し、そちらに発射する。
            for enemy in $game_troop.enemies
              if enemy.mouth_oralsex? or enemy.tops_paizuri?
                enemy.add_state(9)
                enemy.lub_female += 15
                $game_temp.sperm_battler = enemy
                # コモンイベントによる精液箇所の判断（０はぶっかけ）
                $game_variables[4] = 0
                $game_temp.sperm_battler.sperm(n) if $game_system.system_sperm
                # 白フラッシュだけは精液ON/OFF関わらずセット
                $game_temp.sperm_battler.white_flash = true
                #ステートテキストを挿入
                brk = ""
                brk = "、\n\m" if SR_Util.names_over?(enemy.name,$msg.t_target.name)
                if enemy.mouth_oralsex?
                  if enemy == $msg.t_enemy
                    if enemy.positive?
                      emotion = "ごくりと飲み干した！"
                    elsif enemy.negative?
                      emotion = "こくりと飲み込んだ！"
                    else
                      emotion = "ごくりと飲み込んだ！"
                    end
                    text = "#{enemy.name}は#{brk}#{$msg.t_target.name}の精を#{emotion}"
                  else
                    text = "#{$msg.t_target.name}は堪えきれず、\m\n#{enemy.name}の口内に精を吐き出してしまった！"
                  end
                elsif enemy.tops_paizuri?
                  #夢魔の胸サイズ診断
                  brk2 = ""
                  brk2 = "、\n\m" if (enemy.name.size + enemy.bustsize.size) > 33
                  if enemy == $msg.t_enemy
                    text = "#{enemy.name}は\n#{$msg.t_target.name}の精を#{enemy.bustsize}で受け止めた！"
                  else
                    text = "#{$msg.t_target.name}は堪えきれず、\m\n#{enemy.name}の#{enemy.bustsize}に#{brk2}精を吐き出してしまった！"
                  end
                end
                $game_temp.battle_log_text += text + "\n\m"
                # 画像変更
                $game_temp.sperm_battler.graphic_change = true
                # この夢魔を表示にする
                $scene.enemies_display($game_temp.sperm_battler)
              end
            end
          else
            $msg.t_enemy.add_state(9)
            $msg.t_enemy.lub_female += 10
            $game_temp.sperm_battler = $msg.t_enemy
            # コモンイベントによる精液箇所の判断（０はぶっかけ）
            $game_variables[4] = 0
            $game_temp.sperm_battler.sperm(n) if $game_system.system_sperm
            # 白フラッシュだけは精液ON/OFF関わらずセット
            $game_temp.sperm_battler.white_flash = true
            #ステートテキストを挿入
            brk = ""
            brk = "、\n\m" if SR_Util.names_over?($msg.t_enemy.name,$msg.t_target.name)
            text = "#{$msg.t_target.name}は堪えきれず、\m\n#{$msg.t_enemy.name}に精を吐き出してしまった！"
            $game_temp.battle_log_text += text + "\n\m"
            # 画像変更
            $game_temp.sperm_battler.graphic_change = true
            # この夢魔を表示にする
            $scene.enemies_display($game_temp.sperm_battler)
          end
        end
      elsif not target.is_a?(Game_Enemy)
        $game_system.se_play($data_system.actor_collapse_se)
        target.white_flash = true
        @wait_count = 30
      else
        @wait_count = 8
      end
    end

  end
end
