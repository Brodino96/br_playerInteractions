Config = {}

Config.handcuff = {
    anim = {
        ["front"] = {
            ["source"] = { dict = "", name = "" },
            ["target"] = { dict = "", name = "" },
        },
        ["back"] = {
            ["source"] = { dict = "mp_arrest_paired", name = "cop_p2_back_left" },
            ["target"] = { dict = "mp_arrest_paired", name = "crook_p2_back_left" }
        },
        ["uncuff"] = {
            ["source"] = { dict = "mp_arresting", name = "a_uncuff" },
            ["target"] = { dict = "mp_arresting", name = "a_uncuff" }
        },
        ["cuffed"] = {
            ["back"] = { dict = "mp_arresting", name = "idle" },
            ["front"] = { dict = "", name = ""}
        }
    }
}