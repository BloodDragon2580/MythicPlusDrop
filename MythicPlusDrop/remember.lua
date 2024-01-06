local f = CreateFrame("Frame")
local addonPrefix = '|cffd6266cMythicPlusDrop|r'
MYTHICPLUSDROP = {}

-- register cmd
SLASH_MYTHICPLUSDROP1 = "/mythicplusdrop"
SlashCmdList.MYTHICPLUSDROP = function(msg, editBox)
    print(addonPrefix .. ' ' .. (MYTHICPLUSDROP.lastdg or 'Yet to accept invites'))
end

-- events

function f:OnEvent(event, ...)
    self[event](self, event, ...)
end

function f:ADDON_LOADED(event, addOnName)
    if addOnName == 'MythicPlusDrop' then
        MYTHICPLUSDROP = MYTHICPLUSDROP or {}
    end
end

function f:LFG_LIST_APPLICATION_STATUS_UPDATED(event, searchResultID, newStatus, oldStatus, groupName)
    if newStatus ~= "inviteaccepted" then
        return
    end

    MYTHICPLUSDROP.lastdg = C_LFGList.GetActivityInfoTable(C_LFGList.GetSearchResultInfo(searchResultID).activityID).fullName .. ' ' .. groupName
    print(addonPrefix .. ' ' .. (MYTHICPLUSDROP.lastdg or 'Yet to accept invites'))
end

-- setup

f:RegisterEvent("LFG_LIST_APPLICATION_STATUS_UPDATED")
f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", f.OnEvent)
