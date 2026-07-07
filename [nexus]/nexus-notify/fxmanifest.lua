fx_version "cerulean"
game "gta5"
lua54 "yes"

name "nexus-notify"
description "Notification module for Nexus Core"

dependency "nexus-core"

ui_page "html/index.html"

files {
    "html/index.html",
    "html/app.css",
    "html/app.js"
}

client_script "client/main.lua"
