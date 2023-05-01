
--[[
%c1
%c2
%c3
%c4
%c5
%c6
%c7
%c8
%c9
%c10
%c11
]]



function()
  aura_env.printEveryFrame(144, "Display")

  local strs = {}



  strs = {}
  for spellID, info in pairs(aura_env.spellIDToInfo) do
    local holyPower = info[GenHolyPower]()
    local learned = IsPlayerSpell(spellID)

    local spellName = aura_env.getSpellInfo(spellID, SIPart.Name)
    local spellStr = string.format("%s: HP = %d, Learned = %s", spellName, holyPower, tostring(learned))

    local minCharges, maxCharges = aura_env.getSpellCharges(spellID)
    spellStr = spellStr .. string.format(", charges = {%d, %d}", minCharges, maxCharges)

    table.insert(strs, spellStr)
  end


  table.insert(strs, tostring(aura_env.getHolyPowerCapacity()))
  table.insert(strs, tostring(aura_env.getUnitHealthPct("target")))

  -- strs = {}
  -- for i, info in ipairs(aura_env.spellIDToInfo) do
  --   local holyPower = info[GenHolyPower]()
  --   local learned = info[SpellLearned]()

  --   local spellStr = string.format("Spell ID %d: HP = %d, Learned = %s", i, holyPower, tostring(learned))
  --   table.insert(strs, spellStr)
  -- end

  return unpack(strs)


  -- -- Insert finishers
  -- -- TODO Move this to the
  -- aura_env.spell_queue_4 = {}

  -- local cdFmtStr = "%.1f"

  -- local currQueue = {unpack(aura_env.spell_queue_3)}
  -- local currCDs = {}
  -- local currCharges = {}
  -- local currPow = UnitPower("player", aura_env.power_type)
  -- for _i, spell_id in ipairs(currQueue) do
  --   local cd = aura_env.spellToCD[spell_id]
  --   local currSpellCharges = aura_env.getSpellCharges(spell_id)
  --   table.insert(currCDs, cd)
  --   table.insert(currCharges, currSpellCharges)
  -- end
  -- local currIdx = 1

  -- -- Display the spell names
  -- local spellQueueStrs = {}
  -- for _i, spell_id in ipairs(currQueue) do
  --   local spellStr = select(1, GetSpellInfo(spell_id))
  --   table.insert(spellQueueStrs, spellStr)
  -- end
  -- local spellQueueStr = table.concat(spellQueueStrs, ", ")
  -- table.insert(strs, spellQueueStr)

  -- -- Display the cooldowns
  -- local spellCDStrs = {}
  -- for _i, cd in ipairs(currCDs) do
  --   local cdStr = string.format(cdFmtStr, cd)
  --   table.insert(spellCDStrs, cdStr)
  -- end
  -- local spelCDsStr = table.concat(spellCDStrs, ", ")
  -- table.insert(strs, spelCDsStr)

  -- local newPower = aura_env.goIntoTheFuture(currQueue, currCDs, currCharges, currIdx, currPow, aura_env.gcdCD)

  -- -- Display the cooldowns AFTER going ahead in the future one GCD
  -- spellCDStrs = {}
  -- for _i, cd in ipairs(currCDs) do
  --   local cdStr = string.format(cdFmtStr, cd)
  --   table.insert(spellCDStrs, cdStr)
  -- end
  -- spelCDsStr = table.concat(spellCDStrs, ", ")
  -- table.insert(strs, spelCDsStr)

  -- return unpack(strs)
end
