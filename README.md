# lcky-auction

**Standalone FiveM Auction System**

Immersive, optimized, and simple in-game auction experience.

---

## 📋 Features

- ✅ Framework Independent (No ESX/QB-Core)
- ✅ ox_lib Required
- ✅ RAM-Based (No database)
- ✅ Event-Driven (No global loops)
- ✅ Zone-Based (lib.points)
- ✅ 3-Stage Host Control

---

## 🚀 Installation

1. Place in your `resources` folder
2. Ensure `ox_lib` is installed
3. Add `ensure lcky-auction` to server.cfg
4. Start server

---

## 📁 Structure

```
lcky-auction/
├── fxmanifest.lua
├── shared/
│   ├── config.lua
│   └── utils.lua
├── client/
│   ├── main.lua
│   ├── zone.lua
│   ├── ui.lua
│   ├── animation.lua
│   └── keybinds.lua
└── server/
    ├── main.lua
    └── auction.lua
```

---

## 🎮 Usage

### Create Auction
- `/auction` command → fill input dialog

### Join Auction
- Enter zone → press **X**

### Place Bid
- After joining → press **X** → enter amount

### Host Controls
| Key | Action |
|-----|--------|
| F5 | Going Once |
| F6 | Going Twice |
| F7 | SOLD |

---

## ⚙️ Config

Edit `shared/config.lua`:

```lua
Config.Zone.radius = 50.0
Config.Keybinds.joinBid.defaultKey = 'X'
Config.Defaults.defaultDuration = 120
```

---

## ⚡ Optimization

- No `while true` loops
- lib.points internal tick
- TextUI updates only on time change
- Zone-only broadcast

---

## Requirements

- FiveM Server (5181+)
- ox_lib
