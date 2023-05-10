MythicPlusDrop = LibStub("AceAddon-3.0"):NewAddon("MythicPlusDrop", "AceEvent-3.0", "AceTimer-3.0");
MYTHIC_CHEST_TIMERS_LOOT_ILVL = {
0,			-- +0
402,		-- +2
405,		-- +3
405,		-- +4
408,		-- +5
408,		-- +6
411,		-- +7
411,		-- +8
415,		-- +9
415,		-- +10
418,		-- +11
418,		-- +12
421,		-- +13
421,		-- +14
424,		-- +15
424,		-- +16
428,		-- +17
428,		-- +18
431,		-- +19
431};		-- +20

MYTHIC_CHEST_TIMERS_WEEKLY_ILVL = {
0,			-- +0
415,		-- +2
418,		-- +3
421,		-- +4
421,		-- +5
424,		-- +6
424,		-- +7
428,		-- +8
428,		-- +9
431,		-- +10
431,		-- +11
434,		-- +12
434,		-- +13
437,		-- +14
437,		-- +15
441,		-- +16
441,		-- +17
444,		-- +18
444,		-- +19
447};		-- +20

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
-- 1: Überschüssig		/		Overflowing
-- 2: Launisch			/		Skittish
-- 3: Vulkanisch 		/ 		Volcanic
-- 4: Nekrotisch		/		Necrotic
-- 5: Wimmelnd			/		Teeming
-- 6: Wütend 			/ 		Raging
-- 7: Anstachelnd		/		Bolstering
-- 8: Blutig			/		Sanguine
-- 9: Tyrannisch 		/ 		Tyrannical
-- 10: Verstärkt		/		Fortified
-- 11: Platzend			/		Bursting
-- 12: Schrecklich		/		Grievous
-- 13: Explosiv			/		Explosive
-- 14: Bebend			/		Quaking
-- 16: Befallen			/		Infested
-- 117: Schröpfend		/		Reaping
-- 119: Betörend		/		Beguiling
-- 120: Erweckt			/		Awakened
-- 121: Stolz			/		Prideful
-- 122: Inspirierend	/		Inspiring
-- 123: Boshaft			/		Spiteful
-- 124: Stürmisch		/		Storming
-- 128: Gequält			/		Tormented
-- 129: Höllisch		/		Infernal
-- 130: Verschlüsselt	/		Encrypted
-- 131: Verhüllt		/		Shrouded
-- 132: Donnernd		/		Thundering
-- 134: Umschlingend	/		Entangling
-- 135: Befallen		/		Afflicted
-- 136: Unkörperlich	/		Incorporeal
-- 137: Abschirmend		/		Shielding
AFFIXES_SCHEDULE = {
	{10,6,14},
	{9,11,12},
	{10,8,3},
	{9,6,124},
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
