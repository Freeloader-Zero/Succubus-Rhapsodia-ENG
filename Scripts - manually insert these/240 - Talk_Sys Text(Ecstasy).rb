#==============================================================================
# ■ Talk_Sys(分割定義 3)
#------------------------------------------------------------------------------
#   夢魔の口上を検索、表示するためのクラスです。
#   このクラスのインスタンスは $msg で参照されます。
#   ここでは絶頂時のテキストを設定します
#==============================================================================
class Talk_Sys
  def make_text
#########################################################################################################
#●基本情報読み込み
 t_actor = $msg.t_target.name #会話対象のアクター名
 speaker = $msg.t_enemy.name #会話中のエネミー名
 master = $game_actors[101].name #主人公名
 #▼存在するなら、パートナー名
 if $msg.t_partner != nil
   servant = $msg.t_target.name
   servant = $msg.t_partner.name if $msg.t_target == $game_actors[101] 
 else
   servant = nil
 end
 #▼掛け合い時は会話対象を呼び出す
 if $game_switches[97]
   coop_leader = $msg.coop_leader.name
 else
   coop_leader = nil
 end
 # デバッグ用
 if $game_switches[97] and $DEBUG # 掛け合い時限定
   error = "■エラー内容"
   unless master.is_a?(String)
     error += "\nマスターが文字列ではない"
   end
   unless speaker.is_a?(String)
     error += "\nスピーカーが文字列ではない"
   end
   unless coop_leader.is_a?(String)
     error += "\nバックエネミーが文字列ではない"
   end
   unless error == "■エラー内容"
     print error
   end
 end
