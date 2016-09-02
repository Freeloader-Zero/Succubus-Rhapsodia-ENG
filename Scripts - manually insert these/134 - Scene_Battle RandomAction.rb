#==============================================================================
# ■ Scene_Battle (分割定義 6)
#------------------------------------------------------------------------------
# 　バトル画面の処理を行うクラスです。
#==============================================================================

class Scene_Battle
  #--------------------------------------------------------------------------
  # ★ 習得しているホールド以外を外す
  #--------------------------------------------------------------------------
  def hold_action_select(action)
    action.delete(682) unless @active_battler.have_ability?("アクセプト")
    action.delete(683) unless @active_battler.have_ability?("シェルマッチ")
    action.delete(684) unless @active_battler.have_ability?("エキサイトビュー")
    action.delete(687) unless @active_battler.have_ability?("オーラルセックス")
    action.delete(688) unless @active_battler.have_ability?("オーラルセックス")
    action.delete(689) unless @active_battler.have_ability?("フラッタナイズ")
    action.delete(691) unless @active_battler.have_ability?("トレインドホール")
    action.delete(692) unless @active_battler.have_ability?("トレインドホール")
    action.delete(695) unless @active_battler.have_ability?("エンブレイス")
    action.delete(697) unless @active_battler.have_ability?("ペリスコープ")
    action.delete(698) unless @active_battler.have_ability?("ヘブンリーフィール")
    action.delete(700) unless @active_battler.have_ability?("アンドロギュヌス")
    action.delete(701) unless @active_battler.have_ability?("アンドロギュヌス")
    action.delete(705) unless @active_battler.have_ability?("テイルマスタリー")
    action.delete(706) unless @active_battler.have_ability?("テイルマスタリー")
    action.delete(710) unless @active_battler.have_ability?("イクイップディルド")
    action.delete(711) unless @active_battler.have_ability?("イクイップディルド")
    action.delete(712) unless @active_battler.have_ability?("イクイップディルド")
    action.delete(718) unless @active_battler.have_ability?("テンタクルマスタリー")
    action.delete(715) # アイヴィクローズ（ホールド）（没）
    action.delete(716) # デモンズクローズ（ホールド）（没）
    action.delete(719) # インサルトツリー（没）
    unless @active_battler.have_ability?("アヌスマーキング")
      action.delete(702) unless @active_battler.have_ability?("アンドロギュヌス")
      action.delete(707) unless @active_battler.have_ability?("テイルマスタリー")
    end
    unless @active_battler.have_ability?("バインドマスタリー")
      action.delete(696) unless @active_battler.have_ability?("エンブレイス")
    end
=begin
    # 特殊（習得素質＋ヘイトスイッチで解禁される）※→ヘイト解禁オフ
    # ディルドインバック
    unless @active_battler.have_ability?("イクイップディルド") and (
    @active_battler.have_ability?("アヌスマーキング"))# or $game_switches[145])
      action.delete(712) 
    end
=end
    # デモンズアブソーブ
    unless @active_battler.have_ability?("テンタクルマスタリー")# and $game_switches[145]
      action.delete(717)
    end
    
    return action
  end
  #--------------------------------------------------------------------------
  # ★ ランダムな攻め
  #--------------------------------------------------------------------------
  def random_skill_action
#    p "追撃発生／アクション：#{@active_battler.name}／行動：#{$msg.at_type}／対象：#{$msg.at_parts}" if $game_switches[78] and $DEBUG
    action = []
    
    #参照するスキル部分の記述が長いため事前に簡略化
#    random_skill = @active_battler.current_action.skill_id
    #対応する属性(使用側)
    #@71＝手  @72＝口  @73＝胸  @74＝♂  @75＝♀  @76＝尻  @77＝足
    #@78＝尻尾  @79＝触手  @80＝他身体  @81＝ディルド  @82＝視線  @83＝声
    #@84＝手口複合  @85＝鞭  @86＝緊縛
    #対応する属性(対象側)
    #@91＝口  @92＝胸  @93＝尻  @94＝Ａ  @95＝♂  @96＝玉  
    #@97＝♀  @98＝核  @99＝他身体  @100＝目  @101＝耳
