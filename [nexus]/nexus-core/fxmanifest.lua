fx_version "cerulean"
game "gta5"
lua54 "yes"

name "nexus-core"
author "Cursor"
description "Nexus Core framework foundation"
version "1.0.0"

shared_scripts {
    "shared/config.lua",
    "shared/events.lua",
    "shared/utils.lua",
    "shared/locales.lua"
}

server_scripts {
    "@oxmysql/lib/MySQL.lua",
    "server/callbacks.lua",
    "server/database.lua",
    "server/permissions.lua",
    "server/player.lua",
    "server/main.lua"
}

client_scripts {
    "client/main.lua"
}
