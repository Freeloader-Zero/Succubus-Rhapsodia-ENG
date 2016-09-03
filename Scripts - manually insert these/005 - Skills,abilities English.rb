module RPG
  
  class Skill
    attr_accessor :UK_name
    def UK_name
      
      case @id
      
#■Actor base skills
when 2   #服を脱がす
   return "Strip"
when 4   #服を脱ぐ
   return "Undress"
when 5   #シェルマッチ
   return "Scissors"
when 6   #インサート
   return "Insert"
when 7   #オーラルインサート
   return "Oral insert"
when 8   #バックインサート
   return "Backdoor insert"
when 9   #トーク
   return "Talk"
when 10   #トークレジスト
   return "Sweet talk"
when 13   #アクセプト
   return "Invite"
when 14   #オーラルアクセプト
   return "Oral invite"
when 15   #バックアクセプト
   return "Backdoor invite"
when 16   #ドロウネクター
   return "Tongue insert"
when 17   #エンブレイス
   return "Embrace"
when 18   #エキサイトビュー
   return "Straddle"
when 20   #ディルドインサート
   return "Dildo insert"
when 21   #ディルドインマウス
   return "Dildo gag"
when 22   #ディルドインバック
   return "Anal plug-in"
when 25   #デモンズアブソーブ
   return "Feeler suck-in"
when 26   #デモンズドロウ
   return "Feeler insert"
when 28   #インタラプト
   return "Interrupt"
when 29   #リリース
   return "Release"
when 30   #ストラグル
   return "Struggle"
   
   #■♂techniques
when 32   #スウィング
   return "Thrust"
when 33   #ヘヴィスウィング
   return "Piston"
when 34   #ディルドスウィング
   return "Strapon thrust"
when 35   #ラビングピストン
   return "Chest frottage"
when 37   #オーラルピストン
   return "Throat piston"
when 38   #オーラルディルド
   return "Throat dildo"
when 41   #バックピストン
   return "Anal thrust"
when 42   #バックディルド
   return "Dildo ram"

   #■♀techniques
when 47   #グラインド
   return "Grind"
when 48   #ハードグラインド
   return "Wild ride"
when 50   #タイトクロッチ
   return "Tighten"
when 52   #スクラッチ
   return "Tribadism"
when 53   #ハードスクラッチ
   return "Rubdown"
when 55   #ライディング
   return "Facerub"
when 56   #プッシング
   return "Facepress"
   
   #■Oral techniques

when 58   #スロート
   return "Blowjob"
when 59   #ディープスロート
   return "Deepthroat"
when 60   #ドロウスロート
   return "Suck on"
when 61   #サック
   return "Lick"
   
   #■Anal techniques
   
when 64   #スクイーズ
   return "Squeeze"
when 67   #タイトホール
   return "Tighten"
   
   #■Hold counters
      
when 71   #リック
   return "Lick pussy"
when 72   #リック
   return "Lick ass"
when 73   #ミスチーフ
   return "Tickle"
when 74   #リアカレス
   return "Caress"
when 79   #レックレス
   return "Squirm"
   
   #■Actor attacks

when 81   #キッス
   return "Kiss"
when 82   #バスト
   return "Chest"
when 83   #ヒップ
   return "Hips"
when 84   #クロッチ
   return "Crotch"
when 85   #カレス
   return "Caress"
   
   #■Partner attacks

when 87   #キッス
   return "Kiss"
when 91   #ツーパフ
   return "Chest press"
when 101   #ティーズ
   return "Tease"
when 102   #ミスチーフ（没）
   return "Tease out"
when 103   #ファストレイド
   return "Quick raid"
when 104   #トリックレイド
   return "Trick raid"
when 106   #ディバウアー
   return "Devour"
when 111   #プレジャー
   return "Self-pleasure"
   
   #■Actor support techniques

when 121   #ブレス
   return "Breath"
when 122   #カームブレス
   return "Calm breath"
when 123   #ウェイト
   return "Wait"
when 124   #イントラスト
   return "Entrust"
when 125   #リフレッシュ
   return "Refresh"
when 126   #チェック
   return "Check"
when 127   #アナライズ
   return "Analyze"
when 135   #ストリップ
   return "Striptease"
when 140   #テンプテーション
   return "Temptation"
when 145   #ガード
   return "Guard"
when 146   #インデュア
   return "Endure"
when 148   #アピール
   return "Appeal"
when 149   #プロヴォーク
   return "Provoke"

   #■Succubi common magic

when 161   #イリスシード
   return "Heal seed"
when 162   #イリスペタル
   return "Heal petal"
when 163   #イリスフラウ
   return "Heal aura"
when 164   #イリスコロナ
   return "Heal halo"
when 165   #イリスシード・アルダ
   return "Mass Heal seed"