#    p @skill.id if $DEBUG
    #------------------------------------------------------------------------
    # ★追撃処理★
    # スイッチ25(追撃)が入っている場合、追撃スキルが選択される
    #------------------------------------------------------------------------
    if $game_switches[78] == true
      case $msg.at_type
      #●
      when "キス"
        #キスの追撃はキスのみ
        action = [305]
      #●
      when "手"
        #直前に対象を攻めた部位から追撃スキルidを設定
        case $msg.at_parts
        when "対象：胸"
          action = [332]
        when "対象：尻"
          action = [354]
        when "対象：アナル"
          if @target_battlers[0].have_ability?("男")
            action = [355]
          else
            action = [356]
          end
        when "対象：ペニス"
          action = [325]
        when "対象：睾丸"
          action = [326]
        when "対象：アソコ"
          action = [341]
        when "対象：陰核"
          action = [342]
        end
      #●
      when "口"
        #直前に対象を攻めた部位から追撃スキルidを設定
        case $msg.at_parts
        when "対象：胸"
          action = [388]
        when "対象：尻"
          action = [410]
        when "対象：アナル"
          if @target_battlers[0].have_ability?("男")
            action = [411]
          else
            action = [412]
          end
        when "対象：ペニス"
          action = [381]
        when "対象：睾丸"
          action = [382]
        when "対象：アソコ"
          action = [397]
        when "対象：陰核"
          action = [398]
        end
      #●
      when "胸"
        #直前に対象を攻めた部位から追撃スキルidを設定(胸サイズでスキル変更)
        case $msg.at_parts
        when "対象：口"
          if $data_SDB[@active_battler.class_id].bust_size < 2
            action = [445]
          else
            action = [444]
          end
        when "対象：胸"
          if $data_SDB[@active_battler.class_id].bust_size < 2
            action = [454]
          else
            action = [453]
          end
        when "対象：ペニス"
          if $data_SDB[@active_battler.class_id].bust_size < 2
            action = [437]
          else
            action = [436]
          end
        end
      #●
      when "♀"
        #現状で素股しかないのでid固定
        action = [477]
      #●
      when "足"
        case $msg.at_parts
        when "対象：胸"
          action = [494]
        when "対象：ペニス"
          action = [489]
        when "対象：アソコ"
          action = [499]
        end
      #●
      when "愛撫"
        #愛撫には追撃は発生しないので、処理が走っても戻す
        return
      #●
      when "尻尾"
        #直前に対象を攻めた部位から追撃スキルidを設定
        case $msg.at_parts
        when "対象：胸"
          action = [526]
        when "対象：尻"
          action = [543]
        when "対象：アナル"
          if @target_battlers[0].have_ability?("男")
            action = [544]
          else
            action = [545]
          end
        when "対象：ペニス"
          action = [520]
        when "対象：睾丸"
          action = [521]
        when "対象：アソコ"
          action = [533]
        when "対象：陰核"
          action = [534]
        end
      #●
      when "道具"
        #直前に対象を攻めた部位から追撃スキルidを設定
        case $msg.at_parts
        #アナル張型
        when "対象：アナル"
          action = [621]
        #アソコ張型
        when "対象：アソコ"
          action = [614]
        #鞭
        when "使用：鞭"
          action = [557]
        #縛り
        when "使用：緊縛"
          action = [572]
        end
      #●
      when "特殊身体"
        #★特殊身体攻撃は、攻撃個別ごとに設定する
        action = [305]
      #●
      when "暴走行動"
        #暴走愛撫を入れておく(後で再定義する)
        action = [982]
        #★暴走時は行動者のホールド状況によって設定する
        if @active_battler.holding_now?
          # ♀挿入の場合
          if @active_battler.inserting_now?
            action = [984] if @active_battler.penis_insert? or @active_battler.dildo_insert? #♂orディルド
            action = [986] if @active_battler.vagina_insert? #♀
          # 口挿入の場合
          elsif @active_battler.oralsex_now?
            action = [984]
          # 尻挿入の場合
          elsif @active_battler.analsex_now?
            action = [982] if @active_battler.dildo_anal_analsex? #Ａディルドは反撃できないため愛撫に
            action = [984] if @active_battler.penis_analsex? or @active_battler.dildo_analsex? #♂orディルド
            action = [986] if @active_battler.anal_analsex? #Ａ
          # 貝合わせの場合
          elsif @active_battler.shellmatch_now?
            action = [986]
          # 騎乗の場合
          elsif @active_battler.riding_now?
            action = [982] if @active_battler.mouth_riding? #口
            action = [986] if @active_battler.vagina_riding? #♀
          # パイズリの場合
          elsif @active_battler.paizuri_now?
            action = [982] if @active_battler.penis_paizuri? #♂は反撃できないため愛撫に
            action = [986] if @active_battler.tops_paizuri? #胸
          # クンニの場合
          elsif @active_battler.drawing_now?
            action = [982] if @active_battler.vagina_draw? or @active_battler.tentacle_vagina_draw? #♀は反撃できないため愛撫に
            action = [984] if @active_battler.mouth_draw? or @active_battler.tentacle_draw? #口or触手
          # 拘束の場合
          elsif @active_battler.binding_now?
            action = [982]
          # 触手吸引の場合
          elsif @active_battler.usetentacle_now?
            action = [982] if @active_battler.tentacle_penis_absorbing? #♂は反撃できないため愛撫に
            action = [984] if @active_battler.tentacle_absorbing? #触手
          else
            action = [982]
          end
        else
          action = [982]
        end
      #●
      when "ホールド攻撃"
        #直前に対象を攻めた部位から追撃スキルidを設定
        case $msg.at_parts
        when "♀挿入：ペニス側"
          action = [843] #ピストン
        when "♀挿入：アソコ側"
          if @active_battler.initiative_now?
            action = [757] #グラインド
          else
            action = [758] #締める
          end
        when "口挿入：ペニス側"
          action = [852] #イラマチオ
        when "口挿入：口側"
          if @active_battler.initiative_now?
            action = [794]
          else
            action = [795]
          end
        when "尻挿入：ペニス側"
          action = [857]
        when "尻挿入：尻側"
          action = [814]
        when "貝合わせ"
          action = [764]
        when "騎乗：アソコ側"
          action = [769]
        when "騎乗：口側"
          action = [936]
        when "尻騎乗：尻側"
          action = [819]
        when "尻騎乗：口側"
          action = [927]
        when "クンニ"
          action = [801]
        when "ぱふぱふ"
          action = [864]
        when "キッス"
          action = [807]
        when "背面拘束"
          action = [830]
        when "開脚拘束"
          action = [834]
        when "パイズリ"
          action = [840]
        when "尻尾♀挿入"
          action = [869]
        when "尻尾口挿入"
          action = [874]
        when "尻尾尻挿入"
          action = [879]
        when "ディルド♀挿入"
          action = [891]
        when "ディルド口挿入"
          action = [896]
        when "ディルド尻挿入"
          action = [901]
        when "触手♀挿入"
          action = [913]
        when "触手口挿入"
          action = [918]
        when "触手尻挿入"
          action = [923]
        when "触手拘束"
          action = [927]
        end
      #●
      when "ホールド援護"
        action = [964]
      end
    else
      #-----------------------------------------------------------------------
      # ●追撃用アタックパターンリセット
      #-----------------------------------------------------------------------
      $msg.at_type = $msg.at_parts = ""
      pc1 = $mood.point + (@active_battler.dex / 2) #強スキル使用確率
      pc2 = ($mood.point / 2) + (@active_battler.dex / 3) #必殺スキル使用確率
      pc3 = ($mood.point / 3) + (@active_battler.int / 3) #アブノーマル系スキル使用確率
      pc3 -= 100 #基本アブノーマル系スキルは使わないが、ごく一部の夢魔のみムードが高いと使う可能性がある
      #性格単位で一部スキル確率を一部変動
      case @active_battler.personality
      when "好色","勝ち気","柔和","独善","暢気"
        pc1 += $mood.point
      when "上品","内気","陽気","気丈","高貴","潔癖"
        pc3 -= 100
      when "倒錯","意地悪","高慢","陰気","露悪狂"
        pc3 += $mood.point
      end
      count = 0
      loop do
        #-----------------------------------------------------------------------
        # ●ランダムスキルのidから選別
        #-----------------------------------------------------------------------
        case @skill.id
        #======================================================================
        # ●キッス
        #======================================================================
        when 281
          $msg.at_type = "キス"
          action = [301,301,302,302,302]
          action.push(303) if rand(100) < pc1
          action.push(303,304) if rand(100) < pc2
        #======================================================================
        # ●手攻め
        #======================================================================
        when 282
          $msg.at_type = "手"
          #対♂と対♀と対双成でセットするスキルが異なる
          if @target_battlers[0].boy?
            action = [319,319,320]
            if @target_battlers[0].nude?
              action.push(320,320,328,344)
              action.push(321,323,344) if rand(100) < pc1
              action.push(321,322,323,324) if rand(100) < pc2
              action.push(348,349,350) if rand(100) < pc3 #前立腺刺激は確率が低いが一応行う
            end
          elsif @target_battlers[0].futanari?
            action = [319,319,320,328,328,329,334,334,335,344,344,345]
            if @target_battlers[0].nude?
              action.push(320,320,329,329,328,335,335,345,345)
              action.push(321,323,330,336,338,346) if rand(100) < pc1
              action.push(321,324,322,330,331,336,337,339,340,346,347,351) if rand(100) < pc2
              action.push(352,353) if rand(100) < pc3 #アナル刺激は確率が低いが一応行う
            end
          else
            action = [328,328,329,334,334,335,344,344,345]
            if @target_battlers[0].nude?
              action.push(329,329,328,335,335,345,345) if @target_battlers[0].nude?
              action.push(330,336,338,346) if rand(100) < pc1
              action.push(330,331,337,338,339,340,346,347,351) if rand(100) < pc2
              action.push(352,353) if rand(100) < pc3 #アナル刺激は確率が低いが一応行う
            end
          end
        #======================================================================
        # ●口攻め
        #======================================================================
        when 283
          $msg.at_type = "口"
          #対♂と対♀と対双成でセットするスキルが異なる
          if @target_battlers[0].boy?
            action = [375,375,376]
            if @target_battlers[0].nude?
              action.push(376,376,384)
              action.push(377,379,400) if rand(100) < pc1
              action.push(377,378,380) if rand(100) < pc2
              action.push(404,405,406) if rand(100) < pc3 #前立腺刺激は確率が低いが一応行う
            end
          elsif @target_battlers[0].futanari?
            action = [375,375,376,384,384,385,390,390,391,400,400,401]
            if @target_battlers[0].nude?
              action.push(376,376,385,385,391,391,394,401,401)
              action.push(377,379,386,392,394,395,402) if rand(100) < pc1
              action.push(378,380,387,393,396,403,407) if rand(100) < pc2
              action.push(408,409) if rand(100) < pc3 #アナル刺激は確率が低いが一応行う
            end
          else
            action = [384,384,385,390,390,391,400,400,401]
            if @target_battlers[0].nude?
              action.push(385,385,391,391,394,401,401)
              action.push(386,392,394,395,402) if rand(100) < pc1
              action.push(387,393,396,403,407) if rand(100) < pc2
              action.push(408,409) if rand(100) < pc3 #アナル刺激は確率が低いが一応行う
            end
          end
        #======================================================================
        # ●胸攻め
        #======================================================================
        when 284
          $msg.at_type = "胸"
          #対♂と対♀と対双成でセットするスキルが異なる
          if @target_battlers[0].boy?
            #胸の大きさでセットするスキルが異なる
            if $data_SDB[@active_battler.class_id].bust_size < 2
              action = [435,435,443,443]
            else
              action = [431,431,432,439,439,440]
              action.push(432,432,433,440,440,441) if rand(100) < pc1
              action.push(433,434,441,442) if rand(100) < pc2
            end
          elsif @target_battlers[0].futanari?
            #胸の大きさでセットするスキルが異なる
            if $data_SDB[@active_battler.class_id].bust_size < 2
              action = [435,435,443,443,451,451]
              action.push(452) if rand(100) < pc2
            else
              action = [431,431,432,439,439,440,447,447,448]
              action.push(432,432,433,440,440,441,448,448,449) if rand(100) < pc1
              action.push(433,434,441,442,449,450) if rand(100) < pc2
            end
          else
            #胸の大きさでセットするスキルが異なる
            if $data_SDB[@active_battler.class_id].bust_size < 2
              action = [443,443,451,451]
              action.push(452) if rand(100) < pc2
            else
              action = [439,439,440,447,447,448]
              action.push(440,440,441,448,448,449) if rand(100) < pc1
              action.push(441,442,449,450) if rand(100) < pc2
            end
          end
        #======================================================================
        # ●♀攻め
        #======================================================================
        when 285
          $msg.at_type = "♀"
          #♀攻撃は両者裸でないと行わない。また素股以外はホールドなため対♂しかない。
          if @target_battlers[0].boy? or @target_battlers[0].futanari?
            action = [473,473,474,474,474]
            action.push(475) if rand(100) < pc1
            action.push(476) if rand(100) < pc2
          else
            #♀の場合はエラーなので暫定的にフリーアクションとエモーションを使用する
            action = [298,299]
          end
        #======================================================================
        # ●足攻め
        #======================================================================
        when 286
          $msg.at_type = "足"
          #対♂と対♀と対双成でセットするスキルが異なる
          #足攻めは被虐系なので使用条件がやや厳しい
          if @target_battlers[0].boy?
            action = [486,486]
            if @target_battlers[0].nude?
              action.push(487,487,487,488) if rand(100) < pc2
            end
          elsif @target_battlers[0].futanari?
            action = [486,486,496,496]
            if @target_battlers[0].nude?
              action.push(487,487,487,491,491,492,492,497,497,497,488,493,498) if rand(100) < pc2
            end
          else
            action = [496,496]
            if @target_battlers[0].nude?
              action.push(491,491,492,492,493,498,497,497,497) if rand(100) < pc2
            end
          end
        #======================================================================
        # ●愛撫
        #======================================================================
        when 287
          $msg.at_type = "愛撫"
          action = [508,509,510,511,512]
        #======================================================================
        # ●尻尾攻め
        #======================================================================
        when 288
          $msg.at_type = "尻尾"
          #対♂と対♀と対双成でセットするスキルが異なる
          if @target_battlers[0].boy?
            action = [515,515]
