local addonName, addon = ...

do
    addon.DeathAlert = CreateFromMixins(EventRegistry)

    local function OnUnitDied(event, unitGUID)
        local unit = UnitTokenFromGUID(unitGUID)

        if not UnitIsFriend("player", unit) then
            return -- Death Alert is only to notify friends dying
        end

        if UnitIsFeignDeath(unit) then
            return -- That's a Feign Death, not a real Death
        end

        local faction = UnitFactionGroup(unit)
        
        if faction == "Horde" then
            addon:MakeSoundFromSetting("HA_SOUND_DEADHORDE")
        end

        if faction == "Alliance" then
            addon:MakeSoundFromSetting("HA_SOUND_DEADALLY")
        end
    end

    addon.DeathAlert:RegisterFrameEventAndCallback("UNIT_DIED", OnUnitDied, nil)
end