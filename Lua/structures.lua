local loot_pool = {
    ["Mortal"]= {
        {name = "seeking_eternity:advanced_breathing_manual", min = 1, max = 1}
    },
    ["Earthly"] = {
        {name = "seeking_eternity:spirit_star_chart", min = 1, max = 1}
    },
    ["Heavenly"] = {
        {name = "seeking_eternity:final_heaven_method", min = 1, max = 1}
    },
    ["Supreme"] = {
        {name = "seeking_eternity:sutra_of_no_self", min = 1, max = 1}
    }
}

local path = core.get_modpath("seeking_eternity") .. "/schematics/"


core.register_on_generated(function(minp, maxp, blockseed)
    local pr = PseudoRandom(blockseed)

    if pr:next(1, 10) ~= 1 then return end

    local x = pr:next(minp.x, maxp.x)
    local z = pr:next(minp.z, maxp.z)

    local heightmap = core.get_mapgen_object("heightmap")
    if not heightmap then return end

    local side_length = maxp.x - minp.x + 1
    local index = (z - minp.z) * side_length + (x - minp.x) + 1
    local y_surface = heightmap[index]

    if y_surface and y_surface >= minp.y and y_surface <= maxp.y then
        local spawn_pos = {x = x, y = y_surface + 1, z = z}

        core.place_schematic(
            spawn_pos, 
            path .. "cheststoneplatform.mts",
            "random",
            nil,
            true
        )

        local search_min = {x = spawn_pos.x - 5, y = spawn_pos.y, z = spawn_pos.z - 5}
        local search_max = {x = spawn_pos.x + 5, y = spawn_pos.y + 10, z = spawn_pos.z + 5}


        local chest_positions = core.find_nodes_in_area(search_min, search_max, {"default:chest"})

        for _, chest_pos in ipairs(chest_positions) do
            local meta = core.get_meta(chest_pos)
            local inv = meta:get_inventory()

            if inv then
                inv:set_size("main", 8 * 4)

                meta:set_string("formspec",
                    "size[8,9]" ..
                    "list[context;main;0,0.3;8,4;]" ..
                    "list[current_player;main;0,4.8;8,4;]" ..
                    "listring[context;main]" ..
                    "listring[current_player;main]"
                )

                local abs_y = math.abs(spawn_pos.y)
                local tier = "Mortal"

                if abs_y >= 30000 then
                    tier = "Supreme"
            
                elseif abs_y >= 10000 then
                    tier = "Heavenly"

                elseif abs_y >= 1000 then
                    tier = "Earthly"
                end

                meta:set_string("infotext", "Ancient " .. tier .. " Legacy")

                local rolls = pr:next(1, 1)
                local loot_level = loot_pool[tier]
                for i = 1, rolls do
                    local loot = loot_level[pr:next(1, #loot_level)]
                    local amount = pr:next(loot.min, loot.max)
                
                    local itemstack = ItemStack(loot.name .. " " .. amount)
                    inv:add_item("main", itemstack)
                end
            end
        end
    end
end)