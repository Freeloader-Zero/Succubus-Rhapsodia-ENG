#==============================================================================
# ■ Resist_Game
#------------------------------------------------------------------------------
# ★レジストゲーム(矢印押しゲーム)を行う
#==============================================================================
class Resist_Game < Window_Base
  #--------------------------------------------------------------------------
  # ● 公開インスタンス変数
  #--------------------------------------------------------------------------
    attr_accessor   :win                    # ゲームウィンドウ
    attr_accessor   :text                   # テキスト描画用
    attr_accessor   :test_i                 # なんでも変数(テスト用)
    attr_accessor   :test_y                 # なんでも変数(テスト用)
    
    attr_accessor   :max                    # 矢印の 最大個数
    attr_accessor   :target                 # 矢印の 現在操作中の番号
    attr_accessor   :yajirusi_bitmap        # 矢印の 画像(配列)
    attr_accessor   :yajirusi_sprite        # 矢印の 描画用(配列)
    attr_accessor   :yajirusi_list          # 矢印の 制御(配列)
    attr_accessor   :set_x                  # 表示位置Ｘ座標
    attr_accessor   :set_y                  # 表示位置Ｙ座標
    attr_accessor   :bar_bitmap             # 制限時間バー描画用
    attr_accessor   :bar_sprite             # 制限時間バー描画用
    attr_accessor   :success_bitmap         # 成功判定描画用
    
    attr_accessor   :wait_count             # ウェイトカウント
    attr_accessor   :time_count             # タイムカウント
    attr_accessor   :limit_count            # リミット(制限時間)カウント
    attr_accessor   :limit_count_max        # リミット(制限時間)最大値
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  #  ・矢印の向きは0~3の数値で表す。(0↓ 1→ 2↑ 3←)
  #  ・矢印を表示する配列の変数は1から始まる。(個数を分かりやすくするため)
  #--------------------------------------------------------------------------
  def initialize(yajirusi_max = 10, type = 1, time = 4, impossible = false)

    # 変数の初期化
    @wait_count = 0
    @time_count = 0
    
    case time
    when 0 #猶予なし
      n = 48
    when 1 #標準
      n = 60
    when 2 #猶予あり
      n = 88
    when 3 #接待モード
      n = 144
    else
      n = 72
    end
    if $game_temp.resistgame_timer != nil
      @limit_count_max = $game_temp.resistgame_timer
      #１回適用するごとに必ず無効化する
      $game_temp.resistgame_timer = nil
    else
      @limit_count_max = n
    end
    @limit_count = @limit_count_max
    @impossible = impossible
    @impossible = $game_switches[182]
    @max = yajirusi_max # 初期値は10個。呼ぶ時に任意の数にできる(1個以上)
    @target = 1
    @set_x = 0          # ウィンドウと矢印の座標を連動させる用
    @set_y = -30
    @yajirusi_bitmap = []
    @yajirusi_sprite = []
    #@yajirusi_list = []

    #文字列
    @text = Sprite.new
    @text.bitmap = Bitmap.new(640,480)
    
    @test_i = 0
    @test_y = 0

    # ビットマップの準備 (画像を読み込む)
    # メモリ節約のため、一旦「RPG::Cache」を噛ませてセットする
    # ↓2回目以降呼ぶ時は画像ファイルを参照しないので軽くなる(で合ってる？)
    @yajirusi_bitmap[1] = RPG::Cache.picture("yajirusi_black")
    @yajirusi_bitmap[2] = RPG::Cache.picture("yajirusi_blue")
    @yajirusi_bitmap[3] = RPG::Cache.picture("yajirusi_red") # 勝手に作った
    @yajirusi_bitmap[4] = RPG::Cache.picture("yajirusi_white")
    # バックウィンドウ
    @yajirusi_bitmap[5] = RPG::Cache.picture("window_resist")
    @yajirusi_bitmap[6] = RPG::Cache.picture("window_attack")
    
    # スプライトの初期化
    # 配列の0番目がもったいないのでバックウィンドウをセットする
    @yajirusi_sprite[0] = Sprite.new
    @yajirusi_sprite[0].x = @set_x 
    @yajirusi_sprite[0].y = @set_y
    @yajirusi_sprite[0].z = 1
    # バックウィンドウの種類選択 [5]か[6]
    if type == 0 
      back_window = yajirusi_bitmap[5]
    else
      back_window = yajirusi_bitmap[6]
    end
    @yajirusi_sprite[0].bitmap = back_window
    @yajirusi_sprite[0].visible = true
    @yajirusi_sprite[0].opacity = 0
    
    # 矢印の最大数までセットする(max)
    for i in 1..max
      @yajirusi_sprite[i] = Sprite.new
      @yajirusi_sprite[i].x = @set_x + 117 + (45 * (i - 1)) # 並べて配置
      @yajirusi_sprite[i].y = @set_y + 264
      @yajirusi_sprite[i].z = 1
      @yajirusi_sprite[i].ox = 22   # x軸の中心点をセット(44 * 44)
      @yajirusi_sprite[i].oy = 22   # y軸の中心点をセット(44 * 44)
      @yajirusi_sprite[i].angle = (rand(4) * 90)  # 0~3の値(矢印の向き)を取得
      @yajirusi_sprite[i].bitmap = yajirusi_bitmap[1] # 矢印の初期状態(黒)
      @yajirusi_sprite[i].visible = true
      @yajirusi_sprite[i].opacity = 0
    end
    
    unless @impossible
      @yajirusi_sprite[1].bitmap = yajirusi_bitmap[4] # 1つ目の矢印の色を変える
    end
    
    # 制限時間バーをセット
    @bar_bitmap = Bitmap.new(200,5)
    # スプライト
    @bar_sprite = Sprite.new
    @bar_sprite.bitmap = @bar_bitmap
    @bar_sprite.x = @set_x + 220
    @bar_sprite.y = @set_y + 300
    @bar_sprite.z = 1
    @bar_sprite.visible = true

    @success_bitmap = []
    
    # 成否判定をセット
    for i in 0..3
      @success_bitmap[i] = Sprite.new
      @success_bitmap[i].x = @set_x + 220
      @success_bitmap[i].y = @set_y + 218
      @success_bitmap[i].z = 1
      @success_bitmap[i].bitmap = Bitmap.new(200,64)
      @success_bitmap[i].visible = true
      @success_bitmap[i].opacity = 0
      @success_bitmap[i].bitmap.font.name = ["小塚明朝 Pro B", "HGP行書体", "メイリオ"]
      @success_bitmap[i].bitmap.font.size = 28
    end
    
    @success_bitmap[0].bitmap.draw_text(0, 0, 200, 30, "Success!", 1)
    @success_bitmap[1].bitmap.draw_text(0, 0, 200, 30, "failure...", 1)
    @success_bitmap[2].bitmap.draw_text(0, 0, 200, 30, "Acceptance！", 1)
    @success_bitmap[3].bitmap.draw_text(0, 0, 200, 30, "Dissuade...！", 1)
    
  end
  #--------------------------------------------------------------------------
  # ● 一時隠し/出現
  #--------------------------------------------------------------------------  
  def hide
    @bar_sprite.visible = false
    @text.visible = false
    for i in 0..max
      @yajirusi_sprite[i].visible = false
    end
    for i in 0..3
      @success_bitmap[i].visible = false
    end
  end
  def appear
    @bar_sprite.visible = true
    @text.visible = true
    for i in 0..max
      @yajirusi_sprite[i].visible = true
    end
    for i in 0..3
      @success_bitmap[i].visible = true
    end
  end
  #--------------------------------------------------------------------------
  # ● 本体
  #--------------------------------------------------------------------------
  def game_start
    unless $game_temp.resistgame_flag >= 3
      # フェードイン処理
      for i in 0..@yajirusi_sprite.size - 1
        if @yajirusi_sprite[i].opacity < 255
          @yajirusi_sprite[i].opacity += 70
          return
        end
      end

      # クリア条件を満たすか、時間切れで終わる
      if $game_temp.resistgame_clear == true # クリアした
        # SE を演奏
        Audio.se_play("Audio/SE/055-Right01", 80, 100)
        $game_temp.resistgame_flag = 3
    
      elsif @limit_count <= 0 #失敗した(時間切れ)
        if $game_switches[89] == true
          # SE を演奏
          Audio.se_play("Audio/SE/AC_Heal7", 80, 70)
          $game_temp.resistgame_flag = 3
        else
          # SE を演奏
          Audio.se_play("Audio/SE/058-Wrong02", 80, 100)
          $game_temp.resistgame_flag = 3
        end
        
      else
        # 抵抗不可以外の場合はメイン処理
        unless @impossible
          
          if @wait_count <= 0
            #ペナルティの解けた矢印をの色を戻す
            @yajirusi_sprite[@target].bitmap = yajirusi_bitmap[4] #白
          end
    
          # angleの角度で向きを判断する(0度↓ 90度→ 180度↑ 270度←)
          dir = 0
          case @yajirusi_sprite[@target].angle
          when 0 then   #↓
            dir = Input::DOWN
          when 90 then  #→
            dir = Input::RIGHT
          when 180 then #↑
            dir = Input::UP
          when 270 then #←
            dir = Input::LEFT
          end
        
          # 成功判定 (target番目の矢印キーを押せたか)
          # 方向キーを押した時にだけ判定する
          # かつ、ミスペナルティ中は操作を受け付けない
          if (Input.trigger?(Input::DOWN)   \
            || Input.trigger?(Input::RIGHT) \
            || Input.trigger?(Input::UP)    \
            || Input.trigger?(Input::LEFT)) \
            && @wait_count <= 0
           
            if Input.trigger?(dir)
              # 成功
              # 成功した矢印の色を変える
              @yajirusi_sprite[@target].bitmap = yajirusi_bitmap[3] #青
              # SE を演奏
              Audio.se_play("Audio/SE/002-System02", 80, 100)
              # 次の矢印に進む
              @target += 1
              #最後まで押しきったらゲームクリア
              if @target > max
                $game_temp.resistgame_clear = true
              else
                #まだ残っていれば対象の矢印の色を変える
                @yajirusi_sprite[@target].bitmap = yajirusi_bitmap[4] #白
              end
            else
            #ミス
            # SE を演奏
            Audio.se_play("Audio/SE/057-Wrong01", 80, 100)
            # 操作不能時間を設定
            @wait_count = 10
            @limit_count -= 0
            # 一定時間 矢印の色を変える
            @yajirusi_sprite[@target].bitmap = yajirusi_bitmap[2] #赤
            end
          end
          # キャンセルキーを押すと抵抗しない
          if Input.trigger?(Input::B)
            # SE を演奏
            Audio.se_play("Audio/SE/004-System04", 80, 100)
            @wait_count = 10
            @limit_count -= 200
            $game_switches[89] = true if $game_switches[89] == false
          end
        else
          if Input.trigger?(Input::DOWN)   \
            || Input.trigger?(Input::RIGHT) \
            || Input.trigger?(Input::UP)    \
            || Input.trigger?(Input::LEFT) \
            && @wait_count <= 0
            # SE を演奏
            Audio.se_play("Audio/SE/004-System04", 80, 100)
          end
          # キャンセルキーを押すと抵抗しない
          if Input.trigger?(Input::B)
            # SE を演奏
            Audio.se_play("Audio/SE/004-System04", 80, 100)
            @wait_count = 10
            @limit_count -= 100
            $game_switches[89] = true if $game_switches[89] == false
          end

        end
      end
      
    
      @bar_bitmap.clear
      #リミット(制限時間)バーを描画
      @bar_bitmap.fill_rect(0,0,@limit_count * @bar_sprite.bitmap.width / @limit_count_max,5, \
                          Color.new(255,255,255,255))
      @bar_sprite.bitmap = @bar_bitmap

      #--デバッグ用メモ置き場----------------------------------------
      
      #フレーム確認用
      #@text.bitmap.clear
      #@text.bitmap.draw_text(10, 450, 640, 30, @limit_count.to_s)

      #キー取得メモ
      #Input.trigger?(Input::UP)
      
      for i in 1..max
        #@yajirusi_sprite[i].visible = true
      end
    
      #@yajirusi_sprite[1].angle = @test_i
      @test_i += 3
      if @test_i > 360
        @test_i = 0
      end
      #---------------------------------------------------------------
    
      #カウントアップ･ダウン
      @time_count += 1
      @limit_count -= 1

    end

  
    # 成否判定描画
    
    if $game_temp.resistgame_flag == 3
      if $game_temp.resistgame_clear == true
        if @success_bitmap[0].opacity < 255
          @success_bitmap[0].opacity += 30
        end
        if @success_bitmap[0].y > @set_y + 210
          @success_bitmap[0].y -= 1
          return
        end
      else
        #キャンセルした場合
        if $game_switches[89] == true
          #アクターから仕掛けてキャンセルした場合
          if $game_temp.battle_active_battler.is_a?(Game_Actor) and
            not $game_switches[79] == true #トーク中は視点が逆になる
            if @success_bitmap[3].opacity < 255
              @success_bitmap[3].opacity += 30
            end
            if @success_bitmap[3].y > @set_y + 210
              @success_bitmap[3].y -= 1
              return
            end
          #エネミーから仕掛けられて受け入れた場合
          else
            if @success_bitmap[2].opacity < 255
              @success_bitmap[2].opacity += 30
            end
            if @success_bitmap[2].y > @set_y + 210
              @success_bitmap[2].y -= 1
              return
            end
          end
