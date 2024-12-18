-- Cuff
RegisterCommand(Config.handcuff.command, function ()
    local target = GetClosestPlayer(3)
    if not target then
        -- notify
    end

    CuffInit(target)
end, false)