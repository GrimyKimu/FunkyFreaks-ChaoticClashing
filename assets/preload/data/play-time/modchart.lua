-- "Play-Time""

function start(song) 

end

function update(elapsed)
	camHudAngle = cameraAngle

	if cameraAngle > 0 then
		cameraAngle = cameraAngle - 0.035
	elseif cameraAngle < 0 then
		cameraAngle = cameraAngle + 0.035
	end
end


function playerTwoSing()
	cameraAngle = cameraAngle - 0.35
	if cameraAngle < -15 then
		cameraAngle = -15
	end
end

function playerOneSing()
	cameraAngle = cameraAngle + 0.35
	if cameraAngle > 15 then
		cameraAngle = 15
	end
end

function playerTwoTurn()
end

function playerOneTurn()
end