# Custom Research Multipliers

> **Fork of [Research Multipliers](https://mods.factorio.com/mod/research-multipliers) by Xevion.**

Take full control of your research costs in Factorio 2.0. Multiply cycle counts, scale individual science pack costs, or both — it's all up to you. Science packs from **any mod** are detected automatically.

---

## 🔬 Two Multiplier Systems

### Category Multipliers — Scale Research Cycles

Multiply the total number of cycles a technology requires. Affects the **cycle count** directly.

| Multiplier | Value | A 100-cycle tech becomes… |
|:---|:---:|:---|
| **Global** | `7` | `ceil(100 × 7)` = **700 cycles** — 7× harder |
| **Global** | `1` | **100 cycles** — no change |
| **Global** | `0.7` | `ceil(100 × 0.7)` = **70 cycles** — 30% easier |

| Category | Applies to |
|:---|:---|
| **Global** | All technologies |
| **Infinite** | Formula-based infinite research only |

Category multipliers **stack multiplicatively**. Global=2 + Infinite=3 on infinite research → `ceil(count × 6)` = **6× the cycles**.

---

### Per-Pack Multipliers — Scale Packs Per Cycle

Multiply how many of a specific science pack are consumed **per research cycle**.

Example — a tech with 100 cycles at default 1 pack per cycle:

| Pack | Multiplier | Per cycle | Total cost |
|:---|:---:|:---:|:---|
| [item=automation-science-pack] Automation | `1` | 1 | **100** packs |
| [item=logistic-science-pack] Logistic | `2` | 2 | **200** packs |
| [item=chemical-science-pack] Chemical | `7` | 7 | **700** packs |
| [item=military-science-pack] Military | `0.5` | 1 *(min 1)* | **100** packs |

Per-pack amounts are rounded up (minimum 1) and capped at **65,535** per the Factorio engine limit.

---

## 🧪 Supported Science Packs

Every pack listed below gets its own dedicated multiplier setting in **Settings → Startup**.

### Base Game
| | Pack | Setting |
|:---|:---|:---|
| [item=automation-science-pack] | Automation Science | `automation-science-multiplier` |
| [item=logistic-science-pack] | Logistic Science | `logistic-science-multiplier` |
| [item=military-science-pack] | Military Science | `military-science-multiplier` |
| [item=chemical-science-pack] | Chemical Science | `chemical-science-multiplier` |
| [item=production-science-pack] | Production Science | `production-science-multiplier` |
| [item=utility-science-pack] | Utility Science | `utility-science-multiplier` |
| [item=space-science-pack] | Space Science | `space-science-multiplier` |

### Space Age
| | Pack | Setting |
|:---|:---|:---|
| [item=metallurgic-science-pack] | Metallurgic Science | `metallurgic-science-multiplier` |
| [item=electromagnetic-science-pack] | Electromagnetic Science | `electromagnetic-science-multiplier` |
| [item=agricultural-science-pack] | Agricultural Science | `agricultural-science-multiplier` |
| [item=cryogenic-science-pack] | Cryogenic Science | `cryogenic-science-multiplier` |
| [item=promethium-science-pack] | Promethium Science | `promethium-science-multiplier` |

### Space Exploration
| | Pack | Setting |
|:---|:---|:---|
| [item=se-rocket-science-pack] | Rocket Science | `se-rocket-science-multiplier` |
| [item=se-astronomic-science-pack-1] | Astronomic Science (all tiers) | `se-astronomic-science-multiplier` |
| [item=se-biological-science-pack-1] | Biological Science (all tiers) | `se-biological-science-multiplier` |
| [item=se-energy-science-pack-1] | Energy Science (all tiers) | `se-energy-science-multiplier` |
| [item=se-material-science-pack-1] | Material Science (all tiers) | `se-material-science-multiplier` |
| [item=se-deep-space-science-pack-1] | Deep Space Science (all tiers) | `se-deep-space-science-multiplier` |

### Krastorio 2
| | Pack | Setting |
|:---|:---|:---|
| [item=kr-optimization-tech-card] | Optimization Tech Card | `kr-optimization-tech-multiplier` |
| [item=kr-singularity-tech-card] | Singularity Tech Card | `kr-singularity-tech-multiplier` |

> **Other mods?** Packs from any mod are still affected by **category multipliers** (global, infinite) automatically — no configuration needed. To add dedicated per-pack settings, see *Adding support for a new mod* below.

---

## 📦 Installation

1. Download from the [mod portal](https://mods.factorio.com) or drop the zip into your Factorio mods folder.
2. Launch Factorio → **Settings → Startup**.
3. Adjust multipliers for each science pack and category.
4. Restart the game — changes apply at load time.

---

## 🔧 Adding Support for a New Mod

Edit `pack-definitions.lua` and add an entry to the `known_mods` table:

```lua
{
    mod_id = "your-mod-internal-name",
    pack_groups = {
        { setting = "your-science-multiplier", packs = { "your-science-pack" } },
    },
},
```

Then add locale strings in `locale/en/locale.cfg`:

```ini
[mod-setting-name]
your-science-multiplier=[item=your-science-pack] Your Science Multiplier

[mod-setting-description]
your-science-multiplier=Multiplies [item=your-science-pack] Your packs per cycle.
```

---

## 📜 Credits

Forked from [Research Multipliers](https://mods.factorio.com/mod/research-multipliers) by **Xevion**.
