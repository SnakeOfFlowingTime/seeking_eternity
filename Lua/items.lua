core.register_craftitem("seeking_eternity:advanced_breathing_manual", {
    description = "Advanced Breathing Technique Manual",
    inventory_image = "advanced_breathing_book.png",
    on_use = function(itemstack, player, pointed_thing)
        local name = player:get_player_name()
        Seeking_eternity.update_current_technique(player, "Advanced Breathing")
        
    end
})