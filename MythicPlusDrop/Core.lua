MythicPlusDrop = LibStub("AceAddon-3.0"):NewAddon("MythicPlusDrop", "AceEvent-3.0", "AceTimer-3.0");
MYTHIC_CHEST_TIMERS_LOOT_ILVL = {
0,			-- +0
376,		-- +2
376,		-- +3
379,		-- +4
379,		-- +5
382,		-- +6
385,		-- +7
385,		-- +8
389,		-- +9
392,		-- +10
392,		-- +11
392,		-- +12
392,		-- +13
395,		-- +14
398,		-- +15
398,		-- +16
402,		-- +17
402,		-- +18
405,		-- +19
405};		-- +20

MYTHIC_CHEST_TIMERS_WEEKLY_ILVL = {
0,			-- +0
382,		-- +2
385,		-- +3
385,		-- +4
389,		-- +5
389,		-- +6
392,		-- +7
395,		-- +8
395,		-- +9
398,		-- +10
402,		-- +11
405,		-- +12
408,		-- +13
408,		-- +14
411,		-- +15
415,		-- +16
415,		-- +17
418,		-- +18
418,		-- +19
421};		-- +20

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
-- 1: Überschüssig
-- 2: Launisch
-- 3: Vulkanisch
-- 4: Nekrotisch
-- 5: Wimmelnd
-- 6: Wütend
-- 7: Anstachelnd
-- 8: Blutig
-- 9: Tyrannisch
-- 10: Verstärkt
-- 11: Platzend
-- 12: Schrecklich
-- 13: Explosiv
-- 14: Bebend
-- 16: Befallen
-- 117: Schröpfend
-- 119: Betörend
-- 120: Erweckt
-- 121: Stolz
-- 122: Inspirierend
-- 123: Boshaft
-- 124: Stürmisch
-- 128: Gequält
-- 129: Höllisch
-- 130: Verschlüsselt
-- 131: Verhüllt
-- 132: Donnernd
AFFIXES_SCHEDULE = {
	{10,6,14},
	{9,11,12},
	{10,8,3},
	{9,11,124},
	{10,123,12},
	{9,8,13},
	{10,7,124},
	{9,123,14},
	{10,11,13},
	{9,7,3}
}

SEASON_AFFIX = 132;

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
