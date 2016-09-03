#
# Basically, the English words database. 
# I'd rather not use it for all purposes, 
# but hopefully, it will help around
#
def is_translated?(moonrune)
  begin
    if moonrune.translation_check != moonrune
      return true
    else
      return false
    end
      rescue 
      p "something went awry with is_translated?"
      return false
  end
end

def translation_check
# moonrune.translation_check will return:
# the English word if in database
# moonrune if not
    
    
    return self if not self.is_a?(String)
    case self.split(/\//)[0]

    # enemies/classes
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
when "ユニークサキュバス"
   return "Unique Succubus"
   
#personalities
when "好色"
   return "Lusty"
when "上品"
   return "Refined"
when "高慢"
   return "Proud"
when "淡泊"
   return "Frank"
when "柔和"
   return "Gentle"
when "勝ち気"
   return "Adamant"
when "内気"
   return "Shy"
when "陽気"
   return "Happy"
when "意地悪"
   return "Crafty"
when "天然"
   return "True"
when "従順"
   return "Obedient"
when "虚勢"
   return "Gutsy"
when "倒錯"
   return "Pervert"
when "甘え性"
   return "Addicted"
when "不思議"
   return "Strange"
when "真面目"
   return "Serious"
when "腕白"
   return "Naughty"
when "冷静"
   return "Composed"
when "独善" # ▼フルビュアの性格
   return "Conceited"
when "気丈" # ▼リジェオの性格　勝ち気ベース
   return "Headstrong"
when "暢気" # ▼ネイジュレンジの性格　柔和ベース
   return "Easygoing"
when "陰気" # ▼ユーガノットの性格　天然ベース
   return "Depressed"
when "尊大" # ▼ギルゴーンの性格　虚勢ベース
   return "Haughty"
when "高貴" # ▼シルフェの性格　上品ベース
   return "Noble"
when "潔癖" # ▼ラーミルの性格　真面目ベース
   return "Subtle"
when "露悪狂" # ▼ヴェルミィーナの性格　倒錯ベース
   return "Crazy devil"
when "未設定"
   return "Undefined"
  
   #skills
when "服を脱がす"
   return "Strip"
when "服を脱ぐ"
   return "Undress"
when "シェルマッチ"
   return "Scissors"
when "インサート"
   return "Insert"
when "オーラルインサート"
   return "Oral insert"
when "バックインサート"
   return "Backdoor insert"
when "トーク"
   return "Talk"
when "トークレジスト"
   return "Sweet talk"
when "アクセプト"
   return "Invite"
when "オーラルアクセプト"
   return "Oral invite"
when "バックアクセプト"
   return "Backdoor invite"
when "ドロウネクター"
   return "Tongue insert"
when "エンブレイス"
   return "Embrace"
when "エキサイトビュー"
   return "Straddle"
when "ディルドインサート"
   return "Dildo insert"
when "ディルドインマウス"
   return "Dildo gag"
when "ディルドインバック"
   return "Anal plug-in"
when "デモンズアブソーブ"
   return "Feeler suck-in"
when "デモンズドロウ"
   return "Feeler insert"
when "インタラプト"
   return "Interrupt"
when "リリース"
   return "Release"
when "ストラグル"
   return "Struggle"
when "スウィング"
   return "Thrust"
when "ヘヴィスウィング"
   return "Piston"
when "ディルドスウィング"
   return "Strapon thrust"
when "ラビングピストン"
   return "Chest frottage"
when "オーラルピストン"
   return "Throat piston"
when "オーラルディルド"
   return "Throat dildo"
when "バックピストン"
   return "Anal thrust"
when "バックディルド"
   return "Dildo ram"
when "グラインド"
   return "Grind"
when "ハードグラインド"
   return "Wild ride"
when "タイトクロッチ"
   return "Tighten"
when "スクラッチ"
   return "Tribadism"
when "ハードスクラッチ"
   return "Rubdown"
when "ライディング"
   return "Facerub"
when "プッシング"
   return "Facepress"
when "スロート"
   return "Blowjob"
when "ディープスロート"
   return "Deepthroat"
when "ドロウスロート"
   return "Suck on"
when "サック"
   return "Lick"
when "スクイーズ"
   return "Squeeze"
when "タイトホール"
   return "Tighten"
when "リック"
   return "Lick pussy"
when "リック"
   return "Lick ass"
when "ミスチーフ"
   return "Tickle"
when "リアカレス"
   return "Caress"
when "レックレス"
   return "Squirm"
when "キッス"
   return "Kiss"
when "バスト"
   return "Chest"
when "ヒップ"
   return "Hips"
when "クロッチ"
   return "Crotch"
when "カレス"
   return "Caress"
when "キッス"
   return "Kiss"
when "ツーパフ"
   return "Chest press"
when "ティーズ"
   return "Tease"
when "ミスチーフ（没）"
   return "Tease out"
when "ファストレイド"
   return "Quick raid"
when "トリックレイド"
   return "Trick raid"
when "ディバウアー"
   return "Devour"
when "プレジャー"
   return "Self-pleasure"
when "ブレス"
   return "Breath"
when "カームブレス"
   return "Calm breath"
when "ウェイト"
   return "Wait"
when "イントラスト"
   return "Entrust"
when "リフレッシュ"
   return "Refresh"
when "チェック"
   return "Check"
when "アナライズ"
   return "Analyze"
when "ストリップ"
   return "Striptease"
when "テンプテーション"
   return "Temptation"
when "ガード"
   return "Guard"
when "インデュア"
   return "Endure"
when "アピール"
   return "Appeal"
when "プロヴォーク"
   return "Provoke"
when "イリスシード"
   return "Heal seed"
when "イリスペタル"
   return "Heal petal"
when "イリスフラウ"
   return "Heal aura"
when "イリスコロナ"
   return "Heal halo"
when "イリスシード・アルダ"
   return "Mass Heal seed"
when "イリスペタル・アルダ"
   return "Mass Heal petal"
when "イリスフラウ・アルダ"
   return "Mass Heal aura"
when "ラナンブルム"
   return "Charisma"
when "ラナンブルム・アルダ"
   return "Mass Charisma"
when "ラナンイーザ"
   return "Disgrace"
when "ラナンイーザ・アルダ"
   return "Mass Disgrace"
when "ネリネブルム"
   return "Resistance"
when "ネリネブルム・アルダ"
   return "Mass Resistance"
when "ネリネイーザ"
   return "Vulnerability"
when "ネリネイーザ・アルダ"
   return "Mass Vulnerability"
when "エルダブルム"
   return "Energy"
when "エルダブルム・アルダ"
   return "Mass Energy"
when "エルダイーザ"
   return "Debility"
when "エルダイーザ・アルダ"
   return "Mass Debility"
when "サフラブルム"
   return "Deftness"
when "サフラブルム・アルダ"
   return "Mass Deftness"
when "サフライーザ"
   return "Klutz"
when "サフライーザ・アルダ"
   return "Mass Klutz"
when "コリオブルム"
   return "Haste"
when "コリオブルム・アルダ"
   return "Mass Haste"
when "コリオイーザ"
   return "Slow"
when "コリオイーザ・アルダ"
   return "Mass Slow"
when "アスタブルム"
   return "Mana surge"
when "アスタブルム・アルダ"
   return "Mass Mana surge"
when "アスタイーザ"
   return "Mana drain"
when "アスタイーザ・アルダ"
   return "Mass Mana drain"
when "ストレリブルム"
   return "Efflorescence"
when "ストレリブルム・アルダ"
   return "Mass Efflorescence"
when "ストレリイーザ"
   return "Storm of Decay"
when "ストレリイーザ・アルダ"
   return "Mass Storm of Decay"
when "チャーム"
   return "Charm"
when "ペイド・チャーム"
   return "Mass charm"
when "ラスト"
   return "Lust"
when "ペイド・ラスト"
   return "Mass lust"
when "フィルス"
   return "Flirt"
when "ペイド・フィルス"
   return "Mass flirt"
when "レザラジィ"
   return "Collapse"
when "ペイド・レザラジィ"
   return "Mass Collapse"
when "テラー"
   return "Soften"
when "ペイド・テラー"
   return "Mass soften"
when "パラライズ"
   return "Paralyze"
when "ペイド・パラライズ"
   return "Mass paralyze"
when "ルーズ"
   return "Sleep"
when "ペイド・ルーズ"
   return "Mass sleep"
when "トリムルート"
   return "Body cleanse"
when "トリムストーク"
   return "Mind cleanse"
when "トリムヴァイン"
   return "Removal"
when "ブルムカール"
   return "Dispel"
when "ブルムカール・アルダ"
   return "Mass Dispel"
when "イーザカール"
   return "Uncurse"
when "イーザカール・アルダ"
   return "Mass uncurse"
when "ウォッシュフルード"
   return "Cleansing waters"
when "シャイニングレイジ"
   return "Shining rage"
when "クッキング"
   return "Cook"
when "サーヴァントコール"
   return "Servant talk"
when "ランクアップ"
   return "Rank up"
when "服を脱ぐ"
   return "Undress"
when "ストリップ"
   return "Strip"
when "ショウダウン"
   return "Showdown"
when "服を脱がす"
   return "Expose"
when "品定め"
   return "Check out"
when "手ほどき"
   return "Foreplay"
when "甘やかし"
   return "Indulge"
when "スパンク"
   return "Spank"
when "やけくそ三連撃"
   return "Desperation 3-ways"
when "ヒーローキリング"
   return "Hero killer"
when "メテオエクリプス"
   return "Meteo rain"
when "ワールドブレイカー"
   return "World breaker"
when "スキル決め直し"
   return "Pick again"
when "【RD】キッス"
   return "Kiss"
when "【RD】手攻め"
   return "Attack w/ hand"
when "【RD】口攻め"
   return "Attack w/ mouth"
when "【RD】胸攻め"
   return "Attack w/ chest"
when "【RD】アソコ攻め"
   return "Attack w/ pussy"
when "【RD】足攻め"
   return "Attack w/ feet"
when "【RD】愛撫"
   return "Caress"
when "【RD】尻尾攻め"
   return "Tail attack"
when "【RD】道具攻め"
   return "Tool attack"
when "【RD】特殊身体攻め"
   return "Special anatomy attack"
when "【RD】ホールド技"
   return "Hold attack"
when "【RD】自分ホールド中の攻め"
   return "Attack while held"
when "【RD】味方ホールド中の援護"
   return "Defend held friend"
when "【RD】コンフューズ"
   return "Confused"
when "フィアー"
   return "Fear"
when "フリーアクション"
   return "Free action"
when "エモーション"
   return "Emotion"
when "セットサークル"
   return "Set circle"
when "コールドタッチ"
   return "Cold touch"
when "サディストカレス"
   return "Hand of sadist"
when "プライスオブハレム"
   return "Harem Master"
when "プライスオブシナー"
   return "Bushin pleasure"
when "ペルソナブレイク"
   return "Persona break"
when "キャストエントリー"
   return "Caster gate"
when "ハウリング"
   return "Howling"
when "魔性の口付け"
   return "Evil kiss"
when "祝福の口付け"
   return "Blessing kiss"
when "スイートウィスパー"
   return "Sweet whisper"
when "アンラッキーロア"
   return "Dejected love"
when "アンラッキーロア"
   return "Dejected love"
when "懺悔なさい"
   return "Confess"
when "レストレーション"
   return "Restoration"
when "スライミーリキッド"
   return "Slimy fluids"
when "激励"
   return "Cheer"
when "バッドスポア"
   return "Noxious spores"
when "スポアクラウド"
   return "Spore cloud"
when "アイヴィクローズ"
   return "Entangle"
when "デモンズクローズ"
   return "Demon wrap"
when "焦燥"
   return "Aggravate"
when "専心"
   return "Concentration"
when "本能の呼び覚まし"
   return "Primal instincts"
when "自信過剰"
   return "Overconfidence"
when "リラックスタイム"
   return "Relaxation time"
when "スイートアロマ"
   return "Sweet aroma"
when "パッションビート"
   return "Passion beats"
when "マイルドパフューム"
   return "Mild prefume"
when "レッドカーペット"
   return "Red carpet"
when "ストレンジスポア"
   return "Strange spores"
when "ウィークスポア"
   return "Weakening spores"
when "威迫"
   return "Intimidate"
when "心掴み"
   return "Heart grasp"
when "全ては現"
   return "One with the flow"
when "ラブフレグランス"
   return "Love fragrance"
when "スライムフィールド"
   return "Slime field"
when "激励を受ける"
   return "Encourage"
when "アクセプト"
   return "Cowgirl invite"
when "シェルマッチ"
   return "Scissors"
when "エキサイトビュー"
   return "Straddle"
when "オーラルアクセプト"
   return "Oral insert"
when "ドロウネクター"
   return "Tongue insert"
when "フラッタナイズ"
   return "Lock lips"
when "バックアクセプト"
   return "Anal invite"
when "インモラルビュー"
   return "Reverse straddle"
when "エンブレイス"
   return "Embrace"
when "エキシビジョン"
   return "Shameful display"
when "ペリスコープ"
   return "Oppai invite"
when "ヘブンリーフィール"
   return "Heaven's feel"
when "インサート"
   return "Insert"
when "オーラルインサート"
   return "Oral insert"
when "バックインサート"
   return "Backdoor insert"
when "インサートテイル"
   return "Tail insert"
when "マウスインテイル"
   return "Tail mouth insert"
when "バックインテイル"
   return "Tail anal insert"
when "ディルドインサート"
   return "Dildo insert"
when "ディルドインマウス"
   return "Dildo gag"
when "ディルドインバック"
   return "Anal plug-in"
when "アイヴィクローズ"
   return "Entangle"
when "デモンズクローズ"
   return "Demon wrap"
when "デモンズアブソーブ"
   return "Feeler suck-in"
when "デモンズドロウ"
   return "Feeler insert"
when "インサルトツリー"
   return "Tentacle wrap"
when "エナジードレイン"
   return "Energy drain"
when "レベルドレイン"
   return "Level drain"
when "もがく"
   return "Struggle"

    #states
when "失神"
   return "KO"
when "衰弱"
   return "Weak"
when "絶頂"
   return "Climax"
when "半裸"
   return "Half-nude"
when "全裸"
   return "Naked"
when "クライシス"
   return "Crisis"
when "裸"
   return "Nude"
when "挿入"
   return "Insert"
when "汁（ぶっかけ）"
   return "Cum(out)"
when "汁（中出し）"
   return "Cum(in)"
when "絶頂"
   return "Climax"
when "ホールド解除リキャスト"
   return "Hold re-cast"
when "ディレイ"
   return "Delay"
when "秘所潤滑度↑"
   return "Lubricated"
when "空腹"
   return "Hungry"
when "スタン"
   return "Stun"
when "苦痛スタン"
   return "Hurt"
when "ふたなり化"
   return "Hermaphrodite"
when "潤滑♂（少）"
   return "Lubed♂（-）"
when "潤滑♂（多）"
   return "Lubed♂（+）"
when "潤滑♀（少）"
   return "Lubed♀（-）"
when "潤滑♀（多）"
   return "Lubed♀（+）"
when "潤滑♀（溢）"
   return "Lubed♀（++）"
when "潤滑Ａ（少）"
   return "LubedＡ（-）"
when "潤滑Ａ（多）"
   return "LubedＡ（+）"
when "粘液潤滑（少）"
   return "Mucus Lube(-)"
when "粘液潤滑（多）"
   return "Mucus Lube(+)"
when "スライム"
   return "Slime"
when "淫毒"
   return "Aphrodisiac"
when "ローション"
   return "Oiled"
when "スタン：ドキドキ"
   return "Stun:dokidoki"
when "スタン：びっくり"
   return "Stun:off-guard"
when "恍惚"
   return "Ecstasy"
when "欲情"
   return "Desire"
when "暴走"
   return "Rut"
when "虚脱"
   return "Sapped"
when "畏怖"
   return "Soft"
when "麻痺"
   return "Paralyzed"
when "散漫"
   return "Tipsy"
when "高揚"
   return "Merry"
when "沈着"
   return "Calm"
when "全身感度アップ"
   return "Sensitive"
when "口感度アップ"
   return "Mouth sensitive"
when "胸感度アップ"
   return "Chest sensitive"
when "尻感度アップ"
   return "Ass sensitive"
when "♂感度アップ"
   return "♂ sensitive"
when "♀感度アップ"
   return "♀ sensitive"
when "魅力+200％"
   return "CHR+100%"
when "魅力+150％"
   return "CHR+50%"
when "魅力-25％"
   return "CHR-25%"
when "魅力-50％"
   return "CHR-50%"
when "忍耐+40％"
   return "WIL+40%"
when "忍耐+20％"
   return "WIL+20%"
when "忍耐-15％"
   return "WIL-15%"
when "忍耐-30％"
   return "WIL-30%"
when "精力+200％"
   return "POW+100%"
when "精力+150％"
   return "POWr+50%"
when "精力-25％"
   return "POW-25%"
when "精力-50％"
   return "POW-50%"
when "器用さ+200％"
   return "DEX+100%"
when "器用さ+150％"
   return "DEX+50%"
when "器用さ-25％"
   return "DEX-25%"
when "器用さ-50％"
   return "DEX-50%"
when "素早さ+200％"
   return "DEX"
when "素早さ+150％"
   return "SPD+50%"
when "素早さ-25％"
   return "SPD-25%"
when "素早さ-50％"
   return "SPD-50%"
when "精神力+200％"
   return "MAG+100%"
when "精神力+150％"
   return "MAG+50%"
when "精神力-25％"
   return "MAG-25%"
when "精神力-50％"
   return "MAG-50%"
when "ステート増加"
   return "Stat up"
when "ステート減少"
   return "Stat down"
when "ステート全増加"
   return "All stats up"
when "ステート全減少"
   return "All stats down"
when "ステート維持"
   return "Stats neutral"
when "強化ステート解除"
   return "Buff locked"
when "弱体ステート解除"
   return "Debuff locked"
when "能力変化ステート全解除"
   return "Stats locked"
when "満腹度・小回復"
   return "Satiated"
when "防御"
   return "Defense"
when "堅守"
   return "Iron wall"
when "無防備"
   return "Begging"
when "誘引"
   return "Enticed"
when "キススイッチON"
   return "Kiss switch ON"
when "魔法陣"
   return "Magic circle"
when "マーキング"
   return "Marked"
when "マゾスイッチON"
   return "Masochist ON"
when "祝福"
   return "Blessed"
when "焦燥"
   return "Irritated"
when "専心"
   return "Focused"
when "挑発"
   return "Provoke"
when "拘束"
   return "Restrained"
when "破面"
   return "Crazed"    
    
   #Abilities, some might have been returned by skills already
when "男"
   return "Male"
when "女"
   return "Female"
when "口攻めに弱い"
   return "Mouth fetish"
when "手攻めに弱い"
   return "Hand fetish"
when "胸攻めに弱い"
   return "Tits fetish"
when "女陰攻めに弱い"
   return "Pussy fetish"
when "嗜虐攻めに弱い"
   return "M fetish"
when "異形攻めに弱い"
   return "Monmusu fetish"
when "性交に弱い"
   return "Quick shot"
when "肛虐に弱い"
   return "Weak to anal"
when "口が性感帯"
   return "Weak mouth"
when "淫唇"
   return "Lewd mouth"
when "胸が性感帯"
   return "Weak chest"
when "淫乳"
   return "Lewd chest"
when "お尻が性感帯"
   return "Weak ass"
when "淫尻"
   return "Lewd ass"
when "菊座が性感帯"
   return "Weak rosette"
when "淫花"
   return "Lewd rosette"
when "陰核が性感帯"
   return "Weak clit"
when "淫核"
   return "Lewd clit"
when "女陰が性感帯"
   return "Weak vagina"
when "淫壺"
   return "Lewd vagina"
when "キッス熟練"
   return "Kisses mastery"
when "バスト熟練"
   return "Breasts mastery"
when "ヒップ熟練"
   return "Ass mastery"
when "クロッチ熟練"
   return "Pussy mastery"
when "インサート熟練"
   return "Piston mastery"
when "ホールド熟練"
   return "Wrestling mastery"
when "手技の心得"
   return "Hand arts"
when "舌技の心得"
   return "Tongue arts"
when "胸技の心得"
   return "Chest arts"
when "愛撫の心得"
   return "Caress arts"
when "加虐の心得"
   return "Domme arts"
when "被虐の心得"
   return "Sub arts"
when "性交の心得"
   return "Sex arts"
when "呼吸の心得"
   return "Breath mastery"
when "最高の姿"
   return "The best body"
when "童貞"
   return "Virgin"
when "初めてを奪った"
   return "Ravished"
when "処女"
   return "Maiden"
when "初めてを奪われた"
   return "Deflowered"
when "天女の純潔"
   return "Heavenly maiden"
when "両性具有"
   return "Futanari"
when "母乳体質"
   return "Lactating"
when "寵愛"
   return "Favor"
when "大切な人"
   return "Trust"
when "吸精"
   return "Soul-sucking"
when "サディスト"
   return "Sadist"
when "マゾヒスト"
   return "Masochist"
when "カリスマ"
   return "Charisma"
when "ショーストリップ"
   return "Stripteaser"
when "メタモルフォーゼ"
   return "Metamorphosis"
when "小悪魔の連携"
   return "Goblin teamwork"
when "小悪魔の統率"
   return "Goblin leadership"
when "慧眼"
   return "Keen eyes"
when "毒の体液"
   return "Poison body"
when "確固たる自尊心"
   return "Unshakable pride"
when "過敏な身体"
   return "Hypersensitive body"
when "先読み"
   return "Forereading"
when "妄執"
   return "Compulsive obsession"
when "スタミナ"
   return "Stamina"
when "調理知識"
   return "Cooking knowledge"
when "魔法知識"
   return "Magic knowledge"
when "濡れやすい"
   return "Wet"
when "濡れにくい"
   return "Dry"
when "平静"
   return "Calm mind"
when "活気"
   return "Vigorous"
when "胆力"
   return "Courage"
when "柔軟"
   return "Flexible"
when "一心"
   return "Stout"
when "粘体"
   return "Slimy body"
when "プロテクション"
   return "Magic ward"
when "ブロッキング"
   return "Shielded"
when "厚着"
   return "Heavy clothes"
when "免疫力"
   return "Immunity"
when "高揚"
   return "Merry"
when "沈着"
   return "Calm"
when "快楽主義"
   return "Epicurian"
when "ロマンチスト"
   return "Romantic"
when "熟練"
   return "Techniques mastery"
when "自信過剰"
   return "Overconfident"
when "焦欲"
   return "Greedy"
when "執拗な攻め"
   return "Obstinate"
when "洞察力"
   return "Insight"
when "挑発的"
   return "Provocative"
when "ボディアロマ"
   return "Sweet aroma"
when "魅惑的"
   return "Fascinating"
when "サンチェック"
   return "Awesome presence"
when "平穏の保証"
   return "Peacekeeper"
when "バッドチェイン"
   return "Trick chain"
when "自慰癖"
   return "Onanist"
when "精液中毒"
   return "Cum addict"
when "無我夢中"
   return "Desperado"
when "対抗心"
   return "Indomitable"
when "自制心"
   return "Self-control"
when "淫魔の体質"
   return "Lust demon body"
when "超暴走"
   return "Berserker"
when "キススイッチ"
   return "Kiss switch"
when "マゾスイッチ"
   return "Masochist switch"
when "エクスタシーボム"
   return "Explosive orgasm"
when "封印の呪い"
   return "Sealed"
when "ＥＰヒーリング"
   return "EP recovery"
when "ＶＰヒーリング"
   return "VP recovery"
when "回復力"
   return "Healthy"
when "溢れる回復力"
   return "Very healthy"
when "生命力"
   return "Energetic"
when "溢れる生命力"
   return "Very energetic"
when "経験活用力"
   return "Quick learner"
when "蒐集"
   return "Collector"
when "金運"
   return "Gold digger"
when "風音への利き耳"
   return "Wind whispers"
when "ダウジング"
   return "Dowser"
when "シールスタンプ"
   return "Sealer"
when "ダウト"
   return "Doubtful"
when "奇襲の備え"
   return "Ambusher"
when "警戒の備え"
   return "Sentry"
when "隙無し走法"
   return "Dasher"
when "逃走の極意"
   return "Escapist"
when "手際良い採取"
   return "Scavenger"
when "目聡い採取"
   return "Keen harvester"
when "非表示素質テスト"
   return "Headhunter"
when "インサート"
   return "Insert"
when "アクセプト"
   return "Accept"
when "シェルマッチ"
   return "Tribadism"
when "エキサイトビュー"
   return "Straddle"
when "エンブレイス"
   return "Embrace"
when "オーラルセックス"
   return "Oral sex"
when "ペリスコープ"
   return "Breast sex"
when "ヘブンリーフィール"
   return "Heaven's feel"
when "フラッタナイズ"
   return "Lock lips"
when "トレインドホール"
   return "Valley of the Gange"
when "アンドロギュヌス"
   return "Androgynous"
when "テイルマスタリー"
   return "Tail mastery"
when "テンタクルマスタリー"
   return "Feeler mastery"
when "イクイップディルド"
   return "Strapon mastery"
when "アイヴィマスタリー"
   return "Vine mastery"
when "アヌスマーキング"
   return "Anal mastery"
when "バインドマスタリー"
   return "Restraint mastery"
when "料理音痴"
   return "Awful cook"

   
   
    end
  return self
end



############################
#     T O O L B O X        #
############################

def trans_enemies
  b = []
  a = ""
  for i in $data_enemies
    if i != nil and i.name != nil
      oldname = i.name.split(/\//)[0]
      oldname = oldname.gsub("【data】", "").gsub("【fix】","") if oldname.is_a?(String)
      if oldname!= "" and oldname!= nil #and oldname.translation_check != i.UK_name
        a = "when " + i.id.to_s + "   \#" + oldname + "\n"
        b.push(a)
          a = "   return \"" + i.UK_name + "\""
          a = a + "    ***TODO" if oldname == i.UK_name
          a = a + "\n"
          b.push(a)
      end
    end
  end
    open("zzz.txt","a+") do |log|
    log.puts b
    end
end
  
def trans_skills
  b = []
  a = ""
  for i in $data_skills
    if i != nil and i.name != nil
      oldname = i.name.split(/\//)[0]
      if oldname!= "" and oldname!= nil
        a = "when " + i.id.to_s + "   \#" + oldname + "\n"
        b.push(a)
          a = "   return \"" + i.UK_name + "\""
          a = a + "    ***TODO" if oldname == i.UK_name
          a = a + "\n"
          b.push(a)
      end
    end
  end
    open("zzz.txt","a+") do |log|
    log.puts b
    end
end
  
def build_base
  b = []
  a = ""
  for i in $data_states
    if i != nil and i.name != nil
      oldname = i.name.split(/\//)[0]
      if oldname!= "" and oldname!= nil and oldname != i.UK_name
        a = "when \"" + oldname + "\"\n"
#        b.push(a)
          a = a + "   return \"" + i.UK_name + "\""
#          a = a + "    ***TODO" #if oldname == i.UK_name
          a = a + "\n"
          b.push(a)
      end
    end
  end
    open("zzz.txt","a+") do |log|
    log.puts b
    end
end
  
def trans_this
  table = ["陽気","勝ち気","柔和", "高貴", ",",
"意地悪","高慢","虚勢", "気丈", ",",
"好色","上品","倒錯", "独善", ",",
"天然","甘え性", "暢気","内気","従順", "尊大", ",",
"不思議","淡泊","陰気", ",",
"潔癖", "/n",
"露悪狂"]
  b = []
  a = ""
    for i in table
         a = i.translation_check
         b.push(a)
    end
  
    open("zzz.txt","a+") do |log|
    log.puts b
    end
end
