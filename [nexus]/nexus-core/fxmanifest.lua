fx_version "cerulean"
game "gta5"
lua54 "yes"

name "nexus-core"
author "Cursor"
description "Nexus Core framework foundation"
version "0.0.2-beta"

shared_scripts {
    "shared/config.lua",
    "shared/modules_config.lua",
    "shared/events.lua",
    "shared/utils.lua",
    "shared/locales.lua",
    "shared/module_locales.lua",
    "shared/items.lua",
    "shared/gangs.lua",
    "shared/playerdata.lua"
}

files {
    "shared/config.lua",
    "shared/modules_config.lua",
    "shared/events.lua",
    "shared/utils.lua",
    "shared/locales.lua",
    "shared/module_locales.lua",
    "shared/items.lua",
    "shared/gangs.lua",
    "shared/playerdata.lua",
    "shared/callback_client.lua",
    "bridge/server.lua"
}

server_scripts {
    "@oxmysql/lib/MySQL.lua",
    "server/database.lua",
    "server/permissions.lua",
    "server/player.lua",
    "server/security.lua",
    "server/callbacks.lua",
    "server/core.lua",
    "server/main.lua",
    "server/exports.lua"
}

client_scripts {
    "shared/callback_client.lua",
    "client/core.lua",
    "client/main.lua"
}
