#==============================================================================
# ■ Scene_Battle (分割定義 6)
#------------------------------------------------------------------------------
# 　バトル画面の処理を行うクラスです。
#==============================================================================

class Scene_Battle
  #--------------------------------------------------------------------------
  # ★ 特殊ホールド付与の準備
  #--------------------------------------------------------------------------
  def special_hold_start
    $game_switches[81] = true
    @add_hold_flag = true
    hold_record
  end
  #--------------------------------------------------------------------------
  # ★ 特殊ホールド付与の終了
  #--------------------------------------------------------------------------
  def special_hold_end
    $game_switches[81] = false
    @add_hold_flag = false
    hold_pops_order
  end
  #--------------------------------------------------------------------------
  # ★ ホールド挙動処理
  #--------------------------------------------------------------------------
  def hold_effect(skill, active, target)
    
    #画面シェイク
    # ピストン系
    if @hold_shake == true
      #フラッシュ＋アニメーション
      if target.is_a?(Game_Enemy)
        if skill.name == "リリース" or skill.name == "インタラプト"
          active.white_flash = true
          target.animation_id = 129
          target.animation_hit = true
        else
          active.white_flash = true
          target.animation_id = 105
          target.animation_hit = true
        end
      elsif target.is_a?(Game_Actor)
        target.white_flash = true
        active.animation_id = 105
        active.animation_hit = true
      end
      if skill.element_set.include?(37)
        # 画面の縦シェイク
        $game_screen.start_flash(Color.new(255,210,225,220), 8)
        $game_screen.start_shake2(7, 15, 15)
      # グラインド系
      elsif skill.element_set.include?(38)
        # 画面の横シェイク
        $game_screen.start_flash(Color.new(255,210,225,220), 8)
        $game_screen.start_shake(7, 15, 15)
      end
      #ホールド成功時にはテキストを出し、ターゲットを行動済みにする
      unless (skill.name == "リリース" or skill.name == "インタラプト")
        @action_battlers.delete(target)
      end
      make_hold_text(skill, active, target)
    elsif @hold_shake == false
      if skill.element_set.include?(37)
        # 画面の縦シェイク
#        $game_screen.start_flash(Color.new(255,210,225,100), 8)
        $game_screen.start_shake2(2, 15, 10)
      # グラインド系
      elsif skill.element_set.include?(38)
        # 画面の横シェイク
#        $game_screen.start_flash(Color.new(255,210,225,100), 8)
        $game_screen.start_shake(2, 15, 10)
      end
    end
    #-------------------------------------------------------------------------
    # ▼乱交時、ホールド付与時にイニシアチブを変動させる
    #-------------------------------------------------------------------------
    if $game_switches[81] and @add_hold_flag
      # すでに相手が１つ以上ホールドしている場合、対象周りのホールドをすべて反転させる
      if target.hold.hold_output.size > 0 and target.hold.initiative? and
       not ["リリース","インタラプト","ストラグル"].include?(skill.name)
        # 下の記述は簡略化したメソッドにしました
        hold_dancing_change(target)
