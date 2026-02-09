local addonName, addon = ...

local f = CreateFrame("Frame")
f.transient = {}


function f:ADDON_LOADED(event, addonName)
    if addonName ~= "HaDrielAlerts" then
        return
    end

    print("ADDON_LOADED " .. event .. ", " .. addonName)
    addon:InitializeOptions()
end

-- UnitDeath Monitoring

--[[
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
        addon:MakeSoundFromSetting("HA_SOUND_DEADHORDE")
    end
    if UnitFactionGroup(unit) == "Alliance" then
        addon:MakeSoundFromSetting("HA_SOUND_DEADALLY")
    end
end
]]--

-- Group Full Monitoring

function f:UpdatePartySize()
    local old = f.transient.lastPartySize or 1
    local new = GetNumGroupMembers(LE_PARTY_CATEGORY_HOME)

    if old == new then
        return
    end

    f.transient.lastPartySize = new

    if old == 5 then
        addon:MakeSoundFromSetting("HA_SOUND_PARTYFULL")
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
f:RegisterEvent("GROUP_FORMED")
f:RegisterEvent("GROUP_ROSTER_UPDATE")
f:SetScript("OnEvent", f.DispatchEvent)
