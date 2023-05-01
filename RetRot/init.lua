print("Init")

aura_env.frame = 0

aura_env.printEveryFrame = function(period, str)
  if aura_env.frame % period == 0 then
    print(str)
  end
end



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


aura_env.getHolyPowerCapacity = function()
  local max = UnitPowerMax("player", Enum.PowerType.HolyPower)
  local curr = UnitPower("player", Enum.PowerType.HolyPower)
  return max - curr
end

aura_env.getUnitHealthPct = function(unitStr)
  return UnitHealth(unitStr) / UnitHealthMax(unitStr)
end


-- name, rank, icon, castTime, minRange, maxRange, spellID, originalIcon
SIPart = {
  Name = 1,
  Rank = 2,
  Icon = 3,
  CastTime = 4,
  MinRange = 5,
  MaxRange = 6,
  SpellID = 7,
  OriginalIcon = 8,
}
aura_env.getSpellInfo = function(spellID, part)
  local infoTable = {GetSpellInfo(spellID)}
  return infoTable[part]
end


--[[
Goals:
1. Red-out spells that will over-cap
2. Orange-out spells that would be bad
   (e.g. Judgment if already have Judg debuff
   or Divine Resonance are about to go off)
3. Green-highlight the spell that's the best to press right now
]]




--[[
UnitHealthMax("target")
UnitHealthMax("target")
/run print(UnitHealth("target"))
]]



-- This is nice for readability
Spells = {
  BladeOfJustice = 184575,
  Judgment = 20271,
  HammerOfWrath = 24275,
  -- Consecration = 205228,
  CrusaderStrike = 35395,
  TemplarStrikes = 406646,
  TemplarStrike = 407480,
  TemplarSlash = 406647
}

GenHolyPower = 2


-- aura_env.asdf = function(spellID)
--   return GetSpellInfo(spellID)
-- end



-- For the love of whichever god you pray to, make sure that this covers all
-- of the spells in aura_env.spellIDs
aura_env.spellIDToInfo = {
  [Spells.BladeOfJustice] = {
    [GenHolyPower] = function () return 2 end,
  },
  [Spells.Judgment] = {
    [GenHolyPower] = function () return 2 end,
  },
  [Spells.HammerOfWrath] = {
    [GenHolyPower] = function () return 1 end,
  },
  [Spells.CrusaderStrike] = {
    [GenHolyPower] = function () return 1 end,
  },
  [Spells.TemplarStrikes] = {
    [GenHolyPower] = function () return 1 end,
  },
  [Spells.TemplarStrike] = {
    [GenHolyPower] = function () return 1 end,
  },
  [Spells.TemplarSlash] = {
    [GenHolyPower] = function () return 1 end,
  },
}

--
-- This is the source of truth for the priority
--
-- I consider Wake of Ashes to be a CD, along with
-- Avenging Wrath / Crusade, and any active essences.
-- So you'll have to keep track of those yourself :)
--
aura_env.spellIDs = {
  Spells.HammerOfWrath,
  Spells.BladeOfJustice,
  Spells.Judgment,
  Spells.CrusaderStrike,
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

aura_env.tableToStr = function(T)
  local out = ""

  local n = #T

  for i = 1, n do
    out = out .. tostring(T[i])
    if i + 1 < n then
      out = out .. ", "
    end
  end

  return out
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
