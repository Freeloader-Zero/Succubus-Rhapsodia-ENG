#==============================================================================
# ■ Game_BattlerHold
#------------------------------------------------------------------------------
#　バトラーのホールド情報を扱うクラスです。
#==============================================================================

class Game_BattlerHold
  #--------------------------------------------------------------------------
  # ● 公開インスタンス変数
  #--------------------------------------------------------------------------
  attr_accessor :mouth                      # 口
  attr_accessor :tops                       # 上半身
  attr_accessor :penis                      # ペニス
  attr_accessor :vagina                     # アソコ
  attr_accessor :anal                       # アナル
  attr_accessor :tail                       # 尻尾
  attr_accessor :tentacle                   # 触手
  attr_accessor :dildo                      # ディルド
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  def initialize
    @mouth    = Game_BattlerHold_Data.new
    @tops     = Game_BattlerHold_Data.new
    @penis    = Game_BattlerHold_Data.new
    @vagina   = Game_BattlerHold_Data.new
    @anal     = Game_BattlerHold_Data.new 
    @tail     = Game_BattlerHold_Data.new
    @tentacle = Game_BattlerHold_Data.new
    @dildo    = Game_BattlerHold_Data.new
  end
  #--------------------------------------------------------------------------
  # ● パーツ名の出力
  #--------------------------------------------------------------------------
  def parts_names
    box = []
    box.push("mouth")
    box.push("tops")
    box.push("penis")
    box.push("vagina")
    box.push("anal")
    box.push("tail")
    box.push("tentacle")
    box.push("dildo")
    return box
  end
  #--------------------------------------------------------------------------
  # ● ホールド状況の出力
  #--------------------------------------------------------------------------
  def hold_output
    reslut = []
    self_parts = [@mouth, @tops, @penis, @vagina, @anal, @tail, @tentacle, @dildo]
    for one in self_parts
      if one.type != nil
        reslut.push([one.battler, one.parts, one.type, one.initiative])
      end
    end
    return reslut
  end
  #--------------------------------------------------------------------------
  # ● イニシアチブをとっているか？
  #--------------------------------------------------------------------------
  def initiative?
    self_parts = [@mouth, @tops, @penis, @vagina, @anal, @tail, @tentacle, @dildo]
    result_number = 0
    for one in self_parts
      if one.type != nil
        result_number += one.initiative
      end
    end
    return (result_number > 0)
  end
  #--------------------------------------------------------------------------
  # ● 現在のイニシアチブレベル
  #--------------------------------------------------------------------------
  def initiative_level
    self_parts = [@mouth, @tops, @penis, @vagina, @anal, @tail, @tentacle, @dildo]
    result_box = [0]
    for one in self_parts
      if one.type != nil
        result_box.push(one.initiative)
      end
    end
    return (result_box.max)
  end
end

#==============================================================================
# ■ Game_BattlerHold_Data
#------------------------------------------------------------------------------
#　ホールドの詳細情報を扱うクラスです。
#==============================================================================

class Game_BattlerHold_Data
  #--------------------------------------------------------------------------
  # ● 公開インスタンス変数
  #--------------------------------------------------------------------------
  attr_accessor :battler                # 連結している相手
  attr_accessor :parts                  # 連結している箇所
  attr_accessor :type                   # 連結している方法
  attr_accessor :initiative             # 連結時の有利不利
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  def initialize
    @battler = nil
    @parts = nil
    @type = nil
    @initiative = nil
  end
  #--------------------------------------------------------------------------
  # ● 設定
  #--------------------------------------------------------------------------
  def set(battler, parts, type, initiative)
    @battler = battler
    @parts = parts
    @type = type
    @initiative = initiative
  end
  #--------------------------------------------------------------------------
  # ● クリア
  #--------------------------------------------------------------------------
  def clear
    @battler = nil
    @parts = nil
    @type = nil
    @initiative = nil
  end
  
end


