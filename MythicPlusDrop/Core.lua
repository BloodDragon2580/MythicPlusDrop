MythicPlusDrop = LibStub("AceAddon-3.0"):NewAddon("MythicPlusDrop", "AceEvent-3.0", "AceTimer-3.0");
MYTHIC_CHEST_TIMERS_LOOT_ILVL = {
0,			-- +0
496,		-- +2
499,		-- +3
499,		-- +4
502,		-- +5
502,		-- +6
506,		-- +7
506,		-- +8
509,		-- +9
509,		-- +10
509,		-- +11
509,		-- +12
509,		-- +13
509,		-- +14
509,		-- +15
509,		-- +16
509,		-- +17
509,		-- +18
509,		-- +19
509};		-- +20

MYTHIC_CHEST_TIMERS_WEEKLY_ILVL = {
0,			-- +0
509,		-- +2
509,		-- +3
512,		-- +4
512,		-- +5
515,		-- +6
515,		-- +7
519,		-- +8
519,		-- +9
522,		-- +10
522,		-- +11
522,		-- +12
522,		-- +13
522,		-- +14
522,		-- +15
522,		-- +16
522,		-- +17
522,		-- +18
522,		-- +19
522};		-- +20

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
	--{10,136,8},
	--{9,134,7},
	--{10,3,123},
	{9,124,6},
	--{10,134,7},
	--{9,136,123},
	--{10,135,6},
	--{9,3,8},
	--{10,124,11},
	--{9,135,7},
}


SEASON_AFFIX = 129;

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
