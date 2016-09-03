module RPG
  class Class
    attr_accessor :UK_name
    def UK_name
      n = @name.split(/\//)[0]
      return n.translation_check
    end
  end

  class Game_Battler
   attr_accessor :UK_name
   attr_accessor :UK_personality
    def UK_name
      n = @name.split(/\//)[0]
      return n.translation_check
    end
    def UK_personality
      n = @personality
      return n.translation_check
    end
  end
  
  class Game_Actor < Game_Battler
   attr_accessor :UK_name
    def UK_name
      n = self.name.split(/\//)[0]
      return n.translation_check
    end
  end
  
  class Enemy
    attr_accessor :UK_name
    def UK_name
      case @id
      
when 16   #スライム
   return "Slime"
when 25   #インプ
   return "Imp"
when 27   #キャスト
   return "Caster"
when 28   #スライム
   return "Slime"
when 31   #レッサーサキュバス
   return "Lesser Succubus"
when 32   #レッサーサキュバス
   return "Lesser Succubus"
when 33   #レッサーサキュバス
   return "Lesser Succubus"
when 34   #レッサーサキュバス
   return "Lesser Succubus"
when 35   #レッサーサキュバス
   return "Lesser Succubus"
when 36   #レッサーサキュバス
   return "Lesser Succubus"
when 38   #サキュバス
   return "Succubus"
when 39   #サキュバス
   return "Succubus"
when 41   #インプ
   return "Imp"
when 42   #インプ
   return "Imp"
when 43   #インプ
   return "Imp"
when 44   #インプ
   return "Imp"
when 45   #インプ
   return "Imp"
when 47   #キャスト
   return "Caster"
when 48   #キャスト
   return "Caster"
when 50   #ナイトメア
   return "Nightmare"
when 51   #ナイトメア
   return "Nightmare"
when 52   #ナイトメア
   return "Nightmare"
when 53   #ナイトメア
   return "Nightmare"
when 55   #スライム
   return "Slime"
when 56   #スライム
   return "Slime"
when 58   #プチウィッチ
   return "Little Witch"
when 59   #プチウィッチ
   return "Little Witch"
when 60   #プチウィッチ
   return "Little Witch"
when 62   #ウィッチ
   return "Witch"
when 63   #ウィッチ
   return "Witch"
when 65   #サキュバス
   return "Succubus"
when 66   #デビル
   return "Devil"
when 68   #レッサーサキュバス
   return "Lesser Succubus"
when 69   #レッサーサキュバス
   return "Lesser Succubus"
when 70   #サキュバス
   return "Succubus"
when 72   #ファミリア
   return "Familiar"
when 73   #プチウィッチ
   return "Little Witch"
when 74   #ウィッチ
   return "Witch"
when 75   #フルビュア
   return "Fulbeua"
when 77   #デビル
   return "Devil"
when 78   #ワーウルフ
   return "Werewolf"
when 81   #レッサーサキュバス
   return "Lesser Succubus"
when 84   #レッサーサキュバス
   return "Lesser Succubus"
when 85   #インプ
   return "Imp"
when 86   #キャスト
   return "Caster"
when 88   #レッサーサキュバス
   return "Lesser Succubus"
when 91   #レッサーサキュバス
   return "Lesser Succubus"
when 92   #インプ
   return "Imp"
when 93   #ナイトメア
   return "Nightmare"
when 95   #レッサーサキュバス
   return "Lesser Succubus"
when 96   #インプ
   return "Imp"
when 99   #レッサーサキュバス
   return "Lesser Succubus"
when 100   #インプ
   return "Imp"
when 101   #スライム
   return "Slime"
when 104   #レッサーサキュバス
   return "Lesser Succubus"
when 105   #インプ
   return "Imp"
when 106   #ナイトメア
   return "Nightmare"
when 107   #ワーウルフ
   return "Werewolf"
when 110   #レッサーサキュバス
   return "Lesser Succubus"
when 111   #インプ
   return "Imp"
when 112   #ナイトメア
   return "Nightmare"
when 113   #ワーウルフ
   return "Werewolf"
when 115   #ナイトメア
   return "Nightmare"
when 116   #リジェオ
   return "Rejeo"
when 119   #レッサーサキュバス
   return "Lesser Succubus"
when 120   #プリーステス
   return "Priestess"
when 121   #キャスト
   return "Caster"
when 122   #サキュバス
   return "Succubus"
when 123   #プチウィッチ
   return "Little Witch"
when 126   #プチウィッチ
   return "Little Witch"
when 127   #ウィッチ
   return "Witch"
when 128   #レッサーサキュバス
   return "Lesser Succubus"
when 129   #サキュバス
   return "Succubus"
when 130   #インプ
   return "Imp"
when 131   #ファミリア
   return "Familiar"
when 132   #ミミック
   return "Mimic"
when 134   #プチウィッチ
   return "Little Witch"
when 135   #ウィッチ
   return "Witch"
when 136   #レッサーサキュバス
   return "Lesser Succubus"
when 137   #サキュバス
   return "Succubus"
when 139   #サキュバス
   return "Succubus"
when 140   #デビル
   return "Devil"
when 141   #レッサーサキュバス
   return "Lesser Succubus"
when 144   #ゴブリン
   return "Goblin"
when 145   #ギャングコマンダー
   return "Gang Leader"
when 146   #インプ
   return "Imp"
when 147   #デビル
   return "Devil"
when 148   #ナイトメア
   return "Nightmare"
when 149   #ナイトメア
   return "Nightmare"
when 152   #ゴブリン
   return "Goblin"
when 153   #ギャングコマンダー
   return "Gang Leader"
when 154   #インプ
   return "Imp"
when 155   #デビル
   return "Devil"
when 156   #ナイトメア
   return "Nightmare"
when 158   #インプ
   return "Imp"
when 159   #デビル
   return "Devil"
when 162   #サキュバス
   return "Succubus"
when 163   #レッサーサキュバス
   return "Lesser Succubus"
when 164   #アルラウネ
   return "Alraune"
when 165   #マタンゴ
   return "Matango"
when 166   #スライム
   return "Slime"
when 167   #サキュバス
   return "Succubus"
when 170   #サキュバス
   return "Succubus"
when 171   #レッサーサキュバス
   return "Lesser Succubus"
when 172   #アルラウネ
   return "Alraune"
when 173   #マタンゴ
   return "Matango"
when 174   #スライム
   return "Slime"
when 176   #アルラウネ
   return "Alraune"
when 177   #ワーキャット
   return "Werecat"
when 178   #ネイジュレンジ
   return "Neijoronge"
when 181   #プチウィッチ
   return "Little Witch"
when 182   #ウィッチ
   return "Witch"
when 183   #サキュバス
   return "Succubus"
when 184   #レッサーサキュバス
   return "Lesser Succubus"
when 185   #カースメイガス
   return "Cursed Magus"
when 186   #ファミリア
   return "Familiar"
when 187   #スレイヴ
   return "Slave"
when 188   #ミミック
   return "Mimic"
when 189   #プチウィッチ
   return "Little Witch"
when 190   #ウィッチ
   return "Witch"
when 193   #プチウィッチ
   return "Little Witch"
when 194   #ウィッチ
   return "Witch"
when 195   #サキュバス
   return "Succubus"
when 196   #レッサーサキュバス
   return "Lesser Succubus"
when 197   #カースメイガス
   return "Cursed Magus"
when 198   #ファミリア
   return "Familiar"
when 199   #スレイヴ
   return "Slave"
when 200   #ミミック
   return "Mimic"
when 201   #プチウィッチ
   return "Little Witch"
when 202   #ウィッチ
   return "Witch"
when 204   #プチウィッチ
   return "Little Witch"
when 205   #ウィッチ
   return "Witch"
when 206   #レッサーサキュバス
   return "Lesser Succubus"
when 207   #サキュバス
   return "Succubus"
when 208   #ファミリア
   return "Familiar"
when 209   #ゴールドスライム
   return "Gold Slime"
when 212   #シルフェ
   return "Syplhe"
when 215   #インプ
   return "Imp"
when 216   #デビル
   return "Devil"
when 217   #デーモン
   return "Demon"
when 218   #サキュバス
   return "Succubus"
when 219   #レッサーサキュバス
   return "Lesser Succubus"
when 220   #リリム
   return "Lilim"
when 221   #ダークエンジェル
   return "Dark Angel"
when 222   #インプ
   return "Imp"
when 223   #デビル
   return "Devil"
when 226   #インプ
   return "Imp"
when 227   #デビル
   return "Devil"
when 228   #デーモン
   return "Demon"
when 229   #サキュバス
   return "Succubus"
when 230   #レッサーサキュバス
   return "Lesser Succubus"
when 231   #リリム
   return "Lilim"
when 232   #ダークエンジェル
   return "Dark Angel"
when 233   #インプ
   return "Imp"
when 234   #デビル
   return "Devil"
when 236   #デビル
   return "Devil"
when 237   #デーモン
   return "Demon"
when 238   #ワーウルフ
   return "Werewolf"
when 239   #タマモ
   return "Tamano"
when 240   #ユーガノット
   return "Younganoth"
when 243   #レッサーサキュバス
   return "Lesser Succubus"
when 244   #サキュバス
   return "Succubus"
when 245   #サキュバスロード
   return "Succubus Lord"
when 246   #インプ
   return "Imp"
when 247   #デビル
   return "Devil"
when 248   #デーモン
   return "Demon"
when 249   #ガーゴイル
   return "Gargoyle"
when 250   #リリム
   return "Lilim"
when 251   #レッサーサキュバス
   return "Lesser Succubus"
when 252   #サキュバス
   return "Succubus"
when 255   #レッサーサキュバス
   return "Lesser Succubus"
when 256   #サキュバス
   return "Succubus"
when 257   #サキュバスロード
   return "Succubus Lord"
when 258   #インプ
   return "Imp"
when 259   #デビル
   return "Devil"
when 260   #デーモン
   return "Demon"
when 261   #ガーゴイル
   return "Gargoyle"
when 262   #リリム
   return "Lilim"
when 263   #レッサーサキュバス
   return "Lesser Succubus"
when 264   #サキュバス
   return "Succubus"
when 265   #ミミック
   return "Mimic"
when 267   #レッサーサキュバス
   return "Lesser Succubus"
when 268   #サキュバス
   return "Succubus"
when 269   #サキュバスロード
   return "Succubus Lord"
when 270   #ミミック
   return "Mimic"
when 271   #サキュバスロード
   return "Succubus Lord"
when 272   #デーモン
   return "Demon"
when 273   #フルビュア
   return "Fulbeua"
when 274   #ギルゴーン
   return "Gilgoon"
when 277   #レッサーサキュバス
   return "Lesser Succubus"
when 278   #キャスト
   return "Caster"
when 279   #ワーキャット
   return "Werecat"
when 282   #キャスト
   return "Caster"
when 283   #キャスト
   return "Caster"
when 286   #サキュバス
   return "Succubus"
when 287   #サキュバス
   return "Succubus"
when 288   #デビル
   return "Devil"
when 289   #デビル
   return "Devil"
when 290   #ウィッチ
   return "Witch"
when 291   #ウィッチ
   return "Witch"
when 292   #リリム
   return "Lilim"
when 297   #サキュバスロード
   return "Succubus Lord"
when 298   #デーモン
   return "Demon"
when 301   #ラーミル
   return "Rarmil"
when 302   #ヴェルミィーナ
   return "Vermiena"
when 303   #ヴェルミィーナ
   return "Vermiena"
when 304   #ラーミルキャスト
   return "Rarmil Cast"
when 311   #マタンゴ
   return "Matango"
when 312   #レッサーサキュバス
   return "Lesser Succubus"
when 401   #レッサーサキュバス
   return "Lesser Succubus"
when 402   #レッサーサキュバス
   return "Lesser Succubus"
when 403   #サキュバス
   return "Succubus"
when 404   #サキュバス
   return "Succubus"
when 405   #サキュバスロード
   return "Succubus Lord"
when 406   #サキュバスロード
   return "Succubus Lord"
when 407   #インプ
   return "Imp"
when 408   #インプ
   return "Imp"
when 409   #デビル
   return "Devil"
when 410   #デビル
   return "Devil"
when 411   #デーモン
   return "Demon"
when 412   #デーモン
   return "Demon"
when 413   #プチウィッチ
   return "Little Witch"
when 414   #プチウィッチ
   return "Little Witch"
when 415   #ウィッチ
   return "Witch"
when 416   #ウィッチ
   return "Witch"
when 417   #キャスト
   return "Caster"
when 418   #スレイヴ
   return "Slave"
when 419   #ナイトメア
   return "Nightmare"
when 420   #ナイトメア
   return "Nightmare"
when 421   #スライム
   return "Slime"
when 422   #ゴールドスライム
   return "Gold Slime"
when 423   #ファミリア
   return "Familiar"
when 424   #ファミリア
   return "Familiar"
when 425   #ワーウルフ
   return "Werewolf"
when 426   #ワーウルフ
   return "Werewolf"
when 427   #ワーキャット
   return "Werecat"
when 428   #ワーキャット
   return "Werecat"
when 429   #ゴブリン
   return "Goblin"
when 430   #ギャングコマンダー
   return "Gang Leader"
when 431   #プリーステス
   return "Priestess"
when 432   #カースメイガス
   return "Cursed Magus"
when 433   #アルラウネ
   return "Alraune"
when 434   #アルラウネ
   return "Alraune"
when 435   #マタンゴ
   return "Matango"
when 436   #ダークエンジェル
   return "Dark Angel"
when 437   #ガーゴイル
   return "Gargoyle"
when 438   #ミミック
   return "Mimic"
when 439   #ミミック
   return "Mimic"
when 440   #タマモ
   return "Tamano"
when 441   #リリム
   return "Lilim"
when 442   #ネイジュレンジ
   return "Neijoronge"
when 443   #リジェオ
   return "Rejeo"
when 444   #フルビュア
   return "Fulbeua"
when 445   #ギルゴーン
   return "Gilgoon"
when 446   #ユーガノット
   return "Younganoth"
when 447   #シルフェ
   return "Syplhe"
when 448   #ラーミル
   return "Rarmil"
when 449   #ヴェルミィーナ
   return "Vermiena"
when 450   #キャスト
   return "Caster"
   
   #[DATA] enemies
when 1   #データベース
   return "データベース"
when 2   #尻尾持ち
   return "尻尾持ち"
when 3   #チュートリアル
   return "チュートリアル"
when 4   #ボス用基本
   return "ボス用基本"
when 5   #データベース（消極）
   return "データベース（消極）"
when 501   #レッサーサキュバス橙
   return "レッサーサキュバス橙"
when 502   #レッサーサキュバス桃
   return "レッサーサキュバス桃"
when 503   #サキュバス橙
   return "サキュバス橙"
when 504   #サキュバス桃
   return "サキュバス桃"
when 505   #サキュバスロード橙
   return "サキュバスロード橙"
when 506   #サキュバスロード橙
   return "サキュバスロード橙"
when 508   #インプ緑
   return "インプ緑"
when 509   #インプ白
   return "インプ白"
when 510   #デビル緑
   return "デビル緑"
when 511   #デビル白
   return "デビル白"
when 512   #デーモン緑
   return "デーモン緑"
when 513   #デーモン白
   return "デーモン白"
when 515   #プチウィッチ緑
   return "プチウィッチ緑"
when 516   #プチウィッチ紫
   return "プチウィッチ紫"
when 517   #ウィッチ緑
   return "ウィッチ緑"
when 518   #ウィッチ紫
   return "ウィッチ紫"
when 520   #キャスト黄
   return "キャスト黄"
when 522   #スレイヴ紫
   return "スレイヴ紫"
when 524   #ナイトメア黒
   return "ナイトメア黒"
when 525   #ナイトメア黄
   return "ナイトメア黄"
when 527   #スライム青
   return "スライム青"
when 530   #ゴールドスライム黄
   return "ゴールドスライム黄"
when 532   #ファミリア青
   return "ファミリア青"
when 533   #ファミリア緑
   return "ファミリア緑"
when 535   #ワーウルフ黒
   return "ワーウルフ黒"
when 536   #ワーウルフ赤
   return "ワーウルフ赤"
when 538   #ワーキャット黄
   return "ワーキャット黄"
when 539   #ワーキャット黒
   return "ワーキャット黒"
when 541   #ゴブリン赤
   return "ゴブリン赤"
when 543   #ギャングコマンダー赤
   return "ギャングコマンダー赤"
when 546   #プリーステス白
   return "プリーステス白"
when 548   #カースメイガス黒
   return "カースメイガス黒"
when 550   #アルラウネ緑
   return "アルラウネ緑"
when 551   #アルラウネ青
   return "アルラウネ青"
when 553   #マタンゴ赤
   return "マタンゴ赤"
when 555   #ダークエンジェル白
   return "ダークエンジェル白"
when 557   #ガーゴイル黒
   return "ガーゴイル黒"
when 559   #ミミック青
   return "ミミック青"
when 560   #ミミック黒
   return "ミミック黒"
when 562   #タマモ赤
   return "タマモ赤"
when 564   #リリム桃
   return "リリム桃"
when 566   #ネイジュレンジ
   return "Neijoronge"
when 567   #リジェオ
   return "Rejeo"
when 568   #フルビュア
   return "Fulbeua"
when 569   #ギルゴーン
   return "Gilgoon"
when 570   #ユーガノット
   return "Younganoth"
when 571   #シルフェ
   return "Syplhe"
when 572   #ラーミル
   return "Rarmil"
when 573   #ヴェルミィーナ
   return "Vermiena"
when 575   #キャスト黒
   return "キャスト黒"
      
   # [fix] enemies
when 26   #ワーウルフ
   return "Werewolf"
   
   
      end
      text = @name.split(/\//)[0] rescue text = "error: no valid enemy name"
#      text += " *TODO*" if text != nil
      return text
    end
  end
end
