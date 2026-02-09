local addonName, addon = ...

do
    addon.PartyFull = CreateFromMixins(EventRegistry)
    addon.PartyFull.WasFull = C_PartyInfo.IsPartyFull()

    local function UpdatePartyFull()
        local old = addon.PartyFull.WasFull
        local new = C_PartyInfo.IsPartyFull()
        addon.PartyFull.WasFull = new

        if not old and new then
            addon:MakeSoundFromSetting("HA_SOUND_PARTYFULL")
        end
    end

    addon.PartyFull:RegisterFrameEventAndCallback("GROUP_FORMED", UpdatePartyFull)
    addon.PartyFull:RegisterFrameEventAndCallback("GROUP_ROSTER_UPDATE", UpdatePartyFull)
    addon.PartyFull:RegisterFrameEventAndCallback("GROUP_LEFT", UpdatePartyFull)
end