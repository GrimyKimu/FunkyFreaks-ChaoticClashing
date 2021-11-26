-- "Ballistic"

camVar = 1;
cameraZoom = 0.7
hudZoom = 1.0
camHudAngle = 0.0
cameraAngle = 0.0

function update(elapsed)
	camShenigans()
end

function playerTwoSing(note, songPos)
	cameraZoom = cameraZoom + (0.05 * (0.7 / cameraZoom))
	camHudAngle = (math.abs(camHudAngle) + 1.5) * camVar

	camVar = camVar * -1

	if Game.health > 0.1 then
		Game.health = Game.health - (.035 * Game.health)
	end
end

function camShenigans()
	local defaultCam = 0.7
	local funnyVar = math.abs(cameraZoom / 7)
	cameraAngle = camHudAngle * -0.8
	hudZoom = cameraZoom + 0.3

	
	if camHudAngle ~= 0 then
		camHudAngle = camHudAngle * 0.25
	end

	if cameraZoom > defaultCam then
		cameraZoom = cameraZoom - 0.005
	elseif cameraZoom < defaultCam then
		cameraZoom = defaultCam
	end
end