fx_version "cerulean"
game "gta5"
lua54 "yes"

name "nexus-identity"
description "Identity module for Nexus Core"
version "0.0.2-beta"

dependency "nexus-core"

shared_scripts {
    "@nexus-core/shared/config.lua",
    "@nexus-core/shared/modules_config.lua",
    "@nexus-core/shared/events.lua",
    "@nexus-core/shared/utils.lua",
    "@nexus-core/shared/locales.lua",
    "@nexus-core/shared/module_locales.lua"
}

server_scripts {
    "@nexus-core/bridge/server.lua",
    "server/main.lua"
}

client_scripts {
    "@nexus-core/shared/callback_client.lua",
    "client/main.lua"
}
