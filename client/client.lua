local isActive = false
local mode = 'static'
local pointA = nil
local pointB = nil
local isPointASet = false
local CONFIG_MAXDISTANCE = 100
local colorLine = { 0, 255, 0 }
local colorText = { 255, 255, 255 }

local function getRaycastCoord()
    local hit, entityHit, endCoords, surfaceNormal, materialHash = lib.raycast.fromCamera(511, 4, CONFIG_MAXDISTANCE)
    return hit and endCoords or GetGameplayCamCoord() + (GetGameplayCamRot(2) * vector3(0, 0, 100))
end

local function Draw3DText(coords, text, distance)
    local onScreen, _x, _y = GetScreenCoordFromWorldCoord(coords.x, coords.y, coords.z)

    if onScreen then
        local factor = (distance / 20)
        local scale = math.max(0.4, math.min(2.0, factor))

        SetTextScale(scale, scale)
        SetTextFont(4)
        SetTextProportional(1)
        SetTextColour(colorText[1], colorText[2], colorText[3], 215)
        SetTextCentre(true)
        SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextOutline()

        BeginTextCommandDisplayText("STRING")
        AddTextComponentSubstringPlayerName(text)
        EndTextCommandDisplayText(_x, _y)
    end
end

lib.addKeybind({
    name = 'toggleRuler',
    description = 'Activate / Deactivate Ruler',
    defaultKey = 'F6',
    onPressed = function()
        isActive = not isActive
        if isActive then
            pointA = nil
            pointB = nil
            isPointASet = false
            lib.notify({
                title = 'Ruler Activated',
                type = 'inform',
                description = 'Modo: ' ..
                    (mode == 'static' and '2 points' or 'Follow')
            })
        else
            lib.notify({ title = 'Ruler Deactivated', type = 'error' })
        end
    end
})

lib.addKeybind({
    name = 'toggleRulerMode',
    description = 'Toggle Mode',
    defaultKey = 'F7',
    onPressed = function()
        if not isActive then return end
        mode = mode == 'static' and 'follow' or 'static'
        isPointASet = false
        pointA = nil
        pointB = nil

        local modeName = mode == 'static' and '2 Points (Raycast)' or 'Follow (Follow Player)'
        lib.notify({ title = 'Mode Changed', type = 'success', description = modeName })
    end
})

lib.addKeybind({
    name = 'rulerAction',
    description = 'mark Point / Confirm',
    defaultMapper = 'keyboard',
    defaultKey = 'E',
    onPressed = function()
        if not isActive then return end

        local hitCoords = getRaycastCoord()

        if mode == 'static' then
            if not isPointASet then
                pointA = hitCoords
                isPointASet = true
                lib.notify({ title = 'Point A Setted', description = ' Mark Point B' })
            else
                pointB = hitCoords
                lib.notify({ title = 'Point B Setted', description = 'Press E To restart.' })
            end
        elseif mode == 'follow' then
            if not isPointASet then
                pointA = hitCoords
                isPointASet = true
                lib.notify({ title = 'Origin Point Setted', description = 'Move and will change the distance' })
            else
                isPointASet = false
                pointA = nil
                pointB = nil
            end
        end
    end
})

CreateThread(function()
    local playerPed = PlayerPedId()
    while true do
        local wait = 1000

        if isActive then
            wait = 0
            local playerCoords = GetEntityCoords(playerPed)

            local raycastCoord = getRaycastCoord()

            local targetB = nil
            local distance = 0.0

            if mode == 'static' then
                if isPointASet then
                    targetB = pointB or raycastCoord
                end
            elseif mode == 'follow' then
                if isPointASet then
                    targetB = playerCoords
                end
            end

            if pointA and targetB then
                distance = #(pointA - targetB)
                DrawLine(pointA.x, pointA.y, pointA.z, targetB.x, targetB.y, targetB.z, colorLine[1], colorLine[2],
                    colorLine[3], 255)
                local midPoint = (pointA + targetB) / 2
                local text = string.format("%.2f Metros", distance)
                Draw3DText(midPoint, text, distance)
            end

            if not isPointASet then
                DrawMarker(28, raycastCoord.x, raycastCoord.y, raycastCoord.z, 0, 0, 0, 0, 0, 0, 0.1, 0.1, 0.1, 255, 0, 0,
                    200, false, false, 0, false, nil, nil, false)
                lib.showTextUI('[E] Set Point A', { position = 'right-center' })
            elseif mode == 'static' and not pointB then
                DrawMarker(28, raycastCoord.x, raycastCoord.y, raycastCoord.z, 0, 0, 0, 0, 0, 0, 0.1, 0.1, 0.1, 0, 0, 255,
                    200, false, false, 0, false, nil, nil, false)
                lib.showTextUI('[E] Set Point B', { position = 'right-center' })
            elseif pointB then
                lib.showTextUI('[E] Restart Ruler', { position = 'right-center' })
            elseif mode == 'follow' then
                lib.showTextUI('[E] Stop / Restart', { position = 'right-center' })
            end
        else
            lib.hideTextUI()
        end

        Wait(wait)
    end
end)