#            if @target_battlers[0].nude?
#              action.push(516,516,516,523,536)
#              action.push(518,517) if rand(100) < pc1
#              action.push(519) if rand(100) < pc2
#              action.push(539,540) if rand(100) < pc3 #前立腺刺激は確率が低いが一応行う
#            end
          elsif @target_battlers[0].futanari?
            action = [515,515,523,523,528,528,536,536]
#            if @target_battlers[0].nude?
#              action.push(516,516,516,523,523,524,524,524,529,529,529,537,537,537)
#              action.push(518,517,531) if rand(100) < pc1
#              action.push(519,525,530,531,532) if rand(100) < pc2
#              action.push(541,542) if rand(100) < pc3 #アナル刺激は確率が低いが一応行う
#            end
          else
            action = [523,523,528,528,536,536]
#            if @target_battlers[0].nude?
#              action.push(523,523,524,524,524,529,529,529,537,537,537)
#              action.push(531) if rand(100) < pc1
#              action.push(525,530,531,532) if rand(100) < pc2
#              action.push(541,542) if rand(100) < pc3 #アナル刺激は確率が低いが一応行う
#            end
          end
        #======================================================================
        # ●道具攻め
        #======================================================================
        when 289
          $msg.at_type = "道具"
        #======================================================================
        # ●特殊身体攻め
        #======================================================================
        when 290
          $msg.at_type = "特殊身体"
        #======================================================================
        # ●暴走(状況に応じてランダムでスキルをセットする)
        #======================================================================
        when 296
          $msg.at_type = "暴走行動"
          #--------------------------------------------------------------------
          # 共通部分
          #--------------------------------------------------------------------
          #●必ず空振りを２枠、低威力を２枠入れる
          action = [988,988,987,987]
          #●VPが半分を切っていると燃料切れが多めに入る
          action.push(987) if @active_battler.sp < (@active_battler.maxsp / 2)
          action.push(987,988) if @active_battler.sp < (@active_battler.maxsp / 3)
          action.push(987) if @active_battler.sp < (@active_battler.maxsp / 4)
          #●ホールド状態の動作はエネミー、アクター共通となる
          if @active_battler.holding_now?
            #燃料切れの場合
            if @active_battler.sp < 20
              action.push(987,987,987,987,987,987,987)
            # ♀挿入の場合
            elsif @active_battler.inserting_now?
              action.push(983,983,983,983,983,983) if @active_battler.penis_insert? or @active_battler.dildo_insert? #♂orディルド
              action.push(985,985,985,985,985,985) if @active_battler.vagina_insert? #♀
            # 口挿入の場合
            elsif @active_battler.oralsex_now?
              action.push(983,983,983,983,983,983)
            # 尻挿入の場合
            elsif @active_battler.analsex_now?
              action.push(981,981,981,981,981,981) if @active_battler.dildo_anal_analsex? #Ａディルドは反撃できないため愛撫に
              action.push(983,983,983,983,983,983) if @active_battler.penis_analsex? or @active_battler.dildo_analsex? #♂orディルド
              action.push(985,985,985,985,985,985) if @active_battler.anal_analsex? #Ａ
            # 貝合わせの場合
            elsif @active_battler.shellmatch_now?
              action.push(985,985,985,985,985,985)
            # 騎乗の場合
            elsif @active_battler.riding_now?
              action.push(981,981,981,981,981,981) if @active_battler.mouth_riding? #口
              action.push(985,985,985,985,985,985) if @active_battler.vagina_riding? #♀
            # パイズリの場合
            elsif @active_battler.paizuri_now?
              action.push(981,981,981,981,981,981) if @active_battler.penis_paizuri? #♂は反撃できないため愛撫に
              action.push(985,985,985,985,985,985) if @active_battler.tops_paizuri? #胸
            # クンニの場合
            elsif @active_battler.drawing_now?
              action.push(981,981,981,981,981,981) if @active_battler.vagina_draw? or @active_battler.tentacle_vagina_draw? #♀は反撃できないため愛撫に
              action.push(983,983,983,983,983,983) if @active_battler.mouth_draw? or @active_battler.tentacle_draw? #口or触手
            # 拘束の場合
            elsif @active_battler.binding_now?
              action.push(981,981,981,981,981,981)
            # 触手吸引の場合
            elsif @active_battler.usetentacle_now?
              action.push(981,981,981,981,981,981) if @active_battler.tentacle_penis_absorbing? #♂は反撃できないため愛撫に
              action.push(983,983,983,983,983,983) if @active_battler.tentacle_absorbing? #触手
            #それ以外のホールドの場合
            else
              action.push(981,981,981,981,981,981)
            end
          end
          #--------------------------------------------------------------------
          # アクターが暴走状態の場合(非ホールド状態)
          #--------------------------------------------------------------------
          if @active_battler.is_a?(Game_Actor)
            #●非ホールド状態
            unless @active_battler.holding?
              #自分脱衣は、自分ホールド中不可
              unless @active_battler.nude?
                action.push(4,4) unless @active_battler.holding?
              end
              #対象脱衣は、対象ホールド中不可
              unless @target_battlers[0].full_nude?
                action.push(2,2) unless @target_battlers[0].holding?
              end
              #燃料切れの場合
              if @active_battler.sp < 20
                action.push(987,987,987,987,987,987,987)
              #通常時
              else
                action.push(981,981,981,981,981,981,981)
                #♀挿入
                if @active_battler.boy? or @active_battler.futanari?
                  #対象の♀が空いているならインサート
                  action.push(6,6,6,6,6) if @target_battlers[0].hold.vagina.battler == nil and @target_battlers[0].insertable_nude?
                end
                #ディルド挿入
                if @active_battler.equip_dildo?
                  #対象の♀が空いているならインサート
                  action.push(20,20,20,20,20) if @target_battlers[0].hold.vagina.battler == nil and @target_battlers[0].insertable_nude?
                  #対象の口が空いているならディルドマウス
                  action.push(21,21,21,21,21) if @target_battlers[0].hold.mouth.battler == nil
                end
                #その他ホールド(ロウ君でないなら)
                unless @active_battler.boy?
                  #シェルマッチ
                  if @active_battler.have_ability?("シェルマッチ")
                    action.push(5,5,5,5,5) if @target_battlers[0].hold.vagina.battler == nil and @target_battlers[0].insertable_nude?
                  end
                  #エンブレイス
                  if @active_battler.have_ability?("エンブレイス")
                    action.push(17,17,17,17,17) if @target_battlers[0].hold.tops.battler == nil
                  end
                  #エキサイトビュー
                  if @active_battler.have_ability?("エキサイトビュー")
                    action.push(18,18,18,18,18) if @target_battlers[0].hold.mouth.battler == nil
                  end
                  #ドロウネクター
                  if @active_battler.have_ability?("オーラルセックス")
                    action.push(16,16,16,16,16) if @target_battlers[0].hold.vagina.battler == nil and @target_battlers[0].insertable_nude?
                  end
                  #デモンズドロウ
                  if @active_battler.have_ability?("テンタクルマスタリー")
                    #対象の♀が空いているならデモンズドロウ
                    action.push(26,26,26,26,26) if @target_battlers[0].hold.vagina.battler == nil and @target_battlers[0].insertable_nude?
                  end
                end
              end
            end
          #--------------------------------------------------------------------
          # エネミーが暴走状態の場合
          #--------------------------------------------------------------------
          elsif @active_battler.is_a?(Game_Enemy)
            #●非ホールド状態
            unless @active_battler.holding?
              #自分脱衣は、自分ホールド中不可
              unless @active_battler.nude?
                action.push(251,251) unless @active_battler.holding?
              end
              #対象脱衣は、対象ホールド中不可
              unless @target_battlers[0].full_nude?
                action.push(257,257) unless @target_battlers[0].holding?
              end
              #燃料切れの場合
              if @active_battler.sp < 20
                action.push(987,987,987,987,987,987,987)
              #通常時
              else
                action.push(981,981,981,981,981,981,981)
                # 対主人公専用行動
                if @target_battlers[0].boy?
                  #アクセプト
                  if @active_battler.have_ability?("アクセプト")
                    #対象の♂が空いているならアクセプト
                    action.push(682,682,682,682,682) if @target_battlers[0].hold.penis.battler == nil and @target_battlers[0].insertable_nude?
                  end
                  #オーラルアクセプト
                  if @active_battler.have_ability?("オーラルセックス")
                    action.push(687,687,687,687,687) if @target_battlers[0].hold.penis.battler == nil and @target_battlers[0].insertable_nude?
                  end
                  #ペリスコープ
                  if @active_battler.have_ability?("ペリスコープ")
                    action.push(697,697,697,697,697) if @target_battlers[0].hold.penis.battler == nil and @target_battlers[0].insertable_nude?
                  end
                  #ディルドインバック
                  if @active_battler.have_ability?("イクイップディルド")
                    #対象の尻が空いているならディルドインバック
                    action.push(712,712,712,712,712) if @target_battlers[0].hold.anal.battler == nil and @target_battlers[0].insertable_nude?
                  end
                  #デモンズアブソーブ
                  if @active_battler.have_ability?("テンタクルマスタリー")
                    #対象の♂が空いているならデモンズアブソーブ
                    action.push(717,717,717,717,717) if @target_battlers[0].hold.penis.battler == nil and @target_battlers[0].insertable_nude?
                  end
                end
                # 対パートナー専用行動
                unless @target_battlers[0].boy?
                  #シェルマッチ
                  if @active_battler.have_ability?("シェルマッチ")
                    #対象の♀が空いているならシェルマッチ
                    action.push(683,683,683,683,683) if @target_battlers[0].hold.vagina.battler == nil and @target_battlers[0].insertable_nude?
                  end
                  #ディルド
                  if @active_battler.have_ability?("イクイップディルド")
                    #対象の♀が空いているならディルドインサート
                    action.push(710,710,710,710,710) if @target_battlers[0].hold.vagina.battler == nil and @target_battlers[0].insertable_nude?
                    #対象の口が空いているならディルドインマウス
                    action.push(711,711,711,711,711) if @target_battlers[0].hold.mouth.battler == nil
                  end
                  #ドロウネクター
                  if @active_battler.have_ability?("オーラルセックス")
                    action.push(688,688,688,688,688) if @target_battlers[0].hold.vagina.battler == nil and @target_battlers[0].insertable_nude?
                  end
                  #デモンズドロウ
                  if @active_battler.have_ability?("テンタクルマスタリー")
                    #対象の♀が空いているならデモンズドロウ
                    action.push(718,718,718,718,718) if @target_battlers[0].hold.vagina.battler == nil and @target_battlers[0].insertable_nude?
                  end
                end
                #その他ホールド(ロウ君でないなら)
                #エンブレイス
                if @active_battler.have_ability?("エンブレイス")
                  action.push(695,695,695,695,695) if @target_battlers[0].hold.tops.battler == nil
                end
                #エキサイトビュー
                if @active_battler.have_ability?("エキサイトビュー")
                  action.push(684,684,684,684,684) if @target_battlers[0].hold.mouth.battler == nil
                end
                # 習得していないホールドは削除
                action = hold_action_select(action)
              end
            end
          end
        #======================================================================
        # ●ホールド
        #(夢魔個体別にスキルをセット[$data_SDB]、性格別に参照[$data_personality])
        #======================================================================
        when 292
          rate = $data_SDB[@active_battler.class_id].hold_rate
          sp = $data_personality[@active_battler.personality].special_attack
          if 15 <= $mood.point
            action.push(*rate[0])
          end
          if sp[0] <= $mood.point
            action.push(*rate[1]) if rate[1] != nil
          end
          if sp[1] <= $mood.point
            action.push(*rate[2]) if rate[2] != nil
          end
          if sp[2] <= $mood.point
            action.push(*rate[3]) if rate[3] != nil
          end
