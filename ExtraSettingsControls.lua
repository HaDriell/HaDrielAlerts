local addonName, addon = ...

-- Adapted from BugSack's Sharedmedia custom dropdown
SoundDropdownInitializer = CreateFromMixins(
    ScrollBoxFactoryInitializerMixin,
    SettingsElementHierarchyMixin,
    SettingsSearchableElementMixin
)

function SoundDropdownInitializer:GetSetting()
    assert(self.data.setting ~= nil)
    return self.data.setting
end

function SoundDropdownInitializer:Init(setting, tooltip)
    assert(setting ~= nil)
    ScrollBoxFactoryInitializerMixin.Init(self, "SettingsListElementTemplate")

    self.data = {
        setting = setting,
        name = setting:GetName(),
        tooltip = tooltip or "",
    }
    self:AddSearchTags(setting:GetName())
end

function SoundDropdownInitializer:GetExtent()
    return 26
end

function SoundDropdownInitializer:InitFrame(frame)
    local setting = self:GetSetting()

    -- Set frame size
    frame:SetSize(200, 26)

    -- Initialize the SettingsListElementMixin properly
    if not frame.cbrHandles then
        frame.cbrHandles = Settings.CreateCallbackHandleContainer()
    end

    -- Set up the standard element display
    frame.data = self.data
    frame.Text:SetFontObject("GameFontNormal")
    frame.Text:SetText(setting:GetName())
    frame.Text:SetPoint("LEFT", 37, 0)
    frame.Text:SetPoint("RIGHT", frame, "CENTER", -85, 0)

    -- Update button text function
    local function UpdateDropdownText()
        if frame.dropdown then
            frame.dropdown:OverrideText(setting:GetValue())
        end
    end

    local function IsSelected(value)
        local variable = setting:GetVariable()
        return  Settings.GetValue(variable) == value
    end

    local function OnSelection(value)
        local variable = setting:GetVariable()
        Settings.SetValue(variable, value)
        UpdateDropdownText()
    end

    if not frame.dropdown then
        frame.dropdown = CreateFrame("DropdownButton", nil, frame, "WowStyle1DropdownTemplate")
        frame.dropdown:SetPoint("LEFT", frame, "CENTER", -85, 0)
        frame.dropdown:SetPoint("RIGHT", frame, "RIGHT", 0, 0)
        frame.dropdown:SetHeight(26)

        -- Setup menu with scrolling
        frame.dropdown:SetupMenu(function(dropdown, rootDescription)
            rootDescription:SetScrollMode(200)

            local sounds = LibStub("LibSharedMedia-3.0"):List("sound")
            for _, sound in ipairs(sounds) do
                rootDescription:CreateRadio(sound, IsSelected, OnSelection, sound)
            end
        end)
        UpdateDropdownText()
    end

    frame.cbrHandles:SetOnValueChangedCallback(setting:GetVariable(), UpdateDropdownText)
end

function SoundDropdownInitializer:Resetter(frame)
    if frame.cbrHandles then
        frame.cbrHandles:Unregister()
    end
end