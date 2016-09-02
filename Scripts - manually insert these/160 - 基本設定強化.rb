#_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
#_/    ◆ 基本設定強化 - KGC_Base Reinforce ◆
#_/    ◇ Last update : 2009/08/23 ◇
#_/----------------------------------------------------------------------------
#_/  RPGXPの基本機能を微妙に強化します。(バグ修正もあり)
#_/============================================================================
#_/ ≪ステートアイコン表示[StateIcon]≫より下
#_/  なるべく上の方 ([Scene_Debug] の直下付近) に導入してください。
#_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/

#==============================================================================
# ★ カスタマイズ項目 - Customize ★
#==============================================================================

module KGC
  # ◆戦闘背景全体化
  BR_BATTLEBACK_FULL = true
  # ◆戦闘時のステータスウィンドウ透過
  #  BR_BATTLEBACK_FULL が true のときに有効。
  BR_WINDOW_TRANSPARENT_BATTLE = true
  # ◆メインフェーズ時にウィンドウ透過
  #  BR_WINDOW_TRANSPARENT_MAIN_PHASE が false のときに有効。
  BR_WINDOW_TRANSPARENT_MAIN_PHASE = true
  # ◆メインフェーズ時にウィンドウ背景だけ半透過
  #  BR_WINDOW_TRANSPARENT_MAIN_PHASE が false のときに有効。
  BR_WINDOW_BACK_CLEAR_MAIN_PHASE = true
  # ◆メインフェーズ時に、ウィンドウ内部の不透明度を下げない
  BR_WINDOW_OPACITY_FIX = true

  # ◆戦闘時の名前表示を影文字化
  BR_SHADOW_TEXT_NAME_BATTLE = true
  # ◆戦闘時のステート表示を影文字化
  #  他サイトのステート関連スクリプトがバグる場合は false にしてください。
  #  ≪ステートアイコン表示≫ 導入時は無効です。
  BR_SHADOW_TEXT_STATE_BATTLE = true

  # ◆戦闘開始トランジション(nil で解除)
  BR_BATTLE_START_TRANSITION = nil
  #BR_BATTLE_START_TRANSITION = "016-Diamond02"
end

#★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★

$imported = {} if $imported == nil
$imported["Base Reinforce"] = true

#==============================================================================
# ■ RPG::Sprite
#==============================================================================

class RPG::Sprite
  def animation_set_sprites(sprites, cell_data, position)
    for i in 0..15
      sprite = sprites[i]
      pattern = cell_data[i, 0]
      if sprite == nil || pattern == nil || pattern == -1
        sprite.visible = false if sprite != nil
        next
      end
      sprite.visible = true
      sprite.src_rect.set(pattern % 5 * 192, pattern / 5 * 192, 192, 192)
      if position == 3
        if self.viewport != nil
          sprite.x = self.viewport.rect.width / 2
          if self.viewport.rect.height == 481
            sprite.y = 300
          else
            sprite.y = self.viewport.rect.height / 2
          end
        else
          sprite.x, sprite.y = 320, 240
        end
      else
        sprite.x = self.x - self.ox + self.src_rect.width / 2
        sprite.y = self.y - self.oy + self.src_rect.height / 2
        sprite.y -= self.src_rect.height / 4 if position == 0
        sprite.y += self.src_rect.height / 4 if position == 2
      end
      sprite.x += cell_data[i, 1]
      sprite.y += cell_data[i, 2]
      sprite.z = 2000
      sprite.ox = sprite.oy = 96
      sprite.zoom_x = cell_data[i, 3] / 100.0
      sprite.zoom_y = cell_data[i, 3] / 100.0
      sprite.angle = cell_data[i, 4]
      sprite.mirror = (cell_data[i, 5] == 1)
      sprite.opacity = cell_data[i, 6] * self.opacity / 255.0
      sprite.blend_type = cell_data[i, 7]
    end
  end
end

#★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★

#==============================================================================
# ■ Sprite_Battler
#==============================================================================

class Sprite_Battler < RPG::Sprite
  #--------------------------------------------------------------------------
  # ● フレーム更新
  #--------------------------------------------------------------------------
  alias update_KGC_Base_Reinforce update
  def update
    # バトラーが nil の場合
    if @battler == nil
      @battler_name = nil
      @battler_hue = nil
    end

    update_KGC_Base_Reinforce
  end
end

#★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★

#==============================================================================
# ■ Spriteset_Battle
#==============================================================================

