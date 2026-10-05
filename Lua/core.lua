-- keeps track of unlocked_techniques
Seeking_eternity.unlocked_techniques = {}
-- keeps track of whether the player is cultivating
Seeking_eternity.cultivating = {}

-- for changing current technique
function Seeking_eternity.update_current_technique(player, new_technique)
    local name = player:get_player_name()
    local pmeta = player:get_meta()
    pmeta:set_string("seeking_eternity:current_technique", new_technique)
    for i, n in pairs(Seeking_eternity.unlocked_techniques[name]) do
        if n == new_technique then
            return
        end
    end
    table.insert(Seeking_eternity.unlocked_techniques[name], new_technique)
    pmeta:set_string("seeking_eternity:unlocked_techniques", core.serialize(Seeking_eternity.unlocked_techniques[name]))
    Seeking_eternity.get_cultivation_modifier(player)
end

function Seeking_eternity.update_current_physique(player, physique)
    local pmeta = player:get_meta()
    local current_realm = pmeta:get_string("seeking_eternity:cultivation_realm")
    pmeta:set_string("seeking_eternity:physique", physique)

    Seeking_eternity.apply_realm_stats(player, current_realm)
end

function Seeking_eternity.update_current_bloodline(player, bloodline)
    local pmeta = player:get_meta()
    local current_realm = pmeta:get_string("seeking_eternity:cultivation_realm")
    pmeta:set_string("seeking_eternity:bloodline", bloodline)

    Seeking_eternity.apply_realm_stats(player, current_realm)
end

-- gets the next realm in sequence
function Seeking_eternity.get_next_realm(current_realm)
    for i, realm in ipairs(Seeking_eternity.realm_sequence) do
        if realm == current_realm then
            return Seeking_eternity.realm_sequence[i + 1]
        end
    end
    return nil
end

-- handles the breakthroughs 
function Seeking_eternity.update_cultivation_realm(player)
    local name = player:get_player_name()
    local pmeta = player:get_meta()
    local current_realm = pmeta:get_string("seeking_eternity:cultivation_realm")
    local next_realm = Seeking_eternity.get_next_realm(current_realm)
    local current_progress = pmeta:get_int("seeking_eternity:current_progress")
    if Seeking_eternity.progress_calculator(player, current_realm) and next_realm then
        pmeta:set_int("seeking_eternity:current_progress", current_progress - Seeking_eternity.realm_values[current_realm])
        pmeta:set_string("seeking_eternity:cultivation_realm", next_realm)

        local stats = Seeking_eternity.realm_stats[next_realm]
        pmeta:set_int("seeking_eternity:max_spiritual_power", stats.max_spiritual_power)
        Seeking_eternity.spiritual_power[name].max_spiritual_power = stats.max_spiritual_power

        Seeking_eternity.realm[name].cultivation_realm = next_realm
        Seeking_eternity.progress[name].current_progress = pmeta:get_int("seeking_eternity:current_progress")
        Seeking_eternity.progress[name].max_progress = Seeking_eternity.realm_values[next_realm]

        player:hud_change(Seeking_eternity.realm[name].realm_hud, "text", next_realm)
        player:hud_change(Seeking_eternity.progress[name].progress_hud, "text",
        string.format("Foundation: %d/%d", pmeta:get_int("seeking_eternity:current_progress"), Seeking_eternity.realm_values[next_realm]))
        player:hud_change(Seeking_eternity.spiritual_power[name].spiritual_power_hud, "text",
        string.format("Spiritual Power: %d/%d", pmeta:get_int("seeking_eternity:current_spiritual_power"), pmeta:get_int("seeking_eternity:max_spiritual_power")))
        Seeking_eternity.apply_realm_stats(player, next_realm)
    end
end

