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
---@param duration integer Duration of the animation in `ms`
---@param unstoppable boolean If the animation can be stopped
function PlayAnim(anim, duration, unstoppable)
    local playerPed = PlayerPedId()
    TaskPlayAnim(playerPed, anim.dict, anim.name, 2.0, 2.0, duration, 0, 0, false, false, false)
    if unstoppable then
        DisableControls(false, true)
        Wait(duration)
        EnableControls()
    end
end