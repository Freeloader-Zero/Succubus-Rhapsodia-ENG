#==============================================================================
# ■ Game_Enemy
#------------------------------------------------------------------------------
# 　エネミーを扱うクラスです。このクラスは Game_Troop クラス ($game_troop) の
# 内部で使用されます。
#==============================================================================

class Game_Enemy < Game_Battler
  
  #--------------------------------------------------------------------------
  # ★ 個性の作成
  #--------------------------------------------------------------------------
  def make_individuality(personality = "", ability = ["未設定"])
=begin
    box = []
    for action in $data_enemies[id].actions
      box.push($data_skills[action.skill_id].name) 
    end
    p [name] + box
=end
    # ■　個性の作成　■

    # ■追記部分-----------------------------------
    #
    # エネミーのＩＤから判断
    # ・personality_group :  性格グループの取得　
    # ・ability_group     :  素質グループの取得　[素質名/(発生確率/100)]
    #
    # ---------------------------------------------
    
    # デフォルト
    personality_group = [0, "好色", "陽気", "意地悪"]
    ability_group = []
    # そのレベルまでに習得している素質をすべて搭載
    for i in 1..self.level
      for j in $data_classes[self.class_id].learnings
        if j[0] == i
          if j[1] == 1
            ability_group += [j[2]]
          end
        end
      end
    end
    
    # エネミーのクラスごとに自動設定
    case self.class_name
    # -----------------------------------------------------------------------
    when "Lesser Succubus ","Succubus","Succubus Lord "
      personality_group = 
       case self.class_color
       when "橙" ; [1, "好色", "陽気", "陽気"]
       when "桃" ; [1, "好色", "好色", "好色"]
       end
    # -----------------------------------------------------------------------
    when "Iｍp","Devil ","Deｍon"
      personality_group = 
       case self.class_color
       when "緑" ; [1, "勝ち気", "虚勢", "虚勢"]
       when "白" ; [1, "高慢", "高慢", "高慢"]
       end
    # -----------------------------------------------------------------------
    when "Little Witch","Witch "
      personality_group = 
       case self.class_color
       when "緑" ; [1, "上品", "淡泊", "淡泊"]
       when "紫" ; [1, "好色", "好色", "好色"]
       end
    # -----------------------------------------------------------------------
    when "Caster"
      personality_group = 
       case self.class_color
       when "黄" ; [1, "内気", "内気", "従順"]
       when "黒" ; [1, "好色", "好色", "好色"] 
       end
       ability_group += ["女陰が性感帯/100"] if self.class_color == "黒"
    # -----------------------------------------------------------------------
    when "Slave "
      personality_group = 
       case self.class_color
       when "紫" ; [1, "従順", "従順", "倒錯"]
       end
    # -----------------------------------------------------------------------
    when "Nightｍare"
      personality_group = 
       case self.class_color
       when "黒" ; [1, "淡泊", "淡泊", "不思議"]
       when "黄" ; [1, "天然", "天然", "天然"]
       end
    # -----------------------------------------------------------------------
    when "Sliｍe"
      personality_group = 
       case self.class_color
       when "青" ; [1, "天然", "柔和", "柔和"]
       end
    # -----------------------------------------------------------------------
    when "Gold Sliｍe "
      personality_group = 
       case self.class_color
       when "黄" ; [1, "柔和", "柔和", "上品"]
       end
    # -----------------------------------------------------------------------
    when "Familiar"
      personality_group = 
       case self.class_color
       when "青" ; [1, "従順", "淡泊", "淡泊"]
       when "緑" ; [1, "倒錯", "倒錯", "倒錯"]
       end
    # -----------------------------------------------------------------------
    when "Werewolf"
      personality_group = 
       case self.class_color
       when "黒" ; [1, "虚勢", "虚勢", "甘え性"]
       when "赤" ; [1, "勝ち気", "勝ち気", "勝ち気"]
       end
    # -----------------------------------------------------------------------
    when "Werecat "
      personality_group = 
       case self.class_color
       when "黄" ; [2, "天然", "天然", "意地悪"]
       when "黒" ; [1, "不思議", "不思議", "不思議"]
       end
    # -----------------------------------------------------------------------
    when "Goblin", "Goblin Leader "
      personality_group = 
       case self.class_color
       when "赤" ; [1, "陽気", "甘え性", "甘え性"]
       end
    # -----------------------------------------------------------------------
    when "Priestess "
      personality_group = 
       case self.class_color
       when "白" ; [1, "上品", "高慢", "高慢"]
       end
    # -----------------------------------------------------------------------
    when "Cursed Magus"
      personality_group = 
       case self.class_color
       when "黒" ; [1, "好色", "倒錯", "倒錯"]
       end
    # -----------------------------------------------------------------------
    when "Alraune "
      personality_group = 
       case self.class_color
       when "緑" ; [1, "上品", "上品", "甘え性"]
       when "青" ; [1, "意地悪", "意地悪", "意地悪"]
       end
    # -----------------------------------------------------------------------
    when "Matango "
      personality_group = 
       case self.class_color
       when "赤" ; [1, "内気", "上品", "上品"]
       end
    # -----------------------------------------------------------------------
    when "Dark Angel"
      personality_group = 
       case self.class_color
       when "白" ; [1, "意地悪", "柔和", "柔和"]
       end
    # -----------------------------------------------------------------------
    when "Gargoyle"
      personality_group = 
       case self.class_color
       when "黒" ; [1, "高慢", "勝ち気", "勝ち気"]
       end
    # -----------------------------------------------------------------------
    when "Miｍic"
      personality_group = 
       case self.class_color
       when "青" ; [1, "意地悪", "陽気", "陽気"]
       when "黒" ; [1, "不思議", "不思議", "不思議"]
       end
    # -----------------------------------------------------------------------
    when "Taｍaｍo"
      personality_group = 
       case self.class_color
       when "赤" ; [1, "好色", "高慢", "高慢"]
       end
    # -----------------------------------------------------------------------
    when "Liliｍ"
      personality_group = 
       case self.class_color
       when "桃" ; [1, "好色", "意地悪", "意地悪"]
       end
    # -----------------------------------------------------------------------
    when "Unique Succubus ","Unique Tycoon ","Unique Witch"
      case self.class_color
      when "Neijorange"
        personality_group = [1, "暢気", "暢気", "暢気"]
        ability_group += ["胸が性感帯/100"]
      when "Rejeo "
        personality_group = [1, "気丈", "気丈", "気丈"]
        ability_group += ["口が性感帯/100"]
      when "Fulbeua "
        personality_group = [1, "独善", "独善", "独善"]
        ability_group += ["陰核が性感帯/100"]
      when "Gilgoon "
        personality_group = [1, "尊大", "尊大", "尊大"]
        ability_group += ["胸が性感帯/100"]
      when "Yuganaught"
        personality_group = [1, "陰気", "陰気", "陰気"]
        ability_group += ["お尻が性感帯/100"]
      when "Sylphe"
        personality_group = [1, "高貴", "高貴", "高貴"]
        ability_group += ["口が性感帯/100"]
      when "Ramile"
        personality_group = [1, "潔癖", "潔癖", "潔癖"]
        ability_group += ["胸が性感帯/100"]
        ability_group += ["妄執/100"]
      when "Vermiena"
        personality_group = [1, "露悪狂", "露悪狂", "露悪狂"]
        ability_group += ["女陰が性感帯/100"]
      end
    end
    # -----------------------------------------------------------------------
    #  ■ エネミーIDごとに手動設定
    # -----------------------------------------------------------------------
    case self.id
    when 25 # テスト用インプ
      personality_group = [1, "勝ち気", "勝ち気", "勝ち気"]
    when 26 # テスト用ウルフ
      personality_group = [1, "虚勢", "虚勢", "虚勢"]
    when 27 # テスト用キャスト
      personality_group = [1, "内気", "内気", "内気"]
    when 31 # Lv.1 # チュートリアル
      personality_group = [1, "好色", "好色", "好色"]
      ability_group += ["胸が性感帯/100"]
    when 81 # Lv.1 # チュートリアル
      personality_group = [1, "好色", "好色", "好色"]
      ability_group += ["胸が性感帯/100"]
    when 95,139,297 # ライバルサキュバス
      personality_group = [1, "陽気", "陽気", "陽気"]
      ability_group += ["胸が性感帯/100"]
    when 96,140,298 # ライバルデビル
      personality_group = [1, "勝ち気", "勝ち気", "勝ち気"]
      ability_group += ["お尻が性感帯/100"]
    # -----------------------------------------------------------------------
    # ■ＢＯＳＳ
    # -----------------------------------------------------------------------
    when 65 # サキュバス/橙　Lv.18
      personality_group = [1, "陽気", "陽気", "陽気"]
      ability_group += ["胸が性感帯/100"]
    when 66 # デビル/緑　Lv.18
      personality_group = [1, "勝ち気", "勝ち気", "勝ち気"]
      ability_group += ["お尻が性感帯/100"]
    end
    

    