if KGC::BR_BATTLEBACK_FULL
class Spriteset_Battle
  #--------------------------------------------------------------------------
  # ● フレーム更新
  #--------------------------------------------------------------------------
  alias update_KGC_Base_Reinforce update
  def update
    # 元の処理を実行
    update_KGC_Base_Reinforce

    @viewport1.rect.height = 480
    @viewport2.rect.height = 481
    # バトルバックが変更された場合
    if @battleback_name2 != $game_temp.battleback_name
      # 全体化
      @battleback_name2 = $game_temp.battleback_name
      mag_x = 640.0 / @battleback_sprite.bitmap.width
      mag_y = 480.0 / @battleback_sprite.bitmap.height
      @battleback_sprite.zoom_x = mag_x
      @battleback_sprite.zoom_y = mag_y
    end
  end
end
end

#★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★

#==============================================================================
# ■ Window_BattleStatus
#==============================================================================

class Window_BattleStatus < Window_Base
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  alias initialize_KGC_Base_Reinforce initialize
  def initialize
    initialize_KGC_Base_Reinforce

    # 背景透過
    if KGC::BR_WINDOW_TRANSPARENT_BATTLE
      self.opacity = 0
    end
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新
  #--------------------------------------------------------------------------
  if KGC::BR_BATTLEBACK_FULL && !KGC::BR_WINDOW_TRANSPARENT_BATTLE
  def update
    super
    # メインフェーズのときは不透明度をやや下げる(ついでにウィンドウ消去)
    if $game_temp.battle_main_phase
      if self.contents_opacity > 224 && !KGC::BR_WINDOW_OPACITY_FIX
        self.contents_opacity -= 2
      end
      if self.opacity > 0 && KGC::BR_WINDOW_TRANSPARENT_MAIN_PHASE
        self.opacity -= 16
      end
      if self.back_opacity > 128 && KGC::BR_WINDOW_BACK_CLEAR_MAIN_PHASE
        self.back_opacity -= 8
      end
    else
      if self.contents_opacity < 255
        self.contents_opacity += 2
      end
      if self.opacity < 255 && KGC::BR_WINDOW_TRANSPARENT_MAIN_PHASE
        self.opacity += 16
      end
      if self.back_opacity < 255 && KGC::BR_WINDOW_BACK_CLEAR_MAIN_PHASE
        self.back_opacity += 8
      end
    end
  end
  elsif KGC::BR_WINDOW_OPACITY_FIX
  def update
    super
  end
  end
  if KGC::BR_SHADOW_TEXT_NAME_BATTLE
  #--------------------------------------------------------------------------
  # ● 名前の描画
  #--------------------------------------------------------------------------
  def draw_actor_name(actor, x, y)
    self.contents.font.color = normal_color
    self.contents.draw_shadow_text(x, y, 120, 32, actor.name)
  end
  end
  if KGC::BR_SHADOW_TEXT_STATE_BATTLE && !$imported["StateIcon"]
  #--------------------------------------------------------------------------
  # ● ステートの描画
  #--------------------------------------------------------------------------
  def draw_actor_state(actor, x, y, width = 120)
    text = make_battler_state_text(actor, width, true)
    self.contents.font.color = actor.dead? ? knockout_color : normal_color
    self.contents.font.color = crisis_color if actor.state?(15)
    self.contents.draw_shadow_text(x, y, width, 32, text)
  end
  end
end

#★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★

class Interpreter
#==============================================================================
# ■□■□■ Interpreter 3 ■□■□■
#==============================================================================
  #--------------------------------------------------------------------------
  # ● 条件分岐
  #--------------------------------------------------------------------------
  alias command_111_KGC_Base_Rainforce command_111
  def command_111
    result = false
    # 条件判定
    if @parameters[0] == 4
      actor = $game_actors[@parameters[1]]
      if actor != nil && @parameters[2] == 4
        result = (actor.armor1_id == @parameters[3] ||
                  actor.armor2_id == @parameters[3] ||
                  actor.armor3_id == @parameters[3] ||
                  actor.armor4_id == @parameters[3])
      end
      # 判定結果をハッシュに格納
      @branch[@list[@index].indent] = result
      # 判定結果が真だった場合
      if @branch[@list[@index].indent]
        # 分岐データを削除
        @branch.delete(@list[@index].indent)
        # 継続
        return true
      end
    end

    return command_111_KGC_Base_Rainforce
  end
#==============================================================================
# ■□■□■ Interpreter 7 ■□■□■
#==============================================================================
  #--------------------------------------------------------------------------
  # ● スクリプト
  #--------------------------------------------------------------------------
  def command_355
    # script に 1 行目を設定
    script = @list[@index].parameters[0] + "\n"
    # ループ
    loop {
      # 次のイベントコマンドがスクリプト 2 行目以降の場合
      if @list[@index+1].code == 655
        # script に 2 行目以降を追加
        script += @list[@index+1].parameters[0] + "\n"
      # イベントコマンドがスクリプト 2 行目以降ではない場合
      else
        # ループ中断
        break
      end
      # インデックスを進める
      @index += 1
    }
    # 評価
    result = eval(script)
    # 継続
    return true
  end