#          if 100 <= $mood.point
#            action.push(*rate[4]) if rate[4] != nil
#          end
          n = 0
          for i in $game_troop.enemies
            if i.exist?
              n += 1
            end
          end
          if n < 2 and action.include?(695)
            action.delete(695)
            action.delete(696)
          end
          if action == []
#            action.push(251) unless @active_battler.nude?
            action.push(257) unless @target_battlers[0].nude?
            action.push(298) if action == []
          end
          # 習得していないホールドは削除
                action = hold_action_select(action)
=begin
          action.delete(682) unless @active_battler.have_ability?("アクセプト")
          action.delete(683) unless @active_battler.have_ability?("シェルマッチ")
          action.delete(684) unless @active_battler.have_ability?("エキサイトビュー")
          action.delete(687) unless @active_battler.have_ability?("オーラルセックス")
          action.delete(688) unless @active_battler.have_ability?("オーラルセックス")
          action.delete(689) unless @active_battler.have_ability?("フラッタナイズ")
          action.delete(691) unless @active_battler.have_ability?("トレインドホール")
          action.delete(692) unless @active_battler.have_ability?("トレインドホール")
          action.delete(695) unless @active_battler.have_ability?("エンブレイス")
          action.delete(697) unless @active_battler.have_ability?("ペリスコープ")
          action.delete(698) unless @active_battler.have_ability?("ヘブンリーフィール")
          action.delete(700) unless @active_battler.have_ability?("アンドロギュヌス")
          action.delete(701) unless @active_battler.have_ability?("アンドロギュヌス")
          action.delete(705) unless @active_battler.have_ability?("テイルマスタリー")
          action.delete(706) unless @active_battler.have_ability?("テイルマスタリー")
          
          action.delete(710) unless @active_battler.have_ability?("イクイップディルド")
          action.delete(711) unless @active_battler.have_ability?("イクイップディルド")
          action.delete(718) unless @active_battler.have_ability?("テンタクルマスタリー")
          unless @active_battler.have_ability?("アヌスマーキング")
            action.delete(702) unless @active_battler.have_ability?("アンドロギュヌス")
            action.delete(707) unless @active_battler.have_ability?("テイルマスタリー")
            action.delete(712) unless @active_battler.have_ability?("イクイップディルド")
