#==============================================================================
# ■ RPG::Personality
#------------------------------------------------------------------------------
# 　性格の情報。$data_personality["名前"]から参照可能。
#==============================================================================
module RPG
  #--------------------------------------------------------------------------
  # ■ 性格の登録
  #--------------------------------------------------------------------------
  class Personality_registration
    #--------------------------------------------------------------------------
    # ● 公開インスタンス変数
    #--------------------------------------------------------------------------
    attr_accessor :id              # id
    attr_accessor :name            # 名前
    attr_accessor :UK_name         # English namu
    attr_accessor :attack_regist   # 攻め時のレジスト補正
    attr_accessor :defense_regist  # 受け時のレジスト補正
    attr_accessor :talk_pattern    # 好む会話の種類
    attr_accessor :talk_difficulty # 会話難易度
    attr_accessor :special_attack  # 特殊攻撃の使用開放条件
    
    # データ追記
    
    #--------------------------------------------------------------------------
    # ● オブジェクト初期化
    #--------------------------------------------------------------------------
    def initialize(personality_id)
      @id = personality_id
      @name = ""
      @UK_name = ""
      @attack_regist = []
      @defense_regist = []
      #会話タイプで[要求]を引いた場合のランダム選択。
      #["好意","愛撫","脱衣E","脱衣A","視姦","奉仕","吸精","挿入","契約"]
      #対応する数値が現在の$mood.point以下なら選択肢に入る
      @talk_pattern = [0,0,0,0,0,0,0,0,0]
      #会話難易度：その会話に対する要求の度合いを表す
      #レジストゲージの矢印数となる
      #値が大きいほどその会話が選ばれた際に断りづらくなる
      @talk_difficulty = [3,3,3,3,3,3,3,3,3]
      #ホールドや特殊攻撃を行うスイッチ
      #１〜３段階あり、規定数にムード値が達すると使用するようになる
      @special_attack = [20,40,60]
      setup(personality_id)
    end
    #--------------------------------------------------------------------------
    # ● セットアップ
    #--------------------------------------------------------------------------
    def setup(personality_id)
      case personality_id
      when 0
        @name = "好色"
        @UK_name = "Lusty"
        @attack_regist = [2, 2, 3, 3, 4]
        @defense_regist = [0, 0, -1, -2, -3]
        #["好意","愛撫","脱衣E","脱衣A","視姦","奉仕","吸精","挿入","契約"]
        @talk_pattern = [0, 0, 20, 20, 30, 20, 40, 60, 100]
        @talk_difficulty = [3, 4, 4, 4, 4, 3, 4, 6, 3]
        @special_attack = [15,30,45]
      when 1
        @name = "上品"
        @UK_name = "Refined"
        @attack_regist = [0, 1, 1, 1, 2]
        @defense_regist = [2, 2, 1, 1, 0]
        #["好意","愛撫","脱衣E","脱衣A","視姦","奉仕","吸精","挿入","契約"]
        @talk_pattern = [0, 0, 40, 40, 50, 30, 50, 70, 100]
        @talk_difficulty = [3, 4, 4, 4, 4, 3, 4, 6, 3]
        @special_attack = [25,45,65]
      when 2
        @name = "高慢"
        @UK_name = "Proud"
        @attack_regist = [2, 2, 1, 1, 0]
        @defense_regist = [3, 2, 1, 0, -1]
        #["好意","愛撫","脱衣E","脱衣A","視姦","奉仕","吸精","挿入","契約"]
        @talk_pattern = [0, 0, 10, 10, 20, 10, 40, 50, 100]
        @talk_difficulty = [3, 4, 4, 4, 4, 3, 4, 6, 3]
        @special_attack = [30,50,70]
      when 3
        @name = "淡泊"
        @UK_name = "Frank"
        @attack_regist = [0, 0, 0, 0, 1]
        @defense_regist = [0, 0, 0, 0, -1]
        #["好意","愛撫","脱衣E","脱衣A","視姦","奉仕","吸精","挿入","契約"]
        @talk_pattern = [0, 0, 30, 30, 60, 40, 40, 70, 100]
        @talk_difficulty = [3, 4, 4, 4, 4, 3, 4, 6, 3]
        @special_attack = [30,50,70]
      when 4
        @name = "柔和"
        @UK_name = "Gentle"
        @attack_regist = [0, 0, 0, 1, 3]
        @defense_regist = [-1, -1, -1, 0, 0]
        #["好意","愛撫","脱衣E","脱衣A","視姦","奉仕","吸精","挿入","契約"]
        @talk_pattern = [0, 0, 10, 20, 30, 40, 40, 60, 100]
        @talk_difficulty = [3, 4, 4, 4, 4, 3, 4, 6, 3]
        @special_attack = [25,45,65]
      when 5
        @name = "勝ち気"
        @UK_name = "Adamant"
        @attack_regist = [1, 1, 2, 2, 3]
        @defense_regist = [1, 1, 1, 0, -1]
        #["好意","愛撫","脱衣E","脱衣A","視姦","奉仕","吸精","挿入","契約"]
        @talk_pattern = [0, 0, 40, 20, 30, 30, 40, 60, 100]
        @talk_difficulty = [3, 4, 4, 4, 4, 3, 4, 6, 3]
        @special_attack = [20,40,60]
      when 6
        @name = "内気"
        @UK_name = "Shy"
        @attack_regist = [-2, -2, -1, 0, 1]
        @defense_regist = [4, 3, 1, -1, -3]
        #["好意","愛撫","脱衣E","脱衣A","視姦","奉仕","吸精","挿入","契約"]
        @talk_pattern = [0, 0, 50, 40, 60, 60, 60, 80, 100]
        @talk_difficulty = [3, 4, 4, 4, 4, 3, 4, 6, 3]
        @special_attack = [35,55,75]
      when 7
        @name = "陽気"
        @UK_name = "Happy"
        @attack_regist = [1, 1, 1, 2, 2]
        @defense_regist = [0, 0, -1, -1, -2]
        #["好意","愛撫","脱衣E","脱衣A","視姦","奉仕","吸精","挿入","契約"]
        @talk_pattern = [0, 0, 0, 0, 40, 30, 50, 70, 100]
        @talk_difficulty = [3, 4, 4, 4, 4, 3, 4, 6, 3]
        @special_attack = [20,40,60]
      when 8
        @name = "意地悪"
        @UK_name = "Crafty"
        @attack_regist = [0, 1, 1, 2, 3]
        @defense_regist = [2, 1, 0, -1, -2]
        #["好意","愛撫","脱衣E","脱衣A","視姦","奉仕","吸精","挿入","契約"]
        @talk_pattern = [0, 0, 30, 0, 10, 10, 30, 50, 100]
        @talk_difficulty = [3, 4, 4, 4, 4, 3, 4, 6, 3]
        @special_attack = [25,45,65]
      when 9
        @name = "天然"
        @UK_name = "True"
        @attack_regist = [-1, -1, 0, 1, 2]
        @defense_regist = [0, 0, -1, -1, -2]
        #["好意","愛撫","脱衣E","脱衣A","視姦","奉仕","吸精","挿入","契約"]
        @talk_pattern = [0, 0, 20, 20, 70, 50, 30, 70, 100]
        @talk_difficulty = [3, 4, 4, 4, 4, 3, 4, 6, 3]
        @special_attack = [20,40,60]
      when 10
        @name = "従順"
        @UK_name = "Obedient"
        @attack_regist = [-1, -1, -1, 0, 1]
        @defense_regist = [-2, -2, -2, -3, -3]
        #["好意","愛撫","脱衣E","脱衣A","視姦","奉仕","吸精","挿入","契約"]
        @talk_pattern = [0, 0, 60, 60, 60, 60, 40, 60, 100]
        @talk_difficulty = [3, 4, 4, 4, 4, 3, 4, 6, 3]
        @special_attack = [15,30,45]
      when 11
        @name = "虚勢"
        @UK_name = "Gutsy"
        @attack_regist = [3, 1, 0, -1, -2]
        @defense_regist = [3, 1, 0, -1, -2]
        #["好意","愛撫","脱衣E","脱衣A","視姦","奉仕","吸精","挿入","契約"]
        @talk_pattern = [0, 0, 10, 30, 30, 30, 40, 60, 100]
        @talk_difficulty = [3, 4, 4, 4, 4, 3, 4, 6, 3]
        @special_attack = [20,45,70]
      when 12
        @name = "倒錯"
        @UK_name = "Pervert"
        @attack_regist = [2, 3, 3, 4, 4]
        @defense_regist = [-1, -2, -3, -4, -5]
        #["好意","愛撫","脱衣E","脱衣A","視姦","奉仕","吸精","挿入","契約"]
        @talk_pattern = [0, 0, 0, 0, 0, 0, 50, 20, 100]
        @talk_difficulty = [3, 4, 4, 4, 4, 3, 4, 6, 3]
        @special_attack = [10,25,40]
      when 13
        @name = "甘え性"
        @UK_name = "Addicted"
        @attack_regist = [-1, 2, 3, 3, 3]
        @defense_regist = [0, 0, 0, -1, -1]
        #["好意","愛撫","脱衣E","脱衣A","視姦","奉仕","吸精","挿入","契約"]
        @talk_pattern = [0, 0, 20, 20, 40, 0, 50, 20, 100]
        @talk_difficulty = [3, 4, 4, 4, 4, 3, 4, 6, 3]
        @special_attack = [20,40,60]
      when 14
        @name = "不思議"
        @UK_name = "Strange"
        @attack_regist = [2, -3, 3, -4, 4]
        @defense_regist = [-2, 3, -3, 4, -4]
        #["好意","愛撫","脱衣E","脱衣A","視姦","奉仕","吸精","挿入","契約"]
        @talk_pattern = [0, 0, 0, 0, 0, 0, 0, 0, 50]
        @talk_difficulty = [3, 4, 4, 4, 4, 3, 4, 6, 3]
        @special_attack = [10,20,30]
      when 15
        @name = "真面目"
        @UK_name = "Earnest"
        @attack_regist = [0, 1, 1, 2, 2]
        @defense_regist = [1, 1, 1, 0, 0]
        #["好意","愛撫","脱衣E","脱衣A","視姦","奉仕","吸精","挿入","契約"]
        @talk_pattern = [0, 0, 20, 20, 30, 20, 40, 60, 100]
        @talk_difficulty = [3, 4, 4, 4, 4, 3, 4, 6, 3]
        @special_attack = [20,40,60]
      when 16
        @name = "腕白"
        @UK_name = "Naughty"
        @attack_regist = [1, 2, 2, 3, 4]
        @defense_regist = [0, 0, 0, -1, -1]
        #["好意","愛撫","脱衣E","脱衣A","視姦","奉仕","吸精","挿入","契約"]
        @talk_pattern = [0, 0, 20, 20, 30, 20, 40, 60, 100]
        @talk_difficulty = [3, 4, 4, 4, 4, 3, 4, 6, 3]
        @special_attack = [20,40,60]
      when 17
        @name = "冷静"
        @UK_name = "Calm"
        @attack_regist = [0, 0, 0, 1, 1]
        @defense_regist = [2, 2, 3, 3, 4]
        #["好意","愛撫","脱衣E","脱衣A","視姦","奉仕","吸精","挿入","契約"]
        @talk_pattern = [0, 0, 20, 20, 30, 20, 40, 60, 100]
        @talk_difficulty = [3, 4, 4, 4, 4, 3, 4, 6, 3]
        @special_attack = [20,40,60]
      when 18
        @name = "独善" # ▼フルビュアの性格
        @UK_name = "Conceited"
        @attack_regist = [2, 3, 3, 4, 4]
        @defense_regist = [3, 1, -2, -3, -3]
        #["好意","愛撫","脱衣E","脱衣A","視姦","奉仕","吸精","挿入","契約"]
        @talk_pattern = [0, 0, 0, 0, 0, 0, 20, 50, 255]
        @talk_difficulty = [3, 4, 4, 4, 4, 3, 4, 6, 3]
        @special_attack = [20,40,60]
      when 19
        @name = "気丈" # ▼リジェオの性格　勝ち気ベース
        @UK_name = "Headstrong"
        @attack_regist = [1, 1, 2, 2, 3]
        @defense_regist = [1, 1, 1, 0, -1]
        #["好意","愛撫","脱衣E","脱衣A","視姦","奉仕","吸精","挿入","契約"]
        @talk_pattern = [0, 0, 40, 20, 30, 30, 40, 60, 100]
        @talk_difficulty = [3, 4, 4, 4, 4, 3, 4, 6, 3]
        @special_attack = [20,40,60]
      when 20
        @name = "暢気" # ▼ネイジュレンジの性格　柔和ベース
        @UK_name = "Easygoing"
        @attack_regist = [0, 0, 0, 1, 3]
        @defense_regist = [-1, -1, -1, 0, 0]
        #["好意","愛撫","脱衣E","脱衣A","視姦","奉仕","吸精","挿入","契約"]
        @talk_pattern = [0, 0, 10, 20, 30, 40, 40, 60, 100]
        @talk_difficulty = [3, 4, 4, 4, 4, 3, 4, 6, 3]
        @special_attack = [25,45,65]
      when 21
        @name = "陰気" # ▼ユーガノットの性格　天然ベース
        @UK_name = "Depressed"
        @attack_regist = [-1, -1, 0, 1, 2]
        @defense_regist = [0, 0, -1, -1, -2]
        #["好意","愛撫","脱衣E","脱衣A","視姦","奉仕","吸精","挿入","契約"]
        @talk_pattern = [0, 0, 20, 20, 70, 50, 30, 70, 100]
        @talk_difficulty = [3, 4, 4, 4, 4, 3, 4, 6, 3]
        @special_attack = [20,40,60]
      when 22
        @name = "尊大" # ▼ギルゴーンの性格　虚勢ベース
        @UK_name = "Haughty"
        @attack_regist = [3, 1, 0, -1, -2]
        @defense_regist = [3, 1, 0, -1, -2]
        #["好意","愛撫","脱衣E","脱衣A","視姦","奉仕","吸精","挿入","契約"]
        @talk_pattern = [0, 0, 10, 30, 30, 30, 40, 60, 100]
        @talk_difficulty = [3, 4, 4, 4, 4, 3, 4, 6, 3]
        @special_attack = [20,45,70]
      when 23
        @name = "高貴" # ▼シルフェの性格　上品ベース
        @UK_name = "Noble"
        @attack_regist = [0, 1, 1, 1, 2]
        @defense_regist = [2, 2, 1, 1, 0]
        #["好意","愛撫","脱衣E","脱衣A","視姦","奉仕","吸精","挿入","契約"]
        @talk_pattern = [0, 0, 40, 40, 50, 30, 50, 70, 100]
        @talk_difficulty = [3, 4, 4, 4, 4, 3, 4, 6, 3]
        @special_attack = [25,45,65]
      when 24
        @name = "潔癖" # ▼ラーミルの性格　真面目ベース
        @UK_name = "Subtle"
        @attack_regist = [0, 1, 1, 2, 2]
        @defense_regist = [1, 1, 1, 0, 0]
        #["好意","愛撫","脱衣E","脱衣A","視姦","奉仕","吸精","挿入","契約"]
        @talk_pattern = [0, 0, 20, 20, 30, 20, 40, 60, 100]
        @talk_difficulty = [3, 4, 4, 4, 4, 3, 4, 6, 3]
        @special_attack = [20,40,60]
      when 25
        @name = "露悪狂" # ▼ヴェルミィーナの性格　倒錯ベース
        @UK_name = "Crazy devil"
        @attack_regist = [2, 3, 3, 4, 4]
        @defense_regist = [-1, -2, -3, -4, -5]
        #["好意","愛撫","脱衣E","脱衣A","視姦","奉仕","吸精","挿入","契約"]
        @talk_pattern = [0, 0, 0, 0, 0, 0, 50, 20, 100]
        @talk_difficulty = [3, 4, 4, 4, 4, 3, 4, 6, 3]
        @special_attack = [10,25,40]
      else
        @name = "未設定"
        @UK_name = "Undefined"
        @attack_regist = [0, 0, 0, 1, 1]
        @defense_regist = [2, 2, 3, 3, 4]
        #["好意","愛撫","脱衣E","脱衣A","視姦","奉仕","吸精","挿入","契約"]
        @talk_pattern = [0, 0, 20, 20, 30, 20, 40, 60, 100]
        @talk_difficulty = [3, 4, 4, 4, 4, 3, 4, 6, 3]
        @special_attack = [20,40,60]
      end
    end
  end
  #--------------------------------------------------------------------------
  # ■ 素質情報まとめ
  #--------------------------------------------------------------------------
  class Personality
    #--------------------------------------------------------------------------
    # ● 公開インスタンス変数
    #--------------------------------------------------------------------------
    attr_accessor :data
    #--------------------------------------------------------------------------
    # ● オブジェクト初期化
    #--------------------------------------------------------------------------
    def initialize
      @data = []
      @max = 50 #性格の登録数上限
      for i in 0..@max
        @data[i] = Personality_registration.new(i)
      end
    end
    #--------------------------------------------------------------------------
    # ● 性格の取得
    # personality_name : 性格名(idを入れても対応可能)
    #--------------------------------------------------------------------------
    def [](personality_name)
      # 文字列以外の場合が引数の場合
      unless personality_name.is_a?(String)
        return @data[personality_name]
      end
      # 以下、文字列検索
      for data in @data
        if data.name == personality_name
          return data
        end
      end
      # 登録された名前が無い場合
      return @data[0]
    end
    #--------------------------------------------------------------------------
    # ● 性格idの検索
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
      return n
    end
  end
end