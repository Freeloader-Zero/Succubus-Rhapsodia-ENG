class BattlePop_Hold
  
  attr_accessor :battler                  # バトラー
  attr_accessor :action_list             # バトラー
  attr_accessor :initiative
  attr_accessor :display  
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  def initialize(battler)
    @battler = battler
    @data = []
    @fade_flag = 0
    @delete_flag = false
    @action_order = false
    @action_step = 0
    @action_list = []
    @wait_count = 0
    @initiative = 0
    @last_initiative = @initiative
    @initiative_graphic = HoldPop_Initiative_Sprite.new(@initiative)
    @display = false
    hold_pop_max = 3
  end
  #--------------------------------------------------------------------------
  # ● 解放
  #-------------------------------------------------------------------------- 
  def dispose
    for data in @data
      data.dispose
    end
    @initiative_graphic.dispose
  end
  #--------------------------------------------------------------------------
  # ● リフレッシュ
  #-------------------------------------------------------------------------- 
  def refresh
    # バトラーが無い場合は動かさない
    return @battler == nil 
  end

  #--------------------------------------------------------------------------
  # ● ホールドの追加
  #   type   : 種別（♀挿入、顔面騎乗等）
  #   battler: 自分
  #   target : 接続相手
  #   initiative : 初期イニシアチブ
  #-------------------------------------------------------------------------- 
  def add_hold(type, battler, target)
    @data.push(HoldPop_Sprite.new(type, battler, target))
    @data[@data.size - 1].appear
    @data[@data.size - 1].whiten
    Audio.se_play("Audio/SE/se_maoudamashii_chime09", 80, 150)
  end
  #--------------------------------------------------------------------------
  # ● ホールドの消去
  #-------------------------------------------------------------------------- 
  def delete_hold(type, battler, target)
    # バトラーが無い場合は動かさない
    return if @battler == nil
    exist_flag = false
    for data_one in @data
      if data_one.type == type and data_one.battler == battler and data_one.target == target
        data_one.escape
        data_one.hold_delete
        exist_flag = true
      end
    end
    # 対象ホールドがない場合終了
    return if exist_flag == false
    # 残りの処理
    Audio.se_play("Audio/SE/heal02", 80, 100)
    @wait_count = $game_system.battle_speed_time(0)
    @delete_flag = true
  end
  #--------------------------------------------------------------------------
  # ● イニシアチブの変更
  #-------------------------------------------------------------------------- 
  def initiative_change(plus_initiative)
    # バトラーが無い場合は動かさない
    return if @battler == nil
    @initiative += plus_initiative
    @initiative_graphic.now_initiative = @initiative
    refresh
  end
  #--------------------------------------------------------------------------
  # ● フェードイン指示
  #-------------------------------------------------------------------------- 
  def fade_in_order
    @fade_flag = 1
  end
  #--------------------------------------------------------------------------
  # ● フェードアウト指示
  #-------------------------------------------------------------------------- 
  def fade_out_order
    @fade_flag = 2
  end
  #--------------------------------------------------------------------------
  # ● ポップの指示
  #-------------------------------------------------------------------------- 
  def pop_order(action_list = [])
    @action_order = true
    @action_list = action_list
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新
  #-------------------------------------------------------------------------- 
  def update
    # バトラーが無い場合は動かさない
    return if @battler == nil
    
    # イニシアチブグラフィックの更新
    @initiative_graphic.update
    
    # 表示状態を連動
    for data in @data
      data.visible = @display if data != nil
    end
    @initiative_graphic.visible = @display
    
    # 座標を確定（アクターが更新される度に変化するのでupdateで確定）
    # アクターの場合
    if @battler.is_a?(Game_Actor)
      # アクター１である場合は左側に配置
      if @battler == $game_party.battle_actors[0]
        @x_basepoint = 55
        @y_basepoint = 420
      # それ以降は右側に配置
      else 
        @x_basepoint = 585
        @y_basepoint = 420
      end
    # エネミーの場合
    elsif @battler.is_a?(Game_Enemy)
      @x_basepoint = @battler.screen_x - 20
      temp_picture = RPG::Cache.battler(@battler.battler_name, 0)
      @y_basepoint = @battler.screen_y - (temp_picture.height / 2) - 60
      if temp_picture.height <= 410
        @y_basepoint = @battler.screen_y - (temp_picture.height / 2) - 60
      end
      # 座標例外処理
      case @battler.class_name
      when "Succubus"
        @x_basepoint += 15
      when "Little Witch "
        @y_basepoint += 30
      when "Sliｍe"
        @x_basepoint += 15
      end
      @x_basepoint += 25 if @battler.boss_graphic?
    end
    # nilの部分を詰める
    @data.compact!
    # 座標に合わせて配置
    # エネミーの場合、指定座標から下に増やす
    if @battler.is_a?(Game_Enemy)
      @initiative_graphic.x = @x_basepoint
      @initiative_graphic.y = @y_basepoint - 18
      for i in 0...@data.size
        @data[i].x = @x_basepoint
        @data[i].y = @y_basepoint + (18 * i)
      end
    # アクターの場合、指定座標を数に合わせて引き上げてから下に増やす。
    elsif @battler.is_a?(Game_Actor)
      y_point = @y_basepoint - (18 * @data.size)
      for i in 0...@data.size
        @data[i].x = @x_basepoint
        @data[i].y = y_point + (18 * i)
      end
      @initiative_graphic.x = @x_basepoint
      @initiative_graphic.y = y_point - 18
    end
    # ポップごとに更新
    for pop in @data
      pop.update
    end
    # ウェイトがあれば止める
    if @wait_count > 0
      @wait_count -= 1
      return 
    end

    # フェード
    fade_time = 10
    case @fade_flag
    when 1 # フェードイン
      count = 0
      for pop in @data
        pop.opacity += 260 / fade_time 
      end
      @initiative_graphic.opacity += 260 / fade_time 
      if @initiative_graphic.opacity == 255
        @fade_flag = 0
      end
    when 2 # フェードアウト
      count = 0
      for pop in @data
        pop.opacity -= 260 / fade_time
        count += 1 if pop.opacity == 0
      end
      @initiative_graphic.opacity -= 260 / fade_time 
      if @initiative_graphic.opacity == 0
        @fade_flag = 0
      end
    end
    return if @fade_flag != 0

    # 消去フラグが立っている場合は消去指示のあるポップを消す
    if @delete_flag and @action_order == false
      for i in 0...@data.size
        if @data[i].delete?
          @data[i].dispose
          @data[i] = nil
        end
      end
      @delete_flag = false
    end
    
    if @initiative != @last_initiative and @action_order == 0
      @action_order = true
    end
    
    # アクションが起きた場合はアクションを展開する
    if @action_order
      action_update
      return
    end

  end
  #--------------------------------------------------------------------------
  # ● フレーム更新 (アクション一括)
  #-------------------------------------------------------------------------- 
  def action_update
    case @action_step
    when 0; action_update_step0 
    when 1; action_update_step1
    when 2; action_update_step2
    end
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新 (アクション　ステップ０：フェードイン)
  #-------------------------------------------------------------------------- 
  def action_update_step0
    # フェードインを指示
    fade_in_order
    # ステップを進める
    @action_step = 1
  end
  #--------------------------------------------------------------------------
  # ● イニシアチブの確認
  #-------------------------------------------------------------------------- 
  def initiative_check
    if @initiative != @last_initiative
      @initiative_graphic.now_initiative = @initiative
      for data in @data
        data.initiative = @initiative if data != nil
      end
      @last_initiative = @initiative
    end
    data_count = 0
    for data in @data
      if data.delete?
        next
      end
      data_count += 1
    end
    @initiative_graphic.now_data_size = data_count
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新 (アクション　ステップ１：アクション)
  #-------------------------------------------------------------------------- 
  def action_update_step1
    for list in @action_list
      case list[0]
      when 1 # 追加
        add_hold(list[1],list[2],list[3])
      when 2 # 削除
        delete_hold(list[1],list[2],list[3])
      when 3 # 削除
        @initiative = list[1]
      end
    end
    initiative_check
    # ウェイトをつける
    @wait_count = $game_system.battle_speed_time(0) + $game_system.important_wait_time
    # ステップを進める
    @action_step = 2
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新 (アクション　ステップ２：フェードアウト)
  #-------------------------------------------------------------------------- 
  def action_update_step2
    # フェードアウトを指示
    fade_out_order
    # フラグ系をリフレッシュ
    @action_step = 0
    @action_order = false
    @action_list = []
  end
  
  
end