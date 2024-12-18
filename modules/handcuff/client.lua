--------------------- # --------------------- # --------------------- # --------------------

local isCuffed = false
local cuffType

--------------------- # --------------------- # --------------------- # --------------------

---Checks if the specified player is cuffed or not
---@param targetPed integer The entity handle for the target
---@return boolean
local function isPlayerCuffed(targetPed)
    local anim <const> = Config.handcuff.anim["cuffed"]
    if IsEntityPlayingAnim(targetPed, anim["back"].dict, anim["back"].name, 3) or IsEntityPlayingAnim(targetPed, anim["front"].dict, anim["front"].name, 3) then
        return true
    end
    return false
end

---Gets and returns the type of cuffing animation the player is playing
---@param target integer The entity handle of the target
---@return string|nil cuff `"front"` or `"back"`
local function getPlayerCuffType(target)
    local anim <const> = Config.handcuff.anim["cuffed"]
    if IsEntityPlayingAnim(target, anim["back"].dict, anim["back"].name, 3) then
        return "back"
    end
    if IsEntityPlayingAnim(target, anim["front"].dict, anim["front"].name, 3) then
        return "front"
    end
    return nil
end

---Checks if the player can be cuffed or not
---@param target integer The entity handle of the target
---@return boolean bool
local function canBeCuffed(target)
    if GetEntityHealth(target) < 0 or IsPedInAnyVehicle(target, true) then
        return false
    end
    return true
end

---Initializes the cuffing process
---@param targetPed integer The entity handle for the target
function CuffInit(targetPed)

    if not canBeCuffed(targetPed) then
        return --notify
    end

    local action
    local side
    local coords = {}

    if isPlayerCuffed(targetPed) then
        action = "cuff"
    else
        action = "uncuff"
    end

    local playerPed = PlayerPedId()
    local pCoords = GetEntityCoords(playerPed)

    coords["back"] = GetOffsetFromEntityInWorldCoords(targetPed, 0.0, -0.8, 0.0)
    coords["front"] = GetOffsetFromEntityInWorldCoords(targetPed, 0.0, 0.8, 0.0)

    local backDist = #(pCoords - coords["back"])
    local frontDist = #(pCoords - coords["front"])

    if backDist < frontDist then
        side = "back"
    else
        side = "front"
    end

    CreateThread(function ()
        --TaskGoToCoordAnyMeans(playerPed, toGoCoords.x, toGoCoords.y, toGoCoords.z, 1.0, 0, false, 0, 0)
        TaskFollowNavMeshToCoord(playerPed, coords[side].x, coords[side].y, coords[side].z, 1.0, 2000, 0, 1024, GetEntityHeading(targetPed))
        while GetIsTaskActive(playerPed, 238) --[[ CTaskGoToPointAnyMeans https://alloc8or.re/gta5/doc/enums/eTaskTypeIndex.txt ]] do
        -- while #(GetEntityCoords(PlayerPedId() - coords[side]) < 0.3 do -- alternative
            Wait(100)
            print("task active")
        end
        TriggerServerEvent("br_interactions:handcuff", GetPlayerServerId(NetworkGetPlayerIndexFromPed(targetPed)),{
            side = side, action = action
        })
    end)
end

---Maintains the player cuffed
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
                TaskPlayAnim(playerPed, anim.dict, anim.name, 8.0, -8, anim.duration, 49, 0, false, false, false)
            end
        end
    end)
end

---Simulates being a "cop" and do the cuffs
---@param side string `back` or `front`
---@param status string `active` or `passive`
local function doCuff(side, status)
    LoadDict(Config.handcuff.anim["cuff"][status][side].dict)
    PlayAnim(Config.handcuff.anim["cuff"][status][side], true)

    if status == "passive" then
        checkCuff()
        cuffType = side
    end
end

---Sets the player as uncuffed (parameters refer to `Config.handcuff.anim`)
---@param side string `back` or `front`
---@param status string `active` or `passive`
local function undoCuff(side, status)
    if status == "active" then
        LoadDict(Config.handcuff.anim["uncuff"][status][side].dict)
        PlayAnim(Config.handcuff.anim["uncuff"][status][side], true)
    else
        isCuffed = false
        Wait(200)
        ClearPedTasks(PlayerPedId())
    end
end

--------------------- # --------------------- # --------------------- # --------------------

RegisterNetEvent("br_interactions:cuff")
AddEventHandler("br_interactions:cuff", doCuff)

RegisterNetEvent("br_interactions:uncuff")
AddEventHandler("br_interactions:uncuff", undoCuff)

--------------------- # --------------------- # --------------------- # --------------------

exports("isPlayerCuffed", isPlayerCuffed)

--------------------- # --------------------- # --------------------- # --------------------