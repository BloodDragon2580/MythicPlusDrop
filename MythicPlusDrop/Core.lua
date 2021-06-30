MythicPlusDrop = LibStub("AceAddon-3.0"):NewAddon("MythicPlusDrop", "AceEvent-3.0", "AceTimer-3.0");
MYTHIC_CHEST_TIMERS_LOOT_ILVL = {184,213,216,220,220,223,226,226,226,230,230,233,233,233,236};
MYTHIC_CHEST_TIMERS_WEEKLY_ILVL = {0,226,229,233,236,236,239,242,242,246,246,249,249,252,252};

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
  '|cFF50FA7B',
  '|cFFFFFFFF',
  '|cFFFF5555',
  '|cFFFF5555',
  '|cFFFFFFFF',
  '|cFFFF5555',
  '|cFFFF5555',
  '|cFFFF5555',
  '|cFFFF5555',
  '|cFFFFB86C',
  '|cFF50FA7B'
}
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
-- 16: Infested
-- 117: Reaping
-- 119: Beguiling
-- 120: Awekened
-- 121: Prideful
-- 122: Inspiring
-- 123: Spiteful
-- 124: Storming
AFFIXES_SCHEDULE = {
	{10,11,3},
	{9,7,124},
	{10,123,12},
	{9,122,4},
	{10,8,14},
	{9,6,13},
	{10,123,3},
	{9,7,4},
	{10,122,124},
	{9,11,13},
	{10,8,12},
	{9,6,14}
}

SEASON_AFFIX = 121;

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