end

#★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★

class Scene_Battle
#==============================================================================
# ■□■□■ Scene_Battle 1 ■□■□■
#==============================================================================
  #--------------------------------------------------------------------------
  # ● メイン処理
  #--------------------------------------------------------------------------
  if KGC::BR_BATTLE_START_TRANSITION != nil
  def main
    # トランジション実行
    Graphics.transition(40,
      "Graphics/Transitions/" + KGC::BR_BATTLE_START_TRANSITION)
    # トランジション準備
    Graphics.freeze
    # 戦闘用の各種一時データを初期化
    $game_temp.in_battle = true
    $game_temp.battle_turn = 0
    $game_temp.battle_event_flags.clear
    $game_temp.battle_abort = false
    $game_temp.battle_main_phase = false
    $game_temp.battleback_name = $game_map.battleback_name
    $game_temp.forcing_battler = nil
    # バトルイベント用インタプリタを初期化
    $game_system.battle_interpreter.setup(nil, 0)
    # トループを準備
    @troop_id = $game_temp.battle_troop_id
    $game_troop.setup(@troop_id)
    # アクターコマンドウィンドウを作成
    
    
#    @actor_command_window = Window_Battle_Command.new
#    s1 = $data_system.words.attack
#    s2 = $data_system.words.skill
#    s3 = $data_system.words.guard
#    s4 = $data_system.words.item
#    @actor_command_window = Window_Command.new(160, [s1, s2, s3, s4])
#    @actor_command_window.y = 160
#    @actor_command_window.back_opacity = 160
#    @actor_command_window.active = false
#    @actor_command_window.visible = false
    # その他のウィンドウを作成
#    @party_command_window = Window_PartyCommand.new
    @help_window = Window_Help.new
    @help_window.back_opacity = 160
    @help_window.visible = false
    @status_window = Window_BattleStatus.new
    @message_window = Window_Message.new
    # ●ホールド
    @hold = Game_BattlerHold.new
    # ●バトル静止フラグ
    @pause = false
    @helphide = false
    @window_flag = false
    #ムード・ダメージに関するターン処理
    # ●連続して同じスキルを使っている回数
    $repeat_skill_num = 0
    $game_switches[9] = false
    # ●口上読み出しのフラグリセット
    $msg.callsign = 99
    $msg.talk_step = 0
    $msg.tag = ""
    $game_switches[77] = false #絶頂フラグスイッチ
    $game_switches[78] = false #追撃フラグスイッチ
    $game_switches[79] = false #トークフラグスイッチ
    $game_switches[82] = false #焦らしフラグスイッチ
    @hold_shake = nil #ホールド完了時のシェイク処理
    # ●弱点突き関連のリセット
    $weak_number = 0 #弱点突き発生段数
    $weak_result = 0 #弱点突きを行った実数
    $game_temp.error_message = ""
    #メッセージ表示速度を設定
    case $game_system.system_battle_speed
    when 0
      $game_switches[9] = false
      $game_variables[45] = 16
      $game_variables[46] = 4
      $game_variables[47] = 30
    when 1
      $game_switches[9] = true
      $game_variables[45] = 8
      $game_variables[46] = 2
      $game_variables[47] = 48
    when 2
      $game_switches[9] = true
      $game_variables[45] = 4
      $game_variables[46] = 1
      $game_variables[47] = 32
    when 3
      $game_switches[9] = true
      $game_variables[45] = 16
      $game_variables[46] = 1
      $game_variables[47] = 16
    else
      $game_switches[9] = false
      $game_variables[45] = 16
      $game_variables[46] = 1
      $game_variables[47] = 32
    end
    # 全バトラーのリセット
    for enemy in $game_troop.enemies
      enemy.state_runk = [0, 0, 0, 0, 0, 0]
      enemy.ecstasy_count = []
      enemy.crisis_flag = false
      enemy.hold_reset
      enemy.ecstasy_turn = 0
      enemy.sp_down_flag = false
      enemy.talk_weak_check = []
      # 全バトラーのステートログをすべてクリア
      enemy.add_states_log.clear
      enemy.remove_states_log.clear
      #ベッドイン時、空腹襲撃時は最初から弱点チェックをtrueにする
      if $game_switches[85] == true or $game_switches[86] == true
        enemy.checking = 1
      else
        enemy.checking = 0
      end
    end
    for actor in $game_party.party_actors
      actor.state_runk = [0, 0, 0, 0, 0, 0]
      actor.ecstasy_count = []
      actor.crisis_flag = false
      actor.skill_collect = nil
      actor.hold_reset
      actor.lub_male = 0
      actor.lub_female = 0
      actor.lub_anal = 0
      actor.ecstasy_turn = 0
      actor.sp_down_flag = false
      actor.talk_weak_check = []
      #開発度エラー対策
      actor.used_mouth = 0 if actor.used_mouth == nil
      actor.used_anal = 0 if actor.used_anal == nil
      actor.used_sadism = 0 if actor.used_sadism == nil
      # 全バトラーのステートログをすべてクリア
      actor.add_states_log.clear
      actor.remove_states_log.clear
      #ベッドイン時、空腹襲撃時は最初から弱点チェックをtrueにする
      if $game_switches[85] == true or $game_switches[86] == true
        actor.checking = 1
      else
        actor.checking = 0
      end
    end
    # ★全バトラー情報の記録
    battlers_record
    # ★■ムードを初期化
    $mood = Mood_System.new
    # ★インセンスを初期化
    $incense = Incense_System.new
    
    #バトルログを表示するウィンドウを作成 ★
    @battle_log_window = Window_BattleLog.new
    @battle_log_window.visible = false
    
    # ★バトル静止用スプライト作成
