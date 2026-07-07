# Nexus Core

Nexus Core is a custom FiveM roleplay framework built from scratch in Lua with `oxmysql`. The goal of this project is to provide a fully custom RP foundation without depending on QB-Core, ESX, or another existing server core.

This repository currently contains:

- a modular framework structure
- a working `nexus-core` base resource
- SQL schema for the current core systems
- working NUI-based character, appearance, inventory, garage, notify, menu, and HUD foundations
- playable first-pass implementations for characters, appearance, spawn, inventory, vehicles, and garages
- scaffolding for a much larger set of roleplay modules
- txAdmin custom template support
- built-in multilingual support for Dutch, English, German, and French

## Vision

Nexus Core is designed as a modular framework. Instead of putting the whole server into one giant script, each major feature lives in its own `nexus-*` resource. This makes the framework easier to maintain, test, replace, and expand.

Examples:

- economy logic belongs in `nexus-economy`
- job logic belongs in `nexus-jobs`
- police systems belong in `nexus-police`
- inventory systems belong in `nexus-inventory`

The central framework resource is `nexus-core`. Other modules connect to it through shared config, callbacks, database helpers, player state, and exported logic.

## Current project structure

Main files and folders:

- `server.cfg`: the main FXServer configuration
- `recipe.yaml`: txAdmin-ready custom recipe in the root
- `[nexus]/`: all custom Nexus resources
- `[nexus]/nexus-core/`: the heart of the framework
- `[nexus]/nexus-core/sql/schema.sql`: the first SQL schema

## Included resources

### Foundation

- `nexus-core`: shared config, events, callbacks, player lifecycle, permissions, database wrapper
- `nexus-characters`: multicharacter NUI, character create/select/delete flow
- `nexus-spawn`: last-location persistence and spawn support
- `nexus-identity`: identity module placeholder

### Economy and progression

- `nexus-economy`: cash, bank, dirty money basics
- `nexus-banking`: banking module placeholder
- `nexus-jobs`: jobs, grades, duty state, paycheck loop
- `nexus-paycheck`: paycheck module placeholder

### Vehicles

- `nexus-vehicles`: vehicle ownership and storage records
- `nexus-garages`: garage NUI, vehicle spawn/store flow and state updates
- `nexus-fuel`: fuel module placeholder

### Inventory and interaction

- `nexus-inventory`: slot-based inventory with NUI and item interactions
- `nexus-target`: interaction targeting placeholder
- `nexus-interactions`: interaction helper placeholder
- `nexus-crafting`: crafting placeholder
- `nexus-shops`: shops placeholder
- `nexus-clothing`: appearance editor and appearance persistence

### Civilian roleplay

- `nexus-housing`
- `nexus-businesses`
- `nexus-phone`

These are currently scaffolded so the project already has the correct modular structure for expansion.

### Government roleplay

- `nexus-police`
- `nexus-ambulance`
- `nexus-mdt`
- `nexus-evidence`
- `nexus-jail`
- `nexus-dispatch`

### Criminal roleplay

- `nexus-gangs`
- `nexus-drugs`
- `nexus-robberies`
- `nexus-heists`
- `nexus-blackmarket`
- `nexus-laundering`

### UI, staff, and quality

- `nexus-hud`: shared HUD base
- `nexus-menu`: shared menu base
- `nexus-notify`: shared NUI notification layer
- `nexus-scoreboard`
- `nexus-admin`
- `nexus-anticheat-lite`
- `nexus-logs`

## What is already implemented

The project already includes a functional base framework layer:

- account creation based on FiveM player identifiers
- character creation, selection, and delete callbacks
- player loading and unloading
- player money state
- player job state
- permission groups through ACE permissions
- database helper functions through `oxmysql`
- inventory persistence and NUI interaction base
- vehicle persistence base
- garage spawn/store state updates
- appearance persistence
- reconnect persistence through `last_location`

## Requirements

To run Nexus Core you need:

