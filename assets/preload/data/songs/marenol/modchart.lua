-- "MARENOL"

painBool = false
trainsMovement = false
trainMultiplier = 0

hudWidth = 0
hudHeight = 0

showOnlyStrums = false

curBeat = 0
curStep = 0

function update(elapsed)
    camShenigans()

    if painBool == true then
        for i = 0,3 do 
            local receptor = _G["receptor_"..i]
            receptor.alpha = math.random(1, 35) / 50
            receptor.angle = math.random(0,360)
        end
    else
        for i = 0,3 do 
            local receptor = _G["receptor_"..i]

            if i < 4 then
                receptor.alpha = 0.2
            else
                receptor.alpha = 1
            end
        end
    end

    if trainsMovement == true then
        for i = 0,3 do
            local receptor = _G["receptor_"..i]

            receptor.x = receptor.x - (hudWidth / 30 * trainMultiplier)

            if receptor.x > (hudWidth - (hudWidth / 6)) then 
                receptor.x = hudWidth / 12
            elseif receptor.x < (hudWidth / 12) then
                receptor.x = (hudWidth - (hudWidth / 6))
            end
            -- i like trains
        end
    end
end

function beatHit(beat)
    -- this is a goddamn mess and I hate it
    -- FOREFATHERS ALL!!    B E A R   W I T N E S S ! ! !   (to my awful modchart)
    if beat == 9 then
        receptorReset(true, 0.6)

        boyfriend:tweenAlpha(1.0, 0.7)
        trainsMovement = false
        -- true beginning
    end
    if beat >= 0 and beat < 4 then
        widthMod = (hudWidth - (hudWidth / 6)) / 4
        receptorReset(false,0.3)
        defaultCam = 0.5
    end
    if beat >= 4 and beat < 9 then
        trainsMovement = true
        trainMultiplier = 1
        boyfriend.alpha = 0
        painBool = true
    end

	if (beat >= 12 and beat < 108) then
        showOnlyStrums = false
        boyfriend.alpha = 1
        dad.alpha = 1
        defaultCam = 0.5

        if beat == 12 or beat == 44 then
            trainsMovement = false
            enemySings = false
        end
        if (beat >= 44 and beat < 76) or (beat >= 24 and beat < 36) then
            -- the 1st drop
            trainsMovement = true
            painBool = true

            if beat ~= 59 and beat ~= 75 and beat ~= 44 then
                cameraZoom = 0.65
                camHudAngle = 15 * camVar
                camVar = camVar * -1.05
                trainMultiplier = trainMultiplier * -1.5
            else
                camVar = camVar / camVar
                cameraZoom = 0.8
                receptorReset(true,0.1)
                trainMultiplier = 0.1
            end
            
        end
        if beat >= 76 and beat < 108 then

            trainsMovement = false
            enemySings = false
            if beat == 76 then
                receptorReset(true,0.1)
            elseif beat == 79 then
                painBool = true
            end

        end
        if beat >= 40 and beat < 44 then
            trainsMovement = true
            trainMultiplier = 1.0
            painBool = true

            if beat == 40 then
                cameraZoom = 0.8
                camHudAngle = 480
                camVar = camVar / camVar
            end
        end
    end

    if beat >= 108 and beat <= 124 then
        showOnlyStrums = true
        painBool = true
        gf:playAnim("drown", "false")
        boyfriend.alpha = 0
        dad.alpha = 0

        if beat == 108 then

            for i = 3,7 do
                local receptor = _G["receptor_"..i]
                receptor:tweenPos(widthMod * (i - 4) + 150, receptor.defaultY, 6.0)
            end

            trainsMovement = true
            trainMultiplier = 0.05

            defaultCam = 0.8
        end

        trainMultiplier = trainMultiplier * -1.1
        
        if beat == 124 then
            boyfriend:tweenAlpha(1.0, 0.7)
            receptorReset(true, 1.0)
            trainsMovement = false
        end

        if math.fmod(beat, 2) == 0 then
            camHudAngle = 2
        end

        --drowning section
    end  

    if curBeat > 124 and beat < 200 then
        showOnlyStrums = false
        boyfriend.alpha = 1
        dad.alpha = 1

        defaultCam = 0.5

        if beat < 156 or beat > 176 then
            enemySings = true
        else
            enemySings = false
            receptorReset(true, 0.1)
        end
    end

    if beat == 200 then
        receptorReset(true, 0.6)
        enemySings = false
        painBool = true
        trainsMovement = false
    end

    if beat >= 204 and beat < 228 and math.fmod(beat, 4) == 0 then
        showOnlyStrums = true
        gf:playAnim("suffer", "true")
        boyfriend.alpha = 0
        dad.alpha = 0.05
        --heartbeat section
        bfSING = false

        if beat == 204 or beat == 208 or beat == 212 or beat == 216 or beat == 220 or beat == 224 or beat == 228 then
            -- heartbeats("don don")
            for i = 0,7 do
                local receptor = _G["receptor_"..i]
                if i == 0 or i == 4 then 
                    receptor.x = receptor.x - 50
                elseif i == 1 or i == 5 then
                    receptor.x = receptor.x - 25
                elseif i == 2 or i == 6 then 
                    receptor.x = receptor.x + 25
                elseif i == 3 or i == 7 then
                    receptor.x = receptor.x + 50
                end
            end

            cameraZoom = 0.7

            receptorReset(true, 1.5)
        end
    end

    if beat >= 228 and beat < 232 then
        gf:playAnim("turnAround", "false")
        receptorReset(true, 0.1)
        dad.alpha = 0.0
        --turning around
    end

    if beat >= 232 and beat < 236 then
        gf:playAnim("scream", "false")

        for i = 0,7 do
            -- split apart P1's arrows like they were split in half by a goddamn chainsaw =)
            local receptor = _G["receptor_"..i]

            if i >= 4 and i < 6 then
                receptor:tweenPos(receptor.x - 30, receptor.defaultY, 0.7)
            elseif i >= 6 then
                receptor:tweenPos(receptor.x + 30, receptor.defaultY, 0.7)
            elseif i >= 0 and i < 4 then
                receptor:tweenPos(widthMod * i + 150, receptor.defaultY, 0.6)
            end
        end

        --S C R E A M E R
    end

    if beat >= 236 and beat < 300 then
        painBool = true
        showOnlyStrums = true
        gf.alpha = 0
        boyfriend.alpha = 1
        dad.alpha = 0
        bfSING = true
        
        trainsMovement = true
        trainMultiplier = math.random(1,100) / 200 * camVar
        camVar = camVar * -1

        if beat == 236 then
            for i = 4,7 do
                local receptor = _G["receptor_"..i]
    
                if i >= 4 and i < 6 then
                    receptor:tweenPos(receptor.x - 120, receptor.defaultY, 25.0)
                elseif i >= 6 then
                    receptor:tweenPos(receptor.x + 120, receptor.defaultY, 25.0)
                end
            end
        end

        if beat > 268 then
            enemySings = true
        else
            enemySings = false
        end

        -- the clocks
    end

    if beat >= 300 and beat < 332 then
        enemySings = false
        showOnlyStrums = true
        trainsMovement = false

        if beat == 300 then
            receptorReset(true, 0.1)
            dad.alpha = 1.0
            dad:tweenAlpha(0.0, 13)

            boyfriend.alpha = 1
            boyfriend:tweenAlpha(0.4, 13)
        end

        --the true finale
    end

    if beat == 332 then
        showOnlyStrums = true
        gf.alpha = 0
        boyfriend.alpha = 0
        dad.alpha = 0.0
        painBool = false
        receptorReset(true,0.1)

        for i = 0,7 do
            local receptor = _G["receptor_"..i]
            receptor:tweenAlpha(0.0,1.0)
        end

        -- the end
    end

    if beat == 43 or beat == 154 then
        boyfriend:playAnim("firstDeath", "true") -- bf fukin dies lmao
        receptorReset(true, 0.1)
    end
