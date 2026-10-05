-- applies stats, from realm, physique and bloodline despite the function name
function Seeking_eternity.apply_realm_stats(player, realm)
    local pmeta = player:get_meta()
    local physique = pmeta:get_string("seeking_eternity:physique")
    local bloodline = pmeta:get_string("seeking_eternity:bloodline")

    local hp_modifier = Seeking_eternity.physique_stats[physique].hp_modifier *
    Seeking_eternity.bloodline_stats[bloodline].hp_modifier

    local speed_modifier = Seeking_eternity.physique_stats[physique].speed_modifier *
    Seeking_eternity.bloodline_stats[bloodline].speed_modifier

    local max_sp_modifier = Seeking_eternity.physique_stats[physique].max_sp_modifier *
    Seeking_eternity.bloodline_stats[bloodline].max_sp_modifier

    local stats = Seeking_eternity.realm_stats[realm]
    local max_sp = stats.max_spiritual_power * max_sp_modifier
    pmeta:set_int("seeking_eternity:max_spiritual_power", max_sp)

    player:set_properties({hp_max = stats.max_hp * hp_modifier})

    player:set_physics_override({speed = stats.speed * speed_modifier})

    Seeking_eternity.update_hp(player)
end