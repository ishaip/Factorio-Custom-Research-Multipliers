# Custom Research Multipliers

> **Fork of [Research Multipliers](https://mods.factorio.com/mod/research-multipliers) by Xevion.**

Fully customizable research cost multipliers for Factorio 2.0. Adjust cycle counts with global and infinite category multipliers, or fine-tune individual science pack costs per cycle. Works with science packs from **any** mod — base game, Space Age, Space Exploration, Krastorio 2, or anything else. Science packs are detected automatically from the technology tree.

## How it works

The mod has **two types of multipliers** that work independently:

### Category multipliers — change research cycle count

These multiply the total number of research cycles. They accept decimal values.

| Setting | Value | Effect on a 100-cycle tech |
|---|---|---|
| Global | 7 | `ceil(100 × 7)` = **700 cycles** (harder) |
| Global | 1.0 | 100 cycles (no change) |
| Global | 0.7 | `ceil(100 × 0.7)` = **70 cycles** (easier) |

Available category multipliers:
- **Global** — affects all technologies
- **Infinite** — affects infinite research (formula-based technologies)

Category multipliers stack multiplicatively. For example, Global=2 and Infinite=3 on infinite research → `ceil(count × 2 × 3)` = `ceil(count × 6)` = 6× harder.

### Per-pack multipliers — change packs per cycle

These multiply how many of a specific science pack are consumed per research cycle.

| Setting | Value | Effect |
|---|---|---|
| Logistic | 2 | Each cycle costs **2** logistic packs instead of 1 |
| Chemical | 7 | Each cycle costs **7** chemical packs instead of 1 |

So a tech with 100 cycles, logistic=2, chemical=7 would cost:
- **200** logistic packs total (100 × 2)
- **700** chemical packs total (100 × 7)
- Other packs stay at 100 total (100 × 1)

Per-pack amounts are capped at 65535 (Factorio engine limit) and rounded up to at least 1.

## Supported mods

Science packs with dedicated multiplier settings:
- **Base game** — Automation, Logistic, Military, Chemical, Production, Utility, Space
- **Space Age** — Metallurgic, Electromagnetic, Agricultural, Cryogenic, Promethium
- **Space Exploration** — Rocket, Astronomic, Biological, Energy, Material, Deep Space (all tiers)
- **Krastorio 2** — Optimization Tech, Singularity Tech

Packs from **any other mod** still receive category multipliers (global, infinite) automatically.

## Installation

1. Drop the zip into `%appdata%\Factorio\mods` or install via the in-game mod portal.
2. Open **Settings → Startup**. Multiplier settings appear for every detected science pack.
3. Adjust values and restart the game.

## Adding support for a new mod

Edit `pack-definitions.lua` and add an entry to the `known_mods` table:

```lua
{
    mod_id = "your-mod-internal-name",
    pack_groups = {
        { setting = "your-science-multiplier", packs = { "your-science-pack" } },
    },
},
```

Then add locale strings in `locale/en/locale.cfg` under `[mod-setting-name]` and `[mod-setting-description]`.

## Categories

- **Global** — applies to all technologies.
- **Infinite** — all formula-based infinite research (excludes finite-level upgrades like inserter capacity 1-6).
