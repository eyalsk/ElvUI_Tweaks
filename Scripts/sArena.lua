if not sArenaMixin then return end

local E = unpack(ElvUI)
local LSM = E.Libs.LSM

local layoutName = "ElvUI"
local layout = {}

layout.defaultSettings = {
    posX = 483,
    posY = 227,
    scale = 1,
    classIconFontSize = 14,
    spacing = 61,
    growthDirection = 1,
    specIcon = {
        posX = 43,
        posY = 10,
        scale = 1,
    },
    trinket = {
        posX = -121,
        posY = -33,
        scale = 1,
        fontSize = 14,
    },
    racial = {
        posX = -156,
        posY = -33,
        scale = 1,
        fontSize = 14,
    },
    castBar = {
        posX = 10,
        posY = -30,
        scale = 1.3,
        width = 132,
    },
    dr = {
        posX = -121,
        posY = 4,
        size = 30,
        borderSize = 2,
        fontSize = 12,
        spacing = 6,
        growthDirection = 4,
    },
    width = 200,
    height = 43,
    powerBarHeight = 9,
    mirrored = false,
}

local function getSetting(info)
    return layout.db[info[#info]]
end

local function setSetting(info, val)
    layout.db[info[#info]] = val

    for i = 1,3 do
        local frame = info.handler["arena"..i]
        frame:SetSize(layout.db.width, layout.db.height)
        frame.ClassIcon:SetSize(layout.db.height, layout.db.height)
        frame.DeathIcon:SetSize(layout.db.height * 0.8, layout.db.height * 0.8)
        frame.PowerBar:SetHeight(layout.db.powerBarHeight)
        layout:UpdateOrientation(frame)
    end
end

local function setupOptionsTable(self)
    layout.optionsTable = self:GetLayoutOptionsTable(layoutName)

    layout.optionsTable.arenaFrames.args.positioning.args.mirrored = {
        order = 5,
        name = "Mirrored Frames",
        type = "toggle",
        width = "full",
        get = getSetting,
        set = setSetting,
    }

    layout.optionsTable.special = {
        order = 7,
        name = "Special",
        type = "group",
        get = getSetting,
        set = setSetting,
        args = {
            width = {
                order = 1,
                name = "Width",
                type = "range",
                min = 40,
                max = 400,
                step = 1,
            },
            height = {
                order = 2,
                name = "Height",
                type = "range",
                min = 2,
                max = 100,
                step = 1,
            },
            powerBarHeight = {
                order = 2,
                name = "Power Bar Height",
                type = "range",
                min = 1,
                max = 50,
                step = 1,
            },
        },
    }
end

function layout:Initialize(frame)
    self.db = frame.parent.db.profile.layoutSettings[layoutName]

    if not self.optionsTable then
        setupOptionsTable(frame.parent)
    end

    if frame:GetID() == 3 then
        frame.parent:UpdateCastBarSettings(self.db.castBar)
        frame.parent:UpdateDRSettings(self.db.dr)
        frame.parent:UpdateFrameSettings(self.db)
        frame.parent:UpdateSpecIconSettings(self.db.specIcon)
        frame.parent:UpdateTrinketSettings(self.db.trinket)
        frame.parent:UpdateRacialSettings(self.db.racial)
    end

    self:UpdateOrientation(frame)

    frame:SetSize(self.db.width, self.db.height)
    frame.SpecIcon:SetSize(18, 18)
    frame.Trinket:SetSize(32, 32)
    frame.Racial:SetSize(32, 32)

    local statusbar = LSM:Fetch('statusbar', E.db.unitframe.statusbar)
    frame.HealthBar:SetStatusBarTexture(statusbar)

    frame.PowerBar:SetStatusBarTexture(statusbar)
    frame.PowerBar:SetHeight(self.db.powerBarHeight)

    frame.ClassIcon:SetSize(self.db.height, self.db.height)
    frame.ClassIcon:SetTexCoord(0.07, 0.93, 0.07, 0.93)
    frame.ClassIcon:Show()

    frame.SpecIcon.Texture:SetTexCoord(0.07, 0.93, 0.07, 0.93)
    frame.Trinket.Texture:SetTexCoord(0.07, 0.93, 0.07, 0.93)
    frame.Racial.Texture:SetTexCoord(0.07, 0.93, 0.07, 0.93)
    frame.CastBar.Icon:SetTexCoord(0.07, 0.93, 0.07, 0.93)

    local f = frame.Name
    f:SetJustifyH("LEFT")
    f:SetJustifyV("BOTTOM")
    f:SetFontObject("SystemFont_Shadow_Med3")
    f:SetPoint("BOTTOMLEFT", frame.HealthBar, "TOPLEFT", 0, 2)
    f:SetPoint("BOTTOMRIGHT", frame.HealthBar, "TOPRIGHT", 0, 2)
    f:SetHeight(12)

    f = frame.CastBar
    f:SetStatusBarTexture(statusbar)

    f = frame.DeathIcon
    f:ClearAllPoints()
    f:SetPoint("CENTER", frame.HealthBar, "CENTER")
    f:SetSize(self.db.height * 0.8, self.db.height * 0.8)

    frame.HealthText:SetPoint("CENTER", frame.HealthBar)
    frame.HealthText:SetShadowOffset(0, 0)

    frame.PowerText:SetPoint("CENTER", frame.PowerBar)
    frame.PowerText:SetShadowOffset(0, 0)

    local bg = frame.TexturePool:Acquire()
    bg:SetDrawLayer("BACKGROUND", 1)
    bg:SetTexture("Interface\\Tooltips\\UI-Tooltip-Background")
    bg:SetPoint("TOPLEFT", frame, "TOPLEFT", -2, 2)
    bg:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", 2, -2)
    bg:SetVertexColor(0, 0, 0, 1)
    bg:Show()
end

function layout:UpdateOrientation(frame)
    local healthBar = frame.HealthBar
    local powerBar = frame.PowerBar
    local classIcon = frame.ClassIcon

    healthBar:ClearAllPoints()
    powerBar:ClearAllPoints()
    classIcon:ClearAllPoints()

    if self.db.mirrored then
        classIcon:SetPoint("TOPLEFT", frame, "TOPLEFT", 0, 0)

        healthBar:SetPoint("TOPRIGHT", frame, "TOPRIGHT", 0, 0)
        healthBar:SetPoint("BOTTOMLEFT", powerBar, "TOPLEFT", 0, 2)

        powerBar:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", 0, 0)
        powerBar:SetPoint("LEFT", classIcon, "RIGHT", 2, 0)
    else
        classIcon:SetPoint("TOPRIGHT", frame, "TOPRIGHT", 0, 0)

        healthBar:SetPoint("TOPLEFT", frame, "TOPLEFT", 0, 0)
        healthBar:SetPoint("BOTTOMRIGHT", powerBar, "TOPRIGHT", 0, 2)

        powerBar:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", 0, 0)
        powerBar:SetPoint("RIGHT", classIcon, "LEFT", -2, 0)
    end
end

sArenaMixin.layouts[layoutName] = layout
sArenaMixin.defaultSettings.profile.layoutSettings[layoutName] = layout.defaultSettings