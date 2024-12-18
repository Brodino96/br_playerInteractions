Config = {}

Config.handcuff = {
    command = "cuff",
    anim = {
        ["cuff"] = {
            ---Animation for the "cop" that actively cuffs the "criminal"
            ["active"] = {
                ["front"] = { dict = "", name = "", duration = 1 },
                ["back"] = { dict = "mp_arrest_paired", name = "cop_p2_back_left", duration = 3000 },
            },
            ---Animations for the "criminal" that gets cuffed by the "cop"
            ["passive"] = {
                ["front"] = { dict = "", name = "", duration = 1 },
                ["back"] = { dict = "mp_arrest_paired", name = "crook_p2_back_left", duration = 3000 },
            },
        },
        ["uncuff"] = {
            ---Animation for the "cop" that actively uncuffs the "criminal"
            ["active"] = {
                ["front"] = { dict = "mp_arresting", name = "a_uncuff", duration = 3000 },
                ["back"] = { dict = "mp_arresting", name = "a_uncuff", duration = 3000 },
            },
        },
        ---Animation loop for the "criminal" after he got cuffed
        ["cuffed"] = {
            ["front"] = { dict = "", name = "", duration = -1 },
            ["back"] = { dict = "mp_arresting", name = "idle", duration = -1 },
        }

    },
}