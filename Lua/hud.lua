-- tracking tables
Seeking_eternity.spiritual_power = {}
Seeking_eternity.hp = {}
Seeking_eternity.realm = {}
Seeking_eternity.progress = {}
Seeking_eternity.foundation_gain_modifier = {}

-- spiritual power helper function
function Seeking_eternity.update_spiritual_power(player, new_current)
    local name = player:get_player_name()
    local pmeta = player:get_meta()
    pmeta:set_string("seeking_eternity:current_spiritual_power", tostring(new_current))
    local current = pmeta:get_string("seeking_eternity:current_spiritual_power")
    local max = pmeta:get_string("seeking_eternity:max_spiritual_power")

    Seeking_eternity.spiritual_power[name].current = new_current
    player:hud_change(Seeking_eternity.spiritual_power[name].spiritual_power_hud, "text",
    string.format("Spiritual Power: " .. current .. "/" .. max))
end

-- hp helper function
function Seeking_eternity.update_hp(player)
    local name = player:get_player_name()
    local current_hp = player:get_hp()
    local max_hp = player:get_properties().hp_max

    player:hud_change(Seeking_eternity.hp[name].hp_hud, "text", string.format("HP: %d/%d", current_hp, max_hp))
    
end