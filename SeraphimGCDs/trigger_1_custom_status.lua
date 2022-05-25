--
-- This is really just an event loop that does some logic
--
function()
    -- Get the GCD duration
    local currTime = GetTime()
    local gcdStart, gcdDur = GetSpellCooldown(aura_env.gcdID)
    if gcdStart == 0 then
        aura_env.gcdCD = 0
    else
        aura_env.gcdCD = gcdStart + gcdDur - currTime
    end

    aura_env.seraDur = aura_env.getAuraDuration("Seraphim", "player")

    return true
end

