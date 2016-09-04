#==============================================================================
# ■ RPG::Class
#------------------------------------------------------------------------------
# 　名称の判別用。
#==============================================================================
module RPG
  class Class
    #--------------------------------------------------------------------------
    # ● 習得スキル
    #--------------------------------------------------------------------------
    def learnings
      #------------------------------------------------------------------------
      # ■■　概要
      #  習得レベル, タイプ, ID]      #  タイプ：0:スキル, 1:素質
      #  「◆」が付いているものはカラー独自で習得する特殊なもの。
      #------------------------------------------------------------------------
      # 初期スキル
      group = [
      [1, 0, 2],    # Lv1.服を脱がす
      [1, 0, 4],    # Lv1.服を脱ぐ
      [1, 0, 81],   # Lv1.キッス
      [1, 0, 82],   # Lv1.バスト
      [1, 0, 83],   # Lv1.ヒップ
      [1, 0, 84],   # Lv1.クロッチ
      [1, 0, 121],   # Lv1.ブレス
      [1, 0, 123],   # Lv1.ウェイト
      ]
      # クラスIDから男女用初期スキルを追加
      case @id
      when 2 # 主人公
        group += [
        [1, 1, 0],    # Lv1.【男】
        [1, 0, 9],    # Lv1.トーク
        [1, 0, 6],    # Lv1.インサート
#        [1, 0, 32]    # Lv1.スウィング      
        ]
      else
        group += [
        [1, 1, 1],    # Lv1.【女】
        [1, 0, 5],   # Lv1.シェルマッチ
#        [1, 0, 52],   # Lv1.スクラッチ
        [1, 1, 302],    # Lv1.【アクセプト】
        ]
      end
      # クラスIDから個別習得スキルを追加
      case name
      #------------------------------------------------------------------------
      # ■■人間
      #------------------------------------------------------------------------
      when "人間" # 主人公
        # Lv1.【一心】
        group.push([1, 1, 113])
        # Lv2. チェック
        group.push([2, 0, 126])  
        # Lv4.ガード
        group.push([4, 0, 145])  
        # Lv7.【手際よい採取】
        group.push([7, 1, 240]) unless $PRODUCT_VERSION 
        # Lv7.ディバウアー
        group.push([7, 0, 106]) if $PRODUCT_VERSION
        # Lv10.ヘヴィスウィング
        group.push([10, 0, 33])
        # Lv13 .【回復力】
        group.push([13, 1, 212])  
        # Lv16.リフレッシュ
        group.push([16, 0, 125]) 
        # Lv20.焦燥
        group.push([20, 0, 599]) 
        # Lv20.専心
        group.push([20, 0, 600])
        # Lv24.【無我夢中】
        group.push([24, 1, 150])
        # Lv24.【生命力】
        group.push([24, 1, 213]) 
        # Lv24.プライスオブハレム
        group.push([24, 0, 362])
        # Lv28.カームブレス
        group.push([28, 0, 122])
        # Lv33.【超暴走】
        group.push([33, 1, 154]) 
        # Lv37.【対抗心】
        group.push([37, 1, 151])
        # Lv42.【カリスマ】
        group.push([42, 1, 73]) 
        # Lv47.【胆力】
        group.push([47, 1, 110]) 
      #------------------------------------------------------------------------
      # ■■サキュバス種
      #------------------------------------------------------------------------
      when "レッサーサキュバス","サキュバス","サキュバスロード"
        # Lv1.ツーパフ
        group.push([1, 0, 91])   
        # Lv1.【高揚】(桃)
        group.push([1, 1, 120]) if self.color == "桃" 
        # Lv4.ティーズ
        group.push([4, 0, 101])  
        # Lv8.エキサイトビュー
        group.push([8, 0, 18])   
        # Lv12.【吸精】
        group.push([12, 1, 70])  
        # Lv12.ランクアップ（レッサーサキュバス）
        group.push([12, 0, 249]) if self.name == "レッサーサキュバス"
        # Lv15.ラナンブルム
        group.push([15, 0, 171]) 
        # Lv15.ドロウネクター
        group.push([15, 0, 16])  if $PRODUCT_VERSION 
        # Lv15.【ペリスコープ】
        group.push([15, 1, 307]) if $PRODUCT_VERSION 
        # Lv20.イリスシード（橙）
        group.push([20, 0, 161]) if self.color == "橙" 
        # Lv24.スイートウィスパー
        group.push([24, 0, 418])
        # Lv30.テンプテーション
        group.push([30, 0, 140]) 
        # Lv34.【熟練】
        group.push([34, 1, 124]) 
        # Lv34.ランクアップ（サキュバス）
        group.push([34, 0, 249]) if self.name == "サキュバス" 
      #------------------------------------------------------------------------
      # ■■デビル種
      #------------------------------------------------------------------------
      when "インプ","デビル","デーモン"
        # Lv1.ネリネイーザ
        group.push([1, 0, 177])  
        # Lv6.テラー
        group.push([6, 0, 208])  
        # Lv9.エキサイトビュー
        group.push([9, 0, 18])  
        # Lv12.コリオイーザ
        group.push([12, 0, 189]) 
        # Lv12.ランクアップ（インプ）
        group.push([12, 0, 249]) if self.name == "インプ" 
        # Lv16.サフライーザ
        group.push([16, 0, 185]) 
        # Lv18.【胆力】（デビル以降）
        group.push([18, 1, 110]) if self.name == "デビル" or self.name == "デーモン"
        # Lv20.【回復力】
        group.push([20, 1, 212]) 
        # Lv23.ドロウネクター
        group.push([26, 0, 16])  if $PRODUCT_VERSION 
        # Lv23.【ペリスコープ】（デビル以降）
        group.push([26, 1, 307]) if $PRODUCT_VERSION and (self.name == "デビル" or self.name == "デーモン") 
        # Lv27.威迫（デビル以降）
        group.push([27, 0, 620]) if self.name == "デビル" or self.name == "デーモン"
        # Lv30.【溢れる回復力】（緑）
        group.push([30, 1, 213]) if self.color == "緑" 
        # Lv30.コリオイーザ・アルダ（白）
        group.push([30, 0, 190]) if self.color == "白"
        # Lv34.ランクアップ（デビル）
        group.push([34, 0, 249]) if self.name == "デビル"
        # Lv34.【対抗心】
        group.push([34, 1, 151])  
        # Lv37.アスタイーザ・アルダ
        group.push([37, 0, 194]) 
      #------------------------------------------------------------------------
      # ■■ウィッチ種
      #------------------------------------------------------------------------
      when "プチウィッチ","ウィッチ"
        # Lv1.チェック
        group.push([1, 0, 126])
        # Lv1.【手際良い採取】（緑）
        group.push([1, 1, 240]) if self.color == "緑"
        # Lv1.【キススイッチ】(紫)
