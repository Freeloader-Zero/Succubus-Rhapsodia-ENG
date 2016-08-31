module RPG
  class Skill
    attr_accessor :UK_name
    def UK_name
      
      case @id
#■Actor base skills

when 2   #服を脱がす
   return "Strip "
when 4   #服を脱ぐ
   return "Undress "
when 5   #シェルマッチ
   return "Scissors"
when 6   #インサート
   return "Insert"
when 7   #オーラルインサート
   return "Oral Insert "
when 8   #バックインサート
   return "Backdoor insert "
when 9   #トーク
   return "Talk"
when 10   #トークレジスト
   return "Sweet Talk"
when 13   #アクセプト
   return "Accept"
when 14   #オーラルアクセプト
   return "Oral Accept "
when 15   #バックアクセプト
   return "Backdoor Accept "
when 16   #ドロウネクター
   return "Draｗ Nectar "
when 17   #エンブレイス
   return "Eｍbrace "
when 18   #エキサイトビュー
   return "Facesit "
when 20   #ディルドインサート
   return "Dildo Insert"
when 21   #ディルドインマウス
   return "Dildo Gag "
when 22   #ディルドインバック
   return "Dildo Backdoor"
when 25   #デモンズアブソーブ
   return "Feeler Suck-in"
when 26   #デモンズドロウ
   return "Feeler Insert "
when 28   #インタラプト
   return "Interrupt "
when 29   #リリース
   return "Release "
when 30   #ストラグル
   return "Struggle"
   
   #■♂techniques
when 32   #スウィング
   return "Thrust"
when 33   #ヘヴィスウィング
   return "Piston"
when 34   #ディルドスウィング
   return "Strappon Thrust "
when 35   #ラビングピストン
   return "Chest Frottage"
when 37   #オーラルピストン
   return "Oral Piston "
when 38   #オーラルディルド
   return "Oral Dildo"
when 41   #バックピストン
   return "Anal Thrust "
when 42   #バックディルド
   return "Anal Dildo "

   #■♀techniques
when 47   #グラインド
   return "Grind"
when 48   #ハードグラインド
   return "Wild Ride "
when 50   #タイトクロッチ
   return "Tighten "
when 52   #スクラッチ
   return "Tribadisｍ "
when 53   #ハードスクラッチ
   return "Rubdoｗn "
when 55   #ライディング
   return "Facerub "
when 56   #プッシング
   return "Facepress "
   
   #■Oral techniques

when 58   #スロート
   return "Blowjob "
when 59   #ディープスロート
   return "Deepthroat"
when 60   #ドロウスロート
   return "Throat Draｗ "
when 61   #サック
   return "Lick"
   
   #■Anal techniques
   
when 64   #スクイーズ
   return "Sｑueeze "
when 67   #タイトホール
   return "Tighten "
   
   #■Hold counters
      
when 71   #リック
   return "Lick Pussy"
when 72   #リック
   return "Lick Ass"
when 73   #ミスチーフ
   return "Tickle"
when 74   #リアカレス
   return "Caress Back"
when 79   #レックレス
   return "Sｑuirｍ"
   
   #■Actor attacks

when 81   #キッス
   return "Kiss"
when 82   #バスト
   return "Chest "
when 83   #ヒップ
   return "Hips"
when 84   #クロッチ
   return "Crotch"
when 85   #カレス
   return "Caress "
   
   #■Partner attacks

when 87   #キッス
   return "Kiss"
when 91   #ツーパフ
   return "Chest Press "
when 101   #ティーズ
   return "Tease "
when 102   #ミスチーフ（没）
   return "Tease out "
when 103   #ファストレイド
   return "Quick Raid"
when 104   #トリックレイド
   return "Trick Raid"
when 106   #ディバウアー
   return "Devour "
when 111   #プレジャー
   return "Self-pleasure "
   
   #■Actor support techniques

when 121   #ブレス
   return "Breath"
when 122   #カームブレス
   return "Calｍ Breath "
when 123   #ウェイト
   return "Wait"
when 124   #イントラスト
   return "Entrust "
when 125   #リフレッシュ
   return "Refresh "
when 126   #チェック
   return "Check "
when 127   #アナライズ
   return "Analyze "
when 135   #ストリップ
   return "Strip Partner "
when 140   #テンプテーション
   return "Teｍptation"
when 145   #ガード
   return "Guard "
when 146   #インデュア
   return "Endure"
when 148   #アピール
   return "Appeal"
when 149   #プロヴォーク
   return "Provoke "

   #■Succubi common magic

when 161   #イリスシード
   return "Iris Seed "
when 162   #イリスペタル
   return "Iris Petal"
when 163   #イリスフラウ
   return "Iris Aura "
when 164   #イリスコロナ
   return "Iris Croｗn"
when 165   #イリスシード・アルダ
   return "Iris Seed - All "
when 166   #イリスペタル・アルダ
   return "Iris Petal - All"
when 167   #イリスフラウ・アルダ
   return "Iris Aura - All "
when 171   #ラナンブルム
   return "Leanan Blooｍ"
when 172   #ラナンブルム・アルダ
   return "Leanan Blooｍ - All"
