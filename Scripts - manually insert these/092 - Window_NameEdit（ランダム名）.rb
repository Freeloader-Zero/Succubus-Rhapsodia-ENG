#==============================================================================
# ■ Window_NameEdit
#------------------------------------------------------------------------------
# 　ランダム名格納。
#==============================================================================

class Window_NameEdit < Window_Base
  #--------------------------------------------------------------------------
  # ● ランダム名
  #　　type 0:丸ごと取得 1:専用名のみ取得
  #--------------------------------------------------------------------------
  def random_name(type)
    common_name_list = []
    special_name_list = []
    # 共通の名前を取得(主人公は省く)
    if @actor != $game_actors[101]
      common_name_list = [
      "Luna",
      "Paprika",
      "Cocoa",
      "Melfeina",
      "Fiorel",
      "Meine",
      "Rendra",
      "Yutona",
      "Eriju",
      "Braveru",
      "Ralai",
      "Vanilla",
      "Oiuri",
      "Ofura",
      "Reine",
      "Torulte",
      "Chunia",
      "Rufurde",
      "Ashby",
      "Hyusure",
      "Myu",
      "Sophie",
      "Sorunia",
      "Kaloris",
      "Delｗeiss",
      "Kalｍiria",
      "Carane",
      "Tau",
      "Buracche",
      "Zateibi",
      "Eｍily",
      "Renenge",
      "Fenichi",
      "Kaｍira",
      "Mireyu",
      "Krisena",
      "Zarea",
      "Terapalｍ",
      "Lure",
      "Snipe",
      "Neuru",
      "Bianca",
      "Hayuz",
      "Carlen",
      "Lindeia",
      "Finis",
      "Feruve",
      "Luraver",
      "Atoris",
      "Angie",
      "Feｍibelle",
      "Hayonehayona",
      "Equipｍe",
      "Neｗ",
      "Holy",
      "Marika",
      "Safonse",
      "Fufululu",
      "Mintoa",
      "Shia",
      "Ryueru",
      "Torikushi",
      ]
    else
      common_name_list = [
      "Laurat"
      ]
    end
    # 種族毎の名前を追加
    case $data_classes[@actor.class_id].name
    #------------------------------------------------------------------------
    # ■■人間
    #------------------------------------------------------------------------
    when "Huｍan"
      special_name_list = [
      "Laurat",
      "Laurence",
      "Lauren"
      ]
    #------------------------------------------------------------------------
    # ■■サキュバス種
    #------------------------------------------------------------------------
    when "Lesser Succubus "
      special_name_list = [
      "Reki",
      "Dea",
      "Cherito",
      "Nancy",
      "Mystoria",
      "Sue",
      "Ravi",
      "Aｍore",
      "Aini",
      "Reeve",
      "Shita",
      "Polkel",
      "Belura",
      "Nue"
      ]
    when "Succubus"
      special_name_list = [
      "Leone",
      "Fise",
      "Frau",
      "Elise",
      "Proｍethe",
      "Luka",
      "Meria",
      "Litoria",
      "Lulu",
      "Korapto",
      "Misty",
      "Carla",
      "Eraste"
      ]
    when "Succubus Lord "
      special_name_list = [
      "Estella",
      "Benevian",
      "Rocca-Voke",
      "Maya",
      "Ashiera",
      "Voluvue",
      "Anu",
      "Vivio",
      "Moria",
      "Teia",
      "Cetar"
      ]
    #------------------------------------------------------------------------
    # ■■デビル種
    #------------------------------------------------------------------------
    when "Iｍp"
      special_name_list = [
      "Mini",
      "Murin",
      "Pluｍ",
      "Naughty",
      "Al",
      "Petit",
      "Meｍe",
      "Pickle",
      "Fay",
      "Le Roux"
      ]
    when "Devil "
      special_name_list = [
      "Ain",
      "Carol",
      "Marla",
      "Sione",
      "Reiger",
      "Folse",
      "Aｍy",
      "Andrea",
      "Levianne",
      "Laura"
      ]
    when "Deｍon"
      special_name_list = [
      "Griselle",
      "Zapito",
      "Zasrida",
      "Nicceres",
      "Graafa",
      "Leien",
      "Labiella",
      "Noralas",
      "Aster",
      "Verio"
      ]
    #------------------------------------------------------------------------
    # ■■ウィッチ種
    #------------------------------------------------------------------------
    when "Little Witch"
      special_name_list = [
      "Petronia",
      "Sarii",
      "Kiki",
      "Theodora",
      "Isabeau",
      "Curio",
      "Genius",
      "Ceres",
      "Paletta",
      "Teira",
      "Little Mouse",
      "Ariel"
      ]
    when "Witch "
      special_name_list = [
      "Lefy",
      "Vanessa",
      "Wikka",
      "Eva",
      "Glende",
      "Benetta",
      "Marie",
      "Pachie",
      "Margot",
      "Deiretta",
      "Cantante",
      "Learese"
      ]
    #------------------------------------------------------------------------
    # ■■キャスト種
    #------------------------------------------------------------------------
    when "Caster"
      special_name_list = [
      "Ann",
      "Laura",
      "Margaret",
      "Sarah",
      "Wendy",
      "Flone",
      "Coco",
      "Cathy",
      "Iria",
      "Rebecca",
      "Francois",
      "Mary",
      "Chris",
      "Sea",
      "Jane"
      ]
    #------------------------------------------------------------------------
    # ■■スレイヴ種
    #------------------------------------------------------------------------
    when "Slave "
      special_name_list = [
      "Kashieu",
      "Ouida",
      "Santoｍue",
      "Elｍinae",
      "Tanjea",
      "Sofar",
      "Zera",
      "Malkara",
      "Canon",
      ]
    #------------------------------------------------------------------------
    # ■■ナイトメア種
    #------------------------------------------------------------------------
    when "Nightｍare"
      special_name_list = [
      "Hypnox",
      "Mesｍerique",
      "Isles",
      "Kasuｍe",
      "Mabelle",
      "Teita",
      "Cthulhu",
      "Reｍ",
      "Mary",
      "Mea",
      "Meniki",
      "Flo"
      ]
    #------------------------------------------------------------------------
    # ■■スライム種
    #------------------------------------------------------------------------
    when "Sliｍe"
      special_name_list = [
      "Jelly",
      "Paroa",
      "Pudding",
      "Mousse",
      "Lathe",
      "Sue",
      "Panna",
      "Suｍli",
      "Beth",
      "Bubble",
      "Jiggly",
      "Liｍe"
      ]
    when "Gold Sliｍe "
      special_name_list = [
      "Aiyu",
      "Rochuon",
      "Midasa",
      "Paqua",
      "Hanaki",
      "Leidei",
      "Yelloｗ",
      "Tiara",
      "Nanajik",
      "Eoroyo"
      ]
    #------------------------------------------------------------------------
    # ■■ファミリア種
    #------------------------------------------------------------------------
    when "Familiar"
      special_name_list = [
      "Lotta",
      "Challis",
      "Viola",
      "Eｍilia",
      "Peria",
      "Kiｍora",
      "Silk",
      "Ruｍba",
      "Faｍi"
      ]
    #------------------------------------------------------------------------
    # ■■ワーウルフ種
    #------------------------------------------------------------------------
    when "Werewolf"
      special_name_list = [
      "Kerube",
      "Orotoro",
      "Enrir",
      "Leica",
      "Peria",
      "Lugaru",
      "Hattei",
      "Skorr",
      "Hachiko"
      ]
    #------------------------------------------------------------------------
    # ■■ワーキャット種
    #------------------------------------------------------------------------
    when "Werecat "
      special_name_list = [
      "Taｍa",
      "Bastetta",
      "Kay",
      "Sekette",
      "Kitei",
      "Shuridan",
      "Butter-bun",
      "Nyaaｍi",
      "Naｍeless",
      ]
    #------------------------------------------------------------------------
    # ■■ゴブリン種
    #------------------------------------------------------------------------
    when "Goblin"
      special_name_list = [
      "Pirederi",
      "Mogfana",
      "Gabrude",
      "Granada",
      "Kukuri",
      "Frela",
      "Ningusta",
      "Nakuru",
      "Mortara",
      "Diana",
      ]
    when "Goblin Leader "
      special_name_list = [
      "Rinri",
      "Chieftain",
      "Akaboosh",
      "Heartｍen",
      "Taboo",
      "Bodua",
      "Naoe",
      "Kanshin",
      "Zappi",
      ]
    #------------------------------------------------------------------------
    # ■■プリーステス種
    #------------------------------------------------------------------------
    when "Priestess "
      special_name_list = [
      "Marielle",
      "Ursula",
      "Catalina",
      "Anastasia",
      "Anna",
      "Veronica",
      "Polonia",
      "Julia",
      "Eularia",
      ]
    #------------------------------------------------------------------------
    # ■■カースメイガス種
    #------------------------------------------------------------------------
    when "Cursed Magus"
      special_name_list = [
      "Marefy",
      "Godel",
      "Asura",
      "Ravena",
      "Griｍhild",
      "Warp",
      "Saleｍ",
      "Bellatrix",
      "Tsusuruk",
      ]
    #------------------------------------------------------------------------
    # ■■アルラウネ種
    #------------------------------------------------------------------------
    when "Alraune "
      special_name_list = [
      "Namizuki",
      "Dizzy",
      "Asia",
      "Churada",
      "Jikidari",
      "Clover",
      "Dalli",
      "Haidoreji",
      "Hozuki",
      ]
    #------------------------------------------------------------------------
    # ■■マタンゴ種
    #------------------------------------------------------------------------
    when "Matango "
      special_name_list = [
      "Quen",
      "Sasako",
      "Tsukiyo",
      "Dokutsuru",
      "Benny",
      "Shagｍa",
      "Saura",
      "Warai",
      "Majru",
      "Etori",
      "Wanape",
      ]
    #------------------------------------------------------------------------
    # ■■エンジェル種
    #------------------------------------------------------------------------
    when "Dark Angel"
      special_name_list = [
      "Aster",
      "Moann",
      "Zazeru",
      "Belia",
      "Masty",
      "Meriku",
      "Fleur",
      "Shaｍe",
      "Shyton",
      "Israph"
      ]
    #------------------------------------------------------------------------
    # ■■ガーゴイル種
    #------------------------------------------------------------------------
    when "Gargoyle"
      special_name_list = [
      "Grisaiyu",
      "Deanne",
      "Esu",
      "Pelide",
      "Aｍuto",
      "Nelly",
      "Konia",
      "Azure"
      ]
    #------------------------------------------------------------------------
    # ■■ミミック種
    #------------------------------------------------------------------------
    when "Miｍic"
      special_name_list = [
      "Pandora",
      "Kyabii",
      "Trappe",
      "Brudan",
      "Kottori",
      "Kofin",
      "Hanｍakido",
      "Dorosera",
      "Nepentus",
      "Fultora"
      ]
    #------------------------------------------------------------------------
    # ■■タマモ種
    #------------------------------------------------------------------------
    when "Taｍaｍo"
      special_name_list = [
      "Inari",
      "Ducky",
      "Ninetails",
      "Yako",
      "Tsune",
      "Myobu",
      "Kasaｍa",
      "Fushiｍi",
      "Mikuzu",
      "Kuzuno",
      "Shino",
      "Ushiuka"
      ]
    #------------------------------------------------------------------------
    # ■■リリム種
    #------------------------------------------------------------------------
    when "Liliｍ"
      special_name_list = [
      "Rias",
      "Grette",
      "Dorthea",
      "Lize",
      "Cindy",
      "Carlain",
      "Taria",
      "Rapshia",
      "Redfuda",
      ]
    end
    
    name_list = special_name_list
    name_list += common_name_list if name_list == []
    name_list += common_name_list if type == 0
    # 今付いている名前がある場合は省く
    name_list.delete(@name)
    return name_list
  end
end
