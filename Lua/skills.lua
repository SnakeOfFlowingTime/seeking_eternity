-- keeps track of GUI checkbox being enabled or not
Seeking_eternity.flying_enabled = {}

-- flight skill 
function Seeking_eternity.true_flight_skill(player)
    local name = player:get_player_name()
    local pmeta = player:get_meta()
    local privs = core.get_player_privs(name)
    local pos = player:get_pos()
    local node_below = core.get_node_or_nil({x = pos.x, y = pos.y - 0.2, z = pos.z})
    local controls = player:get_player_control()
    local velocity = player:get_velocity()

    -- checks if player is airborne
    local is_airborn = true
    if node_below and node_below.name ~= "air" then
        is_airborn = false
    end
    
    local flying = false
    -- passes the GUI information to the function
    local flying_enabled = (Seeking_eternity.flying_enabled[name] == true)

    -- removes flight privilege if GUI checkbox isn't checked
    if not flying_enabled then
        if privs.fly then
            privs.fly = nil
            core.set_player_privs(name, privs)
            player:set_physics_override({speed = Seeking_eternity.realm_stats[pmeta:get_string("seeking_eternity:cultivation_realm")].speed})
            return false
        end
        return false
    end

    -- gives flight privilege if GUI checkbox is checked
    if not privs.fly and flying_enabled then
        privs.fly = true
        core.set_player_privs(name, privs)
    end

    -- applies flight consumption 
    if privs.fly and is_airborn and velocity.y >= -1.0 and flying_enabled then
        flying = true
        local current = pmeta:get_int("seeking_eternity:current_spiritual_power")
        local drain = Seeking_eternity.passive_skills_stats["True Flight"].consumption
        
        -- for fast flight
        if privs.fly and controls.aux1 then
            player:set_physics_override({speed = Seeking_eternity.realm_stats[pmeta:get_string("seeking_eternity:cultivation_realm")].speed * 2})
            drain = (Seeking_eternity.passive_skills_stats["True Flight"].consumption * 2)
        else
            player:set_physics_override({speed = Seeking_eternity.realm_stats[pmeta:get_string("seeking_eternity:cultivation_realm")].speed})
        end

        -- actual consumption being applied
        local new_current = math.max(0, current - drain)
        Seeking_eternity.update_spiritual_power(player, new_current)

        -- disables flight if player is out of spiritual power
        if new_current <= 0 then
            privs.fly = nil
            core.set_player_privs(name, privs)
            player:set_physics_override({speed = Seeking_eternity.realm_stats[pmeta:get_string("seeking_eternity:cultivation_realm")].speed})
            flying = false
            return flying
        end
    else
        -- back to the ground
        if not is_airborn then
            player:set_physics_override({speed = Seeking_eternity.realm_stats[pmeta:get_string("seeking_eternity:cultivation_realm")].speed})
            flying = false
            return flying
        end
    end
    return flying
end