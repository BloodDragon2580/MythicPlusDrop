function GetModifiers(linkType, ...)
	if type(linkType) ~= 'string' then return end
	local modifierOffset = 4
  local itemID, instanceID, mythicLevel, notDepleted, _ = ... -- "keystone" links

  if mythicLevel and mythicLevel ~= "" then
		mythicLevel = tonumber(mythicLevel);
		if mythicLevel and mythicLevel > 15 then
			mythicLevel = 15;
		end
	else
		mythicLevel = nil;
	end

  if linkType:find('item') then -- only used for ItemRefTooltip currently
		_, _, _, _, _, _, _, _, _, _, _, _, _, instanceID, mythicLevel = ...
		if ... == '138019' then -- mythic keystone
			modifierOffset = 16
		else
			return
		end
	elseif not linkType:find('keystone') then
		return
	end

	local modifiers = {}
	for i = modifierOffset, select('#', ...) do
		local num = strmatch(select(i, ...) or '', '^(%d+)')
		if num then
			local modifierID = tonumber(num)
			--if not modifierID then break end
			tinsert(modifiers, modifierID)
		end
	end
	local numModifiers = #modifiers
	if modifiers[numModifiers] and modifiers[numModifiers] < 2 then
		tremove(modifiers, numModifiers)
	end
	return modifiers, instanceID, mythicLevel
end

local function DecorateTooltip(self)
	local _, link = self:GetItem();
	if type(link) == 'string' and link:find("keystone") then
		local modifiers, instanceID, mythicLevel = GetModifiers(strsplit(':', link))
		if modifiers then
			for _, modifierID in ipairs(modifiers) do
				local modifierName, modifierDescription = C_ChallengeMode.GetAffixInfo(modifierID)
				if modifierName and modifierDescription then
					self:AddLine(format('\n|cff00ff00%s: |cffffffff%s|r', modifierName, modifierDescription), 0, 1, 0, true)
				end
			end
			if type(mythicLevel) == "number" and mythicLevel > 0 then
        self:AddLine(format('\n|cffffcc00%s|r', format(MythicPlusDrop.L["BaseLootLevel"], MYTHIC_CHEST_TIMERS_LOOT_ILVL[mythicLevel])), 0, 1, 0, true)
			end
			self:Show()
		end
	end
end

MythicPlusDropTooltip = {}
function MythicPlusDropTooltip:Init()
	hooksecurefunc(ItemRefTooltip, 'SetHyperlink', DecorateTooltip)
	ItemRefTooltip:HookScript('OnTooltipSetItem', DecorateTooltip)
	GameTooltip:HookScript('OnTooltipSetItem', DecorateTooltip)
end