- a FiveM server artifact with Lua 5.4 support
- `oxmysql`
- a MySQL or MariaDB database
- a valid Cfx.re server license key

## Language support

Nexus Core now includes a central locale system for:

- Dutch (`nl`)
- English (`en`)
- German (`de`)
- French (`fr`)

The language system is defined in `\[nexus]\nexus-core\shared\locales.lua`.

### How it works

- `NexusTranslate(locale, key, ...)` returns a translated string
- `NexusNormalizeLocale(locale)` validates and normalizes locale codes
- `NexusGetSupportedLocales()` returns the supported language list
- player locale is stored on the character record through the `locale` column

### Current integration

The locale system is already connected to:

- core loading messages
- language switching messages
- job duty messages
- paycheck messages
- economy transfer messages
- inventory item labels
- inventory interaction messages
- garage messages
- job labels through translation keys

### Commands

Players can use:

- `/language nl`
- `/language en`
- `/language de`
- `/language fr`
- `/lang nl`
- `/lang en`
- `/lang de`
- `/lang fr`

Using `/language` without an argument shows the active language.

### How to add translations in future scripts

Recommended pattern:

1. Add a translation key in `\[nexus]\nexus-core\shared\locales.lua`
2. Use `NexusTranslate(player.locale, "your.translation.key")` on the server
3. Use `NexusTranslate(currentLocale, "your.translation.key")` on the client
4. Prefer `labelKey` fields in config and item definitions instead of hardcoded text

## Installation

### Manual installation

1. Put this repository in your server root or copy the files into your server root.
2. Make sure `oxmysql` exists in your resources.
3. Create a database, for example `nexus_core`.
4. Import the SQL file from `\[nexus]\nexus-core\sql\schema.sql`.
5. Open `server.cfg`.
6. If you are not using txAdmin recipe deployment, replace these placeholders manually:
   - `{{dbConnectionString}}`
   - `{{serverEndpoints}}`
   - `{{maxClients}}`
   - `{{svLicense}}`
7. Start the server with `server.cfg`.

### Database note for existing installs

If you already imported an older version of the schema, make sure your `nexus_characters` table also contains:

- `appearance`
- `last_location`
- `deleted_at`

These are now used for appearance persistence, reconnect persistence, and soft-delete of characters.

### Example manual database string

Example:

```cfg
set mysql_connection_string "mysql://root:password@127.0.0.1/nexus_core?charset=utf8mb4"
```

## txAdmin custom template

Nexus Core includes a txAdmin custom recipe so the framework can be imported directly in the txAdmin Server Deployer.

Included files:

- `recipe.yaml`

### How to import this as a custom recipe in txAdmin

