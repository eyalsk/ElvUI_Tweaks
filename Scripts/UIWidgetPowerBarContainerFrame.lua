local E = unpack(ElvUI)
local module = E:NewModule("ElvUITweaks:UIWidgetPowerBarContainerFrame")

function module:Initialize()
    UIPARENT_MANAGED_FRAME_POSITIONS["UIWidgetPowerBarContainerFrame"] = nil
    UIWidgetPowerBarContainerFrame.ignoreFramePositionManager = true

    UIWidgetPowerBarContainerFrame:ClearAllPoints()
    UIWidgetPowerBarContainerFrame:SetPoint("CENTER", UIParent, "CENTER", 0, 220)
end

E:RegisterModule(module:GetName())