#        group.push([1, 1, 160]) if self.color == "紫" and $DEBUG
        # Lv2.イリスシード
        group.push([2, 0, 161]) 
        # Lv5.ラナンブルム
        group.push([5, 0, 171]) 
        # Lv8.アスタブルム
        group.push([8, 0, 191]) 
        # Lv10.イーザカール
        group.push([10, 0, 221]) 
        # Lv12.【蒐集】（緑）
        group.push([12, 1, 221]) if self.color == "緑" 
        # Lv12.サフラブルム・アルダ（紫）
        group.push([12, 0, 184]) if self.color == "紫" 
        # Lv12.ランクアップ（プチウィッチ）
        group.push([12, 0, 249]) if self.name == "プチウィッチ"
        # Lv14.パラライズ
        group.push([14, 0, 210]) 
        # Lv17.エルダブルム
        group.push([17, 0, 179]) 
        # Lv20.イリスペタル
        group.push([20, 0, 162]) 
        # Lv25.イリスシード・アルダ（緑）
        group.push([25, 0, 165]) if self.color == "緑"
        # Lv25.コリオブルム・アルダ（紫）
        group.push([25, 0, 188]) if self.color == "紫" 
        # Lv30.セットサークル
        group.push([30, 0, 359])
        # Lv30.【洞察力】（緑）
        group.push([30, 1, 130]) if self.color == "緑" 
        # Lv30.エルダブルム・アルダ（紫）
        group.push([30, 0, 180]) if self.color == "紫" 
        # Lv36.ラナンブルム・アルダ
        group.push([36, 0, 172]) 
        # Lv40.リチュアルサークル
#未        group.push([40, 0, 126]) 
      #------------------------------------------------------------------------
      # ■■キャスト種
      #------------------------------------------------------------------------
      when "キャスト"
        # Lv1.【サンチェック】
        group.push([1, 1, 134]) if self.color == "黒" 
        # Lv1.【手際良い採取】
        group.push([1, 1, 240])
        # Lv1.【ＥＰヒーリング】
        group.push([1, 1, 210]) 
        # Lv5.ネリネブルム
        group.push([5, 0, 175]) 
        # Lv8.【目聡い採取】
        group.push([8, 1, 241]) 
        # Lv10.チェック
        group.push([10, 0, 126]) 
        # Lv14.イリスシード
        group.push([14, 0, 161]) 
        # Lv19.【ＶＰヒーリング】
        group.push([19, 1, 211]) 
        # Lv23.イーザカール
        group.push([23, 0, 221]) 
        # Lv30.リラックスタイム
        group.push([30, 0, 611]) 
        # Lv40.アナライズ
        group.push([40, 0, 127])     
        # Lv50.ネリネブルム・アルダ
        group.push([50, 0, 176]) 
      #------------------------------------------------------------------------
      # ■■スレイヴ種
      #------------------------------------------------------------------------
      when "スレイヴ"
        # ☆シェルマッチ、スクラッチ、【アクセプト】は習得しない
        group.delete([1, 0, 5])
        group.delete([1, 0, 52])
        group.delete([1, 1, 302])
        # Lv1.【焦欲】
        group.push([1, 1, 126])
        # Lv1.ガード
        group.push([4, 0, 145])
        # Lv1.【警戒の備え】
        group.push([1, 1, 228])
        # Lv1.【ＥＰヒーリング】
        group.push([1, 1, 210]) 
        # Lv20.【ＶＰヒーリング】
        group.push([19, 1, 211]) 
        # Lv30.インデュア
        group.push([30, 0, 146])
        # Lv30.アピール
        group.push([30, 0, 148])
      #------------------------------------------------------------------------
      # ■■ナイトメア種
      #------------------------------------------------------------------------
      when "ナイトメア"
        # Lv1.テラー
        group.push([1, 0, 208])
        # Lv1.【胆力】
        group.push([1, 1, 110])
        # Lv3.アスタイーザ
        group.push([3, 0, 193])
        # Lv6.パラライズ
        group.push([6, 0, 210])
        # Lv10.ブルムカール
        group.push([10, 0, 219])
        # Lv13.トリムルート
        group.push([13, 0, 215])
        # Lv16.レザラジィ（黒）
        group.push([16, 0, 206]) if self.color == "黒"
        # Lv16.魔性の口付け（黄）
        group.push([16, 0, 416]) if self.color == "黄"
        # Lv20.ルーズ
        group.push([20, 0, 212])
        # Lv24.サディストカレス
        group.push([34, 0, 361])
        # Lv24.戦慄き
