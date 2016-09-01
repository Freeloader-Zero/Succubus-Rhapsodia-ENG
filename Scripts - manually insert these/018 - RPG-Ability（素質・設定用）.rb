#==============================================================================
# ■ RPG::Ability
#------------------------------------------------------------------------------
# 　素質の情報。$data_ability[id]から参照可能。
#==============================================================================
module RPG
  #--------------------------------------------------------------------------
  # ■ 素質の登録
  #--------------------------------------------------------------------------
  class Ability_registration
    #--------------------------------------------------------------------------
    # ● 公開インスタンス変数
    #--------------------------------------------------------------------------
    attr_accessor :id            # id
    attr_accessor :name          # 名前
    attr_accessor :UK_name       # Engrish, go!
    attr_accessor :description   # 説明
    attr_accessor :icon_name   # 説明
    attr_accessor :hidden      # 非表示素質
    #--------------------------------------------------------------------------
    # ● オブジェクト初期化
    #--------------------------------------------------------------------------
    def initialize(ability_id)
      @id = ability_id
      @name = ""
      @UK_name = ""
      @description = ""
      @icon_name = "acce_003"
      @hidden = false
      setup(ability_id)
    end
    #--------------------------------------------------------------------------
    # ● セットアップ
    #--------------------------------------------------------------------------
    def setup(ability_id)
      
      # 習得素質はid順で並ぶため、順序を考慮すること。
      
      case ability_id
      
      # ■ id [0..9] 性別、その他最優先素質
      
      when 0
        @name = "男" # 〆
        @UK_name = "Male" # 〆
        @description = "A man. ｗith a ♂ attached." #男性。普通、♂がある。"      
      when 1
        @name = "女" # 〆
        @UK_name = "Female" 
        @description = "A woman. ｗith a ♀. And all." #女性。普通、♀がある。"
       
      # ■ id [10..29] 各種弱点(追撃発生率に影響)
      #    10～17は男性用(嗜好)、19～30は女性用(性感帯)となる
      when 10
        @name = "口攻めに弱い" # 〆
        @UK_name = "Mouth Fetish" 
        @description = "Oral and tongue techniques have a higher chance of doing critical damage to you."
      when 11
        @name = "手攻めに弱い" # 〆
        @UK_name = "Hand Fetish" 
        @description = "Hand and finger techniques have a higher chance of doing critical damage to you."
      when 12
        @name = "胸攻めに弱い" # 〆
        @UK_name = "Breast Fetish" 
        @description = "Breast and nipple techniques have a higher chance of doing critical damage to you."
      when 13
        @name = "女陰攻めに弱い" # 〆
        @UK_name = "Pussy Fetish" 
        @description = "Vaginal techniques have a higher chance of doing critical damage to you."
      when 14
        @name = "嗜虐攻めに弱い"
        @UK_name = "S Fetish" 
        @description = "Sadistic attacks, such as foot techniques, have a higher chance of doing critical damage to you."
      when 15
        @name = "異形攻めに弱い"
        @UK_name = "Monmusu Fetish" 
        @description = "Unconventional techniques have a higher chance of doing critical damage to you."
        # 周回プレイにて解禁
      when 16
        @name = "性交に弱い"
        @UK_name = "Weak to Intercourse" 
        @description = "When Inserted, you have a higher chance of suffering critical damage."
      when 17
        @name = "肛虐に弱い"
        @UK_name = "Ass Fetish" 
        @description = "Ass techniques have a higher chance of doing critical damage to you."
        # 周回プレイにて解禁
      
      when 19
        @name = "口が性感帯"
        @UK_name = "Weak Mouth" 
        @description = "Attacks to your mouth have a higher chance of doing critical damage."
      when 20
        @name = "淫唇"
        @UK_name = "Lewd Mouth" 
        @description = "Attacks to your mouth have a very high chance of doing critical damage."
      when 21
        @name = "胸が性感帯"
        @UK_name = "Weak Chest" 
        @description = "Attacks to your breasts have a higher chance of doing critical damage."
      when 22
        @name = "淫乳"
        @UK_name = "Lewd Chest" 
        @description = "Attacks to your breasts have a very high chance of doing critical damage."
      when 23
        @name = "お尻が性感帯"
        @UK_name = "Weak Ass" 
        @description = "Attacks to your backside have a higher chance of doing critical damage."
      when 24
        @name = "淫尻"
        @UK_name = "Lewd Ass" 
        @description = "Attacks to your backside have a very high chance of doing critical damage."
      when 25
        @name = "菊座が性感帯"
        @UK_name = "Weak Rosette" 
        @description = "When anally Inserted, you have a higher chance of suffering critical damage."
        # 周回プレイにて解禁
      when 26
        @name = "淫花"
        @UK_name = "Lewd Rosette" 
        @description = "When anally Inserted, you have a very high chance of suffering critical damage."
        # 周回プレイにて解禁
      when 27
        @name = "陰核が性感帯"
        @UK_name = "Weak Clit" 
        @description = "Attacks to your crotch have a higher chance of doing critical damage."
      when 28
        @name = "淫核"
        @UK_name = "Lewd Clit" 
        @description = "Attacks to your crotch have a very high chance of doing critical damage."
      when 29
        @name = "女陰が性感帯"
        @UK_name = "Weak Pussy" 
        @description = "When vaginally Inserted, you have a higher chance of suffering critical damage."
      when 30
        @name = "淫壺"
        @UK_name = "Lewd Pussy" 
        @description = "When vaginally Inserted, you have a very high chance of suffering critical damage."
        
      
      # ■ id [31..49] 攻撃強化素質 / attack damage bonuses
      #    31～37はアクターの追撃率上昇 / multiple attack trigger
      #    40～46は追加スキル取得条件となる / new skill get
      when 31
        @name = "キッス熟練"
        @UK_name = "Kiss Mastery" 
        @description = "『Kiss』 attack deals more damage and has a higher chance of dealing critical damage."
      when 32
        @name = "バスト熟練"
        @UK_name = "Breast Mastery" 
        @description = "『Chest』 attack deals more damage and has a higher chance of dealing critical damage."
      when 33
        @name = "ヒップ熟練"
        @UK_name = "Ass Mastery"
        @description = "『Hips』 attack deals more damage and has a higher chance of dealing critical damage."
      when 34
        @name = "クロッチ熟練"
        @UK_name = "Crotch Mastery" 
        @description = "『Crotch』 attack deals more damage and has a higher chance of deadling critical damage."
      when 35
        @name = "インサート熟練"
        @UK_name = "Insert Mastery" 
        @description = "Insert-exclusive skills are more powerful and have a higher chance of dealing critical damage."
        # 周回プレイにて解禁
      when 36
        @name = "ホールド熟練"
        @UK_name = "Bondage Mastery" 
        @description = "When using restrictive skills, the RESIST gauge difficulty is easier."
        # 周回プレイにて解禁

      when 40
        @name = "手技の心得"
        @UK_name = "Hand Arts" 
        @description = "You can now make full use of your hands through experience."
      when 41
        @name = "舌技の心得"
        @UK_name = "Tongue Arts" 
        @description = "You're able to learn how to make good use of your tongue through experience."
      when 42
        @name = "胸技の心得"
        @UK_name = "Chest Arts" 
        @description = "Through experience, you can now make full use of chest techniques."
      when 43
        @name = "愛撫の心得"
        @UK_name = "Caress Arts" 
        @description = "Through practice, you're now able to obtain mastery of caressing."
      when 44
        @name = "加虐の心得"
        @UK_name = "Domme Arts" 
        @description = "You can now master S skills."
        # 周回プレイにて解禁
      when 45
        @name = "被虐の心得"
        @UK_name = "Sub Arts" 
        @description = "You can now master M skills."
        # 周回プレイにて解禁
      when 46
        @name = "性交の心得"
        @UK_name = "Sex Arts" 
        @description = "You've learned to master the art of insertion through experience."
      when 47
        @name = "呼吸の心得"
        @UK_name = "Breath Mastery" 
        @description = "Mastery of medication can now be obtained."
      
      
      # ■ id [50..99] 優先表示素質
      
      when 50
        @name = "最高の姿"
        @UK_name = "The Highest Form" 
        @description = "This succubus is as strong as its fully evolved form."
        # ランクアップ前の夢魔でも、
        # 最大ランク時の状態のステータスとして計算される。
      when 51
        @name = "童貞"
        @UK_name = "Virgin" 
        @description = "Still knows nothing of the taste of a woman."
        # 周回プレイにて解禁
      when 52
        @name = "初めてを奪った"
        @UK_name = "Ravished" 
        @description = "You took the virginity of this succubus."
      when 53
        @name = "処女"
        @UK_name = "Maiden" 
        @description = "Has yet to become a woman."
      when 54
        @name = "初めてを奪われた"
        @UK_name = "Virginity Taken" 
        @description = "You gave your virginity to this succubus."
        # 周回プレイにて解禁
      when 55
        @name = "天女の純潔"
        @UK_name = "Heavenly Maiden" 
        @description = "An eternal virgin."
        # フーリーの素質
        
      when 56
        @name = "両性具有"
        @UK_name = "Futanari" 
        @description = "A female that has ♂ parts."
        # 周回プレイにて解禁
      when 57
        @name = "母乳体質"
        @UK_name = "Motherly Bounty" 
        @description = "Milk is flowing out of her breasts."
        # 周回プレイにて解禁
      
        
      when 60
        @name = "寵愛"
        @UK_name = "Loving" 
        @description = "This succubus really likes you..."
      when 61
        @name = "大切な人"
        @UK_name = "Trusting" 
        @description = "There feels like something special between you and this succubus."

      when 70
        @name = "吸精" # 〆
        @UK_name = "Soul-sucking" 
        @description = "When allowed to be on top, a small amount of hunger is satiated."
      when 71
        @name = "サディスト"
        @UK_name = "Sadist" 
        @description = "Effects of S-attribute skills are increased."
      when 72
        @name = "マゾヒスト" # 〆
        @UK_name = "Masochist" 
        @description = "Converts effects of incoming S-attribute skills to different effects."
      when 73
        @name = "カリスマ" # 〆
        @UK_name = "Charismatic" 
        @description = "Have increased chances of being offered a contract after battle."
      when 74
        @name = "ショーストリップ"
        @UK_name = "Stripteaser" 
        @description = "When removing one's own clothes while the Mood is high, all enemies are rendered Horny."

        
      when 80
        @name = "メタモルフォーゼ"
        @UK_name = "Shapeshifter" 
        @description = "Appears in battle disguised as a different succubus. Returns to original form when in CRISIS."
        # ワンダーインプの素質。味方の場合、一番後ろの夢魔の姿になる。
      when 81
        @name = "小悪魔の連携" # 〆
        @UK_name = "Goblin Teamwork" 
        @description = "During battle, can use 【Goblin Leadership】 ｗith an ally."
      when 82
        @name = "小悪魔の統率" # 〆
        @UK_name = "Goblin Leadership" 
        @description = "During battle, can use 【Goblin Teamwork】 ｗith an ally ｗith the same skill."
      when 83
        @name = "慧眼" # 〆
        @UK_name = "Keen Eyes" 
        @description = "Checks all enemies upon entering combat."
        
        
      when 91
        @name = "毒の体液" # 〆
        @UK_name = "Poisonous Fluids" 
        @description = "Contact ｗith this succubus' fluids will produce an\n abnorｍal status effect."
        # ネイジュレンジ限定素質。
      when 92
        @name = "" 
        @description = ""
        # リジェオ限定素質。        
      when 93
        @name = "確固たる自尊心" # 〆
        @UK_name = "Unshakable Pride" 
        @description = "Immune to status abnormalities."
        # フルビュア限定素質。        
      when 94
        @name = "過敏な身体" # 〆
        @UK_name = "Hypersensitive Body" 
        @description = "Has become hypersensitive to pleasures of the flesh."
        # ギルゴーン限定素質。        
      when 95
        @name = "" 
        @description = ""
        # ユーガノット限定素質。        
      when 96
        @name = "先読み" 
        @UK_name = "Forereading" 
        @description = "When having not yet acted yet this turn, become resistant to SS attacks."
        # シルフェ限定素質。
      when 97
        @name = "妄執" # 〆
        @UK_name = "Obsession" 
        @description = "This girl keeps looking at you..."
        # ラーミル限定素質
        
        
        
      # ■ id [100..199] 戦闘系素質
      
      when 103
        @name = "スタミナ"
        @UK_name = "Stamina" 
        @description = "The Weakened phase after climaxing is shorter."
      when 104
        @name = "調理知識" # 〆
        @UK_name = "Cooking Knowledge" 
        @description = "Can cook ingredients."
      when 105
        @name = "魔法知識"
        @UK_name = "Magic Knowledge" 
        @description = "Magic consuｍes less VP."

      when 106
        @name = "濡れやすい" # 〆
        @UK_name = "Wet" 
        @description = "Crotch gets wet easily. Increased lubrication rate."
      when 107
        @name = "濡れにくい" # 〆
        @UK_name = "Prudish" 
        @description = "Crotch lubrication rises slowly."
        
      when 108
        @name = "平静" # 〆
        @UK_name = "Calm Mind" 
        @description = "Doesn't go Berserk easily."
      when 109
        @name = "活気" # 〆
        @UK_name = "Vigorous" 
        @description = "Doesn't becoｍe Lethargic easily."
      when 110
        @name = "胆力" # 〆
        @UK_name = "Courage" 
        @description = "Doesn't becoｍe in Aｗe easily."
      when 111 # 欠番位置
        @name = ""
        @description = ""
      when 112
        @name = "柔軟" # 〆
        @UK_name = "Flexible" 
        @description = "Doesn't get Paralyzed easily."
      when 113
        @name = "一心" # 〆
        @UK_name = "Deterｍined" 
        @description = "Doesn't become in Awe easily."
      when 114
        @name = "粘体" # 〆
        @UK_name = "Slimy Body" 
        @description = "Well lubricated from the start of battle. Also easy to raise target's lubrication."
        # スライム系の素質。
      when 115
        @name = "プロテクション" # 〆
        @UK_name = "Magic Ward" 
        @description = "Iｍｍune to ｍagical effects."
        # ゴールドスライムの素質。
      when 116
        @name = "ブロッキング" # 〆
        @UK_name = "Blocking" 
        @description = "When having not acted during turn, incoming pleasure is reduced."
        # ガーゴイルの素質。
      when 117
        @name = "厚着" # 〆
        @UK_name = "Thick Clothing" 
        @description = "When still clothed, Agility falls but Endurance rises."
        # タマモの素質。
      when 118
        @name = "免疫力" # 〆
        @UK_name = "Immunity" 
        @description = "Immune to spore effects, and resistance to poison."

        
      when 120
        @name = "高揚" # 〆
        @UK_name = "Excited" 
        @description = "Becoｍes Excited upon entering coｍbat."
      when 121
        @name = "沈着" # 〆
        @UK_name = "Coｍposed" 
        @description = "Becoｍes Coｍposed when entering coｍbat."
      when 122
        @name = "快楽主義"
        @UK_name = "Epicurian" 
        @description = "Mood rises when attacked."
      when 123
        @name = "ロマンチスト" # 〆
        @UK_name = "Romantic" 
        @description = "Deals even more damage when mood is high."
      when 124
        @name = "熟練" # 〆
        @UK_name = "Technique Mastery" 
        @description = "Has a higher Sensual Stroke rate."
      when 125
        @name = "自信過剰"
        @UK_name = "Superiority" 
        @description = "Recovers from status abnormalities when this succubus makes the opposition climax."
      when 126
        @name = "焦欲" # 〆
        @UK_name = "Greedy" 
        @description = "When ally other than oneself climaxes, Charm and Vitality increase by 1 stage."
      when 127
        @name = "執拗な攻め" # 〆
        @UK_name = "Relentless" 
        @description = "Pleasure is not reduced as much from repeated use of the same skills."