#            action.delete(717) unless @active_battler.have_ability?("テンタクルマスタリー")
          end
          unless @active_battler.have_ability?("バインドマスタリー")
            action.delete(696) unless @active_battler.have_ability?("エンブレイス")
#            action.delete(719) unless @active_battler.have_ability?("テンタクルマスタリー")
          end
=end
        #======================================================================
        # ●自分ホールド中の攻撃(複数個所ホールドされている場合も加味して全て条件を確認する)
        #======================================================================
        when 293
          if @active_battler.holding?
            $msg.at_type = "ホールド攻撃"
            action = []
            #アソコでインサート状態(グラインド系) 〆
            if @active_battler.vagina_insert? and @target_battlers[0].penis_insert?
              if @target_battlers[0].hold.initiative_level < 3
                action.push(751,751,752,752,752)
                action.push(753) if rand(100) < pc1
                action.push(753,754) if rand(100) < pc2
                # イニシアチブ最大且つ【吸精】持ちの場合、エナジードレインを使用
                if @active_battler.hold.initiative_level == 3 and
                 @active_battler.have_ability?("吸精")
                  action.push(772,772,772,772,772)
                  # ヘイト達成時はレベルドレインも使用
                  if $game_switches[145]
                    action.push(773,773,773,773,773)
                  end
                end
              else
                action.push(755,755,755)
                action.push(755,756) if rand(100) < pc1
                action.push(756) if rand(100) < pc2
              end
            end
            #シェルマッチ状態(スクラッチ系) 〆
            if @active_battler.shellmatch? and @target_battlers[0].shellmatch?
              if @active_battler.initiative?
                action.push(760,760,761,761,761)
                action.push(762) if rand(100) < pc1
                action.push(762,763) if rand(100) < pc2
              else
                action.push(760,760,760)
                action.push(761,761) if rand(100) < pc1
                action.push(762) if rand(100) < pc2
              end
            end
            #騎乗状態(ライディング系) 〆
            if @active_battler.vagina_riding? and @target_battlers[0].mouth_riding?
              #アソコ騎乗状態は有利な場合しか存在しない
              action.push(766,766,766,767,767)
              action.push(767,767,768) if rand(100) < pc1
              action.push(768) if rand(100) < pc2
            end
            #被騎乗状態(ライディング系を使われた場合) 〆
            if @active_battler.mouth_riding? and @target_battlers[0].vagina_riding?
              #被騎乗状態は不利な場合しか存在しない
              action.push(942,942,942)
              #胸揉み、尻揉みは上半身封印されてなければ使う
