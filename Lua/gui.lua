-- breakthrough gui
function Seeking_eternity.breakthrough_gui(player)
    local name = player:get_player_name()
    local pmeta = player:get_meta()
    local current_realm = pmeta:get_string("seeking_eternity:cultivation_realm")
    local current_progress = tonumber(pmeta:get_string("seeking_eternity:current_progress"))
    local max_progress = Seeking_eternity.realm_values[current_realm]
    local next_realm = Seeking_eternity.get_next_realm(current_realm)
    
    -- checks if player meets conditions
    local can_breakthrough = Seeking_eternity.progress_calculator(player, current_realm)

    local formspec = "size[12,9]" ..
        "real_coordinates[true]" ..
        "label[0.5,0.5;Cultivation Status]" ..
        "label[0.5,1.2;Current Realm: " .. current_realm .. "]" ..
        "label[0.5,1.8;Progress: " .. current_progress .. " / " .. max_progress .. "]"

    if next_realm then
        formspec = formspec .. "label[0.5,2.4;Next Realm: " .. next_realm .. "]"
        if can_breakthrough then
            formspec = formspec .. "button[1.5,3.2;3,0.8;btn_breakthrough; BREAKTHROUGH ]"
        else
            formspec = formspec .. "button[1.5,3.2;3,0.8;btn_disabled; Lacking Foundation ]"
        end
    else
        formspec = formspec .. "label[0.5,2.4;You have attained the ultimate realm!]"
    end
    core.show_formspec(name, "seeking_eternity:breakthrough_menu", formspec)
end

-- physique GUI
function Seeking_eternity.physique_gui(player)
    local name = player:get_player_name()
    local pmeta = player:get_meta()
    local physique = pmeta:get_string("seeking_eternity:physique")
    local hp_modifier = Seeking_eternity.physique_stats[physique].hp_modifier
    local speed_modifier = Seeking_eternity.physique_stats[physique].speed_modifier
    local sp_modifier = Seeking_eternity.physique_stats[physique].max_sp_modifier
    local sp_regen_modifier = Seeking_eternity.physique_stats[physique].sp_regen_modifier

    local formspec = "size[12,9]" ..
        "real_coordinates[true]" ..
        "label[0.5,0.5;Physique: ".. physique .. "]" ..
        "label[0.5,1.2;Health Modifier: " .. hp_modifier .. "]" ..
        "label[0.5,1.8;Speed Modifier: " .. speed_modifier .. "]" ..
        "label[0.5,2.4;Spiritual Power Modifier: " .. sp_modifier .. "]" ..
        "label[0.5,3;Spiritual Power Regeneration Modifier: " .. sp_regen_modifier .. "]"
    
    core.show_formspec(name, "seeking_eternity:physique_menu", formspec)
end

-- bloodline GUI
function Seeking_eternity.bloodline_gui(player)
    local name = player:get_player_name()
    local pmeta = player:get_meta()
    local bloodline = pmeta:get_string("seeking_eternity:bloodline")
    local hp_modifier = Seeking_eternity.bloodline_stats[bloodline].hp_modifier
    local speed_modifier = Seeking_eternity.bloodline_stats[bloodline].speed_modifier
    local sp_modifier = Seeking_eternity.bloodline_stats[bloodline].max_sp_modifier
    local sp_regen_modifier = Seeking_eternity.bloodline_stats[bloodline].sp_regen_modifier

    local formspec = "size[12,9]" ..
        "real_coordinates[true]" ..
        "label[0.5,0.5;Bloodline: ".. bloodline .. "]" ..
        "label[0.5,1.2;Health Modifier: " .. hp_modifier .. "]" ..
        "label[0.5,1.8;Speed Modifier: " .. speed_modifier .. "]" ..
        "label[0.5,2.4;Spiritual Power Modifier: " .. sp_modifier .. "]" ..
        "label[0.5,3;Spiritual Power Regeneration Modifier: " .. sp_regen_modifier .. "]"
    
    core.show_formspec(name, "seeking_eternity:bloodline_menu", formspec)
end

-- technique GUI
function Seeking_eternity.technique_gui(player)
    local name = player:get_player_name()
    local pmeta = player:get_meta()
    local current_technique = pmeta:get_string("seeking_eternity:current_technique")
    local unlocked_techniques = core.deserialize(pmeta:get_string("seeking_eternity:unlocked_techniques"))
    local techniques = table.concat(unlocked_techniques, ",")
    local selected_index = 1

    -- gets current technique index
    for i, tech in ipairs(unlocked_techniques) do
        if tech == current_technique then
            selected_index = i
            break
        end
    end

    local formspec = "size[6,4.5]" ..
        "real_coordinates[true]" ..
        "label[0.5,0.5;Techniques]" ..
        "label[0.5,1.2;Current Technique: " .. current_technique .. "]" ..
        "label[0.5,1.6;Unlocked Techniques: ]" ..
        "dropdown[0.5,1.8;5.0,0.8;unlocked_techniques_dropdown;" .. techniques .. ";" .. selected_index .. ";false]"

    core.show_formspec(name, "seeking_eternity:technique_menu", formspec)
end

