# Succubus-Rhapsodia-ENG

==========================================================

English fan translations for the game, "Succubus Rhapsodia"

Game version:
v1.09

Translation version**:
v0.161

**estimated percentage of translation completion

==========================================================

Official Site:
http://succbusrhapsodia.x.fc2.com/top.html

Developer Blog:
http://dreamania.blog.jp/

DLsite:
http://www.dlsite.com/maniax/work/=/product_id/RJ181931

DMM:
http://www.dmm.co.jp/dc/doujin/-/detail/=/cid=d_098909/


==========================================================


Changelogs:

v0.161:
- replaced all script instances with their respective replacements:
	- "\w" with "\065"
	- "\m" with "\066"
	- "\q" with "\067"
	- this is a workaround for the "w", "m", and "q" letters going missing in the battle log (combat messages)
	- reverted the double-byte "ｑ" workaround, going back to the normal single-byte "q" for aesthetic reasons, now that "\q" has been replaced
	- "\y" remains commented out in Window_BattleLog, because it isn't used anyways
	- did not replace "\H" because of how prominently used it is in the events via Map.rxdata files and System/Talk files
- Changed class/enemy name "Neijorage" to "Neijorange", in favor of Strange's assessment of "Neijuranju" (since I also neglected to see the 2nd "n" in the codename "boss_neijurange"
- Reverted class/enemy name "Raｍile " to "Ramile", "Raｍile Caster" to "Ramile Caster "
- Reverted class/enemy name "Verｍiena " to "Vermiena"
- Reverted class/enemy name "Wereｗolf " to "Werewolf"
- Reverted class/enemy name "Faｍiliar " to "Familiar"
- replaced a few "ｗ"s and "ｍ"s in Skill English for sake of making them even bytes
- edited "Mild Prefuｍe" to "Mild Perfume" in Skills English
- revised translation versioning; version now means an estimated percentage of the translation completion of the base game content.


v0.160: (08/31/2016)
- updated scripts v1.09
	- v1.09 added "enemy_before_earnest?" stuff to:
		- Game_Battler Textmake
		- Scene_Battle 4
		- SR_Util other
- translated pre-opening setup scene for Laurat
	- Map227.rxdata

v0.151: 
- skilltext for Provoke


v0.150: (8/30/2016), initial base
- Adopted Strange's "Translation Toolbox", "Skills English", 
	- replaced ~all "skill.name" instances with "skill.UK_name"
	- translates Skill names
- Adopted Strange's "RPG::Ability（素質・設定用）"
	- replaced ~all "ability.name" instance with "ability.UK_name"
	- translates Trait names (SFrame unofficially calls SR's abilities "Traits", because these are all passive)
- Other stuff it generally translates:
	- enemy names (Class.rxdata, Enemies.rxdata, RPG::SDB, etc.)
	- State names
	- UI (~95% complete)
	- Skill descriptions (commmonly used skills complete) 
	- Trait (ability) descriptions (finished but needs editing)
	- Skill combat text (~40-70% complete)
	- State combat text
	- Some of the Talk text (Talk, as in the result of using the talk skill on enemy succubi)
	
	
==========================================================

NOTE TO OTHER EDITORS:

- "Data" folder
	- extract this to the game directory
	- edit with RPG Maker XP Editor (e.g. Enemies.rxdata is edited via hitting F9 in the editor, then going to the "Enemies" tab)
- "Scripts - manually insert these"
	- edit the .rb files with a text editor, like Notepad++
	- manually copy these into the game scripts (F11) via the RPG Maker XP editor
	- if you add more sections from the script, add the position in the Script section listing to the front of the file name. (e.g. RPG::Skilltext os 14th from the top of the script sections listing, therefore it is named "014 - RPG-Skilltext.rb") (used hyphen in name instead of colons because file names cannot have colons).
	- the .spacer files are to be kept blank, only for keeping track of position
	
