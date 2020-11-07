minigunmodName = "Minigun Mod"	--Display name in the modloader UI.

minigunmodDesc = "Minigun go BRRRRRRR."	--Display description in the modloader UI.


timer = 0
rpm = 120
rpmlower = 120
rpmtop = 3600
shottime = 0
function lerp(a,b,t) return a * (1-t) + b * t end

function minigunmodInit()	--This function is called when the modloader recompiles due to enabling a new mod.
	
	chopperShootSound = LoadSound("chopper-shoot")
	chopperShootSound = LoadSound("tools/gun")
end

function minigunmodTick()	--This function is called every tick.
end

function minigunmodDraw()	--This function is called every UI tick while the UI is being rendered.
	if timer <= 0 then
		if UiIsMouseDown() and GetString("game.player.tool") == "spraycan" and not GetBool("game.player.grabbing") then
        		--Explosion(getPlayerRaycastPos(), 1, true)    
			shoot()
			timer = 60/rpm
			shottime = shottime+60/rpm
			rpm = lerp(rpmlower,rpmtop,(shottime/5)*(shottime/5))
      		else
			shottime = 0
			rpm = lerp(rpmlower,rpmtop,(shottime/5)*(shottime/5))
		end
	else
		timer = timer - GetTimeStep()
	end
	if GetBool("game.player.grabbing") then
		if rpm >= 1000 then
			rpm = rpm + UiGetMouseWheel()*100
		else
			if rpm >= 100 then
				rpm = rpm + UiGetMouseWheel()*10
			else
				rpm = rpm + UiGetMouseWheel()*1
			end
		end
		SetString("hud.notification", "Minigun RPM: "..rpm)
	end
end

function minigunmodUI()	--This function is called inside the mod's page of the options menu.
	
end

function getPlayerRaycastPos()

    local plyTransform = GetPlayerTransform()
    local fwdPos = TransformToParentPoint(plyTransform, Vec(0, 0, -300)) -- Player's position, offset by 100 facing forward

    local direction = VecSub(fwdPos, plyTransform.pos)
    local dist = VecLength(direction)
    direction = VecNormalize(direction)

    --print("PlyPos:", vec2str(plyTransform.pos), " direction: ", vec2str(direction))
    local hit, dist = Raycast(plyTransform.pos, direction, dist)

    if hit then
        local hitPos = TransformToParentPoint(plyTransform, Vec(0, 0, dist * -1))
        --print("hit at: ", vec2str(hitPos))
        return hitPos
    end
    return TransformToParentPoint(plyTransform, Vec(0, 0, -1000000))
end


function shoot()
	PlaySound(chopperShootSound, TransformToParentPoint(GetPlayerTransform(), Vec(0, 0, 0)), 5, false)

	local p = TransformToParentPoint(GetPlayerTransform(), Vec(.5, -.5,  3))
	local d = VecNormalize(VecSub(getPlayerRaycastPos(), p))
	local spread = 0.03
	d[1] = d[1] + (math.random()-0.5)*2*spread
	d[2] = d[2] + (math.random()-0.5)*2*spread
	d[3] = d[3] + (math.random()-0.5)*2*spread
	d = VecNormalize(d)
	p = VecAdd(p, VecScale(d, 5))
	Shoot(p, d)	
end