end

widthMod = 0
mercyMode = mercyMode

function receptorReset(matchArrow, timer)
    for i = 0,7 do
        local receptor = _G["receptor_"..i]
        receptor.angle = 0

        if matchArrow == true then
            if i >= 4 and i < 8 then
                receptor:tweenPos(receptor.defaultX - 310, receptor.defaultY, timer)
            elseif i >= 0 and i < 4 then
                receptor:tweenPos(receptor.defaultX + 310, receptor.defaultY, timer)
            end
        else
            if i >= 4 and i < 8 then
                receptor:tweenPos(receptor.defaultX - 310, receptor.defaultY, timer)
            elseif i >= 0 and i < 4 then
                receptor:tweenPos(widthMod * i + 150, receptor.defaultY, timer)
            end
        end
    end
end

camVar = 1
cameraZoom = 0.5
defaultCam = 0.5
hudZoom = 1.0
camHudAngle = 0.0
cameraAngle = 0.0

enemySings = false

function camShenigans()
	cameraAngle = camHudAngle * -0.6

	if camHudAngle ~= 0 then
		camHudAngle = camHudAngle * 0.98
	end

	if cameraZoom ~= defaultCam then
		cameraZoom = (0.8 * cameraZoom) + (0.2 * defaultCam)
	end
end

function playerTwoSing(note, songPos)
    for i = 0,3 do
        local receptor = _G["receptor_"..i]
        if enemySings then
            if note == 0 then
                camHudAngle = 3.5 * camVar
                camVar = camVar * -1
            elseif note == 1 then
                cameraZoom = 0.75
            elseif note == 2 then
                receptor.y = math.random(hudHeight / 50,hudHeight)
            elseif note == 3 then
                receptor.x = math.random(hudWidth / 50,hudWidth)
            end
        end
    end
end

followXOffset = 0
followYOffset = 0
bfSING = true

function playerOneSing(note, songPos)
    -- 0 = left, 1 = down, 2 = up, 3 = right
    if bfSING == true then
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
    else
        followXOffset = 0
        followYOffset = 0
    end
end