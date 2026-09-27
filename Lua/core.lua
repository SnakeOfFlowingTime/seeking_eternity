function Seeking_eternity.get_next_realm(current_realm)
    for i, realm in ipairs(Seeking_eternity.realm_sequence) do
        if realm == current_realm then
            return Seeking_eternity.realm_sequence[i + 1]
        end
    end
    return nil
end

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

function Seeking_eternity.increase_progress(player, amount)
    local name = player:get_player_name()
    local pmeta = player:get_meta()
    local current_progress = pmeta:get_int("seeking_eternity:current_progress")
    local current_realm = pmeta:get_string("seeking_eternity:cultivation_realm")
    local new_progress = current_progress + amount

    pmeta:set_int("seeking_eternity:current_progress", new_progress)
    Seeking_eternity.progress[name].current_progress = new_progress
    player:hud_change(Seeking_eternity.progress[name].progress_hud, "text",
    string.format("Foundation: %d/%d", pmeta:get_int("seeking_eternity:current_progress"), Seeking_eternity.realm_values[current_realm]))
end

core.register_on_joinplayer(function(player)
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
    if current_progress == 0 then
        pmeta:set_int("seeking_eternity:current_progress", 0)
    end
    if cultivation_realm == "" then
        cultivation_realm = "Mortal"
        pmeta:set_string("seeking_eternity:cultivation_realm", "Mortal")
    end
    local max_progress = Seeking_eternity.realm_values[pmeta:get_string("seeking_eternity:cultivation_realm")]
    local current_progress = pmeta:get_int("seeking_eternity:current_progress")
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
    Seeking_eternity.apply_realm_stats(player, cultivation_realm)
end)

core.register_on_leaveplayer(function(player)
    local name = player:get_player_name()
    Seeking_eternity.hp[name] = nil
end)

core.register_on_player_hpchange(function(player, hp_change, reason)
    core.after(0, function()
        if player:is_player() then
            Seeking_eternity.update_hp(player)
        end
    end)
    return hp_change
end, pcall)