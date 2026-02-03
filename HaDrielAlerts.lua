local addonName, addon = ...

local f = CreateFrame("Frame")
f.transient = {}

-- Sound alert implementation

function addon:MakeSound(soundKey)
    local media = LibStub("LibSharedMedia-3.0")
    local sound = media:Fetch("sound", soundKey)
    PlaySoundFile(sound)
end

-- Addon Defaults & Initialization

function addon:CreateDefaultDatabase()
    return {
        sounds = {
            deadHorde = "WCII Orc Dead",
            deadAlly = "WCII Human Dead",
            partyFull = "WCII Misc Human Capture"       
        }
    }
end

function addon:InitializeDatabase()
    if type(HaDrielDB) ~= "table" then
        HaDrielDB = self:CreateDefaultDatabase()
    end
    self.db = HaDrielDB

    addon:MakeSound(self.db.sounds.partyFull)
    -- print("HaDrielAlert: deadHorde sound = " .. self.db.sounds.deadHorde)
    -- print("HaDrielAlert: deadAlly sound = " .. self.db.sounds.deadAlly)
    -- print("HaDrielAlert: partyFull sound = " .. self.db.sounds.partyFull)
end

function f:ADDON_LOADED(event, addonName)
    if addonName ~= "HaDrielAlerts" then
        return
    end

    print("ADDON_LOADED " .. event .. ", " .. addonName)
    addon:InitializeDatabase()
    addon:InitializeOptions()
end

-- UnitDeath Monitoring

function f:UNIT_HEALTH(event, unit)
    if not UnitIsPlayer(unit) then
        return -- Not a player
    end

    if UnitIsFeignDeath(unit) then
        return -- Feign Death -> Ignore
    end

    if not UnitIsDead(unit) then
        return -- Unit is not dead
    end

    if UnitFactionGroup(unit) == "Horde" then
        addon:MakeSound(self.db.sounds.deadHorde)
    end
    if UnitFactionGroup(unit) == "Alliance" then
        addon:MakeSound(self.db.sounds.deadAlly)
    end
end

-- Group Full Monitoring

function f:UpdatePartySize()
    local old = f.transient.lastPartySize or 1
    local new = GetNumGroupMembers(LE_PARTY_CATEGORY_HOME)

    if old == new then
        return
    end

    f.transient.lastPartySize = new

    if old == 5 then
        addon:MakeSound(self.db.partyFull)
    end
end

function f:GROUP_FORMED(event)
    self:UpdatePartySize()
end

function f:GROUP_ROSTER_UPDATE(event)
    self:UpdatePartySize()
end

-- Events

function f:DispatchEvent(event, ...)
    self[event](self, event, ...)
end

f:RegisterEvent("ADDON_LOADED")
f:RegisterEvent("UNIT_HEALTH")
f:RegisterEvent("GROUP_FORMED")
f:RegisterEvent("GROUP_ROSTER_UPDATE")
f:SetScript("OnEvent", f.DispatchEvent)