#    @stasis = Sprite.new
#    @stasis.bitmap = RPG::Cache.windowskin("battle_stasis")
#    @stasis.visible = false
#    @stasis.z = 10000

    # スプライトセットを作成
    @spriteset = Spriteset_Battle.new
    # ウェイトカウントを初期化
    @wait_count = 0
    # トランジション実行
    if $data_system.battle_transition == ""
      Graphics.transition(20)
    else
      Graphics.transition(40, "Graphics/Transitions/" +
        $data_system.battle_transition)
    end
    # プレバトルフェーズ開始
    start_phase1
    # メインループ
    loop {
      Graphics.update
      Input.update
      update
      break if $scene != self
    }
    # マップをリフレッシュ
    $game_map.refresh
    # トランジション準備
    Graphics.freeze
    # ウィンドウを解放
    @actor_command_window.dispose if @actor_command_window != nil
    @party_command_window.dispose
    @help_window.dispose
    @status_window.dispose
    @message_window.dispose
    @skill_window.dispose if @skill_window != nil
    @item_window.dispose if @item_window != nil
    @result_window.dispose if @result_window != nil
    @battle_log_window.dispose if @battle_log_window != nil # ★
    # スプライトセットを解放
    @spriteset.dispose
    # ★■ムードを開放
    $mood.dispose
    # タイトル画面に切り替え中の場合
    if $scene.is_a?(Scene_Title)
      # 画面をフェードアウト
      Graphics.transition
      Graphics.freeze
    end
    # 戦闘テストからゲームオーバー画面以外に切り替え中の場合
    if $BTEST && !$scene.is_a?(Scene_Gameover)
      $scene = nil
    end
  end
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新
  #--------------------------------------------------------------------------
  def update
    # ★F6キーで情報呼び出し
    if Input.trigger?(Input::F6) and $DEBUG
      
      message = ""
      message += "■場の状態\n"
      message += "ムード : #{$mood.point}\n"
        message += "メッセージ速度 : #{$game_system.system_battle_speed}\n"
        message += "メッセージモード : #{$game_system.system_read_mode}\n"
        message += "スキップモード : #{$game_system.ms_skip_mode}\n"
      print message 
      
      
      
      $game_party.party_actors.each_with_index { |actor, index|
        message  = "actor [#{index + 1} / #{$game_party.party_actors.size}]\n"
        message += "name : #{actor.name}\n"
        message += "EP : #{actor.hp} / #{actor.maxhp}\n"
        message += "VP : #{actor.sp} / #{actor.maxsp}\n"
        message += "class : #{actor.race_name} #{actor.race_color}\n"
        message += "states : [#{actor.states.join(',')}]\n"
        message += "personality : [#{actor.personality}]\n"
        message += "battler_name : \"#{actor.battler_name}\"\n"
        message += "潤滑度♂ : \"#{actor.lub_male}\"\n" if actor.have_ability?("男") or actor.have_ability?("両性具有")
        message += "潤滑度♀ : \"#{actor.lub_female}\"\n" if actor.have_ability?("女")
        message += "潤滑度Ａ : \"#{actor.lub_anal}\"\n" if $game_variables[40] > 0
        message += "能力変化度 : \"#{actor.state_runk}\"\n"
        if actor.rankup_flag == true and actor.rankup_flag != nil
          message += "ランクアップ経験 : あり\n" 
        end
        message += "絶頂回数 : \"#{actor.ecstasy_count.size}\"\n"
        message += "Hold/ペニス : \"#{actor.hold.penis.type}\"\n" if actor.hold.penis.battler != nil
        message += "Hold/アソコ : \"#{actor.hold.vagina.type}\"\n" if actor.hold.vagina.battler != nil
        message += "Hold/口 : \"#{actor.hold.mouth.type}\"\n" if actor.hold.mouth.battler != nil
        message += "Hold/アナル : \"#{actor.hold.anal.type}\"\n" if actor.hold.anal.battler != nil
        message += "Hold/上半身 : \"#{actor.hold.tops.type}\"\n" if actor.hold.tops.battler != nil
        message += "Hold/尻尾 : \"#{actor.hold.tail.type}\"\n" if actor.hold.tail.battler != nil
        message += "Hold/触手 : \"#{actor.hold.tentacle.type}\"\n" if actor.hold.tentacle.battler != nil
        message += "Hold/ディルド : \"#{actor.hold.dildo.type}\"\n" if actor.hold.dildo.battler != nil
        message += "Holdイニシアチブ : \"#{actor.initiative_level}\"\n"
       
        print message
      }
      $game_troop.enemies.each_with_index { |enemy, index|
        message  = "enemy [#{index + 1} / #{$game_troop.enemies.size}]\n"
        message += "name : #{enemy.name}\n"
        message += "Lv : #{enemy.level}\n"
        message += "EP : #{enemy.hp} / #{enemy.maxhp}\n"
        message += "VP : #{enemy.sp} / #{enemy.maxsp}\n"
        message += "魅力 : #{enemy.atk}\n"
        message += "忍耐力 : #{enemy.pdef}\n"
        message += "精力 : #{enemy.str}\n"
        message += "器用さ : #{enemy.dex}\n"
        message += "素早さ : #{enemy.agi}\n"
        message += "精神力 : #{enemy.int}\n"
        message += "取得経験値 : #{enemy.exp}\n"
        message += "取得金額 : #{enemy.gold}\n"
        message += "ドロップ : \n"
        for treasure in enemy.treasure
          case treasure[0]
          when 0
            message += "　#{$data_items[treasure[1]].name} #{treasure[2]}％\n"  
          when 1
            message += "　#{$data_weapons[treasure[1]].name} #{treasure[2]}％\n"  
          when 2
            message += "　#{$data_armors[treasure[1]].name} #{treasure[2]}％\n"  
          end
        end
        #{enemy.treasure}\n"
        message += "class : #{enemy.race_name} #{enemy.race_color}\n"
        message += "states : [#{enemy.states.join(',')}]\n"
        message += "personality : [#{enemy.personality}]\n"
        message += "battler_name : \"#{enemy.battler_name}\"\n"
        message += "友好度 : \"#{enemy.love}\"\n"
        message += "好感度 : \"#{enemy.friendly}\"\n"
        message += "潤滑度♂ : \"#{enemy.lub_male}\"\n" if enemy.have_ability?("両性具有")
        message += "潤滑度♀ : \"#{enemy.lub_female}\"\n" if enemy.have_ability?("女")
        message += "潤滑度Ａ : \"#{enemy.lub_anal}\"\n" if $game_variables[40] > 0
        message += "能力変化度 : \"#{enemy.state_runk}\"\n"
        if enemy.rankup_flag == true and enemy.rankup_flag != nil
          message += "ランクアップ経験 : あり\n" 
        end
        message += "絶頂回数 : \"#{enemy.ecstasy_count.size}\"\n"
        message += "Hold/ペニス : \"#{enemy.hold.penis.type}\"\n" if enemy.hold.penis.battler != nil
        message += "Hold/アソコ : \"#{enemy.hold.vagina.type}\"\n" if enemy.hold.vagina.battler != nil
        message += "Hold/口 : \"#{enemy.hold.mouth.type}\"\n" if enemy.hold.mouth.battler != nil
        message += "Hold/アナル : \"#{enemy.hold.anal.type}\"\n" if enemy.hold.anal.battler != nil
        message += "Hold/上半身 : \"#{enemy.hold.tops.type}\"\n" if enemy.hold.tops.battler != nil
        message += "Hold/尻尾 : \"#{enemy.hold.tail.type}\"\n" if enemy.hold.tail.battler != nil
        message += "Hold/触手 : \"#{enemy.hold.tentacle.type}\"\n" if enemy.hold.tentacle.battler != nil
        message += "Hold/ディルド : \"#{enemy.hold.dildo.type}\"\n" if enemy.hold.dildo.battler != nil
        message += "【退場中】\"\n" unless enemy.exist?
        message += "自称：\"#{enemy.nickname_self}\"\n"
        message += "他称：\"#{enemy.nickname_master}\"\n"
        print message
      }
    end
    # ポーズに関する更新
    pause_update
    # ポーズに返したすぐはInput情報をそのまま引き継がせないため、一度返す
    if @pause_return_flag
      @pause_return_flag = false
      return
    end
    # ポーズ中はここで返す
    if @pause
      return
    end
    
    # ★Ｄキーで文章を自動送り(封印)
