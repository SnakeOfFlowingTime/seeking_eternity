-- foundation amount needed to break through to the next realm
Seeking_eternity.realm_values = {
    ["Mortal"] = 250,
    ["Early Stage Qi Refiner"] = 1000,
    ["Middle Stage Qi Refiner"] = 4000,
    ["Late Stage Qi Refiner"] = 16000,
    ["Peak Qi Refiner"] = 1000000
}

-- order of the realms
Seeking_eternity.realm_sequence = {
    "Mortal",
    "Early Stage Qi Refiner",
    "Middle Stage Qi Refiner",
    "Late Stage Qi Refiner",
    "Peak Qi Refiner"
}

-- realm stats, not much to say
Seeking_eternity.realm_stats = {
    ["Mortal"] = {max_hp = 20, speed = 1.0, max_spiritual_power = 0, spiritual_power_regen = 0},
    ["Early Stage Qi Refiner"] = {max_hp = 50, speed = 1.1, max_spiritual_power = 100, spiritual_power_regen = 1},
    ["Middle Stage Qi Refiner"] = {max_hp = 100, speed = 1.2, max_spiritual_power = 400, spiritual_power_regen = 4},
    ["Late Stage Qi Refiner"] = {max_hp = 200, speed = 1.4, max_spiritual_power = 1600, spiritual_power_regen = 16},
    ["Peak Qi Refiner"] = {max_hp = 500, speed = 2, max_spiritual_power = 6400, spiritual_power_regen = 64}
}

-- technique stats, not much to say
Seeking_eternity.technique_stats = {
    ["Basic Breathing"] = {gain_modifier = 1, affinity = nil},
    ["Advanced Breathing"] = {gain_modifier = 2, affinity = nil},
    ["Fire Control Mantra"] = {gain_modifier = 2, affinity = "Fire"},
    ["Spirit Star Chart"] = {gain_modifier = 3, affinity = "Star"},
    ["Final Heaven Method"] = {gain_modifier = 5, affinity = "Heaven"},
    ["Sutra of No Self"] = {gain_modifier = 10, affinity = "Soul"}
}

Seeking_eternity.bloodline_stats = {
    ["Human Bloodline"] = {hp_modifier = 1, speed_modifier = 1, max_sp_modifier = 1, sp_regen_modifier = 1, affinity = nil},
    ["Pseudo-First Tier Fire Fox Bloodline"] = {hp_modifier = 1.5, speed_modifier = 1.4, max_sp_modifier = 1.2, sp_regen_modifier = 1.1, affinity = "Fire"}
}

Seeking_eternity.physique_stats = {
    ["Mortal Physique"] = {hp_modifier = 1, speed_modifier = 1, max_sp_modifier = 1, sp_regen_modifier = 1, affinity = nil},
    ["Iron Bone Body"] = {hp_modifier = 1.2, speed_modifier = 1, max_sp_modifier = 1, sp_regen_modifier = 1, affinity = "Metal"},
    ["Burning Heart Physique"] = {hp_modifier = 1.1, speed_modifier = 1.1, max_sp_modifier = 1, sp_regen_modifier = 1.1, affinity = "Fire"}
}

-- passive skills stats, not much to say
Seeking_eternity.passive_skills_stats = {
    ["True Flight"] = {consumption = 4}
}