https://raw.githubusercontent.com/NexusCorefivem/core/recipe.yaml
```

Do not use the normal GitHub page URL with `/blob/`.

#### 5. Import it into txAdmin

In txAdmin:

1. open Server Deployer
2. choose `Custom Recipe`
3. paste the raw `recipe.yaml` URL
4. continue

#### 6. Fill in the txAdmin deploy fields

txAdmin will ask for:

- server name
- database info
- slot count
- license key

That is enough. The recipe handles the rest.

### What this YML file does when imported

When txAdmin imports this recipe, it will:

1. connect to the database
2. create the needed folders
3. download your Nexus Core repo
4. download default CFX resources
5. move `[nexus]` into `resources/[nexus]`
6. move `server.cfg` into the server root
7. replace txAdmin placeholders in `server.cfg`
8. import `nexus-core/sql/schema.sql`
9. clean temporary files

### Common mistakes

- using the GitHub page URL instead of the raw `recipe.yaml` URL
- forgetting to change the `src` line
- forgetting to push the changed YML to GitHub
- wrong branch in `ref`
- expecting txAdmin to import a local file directly instead of a hosted recipe URL

### What the txAdmin recipe does

The recipe will:

- connect to the selected database
- create the `resources` folder if needed
- download default CFX resources into `resources/[cfx]`
- download your Nexus Core repository
- move the `[nexus]` folder into `resources/[nexus]`
- move `server.cfg` into the server root
- replace template variables in `server.cfg`
- import the SQL schema into the database

## Stability and security

The current Nexus Core base has also been hardened with a first security and stability pass.

Already improved:

- duplicate txAdmin recipe removed so only one source of truth remains
- player money values are normalized and cannot go negative through normal exports
- invalid money account names are blocked
- bank transfer input is validated more strictly
- character creation is sanitized and limited
- character count respects `maxCharacters`
- invalid character IDs are blocked
- vehicle creation validates model names and retries unique plate generation
- garage state updates now verify ownership before writing to the database
- inventory item insertion validates count and metadata type
- player unload handling now clears client state more cleanly
- callback requests validate callback names, payload types, and request IDs
- shared sanitizing helpers are available for future script development
- identifier lookup is more consistent across core and character helpers
- an unnecessary placeholder client loop was removed
- garage spawn/store flow now persists state more carefully
- first-join character flow now opens a real multicharacter UI

This does not mean the framework is fully exploit-proof yet, but the most obvious trust and validation issues in the first build are now reduced.

## Offline verification

Because there is currently no FiveM server available in this workspace, all improvements were done as an offline code-quality pass.

That means I could do:

- structural bug fixes
- input validation improvements
- consistency improvements
- event and callback hardening
- README and developer documentation updates

That also means I could not yet do:

- live FXServer startup validation
- runtime event flow testing
- in-game character load testing
- txAdmin deploy testing against a real server instance
- database migration testing against a live environment

### Recommended first live checks later

As soon as you have a FiveM server available, test these first:

1. txAdmin custom recipe import using the root `recipe.yaml`
2. database connection and schema import
3. first player join opens character UI
4. character create, select, and delete
5. `/appearance` save and reload
6. `/inventory` use, drop, and give
7. `/garage` spawn and `/storecar` store flow
8. reconnect persistence to last location
9. `/language` and `/lang` commands
10. money add/remove/transfer flow
11. job duty toggle and paycheck loop

## server.cfg explanation

The current `server.cfg` is txAdmin-ready.

Important lines:

- `sv_hostname "{{serverName}}"`: server name inserted by txAdmin
- `set mysql_connection_string "{{dbConnectionString}}"`: database string inserted by txAdmin
- `{{serverEndpoints}}`: network endpoints inserted by txAdmin
- `set sv_maxclients {{maxClients}}`: slot count inserted by txAdmin
- `sv_licenseKey "{{svLicense}}"`: license key inserted by txAdmin
- `ensure [cfx]`: starts default CFX resources
- `ensure oxmysql`: starts the database resource
- `ensure [nexus]`: starts all Nexus Core resources

The file is now also split into practical sections for:

- identity and server branding
- game build and core server settings
- network and endpoint privacy
- optional voice defaults
- script security flags
- ACE groups and permission inheritance
- resource start order

The resource section is now also explicit instead of relying only on `ensure [nexus]`. That makes the startup order easier to review and customize per module.

If you use the repo outside txAdmin, replace these values with static values manually.

### ACE permissions in `server.cfg`

Nexus Core uses ACE permissions for staff groups. The core checks:

- `nexus.staff`
- `nexus.admin`
- `nexus.owner`

The included `server.cfg` already defines group inheritance:

- `group.owner` inherits `group.admin`
- `group.admin` inherits `group.dev`
- `group.dev` inherits `group.moderator`
- `group.moderator` inherits `group.support`
- `group.support` inherits `group.staff`
- `group.staff` inherits `group.user`

That means:

- owners automatically have admin and staff rights
- admins automatically have staff rights
- developers can be separated from full owners
- moderators and support can receive lighter access than admins

### How to add your own staff

At the bottom of the ACE section in `server.cfg`, replace the example identifiers with your own real FiveM license identifiers.

Example:

```cfg
add_principal identifier.license:xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx group.owner
add_principal identifier.license:yyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy group.admin
add_principal identifier.license:dddddddddddddddddddddddddddddddddddddddd group.dev
add_principal identifier.license:mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm group.moderator
add_principal identifier.license:ssssssssssssssssssssssssssssssssssssssss group.support
add_principal identifier.license:zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz group.staff
```

Suggested role intent:

- `group.owner`: full server ownership
- `group.admin`: full administration
- `group.dev`: development and technical management
- `group.moderator`: active in-game moderation
- `group.support`: helper/support role
- `group.staff`: minimal staff role

### How the core reads ACE permissions

`nexus-core` maps these ACE permissions to framework groups:

- `nexus.owner` -> `owner`
- `nexus.admin` -> `admin`
- `nexus.staff` -> `staff`
- no ACE match -> `player`

So if a player has:

```cfg
add_principal identifier.license:xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx group.admin
```

and `group.admin` has:

```cfg
add_ace group.admin nexus.admin allow
```

then Nexus Core will recognize that player as `admin`.

## Resource start order

The `server.cfg` now starts Nexus resources explicitly in groups instead of only using `ensure [nexus]`.

This makes it easier to:

- disable one module quickly
- move a module higher or lower in startup order
- debug dependency issues
- build a lighter or heavier server preset

The current order is:

1. default CFX resources
2. `oxmysql`
3. Nexus Core foundation
4. core RP support
5. civilian systems
6. government systems
7. criminal systems
8. UI, admin, and logging

## Core architecture

### `nexus-core`

`nexus-core` is the heart of the framework and contains:

- `shared/config.lua`: global config values
- `shared/events.lua`: central event names
- `shared/utils.lua`: utility helpers
- `server/database.lua`: database wrapper around `oxmysql`
- `server/callbacks.lua`: callback/RPC system
- `server/permissions.lua`: ACE-based permission mapping
- `server/player.lua`: loaded player object handling
- `server/main.lua`: account loading, character loading, and lifecycle events
- `client/main.lua`: client callback handling and simple loading flow

### Callback flow

The framework uses a simple callback/RPC model:

1. client calls `TriggerNexusCallback`
2. request is sent to the server
3. server finds the registered callback handler
4. server processes the request
5. result is sent back to the client

This pattern is used for things like:

- listing characters
- creating a character
- deleting a character
- saving appearance
- reading player balances
- loading inventory
- inventory use/drop/give
- listing vehicles
- garage vehicle lookup

### Player lifecycle

The current player flow is:

1. player joins
2. framework looks up the main license identifier
3. account is created if it does not exist
4. multicharacter UI opens
5. player creates or selects a character
6. selected character is loaded into memory
7. spawn, locale, money, job, and appearance are sent to the client
8. last location is updated during gameplay
9. when the player disconnects, data is saved

## Development guide

This section is for developers who want to build scripts on top of `Nexus Core`.

The main rule is:

- do not build scripts as isolated standalone logic if they depend on player, money, jobs, vehicles, or inventory
- instead, connect them to `nexus-core` and existing `nexus-*` modules

### Important core concepts

When writing scripts for Nexus Core, you will usually work with:

- shared events from `\[nexus]\nexus-core\shared\events.lua`
- server callbacks registered through `RegisterNexusCallback`
- loaded player objects from `GetNexusPlayer(source)`
- exports from modules like economy, jobs, vehicles, and inventory
- translations from `NexusTranslate`

### Important triggers and events

These are the most important built-in events right now.

#### Core events

- `nexus:server:playerLoaded`
  - sent from server to client when the selected character is fully loaded
  - useful for starting HUD, UI, map logic, job logic, spawn logic, and personal systems

- `nexus:server:playerUnloaded`
  - reserved unload event name in the core event map
  - useful as a standard for future cleanup logic

- `nexus:server:characterSelected`
  - client triggers this after choosing a character
  - the core uses this to load character data into memory

- `nexus:server:setLocale`
  - client triggers this to switch language
  - updates the player's current locale

- `nexus:client:localeChanged`
  - server sends this to the client after a language change
  - useful for refreshing UI, menus, or translated labels

- `nexus:client:notify`
  - server sends a notification message to the client
  - use this as the standard message output channel for now

#### Economy events

- `nexus:economy:transferBank`
  - server event for bank transfers between players
  - expects `targetSource` and `amount`

#### Jobs events

- `nexus:jobs:setDuty`
  - toggles a player's duty state
  - expects a boolean value

### Important callbacks

Nexus Core uses its own callback layer.

On the server, register callbacks with:

```lua
RegisterNexusCallback("my:callback:name", function(source, payload)
    return {
        ok = true
    }
end)
```

On the client, call them with:

```lua
TriggerNexusCallback("my:callback:name", { example = true }, function(result, errorCode)
    if errorCode then
        print(errorCode)
        return
    end

    print(json.encode(result))
end)
```

#### Current built-in callbacks

- `nexus:characters:list`
  - returns all characters for the player's account

- `nexus:characters:create`
  - creates a new character
  - payload currently supports `firstname`, `lastname`, `dateofbirth`, `gender`, `locale`

- `nexus:characters:delete`
  - soft-deletes a character for the player's own account

- `nexus:characters:getAppearance`
  - returns the loaded appearance object for the active character

- `nexus:characters:updateAppearance`
  - saves updated appearance data for the active character

- `nexus:characters:updateLocation`
  - stores the player's latest location for reconnect persistence

- `nexus:locale:get`
  - returns the current locale and supported locale list

- `nexus:economy:getBalances`
  - returns `cash`, `bank`, and `dirty`

- `nexus:jobs:get`
  - returns the loaded job object

- `nexus:vehicles:list`
  - returns vehicles owned by the active character

- `nexus:garages:list`
  - returns garage definitions and player vehicles

- `nexus:inventory:get`
  - returns the player's inventory with translated item labels

- `nexus:inventory:use`
  - uses one item from a slot

- `nexus:inventory:drop`
  - drops or removes one or more items from a slot

- `nexus:inventory:give`
  - gives one or more items from a slot to another loaded player

### Important exports

#### `nexus-economy`

- `exports["nexus-economy"]:AddMoney(source, account, amount)`
- `exports["nexus-economy"]:RemoveMoney(source, account, amount)`
- `exports["nexus-economy"]:GetMoney(source, account)`

Supported money accounts right now:

- `cash`
- `bank`
- `dirty`

Example:

```lua
local success = exports["nexus-economy"]:AddMoney(source, "cash", 500)
```

#### `nexus-jobs`

- `exports["nexus-jobs"]:SetJob(source, jobName, grade, onduty)`

Example:

```lua
exports["nexus-jobs"]:SetJob(source, "police", 1, true)
```

#### `nexus-vehicles`

- `exports["nexus-vehicles"]:CreateVehicleRecord(source, model, garage)`
- `exports["nexus-vehicles"]:GetOwnedVehicles(source)`
- `exports["nexus-vehicles"]:GetOwnedVehicleByPlate(source, plate)`

Example:

```lua
local vehicle = exports["nexus-vehicles"]:CreateVehicleRecord(source, "adder", "pillbox")
```

#### `nexus-inventory`

- `exports["nexus-inventory"]:GetPlayerInventory(source)`
- `exports["nexus-inventory"]:AddItem(source, itemName, count, metadata)`

Example:

```lua
exports["nexus-inventory"]:AddItem(source, "water", 1, {})
```

### Player object

Loaded players are stored in memory and can be fetched with:

```lua
local player = GetNexusPlayer(source)
```

If the player is loaded, the object currently contains:

- `player.source`
- `player.accountId`
- `player.characterId`
- `player.citizenId`
- `player.firstname`
- `player.lastname`
- `player.job`
- `player.money`
- `player.spawn`
- `player.lastLocation`
- `player.appearance`
- `player.metadata`
- `player.locale`

#### Useful player methods

- `player:GetName()`
- `player:SetMoney(account, amount)`
- `player:AddMoney(account, amount)`
- `player:RemoveMoney(account, amount)`
- `player:SetJob(jobName, grade, onduty)`
- `player:Save()`

Example:

```lua
local player = GetNexusPlayer(source)
if not player then
    return
