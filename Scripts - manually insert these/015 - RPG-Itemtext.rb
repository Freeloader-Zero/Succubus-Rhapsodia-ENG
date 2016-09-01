#==============================================================================
# ■ RPG::Skill
#------------------------------------------------------------------------------
# 　アイテム個別メッセージ格納
#==============================================================================
module RPG
  class Item
    def message(item, type, myself, user)
      text = ""
      action = ""
      myname = myself.name
      username = user.name
      itemname = item.name
      target = $game_temp.battle_target_battler[0] if $game_temp.battle_target_battler[0] != nil
      targetname = $game_temp.battle_target_battler[0].name if $game_temp.battle_target_battler[0] != nil
      prm = "#{myname}は"
      action = prm + "#{itemname}を使った！"
      avoid = "#{myname}はすばやくかわした！"
      # ■属性で判断
#      if item.element_set.include?(121)
#        action = dodge = ""
#      end
      # ■IDで判断(必要に応じて個別設定)
      case item.id
      when 51,52,53 # 小さなポピー、鮮やかな花冠、ロマンスブーケ
        action = prm + "#{targetname}に\n\066#{itemname}を渡した！"
        avoid  = "しかし#{myname}はもう十分満足そうだ……"
      end
      # メッセージ出力
      case type
      when "action"
        text = action
      when "avoid"
        text = avoid
      end
      return text
    end
  end
end