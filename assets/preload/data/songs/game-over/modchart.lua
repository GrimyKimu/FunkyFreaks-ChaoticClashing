-- "Game-Over"
num = 0.0;
hudWidth = hudWidth
mercyMode = mercyMode

function songStart()
    for i = 4,7 do
        -- centers P1"s(BF) arrows
        -- only a simple repositioning, no fancy spreading or anything
        local receptor = _G["receptor_"..i]

       receptor:tweenPos(receptor.defaultX - 310, receptor.defaultY, 0.4)
    end

    for p = 0,3 do
        local receptor = _G["receptor_"..p]
        local widthMod = (hudWidth - (hudWidth / 6)) / 4
		receptor:tweenAlpha(0.0, 3.0)
        -- receptor:tweenPos(widthMod + (widthMod * p), receptor.defaultY, 0.3)
    end
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

camVar = 1;
cameraZoom = 0.7
hudZoom = 1.0
camHudAngle = 0.0
cameraAngle = 0.0

stepProgress = 0

function beatHit(beat)
	
	camVar = camVar * -1
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