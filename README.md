# Succubus-Rhapsodia-ENG

==========================================================

English fan translations for the game, "Succubus Rhapsodia"


------=:::[ Game version ]:::=------
- v1.10

---=:::[ Translation version* ]:::=---
- v0.181

*Last publically released version
*Estimated percentage of translation completion

==========================================================


----------=:::[ Game ]:::=----------


Official Site:
http://succbusrhapsodia.x.fc2.com/top.html

Developer Blog:
http://dreamania.blog.jp/

DLsite:
http://www.dlsite.com/maniax/work/=/product_id/RJ181931

DMM:
http://www.dmm.co.jp/dc/doujin/-/detail/=/cid=d_098909/


-------=:::[ Other Links ]:::=------


ULMF thread:
http://www.ulmf.org/bbs/showthread.php?t=29519

Github Repository:
https://github.com/Freeloader-Zero/Succubus-Rhapsodia-ENG


==========================================================


-------=:::[ Instructions ]:::=-------


For Translators:
- 0a) If you don't have the RPG Maker XP Editor, you can directly edit individual sections of the Scripts.rxdata via the "Scripts - manually download these" folder.
- 0b) If you have the RPG Maker XP Editor installed, read further:
- 1) Make sure you've installed/patched your game to the appropriate version that this translation uses.
- 2) Download all but the "Scripts - manually download these" folder.
- 3) dump into game folder.
- 4) Merge/Overwrite when prompted.
- 5) Open "Game.rxproj" from within the game folder to use RPG Maker XP Editor to edit the game.

	- if you don't know what the game.rxproj file is and/or don't have it, just make a .txt file, type "RPGXP 1.05" into it (the "1.05" can be replaced with whatever version your RPG Maker XP editor is), then rename the .txt file to "game.rxproj". If your system doesn't yet recognize the file, you can open game.rxproj by right-clicking it, and then selecting "Open with >", "RPG Maker XP".


For Photo/Graphic Translators:
- Recommended fonts:
	- Adobe Garamond Pro, (Opening font of "Succubus Rhapsodia")
	- Nyala, for config UI
	- Times New Roman, for Map Font that you want to look neat and straight
	
	
For testers, freeloaders and other folks:
- 0) Make sure you've installed/patched your game to the appropriate version that this translation uses.
- 1) Download and dump into game folder (except for "Scripts - manually download these", you don't need them; the scripts are already included in the "Scripts.rxdata" file inside the "Data" folder).
- 2) Merge/Overwrite when prompted.
- 3) fapping is optional; enjoyment is mandatory. ;)




==========================================================


-------=:::[ Changelogs ]:::=-------



v0.181: (09/05/2016)
- Added skill descriptions back in (forgot)

v0.180:
- Revised all enemies with spaces at the end of their names (apparently keeping even byte count for enemy names was unnecessary)
	- Fixed a bug with Ramile probably not acting as she should in battle (had wrong name)
	- Fixed a bug with the Little Witch in BattlePop_Hold; she had a wrong name as well (extra space at end)
	- Fixed a probable bug with Gilgoon not acting right either (seems to have had wrong class name, unless my notes were wrong to begin with)
	- Contracted Succubi with spaces in their names will still have the spaces, unfortunately. You can rename them with the Bonuses menu, with the exception of Bosses, since they unfortunately cannot be renamed.
- translated the portal choices (CommonEvents.rxdata, #12), and 1 line of text for the portal on Map209.rxdata ("ホーム#/01", "Home")
- translated and revised some licking skilltext
- translated graphics/pictures/map_name_home.png, "ホーム" -> "Home"
- revised the nipples for "youthful breasts" - "pretty nipples" are now "little nipples"; sounds better
- revised one statetext for accuracy (being willingly stripped naked by enemy)
- refit the succubi status info in Window_Status (used to slide off the right side when changing equipment/runes)
- slightly revised the Armors.rxdata descriptions of status effect resistance runes to better clarify that they don't stack with duplicate runes.
- tweaked a few random names from the random name generator (Window_NameEdit（ランダム名）)


v0.165: (09/04/2016)
- translated more skilltext; some fixes
	- translated and implemented the combat message variations (mood and personality-dependent variations)
	- translated the random idle messages
	- indented some lines that ran out of bounds of the combat message box
	- changed all "ｗ" (double-byte "w") within skilltext to the normal single-byte "w"
- changed statetext
	- changed all "ｗ" (double-byte "w") within statetext to the normal single-byte "w"
- adjusted some skill names
- changed Slime's underwear from "loin mucus" to "protective mucus"
- removed 8 lines Window_Battle_BackLog that I seem to have forgot to remove after testing


**v0.000 (09/04/2016)**
- added original **branch to github.
	- includes the original game v1.10 versions of the scripts from scripts.rxdata that I changed


v0.163: (09/02/2016)
- fixed missing/invisible damage numbers
	- mass replaced all \065, \066, and \067 instances with \, \, and \
	- I guess the curse of invisibility passed on from the \w, \m, and \q.... (my mistake for not paying attention to the damage while stability testing)


v0.162: (09/01/2016)
- updated scripts to game v1.10
	- adds large amounts of conditional dialogues text for Talk, for chain attacks
	- rewords some Dildo strings
- changed some underwear names
	- Slime's underwear from "crotch mucus" to "loin mucus", because I think the latter sounds a little better
	- Nightmare's underwear from "thin cloth" to "tights"
- corrected some skill descriptions; descriptions for skills 002-249 are translated with relative accuracy
- revised some skill names
-> Added the Scripts.rxdata to repository for easier downloading and testing purposes
	- "Scripts - manually insert these" will be kept and manually updated for comparing changes within Scripts.rxdata, or for quick edits


v0.161: (08/31/2016)
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


v0.160:
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



-------=:::[ Credits, thus far ]:::=-------

- Strange
	- Translation Toolbox, Skill names, Trait/Ability names
	- http://www.ulmf.org/bbs/member.php?u=179069

- SFrame
	- Combat messages, descriptions, General UI, just fooling around for now
	- http://www.ulmf.org/bbs/member.php?u=16290
	
	
