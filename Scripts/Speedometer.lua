local E = unpack(ElvUI)
local DT = E:GetModule("DataTexts")
local module = E:NewModule("ElvUITweaks:Speedometer", "AceEvent-3.0")

local SPEED_HEADER = STAT_SPEED .. ":"
local SPEED_GROUND_LABEL = STAT_MOVEMENT_GROUND_TOOLTIP:gsub("%s.+", "")
local SPEED_FLIGHT_LABEL = STAT_MOVEMENT_FLIGHT_TOOLTIP:gsub("%s.+", "")
local SPEED_SWIM_LABEL = STAT_MOVEMENT_SWIM_TOOLTIP:gsub("%s.+", "")

local format = string.format
local GetUnitSpeed = GetUnitSpeed

local currentUnit = "player"
local displayString, lastPanel = ""

local function FormatSpeed(speed)
    return format("%d%%", speed / BASE_MOVEMENT_SPEED * 100 + 0.5)
end

module:RegisterEvent("UNIT_ENTERED_VEHICLE", function(event, unit)
    if unit == "player" then
        currentUnit = "vehicle"
    end
end)

module:RegisterEvent("UNIT_EXITED_VEHICLE", function(event, unit)
    if unit == "player" then
        currentUnit = "player"
    end
end)

local function OnEnter()
	DT.tooltip:ClearLines()

    local _, runSpeed, flightSpeed, swimSpeed = GetUnitSpeed(currentUnit)
    DT.tooltip:AddLine(SPEED_HEADER)
    DT.tooltip:AddDoubleLine(SPEED_GROUND_LABEL, FormatSpeed(runSpeed), 1, 1, 1, 1, 1, 1)
    DT.tooltip:AddDoubleLine(SPEED_FLIGHT_LABEL, FormatSpeed(flightSpeed), 1, 1, 1, 1, 1, 1)
    DT.tooltip:AddDoubleLine(SPEED_SWIM_LABEL, FormatSpeed(swimSpeed), 1, 1, 1, 1, 1, 1)
	DT.tooltip:Show()
end

local function OnEvent(self)
    if UnitInVehicle("player") then
        currentUnit = "vehicle"
    end
    local speed, runSpeed, flightSpeed, swimSpeed = GetUnitSpeed(currentUnit)
    if not IsPlayerMoving() or speed <= 0 then
        if IsFlying() then
            speed = flightSpeed
        elseif IsSwimming() then
            speed = swimSpeed
        else
            speed = runSpeed
        end
    end
	self.text:SetFormattedText(displayString, STAT_SPEED, FormatSpeed(speed))
	lastPanel = self
end

local int = 1
local function OnUpdate(self, t)
    int = int - t
	if int > 0 then return end
    OnEvent(self)
    int = 1
    lastPanel = self
end

local function ValueColorUpdate(hex)
    displayString = strjoin("", "%s: ", hex, "%s|r")

	if lastPanel then OnEvent(lastPanel) end
end
E.valueColorUpdateFuncs[ValueColorUpdate] = true

DT:RegisterDatatext("Speedometer", STAT_CATEGORY_ENHANCEMENTS, {"PLAYER_ENTERING_WORLD", "PLAYER_STARTED_MOVING", "PLAYER_STOPPED_MOVING"}, OnEvent, OnUpdate, nil, OnEnter, nil, "Speedometer")