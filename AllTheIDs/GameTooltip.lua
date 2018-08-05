
local addon_name, addon = ...

local GetCurrencyListLink, GetGlyphLink, GetLootSlotLink, tinsert, strfind,
    strsplit, select, UnitAura, UnitBattlePetSpeciesID, UnitBuff, UnitDebuff,
    UnitGUID, UnitIsWildBattlePet, unpack, wipe
    = GetCurrencyListLink, GetGlyphLink, GetLootSlotLink, tinsert, strfind,
    strsplit, select, UnitAura, UnitBattlePetSpeciesID, UnitBuff, UnitDebuff,
    UnitGUID, UnitIsWildBattlePet, unpack, wipe

addon:HookTipScript("OnTooltipSetItem", function(self)
    local name, link = self:GetItem()
    if link then
        local _,_,id = strfind(link, "|Hitem:(%d+):")
        if id ~= "0" then
            addon:AddIDLine(self, "Item", id)
        end
    end
end)

addon:HookTipScript("OnTooltipSetSpell", function(self)
    local name, spellID = self:GetSpell()
    addon:AddIDLine(self, "Spell", spellID)
end)

--
--
--

local tmpSetUnit = {}
local function handleUnit(tip, unitType, ...) 
    if unitType == "Creature" or unitType == "Pet" or unitType == "Vehicle" then
        local _, _, _, _, id = ...
        tinsert(tmpSetUnit, "NPC")
        tinsert(tmpSetUnit, id)
    elseif unitType == "GameObject" then
        local _, _, _, _, id = ...
        tinsert(tmpSetUnit, "Object")
        tinsert(tmpSetUnit, id)
    end
end

addon:HookTipScript("OnTooltipSetUnit", function(self)
    local name, unit = self:GetUnit()
    if not unit then
        return
    end

    wipe(tmpSetUnit)

    local guid = UnitGUID(unit)
    if guid then
        handleUnit(self, strsplit("-", guid))
    end

    if UnitIsWildBattlePet(unit) then
        local speciesID = UnitBattlePetSpeciesID(unit)
        if speciesID then
            tinsert(tmpSetUnit, "Species")
            tinsert(tmpSetUnit, speciesID)
        end
    end

    if #tmpSetUnit > 0 then
        addon:AddIDLine(self, unpack(tmpSetUnit))
    end
end)

--
--
--

addon:HookTip("SetAchievementByID", function(self, id)
    addon:AddIDLine(self, "Achievement", id)
end)

addon:HookTip("SetCurrencyByID", function(self, id)
    addon:AddIDLine(self, "Currency", id)
end)

addon:HookTip("SetCurrencyToken", function(tip, idx)
    local link = GetCurrencyListLink(idx)
    if link then
        local _, _, name, id = strfind(link, "|H(%w+):(%d+)")
        addon:AddIDLine(tip, name:gsub("^%l", string.upper), id)
    end
end)

addon:HookTip("SetGlyph", function(self, socket, talent)
    local link = GetGlyphLink(socket, talent)
    local _,_, id = strfind(link, "|Hglyph:(%d+)|")
    addon:AddIDLine(self, "Glyph", id)
end)

addon:HookTip("SetGlyphByID", function(self, id)
    addon:AddIDLine(self, "Glyph", id)
end)

addon:HookTip("SetHeirloomByItemID", function(tip, itemid)
    -- This won't cause the OnTooltipSetItem to be called, and the tooltip
    -- won't actually be filled in during the same call either, so we need
    -- to remember what item it was.
    tip._alltheid_type = "Item"
    tip._alltheid_id = itemid
end) 

addon:HookTip("SetHyperlink", function(self, link)
    local _, _, name, id = strfind(link, "(%w+):(%d+)")
    addon:AddIDLine(self, name:gsub("^%l", string.upper), id)
end)

