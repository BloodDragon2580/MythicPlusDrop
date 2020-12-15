MythicPlusDropCMTimer = {}
MYTHIC_CHEST_TIMERS_LOOT_HEIGHT = 20;
-- ---------------------------------------------------------------------------------------------------------------------
function MythicPlusDropCMTimer:Init()

  TimersPosition = {};
  TimersPosition.left = 29;
  TimersPosition.top = -62;
  TimersPosition.relativePoint = "TOPLEFT";

  LootPosition = {};
  LootPosition.right = -29;
  LootPosition.top = -62;
  LootPosition.relativePoint = "TOPRIGHT";

  MythicPlusDropCMTimer.isCompleted = false;
  MythicPlusDropCMTimer.started = false;
  MythicPlusDropCMTimer.reset = false;
  MythicPlusDropCMTimer.frames = {};
  MythicPlusDropCMTimer.timerStarted = false;

  MythicPlusDropCMTimer.frame = CreateFrame("Frame", "CmTimer", ScenarioChallengeModeBlock);
  MythicPlusDropCMTimer.frame:SetPoint(TimersPosition.relativePoint,TimersPosition.left,TimersPosition.top);
  MythicPlusDropCMTimer.frame:EnableMouse(false);
  MythicPlusDropCMTimer.frame:SetWidth(190);
  MythicPlusDropCMTimer.frame:SetHeight(MYTHIC_CHEST_TIMERS_LOOT_HEIGHT);

  MythicPlusDropCMTimer.lootFrame = CreateFrame("Frame", "LootTimer", ScenarioChallengeModeBlock);
  MythicPlusDropCMTimer.lootFrame:SetPoint(LootPosition.relativePoint,LootPosition.right,LootPosition.top);
  MythicPlusDropCMTimer.lootFrame:EnableMouse(false);
  MythicPlusDropCMTimer.lootFrame:SetWidth(200);
  MythicPlusDropCMTimer.lootFrame:SetHeight(MYTHIC_CHEST_TIMERS_LOOT_HEIGHT);

end

-- ---------------------------------------------------------------------------------------------------------------------
function MythicPlusDropCMTimer:OnComplete()
  MythicPlusDropCMTimer.isCompleted = true;
  MythicPlusDropCMTimer.frame:Hide();
  MythicPlusDropCMTimer.lootFrame:Hide();
end

-- ---------------------------------------------------------------------------------------------------------------------
function MythicPlusDropCMTimer:OnStart()
  MythicPlusDropCMTimer.isCompleted = false;
  MythicPlusDropCMTimer.started = true;
  MythicPlusDropCMTimer.reset = false;

  MythicPlusDrop:StartCMTimer()
end

-- ---------------------------------------------------------------------------------------------------------------------
function MythicPlusDropCMTimer:OnReset()
  MythicPlusDropCMTimer.frame:Hide();
  MythicPlusDropCMTimer.lootFrame:Hide();
  MythicPlusDropCMTimer.isCompleted = false;
  MythicPlusDropCMTimer.started = false;
  MythicPlusDropCMTimer.reset = true;
end

-- ---------------------------------------------------------------------------------------------------------------------
function MythicPlusDropCMTimer:ReStart()
  local _, _, difficulty, _, _, _, _, _ = GetInstanceInfo();
  local _, timeCM = GetWorldElapsedTime(1);
  if difficulty == 8 and timeCM > 0 then
    MythicPlusDropCMTimer.started = true;
    MythicPlusDrop:StartCMTimer()
    return
  end

  MythicPlusDropCMTimer.frame:Hide();
  MythicPlusDropCMTimer.lootFrame:Hide();
  MythicPlusDropCMTimer.reset = false
  MythicPlusDropCMTimer.timerStarted = false
  MythicPlusDropCMTimer.started = false
  MythicPlusDropCMTimer.isCompleted = false
  return
end