when 166   #イリスペタル・アルダ
   return "Mass Heal petal"
when 167   #イリスフラウ・アルダ
   return "Mass Heal aura"
when 171   #ラナンブルム
   return "Charisma"
when 172   #ラナンブルム・アルダ
   return "Mass Charisma"
when 173   #ラナンイーザ
   return "Disgrace"
when 174   #ラナンイーザ・アルダ
   return "Mass Disgrace"
when 175   #ネリネブルム
   return "Resistance"
when 176   #ネリネブルム・アルダ
   return "Mass Resistance"
when 177   #ネリネイーザ
   return "Vulnerability"
when 178   #ネリネイーザ・アルダ
   return "Mass Vulnerability"
when 179   #エルダブルム
   return "Energy"
when 180   #エルダブルム・アルダ
   return "Mass Energy"
when 181   #エルダイーザ
   return "Debility"
when 182   #エルダイーザ・アルダ
   return "Mass Debility"
when 183   #サフラブルム
   return "Deftness"
when 184   #サフラブルム・アルダ
   return "Mass Deftness"
when 185   #サフライーザ
   return "Klutz"
when 186   #サフライーザ・アルダ
   return "Mass Klutz"
when 187   #コリオブルム
   return "Haste"
when 188   #コリオブルム・アルダ
   return "Mass Haste"
when 189   #コリオイーザ
   return "Slow"
when 190   #コリオイーザ・アルダ
   return "Mass Slow"
when 191   #アスタブルム
   return "Mana surge"
when 192   #アスタブルム・アルダ
   return "Mass Mana surge"
when 193   #アスタイーザ
   return "Mana drain"
when 194   #アスタイーザ・アルダ
   return "Mass Mana drain"
when 195   #ストレリブルム
   return "Efflorescence"
when 196   #ストレリブルム・アルダ
   return "Mass Efflorescence"
when 197   #ストレリイーザ
   return "Storm of Decay"
when 198   #ストレリイーザ・アルダ
   return "Mass Storm of Decay"
when 200   #チャーム
   return "Charm"
when 201   #ペイド・チャーム
   return "Mass charm"
when 202   #ラスト
   return "Lust"
when 203   #ペイド・ラスト
   return "Mass lust"
when 204   #フィルス
   return "Flirt"
when 205   #ペイド・フィルス
   return "Mass flirt"
when 206   #レザラジィ
   return "Collapse"
when 207   #ペイド・レザラジィ
   return "Mass Collapse"
when 208   #テラー
   return "Soften"
when 209   #ペイド・テラー
   return "Mass soften"
when 210   #パラライズ
   return "Paralyze"
when 211   #ペイド・パラライズ
   return "Mass paralyze"
when 212   #ルーズ
   return "Sleep"
when 213   #ペイド・ルーズ
   return "Mass sleep"
when 215   #トリムルート
   return "Body cleanse"
when 216   #トリムストーク
   return "Mind cleanse"
when 217   #トリムヴァイン
   return "Removal"
when 219   #ブルムカール
   return "Dispel"
when 220   #ブルムカール・アルダ
   return "Mass Dispel"
when 221   #イーザカール
   return "Uncurse"
when 222   #イーザカール・アルダ
   return "Mass uncurse"
when 224   #ウォッシュフルード
   return "Cleansing waters"
when 239   #シャイニングレイジ
   return "Shining rage"

   #■■ＭＡＰ skills■■
   
when 241   #クッキング
   return "Cook"
when 248   #サーヴァントコール
   return "Servant talk"
when 249   #ランクアップ
   return "Rank up"
   
   #■Enemy basic techniques

when 251   #服を脱ぐ
   return "Undress"
when 252   #ストリップ
   return "Strip"
when 253   #ショウダウン
   return "Showdown"
when 257   #服を脱がす
   return "Expose"
when 260   #品定め
   return "Check out"
when 261   #手ほどき
   return "Foreplay"
when 262   #甘やかし
   return "Indulge"
when 263   #スパンク
   return "Spank"
when 275   #やけくそ三連撃
   return "Desperation 3-ways"
when 276   #ヒーローキリング
   return "Hero killer"
when 277   #メテオエクリプス
   return "Meteo rain"
when 278   #ワールドブレイカー
   return "World breaker"
when 279   #スキル決め直し
   return "Pick again"
   
   #■Random basic attacks■

when 281   #【RD】キッス
   return "Kiss"
when 282   #【RD】手攻め
   return "Attack w/ hand"
when 283   #【RD】口攻め
   return "Attack w/ mouth"
when 284   #【RD】胸攻め
   return "Attack w/ chest"
when 285   #【RD】アソコ攻め
   return "Attack w/ pussy"
when 286   #【RD】足攻め
   return "Attack w/ feet"
when 287   #【RD】愛撫
   return "Caress"