class Scene_Battle
  #--------------------------------------------------------------------------
  # ● ホールドの解除
  # owner  : 解除するバトラー
  # target : 設定した場合、解除相手はこのバトラーのみにする
  # type   : １以上の場合、絶頂時用になる
  #--------------------------------------------------------------------------
  def hold_release(owner, target = nil, type = 0)
    # パーツ名を取得する
    owner_parts = owner.hold.parts_names
    # 各パーツごとに確認
    for o_parts_one in owner_parts
      # パーツ情報を変数に入れる
      checking_parts = eval("owner.hold.#{o_parts_one}")
      # このパーツが占有中の場合
      if checking_parts.battler != nil
        # ホールド相手を変数に入れる
        hold_target = checking_parts.battler
        # ホールド対象がtargetの場合、解除を行う
        if hold_target == target or target == nil
          # ホールド相手側の対応パーツ配列を確認する
          target_parts_names = SR_Util.holding_parts_name(checking_parts.type, o_parts_one)
          # 対応パーツごとにチェック
          for t_parts_one in target_parts_names
            # 対応パーツ情報を変数に入れる
            checking_target_parts = eval("hold_target.hold.#{t_parts_one}")
            # 解除を行う
            checking_parts.clear
            checking_target_parts.clear
            # 絶頂時用はアニメやスキルコレクトの初期化を行う
            if type >= 1
              hold_target.animation_id = 7
              hold_target.animation_hit = true
              hold_target.graphic_change = true
              hold_target.skill_collect = nil if hold_target.is_a?(Game_Actor)
              hold_target.add_state(12) if hold_target.is_a?(Game_Enemy)
            end
          end
        end
        #-----------------------------------------------------------------------------
      end
    end
    # 絶頂時用はアニメやスキルコレクトの初期化を行う
    if type >= 1
      owner.animation_id = 7
      owner.animation_hit = true
      owner.graphic_change = true
      owner.skill_collect = nil if owner.is_a?(Game_Actor)
      owner.add_state(12) if owner.is_a?(Game_Enemy)
    end
  end
  #--------------------------------------------------------------------------
  # ● ホールドの付与
  #--------------------------------------------------------------------------
  def add_hold(skill, active, target)
    #ホールド付与(解除)が発生した場合、一時的にスキルコレクトをnilに戻す
    active.skill_collect = nil if active.is_a?(Game_Actor)
    target.skill_collect = nil if target.is_a?(Game_Actor)
    case skill.name
    #スキル名で判断して付与。スキル名を変更した場合はその都度調整すること。
    when "インサート" # 〆
      active.hold.penis.set(target, "アソコ", "♀挿入", 2)
      target.hold.vagina.set(active, "ペニス", "♀挿入", 0)
    when "アクセプト" # 〆
      active.hold.vagina.set(target, "ペニス", "♀挿入", 2)
      target.hold.penis.set(active, "アソコ", "♀挿入", 0)
    when "オーラルアクセプト" # 〆
      active.hold.mouth.set(target, "ペニス", "口挿入", 2)
      target.hold.penis.set(active, "口", "口挿入", 0)
    when "オーラルインサート" # 〆 
      active.hold.penis.set(target, "口", "口挿入", 2)
      target.hold.mouth.set(active, "ペニス", "口挿入" , 0)
    when "ドロウネクター" # 〆
      active.hold.mouth.set(target, "アソコ", "クンニ", 2)
      target.hold.vagina.set(active, "口", "クンニ", 0)
    when "フラッタナイズ" 
      active.hold.mouth.set(target, "口", "キッス", 2)
      target.hold.mouth.set(active, "口", "キッス", 0)
    when "バックインサート"
      active.hold.penis.set(target, "アソコ", "尻挿入", 2)
      target.hold.anal.set(active, "アナル", "尻挿入", 0)
    when "バックアクセプト"
      active.hold.anal.set(target, "ペニス", "尻挿入", 2)
      target.hold.penis.set(active, "アナル", "尻挿入", 0)
    when "エキサイトビュー" # 〆
      active.hold.vagina.set(target, "口", "顔面騎乗", 2)
      target.hold.mouth.set(active, "アソコ", "顔面騎乗", 0)
    when "インモラルビュー" 
      active.hold.anal.set(target, "口", "尻騎乗", 2)
      target.hold.mouth.set(active, "アナル", "尻騎乗" , 0)
    when "エンブレイス" # 〆
      active.hold.tops.set(target, "上半身", "拘束", 2)
      target.hold.tops.set(active, "上半身", "拘束", 0)
    when "エキシビジョン"
      active.hold.tops.set(target, "上半身", "開脚", 2)
      target.hold.tops.set(active, "上半身", "開脚", 0)
    when "ペリスコープ" # 〆
      active.hold.tops.set(target, "ペニス", "パイズリ", 2)
      target.hold.penis.set(active, "上半身", "パイズリ", 0)
    when "ヘブンリーフィール"
      active.hold.tops.set(target, "口", "ぱふぱふ", 2)
      target.hold.mouth.set(active, "上半身", "ぱふぱふ", 0)
    when "シェルマッチ" # 〆
      active.hold.vagina.set(target, "アソコ", "貝合わせ", 2)
