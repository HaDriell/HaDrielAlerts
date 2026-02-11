local addonName, addon = ...

do
    addon.Config = CreateFromMixins(EventRegistry)

    local function OnAddonLoaded(event, loadedAddonName)
        if addonName ~= loadedAddonName then
            return
        end

        -- Setup the SavedVariable and bind to the addon
        HaDrielDB = HaDrielDB or {
            sounds = {},
        }

        local category, layout = Settings.RegisterVerticalLayoutCategory("HaDriel Alerts")
        
        do
            local name = "Output Channel"
            local tooltip = "Audio Channel in which the sounds will be played."
            local variable = "HA_CHANNEL"
            local variableKey = "channel"
            local variableTbl = HaDrielDB
            local defaultValue = "SFX"
            local function GetChannelOptions()
                local container = Settings.CreateControlTextContainer()
                local channels = { "Master", "Music", "SFX", "Ambience", "Dialog", "Talking Head", }
                for _, channel in ipairs(channels) do
                    container:Add(channel, channel)
                end
                return container:GetData()
            end
            
            local setting = Settings.RegisterAddOnSetting(category, variable, variableKey, variableTbl, type(defaultValue), name, defaultValue)
            Settings.CreateDropdown(category, setting, GetChannelOptions, tooltip)
        end

        do
            local name = "Horde Character Death Sound"
            local tooltip = "Sound played when a Horde player dies."
            local variable = "HA_SOUND_DEADHORDE"
            local variableKey = "deadHorde"
            local variableTbl = HaDrielDB.sounds
            local defaultValue = "WCII Orc Dead"
            
            local setting = Settings.RegisterAddOnSetting(category, variable, variableKey, variableTbl, type(defaultValue), name, defaultValue)
            
            local dropdownInitializer = CreateFromMixins(SoundDropdownInitializer)
            dropdownInitializer:Init(setting, tooltip)
            layout:AddInitializer(dropdownInitializer)
            Settings.SetOnValueChangedCallback(variable, function(setting, value)
                addon:MakeSoundFromSetting(variable)
            end)
        end

        do
            local name = "Alliance Character Death Sound"
            local tooltip = "Sound played when an Alliance player dies."
            local variable = "HA_SOUND_DEADALLY"
            local variableKey = "deadAlly"
            local variableTbl = HaDrielDB.sounds
            local defaultValue = "WCII Human Dead"
            
            local setting = Settings.RegisterAddOnSetting(category, variable, variableKey, variableTbl, type(defaultValue), name, defaultValue)
            
            local dropdownInitializer = CreateFromMixins(SoundDropdownInitializer)
            dropdownInitializer:Init(setting, tooltip)
            layout:AddInitializer(dropdownInitializer)
            Settings.SetOnValueChangedCallback(variable, function(setting, value)
                addon:MakeSoundFromSetting(variable)
            end)
        end
        
        do
            local name = "Party Full Sound"
            local tooltip = "Sound played when the group becomes full."
            local variable = "HA_SOUND_PARTYFULL"
            local variableKey = "partyFull"
            local variableTbl = HaDrielDB.sounds
            local defaultValue = "WCII Misc Human Capture"
            
            local setting = Settings.RegisterAddOnSetting(category, variable, variableKey, variableTbl, type(defaultValue), name, defaultValue)
            
            local dropdownInitializer = CreateFromMixins(SoundDropdownInitializer)
            dropdownInitializer:Init(setting, tooltip)
            layout:AddInitializer(dropdownInitializer)
            Settings.SetOnValueChangedCallback(variable, function(setting, value)
                addon:MakeSoundFromSetting(variable)
            end)
        end

        Settings.RegisterAddOnCategory(category)

        addon.Config:UnregisterFrameEventAndCallback("ADDON_LOADED", OnAddonLoaded)
    end

    addon.Config:RegisterFrameEventAndCallback("ADDON_LOADED", OnAddonLoaded)
end