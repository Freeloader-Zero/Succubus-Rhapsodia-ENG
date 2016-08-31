#==============================================================================
# ■ SR_Util　：　ファイル関係
#------------------------------------------------------------------------------
#==============================================================================
module SR_Util

  #--------------------------------------------------------------------------
  # ● ゲームトループの改変
  #--------------------------------------------------------------------------
  def self.game_troop_alter
    for i in 354..386
      for member in $data_troops[i].members
        case $data_enemies[member.enemy_id].name.split(/\//)[1].to_i
        # レッサーサキュバス
        when 5;   member.enemy_id = 196
        when 6;   member.enemy_id = 136
        # サキュバス
        when 10;  member.enemy_id = 195
        when 11;  member.enemy_id = 167
        # サキュバスロード
        when 15;  member.enemy_id = 1
        when 16;  member.enemy_id = 1
        # インプ
        when 21;  member.enemy_id = 154
        when 22;  member.enemy_id = 1
        # デビル
        when 26;  member.enemy_id = 155
        when 27;  member.enemy_id = 1
        # デーモン
        when 31;  member.enemy_id = 1
        when 32;  member.enemy_id = 1
        # プチウィッチ
        when 37;  member.enemy_id = 193
        when 38;  member.enemy_id = 201
        # ウィッチ
        when 42;  member.enemy_id = 194
        when 43;  member.enemy_id = 202
        # キャスト
        when 53;  member.enemy_id = 121
        # スレイヴ
        when 63;  member.enemy_id = 199
        # ナイトメア
        when 74;  member.enemy_id = 156
        when 75;  member.enemy_id = 156
        # スライム
        when 80;  member.enemy_id = 174
        # ゴールドスライム
        when 90;  member.enemy_id = 1
        # ファミリア
        when 96;  member.enemy_id = 198
        when 97;  member.enemy_id = 1
        # ワーウルフ
        when 100; member.enemy_id = 1
        when 101; member.enemy_id = 1
        # ワーキャット
        when 104; member.enemy_id = 1
        when 105; member.enemy_id = 1
        # ゴブリン
        when 108; member.enemy_id = 152
        # ギャングコマンダー
        when 111; member.enemy_id = 153
        # プリーステス
        when 118; member.enemy_id = 120
        # カースメイガス
        when 122; member.enemy_id = 197
        # アルラウネ
        when 126; member.enemy_id = 172
        when 127; member.enemy_id = 1
        # マタンゴ
        when 133; member.enemy_id = 173
        # ダークエンジェル
        when 137; member.enemy_id = 1
        # ガーゴイル
        when 141; member.enemy_id = 1
        # ミミック
        when 145; member.enemy_id = 200
        when 146; member.enemy_id = 1
        # タマモ
        when 152; member.enemy_id = 1
        # リリム
        when 156; member.enemy_id = 1
        end
      end
    end
    # セーブ
    save_data($data_troops, "Data/Troops.rxdata") 
    
    
    
  end

  #--------------------------------------------------------------------------
  # ● 口上データの暗号化セーブ
  #--------------------------------------------------------------------------
  def self.msgdata_save
    save_data($msg, "Data/Talk.rxdata") 
  end

  #--------------------------------------------------------------------------
  # ● クリアデータの暗号化セーブ
  #--------------------------------------------------------------------------
  def self.trial_cleardata_save
    data = []
    for actor in $game_actors.data
      if actor != nil and actor.class_id != 1 and actor != $game_actors[101]
        data.push(actor)
      end
    end
    $takeover_actors = data
    save_data($takeover_actors, "Savedata/trial_cleardata.rxdata") 
  end
  #--------------------------------------------------------------------------
  # ● 暗号化されたクリアデータのロード
  #--------------------------------------------------------------------------
  def self.trial_cleardata_load
    
    f_name = "../Succubus Rhapsodia Trial/Savedata/trial_cleardata.rxdata"
    
    return false unless FileTest.exist?(f_name)
    
    # セーブデータの読み込み
    file = File.open(f_name, "rb")
    $takeover_actors = Marshal.load(file)
    file.close
    # $game_systemに保存
    box = []
    for actor in $takeover_actors
      # バグ持ちのデビルの性格を変更
      if actor.class_name == "Devil " and
       not (actor.personality == "勝ち気" or actor.personality == "虚勢")
        actor.personality = "勝ち気"
      end
      box.push(actor)
    end
    $game_system.takeover_actors = box
    return true
  end
  #--------------------------------------------------------------------------
  # ● 引き継いで契約した夢魔の処理
  #--------------------------------------------------------------------------
  def self.takeover_contract

    # 引き継ぎアクター欄から消去
    for actor in $game_temp.vs_actors
      $game_system.takeover_actors.delete(actor) 
    end
  end
  
  #--------------------------------------------------------------------------
  # ● マップデータの改変
  #--------------------------------------------------------------------------
  def self.map_alter(map_id)
    
    map = load_data(sprintf("Data/Map%03d.rxdata", map_id))
    #--------------------------------------------------------------------------
    # 配置しているイベント位置を左右反転させる
    #--------------------------------------------------------------------------
    for i in map.events.keys
#      map.events[i].page = 
      for page in map.events[i].pages
        if page.graphic.character_name == "185-Light02"
          page.step_anime = false
        end
      end
    end
    #--------------------------------------------------------------------------
    # 上書きする
    save_data(map, sprintf("Data/Map%03d.rxdata", map_id))
    maplist  = load_data("Data/MapInfos.rxdata")
=begin    
    # ミラーマップに別名保存する
    mapinfo = RPG::MapInfo.new
    mapinfo.name = sprintf("ミラーマップ", maplist[map_id].name)
    mapinfo.parent_id = 0
    mapinfo.order = 998
    mapinfo.expanded = true
    mapinfo.scroll_x = 0
    mapinfo.scroll_y = 0
    
    maplist[998]=mapinfo
    save_data(maplist,"Data/MapInfos.rxdata")
=end
  end
  #--------------------------------------------------------------------------
  # ● マップデータの反転
  #--------------------------------------------------------------------------
  def self.map_mirror_save(map_id)
    
    map = load_data(sprintf("Data/Map%03d.rxdata", map_id))
    #--------------------------------------------------------------------------
    # 配置しているタイル位置を左右反転させる
    #--------------------------------------------------------------------------
    # タイル用テーブルを作る
    tile_table = Table.new(map.width, map.height, 3)
    
    # 教会用のみの対応。壁と矢印のみ。
    # おそらくオートタイルが380くらいまであって、そこから通常タイルが出てくる。
=begin    
    # タイル番号出力用
    p ["左上",map.data[39,6,0]]
    p ["左中",map.data[39,7,0]]
    p ["左下",map.data[39,8,0]]
    p ["右上",map.data[41,6,0]]
    p ["右中",map.data[41,7,0]]
    p ["右下",map.data[41,8,0]]
    p ["左",map.data[7,9,1]]
    p ["右",map.data[7,8,1]]
    p ["上",map.data[15,13,1]]
    p ["下",map.data[29,14,1]]
    exit
=end    
    for x in 0...map.width
      for y in 0...map.height
        for z in 0..2
          tile_table[x,y,z] = 
           case map.data[map.width - x - 1,y,z]
           # 矢印左右
           when 389;391
           when 391;389
           # 天井角左右
           when 403;404
           when 404;403
           when 411;412
           when 412;411
           # 壁系左→右
           when 400,408,416,424,432,440
             map.data[map.width - x - 1,y,z] + 2
           # 壁系右→左
           when 402,410,418,426,434,442
             map.data[map.width - x - 1,y,z] - 2
           else
             map.data[map.width - x - 1,y,z]
           end
        end
      end
    end
    # 完成したマップデータを移す
    map.data = tile_table
    #--------------------------------------------------------------------------
    # 配置しているイベント位置を左右反転させる
    #--------------------------------------------------------------------------
    for i in map.events.keys
      map.events[i].x = map.width - map.events[i].x - 1
      # 左へ移動を右へ移動に、右へ移動を左へ移動に
      for page in map.events[i].pages
        for list in page.list
          # 移動ルートの設定の場合
          if list.code == 209
            for move_list in list.parameters[1].list
              case move_list.code
              when 2; move_list.code = 3
              when 3; move_list.code = 2
              end
            end
          end
        end
      end
    end
    #--------------------------------------------------------------------------
    save_data(map, sprintf("Data/Map%03d.rxdata", 998))
    maplist  = load_data("Data/MapInfos.rxdata")
    
    mapinfo = RPG::MapInfo.new
    mapinfo.name = sprintf("ミラーマップ", maplist[map_id].name)
    mapinfo.parent_id = 0
    mapinfo.order = 998
    mapinfo.expanded = true
    mapinfo.scroll_x = 0
    mapinfo.scroll_y = 0
    
    maplist[998]=mapinfo
    save_data(maplist,"Data/MapInfos.rxdata")
  end
  
  

  
  
end