-- checks if foundation is enough to breakthrough
function Seeking_eternity.progress_calculator(player, realm)
    local pmeta = player:get_meta()
    local current_progress = pmeta:get_int("seeking_eternity:current_progress")
    local max_progress = Seeking_eternity.realm_values[realm]
    if current_progress >= max_progress then
        return true
    else
        return false
    end
end

-- handles increasing foundation
function Seeking_eternity.increase_progress(player, amount)
    local name = player:get_player_name()
    local pmeta = player:get_meta()
    local current_progress = pmeta:get_int("seeking_eternity:current_progress")
    local current_realm = pmeta:get_string("seeking_eternity:cultivation_realm")
    local new_progress = current_progress + amount

    pmeta:set_int("seeking_eternity:current_progress", new_progress)
    Seeking_eternity.progress[name].current_progress = new_progress
    
    if Seeking_eternity.progress[name].progress_hud then
        player:hud_change(Seeking_eternity.progress[name].progress_hud, "text",
        string.format("Foundation: %d/%d", pmeta:get_int("seeking_eternity:current_progress"), Seeking_eternity.realm_values[current_realm]))
    end
    
end

-- gets the cultivation modifier
function Seeking_eternity.get_cultivation_modifier(player)
    local name = player:get_player_name()
    local pmeta = player:get_meta()
    local current_technique = pmeta:get_string("seeking_eternity:current_technique")
    local coords = player:get_pos()
    local height = coords.y
    local physique = pmeta:get_string("seeking_eternity:physique")
    local bloodline = pmeta:get_string("seeking_eternity:bloodline")
    local physique_affinity = Seeking_eternity.physique_stats[physique].affinity
    -- these three if statements server to make sure a player doesn't get the max bonus for three nils affinity
    if not physique_affinity then
        physique_affinity = 1
    end
    local bloodline_affinity = Seeking_eternity.bloodline_stats[bloodline].affinity
    if not bloodline_affinity then
        bloodline_affinity = 2
    end
    local technique_affinity = Seeking_eternity.technique_stats[current_technique].affinity
    if not technique_affinity then
        technique_affinity = 3
    end
    if current_technique == "" then
        current_technique = "Basic Breathing"
    end
    local affinity_modifier = 1
    if physique_affinity == bloodline_affinity and bloodline_affinity == technique_affinity then
        affinity_modifier = 4
    elseif physique_affinity == bloodline_affinity or
    physique_affinity == technique_affinity or
    bloodline_affinity == technique_affinity then
        affinity_modifier = 2
    end
    local technique_modifier = Seeking_eternity.technique_stats[current_technique].gain_modifier
    local height_modifier = 1.0 * (math.abs(height) / 100)
    local current_modifier = (1 + height_modifier) * (technique_modifier * affinity_modifier)
    current_modifier = math.round(current_modifier)

    if not Seeking_eternity.foundation_gain_modifier[name] then
        Seeking_eternity.foundation_gain_modifier[name] = {}
    end

    Seeking_eternity.foundation_gain_modifier[name].current_modifier = current_modifier

    if Seeking_eternity.foundation_gain_modifier[name].gain_modifier_hud then
        player:hud_change(Seeking_eternity.foundation_gain_modifier[name].gain_modifier_hud,
        "text", "Cultivation Speed: " .. tostring(current_modifier))
    end
    return current_modifier
end

