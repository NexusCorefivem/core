# Nexus Core

**Version:** `0.0.2-beta`  
**Stack:** FiveM · Lua 5.4 · oxmysql · native `nexus-*` framework

Nexus Core is een volwaardig FiveM roleplay framework — volledig eigen geschreven in Lua. Geen QB-Core, ESX of Qbox dependency. Alles draait op `nexus-core` + 50 `nexus-*` modules.

## Wat zit er in 0.0.2-beta?

- **Volwaardige core** — `GetCoreObject()`, `PlayerData`, lifecycle events, `SyncPlayerData`, state bags
- **50 native modules** — characters, economy, jobs, inventory, vehicles, government, criminal, UI
- **Security layer** — rate limits, proximity checks, ban system, inventory limits
- **Database** — 15 tabellen + `seed.sql` voor jobs/gangs
- **Meertalig** — nl (default), en, de, fr
- **txAdmin ready** — `recipe.yaml` importeert schema + seed automatisch

> **Niet nodig:** `qb-core`, `qbx_core`, of andere QB/Qbox resources.

## Snel starten

1. Installeer `oxmysql` en maak een MySQL database
2. Importeer `[nexus]/nexus-core/sql/schema.sql` en `seed.sql`
3. Start de server met `server.cfg`
4. Voeg staff toe via ACE identifiers onderaan `server.cfg`

**Dev debug:** `setr nexus:debug 1` in `server.cfg`

## Alle resources (50)

De volgorde in `server.cfg` is leidend.

### Foundation (7)

| Resource | Functie |
|----------|---------|
| `nexus-core` | Framework kern, security, callbacks, database |
| `nexus-characters` | Multicharacter NUI |
| `nexus-economy` | Cash, bank, dirty money |
| `nexus-jobs` | Jobs, duty, paycheck loop |
| `nexus-vehicles` | Voertuig-eigendom |
| `nexus-garages` | Garage spawn/store |
| `nexus-inventory` | Inventory + NUI |

### Core RP support (14)

`nexus-spawn` · `nexus-identity` · `nexus-banking` · `nexus-fuel` · `nexus-target` · `nexus-interactions` · `nexus-shops` · `nexus-crafting` · `nexus-clothing` · `nexus-vehiclekeys` · `nexus-customs` · `nexus-carwash` · `nexus-cityhall` · `nexus-dealership`

### Civilian jobs (6)

`nexus-taxi` · `nexus-bus` · `nexus-trucker` · `nexus-garbage` · `nexus-mechanic` · `nexus-management`

### Civilian systems (3)

`nexus-housing` · `nexus-businesses` · `nexus-phone`

### Government (6)

`nexus-police` · `nexus-ambulance` · `nexus-mdt` · `nexus-evidence` · `nexus-jail` · `nexus-dispatch`

### Criminal (6)

`nexus-gangs` · `nexus-drugs` · `nexus-robberies` · `nexus-heists` · `nexus-blackmarket` · `nexus-laundering`

### UI / admin (8)

`nexus-hud` · `nexus-menu` · `nexus-notify` · `nexus-radial` · `nexus-smallresources` · `nexus-scoreboard` · `nexus-admin` · `nexus-logs`

## Core API

```lua
-- Server
local Nexus = exports["nexus-core"]:GetCoreObject()
local player = Nexus.Functions.GetPlayer(source)

-- Client
local Nexus = exports["nexus-core"]:GetCoreObject()
local data = Nexus.Functions.GetPlayerData()
```

### PlayerData

```lua
{
  citizenid = "NX-ABC12345",
  charinfo = { firstname, lastname, birthdate, gender, phone },
  job = { name, label, onduty, grade = { level, name } },
  gang = { name, label, grade = { level, name } },
  money = { cash, bank, dirty },
  metadata = {},
  position = vector4,
  locale = "nl"
}
```

### Belangrijke events

| Event | Type |
|-------|------|
| `nexus:server:onPlayerLoaded` | Server hook na karakter laden |
| `nexus:client:onPlayerLoaded` | Client UI/HUD starten |
| `nexus:client:onJobUpdate` | Job sync |
| `nexus:client:onMoneyChange` | Geld sync |
| `nexus:client:onGangUpdate` | Gang sync |

