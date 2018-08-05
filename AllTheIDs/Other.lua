
local addon_name, addon = ...

local CreateFrame, hooksecurefunc, GetFactionInfo, IsAddOnLoaded, ipairs, tinsert
    = CreateFrame, hooksecurefunc, GetFactionInfo, IsAddOnLoaded, ipairs, tinsert

local event_frame = CreateFrame("FRAME")
event_frame:SetScript("OnEvent", function(frame, event, ...)
    local func = frame[event]
    if func then
        return func(frame, ...)
    end
end)

event_frame.on_addon = {}
local function OnAddOnLoaded(addon, func)
    if IsAddOnLoaded(addon) then
        return func()
    end

    if event_frame.on_addon[addon] ~= nil then
        tinsert(event_frame.on_addon[addon], func)
    else
        event_frame.on_addon[addon] = {func}
    end
end

function event_frame:ADDON_LOADED(addon_name)
    if event_frame.on_addon[addon_name] ~= nil then
        for i, func in ipairs(event_frame.on_addon[addon_name]) do
            func()
        end
        event_frame.on_addon[addon_name] = nil
    end
end
event_frame:RegisterEvent("ADDON_LOADED")

--
-- Achievements
--

OnAddOnLoaded("Blizzard_AchievementUI", function()
    for _, button in ipairs(AchievementFrameAchievementsContainer.buttons) do
        button.shield:HookScript("OnEnter", function(frame)
            local parent = frame:GetParent()
            if GameTooltip:GetOwner() ~= frame then
                return
            end

            addon:AddIDLine(GameTooltip, "Achievement", parent.id)
        end)
    end

    hooksecurefunc("AchievementFrameSummaryAchievement_OnEnter", function(frame)
        if GameTooltip:GetOwner() == nil then
            GameTooltip:SetOwner(frame, "ANCHOR_RIGHT")
        end
        addon:AddIDLine(GameTooltip, "Achievement", frame.id)
        GameTooltip:Show()
    end)

    --
    -- mini achievements (aka progressive)
    --

    local mini_achievements = {}
    local function miniAchievement_OnEnter(frame)
        local idx = frame._alltheid_index
        if idx == nil then
            return
        end
        addon:AddIDLine(GameTooltip, "Achievement", mini_achievements[#mini_achievements-idx+1])
    end

    hooksecurefunc("AchievementObjectives_DisplayProgressiveAchievement", function(frame, id)
        wipe(mini_achievements)

        while id do
            tinsert(mini_achievements, id)
            id = GetPreviousAchievement(id)
        end

        local idx = 1
        while true do
            local mini = _G["AchievementFrameMiniAchievement"..idx]
            if mini == nil then
                break
            end

            if mini:IsShown() and mini._alltheid_index == nil then
                mini:HookScript("OnEnter", miniAchievement_OnEnter)
                mini._alltheid_index = idx
            end
            idx = idx + 1
        end
    end)

    --
    -- meta achievements
    --

    local function metaAchievement_OnEnter(frame)
        addon:AddIDLine(GameTooltip, "Achievement", frame.id)
    end

    hooksecurefunc("AchievementObjectives_DisplayCriteria", function(frame, id)
        local idx = 1
        while true do
            local metacrit = _G["AchievementFrameMeta"..idx]
            if metacrit == nil then
                break
            end

            if metacrit:IsShown() and metacrit._alltheid_onenter == nil then
                metacrit:HookScript("OnEnter", metaAchievement_OnEnter)
                metacrit._alltheid_onenter = true
            end
            idx = idx + 1
        end
    end)
end)

--
-- Mount Collection
--

OnAddOnLoaded("Blizzard_Collections", function()
    hooksecurefunc("MountJournal_UpdateMountDisplay", function()
        local spellID = MountJournal.MountDisplay.lastDisplayed
        if spellID then
            addon:TextAppendID(MountJournal.MountDisplay.InfoButton.Lore, "Spell", spellID)
        end
    end)
end)


--
-- PetJournal
--

do
    OnAddOnLoaded("Blizzard_Collections", function()
        PetJournalPetCardPetInfo:HookScript("OnEnter", function(self)
            if GameTooltip:GetOwner() == self then
                local speciesID = PetJournalPetCard.speciesID
                local _, _, _, creatureID = C_PetJournal.GetPetInfoBySpeciesID(speciesID)
                addon:AddIDLine(GameTooltip, "Species", speciesID, "NPC", creatureID)
            end
        end)
    end)


    local origSharedPetBattleAbilityTooltip_SetAbility = _G.SharedPetBattleAbilityTooltip_SetAbility
    _G.SharedPetBattleAbilityTooltip_SetAbility = function(tip, abilityInfo, additionalInfo)
        local abilityID = abilityInfo:GetAbilityID()
        if abilityID then
            local line = addon:IDLine("Ability", abilityID)

            if additionalInfo then
                additionalInfo = additionalInfo.."\n"..line
            else
                additionalInfo = line
            end
        end

        return origSharedPetBattleAbilityTooltip_SetAbility(tip, abilityInfo, additionalInfo)
    end
end


--
-- Quest Frame
--

hooksecurefunc("QuestMapFrame_UpdateAll", function()
    for i, frame in ipairs(QuestMapFrame.QuestsFrame.Contents:GetLayoutChildren()) do
        if not frame._alltheids_hooked then
            frame._alltheids_hooked = true
            frame:HookScript("OnEnter", function(self)
                local questID = self.questID
                if questID and GameTooltip:GetOwner() == self then
                    addon:AddIDLine(GameTooltip, "Quest", questID)
                end
            end)
        end
    end
end)

--
-- Reputation Frame
--

hooksecurefunc("ReputationFrame_Update", function()
    if ReputationDetailFrame:IsShown() then
        local selected = GetSelectedFaction()
        local _, _, _, _, _, _, _, _, _, _, _, _, _, factionID = GetFactionInfo(selected)
        addon:TextAppendID(ReputationDetailFactionDescription, "Faction", factionID)
    end
end)

--
-- World Map
--

hooksecurefunc(WorldMapFrame, "OnMapChanged", function(self)
    local display = self._alltheid_display
    if not self._alltheid_display then
        -- create a frame that sits on top of map
        local displayFrame = CreateFrame("FRAME", nil, WorldMapFrame.ScrollContainer)
        displayFrame:SetAllPoints()

        -- create text
        display = displayFrame:CreateFontString(nil, "OVERLAY")
        self._alltheid_display = display
        display:SetFontObject(GameFontHighlightLeft)
        display:SetJustifyH("LEFT")
        display:SetHeight(24)
        display:SetWidth(256)
        display:SetPoint("BOTTOMLEFT")
    end

    display:SetText(addon:IDLine("Map", self:GetMapID()))
end)