=begin
       #まず相手のイニシアチブを全て外し、対象をホールドしているバトラー全てに
        #有利２を付与する(自身含む)
        #パーツごとに個別対応すること。
        #●ペニス部分
        if target.hold.penis.battler != nil
          target.hold.penis.initiative = 0
          hold_target = target.hold.penis.battler
          case target.hold.penis.type
          when "♀挿入"
            hold_target.hold.vagina.initiative = 2
          when "口挿入"
            hold_target.hold.mouth.set(nil, nil, nil, nil)
            target.hold.penis.set(nil, nil, nil, nil)
          when "尻挿入"
            hold_target.hold.anal.set(nil, nil, nil, nil)
            target.hold.penis.set(nil, nil, nil, nil)
          when "触手吸引"
            hold_target.hold.tentacle.set(nil, nil, nil, nil)
            target.hold.penis.set(nil, nil, nil, nil)
          end
        end
        #●口部分
        if target.hold.mouth.battler != nil
          target.hold.mouth.initiative = 0
          hold_target = target.hold.mouth.battler
          case target.hold.mouth.type
          when "口挿入"
            hold_target.hold.penis.set(nil, nil, nil, nil)
            target.hold.mouth.set(nil, nil, nil, nil)
          when "ディルド口挿入"
            hold_target.hold.dildo.set(nil, nil, nil, nil)
            target.hold.mouth.set(nil, nil, nil, nil)
          when "クンニ"
            #拘束タイプはイニシアチブが切れた段階で外れる
            hold_target.hold.vagina.set(nil, nil, nil, nil)
            target.hold.mouth.set(nil, nil, nil, nil)
          when "キッス"
            #拘束タイプはイニシアチブが切れた段階で外れる
            hold_target.hold.mouth.set(nil, nil, nil, nil)
            target.hold.mouth.set(nil, nil, nil, nil)
          end
        end
        #●アソコ部分
        if target.hold.vagina.battler != nil
          target.hold.vagina.initiative = 0
          hold_target = target.hold.vagina.battler
          case target.hold.vagina.type
          when "♀挿入"
            hold_target.hold.penis.initiative = 2
          when "貝合わせ"
            hold_target.hold.vagina.initiative = 2
          when "クンニ"
            #拘束タイプはイニシアチブが切れた段階で外れる
            hold_target.hold.mouth.set(nil, nil, nil, nil)
            target.hold.vagina.set(nil, nil, nil, nil)
          when "ディルド♀挿入"
            hold_target.hold.dildo.set(nil, nil, nil, nil)
            target.hold.vagina.set(nil, nil, nil, nil)
          when "顔面騎乗"
            #拘束タイプはイニシアチブが切れた段階で外れる
            hold_target.hold.mouth.set(nil, nil, nil, nil)
            target.hold.vagina.set(nil, nil, nil, nil)
          when "触手クンニ"
            #拘束タイプはイニシアチブが切れた段階で外れる
            hold_target.hold.tentacle.set(nil, nil, nil, nil)
            target.hold.vagina.set(nil, nil, nil, nil)
          end
        end
        #●アナル部分
        if target.hold.anal.battler != nil
          target.hold.anal.initiative = 0
          hold_target = target.hold.anal.battler
          case target.hold.anal.type
          when "尻挿入"
            hold_target.hold.penis.initiative = 2
          when "ディルド尻挿入"
            hold_target.hold.dildo.set(nil, nil, nil, nil)
            target.hold.anal.set(nil, nil, nil, nil)
          when "尻騎乗"
            hold_target.hold.mouth.set(nil, nil, nil, nil)
            target.hold.anal.set(nil, nil, nil, nil)
          end
        end
        #●上半身部分
        if target.hold.tops.battler != nil
          target.hold.tops.initiative = 0
          #上半身はイニシアチブが切れた段階で外れる
          hold_target = target.hold.tops.battler
          case target.hold.tops.type
          when "パイズリ"
            #パイズリはイニシアチブが切れた段階で外れる
            hold_target.hold.penis.set(nil, nil, nil, nil)
            target.hold.tops.set(nil, nil, nil, nil)
          when "ぱふぱふ"
            #ぱふぱふはイニシアチブが切れた段階で外れる
            hold_target.hold.mouth.set(nil, nil, nil, nil)
            target.hold.tops.set(nil, nil, nil, nil)
          when "触手拘束","蔦拘束"
            #拘束タイプはイニシアチブが切れた段階で外れる
            hold_target.hold.tentacle.set(nil, nil, nil, nil)
            target.hold.tops.set(nil, nil, nil, nil)
          else
            hold_target.hold.tops.set(nil, nil, nil, nil)
            target.hold.tops.set(nil, nil, nil, nil)
          end
        end
        #●尻尾部分
        if target.hold.tail.battler != nil
          target.hold.tail.initiative = 0
          #尻尾はイニシアチブが切れた段階で外れる
          hold_target = target.hold.tail.battler
          case target.hold.tail.type
          when "♀挿入"
            hold_target.hold.vagina.set(nil, nil, nil, nil)
          when "口挿入"
            hold_target.hold.mouth.set(nil, nil, nil, nil)
          when "尻挿入"
            hold_target.hold.anal.set(nil, nil, nil, nil)
          end
          target.hold.tail.set(nil, nil, nil, nil)
        end
        #●ディルド部分
        if target.hold.dildo.battler != nil
          target.hold.dildo.initiative = 0
          #尻尾はイニシアチブが切れた段階で外れる
          hold_target = target.hold.dildo.battler
          case target.hold.dildo.type
          when "ディルド♀挿入"
            hold_target.hold.vagina.set(nil, nil, nil, nil)
          when "ディルド口挿入"
            hold_target.hold.mouth.set(nil, nil, nil, nil)
          when "ディルド尻挿入"
            hold_target.hold.anal.set(nil, nil, nil, nil)
          end
          target.hold.dildo.set(nil, nil, nil, nil)
        end
        #●触手部分
        if target.hold.tentacle.battler != nil
          target.hold.tentacle.initiative = 0
          #尻尾はイニシアチブが切れた段階で外れる
          hold_target = target.hold.tentacle.battler
          case target.hold.tentacle.type
          when "触手吸引"
            hold_target.hold.penis.set(nil, nil, nil, nil)
          when "触手♀挿入","触手クンニ"
            hold_target.hold.vagina.set(nil, nil, nil, nil)
          when "触手口挿入"
            hold_target.hold.mouth.set(nil, nil, nil, nil)
          when "触手尻挿入"
            hold_target.hold.anal.set(nil, nil, nil, nil)
          when "触手拘束","蔦拘束","触手開脚"
            hold_target.hold.tops.set(nil, nil, nil, nil)
          end
          target.hold.tentacle.set(nil, nil, nil, nil)
        end
