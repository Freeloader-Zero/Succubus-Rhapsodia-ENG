#==============================================================================
# ■ Talk_Sys(分割定義 5)
#------------------------------------------------------------------------------
#   夢魔の口上を検索、表示するためのクラスです。
#   このクラスのインスタンスは $msg で参照されます。
#   ここではトーク時のシチュエーションごとのテキストを設定します
#==============================================================================
class Talk_Sys
  #============================================================================
  # ●トーク中のテキスト設定(口上表示前のテキスト)
  #============================================================================
  def make_text_aftertalk
    speaker = $msg.t_enemy.name #会話中のエネミー名
    master = $game_actors[101].name #主人公名
    #存在するなら、パートナー名
    if $msg.t_partner != nil
      servant = $msg.t_partner.name
    else
      servant = nil
    end
    m = ""
    case $msg.tag
    #==============================================================================
    # ●会話不成立時
    #==============================================================================
    when "不成立"
      case $msg.at_type
      when "夢魔クライシス"
        m = "#{speaker}は快感に溺れている……！\m\n今は話が出来る状態ではない……！"
      when "主人公クライシス"
        m = "#{speaker}は笑みを浮かべている……！\m\n今は話を聞いてもらえそうにない……！"
      when "夢魔絶頂中"
        m = "#{speaker}は快感に身悶えしている……！\m\n今は話が出来る状態ではない……"
      when "試行過多"
        m = "#{speaker}はどうやら、\m\nこれ以上話を聞いてくれそうにない……"
      when "夢魔恍惚中"
        m = "#{speaker}は放心している……！\m\n今は話が出来る状態ではない……！"
        m = "#{speaker}は意味深な笑みを浮かべている……！\m\n今は話を聞いてもらえそうにない……！" if $msg.t_enemy.holding?
      when "夢魔暴走中"
        m = "#{speaker}は極度に興奮している……！\m\n今は話が出来る状態ではない……！"
      end
    #==============================================================================
    # ●主人公脱衣
    #==============================================================================
    when "主人公脱衣"
      case $msg.talk_step
      when 2 #脱衣を受け入れた場合
        m = "#{master}は#{speaker}の言う通りに、\m\n自ら服を脱いだ！"
      when 77 #脱衣を拒否した場合
        m = "#{master}は思いとどまった！"
      end
    #==============================================================================
    # ●仲間脱衣
    #==============================================================================
    when "仲間脱衣"
      case $msg.talk_step
      when 2 #仲間の脱衣を受け入れた場合
        m = "#{master}は#{speaker}の言う通りに、\m\n#{servant}の服を脱がせた！"
      when 77 #仲間の脱衣を拒否した場合
        m = "#{master}は要求を断った！"
      end
    #==============================================================================
    # ●夢魔脱衣
    #==============================================================================
    when "夢魔脱衣"
      case $msg.talk_step
      when 2 #脱衣を見続けた場合
        m = "#{master}は言う通りに、\m\n#{speaker}の脱ぐ様子を見続けた！"
        m = "#{master}は思わず、\m\n#{speaker}の脱ぐ様子を見続けてしまった！" if $data_SDB[$msg.t_enemy.class_id].name == "キャスト"
        m = "#{master}は食い入るように、\m\n#{speaker}の脱ぐ様子を見続けた！" if $game_actors[101].state?(35)
      when 77 #脱衣を見なかった場合
        m = "#{master}は思いとどまり、\m\n#{speaker}から目を逸らした！"
      end
    #==============================================================================
    # ●吸精・口
    #==============================================================================
    when "吸精・口"
      case $msg.talk_step
      when 2 #吸精を受け入れた場合
        m = "#{master}は#{speaker}に唇を奪われた！\m\n#{master}の身体から力が抜けていく……！"
      when 77 #吸精を拒否した場合
        m = "#{master}は要求を断った！"
      end
    #==============================================================================
    # ●吸精・性器
    #==============================================================================
    when "吸精・性器"
      case $msg.talk_step
      when 2 #吸精を受け入れた場合
        m = "#{speaker}は、\m\n#{master}のペニスにしゃぶりついた！\m\n快感と共に、#{master}の身体から力が抜ける……！"
      when 77 #吸精を拒否した場合
        m = "#{master}は要求を断った！"
      end
    #==============================================================================
    # ●好意
    #==============================================================================
    when "好意"
      m = "#{speaker}は満更でもないようだ……！"
    #==============================================================================
    # ●視姦
    #==============================================================================
    when "視姦"
      case $msg.talk_step
      when 77 #視姦を最初から見なかった場合
        m = "#{master}は誘惑に負けず、\m\n#{speaker}から目を逸らした！"
      when 78 #視姦を途中で断った場合
        m = "#{master}は何とか意思を振り絞り、\m\n#{speaker}から目を逸らした！"
      when 79 #視姦しすぎて暴走した場合
        m = "#{master}は目の前で繰り広げられる、\m\n#{speaker}の痴態から目を逸らすことができない！"
      #継続している場合
      else
        m = "#{speaker}は、\m\n自らの身体を慰めている……！"
        emotion = ""
        case $msg.t_enemy.personality
        when "意地悪","虚勢","倒錯"
          emotion = "思わせぶりな表情で"
          emotion = "#{master}の間近で" if rand($mood.point) > 50
        when "好色","高慢","陽気","柔和","勝ち気"
          emotion = "注がれる視線を楽しむように"
          emotion = "#{master}に見えるように" if rand($mood.point) > 50
        when "淡泊","従順","甘え性","不思議"
          emotion = "行為に没頭するかのように"
          emotion = "#{master}の視線を感じつつ" if rand($mood.point) > 50
        when "内気","上品","天然"
          emotion = "恥ずかしげに顔を背けつつも"
          emotion = "顔を紅潮させつつ" if rand($mood.point) > 50
        end
        #テキスト整形(口、尻系は現在は封印のため、他部位に割り振り)
        case $msg.at_parts
        #胸や乳首で自慰
        when "対象：胸","対象：口"
          if $data_SDB[$msg.t_enemy.class_id].bust_size < 3
            m = "#{speaker}は#{emotion}、\m\n自分の#{$msg.t_enemy.bustsize}を手で撫で回している！"
            m = "#{speaker}は#{emotion}、\m\n自分の乳首を指でこね回している！" if rand($mood.point) > 50
          else
            m = "#{speaker}は#{emotion}、\m\n自分の#{$msg.t_enemy.bustsize}を揉みしだいている！"
            m = "#{speaker}は#{emotion}、\m\n自分の乳首を指でこね回している！" if rand($mood.point) > 50
          end
        #アソコに指入れで自慰
        when "対象：アソコ","対象：尻"
          m = "#{speaker}は#{emotion}、\m\nアソコに指を抜き挿ししている！"
          m = "#{speaker}は#{emotion}、\m\n指でアソコをかき回している！" if rand($mood.point) > 50
        #陰核を弄って自慰
        when "対象：陰核","対象：アナル"
          m = "#{speaker}は#{emotion}、\m\n自分の陰核を指で慰めている！"
          m = "#{speaker}は#{emotion}、\m\n指で陰核を擦り上げている！" if rand($mood.point) > 50
        end
      end
    #==============================================================================
    # ●奉仕
    #==============================================================================
    when "奉仕"
      case $msg.talk_step
      when 77 #視姦を最初から見なかった場合
        m = "#{master}は誘惑に負けず、\m\n#{speaker}の要求を断った！"
        m = "#{master}は後ろ髪を引かれる思いで、\m\n何とか#{speaker}の要求を断った！" if $game_actors[101].state?(35)
      when 78 #視姦を途中で断った場合
        m = "#{master}は何とか意思を振り絞り、\m\n#{speaker}への奉仕の手を止めた！"
      when 79 #視姦しすぎて暴走した場合
        m = "#{master}は熱に浮かされたように、#{speaker}への奉仕を続けている……！"
      #継続している場合
      else
        m = "#{master}は#{speaker}を愛撫した！"
        action = ""
        action = "更に" if $msg.talk_step > 3
        action = "続けて"if $msg.chain_attack == true and $msg.talk_step > 3
        action = "誘われるがままに" if $game_switches[89] == true
        #テキスト整形
        case $msg.at_parts
        #キッスで奉仕
        when "対象：口"
          m = "#{master}は#{action}、\m\n#{speaker}と口内で舌を絡めあった！"
        #胸や乳首に奉仕
        when "対象：胸"
          if $data_SDB[$msg.t_enemy.class_id].bust_size < 3
            m = "#{master}は#{action}、\m\n#{speaker}の#{$msg.t_enemy.bustsize}を揉みしだいた！"
            m = "#{master}は#{action}、\m\n#{speaker}の#{$msg.t_enemy.bustsize}を舌で舐め回した！" if $game_variables[17] > 50 
          else
            m = "#{master}は#{action}、\m\n#{speaker}の#{$msg.t_enemy.bustsize}を手で撫で回した！"
            m = "#{master}は#{action}、\m\n#{speaker}の#{$msg.t_enemy.bustsize}を舌で舐め回した！" if $game_variables[17] > 50 
          end
        #アソコに奉仕
        when "対象：アソコ","対象：アナル"
          m = "#{master}は#{action}、\m\n#{speaker}のアソコに指を抜き挿しした！"
          m = "#{master}は#{action}、\m\n#{speaker}のアソコに舌を出し入れした！" if $game_variables[17] > 50 
        #陰核に奉仕
        when "対象：陰核"
          m = "#{master}は#{action}、\m\n#{speaker}の陰核を指で愛撫した！"
          m = "#{master}は#{action}、\m\n#{speaker}の陰核を舌で舐め上げた！" if $game_variables[17] > 50 
        #お尻に奉仕
        when "対象：尻"
          m = "#{master}は#{action}、\m\n#{speaker}のお尻を両手で愛撫した！"
          m = "#{master}は#{action}、\m\n#{speaker}のお尻を舌で舐め回した！" if $game_variables[17] > 50 
        #アナルに奉仕
