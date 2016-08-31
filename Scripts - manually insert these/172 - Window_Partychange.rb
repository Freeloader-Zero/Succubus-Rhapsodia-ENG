#==============================================================================
# ■ Window_Partychange
#------------------------------------------------------------------------------
# 　パーティメンバーを表示するウィンドウです。
#==============================================================================

class Window_Partychange < Window_Selectable
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  def initialize
    super(0, 68, 640, 320)
    self.contents = Bitmap.new(width - 32, height - 32)
    self.z = 2070
    self.opacity = 0
    @index = 0
    @item_max = $game_party.party_actors.size
    @column_max = 2
    @window = Sprite.new
    @window.y = 0
    @window.z = 2050
    @window.bitmap = RPG::Cache.windowskin("battle_index")
    @window.opacity = 255
    refresh
  end
  #--------------------------------------------------------------------------
  # ● リフレッシュ
  #--------------------------------------------------------------------------
  def dispose
    super
    @window.dispose
  end
  #--------------------------------------------------------------------------
  # ● ヘルプテキスト更新
  #--------------------------------------------------------------------------
  def update_help
    @help_window.set_text("Confirm party.")
  end
  #--------------------------------------------------------------------------
  # ● リフレッシュ
  #--------------------------------------------------------------------------
  def refresh
    
    self.contents.clear
    
    self.contents.font.size = $default_size
    
    

    actors = $game_party.party_actors
    actors.each_index { |i|
    x = 4 + i % 2 * (240 + 32)
    y = i / 2 * 110

      # 非戦闘メンバーは背景を暗くする
#      if i >= actors.size
#        self.contents.fill_rect(0, y, width - 32, 78, Color.new(0, 0, 0, 96))
#      end
      draw_actor_info(actors[i], x, y)
    }
  end
  #--------------------------------------------------------------------------
  # ● アクター情報描画
  #--------------------------------------------------------------------------
  def draw_actor_info(actor, x, y)
    
    self.contents.font.size = $default_size_mini

    draw_actor_graphic(actor, x + 72, y + 60)
    draw_actor_name(actor, x + 120, y)
    draw_actor_class(actor, x + 130, y + 20)

    self.contents.draw_text(x + 28, y + 64, 88, 24, "Lv." + actor.level.to_s, 1)
    draw_actor_state(actor, x + 28, y + 80, 88, 1, 1)

    self.contents.draw_text(x + 120, y + 40, 88, 24, "EP")
    draw_actor_hp(actor, x + 120, y + 38)
    self.contents.draw_text(x + 120, y + 62, 88, 24, "VP")
    draw_actor_sp(actor, x + 120, y + 60)
    draw_actor_fed(actor, x + 120, y + 88) if actor != $game_actors[101]
  end
  #--------------------------------------------------------------------------
  # ● カーソル矩形更新
  #--------------------------------------------------------------------------
  def update_cursor_rect
    # カーソル位置 -1 は全選択
    if @index <= -2
      # カーソルの幅を計算
      cursor_width = self.contents.width / 2 - 32
      # カーソルの座標を計算
      x = (@index + 10) % @column_max * cursor_width + 32
      y = (@index + 10) / @column_max * 110
      # カーソルの矩形を更新
      self.cursor_rect.set(x, y, cursor_width, 110)
  	  return
    elsif @index == -1
      self.cursor_rect.set(32, 0, self.width - 96, 240)
  	  return
    end
    # 現在の行を取得
    row = @index
    # 現在の行が、表示されている先頭の行より前の場合
    if row < self.top_row
      # 現在の行が先頭になるようにスクロール
      self.top_row = row
    end
    # 現在の行が、表示されている最後尾の行より後ろの場合
    if row > self.top_row + (self.page_row_max - 1)
      # 現在の行が最後尾になるようにスクロール
      self.top_row = row - (self.page_row_max - 1)
    end
    # カーソルの幅を計算
    cursor_width = self.contents.width / 2 - 32
    # カーソルの座標を計算
    x = @index % @column_max * cursor_width + 32
    y = @index / @column_max * 110
    # カーソルの矩形を更新
    self.cursor_rect.set(x, y, cursor_width, 110)
  end
  #--------------------------------------------------------------------------
  # ● 先頭の行の取得
  #--------------------------------------------------------------------------
  def top_row
    # ウィンドウ内容の転送元 Y 座標を、1 行の高さ 116 で割る
    return self.oy / 116
  end
  #--------------------------------------------------------------------------
  # ● 先頭の行の設定
  #     row : 先頭に表示する行
  #--------------------------------------------------------------------------
  def top_row=(row)
    # row を 0 ～ row_max - 1 に修正
    row = [[row, 0].max, row_max - 1].min
    # row に 1 行の高さ 116 を掛け、ウィンドウ内容の転送元 Y 座標とする
    self.oy = row * 116
  end
  #--------------------------------------------------------------------------
  # ● 1 ページに表示できる行数の取得
  #--------------------------------------------------------------------------
  def page_row_max
    return 4
  end
  #--------------------------------------------------------------------------
  # ● 行数の取得
  #--------------------------------------------------------------------------
  def row_max
    return $game_party.party_actors.size
  end
  #--------------------------------------------------------------------------
  # ● HPの描画
  #--------------------------------------------------------------------------
  def draw_actor_hp(actor, x, y, width = 144)
    
    
        # 変数rateに 現在のHP/MHPを代入
    if actor.maxhp != 0
      rate = actor.hp.to_f / actor.maxhp
    else
      rate = 0
    end
    # plus_x:X座標の位置補正 rate_x:X座標の位置補正(%) plus_y:Y座標の位置補正
    # plus_width:幅の補正 rate_width:幅の補正(%) height:縦幅
    # align1:描画タイプ1 0:左詰め 1:中央揃え 2:右詰め
    # align2:描画タイプ2 0:上詰め 1:中央揃え 2:下詰め
    # align3:ゲージタイプ 0:左詰め 1:右詰め
    plus_x = 0
    rate_x = 0
    plus_y = 25
    plus_width = 0
    rate_width = 100
    height = 7
    align1 = 1
    align2 = 2
    align3 = 0
    # グラデーション設定 grade1:空ゲージ grade2:実ゲージ
    # (0:横にグラデーション 1:縦にグラデーション 2:斜めにグラデーション(激重)）
    grade1 = 1
    grade2 = 0
    # 色設定。color1:外枠，color2:中枠
    # color3:空ゲージダークカラー，color4:空ゲージライトカラー
    # color5:実ゲージダークカラー，color6:実ゲージライトカラー
    color1 = Color.new(0, 0, 0, 192)
    color2 = Color.new(255, 255, 192, 192)
    color3 = Color.new(0, 0, 0, 192)
    color4 = Color.new(64, 0, 0, 192)
    color5 = Color.new(80 - 24 * rate, 80 * rate, 14 * rate, 192)
    color6 = Color.new(240 - 72 * rate, 240 * rate, 62 * rate, 192)
    # 変数spに描画するゲージの幅を代入
    if actor.maxhp != 0
      hp = (width + plus_width) * actor.hp * rate_width / 100 / actor.maxhp
    else
      hp = 0
    end
    # ゲージの描画
    gauge_rect(x + plus_x + width * rate_x / 100, y + plus_y,
                width, plus_width + width * rate_width / 100,
                height, hp, align1, align2, align3,
                color1, color2, color3, color4, color5, color6, grade1, grade2)
    # オリジナルのHP描画処理を呼び出し
    # MaxHP を描画するスペースがあるか計算
    if width - 32 >= 108
      hp_x = x + width - 108
      flag = true
    elsif width - 32 >= 48
      hp_x = x + width - 48
      flag = false
    end
    hp_x = x + 70
    self.contents.font.color = actor.hp == 0 ? knockout_color :
    actor.hp <= actor.maxhp / 4 ? crisis_color : normal_color
    self.contents.draw_text(hp_x, y - 2, 32, 32, actor.hp.to_s, 2)
    self.contents.font.color = normal_color
    self.contents.draw_text(hp_x + 24, y - 2, 32, 32, " / ", 1)
    self.contents.draw_text(hp_x + 48, y - 2, 32, 32, actor.maxhp.to_s, 0)
  end
  #--------------------------------------------------------------------------
  # ● SP の描画
  #     actor : アクター
  #     x     : 描画先 X 座標
  #     y     : 描画先 Y 座標
  #     width : 描画先の幅
  #--------------------------------------------------------------------------
  def draw_actor_sp(actor, x, y, width = 144)
        # 変数rateに 現在のSP/MSPを代入
    if actor.maxsp != 0
      rate = actor.sp.to_f / actor.maxsp
    else
      rate = 1
    end
    # plus_x:X座標の位置補正 rate_x:X座標の位置補正(%) plus_y:Y座標の位置補正
    # plus_width:幅の補正 rate_width:幅の補正(%) height:縦幅
    # align1:描画タイプ1 0:左詰め 1:中央揃え 2:右詰め
    # align2:描画タイプ2 0:上詰め 1:中央揃え 2:下詰め
    # align3:ゲージタイプ 0:左詰め 1:右詰め
    plus_x = 0
    rate_x = 0
    plus_y = 25
    plus_width = 0
    rate_width = 100
    height = 7
    align1 = 1
    align2 = 2
    align3 = 0
    # グラデーション設定 grade1:空ゲージ grade2:実ゲージ
    # (0:横にグラデーション 1:縦にグラデーション 2:斜めにグラデーション(激重)）
    grade1 = 1
    grade2 = 0
    # 色設定。color1:外枠，color2:中枠
    # color3:空ゲージダークカラー，color4:空ゲージライトカラー
    # color5:実ゲージダークカラー，color6:実ゲージライトカラー
    color1 = Color.new(0, 0, 0, 192)
    color2 = Color.new(255, 255, 192, 192)
    color3 = Color.new(0, 0, 0, 192)
    color4 = Color.new(0, 64, 0, 192)
    color5 = Color.new(14 * rate, 80 - 24 * rate, 80 * rate, 192)
    color6 = Color.new(62 * rate, 240 - 72 * rate, 240 * rate, 192)
    # 変数spに描画するゲージの幅を代入
    if actor.maxsp != 0
      sp = (width + plus_width) * actor.sp * rate_width / 100 / actor.maxsp
    else
      sp = (width + plus_width) * rate_width / 100
    end
    # ゲージの描画
    gauge_rect(x + plus_x + width * rate_x / 100, y + plus_y,
                width, plus_width + width * rate_width / 100,
                height, sp, align1, align2, align3,
                color1, color2, color3, color4, color5, color6, grade1, grade2)
    # オリジナルのSP描画処理を呼び出し

    # MaxSP を描画するスペースがあるか計算
    if width - 32 >= 108
      sp_x = x + width - 108
      flag = true
    elsif width - 32 >= 48
      sp_x = x + width - 48
      flag = false
    end
    sp_x = x + 70
    self.contents.font.color = actor.sp == 0 ? knockout_color :
    actor.sp <= actor.maxsp / 4 ? crisis_color : normal_color
    self.contents.draw_text(sp_x, y - 2, 32, 32, actor.sp.to_s, 2)
    self.contents.font.color = normal_color
    self.contents.draw_text(sp_x + 24, y - 2, 32, 32, " / ", 1)
    self.contents.draw_text(sp_x + 48, y - 2, 32, 32, actor.maxsp.to_s, 0)
  end


end
