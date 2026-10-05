core.register_craftitem("seeking_eternity:pseudo_first_tier_fire_fox_bloodline", {
    description = "Pseudo-First Tier Fire Fox Bloodline",
    inventory_image = "pseudo_first_tier_fire_fox_bloodline.png",
    on_use = function(itemstack, player, pointed_thing)
        Seeking_eternity.update_current_bloodline(player, "Pseudo-First Tier Fire Fox Bloodline")
        itemstack:take_item(1)
        return itemstack
    end
})