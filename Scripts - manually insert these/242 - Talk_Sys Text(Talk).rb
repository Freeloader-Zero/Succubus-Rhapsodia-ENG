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
        m = "#{speaker} is immersed in pleasure...!\\n It's impossible to talk right noｗ...!"
      when "主人公クライシス"
        m = "#{master} stares off vacantly...!\\n can't focus right noｗ!"
      when "夢魔絶頂中"
        m = "#{speaker} is climaxing....! \\n She incapable of talking right noｗ!"
      when "試行過多"
        m = "For some reason, #{speaker} doesn't seem\n\ to ｗant to talk anymore...."
      when "夢魔恍惚中"
        m = "#{speaker} bears blissful expression....! \\n She incapable of talking right noｗ!"
        m = "#{speaker} has a transfixed look on her face....!\\n She seems unable to talk right noｗ...!" if $msg.t_enemy.holding?
      when "夢魔暴走中"
        m = "#{speaker} is violently aroused....!\\n She can't talk right noｗ!"
      end
    #==============================================================================
    # ●主人公脱衣
    #==============================================================================
    when "主人公脱衣"
      case $msg.talk_step
      when 2 #脱衣を受け入れた場合
        m = "#{master} does as #{speaker} says, \\n taking off his oｗn clothes!"
      when 77 #脱衣を拒否した場合
        m = "#{master} declined!"
      end
    #==============================================================================
    # ●仲間脱衣
    #==============================================================================
    when "仲間脱衣"
      case $msg.talk_step
      when 2 #仲間の脱衣を受け入れた場合
        m = "#{master} does as #{speaker} says,\\n stripping #{servant} of her clothes!"
      when 77 #仲間の脱衣を拒否した場合
        m = "#{master} refused her demands!"
      end
    #==============================================================================
    # ●夢魔脱衣
    #==============================================================================
    when "夢魔脱衣"
      case $msg.talk_step
      when 2 #脱衣を見続けた場合
        m = "#{master} does as she says, ｗatching as\\n #{speaker} continued to undresses herself!"
        m = "#{master} unintentionally kept ｗatching as \\n#{speaker} she undressed herself!" if $data_SDB[$msg.t_enemy.class_id].name == "キャスト"
        m = "#{master} watches hungrily, as #{speaker}\\n continued undressing herself!" if $game_actors[101].state?(35)
      when 77 #脱衣を見なかった場合
        m = "#{master} struggled to pull aｗay,\\n averting his eyes from #{speaker}!"
      end
    #==============================================================================
    # ●吸精・口
    #==============================================================================
    when "吸精・口"
      case $msg.talk_step
      when 2 #吸精を受け入れた場合
        m = "#{speaker} locks lips with #{master}!\\n #{master}'s energy is being drained out of his body...!"
      when 77 #吸精を拒否した場合
        m = "#{master} declined her demand!"
      end
    #==============================================================================
    # ●吸精・性器
    #==============================================================================
    when "吸精・性器"
      case $msg.talk_step
      when 2 #吸精を受け入れた場合
        m = "#{speaker} hungrily sucks on #{master}'s penis!\\n #{master}'s strength is being drained and replaced\\n by pleasure...!"
      when 77 #吸精を拒否した場合
        m = "#{master} declined her demand!"
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
        m = "#{master} resists temptation,\\n averting his eyes from #{speaker}!"
      when 78 #視姦を途中で断った場合
        m = "#{master} manages to peel aｗay,\\n averting his eyes from #{speaker}!"
      when 79 #視姦しすぎて暴走した場合
        m = "#{master} cannot look aｗay from the sight before his eyes,\\n falling to #{speaker}'s temptation!"
      #継続している場合
      else
        m = "#{speaker} seeks to satisfy her desires....!"
        emotion = ""
        case $msg.t_enemy.personality
        when "意地悪","虚勢","倒錯"
          emotion = " suggestively"
          emotion = " approaches #{master} and" if rand($mood.point) > 50
        when "好色","高慢","陽気","柔和","勝ち気"
          emotion = " stares at #{master} and leｗdly"
          emotion = ", meeting #{master}'s gaze," if rand($mood.point) > 50
        when "淡泊","従順","甘え性","不思議"
          emotion = ", absorbed in her act,"
          emotion = ", feeling #{master}'s gaze," if rand($mood.point) > 50
        when "内気","上品","天然"
          emotion = " turns her face aｗay as she sloｗly"
          emotion = " blushes as she" if rand($mood.point) > 50
        end
        #テキスト整形(口、尻系は現在は封印のため、他部位に割り振り)
        case $msg.at_parts
        #胸や乳首で自慰
        when "対象：胸","対象：口"
          if $data_SDB[$msg.t_enemy.class_id].bust_size < 3
            m = "#{speaker}#{emotion} runs her\\n hands over her #{$msg.t_enemy.bustsize}!"
            m = "#{speaker}#{emotion} traces her\\n nipple ｗith her finger!" if rand($mood.point) > 50
          else
            m = "#{speaker}#{emotion} squeezes her m\n #{$msg.t_enemy.bustsize} ｗith her hands!"
            m = "#{speaker}#{emotion} traces her\\n nipple ｗith her finger!" if rand($mood.point) > 50
          end
        #アソコに指入れで自慰
        when "対象：アソコ","対象：尻"
          m = "#{speaker}#{emotion} rubs her\\n fingers in and out of her pussy!"
          m = "#{speaker}#{emotion} thrusts her\\n fingers in and out of her pussy!" if rand($mood.point) > 50
        #陰核を弄って自慰
        when "対象：陰核","対象：アナル"
          m = "#{speaker}#{emotion} rubs her\\n clit ｗith her finger!"
          m = "#{speaker}#{emotion} violently rubs\\n her clit ｗith her fingers!" if rand($mood.point) > 50
        end
      end
    #==============================================================================
    # ●奉仕
    #==============================================================================
    when "奉仕"
      case $msg.talk_step
      when 77 #視姦を最初から見なかった場合
        m = "#{master}は誘惑に負けず、\\n#{speaker}の要求を断った！"
        m = "#{master}は後ろ髪を引かれる思いで、\\n何とか#{speaker}の要求を断った！" if $game_actors[101].state?(35)
      when 78 #視姦を途中で断った場合
        m = "#{master} manages to peel aｗay,\\n#{speaker}への奉仕の手を止めた！"
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
          m = "#{master}は#{action}、\\n#{speaker}と口内で舌を絡めあった！"
        #胸や乳首に奉仕
        when "対象：胸"
          if $data_SDB[$msg.t_enemy.class_id].bust_size < 3
            m = "#{master}は#{action}、\\n#{speaker}の#{$msg.t_enemy.bustsize}を揉みしだいた！"
            m = "#{master}は#{action}、\\n#{speaker}の#{$msg.t_enemy.bustsize}を舌で舐め回した！" if $game_variables[17] > 50 
          else
            m = "#{master}は#{action}、\\n#{speaker}の#{$msg.t_enemy.bustsize}を手で撫で回した！"
            m = "#{master}は#{action}、\\n#{speaker}の#{$msg.t_enemy.bustsize}を舌で舐め回した！" if $game_variables[17] > 50 
          end
        #アソコに奉仕
        when "対象：アソコ","対象：アナル"
          m = "#{master}は#{action}、\\n#{speaker}のアソコに指を抜き挿しした！"
          m = "#{master}は#{action}、\\n#{speaker}のアソコに舌を出し入れした！" if $game_variables[17] > 50 
        #陰核に奉仕
        when "対象：陰核"
          m = "#{master}は#{action}、\\n#{speaker}の陰核を指で愛撫した！"
          m = "#{master}は#{action}、\\n#{speaker}の陰核を舌で舐め上げた！" if $game_variables[17] > 50 
        #お尻に奉仕
        when "対象：尻"
          m = "#{master}は#{action}、\\n#{speaker}のお尻を両手で愛撫した！"
          m = "#{master}は#{action}、\\n#{speaker}のお尻を舌で舐め回した！" if $game_variables[17] > 50 
        #アナルに奉仕
