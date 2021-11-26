-- "Play-Time"

camHudAngle = 0.0
cameraAngle = 0.0
cameraZoom = 0.7
hudZoom = 1

function start(song) 

end

function update(elapsed)
	if curBeat > 16 then
		camShenigans()
	end

	
	if curStep < 31 then
		gf:playAnim('cheer', 'true')
	end
end


function playerTwoSing()
	if curBeat > 16 then
		camHudAngle = camHudAngle - 0.5
	end
end

function playerOneSing()
	camHudAngle = camHudAngle + 0.55
end

function beatHit(beat)
	if beat > 16 then
		if math.fmod(beat, 3) == 0 then
			cameraZoom = 0.75
		else
			cameraZoom = 0.725
		end
	end

	camVar = camVar * -1
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
		cameraZoom = (cameraZoom + defaultCam) / 2
	end
end