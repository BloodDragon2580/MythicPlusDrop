MythicPlusDrop = LibStub("AceAddon-3.0"):NewAddon("MythicPlusDrop", "AceEvent-3.0", "AceTimer-3.0");
MYTHIC_CHEST_TIMERS_LOOT_ILVL = {185,187,190,194,194,197,200,200,200,204,204,207,207,207,210};
MYTHIC_CHEST_TIMERS_WEEKLY_ILVL = {0,200,203,207,210,210,213,216,216,220,220,223,223,226,226};

-- 1: Overflowing
-- 2: Skittish
-- 3: Volcanic
-- 4: Necrotic
-- 5: Teeming
-- 6: Raging
-- 7: Bolstering
-- 8: Sanguine
-- 9: Tyrannical
-- 10: Fortified
-- 11: Bursting
-- 12: Grievous
-- 13: Explosive
-- 14: Quaking
AFFIXES_DIFICULTY = {
  '|cFFFF5555',
  '|cFFFFB86C',
  '|cFF50FA7B',
  '|cFFFF5555',
  '|cFFFFB86C',
  '|cFFFFB86C',
  '|cFFFFB86C',
  '|cFF50FA7B',
  '|cFFFF5555',
  '|cFFFF5555',
  '|cFFFFB86C',
  '|cFFFFB86C',
  '|cFFFFB86C',
  '|cFF50FA7B'
}
AFFIXES_SCHEDULE = {
	{10, 8, 14}, -- FORTIFIED, SANGUINE, QUAKING
	{9, 7,13}, -- TYRANNICAL, BOLSTERING,EXPLOSIVE
	{10, 11, 3}, -- FORTIFIED, BURSTING, VOLCANIC
	{9, 6, 4}, -- TYRANNICAL, RAGING, NECROTIC
	{10, 5, 14}, -- FORTIFIED, TEEMING, QUAKING
	{9, 11, 2}, -- TYRANNICAL, BURSTING, SKITTISH
	{10, 7, 12}, -- FORTIFIED, BOLSTERING, GRiEVOUS
	{9, 6, 13}, -- TYRANNICAL, RAGING, EXPLOSIVE
	{10, 8, 12}, -- FORTIFIED, SANGUINE, GRiEVOUS
	{9, 5, 3}, -- TYRANNICAL, TEEMING, VOLCANIC
	{10, 7, 2}, -- FORTIFIED, BOLSTERING, SKITTISH
	{9, 11, 4} -- TYRANNICAL, BURSTING, NECROTIC
}

-- ---------------------------------------------------------------------------------------------------------------------
function MythicPlusDrop:OnInitialize()
  MythicPlusDrop.L = LibStub("AceLocale-3.0"):GetLocale("MythicPlusDrop")

  MythicPlusDropCMTimer:Init();
  MythicPlusDropTooltip:Init();
end

-- ---------------------------------------------------------------------------------------------------------------------
function MythicPlusDrop:OnEnable()
  self:RegisterEvent("CHALLENGE_MODE_START");
  self:RegisterEvent("CHALLENGE_MODE_COMPLETED");
  self:RegisterEvent("CHALLENGE_MODE_RESET");
  self:RegisterEvent("PLAYER_ENTERING_WORLD");
end

-- ---------------------------------------------------------------------------------------------------------------------
function MythicPlusDrop:CHALLENGE_MODE_START()
  MythicPlusDropCMTimer:OnStart();
end

-- ---------------------------------------------------------------------------------------------------------------------
function MythicPlusDrop:StartCMTimer()
  MythicPlusDrop:CancelCMTimer()
  MythicPlusDrop.cmTimer = self:ScheduleRepeatingTimer("OnCMTimerTick", 1)
end

-- ---------------------------------------------------------------------------------------------------------------------
function MythicPlusDrop:CHALLENGE_MODE_COMPLETED()
  MythicPlusDropCMTimer:OnComplete();
end

-- ---------------------------------------------------------------------------------------------------------------------
function MythicPlusDrop:CHALLENGE_MODE_RESET()
  MythicPlusDropCMTimer:OnReset();
end

-- ---------------------------------------------------------------------------------------------------------------------
function MythicPlusDrop:OnCMTimerTick()
  MythicPlusDropCMTimer:Draw();
end

-- ---------------------------------------------------------------------------------------------------------------------
function MythicPlusDrop:PLAYER_ENTERING_WORLD()
  MythicPlusDropCMTimer:ReStart();
end

-- ---------------------------------------------------------------------------------------------------------------------
function MythicPlusDrop:CancelCMTimer()
  if MythicPlusDrop.cmTimer then
    self:CancelTimer(MythicPlusDrop.cmTimer)
    MythicPlusDrop.cmTimer = nil
  end
end
