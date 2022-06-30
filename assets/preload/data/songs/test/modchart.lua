-- "Test"


function songStart()
    for i = 0,7 do
        local receptor = _G["receptor_"..i]
        --Bf's arrows

        if i >= 0 and i < 4 then
            receptor.alpha = 0
        end
    end

    cameraZoom = 0.85
end

defaultCam = 0.85
cameraZoom = 0.85
cameraAngle = 0.0
defaultAngle = 0.0
followXOffset = 0
followYOffset = 0
singTimer = 0

function camShenigans()
	local funnyVar = math.abs(camHudAngle / 5)

	if cameraAngle ~= defaultAngle then
		cameraAngle = (0.95 * cameraAngle) + (0.05 * defaultAngle)
	end

	if cameraZoom ~= defaultCam then
		cameraZoom = (0.9 * cameraZoom) + (0.1 * defaultCam)
	end
end

function update(elapsed)
    camShenigans()

	if singTimer > 0 then
		singTimer = singTimer - elapsed
	elseif singTimer <= 0 then
		defaultAngle = 0
		defaultCam = 0.85
		followYOffset = 0
		followXOffset = 0
	end
end

function playerTwoSing(note, songPos)
    -- 0 = left, 1 = down, 2 = up, 3 = right
	
end

function playerOneSing(note, songPos)
    -- 0 = left, 1 = down, 2 = up, 3 = right
	singTimer = 0.4
	if note == 0 then
		followXOffset = -50
		followYOffset = 0
		defaultCam = 0.85
		defaultAngle = -2

	elseif note == 1 then
		followYOffset = -10
		followXOffset = 0
		defaultCam = 0.84
		defaultAngle = 0

	elseif note == 2 then
		followYOffset = 5
		followXOffset = 0
		defaultCam = 0.865
		defaultAngle = 0

	elseif note == 3 then
		followXOffset = 35
		followYOffset = 0
		defaultCam = 0.85
		defaultAngle = 1.5
	end
end