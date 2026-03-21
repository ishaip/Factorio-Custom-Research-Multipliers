-- Shared configuration for known mods and their science packs.
--
-- To add support for a new mod:
--   1. Add an entry to the known_mods table below
--   2. Add locale entries in locale/en/locale.cfg for the setting names
--
-- The data-final-fixes stage scans ALL technologies generically.
-- This file only controls which per-pack settings are created.
-- Packs from unknown mods still receive global/category multipliers.

local M = {}

-- Known mods and their science pack groups.
-- Each group creates one multiplier setting that applies to all packs listed.
-- mod_id = nil means always loaded (base game).
-- mod_id = "name" means only loaded when that mod is active.
M.known_mods = {
    -- Base game (always available)
    {
        mod_id = nil,
        pack_groups = {
            { setting = "automation-science-multiplier", packs = { "automation-science-pack" } },
            { setting = "logistic-science-multiplier", packs = { "logistic-science-pack" } },
            { setting = "military-science-multiplier", packs = { "military-science-pack" } },
            { setting = "chemical-science-multiplier", packs = { "chemical-science-pack" } },
            { setting = "production-science-multiplier", packs = { "production-science-pack" } },
            { setting = "utility-science-multiplier", packs = { "utility-science-pack" } },
            { setting = "space-science-multiplier", packs = { "space-science-pack" } },
        },
    },
    -- Space Age (official DLC)
    {
        mod_id = "space-age",
        pack_groups = {
            { setting = "metallurgic-science-multiplier", packs = { "metallurgic-science-pack" } },
            { setting = "electromagnetic-science-multiplier", packs = { "electromagnetic-science-pack" } },
            { setting = "agricultural-science-multiplier", packs = { "agricultural-science-pack" } },
            { setting = "cryogenic-science-multiplier", packs = { "cryogenic-science-pack" } },
            { setting = "promethium-science-multiplier", packs = { "promethium-science-pack" } },
        },
    },
    -- Space Exploration (pack names may vary for unofficial 2.0 ports; use the custom text setting if needed)
    {
        mod_id = "space-exploration",
        pack_groups = {
            { setting = "se-rocket-science-multiplier", packs = { "se-rocket-science-pack" } },
            { setting = "se-astronomic-science-multiplier", packs = {
                "se-astronomic-science-pack-1", "se-astronomic-science-pack-2",
                "se-astronomic-science-pack-3", "se-astronomic-science-pack-4",
            } },
            { setting = "se-biological-science-multiplier", packs = {
                "se-biological-science-pack-1", "se-biological-science-pack-2",
                "se-biological-science-pack-3", "se-biological-science-pack-4",
            } },
            { setting = "se-energy-science-multiplier", packs = {
                "se-energy-science-pack-1", "se-energy-science-pack-2",
                "se-energy-science-pack-3", "se-energy-science-pack-4",
            } },
            { setting = "se-material-science-multiplier", packs = {
                "se-material-science-pack-1", "se-material-science-pack-2",
                "se-material-science-pack-3", "se-material-science-pack-4",
            } },
            { setting = "se-deep-space-science-multiplier", packs = {
                "se-deep-space-science-pack-1", "se-deep-space-science-pack-2",
                "se-deep-space-science-pack-3", "se-deep-space-science-pack-4",
            } },
        },
    },
    -- Krastorio 2
    {
        mod_id = "Krastorio2",
        pack_groups = {
            { setting = "kr-optimization-tech-multiplier", packs = { "kr-optimization-tech-card" } },
            { setting = "kr-singularity-tech-multiplier", packs = { "kr-singularity-tech-card" } },
        },
    },
}

--- Returns a list of setting names for all detected mods.
function M.get_active_settings()
    local settings_list = {}
    for _, mod_def in pairs(M.known_mods) do
        if mod_def.mod_id == nil or (mods and mods[mod_def.mod_id]) then
            for _, group in pairs(mod_def.pack_groups) do
                table.insert(settings_list, group.setting)
            end
        end
    end
    return settings_list
end

--- Returns a lookup table: pack_name -> setting_name, for all detected mods.
function M.get_pack_to_setting_map()
    local map = {}
    for _, mod_def in pairs(M.known_mods) do
        if mod_def.mod_id == nil or (mods and mods[mod_def.mod_id]) then
            for _, group in pairs(mod_def.pack_groups) do
                for _, pack_name in pairs(group.packs) do
                    map[pack_name] = group.setting
                end
            end
        end
    end
    return map
end

return M
