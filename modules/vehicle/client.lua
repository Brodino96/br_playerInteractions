local currentVehicle

---Used the button
local function buttonPressed()
    local playerPed = PlayerPedId()
    if not IsPedInAnyVehicle(playerPed, false) then
        return
    end
    currentVehicle = GetVehiclePedIsIn(playerPed, false)
    local name = GetDisplayNameFromVehicleModel(GetEntityModel(currentVehicle))
    OpenCarMenu(name)
end

---Open the specified door
---@param doorId integer The door id
function ToggleDoor(doorId)
    local direction
    if GetVehicleDoorAngleRatio(currentVehicle, doorId) > 0.0 then
        direction = "close"
    else
        direction = "open"
    end
    TriggerServerEvent("br_interactions:toggleDoor", NetworkGetNetworkIdFromEntity(currentVehicle), doorId, direction)
end

RegisterCommand("openvehiclemenu", buttonPressed, false)