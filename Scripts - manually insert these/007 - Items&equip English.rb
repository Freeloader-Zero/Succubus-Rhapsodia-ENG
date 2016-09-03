module RPG
  class Item
    attr_accessor :UK_name
    attr_accessor :UK_description
    def UK_name
      text = item_engbase(@id)[0]
      return text
    end
    def UK_description
      text = item_engbase(@id)[1]
      return text
    end

  end
end

def item_engbase(id)
    result = ["TODO","none yet"]
  case id
  when 1   #デバッグアイテム
    #色々デバッグできるぞ！
   result[0] = "Debug tool"
   result[1] = "Debug many things!"
when 2   #実験室の鍵
    #オープニング用
   result[0] = "Laboratory key"
   result[1] = "Opens a door"
when 3   #滞在機の鍵
    #滞在機の操作をするための鍵。
   result[0] = "滞在機の鍵"
   result[1] = "滞在機の操作をするための鍵。"
when 4   #古印破棄の執行書
    #旧式のルーンを破棄する儀式の執行書。
   result[0] = "Seal-breaking ritual"
   result[1] = "An ancient spell to dispell powerful seals"
when 5   #盟約式の執行書
    #盟約の契りを交わす儀式の執行書。
   result[0] = "Covenant application"
   result[1] = "Describes how to exchange a vow of convenant"
when 19   #プレシャスリング
    #盟約の契りを結ぶために必要な指輪。非装備品。
   result[0] = "Precious ring"
   result[1] = "May be used to seal a pledge of covenant"
when 21   #ハーブティ
    #[茶] ＥＰが小回復する。乾燥したハーブを煮出して飲用としたお茶。
   result[0] = "Herb tea"
   result[1] = "『Tea』 Recover 50EP."
when 22   #アールグレイ
    #[茶] ＥＰが中回復する。ベルガモットの独特の甘い香りがする着香茶。
   result[0] = "Earl grey"
   result[1] = "『Tea』 Recover 200EP."
when 23   #アピトーユブレンド
    #[茶] ＥＰが大回復する。香りが良く飲みやすいが、深みがある茶。
   result[0] = "Happy Toru blend"
   result[1] = "『Tea』 Recover 600EP."
when 24   #ロイヤルナイトティ
    #[茶] ＥＰが全回復する。濃厚で甘美な味わいの夢世界産ミルクティ。
   result[0] = "Royal Night tea"
   result[1] = "『Tea』 Recover all EP."
when 26   #レモンピール
    #[菓] ＥＰが小回復する。菓子は戦闘中でも使用できる。
   result[0] = "Lemon peel"
   result[1] = "『Candy』 Recover 100EP."
when 27   #ドライアプリコット
    #[菓] ＥＰが中回復する。干すことで甘みが凝縮されたアプリコット。
   result[0] = "Dried Apricots"
   result[1] = "『Candy』 Recover 300EP."
when 28   #フルーツタルト
    #[菓] ＥＰが大回復する。上品な味わいで人気な一口サイズのタルト。
   result[0] = "Fruitcake"
   result[1] = "『Candy』 Recover 1000EP."
when 30   #ウェイクアップ
    #仲間を完全回復させる妙薬。失神した仲間にも効果がある。
   result[0] = "Wake-me-up"
   result[1] = "Restores all VP. Can be used on fainted allies."
when 34   #ミルクキノコ
    #夢魔の満腹度が少し満たされる。舐め続けていると傘から白い液体が出る茸。
   result[0] = "Milky Mushroom"
   result[1] = "A little filling. Must be licked a lot for milk to come out."
when 35   #クリハナッツ
    #夢魔の満腹度がそこそこ満たされる。非常に癖のある臭いのする木の実。
   result[0] = "Gonad nuts"
   result[1] = "Filling. Full of nutrients, despite the particular smell."
when 36   #一番搾り
    #夢魔の満腹度が完全に満たされる。人間が飲むには濃すぎる味わいの牛乳。
   result[0] = "Full squeeze"
   result[1] = "Very filling. Most humans cannot bear that much."
when 37   #レモンピール
    #[菓] ＥＰが小回復する。菓子は戦闘中でも使用できる。
   result[0] = "Lemon ale"
   result[1] = "『Candy』 Recover 200EP."
when 49   #ネクストステア
    #レベルを１上げる。
   result[0] = "Next step"
   result[1] = "Raises level by 1"
when 51   #小さなポピー
    #[贈] 相手１人の契約確率を少し上げる。小さく愛らしいポピーの花。
   result[0] = "Poppy flower"
   result[1] = "『Gift』 The recipient will like you a bit more."
