#==============================================================================
# ■ Talk_Sys
#------------------------------------------------------------------------------
#   夢魔の口上を検索、表示するためのクラスです。
#   このクラスのインスタンスは $msg で参照されます。
# 
#==============================================================================
class Talk_Sys
  #--------------------------------------------------------------------------
  # ● 公開インスタンス変数
  #--------------------------------------------------------------------------
  attr_accessor :callsign                 # 口上呼び出しキー
  attr_accessor :talk_step                # 口上ステップ
  attr_accessor :tag                      # 会話タグ(シチュエーション指定用)
  attr_accessor :t_enemy                  # 現在喋っている夢魔
  attr_accessor :t_target                 # 喋る対象になるアクター
  attr_accessor :t_partner                # 対象以外のアクター
  attr_accessor :age                      # 喋る対象との年齢差(夢魔－相手)
  attr_accessor :age2                     # 喋る対象の相方との年齢差(夢魔－相手)
  attr_accessor :age3                     # 連携する相手との年齢差(夢魔－相手)
  attr_accessor :text1                    # 夢魔口上1
  attr_accessor :text2                    # 夢魔口上2
  attr_accessor :text3                    # 夢魔口上3
  attr_accessor :text4                    # 夢魔口上4
  attr_accessor :coop_enemy               # 連携攻撃参加エネミー
  attr_accessor :coop_leader              # 連携を開始した夢魔
  attr_accessor :at_type                  # 攻撃タイプ(追撃スキル選定用)
  attr_accessor :at_parts                 # 攻撃部位(追撃スキル選定用)
  attr_accessor :favorably                # 好感度の会話影響度
  attr_accessor :resist_flag              # レジストゲーム発生フラグ
  attr_accessor :moody_flag               # ムード変動フラグ
  attr_accessor :battlelogwindow_dispose  # バトルログウィンドウの消去
  attr_accessor :stateswindow_refresh     # ステータスウィンドウの更新
  attr_accessor :skillwindow_change       # スキルウィンドウの名称変更
  attr_accessor :talk_command_type        # トーク種類
  attr_accessor :talking_ecstasy_flag     # トーク中絶頂フラグ
  attr_accessor :hold_pops_refresh        # トーク中ホールド状況変更フラグ
  attr_accessor :hold_initiative_refresh  # トーク中ホールド優位更新フラグ
  attr_accessor :befor_talk_action        # トーク中の直前行動管理
  attr_accessor :weakpoints               # トーク中弱点突きフラグ
  attr_accessor :chain_attack             # トーク中同一部位連撃フラグ
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  def initialize
    @callsign = 99
    @talk_step = 0 #基本は0、追撃や絶頂など状況が変わる場合に変動する
    @tag = ""
    @t_enemy = nil
    @t_target = nil
    @t_partner = nil
    @coop_leader = nil
    @age = 0
    @age2 = 0
    @age3 = 0
    @text1 = ""
    @text2 = ""
    @text3 = ""
    @text4 = ""
    @coop_enemy = []
    @msg = Array.new(300)
    # 暫定処理（コモン）
    for i in 0...@msg.size
      @msg[i] = Db_Lessersuccubus_A.new
    end
    @msg[5] = Db_Lessersuccubus_A.new
    @msg[6] = Db_Lessersuccubus_B.new
    @msg[10] = Db_Succubus_A.new
    @msg[11] = Db_Succubus_B.new
    @msg[21] = Db_Imp_A.new
    @msg[26] = Db_Devil_A.new
    @msg[37] = Db_Petitwitch_A.new
    @msg[38] = Db_Petitwitch_B.new
    @msg[42] = Db_Witch_A.new
    @msg[43] = Db_Witch_B.new
    @msg[53] = Db_Cast_A.new
    @msg[74] = Db_Nightmare_A.new
    @msg[80] = Db_Slime_A.new
    @msg[96] = Db_Familiar_A.new
    @msg[100] = Db_Werewolf_A.new
    @msg[253] = Db_Fulbeua.new
    #製品版追加ぶん

    
    @msg[15] = Db_Succubuslord_A.new
    @msg[16] = Db_Succubuslord_B.new
    @msg[22] = Db_Imp_B.new
    @msg[27] = Db_Devil_B.new
    @msg[31] = Db_Daemon_A.new
    @msg[32] = Db_Daemon_B.new
    @msg[54] = Db_Cast_B.new
    @msg[63] = Db_Slave_A.new
    @msg[75] = Db_Nightmare_B.new
    @msg[90] = Db_Goldslime_A.new
    @msg[97] = Db_Familiar_B.new
    @msg[101] = Db_Werewolf_B.new
    @msg[104] = Db_Werecat_A.new
    @msg[105] = Db_Werecat_B.new
    @msg[108] = Db_Goblin_A.new
    @msg[111] = Db_Gangcommander_A.new
    @msg[118] = Db_Priestess_A.new
    @msg[122] = Db_Cursemagus_A.new
    @msg[126] = Db_Alraune_A.new
    @msg[127] = Db_Alraune_B.new
    @msg[133] = Db_Matango_A.new
    @msg[137] = Db_Darkangel_A.new
    @msg[141] = Db_Gargoyle_A.new
    @msg[145] = Db_Mimic_A.new
    @msg[146] = Db_Mimic_B.new
    @msg[152] = Db_Tamamo_A.new
    @msg[156] = Db_Lilim_A.new
    
    @msg[251] = Db_Neijurange.new
    @msg[252] = Db_Rejeo.new
    @msg[254] = Db_Gilgoon.new
    @msg[255] = Db_Youganot.new
    @msg[256] = Db_Shilphe.new
    @msg[257] = Db_Rarmil.new
    @msg[258] = Db_Vermiena.new
    
    #製品版ここまで
    @at_type  = ""
    @at_parts = ""
    @favorably = 0
    @resist_flag = false
    @moody_flag = false
    @keep_flag = false
    @battlelogwindow_dispose = false
    @stateswindow_refresh = false
    @talk_command_type = ""
    @skillwindow_change = nil
    @talking_ecstasy_flag = nil
    @hold_pops_refresh = nil
    @hold_initiative_refresh = []
    @befor_talk_action = []
    @weakpoints = 0
    @chain_attack = false
  end
  #--------------------------------------------------------------------------
  # ● ２つの名前の文字数合計値で改行が必要かを返す
  #--------------------------------------------------------------------------
  def two_names_line_break(two_names_size)
    text = ""
    text = "\n" if two_names_size / 3 > 12
    return text
  end
  #--------------------------------------------------------------------------
  # ● 名前短縮
  #--------------------------------------------------------------------------
  def short_name(battler)
    #主人公(デフォルト名)、ユニークキャラクターは愛称を返す
    case battler.name
    when "ロウラット","ローレンス"
      return "ロウ"
    when "ネイジュレンジ"
      return "ネイジー"
    when "リジェオ"
      return "リズ"
    when "フルビュア"
      return "ルビィ"
    when "ユーガノット"
      return "ユーノ"
    when "ギルゴーン"
      return "ギル"
    when "シルフェ"
      return "シルフェ"
    when "ラーミル"
      return "ラーミル"
    when "ヴェルミィーナ"
      return "ミィーナ"
    end
    call_name = ""
    s_name = battler.name.split("")
    count = 0
    #２文字目が「ミ」で、全体が４文字を越える場合愛称化する（「○ミィ」）
    if s_name[1] == "ミ" and s_name.size > 4
      call_name = s_name[0] + "ミィ"
      return call_name
    end
    #元の名前が４文字以内ならそのまま返す
    return battler.name if s_name.size < 5 
    for i in 0..s_name.size - 1
      if count >= 3
        if ("ァィゥェォャュョーぁぃぅぇぉゃゅょ".include?(s_name[i]) == false)
          return call_name
        elsif ("ァィゥェォャュョーぁぃぅぇぉゃゅょ".include?(s_name[i]) == true)
          call_name += s_name[i]
          return call_name
        end
      else
        call_name += s_name[i]
        if ("ァィゥェォャュョぁぃぅぇぉゃゅょ".include?(s_name[i]) == false)
          count += 1
          if count >= 3 and ("ッっ".include?(s_name[i]) == true)
            count -= 1
          end
        end
      end
    end
    return call_name
  end
  #--------------------------------------------------------------------------
  # ● マップ口上切り替え
  #--------------------------------------------------------------------------
  def mapchat_manage
    #マップイベントは41、チャットは42
    if ($game_switches[85] == true or
      $game_switches[86] == true or
      $game_switches[87] == true or
      $game_switches[88] == true or
      @tag == "ランクアップ")
      @callsign = 41
    #その他
    else
      @callsign = 42
    end    
  end
  #--------------------------------------------------------------------------
  # ● 年齢差・種族判定取得
  #--------------------------------------------------------------------------
  def age_check
    #話し手、受け手が同じでないことが最前提
    if @t_enemy != @t_target
      #話す夢魔と、受け手の年齢差を取得する
