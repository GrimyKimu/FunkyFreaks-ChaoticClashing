-- "Kaos"
switch = false;
num = 0.0;
hudWidth = hudWidth

function songStart()
    for i = 4,7 do
        -- centers P1"s(BF) arrows
        -- only a simple repositioning, no fancy spreading or anything
        local receptor = _G["receptor_"..i]

        receptor:tweenPos(receptor.defaultX - 275, receptor.defaultY, 1.2)
    end

    for p = 0,3 do
        local receptor = _G["receptor_"..p]
        local widthMod = (hudWidth - (hudWidth / 6)) / 4

        receptor:tweenAlpha(0.25, 1.8)
        receptor:tweenPos(widthMod + (widthMod * p), receptor.defaultY, 1.6)
    end
end

function update(elapsed)
	stepProgress = (curStep / 2120)

	if switch == false then
		if num > -2.0 then 
			num = num - 0.2
		elseif num < -2.0 then
			num = -2.0
		end
	elseif switch == true then
		if num < 1.6 then 
			num = num + 0.2
		elseif num > 1.6 then
			num = 1.6
		end
	end

	camShenigans()

	if (curBeat > 12 and curBeat < 408) or (curBeat > 432 and curBeat < 504) then
		local shenVar = 1

		if curBeat > 432 then
			shenVar = 1.5
		end

		arrowShenigans(shenVar)
	end
	
	for p = 0,3 do
		local receptor = _G["receptor_"..p]
		local widthMod = (hudWidth - (hudWidth / 6)) / 4

		receptor.alpha = math.random(5, 30) / 100

		if curBeat == 408 then
			receptor:tweenPos(widthMod + (widthMod * p), receptor.defaultY, 1.0)
		end
	end

	if curStep > 2120 then
		--P2's stumLine fades out at the end of the song
		for p = 0,3 do
			local receptor = _G['receptor_'..p]
			receptor:tweenAlpha(0, 1.0)
		end
	end
end

function playerTwoTurn()
	-- variable that determines who the camera is currently focusing
	switch = false
end

function playerOneTurn()
	switch = true
end

camVar = 1;
cameraZoom = 0.7
hudZoom = 1.0
camHudAngle = 0.0
cameraAngle = 0.0

stepProgress = 0

function beatHit(beat)
	if (curBeat > 12 and curBeat < 408) or (curBeat > 432 and curBeat < 504) then
		if math.fmod(beat, 3) == 0 then
			cameraZoom = 0.8
			camHudAngle = 5 * camVar
		else
			cameraZoom = 0.76
			camHudAngle = 2.5 * camVar
		end
	end

	camVar = camVar * -1
end

function arrowShenigans(shenVar)
	-- the following is P2 arrow shenanigans
	for i = 0,3,1 do 
		local receptor = _G['receptor_'..i]

		-- This section repositions the arrows when they go too far in either direction
		if receptor.x > (hudWidth - (hudWidth / 6)) then 
			receptor.x = hudWidth / 12
		elseif receptor.x < (hudWidth / 12) then
			receptor.x = (hudWidth - (hudWidth / 6))
		end

		-- P2's Arrows are moved either left or right based on how far along the song is and who the camera is focused on, accelerating as the song goes on
		receptor.x = (receptor.x + (hudWidth/40) * stepProgress * math.random() * num * shenVar)
		receptor.angle = receptor.angle + (stepProgress * 6 * math.random() * num * shenVar)
	end
end

function camShenigans()
	local defaultCam = 0.7
	local funnyVar = math.abs(camHudAngle / 5)
	cameraAngle = camHudAngle * -2.5
	hudZoom = (cameraZoom / 0.7)

	if camHudAngle > 0 then
		camHudAngle = camHudAngle - (funnyVar)
	elseif camHudAngle < 0 then
		camHudAngle = camHudAngle + (funnyVar)
	end

	if cameraZoom > defaultCam then
		cameraZoom = (cameraZoom - 0.01)
	end
end