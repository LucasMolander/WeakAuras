--
-- This is really just an event loop that does some logic
--
function()
  aura_env.frame = aura_env.frame + 1
  aura_env.printEveryFrame(144, "Trigger")

  if aura_env.frame % 10 == 0 then
    return true
  end

  -- Re-initialize the bookkeeping
  aura_env.spellToCD = {}
  aura_env.spellToUsable = {}
  aura_env.cdToSpellIDs = {}

  -- Get the GCD duration
  local currTime = GetTime()
  local gcdStart, gcdDur = GetSpellCooldown(aura_env.gcdID)
  if gcdStart == 0 then
    aura_env.gcdCD = 0
  else
    aura_env.gcdCD = gcdStart + gcdDur - currTime
  end

  -- Get each spell's duration
  for _i, spell_id in ipairs(aura_env.spellIDs) do
    local start, duration = GetSpellCooldown(spell_id)

    if start == 0 then
      -- "Off CD"
      if aura_env.gcdCD == 0 then
        -- Really off CD (also off GCD)
        aura_env.spellToCD[spell_id] = 0
      else
        -- Actually on GCD
        aura_env.spellToCD[spell_id] = aura_env.gcdCD
      end
    else
      -- On CD
      aura_env.spellToCD[spell_id] = start + duration - currTime
    end
  end

  -- Let's also keep track of whether they're usable
  for _i, spell_id in ipairs(aura_env.spellIDs) do
    -- We have to use `GetSpellInfo` because it will return
    -- true for a spell ID even if the talent isn't taken...
    -- So we have to feed it the name rather than the ID
    local usable = IsUsableSpell(GetSpellInfo(spell_id))
    aura_env.spellToUsable[spell_id] = usable
  end

  -- Construct a timeline of usable spells
  for _i, spell_id in ipairs(aura_env.spellIDs) do
    local cd = aura_env.spellToCD[spell_id]
    local usable = aura_env.spellToUsable[spell_id]

    if usable then
      -- The lists are sorted in priority order, which is nice
      aura_env.appendInTable(aura_env.cdToSpellIDs, cd, spell_id)
    end
  end

  return true


  -- --
  -- -- TODO
  -- -- ----
  -- -- Only go display_queue_len in the future
  -- -- and see whether a finisher should go there.
  -- --
  -- -- If so, insert it there and continue inserting
  -- -- until we've gone display_queue_len in the future
  -- --
  -- -- OR until we've exhausted all the spells
  -- --
  -- -- ALSO, look at the current charges / max charges
  -- -- via GetSpellCharges()[0]
  -- --


  -- -- power_type = Enum.PowerType.HolyPower
  -- -- power = UnitPower("player", power_type)
  -- -- power_max = UnitPowerMax("player", power_type)
  -- --
  -- -- cstTbl = GetSpellPowerCost(184575)
  -- -- for _, cstInfo in pairs(cstTbl) do print(costInfo.cost) end


  -- -- Go through the timeline and construct the queue
  -- local ordered_cds = {}
  -- for cd in pairs(aura_env.cdToSpellIDs) do
  --   table.insert(ordered_cds, cd)
  -- end
  -- table.sort(ordered_cds)

  -- aura_env.spell_queue = {}
  -- for i = 1, #ordered_cds do
  --   local cd = ordered_cds[i]
  --   local spell_ids = aura_env.cdToSpellIDs[cd]

  --   for _i, spell_id in ipairs(spell_ids) do
  --     table.insert(aura_env.spell_queue, spell_id)
  --   end
  -- end

  -- -- Deprioritize spells that are already "on CD" because they've used
  -- -- one of their charges
  -- aura_env.spell_queue_2 = {}
  -- local prefix_queue = {}
  -- local suffix_queue = {}
  -- for _i, spell_id in ipairs(aura_env.spell_queue) do
  --   local curCharges, maxCharges = aura_env.getSpellCharges(spell_id)
  --   if curCharges < maxCharges then
  --     table.insert(suffix_queue, spell_id)
  --   else
  --     table.insert(prefix_queue, spell_id)
  --   end
  -- end
  -- for _i, spell_id in ipairs(prefix_queue) do
  --   table.insert(aura_env.spell_queue_2, spell_id)
  -- end
  -- for _i, spell_id in ipairs(suffix_queue) do
  --   table.insert(aura_env.spell_queue_2, spell_id)
  -- end

  -- -- Deprioritize spells that would over-cap on the resource
  -- aura_env.spell_queue_3 = {}
  -- prefix_queue = {}
  -- suffix_queue = {}
  -- local curPow = UnitPower("player", aura_env.power_type)
  -- local maxPow = UnitPowerMax("player", aura_env.power_type)
  -- for _i, spell_id in ipairs(aura_env.spell_queue_2) do
  --   local genPow = aura_env.spellIDToInfo[spell_id]["gen_power"]

  --   if (curPow + genPow) > maxPow then
  --     table.insert(suffix_queue, spell_id)
  --   else
  --     table.insert(prefix_queue, spell_id)
  --   end
  -- end
  -- for _i, spell_id in ipairs(prefix_queue) do
  --   table.insert(aura_env.spell_queue_3, spell_id)
  -- end
  -- for _i, spell_id in ipairs(suffix_queue) do
  --   table.insert(aura_env.spell_queue_3, spell_id)
  -- end

  -- -- Insert finishers
  -- aura_env.spell_queue_4 = {}
  -- for _i, spell_id in ipairs(aura_env.spell_queue_3) do
  --   -- If the CD is
  -- end

  -- return true
end
