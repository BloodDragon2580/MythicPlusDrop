MythicPlusDrop = LibStub("AceAddon-3.0"):NewAddon("MythicPlusDrop", "AceEvent-3.0", "AceTimer-3.0");
MYTHIC_CHEST_TIMERS_LOOT_ILVL = {
0,			-- +0
441,		-- +2
444,		-- +3
444,		-- +4
447,		-- +5
447,		-- +6
450,		-- +7
450,		-- +8
454,		-- +9
454,		-- +10
457,		-- +11
457,		-- +12
460,		-- +13
460,		-- +14
463,		-- +15
463,		-- +16
467,		-- +17
467,		-- +18
470,		-- +19
470};		-- +20

MYTHIC_CHEST_TIMERS_WEEKLY_ILVL = {
0,			-- +0
454,		-- +2
457,		-- +3
460,		-- +4
460,		-- +5
463,		-- +6
463,		-- +7
467,		-- +8
467,		-- +9
470,		-- +10
470,		-- +11
473,		-- +12
473,		-- +13
473,		-- +14
476,		-- +15
476,		-- +16
476,		-- +17
480,		-- +18
480,		-- +19
483};		-- +20

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
	{10,6,124},
	{10,134,7},
	{9,136,123},
	{10,135,6},
	{9,3,8},
	{10,124,11},
	{9,135,7},
	{10,136,8},
	{9,134,11},
	{10,3,123},
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