#      active.hold.anal.set(target, "アナル", "貝合わせ", 2)
      target.hold.vagina.set(active, "アソコ", "貝合わせ", 0)
#      active.hold.anal.set(active, "アナル", "貝合わせ", 0)
    when "インサートテイル"
      active.hold.tail.set(target, "アソコ", "♀挿入", 2)
      target.hold.vagina.set(active, "尻尾", "♀挿入", 0)
    when "マウスインテイル"
      active.hold.tail.set(target, "アソコ", "口挿入", 2)
      target.hold.mouth.set(active, "尻尾", "口挿入", 0)
    when "バックインテイル"
      active.hold.tail.set(target, "アソコ", "尻挿入", 2)
      target.hold.anal.set(active, "尻尾", "尻挿入", 0)
    when "ディルドインサート" # 〆
      active.hold.dildo.set(target, "アソコ", "ディルド♀挿入", 2)
      target.hold.vagina.set(active, "ディルド", "ディルド♀挿入", 0)
    when "ディルドインマウス" # 〆
      active.hold.dildo.set(target, "口", "ディルド口挿入", 2)
      target.hold.mouth.set(active, "ディルド", "ディルド口挿入", 0)
    when "ディルドインバック" # 〆
      active.hold.dildo.set(target, "アナル", "ディルド尻挿入", 2)
      target.hold.anal.set(active, "ディルド", "ディルド尻挿入", 0)
    when "インサートテンタクル"
      active.hold.tentacle.set(target, "アソコ", "♀挿入", 2)
      target.hold.vagina.set(active, "触手", "♀挿入", 0)
    when "マウスインテンタクル"
      active.hold.tentacle.set(target, "アソコ", "口挿入", 2)
      target.hold.mouth.set(active, "触手", "口挿入", 0)
    when "バックインテンタクル"
      active.hold.tentacle.set(target, "アソコ", "尻挿入", 2)
      target.hold.anal.set(active, "触手", "尻挿入", 0)
    when "テンタクルバンデージ"
      active.hold.tentacle.set(target, "上半身", "拘束", 2)
      target.hold.tops.set(active, "触手", "拘束", 0)
    when "インサルトツリー"
      active.hold.tentacle.set(target, "上半身", "開脚", 2)
      target.hold.tops.set(active, "触手", "開脚", 0)
    when "アイヴィクローズ" # 〆
      active.hold.tentacle.set(target, "上半身", "蔦拘束", 2)
      target.hold.tops.set(active, "触手", "蔦拘束", 0)
    when "デモンズクローズ" # 〆
      active.hold.tentacle.set(target, "上半身", "触手拘束", 2)
      target.hold.tops.set(active, "触手", "触手拘束", 0)
    when "デモンズアブソーブ" # 〆
      active.hold.tentacle.set(target, "ペニス", "触手吸引", 2)
      target.hold.penis.set(active, "触手", "触手吸引", 0)
    when "デモンズドロウ" # 〆
      active.hold.tentacle.set(target, "アソコ", "触手クンニ", 2)
      target.hold.vagina.set(active, "触手", "触手クンニ", 0)
    #解除スキル
    when "リリース"
      #解除対象にホールドリキャストを付与する
      target.add_state(12) if target.is_a?(Game_Enemy)
      # ホールドの解除（下の記述をメソッドに簡略化）
      hold_release(target, active)
