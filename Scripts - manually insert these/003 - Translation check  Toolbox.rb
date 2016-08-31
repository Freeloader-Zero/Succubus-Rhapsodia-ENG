def translation_check
    return self if not self.is_a?(String)
    case self.split(/\//)[0]

    # enemies
when "スライム"
   return "Slime"
when "インプ"
   return "Imp"
when "キャスト"
   return "Caster"
when "レッサーサキュバス"
   return "Lesser Succubus"
when "サキュバス"
   return "Succubus"
when "ナイトメア"
   return "Nightmare"
when "プチウィッチ"
   return "Little Witch"
when "ウィッチ"
   return "Witch"
when "デビル"
   return "Devil"
when "ファミリア"
   return "Familiar"
when "フルビュア"
   return "Fulbeua"
when "ワーウルフ"
   return "Werewolf"
when "リジェオ"
   return "Rejeo"
when "プリーステス"
   return "Priestess"
when "ミミック"
   return "Mimic"
when "ゴブリン"
   return "Goblin"
when "ギャングコマンダー"
   return "Gang Leader"
when "アルラウネ"
   return "Alraune"
when "マタンゴ"
   return "Matango"
when "ワーキャット"
   return "Werecat"
when "ネイジュレンジ"
   return "Neijoronge"
when "カースメイガス"
   return "Cursed Magus"
when "スレイヴ"
   return "Slave"
when "ゴールドスライム"
   return "Gold Slime"
when "シルフェ"
   return "Syplhe"
when "デーモン"
   return "Demon"
when "リリム"
   return "Lilim"
when "ダークエンジェル"
   return "Dark Angel"
when "タマモ"
   return "Tamano"
when "ユーガノット"
   return "Younganoth"
when "サキュバスロード"
   return "Succubus Lord"
when "ガーゴイル"
   return "Gargoyle"
when "ギルゴーン"
   return "Gilgoon"
when "ラーミル"
   return "Rarmil"
when "ヴェルミィーナ"
   return "Vermiena"
when "ラーミルキャスト"
   return "Rarmil Cast"

   
  
    end
  return self
end



############################
#     T O O L B O X        #
############################

def extract_enemies
  b = []
  for i in $data_enemies
    if i != nil
      a = i.name.split(/\//)[0]
      if a!= "" and a!= nil
        a = "when \"" + a + "\"\n"
        b.push(a)
        if b.uniq != b
          b = b.uniq
        else
          a = "   return \"" + i.UK_name + "\"\n"
          b.push(a)
        end
      end
    end
  end
b = b.uniq
    open("Enemies.txt","a+") do |log|
    log.puts b
    end
p "Done!"
end


def extract_items
  b = []
  for i in $data_items
    if i != nil and i.id > 340
      a = i.name.split(/\//)[0]
      if a!= "" and a!= nil
          if i.UK_name != nil and i.UK_name != i.name
            a = "\##{i.id} : "
            a = a + " : " + i.UK_name
          end
          if i.description != nil and i.description != ""
            a = a + "\n    " + i.description
          end
        b.push(a)
      end
    end
  end
b = b.uniq
    open("Items.txt","a+") do |log|
    log.puts b
    end
p "Done!"
end

def extract_skills
  b = []
  for i in $data_skills
    if i != nil and i.id != nil and i.element_set.include?(38)
      a = i.name.split(/\//)[0]
      if a!= "" and a!= nil
          if i.UK_name != nil and i.UK_name != i.name
            a = i.UK_name
          end
          if i.description != nil and i.description != ""
            a = i.id.to_s + "   " + a + ":    " + i.description
          end
        b.push(a)
      end
    end
  end
b = b.uniq
    open("zSkills.txt","a+") do |log|
    log.puts b
    end
p "Done!"
end

def extract_states_old
  b = []
  for i in $data_states
    if i != nil
      a = name.split(/\//)[0]
      if a!= "" and a!= nil
        a = "when \"" + a.to_s + "\"\n"
          if i.UK_name != "" and i.UK_name != i.name
            a = a + "   return \"" + i.UK_name + "\""
          else a = a + "   return \"\""
          end
        b.push(a)
      end
    end
  end
b = b.uniq
    open("States.txt","a+") do |log|
    log.puts b
    end
p "Done!"
end

def extract_states
  b = []
  for i in $data_states
    if i != nil
      a = i.id #name.split(/\//)[0]
      c = i.name.split(/\//)[0]
      if a!= nil and c!= nil #and i.name =~ /^敏感.*/
        a = "when " + a.to_s
        a += "   \#" + c + "\n"
          if i.UK_name != "" and i.UK_name != i.name
            a = a + "   return \"" + i.UK_name + "\""
          else a = a + "   return \"\""
          end
        b.push(a)
      end
    end
  end
b = b.uniq
    open("zzzStates.txt","a+") do |log|
    log.puts b
    end
p "Done!"
end

def extract_ce(id)
for i in $data_common_events[id].list
#    if i.parameters[0].is_a? String
#      if i.parameters[0].scan(/「./) != []
       if i.parameters.size >= 1
         for j in i.parameters
           if j.is_a? Array
             text1 = text2 = ""
             text1 = j[0] if j[0].is_a? String and j[0].scan(/\$./) == []
             text2 = j[1] if j[1].is_a? String and j[1].scan(/\$./) == []
             text1 += " *** " + text2 if text2 != ""
              open("ce.txt","a+") do |log|
              log.puts text1
              end
           end
         if j.is_a? String and j.scan(/\$./) == []  
           open("ce.txt","a+") do |log|
           log.puts j if j.is_a? String and j.scan(/\$./) == []
         end
         

     end
      end
       end
   end
end
#p 227.chr.ord
#p 128.chr
#p 140.chr


def extract_soul
  b = []
  for i in $data_items
    if i != nil and i.recover_hp > 0 and i.element_set.include?(120)
      a = i.name.split(/\//)[0]
      if a!= "" and a!= nil
          if i.UK_name != nil and i.UK_name != i.name
            a = i.UK_name
          end
            description = $data_enemies[i.recover_hp].UK_name
            description = "enemy #{i.recover_hp} ?" if description == nil
            a += " spawns: " + description
#            a += "need to do this" if i.description == ""
        b.push(a)
      end
    end
  end
b = b.uniq
    open("souls.txt","a+") do |log|
    log.puts b
    end
p "Done!"
end

def extract_armor
  b = []
  for i in $data_armors
    if i != nil
      a = i.name.split(/\//)[0]
      if a!= "" and a!= nil
          if i.UK_name != nil and i.UK_name != i.name and i.guard_element_set.include?(169)
            a = a + " : " + i.UK_name
            if i.description != nil and i.description != ""
            a = a + "\n    " + i.description 
          end
        b.push(i.id)
        b.push(a)
      end
      end
    end
  end
#b = b.uniq
    open("Armors.txt","a+") do |log|
    log.puts b
    end
p "Done!"
end

def get100
      for i in $data_enemies
         $game_party.add_enemy_info(i.id,0) if i != nil
         $game_party.add_enemy_info(i.id,1) if i != nil
  #       $game_party.add_enemy_info(i.id,2) if i != nil         
 #        $game_party.add_enemy_info(i.id,3) if i != nil
#         $game_party.add_enemy_info(i.id,4) if i != nil
         end
       end
       
def ex_autostat
  b = []
  for i in $data_states
     next if i == nil
     if i.guard_element_set.include?(160) or
        i.guard_element_set.include?(156) or
        i.guard_element_set.include?(157) or
        i.guard_element_set.include?(158) or
        i.guard_element_set.include?(164) or
        i.guard_element_set.include?(166)
      a = i.id #name.split(/\//)[0]
      c = i.name.split(/\//)[0]
      if a!= nil and c!= nil
        a = "when " + a.to_s
        a += "   \#" + c + "\n"
          if i.UK_name != "" and i.UK_name != i.name
            a = a + "   return \"" + i.UK_name + "\""
          else a = a + "   return \"\""
          end
        b.push(a)
      end
    end
  end
    open("xx States.txt","a+") do |log|
    log.puts b
    end
p "Done!"
end

def test2
  b = []
    for i in $data_states
      if i != nil and i.name =~ /(.*) Fetish/
        weakpoint = $1
        weakpoint = i.id.to_s + weakpoint
        b.push(weakpoint)
      end
   end
    open("zz.txt","a+") do |log|
    log.puts b
    end
  end
  
 def whocanuse(skillid)
  b = []
  for i in $data_enemies
    if i!= nil
      for j in i.actions
        if j != [] 
          b.push(i.id.to_s + " " + i.UK_name) if j.skill_id == skillid
#          b.push(i.UK_name) if i.element_set.include?(38)
        end
      end
    end
 
  #  open("zzz.txt","a+") do |log|
 #   log.puts b if b!= nil
#    end
end
p b
  end
  
def whatinflicts(a)
  for i in $data_skills
    if i != nil
      if i.plus_state_set.include? a
           b = i.id.to_s + "   " + i.UK_name
           open("zz.txt","a+") do |log|
           log.puts b
         end
         end
    end
    end
end
  
def trans_check
  b = ""
  for i in $data_enemies
    if i != nil
    b = i.UK_name if if i.UK_name != i.name.translation_check
           open("zz.txt","a+") do |log|
           log.puts b
         end
       end
       end
  end
end



def clean_skills
for i in 361..469
  a = $data_skills[i]
  b = "id#{a.id} : " + a.name
  b += " / " + a.UK_name if a.UK_name != a.name
  b += "\n"
    for j in a.element_set
      b += "#{$data_system.elements[j]}, "
    end
    b += "that's all"
    b = b.gsub!(", that's all","") + "\n"
    for j in a.plus_state_set
      next if j == nil
    b += "Inflicts : #{$data_states[j].name}, "
    end
      b += "\n\n"

            open("zzzz.txt","a+") do |log|
            log.puts b
            end
  end
end

def trans_enemies
    b = []
    d = []
  for i in $data_skills
    if i != nil and i.name != nil and i.name != "" #[/\//] != nil
    if i.element_set.include?(14)  
      a = i.name #.split(/\//)[0]
      c = a.translation_check
#      if a != c
        d.push(c)
           a = "when " + i.id.to_s + "   \#" + a + "\n"
#          a += "   \#" + c + "\n"
            if i.UK_name != "" and i.UK_name != i.name
              a = a + "   return \"" + c + "\""
            else a = a + "   return \"\""
            end
          b.push(a)
        end
        end
#    end
  end
p b
b = b.uniq
    open("zzz.txt","a+") do |log|
    log.puts b
    end

  end