#          $game_switches[89] = false
        else
          if @success_bitmap[1].opacity < 255
            @success_bitmap[1].opacity += 30
          end
          if @success_bitmap[1].y > @set_y + 210
            @success_bitmap[1].y -= 1
            return
          end
        end
      end
      @wait_count = 20
      $game_temp.resistgame_flag = 4
    end
    
    
    # フェードアウト処理
    if $game_temp.resistgame_flag == 4 and @wait_count == 0
      yazirusi_max = @yajirusi_sprite.size - 1
      for i in 0..max
        if @yajirusi_sprite[i].opacity > 0
          @yajirusi_sprite[i].opacity -= 51
        end
      end
      if $game_temp.resistgame_clear == true
        if @success_bitmap[0].opacity > 0
          @success_bitmap[0].opacity -= 51
        end
      else
        if @success_bitmap[1].opacity > 0
          @success_bitmap[1].opacity -= 51
        end
        if @success_bitmap[2].opacity > 0
          @success_bitmap[2].opacity -= 51
        end
      end
      
      if @yajirusi_sprite[yazirusi_max].opacity == 0
        $game_temp.resistgame_flag = -1
      else
        return
      end
    end

  

    @wait_count -= 1

  end
  #--------------------------------------------------------------------------
  # ● フレーム更新
  #--------------------------------------------------------------------------
  def update
    
  end
  #--------------------------------------------------------------------------
  # ● 解放
  #--------------------------------------------------------------------------
  def dispose
    for i in 0..max #配列の最後までループ
      @yajirusi_sprite[i].dispose
    end
    for i in 0..3 #配列の最後までループ
      @success_bitmap[i].dispose
    end
    @text.dispose
    @bar_bitmap.dispose
  end
end