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
    BladeOfJustice = 184575,
    Judgment = 20271,
    HammerOfWrath = 24275,
    Consecration = 205228,
    CrusaderStrike = 35395,
    ArcaneTorrent = 155145
}

aura_env.power_type = Enum.PowerType.HolyPower


-- For the love of whichever god you pray to, make sure that this covers all
-- of the spells in aura_env.spellIDs
aura_env.spellIDToInfo = {
    [Spells.BladeOfJustice] = {
        ["gen_power"] = 2,
    },
    [Spells.Judgment] = {
        ["gen_power"] = 1,
    },
    [Spells.HammerOfWrath] = {
        ["gen_power"] = 1,
    },
    [Spells.Consecration] = {
        ["gen_power"] = 1,
    },
    [Spells.CrusaderStrike] = {
        ["gen_power"] = 1,
    },
    [Spells.ArcaneTorrent] = {
        ["gen_power"] = 1,
    }
}

--
-- This is the source of truth for the priority
--
-- I consider Wake of Ashes to be a CD, along with
-- Avenging Wrath / Crusade, and any active essences.
-- So you'll have to keep track of those yourself :)
--
aura_env.spellIDs = {
    Spells.BladeOfJustice,
    Spells.Judgment,
    Spells.HammerOfWrath,
    Spells.Consecration,
    Spells.CrusaderStrike,
    Spells.ArcaneTorrent
}


--
-- Spell bookkeeping
--
aura_env.spellToCD = {}
aura_env.spellToUsable = {}
aura_env.cdToSpellIDs = {}

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

aura_env.getPowerDiff = function(currPower, time)
    -- Paladins don't really generate/decay power over short periods of time
    return 0
end

--
-- Tables are passed by reference, but integers are not.
--
aura_env.goIntoTheFuture = function(queue, CDs, theCharges, idx, power, time)
    if time == 0.0 then
        return power
    end

    -- local spellID = queue[currIdx]
    -- local cd = CDs[currIdx]
    -- local charges = theCharges[currIdx]

    -- local resets = {}

    -- Move the CDs down
    for i, cd in ipairs(CDs) do
        -- local newCD = max(0.0, CDs[i] - time)
        -- if
        CDs[i] = max(0.0, CDs[i] - time)
    end

    -- Let's try ignoring the charges for now
    -- for i, charges in ipairs(theCharges) do
    -- end

    local newPower = power + aura_env.getPowerDiff(power, time)

    return newPower
end



-- -- The implementation is dependent on the class.
-- -- e.g. ret paladins should definitely spend holy power
-- -- if the only HP-generating ability is Crusade Strike
-- -- with one charge.
-- -- TODO Implement this and use it
-- aura_env.shouldReallySpendResource = function()

-- end

-- -- IsUsableSpell() returns true for non-talented spells
-- -- so we need to also check whether it's talented
-- aura_env.isSpellReallyUsable = function(spell_id)
--     if not IsUsableSpell(spell_id) then
--         return false
--     end

--     -- TODO Check the talent info
-- end

