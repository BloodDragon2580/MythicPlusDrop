local ADDON, Addon = ...
local Mod = Addon:NewModule('Keystone')

local function SlotKeystone()
	for container=BACKPACK_CONTAINER, NUM_BAG_SLOTS do
		local slots = C_Container.GetContainerNumSlots(container)
		for slot=1, slots do
			local slotLink = C_Container.GetContainerItemLink(container, slot)
			if slotLink and slotLink:match("|Hkeystone:") then
				C_Container.PickupContainerItem(container, slot)
				if (CursorHasItem()) then
					C_ChallengeMode.SlotKeystone()
				end
			end
		end
	end
end

function Mod:Blizzard_ChallengesUI()
	ChallengesKeystoneFrame:HookScript("OnShow", SlotKeystone)
end

function Mod:Startup()
	self:RegisterAddOnLoaded("Blizzard_ChallengesUI")
end
