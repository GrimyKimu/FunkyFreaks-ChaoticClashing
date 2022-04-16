-- "Not-Sorry"

adjustVar = 0.0;
multiVar = 1
showOnlyStrums = false
painBool = false

-- receptor.alpha = math.random(25, 50) / 50

function update(elapsed)
	if adjustVar < 1 then
		adjustVar = adjustVar + 0.001
	end

	camShenigans()

	local currentBeat = (songPos / 1000) * (bpm/60)

	for i=0,7 do
		local receptor = _G['receptor_'..i]

		receptor.x = (receptor.defaultX - 36 * math.sin((currentBeat + i * 0.5)/(3.5) * math.pi) * adjustVar * multiVar)
		receptor.y = (receptor.defaultY - 12 * math.sin((currentBeat + i * 0.8)/(1.5) * math.pi) * adjustVar * multiVar)


		if curStep >= 512 and curStep < 703 then
			--"Stop, cut the music..."
			if i >= 0 and i <= 3 then 
				receptor.alpha = math.max(math.random(15, 75) / 75, adjustVar)
			end 
			
			if i == 0 and adjustVar > 0 then
				adjustVar = adjustVar - 0.003
			end

			if curStep > 623 then
				showOnlyStrums = true
			end
		end

		if curStep >= 703 and curStep < 1468 then
			--beginning of "Sunlit Storms"
			showOnlyStrums = false
			multiVar = 0.7
	
			receptor:tweenAlpha(1, 0.35)
		end

		if curStep >= 1468 and curStep < 2111 then
			-- thunder strikes, you die
			if i == 0 and multiVar < 1.5 and curStep < 1983 then
				multiVar = multiVar + 0.01
			elseif i == 0 and multiVar > 0.0 then
				multiVar = multiVar - 0.001
			end

			if i >= 0 and i <= 3 then 
				receptor.alpha = math.max(math.random(15, 75) / 75, adjustVar)
			end 
			dad.alpha = math.random(200, 300) / 300

			painBool = true
		end

		if curStep >= 2111 and curStep < 2367 then
			--end of the storm approaches
			painBool = false
			receptor:tweenAlpha(1, 0.35)
			dad.alpha = math.random(200, 300) / 300

			if i == 0 and adjustVar > 0 then
				adjustVar = adjustVar - 0.003
			end
		end

		if curStep >= 2367 and curStep < 3007 then
			--the sunlight returns

			dad.alpha = 1
			multiVar = 1.0
		end

		if curStep >= 3007 then
			--but Dari has fallen
			if i == 0 then
				multiVar = multiVar + 0.001
			end

			receptor:tweenAlpha(0, 2.5)
		end
	end
end

camVar = 1
cameraZoom = 0.7
hudZoom = 1.0
camHudAngle = 0.0
cameraAngle = 0.0

function beatHit(beat)
	if (beat > 32 and beat < 156) or (beat > 240 and beat < 496) or (beat > 624 and beat < 752) then
		if math.fmod(beat, 2) == 0 then
			cameraZoom = 0.7 + (0.05 * multiVar)
		end
	end

	if beat == 132 then
		boyfriend:changeCharacter('bf-worry',boyfriend.x,boyfriend.y)
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

	if painBool then
		cameraZoom = cameraZoom + (0.02 * (0.7 / cameraZoom) * adjustVar)
		camHudAngle = (math.abs(camHudAngle) + 1.5) * camVar * adjustVar

		camVar = camVar * -1

		if Game.health > 0.1 then
			Game.health = Game.health - (.035 * Game.health)
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

function camShenigans()
	local defaultCam = 0.7
	cameraAngle = camHudAngle * -0.8
	hudZoom = cameraZoom + 0.3

	if camHudAngle ~= 0 then
		camHudAngle = camHudAngle * 0.8
	end

	if cameraZoom > defaultCam then
		cameraZoom = cameraZoom - 0.005
	elseif cameraZoom <= defaultCam then
		cameraZoom = defaultCam
	end
end