when 52   #鮮やかな花冠
    #[贈] 相手１人の契約確率を上げる。色どり鮮やかな花の冠。
   result[0] = "Vivid corolla"
   result[1] = "『Gift』 The recipient will like you better."
when 53   #ロマンスブーケ
    #[贈] 相手１人の契約確率を大きく上げる。女性を魅了する花束。
   result[0] = "Bouquet romantique"
   result[1] = "『Gift』 The recipient will like you a lot."
when 71   #風の翼
    #ホームへ戻る。
   result[0] = "Bird wing"
   result[1] = "Sends you back home."
when 151   #粗末な食材
    #[材] お粗末な食材。調理すればマシになる。
   result[0] = "Frugal ingredients"
   result[1] = "『Harvest』 Can be cooked into an acceptable dish."
when 152   #普通の食材
    #[材] 普通の食材。調理すればそこそこ良くはなる。
   result[0] = "Common ingredients"
   result[1] = "『Harvest』 Can be cooked into a decent meal."
when 153   #最高の食材
    #[材] 最高の食材。調理すればその味は引き出される。
   result[0] = "Luxurious ingredients"
   result[1] = "『Harvest』 The best for the best cook."
when 161,210   #マイルドハニー
    #[添] 蜜蜂の作る蜜。料理に入れると味がマイルドになる。
   result[0] = "Sweet honey"
   result[1] = "『Ingredient』 Often used to sweeten dishes."
when 162   #発熱ジンジャー
    #[添] 体を内側から温めるジンジャー。風邪に効く。
   result[0] = "Pungent ginger"
   result[1] = "『Ingredient』 Woody, warm flavor. Great for colds."
when 163   #鮮やかな苺
    #[添] 鮮やかな苺。このまま食べるより料理の飾り付けにしたい。
   result[0] = "Shiny strawberry"
   result[1] = "『Ingredient』 Always an appreciated garnish."
when 164   #渋いクルミ
    #[添] そのまま食べるには渋すぎるクルミ。
   result[0] = "Bitter walnut"
   result[1] = "『Ingredient』 Too bitter to eat as is."
when 165   #スパイシーペッパー
    #[添] ピリっとくる辛さの黒胡椒。
   result[0] = "Spicy pepper"
   result[1] = "『Ingredient』 Pili-pili spiciness."
when 166   #スイートマロン
    #[添] 甘みのある栗の実なのだが、剥くのが少々手間。
   result[0] = "Sweet marron"
   result[1] = "『Ingredient』 A sweeter kind of chestnut."
when 167   #爽やかなレモン
    #[添] フレッシュな酸味がほとばしる瑞々しいレモン。
   result[0] = "Fresh lemon"
   result[1] = "『Ingredient』 As fresh as it is acid."
when 168   #ビターナッツ
    #[添] 頭の冴える苦目なナッツ。魔女の徹夜のお供。
   result[0] = "Bitter nuts"
   result[1] = "『Ingredient』 Guaranteed to rouse your taste buds."
when 169,214   #禍々しい根っこ
    #[添] 生命力溢れる根っこ。魔女の釜の常連。
   result[0] = "Ominous root"
   result[1] = "『Ingredient』 Lively roots. Great for witchcraft too."
when 181   #魔女の鍵
    #パルフィスの魔女たちが使用する鍵。
   result[0] = "Witch's key"
   result[1] = "Used by Pelfrey monestary witches."
when 182   #赫唐辛子
    #炎のような辛さが味わえる赤々とした唐辛子。人間用ではない。
   result[0] = "Sparkly pepper"
   result[1] = "Way too spicy for humans to handle."
when 183   #回廊の鍵
    #パルフィス密教会の回廊の鍵。
   result[0] = "Corridor key"
   result[1] = "A key used somewhere in Pelfrey monastery."
when 199   #忘却の古印
    #記憶の一部を封じる旧式のルーン。破棄が困難で、安易に使えるものではない。
   result[0] = "Forgotten mark"
   result[1] = "Part of an old, long-forgotten seal."
when 201   #白い羽
    #鳥から抜け落ちたであろう白い羽。
   result[0] = "White feather"
   result[1] = "The bird will miss them."
when 202   #大葉
    #それなりに大きい葉っぱ。
   result[0] = "Big leaf"
   result[1] = "Larger than a small leaf."
when 203   #毒林檎
    #多分。
   result[0] = "Poison apple"
   result[1] = "Why not?"
when 205   #質のいい岩石
    #良い感じに塊として採取できた岩石。
   result[0] = "Good rock"
   result[1] = "Definitely better than the other rocks."
when 206   #骨
    #そこそこ太い。何の骨かは不明。
   result[0] = "Bone"
   result[1] = "Quite large. Origins unknown."
