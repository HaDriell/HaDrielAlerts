local addonName, addon = ...

do
    addon.PartyFull = CreateFromMixins(EventRegistry)
    addon.PartyFull.WasFull = C_PartyInfo.IsPartyFull()

    local function UpdatePartyFull()
        local old = addon.PartyFull.WasFull
        local new = C_PartyInfo.IsPartyFull()
        addon.PartyFull.WasFull = new
        
        if old then
            return -- Party was already full
        end

        if new then
            addon:MakeSoundFromSetting("HA_SOUND_PARTYFULL")
        end
    end

    addon.PartyFull:RegisterFrameEventAndCallback("GROUP_FORMED", UpdatePartyFull)
    addon.PartyFull:RegisterFrameEventAndCallback("GROUP_JOINED", UpdatePartyFull)
    addon.PartyFull:RegisterFrameEventAndCallback("GROUP_LEFT", UpdatePartyFull)
    addon.PartyFull:RegisterFrameEventAndCallback("GROUP_ROSTER_UPDATE", UpdatePartyFull)
end