=begin
      when 128
        @name = "話芸"
        @description = "トークの成功率が上がる。"
      when 129
        @name = "呑気"
        @description = "たまに待機ターンになる。"
=end
        
      when 130
        @name = "洞察力" # 〆
        @UK_name = "Insight" 
        @description = "Checks the target that one attacks."
      when 131
        @name = "挑発的"
        @UK_name = "Provocative" 
        @description = "Upon entering coｍbat, 20 VP is consuｍed to snatch the eneｍies' attention."
      when 132
        @name = "ボディアロマ"
        @UK_name = "Sｗeet Aroｍa" 
        @description = "Upon entering coｍbat, 8 VP is consuｍed, raising the ｍood by a little."
      when 133
        @name = "魅惑的"
        @UK_name = "Fascinating" 
        @description = "When entering coｍbat, 40 VP is consuｍed for a sｍall chance of rendering eneｍies Horny."
      when 134
        @name = "サンチェック" # 〆
        @UK_name = "Awesoｍe Presence" 
        @description = "When entering coｍbat, 100 VP is consumed, rendering eneｍies in a Panicked state."
      when 135
        @name = "平穏の保証" # 〆
        @UK_name = "Peacekeeper" 
        @description = "Recovery magic is more effective."
      when 136
        @name = "バッドチェイン" # 〆
        @UK_name = "Trick Chain" 
        @description = "Lands attacks easier on targets ｗith 2 or more status abnorｍalities."

      when 140
        @name = "自慰癖"
        @UK_name = "Masturbator" 
        @description = "Has a habit of masturbating a lot."
      when 141
        @name = "精液中毒"
        @UK_name = "Cum addict" 
        @description = "Has a coｍpulsive habit of consuｍing semen."
        
      when 150
        @name = "無我夢中" # 〆
        @UK_name = "Desperado" 
        @description = "Vitality rises when in CRISIS."
      when 151
        @name = "対抗心" # 〆
        @UK_name = "Coｍpetitive" #rivalry?
        @description = "When there are less allies than eneｍies at the time of an ally's cliｍax, Vitality and Agility increases."
      when 152
        @name = "自制心"
        @UK_name = "Self-control" 
        @description = "Consumes 50 VP when made Horny - increasing Willpower adn removing the Horniness."
      when 153
        @name = "淫魔の体質"
        @UK_name = "Body of a Sex Deｍon" 
        @description = "When Horny, recovers VP autoｍatically at the end of each turn."
      when 154
        @name = "超暴走" # 〆
        @UK_name = "Berserker" 
        @description = "When Berserk, Control and Spirit fall even ｍore, but Vitality rises substantially."
      
      when 160
        @name = "キススイッチ" # 〆
        @UK_name = "Kiss Sｗitch" 
        @description = "Gets turned on when kissed."
      when 161
        @name = "マゾスイッチ"
        @UK_name = "Masochist Sｗitch" 
        @description = "Gets turned on when doｍinated."
        
      when 170
        @name = "エクスタシーボム" # 〆
        @UK_name = "Ecstasy Boｍb" 
        @description = "When cliｍaxing, render all allies except oneself into a Berserk state."
      when 171
        @name = "封印の呪い"
        @UK_name = "Sealed" 
        @description = "Cannot ｍove until pleasure is received, and is sealed again shortly afterwards even if seal was broken."
        # シールデーモンの素質。
        
        
      # ■ id [100..199] 探索系素質
      when 210
        @name = "ＥＰヒーリング" # 〆
        @UK_name = "EP Recovery" 
        @description = "Restores a sｍall amount of EP to the party after a victorious battle."
      when 211
        @name = "ＶＰヒーリング" # 〆
        @UK_name = "VP Recovery" 
        @description = "Restores all VP to the party after a victorious battle."
        
      when 212
        @name = "回復力" # 〆
        @UK_name = "Resilient" 
        @description = "EP Auto-regeneration is slightly increased."
      when 213
        @name = "溢れる回復力" # 〆
        @UK_name = "Overfloｗing Resilience" 
        @description = "EP Auto-regeneration is slightly increased for the whole party."
      when 214
        @name = "生命力" # 〆
        @UK_name = "Energetic" 
        @description = "VP Auto-regeneration is slightly increased."
      when 215
        @name = "溢れる生命力" # 〆
        @UK_name = "Overflowing Energy" 
        @description = "VP Auto-regeneration is slightly increased for the whole party."
        
      when 220
        @name = "経験活用力" # 〆
        @UK_name = "Quick Learner" 
        @description = "EXP gains are increased."
      when 221
        @name = "蒐集" # 〆
        @UK_name = "Collector" 
        @description = "Item Drop chance is increased."
      when 222
        @name = "金運" # 〆
        @UK_name = "Gold Digger" 
        @description = "Increased Lps gains after battle."
      when 223
        @name = "風音への利き耳"
        @UK_name = "Wind whispers" 
        @description = "A dim marker is placed near hidden passages."
      when 224
        @name = "ダウジング"
        @UK_name = "Dowser" 
        @description = "A marker appears on the map when you step over a hidden item."
      when 225
        @name = "シールスタンプ"
        @UK_name = "Sealer" 
        @description = "Reduces damage dealt to party from floor traps."
      when 226
        @name = "ダウト"
        @UK_name = "Doubtful" 
        @description = "Can detect Mimics beforehand."
      when 227
        @name = "奇襲の備え" # 〆
        @UK_name = "Ambusher" 
        @description = "Increases chance of preeｍptive engagements when making\n contact ｗith an eneｍy sprite."
      when 228
        @name = "警戒の備え" # 〆
        @UK_name = "Sentry" 
        @description = "Reduces the chance of the enemy getting a preemptive engagement on you."
      when 229
        @name = "隙無し走法" # 〆
        @UK_name = "Dasher" 
        @description = "Reduces chance of being preeｍptively engaged when\n contacting an eneｍy while dashing."
      when 230
        @name = "逃走の極意" # 〆
        @UK_name = "Escapist" 
        @description = "Increased success rate of escape attempts."
      
        
        
      when 240
        @name = "手際良い採取" # 〆
        @UK_name = "Scavenger" 
        @description = "Decreases the time it takes for collection."
      when 241
        @name = "目聡い採取" # 〆
        @UK_name = "Meticulous" 
        @description = "Increases chance of rare items from collecting."
        
      when 300
        @name = "非表示素質テスト"
        @UK_name = "Headhunter" 
        @description = "非表示素質テストです。hiddenが真の素質は表示されません"
        @hidden = true

      when 301
        @name = "インサート" # 〆
        @UK_name = "Insert" 
        @description = "ホールド習得済み確認用"
        @hidden = true
      when 302
        @name = "アクセプト" # 〆
        @UK_name = "Accept" 
        @description = "ホールド習得済み確認用"
        @hidden = true
      when 303
        @name = "シェルマッチ" # 〆
        @UK_name = "Tribadism" 
        @description = "ホールド習得済み確認用"
        @hidden = true
      when 304
        @name = "エキサイトビュー" # 〆
        @UK_name = "Facesit" 
        @description = "ホールド習得済み確認用"
        @hidden = true
      when 305
        @name = "エンブレイス" # 〆 /密着ホールド(開脚は除く)
        @UK_name = "Embrace" 
        @description = "ホールド習得済み確認用"
        @hidden = true
      when 306
        @name = "オーラルセックス" # 〆 /フェラ＋クンニ兼用
        @UK_name = "Oral sex" 
        @description = "ホールド習得済み確認用"
        @hidden = true
      when 307
        @name = "ペリスコープ" # 〆 /パイズリホールド
        @UK_name = "Breast sex" 
        @description = "ホールド習得済み確認用"
        @hidden = true
      when 308
        @name = "ヘブンリーフィール" # 〆 /ぱふぱふホールド
        @UK_name = "Heaven's feel" 
        @description = "ホールド習得済み確認用"
        @hidden = true
      when 309
        @name = "フラッタナイズ" # 〆 /キッスホールド
        @UK_name = "Lock lips" 
        @description = "ホールド習得済み確認用"
        @hidden = true
      when 310
        @name = "トレインドホール" # 〆 /お尻使用系
        @UK_name = "Valley of the Gange" 
        @description = "ホールド習得済み確認用"
        @hidden = true
      when 311
        @name = "アンドロギュヌス" # 〆 /ペニス使用系
        @UK_name = "Androgynous" 
        @description = "ホールド習得済み確認用"
        @hidden = true
      when 312
        @name = "テイルマスタリー" # 〆 /尻尾使用系
        @UK_name = "Tail Mastery" 
        @description = "ホールド習得済み確認用"
        @hidden = true
      when 313
        @name = "テンタクルマスタリー" # 〆 /触手使用系
        @UK_name = "Feeler Mastery" 
        @description = "ホールド習得済み確認用"
        @hidden = true
      when 314
        @name = "イクイップディルド" # 〆 /ディルド装着系
        @UK_name = "Strapon Mastery" 
        @description = "ホールド習得済み確認用"
        @hidden = true
      when 315
        @name = "アイヴィマスタリー" # 〆 /蔦使用系
        @UK_name = "Vine Mastery" 
        @description = "ホールド習得済み確認用"
        @hidden = true
      when 320
        @name = "アヌスマーキング" # 〆 /尻狙い解禁
        @UK_name = "Anal Marking" 
        @description = "Can aim for the anus through Insertion hold."
        @hidden = true
      when 321
        @name = "バインドマスタリー" # 〆 /拘束技解禁
        @UK_name = "Restraint Mastery" 
        @description = "拘束ホールドを強化する"
        @hidden = true

        
        
      when 332
        @name = "料理音痴" # 〆 /
        @UK_name = "Awful Cook" 
        @description = "この夢魔は料理ができない。"
        @hidden = true
        
      end
    end
  end
  #--------------------------------------------------------------------------
  # ■ 素質情報まとめ
  #--------------------------------------------------------------------------
  class Ability
    #--------------------------------------------------------------------------
    # ● 公開インスタンス変数
    #--------------------------------------------------------------------------
    attr_accessor :data
    #--------------------------------------------------------------------------
    # ● オブジェクト初期化
    #--------------------------------------------------------------------------
    def initialize
      @data = []
      @max = 400 #素質の登録数上限
      for i in 0..@max
        @data[i] = Ability_registration.new(i)
      end
    end
    #--------------------------------------------------------------------------
    # ● 素質の取得
    #--------------------------------------------------------------------------
    def [](ability_id)
      return @data[ability_id]
    end
    #--------------------------------------------------------------------------
    # ● 素質の検索
    #    type : 検索指定   variable : 検索語
    #--------------------------------------------------------------------------
    def search(type, variable)
      
      case type
      when 0 # 名前でＩＤを検索する
        for data in @data
          if data.name == variable
            n = data.id
            break
          end
        end
      end
      
      if n == nil
        text = "対応したＩＤが見当たりませんでした。"
        text += "\n以下のことを確認してくだい。"
        text += "\n・誤字脱字（スクリプトエディタ内全検索）"
        text += "\n・【】を付けて検索していないか"
        text += "\n・素質の上限数が検索したい素質IDの数字以下でないか"
        text += "\n検索ワード：#{variable}"
        print text
      end
      
      return n
    end

  end
end