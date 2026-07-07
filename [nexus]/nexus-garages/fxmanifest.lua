fx_version "cerulean"
game "gta5"
lua54 "yes"

name "nexus-garages"
description "Garage handling for Nexus Core"

dependency "nexus-vehicles"

ui_page "html/index.html"

files {
    "html/index.html",
    "html/app.css",
    "html/app.js"
}

server_scripts {
    "server/main.lua"
}

client_scripts {
    "client/main.lua"
}
