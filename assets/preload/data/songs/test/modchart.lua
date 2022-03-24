-- "Test"

cameraZoom = 0.5

function songStart()
    for i = 4,7 do
        local receptor = _G["receptor_"..i]
        --Bf's arrows
    end

    for p = 0,3 do
        local receptor = _G["receptor_"..i]
		--P2's arrows
        receptor.alpha = 0
    end

    cameraZoom = 0.5
end

function update(elapsed)
    cameraZoom = 0.5
end