#    if Input.trigger?(Input::Z)
#      if $game_switches[9]
#        case $game_variables[50]
#        when 1
#          $game_variables[50] += 1
#          Audio.se_play("Audio/SE/046-Book01", 90, 110)
#        when 2
#          $game_variables[50] += 1
#          Audio.se_play("Audio/SE/046-Book01", 90, 120)
#        when 3
#          $game_variables[50] += 1
#          Audio.se_play("Audio/SE/046-Book01", 90, 130)
#        when 4
#          $game_variables[50] = 0
#          $game_switches[9] = false
#        Audio.se_play("Audio/SE/046-Book01", 90, 100)
#        make_message_speed
#        @ms_speed.visible = true
#        end
#      else
#        $game_switches[9] = true
#        $game_variables[50] += 1
#        Audio.se_play("Audio/SE/046-Book01", 90, 100)
#        make_message_speed
#        @ms_speed.visible = false
#      end
#    end
    #●Ｑキー(Ｌボタン)でメッセージモード変更
    if Input.trigger?(Input::L) and (@window_flag == true or @phase == 4)
      if $game_system.system_read_mode >= 2
        $game_system.system_read_mode = 0
      else
        $game_system.system_read_mode += 1
      end
      if @msg_mode != nil
        if @msg_mode.bitmap != nil
          @msg_mode.bitmap.dispose
        end
      end
      @msg_mode = Sprite.new
      @msg_mode.opacity = 255
      #▼モードごとに画像表示とスイッチング
      case $game_system.system_read_mode
      #手動モード
      when 0
        @msg_mode.bitmap = RPG::Cache.picture("ms_mode_0")
        $game_switches[9] = false
      #半自動モード(標準)
      when 1
        @msg_mode.bitmap = RPG::Cache.picture("ms_mode_1")
        $game_switches[9] = false
      #自動モード
      when 2
        @msg_mode.bitmap = RPG::Cache.picture("ms_mode_2")
        $game_switches[9] = true
      end
      Audio.se_play("Audio/SE/AC_Book2", 90, 100)
    end
    if @msg_mode != nil
      @msg_mode.opacity -= 3 if @msg_mode.opacity > 0
      @msg_mode.opacity -= 4 if @msg_mode.opacity < 200 and @msg_mode.opacity > 0
    end
    #45がオートメッセージID、46がメッセージウェイト、47がバトルウェイトになる
    if Input.trigger?(Input::R) and (@window_flag == true or @phase == 4)
      if $game_system.system_battle_speed >= 2
        $game_system.system_battle_speed = 0
      else
        $game_system.system_battle_speed += 1
      end
      if @msg_speed != nil
        if @msg_speed.bitmap != nil
          @msg_speed.bitmap.dispose
        end
      end
      @msg_speed = Sprite.new
      @msg_speed.opacity = 255
      #変数45：システムウェイト(フェイズの合間のウェイト)
      #変数46：メッセージウェイト(\mや\wの基準値)
      #変数47：オートモード速度(テロップ時のみ有効)
      case $game_system.system_battle_speed
      when 0
