-- Adds a queue timer to the PVPReadyDialog

local E = unpack(ElvUI)
local module = E:NewModule("ElvUITweaks:PVPReadyDialog", "AceEvent-3.0")

PVPReadyDialog.enterButton:ClearAllPoints()
PVPReadyDialog.enterButton:SetPoint("BOTTOM", 0, 25)
PVPReadyDialog.label:SetPoint("TOP", 0, -22)

local queueIndex = 0

local function UpdateStatus()
    if PVPReadyDialog_Showing(queueIndex) then
        local secs = GetBattlefieldPortExpiration(queueIndex)
        if secs and secs > 0 then
            local color = secs > 20 and "f20ff20" or secs > 10 and "fffff00" or "fff0000"
            PVPReadyDialog.label:SetText("Expires in |cf" .. color .. SecondsToTime(secs) .. "|r")
            C_Timer.After(1, UpdateStatus)
        end
    else
        queueIndex = 0
    end
end

module:RegisterEvent("UPDATE_BATTLEFIELD_STATUS", function()
    for index = 1, GetMaxBattlefieldID() do
        local status = GetBattlefieldStatus(index)
        if status == "confirm" then
            queueIndex = index
            UpdateStatus()
            break
        end
    end
end)