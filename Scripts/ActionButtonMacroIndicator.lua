-- Colors the hotkeys to differentiate between regular spells and macros.

local E = unpack(ElvUI)
local AB = E:GetModule("ActionBars")
local LAB = E.Libs.LAB
local module = E:NewModule("ElvUITweaks:ActionButtonMacroIndicator", "AceEvent-3.0")

function module:Initialize()
	LAB.RegisterCallback(AB, "OnButtonUpdate", function(event, button)
		if button._state_type == "action" then
			local actionType = GetActionInfo(button._state_action)
			if actionType == "macro" then
				button.Name:SetText("[M]")
			end
		end
	end)
end

E:RegisterModule(module:GetName())