#下の「インサート、シェルマッチ状態以外は基本反撃系スキルを全部入れる」に追加
#              action.push(944,944,945) unless @active_battler.tops_binding?
            end
            #フェラチオ状態(フェラチオ系)
            if @active_battler.mouth_oralsex? and @target_battlers[0].penis_oralsex?
              if @active_battler.initiative?
                action.push(788,788,789,789,789)
                action.push(790) if rand(100) < pc1
                action.push(790,791) if rand(100) < pc2
              else
                action.push(792,792,792)
                action.push(792,793) if rand(100) < pc1
                action.push(793) if rand(100) < pc2
              end
            end
            #クンニ状態 〆
            if @active_battler.mouth_draw? and @target_battlers[0].vagina_draw?
              #クンニ状態は有利な場合しか存在しない
              action.push(797,797,797,798,798)
              action.push(798,798,799) if rand(100) < pc1
              action.push(799,800) if rand(100) < pc2
            end
            #被クンニ状態 〆
            if @active_battler.vagina_draw? and @target_battlers[0].mouth_draw?
              #被クンニ状態は有利な場合しか存在しない
              action.push(948,948,948,948,948)
            end
            #キッス状態
            if @active_battler.deepkiss? and @target_battlers[0].deepkiss?
              action.push(803,803,803,804,804)
              action.push(804,805,805) if rand(100) < pc1
              action.push(805,806) if rand(100) < pc2
            end
            #アナルセックス状態(スクイーズ系)
            if @active_battler.anal_analsex? and @target_battlers[0].penis_analsex?
              if @active_battler.initiative?
                action.push(810,810,811,811,811)
                action.push(812) if rand(100) < pc1
                action.push(812,813) if rand(100) < pc2
              else
                action.push(810,810,810)
                action.push(811,811) if rand(100) < pc1
                action.push(812) if rand(100) < pc2
              end
            end
            #拘束状態
            if @active_battler.tops_binder? and @target_battlers[0].tops_binding?
              #拘束状態は有利な場合しか存在しない
              action.push(828,828,828)
              action.push(828,829,829) if rand(100) < pc1
            end
            #被拘束状態
            if @active_battler.tops_binding? and @target_battlers[0].tops_binder?
              #拘束状態は有利な場合しか存在しない
              action.push(828,828,828)
              action.push(828,829,829) if rand(100) < pc1
            end
            #パイズリ状態
            if @active_battler.tops_paizuri? and @target_battlers[0].penis_paizuri?
              #パイズリ状態は有利な場合しか存在しない
              action.push(836,836,836,837,837)
              action.push(837,838) if rand(100) < pc1
              action.push(838,839) if rand(100) < pc2
            end
            #ぱふぱふ状態
            if @active_battler.tops_pahupahu? and @target_battlers[0].mouth_pahupahu?
              #ぱふぱふ状態は有利な場合しか存在しない
              action.push(842,842,842,843,843)
              action.push(843,844) if rand(100) < pc1
              action.push(844,845) if rand(100) < pc2
            end
            #ディルドインサート状態
            if @active_battler.dildo_insert? and @target_battlers[0].dildo_vagina_insert?
              action.push(891,891,891,892,892)
              action.push(892,892) if rand(100) < pc1
              action.push(892,893) if rand(100) < pc2
            end
            #ディルドインマウス状態
            if @active_battler.dildo_oralsex? and @target_battlers[0].dildo_mouth_oralsex?
              action.push(896,896,896,897,897)
              action.push(897,897) if rand(100) < pc1
              action.push(897,898) if rand(100) < pc2
            end
            #ディルドインバック状態
            if @active_battler.dildo_analsex? and @target_battlers[0].dildo_anal_analsex?
              action.push(901,901,901,902,902)
              action.push(902,902) if rand(100) < pc1
              action.push(902,903) if rand(100) < pc2
            end
            #デモンズアブソーブ状態
            if @active_battler.tentacle_absorbing? and @target_battlers[0].tentacle_penis_absorbing?
              action.push(733,733,733,734,734)
              action.push(734,735) if rand(100) < pc1
              action.push(735,736) if rand(100) < pc2
            end
            #デモンズドロウ状態
            if @active_battler.tentacle_draw? and @target_battlers[0].tentacle_vagina_draw?
              action.push(738,738,738,739,739)
              action.push(739,740) if rand(100) < pc1
              action.push(740,741) if rand(100) < pc2
            end
            # インサート、シェルマッチ状態以外は基本反撃系スキルを全部入れる
            # 反転無し系はもがくを入れる
            if @active_battler.can_struggle? and @active_battler.target_hold?(@target_battlers[0])
                action.push(947) #キス反撃
              # 胸に手が届くもの
              if @active_battler.can_reach_bust?(@target_battlers[0])
                action.push(944) #胸揉み
              end
              # 秘部に手が届くもの
              if @active_battler.can_reach_secret?(@target_battlers[0])
                action.push(949) #アソコ攻め反撃
                action.push(950) #陰核攻め反撃
                action.push(951) #ペニス攻め反撃
                action.push(952) #睾丸攻め反撃
              end
              # 尻に手が届くもの
              if @active_battler.can_reach_hip?(@target_battlers[0])
                action.push(945) #尻揉み
              end
              #action.push(953,954) #擦り付け系。対応ホールドが無いため没
              action.push(971) # もがく
            end
#            if action == []
#              #エラー対応時は観察になる
#              action = [968]
#            end
#          else
#            #エラー対応時は観察になる
#            action = [968]
          end
        #======================================================================
        # ●自分除く味方がホールド中の行動
        #======================================================================
        when 294
          $msg.at_type = "ホールド援護"
          #性格単位でセットするIDが変更される場合がある
          #at:ホールド中の味方を攻めて高揚させる  on：自慰を始める
          at = on = 0
          case @active_battler.personality
          when "好色","陽気"
            at += $mood.point
            on += ($mood.point / 2)
          when "上品","柔和","高慢","淡泊"
            at += ($mood.point / 2) if $mood.point > 49
            on += ($mood.point / 2) if @active_battler.excited?
          when "勝ち気","意地悪","甘え性"
            at += $mood.point
            on += $mood.point if @active_battler.excited?
          when "内気"
            at += $mood.point if @active_battler.excited? and $mood.point > 49
            on += $mood.point if @active_battler.excited? or $mood.point > 49
          when "天然"
            at += $mood.point
            on += $mood.point
          when "従順"
            at += $mood.point
            at += $mood.point if @active_battler.excited? and $mood.point > 49
          when "虚勢"
            at += $mood.point if $mood.point < 50
            on += $mood.point if @active_battler.excited?
          when "倒錯"
            at += $mood.point * 2
            on += $mood.point * 2
          when "不思議"
            at += rand($mood.point)
            on += rand($mood.point)
          #ボスなど例外の性格
          else
            at += $mood.point if @active_battler.excited?
            on += $mood.point if @active_battler.excited?
          end
          #自分がホールド中の場合は行わない
          unless @active_battler.holding?
            #ターゲットがホールド状態ならホールド専用の攻めを行う
            if @target_battlers[0].holding?
              action = [956,956,968]
              if @target_battlers[0].boy? or @target_battlers[0].futanari?
                action.push(962,962,963) if @target_battlers[0].hold.penis.battler == nil
                action.push(963,958) if @target_battlers[0].hold.penis.type == "口挿入"
              end
              if @target_battlers[0].girl?
                action.push(957,957) if @target_battlers[0].hold.tops.battler == nil
                action.push(958,958) if @target_battlers[0].hold.anal.battler == nil
                action.push(959) if rand(100) < pc3 and @target_battlers[0].hold.anal.battler == nil
                action.push(960,960) if @target_battlers[0].hold.vagina.battler == nil
                action.push(961) if @target_battlers[0].nude?
              end
              action.push(967)if at > rand(100)
              action.push(969)if on > rand(100)
            #ターゲットがホールド状態でない(自分と共に観客状態)なら状況によってランダムに行動を取る
            else
              action = [968,968,968] #観察