=begin
    # -----------------------------------------------------------------------
    #  ■ エネミーIDごとに手動設定
    # -----------------------------------------------------------------------
    case self.id
    when 1 # テスト用レッサーサキュバス
      personality_group = [0, "好色", "陽気", "意地悪"]
    
    when 9 # テスト用OFEレッサーサキュバス
      personality_group = [1, "好色", "好色", "好色"]
      ability_group += ["吸精/100", "高揚/100", "熟練/100"]
    when 25 # テスト用インプ
      personality_group = [1, "勝ち気", "勝ち気", "勝ち気"]
    when 26 # テスト用サキュバス
      personality_group = [1, "好色", "好色", "好色"]
    when 27 # テスト用キャスト
      personality_group = [1, "内気", "内気", "内気"]
    when 28 # テスト用スライム
      personality_group = [1, "天然", "天然", "天然"]
    # -----------------------------------------------------------------------
    #
    # ■ここから実装■
    #
    # -----------------------------------------------------------------------
      
    # -----------------------------------------------------------------------
    #
    # ■レッサーサキュバス/橙
    # -----------------------------------------------------------------------
    when 31 # Lv.1 # チュートリアル
      personality_group = [1, "好色", "陽気", "陽気"]
      ability_group += ["胸が性感帯/100"]
    when 32 # Lv.1 
      personality_group = [1, "好色", "陽気", "陽気"]
    when 33 # Lv.3
      personality_group = [1, "好色", "陽気", "陽気"]
    when 34 # Lv.6
      personality_group = [1, "好色", "陽気", "陽気"]
    when 35 # Lv.8
      personality_group = [1, "好色", "陽気", "陽気"]
    when 36 # Lv.10
      personality_group = [1, "好色", "陽気", "陽気"]
    # -----------------------------------------------------------------------
    #
    # ■サキュバス/橙
    # -----------------------------------------------------------------------
    when 38 # Lv.10
      personality_group = [1, "好色", "陽気", "陽気"]
    when 39 # Lv.13
      personality_group = [1, "好色", "陽気", "陽気"]
      
    # -----------------------------------------------------------------------
    #
    # ■インプ/緑
    # -----------------------------------------------------------------------
    when 41 # Lv.1
      personality_group = [1, "勝ち気", "虚勢", "虚勢"]
    when 42 # Lv.3
      personality_group = [1, "勝ち気", "虚勢", "虚勢"]
    when 43 # Lv.5
      personality_group = [1, "勝ち気", "虚勢", "虚勢"]
    when 44 # Lv.8
      personality_group = [1, "勝ち気", "虚勢", "虚勢"]
    when 45 # Lv.10
      personality_group = [1, "勝ち気", "虚勢", "虚勢"]

    # -----------------------------------------------------------------------
    #
    # ■キャスト/黄色
    # -----------------------------------------------------------------------
    when 47 # Lv.1
      personality_group = [1, "内気", "従順", "従順"]
    when 48 # Lv.3
      personality_group = [1, "内気", "従順", "従順"]
      
    # -----------------------------------------------------------------------
    #
    # ■ナイトメア/黒
    # -----------------------------------------------------------------------
