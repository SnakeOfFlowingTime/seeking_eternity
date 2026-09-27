function Seeking_eternity.cultivation_gui(player)
    local name = player:get_player_name()
    local pmeta = player:get_meta()
    local current_realm = pmeta:get_string("seeking_eternity:cultivation_realm")
    local current_progress = pmeta:get_int("seeking_eternity:current_progress")
    local max_progress = Seeking_eternity.realm_values[current_realm]
    local next_realm = Seeking_eternity.get_next_realm(current_realm)
    
    local can_breakthrough = Seeking_eternity.progress_calculator(player, current_realm)

    local formspec = "size[6,4.5]" ..
        "real_coordinates[true]" ..
        "title[0.5,0.5;Cultivation Status]" ..
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
    core.show_formspec(name, "seeking_eternity:cultivation_menu", formspec)
end

core.register_on_player_receive_fields(function(player, formname, fields)
    if formname ~= "seeking_eternity:cultivation_menu" then return false end

    if fields.btn_breakthrough then
        Seeking_eternity.update_cultivation_realm(player)
        Seeking_eternity.cultivation_gui(player)
    return true
    end
end)

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