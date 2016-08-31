class Scene_Box
  #--------------------------------------------------------------------------
  # ● フェード
  #--------------------------------------------------------------------------
  def fade
    # フェードイン処理。10フレームで行う。
    
    n = 10
    
    case @fade_flag
    
    when 1 # 全出現
      # 中央背景
      if @center[0].opacity < 120
        @center[0].opacity += 120 / n
      end
      # 上フレーム
      if @overF[@overF.size - 1].y < 0
        for overF in @overF
          overF.y += 100 / n
        end
      end
      # 下フレーム
      if @underF[@underF.size - 1].y > 380
        for underF in @underF
          underF.y -= 100 / n
        end
      end
      # ウィンドウ
      for window in @window
        window.opacity += 200 / n
      end
      @actor_graphic.opacity += 260 / n
      @left_window.contents_opacity += 260 / n
      @right_window.contents_opacity += 260 / n

      # すべて完了したらフェードを終了する。
      if @overF[@overF.size - 1].y == 0 \
       and @underF[@underF.size - 1].y == 380
        @fade_flag = 0
      end
      return
      
    when 2 # 全消し
      # 中央背景
      if @center[0].opacity > 0
        @center[0].opacity -= 120 / n
      end
      # 上フレーム
      if @overF[@overF.size - 1].y > -100
        for overF in @overF
          overF.y -= 100 / n
        end
      end
      # 下フレーム
      if @underF[@underF.size - 1].y < 380 + 100
        for underF in @underF
          underF.y += 100 / n
        end
      end
      # ウインドウ
      for window in @window
        window.opacity -= 200 / n
      end
      @actor_graphic.opacity -= 260 / n
      @left_window.contents_opacity -= 260 / n
      @right_window.contents_opacity -= 260 / n

      # すべて完了したらフェードを終了する。
      if @overF[@overF.size - 1].y == -100 \
       and @underF[@underF.size - 1].y == 380 + 100
        # 非表示ではない場合は戻す。
        if @hidden_flag == false
          @return_flag = true
        end
        @fade_flag = 0
      end
      return
      
    when 3 # コマンド用フレーム移動（ON）
      # 上フレーム
      for overF in @overF
        overF.x -= 150 / n
      end
      # 下フレーム
      for underF in @underF
        underF.x += 120 / n
        if underF == @underF[4]
          underF.opacity -= 260 / n
        end
      end
      
      @left_window.contents_opacity -= 260 / n
      @right_window.contents_opacity -= 260 / n
      @window[0].opacity -= 200 / n
      @window[1].opacity -= 200 / n
      
      # すべて完了したらフェードを終了する。
      if @overF[0].x == -150 \
       and @underF[0].x == -120
      @fade_flag = 0
      end
      return

    when 4 # コマンド用フレーム移動（OFF）
      # 上フレーム
      for overF in @overF
        overF.x += 150 / n
      end
      # 下フレーム
      for underF in @underF
        underF.x -= 120 / n
        if underF == @underF[4]
          underF.opacity += 260 / n
        end
      end
      @left_window.contents_opacity += 260 / n
      @right_window.contents_opacity += 260 / n
      @window[0].opacity += 200 / n
      @window[1].opacity += 200 / n
      # すべて完了したらフェードを終了する。
      if @overF[0].x == 0 \
       and @underF[0].x == -240
       @fade_flag = 0
      end
      return
    end
  end

  #--------------------------------------------------------------------------
  # ● 連れて行く処理
  #--------------------------------------------------------------------------
  def party_in
    # パーティに空きがない場合はブザーを鳴らして終了
    if $game_party.actors.size >= 4
      # キャンセル SE を演奏
      $game_system.se_play($data_system.cancel_se)
      $game_temp.message_text = "これ以上パーティに入れられません！"
      return
    end
    # SE を演奏
    Audio.se_play("Audio/SE/005-System05", 80, 100)
    # 素体確認
    unless $game_party.party_actors.include?($game_actors[110])
      unless $game_party.party_actors.include?($game_actors[111])
        unless $game_party.party_actors.include?($game_actors[112])
          unless $game_party.party_actors.include?($game_actors[113])
            $game_variables[77] = 109
          end
        end
      end
    end
    unless $game_party.party_actors.include?($game_actors[106])
      unless $game_party.party_actors.include?($game_actors[107])
        unless $game_party.party_actors.include?($game_actors[108])
          unless $game_party.party_actors.include?($game_actors[109])
            $game_variables[77] = 105
          end
        end
      end
    end
    unless $game_party.party_actors.include?($game_actors[102])
      unless $game_party.party_actors.include?($game_actors[103])
        unless $game_party.party_actors.include?($game_actors[104])
          unless $game_party.party_actors.include?($game_actors[105])
            $game_variables[77] = 101
          end
        end
      end
    end
    # 空き素体を照合する
    n = @now_actor.class_id
    body = $game_variables[77] + $data_SDB[n].exp_type
    # データ移送
    $game_party.data_move(body, @now_actor, 1)
    @now_actor.class_id = 1
    # パーティに加える
    $game_party.add_actor(body)
    box_sort
    $game_party.battle_actor_refresh
  end
  #--------------------------------------------------------------------------
  # ● 預ける処理
  #--------------------------------------------------------------------------
  def box_in
    i = 1
    loop do # ボックス空き確認
      if i == $game_party.box_max + 1 # ボックスが満杯の場合
        # キャンセル SE を演奏
        $game_system.se_play($data_system.cancel_se)
        $game_temp.message_text = "ホームがいっぱいです！\nホームを空けてから預けてください！"
        return
      end
      # 空き（クラスIDが 1 ）の所に入れる。
      if $game_actors[i].class_id == 1
        # ●預けたアクターの使用スキル履歴を消去する
        @now_actor.skill_collect = nil
        n = @now_actor.id
        # パーティから外す
        $game_party.remove_actor(n)
        # データ移送