#      p "@t_enemy：#{@t_enemy.name}／@t_target：#{@t_target.name}"
      e_years = $data_SDB[@t_enemy.class_id].years_type
      t_years = $data_SDB[@t_target.class_id].years_type
      @age = (e_years - t_years)
    #それ以外の場合はAgeを0のフラット状態に戻す
    else
      @age = 0
    end
    #会話の主が主人公の場合、ここで戻す
    return if @t_enemy == $game_actors[101]
    #健在なパートナーが場にいる場合
    n = 0
    for i in $game_party.actors
      if i.exist?
        n += 1
      end
    end
    if n == 2 and @t_partner != nil
      e_years = $data_SDB[@t_enemy.class_id].years_type
      t_years = $data_SDB[@t_partner.class_id].years_type
      @age2 = (e_years - t_years)
    #パートナーがいない場合、あるいは倒れている場合は関連項目をリセットする
    else
      @age2 = 0
    end
    #連携が発生している場合
    if @coop_leader != nil
      #会話対象とリーダーが別の場合、年齢差を取得する
      if @coop_leader != @t_enemy
        e_years = $data_SDB[@t_enemy.class_id].years_type
        t_years = $data_SDB[@coop_leader.class_id].years_type
        @age3 = (e_years - t_years)
      end
    else
      @age3 = 0
    end
  end
  #--------------------------------------------------------------------------
  # ● 口上呼び出しキャラクター選定
  #--------------------------------------------------------------------------
  def prepare
    #●選定済みステップが設定されている場合は飛ばす
    #==============================================================================#
    #  主に戦闘中の逃走(行動対象が明確でない)やマップ上の精の献上で適用される
    if (@talk_step == 100 or
      @tag == "戦闘開始" or
      @tag == "契約" or
      @tag == "空腹" or
      @tag == "精の献上" or
      @tag == "ランクアップ" or
      (@coop_enemy != [] and @coop_enemy.size > 1)
      )
      #●t_target、t_enemyが設定されてない場合は再設定する
      #  t_enemyに関するバグは、動作を通すと逆に困るのでスルー
      if @t_target == nil
        if $game_temp.in_battle
          #●基本設定読み込み
          active = $game_temp.battle_active_battler
          target = $game_temp.battle_target_battler[0]
          if active != nil and target != nil
            if active.is_a?(Game_Actor)
              @t_target = active
            elsif active.is_a?(Game_Enemy)
              @t_target = target
            end
          #行動対象が明確でない場合は、ターゲットを主人公に
          else
            @t_target = $game_actors[101]
          end
        #マップ上はターゲットを主人公に
        else
          @t_target = $game_actors[101]
        end
      end
      #●会話するエネミーの好感度レベルを算定してから戻す
      speak_favorably
      return
    end
    #==============================================================================#
    #●戦闘中のターゲット認識処理
    if $game_temp.in_battle
      #●基本設定読み込み
      active = $game_temp.battle_active_battler
      target = $game_temp.battle_target_battler[0]
      #契約フェイズの場合、トーク中の場合、必ず主人公を話の軸にする
      if @tag == "契約" or $game_switches[79] == true
        if active.is_a?(Game_Actor)
          @t_enemy = target
          @t_target = $game_actors[101]
        elsif active.is_a?(Game_Enemy)
          @t_enemy = active
          @t_target = $game_actors[101]
        end
      # 逃走失敗の場合、主人公を話の軸にし、会話できるエネミーからランダムで選択
      elsif @tag == "逃走失敗"
        talk = []
        for enemy in $game_troop.enemies
          if enemy.talkable?
            talk.push(enemy)
          end
        end
        @t_enemy = talk[rand(talk.size)]
        @t_target = $game_actors[101]
      else
        #パーティで健在なのが主人公のみ(あるいは最初から一人旅)の場合、主人公を話の軸にする
        ct = 0
        if $game_party.party_actors.size == 1
          ct = 0
        #パーティが存在する場合
        else
          #絶頂イベント中は必ず最後までカウントを存続させる(@0831)
          if $game_switches[77] == true
            ct = 1
          #絶頂イベントで無い場合は、場に立っているキャラをカウント
          else
            for i in $game_party.party_actors
              if i.exist? and i != $game_actors[101]
                ct += 1
              end
            end
          end
        end
        #主人公以外にパートナーが健在なら通常処理
        if ct > 0
          if active.is_a?(Game_Actor)
            @t_enemy = target
            @t_target = active
          elsif active.is_a?(Game_Enemy)
            @t_enemy = active
            @t_target = target
          end
        else
          if active.is_a?(Game_Actor)
            @t_enemy = target
            @t_target = $game_actors[101]
          elsif active.is_a?(Game_Enemy)
            @t_enemy = active
            @t_target = $game_actors[101]
          end
        end
      end
      #パートナーを一度nilに戻す
      @t_partner = nil
      if $game_party.actors.size == 2
        for i in $game_party.actors
          if i.exist? and not i == @t_target
            @t_partner = i
          end
        end
      end
