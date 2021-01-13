-- Prevents Blizzard from messing the ActionBar when swapping talents and such.

local E = unpack(ElvUI)
local module = E:NewModule("ElvUITweaks:ActionBar", "AceEvent-3.0")

IconIntroTracker.RegisterEvent = function() end
IconIntroTracker:UnregisterEvent("SPELL_PUSHED_TO_ACTIONBAR")

module:RegisterEvent("SPELL_PUSHED_TO_ACTIONBAR", function(event, _, slot)
	if not InCombatLockdown() and slot <= 120 then
		ClearCursor()
		PickupAction(slot)
		ClearCursor()
	end
end)
