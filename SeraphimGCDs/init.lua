--
-- Nice wrappers around the WoW API
--
aura_env.spellActuallyOnCD = function(spell_id)
    local gcdStart, gcdDur = GetSpellCooldown(aura_env.gcdID)
    local gcdEnd = gcdStart + gcdDur

    local spellStart, spellDur = GetSpellCooldown(spell_id)
    local spellEnd = spellStart + spellDur

    return gcdEnd ~= spellEnd
end

aura_env.getAuraDuration = function(spellName, unit)
    local expTime = (select(6, AuraUtil.FindAuraByName(spellName, unit)))
    if expTime == nil then
        return nil
    else
        local currTime = GetTime()
        return expTime - currTime
    end
end


aura_env.getSpellCharges = function(spell_id)
    local cur, max = GetSpellCharges(spell_id)
    if cur == nil or max == nil then
        -- If it doesn't have charges, treat it like it has 1 charge.
        -- And if it's on CD, make its current charges 0.
        if aura_env.spellActuallyOnCD(spell_id) then
            return 0, 1
        else
            return 1, 1
        end
    else
        return cur, max
    end
end


-- This is nice for readability
Spells = {
    Seraphim = 152262
}

aura_env.power_type = Enum.PowerType.HolyPower


--
-- Spell bookkeeping
--
aura_env.gcdID = 61304

aura_env.lastGCDDur = 0



--
-- This is also where we define some useful functions
--
aura_env.tableLength = function(T)
    local count = 0
    for _ in pairs(T) do count = count + 1 end
    return count
end

aura_env.appendInTable = function(T, k, v)
    if T[k] == nil then
        T[k] = {}
    end

    table.insert(T[k], v)
end

aura_env.predictGCDDur = function()
    local gcdMax = 1.5
    local gcdMin = 0.75
    local hasteRatio = UnitSpellHaste("player") / 100.0
    return max(gcdMax / (1.0 + hasteRatio), gcdMin)
end