when 288   #【RD】尻尾攻め
   return "Tail attack"
when 289   #【RD】道具攻め
   return "Tool attack"
when 290   #【RD】特殊身体攻め
   return "Special anatomy attack"
when 292   #【RD】ホールド技
   return "Hold attack"
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
   return "Emotion"

###   
# note: from here onwards, only including skills with element 14 (name shows in battle)
###
   #◇Special Handiworks◇
   
when 359   #セットサークル
   return "Set circle"
when 360   #コールドタッチ
   return "Cold touch"
when 361   #サディストカレス
   return "Hand of sadist"
when 362   #プライスオブハレム
   return "Harem Master"
when 363   #プライスオブシナー
   return "Bushin pleasure"
when 364   #ペルソナブレイク
   return "Persona break"
when 365   #キャストエントリー
   return "Caster gate"
   
   #◇Special mouthworks◇
   
when 415   #ハウリング
   return "Howling"
when 416   #魔性の口付け
   return "Evil kiss"
when 417   #祝福の口付け
   return "Blessing kiss"
when 418   #スイートウィスパー
   return "Sweet whisper"
when 419   #アンラッキーロア
   return "Dejected love"
when 420   #アンラッキーロア
   return "Dejected love"
when 421   #懺悔なさい
   return "Confess"
   
   #◆special physicals◆
   
when 586   #レストレーション
   return "Restoration"
when 587   #スライミーリキッド
   return "Slimy fluids"
when 588   #激励
   return "Cheer"
when 589   #バッドスポア
   return "Noxious spores"
when 590   #スポアクラウド
   return "Spore cloud"
when 591   #アイヴィクローズ
   return "Entangle"
when 592   #デモンズクローズ
   return "Demon wrap"
when 599   #焦燥
   return "Aggravate"
when 600   #専心
   return "Concentration"
when 601   #本能の呼び覚まし
   return "Primal instincts"
when 602   #自信過剰
   return "Overconfidence"
   
   #◆incenses◆
   
when 611   #リラックスタイム
   return "Relaxation time"
when 612   #スイートアロマ
   return "Sweet aroma"
when 613   #パッションビート
   return "Passion beats"
when 614   #マイルドパフューム
   return "Mild prefume"
when 615   #レッドカーペット
   return "Red carpet"
when 618   #ストレンジスポア
   return "Strange spores"
when 619   #ウィークスポア
   return "Weakening spores"
when 620   #威迫
   return "Intimidate"
when 621   #心掴み
   return "Heart grasp"
when 622   #全ては現
   return "One with the flow"
when 625   #ラブフレグランス
   return "Love fragrance"
when 626   #スライムフィールド
   return "Slime field"
   
   #◆Defensive skills◆
   
when 631   #激励を受ける
   return "Encourage"
   
   #●Holding skills - base●
   
when 682   #アクセプト
   return "Cowgirl invite"
when 683   #シェルマッチ
   return "Scissors"
when 684   #エキサイトビュー
   return "Straddle"
when 687   #オーラルアクセプト
   return "Oral insert"
when 688   #ドロウネクター
   return "Tongue insert"
when 689   #フラッタナイズ
   return "Lock lips"
when 691   #バックアクセプト
   return "Anal invite"
when 692   #インモラルビュー
   return "Reverse straddle"
when 695   #エンブレイス
   return "Embrace"
when 696   #エキシビジョン / hold legs in place
   return "Shameful display" #"Exhibition"
when 697   #ペリスコープ / Paizuri bearhold
   return "Oppai invite"#"Periscope"
when 698   #ヘブンリーフィール / Puff-puff headhold
   return "Heaven's feel"
when 700   #インサート
   return "Insert"
when 701   #オーラルインサート
   return "Oral insert"
when 702   #バックインサート
   return "Backdoor insert"
when 705   #インサートテイル
   return "Tail insert"
when 706   #マウスインテイル
   return "Tail mouth insert"
when 707   #バックインテイル
   return "Tail anal insert"
when 710   #ディルドインサート
   return "Dildo insert"
when 711   #ディルドインマウス
   return "Dildo gag"
when 712   #ディルドインバック
   return "Anal plug-in"
when 715   #アイヴィクローズ
   return "Entangle"
when 716   #デモンズクローズ
   return "Demon wrap"
when 717   #デモンズアブソーブ
   return "Feeler suck-in"
when 718   #デモンズドロウ
   return "Feeler insert"
when 719   #インサルトツリー
   return "Tentacle wrap"
when 772   #エナジードレイン
   return "Energy drain"
when 773   #レベルドレイン
   return "Level drain"
when 971   #もがく
   return "Struggle"
   
      end

      text = @name.split(/\//)[0] rescue text = "error: no valid skill name"
#      text += " *TODO*" if text != nil
      return text
    end
  end
end

