local ADDON, Addon = ...
local Mod = Addon:NewModule('ProgressTracker')
Mod.playerDeaths = {}

local lastQuantity
local lastDied
local lastDiedName
local lastDiedTime
local lastAmount
local lastAmountTime
local lastQuantity

local PRIDEFUL_AFFIX_ID = 121

local progressPresets = {}

local function ProcessLasts()
	if lastDied and lastDiedTime and lastAmount and lastAmountTime then
		if abs(lastAmountTime - lastDiedTime) < 0.1 then
			if not MythicPlusDrop_Data.progress[lastDied] then MythicPlusDrop_Data.progress[lastDied] = {} end
			if MythicPlusDrop_Data.progress[lastDied][lastAmount] then
				MythicPlusDrop_Data.progress[lastDied][lastAmount] = MythicPlusDrop_Data.progress[lastDied][lastAmount] + 1
			else
				MythicPlusDrop_Data.progress[lastDied][lastAmount] = 1
			end
			lastDied, lastDiedTime, lastAmount, lastAmountTime, lastDiedName = nil, nil, nil, nil, nil
		end
	end
end

function Mod:COMBAT_LOG_EVENT_UNFILTERED()
	local timestamp, event, hideCaster, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags, spellID, spellName, spellSchool, x1, x2, x3, x4, x5, x6, x7, x8, x9, x10 = CombatLogGetCurrentEventInfo()
	if event == "UNIT_DIED" then
		if bit.band(destFlags, COMBATLOG_OBJECT_TYPE_NPC) > 0
				and bit.band(destFlags, COMBATLOG_OBJECT_CONTROL_NPC) > 0
				and (bit.band(destFlags, COMBATLOG_OBJECT_REACTION_HOSTILE) > 0 or bit.band(destFlags, COMBATLOG_OBJECT_REACTION_NEUTRAL) > 0) then
			local npc_id = select(6, strsplit("-", destGUID))
			lastDied = tonumber(npc_id)
			lastDiedTime = GetTime()
			lastDiedName = destName
			ProcessLasts()
		end
		if bit.band(destFlags, COMBATLOG_OBJECT_TYPE_PLAYER) > 0 then
			if UnitIsFeignDeath(destName) then
			elseif Mod.playerDeaths[destName] then
				Mod.playerDeaths[destName] = Mod.playerDeaths[destName] + 1
			else
				Mod.playerDeaths[destName] = 1
			end
		end
	end
end

function Mod:SCENARIO_CRITERIA_UPDATE()
	local scenarioType = select(10, C_Scenario.GetInfo())
	if scenarioType == LE_SCENARIO_TYPE_CHALLENGE_MODE then
		local numCriteria = select(3, C_Scenario.GetStepInfo())
		for criteriaIndex = 1, numCriteria do
			local criteriaInfo = C_ScenarioInfo.GetCriteriaInfo(criteriaIndex)
			if criteriaInfo and criteriaInfo.isWeightedProgress then
				local quantityString = criteriaInfo.quantityString
				local currentQuantity = quantityString and tonumber( quantityString:match("%d+") )
				if lastQuantity and currentQuantity < criteriaInfo.totalQuantity and currentQuantity > lastQuantity then
					lastAmount = currentQuantity - lastQuantity
					lastAmountTime = GetTime()
					ProcessLasts()
				end
				lastQuantity = currentQuantity
				break
			end
		end
	end
end

local function StartTime()
	Mod:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	local numCriteria = select(3, C_Scenario.GetStepInfo())
	for criteriaIndex = 1, numCriteria do
		local criteriaInfo = C_ScenarioInfo.GetCriteriaInfo(criteriaIndex)
		if criteriaInfo and criteriaInfo.isWeightedProgress then
			local quantityString = criteriaInfo.quantityString
			lastQuantity = quantityString and tonumber( quantityString:match("%d+") )
			break
		end
	end
end

local function StopTime()
	Mod:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
end

local function CheckTime(...)
	for i = 1, select("#", ...) do
		local timerID = select(i, ...)
		local _, elapsedTime, type = GetWorldElapsedTime(timerID)
		if type == LE_WORLD_ELAPSED_TIMER_TYPE_CHALLENGE_MODE then
			local mapID = C_ChallengeMode.GetActiveChallengeMapID()
			if mapID then
				StartTime()
				return
			end
		end
	end
	StopTime()
end

