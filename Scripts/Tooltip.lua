local _, addon = ...
local Unit = addon.Unit

local E = unpack(ElvUI)
local TT = E:GetModule('Tooltip')
local module = E:NewModule("ElvUITweaks:Tooltip", "AceHook-3.0")

local _G = _G

function module:Initialize()
    self:SecureHook(TT, "SetUnitText", function(self, tt, unit)
        if tt:IsForbidden() then return end
        if UnitIsPlayer(unit) then
            local race, englishRace = UnitRace(unit)
			local _, localizedFaction = E:GetUnitBattlefieldFaction(unit)
            if localizedFaction and englishRace == "Pandaren" then 
                race = localizedFaction .. " " .. race
            end
            for index = 2, GameTooltip:NumLines() do
                local line = _G["GameTooltipTextLeft" .. index]
                if line then
                    local lineText = line:GetText()
                    if lineText and lineText:find(race) then
                        line:SetFormattedText(lineText:gsub(race, "%%s%%s|r"), Unit:GetPlayerReactionColor(unit), race)
                        break
                    end
                end
            end
        end
    end)
end

E:RegisterModule(module:GetName())