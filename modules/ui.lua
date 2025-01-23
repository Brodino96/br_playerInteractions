local items

for i = 1, #Config.radial.list do
    items[#items+1] = Config.defaultRadialItems[Config.radial.list[i]]
    items[#items].onSelect = Config.radial.list[i]
    items[#items].keepOpen = false
end

lib.registerRadial({
    id = "br_interactions",
    items = items
})

exports["ox_target"]:addGlobalPed({
    label = ""
})