when 207   #石英
    #綺麗な石英。
   result[0] = "Quartz"
   result[1] = "Regular quartz."
when 208   #彩色石英
    #色鮮やかな石英。
   result[0] = "Colored quartz."
   result[1] = "Quartz. With a color."
when 211   #ヘルペッパー
    #地獄のような辛さが味わえる香辛料。人間用ではない。
   result[0] = "Hell pepper"
   result[1] = "Spicy like hell. Not meant for humans."
when 213   #青い羽
    #鳥から採取したであろう青い羽。
   result[0] = "Blue feather"
   result[1] = "Like a feather, but blue."
when 215   #魔法石
    #魔力を湧出する石。杖のような魔道具に使用される。
   result[0] = "Magic stone"
   result[1] = "Often used to craft wands."
when 217   #蜘蛛の糸
    #丈夫な蜘蛛の糸。
   result[0] = "Spider silk"
   result[1] = "A strong, durable silk"
when 218   #錆びた手斧
    #手入れされておらず錆びてしまった手斧。切れ味にはもう期待できない。
   result[0] = "Rusty axe"
   result[1] = "Too rusted to be of any use."
when 219   #真紅の石
    #赤色の顔料に使われる石。
   result[0] = "Crimson stone"
   result[1] = "Can be ground into a red pigment."
when 220   #不発ダイナマイト
    #火は着くのだが爆発しないダイナマイト。
   result[0] = "Undetonated TNT"
   result[1] = "The fuse is lit, though."
when 222   #溶岩エビ
    #溶岩に住むエビ。かなり小さくとても苦くて辛いため、食用としては微妙。
   result[0] = "Lava shrimp"
   result[1] = "Small creature living in lava. Spicy."
when 223   #凶悪な頭蓋骨
    #生前はさぞかし凶悪人だったのだろう。
   result[0] = "Hateful skull"
   result[1] = "It really feels like it hates you."
when 224   #精神焦がし
    #この火で焼かれると思考が焼け焦げると言われる地獄の炎。
   result[0] = "Soaring spirit"
   result[1] = "There's still a bit left after going through hellfire."
when 225   #プチ悪魔
    #採取程度で入手できるほど弱小な悪魔。
   result[0] = "Petit devil"
   result[1] = "A small, weak demon. Collectible."
when 226   #捨てられた思い出
    #人が捨てたと思っていても、それはどこかでずっと残るものである。
   result[0] = "Lost memories"
   result[1] = "Someone lost them, now they've been found."
when 228   #樹海ローズマリー
    #薬用に使われる樹海産のハーブ。普通のものとは違い非食用。
   result[0] = "Yukai rosemary"
   result[1] = "Harvested by yukai for medicine. Probably not edible."
when 229   #彷徨える亡霊
    #採取中にまとわりついた亡霊。害は無い。
   result[0] = "Wandering ghost"
   result[1] = "It keeps wandering, even in the bag."
when 230   #冒険者の装備
    #片方だけしかない篭手。どのみち夢魔相手では不器用になるだけである。
   result[0] = "Adventurer gloves"
   result[1] = "They always lose the same one."
when 231   #ひよこの餌
    #カブト虫。本来はもっとすごいものが好まれる。
   result[0] = "Poultry food"
   result[1] = "A beetle. Who probably had greater ambitions."
when 233   #星の砂
    #星形の砂。
   result[0] = "Sandflower"
   result[1] = "Flower-shaped sand."
when 234   #安物の杖
    #廃棄物らしいので持って行って構わないだろう。
   result[0] = "Cheap rod"
   result[1] = "Looks cheap. Feels cheaper."
when 235   #魔獣の心臓
    #今にも動き出しそうな、迫力のある心臓。
   result[0] = "Beast heart"
   result[1] = "It's not beating anymore. Or is it?"
when 236   #魔力片
    #魔力を大量に湧出する破片。大型の魔法機などに使われる。
   result[0] = "Magic shard"
   result[1] = "A piece of magic. Maybe part of a whole."
when 237   #破滅の元
    #危険なもの。
   result[0] = "Bane of Origins"
   result[1] = "Dangerous!"
when 239   #壊れた罠
    #もう使いものにならない罠。
   result[0] = "Broken trap"
   result[1] = "Definitely useless."
when 240   #丈夫な荒縄
    #人1人を吊り上げても千切れなさそうな荒縄。
   result[0] = "Sturdy Aranawa"
   result[1] = "One who can lift a thousand Aranawas, can lift one."
when 241   #夢色香水
    #思考が混濁してしまう、不思議な色の香水。
   result[0] = "Dreamy perfume"
   result[1] = "So subtle, you might just have imagined it."
