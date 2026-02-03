local addonName, addon = ...

local category, layout = Settings.RegisterVerticalLayoutCategory(addonName)
addon.settingsCategory = category

-- Shamelessly adapted from BugSack

local function CreateSharedMediaDropdownInitializer(label, tooltip, getterCallback, setterCallback)
    local DropdownInitializer = CreateFromMixins(ScrollBoxFactoryInitializerMixin, SettingsElementHierarchyMixin, SettingsSearchableElementMixin)

    function DropdownInitializer:Init()
        ScrollBoxFactoryInitializerMixin.Init(self, "SettingsListElementTemplate")
        self.data = {
            name = label,
            tooltip = tooltip,
            GetValue = getterCallback,
            SetValue = setterCallback
        }
        self:AddSearchTags(label)
    end

    function DropdownInitializer:GetExtent()
        return 26 -- Height of the Control
    end

    function DropdownInitializer:InitFrame(frame)
        frame:SetSize(280, 26)

        if not frame.cbrHandles then
            frame.cbrHandles = Settings.CreateCallbackHandleContainer()
        end

        frame.data = self.data
        frame.Text:SetFontObject("GameFontNormal")
        frame.Text:SetText(L["Sound"])
        frame.Text:SetPoint("LEFT", 37, 0)
        frame.Text:SetPoint("RIGHT", frame, "CENTER", -85, 0)

        if not frame.previewButton then
            frame.previewButton = CreateFrame("Button", nil, frame)
            frame.previewButton:SetSize(26, 26)
            frame.previewButton:SetPoint("LEFT", frame, "CENTER", -74, 0)
            frame.previewButton:SetHeight(26)

            local previewIcon = frame.previewButton:CreateTexture(nil, "ARTWORK")
            previewIcon:SetAllPoints()
            previewIcon:SetTexture("Interface\\Commin\\VoiceChat-Speaker")
            previewIcon:SetVertexColor(0.8, 0.8, 0.8)

            frame.previewButton:SetScript("OnEnter", function(control)
                previewIcon:SetVertexColor(1, 1, 1)
                GameTooltip:SetOwner(control, "ANCHOR_TOP")
                GameTooltip:SetText(L["Preview Sound"])
                GameTooltip:Show()
            end)

            frame.previewButton:SetScript("OnLeave", function(control) 
                previewIcon:SetVertexColor(0.8, 0.8, 0.8)
            end)

            frame.previewButton:SetScript("OnClick", function(control)
                local soundKey = self.data.GetValue()
                addon:MakeSound(soundKey)
            end)
        end

        if not frame.soundDropdown then
            
        end
    end
end


function addon:InitializeOptions()
    
end