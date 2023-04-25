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

    -- Get the predicted GCD
    aura_env.predGCD = aura_env.predictGCDDur()

    -- Get the Seraphim duration
    aura_env.seraDur = aura_env.getAuraDuration("Seraphim", "player")

    -- Keep track of whether we have Seraphim
    if aura_env.seraDur > 0 then
        aura_env.currFrameHaveSera = true
        if aura_env.lastFrameHadSera == false then
            -- If we *just* got Seraphim, record the GCD offset
            aura_env.seraStartGCDDur = aura_env.gcdCD
        end
    else
        aura_env.currFrameHaveSera = false
    end

    -- TODO get the number of GCDs you can fit in
    if aura_env.seraDur == 0 then
        aura_env.nGCDs = 0
    else
        -- With this, the rectangles are mostly static
        -- aura_env.nGCDs = (aura_env.seraDur - aura_env.gcdCD) / aura_env.predGCD

        -- With this, the rectangles are offset by GCD had while it proc'd
        -- aura_env.nGCDs = aura_env.seraDur / aura_env.predGCD

        aura_env.nGCDs = (aura_env.seraDur - aura_env.seraStartGCDDur) / aura_env.predGCD
        aura_env.nGCDs = max(aura_env.nGCDs, 0)
    end

    -- Update the Seraphim bookkeeping
    aura_env.lastFrameHadSera = aura_env.currFrameHaveSera

    return true
end