when 173   #ラナンイーザ
   return "Leanan Wither "
when 174   #ラナンイーザ・アルダ
   return "Leanan Wither - All "
when 175   #ネリネブルム
   return "Nellin Blooｍ"
when 176   #ネリネブルム・アルダ
   return "Nellin Blooｍ - All"
when 177   #ネリネイーザ
   return "Nellin Wither "
when 178   #ネリネイーザ・アルダ
   return "Nellin Wither - All "
when 179   #エルダブルム
   return "Elda Blooｍ"
when 180   #エルダブルム・アルダ
   return "Elda Blooｍ - All"
when 181   #エルダイーザ
   return "Elda Wither "
when 182   #エルダイーザ・アルダ
   return "Elda Wither - All "
when 183   #サフラブルム
   return "Saffron Blooｍ "
when 184   #サフラブルム・アルダ
   return "Saffron Blooｍ - All "
when 185   #サフライーザ
   return "Saffron Wither "
when 186   #サフライーザ・アルダ
   return "Saffron Wither - All "
when 187   #コリオブルム
   return "Kurio Blooｍ "
when 188   #コリオブルム・アルダ
   return "Kurio Blooｍ - All "
when 189   #コリオイーザ
   return "Kurio Wither"
when 190   #コリオイーザ・アルダ
   return "Kurio Wither - All"
when 191   #アスタブルム
   return "Alta Blooｍ"
when 192   #アスタブルム・アルダ
   return "Alta Blooｍ - All"
when 193   #アスタイーザ
   return "Alta Wither"
when 194   #アスタイーザ・アルダ
   return "Alta Wither - All"
when 195   #ストレリブルム
   return "Storｍ Blooｍ "
when 196   #ストレリブルム・アルダ
   return "Storｍ Blooｍ - All "
when 197   #ストレリイーザ
   return "Storｍ Wither"
when 198   #ストレリイーザ・アルダ
   return "Storｍ Wither - All"
when 200   #チャーム
   return "Charｍ "
when 201   #ペイド・チャーム
   return "Mass Charｍ"
when 202   #ラスト
   return "Lust"
when 203   #ペイド・ラスト
   return "Mass Lust "
when 204   #フィルス
   return "Flirt "
when 205   #ペイド・フィルス
   return "Mass Flirt"
when 206   #レザラジィ
   return "Resaraji"
when 207   #ペイド・レザラジィ
   return "Mass Resaraji "
when 208   #テラー
   return "Toll"
when 209   #ペイド・テラー
   return "Mass Toll "
when 210   #パラライズ
   return "Paralyze"
when 211   #ペイド・パラライズ
   return "Mass Paralyze "
when 212   #ルーズ
   return "Sleep "
when 213   #ペイド・ルーズ
   return "Mass Sleep"
when 215   #トリムルート
   return "Liliuｍ Root "
when 216   #トリムストーク
   return "Liliuｍ Stalk"
when 217   #トリムヴァイン
   return "Liliuｍ Steｍ "
when 219   #ブルムカール
   return "Blooｍ Call"
when 220   #ブルムカール・アルダ
   return "Blooｍ Call - All"
when 221   #イーザカール
   return "Wither Call"
when 222   #イーザカール・アルダ
   return "Wither Call - All"
when 224   #ウォッシュフルード
   return "Cleansing Waters"
when 239   #シャイニングレイジ
   return "Shining Rage"

   #■■ＭＡＰ skills■■
   
when 241   #クッキング
   return "Cooking "
when 248   #サーヴァントコール
   return "Servant Talk"
when 249   #ランクアップ
   return "Rank Up "
   
   #■Enemy basic techniques

when 251   #服を脱ぐ
   return "Undress "
when 252   #ストリップ
   return "Strip "
when 253   #ショウダウン
   return "Shoｗdoｗn"
when 257   #服を脱がす
   return "Expose "
when 260   #品定め
   return "Check out "
when 261   #手ほどき
   return "Setup "
when 262   #甘やかし
   return "Indulge "
when 263   #スパンク
   return "Spank "
when 275   #やけくそ三連撃
   return "Desperation 3-ways"
when 276   #ヒーローキリング
   return "Hero killer"
when 277   #メテオエクリプス
   return "Meteo rain "
when 278   #ワールドブレイカー
   return "World Breaker "
when 279   #スキル決め直し
   return "Pick Again"
   
   #■Random basic attacks■

when 281   #【RD】キッス
   return "Kiss"
when 282   #【RD】手攻め
   return "Attack w/ hand"
when 283   #【RD】口攻め
   return "Attack w/ Mouth"
when 284   #【RD】胸攻め
   return "Attack w/ chest"
when 285   #【RD】アソコ攻め
   return "Attack w/ pussy"
when 286   #【RD】足攻め
   return "Attack w/ feet"
when 287   #【RD】愛撫
   return "Caress "
when 288   #【RD】尻尾攻め
   return "Tail Attack"
when 289   #【RD】道具攻め
   return "Tool Attack"
when 290   #【RD】特殊身体攻め
   return "Special Anatoｍy Attack"
