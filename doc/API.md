# SpaceUI Library API Reference

SpaceUI Library is a Roblox executor UI library split into `src/` modules with a bundled `dist/SpaceUI.lua` for one-file loading.

## Loading

### Bundled executor load

```lua
local SpaceUI = loadstring(readfile("dist/SpaceUI.lua"))()
```

### Source-tree executor load

```lua
local SpaceUI = loadstring(readfile("src/init.lua"))()
```

If loading source modules remotely, set `getgenv().SpaceUI.BaseUrl` before running `src/init.lua`.

## Topbar Plus toggle

`SpaceUI.Main.Load(file)` creates a right-aligned Topbar Plus icon labeled `SpaceUI`. Selecting the icon opens the main SpaceUI window; deselecting it hides the window. You can override the Topbar Plus raw root before loading with:

```lua
getgenv().SpaceUI = getgenv().SpaceUI or {}
getgenv().SpaceUI.TopbarPlusUrl = "https://raw.githubusercontent.com/Therealtobu/Topbar-Plus-For-Executor/main/"
```

## Global state

The library initializes `getgenv().SpaceUI` with UI config, game config, page/tab state, notification state, and cleanup connections.

## Main API

### `SpaceUI.Main.Load(file)`
Creates the background, dashboard, settings page, notifications, array list, and loads the requested game script/config.

### `SpaceUI.Main.ToggleVisibility(visible)`
Shows or hides the main UI. If `visible` is nil, callers can toggle using the configured keybind.

### `SpaceUI.Main.Uninject()`
Disconnects tracked connections, destroys created UI objects, and fires `SpaceUI.Main.OnUninject`.

## Pages and tabs

### `SpaceUI.Pages.Init()`
Initializes the page selector UI.

### `SpaceUI.Pages.NewPage(data)`
Creates a new page. Common fields include `Name`, `Icon`, and page display options.

### `SpaceUI.Dashboard.NewTab(data)`
Creates a dashboard tab. Tab objects expose module/section/widget creation helpers.

## Components

- `SpaceUI.MainBackground.Init()` creates the main window, drag controls, scale controls, and mobile button helpers.
- `SpaceUI.Notifications.Send(data)` displays a notification. `data.Description`, `data.Duration`, and `data.Flag` are supported.
- `SpaceUI.ArrayList.Init()` creates the module array-list overlay.
- `SpaceUI.SettingsPage.Init(settings)` creates the settings UI.

## Core helpers

- `SpaceUI.Functions.GetGameInfo()` fetches Roblox game metadata for the current universe.
- `SpaceUI.Functions.LoadFile(file, url)` loads local dev files or remote files.
- `SpaceUI.Functions.IsAlive(player)` checks character health/root part state.
- `SpaceUI.Functions.GetModule(name)` returns a registered module by name.
- `SpaceUI.Functions.GetAllModules()` returns registered modules.
- `SpaceUI.Config.Save(file, data)` writes `SpaceUI/Config/<file>.json`.
- `SpaceUI.Config.Load(file, set)` reads config and optionally applies it.

## Directory layout

```text
SpaceUI/
├── src/
│   ├── init.lua
│   ├── Core/
│   ├── Components/
│   ├── Widgets/
│   └── Settings/
├── dist/SpaceUI.lua
└── doc/API.md
```
