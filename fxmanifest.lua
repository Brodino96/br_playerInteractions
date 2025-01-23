fx_version "cerulean"
game "gta5"
lua54 "yes"

author "Brodino"

shared_scripts { "@ox_lib/init.lua", "config.lua", }

server_scripts {
    "modules/handcuff/server.lua"
}

client_scripts {
    "client.lua",
    "modules/utils.lua",
    "modules/handcuff/client.lua",
}