addon:HookTip("SetLFGCompletionReward", function(tip, rewardID)
    local name, icon = GetLFGCompletionReward(rewardID)
    local link = addon.currencyCache[name][icon]
    if link then
        local _, _, name, id = strfind(link, "|H(%w+):(%d+)")
        addon:AddIDLine(tip, name:gsub("^%l", string.upper), id)
    end
end)

addon:HookTip("SetLFGDungeonReward", function(tip, dungeonID, rewardID)
    local name, icon = GetLFGDungeonRewardInfo(dungeonID, rewardID)
    local link = addon.currencyCache[name][icon]
    if link then
        local _, _, name, id = strfind(link, "|H(%w+):(%d+)")
        addon:AddIDLine(tip, name:gsub("^%l", string.upper), id)
    end
end)

addon:HookTip("SetLootCurrency", function(tip, slot)
    local link = GetLootSlotLink(slot)
    if link then
        local _, _, name, id = strfind(link, "|H(%w+):(%d+)")
        addon:AddIDLine(tip, name:gsub("^%l", string.upper), id)
    end
end)

addon:HookTip("SetMerchantCostItem", function(self, idx, currency)
    local currencyID = select(currency, GetMerchantCurrencies())
    addon:AddIDLine(self, "Currency", currencyID)
end)

addon:HookTip("SetQuestCurrency", function(tip, type, idx)
    local name, icon = GetQuestCurrencyInfo(type, idx)
    local link = addon.currencyCache[name][icon]
    if link then
        local _, _, name, id = strfind(link, "|H(%w+):(%d+)")
        addon:AddIDLine(tip, name:gsub("^%l", string.upper), id)
    end
end)

addon:HookTip("SetQuestLogCurrency", function(tip, type, idx)
    local name, icon = GetQuestLogRewardCurrencyInfo(idx)
    local link = addon.currencyCache[name][icon]
    if link then
        local _, _, name, id = strfind(link, "|H(%w+):(%d+)")
        addon:AddIDLine(tip, name:gsub("^%l", string.upper), id)
    end
end)

addon:HookTip("SetQuestLogItem", function(self, ...)
    local link = GetQuestLogItemLink(...)
    if link then
        local _, _, id = strfind(link, "|Hitem:(%d+):")
        if id ~= "0" then
            addon:AddIDLine(self, "Item", id)
        end
    end
end)

-- 6.2 BUG?
addon:HookTip("SetToyByItemID", function(tip, itemid)
    -- This won't cause the OnTooltipSetItem to be called, and the tooltip
    -- won't actually be filled in during the same call either, so we need
    -- to remember what item it was.
    tip._alltheid_type = "Item"
    tip._alltheid_id = itemid
end)

-- 6.2 BUG
addon:HookTip("SetTradeSkillItem", function(tip, itemIdx, reagentIdx)
    local link
    if reagentIdx ~= nil then
        link = GetTradeSkillReagentItemLink(itemIdx, reagentIdx)
    else
        link = GetTradeSkillItemLink(itemIdx)
    end

    if link then
        local _, _, name, id = strfind(link, "|H(%w+):(%d+)")
        if id ~= "0" then
            tip._alltheid_type = name
            tip._alltheid_id = id
            addon:AddIDLine(tip, "Item", id)
        end
    end
end)

addon:HookTip("SetUnitAura", function(self, unit, index, filter)
    local _,_,_,_,_,_,_,_,_, spellID = UnitAura(unit, index, filter)
    addon:AddIDLine(self, "Spell", spellID)
end)

addon:HookTip("SetUnitBuff", function(self, unit, index, filter)
    local _,_,_,_,_,_,_,_,_, spellID = UnitBuff(unit, index, filter)
    addon:AddIDLine(self, "Spell", spellID)
end)

addon:HookTip("SetUnitDebuff", function(self, unit, index, filter)
    local _,_,_,_,_,_,_,_,_, spellID = UnitDebuff(unit, index, filter)
    addon:AddIDLine(self, "Spell", spellID)
end)
