#placeholder, for now

module RPG
  class Item
    attr_accessor :UK_name
    def UK_name
#      case @id


   
#      end

      text = @name.split(/\//)[0] rescue text = "error: no valid item name"
#      text += " *TODO*" if text != nil
      return text
    end
  end
end

module RPG
  class Armor
    attr_accessor :UK_name
    def UK_name
#      case @id


   
#      end

      text = @name.split(/\//)[0] rescue text = "error: no valid armor name"
#      text += " *TODO*" if text != nil
      return text
    end
  end
end

module RPG
  class Weapon
    attr_accessor :UK_name
    def UK_name
      return @name.split(/\//)[0] rescue text = "error: no weapon here anyway"
    end
  end
end
