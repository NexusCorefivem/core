fx_version "cerulean"
game "gta5"
lua54 "yes"

name "nexus-inventory"
description "Inventory foundation for Nexus Core"

dependency "nexus-core"

ui_page "html/index.html"

files {
    "html/index.html",
    "html/app.css",
    "html/app.js"
}

shared_script "shared/items.lua"
server_script "server/main.lua"
client_script "client/main.lua"