end

print(player:GetName())
player:AddMoney("cash", 250)
player:Save()
```

### Notifications

For consistency, new scripts should currently use the core notify event:

```lua
TriggerClientEvent(NexusEvents.notify, source, "Your message here")
```

If your script supports multiple languages, prefer:

```lua
local player = GetNexusPlayer(source)
local locale = player and player.locale or NexusConfig.Framework.defaultLocale
TriggerClientEvent(NexusEvents.notify, source, NexusTranslate(locale, "your.translation.key"))
```

### Translations in custom scripts

All new scripts should use the shared locale system instead of hardcoded text.

Recommended server pattern:

```lua
local player = GetNexusPlayer(source)
local locale = player and player.locale or NexusConfig.Framework.defaultLocale
local message = NexusTranslate(locale, "your.translation.key")
```

Recommended config pattern:

```lua
someItem = {
    labelKey = "items.someItem"
}
```

### Database access

Do not open your own raw database integration inside every script unless needed. Use the core database wrapper:

- `NexusDatabase.FetchAll(query, parameters)`
- `NexusDatabase.FetchSingle(query, parameters)`
- `NexusDatabase.Execute(query, parameters)`
- `NexusDatabase.Insert(query, parameters)`
- `NexusDatabase.OnReady(callback)`

Example:

```lua
local houses = NexusDatabase.FetchAll("SELECT * FROM nexus_properties WHERE owner_character_id = ?", {
    player.characterId
})
```

### Recommended script structure

For a new Nexus resource, follow this pattern:

1. add `dependency "nexus-core"` in `fxmanifest.lua`
2. use `GetNexusPlayer(source)` for loaded player state
3. use `RegisterNexusCallback` for client-server requests
4. use module exports for shared systems like money and inventory
5. use `NexusTranslate` for all player-facing text
6. save only the data your module owns

### Best practices

- always validate `source` and loaded player state before doing gameplay logic
- never trust client data directly for money, items, jobs, or ownership
- keep gameplay authority on the server
- prefer exports and callbacks over duplicated logic
- prefer translation keys over hardcoded text
- keep new resources modular and focused on one responsibility
- use `fxmanifest.lua` dependencies so FiveM resolves load order correctly

### Example: reward player after an action

```lua
RegisterNetEvent("nexus:example:reward", function()
    local source = source
    local player = GetNexusPlayer(source)
    if not player then
        return
    end

    exports["nexus-economy"]:AddMoney(source, "cash", 250)

    local locale = player.locale or NexusConfig.Framework.defaultLocale
    TriggerClientEvent(NexusEvents.notify, source, NexusTranslate(locale, "example.reward_received", 250))
end)
```

### Example: create a new callback-based script

```lua
RegisterNexusCallback("nexus:example:getProfile", function(source)
    local player = GetNexusPlayer(source)
    if not player then
        return nil
    end

    return {
        citizenId = player.citizenId,
        name = player:GetName(),
        job = player.job,
        money = player.money,
        locale = player.locale
    }
end)
```

## Database structure

The SQL schema currently creates these main tables:

- `nexus_accounts`
- `nexus_characters`
- `nexus_jobs`
- `nexus_vehicles`
- `nexus_properties`
- `nexus_inventories`

### Table summary

- `nexus_accounts`: one record per player license
- `nexus_characters`: all playable characters tied to an account
- `nexus_jobs`: reserved for job definitions
- `nexus_vehicles`: owned vehicles and their saved state
- `nexus_properties`: future support for housing and property storage
- `nexus_inventories`: saved inventory data by owner type and owner id

## Current gameplay systems

### Characters

The framework can:

- create a character
- delete a character through soft-delete
- generate a custom `citizenid`
- store spawn and metadata data
- store locale
- store appearance
- store last reconnect position
- load the selected character into the framework state

### Economy

The current economy layer includes:

- cash
- bank
- dirty money
- add/remove/get money exports
- simple bank transfer event

### Jobs

The jobs module includes:

- built-in `unemployed`, `police`, and `ambulance` job configs
- job grade support
- duty state
- timed paycheck loop for on-duty players

### Vehicles and garages

The vehicle layer includes:

- vehicle ownership records
- automatic plate generation
- stored vehicle lookup
- garage and vehicle state tracking
- garage UI flow
- vehicle spawn and store persistence

### Inventory

The inventory system now includes:

- slot-based data structure
- shared item definitions
- player inventory database persistence
- exports to read and add items
- NUI inventory
- use/drop/give actions
- translated item labels and basic interaction feedback

### Appearance and spawn

The appearance/spawn layer now includes:

- multicharacter NUI at first join
- appearance editor UI
- saved character appearance
- saved last location
- reconnect spawn persistence

## ACE permissions

The framework currently uses ACE permissions for groups:

- `nexus.staff`
- `nexus.admin`
- `nexus.owner`

Resolved groups:

- `player`
- `staff`
- `admin`
- `owner`

Example `server.cfg` ACE setup:

```cfg
add_ace group.admin nexus.admin allow
add_ace identifier.license:YOUR_LICENSE_HERE nexus.owner allow
```

## Resource order and dependencies

Resources are separated intentionally. The main dependency flow is:

- `nexus-core` should start before feature modules
- feature modules declare dependencies in their `fxmanifest.lua`
- `ensure [nexus]` loads all Nexus resources, while dependencies help FiveM resolve order

Important core modules already connected:

- `nexus-core`
- `nexus-characters`
- `nexus-economy`
- `nexus-jobs`
- `nexus-vehicles`
- `nexus-garages`
- `nexus-inventory`

## Development status

This is still an early large framework pass. That means:

- the project structure is in place
- core data flow is in place
- several key gameplay systems are now playable in first-pass form
- many advanced roleplay modules are scaffolded but not fully built out yet

Examples of modules that still need deeper implementation:

- phone UI and apps
- housing gameplay
- police tools and MDT logic
- EMS revive/medical gameplay
- evidence collection
- heists and robbery content
- business ownership gameplay
- admin action panels
- HUD and NUI systems

## Recommended next development order

For expanding Nexus Core further, this is the best order:

1. improve identity flow and deeper appearance customization
2. expand inventory with metadata depth, weight rules, stashes, and drag/drop polish
3. add vehicle keys, impound gameplay, and better mod persistence
4. add police and ambulance gameplay systems
5. build housing and businesses
6. add gangs, drugs, robberies, and heists
7. build admin gameplay panels, logs, and anti-cheat checks

## Troubleshooting

### The server does not connect to the database

Check:

- is `oxmysql` installed and started
- is the connection string valid
- does the database exist
- was the SQL schema imported

### Characters do not load

Check:

- whether `nexus-core` started successfully
- whether `nexus-characters` started successfully
- whether `oxmysql` is running
- whether the account and character tables exist

### Appearance does not save or reload

Check:

- whether the `appearance` column exists in `nexus_characters`
- whether `nexus-clothing` started successfully
- whether the selected ped model is valid on the server build

### Vehicles do not store or respawn correctly

Check:

- whether `nexus-vehicles` and `nexus-garages` started successfully
- whether the `last_location`, `fuel`, `engine`, and `body` values are being saved
- whether the plate belongs to the active character

### txAdmin recipe does not work

Check:

- whether the `src` value points to your real GitHub repository
- whether you used the raw URL of the recipe file
- whether the repo branch matches `ref: main`
- whether txAdmin can access the repository

## Notes

This repository is already usable as a custom framework base, but it is not yet a finished full-production RP server. It gives you a fully custom architecture and a clean starting point for building a serious FiveM roleplay server under the `Nexus Core` name.