#        when "対象：アナル"
#          m = "#{master}は#{action}、\\n#{speaker}の菊座を指で愛撫した！"
#          m = "#{master}は#{action}、\\n#{speaker}の菊座を舌で舐め回した！" if $game_variables[17] > 50 
        end
      end
    #==============================================================================
    # ●愛撫・性交
    #==============================================================================
    when "愛撫・性交"
      case $msg.talk_step
      when 77 #愛撫を最初から断った場合
        m = "#{master} resists temptation,\\n and #{speaker}'s proposal!"
        m = "#{master} reluctantly tears aｗay,\\n declining #{speaker}'s proposal!" if $game_actors[101].state?(35)
      when 78 #視姦を途中で断った場合
        m = "#{master} manages to peel aｗay,\\n stopping #{speaker} mid-thrust!"
      #●愛撫を受け入れた場合
      else
        case $msg.at_parts
        #▼インサート・アクセプト
        #--------------------------------------------------------------------------
        when "♀挿入：アソコ側","尻挿入：尻側"
          if $game_variables[17] > 70
            if $game_actors[101].critical == true
              action = ["leｗdly","tightly","firmly"]
              action = action[rand(action.size)]
              move = ["tightens around","strangles","squeezes"]
              move = move[rand(move.size)]
            else
              action = ""
              move = "締め付ける"
            end
            hole = "pussy"
            hole = "ass" if $msg.at_parts == "尻挿入：尻側"
            m = "#{speaker}'s #{hole}\\n #{action} #{move} #{master}'s penis！" 
          else
            if $game_actors[101].critical == true
              if $msg.t_enemy.initiative_level > 0
                #●
                action = "holds #{master} doｗn"
                #●
                waist = ["boldly fucks","poｗerfully fucks","intensely fucks"]
                waist.push("undulatingly fucks","leｗdly fucks","pounds") if $msg.t_enemy.positive?
                waist.push("strenuously fucks","devotedly fucks","lazily fucks") if $msg.t_enemy.negative?
              else
                #●
                action = "entrusts herself to #{master}"
                #●
                waist = ["poｗerfully fucks"]
                waist.push("leｗdly fucks") if $msg.t_enemy.positive?
                waist.push("strenuously fucks") if $msg.t_enemy.negative?
              end
              waist = waist[rand(waist.size)]
            else
              if $msg.t_enemy.initiative_level > 0
                #●
                action = "gazes at #{master}"
                #●
                waist = ["slowly fucks","bounces on top of","gyrates on top"]
                waist.push("teasingly fucks","comfortably fucks") if $msg.t_enemy.positive?
                waist.push("modestly fucks","shamefully fucks") if $msg.t_enemy.negative?
              else
                #●
                action = "matches #{master}'s pace"
                #●
                waist = ["sloｗly fucks"]
                waist.push("teasingly fucks") if $msg.t_enemy.positive?
                waist.push("modestly fucks") if $msg.t_enemy.negative?
              end
              waist = waist[rand(waist.size)]
            end
            m = "#{speaker} #{action} as she #{waist} him!"
          end
        #▼オーラル
        #--------------------------------------------------------------------------
        when "口挿入：口側"
          if $game_actors[101].critical == true
            if $msg.t_enemy.initiative_level > 0
              #●
              action = "sucks"
              #●
              mouth = ["boldly","noisily","intensely"]
              mouth.push("deeply","leｗdly","slowly") if $msg.t_enemy.positive?
              mouth.push("strenuously","devotedly","lazily") if $msg.t_enemy.negative?
              mouth.push("amorously") if $mood.point > 70
            else
              #●
              action = "deepthroats"
              #●
              mouth = ["boldly"]
              mouth.push("leｗdly") if $msg.t_enemy.positive?
              mouth.push("streneously") if $msg.t_enemy.negative?
              mouth.push("amorously") if $mood.point > 70
            end
            mouth = mouth[rand(mouth.size)]
          else
            if $msg.t_enemy.initiative_level > 0
              #●
              action = "sucks"
              #●
              mouth = ["slowly"]
              mouth.push("teasingly","comfortably") if $msg.t_enemy.positive?
              mouth.push("timidly","modestly","shamefully") if $msg.t_enemy.negative?
              mouth.push("amorously") if $mood.point > 70
            else
              #●
              action = "deepthroats"
              #●
              mouth = ["sloｗly"]
              mouth.push("teasingly","gradually") if $msg.t_enemy.positive?
              mouth.push("timidly","hesitantly") if $msg.t_enemy.negative?
            end
            mouth = mouth[rand(mouth.size)]
          end
          m = "#{speaker} #{mouth} #{action} #{master}'s penis!"
        #▼パイズリ
        #--------------------------------------------------------------------------
        when "パイズリ"
          if $game_actors[101].critical == true
            action = "fucks"
            #●
            bust = ["boldly","deliberately"]
            bust.push("lewdly","poｗerfully") if $msg.t_enemy.positive?
            bust.push("strenuously","devotedly","lazily") if $msg.t_enemy.negative?
            bust.push("amorously") if $mood.point > 70
          else
            action = "sandwiches"
            #●
            bust = ["slowly","tightly"]
            bust.push("teasingly","comfortably") if $msg.t_enemy.positive?
            bust.push("timidly","modestly","shamefully") if $msg.t_enemy.negative?
            bust.push("amorously") if $mood.point > 70
          end
          bust = bust[rand(bust.size)]
          m = "#{speaker} #{bust} #{action} #{master}'s penis\\n ｗith her #{$msg.t_enemy.bustsize}!"
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
              action.push("の腰を前に押し出した！\\n#{hold_target}との結合部がより深くなった！")
            #ペニスがパイズリ中の場合
            elsif $game_actors[101].penis_paizuri?
              action.push("の腰を押さえ込んだ！\\n#{hold_target}の動きが更に激しくなった！")
            end
          else
            action.push("のわきの下を舌で舐めてきた！")
            action.push("の首筋にふぅっと息を吹きかけた！")
            action.push("の胸板に指を這わせてきた！")
            action.push("の腰をさわさわと撫でてきた！")
            action.push("の太ももをさわさわと撫でてきた！")
          end
          action = action[rand(action.size)]
          m = "#{speaker}は密着したまま、\\n#{master}#{action}"
        end
      #--------------------------------------------------------------------------
      end
    #==============================================================================
    # ●愛撫・通常
    #==============================================================================
    when "愛撫・通常"
      case $msg.talk_step
      when 77 #愛撫を最初から断った場合
        m = "#{master}は誘惑に負けず、\\n#{speaker}の申し出を断った！"
        m = "#{master}は後ろ髪を引かれる思いで、\\n何とか#{speaker}の要求を断った！" if $game_actors[101].state?(35)
      when 78 #愛撫を途中で断った場合
        m = "#{master}は何とか意思を振り絞り、\\n#{speaker}の行為を押し留めた！"
      #●愛撫を受け入れた場合
      else
        m = "#{speaker}は微笑むと、\\n#{master}のペニスを愛撫してきた！"
        case $msg.at_type
        #--------------------------------------------------------------------------
        when "手"
          #●弱点を突いた
          if $game_actors[101].critical == true
            case @weakpoints
            when 20,10
              if $msg.chain_attack == true
                m = "#{speaker}は反応を楽しむかのように、\\n#{master}のペニスを艶かしく指で弄ぶ！"
                m = "#{speaker}は愛おしむかのように、\\n#{master}のペニスを艶かしく指で弄ぶ！" if $msg.t_enemy.love > 0
              else
                m = "#{speaker}は心得た指捌きで、\\n#{master}のペニスを間断なく攻め立ててきた！"
              end
            else
              if $msg.chain_attack == true
                m = "#{speaker}は間断なく、\\n#{master}のペニスの敏感な部分を攻めてきた！"
              else
                m = "#{speaker}は指を絡めて、\\n#{master}のペニスの敏感な部分を攻めてきた！"
              end
            end
          else
            case @weakpoints
            when 20,10
              if $msg.chain_attack == true
                m = "#{speaker}は間断なく、\\n#{master}のペニスを指で攻め立てる！"
              else
                m = "#{speaker}は指を絡めて、\\n#{master}のペニスをしごき上げてきた！"
              end
            else
              if $msg.chain_attack == true
                m = "#{speaker}は、\\n#{master}のペニスに指を絡め愛撫してきた！"
              else
                m = "#{speaker}は手で、\\n#{master}のペニスをしごいてきた！"
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
                m = "#{speaker}は反応を楽しむかのように、\\n#{master}のペニスを根元から舐め上げてきた！"
                m = "#{speaker}は愛おしむかのように、\\n#{master}のペニスを根元から舐め上げてきた！" if $msg.t_enemy.love > 0
              else
                m = "#{speaker}は心得た舌使いで、\\n#{master}のペニスを間断なく舐め回してきた！"
              end
            else
              if $msg.chain_attack == true
                m = "#{speaker}は間断なく、\\n#{master}のペニスの敏感な部分を舐め続けた！"
              else
                m = "#{speaker}は舌先で、\\n#{master}のペニスの敏感な部分を舐め上げた！"
              end
            end
          else
            case @weakpoints
            when 20,10
              if $msg.chain_attack == true
                m = "#{speaker}は間断なく、\\n#{master}のペニスを丹念に舐め上げてきた！"
              else
                m = "#{speaker}は舌先で、\\n#{master}のペニスを焦らすように舐め上げた！"
              end
            else
              if $msg.chain_attack == true
                m = "#{speaker}は休むことなく、\\n#{master}のペニスを丹念に舐め上げてきた！"
              else
                m = "#{speaker}は舌で、\\n#{master}のペニスを舐め上げてきた！"
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
                m = "#{speaker}は反応を楽しむかのように、\\n#{master}のペニスを両足の裏でしごいてきた！"
                m = "#{speaker}は愛おしむかのように、\\n#{master}のペニスを両足の裏でしごいてきた！" if $msg.t_enemy.love > 0
              else
                m = "#{speaker}は心得ていると言わんばかりに、\\n#{master}のペニスを足裏で捏ね回してきた！"
              end
            else
              if $msg.chain_attack == true
                m = "#{speaker}は休むことなく、\\n#{master}のペニスを足裏で捏ね回してきた！"
              else
                m = "#{speaker}は足の裏で、\\n#{master}のペニスの敏感な部分をしごいてきた！"
              end
            end
          else
            case @weakpoints
            when 20,10
              if $msg.chain_attack == true
                m = "#{speaker}は緩急をつけながら、\\n#{master}のペニスを足の指で更に弄ぶ！"
              else
                m = "#{speaker}は足の指で、\\n#{master}のペニスを焦らすように弄んできた！"
              end
            else
              if $msg.chain_attack == true
                m = "#{speaker}は緩急をつけながら、\\n#{master}のペニスを足裏でしごいてきた！"
              else
                m = "#{speaker}は足の裏で、\\n#{master}のペニスを軽く踏みつけた！"
              end
            end
          end
        #--------------------------------------------------------------------------
        when "胸"
          if $msg.chain_attack == true
            m = "#{speaker}は#{$msg.t_enemy.bustsize}で、\\n#{master}のペニスを間断なく愛撫してきた！"
            m = "#{speaker}は#{$msg.t_enemy.bustsize}を、\\n#{master}のペニスに擦り付けてきた！" if $data_SDB[$msg.t_enemy.class_id].bust_size < 3
          else
            m = "#{speaker}は#{$msg.t_enemy.bustsize}で、\\n#{master}のペニスを挟みしごいてきた！"
            m = "#{speaker}は#{$msg.t_enemy.bustsize}を、\\n#{master}のペニスに押し付けてきた！" if $data_SDB[$msg.t_enemy.class_id].bust_size < 3
          end
          #●弱点を突いた
          if $game_actors[101].critical == true
            case @weakpoints
            when 20,10
              if $msg.chain_attack == true
                if $data_SDB[$msg.t_enemy.class_id].bust_size < 3
                  m = "#{speaker}は反応を楽しむかのように、\\n#{$msg.t_enemy.bustsize}をペニスに擦り付けてきた！"
                  m = "#{speaker}は愛おしむかのように、\\n#{$msg.t_enemy.bustsize}をペニスに擦り付けてきた！" if $msg.t_enemy.love > 0
                else
                  m = "#{speaker}は反応を楽しむかのように、\\n#{$msg.t_enemy.bustsize}でペニスを艶かしく愛撫してきた！"
                  m = "#{speaker}は愛おしむかのように、\\n#{$msg.t_enemy.bustsize}でペニスを艶かしく愛撫してきた！" if $msg.t_enemy.love > 0
                end
              else
                m = "#{speaker}は#{$msg.t_enemy.bustsize}で、\\n#{master}のペニスを挟みしごいてきた！"
                m = "#{speaker}は#{$msg.t_enemy.bustsize}を、\\n#{master}のペニスに押し付けてきた！" if $data_SDB[$msg.t_enemy.class_id].bust_size < 3
              end
            else
              if $msg.chain_attack == true
                m = "#{speaker}は#{$msg.t_enemy.bustsize}で、\\n#{master}のペニスを間断なく愛撫してきた！"
                m = "#{speaker}は#{$msg.t_enemy.bustsize}を、\\n#{master}のペニスに擦り付けてきた！" if $data_SDB[$msg.t_enemy.class_id].bust_size < 3
              else
                m = "#{speaker}は#{$msg.t_enemy.bustsize}で、\\n#{master}のペニスを挟みしごいてきた！"
                m = "#{speaker}は#{$msg.t_enemy.bustsize}を、\\n#{master}のペニスに押し付けてきた！" if $data_SDB[$msg.t_enemy.class_id].bust_size < 3
              end
            end
          else
            case @weakpoints
            when 20,10
              if $msg.chain_attack == true
                m = "#{speaker}は#{$msg.t_enemy.bustsize}で、\\n#{master}のペニスを間断なく愛撫してきた！"
                m = "#{speaker}は#{$msg.t_enemy.bustsize}を、\\n#{master}のペニスに擦り付けてきた！" if $data_SDB[$msg.t_enemy.class_id].bust_size < 3
              else
                m = "#{speaker}は#{$msg.t_enemy.bustsize}で、\\n#{master}のペニスを挟みしごいてきた！"
                m = "#{speaker}は#{$msg.t_enemy.bustsize}を、\\n#{master}のペニスに押し付けてきた！" if $data_SDB[$msg.t_enemy.class_id].bust_size < 3
              end
            else
              if $msg.chain_attack == true
                m = "#{speaker}は#{$msg.t_enemy.bustsize}で、\\n#{master}のペニスを間断なく愛撫してきた！"
                m = "#{speaker}は#{$msg.t_enemy.bustsize}を、\\n#{master}のペニスに擦り付けてきた！" if $data_SDB[$msg.t_enemy.class_id].bust_size < 3
              else
                m = "#{speaker}は#{$msg.t_enemy.bustsize}で、\\n#{master}のペニスを挟みしごいてきた！"
                m = "#{speaker}は#{$msg.t_enemy.bustsize}を、\\n#{master}のペニスに押し付けてきた！" if $data_SDB[$msg.t_enemy.class_id].bust_size < 3
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
                m = "As if enjoying his reaction, #{speaker}\\n continues to bounce up and doｗn #{master}'s penis!"
                m = "#{speaker} continues to lovingly bounce\\n up and doｗn #{master}'s penis!" if $msg.t_enemy.love > 0
              else
                m = "Having found his ｗeakness, #{speaker} grinds\\n her pussy doｗn on #{master}'s penis!"
              end
            else
              if $msg.chain_attack == true
                m = "#{speaker} continues grinding her hips\\n back and forth on #{master}'s penis!"
              else
                m = "#{speaker} rubs her pussy on #{master},\\n vigorously inciting response from his penis!"
              end
            end
          else
            case @weakpoints
            when 20,10
              if $msg.chain_attack == true
                m = "#{speaker} continues bouncing\\n atop #{master}'s penis!"
              else
                m = "#{speaker} rubs her pussy against\\n #{master}'s penis!"
              end
            else
              if $msg.chain_attack == true
                m = "#{speaker} continues bouncing\\n atop #{master}'s penis!"
              else
                m = "#{speaker} rubs her pussy against\\n #{master}'s penis!"
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
                m = "#{speaker}は反応を楽しむかのように、\\n#{master}のペニスを尻尾でしごいてきた！"
                m = "#{speaker}は愛おしむかのように、\\n#{master}のペニスを尻尾でしごいてきた！" if $msg.t_enemy.love > 0
              else
                m = "#{speaker}は慣れた腰使いで、\\n#{master}のペニスを尻尾で弄んできた！"
              end
            else
              if $msg.chain_attack == true
                m = "#{speaker}は尻尾をくねらせ、\\n#{master}のペニスを間断なくしごき上げてきた！"
              else
                m = "#{speaker}は尻尾を巧みに使い、\\n#{master}のペニスをしごき上げてきた！"
              end
            end
          else
            case @weakpoints
            when 20,10
              if $msg.chain_attack == true
                m = "#{speaker}はリズミカルに、\\n尻尾で#{master}のペニスをしごき上げてきた！"
              else
                m = "#{speaker}は自分の尻尾を、\\n#{master}のペニスに巻き付けてきた！"
              end
            else
              if $msg.chain_attack == true
                m = "#{speaker}はリズミカルに、\\n尻尾で#{master}のペニスをしごき上げてきた！"
              else
                m = "#{speaker}は自分の尻尾を、\\n#{master}のペニスに巻き付けてきた！"
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
          m = "#{speaker}は#{master}のペニスを、\\n#{mouth}#{action}！"
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
          m = "#{speaker}は#{$msg.t_enemy.bustsize}で、\\n#{master}のペニスを#{bust}#{action}！"
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
              action.push("の腰を前に押し出した！\\n#{hold_target}との結合部がより深くなった！")
            #ペニスがパイズリ中の場合
            elsif $game_actors[101].penis_paizuri?
              action.push("の腰を押さえ込んだ！\\n#{hold_target}の動きが更に激しくなった！")
            end
          else
            action.push("のわきの下を舌で舐めてきた！")
            action.push("の首筋にふぅっと息を吹きかけた！")
            action.push("の胸板に指を這わせてきた！")
            action.push("の腰をさわさわと撫でてきた！")
            action.push("の太ももをさわさわと撫でてきた！")
          end
          action = action[rand(action.size)]
          m = "#{speaker}は密着したまま、\\n#{master}#{action}"
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
          m = "Having invited #{master}, #{speaker} quickly\\n stabs his penis into her pussy before he can escape!"
        when 77 #挿入拒否
          m = "#{master} hardens his resolve to resist her invitation!"
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
      m = "#{speaker} leans on #{master}'s chest,\\n gazing deeply into his eyes...!"
      m = "#{speaker} leans on #{master}, taking fleeting\\n glances at him ｗhile tｗirling her finger on his chest!" if $msg.t_enemy.negative?
    #==============================================================================
    # ●仲間脱衣
    #==============================================================================
    when "仲間脱衣"
      m = "#{speaker} gazes at #{servant}\\n ｗith a suggestive look on her face...!"
      m = "#{speaker} stares at #{servant}\\n ｗith an insinuating look on her face...!" if $msg.t_enemy.negative?
    #==============================================================================
    # ●夢魔脱衣
    #==============================================================================
    when "夢魔脱衣"
      m = "#{speaker} begins peeling back her clothes,\\n turning toｗards #{master} ｗith a lustful expression!"
      m = "#{speaker} begins peeling back her clothes,\\n eyeing #{master} ｗith suggestive intent!" if $msg.t_enemy.negative?
      m = "#{speaker} shakes the jiggling slime covering\\n her body in front of #{master}'s eyes....!" if $msg.t_enemy.tribe_slime?
    #==============================================================================
    # ●吸精・口
    #==============================================================================
    when "吸精・口"
      m = "#{speaker} closes her eyes,\\n bringing her face close to #{master}'s lips...!"
      m = "#{speaker} smiles,\\n bringing her face close to #{master}'s lips...!" if $msg.t_enemy.positive?
    #==============================================================================
    # ●吸精・性器
    #==============================================================================
    when "吸精・性器"
      m = "#{speaker} closes her eyes,\\n bringing her face close to #{master}'s crotch...!"
      m = "#{speaker} smiles,\\n bringing her face close to #{master}'s crotch...!" if $msg.t_enemy.positive?
    #==============================================================================
    # ●視姦
    #==============================================================================
    when "視姦"
      emotion = ""
      case $msg.t_enemy.personality
      when "好色","高慢"
        emotion = "smiles suggestively"
      when "陽気","柔和","勝ち気"
        emotion = "smiles mischievously"
      when "虚勢","甘え性"
        emotion = "coyly glances in and out of eye contact"
      when "内気"
        emotion = "shyly turns her face the other ｗay"
      when "意地悪"
        emotion = "grins provacatively"
      when "不思議","上品","倒錯"
        emotion = "smiles mysteriously"
      when "淡泊","従順"
        emotion = "blushes slightly"
      when "天然"
        emotion = "looks ｗith a sleepy expression"
      else
        emotion = "stands on full display"
      end
      #テキスト整形(口、尻系は現在は封印のため、他部位に割り振り)
      case $msg.at_parts
      #胸や乳首で自慰
      when "対象：胸","対象：口"
        m = "#{speaker} #{emotion},\\n tracing her #{$msg.t_enemy.bustsize} ｗith her finger!"
      #アソコに指入れで自慰
      when "対象：アソコ","対象：尻"
        m = "#{speaker} #{emotion},\\n tracing a finger doｗn to her crotch!"
      #陰核を弄って自慰
      when "対象：陰核","対象：アナル"
        m = "#{speaker} #{emotion},\\n tracing her finger around her clit!"
      end
    #==============================================================================
    # ●奉仕
    #==============================================================================
    when "奉仕"
      #テキスト整形
      case $msg.at_parts
      #キッスで奉仕
      when "対象：口"
        m = "#{speaker} closes her eyes,\\n offering #{master} her lips!"
      #胸や乳首に奉仕
      when "対象：胸"
        m = "#{speaker} clings tightly to #{master},\\n pressing her #{$msg.t_enemy.bustsize} against his arm!"
      #アソコに奉仕
      when "対象：アソコ","対象：アナル"
        m = "#{speaker} approaches #{master}\n\ and spreads open her pussy ｗith her fingers!"
        m = "ｗith her fingers, #{speaker} bashfully spreads\\n open her intimates!" if $msg.t_enemy.negative?
      #陰核に奉仕
      when "対象：陰核"
        m = "#{speaker} approaches #{master}\n\ and spreads open her pussy ｗith her fingers!"
        m = "ｗith her fingers, #{speaker} bashfully spreads\\n open her intimates!" if $msg.t_enemy.negative?
      #お尻に奉仕
      when "対象：尻"
        m = "Face doｗn, #{speaker} kneels over before #{master},\\n and ｗaves her butt in front of his face!"
        m = "Face doｗn,#{speaker} shyly kneels over,\\n ｗaving her rear in front of #{master}!" if $msg.t_enemy.negative?
      #アナルに奉仕
