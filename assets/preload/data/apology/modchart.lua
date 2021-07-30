-- "Apology"

adjustVar = 0.0;
multiVar = 1

function update(elapsed)
	if adjustVar < 1 then
		adjustVar = adjustVar + 0.001
	end

	local currentBeat = (songPos / 1000) * (bpm/60)

	for i=0,7 do
		if i >= 0 and i <= 3 then
			setActorX(_G['defaultStrum'..i..'X'] + 36 * math.cos((currentBeat + i * 0.5)/(3.5/multiVar) * math.pi) * adjustVar * multiVar, i)
			setActorY(_G['defaultStrum'..i..'Y'] + 12 * math.sin((currentBeat + i * 0.8)/(1.5/multiVar) * math.pi) * adjustVar * multiVar, i)
		end
		if i >= 4 and i <= 7 then
			setActorX(_G['defaultStrum'..i..'X'] - 36 * math.sin((currentBeat + i * 0.5)/(3.5/multiVar) * math.pi) * adjustVar * multiVar, i)
			setActorY(_G['defaultStrum'..i..'Y'] - 12 * math.sin((currentBeat + i * 0.8)/(1.5/multiVar) * math.pi) * adjustVar * multiVar, i)
		end
	end

	if curStep >= 520 and curStep < 568 then
		showOnlyStrums = true -- remove all hud elements besides notes and strums
		if adjustVar > 0 then
			adjustVar = adjustVar - 0.006
		end

		for i=0,7 do 
			tweenFadeIn(i,0,2)
		end
	end

	if curStep == 328 or curStep == 396 or curStep == 568 then
		adjustVar = 0.0
	end

	if curStep == 568 then
		showOnlyStrums = false -- brings the hud elements back
		multiVar = 1.5

		for i=0,7 do
			tweenFadeIn(i,1,0.5)
		end
	end

	if (curStep > 763 and curStep < 778 ) or (curStep > 939)then
		for i=0,7 do
			if curStep > 940 then
				tweenFadeIn(i, 0, 1.5)
			end

			if adjustVar > 0 then
				adjustVar = adjustVar - 0.011
			end
		end
	end
end