local function OnTooltipSetUnit(tooltip)
	local scenarioType = select(10, C_Scenario.GetInfo())
	if scenarioType == LE_SCENARIO_TYPE_CHALLENGE_MODE and Addon.Config.progressTooltip then
		local name, unit = tooltip:GetUnit()
		local guid = unit and UnitGUID(unit)
		if guid then
			local npc_id = select(6, strsplit("-", guid))
			npc_id = tonumber(npc_id)
			local value

			if Addon.Config.progressTooltipMDT and MDT then
				value = MDT:GetEnemyForces(npc_id)
			else
				local info = MythicPlusDrop_Data.progress[npc_id]

				if info then
					local valueCount
					for amount, count in pairs(info) do
						if not valueCount or count > valueCount or (count == valueCount and amount < value) then
							value = amount
							valueCount = count
						end
					end
				end
			end

			if value then
				local numCriteria = select(3, C_Scenario.GetStepInfo())
				local total
				local progressName
				for criteriaIndex = 1, numCriteria do
					local criteriaInfo = C_ScenarioInfo.GetCriteriaInfo(criteriaIndex)
					if criteriaInfo and criteriaInfo.isWeightedProgress then
						progressName = criteriaInfo.description
						total = criteriaInfo.totalQuantity
						break
					end
				end

				if total then
					local forcesFormat = format(" - %s: %%s", progressName)
					local text
					if Addon.Config.progressFormat == 1 or Addon.Config.progressFormat == 4 then
						text = format( format(forcesFormat, "+%.2f%%"), value/total*100)
					elseif Addon.Config.progressFormat == 2 or Addon.Config.progressFormat == 5 then
						text = format( format(forcesFormat, "+%d"), value)
					elseif Addon.Config.progressFormat == 3 or Addon.Config.progressFormat == 6 then
						text = format( format(forcesFormat, "+%.2f%% - +%d"), value/total*100, value)
					end

					if text then
						local matcher = format(forcesFormat, "%d+%%")
						for i=2, tooltip:NumLines() do
							local tiptext = _G["GameTooltipTextLeft"..i]
							local linetext = tiptext and tiptext:GetText()

							if linetext and linetext:match(matcher) then
								tiptext:SetText(text)
								tooltip:Show()
							end
						end
					end
				end
			end
		end
	end
end

function Mod:GeneratePreset()
	local ret = {}
	for npcID, info in pairs(MythicPlusDrop_Data.progress) do
		local value, valueCount
		for amount, count in pairs(info) do
			if not valueCount or count > valueCount or (count == valueCount and amount < value) then
				value = amount
				valueCount = count
			end
		end
		ret[npcID] = value
	end
	MythicPlusDrop_Data.preset = ret
	return ret
end

function Mod:PLAYER_ENTERING_WORLD(...) CheckTime(GetWorldElapsedTimers()) end
function Mod:WORLD_STATE_TIMER_START(...) local timerID = ...; CheckTime(timerID) end
function Mod:WORLD_STATE_TIMER_STOP(...) local timerID = ...; StopTime(timerID) end
function Mod:CHALLENGE_MODE_START(...) CheckTime(GetWorldElapsedTimers()) end
function Mod:CHALLENGE_MODE_RESET(...) wipe(Mod.playerDeaths) end

local function ProgressBar_SetValue(self, percent)

	local scenarioType = select(10, C_Scenario.GetInfo())

	if scenarioType ~= LE_SCENARIO_TYPE_CHALLENGE_MODE then return end

	local numCriteria = select(3, C_Scenario.GetStepInfo())
	local criteriaInfo
	local cInfo

	for criteriaIndex = 1, numCriteria do
		cInfo = C_ScenarioInfo.GetCriteriaInfo(criteriaIndex)
		if cInfo and cInfo.isWeightedProgress then
			criteriaInfo = cInfo
			break
		end
	end

	if not criteriaInfo then return end

	local totalQuantity = criteriaInfo.totalQuantity
	local quantityString = criteriaInfo.quantityString
	local currentQuantity = quantityString and tonumber( quantityString:match("%d+") )

	if currentQuantity and totalQuantity then
		if Addon.Config.progressFormat == 1 then
			self.Bar.Label:SetFormattedText("%.2f%%", currentQuantity/totalQuantity*100)
		elseif Addon.Config.progressFormat == 2 then
			self.Bar.Label:SetFormattedText("%d/%d", currentQuantity, totalQuantity)
		elseif Addon.Config.progressFormat == 3 then
			self.Bar.Label:SetFormattedText("%.2f%% - %d/%d", currentQuantity/totalQuantity*100, currentQuantity, totalQuantity)
		elseif Addon.Config.progressFormat == 4 then
			self.Bar.Label:SetFormattedText("%.2f%% (%.2f%%)", currentQuantity/totalQuantity*100, (totalQuantity-currentQuantity)/totalQuantity*100)
		elseif Addon.Config.progressFormat == 5 then
			self.Bar.Label:SetFormattedText("%d/%d (%d)", currentQuantity, totalQuantity, totalQuantity - currentQuantity)
		elseif Addon.Config.progressFormat == 6 then
			self.Bar.Label:SetFormattedText("%.2f%% (%.2f%%) - %d/%d (%d)", currentQuantity/totalQuantity*100, (totalQuantity-currentQuantity)/totalQuantity*100, currentQuantity, totalQuantity, totalQuantity - currentQuantity)
		end
	end
