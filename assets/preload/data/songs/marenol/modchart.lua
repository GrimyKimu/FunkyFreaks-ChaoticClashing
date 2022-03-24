-- "MARENOL"

painBool = false
dad = nil
bf = nil
gf = nil

function songStart()
    for i = 4,7 do
        -- centers P1"s(BF) arrows
        -- only a simple repositioning, no fancy spreading or anything
        local receptor = _G["receptor_"..i]

        receptor:tweenPos(receptor.defaultX - 275, receptor.defaultY, 0.2)
    end

    for p = 0,3 do
        local receptor = _G["receptor_"..p]
        local widthMod = (hudWidth - (hudWidth / 6)) / 4

        receptor:tweenAlpha(0.1, 3.0)
        receptor:tweenPos(widthMod + (widthMod * p), receptor.defaultY, 0.1)
    end
end


cameraZoom = 0.5

function update(elapsed)
    cameraZoom = 0.5

    if painBool == true then
        for i = 0,7 do 
            local receptor = _G["receptor_"..i]
    
           receptor.alpha = math.random(25, 50) / 50
        end
    else
        for i = 0,7 do 
            local receptor = _G["receptor_"..i]
    
            if i <= 3 then
                receptor.alpha = 0.1
            else
                receptor.alpha = 1
            end
        end
    end    
end

function beatHit(beat)
	if beat < 106 or (beat > 124 and beat < 200) then
        showOnlyStrums = false
        painBool = false
        bf.alpha = 1
        dad.alpha = 1

        --idle section(for gf)
    end

    if beat > 104 and beat <= 120 then
        showOnlyStrums = true
        painBool = true
        gf:playAnim("drown", "false")
        bf.alpha = 0
        dad.alpha = 0.5

        --drowning section
    end

    if beat >= 200 and beat < 228 and math.fmod(beat, 4) == 0 then
        showOnlyStrums = true
        painBool = true
        gf:playAnim("suffer", "true")
        bf.alpha = 0
        dad.alpha = 0.5

        --heartbeat section
    end

    if beat >= 228 and beat < 232 then
        gf:playAnim("turnAround", "false")

        --turning around
    end

    if beat >= 232 and beat < 236 then
        gf:playAnim("scream", "false")

        --S C R E A M E R
    end

    if beat >= 236 and beat < 332 then
        painBool = false
        showOnlyStrums = false
        gf.alpha = 0
        bf.alpha = 1
        dad.alpha = 1

        --the finale and the clocks
    end

    if beat >= 332 then
        showOnlyStrums = true
        gf.alpha = 0
        bf.alpha = 0
        dad.alpha = 0

        --end
    end

    if beat == 43 or beat == 154 then
        bf:playAnim("firstDeath", "true")
    end
end