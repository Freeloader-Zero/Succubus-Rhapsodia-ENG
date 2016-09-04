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
    attr_accessor :description   # 説明
    attr_accessor :icon_name   # 説明
    attr_accessor :hidden      # 非表示素質
    #--------------------------------------------------------------------------
    # ● オブジェクト初期化
    #--------------------------------------------------------------------------
    def initialize(ability_id)
      @id = ability_id
      @name = ""
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
        @description = "男性。普通、♂がある。"      
      when 1
        @name = "女" # 〆
        @description = "女性。普通、♀がある。"
       
      # ■ id [10..29] 各種弱点(追撃発生率に影響)
      #    10～17は男性用(嗜好)、19～30は女性用(性感帯)となる
      when 10
        @name = "口攻めに弱い" # 〆
        @description = "口や舌による攻めを受けた時、被追撃率が上昇してしまう。"
      when 11
        @name = "手攻めに弱い" # 〆
        @description = "指や掌による攻めを受けた時、被追撃率が上昇してしまう。"
      when 12
        @name = "胸攻めに弱い" # 〆
        @description = "乳房や乳首による攻めを受けた時、被追撃率が上昇してしまう。"
      when 13
        @name = "女陰攻めに弱い" # 〆
        @description = "アソコによる攻めを受けた時、被追撃率が上昇してしまう。"
      when 14
        @name = "嗜虐攻めに弱い"
        @description = "足などの嗜虐的な攻めを受けた時、被追撃率が上昇してしまう。"
      when 15
        @name = "異形攻めに弱い"
        @description = "異形のものによる攻めを受けた時、被追撃率が上昇してしまう。"
        # 周回プレイにて解禁
      when 16
        @name = "性交に弱い"
        @description = "性器を挿入し合った時、被追撃率が上昇してしまう。"
      when 17
        @name = "肛虐に弱い"
        @description = "お尻を攻められた時、被追撃率が上昇してしまう。"
        # 周回プレイにて解禁
      
      when 19
        @name = "口が性感帯"
        @description = "口を攻められた時、被追撃率が上昇してしまう。"
      when 20
        @name = "淫唇"
        @description = "口を攻められた時、被追撃率が大幅に上昇してしまう。"
      when 21
        @name = "胸が性感帯"
        @description = "胸を攻められた時、被追撃率が上昇してしまう。"
      when 22
        @name = "淫乳"
        @description = "胸を攻められた時、被追撃率が大幅に上昇してしまう。"
      when 23
        @name = "お尻が性感帯"
        @description = "お尻を攻められた時、被追撃率が上昇してしまう。"
      when 24
        @name = "淫尻"
        @description = "お尻を攻められた時、被追撃率が大幅に上昇してしまう。"
      when 25
        @name = "菊座が性感帯"
        @description = "お尻に挿入された時、被追撃率が上昇してしまう。"
        # 周回プレイにて解禁
      when 26
        @name = "淫花"
        @description = "お尻に挿入された時、被追撃率が大幅に上昇してしまう。"
        # 周回プレイにて解禁
      when 27
        @name = "陰核が性感帯"
        @description = "アソコを攻められた時、被追撃率が上昇してしまう。"
      when 28
        @name = "淫核"
        @description = "アソコを攻められた時、被追撃率が大幅に上昇してしまう。"
      when 29
        @name = "女陰が性感帯"
        @description = "アソコに挿入された時、被追撃率が上昇してしまう。"
      when 30
        @name = "淫壺"
        @description = "アソコに挿入された時、被追撃率が大幅に上昇してしまう。"
        
      
      # ■ id [31..49] 攻撃強化素質
      #    31～37はアクターの追撃率上昇、40～46は追加スキル取得条件となる
      when 31
        @name = "キッス熟練"
        @description = "『キッス』を使用した時、威力と追撃率が上昇する。"
      when 32
        @name = "バスト熟練"
        @description = "『バスト』を使用した時、威力と追撃率が上昇する。"
      when 33
        @name = "ヒップ熟練"
        @description = "『ヒップ』を使用した時、威力と追撃率が上昇する"
      when 34
        @name = "クロッチ熟練"
        @description = "『クロッチ』を使用した時、威力と追撃率が上昇する。"
      when 35
        @name = "インサート熟練"
        @description = "挿入中のみ使用可能なスキルを使用した時、威力と追撃率が上昇する。"
        # 周回プレイにて解禁
      when 36
        @name = "ホールド熟練"
        @description = "相手を拘束するスキルを使用した時、レジスト難易度が下がる。"
        # 周回プレイにて解禁

      when 40
        @name = "手技の心得"
        @description = "手を駆使したスキルを体得できる。"
      when 41
        @name = "舌技の心得"
        @description = "口を駆使したスキルを体得できる。"
      when 42
        @name = "胸技の心得"
        @description = "胸を駆使したスキルを体得できる。"
      when 43
        @name = "愛撫の心得"
        @description = "愛撫のスキルを体得できる。"
      when 44
        @name = "加虐の心得"
        @description = "Ｓ属性を持つスキルを体得できる"
        # 周回プレイにて解禁
      when 45
        @name = "被虐の心得"
        @description = "Ｍ属性を持つスキルを体得できる。"
        # 周回プレイにて解禁
      when 46
        @name = "性交の心得"
        @description = "挿入した際に使用するスキルを体得できる。"
      when 47
        @name = "呼吸の心得"
        @description = "自己回復のスキルを体得できる。"
      
      
      # ■ id [50..99] 優先表示素質
      
      when 50
        @name = "最高の姿"
        @description = "最大ランク時のステータスになる。"
        # ランクアップ前の夢魔でも、
        # 最大ランク時の状態のステータスとして計算される。
      when 51
        @name = "童貞"
        @description = "未だ「女」の味を知らない状態。"
        # 周回プレイにて解禁
      when 52
        @name = "初めてを奪った"
        @description = "貴方はこの夢魔の処女を奪った。"
      when 53
        @name = "処女"
        @description = "未だ「女」となっていない状態。"
      when 54
        @name = "初めてを奪われた"
        @description = "貴方はこの夢魔に初めてを捧げた。"
        # 周回プレイにて解禁
      when 55
        @name = "天女の純潔"
        @description = "永遠の処女である。"
        # フーリーの素質
        
      when 56
        @name = "両性具有"
        @description = "女性にして♂を持っている。"
        # 周回プレイにて解禁
      when 57
        @name = "母乳体質"
        @description = "母乳が出る。"
        # 周回プレイにて解禁
      
        
      when 60
        @name = "寵愛"
        @description = "この夢魔は貴方を気に入っている。"
      when 61
        @name = "大切な人"
        @description = "貴方とこの夢魔は互いを特別な存在だと感じている。"

      when 70
        @name = "吸精" # 〆
        @description = "自分が相手を絶頂させた時、満腹度を小回復する。"
      when 71
        @name = "サディスト"
        @description = "使用するＳ属性のスキルの効果が上がる。"
      when 72
        @name = "マゾヒスト" # 〆
        @description = "Ｓ属性のスキルを受けた場合に別の効果に変わる。"
      when 73
        @name = "カリスマ" # 〆
        @description = "戦闘終了時に戦闘に出ている時、契約しやすくなる。"
      when 74
        @name = "ショーストリップ"
        @description = "自分で服を脱いだ時に、ムードが高いほど敵全員を欲情状態にする。"

        
      when 80
        @name = "メタモルフォーゼ"
        @description = "別の夢魔の姿で戦闘に出る。クライシスになると元に戻る。"
        # ワンダーインプの素質。味方の場合、一番後ろの夢魔の姿になる。
      when 81
        @name = "小悪魔の連携" # 〆
        @description = "戦闘中、【小悪魔の統率】を持つ仲間のスキルを使用できる。"
      when 82
        @name = "小悪魔の統率" # 〆
        @description = "戦闘中、【小悪魔の連携】を持つ仲間が自分と同じスキルを使用できる。"
      when 83
        @name = "慧眼" # 〆
        @description = "戦闘に出た時に相手全体をチェックした状態にする。"
        
        
      when 91
        @name = "毒の体液" # 〆
        @description = "この夢魔の体液に触れると、状態異常になる。"
        # ネイジュレンジ限定素質。
      when 92
        @name = "" 
        @description = ""
        # リジェオ限定素質。        
      when 93
        @name = "確固たる自尊心" # 〆
        @description = "この夢魔は状態異常にならない。"
        # フルビュア限定素質。        
      when 94
        @name = "過敏な身体" # 〆
        @description = "大きく快感を受けるようになってしまっている。"
        # ギルゴーン限定素質。        
      when 95
        @name = "" 
        @description = ""
        # ユーガノット限定素質。        
      when 96
        @name = "先読み" 
        @description = "自分がターン中まだ行動していない時、被SS確率が下がる。"
        # シルフェ限定素質。
      when 97
        @name = "妄執" # 〆
        @description = "彼女は貴方を狙い続ける。"
        # ラーミル限定素質
        
        
        
      # ■ id [100..199] 戦闘系素質
      
      when 103
        @name = "スタミナ"
        @description = "絶頂後の衰弱・絶頂ターンが減少する。"
      when 104
        @name = "調理知識" # 〆
        @description = "食材を調理してくれる。"
      when 105
        @name = "魔法知識"
        @description = "魔法を使用する時の消費ＶＰが軽減される。"

      when 106
        @name = "濡れやすい" # 〆
        @description = "アソコの潤滑度が上がりやすい。"
      when 107
        @name = "濡れにくい" # 〆
        @description = "アソコの潤滑度が上がりにくい。"
        
      when 108
        @name = "平静" # 〆
        @description = "暴走状態になりにくい。"
      when 109
        @name = "活気" # 〆
        @description = "虚脱状態になりにくい。"
      when 110
        @name = "胆力" # 〆
        @description = "畏怖状態になりにくい。"
      when 111 # 欠番位置
        @name = ""
        @description = ""
      when 112
        @name = "柔軟" # 〆
        @description = "麻痺状態になりにくい。"
      when 113
        @name = "一心" # 〆
        @description = "散漫状態になりにくい。"
      when 114
        @name = "粘体" # 〆
        @description = "最初から全ての潤滑度が高いが、相手の潤滑度を上げやすい。"
        # スライム系の素質。
      when 115
        @name = "プロテクション" # 〆
        @description = "魔法の効果が一切効かない。"
        # ゴールドスライムの素質。
      when 116
        @name = "ブロッキング" # 〆
        @description = "自分がターン中まだ行動していない時、受ける快感が下がる。"
        # ガーゴイルの素質。
      when 117
        @name = "厚着" # 〆
        @description = "着衣状態の時、素早さが下がるが忍耐力が上がる。"
        # タマモの素質。
      when 118
        @name = "免疫力" # 〆
        @description = "胞子の影響を受けず、毒にも強い。"

        
      when 120
        @name = "高揚" # 〆
        @description = "戦闘に出た時に高揚状態になる。"
      when 121
        @name = "沈着" # 〆
        @description = "戦闘に出た時に沈着状態になる。"
      when 122
        @name = "快楽主義"
        @description = "攻撃を受けるとムードを上げる。"
      when 123
        @name = "ロマンチスト" # 〆
        @description = "ムードが高いほど、与える快感がより大きくなる。"
      when 124
        @name = "熟練" # 〆
        @description = "Sensual Stroke率が上がる。"
      when 125
        @name = "自信過剰"
        @description = "この夢魔が敵を絶頂させた時に、自分の状態異常を回復する。"
      when 126
        @name = "焦欲" # 〆
        @description = "自分以外の味方が絶頂した時、自分の魅力と精力を１段階上げる"
      when 127
        @name = "執拗な攻め" # 〆
        @description = "連続して同じスキルで攻めても快感が減衰しにくい。"
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
        @description = "攻めた相手をチェックした状態にする。"
      when 131
        @name = "挑発的"
        @description = "戦闘に出た時にＶＰを２０消費して、敵全員を挑発する。"
      when 132
        @name = "ボディアロマ"
        @description = "戦闘に出た時にＶＰを８消費して、ムードを少し上げる。"
      when 133
        @name = "魅惑的"
        @description = "戦闘に出た時にＶＰを４０消費して、敵全員を低確率で欲情にする。"
      when 134
        @name = "サンチェック" # 〆
        @description = "戦闘に出た時にＶＰを１００消費して、敵全員を畏怖にする。"
      when 135
        @name = "平穏の保証" # 〆
        @description = "使用する回復魔法の効果が上がる。"
      when 136
        @name = "バッドチェイン" # 〆
        @description = "２つ以上状態異常がついた相手を追撃しやすい。"

      when 140
        @name = "自慰癖"
        @description = "自慰が癖になっている。"
      when 141
        @name = "精液中毒"
        @description = "精液が癖になっている。"
        
      when 150
        @name = "無我夢中" # 〆
        @description = "クライシスになると精力が上がる。"
      when 151
        @name = "対抗心" # 〆
        @description = "味方の絶頂時に味方の数が敵の数より少ない場合、精力と素早さを上げる。"
      when 152
        @name = "自制心"
        @description = "欲情になるとＶＰを５０消費し、精神力を上げて欲情を回復する。"
      when 153
        @name = "淫魔の体質"
        @description = "欲情状態の時、ターンの終了時毎にＶＰが自動回復する。"
      when 154
        @name = "超暴走" # 〆
        @description = "暴走状態の時、忍耐力と精神力が更に下がり精力が大幅に上がる。"
      
      when 160
        @name = "キススイッチ" # 〆
        @description = "キスをされるとスイッチが入る。"
      when 161
        @name = "マゾスイッチ"
        @description = "罵倒されるとスイッチが入る。"
        
      when 170
        @name = "エクスタシーボム" # 〆
        @description = "絶頂した時、自分以外の味方全員を暴走状態にする。"
      when 171
        @name = "封印の呪い"
        @description = "快楽を受けるまで動けず、封印を解いてもしばらくすればまた封印される。"
        # シールデーモンの素質。
        
        
      # ■ id [100..199] 探索系素質
      when 210
        @name = "ＥＰヒーリング" # 〆
        @description = "戦闘勝利時にパーティ全員のＥＰを小回復する。"
      when 211
        @name = "ＶＰヒーリング" # 〆
        @description = "戦闘勝利時にパーティ全員のＶＰを小回復する。"
        
      when 212
        @name = "回復力" # 〆
        @description = "自動回復するＥＰ量が少し上がる。"
      when 213
        @name = "溢れる回復力" # 〆
        @description = "パーティ全員の自動回復するＥＰ量が少し上がる。"
      when 214
        @name = "生命力" # 〆
        @description = "自動回復するＶＰ量が少し上がる。"
      when 215
        @name = "溢れる生命力" # 〆
        @description = "パーティ全員の自動回復するＶＰ量が少し上がる。"
        
      when 220
        @name = "経験活用力" # 〆
        @description = "戦闘終了時の取得経験値量が増える。"
      when 221
        @name = "蒐集" # 〆
        @description = "戦闘終了時のアイテムドロップ率が上がる。"
      when 222
        @name = "金運" # 〆
        @description = "戦闘終了時に貰えるLps.の量が増える。"
      when 223
        @name = "風音への利き耳"
        @description = "隠し通路などの近くにマーカーがぼんやりと現れる。"
      when 224
        @name = "ダウジング"
        @description = "マップ上で見えないアイテムの上を通るとマーカーが現れる。"
      when 225
        @name = "シールスタンプ"
        @description = "パーティが受けるダメージ床からの快感を軽減する。"
      when 226
        @name = "ダウト"
        @description = "夢魔が擬態しているのを事前に察知できる。"
      when 227
        @name = "奇襲の備え" # 〆
        @description = "敵シンボルと接触した時に、こちらが先手を取れる確率が上がる。"
      when 228
        @name = "警戒の備え" # 〆
        @description = "敵シンボルと接触した時に、敵に先手を取られる確率が下がる。"
      when 229
        @name = "隙無し走法" # 〆
        @description = "ダッシュ中に敵シンボルと接触しても、先手を取られにくくなる。"
      when 230
        @name = "逃走の極意" # 〆
        @description = "自分が逃走する場合、逃走率が上がる。"
      
        
        
      when 240
        @name = "手際良い採取" # 〆
        @description = "採取にかかる時間が短くなる。"
      when 241
        @name = "目聡い採取" # 〆
        @description = "採取で希少なものが手に入りやすくなる。"
        
      when 300
        @name = "非表示素質テスト"
        @description = "非表示素質テストです。hiddenが真の素質は表示されません"
        @hidden = true

      when 301
        @name = "インサート" # 〆
        @description = "ホールド習得済み確認用"
        @hidden = true
      when 302
        @name = "アクセプト" # 〆
        @description = "ホールド習得済み確認用"
        @hidden = true
      when 303
        @name = "シェルマッチ" # 〆
        @description = "ホールド習得済み確認用"
        @hidden = true
      when 304
        @name = "エキサイトビュー" # 〆
        @description = "ホールド習得済み確認用"
        @hidden = true
      when 305
        @name = "エンブレイス" # 〆 /密着ホールド(開脚は除く)
        @description = "ホールド習得済み確認用"
        @hidden = true
      when 306
        @name = "オーラルセックス" # 〆 /フェラ＋クンニ兼用
        @description = "ホールド習得済み確認用"
        @hidden = true
      when 307
        @name = "ペリスコープ" # 〆 /パイズリホールド
        @description = "ホールド習得済み確認用"
        @hidden = true
      when 308
        @name = "ヘブンリーフィール" # 〆 /ぱふぱふホールド
        @description = "ホールド習得済み確認用"
        @hidden = true
      when 309
        @name = "フラッタナイズ" # 〆 /キッスホールド
        @description = "ホールド習得済み確認用"
        @hidden = true
      when 310
        @name = "トレインドホール" # 〆 /お尻使用系
        @description = "ホールド習得済み確認用"
        @hidden = true
      when 311
        @name = "アンドロギュヌス" # 〆 /ペニス使用系
        @description = "ホールド習得済み確認用"
        @hidden = true
      when 312
        @name = "テイルマスタリー" # 〆 /尻尾使用系
        @description = "ホールド習得済み確認用"
        @hidden = true
      when 313
        @name = "テンタクルマスタリー" # 〆 /触手使用系
        @description = "ホールド習得済み確認用"
        @hidden = true
      when 314
        @name = "イクイップディルド" # 〆 /ディルド装着系
        @description = "ホールド習得済み確認用"
        @hidden = true
      when 315
        @name = "アイヴィマスタリー" # 〆 /蔦使用系
        @description = "ホールド習得済み確認用"
        @hidden = true
      when 320
        @name = "アヌスマーキング" # 〆 /尻狙い解禁
        @description = "挿入ホールドで菊座を狙えるようになる"
        @hidden = true
      when 321
        @name = "バインドマスタリー" # 〆 /拘束技解禁
        @description = "拘束ホールドを強化する"
        @hidden = true

        
        
      when 332
        @name = "料理音痴" # 〆 /
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