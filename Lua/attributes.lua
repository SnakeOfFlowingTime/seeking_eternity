function Seeking_eternity.apply_realm_stats(player, realm)
    local stats = Seeking_eternity.realm_stats[realm]

    player:set_properties({hp_max = stats.max_hp})
    player:set_physics_override({speed = stats.speed})
    Seeking_eternity.update_hp(player)
end