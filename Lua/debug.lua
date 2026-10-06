-- debug command to set player foundation (probably could use some of the newer functions i made)
core.register_chatcommand("setprogress", {
    param = "<amount> [Player_name]",
    description = "Sets current progress",
    privs = {server = true},
    func = function(name, param)
        local amount_str, target_name = param:match("^(%d+)%s*(.*)$")
        if not amount_str then
            return false, "Amount missing"
        end

        local amount = amount_str
        if tonumber(amount) == nil then
            return false, "Invalid Amount"
        end

        if target_name == "" then
            target_name = name
        end

        local target_player = core.get_player_by_name(target_name)

        if not target_player then
            return false, "No such online player"
        end

        local pmeta = target_player:get_meta()
        local current_realm = pmeta:get_string("seeking_eternity:cultivation_realm")
        local max_progress = Seeking_eternity.realm_values[current_realm]
        
        pmeta:set_string("seeking_eternity:current_progress", amount)
        if Seeking_eternity.progress[target_name] then
            Seeking_eternity.progress[target_name].current_progress = tonumber(amount)
            target_player:hud_change(Seeking_eternity.progress[target_name].progress_hud, "text", string.format("Foundation: %d/%d", tonumber(amount), max_progress))
        end
        return true
    end
})
