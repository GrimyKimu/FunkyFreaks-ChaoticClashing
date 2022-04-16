-- "New-Puppet"

camHudAngle = 0.0
cameraAngle = 0.0
cameraZoom = 0.7
hudZoom = 1

function start(song) 

end

function update(elapsed)
	camShenigans()
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

camVar = 1

function beatHit(beat)
	if beat > 16 then
		if math.fmod(beat, 3) == 0 then
			cameraZoom = 0.72
			camHudAngle = 2.5 * camVar
			camVar = camVar * -1
		else
			cameraZoom = 0.71
			camHudAngle = 1.2 * camVar
			camVar = camVar * -1
		end
	end
end

function camShenigans()
	local defaultCam = 0.7
	local funnyVar = math.abs(camHudAngle / 15)
	cameraAngle = camHudAngle * -0.5
	hudZoom = cameraZoom + 0.3

	if camHudAngle > 0 then
		camHudAngle = camHudAngle - (funnyVar)
	elseif camHudAngle < 0 then
		camHudAngle = camHudAngle + (funnyVar)
	end

	if cameraZoom > defaultCam then
		cameraZoom = (cameraZoom + defaultCam) / 2
	end
end