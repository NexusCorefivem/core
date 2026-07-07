fx_version "cerulean"
game "gta5"
lua54 "yes"

name "nexus-clothing"
description "Clothing module for Nexus Core"

dependency "nexus-characters"

ui_page "html/index.html"

files {
    "html/index.html",
    "html/app.css",
    "html/app.js"
}

server_script "server/main.lua"
client_script "client/main.lua"
