local _, addon = ...

local E, _, _, P = unpack(ElvUI);
local module = E:NewModule("ElvUITweaks:StickyChatWindow", "AceEvent-3.0")

P["StickyChatWindow"] = {
	["LastWindow"] = GENERAL
}

local function getChatWindowByName(name)
	for i = 1, NUM_CHAT_WINDOWS do
		local chatName = GetChatWindowInfo(i)
		if chatName == name then
			return _G["ChatFrame" .. i]
		end
	end
	return ChatFrame1
end

module:RegisterEvent("PLAYER_ENTERING_WORLD", function()
	local chatFrame = getChatWindowByName(E.db.StickyChatWindow.LastWindow)
    FCFDock_SelectWindow(GENERAL_CHAT_DOCK, chatFrame)
    FCF_DockUpdate()
end)

function module:Initialize()
	for i = 1, NUM_CHAT_WINDOWS do
		local chatFrame = _G["ChatFrame" .. i]
		local chatFrameTab = _G[chatFrame:GetName() .. "Tab"]
        chatFrameTab:HookScript("OnClick", function()
            E.db.StickyChatWindow.LastWindow = chatFrame.name
		end)
    end
end

E:RegisterModule(module:GetName())