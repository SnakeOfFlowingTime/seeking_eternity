-- foundation amount needed to break through to the next realm
Seeking_eternity.realm_values = {
    ["Mortal"] = 1000,
    ["Early Stage Qi Refiner"] = 4000,
    ["Middle Stage Qi Refiner"] = 16000,
    ["Late Stage Qi Refiner"] = 64000,
    ["Peak Qi Refiner"] = 1000000,
    ["Early Stage Foundation Establishment"] = 4000000,
    ["Middle Stage Foundation Establishment"] = 16000000,
    ["Late Stage Foundation Establishment"] = 64000000,
    ["Peak Foundation Establishment"] = 1000000000,
    ["Early Stage Golden Core"] = 4000000000,
    ["Middle Stage Golden Core"] = 16000000000,
    ["Late Stage Golden Core"] = 64000000000,
    ["Peak Golden Core"] = 1000000000000,
}

-- order of the realms
Seeking_eternity.realm_sequence = {
    "Mortal",
    "Early Stage Qi Refiner",
    "Middle Stage Qi Refiner",
    "Late Stage Qi Refiner",
    "Peak Qi Refiner",
    "Early Stage Foundation Establishment",
    "Middle Stage Foundation Establishment",
    "Late Stage Foundation Establishment",
    "Peak Foundation Establishment",
    "Early Stage Golden Core",
    "Middle Stage Golden Core",
    "Late Stage Golden Core",
    "Peak Golden Core"
}

-- realm stats, not much to say
Seeking_eternity.realm_stats = {
    ["Mortal"] = {max_hp = 20, speed = 1.0, max_spiritual_power = 0, spiritual_power_regen = 0},
    ["Early Stage Qi Refiner"] = {max_hp = 30, speed = 1.1, max_spiritual_power = 100, spiritual_power_regen = 1},
    ["Middle Stage Qi Refiner"] = {max_hp = 50, speed = 1.2, max_spiritual_power = 400, spiritual_power_regen = 4},
    ["Late Stage Qi Refiner"] = {max_hp = 80, speed = 1.4, max_spiritual_power = 1600, spiritual_power_regen = 16},
    ["Peak Qi Refiner"] = {max_hp = 100, speed = 2, max_spiritual_power = 6400, spiritual_power_regen = 64},
    ["Early Stage Foundation Establishment"] = {max_hp = 300, speed = 3, max_spiritual_power = 100000, spiritual_power_regen = 1000},
    ["Middle Stage Foundation Establishment"] = {max_hp = 500, speed = 3.5, max_spiritual_power = 400000, spiritual_power_regen = 4000},
    ["Late Stage Foundation Establishment"] = {max_hp = 800, speed = 4.5, max_spiritual_power = 1600000, spiritual_power_regen = 16000},
    ["Peak Foundation Establishment"] = {max_hp = 1000, speed = 5, max_spiritual_power = 6400000, spiritual_power_regen = 64000},
    ["Early Stage Golden Core"] = {max_hp = 3000, speed = 7.5, max_spiritual_power = 100000000, spiritual_power_regen = 1000000},
    ["Middle Stage Golden Core"] = {max_hp = 5000, speed = 8, max_spiritual_power = 400000000, spiritual_power_regen = 4000000},
    ["Late Stage Golden Core"] = {max_hp = 8000, speed = 9, max_spiritual_power = 1600000000, spiritual_power_regen = 16000000},
    ["Peak Golden Core"] = {max_hp = 10000, speed = 10, max_spiritual_power = 6400000000, spiritual_power_regen = 64000000},
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
    ["True Flight"] = {consumption = 4, min_realm = "Early Stage Qi Refiner"},
    ["Speed Boost"] = {consumption = 64, min_realm = "Early Stage Foundation Establishment"},
}