=end
      end

      
      # その後、ホールド付与処理を行う
      add_hold(skill, active, target)
      # グラフィックチェンジフラグを立てる
      active.graphic_change = true
      target.graphic_change = true
    end
  end
  #--------------------------------------------------------------------------
  # ★ ホールド完了時テキスト処理
  #--------------------------------------------------------------------------
  def make_hold_text(skill, active, target)
    if active.is_a?(Game_Actor)
      #ホールド名からテキストを整形
      
      brk = "\n" if SR_Util.names_over?(active.name,target.name)
      case skill.name
      when "インサート"
        text = "#{active.name} inserted into #{target.name}!"
      when "アクセプト"
        text = "#{active.name} inserted #{target.name}'s penis into her pussy!"
      when "オーラルインサート"
        text = "#{active.name} inserted into#{brk} #{target.name}'s ｍouth!"
      when "オーラルアクセプト"
        text = "#{active.name} sucked#{brk} #{target.name}'s penis into her ｍouth!"
      when "バックインサート"
        text = "#{active.name} inserted into#{brk} up #{target.name}'s ass!"
      when "バックアクセプト"
        text = "#{active.name} inserted #{target.name}'s penis up her ass!"
      when "エキサイトビュー"
        text = "#{active.name} is straddling #{brk}#{target.name}'s face!"
      when "ドロウネクター"
        if active.name == $game_actors[101]
        text = "#{active.name} drinks in #{brk}#{target.name}'s pussy ｗith his ｍouth!"
        else
        text = "#{active.name} drinks in #{brk}#{target.name}'s pussy\n ｗith her ｍouth!"
        end
      when "エンブレイス"
        text = "#{active.name} clings tightly to #{brk}#{target.name}!"
      when "シェルマッチ"
        text = "#{active.name} legs intertwined ｗith #{brk}#{target.name}'s!"
      when "ディルドインサート"
        text = "#{active.name} inserted into #{brk}#{target.name}!"
      when "ディルドインマウス"
        text = "#{active.name} inserted into #{brk}#{target.name}'s ｍouth!"
      when "ディルドインバック"
        text = "#{active.name} inserted up #{brk}#{target.name}'s ass!"
      when "アイヴィクローズ","デモンズクローズ"
        text = "#{active.name}の操る触手は、\n#{target.name}の身体を絡めとった！"
      when "デモンズアブソーブ"
        text = "#{active.name}の操る触手が、\n#{target.name}のペニスに吸い付いた！"
      when "デモンズドロウ"
        text = "#{active.name}の操る触手が、\n#{target.name}のアソコに吸い付いた！"
      when "リリース"
        text = "#{active.name} broke free froｍ #{target.name}!"
      when "インタラプト"
        if active == $game_actors[101]
          for i in $game_party.actors
            if i != $game_actors[101]
              partner = i
            end
          end
        else
          partner = $game_actors[101]
        end
        text = "#{active.name} separated #{partner.name} froｍ #{target.name}!"
      end
    elsif active.is_a?(Game_Enemy)
      #ホールド名からテキストを整形
      case skill.name
      when "インサート"
        if $game_switches[89] == true #キャンセルキーで受け入れた場合
          text = "#{target.name} spreads her legs\n to receive #{active.name}'s insertion!"
        else
          text = "#{target.name} ｗas violated by #{active.name}!"
        end
      when "アクセプト"
        if $game_switches[89] == true #キャンセルキーで受け入れた場合
          text = "#{target.name} lies on his back,\n ready to be inserted by #{active.name}!"
        else
          text = "#{target.name} ｗas violated by #{active.name}!"
        end
      when "オーラルインサート"
        if $game_switches[89] == true #キャンセルキーで受け入れた場合
          text = "#{target.name} opens her mouth\n to receive #{active.name}'s penis!"
        else
          text = "#{active.name}'s penis has been\n screｗed into #{target.name}'s ｍouth!"
        end
      when "オーラルアクセプト"
        if $game_switches[89] == true #キャンセルキーで受け入れた場合
          text = "#{target.name} thrusts forward, offering\n his penis to #{active.name}'s lewd ｍouth!"
        else
          text = "#{target.name}'s penis ｗas stuffed\n into #{active.name}'s ｍouth!"
        end
      when "バックインサート"
        if $game_switches[89] == true #キャンセルキーで受け入れた場合
          text = "#{target.name} opens up her ass\n to receive #{active.name}'s penis!"
        else
          text = "#{target.name}'s sphincter has been pierced by\n #{active.name}'s penis!"
        end
      when "バックアクセプト"
        if $game_switches[89] == true #キャンセルキーで受け入れた場合
          text = "#{target.name} looks upward, ready to\n be inserted into #{active.name}'s ass!"
        else
          text = "#{target.name}'s penis has been sｗalloｗed by\n #{active.name}'s ass!"
        end
      when "エキサイトビュー"
        if $game_switches[89] == true #キャンセルキーで受け入れた場合
          text = "Lying down, #{target.name} willingly accepts\n to be sat on by #{active.name}!"
        else
          text = "#{target.name}'s face is being sｍothered by\n #{active.name}'s pussy!"
        end
      when "インモラルビュー"
        if $game_switches[89] == true #キャンセルキーで受け入れた場合
          text = "Lying down, #{target.name} willingly accepts\n to be sat on by #{active.name}!"
        else
          text = "#{target.name}'s face is being sｍothered by\n #{active.name}'s ass!"
        end
      when "エンブレイス"
        if $game_switches[89] == true #キャンセルキーで受け入れた場合
          if active.name == $game_actors[101]
          text = "#{target.name} relaxes and entrusts his body\n to #{active.name}!"
          else
          text = "#{target.name} relaxes and entrusts her\n body to #{active.name}!"
          end
        else
          text = "#{active.name} clung tightly to #{target.name}!"
        end
      when "エキシビジョン"
        if $game_switches[89] == true #キャンセルキーで受け入れた場合
          text = "#{target.name} spreads her legs,\n entrusting herself to #{active.name}!"
        else
          text = "#{active.name} clings on to #{target.name},\n opening up her crotch for all to see!"
        end
      when "ペリスコープ"
        if $game_switches[89] == true #キャンセルキーで受け入れた場合
          text = "#{target.name} thrusts out his pelvis\n and buries his penis in #{active.name}'s breasts!"
        else
          text = "#{target.name}'s penis has been\n sｗalloｗed by #{active.name}'s cleavage!!"
        end
      when "シェルマッチ"
        if $game_switches[89] == true #キャンセルキーで受け入れた場合
          text = "#{target.name} opens her legs to accept #{active.name}!"
        else
          text = "#{target.name} legs have been entangled ｗith #{active.name}!"
        end
      when "ドロウネクター"
        if $game_switches[89] == true #キャンセルキーで受け入れた場合
          text = "#{target.name} opens up her slit ｗith her\n finger, happily accepting #{active.name}'s ｍouth!"
        else
          text = "#{target.name}'s pussy is being sucked on\n by #{active.name}'s ｍouth!"
        end
      when "インサートテイル"
        text = "#{active.name} sticks her tail inside #{target.name}'s pussy!"
      when "マウスインテイル"
        text = "#{active.name} sticks her tail inside #{target.name}'s ｍouth!"
      when "バックインテイル"
        text = "#{active.name} sticks her tail up #{target.name}'s ass!"
      when "ディルドインサート"
        if $game_switches[89] == true #キャンセルキーで受け入れた場合
          text = "#{target.name} spreads her legs to receive #{active.name}!"
        else
          text = "#{active.name} pierces #{target.name}'s pussy!"
        end
      when "ディルドインマウス"
        if $game_switches[89] == true #キャンセルキーで受け入れた場合
          text = "#{target.name}は自ら口を開け、\n#{active.name}のディルドを咥え込んだ！"
        else
          text = "#{target.name}の口に、\n#{active.name}のディルドがねじ込まれた！"
        end
      when "ディルドインバック"
        if $game_switches[89] == true #キャンセルキーで受け入れた場合
          text = "#{target.name}は自らお尻を上げ、\n#{active.name}のディルドの挿入を迎え入れた！"
        else
          text = "#{target.name}の菊座に、\n#{active.name}のディルドが突き入れられた！"
        end
      when "インサートテンタクル"
        text = "#{target.name}のアソコに、\n#{active.name}の操る触手が侵入してきた！"
      when "マウスインテンタクル"
        text = "#{target.name}の口に、\n#{active.name}の操る触手が侵入してきた！"
      when "バックインテンタクル"
        text = "#{target.name}の菊座に、\n#{active.name}の操る触手が侵入してきた！"
      when "アイヴィクローズ","デモンズクローズ"
        if $game_switches[89] == true #キャンセルキーで受け入れた場合
          text = "#{target.name}は、\n#{active.name}の操る触手に身を差し出した！！"
        else
          text = "#{target.name}の身体は、\n#{active.name}の操る触手に絡め取られてしまった！！"
        end
      when "デモンズアブソーブ"
        if $game_switches[89] == true #キャンセルキーで受け入れた場合
          text = "#{target.name}は自ら仰向けになり、\n#{active.name}の操る触手の口を受け入れた！！"
        else
          text = "#{target.name}のペニスは、\n#{active.name}の操る触手に咥えられてしまった！！"
        end
      when "デモンズドロウ"
        if $game_switches[89] == true #キャンセルキーで受け入れた場合
          text = "#{target.name}は自ら指でアソコを広げ、、\n#{active.name}の操る触手の口を受け入れた！！"
        else
          text = "#{target.name}のアソコに、\n#{active.name}の操る触手が張り付いてきた！！"
        end
      when "インサルトツリー"
        text = "#{active.name}の操る触手が怪しく蠢くと、\n#{target.name}は股を大きく広げた姿勢にされてしまった！"
      end
    end
    $game_temp.battle_log_text += text + "\065\067"
  end
  #--------------------------------------------------------------------------
  # ★ ホールド終了時テキスト処理
  #--------------------------------------------------------------------------
  def make_unhold_text(target)
    #テキストは１文字につきサイズ３
    #１行表示限界は２６文字なので、名前の合計が１２文字(サイズ36)を越える場合は改行を入れる
    text = []
    #●まずターゲットの絶頂描写を入れる
    if target == $game_actors[101]
      text.push("#{target.name}は激しく消耗している……！")
      text.push("#{target.name}は極度に消耗している……！") if target.ecstasy_count.size > 1 #すでに２度以上絶頂している場合
    else
      text.push("#{target.name}は快感に喘いでいる……！")
    end
    #●その後、ホールド対象の描写を入れる
    if target.hold.penis.battler != nil
      holder = target.hold.penis.battler
      case target.hold.penis.type
      when "♀挿入"
        text.push("#{holder.name} releases his penis froｍ her vagina!")
      when "口挿入"
        text.push("#{holder.name}'s ｍouth releases his penis!")
      when "尻挿入"
        text.push("#{holder.name} released his penis froｍ her ass!")
      when "パイズリ"
        text.push("#{holder.name} released his penis froｍ her cleavage!")
      end
    end
    if target.hold.vagina.battler != nil
      holder = target.hold.vagina.battler
      case target.hold.vagina.type
      when "♀挿入"
        item = target.hold.vagina.parts
        text.push("#{holder.name} pulled his penis out of her #{item}!")
      when "顔面騎乗","クンニ"
        text.push("#{holder.name} pulls aｗay froｍ #{target.name}'s crotch!")
      when "貝合わせ"
        text.push("#{holder.name} untｗines her legs!")
      end
    end
    if target.hold.mouth.battler != nil
      holder = target.hold.mouth.battler
      case target.hold.mouth.type
      when "口挿入"
        item = target.hold.mouth.parts
        text.push("#{holder.name} pulled his penis out of her #{item}!")
      when "顔面騎乗","尻騎乗","ぱふぱふ"
        text.push("#{holder.name} releases #{target.name}!")
      when "クンニ","キッス"
        text.push("#{holder.name} parts froｍ #{target.name}'s lips!")
      end
    end
    if target.hold.anal.battler != nil
      holder = target.hold.anal.battler
      case target.hold.anal.type
      when "尻挿入"
        text.push("#{holder.name} pulled his penis out of her #{item}!")
      when "尻騎乗"
        text.push("#{holder.name} releases #{target.name}!")
      end
    end
    if target.hold.tops.battler != nil
      holder = target.hold.tops.battler
      case target.hold.tops.type
      when "拘束","開脚","ぱふぱふ"
        text.push("#{holder.name} lets go of #{target.name}!")
      end
    end
    if target.hold.tail.battler != nil
      holder = target.hold.tail.battler
      case target.hold.tail.type
      when "♀挿入","口挿入","尻挿入"
        text.push("#{target.name} was released froｍ her tail's grasp!")
      end
    end
    if target.hold.tentacle.battler != nil
      holder = target.hold.tentacle.battler
      case target.hold.tentacle.type
      when "♀挿入","口挿入","尻挿入"
        text.push("#{holder.name} releases her tentacle!")
      end
    end
    if target.hold.dildo.battler != nil
      holder = target.hold.dildo.battler
      brk = "、\n" if SR_Util.names_over?(holder.name,target.name)
      case target.hold.dildo.type
      when "♀挿入","口挿入","尻挿入"
        text.push("#{holder.name} releases her dildo!")
      end
    end
    a = ""
    a += text[0] if text[0] != nil
    a += "\n\066" if text[1] != nil
    a += text[1] if text[1] != nil
    a += "\n\066" if text[2] != nil
    a += text[2] if text[2] != nil
    a += "\n\066" if text[3] != nil
    a += text[3] if text[3] != nil
    $game_temp.battle_log_text += a + "\065\067"
  end
  #--------------------------------------------------------------------------
  # ● 乱交時のホールド付与によるイニシアチブ変動
  # owner : 減少するバトラー
  #--------------------------------------------------------------------------
  def hold_dancing_change(owner)
    # パーツ名を取得する
    owner_parts = owner.hold.parts_names
    # 各パーツごとに確認
    for o_parts_one in owner_parts
      # パーツ情報を変数に入れる
      checking_parts = eval("owner.hold.#{o_parts_one}")
      # このパーツが占有中の場合
      if checking_parts.battler != nil
        initiative_zero_flag = false
        # ０以下で無ければイニシアチブを減少させる
        if checking_parts.initiative > 0
          checking_parts.initiative = 0
          # これによりイニシアチブが０になった場合、フラグを立てる
          initiative_zero_flag = true
        end
        #-----------------------------------------------------------------------------
        # ▽イニシアチブが０にされた時の変動
        if checking_parts.initiative == 0
          # ホールド相手を変数に入れる
          hold_target = checking_parts.battler
          # ホールド相手側の対応パーツ配列を確認する
          target_parts_names = SR_Util.holding_parts_name(checking_parts.type, o_parts_one)
          # 対応パーツごとにチェック
          for t_parts_one in target_parts_names
            # 対応パーツ情報を変数に入れる
            checking_target_parts = eval("hold_target.hold.#{t_parts_one}")
            # 逆転可能なホールドは対応パーツのイニシアチブを２にまで引き上げる
            if SR_Util.reversible_hold?(checking_target_parts.type)
              if checking_target_parts.initiative < 2
                checking_target_parts.initiative = 2
              end
            # 逆転不可なものはホールドを解除させる
            else
              # イニシアチブが０にされた（優勢から劣勢になった）時は解除
              if initiative_zero_flag
                checking_parts.clear
                checking_target_parts.clear
              # イニシアチブが元々０の時（元から劣勢）はイニシアチブを２にまで引き上げる
              else
                if checking_target_parts.initiative < 2
                  checking_target_parts.initiative = 2
                end
              end
            end
          end
        end
        #-----------------------------------------------------------------------------
      end
    end
  end
  #--------------------------------------------------------------------------
  # ● クリティカル等によるホールドイニシアチブ減少
  # owner : 減少するバトラー
  #--------------------------------------------------------------------------
  def hold_initiative_down(owner)
    # パーツ名を取得する
    owner_parts = owner.hold.parts_names
    # 各パーツごとに確認
    for o_parts_one in owner_parts
      # パーツ情報を変数に入れる
      checking_parts = eval("owner.hold.#{o_parts_one}")
      # このパーツが占有中の場合
      if checking_parts.battler != nil
        initiative_zero_flag = false
        # ０以下で無ければイニシアチブを減少させる
        if checking_parts.initiative > 0
          checking_parts.initiative -= 1
          # これによりイニシアチブが０になった場合、フラグを立てる
          initiative_zero_flag = true if checking_parts.initiative == 0
        end
        #-----------------------------------------------------------------------------
        # イニシアチブが０の相手に対する効果
        if checking_parts.initiative == 0
          # ホールド相手を変数に入れる
          hold_target = checking_parts.battler
          # ホールド相手側の対応パーツ配列を確認する
          target_parts_names = SR_Util.holding_parts_name(checking_parts.type, o_parts_one)
          # 対応パーツごとにチェック
          for t_parts_one in target_parts_names
            # 対応パーツ情報を変数に入れる
            checking_target_parts = eval("hold_target.hold.#{t_parts_one}")
            # ▽逆転可能なホールド
            # 対応パーツのイニシアチブを加算させる
            if SR_Util.reversible_hold?(checking_target_parts.type)
              # イニシアチブが０にされた（優勢から劣勢になった）時は２まで引き上げる
              if initiative_zero_flag
                if checking_target_parts.initiative < 2
                  checking_target_parts.initiative = 2
                end
              # イニシアチブが元々０の時（元から劣勢）はイニシアチブを加算させる
              else
                if checking_target_parts.initiative < 3
                  checking_target_parts.initiative += 1
                end
              end
            # ▽逆転不可なホールドを解除させる
            else
              # イニシアチブが０にされた（優勢から劣勢になった）時は解除
              if initiative_zero_flag
                checking_parts.clear
                checking_target_parts.clear
              # イニシアチブが元々０の時（元から劣勢）はイニシアチブを加算させる
              else
                if checking_target_parts.initiative < 3
                  checking_target_parts.initiative += 1
                end
              end
            end
          end
        end
        #-----------------------------------------------------------------------------
      end
    end
    
