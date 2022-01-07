-- "Death-Waltz"


adjustVar = 0.0;
multiVar = 1
dad = nil
camVar = 1;
cameraZoom = 0.7
hudZoom = 1.0
camHudAngle = 0.0
cameraAngle = 0.0

function update(elapsed)
    if adjustVar > 0.0 then
        adjustVar = adjustVar - 0.01
    end

	local currentBeat = (songPos / 1000) * (bpm/60)

    if currentBeat > 342 then
        multiVar = 2.0
    end

	dad.x = dad.x - 12 * math.sin((currentBeat + i * 0.5)/(1.5/multiVar) * math.pi) * adjustVar * (multiVar - 0.5)
    dad.y = dad.y - 36 * math.sin((currentBeat + i * 0.5)/(3.5/multiVar) * math.pi) * adjustVar * multiVar

    camShenigans()
end

function playerTwoSing(note, songPos)
	camHudAngle = (math.abs(camHudAngle) + 1.5) * camVar
    
    if adjustVar < 1.0 then
        adjustVar = adjustVar - 0.15
    end

	camVar = camVar * -1

	if Game.health > 0.1 then
		Game.health = Game.health - (.025 * Game.health)
	end
end

function beatHit(beat)
    if math.fmod(beat, 4) == 0 then
        cameraZoom = 0.76
    else
        cameraZoom = 0.73
    end
end

function camShenigans()
	local defaultCam = 0.7
	local funnyVar = math.abs(camHudAngle / 25)
	cameraAngle = camHudAngle * -0.5
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