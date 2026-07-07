fx_version "cerulean"
game "gta5"
lua54 "yes"

name "nexus-menu"
description "Menu module for Nexus Core"
version "0.0.2-beta"

dependency "nexus-core"

ui_page "html/index.html"

files {
    "html/index.html",
    "html/app.css",
    "html/app.js"
}

client_script "client/main.lua"
