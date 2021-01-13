local _, addon = ...
local Unit = addon.Unit

ElvUF.Tags.Events["xnamecolor"] = "UNIT_NAME_UPDATE UNIT_FACTION"
ElvUF.Tags.Methods["xnamecolor"] = function(unit)
    local unitReaction = UnitReaction(unit, "player")
    if UnitIsPlayer(unit) then
        return Unit:GetPlayerReactionColor(unit)
    elseif unitReaction then
		local reaction = ElvUF.colors.reaction[unitReaction]
		return Hex(reaction[1], reaction[2], reaction[3])
	else
		return "|cffc2c2c2"
	end
end

ElvUF.Tags.Events["xplayercolor"] = ElvUF.Tags.Events["xnamecolor"]
ElvUF.Tags.Methods["xplayercolor"] = function(unit)
    if UnitIsPlayer(unit) then
        return Unit:GetPlayerReactionColor(unit)
	end
end