# ●●「淡白」と「淡泊」が混在していたのでさんずい有りに統一(2014-0819)    
    when 50 # Lv.4
      personality_group = [1, "淡泊", "淡泊", "不思議"]
    when 51 # Lv.6
      personality_group = [1, "淡泊", "淡泊", "不思議"]
    when 52 # Lv.8
      personality_group = [1, "淡泊", "淡泊", "不思議"]
    when 53 # Lv.10
      personality_group = [1, "淡泊", "淡泊", "不思議"]

    # -----------------------------------------------------------------------
    #
    # ■スライム/青
    # -----------------------------------------------------------------------
    when 55 # Lv.2
      personality_group = [1, "天然", "柔和", "柔和"]
    when 56 # Lv.5
      personality_group = [1, "天然", "柔和", "柔和"]

    # -----------------------------------------------------------------------
    #
    # ■プチウィッチ/緑
    # -----------------------------------------------------------------------
    when 58 # Lv.4
      personality_group = [1, "上品", "淡泊", "淡泊"]
    when 59 # Lv.8
      personality_group = [1, "上品", "淡泊", "淡泊"]
    when 60 # Lv.10
      personality_group = [1, "上品", "淡泊", "淡泊"]
      
    # -----------------------------------------------------------------------
    #
    # ■ウィッチ/緑
    # -----------------------------------------------------------------------
    when 62 # Lv.10
      personality_group = [1, "上品", "淡泊", "淡泊"]
    when 63 # Lv.13
      personality_group = [1, "上品", "淡泊", "淡泊"]
      
    # -----------------------------------------------------------------------
    #
    # ■ファミリア/青
    # -----------------------------------------------------------------------
    when 72 # Lv.10
      personality_group = [1, "従順", "淡泊", "淡泊"]
      
    # -----------------------------------------------------------------------
    #
    # ■デビル/緑
    # -----------------------------------------------------------------------
    when 77 # Lv.12
      personality_group = [1, "勝ち気", "虚勢", "虚勢"]

    # -----------------------------------------------------------------------
    #
    # ■ＢＯＳＳ
    # -----------------------------------------------------------------------
     when 65 # サキュバス/橙　Lv.18
      personality_group = [1, "陽気", "陽気", "陽気"] # 実装できるなら柔和
      ability_group += ["胸が性感帯/100"]
     when 66 # デビル/緑　Lv.18
      personality_group = [1, "勝ち気", "勝ち気", "勝ち気"] # 実装できるなら高慢
      ability_group += ["お尻が性感帯/100"]
     when 75 # フルビュア　Lv.25
      personality_group = [1, "独善", "独善", "独善"] # 実装できるなら高慢
      ability_group += ["陰核が性感帯/100"]

    # -----------------------------------------------------------------------
    #
    # ■Ｏ・Ｆ・Ｅ
    # -----------------------------------------------------------------------
    when 68 # レッサーサキュバス/桃　Lv.10
      personality_group = [1, "好色", "好色", "好色"]
    when 69 # レッサーサキュバス/桃　Lv.15
      personality_group = [1, "好色", "好色", "好色"]
    when 70 # サキュバス/桃　Lv.20
      personality_group = [1, "好色", "好色", "好色"]
    when 73 # プチウィッチ/紫　Lv.16
      personality_group = [1, "好色", "好色", "好色"]
    when 74 # ウィッチ/紫　Lv.18
      personality_group = [1, "好色", "好色", "好色"]
    end

    # ---------------------------------------------