#              action.push(251,251,251) unless @active_battler.nude? #自分脱衣
              action.push(257,257,257) unless @target_battlers[0].nude? #相手脱衣
              action.push(967)if at > rand(100) #味方攻め
              action.push(969)if on > rand(100) #自慰
            end
          end
        end
        if count >= 1
          if action != []
            for i in action.clone
              if not @active_battler.skill_can_use?(i)
                action -= [i]
              end
            end
          end
          # カウントが１以上且つ、アクションが無い場合、
          # それは両方のアクターに使用できないものである。
          # そのため、使用条件の無い別のアクションを入れる。
          if action == []
            # ２割で無害アクション
            if 20 > rand(100)
              # エモーション
              action = [299]
              # ターゲットがホールド中は見学・実況
              action = [968] if @target_battlers[0].holding?
              # 自分がホールド中且つ、ムード乱数で自慰
              action = [969] if @active_battler.holding? and $mood.point < rand(120)
              # 自分が上半身拘束、触手拘束を受けている場合は見学・実況
              action = [968] if @active_battler.tops_binding? or @active_battler.tentacle_binding?
              #行動エネミーのVPが怪しい場合、回復を入れる
              action = [970] if @active_battler.holding? and @active_battler.sp < (@active_battler.maxsp / 5).floor
            else
              # 決め直し指示
              action = [279]
            end
          end
          break
        elsif count == 0
          if action != []
            for i in action.clone
              if not @active_battler.skill_can_use?(i)
                action -= [i]
              end
            end
          end
          # カウントが０且つ、アクションが無い場合、
          # 別のアクターをターゲットにして確認する。
          if action == []
            count += 1
            if @target_battlers[0] == $game_actors[101]
              for actor in $game_party.actors
                if actor.exist? and actor != $game_actors[101]
                  @target_battlers[0] = actor
                  $game_temp.battle_target_battler[0] = actor
                end
              end
            else
              @target_battlers[0] = $game_actors[101]
              $game_temp.battle_target_battler[0] = $game_actors[101]
            end
            next
          else
            break
          end
        end
      end
    end
    # 全アクションを確認し、使用できないものをすべて外す
    for i in action
      action.delete(i) unless @active_battler.skill_can_use?(i)
    end
    

    # アクションが無い場合、エモーションに
    if action == []
      # エモーション
      action = [299]
    end
   
    
    @active_battler.current_action.skill_id = action[rand(action.size)]
    attack_element_check
    # ★スキル使用
    @skill = $data_skills[@active_battler.current_action.skill_id]
    @active_battler.current_action.kind = 1
    if @skill.scope == 7 #自分に行うもの
      $game_temp.attack_combo_target = @active_battler
      @target_battlers = []
      @target_battlers.push($game_temp.attack_combo_target)
      # ★ターゲットバトラーの情報を記憶
      $game_temp.battle_target_battler = @target_battlers
    elsif @skill.scope == 3 #味方単体に行うもの
      if @skill.id == 967
        bx = []
        for enemy in $game_troop.enemies
          if enemy.exist? and enemy != @active_battler and enemy.holding?
            bx.push(enemy)
          end
        end
        $game_temp.attack_combo_target = bx[rand(bx.size)] if bx != []
      else
        bx = []
        for enemy in $game_troop.enemies
          if enemy.exist? and enemy != @active_battler
            bx.push(enemy)
          end
        end
        $game_temp.attack_combo_target = bx[rand(bx.size)] if bx != []
      end
      @target_battlers = []
      @target_battlers.push($game_temp.attack_combo_target)
      # ★ターゲットバトラーの情報を記憶
      $game_temp.battle_target_battler = @target_battlers
    end
    if @active_battler.is_a?(Game_Enemy)
      @active_battler.current_action.decide_random_target_for_enemy
    elsif  @active_battler.is_a?(Game_Actor)
      @active_battler.current_action.decide_random_target_for_actor
    end
    $game_temp.battle_target_battler = @target_battlers
    # ●記憶したスキルを解除
    $game_temp.skill_selection = nil
  end
  #--------------------------------------------------------------------------
  # ★ 攻撃スキルの属性チェック(追撃、絶頂口上制御に使用)
  #--------------------------------------------------------------------------
  def attack_element_check
    #エラー落ち対策(@0830)
    return if @active_battler == nil
    return if $data_skills[@active_battler.current_action.skill_id].name == ""