#########################################################################################################
if $game_temp.battle_active_battler.is_a?(Game_Enemy)
#========================================================================================================
case $msg.at_type
#----------------------------------------------------------------------------------------
when "ホールド攻撃"
#----------------------------------------------------------------------------------------
when "キス"
#----------------------------------------------------------------------------------------
when "手"
#----------------------------------------------------------------------------------------
when "口"
#----------------------------------------------------------------------------------------
when "胸"
#----------------------------------------------------------------------------------------
when "♀"
#----------------------------------------------------------------------------------------
when "足"
#----------------------------------------------------------------------------------------
end
#========================================================================================================
#▼メッセージが無い場合、汎用攻めテキストを入れる
if m = ""
  case $msg.talk_step
  when 1 #◆初撃
    emotion = ["微笑を浮かべ","反応を楽しむかのように"]
    emotion.push("上目遣いに","甘えるような仕種で") if $msg.t_enemy.age == 1
    emotion.push("妖艶な笑みを浮かべ") if $msg.t_enemy.age >= 3
    emotion.push("悪戯っぽく笑みを浮かべ") if $msg.t_enemy.positive?
    emotion.push("くすりと微笑むと") if $msg.t_enemy.negative?
    emotion.push("蔑むような表情で","にやりと笑い","すうっと目を細めると") if $msg.t_enemy.personality == "高慢" or $msg.t_enemy.personality == "意地悪" or $msg.t_enemy.personality == "露悪狂"
    emotion = ["恍惚とした表情で","熱っぽい瞳で"] if $msg.t_enemy.crisis?
    emotion = emotion[rand(emotion.size)]
    #------
    action = ["焦らすように","緩急をつけて"]
    action.push("大胆に","激しく") if $msg.t_enemy.positive?
    action.push("優しく","丁寧に") if $msg.t_enemy.negative?
    action.push("一所懸命") if $msg.t_enemy.personality == "従順" or $msg.t_enemy.personality == "甘え性"
    action = action[rand(action.size)]
    #------
    if $msg.t_enemy.inserting_now? and $msg.t_enemy.vagina_insert?
      text = ["腰を振ってきた！","腰を動かしてきた！"]
      text = text[rand(text.size)]
    elsif $msg.t_enemy.oralsex_now? and $msg.t_enemy.mouth_oralsex?
      text = ["#{t_actor}のペニスを舐め回してきた！","#{t_actor}のペニスをしゃぶってきた！"]
      text = text[rand(text.size)]
    else
      text = "#{t_actor}を愛撫してきた！"
    end
    m = "#{speaker}は#{emotion}、\n#{action}#{text}"
  #-------------------------------------------------------------------------------------------------
  when 2..5 #◆連携
    if $msg.t_enemy.ecstasy_emotion == "喜"
      emotion = ["#{coop_leader}に微笑み"]
      emotion.push("#{coop_leader}に目配せし","#{coop_leader}に合わせ") if $msg.t_enemy.age >= 3 or $msg.t_enemy.tribe == $msg.coop_leader.tribe
      emotion.push("#{coop_leader}に促され") if $msg.t_enemy.negative?
    elsif $msg.t_enemy.ecstasy_emotion == "怒"
      emotion = ["#{coop_leader}に負けじと"]
      emotion.push("#{coop_leader}を睨むと","#{coop_leader}に張り合い") if $msg.t_enemy.age >= 3 or $msg.t_enemy.tribe == $msg.coop_leader.tribe
      emotion.push("複雑な表情を浮かべ","不満げな視線で") if $msg.t_enemy.negative?
    end
    emotion = emotion[rand(emotion.size)]
    #------
    if $msg.t_enemy.ecstasy_emotion == "喜"
      action = ["#{t_actor}の抵抗を阻害してきた！","#{t_actor}の動きを押さえ込んできた！"]
    elsif $msg.t_enemy.ecstasy_emotion == "怒"
      action = ["#{t_actor}を愛撫しはじめた！","#{t_actor}に密着してきた！"]
    end
    #▼アクセプト(♀挿入)状態
    if $msg.t_enemy.vagina_insert?
      action = ["艶かしく腰を前後させてきた！","激しく腰を動かしてきた！","アソコをきゅっと締めてきた！","激しく腰を前後させてきた！","艶かしく腰を振ってきた！"]
    #▼オーラルアクセプト(口挿入)状態
    elsif $msg.t_enemy.mouth_oralsex?
      action = ["#{t_actor}のペニスをしゃぶってきた！","#{t_actor}のペニスを口内で舐め回した！","#{t_actor}のペニスを喉奥まで飲み込んできた！"]
    #▼バックアクセプト(尻挿入)状態
    elsif $msg.t_enemy.anal_analsex?
      action = ["艶かしく腰を前後させてきた！","激しく腰を動かしてきた！","菊座をきゅっと締めてきた！","激しく腰を前後させてきた！","艶かしく腰を振ってきた！"]
    #▼エンブレイス(密着)状態
    elsif $msg.t_enemy.tops_binder?
      action = ["密着したまま#{t_actor}を愛撫してきた！"]
    #▼ペリスコープ(パイズリ)状態
    elsif $msg.t_enemy.tops_paizuri?
      action = ["#{$msg.t_enemy.bustsize}で挟んだ#{t_actor}のペニスを、\n艶かしい動きで擦り上げてきた！"]
    #▼ヘブンリーフィール(ぱふぱふ)状態
    elsif $msg.t_enemy.tops_pahupahu?
      action = ["絶頂寸前の#{t_actor}の顔を、\n#{$msg.t_enemy.bustsize}で抱きしめてきた！"]
    #▼エキサイトビュー(顔面騎乗)状態
    elsif $msg.t_enemy.vagina_riding?
      action = ["#{t_actor}の顔に騎乗したまま、\n腰を落としてアソコを押し付けてきた！"]
      action.push("#{t_actor}の顔に騎乗したまま、\nゆっくりと腰を前後させてきた！")
      action.push("#{t_actor}の顔に騎乗したまま、\n腰を艶かしく前後させてきた！") if $msg.t_enemy.positive?
    #▼インモラルビュー(尻顔面騎乗)状態
    elsif $msg.t_enemy.anal_hipriding?
      action = ["#{t_actor}の顔に騎乗したまま、\n腰を落としてお尻を押し付けてきた！"]
      action.push("#{t_actor}の顔に騎乗したまま、\nゆっくりと腰を前後させてきた！")
      action.push("#{t_actor}の顔に騎乗したまま、\nお尻を艶かしく前後させてきた！") if $msg.t_enemy.positive?
    #▼シェルマッチ(貝合わせ)状態
    elsif $msg.t_enemy.shellmatch?
      action = ["#{t_actor}の脚を抱えて腰を振ってきた！","#{t_actor}の脚を抱えて腰を動かしてきた！"]
      action.push("#{t_actor}とアソコを密着させたまま、\n腰をくねらせてアソコを刺激してきた！") if $msg.t_enemy.positive?
    #▼フラッタナイズ(ディープキス)状態
    elsif $msg.t_enemy.deepkiss?
      action = ["#{t_actor}を抱き寄せ、熱いキスを交わした！","#{t_actor}と濃厚なキスを交わした！"]
    #▼ドロウネクター(クンニリングス)状態
    elsif $msg.t_enemy.mouth_draw?
      action = ["#{t_actor}のアソコに舌を挿し入れてきた！","#{t_actor}のアソコを激しく舐め上げてきた！"]
      action.push("#{t_actor}の愛蜜を音を立てて吸ってきた！") if $msg.t_enemy.positive?
    #▼ディルドインサート(ディルド♀挿入)状態
    elsif $msg.t_enemy.dildo_insert?
      action = ["#{t_actor}の反応を楽しむように、\nディルドを艶かしく前後させてきた！"]
    #▼ディルドインマウス(ディルド口挿入)状態
    elsif $msg.t_enemy.dildo_oralsex?
      action = ["#{t_actor}の反応を楽しむように、\nディルドを艶かしく前後させてきた！"]
    #▼ディルドインバック(ディルド尻挿入)状態
    elsif $msg.t_enemy.dildo_analsex?
      action = ["#{t_actor}の反応を楽しむように、\nディルドを艶かしく前後させてきた！"]
    end
    action = action[rand(action.size)]
    #------
    m = "#{speaker}は#{emotion}、\n#{action}"
  #-------------------------------------------------------------------------------------------------
  when 7 #◆追撃(特定ホールドのみ)
    emotion = ["微笑を浮かべ","反応を楽しみながら"]
    emotion.push("上目遣いで","甘えるように") if $msg.t_enemy.age == 1
    emotion.push("妖艶な表情で") if $msg.t_enemy.age >= 3
    emotion.push("悪戯っぽく笑い") if $msg.t_enemy.positive?
    emotion.push("くすりと微笑み") if $msg.t_enemy.negative?
    emotion.push("蔑むような視線で","にやにやと笑い","すうっと目を細め") if $msg.t_enemy.personality == "高慢" or $msg.t_enemy.personality == "意地悪" or $msg.t_enemy.personality == "露悪狂"
    emotion = ["恍惚とした表情で","熱に浮かされるように"] if $msg.t_enemy.crisis?
    emotion = emotion[rand(emotion.size)]
    #------
    action = ["更に焦らすように"]
    action.push("更に激しく") if $msg.t_enemy.positive?
    action.push("じっくりと") if $msg.t_enemy.negative?
    action.push("より丁寧に") if $msg.t_enemy.personality == "従順"
    action = action[rand(action.size)]
    if $msg.t_enemy.inserting_now? and $msg.t_enemy.vagina_insert?
      text = ["腰を振ってきた！","腰を動かしてきた！"]
      text = text[rand(text.size)]
    elsif $msg.t_enemy.oralsex_now? and $msg.t_enemy.mouth_oralsex?
      text = ["#{t_actor}のペニスを舐め回してきた！","#{t_actor}のペニスをしゃぶってきた！"]
      text = text[rand(text.size)]
    else
      text = "#{t_actor}を愛撫してきた！"
    end
    #------
    m = "#{speaker}は#{emotion}、\n#{action}#{text}"
  #-------------------------------------------------------------------------------------------------
  when 9 #◆とどめ
    emotion = ["とどめとばかりに","くすりと小さく笑い"]
    emotion.push("上目遣いで","甘えるように") if $msg.t_enemy.age == 1
    emotion.push("妖艶な表情で") if $msg.t_enemy.age >= 3
    emotion.push("悪戯っぽく笑い") if $msg.t_enemy.positive?
    emotion.push("笑みを絶やさず") if $msg.t_enemy.negative?
    emotion.push("蔑むような視線で","にやにやと笑い","すうっと目を細め") if $msg.t_enemy.personality == "高慢" or $msg.t_enemy.personality == "意地悪" or $msg.t_enemy.personality == "露悪狂"
    emotion = ["恍惚とした表情で","熱に浮かされるように"] if $msg.t_enemy.crisis?
    emotion = emotion[rand(emotion.size)]
    #------
    action = ["畳み掛けるように"]
    action.push("的確な愛撫で") if $msg.t_enemy.age >= 3
    action.push("なおも激しく") if $msg.t_enemy.positive?
    action.push("大胆に") if $msg.t_enemy.negative?
    action.push("なおも丁寧に","一心不乱に") if $msg.t_enemy.personality == "従順"
    action = action[rand(action.size)]
    if $msg.t_enemy.inserting_now? and $msg.t_enemy.vagina_insert?
      text = ["腰を振ってきた！","腰を動かしてきた！"]
      text = text[rand(text.size)]
    elsif $msg.t_enemy.oralsex_now? and $msg.t_enemy.mouth_oralsex?
      text = ["#{t_actor}のペニスを舐め回してきた！","#{t_actor}のペニスをしゃぶってきた！"]
      text = text[rand(text.size)]
    else
      text = "#{t_actor}を攻め立てた！"
    end
    #------
    m = "#{speaker}は#{emotion}、\n#{action}#{text}"
  #-------------------------------------------------------------------------------------------------
  when 10 #◆余韻
    action = ["満足げな笑みを浮かべている……！","くすくすと笑っている……！"]
    action.push("妖艶な笑みを浮かべ、\n#{t_actor}を見つめている……！") if $msg.t_enemy.age >= 3
    action.push("微笑みながら、\n#{t_actor}の髪を撫でている……！") if $msg.t_enemy.personality == "上品"
    action.push("蔑むような瞳で、\n#{t_actor}を見下ろしている……！") if $msg.t_enemy.personality == "高慢"
    action.push("にやにやと笑いながら、\n#{t_actor}を見下ろしている……！") if $msg.t_enemy.personality == "意地悪"
    action.push("勝ち誇ったような表情で、\n#{t_actor}を見下ろしている……！") if $msg.t_enemy.personality == "勝ち気"
    action.push("自分の行為を思い出し、\n恥ずかしがっている……！") if $msg.t_enemy.personality == "内気"
    action.push("#{t_actor}に密着し、\n愛おしそうに頬ずりしている……！") if $msg.t_enemy.personality == "甘え性"
    action.push("惚けたような表情で、\n#{t_actor}を見つめている……！") if $msg.t_enemy.personality == "不思議"
    action = action[rand(action.size)]
    #------
    m = "#{speaker}は#{action}"
  #-------------------------------------------------------------------------------------------------
  when 11..14 #◆連携余韻
    if $msg.t_enemy.ecstasy_emotion == "喜"
      emotion = ["一息つくと","満足そうに"]
      emotion.push("やり遂げた表情で") if $msg.t_enemy.tribe == $msg.coop_leader.tribe
      emotion.push("楽しげな様子で") if $msg.t_enemy.positive?
      emotion.push("満ち足りた様子で") if $msg.t_enemy.negative?
    elsif $msg.t_enemy.ecstasy_emotion == "怒"
      emotion = ["ため息をつくと","複雑な表情で","残念そうな様子で"]
    end
    emotion = emotion[rand(emotion.size)]
    #------
    if $msg.t_enemy.ecstasy_emotion == "喜"
      action = ["#{cp_leader}に微笑んだ……！","#{t_actor}に微笑んだ……！"]
      action.push("行為の余韻を楽しんでいる……！") if $msg.t_enemy.age >= 3
      action.push("#{cp_leader}と笑顔を向け合っている……！") if $msg.t_enemy.tribe == $msg.coop_leader.tribe
    elsif $msg.t_enemy.ecstasy_emotion == "怒"
      action = ["#{cp_leader}に不満げな視線を送った……！","#{t_actor}に不満げな視線を送った……！"]
      action.push("#{cp_leader}に恨めしげな視線を送っている！") if $msg.t_enemy.personality == "倒錯"
      action.push("#{cp_leader}に不満の声を上げている……！") if $msg.t_enemy.personality == "高慢"
      action.push("#{t_actor}を悲しげに見つめている……") if $msg.t_enemy.personality == "内気"
    end
    action = action[rand(action.size)]
    #------
    m = "#{speaker}は#{emotion}、\n#{action}"
  #-------------------------------------------------------------------------------------------------
  when 20 #◆戦闘継続(ホールド中の場合は解除する)
    emotion = ["くすりと笑い"]
    emotion.push("悪戯っぽく笑い") if $msg.t_enemy.age == 1
    emotion.push("満足げな表情で") if $msg.t_enemy.age >= 3
    emotion.push("満足げな表情で") if $msg.t_enemy.positive?
    emotion.push("くすりと笑い") if $msg.t_enemy.negative?
    emotion.push("意地悪げな笑みを浮かべ") if $msg.t_enemy.personality == "高慢" or $msg.t_enemy.personality == "意地悪" or $msg.t_enemy.personality == "露悪狂"
    emotion = ["名残惜しそうに"] if $msg.t_enemy.crisis?
    emotion = emotion[rand(emotion.size)]
    #------
    action = ["#{t_actor}から離れた……！"]
    action.push("#{t_actor}にそっと口付けすると、\n#{t_actor}を解放した……！") if $msg.t_enemy.age >= 3 or $msg.t_enemy.personality == "従順"
    action.push("#{t_actor}を解放した……！") if $msg.t_enemy.positive?
    action = action[rand(action.size)]
    #------
    m = "#{speaker}は#{emotion}、\n#{action}"
  #-------------------------------------------------------------------------------------------------
  when 21 #◆戦闘継続(ホールド中の場合は継続)
    emotion = ["くすりと笑い"]
    emotion.push("悪戯っぽく笑い") if $msg.t_enemy.age == 1
    emotion.push("妖艶な笑みを浮かべ") if $msg.t_enemy.age >= 3
    emotion.push("休む暇も無く") if $msg.t_enemy.positive?
    emotion.push("くすりと笑い") if $msg.t_enemy.negative?
    emotion.push("にやりと笑みを浮かべ") if $msg.t_enemy.personality == "高慢" or $msg.t_enemy.personality == "意地悪" or $msg.t_enemy.personality == "露悪狂"
    emotion = ["恍惚とした表情で","熱に浮かされたように"] if $msg.t_enemy.crisis?
    emotion = emotion[rand(emotion.size)]
    #------
    action = ["#{t_actor}に覆いかぶさってきた……！"]
    #▼アクセプト(♀挿入)状態
    if $msg.t_enemy.vagina_insert?
      action = ["#{t_actor}の上で再び腰を振りはじめた！"]
      action.push("#{t_actor}の反応を楽しむように、\n腰を艶かしく前後させてきた！") if $msg.t_enemy.positive?
      action.push("精を受け止めた余韻を愉しんでいる……！") if $msg.t_enemy.negative?
    #▼オーラルアクセプト(口挿入)状態
    elsif $msg.t_enemy.mouth_oralsex?
      action = ["#{t_actor}のペニスを咥えたまま、\nゆっくりと口を動かしてきた！"]
      action.push("#{t_actor}の精をごくりと飲み込むと、\n更に絞り取るようにペニスをしゃぶってきた！") if $msg.t_enemy.positive?
      action.push("うっとりとした表情で、\n#{t_actor}のペニスをしゃぶり続けている……！") if $msg.t_enemy.negative?
    #▼バックアクセプト(尻挿入)状態
    elsif $msg.t_enemy.anal_analsex?
      action = ["#{t_actor}の上で、再び腰を振りはじめた！"]
      action.push("#{t_actor}の反応を楽しむように、\n腰を艶かしく前後させている！") elsif $msg.t_enemy.positive?
      action.push("精を受け止めた余韻を愉しんでいる……！") if $msg.t_enemy.negative?
    #▼エンブレイス(密着)状態
    elsif $msg.t_enemy.tops_binder?
      action = ["#{t_actor}に更に密着してきた……！"]
    #▼ペリスコープ(パイズリ)状態
    elsif $msg.t_enemy.tops_paizuri?
      action = ["絶頂したばかりの#{t_actor}のペニスを、\nその#{$msg.t_enemy.bustsize}で弄び続けている……！"]
      action.push("胸に放たれた精を舐め取ると、\n続けて#{$msg.t_enemy.bustsize}で挟み込んできた！") if $msg.t_enemy.positive?
    #▼ヘブンリーフィール(ぱふぱふ)状態
    elsif $msg.t_enemy.tops_pahupahu?
      action = ["絶頂したばかりの#{t_actor}の顔を、\nその#{$msg.t_enemy.bustsize}で更に抱きしめてきた！"]
    #▼エキサイトビュー(顔面騎乗)状態
    elsif $msg.t_enemy.vagina_riding?
      action = ["#{t_actor}の顔に騎乗したまま、\n更に腰を落としアソコを押し付けてきた！"]
      action.push("#{t_actor}の顔に騎乗したまま、\n腰を艶かしく前後させてきた！") if $msg.t_enemy.positive?
      action.push("#{t_actor}の顔に騎乗したまま、\n恍惚とした表情で腰を振っている！") if $msg.t_enemy.negative?
    #▼インモラルビュー(尻顔面騎乗)状態
    elsif $msg.t_enemy.anal_hipriding?
      action = ["#{t_actor}の顔に騎乗したまま、\n更に腰を落としお尻を押し付けてきた！"]
      action.push("#{t_actor}の顔に騎乗したまま、\nお尻を艶かしく前後させてきた！") if $msg.t_enemy.positive?
      action.push("#{t_actor}の顔に騎乗したまま、\n恍惚とした表情でお尻を振っている！") if $msg.t_enemy.negative?
    #▼シェルマッチ(貝合わせ)状態
    elsif $msg.t_enemy.shellmatch?
      action = ["#{t_actor}の脚を抱えて腰を振りはじめた！"]
    #▼フラッタナイズ(ディープキス)状態
    elsif $msg.t_enemy.deepkiss?
      action = ["#{t_actor}の顔を抱き寄せ更にキスを続けた！"]
    #▼ドロウネクター(クンニリングス)状態
    elsif $msg.t_enemy.mouth_draw?
      action = ["#{t_actor}のアソコを舐め続けている！"]
    #▼ディルドインサート(ディルド♀挿入)状態
    elsif $msg.t_enemy.dildo_insert?
      action = ["#{t_actor}の反応を楽しむように、\n再びディルドを艶かしく前後させてきた！"]
    #▼ディルドインマウス(ディルド口挿入)状態
    elsif $msg.t_enemy.dildo_oralsex?
      action = ["#{t_actor}の反応を楽しむように、\n再びディルドを艶かしく前後させてきた！"]
    #▼ディルドインバック(ディルド尻挿入)状態
    elsif $msg.t_enemy.dildo_analsex?
      action = ["#{t_actor}の反応を楽しむように、\n再びディルドを艶かしく前後させてきた！"]
    end
    action = action[rand(action.size)]
    #------
    m = "#{speaker}は#{emotion}、\n#{action}"
  #-------------------------------------------------------------------------------------------------
  when 30 #◆終了
    #●対象が主人公で無い場合、戦闘継続するテキストにする
    if $msg.t_target != $game_actors[101]
      action = ["に向き直り、微笑んだ","に期待の眼差しを向けてきた"]
      action.push("に意味深な微笑みを向けてきた") if $msg.t_enemy.age >= 3 or $msg.t_enemy.personality == "倒錯"
      action.push("に熱い視線を送っている") if $msg.t_enemy.positive?
      action.push("に気恥ずかしそうに微笑んだ") if $msg.t_enemy.negative?
      action = action[rand(action.size)]
      #------
      m = "#{speaker}は#{servant}から離れ、\n#{master}#{action}……！"
    #●対象が主人公の場合、戦闘終了を暗示するテキストにする
    else
      emotion = ["くすりと笑い"]
      emotion.push("悪戯っぽく笑い") if $msg.t_enemy.age == 1
      emotion.push("妖艶な笑みを浮かべ") if $msg.t_enemy.age >= 3
      emotion.push("楽しげな様子で") if $msg.t_enemy.positive?
      emotion.push("くすりと笑い") if $msg.t_enemy.negative?
      emotion.push("にやりと笑みを浮かべ") if $msg.t_enemy.personality == "高慢" or $msg.t_enemy.personality == "意地悪" or $msg.t_enemy.personality == "露悪狂"
      emotion = ["恍惚とした表情で","熱に浮かされたように"] if $msg.t_enemy.crisis?
      emotion = emotion[rand(emotion.size)]
      #------
      action = ["#{t_actor}に近づいてくる……！"]
      action.push("#{t_actor}に覆いかぶさってきた……！") if $msg.t_enemy.positive?
      action = action[rand(action.size)]
      #------
      m = "#{speaker}は#{emotion}、\n#{action}"
    end
  #-------------------------------------------------------------------------------------------------
  when 50 #◆絶頂(システムテキスト)
    m = "#{t_actor}はこれ以上耐えられない！\\|\\|"
    m = "#{t_actor}の喘ぎ声が辺りに響く！\\|\\|" unless $msg.t_target.boy?
  end