-- ---------------------------------------------------------------------------------------------------------------------
function MythicPlusDropCMTimer:Draw()
  local _, _, difficulty, _, _, _, _, currentZoneID = GetInstanceInfo();
  if difficulty ~= 8 then
    MythicPlusDropCMTimer.frame:Hide();
    MythicPlusDropCMTimer.lootFrame:Hide();
    return
  end

  if not MythicPlusDropCMTimer.started and not MythicPlusDropCMTimer.reset and MythicPlusDropCMTimer.timerStarted then
    MythicPlusDrop:CancelCMTimer()
    MythicPlusDropCMTimer.timerStarted = false
    MythicPlusDropCMTimer.frame:Hide();
    MythicPlusDropCMTimer.lootFrame:Hide();
    return
  end

  if MythicPlusDropCMTimer.reset or MythicPlusDropCMTimer.isCompleted then
    MythicPlusDropCMTimer.reset = false
    MythicPlusDropCMTimer.timerStarted = false
    MythicPlusDropCMTimer.started = false
    MythicPlusDrop:CancelCMTimer();
    MythicPlusDropCMTimer.frame:Hide();
    MythicPlusDropCMTimer.lootFrame:Hide();
    return
  end


  MythicPlusDropCMTimer.timerStarted = true
  local _, timeCM = GetWorldElapsedTime(1)
  if not timeCM or timeCM <= 0 then
    return
  end

  if not MythicPlusDropCMTimer.isCompleted then
    MythicPlusDropCMTimer.frame:Show();
    MythicPlusDropCMTimer.lootFrame:Show();
  end

  local cmLevel, _, _ = C_ChallengeMode.GetActiveKeystoneInfo();
  local currentMapId = C_ChallengeMode.GetActiveChallengeMapID();
  local _, _, maxTime = C_ChallengeMode.GetMapUIInfo(currentMapId);

  -- Chest Timer
  local threeChestTime = maxTime * 0.6;
  local twoChestTime = maxTime * 0.8;
  local oneChestTime = maxTime;

  local timeLeft3 = threeChestTime - timeCM;
  if timeLeft3 < 0 then
    timeLeft3 = 0;
  end

  local timeLeft2 = twoChestTime - timeCM;
  if timeLeft2 < 0 then
    timeLeft2 = 0;
  end

  local timeLeft1 = oneChestTime - timeCM;
  if timeLeft1 < 0 then
    timeLeft1 = 0;
  end

  -- loot frame
  if not MythicPlusDropCMTimer.frames.chestloot then
    local label = CreateFrame("Frame", nil, MythicPlusDropCMTimer.lootFrame);
    label:SetAllPoints()
    label.text = label:CreateFontString(nil, "BACKGROUND", "GameFontHighlight");
    label.text:SetPoint("TOPRIGHT", 0,0);
    label.text:SetJustifyH("RIGHT");
    label.text:SetFontObject("GameFontHighlight");

    MythicPlusDropCMTimer.frames.chestloot = {
      labelFrame = label
    }
  end

  -- -- Chest Timers
  if not MythicPlusDropCMTimer.frames.chesttimer then
    local label = CreateFrame("Frame", nil, MythicPlusDropCMTimer.frame)
    label:SetAllPoints()
    label.text = label:CreateFontString(nil, "BACKGROUND", "GameFontHighlight");
    label.text:SetPoint("TOPLEFT", 0,0);
    MythicPlusDropCMTimer.frames.chesttimer = {
      labelFrame = label
    }
  end

  local lootLevel = 0;
  if cmLevel > 15 then
    lootLevel = MYTHIC_CHEST_TIMERS_LOOT_ILVL[15];
  else
    lootLevel = MYTHIC_CHEST_TIMERS_LOOT_ILVL[cmLevel];
  end

  if cmLevel > 19 then
    MythicPlusDropCMTimer.frames.chestloot.labelFrame.text:SetText("100% 3x|cFF00FF00" .. lootLevel);
  end
  if cmLevel < 20 then
    MythicPlusDropCMTimer.frames.chestloot.labelFrame.text:SetText("80% 3x|cFF00FF00" .. lootLevel);
  end
  if cmLevel < 19 then
    MythicPlusDropCMTimer.frames.chestloot.labelFrame.text:SetText("60% 3x|cFF00FF00" .. lootLevel);
  end
  if cmLevel < 18 then
    MythicPlusDropCMTimer.frames.chestloot.labelFrame.text:SetText("40% 3x|cFF00FF00" .. lootLevel);
  end
  if cmLevel < 17 then
    MythicPlusDropCMTimer.frames.chestloot.labelFrame.text:SetText("20% 3x|cFF00FF00" .. lootLevel);
  end
  if cmLevel < 16 then
    MythicPlusDropCMTimer.frames.chestloot.labelFrame.text:SetText("2x|cFF00FF00" .. lootLevel);
  end

  if timeLeft3 > 0 then
    MythicPlusDropCMTimer.frames.chesttimer.labelFrame.text:SetText(format(MythicPlusDrop.L["Keystone_Level"], '+3')..": "..MythicPlusDropCMTimer:FormatSeconds(timeLeft3));
    MythicPlusDropCMTimer.frames.chesttimer.labelFrame.text:SetFontObject("GameFontHighlight");
  elseif timeLeft2 > 0 then
    MythicPlusDropCMTimer.frames.chesttimer.labelFrame.text:SetText(format(MythicPlusDrop.L["Keystone_Level"], '+2')..": "..MythicPlusDropCMTimer:FormatSeconds(timeLeft2));
    MythicPlusDropCMTimer.frames.chesttimer.labelFrame.text:SetFontObject("GameFontHighlight");
  elseif timeLeft1 > 0 then
    MythicPlusDropCMTimer.frames.chesttimer.labelFrame.text:SetText(format(MythicPlusDrop.L["Keystone_Level"], '+1'));
    MythicPlusDropCMTimer.frames.chesttimer.labelFrame.text:SetFontObject("GameFontHighlight");
  else
    MythicPlusDropCMTimer.frames.chesttimer.labelFrame.text:SetText(format(MythicPlusDrop.L["Keystone_Level"], '|cffff0000-1'));
    MythicPlusDropCMTimer.frames.chesttimer.labelFrame.text:SetFontObject("GameFontHighlight");
    MythicPlusDropCMTimer.frames.chestloot.labelFrame.text:SetText("1x|cFF00FF00" .. lootLevel);
  end

end

-- ---------------------------------------------------------------------------------------------------------------------
function MythicPlusDropCMTimer:ResolveTime(seconds)
  local min = math.floor(seconds/60);
  local sec = seconds - (min * 60);
  return min, sec;
end

-- ---------------------------------------------------------------------------------------------------------------------
function MythicPlusDropCMTimer:FormatSeconds(seconds)
  local min, sec = MythicPlusDropCMTimer:ResolveTime(seconds)
  if min < 10 then
    min = "0" .. min
  end

  if sec < 10 then
    sec = "0" .. sec
  end

  return min .. ":" .. sec
end

