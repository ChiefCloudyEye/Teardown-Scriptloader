#include "mods/examplemod.lua"
mods = {
	"examplemod",
}



enabledmods={}
function initMods()
	for i in pairs(enabledmods)
	do
		loadstring(enabledmods[i].."Init()")()
	end
end
function tickMods()
	for i in pairs(enabledmods)
	do
		loadstring(enabledmods[i].."Tick()")()
	end
end
function drawMods()
	for i in pairs(enabledmods)
	do
		loadstring(enabledmods[i].."Draw()")()
	end
end
function debugMods()
	for i in pairs(enabledmods)
	do
		SetString("hud.notification", getName(i).." failed to compile. (\""..mods[i].."Init()\")")
		loadstring(enabledmods[i].."Init()")()
		SetString("hud.notification", getName(i).." failed to compile. (\""..mods[i].."Tick()\")")
		loadstring(enabledmods[i].."Tick()")()
		SetString("hud.notification", getName(i).." failed to compile. (\""..mods[i].."Draw()\")")
		loadstring(enabledmods[i].."Draw()")()
	end
	SetString("hud.notification", "Mods successfully compiled.")
end
function getName(index)
	return loadstring("return "..mods[index].."Name")()
end
function getDesc(index)
	return loadstring("return "..mods[index].."Desc")()
end
function toggle(index)
	if getEnabled(index) then
		--table.remove(enabledmods,index)
		enabledmods[index] = nil
	else
		enabledmods[index] = mods[index]
		debugMods()
	end
end
function getEnabled(index)
	return mods[index] == enabledmods[index]
end