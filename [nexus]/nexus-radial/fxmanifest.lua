fx_version "cerulean"
game "gta5"
lua54 "yes"

name "nexus-radial"
description "Radial menu for Nexus Core"
version "0.0.2-beta"

dependency "nexus-core"
dependency "nexus-menu"
dependency "nexus-jobs"
dependency "nexus-identity"
dependency "nexus-vehiclekeys"

shared_scripts {
    "@nexus-core/shared/config.lua",
    "@nexus-core/shared/modules_config.lua",
    "@nexus-core/shared/events.lua",
    "@nexus-core/shared/utils.lua",
    "@nexus-core/shared/locales.lua",
    "@nexus-core/shared/module_locales.lua",
    "@nexus-core/shared/callback_client.lua"
}

client_script "client/main.lua"
