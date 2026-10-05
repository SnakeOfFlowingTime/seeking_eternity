core.register_craftitem("seeking_eternity:iron_bone_body", {
    description = "Iron Bone Body",
    inventory_image = "iron_bone_body.png",
    on_use = function(itemstack, player, pointed_thing)
        Seeking_eternity.update_current_physique(player, "Iron Bone Body")
        itemstack:take_item(1)
        return itemstack
    end
})
core.register_craftitem("seeking_eternity:burning_heart_physique", {
    description = "Burning Heart Physique",
    inventory_image = "burning_heart_physique.png",
    on_use = function(itemstack, player, pointed_thing)
        Seeking_eternity.update_current_physique(player, "Burning Heart Physique")
        itemstack:take_item(1)
        return itemstack
    end
})