#        when "対象：アナル"
#          m = "#{master}は#{action}、\m\n#{speaker}の菊座を指で愛撫した！"
#          m = "#{master}は#{action}、\m\n#{speaker}の菊座を舌で舐め回した！" if $game_variables[17] > 50 
        end
      end
    #==============================================================================
    # ●愛撫・性交
    #==============================================================================
    when "愛撫・性交"
      case $msg.talk_step
      when 77 #愛撫を最初から断った場合
        m = "#{master}は誘惑に負けず、\m\n#{speaker}の申し出を断った！"
        m = "#{master}は後ろ髪を引かれる思いで、\m\n何とか#{speaker}の要求を断った！" if $game_actors[101].state?(35)
      when 78 #視姦を途中で断った場合
        m = "#{master}は何とか意思を振り絞り、\m\n#{speaker}の行為を押し留めた！"
      #●愛撫を受け入れた場合
      else
        case $msg.at_parts
        #▼インサート・アクセプト
        #--------------------------------------------------------------------------
        when "♀挿入：アソコ側","尻挿入：尻側"
          if $game_variables[17] > 70
            if $game_actors[101].critical == true
              action = ["艶かしく","きゅっと","ぎゅっと"]
              action = action[rand(action.size)]
              move = ["締め付ける","締め上げる","絞り上げる"]
              move = move[rand(move.size)]
            else
              action = ""
              move = "締め付ける"
            end
            hole = "アソコ"
            hole = "菊門" if $msg.at_parts == "尻挿入：尻側"
            m = "#{speaker}の#{hole}が、\m\n#{master}のペニスを#{action}#{move}！" 
          else
            if $game_actors[101].critical == true
              if $msg.t_enemy.initiative_level > 0
                #●
                action = "を押さえ込み"
                #●
                waist = ["大胆に","大きく","激しく"]
                waist.push("うねるように","艶かしく","緩急をつけて") if $msg.t_enemy.positive?
                waist.push("一所懸命に","一心不乱に","蕩けた表情で") if $msg.t_enemy.negative?
              else
                #●
                action = "に身体を預け"
                #●
                waist = ["大きく"]
                waist.push("艶かしく") if $msg.t_enemy.positive?
                waist.push("一所懸命に") if $msg.t_enemy.negative?
              end
              waist = waist[rand(waist.size)]
            else
              if $msg.t_enemy.initiative_level > 0
                #●
                action = "を見つめながら"
                #●
                waist = ["ゆっくりと","前後に","回すように"]
                waist.push("焦らすように","ゆったりと") if $msg.t_enemy.positive?
                waist.push("控えめに","恥らいつつも") if $msg.t_enemy.negative?
              else
                #●
                action = "に動きを合わせ"
                #●
                waist = ["ゆっくりと"]
                waist.push("焦らすように") if $msg.t_enemy.positive?
                waist.push("控えめに") if $msg.t_enemy.negative?
              end
              waist = waist[rand(waist.size)]
            end
            m = "#{speaker}は#{master}#{action}、\m\n#{waist}腰を振ってきた！"
          end
        #▼オーラル
        #--------------------------------------------------------------------------
        when "口挿入：口側"
          if $game_actors[101].critical == true
            if $msg.t_enemy.initiative_level > 0
              #●
              action = "しゃぶってきた"
              #●
              mouth = ["大胆に","音を立てて","激しく"]
              mouth.push("吸い込むように","艶かしく","緩急をつけて") if $msg.t_enemy.positive?
              mouth.push("一所懸命に","一心不乱に","蕩けた表情で") if $msg.t_enemy.negative?
              mouth.push("愛おしむように") if $mood.point > 70
            else
              #●
              action = "喉奥まで呑み込んできた"
              #●
              mouth = ["大胆に"]
              mouth.push("妖艶な表情で") if $msg.t_enemy.positive?
              mouth.push("一所懸命に") if $msg.t_enemy.negative?
              mouth.push("愛おしむように") if $mood.point > 70
            end
            mouth = mouth[rand(mouth.size)]
          else
            if $msg.t_enemy.initiative_level > 0
              #●
              action = "しゃぶってきた"
              #●
              mouth = ["ゆっくりと"]
              mouth.push("焦らすように","ゆったりと") if $msg.t_enemy.positive?
              mouth.push("おずおずと","控えめに","恥らいつつも") if $msg.t_enemy.negative?
              mouth.push("愛おしむように") if $mood.point > 70
            else
              #●
              action = "喉奥まで呑み込んできた"
              #●
              mouth = ["ゆっくりと"]
              mouth.push("焦らすように","じわじわと") if $msg.t_enemy.positive?
              mouth.push("おずおずと","意を決して") if $msg.t_enemy.negative?
            end
            mouth = mouth[rand(mouth.size)]
          end
          m = "#{speaker}は#{master}のペニスを、\m\n#{mouth}#{action}！"
        #▼パイズリ
        #--------------------------------------------------------------------------
        when "パイズリ"
          if $game_actors[101].critical == true
            action = "しごいてきた"
            #●
            bust = ["大胆に","激しく"]
            bust.push("艶かしく","緩急をつけて") if $msg.t_enemy.positive?
            bust.push("一所懸命に","一心不乱に","蕩けた表情で") if $msg.t_enemy.negative?
            bust.push("愛おしむように") if $mood.point > 70
          else
            action = "挟んできた"
            #●
            bust = ["ゆっくりと","上下に"]
            bust.push("焦らすように","ゆったりと") if $msg.t_enemy.positive?
            bust.push("おずおずと","控えめに","恥らいつつも") if $msg.t_enemy.negative?
            bust.push("愛おしむように") if $mood.point > 70
          end
          bust = bust[rand(bust.size)]
          m = "#{speaker}は#{$msg.t_enemy.bustsize}で、\m\n#{master}のペニスを#{bust}#{action}！"
        #--------------------------------------------------------------------------
        when "背面拘束"
          action = []
          if $game_actors[101].critical == true
            action.push("の首筋を舌先で舐めてきた！")
            action.push("の耳たぶを甘噛みしてきた！")
            action.push("の乳首を舌先で舐めてきた！")
            action.push("に自分の胸を押し付けてきた！")
            #ペニスが空いている場合
            if $game_actors[101].hold.penis.battler == nil
              action.push("のペニスを指で弄ってきた！") 
              action.push("のペニスを指先で撫でてきた！")
            #ペニスがインサート中の場合(アナル含む)
            elsif $game_actors[101].penis_insert? or $game_actors[101].penis_analsex?
              hold_target = $game_actors[101].hold.penis.battler
              action.push("の腰を前に押し出した！\m\n#{hold_target}との結合部がより深くなった！")
            #ペニスがパイズリ中の場合
            elsif $game_actors[101].penis_paizuri?
              action.push("の腰を押さえ込んだ！\m\n#{hold_target}の動きが更に激しくなった！")
            end
          else
            action.push("のわきの下を舌で舐めてきた！")
            action.push("の首筋にふぅっと息を吹きかけた！")
            action.push("の胸板に指を這わせてきた！")
            action.push("の腰をさわさわと撫でてきた！")
            action.push("の太ももをさわさわと撫でてきた！")
          end
          action = action[rand(action.size)]
          m = "#{speaker}は密着したまま、\m\n#{master}#{action}"
        end
      #--------------------------------------------------------------------------
      end
    #==============================================================================
    # ●愛撫・通常
    #==============================================================================
    when "愛撫・通常"
      case $msg.talk_step
      when 77 #愛撫を最初から断った場合
        m = "#{master}は誘惑に負けず、\m\n#{speaker}の申し出を断った！"
        m = "#{master}は後ろ髪を引かれる思いで、\m\n何とか#{speaker}の要求を断った！" if $game_actors[101].state?(35)
      when 78 #愛撫を途中で断った場合
        m = "#{master}は何とか意思を振り絞り、\m\n#{speaker}の行為を押し留めた！"
      #●愛撫を受け入れた場合
      else
        m = "#{speaker}は微笑むと、\m\n#{master}のペニスを愛撫してきた！"
        case $msg.at_type
        #--------------------------------------------------------------------------
        when "手"
          #●弱点を突いた
          if $game_actors[101].critical == true
            case @weakpoints
            when 20,10
              if $msg.chain_attack == true
                m = "#{speaker}は反応を楽しむかのように、\m\n#{master}のペニスを艶かしく指で弄ぶ！"
                m = "#{speaker}は愛おしむかのように、\m\n#{master}のペニスを艶かしく指で弄ぶ！" if $msg.t_enemy.love > 0
              else
                m = "#{speaker}は心得た指捌きで、\m\n#{master}のペニスを間断なく攻め立ててきた！"
              end
            else
              if $msg.chain_attack == true
                m = "#{speaker}は間断なく、\m\n#{master}のペニスの敏感な部分を攻めてきた！"
              else
                m = "#{speaker}は指を絡めて、\m\n#{master}のペニスの敏感な部分を攻めてきた！"
              end
            end
          else
            case @weakpoints
            when 20,10
              if $msg.chain_attack == true
                m = "#{speaker}は間断なく、\m\n#{master}のペニスを指で攻め立てる！"
              else
                m = "#{speaker}は指を絡めて、\m\n#{master}のペニスをしごき上げてきた！"
              end
            else
              if $msg.chain_attack == true
                m = "#{speaker}は、\m\n#{master}のペニスに指を絡め愛撫してきた！"
              else
                m = "#{speaker}は手で、\m\n#{master}のペニスをしごいてきた！"
              end
            end
          end
        #--------------------------------------------------------------------------
        when "口"
          #●弱点を突いた
          if $game_actors[101].critical == true
            case @weakpoints
            when 20,10
              if $msg.chain_attack == true
                m = "#{speaker}は反応を楽しむかのように、\m\n#{master}のペニスを根元から舐め上げてきた！"
                m = "#{speaker}は愛おしむかのように、\m\n#{master}のペニスを根元から舐め上げてきた！" if $msg.t_enemy.love > 0
              else
                m = "#{speaker}は心得た舌使いで、\m\n#{master}のペニスを間断なく舐め回してきた！"
              end
            else
              if $msg.chain_attack == true
                m = "#{speaker}は間断なく、\m\n#{master}のペニスの敏感な部分を舐め続けた！"
              else
                m = "#{speaker}は舌先で、\m\n#{master}のペニスの敏感な部分を舐め上げた！"
              end
            end
          else
            case @weakpoints
            when 20,10
              if $msg.chain_attack == true
                m = "#{speaker}は間断なく、\m\n#{master}のペニスを丹念に舐め上げてきた！"
              else
                m = "#{speaker}は舌先で、\m\n#{master}のペニスを焦らすように舐め上げた！"
              end
            else
              if $msg.chain_attack == true
                m = "#{speaker}は休むことなく、\m\n#{master}のペニスを丹念に舐め上げてきた！"
              else
                m = "#{speaker}は舌で、\m\n#{master}のペニスを舐め上げてきた！"
              end
            end
          end
        #--------------------------------------------------------------------------
        when "足"
          #●弱点を突いた
          if $game_actors[101].critical == true
            case @weakpoints
            when 20,10
              if $msg.chain_attack == true
                m = "#{speaker}は反応を楽しむかのように、\m\n#{master}のペニスを両足の裏でしごいてきた！"
                m = "#{speaker}は愛おしむかのように、\m\n#{master}のペニスを両足の裏でしごいてきた！" if $msg.t_enemy.love > 0
              else
                m = "#{speaker}は心得ていると言わんばかりに、\m\n#{master}のペニスを足裏で捏ね回してきた！"
              end
            else
              if $msg.chain_attack == true
                m = "#{speaker}は休むことなく、\m\n#{master}のペニスを足裏で捏ね回してきた！"
              else
                m = "#{speaker}は足の裏で、\m\n#{master}のペニスの敏感な部分をしごいてきた！"
              end
            end
          else
            case @weakpoints
            when 20,10
              if $msg.chain_attack == true
                m = "#{speaker}は緩急をつけながら、\m\n#{master}のペニスを足の指で更に弄ぶ！"
              else
                m = "#{speaker}は足の指で、\m\n#{master}のペニスを焦らすように弄んできた！"
              end
            else
              if $msg.chain_attack == true
                m = "#{speaker}は緩急をつけながら、\m\n#{master}のペニスを足裏でしごいてきた！"
              else
                m = "#{speaker}は足の裏で、\m\n#{master}のペニスを軽く踏みつけた！"
              end
            end
          end
        #--------------------------------------------------------------------------
        when "胸"
          if $msg.chain_attack == true
            m = "#{speaker}は#{$msg.t_enemy.bustsize}で、\m\n#{master}のペニスを間断なく愛撫してきた！"
            m = "#{speaker}は#{$msg.t_enemy.bustsize}を、\m\n#{master}のペニスに擦り付けてきた！" if $data_SDB[$msg.t_enemy.class_id].bust_size < 3
          else
            m = "#{speaker}は#{$msg.t_enemy.bustsize}で、\m\n#{master}のペニスを挟みしごいてきた！"
            m = "#{speaker}は#{$msg.t_enemy.bustsize}を、\m\n#{master}のペニスに押し付けてきた！" if $data_SDB[$msg.t_enemy.class_id].bust_size < 3
          end
          #●弱点を突いた
          if $game_actors[101].critical == true
            case @weakpoints
            when 20,10
              if $msg.chain_attack == true
                if $data_SDB[$msg.t_enemy.class_id].bust_size < 3
                  m = "#{speaker}は反応を楽しむかのように、\m\n#{$msg.t_enemy.bustsize}をペニスに擦り付けてきた！"
                  m = "#{speaker}は愛おしむかのように、\m\n#{$msg.t_enemy.bustsize}をペニスに擦り付けてきた！" if $msg.t_enemy.love > 0
                else
                  m = "#{speaker}は反応を楽しむかのように、\m\n#{$msg.t_enemy.bustsize}でペニスを艶かしく愛撫してきた！"
                  m = "#{speaker}は愛おしむかのように、\m\n#{$msg.t_enemy.bustsize}でペニスを艶かしく愛撫してきた！" if $msg.t_enemy.love > 0
                end
              else
                m = "#{speaker}は#{$msg.t_enemy.bustsize}で、\m\n#{master}のペニスを挟みしごいてきた！"
                m = "#{speaker}は#{$msg.t_enemy.bustsize}を、\m\n#{master}のペニスに押し付けてきた！" if $data_SDB[$msg.t_enemy.class_id].bust_size < 3
              end
            else
              if $msg.chain_attack == true
                m = "#{speaker}は#{$msg.t_enemy.bustsize}で、\m\n#{master}のペニスを間断なく愛撫してきた！"
                m = "#{speaker}は#{$msg.t_enemy.bustsize}を、\m\n#{master}のペニスに擦り付けてきた！" if $data_SDB[$msg.t_enemy.class_id].bust_size < 3
              else
                m = "#{speaker}は#{$msg.t_enemy.bustsize}で、\m\n#{master}のペニスを挟みしごいてきた！"
                m = "#{speaker}は#{$msg.t_enemy.bustsize}を、\m\n#{master}のペニスに押し付けてきた！" if $data_SDB[$msg.t_enemy.class_id].bust_size < 3
              end
            end
          else
            case @weakpoints
            when 20,10
              if $msg.chain_attack == true
                m = "#{speaker}は#{$msg.t_enemy.bustsize}で、\m\n#{master}のペニスを間断なく愛撫してきた！"
                m = "#{speaker}は#{$msg.t_enemy.bustsize}を、\m\n#{master}のペニスに擦り付けてきた！" if $data_SDB[$msg.t_enemy.class_id].bust_size < 3
              else
                m = "#{speaker}は#{$msg.t_enemy.bustsize}で、\m\n#{master}のペニスを挟みしごいてきた！"
                m = "#{speaker}は#{$msg.t_enemy.bustsize}を、\m\n#{master}のペニスに押し付けてきた！" if $data_SDB[$msg.t_enemy.class_id].bust_size < 3
              end
            else
              if $msg.chain_attack == true
                m = "#{speaker}は#{$msg.t_enemy.bustsize}で、\m\n#{master}のペニスを間断なく愛撫してきた！"
                m = "#{speaker}は#{$msg.t_enemy.bustsize}を、\m\n#{master}のペニスに擦り付けてきた！" if $data_SDB[$msg.t_enemy.class_id].bust_size < 3
              else
                m = "#{speaker}は#{$msg.t_enemy.bustsize}で、\m\n#{master}のペニスを挟みしごいてきた！"
                m = "#{speaker}は#{$msg.t_enemy.bustsize}を、\m\n#{master}のペニスに押し付けてきた！" if $data_SDB[$msg.t_enemy.class_id].bust_size < 3
              end
            end
          end
        #--------------------------------------------------------------------------
        when "♀"
          #●弱点を突いた
          if $game_actors[101].critical == true
            case @weakpoints
            when 20,10
              if $msg.chain_attack == true
                m = "#{speaker}は反応を楽しむかのように、\m\n#{master}のペニスの上で腰を振ってきた！"
                m = "#{speaker}は愛おしむかのように、\m\n#{master}のペニスの上で腰を振ってきた！" if $msg.t_enemy.love > 0
              else
                m = "#{speaker}は心得た腰使いで、\m\n#{master}のペニスにアソコを擦り付けてきた！"
              end
            else
              if $msg.chain_attack == true
                m = "#{speaker}は腰を前後にくねらせ、\m\n#{master}のペニスをアソコで擦り上げてきた！"
              else
                m = "#{speaker}は自分のアソコを、\m\n#{master}のペニスに激しく擦り付けてきた！"
              end
            end
          else
            case @weakpoints
            when 20,10
              if $msg.chain_attack == true
                m = "#{speaker}は緩急をつけながら、\m\n#{master}のペニスの上で腰を振ってきた！"
              else
                m = "#{speaker}は自分のアソコを、\m\n#{master}のペニスに擦り付けてきた！"
              end
            else
              if $msg.chain_attack == true
                m = "#{speaker}は緩急をつけながら、\m\n#{master}のペニスの上で腰を振ってきた！"
              else
                m = "#{speaker}は自分のアソコを、\m\n#{master}のペニスに擦り付けてきた！"
              end
            end
          end
        #--------------------------------------------------------------------------
        when "尻尾"
          #●弱点を突いた
          if $game_actors[101].critical == true
            case @weakpoints
            when 20,10
              if $msg.chain_attack == true
                m = "#{speaker}は反応を楽しむかのように、\m\n#{master}のペニスを尻尾でしごいてきた！"
                m = "#{speaker}は愛おしむかのように、\m\n#{master}のペニスを尻尾でしごいてきた！" if $msg.t_enemy.love > 0
              else
                m = "#{speaker}は慣れた腰使いで、\m\n#{master}のペニスを尻尾で弄んできた！"
              end
            else
              if $msg.chain_attack == true
                m = "#{speaker}は尻尾をくねらせ、\m\n#{master}のペニスを間断なくしごき上げてきた！"
              else
                m = "#{speaker}は尻尾を巧みに使い、\m\n#{master}のペニスをしごき上げてきた！"
              end
            end
          else
            case @weakpoints
            when 20,10
              if $msg.chain_attack == true
                m = "#{speaker}はリズミカルに、\m\n尻尾で#{master}のペニスをしごき上げてきた！"
              else
                m = "#{speaker}は自分の尻尾を、\m\n#{master}のペニスに巻き付けてきた！"
              end
            else
              if $msg.chain_attack == true
                m = "#{speaker}はリズミカルに、\m\n尻尾で#{master}のペニスをしごき上げてきた！"
              else
                m = "#{speaker}は自分の尻尾を、\m\n#{master}のペニスに巻き付けてきた！"
              end
            end
          end
        end
        #■ホールド暫定措置
        if $msg.t_enemy.holding_now?
        case $msg.at_parts
        #▼オーラル
        #--------------------------------------------------------------------------
        when "口挿入：口側"
          if $game_actors[101].critical == true
            if $msg.t_enemy.initiative_level > 0
              #●
              action = "しゃぶってきた"
              #●
              mouth = ["大胆に","音を立てて","激しく"]
              mouth.push("吸い込むように","艶かしく","緩急をつけて") if $msg.t_enemy.positive?
              mouth.push("一所懸命に","一心不乱に","蕩けた表情で") if $msg.t_enemy.negative?
              mouth.push("愛おしむように") if $mood.point > 70
            else
              #●
              action = "喉奥まで呑み込んできた"
              #●
              mouth = ["大胆に"]
              mouth.push("妖艶な表情で") if $msg.t_enemy.positive?
              mouth.push("一所懸命に") if $msg.t_enemy.negative?
              mouth.push("愛おしむように") if $mood.point > 70
            end
            mouth = mouth[rand(mouth.size)]
          else
            if $msg.t_enemy.initiative_level > 0
              #●
              action = "しゃぶってきた"
              #●
              mouth = ["ゆっくりと"]
              mouth.push("焦らすように","ゆったりと") if $msg.t_enemy.positive?
              mouth.push("おずおずと","控えめに","恥らいつつも") if $msg.t_enemy.negative?
              mouth.push("愛おしむように") if $mood.point > 70
            else
              #●
              action = "喉奥まで呑み込んできた"
              #●
              mouth = ["ゆっくりと"]
              mouth.push("焦らすように","じわじわと") if $msg.t_enemy.positive?
              mouth.push("おずおずと","意を決して") if $msg.t_enemy.negative?
            end
            mouth = mouth[rand(mouth.size)]
          end
          m = "#{speaker}は#{master}のペニスを、\m\n#{mouth}#{action}！"
        #▼パイズリ
        #--------------------------------------------------------------------------
        when "パイズリ"
          if $game_actors[101].critical == true
            action = "しごいてきた"
            #●
            bust = ["大胆に","激しく"]
            bust.push("艶かしく","緩急をつけて") if $msg.t_enemy.positive?
            bust.push("一所懸命に","一心不乱に","蕩けた表情で") if $msg.t_enemy.negative?
            bust.push("愛おしむように") if $mood.point > 70
          else
            action = "挟んできた"
            #●
            bust = ["ゆっくりと","上下に"]
            bust.push("焦らすように","ゆったりと") if $msg.t_enemy.positive?
            bust.push("おずおずと","控えめに","恥らいつつも") if $msg.t_enemy.negative?
            bust.push("愛おしむように") if $mood.point > 70
          end
          bust = bust[rand(bust.size)]
          m = "#{speaker}は#{$msg.t_enemy.bustsize}で、\m\n#{master}のペニスを#{bust}#{action}！"
        #--------------------------------------------------------------------------
        when "背面拘束"
          action = []
          if $game_actors[101].critical == true
            action.push("の首筋を舌先で舐めてきた！")
            action.push("の耳たぶを甘噛みしてきた！")
            action.push("の乳首を舌先で舐めてきた！")
            action.push("に自分の胸を押し付けてきた！")
            #ペニスが空いている場合
            if $game_actors[101].hold.penis.battler == nil
              action.push("のペニスを指で弄ってきた！") 
              action.push("のペニスを指先で撫でてきた！")
            #ペニスがインサート中の場合(アナル含む)
            elsif $game_actors[101].penis_insert? or $game_actors[101].penis_analsex?
              hold_target = $game_actors[101].hold.penis.battler
              action.push("の腰を前に押し出した！\m\n#{hold_target}との結合部がより深くなった！")
            #ペニスがパイズリ中の場合
            elsif $game_actors[101].penis_paizuri?
              action.push("の腰を押さえ込んだ！\m\n#{hold_target}の動きが更に激しくなった！")
            end
          else
            action.push("のわきの下を舌で舐めてきた！")
            action.push("の首筋にふぅっと息を吹きかけた！")
            action.push("の胸板に指を這わせてきた！")
            action.push("の腰をさわさわと撫でてきた！")
            action.push("の太ももをさわさわと撫でてきた！")
          end
          action = action[rand(action.size)]
          m = "#{speaker}は密着したまま、\m\n#{master}#{action}"
        end
        end #if $msg.t_enemy.holding_now?
      #--------------------------------------------------------------------------
      end
    #==============================================================================
    # ●交合
    #==============================================================================
    when "交合"
      case $msg.at_type
      when "♀挿入"
        case $msg.talk_step
        when 2 #挿入受諾
          m = "#{master}は誘われるまま、\m\n#{speaker}のアソコにペニスを突き入れた！"
        when 77 #挿入拒否
          m = "#{master}は強い意志で思い留まった！"
        end
