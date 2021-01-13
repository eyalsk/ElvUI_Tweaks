local _, addon = ...

local Unit = {}
addon.Unit = Unit

function Unit:GetPlayerReactionColor(unit)
    if UnitIsFriend(unit, "player") then
        return "|cff49ad4d"
    else
        return "|cffff0000"
    end
end