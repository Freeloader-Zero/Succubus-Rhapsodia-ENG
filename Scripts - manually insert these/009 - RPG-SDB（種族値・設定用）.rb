#==============================================================================
# ■ RPG::SDB
#------------------------------------------------------------------------------
# 　素質の情報。$data_SDB[id]から参照可能。
#==============================================================================
module RPG
  #--------------------------------------------------------------------------
  # ■ 種族値の登録
  #--------------------------------------------------------------------------
  class Succubus_registration
    #--------------------------------------------------------------------------
    # ● 公開インスタンス変数
    #--------------------------------------------------------------------------  
    attr_accessor :name             # 種族名
    attr_accessor :class_id         # クラスID
    attr_accessor :exp_type         # 経験値テーブルタイプ
    attr_accessor :graphics         # グラフィック
    attr_accessor :maxhp            # 最大ＥＰ 
    attr_accessor :maxsp            # 最大ＶＰ
    attr_accessor :str              # 精力
    attr_accessor :dex              # 器用さ
    attr_accessor :agi              # 素早さ
    attr_accessor :int              # 精神力
    attr_accessor :atk              # 魅力
    attr_accessor :pdef             # 忍耐力
    attr_accessor :mdef             # 自制心
    attr_accessor :digest           # 空腹率
    attr_accessor :absorb           # 吸精量
    attr_accessor :maxrune          # 最大ルーン刻印数
    attr_accessor :d_power          # 夢の魔力
    attr_accessor :next_rank_id     # 次ランクＩＤ
    attr_accessor :contract_level   # 契約難度
    attr_accessor :years_type       # 年齢タイプ
    attr_accessor :legless          # 足使用不可
    attr_accessor :tail             # 攻撃に使える尻尾の有無
    #(・years_type:目安 1:12以下, 2:15以下, 3:20以下, 4:29以下, 5:30以上 )
    attr_accessor :bust_size        # バストサイズ
    #(・bust_size :目安 1:A以下, 2:B, 3:C, 4:D, 5:E以上 )
    attr_accessor :hold_rate        # ホールド技使用の頻度
    attr_accessor :exp              # 取得経験値
    attr_accessor :gold             # 取得金額
    attr_accessor :default_name_self# デフォルトネーム(自分の一人称)
    attr_accessor :default_name_hero# デフォルトネーム(対主人公の二人称)
    
    #--------------------------------------------------------------------------
    # ● オブジェクト初期化
    #--------------------------------------------------------------------------
    def initialize(race_id)
      @next_rank_id = 0
      @years_type = 1
      @legless = false
      @tail = nil
      @bust_size = 0
      @hold_rate = []
      @exp = 10
      @gold = 10
      setup(race_id)
    end
    #--------------------------------------------------------------------------
    # ● 種族値の取得
    #     race_id : 種族 ID
    #--------------------------------------------------------------------------
    def setup(race_id)

      @class_id = race_id
      
      case race_id
      #------------------------------------------------------------------------
      # ■■人間
      #
      # 主人公。ＶＰが高く、あとは至って平均的。
      # 満腹度や夢の魔力は発生しないために０。
      #------------------------------------------------------------------------
      when 2 #人間/男
        @name, @graphics = "Huｍan", "hero1"
        @class_id, @exp_type = race_id, 2
        @maxhp, @maxsp = 300, 600
        @str, @dex, @agi, @int = 100, 50, 80, 50
        @atk, @pdef, @mdef = 50, 50, 100
        @digest, @absorb = 0, 0
        @maxrune, @d_power = 5, 0
        @years_type, @bust_size = 3, 0
        @default_name_self = "僕"
        @default_name_hero = "君"
              
      #------------------------------------------------------------------------
      # ■■サキュバス種
      #
      # レッサーは少々頼りないが、このゲームに置いての戦闘要員の基本となる種族。
      # 平均水準以上の能力を持つが、ランクが上がる毎に満腹度や吸精量が重くなる。
      #------------------------------------------------------------------------
      when 5,6 
        @name = "Lesser Succubus "
        @exp_type = 1
        @maxhp, @maxsp = 350, 300
        @str, @dex, @agi, @int = 60, 50, 45, 42
        @atk, @pdef, @mdef = 90, 40, 100
        @digest, @absorb = 4, 150
        @maxrune, @d_power = 3, 1
        @years_type, @bust_size = 3, 3
        @tail = true
        @hold_rate[0] = [682,687,695] #無条件
        @hold_rate[1] = [683,684,689,697,700,710] #ムード20前後で解禁
        @hold_rate[2] = [688,698,701,705,706,711] #ムード40前後で解禁
        @hold_rate[3] = [691,692,696,702,707,712] #ムード60前後で解禁
        @hold_rate[4] = [715,716,717,718,719] #ムード100で解禁
        @contract_level = 0
        @exp = 10
        @gold = 8
        case race_id 
        when 5 # 橙
          @graphics = "lesser_succubus1-1"
          @next_rank_id = 10
          @default_name_self = "アタシ"
          @default_name_hero = "お兄さん"
        when 6 # 桃
          @graphics = "lesser_succubus1-2"
          @next_rank_id = 11
          @default_name_self = "アタシ"
          @default_name_hero = "お兄さん"
        end
      #------------------------------------------------------------------------
      when 10,11 
        @name = "Succubus"
        @exp_type = 1
        @maxhp, @maxsp =  380, 360
        @str, @dex, @agi, @int = 90, 70, 85, 60
        @atk, @pdef, @mdef = 120, 65, 100
        @digest, @absorb = 5, 320
        @years_type, @bust_size = 3, 4
        @tail = true
        @maxrune, @d_power = 3, 2
        @hold_rate[0] = [682,687,697] #無条件
        @hold_rate[1] = [683,684,689,695,700,710] #ムード20前後で解禁
        @hold_rate[2] = [688,698,701,705,706,711] #ムード40前後で解禁
        @hold_rate[3] = [691,692,696,702,707,712] #ムード60前後で解禁
        @hold_rate[4] = [715,716,717,718,719] #ムード100で解禁
        @contract_level = 10
        @exp = 18
        @gold = 14
        case race_id 
        when 10 # 橙
          @graphics = "succubus1-1"
          @next_rank_id = 15
          @default_name_self = "アタシ"
          @default_name_hero = "キミ"
        when 11 # 桃
          @graphics = "succubus1-2"
          @next_rank_id = 16
          @default_name_self = "アタシ"
          @default_name_hero = "キミ"
        end
      #------------------------------------------------------------------------
      when 15,16 
        @name = "Succubus Lord "
        @exp_type = 1
        @maxhp, @maxsp =  400, 380
        @str, @dex, @agi, @int = 100, 100, 100, 82
        @atk, @pdef, @mdef = 140, 80, 100
        @digest, @absorb = 6, 500
        @years_type, @bust_size = 4, 5
        @tail = true
        @maxrune, @d_power = 3, 3
        @hold_rate[0] = [682,687,698] #無条件
        @hold_rate[1] = [683,684,689,695,697,700,710] #ムード20前後で解禁
        @hold_rate[2] = [688,701,705,706,711] #ムード40前後で解禁
        @hold_rate[3] = [691,692,696,702,707,712] #ムード60前後で解禁
        @hold_rate[4] = [715,716,717,718,719] #ムード100で解禁
        @contract_level = 20
        @exp = 26
        @gold = 20
        case race_id 
        when 15 # 橙
          @graphics = "succubus_lord2-1"
          @default_name_self = "私"
          @default_name_hero = "貴方"
        when 16 # 桃
          @graphics = "succubus_lord2-2"
          @default_name_self = "私"
          @default_name_hero = "貴方"
        end
        
      #------------------------------------------------------------------------
      # ■■デビル種
      #
      # インプは素早さがあるが、デビル以降からは低速になり、戦闘力が上がる。
      # サキュバス種に比べ、魔法を多く覚える。上位種ほど満腹度や吸精量が重くなる。
      #------------------------------------------------------------------------
      when 21,22 
        @name = "Iｍp"
        @exp_type = 1
        @maxhp, @maxsp = 290, 250
        @str, @dex, @agi, @int = 100, 38, 75, 38
        @atk, @pdef, @mdef = 60, 40, 100
        @digest, @absorb = 3, 110
        @maxrune, @d_power = 3, 1
        @years_type, @bust_size = 1, 1
        @tail = true
        @hold_rate[0] = [682,695] #無条件
        @hold_rate[1] = [683,684,687,689,700,710] #ムード20前後で解禁
        @hold_rate[2] = [688,701,702,705,706,707,711] #ムード40前後で解禁
        @hold_rate[3] = [697,698,691,692,696,712] #ムード60前後で解禁
        @hold_rate[4] = [715,716,717,718,719] #ムード100で解禁
        @contract_level = 0
        @exp = 10
        @gold = 5
        case race_id 
        when 21 # 緑
          @graphics = "imp0-1"
          @next_rank_id = 26
          @default_name_self = "夢魔短縮名"
          @default_name_hero = "おにーちゃん"
        when 22 # 白
          @graphics = "imp0-2"
          @next_rank_id = 27
          @default_name_self = "ボク"
          @default_name_hero = "主人公名"
        end
      #------------------------------------------------------------------------
      when 26,27 # デビル
        @name = "Devil "
        @exp_type = 1
        @maxhp, @maxsp = 370, 370
        @str, @dex, @agi, @int = 110, 55, 65, 100
        @atk, @pdef, @mdef = 110, 62, 100
        @digest, @absorb = 5, 320
        @years_type, @bust_size = 3, 4
        @tail = true
        @hold_rate[0] = [682,683,684] #無条件
        @hold_rate[1] = [687,688,689,700,710] #ムード20前後で解禁
        @hold_rate[2] = [695,697,698,701,702,705,706,707,711] #ムード40前後で解禁
        @hold_rate[3] = [691,692,696,712] #ムード60前後で解禁
        @hold_rate[4] = [715,716,717,718,719] #ムード100で解禁
        @maxrune, @d_power = 3, 2
        @contract_level = 10
        @exp = 18
        @gold = 14
        case race_id 
        when 26 # 緑
          @graphics = "devil1-1"
          @next_rank_id = 31
          @default_name_self = "あたし"
          @default_name_hero = "兄さん"
        when 27 # 白
          @graphics = "devil1-2"
          @next_rank_id = 32
          @default_name_self = "俺"
          @default_name_hero = "主人公名"
        end
      #------------------------------------------------------------------------
      when 31,32 # デ―モン
        @name = "Deｍon"
        @exp_type = 1
        @maxhp, @maxsp = 400, 400
        @str, @dex, @agi, @int = 150, 75, 65, 140
        @atk, @pdef, @mdef = 135, 80, 100
        @digest, @absorb = 6, 500
        @years_type, @bust_size = 4, 5
        @tail = true
        @hold_rate[0] = [682,683,698] #無条件
        @hold_rate[1] = [687,684,688,689,700,710] #ムード20前後で解禁
        @hold_rate[2] = [695,696,697,692,701,702,705,706,707,711] #ムード40前後で解禁
        @hold_rate[3] = [691,712] #ムード60前後で解禁
        @hold_rate[4] = [715,716,717,718,719] #ムード100で解禁
        @maxrune, @d_power = 3, 3
        @contract_level = 20
        @exp = 26
        @gold = 20
        case race_id 
        when 31 # 緑
          @graphics = "daemon2-1"
          @default_name_self = "あたし"
          @default_name_hero = "坊や"
        when 32 # 白
          @graphics = "daemon2-2"
          @default_name_self = "私"
          @default_name_hero = "主人公名"
        end
        
      #------------------------------------------------------------------------
      # ■■ウィッチ種
      #
      # 耐久・素早さは中途半端だが、精神力の伸びが良く、魔法前提の攻めが得意。
      # 探索スキルもそこそこあり、戦闘もある程度できる。そのままでは器用貧乏。
      #------------------------------------------------------------------------
      when 37,38 
        @name = "Little Witch"
        @exp_type = 2
        @maxhp, @maxsp = 200, 230
        @str, @dex, @agi, @int = 30, 40, 40, 80
        @atk, @pdef, @mdef = 45, 30, 100
        @digest, @absorb = 2, 100
        @maxrune, @d_power = 3, 1
        @years_type, @bust_size = 2, 2
        @hold_rate[0] = [687,688] #無条件
        @hold_rate[1] = [682,683,689,695] #ムード20前後で解禁
        @hold_rate[2] = [684,698,700,701,710,711] #ムード40前後で解禁
        @hold_rate[3] = [691,692,696,697,702,712] #ムード60前後で解禁
        @hold_rate[4] = [705,706,707,715,716,717,718,719] #ムード100で解禁
        @contract_level = 0
        @exp = 9
        @gold = 10
        case race_id 
        when 37 # 緑
          @graphics = "petit_witch0-1"
          @next_rank_id = 42
          @default_name_self = "ボク"
          @default_name_hero = "お兄さん"
        when 38 # 紫
          @graphics = "petit_witch0-2"
          @next_rank_id = 43
          @default_name_self = "ボク"
          @default_name_hero = "お兄さん"
        end
      #------------------------------------------------------------------------
      when 42,43 
        @name = "Witch "
        @exp_type = 2
        @maxhp, @maxsp = 310, 350
        @str, @dex, @agi, @int = 65, 50, 50, 140
        @atk, @pdef, @mdef = 70, 50, 100
        @digest, @absorb = 3, 200
        @maxrune, @d_power = 3, 2
        @years_type, @bust_size = 3, 3
        @hold_rate[0] = [687,688,695] #無条件
        @hold_rate[1] = [682,683,689,698] #ムード20前後で解禁
        @hold_rate[2] = [684,692,697,700,701,710,711] #ムード40前後で解禁
        @hold_rate[3] = [691,696,702,712] #ムード60前後で解禁
        @hold_rate[4] = [705,706,707,715,716,717,718,719] #ムード100で解禁
        @contract_level = 8
        @exp = 17
        @gold = 18
        case race_id 
        when 42 # 緑
          @graphics = "witch1-1"
          @default_name_self = "私"
          @default_name_hero = "君"
        when 43 # 紫
          @graphics = "witch1-2"
          @default_name_self = "僕"
          @default_name_hero = "君"
       end

      #------------------------------------------------------------------------
      # ■■キャスト種
      #
      # 素早さが少しある程度で、あとは平均以下。戦闘には向いていない種族。
      # 探索スキルや後方支援スキルを覚え満腹度の減りが微小と、探索に向いている。
      #------------------------------------------------------------------------
      when 53,54
        @name = "Caster"
        @exp_type = 2
        @maxhp, @maxsp = 220, 220
        @str, @dex, @agi, @int = 30, 35, 60, 30
        @atk, @pdef, @mdef = 40, 40, 100
        @digest, @absorb = 2, 50
        @maxrune, @d_power = 3, 1
        @years_type, @bust_size = 2, 1
        @hold_rate[0] = [689,695] #無条件
        @hold_rate[1] = [687,688] #ムード20前後で解禁
        @hold_rate[2] = [682,683,684,697,698] #ムード40前後で解禁
        @hold_rate[3] = [691,692,700,701,702,710,711,712] #ムード60前後で解禁
        @hold_rate[4] = [696,705,706,707,715,716,717,718,719] #ムード100で解禁
        @contract_level = 2
        @exp = 7
        @gold = 15
        case race_id 
        when 53 # 黄
          @graphics = "cast0-1"
          @default_name_self = "わたし"
          @default_name_hero = "お兄さん"
        when 54 # 黒
          @graphics = "cast0-1"
          @maxhp, @maxsp = 400, 300
          @str, @dex, @agi, @int = 100, 100, 60, 100
          @atk, @pdef, @mdef = 200, 40, 100
          @default_name_self = "私"
          @default_name_hero = "主人公名"
        end

      #------------------------------------------------------------------------
      # ■■スレイヴ種
      #
      # ステータスは何もかも平均以下。その代わり満腹度の減りは最低値。
      # ルーンを５つ刻印できるため、カスタマイズ性がある。
      #------------------------------------------------------------------------
      when 63 
        @name = "Slave "
        @exp_type = 1
        @maxhp, @maxsp = 200, 200
        @str, @dex, @agi, @int = 30, 30, 30, 30
        @atk, @pdef, @mdef = 30, 30, 100
        @digest, @absorb = 1, 30
        @maxrune, @d_power = 5, 1
        @years_type, @bust_size = 2, 1
        @hold_rate[0] = [682,683,687,688] #無条件
        @hold_rate[1] = [684,689,691,692,697,698] #ムード20前後で解禁
        @hold_rate[2] = [695,700,701,710,711] #ムード40前後で解禁
        @hold_rate[3] = [696,702,712] #ムード60前後で解禁
        @hold_rate[4] = [705,706,707,715,716,717,718,719] #ムード100で解禁
        @contract_level = 8
        @exp = 5
        @gold = 0
        case race_id 
        when 63 # 紫
          @graphics = "slave0-1"
          @default_name_self = "わたし"
          @default_name_hero = "兄様"
        end

      #------------------------------------------------------------------------
      # ■■ナイトメア種
      #
      # 妨害スキル特化の種族であり、精神力と素早さがそこそこ高くそれ以外は平凡。
      # 単体では戦闘下手で、それを補うパーティ構築が重要な種族。
      #------------------------------------------------------------------------
      when 74,75
        @name = "Nightｍare"
        @exp_type = 3
        @maxhp, @maxsp = 330, 300
        @str, @dex, @agi, @int = 35, 47, 110, 80
        @atk, @pdef, @mdef = 75, 58, 100
        @digest, @absorb = 3, 180
        @maxrune, @d_power = 3, 2
        @years_type, @bust_size = 3, 3
        @hold_rate[0] = [684,692,695] #無条件
        @hold_rate[1] = [687,688,689,691,698] #ムード20前後で解禁
        @hold_rate[2] = [696,697] #ムード40前後で解禁
        @hold_rate[3] = [682,683,700,701,702,710,711,712] #ムード60前後で解禁
        @hold_rate[4] = [705,706,707,715,716,717,718,719] #ムード100で解禁
        @contract_level = 4
        @exp = 14
        @gold = 8
        case race_id 
        when 74 # 黒
          @graphics = "nightmare1-1"
          @default_name_self = "私"
          @default_name_hero = "おにーさん"
        when 75 # 黄
          @graphics = "nightmare1-2"
          @default_name_self = "私"
          @default_name_hero = "おにーさん"
        end

      #------------------------------------------------------------------------
      # ■■スライム種
      #
      # 高耐久とそれなりの火力、専用素質を持つが素早さは最低。精神力も結構低い。
      # レジストに対して非常に弱く、満腹度の減りも重めと、かなり癖が強い。
      #------------------------------------------------------------------------
      when 80 
        @name = "Sliｍe"
        @exp_type = 3
        @maxhp, @maxsp = 500, 350
        @str, @dex, @agi, @int = 50, 50, 20, 25
        @atk, @pdef, @mdef = 90, 85, 100
        @digest, @absorb = 4, 230
        @years_type, @bust_size = 3, 4
        @maxrune, @d_power = 3, 2
        @hold_rate[0] = [682,683,695] #無条件
        @hold_rate[1] = [687,688,697,698] #ムード20前後で解禁
        @hold_rate[2] = [684,691,692,700,701,710,711] #ムード40前後で解禁
        @hold_rate[3] = [689,696,702,712] #ムード60前後で解禁
        @hold_rate[4] = [705,706,707,715,716,717,718,719] #ムード100で解禁
        @contract_level = 4
        @exp = 14
        @gold = 1
        case race_id 
        when 80 # 青
          @graphics = "slime1-1"
          @default_name_self = "夢魔名"
          @default_name_hero = "おにいさん"
        end
      #------------------------------------------------------------------------
      # □ゴールドスライム
      #
      # スライムを少し強化したようなステータスを持つ。
      # その分、満腹度の減りは早め。
      #------------------------------------------------------------------------
      when 90
        @name = "Gold Sliｍe "
        @exp_type = 3
        @maxhp, @maxsp = 480, 310
        @str, @dex, @agi, @int = 50, 50, 20, 60
        @atk, @pdef, @mdef = 90, 110, 100
        @digest, @absorb = 4, 350
        @years_type, @bust_size = 3, 4
        @maxrune, @d_power = 3, 3
        @hold_rate[0] = [682,683,695] #無条件
        @hold_rate[1] = [687,688,697,698] #ムード20前後で解禁
        @hold_rate[2] = [684,691,692,700,701,710,711] #ムード40前後で解禁
        @hold_rate[3] = [689,696,702,712] #ムード60前後で解禁
        @hold_rate[4] = [705,706,707,715,716,717,718,719] #ムード100で解禁
        @contract_level = 20
        @exp = 20
        @gold = 50
        case race_id 
        when 90 # 黄
          @graphics = "gold_slime1-1"
          @default_name_self = "わたし"
          @default_name_hero = "お兄さん"
        end

      #------------------------------------------------------------------------
      # ■■ファミリア種
      #
      # 全体的に平均よりやや下。キャストに比べるとやや戦闘的。
      # 探索スキルや後方支援スキルを覚え満腹度の減りが微小と、探索に向く。
      #------------------------------------------------------------------------
      when 96,97
        @name = "Familiar"
        @exp_type = 3
        @maxhp, @maxsp = 240, 220
        @str, @dex, @agi, @int = 30, 65, 40, 50
        @atk, @pdef, @mdef = 50, 40, 100
        @digest, @absorb = 2, 90
        @maxrune, @d_power = 3, 1
        @years_type, @bust_size = 2, 1
        @tail = true
        @hold_rate[0] = [687,688,695] #無条件
        @hold_rate[1] = [682,683,697,698] #ムード20前後で解禁
        @hold_rate[2] = [684,691,692,700,701,702,710,711,712] #ムード40前後で解禁
        @hold_rate[3] = [689,696] #ムード60前後で解禁
        @hold_rate[4] = [705,706,707,715,716,717,718,719] #ムード100で解禁
        @contract_level = 8
        @exp = 10
        @gold = 9
        case race_id 
        when 96 # 青
          @graphics = "familiar0-1"
          @default_name_self = "私め"
          @default_name_hero = "ご主人様"
        when 97 # 緑
          @graphics = "familiar0-2"
          @default_name_self = "私め"
          @default_name_hero = "マスター"
          @hold_rate[1] += [710,711,712]
        end

      #------------------------------------------------------------------------
      # ■■ワーウルフ種
      #
      # 精力の高いホールドアタッカー。インサート系が強い。
      # 素早さも高いが、器用さ、精神力は低く満腹度の減りも早め。
      #------------------------------------------------------------------------
      when 100,101
        @name = "Werewolf"
        @exp_type = 3
        @maxhp, @maxsp = 350, 340
        @str, @dex, @agi, @int = 150, 50, 105, 22
        @atk, @pdef, @mdef = 70, 50, 100
        @digest, @absorb = 4, 210
        @maxrune, @d_power = 3, 2
        @years_type, @bust_size = 3, 2
        @tail = true
        @hold_rate[0] = [682,684,687,688] #無条件
        @hold_rate[1] = [683,695,700,701] #ムード20前後で解禁
        @hold_rate[2] = [689,697,698,702] #ムード40前後で解禁
        @hold_rate[3] = [691,692,696,710,711,712] #ムード60前後で解禁
        @hold_rate[4] = [705,706,707,715,716,717,718,719] #ムード100で解禁
        @contract_level = 8
        @exp = 16
        @gold = 4
        case race_id 
        when 100 # 黒
          @graphics = "werewolf1-1"
          @default_name_self = "ぼく"
          @default_name_hero = "ご主人"
        when 101 # 赤
          @graphics = "werewolf1-2"
          @default_name_self = "おれ"
          @default_name_hero = "ご主人"
        end
        
      #------------------------------------------------------------------------
      # ■■ワーキャット種
      #
      # 素早さが高く精力もそこそこ。他は平均水準。器用貧乏になりがち。
      # できることは多いのでカスタマイズ次第。
      #------------------------------------------------------------------------
      when 104,105
        @name = "Werecat "
        @exp_type = 3
        @maxhp, @maxsp = 300, 300
        @str, @dex, @agi, @int = 90, 80, 110, 70
        @atk, @pdef, @mdef = 70, 50, 100
        @digest, @absorb = 3, 160
        @maxrune, @d_power = 3, 2
        @years_type, @bust_size = 3, 1
        @tail = true
        @hold_rate[0] = [684,689,695] #無条件
        @hold_rate[1] = [682,683,687,688] #ムード20前後で解禁
        @hold_rate[2] = [692,697,698,700,701,705,706,710,711] #ムード40前後で解禁
        @hold_rate[3] = [691,696,702,707,712] #ムード60前後で解禁
        @hold_rate[4] = [715,716,717,718,719] #ムード100で解禁
        @contract_level = 8
        @exp = 15
        @gold = 15
        case race_id 
        when 104 # 黄
          @graphics = "werecat1-1"
          @default_name_self = "あちし"
          @default_name_hero = "おにぃさん"
        when 105 # 黒
          @graphics = "werecat1-2"
          @default_name_self = "あちし"
          @default_name_hero = "おにぃさん"
        end
        
      #------------------------------------------------------------------------
      # ■■ゴブリン種
      #
      # ゴブリンは精力アタッカーに寄ったインプのようなステータス。
      # ギャングコマンダーは安定感ができるが攻撃性能はそこまで。
      #------------------------------------------------------------------------
      when 108
        @name = "Goblin"
        @exp_type = 2
        @maxhp, @maxsp = 290, 260
        @str, @dex, @agi, @int = 120, 50, 80, 20
        @atk, @pdef, @mdef = 70, 40, 100
        @digest, @absorb = 3, 160
        @maxrune, @d_power = 3, 1
        @years_type, @bust_size = 1, 1
        @hold_rate[0] = [684,695] #無条件
        @hold_rate[1] = [682,683,687,688,700,710] #ムード20前後で解禁
        @hold_rate[2] = [689,692,697,698,701,711] #ムード40前後で解禁
        @hold_rate[3] = [691,696,702,712] #ムード60前後で解禁
        @hold_rate[4] = [705,706,707,715,716,717,718,719] #ムード100で解禁
        @contract_level = 4
        @exp = 12
        @gold = 10
        case race_id 
        when 108 # 赤
          @graphics = "goblin0-1"
          @next_rank_id = 111
          @default_name_self = "あたい"
          @default_name_hero = "にーちゃん"
        end
      #------------------------------------------------------------------------
      when 111
        @name = "Goblin Leader "
        @exp_type = 2
        @maxhp, @maxsp = 350, 320
        @str, @dex, @agi, @int = 110, 50, 80, 90
        @atk, @pdef, @mdef = 95, 70, 100
        @digest, @absorb = 4, 300
        @maxrune, @d_power = 3, 2
        @years_type, @bust_size = 1, 1
        @hold_rate[0] = [687,688] #無条件
        @hold_rate[1] = [682,683,684,695,700,710] #ムード20前後で解禁
        @hold_rate[2] = [689,692,697,698,701,711] #ムード40前後で解禁
        @hold_rate[3] = [691,696,702,712] #ムード60前後で解禁
        @hold_rate[4] = [705,706,707,715,716,717,718,719] #ムード100で解禁
        @contract_level = 12
        @exp = 17
        @gold = 18
        case race_id 
        when 111 # 赤
          @graphics = "gangcommander0-1"
          @default_name_self = "あたし"
          @default_name_hero = "にーさま"
        end

      #------------------------------------------------------------------------
      # ■■プリーステス種
      #
      # 耐久おばけ。ただし攻撃性能は無いに等しい。
      # 回復手段も豊富だが、ホールドには弱く完封もされやすい。
      #------------------------------------------------------------------------
      when 118
        @name = "Priestess "
        @exp_type = 3
        @maxhp, @maxsp = 380, 340
        @str, @dex, @agi, @int = 5, 5, 30, 120
        @atk, @pdef, @mdef = 5, 150, 100
        @digest, @absorb = 3, 230
        @maxrune, @d_power = 3, 2
        @years_type, @bust_size = 3, 2
        @hold_rate[0] = [] #無条件
        @hold_rate[1] = [] #ムード20前後で解禁
        @hold_rate[2] = [689,695] #ムード40前後で解禁
        @hold_rate[3] = [682,683,684,687,688,691,692,696,697,698,700,701,702,710,711,712] #ムード60前後で解禁
        @hold_rate[4] = [705,706,707,715,716,717,718,719] #ムード100で解禁
        @contract_level = 15
        @exp = 14
        @gold = 17
        case race_id 
        when 118 # 白
          @graphics = "priestess1-1"
          @default_name_self = "私"
          @default_name_hero = "貴公"
        end

      #------------------------------------------------------------------------
      # ■■カースメイガス種
      #
      # 特殊バステ系ウィッチ。
      # ウィッチ程器用ではないものの、素の攻撃性能はウィッチ以上。
      #------------------------------------------------------------------------
      when 122
        @name = "Cursed Magus"
        @exp_type = 3
        @maxhp, @maxsp = 310, 350
        @str, @dex, @agi, @int = 70, 50, 40, 140
        @atk, @pdef, @mdef = 92, 50, 100
        @digest, @absorb = 3, 270
        @maxrune, @d_power = 3, 2
        @years_type, @bust_size = 4, 4
        @hold_rate[0] = [682,683,687,688,689] #無条件
        @hold_rate[1] = [684,692,695,697,698,710,711] #ムード20前後で解禁
        @hold_rate[2] = [691,700,701,712] #ムード40前後で解禁
        @hold_rate[3] = [696,702] #ムード60前後で解禁
        @hold_rate[4] = [705,706,707,715,716,717,718,719] #ムード100で解禁
        @contract_level = 8
        @exp = 16
        @gold = 16
        case race_id 
        when 122 # 黒
          @graphics = "cursemagus2-1"
          @default_name_self = "アタシ"
          @default_name_hero = "アナタ"
        end
        
      #------------------------------------------------------------------------
      # ■■アルラウネ種
      #
      # 魅力の高いアタッカー。素早さ以外は平均的な能力値。
      # 【ロマンチスト】により高ムード時の爆発力がある。
      #------------------------------------------------------------------------
      when 126,127
        @name = "Alraune "
        @exp_type = 3
        @maxhp, @maxsp = 370, 320
        @str, @dex, @agi, @int = 80, 80, 25, 50
        @atk, @pdef, @mdef = 100, 70, 100
        @digest, @absorb = 4, 300
        @maxrune, @d_power = 3, 2
        @years_type, @bust_size = 3, 3
        @hold_rate[0] = [689] #無条件
        @hold_rate[1] = [687,688,695,698,718] #ムード20前後で解禁
        @hold_rate[2] = [682,683,697,700,701,710,711,717,719] #ムード40前後で解禁
        @hold_rate[3] = [684,691,692,696,702,712,715,716] #ムード60前後で解禁
        @hold_rate[4] = [705,706,707] #ムード100で解禁
        @contract_level = 6
        @exp = 16
        @gold = 8
        case race_id 
        when 126 # 緑
          @graphics = "alraune1-1"
          @default_name_self = "わたし"
          @default_name_hero = "おにいさん"
        when 127 # 青
          @graphics = "alraune1-2"
          @default_name_self = "私"
          @default_name_hero = "お兄様"
        end

      #------------------------------------------------------------------------
      # ■■マタンゴ種
      #
      # 鈍足型バステ撒き。ナイトメアとは違い、複数のバステをランダムに付ける種。
      # 耐久力そこそこ、火力はあんまりといった所。ナイトメアの相互互換。
      #------------------------------------------------------------------------
      when 133
        @name = "Matango "
        @exp_type = 3
        @maxhp, @maxsp = 420, 310
        @str, @dex, @agi, @int = 35, 47, 35, 60
        @atk, @pdef, @mdef = 80, 90, 100
        @digest, @absorb = 3, 280
        @maxrune, @d_power = 3, 2
        @years_type, @bust_size = 4, 3
        @hold_rate[0] = [687,688,695] #無条件
        @hold_rate[1] = [682,683,689,698] #ムード20前後で解禁
        @hold_rate[2] = [684,697,700,701,710,711] #ムード40前後で解禁
        @hold_rate[3] = [691,692,696,702,712] #ムード60前後で解禁
        @hold_rate[4] = [705,706,707,715,716,717,718,719] #ムード100で解禁
        @contract_level = 6
        @exp = 15
        @gold = 8
        case race_id 
        when 133 # 赤
          @graphics = "matango2-1"
          @default_name_self = "私"
          @default_name_hero = "貴方"
        end
        
      #------------------------------------------------------------------------
      # ■■ダークエンジェル種
      #
      # 戦闘支援と攻撃の両立をしたタイプ。
      # ウィッチやカースメイガス程器用では無いが、単体でも十分な火力を持つ。
      #------------------------------------------------------------------------
      when 137
        @name = "Dark Angel"
        @exp_type = 3
        @maxhp, @maxsp = 310, 350
        @str, @dex, @agi, @int = 70, 80, 95, 80
        @atk, @pdef, @mdef = 100, 50, 100
        @digest, @absorb = 3, 220
        @maxrune, @d_power = 3, 2
        @years_type, @bust_size = 3, 3
        @hold_rate[0] = [689,695,698] #無条件
        @hold_rate[1] = [684,687,688,692,697] #ムード20前後で解禁
        @hold_rate[2] = [682,683,691,700,701,710,711] #ムード40前後で解禁
        @hold_rate[3] = [696,702,712] #ムード60前後で解禁
        @hold_rate[4] = [705,706,707,715,716,717,718,719] #ムード100で解禁
        @contract_level = 10
        @exp = 17
        @gold = 15
        case race_id 
        when 137 # 白
          @graphics = "dark_angel1-1"
          @default_name_self = "わたくし"
          @default_name_hero = "あなた"
        end
        
      #------------------------------------------------------------------------
      # ■■ガーゴイル種
      #
      # 忍耐力が素で高い快感軽減タイプ。他も器用さが無い以外はそこそこ。
      # 攻撃能力は無くはないが、攻撃スキルに乏しくそこまで強くはない。
      #------------------------------------------------------------------------
      when 141
        @name = "Gargoyle"
        @exp_type = 3
        @maxhp, @maxsp = 380, 340
        @str, @dex, @agi, @int = 90, 45, 60, 70
        @atk, @pdef, @mdef = 80, 135, 100
        @digest, @absorb = 3, 240
        @maxrune, @d_power = 3, 2
        @years_type, @bust_size = 3, 4
        @tail = true
        @hold_rate[0] = [684,695] #無条件
        @hold_rate[1] = [682,683,687,688,696,698,700,701,710,711] #ムード20前後で解禁
        @hold_rate[2] = [692,697,702,705,706,712] #ムード40前後で解禁
        @hold_rate[3] = [689,691,707] #ムード60前後で解禁
        @hold_rate[4] = [715,716,717,718,719] #ムード100で解禁
        @contract_level = 10
        @exp = 17
        @gold = 10
        case race_id 
        when 141 # 黒
          @graphics = "gargoyle1-1"
          @default_name_self = "あたい"
          @default_name_hero = "マスター"
        end
        
      #------------------------------------------------------------------------
      # ■■ミミック種
      #
      # 耐久型支援タイプ。ウィッチとガーゴイルを足して２で割ったような性能。
      # 攻撃性能も魔法で強化して戦うことが前提。
      #------------------------------------------------------------------------
      when 145,146
        @name = "Miｍic"
        @exp_type = 3
        @maxhp, @maxsp = 360, 350
        @str, @dex, @agi, @int = 70, 50, 40, 110
        @atk, @pdef, @mdef = 80, 110, 100
        @digest, @absorb = 3, 270
        @maxrune, @d_power = 3, 2
        @years_type, @bust_size = 3, 3
        @hold_rate[0] = [697,698] #無条件
        @hold_rate[1] = [684,687,688,689,691,692,695,710,711] #ムード20前後で解禁
        @hold_rate[2] = [682,683,700,701,712] #ムード40前後で解禁
        @hold_rate[3] = [696,702] #ムード60前後で解禁
        @hold_rate[4] = [705,706,707,715,716,717,718,719] #ムード100で解禁
        @contract_level = 12
        @exp = 18
        @gold = 22
        case race_id 
        when 145 # 青
          @graphics = "mimic1-1"
          @default_name_self = "ワタシ"
          @default_name_hero = "お兄さん"
        when 146 # 黒
          @graphics = "mimic1-2"
          @default_name_self = "わたくし"
          @default_name_hero = "坊っちゃん"
        end
        
      #------------------------------------------------------------------------
      # ■■タマモ種
      #
      # 素質【厚着】により、高耐久鈍足アタッカーと低耐久高速アタッカーの顔を持つ。
      # 使いこなすのは難しいが、ステータス自体は侮れなく優秀。
      #------------------------------------------------------------------------
      when 152
        @name = "Taｍaｍo"
        @exp_type = 4
        @maxhp, @maxsp = 380, 380
        @str, @dex, @agi, @int = 100, 110, 110, 90
        @atk, @pdef, @mdef = 130, 30, 100
        @digest, @absorb = 6, 500
        @maxrune, @d_power = 3, 3
        @years_type, @bust_size = 3, 3
        @tail = true
        @hold_rate[0] = [689,705,706,707] #無条件
        @hold_rate[1] = [687,688,691,692,695,697,698] #ムード20前後で解禁
        @hold_rate[2] = [682,683,684,696] #ムード40前後で解禁
        @hold_rate[3] = [700,701,702,710,711,712] #ムード60前後で解禁
        @hold_rate[4] = [715,716,717,718,719] #ムード100で解禁
        @contract_level = 20
        @exp = 22
        @gold = 25
        case race_id 
        when 152 # 赤
          @graphics = "tamamo1-1"
          @default_name_self = "わらわ"
          @default_name_hero = "そなた"
        end
        
      #------------------------------------------------------------------------
      # ■■リリム種
      #
      # 耐久面を削り、火力とスピードに特化した低耐久高速アタッカー。
      # 魔法もそれなりに覚え、早さを利用した支援にも使える
      #------------------------------------------------------------------------
      when 156
        @name = "Liliｍ"
        @exp_type = 3
        @maxhp, @maxsp = 300, 340
        @str, @dex, @agi, @int = 100, 110, 120, 80
        @atk, @pdef, @mdef = 140, 20, 100
        @digest, @absorb = 5, 500
        @maxrune, @d_power = 3, 3
        @years_type, @bust_size = 2, 3
        @tail = true
        @hold_rate[0] = [682,684,687] #無条件
        @hold_rate[1] = [683,688,689,695,698] #ムード20前後で解禁
        @hold_rate[2] = [691,692,697,700,701,705,710,711] #ムード40前後で解禁
        @hold_rate[3] = [696,702,706,707,712] #ムード60前後で解禁
        @hold_rate[4] = [715,716,717,718,719] #ムード100で解禁
        @contract_level = 12
        @exp = 20
        @gold = 10
        case race_id 
        when 156 # 桃
          @graphics = "lilim0-1"
          @default_name_self = "私"
          @default_name_hero = "主人公名"
        end
        
      #------------------------------------------------------------------------
      # ■■ユニーク夢魔
      #------------------------------------------------------------------------
      # ■■ネイジュレンジ
      #
      # 耐久型バステ撒き。ＥＰ、ＶＰはかなり高い。素早さ、精神力は致命的。
      # 攻撃性能も悪いわけではなく、攻撃するだけで自然とバステがつくので強力。
      #------------------------------------------------------------------------
      when 251 #ユニークサキュバス/ネイジュレンジ
        @name, @graphics = "Neijorange", "boss_neijurange"
        @exp_type = 4
        @maxhp, @maxsp =  500, 400
        @str, @dex, @agi, @int = 80, 60, 5, 20
        @atk, @pdef, @mdef = 90, 100, 100
        @digest, @absorb = 6, 580
        @maxrune, @d_power = 3, 50
        @years_type, @bust_size = 3, 4
        @tail = true
        @hold_rate[0] = [684,687,688] #無条件
        @hold_rate[1] = [682,683,695,697,689,698,705,706] #ムード20前後で解禁
        @hold_rate[2] = [692,700,701,707,710,711] #ムード40前後で解禁
        @hold_rate[3] = [691,696,702,712] #ムード60前後で解禁
        @hold_rate[4] = [715,716,717,718,719] #ムード100で解禁
        @contract_level = 0
        @default_name_self = "あたし"
        @default_name_hero = "キミ"
      #------------------------------------------------------------------------
      # ■■リジェオ
      #
      # フィールド型支援型ユニーク。レッサーサキュバス程度は攻撃性能はある。
      # 素早さも高いが、ＶＰはかなり低く戦闘ではスタミナ切れが早い。
      #------------------------------------------------------------------------
      when 252 #ユニークサキュバス/リジェオ
        @name, @graphics = "Rejeo ", "boss_rejeo"
        @exp_type = 4
        @maxhp, @maxsp = 350, 200
        @str, @dex, @agi, @int = 60, 80, 110, 80
        @atk, @pdef, @mdef = 90, 30, 100
        @digest, @absorb = 3, 350
        @maxrune, @d_power = 3, 50
        @years_type, @bust_size = 2, 1
        @tail = true
        @hold_rate[0] = [689,695] #無条件
        @hold_rate[1] = [687,688] #ムード20前後で解禁
        @hold_rate[2] = [683,710,711] #ムード40前後で解禁
        @hold_rate[3] = [682,684,691,692,696,697,698,700,701,702,705,706,707,712] #ムード60前後で解禁
        @hold_rate[4] = [715,716,717,718,719] #ムード100で解禁
        @contract_level = 0
        @default_name_self = "私"
        @default_name_hero = "主人公名"
      #------------------------------------------------------------------------
      # ■■フルビュア
      #
      # 高速火力アタッカー。攻撃性能がとにかく高く、素早さもかなり高い。
      # 耐久力は決して低くはないものの、不安の残る所。
      #------------------------------------------------------------------------
      when 253 #ユニークサキュバス/フルビュア
        @name, @graphics = "Fulbeua ", "boss_fulbeua"
        @exp_type = 4
        @maxhp, @maxsp =  360, 400
        @str, @dex, @agi, @int = 110, 95, 102, 70
        @atk, @pdef, @mdef = 170, 50, 100
        @digest, @absorb = 6, 620
        @maxrune, @d_power = 3, 50
        @years_type, @bust_size = 3, 4
        @tail = true
        @hold_rate[0] = [682,683,684,687,688] #無条件
        @hold_rate[1] = [689,697,698,700,701,705] #ムード20前後で解禁
        @hold_rate[2] = [691,692,702,706,710,711] #ムード40前後で解禁
        @hold_rate[3] = [695,696,707,712] #ムード60前後で解禁
        @hold_rate[4] = [715,716,717,718,719] #ムード100で解禁
        @contract_level = 0
        @default_name_self = "私"
        @default_name_hero = "貴方"
      #------------------------------------------------------------------------
      # ■■ギルゴーン
      #
      # 夢魔のおもちゃ。膨大なＶＰにより耐久面は多少相殺されている。
      # 攻撃性能は低く、戦闘型支援タイプ。精神力も膨大で、魔法の効果は高い。
      #------------------------------------------------------------------------
      when 254 #ユニークサキュバス/ギルゴーン
        @name, @graphics = "Gilgoon ", "boss_gilgoon"
        @exp_type = 4
        @maxhp, @maxsp =  250, 1000
        @str, @dex, @agi, @int = 30, 30, 40, 300
        @atk, @pdef, @mdef = 40, 5, 100
        @digest, @absorb = 4, 500
        @maxrune, @d_power = 3, 50
        @years_type, @bust_size = 1, 1
        @hold_rate[0] = [683,687,688,700,701,710,711] #無条件
        @hold_rate[1] = [689,691,697,698,702,712] #ムード20前後で解禁
        @hold_rate[2] = [682,684,692] #ムード40前後で解禁
        @hold_rate[3] = [695,696] #ムード60前後で解禁
        @hold_rate[4] = [705,706,707,715,716,717,718,719] #ムード100で解禁
        @contract_level = 0
        @default_name_self = "我"
        @default_name_hero = "貴様"
      #------------------------------------------------------------------------
      # ■■ユーガノット
      #
      # 触手によるホールドアタッカー。素の能力は低いが、触手スキルが強力。
      # ＶＰは高いものの、触手スキルの消費ＶＰは高め。精神力は優秀。
      #------------------------------------------------------------------------
      when 255 #ユニークサキュバス/ユーガノット
        @name, @graphics = "Yuganaught", "boss_youganot"
        @exp_type = 4
        @maxhp, @maxsp =  320, 470
        @str, @dex, @agi, @int = 40, 80, 90, 180
        @atk, @pdef, @mdef = 100, 80, 100
        @digest, @absorb = 6, 600
        @maxrune, @d_power = 3, 50
        @years_type, @bust_size = 2, 2
        @tail = true
        @hold_rate[0] = [717,717,717,718,718,718] #無条件
        @hold_rate[1] = [684,688,692,689,698,700,701,705] #ムード20前後で解禁
        @hold_rate[2] = [682,687,697,702,706,710,711] #ムード40前後で解禁
        @hold_rate[3] = [683,691,707,712] #ムード60前後で解禁
        @hold_rate[4] = [695,696] #ムード100で解禁
        @contract_level = 0
        @default_name_self = "ボク"
        @default_name_hero = "キミ"
      #------------------------------------------------------------------------
      # ■■シルフェ
      #
      # 支援と攻撃を両立するユニーク。多様性に特化している。
      # 素の攻撃性能は低いが【ロマンチスト】持ちで、火力にも期待できる
      #------------------------------------------------------------------------
      when 256 #ユニークサキュバス/シルフェ
        @name, @graphics = "Sylphe", "boss_shilphe"
        @exp_type = 4
        @maxhp, @maxsp =  380, 380
        @str, @dex, @agi, @int = 90, 100, 50, 90
        @atk, @pdef, @mdef = 90, 90, 100
        @digest, @absorb = 5, 550
        @maxrune, @d_power = 3, 50
        @years_type, @bust_size = 3, 4
        @tail = true
        @hold_rate[0] = [689,695] #無条件
        @hold_rate[1] = [687,688,697,698] #ムード20前後で解禁
        @hold_rate[2] = [683,692,710,711] #ムード40前後で解禁
        @hold_rate[3] = [682,684,691,696,712] #ムード60前後で解禁
        @hold_rate[4] = [700,701,702,705,706,707,715,716,717,718,719] #ムード100で解禁
        @contract_level = 0
        @default_name_self = "私"
        @default_name_hero = "主人公名様"
      #------------------------------------------------------------------------
      # ■■ラーミル
      #
      # そこそこなステータス。精神力が高く、魔法も多用に使える。
      # 火力はそこまでといった印象ではないが、十分高い方。
      #------------------------------------------------------------------------
      when 257 #ユニークサキュバス/ラーミル
        @name, @graphics = "Ramile", "boss_rarmil"
        @exp_type = 4
        @maxhp, @maxsp = 400, 450
        @str, @dex, @agi, @int = 80, 50, 60, 250
        @atk, @pdef, @mdef = 80, 80, 100
        @digest, @absorb = 5, 580
        @maxrune, @d_power = 3, 50
        @years_type, @bust_size = 4, 4
        @hold_rate[0] = [687,689,697,698] #無条件
        @hold_rate[1] = [682,684,692] #ムード20前後で解禁
        @hold_rate[2] = [691] #ムード40前後で解禁
        @hold_rate[3] = [683,688,695,696,700,701,702,710,711,712] #ムード60前後で解禁
        @hold_rate[4] = [705,706,707,715,716,717,718,719] #ムード100で解禁
        @contract_level = 0
        @default_name_self = "私"
        @default_name_hero = "主人公名"
      #------------------------------------------------------------------------
      # ■■ヴェルミィーナ
      #
      # 単純戦闘能力で言えば最強。全てに置いて高水準なステータスを持つ
      # その代わり空腹率は最大値の7。完全に戦闘特化となっている。
      #------------------------------------------------------------------------
      when 258 #ユニークサキュバス/ヴェルミィーナ
        @name, @graphics = "Vermiena", "boss_vermiena"
        @exp_type = 4
        @maxhp, @maxsp = 450, 450
        @str, @dex, @agi, @int = 140, 140, 100, 100
        @atk, @pdef, @mdef = 160, 100, 100
        @digest, @absorb = 7, 1000
        @maxrune, @d_power = 3, 50
        @years_type, @bust_size = 3, 5
        @tail = true
        @hold_rate[0] = [687,688,689] #無条件
        @hold_rate[1] = [682,683,697,698] #ムード20前後で解禁
        @hold_rate[2] = [684,692,700,701,705,710,711] #ムード40前後で解禁
        @hold_rate[3] = [691,695,696,702,706,707,712] #ムード60前後で解禁
        @hold_rate[4] = [715,716,717,718,719] #ムード100で解禁
        @contract_level = 0
        @default_name_self = "私"
        @default_name_hero = "主人公名"
      #------------------------------------------------------------------------
      # ■■その他
      #------------------------------------------------------------------------
      else
        @name = "Succubus"
        @exp_type = 1
        @maxhp, @maxsp =  380, 360
        @str, @dex, @agi, @int = 90, 70, 85, 60
        @atk, @pdef, @mdef = 120, 65, 100
        @digest, @absorb = 5, 320
        @years_type, @bust_size = 3, 4
        @tail = true
        @maxrune, @d_power = 3, 2
        @hold_rate[0] = [682,687,697] #無条件
        @hold_rate[1] = [683,684,689,695,700,710] #ムード20前後で解禁
        @hold_rate[2] = [688,698,701,705,706,711] #ムード40前後で解禁
        @hold_rate[3] = [691,692,696,702,707,712] #ムード60前後で解禁
        @hold_rate[4] = [715,716,717,718,719] #ムード100で解禁
        @contract_level = 10
        @exp = 18
        @gold = 14
      end
    end
  end
  #--------------------------------------------------------------------------
  # ■ 種族値情報まとめ
  #--------------------------------------------------------------------------
  class SDB
    #--------------------------------------------------------------------------
    # ● 公開インスタンス変数
    #--------------------------------------------------------------------------
    attr_accessor :data
    #--------------------------------------------------------------------------
    # ● オブジェクト初期化
    #--------------------------------------------------------------------------
    def initialize
      @data = []
      @max = 300 #素質の登録数上限
      for i in 0..@max
        @data[i] = Succubus_registration.new(i)
      end
    end
    #--------------------------------------------------------------------------
    # ● 種族値の取得
    #--------------------------------------------------------------------------
    def [](succubus_id)
      return @data[succubus_id]
    end
  end
end