#        $game_variables[45] = 60
#        $game_variables[46] = 5
#        $game_variables[47] = 60
        @msg_speed.bitmap = RPG::Cache.picture("ms_speed_0")
      when 1
#        $game_variables[45] = 30
#        $game_variables[46] = 3
#        $game_variables[47] = 40
        @msg_speed.bitmap = RPG::Cache.picture("ms_speed_1")
      when 2
#        $game_variables[45] = 16
#        $game_variables[46] = 1
#        $game_variables[47] = 28
        @msg_speed.bitmap = RPG::Cache.picture("ms_speed_2")
      end
      Audio.se_play("Audio/SE/AC_Book2", 90, 100)
    end
    if @msg_speed != nil
      @msg_speed.opacity -= 3 if @msg_speed.opacity > 0
      @msg_speed.opacity -= 4 if @msg_speed.opacity < 200 and @msg_speed.opacity > 0
    end
    
    # バトルイベント実行中の場合
    if $game_system.battle_interpreter.running?
      @running = true
      # インタプリタを更新
      $game_system.battle_interpreter.update
      # アクションを強制されているバトラーが存在しない場合
      if $game_temp.forcing_battler == nil
        # バトルイベントの実行が終わった場合
        unless $game_system.battle_interpreter.running?
          if @phase != 6
            # 戦闘継続の場合、バトルイベントのセットアップを再実行
            unless judge
              setup_battle_event
            end
          end
        end
        # アフターバトルフェーズでなく、メッセージが表示されていない
        # かつアニメ表示中ではない場合
        if @phase != 5 && !@message_window.visible && !@spriteset.effect?
          # ステータスウィンドウをリフレッシュ
          @status_window.refresh
        end
      end
    elsif @running
      # ステータスウィンドウをリフレッシュ
      @status_window.refresh
      @running = false
    end
    
    # システム (タイマー)、画面を更新
    $game_system.update
    $game_screen.update
    # タイマーが 0 になった場合
    if $game_system.timer_working && $game_system.timer == 0
      # バトル中断
      $game_temp.battle_abort = true
    end
    # ウィンドウを更新
    @battle_log_window.update #★
    @help_window.update