-- handles players joining
core.register_on_joinplayer(function(player)
    -- disables default health bar to allow custom one
    player:hud_set_flags({
        healthbar = false,
        breathbar = true
    })
    local name = player:get_player_name()
    local pmeta = player:get_meta()
    local current = pmeta:get_int("seeking_eternity:current_spiritual_power")
    local max = pmeta:get_int("seeking_eternity:max_spiritual_power")
    local cultivation_realm = pmeta:get_string("seeking_eternity:cultivation_realm")
    local current_progress = pmeta:get_int("seeking_eternity:current_progress")
    local current_technique = pmeta:get_string("seeking_eternity:current_technique")
    local current_physique = pmeta:get_string("seeking_eternity:physique")
    if current_physique == "" then
        current_physique = "Mortal Physique"
        pmeta:set_string("seeking_eternity:physique", "Mortal Physique")
    end

    local current_bloodline = pmeta:get_string("seeking_eternity:bloodline")
    if current_bloodline == "" then
        current_bloodline = "Human Bloodline"
        pmeta:set_string("seeking_eternity:bloodline", "Human Bloodline")
    end
    local unlocked_techniques = core.deserialize(pmeta:get_string("seeking_eternity:unlocked_techniques"))

    if current_technique == "" then
        current_technique = "Basic Breathing"
        Seeking_eternity.unlocked_techniques[name] = {current_technique}
        Seeking_eternity.update_current_technique(player, current_technique)
    end

    if not unlocked_techniques then
        Seeking_eternity.unlocked_techniques[name] = {current_technique}
        pmeta:set_string("seeking_eternity:unlocked_techniques", core.serialize(Seeking_eternity.unlocked_techniques[name]))
    else
        Seeking_eternity.unlocked_techniques[name] = unlocked_techniques
    end
    
    -- gets current foundation gain modifier
    local current_modifier = Seeking_eternity.get_cultivation_modifier(player)

    if current_progress == 0 then
        pmeta:set_int("seeking_eternity:current_progress", 0)
    end

    if cultivation_realm == "" then
        cultivation_realm = "Mortal"
        pmeta:set_string("seeking_eternity:cultivation_realm", "Mortal")
    end

    local max_progress = Seeking_eternity.realm_values[pmeta:get_string("seeking_eternity:cultivation_realm")]
    current_progress = pmeta:get_int("seeking_eternity:current_progress")
    if max == 0 then
        pmeta:set_int("seeking_eternity:current_spiritual_power", 0)
        pmeta:set_int("seeking_eternity:max_spiritual_power", 0)
    end

    local current_hp = player:get_hp()
    local max_hp = player:get_properties().hp_max

    Seeking_eternity.hp[name] = {
        hp_hud = player:hud_add({
            hud_elem_type = "text",
            position = {x = 0.5, y = 0.95},
            text = string.format("HP: %d/%d", current_hp, max_hp),
            alignment = {x = 0, y = 0},
            offset = {x = -250, y = -50},
            number = 0xFF0000
        })
    }
    Seeking_eternity.spiritual_power[name] = {
        current = pmeta:get_int("seeking_eternity:current_spiritual_power"),
        max = pmeta:get_int("seeking_eternity:max_spiritual_power"),
        spiritual_power_hud = player:hud_add({
            hud_elem_type = "text",
            position = {x = 0.5, y = 1},
            text = string.format("Spiritual Power: %d/%d", current, max),
            alignment = {x = -1, y = -1},
            offset = {x = -250, y = -110},
            number = 0x00C8FF
        })
    }
    Seeking_eternity.realm[name] = {
        cultivation_realm = pmeta:get_string("seeking_eternity:cultivation_realm"),
        realm_hud = player:hud_add({
            hud_elem_type = "text",
            position = {x = 0.5, y = 0.85},
            offset = {x = 0,   y = 0},
            anchor = {x = 0.5, y = 0.5},
            text = cultivation_realm,
            number = 0xFFFFFF,
            scale = {x = 100, y = 20}
        })
    }
    Seeking_eternity.progress[name] = {
        current_progress = pmeta:get_int("seeking_eternity:current_progress"),
        max_progress = max_progress,
        progress_hud = player:hud_add({
            hud_elem_type = "text",
            position = {x = 1, y = 1},
            text = string.format("Foundation: %d/%d", current_progress, max_progress),
            alignment = {x = -1, y = -1},
            offset = {x = -250, y = -110},
            number = 0xFFD700
        })
    }
    Seeking_eternity.foundation_gain_modifier[name] = {
        current_modifier = current_modifier,
        gain_modifier_hud = player:hud_add({
            hud_elem_type = "text",
            position = {x = 0.5, y = 0.80},
            offset = {x = 0,   y = 0},
            anchor = {x = 0.5, y = 0.5},
            text = "Cultivation Speed: " .. current_modifier,
            number = 0xFFFFFF,
            scale = {x = 100, y = 20}
        })
    }
    -- applies realm stats on joining
    Seeking_eternity.apply_realm_stats(player, cultivation_realm)

    -- defaults cultivating to false
    Seeking_eternity.cultivating[name] = false

    -- handles flight check stuff
    local flying_enabled = pmeta:get_string("seeking_eternity:flying_enabled")
    if flying_enabled == "true" then
        Seeking_eternity.flying_enabled[name] = true
    else
        Seeking_eternity.flying_enabled[name] = false
    end
end)