=begin
      #●ペニス解除
      if target.hold.penis.battler == active
        case target.hold.penis.type
        when "♀挿入"
          active.hold.vagina.set(nil, nil, nil, nil)
        when "口挿入"
          active.hold.mouth.set(nil, nil, nil, nil)
        when "尻挿入"
          active.hold.anal.set(nil, nil, nil, nil)
        when "パイズリ"
          active.hold.tops.set(nil, nil, nil, nil)
        when "触手吸引"
          active.hold.tentacle.set(nil, nil, nil, nil)
        end
        target.hold.penis.set(nil, nil, nil, nil)
      #●アソコ解除
      elsif target.hold.vagina.battler == active
        case target.hold.vagina.type
        when "♀挿入"
          case target.hold.vagina.parts
          when "ペニス"
            active.hold.penis.set(nil, nil, nil, nil)
          when "尻尾"
            active.hold.tail.set(nil, nil, nil, nil)
          when "触手"
            active.hold.tentacle.set(nil, nil, nil, nil)
          end
        when "顔面騎乗"
          active.hold.mouth.set(nil, nil, nil, nil)
        when "貝合わせ"
          active.hold.vagina.set(nil, nil, nil, nil)
          active.hold.anal.set(nil, nil, nil, nil)
          target.hold.anal.set(nil, nil, nil, nil)
        when "クンニ"
          active.hold.mouth.set(nil, nil, nil, nil)
        when "触手クンニ"
          active.hold.tentacle.set(nil, nil, nil, nil)
        when "ディルド♀挿入"
          active.hold.dildo.set(nil, nil, nil, nil)
        end
        target.hold.vagina.set(nil, nil, nil, nil)
      #●口解除
      elsif target.hold.mouth.battler == active
        case target.hold.mouth.type
        when "口挿入"
          case target.hold.mouth.parts
          when "ペニス"
            active.hold.penis.set(nil, nil, nil, nil)
          when "尻尾"
            active.hold.tail.set(nil, nil, nil, nil)
          when "触手"
            active.hold.tentacle.set(nil, nil, nil, nil)
          end
        when "顔面騎乗"
          active.hold.vagina.set(nil, nil, nil, nil)
        when "尻騎乗"
          active.hold.anal.set(nil, nil, nil, nil)
        when "クンニ"
          active.hold.vagina.set(nil, nil, nil, nil)
        when "キッス"
          active.hold.mouth.set(nil, nil, nil, nil)
        when "ディルド口挿入"
          active.hold.dildo.set(nil, nil, nil, nil)
        end
        target.hold.mouth.set(nil, nil, nil, nil)
      #●アナル解除
      elsif target.hold.anal.battler == active
        case target.hold.anal.type
        when "尻挿入"
          case target.hold.anal.parts
          when "ペニス"
            active.hold.penis.set(nil, nil, nil, nil)
          when "尻尾"
            active.hold.tail.set(nil, nil, nil, nil)
          when "触手"
            active.hold.tentacle.set(nil, nil, nil, nil)
          end
        when "尻騎乗"
          active.hold.mouth.set(nil, nil, nil, nil)
        when "ディルド尻挿入"
          active.hold.dildo.set(nil, nil, nil, nil)
        end
        target.hold.anal.set(nil, nil, nil, nil)
      #●上半身解除
      elsif target.hold.tops.battler == active
        case target.hold.tops.type
        when "パイズリ"
          active.hold.penis.set(nil, nil, nil, nil)
        when "ぱふぱふ"
          active.hold.mouth.set(nil, nil, nil, nil)
        when "触手拘束","蔦拘束"
          active.hold.tentacle.set(nil, nil, nil, nil)
        else
          active.hold.tops.set(nil, nil, nil, nil)
        end
        target.hold.tops.set(nil, nil, nil, nil)
      #●尻尾解除
      elsif target.hold.tail.battler == active
        case target.hold.tail.type
        when "♀挿入"
          active.hold.vagina.set(nil, nil, nil, nil)
        when "口挿入"
          active.hold.mouth.set(nil, nil, nil, nil)
        when "尻挿入"
          active.hold.anal.set(nil, nil, nil, nil)
        end
        target.hold.tail.set(nil, nil, nil, nil)
      #●触手解除
      elsif target.hold.tentacle.battler == active
        case target.hold.tentacle.type
        when "触手吸引"
          active.hold.penis.set(nil, nil, nil, nil)
        when "触手♀挿入","触手クンニ"
          active.hold.vagina.set(nil, nil, nil, nil)
        when "触手口挿入"
          active.hold.mouth.set(nil, nil, nil, nil)
        when "触手尻挿入"
          active.hold.anal.set(nil, nil, nil, nil)
        when "触手拘束","蔦拘束","触手開脚"
          active.hold.tops.set(nil, nil, nil, nil)
        end
        target.hold.tentacle.set(nil, nil, nil, nil)
      #●ディルド解除
      elsif target.hold.dildo.battler == active
        case target.hold.dildo.type
        when "ディルド♀挿入"
          active.hold.vagina.set(nil, nil, nil, nil)
        when "ディルド口挿入"
          active.hold.mouth.set(nil, nil, nil, nil)
        when "ディルド尻挿入"
          active.hold.anal.set(nil, nil, nil, nil)
        end
        target.hold.dildo.set(nil, nil, nil, nil)
      end