# ホールドポップの指示はもがく等、
#複数相手を通る場合があるのでこのメソッドを通ったあとで指定
=begin 
    # ホールドポップの指示
    hold_pops_order
=end

  end
  #--------------------------------------------------------------------------
  # ● 各バトラーにホールド状況を記録
  #--------------------------------------------------------------------------
  def hold_record
    for battler in $game_party.party_actors + $game_troop.enemies
      battler.hold_list = battler.hold.hold_output
    end
  end
  #--------------------------------------------------------------------------
  # ● 増減したホールドポップを指示
  #--------------------------------------------------------------------------
  def hold_pops_order
    # 全員のホールド状況を確認する
    for battler in $game_party.battle_actors + $game_troop.enemies
      # 前回と現在のホールド状況を出す。
      last_hold = battler.hold_list
      now_hold = battler.hold.hold_output
      # 前のホールド状況と違う場合、データを洗い出す。
      if last_hold != now_hold
        # 追加されたホールドと削除されたホールドの箱を初期化
        add_hold = []
        delete_hold = []
        #----------------------------------------------------------------------
        # 追加側を確認
        #----------------------------------------------------------------------
        for now in now_hold
          # 同ホールドの存在フラグを初期化
          exist_flag = false
          for last in last_hold
            # 同ホールドが見つかったらフラグを立てて終了
            if now[0] == last[0] and now[2] == last[2]
              exist_flag = true
              break
            end
          end
          # 同じホールドがなかった場合、それは追加されたものである。
          if exist_flag == false
            add_hold.push(now)
          end
        end
        # タイプが重複しているものを1つにまとめる
        result_box = []
        for hold in add_hold
          overlap_flag = false
          for result in result_box
            if hold[0] == result[0] and hold[2] == result[2]
              overlap_flag = true
              break
            end
          end
          if overlap_flag == false
            result_box.push(hold)
          end
        end
        add_hold = result_box
        #----------------------------------------------------------------------
        # 削除側を確認
        #----------------------------------------------------------------------
        for last in last_hold
          # 同ホールドの存在フラグを初期化
          exist_flag = false
          for now in now_hold
            # 同ホールドが見つかったらフラグを立てて終了
            if now[0] == last[0] and now[2] == last[2]
              exist_flag = true
              break
            end
          end
          # 同じホールドがなかった場合、それは削除されたものである。
          if exist_flag == false
            delete_hold.push(last) 
          end
        end
        # タイプが重複しているものを1つにまとめる
        result_box = []
        for hold in delete_hold
          overlap_flag = false
          for result in result_box
            if hold[0] == result[0] and hold[2] == result[2]
              overlap_flag = true
              break
            end
          end
          if overlap_flag == false
            result_box.push(hold)
          end
        end
        delete_hold = result_box
        #----------------------------------------------------------------------
        # 前回と現在のイニシアチブを確認
        #----------------------------------------------------------------------
        last_initiative = 0
        for last in last_hold
          last_initiative = last[3] 
          break
        end
        now_initiative = 0
        for now in now_hold
          now_initiative = now[3] 
          break
        end
        #----------------------------------------------------------------------
        # ホールドポップへの指示を作成
        #----------------------------------------------------------------------
        order = []
        for hold in add_hold
          order.push([1, hold[2], battler, hold[0]])
        end
        for hold in delete_hold
          order.push([2, hold[2], battler, hold[0]])
        end
        order.push([3, now_initiative])
        battler.hold_pop_order = order
      end
    end
  end