when 242   #強そうな武器
    #名の知れた剣士の相棒だっただろう武器。夢魔相手じゃ無用の長物。
   result[0] = "Powerful weapon"
   result[1] = "A mighty weapon. Not so much against inmas, though."
when 243   #サキュバスの服
    #夢魔の脱ぎ捨てた際どい意匠の服。
   result[0] = "Succubus clothes"
   result[1] = "Designed for swift take-off."
when 245   #小さな隣人
    #どうやら迷子になっている妖精。
   result[0] = "Tiny friend"
   result[1] = "So, apparently, a fairy got lost."
when 296   #夢魔の像
    #教会に保管されているには扇情的すぎる夢魔の像。
   result[0] = "Inma bust"
   result[1] = "Makes one wonder, why it was in a church."
when 297   #天使の像
    #教会に祀られた天使の像。足元が欠けており、置くと少し傾く。
   result[0] = "Angel figure"
   result[1] = "A statue of an angel. Its feet are missing, it cannot stand."
when 298   #ラプソディアコイン
    #夢世界の記念硬貨。
   result[0] = "Rhapsodia coin"
   result[1] = "A collectible coin in the dream world."
when 301   #真夜の華
    #夢魔の好む、闇夜に映える妖艶な紫色の華。
   result[0] = "Nightbloom"
   result[1] = "A flower that shines in the dark."
when 302   #魔獣の牙
    #悪魔の持つ装飾品に使われる、凶暴そうな獣の牙。
   result[0] = "Beast fang"
   result[1] = "Very popular in accesory crafting."
when 303   #見知った銀貨
    #現実世界で使われる銀貨。夢世界では価値がない。
   result[0] = "Silver coin"
   result[1] = "Would be worth much in the real world. But not here."
when 304   #恐怖溜まり
    #ナイトメアの集めた恐怖心が溜まったもの。
   result[0] = "Lump of fear"
   result[1] = "Harvested in any good nightmare."
when 305   #ぷるぷるした粘液
    #スライムの一部であった流動体の液体。
   result[0] = "Puripuri mucus"
   result[1] = "Actually part of a slime's body."
when 306   #怪しい調合液
    #魔女の作った試験品。時々派手な音を立てて泡立つ。
   result[0] = "Dubious concoction"
   result[1] = "Some witch made this. Bubbling and shaking."
when 307   #使い魔の箒
    #空を飛ぶものではなく、掃除をするためのもの。
   result[0] = "Familiar broom"
   result[1] = "Actually used for cleaning. Not for flying."
when 308   #肉球スタンプ
    #押すとぷにっとした手応えがある。
   result[0] = "Squishy paw"
   result[1] = "It's begging to be squished."
when 309   #獣の角
    #ゴブリンが仕留めた獣の角。それなりに重い。
   result[0] = "Beast horn"
   result[1] = "Probably from something a goblin killed. Heavy."
when 310   #ダイヤモンド
    #光が内部で幾つも反射しあい、様々な輝きを見せる美しい宝石。
   result[0] = "Diamond"
   result[1] = "Very shiny when exposed to sunlight."
when 311   #石像の鱗
    #石像から剥がれたとても固い鱗。
   result[0] = "Stone scale"
   result[1] = "Came off a statue. Really hard."
when 312   #金の粘液
    #ゴールドスライムの一部であった流動体の金の液体。
   result[0] = "Golden mucus"
   result[1] = "Liquid gold. And part of a slime."
when 313   #雅の扇
    #見たことがない異国情緒を思わせる扇。
   result[0] = "Miyabi fan"
   result[1] = "Feels very exotic. "
when 314   #小さな悪魔像
    #手のひらサイズの小さな悪魔像。力を持っているが、弱々しい。
   result[0] = "Devil figure"
   result[1] = "Palm-sized replica of a huge devil."
         
    end
  return result
end

module RPG
  class Armor
    attr_accessor :UK_name
    def UK_name
#      case @id


   
#      end

      text = @name.split(/\//)[0] rescue text = "error: no valid armor name"
#      text += " *TODO*" if text != nil
      return text
    end
  end
end

module RPG
  class Weapon
    attr_accessor :UK_name
    def UK_name
      return @name.split(/\//)[0] rescue text = "error: no weapon here anyway"
    end
  end
end

module RPG
  class Armor
    attr_accessor :UK_name
    def UK_name
#      case @id


   
#      end

      text = @name.split(/\//)[0] rescue text = "error: no valid armor name"
#      text += " *TODO*" if text != nil
      return text
    end
  end
end

module RPG
  class Weapon
    attr_accessor :UK_name
    def UK_name
      return @name.split(/\//)[0] rescue text = "error: no weapon here anyway"
    end
  end
end