=end
    
    # 弱点が入っていなければ弱点素質を入れる
    if not ability_group.include?("口が性感帯/100") \
     and not ability_group.include?("胸が性感帯/100") \
     and not ability_group.include?("お尻が性感帯/100") \
     and not ability_group.include?("陰核が性感帯/100") \
     and not ability_group.include?("女陰が性感帯/100") 
      # 弱点素質の決定
      case rand(4)
      when 0
        ability_group += ["口が性感帯/100"]
      when 1
        ability_group += ["胸が性感帯/100"]
      when 2
        ability_group += ["お尻が性感帯/100"]
      when 3
        ability_group += ["陰核が性感帯/100"]
      end
    end
    
    
    

    # 性格確定
    if personality == ""
      c = rand(10)
      case personality_group[0]
      when 0 # [6 : 3 : 1]
        if c <= 5
          self.personality = personality_group[1]
        elsif c >= 6 and c <= 8
          self.personality = personality_group[2]
        else
          self.personality = personality_group[3]
        end
      when 1 # [5 : 4 : 1]
        if c <= 4
          self.personality = personality_group[1]
        elsif c >= 5 and c <= 8
          self.personality = personality_group[2]
        else
          self.personality = personality_group[3]
        end
      when 2 # [4 : 3 : 3]
        if c <= 3
          self.personality = personality_group[1]
        elsif c >= 4 and c <= 6
          self.personality = personality_group[2]
        else
          self.personality = personality_group[3]
        end
      end
    else
      # 引数がある場合、そのままエネミーの性格にする。
      self.personality = personality
    end
    
    # 素質確定
    if ability == ["未設定"]
      for i in ability_group
        c = rand(100) + 1
        # 文字列の時は確率に沿って習得
        if i.is_a?(String)
          if c <= i.split(/\//)[1].to_i
            n = $data_ability.search(0, i.split(/\//)[0])
            self.gain_ability(n)
          end
        # 数字の時は確定で習得
        else
          self.gain_ability(i)
        end
      end
    else
      # 引数がある場合、そのままエネミーの素質にする。
      for i in ability
        n = i
        n = $data_ability.search(0, i) if i.is_a?(String)
        self.gain_ability(n)
      end
    end

    # 呼称を設定（イベントやボスである場合は除く）
    unless ($data_enemies[@enemy_id].element_ranks[124] == 1 or
     $data_enemies[@enemy_id].element_ranks[126] == 1 or 
     $data_enemies[@enemy_id].element_ranks[128] == 1)
      $msg.defaultname_select(self)
    end
    
    # ついでに初期友好度も確定
    # 初期値30（レベル１で）
    self.friendly = 31
    # これに種族毎の契約難度に合わせて下げる。
    self.friendly -= $data_SDB[self.class_id].contract_level * 3
    # さらにレベルが１上がっている毎に下げる。
    for i in 1..self.level
      self.friendly -= 1
    end
    
  end

end
