#==============================================================================
# ¡ Game_Actor
#------------------------------------------------------------------------------
# @ƒAƒNƒ^[‚ğˆµ‚¤ƒNƒ‰ƒX‚Å‚·B‚±‚ÌƒNƒ‰ƒX‚Í Game_Actors ƒNƒ‰ƒX ($game_actors)
# ‚Ì“à•”‚Åg—p‚³‚êAGame_Party ƒNƒ‰ƒX ($game_party) ‚©‚ç‚àQÆ‚³‚ê‚Ü‚·B
#==============================================================================

class Game_Actor < Game_Battler
  #--------------------------------------------------------------------------
  # œ ŒöŠJƒCƒ“ƒXƒ^ƒ“ƒX•Ï”
  #--------------------------------------------------------------------------
  attr_reader   :name                   # –¼‘O
  attr_reader   :character_name         # ƒLƒƒƒ‰ƒNƒ^[ ƒtƒ@ƒCƒ‹–¼
  attr_reader   :character_hue          # ƒLƒƒƒ‰ƒNƒ^[ F‘Š
  attr_reader   :class_id               # ƒNƒ‰ƒX ID
  attr_accessor :weapon_id              # •Ší ID
  attr_accessor :armor1_id              # ‚ ID
  attr_accessor :armor2_id              # “ª–h‹ï ID
  attr_accessor :armor3_id              # ‘Ì–h‹ï ID
  attr_accessor :armor4_id              # ‘•ü•i ID
  attr_reader   :level                  # ƒŒƒxƒ‹
  attr_accessor :exp                    # EXP
  # š’Ç‰Á‰ÓŠ---------------------------------------------------------------
  attr_accessor :skills                 # ƒXƒLƒ‹
  attr_accessor :base_atk2              # UŒ‚—Íi’²®—pj
  attr_accessor :base_pdef2             # •¨—–hŒäi’²®—pj
  attr_accessor :base_mdef2             # –‚–@–hŒäi’²®—pj
  attr_accessor :promise                # Œ_–ñƒ|ƒCƒ“ƒg
  attr_accessor :maxfed                 # Å‘å–• “x
  attr_accessor :fed                    # –• “x
  attr_accessor :digest                 # ‹ó• —¦
  attr_accessor :absorb                 # ‹z¸—¦
  attr_accessor :d_power                # –²‚Ì–‚—Í
  attr_accessor :exp_tank               # ŒoŒ±’lƒ^ƒ“ƒN
  attr_accessor :race                   # í‘°
  attr_accessor :hp_autoheal            # EP©“®‰ñ•œ
  attr_accessor :sp_autoheal            # VP©“®‰ñ•œ
  attr_accessor :vs_me                  # ‚±‚Ì–²–‚‚Æí“¬’†
  attr_accessor :exp_list               # ŒoŒ±’lƒe[ƒuƒ‹
  attr_accessor :level_up_log           # ƒŒƒxƒ‹ƒAƒbƒvƒƒO
  attr_accessor :skill_collect          # ƒXƒLƒ‹g—p—š—ğ
  attr_accessor :exp_plus_flag          # ŒoŒ±’l‚ğ‘½‚ß‚É–á‚Á‚½‚©H
  
  #--------------------------------------------------------------------------
  # œ ƒIƒuƒWƒFƒNƒg‰Šú‰»
  #     actor_id : ƒAƒNƒ^[ ID
  #--------------------------------------------------------------------------
  def initialize(actor_id)
    super()
    setup(actor_id)
  end
  #--------------------------------------------------------------------------
  # œ ƒZƒbƒgƒAƒbƒv
  #     actor_id : ƒAƒNƒ^[ ID
  #--------------------------------------------------------------------------
  def setup(actor_id)
    actor = $data_actors[actor_id]
    @actor_id = actor_id
    @name = actor.name
    @character_name = actor.character_name
    @character_hue = actor.character_hue
    @battler_name = actor.battler_name
    @battler_hue = actor.battler_hue
    @class_id = actor.class_id
    @weapon_id = actor.weapon_id
    @armor1_id = actor.armor1_id
    @armor2_id = actor.armor2_id
    @armor3_id = actor.armor3_id
    @armor4_id = actor.armor4_id
    @level = actor.initial_level
    @exp_list = Array.new(101)
    make_exp_list
    @exp = @exp_list[@level]
    @skills = []
    @hp = maxhp
    @sp = maxsp
    @states = []
    @states_turn = {}
    @maxhp_plus = 0
    @maxsp_plus = 0
    @str_plus = 0
    @dex_plus = 0
    @agi_plus = 0
    @int_plus = 0
    # š XV‰ÓŠ
    @base_atk2 = 0
    @base_pdef2 = 0
    @base_mdef2 = 0
    @promise = 0
    @maxfed = 100
    @fed = 100
    @digest = 0
    @absorb = 0
    @d_power = 0
    @exp_tank = 0
    @hp_autoheal = 1
    @sp_autoheal = 1
    @vs_me = false
    @skill_collect = nil
    # ƒXƒLƒ‹K“¾
    @skills = []
    if actor_id == 101
      for i in 1..@level
        for j in $data_classes[@class_id].learnings
          if j[0] == i
            if j[1] == 0
              learn_skill(j[2])
            else
              gain_ability(j[2])
            end
          end
        end
      end
    end
    @level_up_log = ""
    # ƒI[ƒgƒXƒe[ƒg‚ğXV
    update_auto_state(nil, $data_armors[@armor1_id])
    update_auto_state(nil, $data_armors[@armor2_id])
    update_auto_state(nil, $data_armors[@armor3_id])
    update_auto_state(nil, $data_armors[@armor4_id])
  end
  #--------------------------------------------------------------------------
  # œ ƒAƒNƒ^[ ID æ“¾
  #--------------------------------------------------------------------------
  def id
    return @actor_id
  end
  #--------------------------------------------------------------------------
  # œ ƒCƒ“ƒfƒbƒNƒXæ“¾
  #--------------------------------------------------------------------------
  def index
    return $game_party.actors.index(self)
  end
  #--------------------------------------------------------------------------
  # œ EXP ŒvZ
  #--------------------------------------------------------------------------
  def make_exp_list
    actor = $data_actors[@actor_id]
    @exp_list[1] = 0
    pow_i = 2.4 + actor.exp_inflation / 100.0
    for i in 2..100
      if i > actor.final_level
        @exp_list[i] = 0
      else
        n = actor.exp_basis * ((i + 3) ** pow_i) / (5 ** pow_i)
        @exp_list[i] = @exp_list[i-1] + Integer(n)
      end
    end
  end
  #--------------------------------------------------------------------------
  # œ ‘®«•â³’l‚Ìæ“¾
  #     element_id : ‘®« ID
  #--------------------------------------------------------------------------
  def element_rate(element_id)
    # ‘®«—LŒø“x‚É‘Î‰‚·‚é”’l‚ğæ“¾
    table = [0,200,150,100,50,0,-100]
    result = table[$data_classes[@class_id].element_ranks[element_id]]
    # –h‹ï‚Å‚±‚Ì‘®«‚ª–hŒä‚³‚ê‚Ä‚¢‚éê‡‚Í”¼Œ¸
    for i in [@armor1_id, @armor2_id, @armor3_id, @armor4_id]
      armor = $data_armors[i]
      if armor != nil and armor.guard_element_set.include?(element_id)
        result /= 2
      end
    end
    # ƒXƒe[ƒg‚Å‚±‚Ì‘®«‚ª–hŒä‚³‚ê‚Ä‚¢‚éê‡‚Í”¼Œ¸
    for i in @states
      if $data_states[i].guard_element_set.include?(element_id)
        result /= 2
      end
    end
    # ƒƒ\ƒbƒhI—¹
    return result
  end
  #--------------------------------------------------------------------------
  # œ ƒXƒe[ƒg—LŒø“x‚Ìæ“¾
  #--------------------------------------------------------------------------
  def state_ranks
    return $data_classes[@class_id].state_ranks
  end
  #--------------------------------------------------------------------------
  # œ ƒXƒe[ƒg–hŒä”»’è
  #     state_id : ƒXƒe[ƒg ID
  #--------------------------------------------------------------------------
  def state_guard?(state_id)
    for i in [@armor1_id, @armor2_id, @armor3_id, @armor4_id]
      armor = $data_armors[i]
      if armor != nil
        if armor.guard_state_set.include?(state_id)
          return true
        end
      end
    end
    return false
  end
  #--------------------------------------------------------------------------
  # œ ’ÊíUŒ‚‚Ì‘®«æ“¾
  #--------------------------------------------------------------------------
  def element_set
    weapon = $data_weapons[@weapon_id]
    return weapon != nil ? weapon.element_set : []
  end
  #--------------------------------------------------------------------------
  # œ ’ÊíUŒ‚‚ÌƒXƒe[ƒg•Ï‰» (+) æ“¾
  #--------------------------------------------------------------------------
  def plus_state_set
    weapon = $data_weapons[@weapon_id]
    return weapon != nil ? weapon.plus_state_set : []
  end
  #--------------------------------------------------------------------------
  # œ ’ÊíUŒ‚‚ÌƒXƒe[ƒg•Ï‰» (-) æ“¾
  #--------------------------------------------------------------------------
  def minus_state_set
    weapon = $data_weapons[@weapon_id]
    return weapon != nil ? weapon.minus_state_set : []
  end
  #--------------------------------------------------------------------------
  # œ MaxHP ‚Ìæ“¾
  #--------------------------------------------------------------------------
  def maxhp
    n = [[base_maxhp + @maxhp_plus, 1].max, 9999].min
    for i in @states
      n *= $data_states[i].maxhp_rate / 100.0
    end
    n = [[Integer(n), 1].max, 9999].min
    n += 300 if self.is_a?(Game_Actor) and self.equip?("–\H‚Ìƒ‹[ƒ“")
    return n
  end
  #--------------------------------------------------------------------------
  # œ Šî–{ MaxHP ‚Ìæ“¾
  #--------------------------------------------------------------------------
  def base_maxhp
    return $data_actors[@actor_id].parameters[0, @level]
  end
  #--------------------------------------------------------------------------
  # œ Šî–{ MaxSP ‚Ìæ“¾
  #--------------------------------------------------------------------------
  def base_maxsp
    return $data_actors[@actor_id].parameters[1, @level]
  end
  #--------------------------------------------------------------------------
  # œ Šî–{˜r—Í‚Ìæ“¾
  #--------------------------------------------------------------------------
  def base_str
    n = $data_actors[@actor_id].parameters[2, @level]
    weapon = $data_weapons[@weapon_id]
    armor1 = $data_armors[@armor1_id]
    armor2 = $data_armors[@armor2_id]
    armor3 = $data_armors[@armor3_id]
    armor4 = $data_armors[@armor4_id]
    n += weapon != nil ? weapon.str_plus : 0
    n += armor1 != nil ? armor1.str_plus : 0
    n += armor2 != nil ? armor2.str_plus : 0
    n += armor3 != nil ? armor3.str_plus : 0
    n += armor4 != nil ? armor4.str_plus : 0
    return [[n, 1].max, 999].min
  end
  #--------------------------------------------------------------------------
  # œ Šî–{Ší—p‚³‚Ìæ“¾
  #--------------------------------------------------------------------------
  def base_dex
    n = $data_actors[@actor_id].parameters[3, @level]
    weapon = $data_weapons[@weapon_id]
    armor1 = $data_armors[@armor1_id]
    armor2 = $data_armors[@armor2_id]
    armor3 = $data_armors[@armor3_id]
    armor4 = $data_armors[@armor4_id]
    n += weapon != nil ? weapon.dex_plus : 0
    n += armor1 != nil ? armor1.dex_plus : 0
    n += armor2 != nil ? armor2.dex_plus : 0
    n += armor3 != nil ? armor3.dex_plus : 0
    n += armor4 != nil ? armor4.dex_plus : 0
    return [[n, 1].max, 999].min
  end
  #--------------------------------------------------------------------------
  # œ Šî–{‘f‘‚³‚Ìæ“¾
  #--------------------------------------------------------------------------
  def base_agi
    n = $data_actors[@actor_id].parameters[4, @level]
    weapon = $data_weapons[@weapon_id]
    armor1 = $data_armors[@armor1_id]
    armor2 = $data_armors[@armor2_id]
    armor3 = $data_armors[@armor3_id]
    armor4 = $data_armors[@armor4_id]
    n += weapon != nil ? weapon.agi_plus : 0
    n += armor1 != nil ? armor1.agi_plus : 0
    n += armor2 != nil ? armor2.agi_plus : 0
    n += armor3 != nil ? armor3.agi_plus : 0
    n += armor4 != nil ? armor4.agi_plus : 0
    return [[n, 1].max, 999].min
  end
  #--------------------------------------------------------------------------
  # œ Šî–{–‚—Í‚Ìæ“¾
  #--------------------------------------------------------------------------
  def base_int
    n = $data_actors[@actor_id].parameters[5, @level]
    weapon = $data_weapons[@weapon_id]
    armor1 = $data_armors[@armor1_id]
    armor2 = $data_armors[@armor2_id]
    armor3 = $data_armors[@armor3_id]
    armor4 = $data_armors[@armor4_id]
    n += weapon != nil ? weapon.int_plus : 0
    n += armor1 != nil ? armor1.int_plus : 0
    n += armor2 != nil ? armor2.int_plus : 0
    n += armor3 != nil ? armor3.int_plus : 0
    n += armor4 != nil ? armor4.int_plus : 0
    return [[n, 1].max, 999].min
  end
  #--------------------------------------------------------------------------
  # œ Šî–{UŒ‚—Í‚Ìæ“¾
  #--------------------------------------------------------------------------
  def base_atk
    weapon = $data_weapons[@weapon_id]
    return weapon != nil ? weapon.atk : 0
  end
  #--------------------------------------------------------------------------
  # œ Šî–{•¨—–hŒä‚Ìæ“¾
  #--------------------------------------------------------------------------
  def base_pdef
    weapon = $data_weapons[@weapon_id]
    armor1 = $data_armors[@armor1_id]
    armor2 = $data_armors[@armor2_id]
    armor3 = $data_armors[@armor3_id]
    armor4 = $data_armors[@armor4_id]
    pdef1 = weapon != nil ? weapon.pdef : 0
    pdef2 = armor1 != nil ? armor1.pdef : 0
    pdef3 = armor2 != nil ? armor2.pdef : 0
    pdef4 = armor3 != nil ? armor3.pdef : 0
    pdef5 = armor4 != nil ? armor4.pdef : 0
    return pdef1 + pdef2 + pdef3 + pdef4 + pdef5
  end
  #--------------------------------------------------------------------------
  # š ’²®—pŠî–{•¨—–hŒä‚Ìæ“¾
  #--------------------------------------------------------------------------
  def base_pdef2
    weapon = $data_weapons[@weapon_id]
    armor1 = $data_armors[@armor1_id]
    armor2 = $data_armors[@armor2_id]
    armor3 = $data_armors[@armor3_id]
    armor4 = $data_armors[@armor4_id]
    pdef1 = weapon != nil ? weapon.pdef : 0
    pdef2 = armor1 != nil ? armor1.pdef : 0
    pdef3 = armor2 != nil ? armor2.pdef : 0
    pdef4 = armor3 != nil ? armor3.pdef : 0
    pdef5 = armor4 != nil ? armor4.pdef : 0
    return pdef1 + pdef2 + pdef3 + pdef4 + pdef5 + int
  end
  #--------------------------------------------------------------------------
  # œ Šî–{–‚–@–hŒä‚Ìæ“¾
  #--------------------------------------------------------------------------
  def base_mdef
    weapon = $data_weapons[@weapon_id]
    armor1 = $data_armors[@armor1_id]
    armor2 = $data_armors[@armor2_id]
    armor3 = $data_armors[@armor3_id]
    armor4 = $data_armors[@armor4_id]
    mdef1 = weapon != nil ? weapon.mdef : 0
    mdef2 = armor1 != nil ? armor1.mdef : 0
    mdef3 = armor2 != nil ? armor2.mdef : 0
    mdef4 = armor3 != nil ? armor3.mdef : 0
    mdef5 = armor4 != nil ? armor4.mdef : 0
    return mdef1 + mdef2 + mdef3 + mdef4 + mdef5
  end
  #--------------------------------------------------------------------------
  # œ Šî–{‰ñ”ğC³‚Ìæ“¾
  #--------------------------------------------------------------------------
  def base_eva
    armor1 = $data_armors[@armor1_id]
    armor2 = $data_armors[@armor2_id]
    armor3 = $data_armors[@armor3_id]
    armor4 = $data_armors[@armor4_id]
    eva1 = armor1 != nil ? armor1.eva : 0
    eva2 = armor2 != nil ? armor2.eva : 0
    eva3 = armor3 != nil ? armor3.eva : 0
    eva4 = armor4 != nil ? armor4.eva : 0
    return eva1 + eva2 + eva3 + eva4
  end
  #--------------------------------------------------------------------------
  # œ ’ÊíUŒ‚ UŒ‚‘¤ƒAƒjƒ[ƒVƒ‡ƒ“ ID ‚Ìæ“¾
  #--------------------------------------------------------------------------
  def animation1_id
    weapon = $data_weapons[@weapon_id]
    return weapon != nil ? weapon.animation1_id : 0
  end
  #--------------------------------------------------------------------------
  # œ ’ÊíUŒ‚ ‘ÎÛ‘¤ƒAƒjƒ[ƒVƒ‡ƒ“ ID ‚Ìæ“¾
  #--------------------------------------------------------------------------
  def animation2_id
    weapon = $data_weapons[@weapon_id]
    return weapon != nil ? weapon.animation2_id : 0
  end

  #--------------------------------------------------------------------------
  # œ EXP ‚Ì•¶š—ñæ“¾
  #--------------------------------------------------------------------------
  def exp_s
    return @exp_list[@level+1] > 0 ? @exp.to_s : "----"
  end
  #--------------------------------------------------------------------------
  # œ Ÿ‚ÌƒŒƒxƒ‹‚Ì EXP ‚Ì•¶š—ñæ“¾
  #--------------------------------------------------------------------------
  def next_exp_s
    return @exp_list[@level+1] > 0 ? @exp_list[@level+1].to_s : "----"
  end
  #--------------------------------------------------------------------------
  # œ Ÿ‚ÌƒŒƒxƒ‹‚Ü‚Å‚Ì EXP ‚Ì•¶š—ñæ“¾
  #--------------------------------------------------------------------------
  def next_rest_exp_s
    return @exp_list[@level+1] > 0 ?
      (@exp_list[@level+1] - @exp).to_s : "----"
  end
  #--------------------------------------------------------------------------
  # œ ƒI[ƒgƒXƒe[ƒg‚ÌXV
  #     old_armor : ŠO‚µ‚½–h‹ï
  #     new_armor : ‘•”õ‚µ‚½–h‹ï
  #--------------------------------------------------------------------------
  def update_auto_state(old_armor, new_armor)
    # ŠO‚µ‚½–h‹ï‚ÌƒI[ƒgƒXƒe[ƒg‚ğ‹­§‰ğœ
    if old_armor != nil and old_armor.auto_state_id != 0
      remove_state(old_armor.auto_state_id, true)
    end
    # ‘•”õ‚µ‚½–h‹ï‚ÌƒI[ƒgƒXƒe[ƒg‚ğ‹­§•t‰Á
    if new_armor != nil and new_armor.auto_state_id != 0
      add_state(new_armor.auto_state_id, true)
    end
  end
  #--------------------------------------------------------------------------
  # œ ‘•”õŒÅ’è”»’è
  #     equip_type : ‘•”õƒ^ƒCƒv
  #--------------------------------------------------------------------------
  def equip_fix?(equip_type)
    case equip_type
    when 0  # •Ší
      return $data_actors[@actor_id].weapon_fix
    when 1  # ‚
      return $data_actors[@actor_id].armor1_fix
    when 2  # “ª
      return $data_actors[@actor_id].armor2_fix
    when 3  # g‘Ì
      return $data_actors[@actor_id].armor3_fix
    when 4  # ‘•ü•i
      return $data_actors[@actor_id].armor4_fix
    end
    return false
  end
  #--------------------------------------------------------------------------
  # œ ‘•”õ‚Ì•ÏX
  #     equip_type : ‘•”õƒ^ƒCƒv
  #     id    : •Ší or –h‹ï ID  (0 ‚È‚ç‘•”õ‰ğœ)
  #--------------------------------------------------------------------------
  def equip(equip_type, id)
    case equip_type
    when 0  # •Ší
      if id == 0 or $game_party.weapon_number(id) > 0
        $game_party.gain_weapon(@weapon_id, 1)
        @weapon_id = id
        $game_party.lose_weapon(id, 1)
      end
    when 1  # ‚
      if id == 0 or $game_party.armor_number(id) > 0
        update_auto_state($data_armors[@armor1_id], $data_armors[id])
        $game_party.gain_armor(@armor1_id, 1)
        @armor1_id = id
        $game_party.lose_armor(id, 1)
      end
    when 2  # “ª
      if id == 0 or $game_party.armor_number(id) > 0
        update_auto_state($data_armors[@armor2_id], $data_armors[id])
        $game_party.gain_armor(@armor2_id, 1)
        @armor2_id = id
        $game_party.lose_armor(id, 1)
      end
    when 3  # g‘Ì
      if id == 0 or $game_party.armor_number(id) > 0
        update_auto_state($data_armors[@armor3_id], $data_armors[id])
        $game_party.gain_armor(@armor3_id, 1)
        @armor3_id = id
        $game_party.lose_armor(id, 1)
      end
    when 4  # ‘•ü•i
      if id == 0 or $game_party.armor_number(id) > 0
        update_auto_state($data_armors[@armor4_id], $data_armors[id])
        $game_party.gain_armor(@armor4_id, 1)
        @armor4_id = id
        $game_party.lose_armor(id, 1)
      end
    end
  end
  #--------------------------------------------------------------------------
  # œ ‘•”õ‰Â”\”»’è
  #     item : ƒAƒCƒeƒ€
  #--------------------------------------------------------------------------
  def equippable?(item)
    # •Ší‚Ìê‡
    if item.is_a?(RPG::Weapon)
      # Œ»İ‚ÌƒNƒ‰ƒX‚Ì‘•”õ‰Â”\‚È•Ší‚ÉŠÜ‚Ü‚ê‚Ä‚¢‚éê‡
      if $data_classes[@class_id].weapon_set.include?(item.id)
        return true
      end
    end
    # –h‹ï‚Ìê‡
    if item.is_a?(RPG::Armor)
      # Œ»İ‚ÌƒNƒ‰ƒX‚Ì‘•”õ‰Â”\‚È–h‹ï‚ÉŠÜ‚Ü‚ê‚Ä‚¢‚éê‡
      if $data_classes[@class_id].armor_set.include?(item.id)
        return true
      end
    end
    return false
  end
  #--------------------------------------------------------------------------
  # œ EXP ‚Ì•ÏX
  #     exp : V‚µ‚¢ EXP
  #--------------------------------------------------------------------------
  def exp=(exp)
    @exp = [[exp, 9999999].min, 0].max
    text = ""
    @level_up_log = ""
    myname = self.name
    up_flag = false
    # ƒŒƒxƒ‹ƒAƒbƒv
    while @exp >= @exp_list[@level+1] and @exp_list[@level+1] > 0
      @level += 1
      text += "\\" #if up_flag
      text += "#{myname} reached Lv.#{@level.to_s}!"
      # ƒXƒLƒ‹K“¾
      for j in $data_classes[@class_id].learnings
        if j[0] == @level
          if j[1] == 0
            learn_skill(j[2])
            text += "\\#{myname} learned #{$data_skills[j[2]].UK_name}!"
          else
            gain_ability(j[2])
            # ”ñ•\¦‘f¿‚Í•\¦‚µ‚È‚¢
            if $data_ability[j[2]].hidden == false
              text += "\\#{myname} got the y#{$data_ability[j[2]].UK_name}z trait!"
            end
          end
        end
      end