#    @party_command_window.update

    if @actor_command_window != nil and @phase == 3
      @actor_command_window.update 
    end

    @status_window.update
    @message_window.update

    if @phase != 6
      # スプライトセットを更新
      @spriteset.update
    end
    
    # ★全バトラー情報の記録
    battlers_record
    
    #--レジストゲームが呼び出された場合★---------------------------
    if $game_temp.resistgame_flag == 1
      if @active_battler.is_a?(Game_Enemy)
        type = 0
      else
        if $game_switches[79]
          type = 0
        else
          type = 1
        end
      end
      #呼ばれる度にnewで初期化する(同じ画面で複数回実行する事があるので)
      if $game_switches[79] == true
        if $game_temp.talk_resist_flag_log[/\\T/] != nil
          @resistgame = Resist_Game.new($game_temp.resistgame_difficulty, type, $game_system.system_regist)
          $game_temp.resistgame_swicth = true
          $game_temp.resistgame_flag = 2
        end
      else
        @resistgame = Resist_Game.new($game_temp.resistgame_difficulty, type, $game_system.system_regist)
        $game_temp.resistgame_swicth = true
        $game_temp.resistgame_flag = 2
      end
      $game_system.menu_disabled = true
    elsif $game_temp.resistgame_flag >= 2
      if $game_temp.talk_resist_flag_log != ""
        if $game_temp.talk_resist_flag_log[/\\T/] != nil
          if $msg.resist_flag == true
            #ゲームを呼ぶ(戻り値･･･成功:true 失敗:false)
            @resistgame.game_start
            return
          end
        else
          #ゲームを呼ぶ(戻り値･･･成功:true 失敗:false)
          @resistgame.game_start
          return
        end
      else
        #ゲームを呼ぶ(戻り値･･･成功:true 失敗:false)
        @resistgame.game_start
        return
      end
      
    elsif $game_temp.resistgame_flag < 0 #終わる時、flagには「-1」を入れる
      
      #ゲームを開放して終わる
      @resistgame.dispose
      $game_temp.resistgame_swicth = false
      $game_temp.resistgame_flag = 0
      $game_system.menu_disabled = false
      $msg.resist_flag = false
      #
