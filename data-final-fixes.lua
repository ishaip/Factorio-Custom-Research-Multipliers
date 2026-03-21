local pack_config = require("pack-definitions")

-- Read category multipliers from settings
local global_multiplier = settings.startup["global-multiplier"].value
local infinite_research_multiplier = settings.startup["infinite-research-multiplier"].value

-- Build pack -> setting name map from pack-definitions (covers known mods)
local pack_to_setting = pack_config.get_pack_to_setting_map()

-- Read per-pack multiplier values from settings, keyed by setting name
local science_pack_multipliers = {}
for pack_name, setting_name in pairs(pack_to_setting) do
    if science_pack_multipliers[setting_name] == nil then
        local ok, setting = pcall(function() return settings.startup[setting_name] end)
        if ok and setting then
            science_pack_multipliers[setting_name] = setting.value
        else
            science_pack_multipliers[setting_name] = 1.0
        end
    end
end

-- Discover ALL unique science packs used across all technologies (generic scan)
local discovered_packs = {}
for _, technology in pairs(data.raw.technology) do
    if technology.unit and technology.unit.ingredients then
        for _, ingredient in pairs(technology.unit.ingredients) do
            local pack_name = ingredient[1] or ingredient.name
            if pack_name then
                discovered_packs[pack_name] = true
            end
        end
    end
end

log("Discovered " .. table_size(discovered_packs) .. " unique science packs across all technologies:")
for pack_name, _ in pairs(discovered_packs) do
    local mapped = pack_to_setting[pack_name] and (" -> " .. pack_to_setting[pack_name]) or " (no per-pack setting)"
    log("  " .. pack_name .. mapped)
end

function is_infinite_research(name)
    local tech = data.raw.technology[name]
    return tech and tech.unit and tech.unit.count == nil
end

function calculate(name, technology)
    -- Skip trigger-based technologies or those without proper unit definitions
    if technology.research_trigger ~= nil then
        return
    elseif technology.unit == nil or technology.unit.ingredients == nil then
        log("Skipping technology \"" .. name .. "\": no unit or ingredients defined.")
        return
    end

    -- =========================================================================
    -- Phase 1: Category multipliers modify TOTAL RESEARCH COUNT (cycles)
    --          Formula: ceil(count * multiplier)
    --          multiplier > 1 = more expensive, multiplier < 1 = cheaper
    -- =========================================================================
    local count_multiplier = 1.0

    if global_multiplier ~= 1 then
        count_multiplier = count_multiplier * global_multiplier
    end

    if infinite_research_multiplier ~= 1 and is_infinite_research(name) then
        count_multiplier = count_multiplier * infinite_research_multiplier
    end

    -- Apply category multiplier to research count
    if count_multiplier ~= 1.0 and count_multiplier > 0 then
        if technology.unit.count_formula then
            -- Formula-based (infinite research)
            technology.unit.count_formula = 'max(1, (' .. technology.unit.count_formula .. ')*' .. count_multiplier .. ')'
            log(name .. " : formula adjusted by x" .. count_multiplier)
        elseif technology.unit.count then
            local original_count = technology.unit.count
            technology.unit.count = math.max(math.ceil(original_count * count_multiplier), 1)
            log(name .. " : count " .. original_count .. " -> " .. technology.unit.count .. " (x" .. count_multiplier .. ")")
        end
    end

    -- =========================================================================
    -- Phase 2: Per-pack multipliers modify PACKS PER CYCLE (ingredient amounts)
    --          Formula: ceil(amount * multiplier), capped at 65535
    -- =========================================================================
    local any_ingredient_changed = false
    for _, ingredient in pairs(technology.unit.ingredients) do
        local pack_name = ingredient[1] or ingredient.name
        local original_amount = ingredient[2] or ingredient.amount or 1

        local ingredient_multiplier = 1.0

        -- Look up per-pack multiplier for this specific pack
        if pack_name then
            local setting_name = pack_to_setting[pack_name]
            if setting_name then
                local pack_multiplier = science_pack_multipliers[setting_name]
                if pack_multiplier and pack_multiplier ~= 1.0 then
                    ingredient_multiplier = pack_multiplier
                end
            end
        end

        -- Apply per-pack multiplier to ingredient amount
        if ingredient_multiplier ~= 1 and ingredient_multiplier > 0 then
            -- Factorio caps ingredient amounts at uint16 (65535)
            local new_amount = math.min(math.max(math.ceil(original_amount * ingredient_multiplier), 1), 65535)

            -- Update both array-style [2] and named .amount for compatibility
            if ingredient[2] then
                ingredient[2] = new_amount
            end
            if ingredient.amount then
                ingredient.amount = new_amount
            end
            if not ingredient[2] and not ingredient.amount then
                ingredient[2] = new_amount
            end

            any_ingredient_changed = true
            log(name .. " : " .. (pack_name or "?") .. " " .. original_amount .. " -> " .. new_amount .. " (x" .. ingredient_multiplier .. ")")
        end
    end

    if not any_ingredient_changed and count_multiplier == 1.0 then
        log(name .. " : no changes")
    end
end

-- Process ALL technologies generically
for name, technology in pairs(data.raw.technology) do
    xpcall(calculate, function(err)
        log("Error in technology " .. name .. ": " .. err)
    end, name, technology)
end
