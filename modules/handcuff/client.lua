--------------------- # --------------------- # --------------------- # --------------------

local isCuffed = false
local cuffType = ""

--------------------- # --------------------- # --------------------- # --------------------

---Returns `true` if the player is already cuffed and `false` if it's not
---@param target integer Entity handle of the target
---@return boolean
local function isPlayerCuffed(target)
    local anim = Config.handcuff.anim["cuffed"] ---@type table
    if IsEntityPlayingAnim(target, anim["back"].dict, anim["back"].name, 3) or IsEntityPlayingAnim(target, anim["front"].dict, anim["front"].name, 3) then
        return true
    end
    return false
end

---Returns the type of cuffing the player is experiencing `front` or `back`
---@param target integer Entity handle of the target
---@return string|nil cuff The type of cuffing
local function getPlayerCuffType(target)
    local anim = Config.handcuff.anim["cuffed"] ---@type table

    if IsEntityPlayingAnim(target, anim["back"].dict, anim["back"].name, 3) then
        return "back"
    end

    if IsEntityPlayingAnim(target, anim["front"].dict, anim["front"].name, 3) then
        return "front"
    end

    return nil
end

---Returns `true` if the player can be cuffed and `false` if it can't
---@param target integer Entity handle of the target
---@return boolean
local function canBeCuffed(target)
    if GetEntityHealth(target) < 0 or IsPedInAnyVehicle(target, true) then
        return false
    end

    return true
end

---Starts the cuffing process
---@param target integer Entity handle of the target
local function cuffPlayer(target)
    if not canBeCuffed(target) then
        return
    end

    local playerPed = PlayerPedId()
    local pCoords = GetEntityCoords(playerPed)

    local type = ""

    local back = GetOffsetFromEntityInWorldCoords(target, 0.0, -0.8, 0.0)
    local front = GetOffsetFromEntityInWorldCoords(target, 0.0, 0.8, 0.0)

    local backDist = #(pCoords - back)
    local frontDist = #(pCoords - front)

    if backDist > 0.5 and frontDist > 0.5 then
        return
    end

    local toGoCoords

    if backDist - frontDist > 0 then
        toGoCoords = back
        type = "back"
    else
        toGoCoords = front
        type = "front"
    end

    CreateThread(function ()
        TaskGoToCoordAnyMeans(playerPed, toGoCoords.x, toGoCoords.y, toGoCoords.z, 1.0, 0, false, 0, 0)
        while GetIsTaskActive(playerPed, 224) --[[ CTaskGoToPointAnyMeans ]] do
            Wait(100)
        end
        TriggerServerEvent("br_interactions:handcuff", GetPlayerServerId(NetworkGetPlayerIndexFromPed(target)), type)
    end)
end

---Starts the UNcuffing process
---@param target integer Entity handle of the target
local function uncuffPlayer(target)
    if not isPlayerCuffed(target) then
        return
    end

    local playerPed = PlayerPedId()
    local pCoords = GetEntityCoords(playerPed)

    local type = getPlayerCuffType(target)
    if not type then
        return
    end

    local coords
    if type == "back" then
        coords = GetOffsetFromEntityInWorldCoords(target, 0.0, -0.8, 0.0)
    else
        coords = GetOffsetFromEntityInWorldCoords(target, 0.0, 0.8, 0.0)
    end

    local dist = #(pCoords - coords)

    if dist > 0.5 then
        return
    end

    CreateThread(function ()
        TaskGoToCoordAnyMeans(playerPed, coords.x, coords.y, coords.z, 1.0, 0, false, 0, 0)
        while GetIsTaskActive(playerPed, 224) --[[ CTaskGoToPointAnyMeans ]] do
            Wait(100)
        end
        TriggerServerEvent("br_interactions:uncuff", GetPlayerServerId(NetworkGetPlayerIndexFromPed(target)), type)
    end)
end

---Main function triggered when button is clicked
---@param target integer Entity handle of the target
function CuffInit(target)
    if isPlayerCuffed(target) then
        uncuffPlayer(target)
    else
        cuffPlayer(target)
    end
end

--------------------- # --------------------- # --------------------- # --------------------

local function checkCuff()
    isCuffed = true
    CreateThread(function ()
        while isCuffed do
            Wait(0)

            local playerPed = PlayerPedId()

            DisableAllControlActions(0)
            EnableControlAction(0, 1, true) -- mouse left/right
            EnableControlAction(0, 2, true) -- mouse up/down
            EnableControlAction(0, 32, true) -- W
            EnableControlAction(0, 34, true) -- A
            EnableControlAction(0, 33, true) -- S
            EnableControlAction(0, 35, true) -- D

            local anim = Config.handcuff.anim["cuffed"][cuffType]
            if not IsEntityPlayingAnim(playerPed, anim.dict, anim.name, 3) and not IsEntityPlayingAnim(playerPed, "nm", "firemans_carry", 3) then
                LoadDict(anim.dict)
                TaskPlayAnim(playerPed, anim.dict, anim.name, 8.0, -8, -1, 49, 0, false, false, false)
            end
        end
    end)
end

local function doCuff(type, active)
    LoadDict(Config.handcuff.anim[type][active].dict)
    PlayAnim(Config.handcuff.anim[type][active], 3000, true)

    if active == "target" then
        cuffType = type
        checkCuff()
    end
end

local function undoCuff(type, active)
    LoadDict(Config.handcuff.anim[type][active].dict)
    PlayAnim(Config.handcuff.anim[type][active], 3000, true)

    if active == "target" then
        isCuffed = false
        Wait(200)
        ClearPedTasks(PlayerPedId())
    end
end

--------------------- # --------------------- # --------------------- # --------------------

RegisterNetEvent("br_interactions:handcuff")
AddEventHandler("br_interactions:handcuff", doCuff)

RegisterNetEvent("br_interactions:uncuff")
AddEventHandler("br_interactions:uncuff", undoCuff)

RegisterCommand("clearcuff", function ()
    undoCuff(getPlayerCuffType(PlayerPedId()), "target")
end, false)

--------------------- # --------------------- # --------------------- # --------------------

exports("isCuffed", function ()
    return isCuffed
end)

exports("isPlayerCuffed", isPlayerCuffed)

--------------------- # --------------------- # --------------------- # --------------------