when 292   #【RD】ホールド技
   return "Hold Attack"
when 293   #【RD】自分ホールド中の攻め
   return "Attack while held"
when 294   #【RD】味方ホールド中の援護
   return "Defend held friend"
when 296   #【RD】コンフューズ
   return "Confused"
when 297   #フィアー
   return "Fear"
when 298   #フリーアクション
   return "Free action"
when 299   #エモーション
   return "Eｍotion"

###   
# note: from here onwards, only including skills with element 14 (name shows in battle)
###
   #◇Special Handiworks◇
   
when 359   #セットサークル
   return "Set Circle"
when 360   #コールドタッチ
   return "Cold Touch"
when 361   #サディストカレス
   return "Touch of Sadisｍ"
when 362   #プライスオブハレム
   return "Ｈareｍ Pleasure"
when 363   #プライスオブシナー
   return "Bushin Pleasure"
when 364   #ペルソナブレイク
   return "Persona Break"
when 365   #キャストエントリー
   return "Caster Gate"
   
   #◇Special mouthworks◇
   
when 415   #ハウリング
   return "Howling"
when 416   #魔性の口付け
   return "Devil's Kiss"
when 417   #祝福の口付け
   return "Blessed Kiss"
when 418   #スイートウィスパー
   return "Sｗeet Whisper"
when 419   #アンラッキーロア
   return "Dejected Love"
when 420   #アンラッキーロア
   return "Dejected Love"
when 421   #懺悔なさい
   return "Confess"
   
   #◆special physicals◆
   
when 586   #レストレーション
   return "Restoration"
when 587   #スライミーリキッド
   return "Sliｍy Fluids"
when 588   #激励
   return "Cheer"
when 589   #バッドスポア
   return "Noxious Spores"
when 590   #スポアクラウド
   return "Spore Cloud"
when 591   #アイヴィクローズ
   return "Entangle"
when 592   #デモンズクローズ
   return "Deｍon Wrap"
when 599   #焦燥
   return "Ｈaste "
when 600   #専心
   return "Concentration"
when 601   #本能の呼び覚まし
   return "Priｍal Instincts"
when 602   #自信過剰
   return "Overconfidence"
   
   #◆incenses◆
   
when 611   #リラックスタイム
   return "Relaxation Tiｍe"
when 612   #スイートアロマ
   return "Sｗeet Aroｍa"
when 613   #パッションビート
   return "Passion Beats"
when 614   #マイルドパフューム
   return "Mild Prefuｍe"
when 615   #レッドカーペット
   return "Red Carpet"
when 618   #ストレンジスポア
   return "Strange Spores"
when 619   #ウィークスポア
   return "Weakening Spores"
when 620   #威迫
   return "Intiｍidate"
when 621   #心掴み
   return "Heart Grasp"
when 622   #全ては現
   return "One with the Flow"
when 625   #ラブフレグランス
   return "Love Fragrance"
when 626   #スライムフィールド
   return "Sliｍe Field"
   
   #◆Defensive skills◆
   
when 631   #激励を受ける
   return "Cheer up"
   
   #●Holding skills - base●
   
when 682   #アクセプト
   return "Accept"
when 683   #シェルマッチ
   return "Scissors"
when 684   #エキサイトビュー
   return "Facesit "
when 687   #オーラルアクセプト
   return "Oral Insert "
when 688   #ドロウネクター
   return "Oral Pin"
when 689   #フラッタナイズ
   return "Lock lips"
when 691   #バックアクセプト
   return "Anal catch"
when 692   #インモラルビュー
   return "Dark Side "
when 695   #エンブレイス
   return "Eｍbrace "
when 696   #エキシビジョン / hold legs in place
   return "Spread 'eｍ" #"Exhibition"
when 697   #ペリスコープ / Paizuri bearhold
   return "Paizuri Lock"#"Periscope"
when 698   #ヘブンリーフィール / Puff-puff headhold
   return "Heaven's Feel "
when 700   #インサート
   return "Insert"
when 701   #オーラルインサート
   return "Oral Insert "
when 702   #バックインサート
   return "Backdoor Insert "
when 705   #インサートテイル
   return "Tail Insert "
when 706   #マウスインテイル
   return "Oral Tail Insert"
when 707   #バックインテイル
   return "Anal Tail Insert"
when 710   #ディルドインサート
   return "Dildo Insert "
when 711   #ディルドインマウス
   return "Oral Dildo Insert "
when 712   #ディルドインバック
   return "Anal Dildo Insert "
when 715   #アイヴィクローズ
   return "Entangle"
when 716   #デモンズクローズ
   return "Deｍon Wrap"
when 717   #デモンズアブソーブ
   return "Feeler Suck-in"
when 718   #デモンズドロウ
   return "Feeler Insert "
when 719   #インサルトツリー
   return "Tentacle Wrap "
when 772   #エナジードレイン
   return "Energy Drain"
when 773   #レベルドレイン
   return "Level Drain "
when 971   #もがく
   return "Struggle"
   
      end

      text = @name.split(/\//)[0] rescue text = "error: no valid skill name"
#      text += " *TODO*" if text != nil
      return text
    end
  end
end

