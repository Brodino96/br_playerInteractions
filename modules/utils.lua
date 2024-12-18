local stop = false

---Disable the player controls
---@param allowMovement boolean If the player can move
---@param allowCamera boolean If the player can look around
function DisableControls(allowMovement, allowCamera)
    stop = true
    CreateThread(function ()
        while stop do
            Wait(0)

            DisableAllControlActions(0)

            if allowMovement then
                EnableControlAction(0, 32, true) -- W
                EnableControlAction(0, 34, true) -- A
                EnableControlAction(0, 33, true) -- S
                EnableControlAction(0, 35, true) -- D
            end

            if allowCamera then
                EnableControlAction(0, 1, true) -- mouse left/right
                EnableControlAction(0, 2, true) -- mouse up/down
            end
        end
    end)
end

---Gives control back to the player
function EnableControls()
    stop = false
end

---Loads the specified animation dict
---@param dict string
function LoadDict(dict)
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Wait(0)
    end
end

---Plays the specified animation
---@param anim table Contains animation's dict and name
---@param unstoppable boolean If the animation can be stopped
---@return boolean
function PlayAnim(anim, unstoppable)
    local playerPed = PlayerPedId()
    TaskPlayAnim(playerPed, anim.dict, anim.name, 2.0, 2.0, anim.duration, 0, 0, false, false, false)
    if unstoppable then
        DisableControls(false, true)
        Wait(anim.duration)
        EnableControls()
        return true
    end
    return true
end

---Returns the closest player within the specified range
---@param range number Range in GTA units
---@return integer
function GetClosestPlayer(range)
    local ped = 0
    local players = GetActivePlayers()
    local pCoords = GetEntityCoords(PlayerPedId())
    for i = 1, #players do
        local currentPed = GetPlayerPed(players[i])
        if #(pCoords - GetEntityCoords(currentPed)) < range then
            ped = currentPed
        end
    end
    return ped
end