end

local progressBarFound = false

local function findProgressBar()

	if progressBarFound then return end

	local usedBars = ScenarioObjectiveTracker.usedProgressBars or {}

	for _, bar in pairs(usedBars) do
		if bar.used then
			hooksecurefunc(bar, "SetValue", ProgressBar_SetValue)
			progressBarFound = true
			break
		end
	end
end

hooksecurefunc(ScenarioObjectiveTracker.ObjectivesBlock, "AddProgressBar", findProgressBar )

local function DeathCount_OnEnter(self)
	local parent = self:GetParent()

	GameTooltip:SetOwner(self, "ANCHOR_LEFT")
	GameTooltip:SetText(CHALLENGE_MODE_DEATH_COUNT_TITLE:format(parent.deathCount), 1, 1, 1)
	GameTooltip:AddLine(CHALLENGE_MODE_DEATH_COUNT_DESCRIPTION:format(SecondsToClock(parent.timeLost, false)))

	GameTooltip:AddLine(" ")
	local list = {}
	local deathsCount = 0
	for unit,count in pairs(Mod.playerDeaths) do
		local _, class = UnitClass(unit)
		deathsCount = deathsCount + count
		table.insert(list, { count = count, unit = unit, class = class })
	end
	table.sort(list, function(a, b)
		if a.count ~= b.count then
			return a.count > b.count
		else
			return a.unit < b.unit
		end
	end)

	for _,item in ipairs(list) do
		local color = RAID_CLASS_COLORS[item.class] or HIGHLIGHT_FONT_COLOR
		GameTooltip:AddDoubleLine(item.unit, item.count, color.r, color.g, color.b, HIGHLIGHT_FONT_COLOR:GetRGB())
	end
	GameTooltip:Show()
end

function Mod:Blizzard_ObjectiveTracker()
	ScenarioObjectiveTracker.ChallengeModeBlock.DeathCount:SetScript("OnEnter", DeathCount_OnEnter)
end

function Mod:Startup()
	if not MythicPlusDrop_Data then
		MythicPlusDrop_Data = {}
	end
	if not MythicPlusDrop_Data.progress then
		MythicPlusDrop_Data = { progress = MythicPlusDrop_Data }
	end
	if not MythicPlusDrop_Data.state then MythicPlusDrop_Data.state = {} end
	local mapID = C_ChallengeMode.GetActiveChallengeMapID()
	if select(10, C_Scenario.GetInfo()) == LE_SCENARIO_TYPE_CHALLENGE_MODE and mapID and mapID == MythicPlusDrop_Data.state.mapID and MythicPlusDrop_Data.state.playerDeaths then
		Mod.playerDeaths = MythicPlusDrop_Data.state.playerDeaths
	else
		MythicPlusDrop_Data.state.mapID = nil
		MythicPlusDrop_Data.state.playerDeaths = Mod.playerDeaths
	end

	self:RegisterEvent("SCENARIO_CRITERIA_UPDATE")
	self:RegisterEvent("PLAYER_ENTERING_WORLD")
	self:RegisterEvent("WORLD_STATE_TIMER_START")
	self:RegisterEvent("WORLD_STATE_TIMER_STOP")
	self:RegisterEvent("CHALLENGE_MODE_START")
	self:RegisterEvent("CHALLENGE_MODE_RESET")
	self:RegisterAddOnLoaded("Blizzard_ObjectiveTracker")
	CheckTime(GetWorldElapsedTimers())
	TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Unit, OnTooltipSetUnit)

	Addon.Config:RegisterCallback('progressFormat', function()
		local usedBars = ScenarioObjectiveTracker.usedProgressBars or {}
		for _, bar in pairs(usedBars) do
			if bar.used then
				ProgressBar_SetValue(bar)
				break
			end
		end
	end)
end