#      when "対象：アナル"
#        m = "#{master}は#{action}、\\n#{speaker}の菊座を指で愛撫した！"
#        m = "#{master}は#{action}、\\n#{speaker}の菊座に舌を這わせた！" if $game_variables[17] > 50 
      end
    #==============================================================================
    # ●愛撫・通常
    #==============================================================================
    when "愛撫・通常"
      emotion = ""
      case $msg.t_enemy.personality
      when "勝ち気","高慢","意地悪"
        emotion = "licks her lips"
      when "上品","柔和"
        emotion = "softly smiles"
      when "淡泊","虚勢"
        emotion = "glances fleetingly"
      when "内気","従順","倒錯"
        emotion = "looks ｗith feverish eyes"
      when "不思議","天然"
        emotion = "bears an admiring look"
      when "陽気","甘え性"
        emotion = "smiles mischievously"
      else #好色
        emotion = "smiles suggestively"
      end
      m = "#{speaker}は#{emotion}、\\n#{master}のペニスを見つめている！"
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
        m = "#{speaker}は#{emotion}、\\n#{master}#{action}！"
      end
    #==============================================================================
    # ●愛撫・性交
    #==============================================================================
    when "愛撫・性交"
      emotion = ""
      case $msg.t_enemy.personality
      when "勝ち気","高慢","意地悪"
        emotion = "licks her lips"
      when "上品","柔和"
        emotion = "softly smiles"
      when "淡泊","虚勢"
        emotion = "looks ｗith feverish eyes"
      when "内気","従順","倒錯"
        emotion = "stares ｗith longing eyes"
      when "不思議","天然"
        emotion = "bears a carefree smile"
      when "陽気","甘え性"
        emotion = "smiles mischievously"
      else #好色
        emotion = "smiles suggestively"
      end
      action = []
      case $msg.at_parts
      #▼インサート・アクセプト
      #--------------------------------------------------------------------------
      when "♀挿入：アソコ側","尻挿入：尻側"
        action.push("turning her backside toｗards #{master}")
        action.push("looking doｗn at #{master}") if $msg.t_enemy.initiative_level > 0
      when "口挿入：口側","パイズリ"
        action.push("looking up at #{master}")
        action.push("toying around ｗith #{master}'s penis") if $msg.t_enemy.initiative_level > 0
      when "背面拘束"
        action.push("holding #{master} doｗn even more")
      else
        action.push("holding #{master} doｗn even more")
      end
      action = action[rand(action.size)]
      m = "#{speaker} #{emotion},\\n #{action}!"
    #==============================================================================
    # ●交合
    #==============================================================================
    when "交合"
      case $msg.t_enemy.personality
      when "好色"
        m = "#{speaker} teases open her pussy,\\n smiling promiscuously as she beckons #{master}!" #前
        m = "#{speaker} crawls doｗn on all fours,\\n reaching back to spread her pussy temptingly!" if $game_variables[17] > 50 #後
      when "上品"
        m = "As if to tempt him, #{speaker}\n\ spreads her legs and beckons #{master} ｗith her finger!" #前
        m = "#{speaker} crawls doｗn on all fours,\\n seductively gazing into #{master}'s eyes!" if $game_variables[17] > 50 #後
      when "高慢"
        m = "#{speaker} teases open her pussy,\\n smiling at #{master} ｗith a procative gaze!" #前
        m = "#{speaker} thrusts out her ass,\\n throwing #{master} a daring smile!" if $game_variables[17] > 50 #後
      when "淡泊"
        m = "#{speaker} blushes shyly,\\n opening up her legs for #{master} to see!" #前
        m = "#{speaker} crawls doｗn on all fours,\\n giving #{master} a welcoming gaze!" if $game_variables[17] > 50 #後
      when "柔和"
        m = "As if to tempt him, #{speaker}\n\ spreads her legs and beckons #{master} ｗith her finger!" #前
        m = "#{speaker} crawls doｗn on all fours,\\n reaching back to spread her pussy temptingly!" if $game_variables[17] > 50 #後
      when "勝ち気"
        m = "#{speaker} boldly spreads her legs apart,\\n casting a provoking gaze at #{master}!" #前
        m = "#{speaker} crawls doｗn on all fours,\\n throwing #{master} a fearless smile!" if $game_variables[17] > 50 #後
      when "内気"
        m = "Covering her face ｗith her hands,\\n #{speaker} opens her legs for #{master} to see!" #前
        m = "#{speaker} crawls doｗn on all fours,\\n shamefully turns her butt toｗards #{master}!" if $game_variables[17] > 50 #後
      when "陽気"
        m = "#{speaker} boldly spreads her legs apart、\\n staring at #{master} ｗith expectant eyes!" #前
        m = "#{speaker} thrusts out her ass,\\n staring at #{master} ｗith expectant eyes!" if $game_variables[17] > 50 #後
      when "意地悪"
        m = "As if to tempt him, #{speaker}\n\ spreads her legs and beckons #{master} ｗith her finger!" #前
        m = "#{speaker} crawls doｗn on all fours, \\n reaching back to spread her pussy temptingly!" if $game_variables[17] > 50 #後
      when "天然"
        m = "#{speaker} looks expectantly at #{master}\\n as she spreads open her legs!" #前
        m = "#{speaker} craｗls doｗn on all fours,\\n staring at #{master} ｗith longing eyes!" if $game_variables[17] > 50 #後
      when "従順"
        m = "#{speaker} boldly spreads her legs apart,\\n looking obediently at #{master}!" #前
        m = "#{speaker} thrusts out her ass,\\n staring at #{master} ｗith longing eyes!" if $game_variables[17] > 50 #後
      when "虚勢"
        m = "#{speaker} doggedly spreads open her legs,\\n and shoots a provoking gaze at #{master}!" #前
        m = "#{speaker} thrusts out her ass,\\n and looks at #{master} ｗith a challenging expression!" if $game_variables[17] > 50 #後
      when "倒錯"
        m = "#{speaker} teases open her pussy,\\n throｗing #{master} a bewitching smile!" #前
        m = "#{speaker} craｗls doｗn on all fours、\\n staring at #{master} ｗith longing eyes!" if $game_variables[17] > 50 #後
      when "甘え性"
        m = "#{speaker} looks expectantly, \\n ｗatching #{master} as she spreads her legs!" #前
        m = "#{speaker} craｗls doｗn on all fours,\\n staring at #{master} ｗith longing eyes!" if $game_variables[17] > 50 #後
      when "不思議"
        m = "#{speaker} slowly opens up her legs, ｗatching \\n #{master} as she lifts up her pelvis!" #前
        m = "#{speaker} thrusts out her ass,\\n looking back at #{master}!" if $game_variables[17] > 50 #後
      when "独善"
        m = "#{speaker} opens her legs for display,\\n throwing #{master} a bewitching smile!" #前
        m = "#{speaker} crawls doｗn on all fours,\\n arching her ass high as if to provoke #{master}!" if $game_variables[17] > 50 #後
      end
    end
   #============================================================================
    return if m == ""
    $game_temp.battle_log_text += m
  end
###############################################################################  
end