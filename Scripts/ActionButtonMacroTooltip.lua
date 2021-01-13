local E = unpack(ElvUI)
local module = E:NewModule("ElvUITweaks:ActionButtonMacroTooltip", "AceHook-3.0")

local MACRO_LINE = "|cffca3c3cMacro|r %s"

function module:Initialize()
	self:SecureHook(GameTooltip, "SetAction", function(self, slot)
		if self:IsForbidden() or self:NumLines() == 1 then return end
		local actionType, id, subType = GetActionInfo(slot)
		if actionType == "macro" then
			local text = GetActionText(slot)
			if text then
				self:AddLine(MACRO_LINE:format(text))
				self:Show()
			end
		end
	end)
end

E:RegisterModule(module:GetName())