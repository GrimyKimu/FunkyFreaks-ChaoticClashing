-- "Madness"

camVar = 1;
cameraZoom = 0.7
hudZoom = 1.0
camHudAngle = 0.0
cameraAngle = 0.0

function update(elapsed)
	camShenigans()

	if leftVar > 0 then
		leftVar = leftVar - (leftVar / 10)
	end
	if downVar > 0 then
		downVar = downVar - (downVar / 10)
	end
	if upVar > 0 then
		upVar = upVar - (upVar / 10)
	end
	if rightVar > 0 then
		rightVar = rightVar - (rightVar / 10)
	end

	local currentBeat = (songPos / 1000) * (bpm/60)

	for i=0,7 do
		local receptor = _G['receptor_'..i]

		local hahaLeft = 0.7
		local hahaDown = 0.7
		local hahaUp = 0.7
		local hahaRight = 0.7

		if i == 0 or i == 4 then 
			hahaLeft = 2.1
		elseif i == 1 or i == 5 then 
			hahaDown = 2.1
		elseif i == 2 or i == 6 then 
			hahaUp = 2.1
		elseif i == 3 or i == 7 then 
			hahaRight = 2.1
		end


		receptor.x = receptor.defaultX + (-24 * leftVar * hahaLeft) + (24 * rightVar * hahaRight)
		receptor.y = receptor.defaultY + (24 * downVar * hahaDown) + (-24 * upVar * hahaUp)
	end
end

leftVar = 0.0
downVar = 0.0
upVar = 0.0
rightVar = 0.0

function playerTwoSing(note, songPos)
	if note == 0 then
		leftVar = leftVar + 2.5
	elseif note == 1 then
		downVar = downVar + 2.5
	elseif note == 2 then
		upVar = upVar + 2.5
	elseif note == 3 then
		rightVar = rightVar + 2.5
	end

	if Game.health > 0.1 then
		Game.health = Game.health - (.035 * Game.health)
	end
end

function playerOneSing(note, songPos)
	if note == 0 then
		leftVar = leftVar + 1.0
	elseif note == 1 then
		downVar = downVar + 1.0
	elseif note == 2 then
		upVar = upVar + 1.0
	elseif note == 3 then
		rightVar = rightVar + 1.0
	end
end

function beatHit(beat)
	if (beat > 32 and beat < 256) then
		if math.fmod(beat, 4) == 0 then
			cameraZoom = 0.78
			camHudAngle = 4 * camVar
		else
			cameraZoom = 0.765
			camHudAngle = 2 * camVar
		end
	elseif (beat > 256 and beat < 384) then
		cameraZoom = 0.76
		camHudAngle = 1 * camVar
	elseif (beat > 384 and beat < 448) then
		if math.fmod(beat, 4) == 0 then
			cameraZoom = 0.8
			camHudAngle = 4 * camVar
		else
			cameraZoom = 0.775
			camHudAngle = 2 * camVar
		end
	elseif (beat > 448 and beat < 512) then
		if math.fmod(beat, 4) == 0 then
			cameraZoom = 0.78
			camHudAngle = 4 * camVar
		else
			cameraZoom = 0.765
			camHudAngle = 2 * camVar
		end
	end
	--cam zooms during the slower duet section are less intense (1st elseif)
	--cam zooms during the repeated of the chorus are significantly worse (2nd elseif)

	camVar = camVar * -1

	-- on the beats of the "HEY!"s, cheer
	if beat == 203 or beat == 235 or beat == 395 or beat == 411 then
		dad:playAnim('cheer', 'true')
		gf:playAnim('cheer', 'true')
	elseif beat == 219 or beat == 251 or beat == 427 or beat == 443 then
		gf:playAnim('cheer', 'true')
	end
end

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