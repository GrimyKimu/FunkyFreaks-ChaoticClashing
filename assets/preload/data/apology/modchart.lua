-- "Apology"

adjustVar = 0.0;
multiVar = 1
showOnlyStrums = false

function update(elapsed)
	if adjustVar < 1 then
		adjustVar = adjustVar + 0.001
	end

	local currentBeat = (songPos / 1000) * (bpm/60)

	for i=0,7 do
		local receptor = _G['receptor_'..i]

		receptor.x = (receptor.defaultX - 36 * math.sin((currentBeat + i * 0.5)/(3.5/multiVar) * math.pi) * adjustVar * multiVar)
		receptor.y = (receptor.defaultY - 12 * math.sin((currentBeat + i * 0.8)/(1.5/multiVar) * math.pi) * adjustVar * multiVar)

		if (curStep > 763 and curStep < 778 ) or (curStep > 939)then
			if curStep > 940 then
				receptor:tweenAlpha(0, 1.5)
			end

			if adjustVar > 0 then
				adjustVar = adjustVar - 0.011
			end
		end

		if curStep >= 568 and curStep < 940 then
			showOnlyStrums = false -- brings the hud elements back
			multiVar = 1.5
	
			receptor:tweenAlpha(1, 0.5)
		end

		if curStep >= 520 and curStep < 568 then
			showOnlyStrums = true -- remove all hud elements besides notes and strums
			if adjustVar > 0 then
				adjustVar = adjustVar - 0.006
			end

			receptor:tweenAlpha(0, 1.5)
		end

		if curStep == 328 or curStep == 396 or curStep == 568 then
			adjustVar = 0.0
		end
	end
end