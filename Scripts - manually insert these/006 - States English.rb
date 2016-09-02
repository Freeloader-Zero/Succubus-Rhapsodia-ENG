module RPG
  class State
    attr_accessor :UK_name
    def UK_name
      case @id

when 1   #失神
   return "KO"
when 2   #衰弱
   return "Weak"
when 3,11   #絶頂
   return "Climax"
when 4   #半裸
   return "Half-nude"
when 5   #全裸
   return "Naked"
when 6   #クライシス
   return "Crisis"
when 7   #裸
   return "Nude"
when 8   #挿入
   return "Insert"
when 9   #汁（ぶっか）
   return "Cum(out)"
when 10   #汁（中出し）
   return "Cum(in)"
when 12   #ホールド解除リキャスト
   return "Hold re-cast"
when 13   #ディレイ
   return "Delay"
when 14   #秘所潤滑度↑
   return "Lubricated"
when 15   #空腹
   return "Hungry"
when 16   #スタン
   return "Stun"
when 17   #苦痛スタン
   return "Hurt"
when 19   #ふたなり化
   return "Hermaphrodite"
when 20   #潤滑♂（少）
   return "Lubed♂（-）"
when 21   #潤滑♂（多）
   return "Lubed♂（+）"
when 22   #潤滑♀（少）
   return "Lubed♀（-）"
when 23   #潤滑♀（多）
   return "Lubed♀（+）"
when 24   #潤滑♀（溢）
   return "Lubed♀（++）"
when 25   #潤滑Ａ（少）
   return "LubedＡ（-）"
when 26   #潤滑Ａ（多）
   return "LubedＡ（+）"
when 27   #粘液潤滑（少）
   return "Mucus Lube(-)"
when 28   #粘液潤滑（多）
   return "Mucus Lube(+)"
when 29   #スライム
   return "Slime"
when 30   #淫毒
   return "Aphrodisiac"
when 31   #ローション
   return "Oiled"
when 32   #スタン：ドキドキ
   return "Stun:dokidoki"
when 33   #スタン：びっくり
   return "Stun:off-guard"
when 34   #恍惚
   return "Ecstasy"
when 35   #欲情
   return "Desire"
when 36   #暴走
   return "Rut"
when 37   #虚脱 / collapse
   return "Sapped"
when 38   #畏怖
   return "Soft"
when 39   #麻痺
   return "Paralyzed"
when 40   #散漫
   return "Tipsy"
when 41   #高揚
   return "Merry"
when 42   #沈着
   return "Calm"
when 45   #全身感度アップ
   return "Sensitive"
when 46   #口感度アップ
   return "Mouth sensitive"
when 47   #胸感度アップ
   return "Chest sensitive"
when 48   #尻感度アップ
   return "Ass sensitive"
when 49   #♂感度アップ
   return "♂ sensitive"
when 50   #♀感度アップ
   return "♀ sensitive"
when 55   #魅力+200％
   return "CHR+100%"
when 56   #魅力+150％
   return "CHR+50%"
when 57   #魅力-25％
   return "CHR-25%"
when 58   #魅力-50％
   return "CHR-50%"
when 59   #忍耐+40％
   return "WIL+40%"
when 60   #忍耐+20％
   return "WIL+20%"
when 61   #忍耐-15％
   return "WIL-15%"
when 62   #忍耐-30％
   return "WIL-30%"
when 63   #精力+200％
   return "POW+100%"
when 64   #精力+150％
   return "POWr+50%"
when 65   #精力-25％
   return "POW-25%"
when 66   #精力-50％
   return "POW-50%"
when 67   #器用さ+200％
   return "DEX+100%"
when 68   #器用さ+150％
   return "DEX+50%"
when 69   #器用さ-25％
   return "DEX-25%"
when 70   #器用さ-50％
   return "DEX-50%"
when 71   #素早さ+200％
   return "DEX"
when 72   #素早さ+150％
   return "SPD+50%"
when 73   #素早さ-25％
   return "SPD-25%"
when 74   #素早さ-50％
   return "SPD-50%"
when 75   #精神力+200％
   return "MAG+100%"
when 76   #精神力+150％
   return "MAG+50%"
when 77   #精神力-25％
   return "MAG-25%"
when 78   #精神力-50％
   return "MAG-50%"
when 80   #ステート増加
   return "Stat up"
when 81   #ステート減少
   return "Stat down"
when 82   #ステート全増加
   return "All stats up"
when 83   #ステート全減少
   return "All stats down"
when 84   #ステート維持
   return "Stats neutral"
when 85   #強化ステート解除
   return "Buff locked"
when 86   #弱体ステート解除
   return "Debuff locked"
when 87   #能力変化ステート全解除
   return "Stats locked"
when 89   #満腹度・小回復
   return "Satiated"
when 93   #防御
   return "Defense"
when 94   #堅守
   return "Iron wall"
when 95   #無防備
   return "Begging"
when 96   #誘引
   return "Enticed"
when 97   #キススイッチON
   return "Kiss switch ON"
when 98   #魔法陣
   return "Magic circle"
when 99   #マーキング
   return "Marked"
when 100   #マゾスイッチON
   return "Masochist ON"
when 101   #祝福
   return "Blessed"
when 102   #焦燥
   return "Irritated"
when 103   #専心
   return "Focused"
when 104   #挑発
   return "Provoke"
when 105   #拘束
   return "Restrained"
when 106   #破面
   return "Crazed"
   
      end
      text = @name.split(/\//)[0] rescue text = "error: no valid state name"
#      text += " *TODO*" if text != nil
      return text
    end
  end
end