=end
    when "インタラプト"
      #解除対象にホールドリキャストを付与する
      target.add_state(12) if target.is_a?(Game_Enemy)
      if active == $game_actors[101]
        for i in $game_party.actors
          if i != $game_actors[101]
            hold_actor = i
          end
        end
      else
        hold_actor = $game_actors[101]
      end
      #ホールドアクターのスキルコレクトも解除
      hold_actor.skill_collect = nil if hold_actor.is_a?(Game_Actor)
      # ホールドの解除（下の記述をメソッドに簡略化）
      hold_release(target, hold_actor)
=begin
      #●ペニス解除
      if target.hold.penis.battler == hold_actor
        case target.hold.penis.type
        when "♀挿入"
          hold_actor.hold.vagina.set(nil, nil, nil, nil)
        when "口挿入"
          hold_actor.hold.mouth.set(nil, nil, nil, nil)
        when "尻挿入"
          hold_actor.hold.anal.set(nil, nil, nil, nil)
        when "パイズリ"
          hold_actor.hold.tops.set(nil, nil, nil, nil)
        when "触手吸引"
          hold_actor.hold.tentacle.set(nil, nil, nil, nil)
        end
        target.hold.penis.set(nil, nil, nil, nil)
      #●アソコ解除
      elsif target.hold.vagina.battler == hold_actor
        case target.hold.vagina.type
        when "♀挿入"
          case target.hold.vagina.parts
          when "ペニス"
            hold_actor.hold.penis.set(nil, nil, nil, nil)
          when "尻尾"
            hold_actor.hold.tail.set(nil, nil, nil, nil)
          when "触手"
            hold_actor.hold.tentacle.set(nil, nil, nil, nil)
          when "ディルド"
            hold_actor.hold.dildo.set(nil, nil, nil, nil)
          end
        when "顔面騎乗"
          hold_actor.hold.mouth.set(nil, nil, nil, nil)
        when "貝合わせ"
          hold_actor.hold.vagina.set(nil, nil, nil, nil)
          hold_actor.hold.anal.set(nil, nil, nil, nil)
          target.hold.anal.set(nil, nil, nil, nil)
        when "クンニ"
          hold_actor.hold.mouth.set(nil, nil, nil, nil)
        when "触手クンニ"
          hold_actor.hold.tentacle.set(nil, nil, nil, nil)
        end
        target.hold.vagina.set(nil, nil, nil, nil)
      #●口解除
      elsif target.hold.mouth.battler == hold_actor
        case target.hold.mouth.type
        when "口挿入"
          case target.hold.mouth.parts
          when "ペニス"
            hold_actor.hold.penis.set(nil, nil, nil, nil)
          when "尻尾"
            hold_actor.hold.tail.set(nil, nil, nil, nil)
          when "触手"
            hold_actor.hold.tentacle.set(nil, nil, nil, nil)
          when "ディルド"
            hold_actor.hold.dildo.set(nil, nil, nil, nil)
          end
        when "ディルド口挿入"
          hold_actor.hold.dildo.set(nil, nil, nil, nil)
        when "顔面騎乗"
          hold_actor.hold.vagina.set(nil, nil, nil, nil)
        when "尻騎乗"
          hold_actor.hold.anal.set(nil, nil, nil, nil)
        when "クンニ"
          hold_actor.hold.vagina.set(nil, nil, nil, nil)
        when "キッス"
          hold_actor.hold.mouth.set(nil, nil, nil, nil)
        end
        target.hold.mouth.set(nil, nil, nil, nil)
      #●アナル解除
      elsif target.hold.anal.battler == hold_actor
        case target.hold.anal.type
        when "尻挿入"
          case target.hold.anal.parts
          when "ペニス"
            hold_actor.hold.penis.set(nil, nil, nil, nil)
          when "尻尾"
            hold_actor.hold.tail.set(nil, nil, nil, nil)
          when "触手"
            hold_actor.hold.tentacle.set(nil, nil, nil, nil)
          when "ディルド"
            hold_actor.hold.dildo.set(nil, nil, nil, nil)
          end
        when "ディルド尻挿入"
          hold_actor.hold.dildo.set(nil, nil, nil, nil)
        when "尻騎乗"
          hold_actor.hold.mouth.set(nil, nil, nil, nil)
        end
        target.hold.anal.set(nil, nil, nil, nil)
      #●上半身解除
      elsif target.hold.tops.battler == hold_actor
        case target.hold.tops.type
        when "パイズリ"
          hold_actor.hold.penis.set(nil, nil, nil, nil)
        when "ぱふぱふ"
          hold_actor.hold.mouth.set(nil, nil, nil, nil)
        when "触手拘束","蔦拘束"
          hold_actor.hold.tentacle.set(nil, nil, nil, nil)
        else
          hold_actor.hold.tops.set(nil, nil, nil, nil)
        end
        target.hold.tops.set(nil, nil, nil, nil)
      #●尻尾解除
      elsif target.hold.tail.battler == hold_actor
        case target.hold.tail.type
        when "♀挿入"
          hold_actor.hold.vagina.set(nil, nil, nil, nil)
        when "口挿入"
          hold_actor.hold.mouth.set(nil, nil, nil, nil)
        when "尻挿入"
          hold_actor.hold.anal.set(nil, nil, nil, nil)
        end
        target.hold.tail.set(nil, nil, nil, nil)
      #●触手解除
      elsif target.hold.tentacle.battler == hold_actor
        case target.hold.tentacle.type
        when "触手吸引"
          hold_actor.hold.penis.set(nil, nil, nil, nil)
        when "触手♀挿入","触手クンニ"
          hold_actor.hold.vagina.set(nil, nil, nil, nil)
        when "触手口挿入"
          hold_actor.hold.mouth.set(nil, nil, nil, nil)
        when "触手尻挿入"
          hold_actor.hold.anal.set(nil, nil, nil, nil)
        when "触手拘束","蔦拘束","触手開脚"
          hold_actor.hold.tops.set(nil, nil, nil, nil)
        end
        target.hold.tentacle.set(nil, nil, nil, nil)
      #●ディルド解除
      elsif target.hold.dildo.battler == hold_actor
        case target.hold.dildo.type
        when "ディルド♀挿入"
          hold_actor.hold.vagina.set(nil, nil, nil, nil)
        when "ディルド口挿入"
          hold_actor.hold.mouth.set(nil, nil, nil, nil)
        when "ディルド尻挿入"
          hold_actor.hold.anal.set(nil, nil, nil, nil)
        end
        target.hold.dildo.set(nil, nil, nil, nil)
      end