-- handles players leaving
core.register_on_leaveplayer(function(player)
    local name = player:get_player_name()
    local pmeta = player:get_meta()
    if Seeking_eternity.flying_enabled[name] ~= nil then
        pmeta:set_string("seeking_eternity:flying_enabled", tostring(Seeking_eternity.flying_enabled[name]))
    end

    Seeking_eternity.hp[name] = nil
    Seeking_eternity.realm[name] = nil
    Seeking_eternity.spiritual_power[name] = nil
    Seeking_eternity.progress[name] = nil
    Seeking_eternity.foundation_gain_modifier[name] = nil
    Seeking_eternity.flying_enabled[name] = nil
end)

-- custom hp bar stuff
core.register_on_player_hpchange(function(player, hp_change, reason)
    core.after(0, function()
        if player:is_player() then
            Seeking_eternity.update_hp(player)
        end
    end)
    return hp_change
end, pcall)

-- designated first timer
local first_timer = 0

-- handles the second by second stuff like SP regen and flight checks
core.register_globalstep(function(dtime)
    first_timer = first_timer + dtime
    if first_timer < 1.0 then
        return
    end
    first_timer = 0
    for i, player in ipairs(core.get_connected_players()) do
        local name = player:get_player_name()
        local pmeta = player:get_meta()
        local current_realm = pmeta:get_string("seeking_eternity:cultivation_realm")
        if current_realm == "" then current_realm = "Mortal" end

        local current = pmeta:get_int("seeking_eternity:current_spiritual_power")
        local max = pmeta:get_int("seeking_eternity:max_spiritual_power")
        local physique = pmeta:get_string("seeking_eternity:physique")
        local bloodline = pmeta:get_string("seeking_eternity:bloodline")
        local sp_regen_modifier = Seeking_eternity.physique_stats[physique].sp_regen_modifier *
        Seeking_eternity.bloodline_stats[bloodline].sp_regen_modifier

        -- flight skill
        Seeking_eternity.true_flight_skill(player)
        
        -- checks if SP should recharge based on whether the player is cultivating
        if not Seeking_eternity.cultivating[name] then
            if current < max then
            local new_current = math.min(max, current + (Seeking_eternity.realm_stats[current_realm].spiritual_power_regen * sp_regen_modifier))
            Seeking_eternity.update_spiritual_power(player, new_current)
            end
        end

        -- gets foundation gain modifier to update the hud and stuff
        Seeking_eternity.get_cultivation_modifier(player)
    end
end)

-- designated second timer (nothing to say about it)
local second_timer = 0

-- handles the cultivation gain
core.register_globalstep(function(dtime)
    second_timer = second_timer + dtime
    if second_timer < 10.0 then
        return
    end
    second_timer = 0
    for i, player in ipairs(core.get_connected_players()) do
        local name = player:get_player_name()
        if Seeking_eternity.cultivating[name] then
            Seeking_eternity.increase_progress(player, Seeking_eternity.get_cultivation_modifier(player))
        end
    end
end)
