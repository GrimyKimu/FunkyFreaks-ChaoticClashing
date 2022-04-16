-- "KittyCaT-Sonata"

function update(elapsed)
	camShenigans()

	if curBeat >= 382 then
		dad.alpha = math.max(math.random(1, 100) / 100, 382 / curBeat * 0.9)
		--.alpha = math.max(math.random(15, 75) / 75, adjustVar)
	end
end

function beatHit(beat)
	if (beat > 12 and beat < 231) or (beat > 394 and beat < 547) then
		if math.fmod(beat, 3) == 0 then
			cameraZoom = 0.76
			camHudAngle = 2 * camVar
		else
			cameraZoom = 0.73
			camHudAngle = 1 * camVar
		end
	elseif (beat > 252 and beat < 394) then
		if math.fmod(beat, 2) == 0 then
			cameraZoom = 0.78
			camHudAngle = 2 * camVar
		else
			cameraZoom = 0.74
			camHudAngle = 1 * camVar
		end
	end


	camVar = camVar * -1

end

curBeat = 0
camVar = 1

function camShenigans()
	local defaultCam = 0.7
	local funnyVar = math.abs(camHudAngle / 15)
	cameraAngle = camHudAngle * -0.8
	hudZoom = cameraZoom + 0.3

	if camHudAngle > 0 then
		camHudAngle = camHudAngle - (funnyVar)
	elseif camHudAngle < 0 then
		camHudAngle = camHudAngle + (funnyVar)
	end

	if cameraZoom > defaultCam then
		cameraZoom = cameraZoom - 0.005
	elseif cameraZoom < defaultCam then
		cameraZoom = defaultCam
	end
end

switch = false;

function playerTwoTurn()
	-- variable that determines who the camera is currently focusing
	switch = false
end

function playerOneTurn()
	switch = true
end

followXOffset = 0
followYOffset = 0

function playerTwoSing(note, songPos)
    -- 0 = left, 1 = down, 2 = up, 3 = right
	if switch == false then
		if note == 0 then
			followXOffset = -30 - (30 * math.random())
			followYOffset = 0
		elseif note == 1 then
			followYOffset = 30 + (30 * math.random())
			followXOffset = 0
		elseif note == 2 then
			followYOffset = -30 - (30 * math.random())
			followXOffset = 0
		elseif note == 3 then
			followXOffset = 30 + (30 * math.random())
			followYOffset = 0
		end
	end
end

function playerOneSing(note, songPos)
    -- 0 = left, 1 = down, 2 = up, 3 = right
	if switch == true then
		if note == 0 then
			followXOffset = -30 - (30 * math.random())
			followYOffset = 0
		elseif note == 1 then
			followYOffset = 30 + (30 * math.random())
			followXOffset = 0
		elseif note == 2 then
			followYOffset = -30 - (30 * math.random())
			followXOffset = 0
		elseif note == 3 then
			followXOffset = 30 + (30 * math.random())
			followYOffset = 0
		end
	end
end