#    p "#{@active_battler.name}／#{@active_battler.current_action.skill_id}" if $DEBUG
    # ★追撃用に、スキルidから攻撃部位を確認
    sid = $data_skills[@active_battler.current_action.skill_id]
    #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
    #アクター側はランダムスキル選定時のtype指定をしていないのでここで設定
    if @active_battler.is_a?(Game_Actor)
      $msg.at_type = sid.name
    end
    #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
    #♀挿入攻撃：ペニス側
    if sid.element_set.include?(142)
      $msg.at_parts = "♀挿入：ペニス側"
    #口挿入攻撃：ペニス側
    elsif sid.element_set.include?(143)
      $msg.at_parts = "口挿入：ペニス側"
    #尻挿入攻撃：ペニス側
    elsif sid.element_set.include?(144)
      $msg.at_parts = "尻挿入：ペニス側"
    #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
    #口挿入攻撃：口側
    elsif sid.element_set.include?(148)
      $msg.at_parts = "口挿入：口側"
    #顔面騎乗攻撃：口側
    elsif sid.element_set.include?(149)
      $msg.at_parts = "騎乗：口側"
    #尻騎乗攻撃：口側
    elsif sid.element_set.include?(145)
      $msg.at_parts = "尻騎乗：口側"
    #クンニ攻撃：口側
    elsif sid.element_set.include?(150)
      $msg.at_parts = "クンニ"
    #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
    #尻挿入攻撃：尻側
    elsif sid.element_set.include?(153)
      $msg.at_parts = "尻挿入：尻側"
    #尻騎乗攻撃：尻側
    elsif sid.element_set.include?(154)
      $msg.at_parts = "尻騎乗：尻側"
    #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
    #♀挿入攻撃：♀側
    elsif sid.element_set.include?(157)
      $msg.at_parts = "♀挿入：アソコ側"
    #顔面騎乗攻撃：♀側
    elsif sid.element_set.include?(158)
      $msg.at_parts = "騎乗：アソコ側"
    #貝合わせ攻撃
    elsif sid.element_set.include?(159)
      $msg.at_parts = "貝合わせ"
    #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
    #パイズリ攻撃
    elsif sid.element_set.include?(160)
      $msg.at_parts = "パイズリ"
    #背面拘束中攻撃
    elsif sid.element_set.include?(163)
      $msg.at_parts = "背面拘束"
    #開脚拘束中攻撃
    elsif sid.element_set.include?(164)
      $msg.at_parts = "開脚拘束"
    #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
    #尻尾♀挿入攻撃
    elsif sid.element_set.include?(167)
      $msg.at_parts = "尻尾♀挿入"
    #尻尾口挿入攻撃
    elsif sid.element_set.include?(168)
      $msg.at_parts = "尻尾口挿入"
    #尻尾尻挿入攻撃
    elsif sid.element_set.include?(169)
      $msg.at_parts = "尻尾尻挿入"
    #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
    #触手♀挿入攻撃
    elsif sid.element_set.include?(172)
      $msg.at_parts = "触手♀挿入"
    #触手口挿入攻撃
    elsif sid.element_set.include?(173)
      $msg.at_parts = "触手口挿入"
    #触手尻挿入攻撃
    elsif sid.element_set.include?(174)
      $msg.at_parts = "触手尻挿入"
    #触手拘束中攻撃
    elsif sid.element_set.include?(175)
      $msg.at_parts = "触手拘束"
    #触手拘束中攻撃
    elsif sid.element_set.include?(176)
      $msg.at_parts = "触手開脚拘束"
    #ディルド♀挿入攻撃
    elsif sid.element_set.include?(183)
      $msg.at_parts = "ディルド♀挿入"
    #ディルド口挿入攻撃
    elsif sid.element_set.include?(184)
      $msg.at_parts = "ディルド口挿入"
    #ディルド尻挿入攻撃
    elsif sid.element_set.include?(185)
      $msg.at_parts = "ディルド尻挿入"
    #触手♂吸引攻撃
    elsif sid.element_set.include?(186)
      $msg.at_parts = "触手♂吸引"
    #触手♀クンニ攻撃
    elsif sid.element_set.include?(187)
      $msg.at_parts = "触手♀吸引"
    #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
    #鞭使用の攻撃
    elsif sid.element_set.include?(85)
      $msg.at_parts = "使用：鞭"
    #縛り使用の攻撃
    elsif sid.element_set.include?(86)
      $msg.at_parts = "使用：緊縛"
    #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
    #口対象の攻撃
    elsif sid.element_set.include?(91)
      $msg.at_parts = "対象：口"
    #胸、乳首対象の攻撃
    elsif sid.element_set.include?(92)
      $msg.at_parts = "対象：胸"
    #尻対象の攻撃
    elsif sid.element_set.include?(93)
      $msg.at_parts = "対象：尻"
    #アナル対象の攻撃
    elsif sid.element_set.include?(94)
      $msg.at_parts = "対象：アナル"
    #ペニス対象の攻撃
    elsif sid.element_set.include?(95)
      $msg.at_parts = "対象：ペニス"
    #睾丸対象の攻撃
    elsif sid.element_set.include?(96)
      $msg.at_parts = "対象：睾丸"
    #アソコ対象の攻撃
    elsif sid.element_set.include?(97)
      $msg.at_parts = "対象：アソコ"
    #陰核対象の攻撃
    elsif sid.element_set.include?(98)
      $msg.at_parts = "対象：陰核"
    #その他部位が対象の攻撃
    elsif sid.element_set.include?(99)
      $msg.at_parts = "対象：その他身体"
    #視覚対象の攻撃
    elsif sid.element_set.include?(100)
      $msg.at_parts = "対象：視覚"
    #聴覚対象の攻撃
    elsif sid.element_set.include?(101)
      $msg.at_parts = "対象：聴覚"
    end
    #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
    #暴走行動時は必ず「その他身体」に対象がセットされるため、
    #属性付与を含めて再装填する
    sid.element_set.delete(99) if sid.element_set.include?(99)#身体
    if $msg.at_type == "暴走行動"
      case sid.id
      #暴走愛撫(VP切れ時も含む)
      when 981,982,987
        parts = []
        if @target_battlers[0].hold.mouth.battler == nil or @target_battlers[0].hold.mouth.battler == @active_battler
          parts.push("対象：口","対象：口")
        end
        if @target_battlers[0].hold.tops.battler == nil or @target_battlers[0].hold.tops.battler == @active_battler
          parts.push("対象：胸","対象：胸")
        end
        if @target_battlers[0].hold.anal.battler == nil or @target_battlers[0].hold.anal.battler == @active_battler
          parts.push("対象：尻","対象：尻")
        end
        if @target_battlers[0].girl? or @target_battlers[0].futanari?
          if @target_battlers[0].hold.vagina.battler == nil or @target_battlers[0].hold.vagina.battler == @active_battler
            parts.push("対象：アソコ","対象：アソコ")
          end
        end
        if @target_battlers[0].boy? or @target_battlers[0].futanari?
          if @target_battlers[0].hold.penis.battler == nil or @target_battlers[0].hold.penis.battler == @active_battler
            parts.push("対象：ペニス","対象：ペニス")
          end
        end
        #攻撃部位決定
        if parts == []
          $msg.at_parts = "対象：その他身体"
        else
          parts = parts[rand(parts.size)]
        end
        #属性装填(既に決定されている場合は別)
        unless $msg.at_parts == "対象：その他身体"
          $msg.at_parts = parts
          case parts
          when "対象：口"
            sid.element_set.push(91)
          when "対象：胸"
            sid.element_set.push(92)
          when "対象：尻"
            sid.element_set.push(93)
          when "対象：アソコ"
            sid.element_set.push(97)
          when "対象：ペニス"
            sid.element_set.push(95)
          end
        end
      #暴走ピストン・グラインド
      when 983,984,985,986
        sid.element_set.delete(80) if sid.element_set.include?(80)#身体使用
        #ペニス系
        if @active_battler.penis_insert?
          $msg.at_parts = "♀挿入：ペニス側"
          sid.element_set.push(74,97)
        elsif @active_battler.penis_oralsex?
          $msg.at_parts = "口挿入：ペニス側"
          sid.element_set.push(74,91)
        elsif @active_battler.mouth_oralsex?
          $msg.at_parts = "口挿入：口側"
          sid.element_set.push(72,91)
        elsif @active_battler.penis_analsex?
          $msg.at_parts = "尻挿入：ペニス側"
          sid.element_set.push(74,94)
        #尻尾系
        elsif @active_battler.tail_insert?
          $msg.at_parts = "尻尾♀挿入"
          sid.element_set.push(78,97)
        elsif @active_battler.tail_oralsex?
          $msg.at_parts = "尻尾口挿入"
          sid.element_set.push(78,91)
        elsif @active_battler.tail_analsex?
          $msg.at_parts = "尻尾尻挿入"
          sid.element_set.push(78,94)
        #触手系
        elsif @active_battler.tentacle_insert?
          $msg.at_parts = "触手♀挿入"
          sid.element_set.push(79,97)
        elsif @active_battler.tentacle_oralsex?
          $msg.at_parts = "触手口挿入"
          sid.element_set.push(79,91)
        elsif @active_battler.tentacle_analsex?
          $msg.at_parts = "触手尻挿入"
          sid.element_set.push(79,94)
        #ディルド系
        elsif @active_battler.dildo_insert?
          $msg.at_parts = "ディルド♀挿入"
          sid.element_set.push(81,97)
        elsif @active_battler.dildo_oralsex?
          $msg.at_parts = "ディルド口挿入"
          sid.element_set.push(81,91)
        elsif @active_battler.dildo_analsex?
          $msg.at_parts = "ディルド尻挿入"
          sid.element_set.push(81,94)
        #その他
        elsif @active_battler.mouth_draw?
          $msg.at_parts = "クンニ"
          sid.element_set.push(72,97,98)
        elsif @active_battler.mouth_riding?
          $msg.at_parts = "騎乗：口側"
          sid.element_set.push(75,91)
        elsif @active_battler.mouth_hipriding?
          $msg.at_parts = "尻騎乗：口側"
          sid.element_set.push(76,91)
        elsif @active_battler.tops_paizuri?
          $msg.at_parts = "パイズリ"
          sid.element_set.push(73,95)
        elsif @active_battler.tentacle_absorb?
          $msg.at_parts = "触手♂吸引"
          sid.element_set.push(79,95)
        elsif @active_battler.tentacle_draw?
          $msg.at_parts = "触手♀吸引"
          sid.element_set.push(79,97,98)
        elsif @active_battler.vagina_insert?
          $msg.at_parts = "♀挿入：アソコ側"
          sid.element_set.push(75,95)
        elsif @active_battler.vagina_riding?
          $msg.at_parts = "騎乗：アソコ側"
          sid.element_set.push(75,91)
        elsif @active_battler.shellmatch?
          $msg.at_parts = "貝合わせ"
          sid.element_set.push(75,97)
        elsif @active_battler.anal_analsex?
          $msg.at_parts = "尻挿入：尻側"
          sid.element_set.push(76,95)
        elsif @active_battler.anal_hipriding?
          $msg.at_parts = "尻騎乗：尻側"
          sid.element_set.push(76,91)
        end
      end
    end
  end
  
  
end