=end
#    when "ストラグル"
    end
  end

  #--------------------------------------------------------------------------
  # ● ホールドの解除
  #--------------------------------------------------------------------------
  def remove_hold(behavior,remover,type = nil)
#    remover = $msg.t_enemy
    
    case behavior
    when "絶頂" #removerは絶頂したキャラクター
      # ホールドの解除（下の記述をメソッドに簡略化）
      hold_release(remover, nil, 1)
=begin
      #解除対象がエネミーの場合、ホールドリキャストを付与する
      remover.add_state(12) if remover.is_a?(Game_Enemy)
      remover.skill_collect = nil if remover.is_a?(Game_Actor)
      remover.animation_id = 7
      remover.animation_hit = true
      remover.graphic_change = true
      #口解除
      if remover.hold.mouth.battler != nil
        target = remover.hold.mouth.battler
        #解除対象がエネミーの場合、ホールドリキャストを付与する
        target.add_state(12) if target.is_a?(Game_Enemy)
        case remover.hold.mouth.type
        when "口挿入"
          #口挿入がペニスの場合
          if (target.hold.penis.battler == remover and target.hold.penis.type == "口挿入")
            target.hold.penis.set(nil, nil, nil, nil)
          #口挿入が尻尾の場合
          elsif (target.hold.tail.battler == remover and target.hold.tail.type == "口挿入")
            target.hold.tail.set(nil, nil, nil, nil)
          #口挿入が触手の場合
          elsif (target.hold.tentacle.battler == remover and target.hold.tentacle.type == "口挿入")
            target.hold.tentacle.set(nil, nil, nil, nil)
          #口挿入がディルドの場合
          elsif (target.hold.dildo.battler == remover and target.hold.dildo.type == "口挿入")
            target.hold.dildo.set(nil, nil, nil, nil)
          end
        when "ディルド口挿入"
          target.hold.dildo.set(nil, nil, nil, nil)
        when "顔面騎乗" #顔騎を仕掛けられている場合
          target.hold.vagina.set(nil, nil, nil, nil)
          target.hold.anal.set(nil, nil, nil, nil)
        when "クンニ" #クンニを仕掛けている場合
          target.hold.vagina.set(nil, nil, nil, nil)
        when "尻騎乗" #尻騎乗を仕掛けられている場合
          target.hold.anal.set(nil, nil, nil, nil)
        when "キッス" #キッスを仕掛けられている場合
          target.hold.mouth.set(nil, nil, nil, nil)
        end
        remover.hold.mouth.set(nil, nil, nil, nil)
        target.animation_id = 7
        target.animation_hit = true
        target.graphic_change = true
        target.skill_collect = nil if target.is_a?(Game_Actor)
      end
      #アソコ解除
      if remover.hold.vagina.battler != nil
        target = remover.hold.vagina.battler
        #解除対象がエネミーの場合、ホールドリキャストを付与する
        target.add_state(12) if target.is_a?(Game_Enemy)
        case remover.hold.vagina.type
        when "♀挿入"
          #アソコ挿入がペニスの場合
          if (target.hold.penis.battler == remover and target.hold.penis.type == "♀挿入")
            target.hold.penis.set(nil, nil, nil, nil)
          #アソコ挿入が尻尾の場合
          elsif (target.hold.tail.battler == remover and target.hold.tail.type == "♀挿入")
            target.hold.tail.set(nil, nil, nil, nil)
          #アソコ挿入が触手の場合
          elsif (target.hold.tentacle.battler == remover and target.hold.tentacle.type == "♀挿入")
            target.hold.tentacle.set(nil, nil, nil, nil)
          #アソコ挿入がディルドの場合
          elsif (target.hold.dildo.battler == remover and target.hold.dildo.type == "♀挿入")
            target.hold.dildo.set(nil, nil, nil, nil)
          end
        when "ディルド♀挿入"
          target.hold.dildo.set(nil, nil, nil, nil)
        when "貝合わせ"
          target.hold.vagina.set(nil, nil, nil, nil)
          target.hold.anal.set(nil, nil, nil, nil)
          remover.hold.anal.set(nil, nil, nil, nil)
        when "クンニ"
          target.hold.mouth.set(nil, nil, nil, nil)
        when "触手クンニ"
          target.hold.tentacle.set(nil, nil, nil, nil)
        when "顔面騎乗" #顔騎を仕掛けている場合
          target.hold.mouth.set(nil, nil, nil, nil)
          remover.hold.anal.set(nil, nil, nil, nil)
        end
        remover.hold.vagina.set(nil, nil, nil, nil)
        target.animation_id = 7
        target.animation_hit = true
        target.graphic_change = true
        target.skill_collect = nil if target.is_a?(Game_Actor)
      end
      #ペニス解除
      if remover.hold.penis.battler != nil
        target = remover.hold.penis.battler
        #解除対象がエネミーの場合、ホールドリキャストを付与する
        target.add_state(12) if target.is_a?(Game_Enemy)
        case remover.hold.penis.type
        when "♀挿入"
          target.hold.vagina.set(nil, nil, nil, nil)
        when "口挿入"
          target.hold.mouth.set(nil, nil, nil, nil)
        when "尻挿入"
          target.hold.anal.set(nil, nil, nil, nil)
        when "パイズリ"
          target.hold.tops.set(nil, nil, nil, nil)
        when "触手吸引"
          target.hold.tentacle.set(nil, nil, nil, nil)
        end
        remover.hold.penis.set(nil, nil, nil, nil)
        target.animation_id = 7
        target.animation_hit = true
        target.graphic_change = true
        target.skill_collect = nil if target.is_a?(Game_Actor)
      end
      #菊座解除
      if remover.hold.anal.battler != nil
        target = remover.hold.anal.battler
        #解除対象がエネミーの場合、ホールドリキャストを付与する
        target.add_state(12) if target.is_a?(Game_Enemy)
        #アナル挿入がペニスの場合
        if (target.hold.penis.battler == remover and target.hold.penis.type == "尻挿入")
          target.hold.penis.set(nil, nil, nil, nil)
        #アナル挿入が尻尾の場合
        elsif (target.hold.tail.battler == remover and target.hold.tail.type == "尻挿入")
          target.hold.tail.set(nil, nil, nil, nil)
        #アナル挿入が触手の場合
        elsif (target.hold.tentacle.battler == remover and target.hold.tentacle.type == "尻挿入")
          target.hold.tentacle.set(nil, nil, nil, nil)
        #アナル挿入がディルドの場合
        elsif (target.hold.dildo.battler == remover and target.hold.dildo.type == "尻挿入")
          target.hold.dildo.set(nil, nil, nil, nil)
        end
        remover.hold.anal.set(nil, nil, nil, nil)
        target.animation_id = 7
        target.animation_hit = true
        target.graphic_change = true
        target.skill_collect = nil if target.is_a?(Game_Actor)
      end
      #上半身拘束解除
      if remover.hold.tops.battler != nil
        target = remover.hold.tops.battler
        #解除対象がエネミーの場合、ホールドリキャストを付与する
        target.add_state(12) if target.is_a?(Game_Enemy)
        if (target.hold.tops.battler == remover and (target.hold.tops.type == "拘束" or target.hold.tops.type == "開脚"))
          target.hold.tops.set(nil, nil, nil, nil)
        elsif (target.hold.tentacle.battler == remover and (target.hold.tops.type == "触手拘束" or target.hold.tops.type == "触手開脚" or target.hold.tops.type == "蔦拘束"))
          target.hold.tentacle.set(nil, nil, nil, nil)
        elsif (target.hold.penis.battler == remover and target.hold.penis.type == "パイズリ")
          target.hold.penis.set(nil, nil, nil, nil)
        elsif (target.hold.mouth.battler == remover and target.hold.mouth.type == "ぱふぱふ")
          target.hold.mouth.set(nil, nil, nil, nil)
        end
        remover.hold.tops.set(nil, nil, nil, nil)
        target.animation_id = 7
        target.animation_hit = true
        target.graphic_change = true
        target.skill_collect = nil if target.is_a?(Game_Actor)
      end
      #尻尾解除
      if remover.hold.tail.battler != nil
        target = remover.hold.tail.battler
        #解除対象がエネミーの場合、ホールドリキャストを付与する
        target.add_state(12) if target.is_a?(Game_Enemy)
        case remover.hold.tail.type
        when "♀挿入"
          target.hold.vagina.set(nil, nil, nil, nil)
        when "口挿入"
          target.hold.mouth.set(nil, nil, nil, nil)
        when "尻挿入"
          target.hold.anal.set(nil, nil, nil, nil)
        end
        remover.hold.tail.set(nil, nil, nil, nil)
        target.animation_id = 7
        target.animation_hit = true
        target.graphic_change = true
        target.skill_collect = nil if target.is_a?(Game_Actor)
      end
      #触手・スライム解除
      if remover.hold.tentacle.battler != nil
        target = remover.hold.tentacle.battler
        #解除対象がエネミーの場合、ホールドリキャストを付与する
        target.add_state(12) if target.is_a?(Game_Enemy)
        case remover.hold.tentacle.type
        when "触手吸引"
          target.hold.vagina.set(nil, nil, nil, nil)
        when "触手♀挿入","触手クンニ"
          target.hold.vagina.set(nil, nil, nil, nil)
        when "触手口挿入"
          target.hold.mouth.set(nil, nil, nil, nil)
        when "触手尻挿入"
          target.hold.anal.set(nil, nil, nil, nil)
        when "触手拘束","蔦拘束","触手開脚"
          target.hold.tops.set(nil, nil, nil, nil)
        end
        remover.hold.tentacle.set(nil, nil, nil, nil)
        target.animation_id = 7
        target.animation_hit = true
        target.graphic_change = true
        target.skill_collect = nil if target.is_a?(Game_Actor)
      end
      #ディルド解除
      if remover.hold.dildo.battler != nil
        target = remover.hold.dildo.battler
        #解除対象がエネミーの場合、ホールドリキャストを付与する
        target.add_state(12) if target.is_a?(Game_Enemy)
        case remover.hold.dildo.type
        when "ディルド♀挿入"
          target.hold.vagina.set(nil, nil, nil, nil)
        when "ディルド口挿入"
          target.hold.mouth.set(nil, nil, nil, nil)
        when "ディルド尻挿入"
          target.hold.anal.set(nil, nil, nil, nil)
        end
        remover.hold.dildo.set(nil, nil, nil, nil)
        target.animation_id = 7
        target.animation_hit = true
        target.graphic_change = true
        target.skill_collect = nil if target.is_a?(Game_Actor)
      end
=end
    end
  end
end