#      p "@t_enemy：#{@t_enemy.name}／@t_target：#{@t_target.name}"if $DEBUG
      #●自分自身を対象に取るスキルの場合、会話する相手をランダムで取得
      if @t_enemy == @t_target
        #▼行動側がアクターの場合、健在な夢魔を取得
        if @t_enemy.is_a?(Game_Actor)
          #現段階で会話可能な夢魔をランダムに取得
          talk = []
          for i in $game_troop.enemies
            if i.talkable? or i.berserk == true
              talk.push(i)
            end
          end
          #会話可能な夢魔が居なかった場合、無言を呼び出して返す
          #パートナー夢魔の返しはいずれ考えるかも
          if talk == []
            @talk_step = 99 #会話非成立ステップ
            @text1 = @text2 = @text3 = @text4 = ""
            return @text1 = "「……………」"
          end
          #会話可能な夢魔をトークエネミーに設定
          @t_enemy = talk[rand(talk.size)]
        #▼行動側がエネミーの場合、健在なアクターを取得
        elsif @t_target.is_a?(Game_Enemy)
          #主人公一人旅の場合、必ず主人公を設定
          if $game_party.party_actors.size == 1
            @t_target = $game_actors[101]
          #パートナーが存在する場合、健在なアクターからランダムで選定
          else
            talk = []
            for i in $game_party.actors
              talk.push(i) if i.exist?
            end
            @t_target = talk[rand(talk.size)]
          end
        end
      end
    #==============================================================================#
    #●マップ中のターゲット認識処理
    else
      #マップ中に口上をコールされた場合、マップ上専用コールサインを呼ぶ
      mapchat_manage
      #●パートナー夢魔が１人以上パーティに居ればランダムで設定
      #  ロウ君は必ず聞き手になる
      if $game_party.party_actors.size != 1
        @talk_step = 0 #会話非成立ステップを戻す
        @t_target = $game_actors[101]
        @t_enemy = ""
        loop do
          n = rand($game_party.party_actors.size)
          if $game_party.party_actors[n] != $game_actors[101]
            @t_enemy = $game_party.party_actors[n]
            break
          end
        end
      #パーティが１人の場合、ロウ君の無言を設定して終了
      else
        @talk_step = 99 #会話非成立ステップ
        @t_enemy = @t_target = $game_actors[101]
        @text1 = @text2 = @text3 = @text4 = ""
        return @text1 = "「……………」"
      end
    end
    #●会話エネミーが確定したら好感度レベルを算出して戻す
    speak_favorably
  end
  #--------------------------------------------------------------------------
  # ● 絶頂時参加キャラカウント(ついでにコールサインも設定)
  #--------------------------------------------------------------------------
  def ecstasy_member_check
    #アクターの攻撃でエネミーが絶頂した場合
    if $game_temp.battle_active_battler.is_a?(Game_Actor)
      @t_enemy = $game_temp.battle_target_battler[0]
      @t_target = $game_temp.battle_active_battler
      #コールサイン設定(自分が絶頂のみ)
      if @t_target == $game_actors[101]
        @callsign = 2
        @callsign = 12 if $game_switches[85]
      else
        @callsign = 22
        @callsign = 32 if $game_switches[85]
      end
    #エネミーの攻撃でアクターが絶頂した場合
    elsif $game_temp.battle_active_battler.is_a?(Game_Enemy)
      @t_enemy = $game_temp.battle_active_battler
      @t_target = $game_temp.battle_target_battler[0]
      #パートナーを一度nilに戻す
      @t_partner = nil
      if $game_party.actors.size == 2
        for i in $game_party.actors
          if i.exist? and not i == @t_target
            @t_partner = i
          end
        end
      end
      #対象と乱交状態、あるいは対象がホールドで自分は非ホールドの場合
      #別のホールド状態の対象から突込みが入る
      #どちらかを満たしている段階でエネミーは２体以上なので、
      #１体か否かのチェックは入れない
      if @t_target.dancing? or not @t_enemy.holding_now?
        count = []
        count.push(@t_target.hold.penis.battler) if @t_target.hold.penis.battler != nil
        count.push(@t_target.hold.mouth.battler) if @t_target.hold.mouth.battler != nil
        count.push(@t_target.hold.anal.battler) if @t_target.hold.anal.battler != nil
        count.push(@t_target.hold.tops.battler) if @t_target.hold.tops.battler != nil
        count.push(@t_target.hold.vagina.battler) if @t_target.hold.vagina.battler != nil
        count.push(@t_target.hold.tail.battler) if @t_target.hold.tail.battler != nil
        count.push(@t_target.hold.dildo.battler) if @t_target.hold.dildo.battler != nil
        count.push(@t_target.hold.tentacle.battler) if @t_target.hold.tentacle.battler != nil
        count.delete(@t_enemy) if count.include?(@t_enemy)
        #連携夢魔が１体以上なら、配列をシャッフルして登録する
        if count.size > 0
          #開始時のエネミーをリーダーとして登録する
          @coop_leader = @t_enemy
          count.shuffle!
          @coop_enemy.push(@t_enemy)
          for i in 0..count.size - 1
            @coop_enemy.push(count[i])
          end
        else
          @coop_leader = nil
          @coop_enemy = []
        end
      else
        @coop_leader = nil
        @coop_enemy = []
      end
      #コールサイン設定(ホールドか否かもチェック)
      if @t_target == $game_actors[101]
        if @t_enemy.holding_now?
          @callsign = 0
          @callsign = 10 if $game_switches[85]
        else
          @callsign = 1
          @callsign = 11 if $game_switches[85]
        end
      else
        if @t_enemy.holding_now?
          @callsign = 20
          @callsign = 30 if $game_switches[85]
        else
          @callsign = 21
          @callsign = 31 if $game_switches[85]
        end
      end
    end
  end
  #--------------------------------------------------------------------------
  # ● 絶頂時反応
  #    ▽喜：歓迎する反応・良い反応(普通の反応も含む)
  #    ▽怒：嫌がる反応・悪い反応
  #--------------------------------------------------------------------------
  def ecstasy_emotion
    emotion = []
    #性格でベース感情を設定
    case @t_enemy.personality
    when "陽気"
      emotion.push("喜","喜","喜","怒")
    when "意地悪"
      emotion.push("喜","怒","怒","怒")
    when "好色"
      emotion.push("喜","喜","喜","怒")
    when "天然"
      emotion.push("喜","喜","喜","怒")
    when "内気"
      emotion.push("喜","喜","怒","怒")
    when "不思議"
      emotion.push("喜","喜","喜","怒")
    when "勝ち気"
      emotion.push("喜","喜","怒","怒")
    when "高慢"
      emotion.push("喜","怒","怒","怒")
    when "上品"
      emotion.push("喜","怒","怒","怒")
    when "甘え性"
      emotion.push("喜","喜","喜","怒")
    when "従順"
      emotion.push("喜","喜","喜","怒")
    when "淡泊"
      emotion.push("喜","喜","喜","怒")
    when "柔和"
      emotion.push("喜","喜","喜","怒")
    when "虚勢"
      emotion.push("喜","怒","怒","怒")
    when "倒錯"
      emotion.push("喜","喜","怒","怒")
    else
      emotion.push("喜","喜","怒","怒")
    end
    #種族で追加感情を設定
    case $data_SDB[@t_enemy.class_id].name
    #喜のみ
    when "スライム","ゴールドスライム","スレイヴ","ファミリア"
      emotion.push("喜","喜","喜","喜","喜","喜")
    #喜が多い
    when "サキュバスロード","タマモ","ミミック","ナイトメア"
      emotion.push("喜","喜","喜","喜","喜","怒")
    #喜の傾向
    when "サキュバス","デーモン","ウィッチ","アルラウネ"
      emotion.push("喜","喜","喜","喜","怒","怒")
    #怒の傾向
    when "プチウィッチ","ゴブリン","ガーゴイル"
      emotion.push("喜","喜","怒","怒","怒","怒")
    #怒が多い
    when "ワーウルフ","カースメイガス"
      emotion.push("喜","怒","怒","怒","怒","怒")
    #怒のみ
    when "プリーステス"
      emotion.push("怒","怒","怒","怒","怒","怒")
    #それ以外(同じくらいの感覚)
    else
      emotion.push("喜","喜","喜","怒","怒","怒")
    end
    #出力
    @t_enemy.ecstasy_emotion = emotion[rand(emotion.size)]
    return
  end
  #============================================================================
  # ●口上の好感度分岐
  #============================================================================
  def speak_favorably
    return if @t_target == nil or @t_enemy == nil
    if $game_temp.in_battle
      mood_rate = ecst_count = 0
      #ムード補正(５刻みで１上昇、最大２０)
      if $mood.point > 0
        mood_rate += ($mood.point / 5).floor
      end
      #絶頂回数補正：相手(１回ごとに５上昇、最大１５)
      if @t_target.ecstasy_count.size > 0
        ext = @t_target.ecstasy_count.size
        ecst_count += [(ext * 5), 15].min
      end
      #絶頂回数補正：自分(１回ごとに１０上昇、最大３０)
      if @t_enemy.ecstasy_count.size > 0
        ext2 = @t_enemy.ecstasy_count.size
        ecst_count += [(ext2 * 10), 30].min
      end
      #夢魔の好感度に上記補正を加算、70で割った値(端数切り上げ)が好感度ランクとなる
      #ランクの理論最高値は５とする
      @favorably = @t_enemy.love + mood_rate + ecst_count
      @favorably = (@favorably / 70).ceil
      @favorably = [[@favorably, 1].max, 5].min
    else
      #マップ中は夢魔の好感度のみを基準とし、50で割った値(端数切捨て)＋１がランクとなる
      #ランクの最高値は５とする
      @favorably = (@t_enemy.love / 50).floor + 1
      @favorably = [[@favorably, 1].max, 5].min
    end
  end
  #--------------------------------------------------------------------------
  # ● 性格別口上の最終調整
  #--------------------------------------------------------------------------
  def adjust(ms)
    return if ms == []
    ms2 = ms.clone
    ct = ms.size - 1
