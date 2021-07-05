-- "Apology"

function start(song) -- do nothing
    
end


function update(elapsed)
    if curStep < 520 then
		for i=0,7 do
			setActorX(_G['defaultStrum'..i..'X'],i)
			setActorY(_G['defaultStrum'..i..'Y'],i)
		end
	end

	if curStep >= 520 and curStep < 570 then
        showOnlyStrums = true -- remove all hud elements besides notes and strums

		for i=0,7 do 
            tweenFadeIn(i,0,0.4)
		end
	end

    if curStep >= 570 and curStep < 764 then
        showOnlyStrums = false -- brings the hud elements back
		local currentBeat = (songPos / 1000)*(bpm/60)

		for i=0,7 do
			tweenFadeIn(i,1,0.4)

			local switch = 1

			if i >= 0 and i <= 3 then
				switch = -1
			end

			setActorX(_G['defaultStrum'..i..'X'] + 32 * math.sin((currentBeat + i*0.5)/3 * math.pi * switch), i)
			setActorY(_G['defaultStrum'..i..'Y'] + 32 * math.cos((currentBeat + i*0.5)/3 * math.pi * switch), i)
		end
	end

	if curStep > 764 and curStep < 778 then
		cameraZoom = cameraZoom - 0.001
		for i=0,7 do
			local yes = 1

			if downscroll == false then
				yes = -1
			end

			setActorY(getActorY(i) + (1.5 * yes), i)
		end
	end

	if curStep == 764 or curStep == 940 then
		for i=0,7 do
			setActorX(_G['defaultStrum'..i..'X'],i)
			setActorY(_G['defaultStrum'..i..'Y'],i)
		end
	end

	if curStep > 778 and curStep < 940 then
		cameraZoom = 0.7
		local currentBeat = (songPos / 1000)*(bpm/60)

		for i=0,7 do
			local switch = 1

			if i >= 0 and i <= 3 then
				switch = -1
			end

			setActorX(_G['defaultStrum'..i..'X'] + 32 * math.sin((currentBeat + i*0.5)/3 * math.pi * switch), i)
			setActorY(_G['defaultStrum'..i..'Y'] + 32 * math.cos((currentBeat + i*0.5)/3 * math.pi * switch), i)
		end
	end

	if curStep > 940 then
		for i=0,7 do
			tweenFadeIn(i,0,1)

			local yes = 1

			if downscroll == false then
				yes = -1
			end

			setActorY(getActorY(i) + (1.5 * yes), i)
		end
	end
end