=begin
  #--------------------------------------------------------------------------
  # ★ ホールド有利不利切り替え
  #--------------------------------------------------------------------------
  def hold_initiative(skill, active, target)
    #●方策
    #０：ホールドに成功した場合
    #１：仕掛けた側、相手が両方未ホールドの場合  ＞  仕掛けた側に仕掛けたホールドの有利が★２で付く
    #２：相手がすでにホールド中の場合  ＞  仕掛けた側に仕掛けたホールドの有利が★２で、
    #    その上で相手の有利が全て消えて、相手に仕掛けているホールドキャラ全員にも★１が付く
    #▼99オフ(ダメージやアタックで変動する場合)
    #１：相手が有利の場合、まず全ての有利を１段階低下させる
    #２：相手の有利のうち、★が０になったらそのホールドしている相手に★１を付与する
    #３：自分が有利の場合、★が２以下だったなら★を１段階アップさせる
    #-------------------------------------------------------------------------
    # ▼ホールドスキルではない、一般スキルによる効果
    #-------------------------------------------------------------------------
    # ▽パターン３：相手がホールド中で、相手にセンシャルエフェクトを発生させた
    #-------------------------------------------------------------------------
    hd_text = ""
    if (target.critical or skill.element_set.include?(207)) and target.holding?
      #面倒でもパーツごとに個別対応。
      #相手のイニシアチブを－１する。１の時に－１した場合、イニシアチブが反転する
      #既に攻撃対象のイニシアチブが０の場合、ホールド対象に＋１（最大３）する
      #●ペニス部分
      if target.hold.penis.battler != nil
        if target.hold.penis.initiative > 0
          target.hold.penis.initiative -= 1
        end
        if target.hold.penis.initiative == 0
          hold_target = target.hold.penis.battler
          case target.hold.penis.type
          when "♀挿入"
            hold_target.hold.vagina.initiative += 1 unless hold_target.hold.vagina.initiative > 2
          when "口挿入"
            hold_target.hold.mouth.initiative += 1 unless hold_target.hold.mouth.initiative > 2
          when "尻挿入"
            hold_target.hold.anal.initiative += 1 unless hold_target.hold.anal.initiative > 2
          when "パイズリ"
            hold_target.hold.tops.initiative += 1 unless hold_target.hold.tops.initiative > 2
          when "触手吸引"
            hold_target.hold.tentacle.initiative += 1 unless hold_target.hold.tentacle.initiative > 2
          end
        end
      end
      #●口部分
      if target.hold.mouth.battler != nil
        if target.hold.mouth.initiative > 0
          target.hold.mouth.initiative -= 1
        end
        if target.hold.mouth.initiative == 0
          hold_target = target.hold.mouth.battler
          case target.hold.mouth.type
          when "口挿入"
            case target.hold.mouth.parts
            when "ペニス"
              hold_target.hold.penis.set(nil, nil, nil, nil)
              target.hold.mouth.set(nil, nil, nil, nil)
            when "尻尾"
              hold_target.hold.tail.set(nil, nil, nil, nil)
              target.hold.mouth.set(nil, nil, nil, nil)
            when "ディルド"
              hold_target.hold.dildo.set(nil, nil, nil, nil)
              target.hold.mouth.set(nil, nil, nil, nil)
            when "触手"
              hold_target.hold.tentacle.set(nil, nil, nil, nil)
              target.hold.mouth.set(nil, nil, nil, nil)
            end
          when "顔面騎乗"
            hold_target.hold.vagina.initiative += 1 unless hold_target.hold.vagina.initiative > 2
          when "尻騎乗"
            hold_target.hold.anal.initiative += 1 unless hold_target.hold.anal.initiative > 2
          when "キッス"
            hold_target.hold.mouth.initiative += 1 unless hold_target.hold.mouth.initiative > 2
          when "クンニ"
            #拘束タイプはイニシアチブが切れた段階で外れる
            hold_target.hold.vagina.set(nil, nil, nil, nil)
            target.hold.mouth.set(nil, nil, nil, nil)
          end
        end
      end
      #●アソコ部分
      if target.hold.vagina.battler != nil
        if target.hold.vagina.initiative > 0
          target.hold.vagina.initiative -= 1
        end
        if target.hold.vagina.initiative == 0
          hold_target = target.hold.vagina.battler
          case target.hold.vagina.type
          when "♀挿入"
            case target.hold.vagina.parts
            when "ペニス"
              hold_target.hold.penis.initiative += 1 unless hold_target.hold.penis.initiative > 2
            when "尻尾"
              hold_target.hold.tail.set(nil, nil, nil, nil)
              target.hold.vagina.set(nil, nil, nil, nil)
            when "ディルド"
              hold_target.hold.dildo.set(nil, nil, nil, nil)
              target.hold.vagina.set(nil, nil, nil, nil)
            when "触手"
              hold_target.hold.tentacle.set(nil, nil, nil, nil)
              target.hold.vagina.set(nil, nil, nil, nil)
            end
          when "貝合わせ"
            hold_target.hold.vagina.initiative += 1 unless hold_target.hold.vagina.initiative > 2
          when "顔面騎乗"
            #拘束タイプはイニシアチブが切れた段階で外れる
            hold_target.hold.mouth.set(nil, nil, nil, nil)
            target.hold.vagina.set(nil, nil, nil, nil)
          end
        end
      end
      #●アナル部分
      if target.hold.anal.battler != nil
        if target.hold.anal.initiative > 0
          target.hold.anal.initiative -= 1
        end
        if target.hold.anal.initiative == 0
          hold_target = target.hold.anal.battler
          case target.hold.anal.type
          when "尻挿入"
            case target.hold.anal.parts
            when "ペニス"
              hold_target.hold.penis.initiative += 1 unless hold_target.hold.penis.initiative > 2
            when "尻尾"
              hold_target.hold.tail.set(nil, nil, nil, nil)
              target.hold.anal.set(nil, nil, nil, nil)
            when "ディルド"
              hold_target.hold.dildo.set(nil, nil, nil, nil)
              target.hold.anal.set(nil, nil, nil, nil)
            when "触手"
              hold_target.hold.tentacle.set(nil, nil, nil, nil)
              target.hold.anal.set(nil, nil, nil, nil)
            end
          when "尻騎乗"
            #拘束タイプはイニシアチブが切れた段階で外れる
            hold_target.hold.mouth.set(nil, nil, nil, nil)
            target.hold.anal.set(nil, nil, nil, nil)
          end
        end
      end
      #●上半身部分
      if target.hold.tops.battler != nil
        hold_target = target.hold.tops.battler
        if target.hold.tops.initiative > 0
          target.hold.tops.initiative -= 1
          if target.hold.tops.initiative == 0
            #上半身はイニシアチブが切れた段階で外れる
            hold_target = target.hold.tops.battler
            hold_target.hold.tops.set(nil, nil, nil, nil)
            case target.hold.tops.parts
            when "上半身" #エンブレイス
              target.hold.tops.set(nil, nil, nil, nil)
            when "口" #ヘブンリーフィール
              target.hold.mouth.set(nil, nil, nil, nil)
            when "ペニス" #ペリスコープ
              target.hold.penis.set(nil, nil, nil, nil)
            when "触手" #ペリスコープ
              target.hold.tentacle.set(nil, nil, nil, nil)
            end
          end
        #既にイニシアチブが０(対象が被拘束状態)なら相手に＋１する
        else
          case target.hold.tops.parts
          when "口"
            hold_target.hold.mouth.initiative += 1 unless hold_target.hold.mouth.initiative > 2
          when "ペニス"
            hold_target.hold.penis.initiative += 1 unless hold_target.hold.penis.initiative > 2
          when "上半身"
            hold_target.hold.tops.initiative += 1 unless hold_target.hold.tops.initiative > 2
          end
        end
      end
      #●尻尾部分
      if target.hold.tail.battler != nil
        if target.hold.tail.initiative > 0
          target.hold.tail.initiative -= 1
          if target.hold.tail.initiative == 0
            #尻尾挿入はイニシアチブが切れた段階で外れる
            hold_target = target.hold.tail.battler
            case target.hold.tail.parts
            when "アソコ"
              hold_target.hold.vagina.set(nil, nil, nil, nil)
            when "口"
              hold_target.hold.mouth.set(nil, nil, nil, nil)
            when "アナル"
              hold_target.hold.anal.set(nil, nil, nil, nil)
            end
            target.hold.tail.set(nil, nil, nil, nil)
          end
        end
      end
      #●ディルド部分
      if target.hold.dildo.battler != nil
        if target.hold.dildo.initiative > 0
          target.hold.dildo.initiative -= 1
          if target.hold.dildo.initiative == 0
            #ディルド挿入はイニシアチブが切れた段階で外れる
            hold_target = target.hold.dildo.battler
            case target.hold.dildo.parts
            when "アソコ"
              hold_target.hold.vagina.set(nil, nil, nil, nil)
            when "口"
              hold_target.hold.mouth.set(nil, nil, nil, nil)
            when "アナル"
              hold_target.hold.anal.set(nil, nil, nil, nil)
            end
            target.hold.dildo.set(nil, nil, nil, nil)
          end
        end
      end
      #●触手部分
      if target.hold.tentacle.battler != nil
        if target.hold.tentacle.initiative > 0
          target.hold.tentacle.initiative -= 1
          if target.hold.tentacle.initiative == 0
            #触手挿入・拘束はイニシアチブが切れた段階で外れる
            hold_target = target.hold.tentacle.battler
            case target.hold.tentacle.parts
            when "ペニス"
              hold_target.hold.penis.set(nil, nil, nil, nil)
            when "アソコ"
              hold_target.hold.vagina.set(nil, nil, nil, nil)
            when "口"
              hold_target.hold.mouth.set(nil, nil, nil, nil)
            when "アナル"
              hold_target.hold.anal.set(nil, nil, nil, nil)
            when "上半身"
              hold_target.hold.tops.set(nil, nil, nil, nil)
            end
            target.hold.tentacle.set(nil, nil, nil, nil)
          end
        end
      end
    end
    # ホールドポップの指示
    hold_pops_order
    # 体位テキスト
    $game_temp.battle_log_text += "\065\067" + hd_text if hd_text != ""
  end
=end

end