#      when "口挿入"
#      when "尻挿入"
#      when "パイズリ"
#      when "キッス"
      end
    end
    #============================================================================
    return if m == ""
    $game_temp.battle_log_text += m
  end

###############################################################################  
  #============================================================================
  # ●トーク中のテキスト設定(口上表示前のテキスト)
  #============================================================================
  def make_text_pretalk
    speaker = $msg.t_enemy.name #会話中のエネミー名
    master = $game_actors[101].name #主人公名
    #存在するなら、パートナー名
    if $msg.t_partner != nil
      servant = $msg.t_partner.name
    else
      servant = nil
    end
    m = ""
    case $msg.tag
    #==============================================================================
    # ●主人公脱衣
    #==============================================================================
    when "主人公脱衣"
      m = "#{speaker}は#{master}の胸元に、\m\n意味ありげな視線を向けてきた……！"
      m = "#{speaker}は#{master}の胸元を、\m\n落ち着かない様子でちらちらと伺っている！" if $msg.t_enemy.negative?
    #==============================================================================
    # ●仲間脱衣
    #==============================================================================
    when "仲間脱衣"
      m = "#{speaker}は含みのある表情で、\m\n#{servant}を見つめている……！"
      m = "#{speaker}は意味ありげな表情で、\m\n#{servant}を見つめている……！" if $msg.t_enemy.negative?
    #==============================================================================
    # ●夢魔脱衣
    #==============================================================================
    when "夢魔脱衣"
      m = "#{speaker}は服の合わせ目をはだけ、\m\n#{master}に艶っぽい表情を向けた！"
      m = "#{speaker}は服の合わせ目をはだけ、\m\n#{master}に意味ありげな表情を向けた！" if $msg.t_enemy.negative?
      m = "#{speaker}の身体を覆う粘液が、\m\n#{master}の視線の先で揺れている……！" if $msg.t_enemy.tribe_slime?
    #==============================================================================
    # ●吸精・口
    #==============================================================================
    when "吸精・口"
      m = "#{speaker}は目を閉じて、\m\n#{master}の唇に顔を近づけてきた……！"
      m = "#{speaker}は笑みを浮かべ、\m\n#{master}の唇に顔を近づけてきた……！" if $msg.t_enemy.positive?
    #==============================================================================
    # ●吸精・性器
    #==============================================================================
    when "吸精・性器"
      m = "#{speaker}は目を閉じて、\m\n#{master}のペニスに顔を近づけてきた……！"
      m = "#{speaker}は笑みを浮かべ、\m\n#{master}のペニスに顔を近づけてきた……！" if $msg.t_enemy.positive?
    #==============================================================================
    # ●視姦
    #==============================================================================
    when "視姦"
      emotion = ""
      case $msg.t_enemy.personality
      when "好色","高慢"
        emotion = "妖艶な笑みを浮かべ"
      when "陽気","柔和","勝ち気"
        emotion = "悪戯っぽい笑みを浮かべ"
      when "虚勢","甘え性"
        emotion = "ちらちらとこちらを伺いながら"
      when "内気"
        emotion = "恥ずかしげに顔を伏せつつも"
      when "意地悪"
        emotion = "にやりと挑発的に口元を歪め"
      when "不思議","上品","倒錯"
        emotion = "意味ありげな笑みを浮かべ"
      when "淡泊","従順"
        emotion = "わずかに顔を紅潮させつつ"
      when "天然"
        emotion = "とろんとした表情で"
      else
        emotion = "見せ付けるかのように"
      end
      #テキスト整形(口、尻系は現在は封印のため、他部位に割り振り)
      case $msg.at_parts
      #胸や乳首で自慰
      when "対象：胸","対象：口"
        m = "#{speaker}は#{emotion}、\m\n自分の#{$msg.t_enemy.bustsize}に指を這わせた！"
      #アソコに指入れで自慰
      when "対象：アソコ","対象：尻"
        m = "#{speaker}は#{emotion}、\m\n自分のアソコに指を這わせた！"
      #陰核を弄って自慰
      when "対象：陰核","対象：アナル"
        m = "#{speaker}は#{emotion}、\m\n自分の陰核に指を這わせた！"
      end
    #==============================================================================
    # ●奉仕
    #==============================================================================
    when "奉仕"
      #テキスト整形
      case $msg.at_parts
      #キッスで奉仕
      when "対象：口"
        m = "#{speaker}は目を閉じ、\m\n#{master}に唇を向けてきた！"
      #胸や乳首に奉仕
      when "対象：胸"
        m = "#{speaker}は#{master}の腕に抱きつき、\m\n自分の#{$msg.t_enemy.bustsize}を擦り付けてきた！"
      #アソコに奉仕
      when "対象：アソコ","対象：アナル"
        m = "#{speaker}は#{master}の目の前で、\m\n指で自らアソコを開いて見せてきた！"
        m = "#{speaker}は恥らいつつも、\m\n指で自らアソコを開いて見せてきた！" if $msg.t_enemy.negative?
      #陰核に奉仕
      when "対象：陰核"
        m = "#{speaker}は#{master}の目の前で、\m\n指で自らアソコを開いて見せてきた！"
        m = "#{speaker}は恥らいつつも、\m\n指で自らアソコを開いて見せてきた！" if $msg.t_enemy.negative?
      #お尻に奉仕
      when "対象：尻"
        m = "#{speaker}は#{master}の目の前で、\m\nうつ伏せになってお尻を振ってきた！"
        m = "#{speaker}は恥らいつつも、\m\nうつ伏せになってお尻を向けてきた！" if $msg.t_enemy.negative?
      #アナルに奉仕
