-- %c1

-- %c2

-- %c3


function()
    local strs = {}

    local cdFmtStr = "%.1f"

    -- Insert finishers
    -- TODO Move this to the
    aura_env.spell_queue_4 = {}

    local currQueue = {unpack(aura_env.spell_queue_3)}
    local currCDs = {}
    local currCharges = {}
    local currPow = UnitPower("player", aura_env.power_type)
    for _i, spell_id in ipairs(currQueue) do
        local cd = aura_env.spellToCD[spell_id]
        local currSpellCharges = aura_env.getSpellCharges(spell_id)
        table.insert(currCDs, cd)
        table.insert(currCharges, currSpellCharges)
    end
    local currIdx = 1

    -- Display the spell names
    local spellQueueStrs = {}
    for _i, spell_id in ipairs(currQueue) do
        local spellStr = select(1, GetSpellInfo(spell_id))
        table.insert(spellQueueStrs, spellStr)
    end
    spellQueueStr = table.concat(spellQueueStrs, ", ")
    table.insert(strs, spellQueueStr)

    -- Display the cooldowns
    spellCDStrs = {}
    for _i, cd in ipairs(currCDs) do
        local cdStr = string.format(cdFmtStr, cd)
        table.insert(spellCDStrs, cdStr)
    end
    spelCDsStr = table.concat(spellCDStrs, ", ")
    table.insert(strs, spelCDsStr)

    local newPower = aura_env.goIntoTheFuture(currQueue, currCDs, currCharges, currIdx, currPow, aura_env.gcdCD)

    -- Display the cooldowns AFTER going ahead in the future one GCD
    spellCDStrs = {}
    for _i, cd in ipairs(currCDs) do
        local cdStr = string.format(cdFmtStr, cd)
        table.insert(spellCDStrs, cdStr)
    end
    spelCDsStr = table.concat(spellCDStrs, ", ")
    table.insert(strs, spelCDsStr)

    return unpack(strs)
end
