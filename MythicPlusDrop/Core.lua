MythicPlusDrop = LibStub("AceAddon-3.0"):NewAddon("MythicPlusDrop", "AceEvent-3.0", "AceTimer-3.0");
MYTHIC_CHEST_TIMERS_LOOT_ILVL = {
0,			-- +0
262,		-- +2
265,		-- +3
268,		-- +4
272,		-- +5
275,		-- +6
275,		-- +7
278,		-- +8
278,		-- +9
281,		-- +10
281,		-- +11
285,		-- +12
285,		-- +13
288,		-- +14
288,		-- +15
288,		-- +16
288,		-- +17
288,		-- +18
288,		-- +19
288};		-- +20

MYTHIC_CHEST_TIMERS_WEEKLY_ILVL = {
0,			-- +0
278,		-- +2
278,		-- +3
278,		-- +4
281,		-- +5
281,		-- +6
285,		-- +7
288,		-- +8
288,		-- +9
291,		-- +10
294,		-- +11
298,		-- +12
298,		-- +13
301,		-- +14
304,		-- +15
304,		-- +16
304,		-- +17
304,		-- +18
304,		-- +19
304};		-- +20

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
	{11,124,10},
	{6,3,9},
	{122,12,10},
	{123,4,9},
	{7,14,10},
	{8,124,9},
	{6,13,10},
	{11,3,9},
	{123,12,10},
	{122,14,9},
	{8,4,10},
	{7,13,9}
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