end
#========================================================================================================
elsif $game_temp.battle_active_battler.is_a?(Game_Actor)
#========================================================================================================
#●対エネミー夢魔：絶頂テキスト
case $msg.talk_step
#▼初撃
when 1
  tec = action = []
  case $msg.at_type
  #▼ホールド攻め系
  when "スウィング","ヘヴィスウィング","スクラッチ"
    action = ["の身体が快感で震える！"]
    action.push("から一際大きな嬌声が漏れる！") if $msg.t_target.positive?
    action.push("から言葉にならない嬌声が漏れる！") if $msg.t_target.negative?
    action.push("の小さな身体が大きく跳ねる！") if $msg.t_target.girl? and $msg.t_target.age == 1
    action = action[rand(action.size)]
    #テキスト出力
    m = "#{t_actor}が腰を振るたび、\n#{speaker}#{action}"
  #▼キッス系(特殊)
  when "キッス"
    tec = ["情熱的な"]
    tec.push("魅惑的な","大胆な") if $msg.t_target.positive?
    tec.push("一心不乱な","ひたむきな") if $msg.t_target.negative?
    tec.push("心得た","妖艶な") if $msg.t_target.girl? and $msg.t_target.age > 2
    tec.push("一所懸命な","愛らしい") if $msg.t_target.girl? and $msg.t_target.age < 3
    tec = tec[rand(tec.size)]
    action = ["の身体が快感に震える！","は蕩けたような表情を浮かべている！"]
    action = action[rand(action.size)]
    #テキスト出力
    m = "#{t_actor}の#{tec}口付けで、\n#{speaker}#{action}"
  #▼その他一般的な攻め
  else
    tec = ["情熱的な"]
    tec.push("魅惑的な","大胆な") if $msg.t_target.positive?
    tec.push("一心不乱な","熱心な") if $msg.t_target.negative?
    tec.push("心得た","妖艶な") if $msg.t_target.girl? and $msg.t_target.age > 2
    tec.push("一所懸命な","ひたむきな") if $msg.t_target.girl? and $msg.t_target.age < 3
    tec = tec[rand(tec.size)]
    action = ["の身体が快感に震える！","の口から嬌声が漏れる！","の身体が大きく震える！"]
    action = action[rand(action.size)]
    #テキスト出力
    m = "#{t_actor}の#{tec}愛撫で、\n#{speaker}#{action}"
  end
