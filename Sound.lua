local addonName, addon = ...

-- Initial implementation, will be removed later
function addon:MakeSound(soundKey, channel)
    local media = LibStub("LibSharedMedia-3.0")
    local sound = media:Fetch("sound", soundKey)
    
    PlaySoundFile(sound, channel)
end

function addon:MakeSoundFromSetting(variable)
    local channel = Settings.GetValue("HA_CHANNEL")
    local soundKey = Settings.GetValue(variable)
    local media = LibStub("LibSharedMedia-3.0")
    local sound = media:Fetch("sound", soundKey)

    PlaySoundFile(sound, channel)
end
