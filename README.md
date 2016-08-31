# Succubus-Rhapsodia-ENG

==========================================================

English fan translations for the game, "Succubus Rhapsodia"

Game version:
v1.08

Translation version:
v1.01


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


v1.01: skilltext for Provoke

v1.00: initial base
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
	