### Belangrijke exports

| Export | Resource |
|--------|----------|
| `GetCoreObject()` | nexus-core |
| `GetNexusPlayer(source)` | nexus-core |
| `SyncPlayerData(source, key, value)` | nexus-core |
| `AddMoney` / `RemoveMoney` | nexus-economy |
| `SetJob` | nexus-jobs |
| `AddItem` / `RegisterUseableItem` | nexus-inventory |
| `CreateVehicleRecord` | nexus-vehicles |
| `HasKeys` / `GiveKeys` | nexus-vehiclekeys |
| `SetPlayerGang` | nexus-gangs |

## Nieuw script schrijven

```lua
-- fxmanifest.lua
dependency "nexus-core"
version "0.0.2-beta"

server_scripts {
    "@nexus-core/bridge/server.lua",
    "server/main.lua"
}

shared_scripts {
    "@nexus-core/shared/events.lua",
    "@nexus-core/shared/callback_client.lua"
}
```

```lua
-- server
RegisterNexusCallback("nexus:myscript:action", function(source, payload)
    local player = GetNexusPlayer(source)
    if not player then return nil end
    return { ok = true }
end)
```

## Database

Import beide bestanden:

- `[nexus]/nexus-core/sql/schema.sql`
- `[nexus]/nexus-core/sql/seed.sql`

| Tabel | Doel |
|-------|------|
| `nexus_accounts` | Speler accounts |
| `nexus_bans` | Bans |
| `nexus_characters` | Karakters |
| `nexus_jobs` + `nexus_job_grades` | Job definities |
| `nexus_gangs` + `nexus_gang_grades` | Gang definities |
| `nexus_vehicles` | Voertuigen |
| `nexus_inventories` | Inventory |
| `nexus_properties` | Woningen |
| `nexus_stashes` | Stashes |
| `nexus_licenses` | Vergunningen |
| `nexus_contacts` / `nexus_phone_messages` | Telefoon |
| `nexus_logs` / `nexus_dispatch` | Logging / meldkamer |

Upgrade van oudere install? Zie `sql/migrations/003_full_core.sql`.

## Security (0.0.2-beta)

`nexus-core/server/security.lua` beschermt tegen veelvoorkomende exploits:

- Rate limiting op callbacks en economy events
- Proximity checks bij shops, jobs, ATM, heists
- On-duty checks voor police/ambulance
- Ban check bij connect + character select
- Inventory weight/slot limits
- Geen client-trusted metadata/jail/death/gang events

**Verwijderd (niet meer in repo):**

- `qb-core` / `qbx_core` — geen QB/Qbox bridge
- `nexus-paycheck` — dubbel met jobs paycheck
- `nexus-anticheat-lite` — vervangen door security layer

## Keybinds

| Key | Actie |
|-----|-------|
| F1 | Radial menu |
| L | Voertuig lock |
| B | Gordel |
| X | Handen omhoog |

## Taal

`/language nl` · `/language en` · `/language de` · `/language fr`

## ACE permissions

`nexus.staff` · `nexus.admin` · `nexus.owner` — configureer in `server.cfg`

## txAdmin

Importeer de raw URL van `recipe.yaml` in txAdmin Server Deployer → Custom Recipe.

De recipe:

1. Downloadt de repo
2. Plaatst `[nexus]` in `resources/`
3. Importeert `schema.sql` + `seed.sql`
4. Vult `server.cfg` placeholders in

## Troubleshooting

| Probleem | Oplossing |
|----------|-----------|
| `RegisterNexusCallback` is nil | Voeg `@nexus-core/bridge/server.lua` toe op server |
| Character UI blijft hangen | Check console op `nexus-core` / `nexus-characters` errors |
| Database errors | Import schema + seed opnieuw |
| QB errors in console | Verwijder `qb-core`/`qbx_core` van je server |

---

*Nexus Core 0.0.2-beta — native framework, geen QB/Qbox.*