#      up_flag = true 
    end
    
    # ƒŒƒxƒ‹ƒ_ƒEƒ“
    while @exp < @exp_list[@level]
      @level -= 1
    end
    if text != ""
      @level_up_log = text
    end
    # Œ»İ‚Ì HP ‚Æ SP ‚ªÅ‘å’l‚ğ’´‚¦‚Ä‚¢‚½‚çC³
    @hp = [@hp, self.maxhp].min
    @sp = [@sp, self.maxsp].min
  end
  #--------------------------------------------------------------------------
  # œ ƒŒƒxƒ‹‚Ì•ÏX
  #     level : V‚µ‚¢ƒŒƒxƒ‹
  #--------------------------------------------------------------------------
  def level=(level)
    # ã‰ºŒÀƒ`ƒFƒbƒN
    level = [[level, $MAX_LEVEL].min, 1].max
    # EXP ‚ğ•ÏX
    self.exp = @exp_list[level]
  end
  #--------------------------------------------------------------------------
  # œ ƒXƒLƒ‹‚ğŠo‚¦‚é
  #     skill_id : ƒXƒLƒ‹ ID
  #--------------------------------------------------------------------------
  def learn_skill(skill_id)
    if skill_id > 0 and not skill_learn?(skill_id, "ORIGINAL")
      @skills.push(skill_id)
      @skills.sort!
    end
  end
  #--------------------------------------------------------------------------
  # œ ƒXƒLƒ‹‚ğ–Y‚ê‚é
  #     skill_id : ƒXƒLƒ‹ ID
  #--------------------------------------------------------------------------
  def forget_skill(skill_id)
    @skills.delete(skill_id)
  end
  #--------------------------------------------------------------------------
  # œ ƒXƒLƒ‹‚ÌK“¾Ï‚İ”»’è
  #     skill_id : ƒXƒLƒ‹ ID
  #--------------------------------------------------------------------------
  def skill_learn?(skill_id, type = "ALL")
    # í“¬’†‚©‚Â‚`‚k‚k‚È‚çí“¬’†—pƒXƒLƒ‹‚ğ•Ô‚·
    return battle_skills.include?(skill_id) if type == "ALL" and $game_temp.in_battle
    # ‚`‚k‚k‚È‚çK“¾‚µ‚Ä‚¢‚é‘SƒXƒLƒ‹‚ğ•Ô‚·
    return all_skills.include?(skill_id) if type == "ALL"
    # ‚»‚êˆÈŠO‚È‚ç©—ÍK“¾‚Ì‚İ‚ÌƒXƒLƒ‹‚ğ•Ô‚·
    return @skills.include?(skill_id)
  end
  #--------------------------------------------------------------------------
  # œ ƒXƒLƒ‹‚Ìg—p‰Â”\”»’è
  #     skill_id : ƒXƒLƒ‹ ID
  #--------------------------------------------------------------------------
  def skill_can_use?(skill_id)
    if not skill_learn?(skill_id)
      return false unless self.berserk == true
    end
    return super
  end
  #--------------------------------------------------------------------------
  # œ –¼‘O‚Ì•ÏX
  #     name : V‚µ‚¢–¼‘O
  #--------------------------------------------------------------------------
  def name=(name)
    @name = name
  end
  #--------------------------------------------------------------------------
  # š DŠ´“x‚Ì•ÏX
  #     love : V‚µ‚¢DŠ´“x
  #--------------------------------------------------------------------------
  def love=(love)
    if self.have_ability?("’ˆ¤")
      @love = [[love, 150].min, 0].max
    else
      @love = [[love, $MAX_LOVE].min, 0].max
    end
  end
  #--------------------------------------------------------------------------
  # š Œ_–ñ‚Ìì‚Ì•ÏX
  #     promise : V‚µ‚¢Œ_–ñ‚Ìì
  #--------------------------------------------------------------------------
  def promise=(promise)
    @promise = [[promise, 999999].min, 0].max
  end
  #--------------------------------------------------------------------------
  # œ ƒNƒ‰ƒX ID ‚Ì•ÏX
  #     class_id : V‚µ‚¢ƒNƒ‰ƒX ID
  #--------------------------------------------------------------------------
  def class_id=(class_id)
    if $data_classes[class_id] != nil
      @class_id = class_id
      # ‘•”õ‚Å‚«‚È‚­‚È‚Á‚½ƒAƒCƒeƒ€‚ğŠO‚·
      unless equippable?($data_weapons[@weapon_id])
        equip(0, 0)
      end
      unless equippable?($data_armors[@armor1_id])
        equip(1, 0)
      end
      unless equippable?($data_armors[@armor2_id])
        equip(2, 0)
      end
      unless equippable?($data_armors[@armor3_id])
        equip(3, 0)
      end
      unless equippable?($data_armors[@armor4_id])
        equip(4, 0)
      end
    end
  end
  #--------------------------------------------------------------------------
  # œ ƒOƒ‰ƒtƒBƒbƒN‚Ì•ÏX
  #     character_name : V‚µ‚¢ƒLƒƒƒ‰ƒNƒ^[ ƒtƒ@ƒCƒ‹–¼
  #     character_hue  : V‚µ‚¢ƒLƒƒƒ‰ƒNƒ^[ F‘Š
  #     battler_name   : V‚µ‚¢ƒoƒgƒ‰[ ƒtƒ@ƒCƒ‹–¼
  #     battler_hue    : V‚µ‚¢ƒoƒgƒ‰[ F‘Š
  #--------------------------------------------------------------------------
  def set_graphic(character_name, character_hue, battler_name, battler_hue)
    @character_name = character_name
    @character_hue = character_hue
    @battler_name = battler_name
    @battler_hue = battler_hue
  end
  #--------------------------------------------------------------------------
  # œ ƒoƒgƒ‹‰æ–Ê X À•W‚Ìæ“¾
  #--------------------------------------------------------------------------
  def screen_x
    # ƒp[ƒeƒB“à‚Ì•À‚Ñ‡‚©‚ç X À•W‚ğŒvZ‚µ‚Ä•Ô‚·
    if self.index != nil
      return self.index * 160 + 80
    else
      return 0
    end
  end
  #--------------------------------------------------------------------------
  # œ ƒoƒgƒ‹‰æ–Ê Y À•W‚Ìæ“¾
  #--------------------------------------------------------------------------
  def screen_y
    return 464
  end
  #--------------------------------------------------------------------------
  # œ ƒoƒgƒ‹‰æ–Ê Z À•W‚Ìæ“¾
  #--------------------------------------------------------------------------
  def screen_z
    # ƒp[ƒeƒB“à‚Ì•À‚Ñ‡‚©‚ç Z À•W‚ğŒvZ‚µ‚Ä•Ô‚·
    if self.index != nil
      return 4 - self.index
    else
      return 0
    end
  end
  #--------------------------------------------------------------------------
  # œ –• “x ‚Ì•ÏX
  #--------------------------------------------------------------------------
  def fed
    return [[@fed, 0].max, 100].min
  end
  #---------------------------------------------------------------------------- 
  # œ –• “x‚ÌŒ¸­
  #----------------------------------------------------------------------------
  def fed_down
    if self != $game_actors[101]
      @fed -= self.digest
      if @fed <= 20 and not self.state?(15)
        $game_temp.hungry = true
        self.add_state(15)
        text = "#{@name}\n seems to be hungry again..."
        SR_Util.announce(text)
      end
      if @fed <= 0
        $game_temp.vs_actors.push(self)
        @vs_me = true
      end
    end
  end
  #--------------------------------------------------------------------------
  # œ ƒ‰ƒ“ƒNƒAƒbƒv
  #--------------------------------------------------------------------------
  def rank_up
    # ƒNƒ‰ƒX‚Ì–¼‘O‚»‚Ì‚Ü‚Ü‚È‚çƒtƒ‰ƒO‚ğ—§‚Ä‚éB
    name_flag = @name == $data_classes[@class_id].name ? true :false
    # ƒ‰ƒ“ƒNƒAƒbƒvˆ—
    @class_id = $data_SDB[self.class_id].next_rank_id
    self.set_graphic($data_SDB[self.class_id].graphics,0,$data_SDB[self.class_id].graphics,0)
    @name = $data_classes[@class_id].name if name_flag == true
    # ƒ‰ƒ“ƒNƒAƒbƒv‚ğÁ‹
    @skills.delete(249)
    
    # ƒXƒLƒ‹K“¾
    for j in $data_classes[@class_id].learnings
      if j[0] <= @level
        if j[1] == 0
          learn_skill(j[2])
        else
          gain_ability(j[2])
        end
      end
    end
    # ƒCƒ“ƒvAƒSƒuƒŠƒ“ˆÈŠO‚ªy¬ˆ«–‚‚Ì˜AŒgz‚ğ‘f‚Å‚Á‚Ä‚¢‚éê‡A
    # y¬ˆ«–‚‚Ì“—¦z‚É•ÏX‚·‚éBiˆê‰‹t‚àİ’èj
    unless petit_devil_link?($data_SDB[self.class_id])
      if self.have_ability?("¬ˆ«–‚‚Ì˜AŒg", "ORIGINAL")
        self.remove_ability(81)
        self.gain_ability(82)
      end
    else
      if self.have_ability?("¬ˆ«–‚‚Ì“—¦", "ORIGINAL")
        self.remove_ability(82)
        self.gain_ability(81)
      end
    end
    # ƒfƒtƒHŒÄÌ‚ğİ’è
    @defaultname_self = nil
    @defaultname_hero = nil
    $msg.defaultname_select(self)    
  end
  #--------------------------------------------------------------------------
  # œ –• “x ‚Ì‘Œ¸
  #--------------------------------------------------------------------------
  def fed=(fed)
    @fed = fed
    @fed = [[@fed, 100].min, 0].max
    if @fed > 20 and self.state?(15)
      self.remove_state(15)
      # í“¬’†‚É‰ñ•œ‚µ‚½ê‡‚ÍƒƒO‚ğo‚·
      if $game_temp.in_battle
        self.remove_states_log.delete($data_states[15])
        text = "\\n#{self.name}'s hunger has been satiated!"
        $game_temp.battle_log_text += text
      end
    end 
  end
  #----------------------------------------------------------------
  # œ K“¾ƒŠƒZƒbƒg
  #----------------------------------------------------------------
  def learn_reset(type = 0)
    skills_box    = []
    abilities_box = []
    if type == 0
      # Œ_–ñ‚Ìì‚ÅK“¾‚Å‚«‚é‚à‚Ì‚Í•Û
      for bonus in $data_classes[self.class_id].bonus
        case bonus[1]
        when 0 # ƒXƒLƒ‹
          if self.skill_learn?(bonus[2],"ORIGINAL")
            skills_box.push(bonus[2])
          end
        when 1 # ‘f¿
          if self.have_ability?(bonus[2],"ORIGINAL")
            abilities_box.push(bonus[2])
          end
        end
      end
    end
    # •Û‚µ‚½‚¢‘f¿‚ğ•Û
    keep_ability = []
    for i in 1..61 # ã“_“™‚Ìæ“V‘f¿‚Í•Û
      keep_ability.push(i)
    end
    for i in 301..400 # ƒz[ƒ‹ƒhƒXƒLƒ‹K“¾‘f¿‚à•Û
      keep_ability.push(i)
    end
    for keep in keep_ability
      if self.have_ability?(keep,"ORIGINAL")
        abilities_box.push(keep)
      end
    end
    abilities_box.uinq! # d•¡‚ğÁ‚·
    # ƒŠƒtƒŒƒbƒVƒ…‚³‚¹‚é
    self.skills = skills_box.sort
    self.ability = abilities_box.sort
    # ƒz[ƒ‹ƒhƒXƒLƒ‹K“¾‘f¿‚ª”²‚¯‚Ä‚¢‚éê‡A‚±‚ê‚ğÄ‘•“U
    for skill_id in self.skills
      case skill_id
      when 5  # ƒVƒFƒ‹ƒ}ƒbƒ`
        self.gain_ability(303)
      when 6  # ƒCƒ“ƒT[ƒg 
        self.gain_ability(301) 
      when 16 # ƒhƒƒEƒlƒNƒ^[
        self.gain_ability(306)
      when 17 # ƒGƒ“ƒuƒŒƒCƒX
        self.gain_ability(305)
      when 18 # ƒGƒLƒTƒCƒgƒrƒ…[
        self.gain_ability(304)
      end
    end
    #ƒŒƒxƒ‹‘Ñ‚É‰‚¶‚ÄƒXƒLƒ‹‚ğÄæ“¾
    for i in 1..self.level
      for j in $data_classes[self.class_id].learnings
        if j[0] == i
          if j[1] == 0
            learn_skill(j[2])
          else
            gain_ability(j[2])
          end
        end
      end
    end
  end
end