#▼追撃(特定ホールドのみ)
when 7
  case $msg.at_type
  when "スウィング","ヘヴィスウィング"
    action = "目掛けて腰を打ちつけた！"
    action = "の腰を掴み、力強く突き上げた！" if $msg.t_target.penis_intv == 0
    m = "#{speaker}#{action}"
  when "スクラッチ"
    m = "#{t_actor}は更に激しく、\n#{speaker}とアソコを擦り合わせた！"
  else
    m = "#{t_actor}は更に激しく、\n#{speaker}の敏感な部分を攻め立てた！"
  end
#▼とどめ
when 9
  action = ["の身体が、\n弓のように大きくしなる！","の嬌声が、\nひときわ大きく周囲に響く！"]
  action.push("の身体が、\nあまりの快感にきゅっと強張る！")
  action = action[rand(action.size)]
  #テキスト出力
  m = "#{speaker}#{action}"
#▼余韻行動
when 10
  action = ["快感で身悶えしている……！","蕩けたような表情で悶えている……！"]
  action.push("恍惚とした表情を浮かべている……！") if $msg.t_target.positive?
  action.push("荒い息をつきながら悶えている……！") if $msg.t_target.negative?
  action = action[rand(action.size)]
  #テキスト出力
  m = "#{speaker}は#{action}"
