-- "Chaos""

function setDefault(id)
	_G['defaultStrum'..id..'X'] = getActorX(id)
	
	defaultCamX = getCameraX()
	defaultCamY = getCameraY()
end

switch = false;
num = 0.0;
enemy = .8;

function start(song) -- do nothing
	if difficulty == 0 then
		enemy = 0.5
	elseif difficulty == 2 then
		enemy = 1.1
	end

    for i = 4, 7 do 
		-- centers P1's(BF) arrows
		-- only a simple repositioning, no fancy spreading or anything
		tweenPosXAngle(i, _G['defaultStrum'..i..'X'] - 275,getActorAngle(i), 2.0, 'setDefault')
	end

	for i = 0, 3 do 
		-- spreads P2's(enemy) arrows evenly across a decicated area of the screen
		-- widthMod is the variable that stores the value of the area that's being utilized
		local widthMod = ((screenWidth - getActorWidth(i) - 5) /4)
		tweenPosXAngle(i, widthMod + (widthMod * i),getActorAngle(i), 2.0, 'setDefault')
	end
end

function update(elapsed)
	if switch == false then
		if num > -2.0 then 
			num = num - 0.5
		elseif num <= -2.0 then
			num = -2.0
		end
	elseif switch == true then
		if num < 1.6 then 
			num = num + 0.4
		elseif num >= 1.6 then
			num = 1.6
		end
	end

	-- the following is P2 arrow shenanigans
	for i = 0, 3 do 
		-- This section repositions the arrows when they go too far in either direction
		if getActorX(i) > (screenWidth - getActorWidth(i)) then 
			setActorX(5, i)
		elseif getActorX(i) < 5 then 
			setActorX(screenWidth - getActorWidth(i), i)
		end

		-- P2's Arrows are moved either left or right based on how far along the song is
		-- and who the camera is focused on accelerating as the song goes on
		setActorX(getActorX(i) + (screenWidth/100) * (curStep / 1776) * num, i)

		if curStep > 1776 then
			--P2's stum-notes fade out at the end of the song
			tweenFadeIn(i, 0, 1.0)
		end
	end

	-- step 1776 is when the song ends
	if curStep == 1 then
		for i = 0, 7 do 
			setActorAlpha(0, i)

			if i <= 3 then
				tweenFadeIn(i, 0.3 * enemy, 2.5)
			end
			if i >= 4 then
				tweenFadeIn(i, 1, 2.5)
			end
		end
	end
end

function playerTwoTurn()
	-- variable that determines who the camera is currently focusing
	switch = false
end

function playerOneTurn()
	switch = true
end