#      when "対象：アナル"
#        m = "#{master}は#{action}、\m\n#{speaker}の菊座を指で愛撫した！"
#        m = "#{master}は#{action}、\m\n#{speaker}の菊座に舌を這わせた！" if $game_variables[17] > 50 
      end
    #==============================================================================
    # ●愛撫・通常
    #==============================================================================
    when "愛撫・通常"
      emotion = ""
      case $msg.t_enemy.personality
      when "勝ち気","高慢","意地悪"
        emotion = "舌なめずりをしつつ"
      when "上品","柔和"
        emotion = "柔らかい笑みを浮かべ"
      when "淡泊","虚勢"
        emotion = "ちらちらと横目で"
      when "内気","従順","倒錯"
        emotion = "熱っぽい瞳で"
      when "不思議","天然"
        emotion = "感心した表情で"
      when "陽気","甘え性"
        emotion = "悪戯っぽい笑みを浮かべ"
      else #好色
        emotion = "妖艶な笑みを浮かべ"
      end
      m = "#{speaker}は#{emotion}、\m\n#{master}のペニスを見つめている！"
      #▼別ホールドの専用が出来るまでの一時措置(@0830)
      if $msg.t_enemy.holding_now?
        emotion = ""
        case $msg.t_enemy.personality
        when "勝ち気","高慢","意地悪"
          emotion = "舌なめずりをしつつ"
        when "上品","柔和"
          emotion = "柔らかい笑みを浮かべ"
        when "淡泊","虚勢"
          emotion = "熱っぽい瞳で"
        when "内気","従順","倒錯"
          emotion = "潤んだ瞳で"
        when "不思議","天然"
          emotion = "屈託の無い笑みを浮かべ"
        when "陽気","甘え性"
          emotion = "悪戯っぽい笑みを浮かべ"
        else #好色
          emotion = "妖艶な笑みを浮かべ"
        end
        action = []
        case $msg.at_parts
        #▼インサート・アクセプト
        #--------------------------------------------------------------------------
        when "♀挿入：アソコ側","尻挿入：尻側"
          action.push("の背に腕を回してきた")
          action.push("を見下ろしてきた") if $msg.t_enemy.initiative_level > 0
        when "口挿入：口側","パイズリ"
          action.push("を見上げてきた")
          action.push("のペニスと戯れている") if $msg.t_enemy.initiative_level > 0
        when "背面拘束"
          action.push("に更に身体を密着させてきた")
        else
          action.push("に更に身体を密着させてきた")
        end
        action = action[rand(action.size)]
        m = "#{speaker}は#{emotion}、\m\n#{master}#{action}！"
      end
    #==============================================================================
    # ●愛撫・性交
    #==============================================================================
    when "愛撫・性交"
      emotion = ""
      case $msg.t_enemy.personality
      when "勝ち気","高慢","意地悪"
        emotion = "舌なめずりをしつつ"
      when "上品","柔和"
        emotion = "柔らかい笑みを浮かべ"
      when "淡泊","虚勢"
        emotion = "熱っぽい瞳で"
      when "内気","従順","倒錯"
        emotion = "潤んだ瞳で"
      when "不思議","天然"
        emotion = "屈託の無い笑みを浮かべ"
      when "陽気","甘え性"
        emotion = "悪戯っぽい笑みを浮かべ"
      else #好色
        emotion = "妖艶な笑みを浮かべ"
      end
      action = []
      case $msg.at_parts
      #▼インサート・アクセプト
      #--------------------------------------------------------------------------
      when "♀挿入：アソコ側","尻挿入：尻側"
        action.push("の背に腕を回してきた")
        action.push("を見下ろしてきた") if $msg.t_enemy.initiative_level > 0
      when "口挿入：口側","パイズリ"
        action.push("を見上げてきた")
        action.push("のペニスと戯れている") if $msg.t_enemy.initiative_level > 0
      when "背面拘束"
        action.push("に更に身体を密着させてきた")
      else
        action.push("に更に身体を密着させてきた")
      end
      action = action[rand(action.size)]
      m = "#{speaker}は#{emotion}、\m\n#{master}#{action}！"
    #==============================================================================
    # ●交合
    #==============================================================================
    when "交合"
      case $msg.t_enemy.personality
      when "好色"
        m = "#{speaker}は焦らすように股を広げ、\m\n妖艶な笑みを浮かべ#{master}を手招きした！" #前
        m = "#{speaker}は四つん這いになり、\m\n後ろ手でアソコを広げて誘惑してきた！" if $game_variables[17] > 50 #後
      when "上品"
        m = "#{speaker}は誘惑するかのように、\m\n脚を開いて#{master}に手招きをした！" #前
        m = "#{speaker}は四つん這いになり、\m\n悩ましげな瞳で#{master}を見つめてきた！" if $game_variables[17] > 50 #後
      when "高慢"
        m = "#{speaker}は焦らすように股を広げ、\m\n挑発するように#{master}を見つめてきた！" #前
        m = "#{speaker}はお尻を突き出し、\m\n不敵な笑みで#{master}を見つめてきた！" if $game_variables[17] > 50 #後
      when "淡泊"
        m = "#{speaker}はやや恥らいつつも、\m\n#{master}に見えるように脚を広げてきた！" #前
        m = "#{speaker}は四つん這いになり、\m\n様子を伺うかのように#{master}を見ている！" if $game_variables[17] > 50 #後
      when "柔和"
        m = "#{speaker}は誘惑するかのように、\m\n脚を開いて#{master}に手招きをした！" #前
        m = "#{speaker}は四つん這いになり、\m\n後ろ手でアソコを広げて誘惑してきた！" if $game_variables[17] > 50 #後
      when "勝ち気"
        m = "#{speaker}は大胆に股を広げ、\m\n挑発するように#{master}を見つめてきた！" #前
        m = "#{speaker}は四つん這いになり、\m\n不敵な笑みで#{master}を見つめてきた！" if $game_variables[17] > 50 #後
      when "内気"
        m = "#{speaker}は手で顔を覆いつつ、\m\n#{master}に見えるように股を広げてきた！" #前
        m = "#{speaker}は四つん這いになり、\m\n#{master}にお尻を恥ずかしげに向けてきた！" if $game_variables[17] > 50 #後
      when "陽気"
        m = "#{speaker}は大胆に股を広げ、\m\n期待を込めた瞳で#{master}を見つめてきた！" #前
        m = "#{speaker}はお尻を突き出し、\m\n期待を込めた瞳で#{master}を見つめてきた！" if $game_variables[17] > 50 #後
      when "意地悪"
        m = "#{speaker}は誘惑するかのように、\m\n脚を開いて#{master}に手招きをした！" #前
        m = "#{speaker}は四つん這いになり、\m\n後ろ手でアソコを広げて誘惑してきた！" if $game_variables[17] > 50 #後
      when "天然"
        m = "#{speaker}は期待を込めた眼差しで、\m\n股を広げて#{master}を見つめてきた！" #前
        m = "#{speaker}は四つん這いになり、\m\n潤んだ瞳で#{master}を見つめてきた！" if $game_variables[17] > 50 #後
      when "従順"
        m = "#{speaker}は大胆に股を広げ、\m\n上目遣いに#{master}を見つめてきた！" #前
        m = "#{speaker}はお尻を突き出し、\m\n潤んだ瞳で#{master}を見つめてきた！" if $game_variables[17] > 50 #後
      when "虚勢"
        m = "#{speaker}は意を決したように股を広げ、\m\n挑発するように#{master}を見つめてきた！" #前
        m = "#{speaker}はお尻を突き出し、\m\n挑むような表情で#{master}を見つめてきた！" if $game_variables[17] > 50 #後
      when "倒錯"
        m = "#{speaker}は焦らすように股を広げ、\m\n妖艶な笑みを浮かべ#{master}を手招きした！" #前
        m = "#{speaker}は四つん這いになり、\m\n潤んだ瞳で#{master}を見つめてきた！" if $game_variables[17] > 50 #後
      when "甘え性"
        m = "#{speaker}は期待を込めた眼差しで、\m\n股を広げて#{master}を見つめてきた！" #前
        m = "#{speaker}は四つん這いになり、\m\n潤んだ瞳で#{master}を見つめてきた！" if $game_variables[17] > 50 #後
      when "不思議"
        m = "#{speaker}は脚をゆっくりと広げつつ、\m\n腰を浮かせて#{master}を見つめてきた！" #前
        m = "#{speaker}は尻たぶを両手で広げ、\m\n#{master}を見つめてきた！" if $game_variables[17] > 50 #後
      when "独善"
        m = "#{speaker}は見せ付けるように脚を広げ、\m\n妖艶な笑みで#{master}を見つめてきた！" #前
        m = "#{speaker}は四つん這いになると、\m\nお尻を高く上げて#{master}を挑発した！" if $game_variables[17] > 50 #後
      end
    end
   #============================================================================
    return if m == ""
    $game_temp.battle_log_text += m
  end
###############################################################################  
end