#未        group.push([24, 0, 127])
        # Lv30.ペイド・テラー
        group.push([30, 0, 209])
        # Lv34.ペイド・レザラジィ（黒）
        group.push([34, 0, 207]) if self.color == "黒"
        # Lv34.【バッドチェイン】（黄）
        group.push([34, 1, 136]) if self.color == "黄"
        # Lv38.ペイド・ルーズ
        group.push([38, 0, 213])
      #------------------------------------------------------------------------
      # ■■スライム種
      #------------------------------------------------------------------------
      when "スライム","ゴールドスライム"
        # Lv1.【柔軟】
        group.push([1, 1, 112])
        # Lv1.【粘体】
        group.push([1, 1, 114])
        # Lv1.【プロテクション】
        group.push([1, 1, 115]) if self.name == "ゴールドスライム"
        # Lv1.【金運】
        group.push([1, 1, 222]) if self.name == "ゴールドスライム"
        # Lv3.スライミーリキッド
        group.push([3, 0, 587])
        # Lv7.ツーパフ
        group.push([7, 0, 91])
        # Lv7.レストレーション
        group.push([7, 0, 586])
        # Lv10.コールドタッチ
        group.push([10, 0, 360])
        # Lv13.【回復力】
        group.push([13, 1, 212]) if self.name == "スライム"
        # Lv16.エンブレイス
        group.push([16, 0, 17])
        # Lv20.リフレッシュ
        group.push([20, 0, 125])
        # Lv23.ドロウネクター
        group.push([25, 0, 16])
        # Lv23.【ペリスコープ】
        group.push([25, 1, 307])
        # Lv27.アピール
        group.push([27, 0, 148])
        # Lv30.スライムフィールド
        group.push([30, 0, 626])
        # Lv36.カームブレス
        group.push([36, 0, 122]) if self.name == "スライム"
      #------------------------------------------------------------------------
      # ■■ファミリア種
      #------------------------------------------------------------------------
      when "ファミリア"
        # Lv1.【手際良い採取】（青）
        group.push([1, 1, 240]) if self.color == "青"
        # Lv1.ディルドインサート（緑）
        group.push([1, 0, 20]) if self.color == "緑"
        # Lv1.ディルドインマウス（緑）
        group.push([1, 0, 21]) if self.color == "緑"
        # Lv3.【目聡い採取】（青）
        group.push([3, 1, 241]) if self.color == "青"
        # Lv3.【高揚】（緑）
        group.push([3, 1, 120]) if self.color == "緑"
        # Lv4.チェック
        group.push([4, 0, 126])
        # Lv4.クッキング（青）
        group.push([4, 0, 241]) if self.color == "青"
        # Lv8.コリオイーザ
        group.push([8, 0, 189])
        # Lv10.エルダブルム
        group.push([10, 0, 179])
        # Lv14.【蒐集】（青）
        group.push([14, 1, 221]) if self.color == "青"
        # Lv14.パッションビート
        group.push([14, 0, 613]) if self.color == "緑"   
        # Lv18.トリムストーク
        group.push([18, 0, 216])
        # Lv20.【調理知識】（青）
        group.push([20, 1, 104]) if self.color == "青"
        # Lv20.エンブレイス
        group.push([20, 0, 17])
        # Lv24.専心
        group.push([24, 0, 600]) if self.color == "青"
        # Lv24.焦燥
        group.push([24, 0, 599]) if self.color == "緑"
        # Lv28.【一心】（青）
        group.push([28, 1, 113]) if self.color == "青"
        # Lv28.【胆力】（緑）
        group.push([28, 1, 120]) if self.color == "緑"
        # Lv36.【平静】（青）
        group.push([36, 1, 108]) if self.color == "青"
        # Lv36.【熟練】（緑）
        group.push([36, 1, 124]) if self.color == "緑"
      #------------------------------------------------------------------------
      # ■■ワーウルフ種
      #------------------------------------------------------------------------
      when "ワーウルフ"
        # Lv1.ハウリング
        group.push([1, 0, 415])
        # Lv1.【目聡い採取】（黒）
        group.push([1, 1, 240]) if self.color == "黒"
        # Lv1.【超暴走】（赤）
        group.push([4, 1, 154]) if self.color == "赤"
        # Lv3 エキサイトビュー
        group.push([3, 0, 18])
        # Lv6.【回復力】
        group.push([6, 1, 212])
        # Lv9.【ダウト】
        group.push([9, 1, 226])
        # Lv12.本能の呼び覚まし
        group.push([12, 0, 601])
        # Lv14.ドロウネクター
        group.push([16, 0, 16]) if $PRODUCT_VERSION
        # Lv20.威迫
        group.push([20, 0, 620])   
        # Lv24.【警戒の備え】（黒）
        group.push([24, 1, 228]) if self.color == "黒"
        # Lv24.【活気】（赤）
        group.push([24, 1, 109]) if self.color == "赤"
        # Lv27.パッションビート
        group.push([27, 0, 613])   
        # Lv30.【生命力】
        group.push([30, 1, 214]) 
        # Lv36.【対抗心】
        group.push([36, 1, 151])  
      #------------------------------------------------------------------------
      # ■■ワーキャット種
      #------------------------------------------------------------------------
      when "ワーキャット"
        # Lv1.【柔軟】
        group.push([1, 1, 112])
        # Lv1.【金運】(黄)
        group.push([1, 1, 222]) if self.color == "黄"
        # Lv1.アンラッキーロア(黒)
        group.push([1, 0, 420]) if self.color == "黒"
        # Lv3.チャーム
        group.push([3, 0, 200])
        # Lv7.ラナンブルム
        group.push([7, 0, 171]) 
        # Lv10.ルーズ
        group.push([10, 0, 212])
        # Lv13.トリックレイド
        group.push([13, 0, 104])
        # Lv18.イリスシード
        group.push([18, 0, 161]) 
        # Lv20.サフライーザ
        group.push([20, 0, 185])
        # Lv24.エルダブルム
        group.push([24, 0, 179])
        # Lv28.ドロウネクター
        group.push([28, 0, 16])
        # Lv30.本能の呼び覚まし
        group.push([30, 0, 601])
        # Lv35.ペイド・ルーズ
        group.push([35, 0, 212])
      #------------------------------------------------------------------------
      # ■■ゴブリン種
      #------------------------------------------------------------------------
      when "ゴブリン","ギャングコマンダー"
        # Lv1.【小悪魔の連携】
        group.push([1, 1, 81]) if self.name == "ゴブリン"
        # Lv1.【小悪魔の統率】
        group.push([1, 1, 82]) if self.name == "ギャングコマンダー"
        # Lv1.【奇襲の備え】
        group.push([1, 1, 227])
        # Lv4.エキサイトビュー
        group.push([4, 0, 18])
        # Lv9.エルダブルム
        group.push([9, 0, 179]) 
        # Lv13.ドロウネクター
        group.push([13, 0, 16])  
        # Lv17.コリオブルム
        group.push([17, 0, 187]) 
        # Lv20.焦燥
        group.push([20, 0, 599]) 
        # Lv23.パッションビート
        group.push([23, 0, 613])   
        # Lv26.ランクアップ（ゴブリン）
        group.push([26, 0, 249]) if self.name == "ゴブリン"
        # Lv26.激励
        group.push([26, 0, 588]) if self.name == "ギャングコマンダー"
        # Lv29.ガード
        group.push([29, 0, 145]) if self.name == "ギャングコマンダー"
        # Lv29.パラライズ
        group.push([29, 0, 210]) if self.name == "ギャングコマンダー"
        # Lv35.【対抗心】
        group.push([35, 1, 151]) 
        # Lv40.プロヴォーク
        group.push([40, 0, 149])
      #------------------------------------------------------------------------
      # ■■プリーステス種
      #------------------------------------------------------------------------
      when "プリーステス"
        # ☆シェルマッチ、スクラッチ、【アクセプト】は習得しない
        group.delete([1, 0, 5])   
        group.delete([1, 0, 52])
        group.delete([1, 1, 302])
        # Lv1.【平穏の保証】
        group.push([1, 1, 135])
        # Lv1.イリスシード
        group.push([1, 0, 161]) 
        # Lv1.懺悔なさい
        group.push([1, 0, 421]) 
        # Lv4.ネリネブルム
        group.push([4, 0, 175]) 
        # Lv7.イーザカール
        group.push([7, 0, 221]) 
        # Lv10.アスタブルム
        group.push([10, 0, 191]) 
        # Lv17.イリスペタル
        group.push([17, 0, 162]) 
        # Lv21.イリスシード・アルダ
        group.push([21, 0, 165]) 
        # Lv25.ウォッシュフルード
        group.push([25, 0, 224])   
        # Lv30.イリスフラウ
        group.push([30, 0, 163]) 
        # Lv36.イリスペタル・アルダ
        group.push([36, 0, 166]) 
        # Lv40.イリスコロナ
        group.push([50, 0, 164]) 
        # Lv55.イリスフラウ・アルダ
        group.push([60, 0, 167]) 
      #------------------------------------------------------------------------
      # ■■カースメイガス種
      #------------------------------------------------------------------------
      when "カースメイガス"
        # Lv1.テラー
        group.push([1, 0, 208])  
        # Lv1.【マゾヒスト】
        group.push([1, 1, 72])
        # Lv1.ラスト
        group.push([1, 0, 202])
        # Lv4.サフライーザ
        group.push([4, 0, 185])
        # Lv7.エルダイーザ
        group.push([7, 0, 181])
        # Lv11.コリオイーザ
        group.push([11, 0, 189])
        # Lv16.レザラジィ
        group.push([16, 0, 206])
        # Lv20.エンブレイス
        group.push([20, 0, 17])
        # Lv20.【ペリスコープ】
        group.push([20, 1, 307])
        # Lv24.サディストカレス
        group.push([24, 0, 361])
        # Lv30.ペイド・ラスト
        group.push([30, 0, 203])
        # Lv35.サフライーザ・アルダ
        group.push([35, 0, 186])
        # Lv40.【慧眼】
        group.push([40, 1, 83])
        # Lv50.エルダイーザ・アルダ
        group.push([50, 0, 182])
      #------------------------------------------------------------------------
      # ■■アルラウネ種
      #------------------------------------------------------------------------
      when "アルラウネ"
        # Lv1.【ダウト】
        group.push([1, 1, 226])
        # Lv1.【免疫力】
        group.push([1, 1, 118])
        # Lv1.【ロマンチスト】
        group.push([1, 1, 123])
        # Lv1.【吸精】
        group.push([1, 1, 70]) if self.color == "青"
        # Lv1.スイートウィスパー
        group.push([1, 0, 418])
        # Lv1.ラブフレグランス
        group.push([1, 0, 625])
        # Lv7.【回復力】
        group.push([7, 1, 212])
        # Lv12.エンブレイス
        group.push([12, 0, 17])
        # Lv15.スイートアロマ
        group.push([15, 0, 612])
        # Lv20.アイヴィクローズ
        group.push([20, 0, 591])
        # Lv23.ドロウネクター
        group.push([23, 0, 16]) 
        # Lv23.【ペリスコープ】
        group.push([23, 1, 307]) 
        # Lv26.【生命力】
        group.push([26, 1, 213]) 
        # Lv30.祝福の口付け
        group.push([30, 0, 417]) if self.color == "緑"
        # Lv30.魔性の口付け
        group.push([30, 0, 416]) if self.color == "青"
        # Lv34.【一心】
        group.push([34, 1, 113]) if self.color == "緑"
        # Lv34.【胆力】
        group.push([34, 1, 110]) if self.color == "青"
        # Lv40.リフレッシュ
        group.push([40, 0, 125]) if self.color == "緑"
      #------------------------------------------------------------------------
      # ■■マタンゴ種
      #------------------------------------------------------------------------
      when "マタンゴ"
        # Lv1.【ダウト】
        group.push([1, 1, 226])
        # Lv1.【免疫力】
        group.push([1, 1, 118])
        # Lv1.リフレッシュ
        group.push([1, 0, 125])
        # Lv4.バッドスポア
        group.push([4, 0, 589])
        # Lv8.【回復力】
        group.push([8, 1, 212])
        # Lv15.スポアクラウド
        group.push([15, 0, 590])
        # Lv19.【生命力】
        group.push([19, 1, 213]) 
        # Lv23.イリスシード
        group.push([23, 0, 161]) 
        # Lv26.【奇襲の備え】
        group.push([26, 1, 227])
        # Lv30.ストレンジスポア
        group.push([30, 0, 618])
        # Lv35.イリスペタル
        group.push([35, 0, 162]) 
        # Lv40.ウィークスポア
        group.push([40, 0, 619])
      #------------------------------------------------------------------------
      # ■■エンジェル種
      #------------------------------------------------------------------------
      when "ダークエンジェル"
        # Lv1.魔性の口付け
        group.push([1, 0, 416])
        # Lv1.祝福の口付け
        group.push([1, 0, 417])
        # Lv1.イリスシード
        group.push([1, 0, 161]) 
        # Lv4.ティーズ
        group.push([4, 0, 101])  
        # Lv10.エルダブルム
        group.push([10, 0, 179])
        # Lv14.サフライーザ
        group.push([14, 0, 185])
        # Lv20.イリスペタル
        group.push([20, 0, 162]) 
        # Lv24.イリスシード・アルダ
        group.push([24, 0, 165]) 
        # Lv28.エンブレイス
        group.push([28, 0, 17])
        # Lv28.【ペリスコープ】
        group.push([28, 1, 307]) 
        # Lv32.リラックスタイム
        group.push([32, 0, 611]) 
        # Lv38.エキサイトビュー
        group.push([38, 0, 18])   
        # Lv40.ウォッシュフルード
        group.push([40, 0, 224])   
        # Lv45.イリスフラウ
        group.push([45, 0, 163]) 
      #------------------------------------------------------------------------
      # ■■ガーゴイル種
      #------------------------------------------------------------------------
      when "ガーゴイル"
        # Lv1.【ダウト】
        group.push([1, 1, 226])
        # Lv1.【ブロッキング】
        group.push([1, 1, 116])
        # Lv1.ガード
        group.push([1, 0, 145])  
        # Lv1.【奇襲の備え】
        group.push([1, 1, 227])
        # Lv1.【警戒の備え】
        group.push([1, 1, 228])
        # Lv1.プロヴォーク
        group.push([1, 0, 149])
        # Lv36.カームブレス
        group.push([36, 0, 122])
        # Lv40.威迫
        group.push([8, 0, 620])   
        # Lv42.インデュア
        group.push([1, 0, 146])
        # Lv45.リフレッシュ
        group.push([1, 0, 125])
      #------------------------------------------------------------------------
      # ■■ミミック種
      #------------------------------------------------------------------------
      when "ミミック"
        # Lv1.【ダウト】
        group.push([1, 1, 226]) if self.color == "青"
        # Lv1.パッションビート
        group.push([8, 0, 613]) if self.color == "青"
        # Lv1.【焦欲】
        group.push([1, 1, 126]) if self.color == "黒"
        # Lv1.【エクスタシーボム】
        group.push([1, 1, 170]) if self.color == "黒"
        # Lv1.アピール
        group.push([1, 0, 148]) if self.color == "青"
        # Lv1.プロヴォーク
        group.push([1, 0, 149]) if self.color == "黒"
        # Lv1.【蒐集】
        group.push([1, 1, 221])
        # Lv1.【金運】
        group.push([1, 1, 222])
        # Lv1.【奇襲の備え】
        group.push([1, 1, 227])
        # Lv1.チャーム
        group.push([1, 0, 200])
        # Lv10.ネリネブルム
        group.push([25, 0, 175])
        # Lv15.ドロウネクター
        group.push([15, 0, 16]) 
        # Lv18.ラナンブルム
        group.push([18, 0, 171]) 
        # Lv22.トリックレイド
        group.push([22, 0, 104])
        # Lv25.ファストレイド
        group.push([22, 0, 103])
        # Lv30.ガード
        group.push([30, 0, 145])  
        # Lv40.インデュア
        group.push([40, 0, 146])
      #------------------------------------------------------------------------
      # ■■タマモ種
      #------------------------------------------------------------------------
      when "タマモ"
        # Lv1.【厚着】
        group.push([1, 1, 117]) 
        # Lv1.【ブロッキング】
        group.push([1, 1, 116])
        # Lv1.ツーパフ
        group.push([1, 0, 91])   
        # Lv4.ティーズ
        group.push([4, 0, 101])  
        # Lv8.サフラブルム
        group.push([8, 0, 183])
        # Lv15.ドロウネクター
        group.push([15, 0, 16]) 
        # Lv15.【ペリスコープ】
        group.push([15, 1, 307])
        # Lv30.テンプテーション
        group.push([30, 0, 140]) 
        # Lv25.エキサイトビュー
        group.push([8, 0, 18])   
        # Lv30.【熟練】
        group.push([30, 1, 124]) 
        # Lv40.【生命力】
        group.push([40, 1, 213]) 
        # Lv50.本能の呼び覚まし
        group.push([12, 0, 601])
      #------------------------------------------------------------------------
      # ■■リリム種
      #------------------------------------------------------------------------
      when "リリム"
        # Lv1.【焦欲】
        group.push([1, 1, 126])
        # Lv1.【吸精】
        group.push([1, 1, 70])  
        # Lv1.チャーム
        group.push([1, 0, 200])
        # Lv1.ラスト
        group.push([1, 0, 202])
        # Lv1.エキサイトビュー
        group.push([1, 0, 18])
        # Lv7.ネリネイーザ
        group.push([7, 0, 177])  
        # Lv12.ツーパフ
        group.push([12, 0, 91])   
        # Lv20.ドロウネクター
        group.push([20, 0, 16]) 
        # Lv20.エンブレイス
        group.push([20, 0, 17])
        # Lv20.【ペリスコープ】
        group.push([20, 1, 307])
        # Lv25.アスタイーザ
        group.push([25, 0, 193])
        # Lv30.【熟練】
        group.push([30, 1, 124]) 
        # Lv40.【超暴走】
        group.push([40, 1, 154]) 
        # Lv50.【執拗な攻め】
        group.push([40, 1, 127]) 
      #------------------------------------------------------------------------
      # ■■ユニークサキュバス種
      #------------------------------------------------------------------------
      when "ユニークサキュバス","ユニークタイクーン","ユニークウィッチ"
        case self.color
        #----------------------------------------------------------------------
        # ■■ネイジュレンジ
        #----------------------------------------------------------------------
        when "ネイジュレンジ"
          # Lv1.【胸が性感帯】
          group.push([1, 1, 21])
          # Lv1.【毒の体液】
          group.push([1, 1, 91])
          # Lv1.【免疫力】
          group.push([1, 1, 118])
          # Lv1.【濡れやすい】
          group.push([1, 1, 106])
          # Lv1.ストレンジスポア
          group.push([1, 0, 618])
          # Lv1.ウィークスポア
          group.push([1, 0, 619])
          # Lv1.ツーパフ
          group.push([1, 0, 91])   
          # Lv1.エキサイトビュー
          group.push([1, 0, 18])
          # Lv1.ドロウネクター
          group.push([1, 0, 16]) 
          # Lv1.【ペリスコープ】
          group.push([1, 1, 307])
          # Lv42.プロヴォーク
          group.push([42, 0, 149])
        #----------------------------------------------------------------------
        # ■■リジェオ
        #----------------------------------------------------------------------
        when "リジェオ"
          # Lv1.【胸が性感帯】
          group.push([1, 1, 19])
          # Lv1.【無我夢中】
          group.push([1, 1, 150])
          # Lv5.サフラブルム
          group.push([5, 0, 183])
          # Lv5.セットサークル
          group.push([5, 0, 359])
          # Lv10.ドロウネクター
          group.push([10, 0, 16])
          # Lv10.イーザカール
          group.push([10, 0, 221]) 
          # Lv15.【警戒の備え】
          group.push([15, 1, 228])
          # Lv15.【隙無し走法】
          group.push([15, 1, 229])
          # Lv15.【逃走の極意】
          group.push([15, 1, 230])
          # Lv20.パラライズ
          group.push([20, 0, 210])
          # Lv25.ラナンブルム
          group.push([25, 0, 171]) 
          # Lv30.トリムルート
          group.push([30, 0, 215])
          # Lv30.エンブレイス
          group.push([30, 0, 17])
          # Lv40.サフラブルム・アルダ
          group.push([40, 0, 184])
        #----------------------------------------------------------------------
        # ■■フルビュア
        #----------------------------------------------------------------------
        when "フルビュア"
          # Lv1.【確固たる自尊心】
          group.push([1, 1, 93]) if $PRODUCT_VERSION
          # Lv1.【陰核が性感帯】
          group.push([1, 1, 27])
          # Lv1.エキサイトビュー
          group.push([1, 0, 18])
          # Lv1.テンプテーション
          group.push([1, 0, 140]) 
          # Lv1.ツーパフ
          group.push([1, 0, 91])   
          # Lv1.ティーズ
          group.push([1, 0, 101])  
          # Lv1.【吸精】
          group.push([1, 1, 70])  
          # Lv25.【熟練】
          group.push([25, 1, 124])  
          # Lv25.【対抗心】
          group.push([25, 1, 151])  
          # Lv25.自信過剰
          group.push([25, 0, 602])  
          # Lv25.ドロウネクター
          group.push([25, 0, 16]) 
          # Lv25.【ペリスコープ】
          group.push([25, 1, 307])
          # Lv25.プライスオブシナー
          group.push([25, 0, 363])
          # Lv25.パッションビート
          group.push([25, 0, 613])
          # Lv50.【カリスマ】
          group.push([50, 1, 73]) 
        #----------------------------------------------------------------------
        # ■■ギルゴーン
        #----------------------------------------------------------------------
        when "ギルゴーン"
          # ☆シェルマッチ、スクラッチ、【アクセプト】は習得しない
          group.delete([1, 0, 5])   
          group.delete([1, 0, 52])
          group.delete([1, 1, 302])
          # Lv1.【胸が性感帯】
          group.push([1, 1, 21])
          # Lv1.【過敏な身体】
          group.push([1, 1, 94])
          # Lv1.【料理音痴】
          group.push([1, 1, 332])
          # Lv1.【ダウト】
          group.push([1, 1, 213])
          # Lv1.ガード
          group.push([1, 0, 145])
          # Lv1.エルダイーザ・アルダ
          group.push([1, 0, 182])
          # Lv1.サフライーザ・アルダ
          group.push([1, 0, 186])
          # Lv1.コリオイーザ・アルダ
          group.push([1, 0, 190])
          # Lv1.アスタイーザ・アルダ
          group.push([1, 0, 194])
          # Lv1.ペイド・レザラジィ
          group.push([1, 0, 207])
          # Lv1.ペイド・テラー
          group.push([1, 0, 209])
          # Lv1.ペイド・パラライズ
          group.push([1, 0, 211])
          # Lv1.ペイド・ルーズ
          group.push([1, 0, 213])
          # Lv1.ストレリイーザ
          group.push([1, 0, 197])
          # Lv1.激励
          group.push([1, 0, 588])
          # Lv1.ブルムカール・アルダ
          group.push([1, 0, 220])
          # Lv45.インデュア
          group.push([45, 0, 146])
        #----------------------------------------------------------------------
        # ■■ユーガノット
        #----------------------------------------------------------------------
        when "ユーガノット"
          # Lv1.【お尻が性感帯】
          group.push([1, 1, 23])
          # Lv1.【サンチェック】
          group.push([1, 1, 134])
          # Lv1.【胆力】
          group.push([1, 1, 110])
          # Lv1.【マゾヒスト】
          group.push([1, 1, 72])
          # Lv1.デモンズドロウ
          group.push([1, 0, 26])
          # Lv1.【吸精】
          group.push([1, 1, 70])  
          # Lv1.アスタブルム
          group.push([1, 0, 191]) 
          # Lv1.ネリネイーザ
          group.push([1, 0, 177])  
          # Lv1.コールドタッチ
          group.push([1, 0, 360])
          # Lv8.威迫
          group.push([8, 0, 620])   
          # Lv16.レザラジィ
          group.push([16, 0, 206])
          # Lv20.ルーズ
          group.push([20, 0, 212])
          # Lv24.サディストカレス
          group.push([24, 0, 361])
        #----------------------------------------------------------------------
        # ■■シルフェ
        #----------------------------------------------------------------------
        when "シルフェ"
          # Lv1.【口が性感帯】
          group.push([1, 1, 19])
          # Lv1.【ロマンチスト】
          group.push([1, 1, 123])  
          # Lv1.【先読み】
          group.push([1, 1, 96])  
          # Lv1.【料理音痴】
          group.push([1, 1, 332])
          # Lv1.サーヴァントコール
          group.push([1, 0, 248])  
          # Lv1.ドロウネクター
          group.push([1, 0, 16]) 
          # Lv1.【ペリスコープ】
          group.push([1, 1, 307])
          # Lv1.エンブレイス
          group.push([1, 0, 17])
          # Lv1.スイートウィスパー
          group.push([1, 0, 418])
          # Lv1.テンプテーション
          group.push([1, 0, 140]) 
          # Lv1.ラブフレグランス
          group.push([1, 0, 625])
          # Lv1.アスタブルム
          group.push([1, 0, 191]) 
          # Lv1.祝福の口付け
          group.push([1, 0, 417])
          # Lv1.ツーパフ
          group.push([1, 0, 91])   
          # Lv1.ティーズ
          group.push([1, 0, 101])  
          # Lv45.アスタブルム・アルダ
          group.push([45, 0, 192]) 
        #----------------------------------------------------------------------
        # ■■ラーミル
        #----------------------------------------------------------------------
        when "ラーミル"
          # Lv1.【胸が性感帯】
          group.push([1, 1, 21])
          # Lv1.【超暴走】
          group.push([1, 1, 154])
          # Lv1.【無我夢中】
          group.push([1, 1, 150])
          # Lv15.【警戒の備え】
          group.push([15, 1, 228])
          # Lv15.【逃走の極意】
          group.push([15, 1, 230])
          # Lv1.ドロウネクター
          group.push([1, 0, 16]) 
          # Lv1.ストレリブルム
          group.push([1, 0, 195])
          # Lv1.セットサークル
          group.push([1, 0, 359])
          # Lv5.ネリネブルム
          group.push([5, 0, 175]) 
          # Lv5.コリオブルム
          group.push([5, 0, 187]) 
          # Lv38.ペイド・チャーム
          group.push([38, 0, 201])
          # Lv38.ペイド・パラライズ
          group.push([38, 0, 211])
          # Lv56.【ペリスコープ】
          group.push([56, 1, 307])
          # Lv60.ウォッシュフルード
          group.push([60, 0, 224]) 
        #----------------------------------------------------------------------
        # ■■ヴェルミィーナ
        #----------------------------------------------------------------------
        when "ヴェルミィーナ"
          # Lv1.【女陰が性感帯】
          group.push([1, 1, 29])
          # Lv1.【吸精】
          group.push([1, 1, 70])  
          # Lv1.ツーパフ
          group.push([1, 0, 91])   
          # Lv1.ティーズ
          group.push([1, 0, 101])  
          # Lv1.エキサイトビュー
          group.push([1, 0, 18])
          # Lv1.ドロウネクター
          group.push([1, 0, 16]) 
          # Lv1.【ペリスコープ】
          group.push([1, 1, 307])
          # Lv1.【熟練】
          group.push([1, 1, 124]) 
          # Lv1.【執拗な攻め】
          group.push([1, 1, 127]) 
          # Lv1.【エクスタシーボム】
          group.push([1, 1, 170]) 
          # Lv1.プライスオブシナー
          group.push([1, 0, 363])
          # Lv1.全ては現
          group.push([1, 0, 622])
          # Lv1.ペルソナブレイク
          group.push([1, 0, 364])
          # Lv1.ネリネイーザ
          group.push([1, 0, 177])  
          # Lv1.アスタイーザ
          group.push([1, 0, 193]) 
          # Lv1.スイートウィスパー
          group.push([1, 0, 418])
          # Lv1.魔性の口付け
          group.push([1, 0, 416])
          # Lv65.エンブレイス
          group.push([65, 0, 17])
        end
      end  

      #------------------------------------------------------------------------
      # ■ ホールドスキルが入った場合、自動で入れる。
      # ※アクセプト、ペリスコープは味方時では使用できないので上に手動で入れる。
      #------------------------------------------------------------------------
      for learn in group
        if learn[1] == 0
          case learn[2]
          when 5  # シェルマッチ
            group += [[learn[0], 1, 303]]
          when 6  # インサート 
            group += [[learn[0], 1, 301]]
          when 16 # ドロウネクター
            group += [[learn[0], 1, 306]]
          when 17 # エンブレイス
            group += [[learn[0], 1, 305]]
          when 18 # エキサイトビュー
            group += [[learn[0], 1, 304]]
          when 20 # イクイップディルド
            group += [[learn[0], 1, 314]]
          when 26 # テンタクルマスタリー
            group += [[learn[0], 1, 313]]
          end
        end
      end
      
      

      
      
      
      return group
    end
    #--------------------------------------------------------------------------
    # ● 名前取得
    #--------------------------------------------------------------------------
    def name
      n = @name.split(/\//)[0]
      n = @name if n == nil
      return n
    end
    #--------------------------------------------------------------------------
    # ● 色取得
    #--------------------------------------------------------------------------
    def color
      n = @name.split(/\//)[1]
      n = "未設定" if n == nil
      return n
    end
    #--------------------------------------------------------------------------
    # ● 公開インスタンス変数
    #--------------------------------------------------------------------------
    def original_name
      return @name      
    end
  end
end