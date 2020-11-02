basicmodName = "Basic Mod"	--Display name in the modloader UI.

basicmodDesc = "A basic mod to show a simple setup.\nAdds Infinite Ammo, All Weapons, and Max Upgrades\ncommands. All of these commands are reversable and do not\neffect your save."	--Display description in the modloader UI.


infammo = false
maxupgrades = false
allweap = false

function basicmodInit()	--This function is called when the modloader recompiles due to enabling a new mod.
	
end

function basicmodTick()	--This function is called every tick.
	if infammo then
		local tools = {
			"sledge",
			"spraycan",
			"extinguisher",
			"blowtorch",
			"shotgun",
			"plank",
			"pipebomb",
			"gun",
			"bomb",
			"rocket",
		}
		for i in pairs(tools)
		do
			SetInt("game.tool." .. tools[i] .. ".ammo", 1)
		end
	end
end

function basicmodDraw()	--This function is called every UI tick while the UI is being rendered.
	
end

function basicmodUI()	--This function is called inside the mod's page of the options menu.
	UiTranslate(20+buttonwidth/2, 700-90)
	UiTranslate(0,-80)
	local text = ""
	if allweap then
		text = "Disable"
	else
		text = "Enable"
	end
	if UiTextButton(text.." All Weapons",  240, 40) then
		if allweap then
			allweap = false
			local tools = {
				"sledge",
				"spraycan",
				"extinguisher",
				"blowtorch",
				"shotgun",
				"plank",
				"pipebomb",
				"gun",
				"bomb",
				"rocket",
			}
			for i in pairs(tools)
			do
				SetBool("game.tool." .. tools[i] .. ".enabled", GetBool("savegame.tool." .. tools[i] .. ".enabled"))
			end
		else
			allweap = true
			local tools = {
				"sledge",
				"spraycan",
				"extinguisher",
				"blowtorch",
				"shotgun",
				"plank",
				"pipebomb",
				"gun",
				"bomb",
				"rocket",
			}
			for i in pairs(tools)
			do
				SetBool("game.tool." .. tools[i] .. ".enabled", true)
			end
		end
		
	end
	UiTranslate(0,-50)
	local text = ""
	if infammo then
		text = "Disable"
	else
		text = "Enable"
	end
	if UiTextButton(text.." Infinite Ammo",  240, 40) then
		if infammo then
			infammo = false
		else
			infammo = true
		end
	end
	UiTranslate(0,-50)
	local text = ""
	if maxupgrades then
		text = "Disable"
	else
		text = "Enable"
	end
	if UiTextButton(text.." Max Upgrades",  240, 40) then
		if maxupgrades then
			maxupgrades = false
			for id,tool in pairs(gTools) do
				for j=1, #tool.upgrades do
					local prop = tool.upgrades[j].id
					local value = tool.upgrades[j].default
					local saved = GetInt("savegame.tool."..id.."."..prop)
					if saved > value then
						value = saved 
					end
					SetInt("game.tool."..id.."."..prop, value)
				end
			end
		else
			maxupgrades = true
			for id,tool in pairs(gTools) do
				for j=1, #tool.upgrades do
					local prop = tool.upgrades[j].id
					local value = tool.upgrades[j].max
					local saved = GetInt("savegame.tool."..id.."."..prop)
					SetInt("game.tool."..id.."."..prop, value)
				end
			end
		end
	end
end