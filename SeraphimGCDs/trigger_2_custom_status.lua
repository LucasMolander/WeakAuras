function()
    local nMoreGCDs = aura_env.nGCDs - aura_env.config.rectangle_index
    if nMoreGCDs > 0 then
        -- Turn this rectangle on and update the max height
        local heightRatio = min(nMoreGCDs, 1)
        local heightPx = heightRatio * aura_env.config.max_height
        aura_env.region:SetRegionHeight(heightPx)
        return true
    else
        return false
    end
end

