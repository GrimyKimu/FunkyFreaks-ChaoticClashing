-- "Test"

cameraZoom = 0.5

function songStart()
    for i = 0,7 do
        local receptor = _G["receptor_"..i]
        --Bf's arrows

        if i >= 0 and i < 4 then
            receptor.alpha = 0
        end
    end

    cameraZoom = 0.5
end

function update(elapsed)
    cameraZoom = 0.5
end
followXOffset = 0
followYOffset = 0

function playerTwoSing(note, songPos)
    -- 0 = left, 1 = down, 2 = up, 3 = right
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

function playerOneSing(note, songPos)
    -- 0 = left, 1 = down, 2 = up, 3 = right
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