-- cultivation GUI
function Seeking_eternity.cultivation_gui(player)
    local name = player:get_player_name()
    local formspec = "size[6,4.5]" ..
        "real_coordinates[true]" ..
        "label[0.5,0.5;Cultivate]"

    -- checks if player is cultivating
    if not Seeking_eternity.cultivating[name] then
        formspec = formspec .. "button[1.5,3.2;3,0.8;btn_cultivate; Cultivate ]"
    else
        formspec = formspec .. "button[1.5,3.2;3,0.8;btn_stop_cultivate; Stop Cultivating ]"
    end
    core.show_formspec(name, "seeking_eternity:cultivation_menu", formspec)
end

-- passive GUI
function Seeking_eternity.passive_skill_gui(player)
    local name = player:get_player_name()
    local pmeta = player:get_meta()
    local realm = pmeta:get_string("seeking_eternity:cultivation_realm")
    local realm_index = 1
    for i, n in ipairs(Seeking_eternity.realm_sequence) do
        if realm == n then
            realm_index = i
        end
    end

    -- verifies if flight is enabled
    local is_enabled = "false"
    if Seeking_eternity.flying_enabled[name] == true then
        is_enabled = "true"
    end
    local formspec = "size[12,9]" ..
        "real_coordinates[true]"
    if realm_index > 1 then
        formspec = formspec .. "checkbox[0.5,1.2;toggle_flight;Enable Flight;" .. is_enabled .. "]"
    end
    local speed_boost_enabled = "false"
    if Seeking_eternity.speed_boost_enabled[name] == true then
        speed_boost_enabled = "true"
    end
    if realm_index >= 6 then
        formspec = formspec .. "checkbox[0.5,1.8;toggle_speed_boost;Enable Speed Boost;" .. speed_boost_enabled .. "]"
    end
    core.show_formspec(name, "seeking_eternity:passive_skill_menu", formspec)
end

-- passive GUI backend
core.register_on_player_receive_fields(function(player, formname, fields)
    if formname ~= "seeking_eternity:passive_skill_menu" then return end
    local name = player:get_player_name()

    if fields.toggle_flight ~= nil then
        Seeking_eternity.flying_enabled[name] = (fields.toggle_flight == "true")
        Seeking_eternity.passive_skill_gui(player)
    end

    if fields.toggle_speed_boost ~= nil then
        Seeking_eternity.speed_boost_enabled[name] = (fields.toggle_speed_boost == "true")
        Seeking_eternity.passive_skill_gui(player)
    end
end)

-- cultivation GUI backend
core.register_on_player_receive_fields(function(player, formname, fields)
    if formname ~= "seeking_eternity:cultivation_menu" then return end
    local name = player:get_player_name()

    if fields.btn_cultivate then
        Seeking_eternity.cultivating[name] = true
        Seeking_eternity.cultivation_gui(player)
    end
    if fields.btn_stop_cultivate then
        Seeking_eternity.cultivating[name] = false
        Seeking_eternity.cultivation_gui(player)
    end
    
end)

-- technique GUI backend
core.register_on_player_receive_fields(function(player, formname, fields)
    if formname ~= "seeking_eternity:technique_menu" then return end

    if fields.unlocked_techniques_dropdown then
        Seeking_eternity.update_current_technique(player, fields.unlocked_techniques_dropdown)
        Seeking_eternity.technique_gui(player)
    end
   
end)

-- breakthrough GUI backend
core.register_on_player_receive_fields(function(player, formname, fields)
    if formname ~= "seeking_eternity:breakthrough_menu" then return false end

    if fields.btn_breakthrough then
        Seeking_eternity.update_cultivation_realm(player)
        Seeking_eternity.breakthrough_gui(player)
    return true
    end
end)

-- chat command to open physique menu
core.register_chatcommand("physique", {
    description = "Opens the physique menu",
    func = function(name)
        local player = core.get_player_by_name(name)
        if player then
            Seeking_eternity.physique_gui(player)
            return true
        end
    end
})

-- chat command to open bloodline menu
core.register_chatcommand("bloodline", {
    description = "Opens the bloodline menu",
    func = function(name)
        local player = core.get_player_by_name(name)
        if player then
            Seeking_eternity.bloodline_gui(player)
            return true
        end
    end
})

-- chat command to open passive menu
core.register_chatcommand("passive", {
    description = "Opens the passive skill menu",
    func = function(name)
        local player = core.get_player_by_name(name)
        if player then
            Seeking_eternity.passive_skill_gui(player)
            return true
        end
    end
})

-- chat command to open cultivation menu
core.register_chatcommand("cultivate", {
    description = "Opens the cultivation menu",
    func = function(name)
        local player = core.get_player_by_name(name)
        if player then
            Seeking_eternity.cultivation_gui(player)
            return true
        end
    end
})

-- chat command to open technique menu
core.register_chatcommand("technique", {
    description = "Opens the technique selection menu",
    func = function(name)
        local player = core.get_player_by_name(name)
        if player then
            Seeking_eternity.technique_gui(player)
            return true
        end
    end
})

-- chat command to open breakthrough menu
core.register_chatcommand("breakthrough", {
    description = "Opens the breakthrough menu",
    func = function(name)
        local player = core.get_player_by_name(name)
        if player then
            Seeking_eternity.breakthrough_gui(player)
            return true
        end
    end
})