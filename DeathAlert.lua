local addonName, addon = ...

do
    local function OnUnitDied(event, unitGUID)
        local unit = UnitTokenFromGUID(unitGUID)

        if UnitIsFeignDeath(unit) then
            return -- Feign Death -> Ignore
        end

        local faction = UnitFactionGroup(unit)
        
        if faction == "Horde" then
            addon:MakeSoundFromSetting("HA_SOUND_DEADHORDE")
        end

        if faction == "Alliance" then
            addon:MakeSoundFromSetting("HA_SOUND_DEADALLY")
        end
    end

    EventRegistry:RegisterFrameEventAndCallback("UNIT_DIED", OnUnitDied, nil)
end