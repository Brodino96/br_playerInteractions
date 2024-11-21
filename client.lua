RegisterCommand("cuff", function ()
    local players = GetActivePlayers()
    local pCoords = GetEntityCoords(PlayerPedId())
    for i = 1, #players do
        local ped = GetPlayerPed(players[i])

        if #(pCoords - GetEntityCoords(ped)) < 10 then
            return CuffInit(ped)
        end
    end
end, false)