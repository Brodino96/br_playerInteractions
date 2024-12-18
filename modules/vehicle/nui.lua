---Opens the vehicle ui
---@param vehicleName string Vehicle model
function OpenCarMenu(vehicleName)
    SendNUIMessage({
        ui = "vehicle",
        action = "open",
        vehicle = vehicleName
    })
    SetNuiFocus(false, true)
end

RegisterNUICallback("ToogleDoor", function (body, cb)
    ToogleDoor(body.id)
    cb()
end)

RegisterNUICallback("ToggleEngine", function (body, cb)
    ToggleEngine()
    cb()
end)

RegisterNUICallback("ToggleWindow", function (body, cb)
    ToggleWindow(body.id)
    cb()
end)