#    p "ms2"
#    p ms2
    for i in 0..ct
#      if ms[i].values[0] == ""
      if ms[i]["tx1"] == "" or ms[i] == {} or (ms[i]["tx1"] == "「…………\\H」" and i > 0)
        ms2.delete(ms2[i])
      end
    end
    return if ms2 == []
    if ms2.size > 1 and $game_temp.in_battle #基礎口上以外に１つ以上空白でない口上が入っている場合
      ms2[0] = nil 
      ms2.compact! 
#      ms2.delete(ms2[0]) if $game_temp.in_battle # 重複していると全部消える
    end
    #■テキストをランダムに格納
    #  キーが"tx"ならテキスト格納、"md"ならムードアップパターン読み出し
    ms = ms2[rand(ms2.size)]
    last_number = 0
    for i in 0..(ms.size - 1)
      if ms.values[i] != nil
        case ms.keys[i]
        when "md"
          moody_count(ms.values[i])
          @moody_flag = true
        when "tx1"
          @text1 = ms.values[i]
          last_number = 1 if last_number < 1
        when "tx2"
          @text2 = ms.values[i]
          last_number = 2 if last_number < 2
        when "tx3"
          @text3 = ms.values[i]
          last_number = 3 if last_number < 3
        when "tx4"
          @text4 = ms.values[i]
          last_number = 4 if last_number < 4
        end
      end
    end
    if (["主人公脱衣","仲間脱衣","夢魔脱衣","吸精・口","吸精・性器","交合"].include?($msg.tag) and $msg.talk_step == 1) or
    (["愛撫・通常","愛撫・性交","視姦","奉仕"].include?($msg.tag) and $msg.talk_step >= 1 and $msg.talk_step <= 76)
      case last_number
      when 1; @text1 += "\\T" unless @text1.include?("\\T")
      when 2; @text2 += "\\T" unless @text2.include?("\\T") 
      when 3; @text3 += "\\T" unless @text3.include?("\\T")
      when 4; @text4 += "\\T" unless @text4.include?("\\T")
      end
    end
  end
  #--------------------------------------------------------------------------
  # ● 会話のムード・友好度上昇タイプ
  #    通常時は1～6の６タイプ。
  #    絶頂時の掛け合いなど友好度のみの変動は10～15
  #    トーク時の修正は20～
  #--------------------------------------------------------------------------
  def moody_count(type)
    # 戦闘中且つ契約フェーズ中は通さない
    if $game_temp.in_battle and $scene.phase == 6
      return
    end
    case type.to_i
    #▼とても不満の残る反応だった(ムード大きくダウン) 
    when 1
      pt = -10 + rand(3) - rand(4)
      $mood.rise(pt)
    #▼不満で興味が削がれた(ムード若干ダウン)
    when 2
      pt = -5 + rand(2) - rand(3)
      $mood.rise(pt)
    #▼反応に興味を持った(友好度若干上昇、ムード上昇)
    when 3
      pt = 7 + rand(4) - rand(4)
      $mood.rise(pt)
      @t_enemy.like(3)
    #▼反応に好感を持った(友好度上昇、ムード若干上昇)
    when 4
      pt = 10 + rand(3) - rand(2)
      $mood.rise(pt)
      @t_enemy.like(5)
    #▼とても満足できる反応だった(友好度、ムード共に上昇)
    when 5
      pt = 15 + rand(4) - rand(3)
      $mood.rise(pt)
      @t_enemy.like(8)
    #-------------------------------------------------
    #▼反応が気になった(友好度：微小)
    when 10
      @t_enemy.like(1)
    #▼反応に好感を持った(友好度：小)
    when 11
      @t_enemy.like(2)
    #▼反応にドキっとした(友好度：中)
    when 12
      @t_enemy.like(4)
    #▼反応が自分の好みだった(友好度：大)
    when 13
      @t_enemy.like(10)
    #▼心が奪われた(友好度：特大)
    when 14
      @t_enemy.like(30)
    #-------------------------------------------------
    #▼トーク反応(拒否)
    when 20
      pt = -5 - rand(5)
      $mood.rise(pt)
    #▼トーク反応(中断)
    when 21
      @t_enemy.like(3)
    #▼トーク反応(前口上)
    when 22
      pt = 5 + rand(5)
      $mood.rise(pt)
      @t_enemy.like(5)
    #▼トーク反応(脱衣)
    when 23
      pt = 10 + rand(3) - rand(3)
      $mood.rise(pt)
      @t_enemy.like(5)
    #▼トーク反応(愛撫・奉仕・視姦)
    when 24
      pt = 2 + rand(4) - rand(3)
      $mood.rise(pt)
      @t_enemy.like(3)
    #▼トーク反応(吸精)
    when 25
      pt = 8 + rand(3)
      $mood.rise(pt)
      @t_enemy.like(5)
    #▼トーク反応(交合)
    when 26
      pt = 10 + rand(6)
      $mood.rise(pt)
      @t_enemy.like(15)
    #▼トーク反応(奉仕完了・視姦完了・好意)
    when 27
      pt = 5 + rand(5)
      $mood.rise(pt)
      @t_enemy.like(10)
    #▼トーク反応(不成立・絶頂中)
    when 28
      @t_enemy.like(10)
    #▼トーク反応(不成立・クライシス)
    when 29
      @t_enemy.like(4)
    #▼トーク反応(不成立・ステート)
    when 30
      @t_enemy.like(2)
    end
  end
  #--------------------------------------------------------------------------
  # ● デフォルトネーム設定
  #--------------------------------------------------------------------------
  def defaultname_select(battler)
    #★外部のSystem/talk/00_Systemフォルダで設定
  end
  #--------------------------------------------------------------------------
  # ● 実際の口上呼び出し
  #--------------------------------------------------------------------------
  def call(battler)
    @text1 = @text2 = @text3 = @text4 = ""
    #主人公が呼び出された場合は戻す
    if battler == $game_actors[101]
      return @text1 = "「……………」"
    end
    #年齢差を取得しておく
    age_check
    #絶頂時口上呼び出しの場合、付属テキストも読んでおく
    if $game_switches[77] == true
      ecstasy_emotion
      make_text
    end
    if battler != nil and battler.class_id != nil and @talk_step != 99
      #p "#{battler.name}／性格：#{battler.personality}／#{@tag}" if $DEBUG
      id = $data_personality.search(0, battler.personality)
      return @msg[battler.class_id].personality[id].manage
    else
      @text1 = @text2 = @text3 = @text4 = ""
      return @text1 = "「……………」"
    end
  end
end
