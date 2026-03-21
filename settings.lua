local pack_config = require("pack-definitions")
local active_pack_settings = pack_config.get_active_settings()

-- Category multipliers (always available)
local category_settings = {
    "global-multiplier",
    "infinite-research-multiplier",
}

-- helper function for acquiring a stable ordering string
function get_order(value)
    local result = ""
    if value >= 26 then
        for _ = 1, (value / 26) do
            result = result .. string.char(97 + 26 - 1)
        end
        value = value % 26
    end
    result = result .. string.char(97 + value - 1)
    return result
end

local all_settings = {}

-- Category settings (global, infinite)
for index, setting_name in pairs(category_settings) do
    table.insert(all_settings, {
        type = "double-setting",
        name = setting_name,
        setting_type = "startup",
        order = get_order(index),
        minimum_value = 0.000000000001,
        default_value = 1.0,
    })
end

-- Per-pack settings (dynamically generated from detected mods)
for index, setting_name in pairs(active_pack_settings) do
    table.insert(all_settings, {
        type = "double-setting",
        name = setting_name,
        setting_type = "startup",
        order = get_order(index + #category_settings),
        minimum_value = 0.000000000001,
        default_value = 1.0,
    })
end

data:extend(all_settings)