#      @wait_count = 20
      @battle_log_window.contents.clear

      
      # バトルログをクリア
      @battle_log_window.contents.clear
      @battle_log_window.keep_flag = false
      $game_temp.battle_log_text = ""
    end
    #-----------------------------------------------------------------------
    # ●コモンイベント等からバトルログウィンドウを消す場合の処理
    #   主にトーク処理用
    if $msg.battlelogwindow_dispose == true
      # バトルログをクリア
      @battle_log_window.contents.clear
      @battle_log_window.keep_flag = false
      $game_temp.battle_log_text = ""
      #フラグを降ろす
      $msg.battlelogwindow_dispose = false
    end
    #-----------------------------------------------------------------------
    # ●コモンイベント等からステータスウィンドウを更新する場合の処理
    #   主にトーク処理用
    if $msg.stateswindow_refresh == true
      #ステータスウィンドウを更新
      @status_window.refresh
      #フラグを降ろす
      $msg.stateswindow_refresh = false
    end
    #-----------------------------------------------------------------------
    # ●コモンイベント等からホールド状況をスキル以外で更新する場合の処理
    #   主にトーク処理用
    if $msg.hold_initiative_refresh.size >= 2
      # ホールドイニシアチブの更新指示
      #hold_initiative(@skill, $msg.hold_initiative_refresh[0], $msg.hold_initiative_refresh[1])
      hold_initiative_down($msg.hold_initiative_refresh[1])
      # ホールドポップ
      hold_pops_order
      #フラグを降ろす
      #$game_temp.skill_selection
      $msg.hold_initiative_refresh = []
    end
    #-----------------------------------------------------------------------
    # ●コモンイベント等からホールドイニシアチブを更新する場合の処理
    #   主にトーク処理用
    if $msg.hold_pops_refresh == true
      # ホールドポップの指示
      hold_pops_order
      #フラグを降ろす
      $msg.hold_pops_refresh = false
    end
    #-----------------------------------------------------------------------
    # ●コモンイベント等からスキルウィンドウ名称を更新する場合の処理
    #   主にトーク処理用
    if $msg.skillwindow_change != nil
      #スキル名表示のヘルプウィンドウが出ている時のみ適用
      if @help_window.window.visible == true
        #名称がcloseの場合、ヘルプウィンドウを消去する
        if $msg.skillwindow_change == "close"
          @help_window.window.visible = false
          @help_window.set_text("")
        else
          # ヘルプウィンドウに変更後の名称を表示
          @help_window.set_text($msg.skillwindow_change, 1)
        end
      end
      #フラグを降ろす
      $msg.skillwindow_change = nil
    end
    #-----------------------------------------------------------------------

    # トランジション処理中の場合
    if $game_temp.transition_processing
      # トランジション処理中フラグをクリア
      $game_temp.transition_processing = false
      # トランジション実行
      if $game_temp.transition_name == ""
        Graphics.transition(20)
      else
        Graphics.transition(40, "Graphics/Transitions/" +
          $game_temp.transition_name)
      end
    end
    # ★■ムードを更新
    $mood.update
    # メッセージウィンドウ表示中の場合
    if $game_temp.message_window_showing
      return
    end
    
    # エフェクト表示中の場合
    if @spriteset.effect?
      return
    end
    # ゲームオーバーの場合
    if $game_temp.gameover
      # ゲームオーバー画面に切り替え
      $scene = Scene_Gameover.new
      return
    end
    # タイトル画面に戻す場合
    if $game_temp.to_title
      # タイトル画面に切り替え
      $scene = Scene_Title.new
      return
    end
    # バトル中断の場合
    if $game_temp.battle_abort
      # バトル開始前の BGM に戻す
      $game_system.bgm_play($game_temp.map_bgm)
      # バトル終了
      battle_end(1)
      return
    end
    
    # ★バトルログがウェイトしている場合、連動してウェイトする。
    if @battle_log_window.wait_count > 0 and $game_temp.battle_log_wait_flag == true
      @wait_count += @battle_log_window.wait_count
      $game_temp.battle_log_wait_flag = false
    end
    # ウェイト中の場合
    if @wait_count > 0
      # ウェイトカウントを減らす
      @wait_count -= 1
      return
    end
    
    # エネミーの表示をウェイト後に予約している場合、表示させる
    if @display_order_enemy != nil
      enemies_display(@display_order_enemy)
      @display_order_enemy = nil
    end
    
    
    # アクションを強制されているバトラーが存在せず、
    # かつバトルイベントが実行中の場合
    if $game_temp.forcing_battler == nil &&
       $game_system.battle_interpreter.running?
      return
    end
    
    # 特殊フェイズがある場合はそちらを優先
    if @go_appear_effect_step
      appear_effect_step
      return
    end
    if @go_dead_effect_step
      dead_effect_step
      return
    end
    # フェーズによって分岐
    case @phase
    when 0  # スタートフェーズ
      update_phase0
    when 1  # プレバトルフェーズ
      update_phase1
    when 2  # パーティコマンドフェーズ
      update_phase2
    when 3  # アクターコマンドフェーズ
      update_phase3
    when 4  # メインフェーズ
      update_phase4
    when 5  # アフターバトルフェーズ
      update_phase5
    when 6  # 契約フェーズ
      update_phase6
    end
  end
  #--------------------------------------------------------------------------
  # ● バトル終了
  #     result : 結果 (0:勝利 1:逃走 2:敗北)
  #--------------------------------------------------------------------------
  alias battle_end_KGC_Base battle_end
  def battle_end(result)
    #★インセンスを解除
    $incense = nil
    # オートステートを更新
    for actor in $game_party.actors
      for i in 1...($imported["EquipExtension"] ? actor.equip_type.size : 5)
        actor.update_auto_state(nil, $data_armors[
          $imported["EquipExtension"] ? actor.armor_id[i] :
          eval("actor.armor#{i}_id")])
      end
    end

    battle_end_KGC_Base(result)
  end
end