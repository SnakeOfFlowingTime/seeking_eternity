core.register_craftitem("seeking_eternity:advanced_breathing_manual", {
    description = "Advanced Breathing Technique Manual",
    inventory_image = "advanced_breathing_book.png",
    on_use = function(itemstack, player, pointed_thing)
        Seeking_eternity.update_current_technique(player, "Advanced Breathing")
    end
})
core.register_craftitem("seeking_eternity:spirit_star_chart", {
    description = "Spirit Star Chart",
    inventory_image = "spirit_star_chart.png",
    on_use = function(itemstack, player, pointed_thing)
        Seeking_eternity.update_current_technique(player, "Spirit Star Chart")
    end
})
core.register_craftitem("seeking_eternity:final_heaven_method", {
    description = "Final Heaven Method",
    inventory_image = "final_heaven_method.png",
    on_use = function(itemstack, player, pointed_thing)
        Seeking_eternity.update_current_technique(player, "Final Heaven Method")
    end
})
core.register_craftitem("seeking_eternity:sutra_of_no_self", {
    description = "Sutra of No Self",
    inventory_image = "sutra_of_no_self.png",
    on_use = function(itemstack, player, pointed_thing)
        Seeking_eternity.update_current_technique(player, "Sutra of No Self")
    end
})
core.register_craftitem("seeking_eternity:fire_control_mantra", {
    description = "Fire Control Mantra",
    inventory_image = "fire_control_mantra.png",
    on_use = function(itemstack, player, pointed_thing)
        Seeking_eternity.update_current_technique(player, "Fire Control Mantra")
    end
})
