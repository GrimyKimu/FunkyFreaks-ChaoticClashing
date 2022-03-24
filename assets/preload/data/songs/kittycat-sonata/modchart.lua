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