#        text = "【預ける】\n"
#        text +=  "受信側ＩＤ：#{$game_actors[i].id}\n"
#        text += "受信側クラス：#{$game_actors[i].class_id}\n"
#        text +=  "送信側ＩＤ：#{@now_actor.id}\n"
#        text += "送信側クラス：#{@now_actor.class_id}"
#        print text
        $game_party.data_move(i, @now_actor, 1)
        $game_actors[n].class_id = 1
        # SE を演奏
        Audio.se_play("Audio/SE/005-System05", 80, 100)
        break
      else
        i += 1
      end
    end
    box_sort
    $game_party.battle_actor_refresh
  end
  #--------------------------------------------------------------------------
  # ● 契約破棄
  #--------------------------------------------------------------------------
  def release
    # SE を演奏
    Audio.se_play("Audio/SE/heal02", 80, 100)
    # 解放した箇所を空き（クラスIDが 1 ）にする
    @now_actor.class_id = 1
    # パーティの夢魔を解放した場合その夢魔をパーティから外す。
    if $game_party.party_actors.include?(@now_actor)
      $game_party.remove_actor(@now_actor.id)
      $game_party.battle_actor_refresh
    end
    # ボックス前詰め
    box_sort
  end
  #--------------------------------------------------------------------------
  # ● ボックスの前詰め作業
  #--------------------------------------------------------------------------
  def box_sort
    box = []
    for i in 1..$game_party.box_max
      box.push($game_actors[i].dup) if $game_actors[i].class_id != 1
      $game_actors[i].class_id = 1
      $game_actors[i].level = 1
      $game_actors[i].name = ""
      $game_actors[i].skills = []
      $game_actors[i].ability = []
    end
    
    for i in 0...box.size
#      text = "前詰め#{i}\n"
#      text +=  "受信側ＩＤ：#{box[i].id}\n"
#      text += "受信側クラス：#{$game_actors[i + 1].class_id}\n"
#      text += "受信側スキル：#{$game_actors[i + 1].skills}\n"
#      text +=  "送信側ＩＤ：#{box[i].id}\n"
#      text += "送信側クラス：#{box[i].class_id}\n"
#      text += "送信側スキル：#{box[i].skills}"
#      print text
      $game_party.data_move($game_actors[i + 1].id, box[i])
    end
    
#    text = "ボックス内確認\n"
#    for a in 1..$game_party.box_max
#      text += "#{$game_actors[a].id}：#{$game_actors[a].name}：#{$game_actors[a].class_id}\n"
#      text += "#{$game_actors[a].skills}\n"
#    end
#    print text
  
    
    
    
    @now_actor = @right_window.actor = @left_window.actor_data
  end
  #--------------------------------------------------------------------------
  # ● ボックスの並び替え作業 ##不安定のため現状没
  #    type : 0:種族順, 1:レベル順 
  #--------------------------------------------------------------------------
  def pigeonhole(type)
    box = []
    for i in 1..$game_party.box_max
      box.push($game_actors[i].dup) if $game_actors[i].class_id != 1
      $game_actors[i].class_id = 1
      
    end
    
    case type
    when 0
      result = box.sort{|a, b| a.class_id <=> b.class_id }
      if box == result
        box.sort!{|a, b| b.class_id <=> a.class_id }
      else
        box = result
      end
    when 1
      result = box.sort{|a, b| b.level <=> a.level }
      if box == result
        box.sort!{|a, b| a.level <=> b.level }
      else
        box = result
      end
    end
    
    for i in 0...box.size
      $game_party.data_move($game_actors[i + 1],box[i])
    end
    
    @now_actor = @right_window.actor = @left_window.actor_data
    graphic_refresh
end

  
  
end