local addonName, addon = ...

do
    addon.DeathAlert = CreateFromMixins(EventRegistry)

    local function OnUnitDied(event, unitGUID)
        local unitName = UnitNameFromGUID(unitGUID)
        if issecretvalue(unitName) then
            return -- Not a Player or Pet
        end

        local unit = UnitTokenFromGUID(unitGUID)
        if issecretvalue(unit) or (not UnitIsHumanPlayer(unit)) then
            return -- Not a friend unit (PVP I guess ? that's untested)
        end
        if UnitIsFeignDeath(unit) then
            return -- That's a Feign Death, Ignore this event
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