#▼ホールド継続(ホールド時のみ)
when 21
  m = "#{t_actor}は一呼吸置くと、\n再び#{speaker}に覆いかぶさった！"
else
  m = ""
end
#========================================================================================================
end #game_enemy/actor
#========================================================================================================
#■テキスト整形
if  m != ""
  m += "TALKTEXT"
  $msg.text4 = m
end
#########################################################################################################
end #def
end #class

=begin
#**********************************************************************************************
 ●トークステップの記述様式
 #▼絶頂前
 #共通
  1：対象のＥＰを０にしたキャラクターの行動
 #２～４は連携専用
  2：連携キャラクター１の行動(キャラクター１が存在すれば)
  3：連携キャラクター２の行動(キャラクター２が存在すれば)
  4：連携キャラクター３の行動(キャラクター３が存在すれば)
 #共通
  7：対象のＥＰを０にしたキャラクターの追撃
     ※インサート、ペリスコープ、オーラルインサート、バックインサート、シェルマッチの５つのみ発生する
       連携時、通常攻撃時、その他ホールド時は飛ばして次に移行
  9：対象のＥＰを０にしたキャラクターのとどめの行動
 #▼絶頂後
 10：対象のＥＰを０にしたキャラクターの余韻行動
 #11～13は連携専用
 11：連携キャラクター１の余韻行動(キャラクター１が存在すれば)
 12：連携キャラクター２の余韻行動(キャラクター２が存在すれば)
 13：連携キャラクター３の余韻行動(キャラクター３が存在すれば)
 #ホールド中のみ表示
 20：余韻後、ＥＰを０にしたキャラクターがホールドを解除する場合
 21：余韻後、ＥＰを０にしたキャラクターがホールドを継続する場合
 #共通
 30：対象のＶＰが０となった場合(失神)
 50：絶頂寸前のテキスト表示(システム)
#**********************************************************************************************
=end
